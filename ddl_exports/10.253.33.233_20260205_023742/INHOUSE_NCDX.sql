-- DDL Export
-- Server: 10.253.33.233
-- Database: INHOUSE_NCDX
-- Exported: 2026-02-05T02:37:53.412051

USE INHOUSE_NCDX;
GO

-- --------------------------------------------------
-- INDEX dbo.BO_client_deposit_recno
-- --------------------------------------------------
CREATE CLUSTERED INDEX [co_pcode] ON [dbo].[BO_client_deposit_recno] ([cltcode])

GO

-- --------------------------------------------------
-- INDEX dbo.CliBal
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxcl] ON [dbo].[CliBal] ([Cltcode])

GO

-- --------------------------------------------------
-- INDEX dbo.foaccbill
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [amt] ON [dbo].[foaccbill] ([Amount])

GO

-- --------------------------------------------------
-- INDEX dbo.foaccbill
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [amt12] ON [dbo].[foaccbill] ([Amount])

GO

-- --------------------------------------------------
-- INDEX dbo.NCMS_marh
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_clcode] ON [dbo].[NCMS_marh] ([Clcode])

GO

-- --------------------------------------------------
-- INDEX dbo.PenalRev_Table
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxptydt] ON [dbo].[PenalRev_Table] ([Party_Code], [RevDate])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.foaccbill
-- --------------------------------------------------
ALTER TABLE [dbo].[foaccbill] ADD CONSTRAINT [PK__foaccbil__58118376D2F2FED3] PRIMARY KEY ([BillDate], [Party_Code], [Sell_Buy], [Branchcd])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FOACCBILLDATA_RTB
-- --------------------------------------------------
ALTER TABLE [dbo].[FOACCBILLDATA_RTB] ADD CONSTRAINT [PK__foaccbil__58118376D2F2FED31] PRIMARY KEY ([BillDate], [Party_Code], [Sell_Buy], [Branchcd])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_DupRec
-- --------------------------------------------------
  
CREATE procedure AGG_DupRec    
as    
set nocount on    
select * INTO #A1 from ACCOUNTNCDX.dbo.ledger where vdt >=convert(Date,getdate()-10) AND CHECKEDBY='ONLINE' AND VTYP=2    
select * INTO #A2 from ACCOUNTNCDX.dbo.ledger where vdt >=convert(Date,getdate()-10) AND CHECKEDBY<>'ONLINE' AND VTYP=2    
SELECT B.*,A.DDNO,A.L1_SNO INTO #B1 FROM ACCOUNTNCDX.dbo.LEDGER1 A JOIN #A1 B ON A.VNO=B.VNO     
AND A.VTYP=B.VTYP AND A.LNO=B.LNO    
SELECT B.*,A.DDNO,A.L1_SNO INTO #B2 FROM ACCOUNTNCDX.dbo.LEDGER1 A JOIN #A2 B ON A.VNO=B.VNO     
AND A.VTYP=B.VTYP AND A.LNO=B.LNO    
SELECT A.* INTO #C1 FROM #B1 A JOIN  #B2 B ON A.CLTCODE=B.CLTCODE AND A.VAMT=B.VAMT AND A.DDNO=B.DDNO
DELETE from AGG_DupRecLog where CONVERT(varchar(11),GETDATE(),106)= CONVERT(varchar(11),GETDATE(),106)     
insert into AGG_DupRecLog    
select count(1) as DupCount,Getdate() as ProTime From ACCOUNTNCDX.dbo.ledger where vtyp=2     
and vno in (Select vno from #c1)     
and checkedby='ONLINE' --AND CLTCODE NOT IN ('02020','03014')    
having count(1) > 0    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BOND_POdet
-- --------------------------------------------------

  
CREATE Proc [dbo].[BOND_POdet](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #bond_marh from bond_marh where 1=2            
            
IF @pcode is null            
BEGIN            
       
if(select COUNT(1) from INTRANET.cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
DECLARE @MARGINDATE1 AS DATETIME        
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)         into #main from           
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE     
      
                 
   update #main set initialmargin=b.peakMargin                 
   from(                      
   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
   ) b                       
   where #main.Party_code=b.party_code                        
  
   insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
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
 insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
 end         
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #bond_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #bond_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #bond_marh set ledgeramount=balance from #bb b  where #bond_marh.clcode=b.cltcode              
 update #bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #bond_marh.clcode=b.party_Code              
 update #bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #bond_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #bond_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_Bond            
             
 update #bond_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno_bond  WITH (NOLOCK)  group by cltcode) b              
 where #bond_marh.clcode=b.cltcode             
          
 update #bond_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #bond_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #bond_marh.clcode=b.party_code            
          
 update #bond_marh set c=            
 (case             
 when (imargin*(NonCashConsideration/100))+non_cash > 0             
 then 0             
 else (imargin*(NonCashConsideration/100))+non_cash             
 end)             
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                    
                                                                  
 update #bond_marh set PayoutValue =            
 case                                                
 when c >= ledgeramount  then ledgeramount        
 when c < ledgeramount then c                                                
 else 0 end        
           
 update #bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr           
   
 update #bond_marh set received=b.vamt from  
 (   
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #bond_marh.clcode=b.cltcode   
  
 truncate table bond_marh            
          
 insert into bond_marh            
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)            
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #bond_marh            
          
END            
ELSE            
BEGIN            
           
 insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/   
    /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
  ) a            
 group by cltcode            
          
          
 insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #bond_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #bond_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #bond_marh set ledgeramount=balance from #bb1 b  where #bond_marh.clcode=b.cltcode              
 update #bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #bond_marh.clcode=b.party_Code              
          
 update #bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #bond_marh set OTherDr=b.Vbal from     
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #bond_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco_bond @pcode           
          
 update #bond_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno_bond WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #bond_marh.clcode=b.cltcode             
          
 update #bond_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #bond_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #bond_marh.clcode=b.party_code            
          
 update #bond_marh set c=            
 (case             
 when (imargin*(NonCashConsideration/100))+non_cash > 0             
 then 0             
 else (imargin*(NonCashConsideration/100))+non_cash             
 end)             
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                    
                                                                  
 update #bond_marh set PayoutValue =            
 case                                                
 when c >= ledgeramount  then ledgeramount        
 when c < ledgeramount then c                                                
 else 0 end               
          
 update #bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr           
  
 update #bond_marh set received=b.vamt from  
 (   
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #bond_marh.clcode=b.cltcode   
  
          
 delete from bond_marh where clcode=@pcode           
          
 insert into bond_marh            
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)            
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #bond_marh            
           
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
select @fromdt=sdtcur from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtnxt = (select sdtcur  from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate())        
select @todate=ldtcur from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate()        
-----------END----------------------      

IF @pcode is null
BEGIN
	      
		select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet      
		from accountncdx.dbo.ledger b with (nolock)       
		where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1      
		      
		select       
		bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo      
		into #led1      
		from accountncdx.dbo.ledger1 with (nolock)      
		where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )       
		      
		select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype       
		      
		      
		select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,       
		isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),       
		Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),       
		treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate(),narration
		into #recodet       
		From accountncdx.dbo.LEDGER l with (nolock)      
		join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno      
		and vdt <= getdate()       
		and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%') 
		/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */
		    
		        
		/*                                  
		select top 0 * into BO_client_deposit_recno from [CSOKYC-6].general.dbo.BO_client_deposit_recno       
		create clustered index co_pcode on BO_client_deposit_recno(cltcode)       
		*/      
		  
		delete from #recodet where narration = 'BEING AMT RECD TECH PROCESS'  
		delete from #recodet where narration = 'BEING AMT RECEIVED BY ONLINE TRF'      
		      
		delete #recodet from #recodet a inner join NCDX.DBO.CLient1 b WITH (NOLOCK) on       
		a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')       
		      
		truncate table BO_client_deposit_recno       
		insert into BO_client_deposit_recno   
		select co_code='NCDEX',getdate(),accno,vtyp,booktype,vno,vdt,tdate,ddno,cltcode,acname,drcr,Dramt,Cramt,treldt,refno,last_Date from #recodet (nolock)  
      
END
ELSE
BEGIN

	select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet        
	from ACCOUNTNCDX.dbo.ledger b with (nolock)         
	where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode  

	select         
	bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,  
	accno=space(10)        
	into #ledger1c        
	from ACCOUNTNCDX.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype       
	where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         

	select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc        
	from ACCOUNTNCDX.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp  
	where  a.lno=1  /*and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process') */

	update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype  

	select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
	isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
	Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
	treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()         
	into #recodetc         
	From ACCOUNTNCDX.dbo.LEDGER l with (nolock)        
	join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
	and vdt <= getdate()         
	and       
	(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%')  
	/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */
	   
	delete #recodetc from #recodetc a inner join NCDX.dbo.CLient1 b WITH (NOLOCK) on         
	a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
	     
	delete from BO_client_deposit_recno where cltcode=@pcode        
	insert into BO_client_deposit_recno select co_code='NCDEX',getdate(),* from #recodetc (nolock)      

END

      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_02042014
-- --------------------------------------------------
CREATE Procedure Fetch_CliUnreco_02042014  
as  
  
set nocount on  
  
declare @fromdt as datetime,@todate as datetime  
select @fromdt=sdtcur,@todate=ldtcur from accountncdx.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()  
  
select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet  
from accountncdx.dbo.ledger b with (nolock)   
where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1  
  
select   
bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo  
into #led1  
from accountncdx.dbo.ledger1 with (nolock)  
where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )   
  
select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype   
  
  
select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,   
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),   
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),   
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()   
into #recodet   
From accountncdx.dbo.LEDGER l with (nolock)  
join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno  
and vdt <= getdate()   
and l.narration not like 'BEING AMT RECD TECH PROCESS%'  
    
/*                              
select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno   
create clustered index co_pcode on BO_client_deposit_recno(cltcode)   
*/  
  
  
delete #recodet from #recodet a inner join NCDX.DBO.CLient1 b WITH (NOLOCK) on   
a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')   
  
truncate table BO_client_deposit_recno   
insert into BO_client_deposit_recno select co_code='NCDEX',getdate(),* from #recodet (nolock)   
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_Bond
-- --------------------------------------------------



    
CREATE Procedure [dbo].[Fetch_CliUnreco_Bond](@pcode as varchar(10) = null)      
as      
      
set nocount on      
      
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/      
declare @fromdt as datetime,@todate as datetime        
select @fromdt=sdtcur from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtnxt = (select sdtcur  from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate())        
select @todate=ldtcur from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate()        
-----------END----------------------      

