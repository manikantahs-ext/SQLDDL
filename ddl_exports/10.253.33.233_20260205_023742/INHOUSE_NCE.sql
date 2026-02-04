-- DDL Export
-- Server: 10.253.33.233
-- Database: INHOUSE_NCE
-- Exported: 2026-02-05T02:37:53.913511

USE INHOUSE_NCE;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco
-- --------------------------------------------------
create Procedure [dbo].[Fetch_CliUnreco](@pcode as varchar(10) = null)      
as      
      
set nocount on      
      
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/      
declare @fromdt as datetime,@todate as datetime        
select @fromdt=sdtcur from ACCOUNTNCE.dbo.parameter where sdtnxt = (select sdtcur  from ACCOUNTNCE.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())        
select @todate=ldtcur from ACCOUNTNCE.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()        
-----------END----------------------      

IF @pcode is null
BEGIN
	      
	select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet      
	from ACCOUNTNCE.dbo.ledger b with (nolock)       
	where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1      
	      

	select       
	bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,
	clear_mode,L1_SNo      
	into #led1      
	from ACCOUNTNCE.dbo.ledger1 with (nolock)      
	where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )       
	      
	select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype       
	      
	      
	select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,       
	isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),       
	Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),       
	treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate(),l.narration       
	into #recodet       
	From ACCOUNTNCE.dbo.LEDGER l with (nolock)      
	join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno      
	and vdt <= getdate()       
	and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%')
	/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')*/
	        
	/*                                  
	select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno       
	create clustered index co_pcode on BO_client_deposit_recno(cltcode)       
	*/      

	delete from #recodet where narration = 'BEING AMT RECD TECH PROCESS'
	delete from #recodet where narration = 'BEING AMT RECEIVED BY ONLINE TRF'
	      
	      
	delete #recodet from #recodet a inner join NCE.DBO.CLient1 b WITH (NOLOCK) on       
	a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')       
	      
	truncate table BO_client_deposit_recno       
	insert into BO_client_deposit_recno 
	select co_code='NCE',getdate(),accno,vtyp,booktype,vno,vdt,tdate,ddno,cltcode,acname,drcr,Dramt,Cramt,treldt,refno,last_Date from #recodet (nolock)       
      
END

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_ForPO
-- --------------------------------------------------
create Procedure [dbo].[Fetch_CliUnreco_ForPO](@pcode as varchar(10) = null)        
as        
        
set nocount on        
        
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/        
declare @fromdt as datetime,@todate as datetime          
select @fromdt=sdtcur from ACCOUNTNCE.dbo.parameter where sdtnxt = (select sdtcur  from ACCOUNTNCE.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())          
select @todate=ldtcur from ACCOUNTNCE.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()          
-----------END----------------------        
  
IF @pcode is null  
BEGIN  
    select distinct party_code into #PO_client_unreco from  INTRANET.cms.dbo.NCMS_PO_Request_ForPayout with(nolock)     
    
  create index #PO_cli on #PO_client_unreco(Party_code)    
    
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet        
 from accountNCE.dbo.ledger b with (nolock)       ,#PO_client_unreco p                
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3)    and b.CLTCODE=p.party_code          
           
         
  
 select         
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,t.vtyp,t.vno,t.lno,drcr,t.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,  
 clear_mode,L1_SNo        
 into #led1        
 from accountNCE.dbo.ledger1 t with (nolock), #vdet l where l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype      
 and drcr='C' and clear_mode not in ( 'R', 'C') and t.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         
         
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype         
         
         
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate(),l.narration         
 into #recodet         
 From accountNCE.dbo.LEDGER l with (nolock)        
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
 and vdt <= getdate()         
 and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%')  
 /*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')*/  
           
 /*                                    
 select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno         
 create clustered index co_pcode on BO_client_deposit_recno(cltcode)         
 */        
  
 delete from #recodet where narration = 'BEING AMT RECD TECH PROCESS'  
 delete from #recodet where narration = 'BEING AMT RECEIVED BY ONLINE TRF'  
         
         
 delete #recodet from #recodet a inner join NCE.DBO.CLient1 b WITH (NOLOCK) on         
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
         
 truncate table BO_client_deposit_recno         
 insert into BO_client_deposit_recno   
 select co_code='MCX',getdate(),accno,vtyp,booktype,vno,vdt,tdate,ddno,cltcode,acname,drcr,Dramt,Cramt,treldt,refno,last_Date from #recodet (nolock)         
        
END  
ELSE  
BEGIN  
  
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet          
 from ACCOUNTNCE.dbo.ledger b with (nolock)           
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode    
  
 select           
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,    
 accno=space(10)          
 into #ledger1c          
 from ACCOUNTNCE.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype         
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )           
  
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc          
 from ACCOUNTNCE.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp    
 where  a.lno=1 /*and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process')  */  
  
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype    
  
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,           
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),           
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),           
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()           
 into #recodetc           
 From ACCOUNTNCE.dbo.LEDGER l with (nolock)          
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno          
 and vdt <= getdate()           
 and         
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%')  
 /*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')    */  
      
 delete #recodetc from #recodetc a inner join NCE.dbo.CLient1 b WITH (NOLOCK) on           
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')           
        
 delete from BO_client_deposit_recno where cltcode=@pcode          
 insert into BO_client_deposit_recno select co_code='MCX',getdate(),* from #recodetc (nolock)        
  
END  
  
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet
-- --------------------------------------------------

CREATE Proc [dbo].[NCMS_POdet](@pcode as varchar(10) = null)                  
as                  
                  
set nocount on      
  
              
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50                  
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCE.dbo.tbl_clientmargin WITH (NOLOCK)                   
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()                  
--select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE())                  
  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCE.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
                  
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2                  
CREATE CLUSTERED INDEX IDXCL ON #NCMS_marh(CLCODE)    
IF @pcode is null                  
BEGIN   
  select distinct party_code into #PO_client from  INTRANET.cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   
  
  create index #PO_cli on #PO_client(Party_code)  
  
--DECLARE @MARGINDATE1 AS DATETIME        
-- set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='MCX' and SEGMENT='FUTURES'  
  
      
--if(select COUNT(1) from INTRANET.cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='MCX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money=1  
       
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
--   NCE.dbo.tbl_clientmargin WITH (NOLOCK)            
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
--   NCE.dbo.tbl_clientmargin a WITH (NOLOCK)  ,#PO_client p          
--   where margindate =@MARGINDATE    and a.party_code=p.party_code      
      
                 
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
if((CONVERT(VARCHAR(5),GETDATE(),108)>='01:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='14:59'))      
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
 select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),                   
 ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),                    
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin a WITH (NOLOCK)    ,#PO_client p                     
 where margindate = @MARGINDATE   and a.party_code=p.party_code                     
 ) b               

end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select                    
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',                   
 clcode=b.party_code,                   
 imargin=0,/*-b.initialmargin, */        /*commented on 07 july 2021 as suggested by raahul sir*/          
 span=0,                   
 total=0,/*-b.initialmargin, */        /*commented on 07 july 2021 as suggested by raahul sir*/           
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin a WITH (NOLOCK)    ,#PO_client p                     
 where margindate = @MARGINDATE   and a.party_code=p.party_code                     
 ) b                    
end 

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                      
 into #bb                    
 from                  
 (                  
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCE.dbo.ledger a (nolock)   ,#PO_client p                        
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  
 and CLTCODE=p.party_code /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') */   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null                    
      
 select * into #NCMS_Colleteral from NCMS_Colleteral with(nolock)      
                 
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                    
 from #NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null                   
                
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                    
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteral b with (nolock)         
 where #NCMS_marh.clcode=b.party_Code       
               
 /*            
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                    
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0                   
 then 0  else total-received  end                   
 */            
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)               
                
 update #NCMS_marh set OTherDr=b.Vbal from                    
(select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                    
 where #NCMS_marh.clcode=b.cltcode                  
                
 exec Fetch_CliUnreco_ForPO                  
                   
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin WITH (NOLOCK)                    
 where margindate = @MARGINDATE and party_Code=@pcode                  
 ) b                    
      
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)                   
 into #bb1                    
 from                  
 (                  
  Select cltcode,vamt,drcr from ACCOUNTNCE.dbo.ledger a (nolock)                   
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')              */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18    AND A.VNO=B.VNO    )  
 /********************************************************************************/      
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null                    
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0               
 from NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode                  
                
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                    
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b with (nolock) where #NCMS_marh.clcode=b.party_Code                    
             
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) group by cltcode) b                    
 where #NCMS_marh.clcode=b.cltcode                   
                
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration                   
                
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent                  
 from intranet.cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code                  
                
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
  
                
 delete from NCMS_marh where clcode=@pcode                 
                
 insert into NCMS_marh                  
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)                  
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh                  
                 