IF @pcode is null
BEGIN
	      
		select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet      
		from accountncdx.dbo.ledger b with (nolock)       
		where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1      
		      
		select       
		bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo      
		into #led1      
		from accountncdx.dbo.ledger1 with (nolock)      
		where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )       
		      
		select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype       
		      
		      
		select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,       
		isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),       
		Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),       
		treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate(),narration
		into #recodet       
		From accountncdx.dbo.LEDGER l with (nolock)      
		join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno      
		and vdt <= getdate()       
		and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%') 
		/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */
		    
		        
		/*                                  
		select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno       
		create clustered index co_pcode on BO_client_deposit_recno(cltcode)       
		*/      
		  
		delete from #recodet where narration = 'BEING AMT RECD TECH PROCESS'  
		delete from #recodet where narration = 'BEING AMT RECEIVED BY ONLINE TRF'      
		      
		delete #recodet from #recodet a inner join NCDX.DBO.CLient1 b WITH (NOLOCK) on       
		a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')       
		      
		truncate table BO_client_deposit_recno_bond       
		insert into BO_client_deposit_recno_bond   
		select co_code='NCDEX',getdate(),accno,vtyp,booktype,vno,vdt,tdate,ddno,cltcode,acname,drcr,Dramt,Cramt,treldt,refno,last_Date from #recodet (nolock)  
      
END
ELSE
BEGIN

	select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet        
	from ACCOUNTNCDX.dbo.ledger b with (nolock)         
	where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode  

	select         
	bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,  
	accno=space(10)        
	into #ledger1c        
	from ACCOUNTNCDX.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype       
	where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         

	select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc        
	from ACCOUNTNCDX.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp  
	where  a.lno=1  /*and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process') */

	update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype  

	select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
	isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
	Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
	treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()         
	into #recodetc         
	From ACCOUNTNCDX.dbo.LEDGER l with (nolock)        
	join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
	and vdt <= getdate()         
	and       
	(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%')  
	/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */
	   
	delete #recodetc from #recodetc a inner join NCDX.dbo.CLient1 b WITH (NOLOCK) on         
	a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
	     
	delete from BO_client_deposit_recno_bond where cltcode=@pcode        
	insert into BO_client_deposit_recno_bond select co_code='NCDEX',getdate(),* from #recodetc (nolock)      

END

      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_forPO
-- --------------------------------------------------



    
CREATE Procedure [dbo].[Fetch_CliUnreco_forPO](@pcode as varchar(10) = null)      
as      
      
set nocount on      
      
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/      
declare @fromdt as datetime,@todate as datetime        
select @fromdt=sdtcur from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtnxt = (select sdtcur  from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate())        
select @todate=ldtcur from ACCOUNTNCDX.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate()        
-----------END----------------------      

IF @pcode is null
BEGIN
	     select distinct party_code into #PO_client_unreco from  INTRANET.cms.dbo.NCMS_PO_Request_ForPayout with(nolock)     
    
  create index #PO_cli on #PO_client_unreco(Party_code)  
  
		select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet      
		from accountncdx.dbo.ledger b with (nolock)   ,#PO_client_unreco p                
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3)    and b.CLTCODE=p.party_code 
		      
		select       
		bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,t.vtyp,t.vno,t.lno,drcr,t.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo      
		into #led1      
		from accountncdx.dbo.ledger1 t with (nolock) , #vdet l where l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype      
 and drcr='C' and clear_mode not in ( 'R', 'C') and t.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )        
		      
		select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype       
		      
		      
		select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,       
		isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),       
		Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),       
		treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate(),narration
		into #recodet       
		From accountncdx.dbo.LEDGER l with (nolock)      
		join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno      
		and vdt <= getdate()       
		and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%') 
		/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */
		    
		        
		/*                                  
		select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno       
		create clustered index co_pcode on BO_client_deposit_recno(cltcode)       
		*/      
		  
		delete from #recodet where narration = 'BEING AMT RECD TECH PROCESS'  
		delete from #recodet where narration = 'BEING AMT RECEIVED BY ONLINE TRF'      
		      
		delete #recodet from #recodet a inner join NCDX.DBO.CLient1 b WITH (NOLOCK) on       
		a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')       
		      
		truncate table BO_client_deposit_recno       
		insert into BO_client_deposit_recno   
		select co_code='NCDEX',getdate(),accno,vtyp,booktype,vno,vdt,tdate,ddno,cltcode,acname,drcr,Dramt,Cramt,treldt,refno,last_Date from #recodet (nolock)  
      
END
ELSE
BEGIN

	select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet        
	from ACCOUNTNCDX.dbo.ledger b with (nolock)         
	where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode  

	select         
	bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,  
	accno=space(10)        
	into #ledger1c        
	from ACCOUNTNCDX.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype       
	where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         

	select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc        
	from ACCOUNTNCDX.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp  
	where  a.lno=1  /*and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process') */

	update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype  

	select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
	isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
	Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
	treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()         
	into #recodetc         
	From ACCOUNTNCDX.dbo.LEDGER l with (nolock)        
	join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
	and vdt <= getdate()         
	and       
	(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%')  
	/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */
	   
	delete #recodetc from #recodetc a inner join NCDX.dbo.CLient1 b WITH (NOLOCK) on         
	a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
	     
	delete from BO_client_deposit_recno where cltcode=@pcode        
	insert into BO_client_deposit_recno select co_code='NCDEX',getdate(),* from #recodetc (nolock)      

END

      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIDWARE_ledger_INHOUSE
-- --------------------------------------------------

CREATE procedure MIDWARE_ledger_INHOUSE  
as                  
                  
set nocount on                  
----- accountNCDX Master                  
          
truncate table INHOUSE_NCDX.dbo.ledger          
    
/* Fetch Party Ledger */    
insert into INHOUSE_NCDX.dbo.ledger                
select * from accountNCDX.dbo.ledger with (nolock)     
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
insert into INHOUSE_NCDX.dbo.ledger                
select * from accountNCDX.dbo.ledger with (nolock)     
where vdt >= @sdt and cltcode >='0' and cltcode <='99999999'       
    
                  
truncate table INHOUSE_NCDX.dbo.ledger1          
insert into INHOUSE_NCDX.dbo.ledger1                
select * from accountNCDX.dbo.ledger1 with (nolock)        
          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Midware_master_INHOUSE
-- --------------------------------------------------
CREATE procedure [dbo].[Midware_master_INHOUSE]  
as            
            
set nocount on            
----- Account Master            
truncate table INHOUSE_NCDX.dbo.acmast            
insert into INHOUSE_NCDX.dbo.acmast             
select * from ACCOUNTNCDX.DBO.acmast with (nolock)     
            
truncate table INHOUSE_NCDX.dbo.vmast            
insert into INHOUSE_NCDX.dbo.vmast            
select * from ACCOUNTNCDX.DBO.vmast with (nolock)     
            
truncate table INHOUSE_NCDX.dbo.parameter             
insert into INHOUSE_NCDX.dbo.parameter             
select * from ACCOUNTNCDX.DBO.parameter with (nolock)     
          
truncate table INHOUSE_NCDX.dbo.costmast          
insert into INHOUSE_NCDX.dbo.costmast             
select * from ACCOUNTNCDX.DBO.costmast with (nolock) --  00:01 secs            
            
            
--- Scrip Master            
truncate table INHOUSE_NCDX.DBO.FOscrip1            
insert into INHOUSE_NCDX.DBO.FOscrip1            
select * from NCDX.DBO.FOscrip1 with (nolock)            
            
truncate table INHOUSE_NCDX.DBO.FOscrip2            
insert into INHOUSE_NCDX.DBO.FOscrip2            
select * from NCDX.DBO.FOscrip2 with (nolock)            
            
--- Sub-broker            
truncate table INHOUSE_NCDX.DBO.subbrokers             
insert into INHOUSE_NCDX.DBO.subbrokers             
select * from NCDX.dbo.subbrokers with (nolock)            
            
--- Branch            
truncate table INHOUSE_NCDX.DBO.branches            
insert into INHOUSE_NCDX.DBO.branches            
select * from NCDX.dbo.branches with (nolock)            
            
--- Region            
truncate table INHOUSE_NCDX.DBO.region            
insert into INHOUSE_NCDX.DBO.region            
select * from NCDX.dbo.region with (nolock)            
            
--- Brokerage            
truncate table INHOUSE_NCDX.DBO.Broktable            
insert into INHOUSE_NCDX.DBO.Broktable            
select * from NCDX.dbo.Broktable with (nolock)            
          
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIDWARE_TrxDetails_INHOUSE
-- --------------------------------------------------
CREATE procedure [dbo].[MIDWARE_TrxDetails_INHOUSE]  
as        
set nocount on                  
        
declare @sdate as varchar(11)        
select top 1 @sdate=convert(varchar(13),sauda_DAte) from NCDX.dbo.fosettlement         
--print @sdate        
        
truncate table INHOUSE_NCDX.dbo.fosettlement
insert into INHOUSE_NCDX.dbo.fosettlement         
select * from NCDX.dbo.fosettlement with (nolock)     where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'             
        
truncate table INHOUSE_NCDX.dbo.foBILLVALAN 
insert into INHOUSE_NCDX.dbo.foBILLVALAN        
select * from NCDX.dbo.foBILLVALAN  with (nolock)   where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'             
    
truncate table INHOUSE_NCDX.dbo.tbl_clientmargin 
insert into INHOUSE_NCDX.dbo.tbl_clientmargin        
select * from NCDX.dbo.tbl_clientmargin  with (nolock)     where margindate >= @sdate+' 00:00:00' and  margindate <= @sdate+' 23:59:59'           
      
truncate table  INHOUSE_NCDX.dbo.collateraldetails 
insert into INHOUSE_NCDX.dbo.collateraldetails        
select * from msajag.dbo.collateraldetails with (nolock)    where effdate >= @sdate+' 00:00:00' and  effdate <= @sdate+' 23:59:59'              
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet
-- --------------------------------------------------

  
CREATE Proc [dbo].[NCMS_POdet](@pcode as varchar(10) = null)            
as            
            
set nocount on            
  
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:45') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update INTRANET.CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=11  
end          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
IF @pcode is null            
BEGIN            
    select distinct party_code into #PO_client from  INTRANET.cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   
  
  create index #PO_cli on #PO_client(Party_code)  
  
--if(select COUNT(1) from INTRANET.cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
  
--    select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
--   where margindate =@MARGINDATE and a.party_code=p.party_code   
      
                 
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
 imargin= -b.initialmargin,             
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select              
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',             
 clcode=b.party_code,             
 imargin=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/             
 span=0,             
 total=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/              
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
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
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
  
          
 delete from NCMS_marh where clcode=@pcode           
          
 insert into NCMS_marh            
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)            
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh            
           
END   
  
   Drop table #bb
   Drop table #dd
   drop table #NCMS_marh
  drop table #PO_client
  drop table #SharePO
  drop table #UnpleadgePO

exec angelcommodity.INHOUSE_NCE.dbo.NCMS_POdet 
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:45') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update INTRANET.CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=11     
End  
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_03Apr2018
-- --------------------------------------------------
create Proc [dbo].[NCMS_POdet_03Apr2018](@pcode as varchar(10) = null)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin           
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
          
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
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
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
 ) a          
 group by cltcode          
        
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
        
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
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin           
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
          
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59') a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
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
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'        
 ) a          
 group by cltcode          
        
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
        
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
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin           
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()          


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'
   /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18        )
 /********************************************************************************/
 ) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
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
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'   
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18        )
 /********************************************************************************/     
 ) a          
 group by cltcode          
        
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
        
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
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
-- PROCEDURE dbo.NCMS_POdet_09May2022
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_09May2022](@pcode as varchar(10) = null)          
as          
          