END  
  Drop table #bb
  Drop table #NCMS_Colleteral
  drop table #NCMS_marh
  drop table #PO_client

 
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_commodity
-- --------------------------------------------------

CREATE Proc [dbo].[NCMS_POdet_commodity](@pcode as varchar(10) = null)                  
as                  
                  
set nocount on      
  
              
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50                  
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCE.dbo.tbl_clientmargin WITH (NOLOCK)                   
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()                  
--select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE())                  
  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCE.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
                  
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2                  
CREATE CLUSTERED INDEX IDXCL ON #NCMS_marh(CLCODE)    
IF @pcode is null                  
BEGIN   
  select distinct party_code into #PO_client from INTRANET.cms.dbo.NCMS_Commodity_clients with(nolock) 
   where CAST(updatedOn as date)=CAST(GETDATE() as date)  

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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin a WITH (NOLOCK)    ,#PO_client p                     
 where margindate = @MARGINDATE   and a.party_code=p.party_code                     
 ) b               

 

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                      
 into #bb                    
 from                  
 (                  
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCE.dbo.ledger a (nolock)   ,#PO_client p                        
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  
 and CLTCODE=p.party_code /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') */   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null                    
      
 select * into #NCMS_Colleteral from NCMS_Colleteral with(nolock)      
                 
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                    
 from #NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null                   
                
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                    
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteral b with (nolock)         
 where #NCMS_marh.clcode=b.party_Code       
               
 /*            
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                    
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0                   
 then 0  else total-received  end                   
 */            
             
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)               
                
 update #NCMS_marh set OTherDr=b.Vbal from                    
(select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                    
 where #NCMS_marh.clcode=b.cltcode                  
                
 exec Fetch_CliUnreco_ForPO                  
                   
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from                     
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                    
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
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
 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/   
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin WITH (NOLOCK)                    
 where margindate = @MARGINDATE and party_Code=@pcode                  
 ) b                    
      
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)                   
 into #bb1                    
 from                  
 (                  
  Select cltcode,vamt,drcr from ACCOUNTNCE.dbo.ledger a (nolock)                   
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')              */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18    AND A.VNO=B.VNO    )  
 /********************************************************************************/      
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null                    
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0               
 from NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode                  
                
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                    
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b with (nolock) where #NCMS_marh.clcode=b.party_Code                    
             
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) group by cltcode) b                    
 where #NCMS_marh.clcode=b.cltcode                   
                
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration                   
                
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent                  
 from intranet.cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code                  
                
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
  
                
 delete from NCMS_marh where clcode=@pcode                 
                
 insert into NCMS_marh                  
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)                  
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh                  
                 
END  
  Drop table #bb
  Drop table #NCMS_Colleteral
  drop table #NCMS_marh
  drop table #PO_client

 
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_ForRealTime_PO
-- --------------------------------------------------
create Proc [dbo].[NCMS_POdet_ForRealTime_PO](@pcode as varchar(10) = null)                  
as                  
                  
set nocount on      
               
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50                  
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCE.dbo.tbl_clientmargin WITH (NOLOCK)                   
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()                  
--select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE())                  
  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCE.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
                  
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2                  
CREATE CLUSTERED INDEX IDXCL ON #NCMS_marh(CLCODE)    
  
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin a WITH (NOLOCK)    ,#PO_client p                        
 where margindate = @MARGINDATE   and a.party_code=p.party_code                     
 ) b                    

 
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                      
 into #bb                    
 from                  
 (                  
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCE.dbo.ledger a (nolock)   ,#PO_client p                        
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  
 and CLTCODE=p.party_code /* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') */   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null                    
      
 select * into #NCMS_Colleteral from NCMS_Colleteral with(nolock)      
                 
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                    
 from #NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null                   
                
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                    
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteral b with (nolock)         
 where #NCMS_marh.clcode=b.party_Code       
                     
                
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
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

create Proc [dbo].[NCMS_POdet_Morning](@pcode as varchar(10) = null)                
as                
                
set nocount on                
              
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 100                
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCE.dbo.tbl_clientmargin WITH (NOLOCK)                 
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()                
--select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE())                