set nocount on          


if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))    
Begin
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=11
end        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/         
          
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2          
          
IF @pcode is null          
BEGIN          
    
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0
begin
DECLARE @MARGINDATE1 AS DATETIME      
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [196.1.115.196].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'

		select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [196.1.115.196].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)
		 where margindate =@MARGINDATE1
		 and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code
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
		 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)          
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
		 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)          
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
 imargin=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,           
 total=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/            
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
 
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/
 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code  
 
    /*************************Unpleadge Po adjust***************************/
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
 
    /*************************Share Po adjust***************************/
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
           
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
  
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code            
        
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
        
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=11   
End
      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_15Dec2020
-- --------------------------------------------------
create Proc [dbo].[NCMS_POdet_15Dec2020](@pcode as varchar(10) = null)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
 
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/
 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code  
 
    /*************************Unpleadge Po adjust***************************/
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
 
    /*************************Share Po adjust***************************/
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
           
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
  
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code            
        
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
        
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=11  
end          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtnxt/*sdtcur*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
IF @pcode is null            
BEGIN            
    select distinct party_code into #PO_client from  [196.1.115.132].cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   
  
  create index #PO_cli on #PO_client(Party_code)  
  
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
  
--    select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
--   where margindate =@MARGINDATE and a.party_code=p.party_code   
      
                 
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
 imargin= -b.initialmargin,             
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
/*end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select              
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',             
 clcode=b.party_code,             
 imargin=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/             
 span=0,             
 total=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/              
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
 end*/         
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
 -- and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=11     
End  
        
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=11  
end          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtnxt/*sdtcur*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
IF @pcode is null            
BEGIN            
    select distinct party_code into #PO_client from  [196.1.115.132].cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   
  
  create index #PO_cli on #PO_client(Party_code)  
  
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
DECLARE @MARGINDATE1 AS DATETIME        
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
   NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
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
 imargin=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/             
 span=0,             
 total=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/              
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
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
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
 -- and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=11     
End  
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_25Nov2020
-- --------------------------------------------------
create Proc [dbo].[NCMS_POdet_25Nov2020](@pcode as varchar(10) = null)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
 
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/
 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
  
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code            
        
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
        
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=11  
end          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtnxt/*sdtcur*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
IF @pcode is null            
BEGIN            
    select distinct party_code into #PO_client from  [196.1.115.132].cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   
  
  create index #PO_cli on #PO_client(Party_code)  
  
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
  
--    select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
--   where margindate =@MARGINDATE and a.party_code=p.party_code   
      
                 
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
 imargin= -b.initialmargin,             
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select              
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',             
 clcode=b.party_code,             
 imargin=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/             
 span=0,             
 total=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/              
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
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
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
 -- and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=11     
End  
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_30Mar2019
-- --------------------------------------------------
create Proc [dbo].[NCMS_POdet_30Mar2019](@pcode as varchar(10) = null)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
         
          
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
    /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
  ) a          
 group by cltcode          
        
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code            
        
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
        
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=11  
end          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtnxt/*sdtcur*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
IF @pcode is null            
BEGIN            
    select distinct party_code into #PO_client from  [196.1.115.132].cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   
  
  create index #PO_cli on #PO_client(Party_code)  
  
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
  
--    select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
--   where margindate =@MARGINDATE and a.party_code=p.party_code   
      
                 
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
 imargin= -b.initialmargin,             
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
/*end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select              
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',             
 clcode=b.party_code,             
 imargin=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/             
 span=0,             
 total=0,/*-b.initialmargin, */  /*commented on 07 july 2021 as suggested by raahul sir*/              
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
 end*/         
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
 -- and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=11     
End  
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_commodity
-- --------------------------------------------------

  
CREATE Proc [dbo].[NCMS_POdet_commodity](@pcode as varchar(10) = null)            
as            
            
set nocount on            
     
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
IF @pcode is null            
BEGIN            
    select distinct party_code into #PO_client from INTRANET.cms.dbo.NCMS_Commodity_clients with(nolock) 
   where CAST(updatedOn as date)=CAST(GETDATE() as date)
  
 
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select              
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',             
 clcode=b.party_code,             
 imargin= -b.initialmargin,             
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
  
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 --update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
  
          
 delete from NCMS_marh where clcode=@pcode           
          
 insert into NCMS_marh            
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)            
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh            
           
END   
  
   Drop table #bb
   Drop table #dd
   drop table #NCMS_marh
  drop table #PO_client
  drop table #SharePO
  drop table #UnpleadgePO

        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_ForRealTime_PO
-- --------------------------------------------------
  
  
CREATE Proc [dbo].[NCMS_POdet_ForRealTime_PO](@pcode as varchar(10) = null)            
as            
            
set nocount on            
         
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2            
            
     select distinct party_code into #PO_client from  INTRANET.cms.dbo.NCMS_RealPO_ForProcess  with(nolock)  where validationtxt='OK'  
  
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin a WITH (NOLOCK) ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code        
 ) b              
 
 
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)     ,#PO_client p             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   and CLTCODE=p.party_code  
  
    /*Added to exclude opening balance of current year*/  
 -- /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
  
   select * into #NCMS_Colleteralq from NCMS_Colleteral with(nolock) 

 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from #NCMS_Colleteralq a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco_forPO            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
 
        
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/
 balance=sum(case when drcr='D' then -VAMT
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND 
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)               
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
 
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/
 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code  
 
    /*************************Unpleadge Po adjust***************************/
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
 
    /*************************Share Po adjust***************************/
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
           
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
  
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code            
        
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
        
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 --from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from Unpleadge_marh where 1=2            
            
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
           
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
-- PROCEDURE dbo.NCMS_POdet_Unpledge_14Sep2023
-- --------------------------------------------------
  
create Proc [dbo].[NCMS_POdet_Unpledge_14Sep2023](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from Unpleadge_marh where 1=2            
            
IF @pcode is null            
BEGIN            
      
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
DECLARE @MARGINDATE1 AS DATETIME        
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
 end         
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
    /*************************Unpleadge Po adjust***************************/  
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
   
    /*************************Share Po adjust***************************/  
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
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */  
    
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
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
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NCMS_marh.clcode=b.party_Code              
          
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
          
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
          
 exec Fetch_CliUnreco @pcode           
          
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
-- PROCEDURE dbo.NRMS_LiveLedger
-- --------------------------------------------------
CREATE Proc [dbo].[NRMS_LiveLedger](@pcode as varchar(10) = null)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/         
          
select *,convert(money,0) as c into #NRMS_marh from NRMS_marh where 1=2          
          
IF @pcode is null          
BEGIN          
          
 insert into #NRMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
 
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/
 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NRMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NRMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NRMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NRMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NRMS_marh set ledgeramount=balance from #bb b  where #NRMS_marh.clcode=b.cltcode            
 update #NRMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NRMS_marh.clcode=b.party_Code            
 update #NRMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NRMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NRMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NRMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NRMS_marh.clcode=b.cltcode           
        
 update #NRMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NRMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b where #NRMS_marh.clcode=b.party_code          
        
 update #NRMS_marh set c=          
 (case           
 when (imargin*(NonCashConsideration/100))+non_cash > 0           
 then 0           
 else (imargin*(NonCashConsideration/100))+non_cash           
 end)           
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                  
                                                                
 update #NRMS_marh set PayoutValue =          
 case                                              
 when c >= ledgeramount  then ledgeramount      
 when c < ledgeramount then c                                              
 else 0 end      
         
 update #NRMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr         
 
 update #NRMS_marh set received=b.vamt from
 ( 
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
	 where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'
 ) b 
 where #NRMS_marh.clcode=b.cltcode 

 truncate table NRMS_marh          
        
 insert into NRMS_marh          
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)          
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NRMS_marh          
        
END          
ELSE          
BEGIN          
         
 insert into #NRMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')       */
  
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/ 
    /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
  ) a          
 group by cltcode          
        
        
 insert into #NRMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NRMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NRMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NRMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NRMS_marh set ledgeramount=balance from #bb1 b  where #NRMS_marh.clcode=b.cltcode            
 update #NRMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b WITH (NOLOCK)   where #NRMS_marh.clcode=b.party_Code            
        
 update #NRMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
        
 update #NRMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NRMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NRMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK)   where cltcode=@pcode group by cltcode) b            
 where #NRMS_marh.clcode=b.cltcode           
        
 update #NRMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NRMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b  WITH (NOLOCK)  where #NRMS_marh.clcode=b.party_code          
        
 update #NRMS_marh set c=          
 (case           
 when (imargin*(NonCashConsideration/100))+non_cash > 0           
 then 0           
 else (imargin*(NonCashConsideration/100))+non_cash           
 end)           
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                  
                                                                
 update #NRMS_marh set PayoutValue =          
 case                                              
 when c >= ledgeramount  then ledgeramount      
 when c < ledgeramount then c                                              
 else 0 end             
        
 update #NRMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr         

 update #NRMS_marh set received=b.vamt from
 ( 
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
	 where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'
 ) b 
 where #NRMS_marh.clcode=b.cltcode 

       
 delete from NRMS_marh where clcode=@pcode         
        
 insert into NRMS_marh          
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)          
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NRMS_marh          
         
END          
Set nocount off

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
-- PROCEDURE dbo.SEBI_PO_Coll
-- --------------------------------------------------
    
CREATE proc [dbo].[SEBI_PO_Coll]  
as   
begin  
truncate table SEBI_colletral_data   
   
 insert into SEBI_colletral_data     
 select *  from anand1.msajag.dbo.CollateralDetails c WITH (NOLOCK)     
   where exchange='NCX' and segment='FUTURES' and effdate = (select max(effdate) from anand1.msajag.dbo.CollateralDetails WITH (NOLOCK)     
   where effDate >= getdate()-10  and effDate <= getdate()  )      
 and exists  (select Party_Code from SEBI_Client s with(nolock) where s.party_code=c.Party_Code)  
   
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
 select  distinct party_code from INTRANET.cms.dbo.sccs_clientmaster_provisional with(nolock) where  
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2            
             
      
--if(select COUNT(1) from INTRANET.cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0  
--    and party_code in (select party_code from #aaa)  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  and party_code in (select party_code from #aaa)    
      
                 
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE   and party_code in (select party_code from #aaa)           
 ) b              
 --end         
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
  and CLTCODE in (select party_code from #aaa)  
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)  where party_code in (select party_code from #aaa)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
    
  select * into #NCMS_Colleteralq from NCMS_Colleteral where  party_Code in (select party_code from #aaa)  
    
  exec SEBI_PO_Coll  
         
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from #NCMS_Colleteralq a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b where #NCMS_marh.clcode=b.party_Code    
   
 --update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)     
         
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK) where cltcode in (select party_code from #aaa)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  and CLTCODE in (select party_code from #aaa)  
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


CREATE Proc [dbo].[SEBI_POdet_24Jun2021](@pcode as varchar(10) = null)          
as          
          
set nocount on          


select distinct party_code into #aaa from MIS.sccs.dbo.sccs_clientmaster with(nolock)
          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                              
          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                              
          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                              
          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'            
          and exclude='N' 
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)             
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtnxt from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/         
          
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2          
          
IF @pcode is null          
BEGIN          
    
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0
begin
DECLARE @MARGINDATE1 AS DATETIME      
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [196.1.115.196].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'

		select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [196.1.115.196].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)
		 where margindate =@MARGINDATE1
		 and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0
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
		 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)          
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
		 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)          
		 where margindate =@MARGINDATE  and party_code in (select party_code from #aaa)  
		  
		             
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE   and party_code in (select party_code from #aaa)         
 ) b            
 end       
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/
 balance=sum(case when drcr='D' then -VAMT
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND 
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)               
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/
  and CLTCODE in (select party_code from #aaa)
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
 -- and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )
 /********************************************************************************/
 
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)  where party_code in (select party_code from #aaa)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code  
 
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK) where cltcode in (select party_code from #aaa)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
	 where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  and CLTCODE in (select party_code from #aaa)
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
-- PROCEDURE dbo.SEBI_POdet_For_financialYearEnd
-- --------------------------------------------------
  
  
CREATE Proc [dbo].[SEBI_POdet_For_financialYearEnd](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2            
            
IF @pcode is null            
BEGIN            
      
if(select COUNT(1) from INTRANET.cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
DECLARE @MARGINDATE1 AS DATETIME        
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
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
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
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
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
   
  /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code    
   
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
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
-- select  distinct party_code from INTRANET.cms.dbo.sccs_clientmaster_provisional with(nolock) where  
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2            
             
      
--if(select COUNT(1) from INTRANET.cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0  
--    and party_code in (select party_code from #aaa)  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  and party_code in (select party_code from #aaa)    
      
                 
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE  -- and party_code in (select party_code from #aaa)           
 ) b              
 --end         
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
  --and CLTCODE in (select party_code from #aaa)  
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)  --where party_code in (select party_code from #aaa)
 ) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
    
 -- select * into #NCMS_Colleteralq from NCMS_Colleteral with(nolock) --where  party_Code in (select party_code from #aaa)  
    
 -- exec SEBI_PO_Coll  
         
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 --from #NCMS_Colleteralq a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
-- update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b where #NCMS_marh.clcode=b.party_Code    
   
 --update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)     
         
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK) --where cltcode in (select party_code from #aaa)  
 group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
 --update #NCMS_marh set c=            
 --(case             
 --when (imargin*(NonCashConsideration/100))+non_cash > 0             
 --then 0             
 --else (imargin*(NonCashConsideration/100))+non_cash             
 --end)             
 --+ ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                    
   
  --update #NCMS_marh set imargin=imargin*2.25         
  
                                                                  
 --update #NCMS_marh set PayoutValue =            
 --case                                                
 --when c >= ledgeramount  then ledgeramount        
 --when c < ledgeramount then c                                                
 --else 0 end        
           
 --update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr           
   
 update #NCMS_marh set received=b.vamt from  
 (   
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C' -- and CLTCODE in (select party_code from #aaa)  
 ) b   
 where #NCMS_marh.clcode=b.cltcode 
 
  /*added for unsetteledDrbills*/
    select cltcode,sum(VAMT) as UnsettledDrBill into #drbills from ACCOUNTNCDX.dbo.ledger WITH(NOLOCK)  
  where cast(EDT as date)>cast(getdate() as date) and VTYP in ('79','15') and DRCR='D' group by cltcode

  update  a set a.UnsettledDrBill=b.UnsettledDrBill from #NCMS_marh a, (select cltcode,UnsettledDrBill from #drbills) b where a.Clcode=b.CLTCODE
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
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK)               
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
   
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =  
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/           
            
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2            
             
      
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--DECLARE @MARGINDATE1 AS DATETIME        
---- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='NCX' and SEGMENT='FUTURES'  
  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='NCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0  
--    and party_code in (select party_code from #aaa)  
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
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
--   NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  and party_code in (select party_code from #aaa)    
      
                 
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from             
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE  -- and party_code in (select party_code from #aaa)           
 ) b              
 --end         
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                 
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCDX.dbo.ledger a  with(nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/  
  --and CLTCODE in (select party_code from #aaa)  
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCDX.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18   AND A.VNO=B.VNO     )  
 /********************************************************************************/  
   
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a            
 group by cltcode            
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)  --where party_code in (select party_code from #aaa)
 ) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
    
  select * into #NCMS_Colleteralq from NCMS_Colleteral with(nolock) --where  party_Code in (select party_code from #aaa)  
    
  exec SEBI_PO_Coll  
         
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from #NCMS_Colleteralq a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b where #NCMS_marh.clcode=b.party_Code    
   
 --update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)     
         
 update #NCMS_marh set OTherDr=b.Vbal from              
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b              
 where #NCMS_marh.clcode=b.cltcode            
  
          
 exec Fetch_CliUnreco            
             
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from               
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK) --where cltcode in (select party_code from #aaa)  
 group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code            
          
 --update #NCMS_marh set c=            
 --(case             
 --when (imargin*(NonCashConsideration/100))+non_cash > 0             
 --then 0             
 --else (imargin*(NonCashConsideration/100))+non_cash             
 --end)             
 --+ ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                    
   
  --update #NCMS_marh set imargin=imargin*2.25         
  
                                                                  
 --update #NCMS_marh set PayoutValue =            
 --case                                                
 --when c >= ledgeramount  then ledgeramount        
 --when c < ledgeramount then c                                                
 --else 0 end        
           
 --update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr           
   
 update #NCMS_marh set received=b.vamt from  
 (   
  Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C' -- and CLTCODE in (select party_code from #aaa)  
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
   select a.* into #NewCollNCDX from msajag.dbo.CollateralDetails a WITH (NOLOCK)     
   where exchange='NCX' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK)       
   where effDate <= getdate() and exchange='NCX' and segment='FUTURES')        
      
    
select a.*,c.[Angel scrip category] as Angel_Scrip,c.[ANGEL_VAR %] as Var_margin,CONVERT(MONEY, 0) as Value_BHC,      
CONVERT(MONEY, 0) as Value_AHC      
 into #we  from #NewCollNCDX a join      
 [CSOKYC-6].GENERAL.DBO.TBL_NRMS_RESTRICTED_SCRIPS c with(nolock) on a.ISIN=c.[isin no]      
    
 update #we set Value_BHC=qty*cl_rate      
update #we set Value_AHC=isnull(Value_BHC,0)-(isnull(Value_BHC,0)*isnull(Var_Margin,0)/100)      
    
truncate table Unpleadge_Colleteral    
    
insert into Unpleadge_Colleteral    
select party_code,0,sum(Value_AHC) from #we group by party_code    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_CliBal
-- --------------------------------------------------
CREATE Procedure [dbo].[Upd_CliBal]
as

set nocount on

truncate table CliBal

insert into CliBal
SELECT cltcode,
       Sum(CASE
             WHEN drcr = 'D' THEN -vamt
             ELSE vamt
           END) AS Ledger
FROM   accountncdx.dbo.ledger WITH (nolock)
WHERE  vdt >= (SELECT sdtcur
               FROM   accountncdx.dbo.parameter WITH (nolock)
               WHERE  sdtcur <= Getdate()
                      AND ldtcur >= Getdate())
       AND vdt <= (SELECT ldtcur
                   FROM   accountncdx.dbo.parameter WITH (nolock)
                   WHERE  sdtcur <= Getdate()
                          AND ldtcur >= Getdate())
       AND Isnumeric(cltcode) = 0 and ( VTYP<>35 or enteredby<>'MTF PROCESS')
GROUP  BY cltcode 

set nocount off

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
 PRINT @STR                  
  EXEC(@STR)                  
          
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MTF_Funding
-- --------------------------------------------------
--USP_MTF_Funding '2020-10-08 00:00:00.000'
CREATE Proc [dbo].[USP_MTF_Funding](@FilterDate as Datetime)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCDX.dbo.tbl_clientmargin WITH (NOLOCK) where MARGINDATE=@FilterDate
select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter WITH (NOLOCK)   where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
 --select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCDX.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
 

/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCDX.dbo.parameter with(nolock) where ldtcur        =
(select ldtprv from ACCOUNTNCDX.dbo.parameter with(nolock) where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/ 
 namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from           
 NCDX.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTNCDX.dbo.ledger a  with(nolock)           
 where VDT>=@FilterDate and VDT <= @FilterDate+' 23:59:59' and VTYP=15
 ) a          
 group by cltcode          
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCDX.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a  WITH (NOLOCK)  left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)         
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          

        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno  WITH (NOLOCK)  group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from intranet.cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
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
	 Select cltcode,vamt from ACCOUNTNCDX.dbo.ledger a (nolock) 
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
-- PROCEDURE dbo.USP_PenalReverse
-- --------------------------------------------------
CREATE PROCEDURE Usp_penalreverse
AS
    SET nocount ON

    DECLARE @FromDate AS DATETIME,
            @ToDate   AS DATETIME

    SELECT @FromDate = sdtcur
    FROM   accountncdx.dbo.parameter
    WHERE  sdtnxt = (SELECT sdtcur
                     FROM   accountncdx.dbo.parameter
                     WHERE  sdtcur <= Getdate()
                            AND ldtcur >= Getdate())

    SET @ToDate=CONVERT(DATETIME, CONVERT(VARCHAR(10), Getdate(), 101)
                                  + ' 23:59:59')

    SELECT vno,
           vtyp
    INTO   #bb
    FROM   accountncdx.dbo.ledger WITH (nolock)
    WHERE  cltcode = '560001'
           AND vdt >= @FromDate
           AND vdt <= @ToDate
           AND drcr = 'D'
           AND vtyp = 8

    CREATE CLUSTERED INDEX idxvno
      ON #bb (vno, vtyp)

    TRUNCATE TABLE penalrev_table

    INSERT INTO penalrev_table
                (revdate,
                 party_code,
                 revamount)
    SELECT vdt=CONVERT(DATETIME, CONVERT(VARCHAR(11), vdt)),
           cltcode,
           Vamt=Sum(vamt)
    FROM   (SELECT a.vdt,
                   a.cltcode,
                   a.vamt
            FROM   accountncdx.dbo.ledger a WITH (nolock)
                   INNER JOIN #bb b
                           ON a.vno = b.vno
                              AND a.vtyp = b.vtyp
                              /* and vdt>=@FromDate and vdt <=@ToDate */
                              AND drcr = 'C') X
    GROUP  BY CONVERT(DATETIME, CONVERT(VARCHAR(11), vdt)),
              cltcode

    SET nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_testing_result
-- --------------------------------------------------
-- =============================================
-- Author:		<RUCHI SHAH>
-- Create date: <27-Apr-2023>
-- Description:	<Testing - Compair BACK-office data and RTB data>
-- Example 
/*
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'STT'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'Stamp Duty'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'Day wise Summary - CCD'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'CCD'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'Day wise Summary - FOSETTLEMENT'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'FOSETTLEMENT'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'Charges'
exec [INHOUSE_NCDX].dbo.usp_testing_result @sdate = '2023-04-25',@Category = 'BILLVALAN'
*/
-- =============================================
CREATE PROCEDURE usp_testing_result
	@sdate date, 
	@Category varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- STT
	IF @Category = 'STT'
	BEGIN
		SELECT * FROM
		(
		SELECT TBA = 'RTB', RECTYPE, INST_TYPE, COUNT(DISTINCT PARTY_CODE) CL , SUM(PQTYTRD) AS PQ , SUM(PAMTTRD) AS PAMT, 
		SUM(PSTTTRD) AS PSTT, SUM(SQTYTRD) AS SQ, SUM(SAMTTRD) AS SAMT, SUM(SSTTTRD) AS SSTT, SUM(TOTALSTT) AS TSTT
		FROM STT_ClientDetail_RTB WITH (NOLOCK) WHERE SAUDA_DATE = @sdate
		GROUP BY RECTYPE, INST_TYPE
		union all 
		SELECT TBA = 'ORG', RECTYPE, INST_TYPE, COUNT(DISTINCT PARTY_CODE) CL , SUM(PQTYTRD) AS PQ , SUM(PAMTTRD) AS PAMT, 
		SUM(PSTTTRD) AS PSTT, SUM(SQTYTRD) AS SQ, SUM(SAMTTRD) AS SAMT, SUM(SSTTTRD) AS SSTT, SUM(TOTALSTT) AS TSTT
		FROM NCDX..STT_ClientDetail WITH (NOLOCK) WHERE SAUDA_DATE = @sdate 
		GROUP BY RECTYPE, INST_TYPE
		) a
		ORDER BY INST_TYPE, RECTYPE
	END

	---STAMP DUTY
	ELSE IF @Category = 'Stamp Duty'
	BEGIN
		SELECT TBA = 'RTB', INST_TYPE, COUNT(DISTINCT PARTY_CODE) CL , SUM(BUYQTY) AS PQ , SUM(SELLQTY) AS SQ, 
		SUM(BUYSTAMP) AS BUY_ST, SUM(SELLSTAMP) AS SELL_ST, SUM(TOTALSTAMP) AS TOT_ST
		FROM TBL_STAMP_DATA_RTB WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate -- AND PARTY_CODE = 'A1000092'
		GROUP BY INST_TYPE
		UNION ALL
		SELECT TBA = 'ORG', INST_TYPE, COUNT(DISTINCT PARTY_CODE) CL , SUM(BUYQTY) AS PQ , SUM(SELLQTY) AS SQ, 
		SUM(BUYSTAMP) AS BUY_ST, SUM(SELLSTAMP) AS SELL_ST, SUM(TOTALSTAMP) AS TOT_ST
		 FROM NCDX..TBL_STAMP_DATA WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate --AND PARTY_CODE = 'A1000092'
		--AND TOTALSTAMP <> 0 
		GROUP BY INST_TYPE
		ORDER BY INST_TYPE
	END

	-- CCD (day summary) 
	ELSE IF @Category = 'Day wise Summary - CCD'
	BEGIN
		SELECT N_TAB = 'RTB', COUNT(DISTINCT PARTY_CODE) CLT , SUM(QTY) AS QTY, SUM(BROKERAGE) AS BROKERAGE, SUM(SERVICE_TAX) AS SERVICE_TAX, 
		SUM(INS_CHRG) AS INS_CHRG, SUM(NETAMOUNT) AS NETAMOUNT , SUM(SEBI_TAX) AS SEBI_TAX, SUM(TURN_TAX) AS TURN_TAX, SUM(BROKER_CHRG) AS BROKER_CHRG, 
		SUM(OTHER_CHRG) AS OTHER_CHRG, SUM(NETAMOUNTALL) AS NETAMOUNTALL, SUM(BROK) AS BROK
		FROM MSAJAG.dbo.COMMON_CONTRACT_DATA_RTB_FO_NCDX with (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate -- AND CL_RATE <> 0
		UNION ALL
		SELECT N_TAB = 'ORG', COUNT(DISTINCT PARTY_CODE) CLT, SUM(QTY) AS QTY, SUM(BROKERAGE) AS BROKERAGE, SUM(SERVICE_TAX) AS SERVICE_TAX, 
		SUM(INS_CHRG) AS INS_CHRG, SUM(NETAMOUNT) AS NETAMOUNT , SUM(SEBI_TAX) AS SEBI_TAX, SUM(TURN_TAX) AS TURN_TAX, SUM(BROKER_CHRG) AS BROKER_CHRG, 
		SUM(OTHER_CHRG) AS OTHER_CHRG, SUM(NETAMOUNTALL) AS NETAMOUNTALL, SUM(BROK) AS BROK
		FROM MCDX.dbo.COMMON_CONTRACT_DATA WITH (NOLOCK) WHERE -- PARTY_CODE = 'A219988' AND 
			 EXCHANGE = 'NCX' AND SEGMENT = 'FUTURES' AND cast(SAUDA_DATE as date)= @sdate
	END

	-- CCD details
	ELSE IF @Category = 'CCD'
	BEGIN
		SELECT * FROM (
			SELECT N_TAB = 'RTB', SELL_BUY, BFCF_FLAG, COUNT(DISTINCT PARTY_CODE) CLT, SUM(QTY) AS QTY, SUM(BROKERAGE) AS BROKERAGE, SUM(SERVICE_TAX) AS SERVICE_TAX, 
			SUM(INS_CHRG) AS INS_CHRG, SUM(NETAMOUNT) AS NETAMOUNT , SUM(SEBI_TAX) AS SEBI_TAX, SUM(TURN_TAX) AS TURN_TAX, SUM(BROKER_CHRG) AS BROKER_CHRG, 
			SUM(OTHER_CHRG) AS OTHER_CHRG, SUM(NETAMOUNTALL) AS NETAMOUNTALL, SUM(BROK) AS BROK
			FROM MSAJAG.dbo.COMMON_CONTRACT_DATA_RTB_FO_NCDX WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate
			GROUP BY SELL_BUY, BFCF_FLAG
			UNION ALL
			SELECT N_TAB = 'ORG', SELL_BUY, BFCF_FLAG, COUNT(DISTINCT PARTY_CODE) CLT, SUM(QTY) AS QTY, SUM(BROKERAGE) AS BROKERAGE, SUM(SERVICE_TAX) AS SERVICE_TAX, 
			SUM(INS_CHRG) AS INS_CHRG, SUM(NETAMOUNT) AS NETAMOUNT , SUM(SEBI_TAX) AS SEBI_TAX, SUM(TURN_TAX) AS TURN_TAX, SUM(BROKER_CHRG) AS BROKER_CHRG, 
			SUM(OTHER_CHRG) AS OTHER_CHRG, SUM(NETAMOUNTALL) AS NETAMOUNTALL, SUM(BROK) AS BROK
			 FROM MCDX.dbo.COMMON_CONTRACT_DATA WITH (NOLOCK) WHERE -- PARTY_CODE = 'A219988' AND 
			 EXCHANGE = 'NCX' AND SEGMENT = 'FUTURES' AND cast(SAUDA_DATE as date)= @sdate
			GROUP BY SELL_BUY, BFCF_FLAG
		) A
		ORDER BY SELL_BUY, BFCF_FLAG
	END

	--FOSETTLEMENT - day summary 
	ELSE IF @Category = 'Day wise Summary - FOSETTLEMENT'
	BEGIN
		SELECT S_TABEL = 'RTB', COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(QTY) AS T_QTY , 
		SUM(NET_TOTAL_BEFORE_LEVIES-BROKERAGE) AS AMT , SUM(SERVICE_TAX) AS SERVICE_TAX , SUM(SEBIFEE) AS SEBIFEE, SUM(TURN_TAX) AS TURN_TAX, 
		SUM(STAMPDUTY) AS SD, SUM(STT) AS STT FROM PCNORDERDETAILS_FO_RTB WITH (NOLOCK)
		WHERE cast(TRADE_DATE as date)= @sdate --AND TRADE_TYPE = 'BT'
		UNION ALL
		SELECT S_TABEL = 'ORG', COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(TRADEQTY) AS T_QTY , 
		SUM(TRADE_AMOUNT) AS AMT , SUM(SERVICE_TAX) AS SERVICE_TAX , SUM(SEBI_TAX) AS SEBIFEE, SUM(TURN_TAX) AS TURN_TAX, 
		SUM(BROKER_CHRG) AS SD, SUM(INS_CHRG) AS STT 
		FROM NCDX..FOSETTLEMENT WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate
		AND AUCTIONPART = ''
	END

	--FOSETTLEMENT details
	ELSE IF @Category = 'FOSETTLEMENT'
	BEGIN
		SELECT * FROM (
			SELECT S_TABEL = 'RTB', INST_TYPE, BUYSELL, COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(QTY) AS T_QTY , 
			SUM(NET_TOTAL_BEFORE_LEVIES-BROKERAGE) AS AMT , SUM(SERVICE_TAX) AS SERVICE_TAX , SUM(SEBIFEE) AS SEBIFEE, SUM(TURN_TAX) AS TURN_TAX, 
			SUM(STAMPDUTY) AS SD, SUM(STT) AS STT FROM PCNORDERDETAILS_FO_RTB WITH (NOLOCK)
			 WHERE cast(TRADE_DATE as date)= @sdate --AND TRADE_TYPE = 'BT'
			GROUP BY INST_TYPE, BUYSELL
			UNION ALL
			SELECT S_TABEL = 'ORG', INST_TYPE, SELL_BUY, COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(TRADEQTY) AS T_QTY , 
			SUM(TRADE_AMOUNT) AS AMT , SUM(SERVICE_TAX) AS SERVICE_TAX , SUM(SEBI_TAX) AS SEBIFEE, SUM(TURN_TAX) AS TURN_TAX, 
			SUM(BROKER_CHRG) AS SD, SUM(INS_CHRG) AS STT 
			FROM NCDX..FOSETTLEMENT WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate -- AND PARTY_CODE = 'D417893'
			AND AUCTIONPART = ''
			GROUP BY INST_TYPE, SELL_BUY
		) A
		ORDER BY INST_TYPE, BUYSELL, S_TABEL
	END

	---Charges
	ELSE IF @Category = 'Charges'
	BEGIN
		Select * from 
		(
			SELECT S_TABEL = 'RTB', INST_TYPE, COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(tot_buyqty) AS B_QTY , SUM(tot_SELLqty) AS S_QTY , 
			SUM(TOT_TURNOVER) AS T_AMT , SUM(TOT_SERTAX) AS SERVICE_TAX , SUM(TOT_BROK) AS TOT_BROK, SUM(TOT_TURN_TAX) AS TURN_TAX, 
			SUM(TOT_STT) AS STT -- SUM(STAMPDUTY) AS STAMPDUTY, 
			FROM PRORDERWISEDETAILS_FO_RTB WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate --AND AUCTIONPART = ''
			GROUP BY INST_TYPE

			UNION ALL

			SELECT S_TABEL = 'ORG', CD_INST_TYPE, COUNT(DISTINCT CD_PARTY_CODE) AS PARTY_CODE, SUM(CD_TOT_BUYQTY) AS B_QTY , SUM(CD_TOT_SELLQTY) AS S_QTY , 
			SUM(CD_TOT_TURNOVER) AS T_AMT , SUM(CD_TOT_SERTAX) AS SERVICE_TAX , SUM(CD_TOT_BROK) AS TOT_BROK, SUM(CD_TOT_TURN_TAX) AS TURN_TAX, 
			SUM(CD_TOT_STT) AS STT -- SUM(STAMPDUTY) AS STAMPDUTY, 
			FROM NCDX..CHARGES_DETAIL WITH (NOLOCK) WHERE cast(CD_SAUDA_DATE as date)= @sdate AND CD_AUCTIONPART = ''
			GROUP BY CD_INST_TYPE	
		) A
		ORDER BY INST_TYPE
	END

	-- billvalan 
	ELSE IF @Category = 'BILLVALAN'
	BEGIN
		SELECT * FROM 
		(
			SELECT S_TABLE = 'RTB', INST_TYPE, TRADETYPE, COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(PQTY) AS PQTY, SUM(SQTY) AS SQTY, 
			SUM(PBILLAMT) AS PBILLAMT , SUM(SBILLAMT) AS SBILLAMT, SUM(SEBI_TAX) AS SEBI_TAX, SUM(TURN_TAX) AS TURN_TAX, SUM(BROKER_NOTE) AS SD, SUM(INS_CHRG) AS STT
			 FROM PCNTRADESUMMARY_FO_RTB WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate -- AND PARTY_CODE = 'A1004858'
			GROUP BY INST_TYPE, TRADETYPE
			UNION ALL
			SELECT S_TABLE = 'ORG', INST_TYPE, TRADETYPE, COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, SUM(PQTY) AS PQTY, SUM(SQTY) AS SQTY, 
			SUM(PBILLAMT) AS PBILLAMT , SUM(SBILLAMT) AS SBILLAMT, SUM(SEBI_TAX) AS SEBI_TAX, SUM(TURN_TAX) AS TURN_TAX, SUM(BROKER_NOTE) AS SD, SUM(INS_CHRG) AS STT
			 FROM NCDX..FOBILLVALAN WITH (NOLOCK) WHERE cast(SAUDA_DATE as date)= @sdate -- AND PARTY_CODE = 'A1004858'
			 AND AUCTIONPART = ''
			GROUP BY INST_TYPE, TRADETYPE 
		) A
		ORDER BY INST_TYPE, TRADETYPE
	END

END

GO

-- --------------------------------------------------
-- TABLE dbo.acmast
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast]
(
    [acname] VARCHAR(100) NULL,
    [longname] VARCHAR(100) NULL,
    [actyp] CHAR(10) NULL,
    [accat] CHAR(10) NULL,
    [familycd] CHAR(10) NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [accdtls] CHAR(35) NULL,
    [grpcode] CHAR(13) NULL,
    [BookType] CHAR(2) NULL,
    [MicrNo] VARCHAR(10) NULL,
    [branchcode] VARCHAR(10) NULL,
    [BtoBPayment] INT NULL,
    [PayMode] CHAR(1) NULL,
    [POBankName] VARCHAR(50) NULL,
    [POBranch] VARCHAR(25) NULL,
    [POBankcode] VARCHAR(10) NULL
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
-- TABLE dbo.AGG_DupRecLog
-- --------------------------------------------------
CREATE TABLE [dbo].[AGG_DupRecLog]
(
    [DupCount] INT NULL,
    [PrpTime] DATETIME NULL
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
    [ddno] VARCHAR(18) NULL,
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
    [ddno] VARCHAR(18) NULL,
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
-- TABLE dbo.bond_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[bond_marh]
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
-- TABLE dbo.branches
-- --------------------------------------------------
CREATE TABLE [dbo].[branches]
(
    [Branch_cd] CHAR(10) NOT NULL,
    [Short_Name] CHAR(20) NOT NULL,
    [Long_Name] CHAR(50) NULL,
    [Address1] CHAR(25) NULL,
    [Address2] CHAR(25) NULL,
    [City] CHAR(20) NULL,
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
    [deftrader] BIT NULL
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
    [Branch_Code] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CliBal
-- --------------------------------------------------
CREATE TABLE [dbo].[CliBal]
(
    [Cltcode] VARCHAR(10) NULL,
    [Ledger] MONEY NULL
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
-- TABLE dbo.foaccbill
-- --------------------------------------------------
CREATE TABLE [dbo].[foaccbill]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(12) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [BillDate] SMALLDATETIME NOT NULL,
    [Start_Date] SMALLDATETIME NOT NULL,
    [End_Date] SMALLDATETIME NOT NULL,
    [PayIn_Date] SMALLDATETIME NOT NULL,
    [PayOut_Date] SMALLDATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [expiryflag] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [Reserved3] INT NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOACCBILLDATA_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[FOACCBILLDATA_RTB]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(12) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [BillDate] SMALLDATETIME NOT NULL,
    [Start_Date] SMALLDATETIME NOT NULL,
    [End_Date] SMALLDATETIME NOT NULL,
    [PayIn_Date] SMALLDATETIME NOT NULL,
    [PayOut_Date] SMALLDATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [expiryflag] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [Reserved3] INT NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOBillValan
-- --------------------------------------------------
CREATE TABLE [dbo].[FOBillValan]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Client_Type] VARCHAR(10) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(10) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] SMALLDATETIME NULL,
    [Option_type] VARCHAR(2) NULL,
    [Strike_Price] MONEY NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MaturityDate] SMALLDATETIME NULL,
    [Sauda_date] SMALLDATETIME NULL,
    [IsIn] VARCHAR(12) NULL,
    [PQty] INT NULL,
    [SQty] INT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [PAmt] MONEY NULL,
    [SAmt] MONEY NULL,
    [PBrokAmt] MONEY NULL,
    [SBrokAmt] MONEY NULL,
    [PBillAmt] MONEY NULL,
    [SBillAmt] MONEY NULL,
    [Cl_Rate] MONEY NULL,
    [Cl_Chrg] MONEY NULL,
    [ExCl_Chrg] MONEY NULL,
    [Service_Tax] MONEY NULL,
    [ExSer_Tax] MONEY NULL,
    [InExSerFlag] SMALLINT NULL,
    [sebi_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [Broker_note] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [TradeType] VARCHAR(3) NULL,
    [ParticiPantCode] VARCHAR(15) NULL,
    [Terminal_Id] VARCHAR(15) NULL,
    [Family] VARCHAR(10) NULL,
    [FamilyName] VARCHAR(50) NULL,
    [Trader] VARCHAR(20) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [StatusName] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(2) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Region] VARCHAR(50) NULL,
    [UpdateDate] VARCHAR(11) NULL,
    [email] VARCHAR(100) NULL,
    [SBU] VARCHAR(10) NULL,
    [RELMGR] VARCHAR(10) NULL,
    [GRP] VARCHAR(10) NULL,
    [Sector] VARCHAR(20) NULL,
    [CMClosing] MONEY NULL,
    [Track] VARCHAR(1) NULL,
    [Numerator] MONEY NULL,
    [Denominator] MONEY NULL,
    [RegularLot] MONEY NULL,
    [Area] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOBILLVALANDATA_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[FOBILLVALANDATA_RTB]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Client_Type] VARCHAR(10) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(14) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] SMALLDATETIME NULL,
    [Option_type] VARCHAR(2) NULL,
    [Strike_Price] MONEY NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MaturityDate] SMALLDATETIME NULL,
    [Sauda_date] SMALLDATETIME NULL,
    [IsIn] VARCHAR(12) NULL,
    [PQty] INT NULL,
    [SQty] INT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [PAmt] MONEY NULL,
    [SAmt] MONEY NULL,
    [PBrokAmt] MONEY NULL,
    [SBrokAmt] MONEY NULL,
    [PBillAmt] MONEY NULL,
    [SBillAmt] MONEY NULL,
    [Cl_Rate] MONEY NULL,
    [Cl_Chrg] MONEY NULL,
    [ExCl_Chrg] MONEY NULL,
    [Service_Tax] MONEY NULL,
    [ExSer_Tax] MONEY NULL,
    [InExSerFlag] SMALLINT NULL,
    [sebi_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [Broker_note] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [TradeType] VARCHAR(3) NULL,
    [ParticiPantCode] VARCHAR(15) NULL,
    [Terminal_Id] VARCHAR(15) NULL,
    [Family] VARCHAR(10) NULL,
    [FamilyName] VARCHAR(50) NULL,
    [Trader] VARCHAR(20) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [StatusName] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(2) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Region] VARCHAR(50) NULL,
    [UpdateDate] VARCHAR(11) NULL,
    [email] VARCHAR(100) NULL,
    [SBU] VARCHAR(100) NULL,
    [RELMGR] VARCHAR(100) NULL,
    [GRP] VARCHAR(100) NULL,
    [Sector] VARCHAR(20) NULL,
    [CMClosing] MONEY NULL,
    [Track] VARCHAR(1) NULL,
    [Numerator] MONEY NULL,
    [Denominator] MONEY NULL,
    [RegularLot] MONEY NULL,
    [Area] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foscrip1
-- --------------------------------------------------
CREATE TABLE [dbo].[foscrip1]
(
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Expirydate] DATETIME NULL,
    [Strike_Price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foscrip2
-- --------------------------------------------------
CREATE TABLE [dbo].[foscrip2]
(
    [Inst_Type] VARCHAR(6) NOT NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_Name] VARCHAR(25) NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NULL,
    [Startdate] SMALLDATETIME NULL,
    [Maturitydate] DATETIME NULL,
    [Series] VARCHAR(2) NULL,
    [Cor_Act_Level] INT NULL,
    [C_Regular_Lot] INT NULL,
    [C_Issue_Mat_Dt] SMALLDATETIME NULL,
    [C_U_Inst_type] VARCHAR(6) NULL,
    [C_U_Symbol] VARCHAR(12) NULL,
    [C_U_Series] VARCHAR(2) NULL,
    [C_U_Expirydate] SMALLDATETIME NULL,
    [C_U_StrikePrice] MONEY NULL,
    [C_U_Option_type] VARCHAR(2) NULL,
    [C_U_CAL] INT NULL,
    [PriceUnit] VARCHAR(20) NULL,
    [Numerator] MONEY NULL,
    [Denominator] MONEY NULL,
    [RegularLot] MONEY NULL,
    [Qty_Unit] VARCHAR(10) NULL,
    [Delivery_Lot] NUMERIC(18, 4) NULL,
    [Delivery_Unit] VARCHAR(10) NULL,
    [P_Key] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fosettlement
-- --------------------------------------------------
CREATE TABLE [dbo].[fosettlement]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Strike_price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] MONEY NULL,
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
    [Status] VARCHAR(3) NULL,
    [CpId] INT NULL,
    [Instrument] MONEY NULL,
    [BookType] MONEY NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] VARCHAR(10) NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] MONEY NULL,
    [Reserved1] INT NULL,
    [Reserved2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.globals
-- --------------------------------------------------
CREATE TABLE [dbo].[globals]
(
    [year] VARCHAR(4) NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] NUMERIC(3, 2) NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] VARCHAR(30) NULL,
    [sebi_turn_ac] VARCHAR(30) NULL,
    [broker_note_ac] VARCHAR(30) NULL,
    [other_chrg_ac] VARCHAR(30) NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NULL,
    [year_end_dt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger]