/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
                
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2                
CREATE CLUSTERED INDEX IDXCL ON #NCMS_marh(CLCODE)  
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
 namount=ledgeramount+(cash_coll+noncash_coll),                  
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                 
 NCE.dbo.tbl_clientmargin WITH (NOLOCK)                  
 where margindate = @MARGINDATE                 
 ) b                  
              
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/
 balance=sum(case when drcr='D' then -VAMT
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND 
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                    
 into #bb                  
 from                
 (                
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCE.dbo.ledger a (nolock)                 
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'/* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') */ 
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/) a                
 group by cltcode                
              
              
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                  
 from                 
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                  
 left outer join #NCMS_marh b                 
 on a.cltcode = b.clcode                   
 where b.clcode is null                  
    
 select * into #NCMS_Colleteral from NCMS_Colleteral    
               
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                  
 from #NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null                 
              
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                  
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteral b with (nolock)       
 where #NCMS_marh.clcode=b.party_Code     
     
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
	 Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock) 
	 where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'
 ) b 
 where #NCMS_marh.clcode=b.cltcode 

             
 truncate table NCMS_marh                
              
 insert into NCMS_marh                
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)                
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh                
              
END                
              
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_Unpledge
-- --------------------------------------------------
create Proc [dbo].[NCMS_POdet_Unpledge](@pcode as varchar(10) = null)                  
as                  
                  
set nocount on                  
                
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50                  
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCE.dbo.tbl_clientmargin WITH (NOLOCK)                   
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()                  
--select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE())                  
  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
                  
select *,convert(money,0) as c into #NCMS_marh from Unpleadge_marh where 1=2                  
CREATE CLUSTERED INDEX IDXCL ON #NCMS_marh(CLCODE)    
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin WITH (NOLOCK)                    
 where margindate = @MARGINDATE                   
 ) b                    
                 
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)                   
 into #bb                    
 from                  
 (                  
 Select cltcode,vamt,drcr from ACCOUNTNCE.dbo.ledger a (nolock)                   
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'/* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') */   
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCE.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null          
 
         
  exec SP_Unpleadge_Colleteral
  
 select * into #NCMS_Colleteral from Unpleadge_Colleteral with(nolock) 
 create index #t on #NCMS_Colleteral (party_code)  
                       
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                    
 from #NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null                   
                
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                    
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteral b with (nolock)         
 where #NCMS_marh.clcode=b.party_Code       
  
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
  
               
 truncate table Unpleadge_marh                  
                
 insert into Unpleadge_marh                  
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)                  
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh                  
                
END                  
                
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_POdet_new
-- --------------------------------------------------
  
create Proc [dbo].[SEBI_POdet_new](@Flag as varchar(10) = null)                  
as                  
                  
set nocount on                  
  
  
  
--truncate table SEBI_Client        
--insert into SEBI_Client  
--select distinct party_code from MIS.sccs.dbo.sccs_clientmaster with(nolock)  
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
  
--select *  into #aaa  from SEBI_Client  
  
DECLARE @Days VARCHAR(20)                            
                            
 SET @Days = (                            
   SELECT DATENAME(dw, GETDATE())                            
   )                 
--if (@Flag='Daily' and @Days = 'Tuesday')    
--Begin   
--insert into SEBI_colletral_data_hist  
--select *  from SEBI_colletral_data  
--end  
          
                
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50                  
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NCE.dbo.tbl_clientmargin WITH (NOLOCK)                   
select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()                  
--select @sdtcur=sdtcur from ACCOUNTNCE.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE())                  
  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur/*sdtnxt*/ from ACCOUNTNCE.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTNCE.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
                  
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2                  
CREATE CLUSTERED INDEX IDXCL ON #NCMS_marh(CLCODE)    
   
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
 initialmargin = isnull(initialmargin,0)+ isnull(AddMargin,0),--+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                    
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-AddMargin)  from                   
 NCE.dbo.tbl_clientmargin WITH (NOLOCK)                    
 where margindate = @MARGINDATE-- and party_code in (select party_code from #aaa)                  
 ) b                    