(
    [vtyp] SMALLINT NOT NULL,
    [vno] VARCHAR(12) NULL,
    [edt] DATETIME NULL,
    [lno] INT NULL,
    [acname] VARCHAR(100) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NULL,
    [vno1] VARCHAR(12) NULL,
    [refno] CHAR(12) NULL,
    [balamt] MONEY NOT NULL,
    [NoDays] INT NULL,
    [cdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [BookType] CHAR(2) NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [pdt] DATETIME NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [actnodays] INT NULL,
    [narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger1
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger1]
(
    [bnkname] VARCHAR(50) NULL,
    [brnname] VARCHAR(20) NULL,
    [dd] CHAR(1) NULL,
    [ddno] VARCHAR(15) NULL,
    [dddt] DATETIME NULL,
    [reldt] DATETIME NULL,
    [relamt] MONEY NULL,
    [refno] CHAR(12) NOT NULL,
    [receiptno] INT NULL,
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] NUMERIC(18, 0) NULL,
    [drcr] CHAR(1) NULL,
    [BookType] CHAR(2) NULL,
    [MicrNo] INT NULL,
    [SlipNo] INT NULL,
    [slipdate] DATETIME NULL,
    [ChequeInName] VARCHAR(50) NULL,
    [Chqprinted] TINYINT NULL,
    [clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCMS_Comm_27Jul2021
-- --------------------------------------------------
CREATE TABLE [dbo].[NCMS_Comm_27Jul2021]
(
    [cltcode] VARCHAR(10) NOT NULL
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
-- TABLE dbo.NRMS_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[NRMS_marh]
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
-- TABLE dbo.offer_pcnorderDetails_FO_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[offer_pcnorderDetails_FO_RTB]
(
    [party_code] VARCHAR(20) NULL,
    [segment] VARCHAR(20) NULL,
    [order_No] VARCHAR(100) NULL,
    [order_time] VARCHAR(30) NULL,
    [trade_time] VARCHAR(30) NULL,
    [buysell] VARCHAR(20) NULL,
    [qty] INT NULL,
    [trade_no] VARCHAR(50) NULL,
    [security_name] VARCHAR(200) NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Expirydate] DATE NULL,
    [Strike_price] MONEY NULL,
    [Option_Type] VARCHAR(2) NULL,
    [Userid] INT NULL,
    [trade_date] DATETIME NULL,
    [sett_no] VARCHAR(30) NULL,
    [contract_no] VARCHAR(50) NULL,
    [brokerage] MONEY NULL,
    [net_rate_per_unit] MONEY NULL,
    [net_total_before_levies] MONEY NULL,
    [market_rate] FLOAT NULL,
    [cl_rate] FLOAT NULL,
    [Trade_type] VARCHAR(15) NULL,
    [CTCLID] VARCHAR(20) NULL,
    [memID] VARCHAR(20) NULL,
    [ContractNo] VARCHAR(30) NULL,
    [ContractNo_seg] VARCHAR(30) NULL,
    [Stampduty] NUMERIC(18, 4) NULL,
    [service_tax] NUMERIC(18, 4) NULL,
    [turn_tax] NUMERIC(18, 4) NULL,
    [stt] NUMERIC(18, 4) NULL,
    [sebifee] NUMERIC(18, 4) NULL,
    [series] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(20) NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [LOT_SIZE] INT NULL,
    [Table_No] VARCHAR(5) NULL,
    [Line_No] INT NULL,
    [Val_perc] CHAR(2) NULL,
    [leg_Type] VARCHAR(8) NULL,
    [Day_puc] DECIMAL(18, 4) NULL,
    [Day_Sales] DECIMAL(18, 4) NULL,
    [Sett_Purch] DECIMAL(18, 4) NULL,
    [sett_sales] DECIMAL(18, 4) NULL,
    [NORMAL] DECIMAL(18, 4) NULL,
    [OTHER_CHRG] NUMERIC(36, 12) NULL,
    [NUMERATOR] NUMERIC(18, 4) NULL,
    [DENOMINATOR] NUMERIC(18, 4) NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [OFFER_DISCOUNT_BROKERAGE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.offer_prorderwisedetails_FO_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[offer_prorderwisedetails_FO_RTB]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Sauda_Date] DATETIME NOT NULL,
    [Contract_No] VARCHAR(14) NOT NULL,
    [Trade_No] VARCHAR(15) NOT NULL,
    [Order_No] VARCHAR(16) NULL,
    [Inst_Type] VARCHAR(6) NOT NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Expiry_Date] DATETIME NOT NULL,
    [Option_Type] VARCHAR(2) NOT NULL,
    [Strike_Price] MONEY NOT NULL,
    [MarketLot] INT NOT NULL,
    [Scheme_Id] INT NOT NULL,
    [ComputationLevel] CHAR(1) NOT NULL,
    [ComputationOn] CHAR(1) NOT NULL,
    [ComputationType] CHAR(1) NOT NULL,
    [BuyRate] MONEY NOT NULL,
    [SellRate] MONEY NOT NULL,
    [Tot_BuyQty] INT NOT NULL,
    [Tot_SellQty] INT NOT NULL,
    [Tot_BuyTurnOver] MONEY NOT NULL,
    [Tot_SellTurnOver] MONEY NOT NULL,
    [Tot_BuyTurnOver_Rounded] MONEY NOT NULL,
    [Tot_SellTurnOver_Rounded] MONEY NOT NULL,
    [Tot_TurnOver] MONEY NOT NULL,
    [Tot_TurnOver_Rounded] MONEY NOT NULL,
    [Tot_Lot] INT NOT NULL,
    [Tot_Res_TurnOver] MONEY NOT NULL,
    [Tot_Res_TurnOver_Rounded] MONEY NOT NULL,
    [Tot_Res_Lot] INT NOT NULL,
    [Tot_BuyBrok] MONEY NOT NULL,
    [Tot_SellBrok] MONEY NOT NULL,
    [Tot_Brok] MONEY NOT NULL,
    [Tot_BuySerTax] MONEY NOT NULL,
    [Tot_SellSerTax] MONEY NOT NULL,
    [Tot_SerTax] MONEY NOT NULL,
    [Tot_Stt] MONEY NOT NULL,
    [Tot_Turn_Tax] MONEY NOT NULL,
    [Exch_BuyRate] MONEY NOT NULL,
    [Exch_SellRate] MONEY NOT NULL,
    [TimeStamp] DATETIME NOT NULL,
    [TOT_OTHER_CHRG] NUMERIC(36, 12) NULL,
    [OFFER_DISCOUNT_BROKERAGE] MONEY NULL
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
    [BranchFlag] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.party4
-- --------------------------------------------------
CREATE TABLE [dbo].[party4]
(
    [EXCHANGE] VARCHAR(7) NOT NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [vtyp] SMALLINT NOT NULL,
    [TYPE] VARCHAR(6) NOT NULL,
    [DRCR] CHAR(1) NULL,
    [VDT] DATETIME NULL,
    [VNO] VARCHAR(12) NULL,
    [VAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PCNORDERDETAILS_FO_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[PCNORDERDETAILS_FO_RTB]
(
    [party_code] VARCHAR(20) NULL,
    [segment] VARCHAR(20) NULL,
    [order_No] VARCHAR(100) NULL,
    [order_time] VARCHAR(30) NULL,
    [trade_time] VARCHAR(30) NULL,
    [buysell] VARCHAR(20) NULL,
    [qty] INT NULL,
    [trade_no] VARCHAR(50) NULL,
    [security_name] VARCHAR(200) NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Expirydate] DATE NULL,
    [Strike_price] MONEY NULL,
    [Option_Type] VARCHAR(2) NULL,
    [Userid] INT NULL,
    [trade_date] DATETIME NULL,
    [sett_no] VARCHAR(30) NULL,
    [contract_no] VARCHAR(50) NULL,
    [brokerage] MONEY NULL,
    [net_rate_per_unit] MONEY NULL,
    [net_total_before_levies] MONEY NULL,
    [market_rate] FLOAT NULL,
    [cl_rate] FLOAT NULL,
    [Trade_type] VARCHAR(15) NULL,
    [CTCLID] VARCHAR(20) NULL,
    [memID] VARCHAR(20) NULL,
    [ContractNo] VARCHAR(30) NULL,
    [ContractNo_seg] VARCHAR(30) NULL,
    [Stampduty] NUMERIC(18, 4) NULL,
    [service_tax] NUMERIC(18, 4) NULL,
    [turn_tax] NUMERIC(18, 4) NULL,
    [stt] NUMERIC(18, 4) NULL,
    [sebifee] NUMERIC(18, 4) NULL,
    [series] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(20) NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [LOT_SIZE] INT NULL,
    [Table_No] VARCHAR(5) NULL,
    [Line_No] INT NULL,
    [Val_perc] CHAR(2) NULL,
    [leg_Type] VARCHAR(8) NULL,
    [Day_puc] DECIMAL(18, 4) NULL,
    [Day_Sales] DECIMAL(18, 4) NULL,
    [Sett_Purch] DECIMAL(18, 4) NULL,
    [sett_sales] DECIMAL(18, 4) NULL,
    [NORMAL] DECIMAL(18, 4) NULL,
    [OTHER_CHRG] NUMERIC(36, 12) NULL,
    [NUMERATOR] NUMERIC(18, 4) NULL,
    [DENOMINATOR] NUMERIC(18, 4) NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [AUCTIONPART] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcnTradeSummary_FO_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[pcnTradeSummary_FO_RTB]
(
    [Party_Code] VARCHAR(10) NULL,
    [BillNo] INT NULL,
    [ContractNo] VARCHAR(10) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] SMALLDATETIME NULL,
    [Option_type] VARCHAR(2) NULL,
    [Strike_Price] MONEY NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MaturityDate] SMALLDATETIME NULL,
    [Sauda_date] SMALLDATETIME NULL,
    [IsIn] VARCHAR(12) NULL,
    [PQty] INT NULL,
    [SQty] INT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [PAmt] MONEY NULL,
    [SAmt] MONEY NULL,
    [PBrokAmt] MONEY NULL,
    [SBrokAmt] MONEY NULL,
    [PBillAmt] MONEY NULL,
    [SBillAmt] MONEY NULL,
    [Cl_Rate] MONEY NULL,
    [Cl_Chrg] MONEY NULL,
    [ExCl_Chrg] MONEY NULL,
    [Service_Tax] MONEY NULL,
    [ExSer_Tax] MONEY NULL,
    [InExSerFlag] SMALLINT NULL,
    [sebi_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [Broker_note] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [TradeType] VARCHAR(3) NULL,
    [ParticiPantCode] VARCHAR(15) NULL,
    [Terminal_Id] VARCHAR(15) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [StatusName] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(2) NULL,
    [Dummy5] MONEY NULL,
    [CMCLOSING] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PenalRev_Table
-- --------------------------------------------------
CREATE TABLE [dbo].[PenalRev_Table]
(
    [RevDate] DATETIME NULL,
    [Party_Code] VARCHAR(10) NULL,
    [RevAmount] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.prorderwisedetails_FO_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[prorderwisedetails_FO_RTB]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Sauda_Date] DATETIME NOT NULL,
    [Contract_No] VARCHAR(14) NOT NULL,
    [Trade_No] VARCHAR(15) NOT NULL,
    [Order_No] VARCHAR(16) NULL,
    [Inst_Type] VARCHAR(6) NOT NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Expiry_Date] DATETIME NOT NULL,
    [Option_Type] VARCHAR(2) NOT NULL,
    [Strike_Price] MONEY NOT NULL,
    [MarketLot] INT NOT NULL,
    [Scheme_Id] INT NOT NULL,
    [ComputationLevel] CHAR(1) NOT NULL,
    [ComputationOn] CHAR(1) NOT NULL,
    [ComputationType] CHAR(1) NOT NULL,
    [BuyRate] MONEY NOT NULL,
    [SellRate] MONEY NOT NULL,
    [Tot_BuyQty] INT NOT NULL,
    [Tot_SellQty] INT NOT NULL,
    [Tot_BuyTurnOver] MONEY NOT NULL,
    [Tot_SellTurnOver] MONEY NOT NULL,
    [Tot_BuyTurnOver_Rounded] MONEY NOT NULL,
    [Tot_SellTurnOver_Rounded] MONEY NOT NULL,
    [Tot_TurnOver] MONEY NOT NULL,
    [Tot_TurnOver_Rounded] MONEY NOT NULL,
    [Tot_Lot] INT NOT NULL,
    [Tot_Res_TurnOver] MONEY NOT NULL,
    [Tot_Res_TurnOver_Rounded] MONEY NOT NULL,
    [Tot_Res_Lot] INT NOT NULL,
    [Tot_BuyBrok] MONEY NOT NULL,
    [Tot_SellBrok] MONEY NOT NULL,
    [Tot_Brok] MONEY NOT NULL,
    [Tot_BuySerTax] MONEY NOT NULL,
    [Tot_SellSerTax] MONEY NOT NULL,
    [Tot_SerTax] MONEY NOT NULL,
    [Tot_Stt] MONEY NOT NULL,
    [Tot_Turn_Tax] MONEY NOT NULL,
    [Exch_BuyRate] MONEY NOT NULL,
    [Exch_SellRate] MONEY NOT NULL,
    [TimeStamp] DATETIME NOT NULL,
    [TOT_OTHER_CHRG] NUMERIC(36, 12) NULL,
    [AUCTIONPART] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.region
-- --------------------------------------------------
CREATE TABLE [dbo].[region]
(
    [RegionCode] VARCHAR(10) NULL,
    [Description] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL
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
-- TABLE dbo.STT_ClientDetail_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[STT_ClientDetail_RTB]
(
    [RecType] INT NOT NULL,
    [Sauda_Date] DATETIME NOT NULL,
    [ContractNo] VARCHAR(7) NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_Type] VARCHAR(6) NOT NULL,
    [Option_Type] VARCHAR(6) NOT NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Expirydate] DATETIME NOT NULL,
    [Strike_price] MONEY NULL,
    [TrdPrice] MONEY NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PSTTTrd] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SSTTTrd] MONEY NULL,
    [TotalSTT] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.subbrokers
-- --------------------------------------------------
CREATE TABLE [dbo].[subbrokers]
(
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(30) NULL,
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
    [Branch_code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_clientmargin
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_clientmargin]
(
    [party_code] VARCHAR(15) NOT NULL,
    [margindate] DATETIME NOT NULL,
    [billamount] MONEY NOT NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [noncash_coll] MONEY NOT NULL,
    [initialmargin] MONEY NOT NULL,
    [lst_update_dt] DATETIME NOT NULL,
    [short_name] VARCHAR(25) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [sub_broker] VARCHAR(20) NULL,
    [trader] VARCHAR(20) NULL,
    [MTMMargin] MONEY NULL,
    [AddMargin] MONEY NULL
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
-- TABLE dbo.TBL_RTB_DATA_UPD
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RTB_DATA_UPD]
(
    [SAUDA_DATE] DATETIME NULL,
    [UPD_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_STAMP_DATA_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_STAMP_DATA_RTB]
(
    [SAUDA_DATE] DATETIME NULL,
    [CONTRACTNO] VARCHAR(14) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [SYMBOL] VARCHAR(12) NULL,
    [EXPIRYDATE] SMALLDATETIME NULL,
    [STRIKE_PRICE] MONEY NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [BUYQTY] INT NULL,
    [SELLQTY] INT NULL,
    [BUYAVGRATE] NUMERIC(38, 2) NULL,
    [SELLAVGRATE] NUMERIC(38, 2) NULL,
    [BUYSTAMP] NUMERIC(38, 2) NULL,
    [SELLSTAMP] NUMERIC(38, 2) NULL,
    [TOTALSTAMP] NUMERIC(38, 2) NULL,
    [L_STATE] VARCHAR(100) NULL,
    [LASTRUNDATE] DATETIME NOT NULL
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
-- TABLE dbo.vmast
-- --------------------------------------------------
CREATE TABLE [dbo].[vmast]
(
    [Vtype] SMALLINT NOT NULL,
    [Vdesc] VARCHAR(35) NOT NULL,
    [ShortDesc] CHAR(6) NULL,
    [DispFlag] CHAR(1) NULL,
    [NarratioN] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.AIAAS_ExEmpActiveLogin
-- --------------------------------------------------
   
CREATE View AIAAS_ExEmpActiveLogin    
as    
select fldusername as BO_LoginId,emp_no,Emp_name,designation,CostCode,separationdate,CategoryDesc,Department,Sr_Name from    
(select * from AIAAS_UserInfo where active='Yes') a,    
intranet.risk.dbo.Vw_EmpInfoBlock  b    
where CHARINDEX(b.emp_no,fldusername) > 0

GO

-- --------------------------------------------------
-- VIEW dbo.AIAAS_UserInfo
-- --------------------------------------------------
CREATE View AIAAS_UserInfo  
as  
select a.fldauto,fldusername,username=fldfirstname+' '+fldmiddlename+' '+fldlastname,
Active=
(Case   
when isnull(b.fldstatus,9)=0 then 'Yes'   
when isnull(b.fldstatus,9)=1 then 'No'   
else 'Missing' end)  
from ncdx.dbo.tblpradnyausers a with (nolock) left outer join ncdx.dbo.tblUserControlMaster b with (nolock)  
on a.fldauto=b.flduserid  
where fldadminauto in (1,9,189,186,188)

GO

-- --------------------------------------------------
-- VIEW dbo.Angel_CMS_client_deposit_recno
-- --------------------------------------------------

CREATE VIEW Angel_CMS_client_deposit_recno
AS
SELECT 
accno,vtyp,booktype,vno,vdt,tdate,ddno,cltcode,acname,drcr,Dramt,Cramt,treldt,refno,last_Date
FROM 
BO_client_deposit_recno WITH (NOLOCK)

GO

-- --------------------------------------------------
-- VIEW dbo.NCMS_Colleteral
-- --------------------------------------------------

CREATE View [dbo].[NCMS_Colleteral]
as
	select party_Code,      
	CashColl=sum(Case when Cash_NCash='C' then FinalAmount else 0 end),      
	NonCashColl=sum(Case when Cash_NCash='N' then FinalAmount else 0 end)      
	from 
	( 
		 select Party_Code,FinalAmount,Cash_Ncash=(Case when scrip_cd='' and cash_ncash='' then 'C' else Cash_Ncash end)
		 from msajag.dbo.CollateralDetails WITH (NOLOCK) 
		 where exchange='NCX' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK) 
		 where effDate <= getdate() --and exchange='NCX' 		 and segment='FUTURES'
		 )  
	) x group by party_code

GO

-- --------------------------------------------------
-- VIEW dbo.ROE_GetAcMast
-- --------------------------------------------------

create view ROE_GetAcMast
as
select cltcode from accountncdx.dbo.acmast with (nolock) where       
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode with (nolock) where segment='NCDX')      
and cltcode not in (select cltcode from intranet.roe.dbo.ff_bank_details with (nolock) where segment='NCDEX' and cltcode <> 0)

GO

-- --------------------------------------------------
-- VIEW dbo.ROE_GetHOfund
-- --------------------------------------------------
create view ROE_GetHOfund
as
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  
from accountncdx.dbo.ledger (nolock) 
where vdt >= (select sdtcur from accountncdx.dbo.parameter with (nolock) where sdtcur <=getdate() and ldtcur >=getdate())
and vdt<=getdate()        
and cltcode in (select cltcode from ROE_GetAcMast)

GO