--end                
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)                      
 into #bb                    
 from                  
 (                  
 Select cltcode,vamt,drcr,CDT,VTYP from ACCOUNTNCE.dbo.ledger a (nolock)                   
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'/* and (VTYP<>35 and isnull(enteredby,'')<>'mtf process') */   
-- and CLTCODE in (select party_code from #aaa)  
    /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTNCE.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/) a                  
 group by cltcode                  
                
                
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                    
 from                   
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NCE.dbo.client2 (nolock)-- where party_code in (select party_code from #aaa)
 ) b  on a.cltcode=b.party_Code ) a                    
 left outer join #NCMS_marh b                   
 on a.cltcode = b.clcode                     
 where b.clcode is null                    
      
 --select * into #NCMS_Colleteral from NCMS_Colleteral with(nolock) -- where  party_Code in (select party_code from #aaa)    
   
 --exec SEBI_PO_Coll  
                 
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                      
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                    
 --from #NCMS_Colleteral a with (nolock) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null                   
                
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                    
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteral b with (nolock)         
 --where #NCMS_marh.clcode=b.party_Code       
               
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno-- where cltcode in (select party_code from #aaa)
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
  Select cltcode,vamt from ACCOUNTNCE.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C' --and CLTCODE in (select party_code from #aaa)  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   

  /*added for unsetteledDrbills*/
    select cltcode,sum(VAMT) as UnsettledDrBill into #drbills from ACCOUNTNCE.dbo.ledger WITH(NOLOCK)  
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
-- PROCEDURE dbo.SP_Unpleadge_Colleteral
-- --------------------------------------------------
CREATE Proc SP_Unpleadge_Colleteral              
as              
            
Begin               
   select a.* into #NewcollNCE from msajag.dbo.CollateralDetails a WITH (NOLOCK)             
   where exchange='NCE' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK)               
   where effDate <= getdate() and exchange='NCE' and segment='FUTURES')                
              
            
select a.*,c.[Angel scrip category] as Angel_Scrip,c.[ANGEL_VAR %] as Var_margin,CONVERT(MONEY, 0) as Value_BHC,              
CONVERT(MONEY, 0) as Value_AHC              
 into #we  from #NewcollNCE a join              
 [CSOKYC-6].GENERAL.DBO.TBL_NRMS_RESTRICTED_SCRIPS c with(nolock) on a.ISIN=c.[isin no]              
            
 update #we set Value_BHC=qty*cl_rate              
update #we set Value_AHC=isnull(Value_BHC,0)-(isnull(Value_BHC,0)*isnull(Var_Margin,0)/100)              
            
truncate table Unpleadge_Colleteral            
            
insert into Unpleadge_Colleteral            
select party_code,0,sum(Value_AHC) from #we group by party_code            
            
end

GO

-- --------------------------------------------------
-- TABLE dbo.BO_client_deposit_recno
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_client_deposit_recno]
(
    [co_Code] VARCHAR(10) NULL,
    [Upd_date] DATETIME NOT NULL,
    [accno] VARCHAR(30) NULL,
    [vtyp] SMALLINT NOT NULL,
    [booktype] CHAR(2) NOT NULL,
    [vno] VARCHAR(12) NOT NULL,
    [vdt] DATETIME NULL,
    [tdate] VARCHAR(30) NULL,
    [ddno] VARCHAR(30) NULL,
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
-- TABLE dbo.FOBILLVALANDATA_RTB
-- --------------------------------------------------
CREATE TABLE [dbo].[FOBILLVALANDATA_RTB]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
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
    [Area] VARCHAR(10) NULL,
    [Numerator] NUMERIC(18, 4) NULL,
    [Denominator] NUMERIC(18, 4) NULL
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
    [Expirydate] DATETIME NULL,
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
-- TABLE dbo.TBL_RTB_NCEDATA_UPD
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RTB_NCEDATA_UPD]
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
   from anand1.msajag.dbo.CollateralDetails WITH (NOLOCK)       
   where exchange='NCE' and segment='FUTURES' and effdate = (select max(effdate) from anand1.msajag.dbo.CollateralDetails WITH (NOLOCK)       
   where effDate >= getdate()-10 and effDate <= getdate() and exchange='NCE' and segment='FUTURES')        
 ) x group by party_code

GO

