-- DDL Export
-- Server: 10.253.78.163
-- Database: TERMINALMASTER
-- Exported: 2026-02-05T12:32:32.068017

USE TERMINALMASTER;
GO

-- --------------------------------------------------
-- FUNCTION dbo.get_trade_num
-- --------------------------------------------------
CREATE function get_trade_num(@tradenum varchar(30))  
RETURNs varchar(30)
As  
Begin  
--set @mmonth =  2  
--set @myear  = 2007  
Return 
replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(@tradenum
,'a',''),'b',''),'c',''),'d',''),'e',''),'f',''),'g',''),'h',''),'i',''),'j',''),'k',''),'l',''),'m',''),'n',''),'o',''),'p',''),'q',''),'r',''),'s',''),'t',''),'u',''),'v',''),'w',''),'x',''),'y',''),'z','')
  
End

GO

-- --------------------------------------------------
-- INDEX dbo.ebroking_Trades
-- --------------------------------------------------
CREATE CLUSTERED INDEX [dtcl] ON [dbo].[ebroking_Trades] ([dCurrentTime], [Party_Code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_mst_Terminals
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_mst_Terminals] ADD CONSTRAINT [PK_tbl_mst_Terminals] PRIMARY KEY ([Terminal_Id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CallNTrade_TO
-- --------------------------------------------------
CREATE procedure CallNTrade_TO (@fdate as varchar(11),@tdate as varchar(11),@access_to as varchar(15),@access_code as varchar(15))
as 
set nocount on

--select * from ebroking_trades
--declare @fdate as varchar(11),@tdate as varchar(11)
--Set @fdate='07/12/2009'  
--Set @tdate='07/12/2009'

declare @FDATE1 as varchar(11),@TDATE1 as varchar(11),@sql as varchar(2000)
set @FDATE1=convert(varchar(11),convert(datetime,@FDATE,103))                                                                                 
set @TDATE1=convert(varchar(11),convert(datetime,@TDATE,103)) 

set @sql='set nocount on
select Branch=branch_cd,[Dealer ID]=sdealerid,
bseTo=convert(decimal(15,2),sum(case when nMarketSegmentId=8 then (nQuantityTraded*nTradedPrice)/10000000 else 0 end)),
bsetrade=sum(case when nMarketSegmentId=8 then 1 else 0 end),
nseTo=convert(decimal(15,2),sum(case when nMarketSegmentId=1 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),
nsetrade=sum(case when nMarketSegmentId=1 then 1 else 0 end),
foTo=convert(decimal(15,2),sum(case when nMarketSegmentId=2 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),
fotrade=sum(case when nMarketSegmentId=2 then 1 else 0 end),
ncdexTo=convert(decimal(15,2),sum(case when nMarketSegmentId=64 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),
ncdextrade=sum(case when nMarketSegmentId=64 then 1 else 0 end),
mcxTo=convert(decimal(15,2),sum(case when nMarketSegmentId=16 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),
mcxtrade=sum(case when nMarketSegmentId=16 then 1 else 0 end),
mcxsxTo=convert(decimal(15,2),sum(case when nMarketSegmentId=1024 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),
mcxsxtrade=sum(case when nMarketSegmentId=1024 then 1 else 0 end),
[Server]=serverip
into #op
from ebroking_trades e left outer join (select branch_cd,party_code from intranet.risk.dbo.client_details)  c
on e.party_code=c.party_code 
where convert(datetime,convert(varchar(11),dCurrentTime)) >='''+@FDATE1+'''
and  convert(datetime,convert(varchar(11),dCurrentTime)) <='''+@TDATE1+'''
group by serverip,sdealerid,branch_cd 

--drop table #op
select * from #op

select '''',''Total '',
convert(decimal(15,2),sum(bseTo)),sum(bsetrade),
convert(decimal(15,2),sum(nseTo)),sum(nsetrade),
convert(decimal(15,2),sum(foTo)),sum(fotrade),
convert(decimal(15,2),sum(ncdexTo)),sum(ncdextrade),
convert(decimal(15,2),sum(mcxTo)),sum(mcxtrade),
convert(decimal(15,2),sum(mcxsxtrade)),sum(mcxsxtrade),''''
from #op set nocount off'

--print(@sql)
exec(@sql)

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CallNTrade_TO_test
-- --------------------------------------------------
CREATE procedure CallNTrade_TO_test --(@fdate as varchar(11),@tdate as varchar(11),@access_to as varchar(15),@access_code as varchar(15))  
as   
set nocount on  
  
--select * from ebroking_trades  
--declare @fdate as varchar(11),@tdate as varchar(11)  
--Set @fdate='07/12/2009'    
--Set @tdate='07/12/2009'  
  
declare @FDATE1 as varchar(11),@TDATE1 as varchar(11),@sql as varchar(2000)  
set @FDATE1=convert(varchar(11),convert(datetime,getdate()-1,103))                                                                                   
set @TDATE1=convert(varchar(11),convert(datetime,getdate()-1,103))   
  
set @sql='set nocount on  
select Branch=branch_cd,[Dealer ID]=sdealerid,  
bseTo=convert(decimal(15,2),sum(case when nMarketSegmentId=8 then ((nQuantityTraded) * (nTradedPrice))/10000000 else 0 end)),  
bsetrade=sum(case when nMarketSegmentId=8 then 1 else 0 end),  
nseTo=convert(decimal(15,2),sum(case when nMarketSegmentId=1 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),  
nsetrade=sum(case when nMarketSegmentId=1 then 1 else 0 end),  
foTo=convert(decimal(15,2),sum(case when nMarketSegmentId=2 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),  
fotrade=sum(case when nMarketSegmentId=2 then 1 else 0 end),  
ncdexTo=convert(decimal(15,2),sum(case when nMarketSegmentId=64 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),  
ncdextrade=sum(case when nMarketSegmentId=64 then 1 else 0 end),  
mcxTo=convert(decimal(15,2),sum(case when nMarketSegmentId=16 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),  
mcxtrade=sum(case when nMarketSegmentId=16 then 1 else 0 end),  
mcxsxTo=convert(decimal(15,2),sum(case when nMarketSegmentId=1024 then (nQuantityTraded*nTradedPrice)/10000000  else 0 end)),  
mcxsxtrade=sum(case when nMarketSegmentId=1024 then 1 else 0 end),  
[Server]=serverip  
into #op  
from ebroking_trades e left outer join (select branch_cd,party_code from intranet.risk.dbo.client_details)  c  
on e.party_code=c.party_code   
where convert(datetime,convert(varchar(11),dCurrentTime)) >='''+@FDATE1+'''  
and  convert(datetime,convert(varchar(11),dCurrentTime)) <='''+@TDATE1+'''  
group by serverip,sdealerid,branch_cd   
  
--drop table #op  
select * from #op  
  
--select '''',''Total '',  
--convert(decimal(15,2),sum(bseTo)),sum(bsetrade),  
--convert(decimal(15,2),sum(nseTo)),sum(nsetrade),  
--convert(decimal(15,2),sum(foTo)),sum(fotrade),  
--convert(decimal(15,2),sum(ncdexTo)),sum(ncdextrade),  
--convert(decimal(15,2),sum(mcxTo)),sum(mcxtrade),  
--convert(decimal(15,2),sum(mcxsxtrade)),sum(mcxsxtrade),''''  
--from #op set nocount off
'  
  
--print(@sql)  
exec(@sql)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebroking_trade_commo
-- --------------------------------------------------
create procedure ebroking_trade_commo  (@fdate as varchar(11) )          
as
--declare @fdate as varchar(11)
if @fdate='%'
BEGIN

select @fdate=max(sauda_date) from mis.remisior.dbo.comb_co 
END 

--delete from ebroking_Trades where nMarketSegmentId in ('8','1','2') 
--and  dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59'

insert into ebroking_Trades 
select * from [196.1.115.245].terminalmaster.dbo.ebroking_Trades where   
dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebroking_trade_dump_245
-- --------------------------------------------------
CREATE procedure ebroking_trade_dump_245(@fdate as varchar(11) )                
as      
  
--declare @fdate as varchar(11)      
if @fdate='%'      
BEGIN      
select @fdate=max(sauda_date) from mis.remisior.dbo.comb_co       
END       
     
delete from ebroking_Trades where     
dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+ ' 23:59:59'      
      
insert into ebroking_Trades       
select * from [196.1.115.245].terminalmaster.dbo.ebroking_Trades where         
dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+ ' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebroking_trade_eq
-- --------------------------------------------------
create procedure ebroking_trade_eq  (@fdate as varchar(11) )          
as
--declare @fdate as varchar(11)
if @fdate='%'
BEGIN

select @fdate=max(sauda_date)+1 from mis.remisior.dbo.comb_co 
END 

--delete from ebroking_Trades where nMarketSegmentId in ('8','1','2') 
--and  dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59'

insert into ebroking_Trades 
select * from [196.1.115.245].terminalmaster.dbo.ebroking_Trades where   
dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebrokingOfflineTrades_seg
-- --------------------------------------------------
CREATE PROC Ebrokingofflinetrades_seg (@FDATE AS VARCHAR(11))
AS
    IF @FDATE = '%'
      BEGIN
          --DECLARE @FDATE AS VARCHAR(11)                                                                                                      
          SELECT @FDATE = Max(SAUDA_DATE)
          FROM   MIS.REMISIOR.DBO.COMB_CO
      --PRINT @FDATE                                                                                                            
      END

    ----- SP FOR BSE                            
    DELETE FROM EBROKINGOFFLINETRADES
    WHERE  SAUDA_DATE >= @FDATE
           AND SAUDA_DATE <= @FDATE + ' 23:59:59'

    INSERT INTO EBROKINGOFFLINETRADES
    SELECT SEGMENT='BSECM',
           SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
           B.PARTY_CODE,
           TOTAL_BROK=Sum(NBROKAPP * TRADEQTY),
           --MARKETVALUE=SUM(MARKETRATE*TRADEQTY),                            
           --TURNOVER=SUM(N_NETRATE*TRADEQTY) --INTO EBROKINGOFFLINETRADES                            
           TURNOVER=Sum(MARKETRATE * TRADEQTY)
    FROM   (SELECT DISTINCT PARTY_CODE,
                            BSE_CODE,
                            NTRADEDORDERNUMBER,
                            NTRADENUMBER
            FROM   EBROKING_TRADES
            WHERE
             NMARKETSEGMENTID = '8'
             AND DCURRENTTIME >= @FDATE + ' 00:00:00'
             AND DCURRENTTIME <= @FDATE + ' 23:59:59'
             AND PARTY_CODE <> SDEALERID) A,
           (SELECT SAUDA_DATE,
                   PARTY_CODE,
                   SCRIP_CD,
                   NBROKAPP,
                   ORDER_NO,
                   TRADEQTY,
                   MARKETRATE,
                   N_NETRATE,
                   TRADE_NO
            FROM   ANAND.BSEDB_AB.DBO.SETTLEMENT
            WHERE
             SAUDA_DATE >= @FDATE + ' 00:00:00'
             AND SAUDA_DATE <= @FDATE + ' 23:59:59') B
    WHERE
      DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
      AND B.SCRIP_CD = A.BSE_CODE
      AND A.PARTY_CODE = B.PARTY_CODE
      AND B.ORDER_NO = A.NTRADEDORDERNUMBER
    GROUP  BY
      CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
      B.PARTY_CODE

    ----- SP FOR NSE                            
    INSERT INTO EBROKINGOFFLINETRADES
    SELECT SEGMENT='NSECM',
           SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
           B.PARTY_CODE,
           TOTAL_BROK=Sum(NBROKAPP * TRADEQTY),
           --MARKETVALUE=SUM(MARKETRATE*TRADEQTY),                            
           --TURNOVER=SUM(N_NETRATE*TRADEQTY) --INTO EBROKINGOFFLINETRADES                            
           TURNOVER=Sum(MARKETRATE * TRADEQTY)
    FROM   (SELECT DISTINCT PARTY_CODE,
                            BSE_CODE=SSYMBOL,
                            NTRADEDORDERNUMBER,
                            NTRADENUMBER
            FROM   EBROKING_TRADES
            WHERE
             NMARKETSEGMENTID = '1'
             AND DCURRENTTIME >= @FDATE + ' 00:00:00'
             AND DCURRENTTIME <= @FDATE + ' 23:59:59'
             AND PARTY_CODE <> SDEALERID) A,
           (SELECT SAUDA_DATE,
                   PARTY_CODE,
                   SCRIP_CD,
                   NBROKAPP,
                   ORDER_NO,
                   TRADEQTY,
                   MARKETRATE,
                   N_NETRATE,
                   TRADE_NO
            FROM   ANAND1.MSAJAG.DBO.SETTLEMENT
            WHERE
             SAUDA_DATE >= @FDATE + ' 00:00:00'
             AND SAUDA_DATE <= @FDATE + ' 23:59:59') B
    WHERE
      DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
      AND B.SCRIP_CD = A.BSE_CODE
      AND A.PARTY_CODE = B.PARTY_CODE
      AND B.ORDER_NO = A.NTRADEDORDERNUMBER
    GROUP  BY
      CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
      B.PARTY_CODE

    ----- SP FOR FO                            
    SELECT B.*,
           BSE_CODE,
           NTRADEDORDERNUMBER,
           NTRADENUMBER,
           TURNOVER=( STRIKE_PRICE + PRICE ) * TRADEQTY,
           BROKERAGE=CASE
                       WHEN LEFT(INST_TYPE, 3) = 'FUT' THEN TRADEQTY * BROKAPPLIED
                       ELSE 0
                     END
    INTO   #FOFILE
    FROM   (SELECT DISTINCT PARTY_CODE,
                            BSE_CODE,
                            NTRADEDORDERNUMBER,
                            NTRADENUMBER
            FROM   EBROKING_TRADES
            WHERE
             NMARKETSEGMENTID = '2'
             AND DCURRENTTIME >= @FDATE + ' 00:00:00'
             AND DCURRENTTIME <= @FDATE + ' 23:59:59'
             AND PARTY_CODE <> SDEALERID) A,
           (SELECT TRADE_NO,
                   SAUDA_DATE,
                   PARTY_CODE,
                   SYMBOL,
                   INST_TYPE,
                   SEC_NAME,
                   EXPIRYDATE,
                   OPTION_TYPE,
                   NBROKAPP,
                   ORDER_NO,
                   TRADEQTY,
                   BROKAPPLIED,
                   PRICE,
                   STRIKE_PRICE
            FROM   ANGELFO.NSEFO.DBO.FOSETTLEMENT
            WHERE
             SAUDA_DATE >= @FDATE + ' 00:00:00'
             AND SAUDA_DATE <= @FDATE + ' 23:59:59') B
    WHERE
      A.PARTY_CODE = B.PARTY_CODE
      AND DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
      AND B.ORDER_NO = A.NTRADEDORDERNUMBER

    --GROUP BY CONVERT(DATETIME,CONVERT(VARCHAR(11),SAUDA_DATE)),B.PARTY_CODE                  
    SELECT TRADE_NO,
           ORDER_NO,
           PARTY_CODE,
           BROKERAGE=Sum(CD_TOT_BROK)
    INTO   #NSEFO_OPT
    FROM   #FOFILE A,
           ANGELFO.NSEFO.DBO.CHARGES_DETAIL B
    WHERE
      A.TRADE_NO = B.CD_AUCTIONPART + B.CD_TRADE_NO
      --A.TRADE_NO=B.CD_TRADE_NO                                              
      AND A.ORDER_NO = B.CD_ORDER_NO
      AND A.PARTY_CODE = B.CD_PARTY_CODE
      AND B.CD_SAUDA_DATE >= @FDATE
      AND B.CD_SAUDA_DATE <= @FDATE + ' 23:59:59'
    GROUP  BY
      TRADE_NO,
      ORDER_NO,
      PARTY_CODE

    UPDATE #FOFILE
    SET    BROKERAGE = B.BROKERAGE
    FROM   #NSEFO_OPT B
    WHERE  ( #FOFILE.TRADE_NO ) = B.TRADE_NO
           AND #FOFILE.ORDER_NO = B.ORDER_NO
           AND #FOFILE.PARTY_CODE = B.PARTY_CODE

    INSERT INTO EBROKINGOFFLINETRADES
    SELECT SEGMENT='FO',
           SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
           PARTY_CODE,
           TOTAL_BROK=Sum(BROKERAGE),
           --MARKETVALUE=SUM(MARKETRATE*TRADEQTY),                            
           TURNOVER=Sum(TURNOVER)
    FROM   #FOFILE
    GROUP  BY
      CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
      PARTY_CODE

    ----- SP FOR MCX – 12685                            
    INSERT INTO EBROKINGOFFLINETRADES
    SELECT SEGMENT='MCX',
           SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
           B.PARTY_CODE,
           TOTAL_BROK=Sum(BROKAPPLIED * TRADEQTY * ( BOOKTYPE / INSTRUMENT )),
           TURNOVER=Sum(( STRIKE_PRICE + PRICE ) * TRADEQTY * ( BOOKTYPE / INSTRUMENT ))
    FROM   (SELECT DISTINCT PARTY_CODE,
                            BSE_CODE,
                            NTRADEDORDERNUMBER,
                            NTRADENUMBER
            FROM   EBROKING_TRADES
            WHERE
             NMARKETSEGMENTID = '16'
             AND DCURRENTTIME >= @FDATE + ' 00:00:00'
             AND DCURRENTTIME <= @FDATE + ' 23:59:59'
             AND PARTY_CODE <> SDEALERID) A,
           (SELECT TRADE_NO,
                   SAUDA_DATE,
                   PARTY_CODE,
                   SYMBOL,
                   STRIKE_PRICE,
                   INST_TYPE,
                   SEC_NAME,
                   EXPIRYDATE,
                   OPTION_TYPE,
                   BOOKTYPE,
                   INSTRUMENT,
                   ORDER_NO,
                   TRADEQTY,
                   BROKAPPLIED,
                   PRICE
            FROM   ANGELCOMMODITY.MCDX.DBO.FOSETTLEMENT
            WHERE
             SAUDA_DATE >= @FDATE + ' 00:00:00'
             AND SAUDA_DATE <= @FDATE + ' 23:59:59') B
    WHERE
      A.PARTY_CODE = B.PARTY_CODE
      AND DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
      AND B.ORDER_NO = A.NTRADEDORDERNUMBER
    GROUP  BY
      CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
      B.PARTY_CODE

    ----- SP FOR NCDEX – 00220                            
    INSERT INTO EBROKINGOFFLINETRADES
    SELECT SEGMENT='NCDEX',
           SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
           B.PARTY_CODE,
           TOTAL_BROK=Sum(BROKAPPLIED * TRADEQTY * ( BOOKTYPE / INSTRUMENT )),
           TURNOVER=Sum(( STRIKE_PRICE + PRICE ) * TRADEQTY * ( BOOKTYPE / INSTRUMENT ))
    FROM   (SELECT DISTINCT PARTY_CODE,
                            BSE_CODE,
                            NTRADEDORDERNUMBER,
                            NTRADENUMBER
            FROM   EBROKING_TRADES
            WHERE
             NMARKETSEGMENTID = '64'
             AND DCURRENTTIME >= @FDATE + ' 00:00:00'
             AND DCURRENTTIME <= @FDATE + ' 23:59:59'
             AND PARTY_CODE <> SDEALERID) A,
           (SELECT TRADE_NO,
                   SAUDA_DATE,
                   PARTY_CODE,
                   SYMBOL,
                   STRIKE_PRICE,
                   INST_TYPE,
                   SEC_NAME,
                   EXPIRYDATE,
                   OPTION_TYPE,
                   BOOKTYPE,
                   INSTRUMENT,
                   ORDER_NO,
                   TRADEQTY,
                   BROKAPPLIED,
                   PRICE
            FROM   ANGELCOMMODITY.NCDX.DBO.FOSETTLEMENT
            WHERE
             SAUDA_DATE >= @FDATE + ' 00:00:00'
             AND SAUDA_DATE <= @FDATE + ' 23:59:59') B
    WHERE
      A.PARTY_CODE = B.PARTY_CODE
      AND DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
      AND B.ORDER_NO = A.NTRADEDORDERNUMBER
    GROUP  BY
      CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
      B.PARTY_CODE

    ----- SP FOR MCXSX – 10500                            
    INSERT INTO EBROKINGOFFLINETRADES
    SELECT SEGMENT='MCXSX',
           SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
           B.PARTY_CODE,
           TOTAL_BROK=Sum(BROKAPPLIED * TRADEQTY * ( BOOKTYPE / INSTRUMENT )),
           TURNOVER=Sum(( STRIKE_PRICE + PRICE ) * TRADEQTY * ( BOOKTYPE / INSTRUMENT ))
    FROM   (SELECT DISTINCT PARTY_CODE,
                            BSE_CODE,
                            NTRADEDORDERNUMBER,
                            NTRADENUMBER
            FROM   EBROKING_TRADES
            WHERE
             NMARKETSEGMENTID = '1024'
             AND DCURRENTTIME >= @FDATE + ' 00:00:00'
             AND DCURRENTTIME <= @FDATE + ' 23:59:59'
             AND PARTY_CODE <> SDEALERID) A,
           (SELECT TRADE_NO,
                   SAUDA_DATE,
                   PARTY_CODE,
                   SYMBOL,
                   STRIKE_PRICE,
                   INST_TYPE,
                   SEC_NAME,
                   EXPIRYDATE,
                   OPTION_TYPE,
                   BOOKTYPE,
                   INSTRUMENT,
                   ORDER_NO,
                   TRADEQTY,
                   BROKAPPLIED,
                   PRICE
            FROM   ANGELCOMMODITY.MCDXCDS.DBO.FOSETTLEMENT
            WHERE
             SAUDA_DATE >= @FDATE + ' 00:00:00'
             AND SAUDA_DATE <= @FDATE + ' 23:59:59') B
    WHERE
      A.PARTY_CODE = B.PARTY_CODE
      AND DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
      AND B.ORDER_NO = A.NTRADEDORDERNUMBER
    GROUP  BY
      CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
      B.PARTY_CODE
      
      ----- SP for NSX – 12798                            
INSERT INTO EBROKINGOFFLINETRADES
SELECT SEGMENT='NSX',
       SAUDA_DATE=CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
       B.PARTY_CODE,
       TOTAL_BROK=Sum(BROKAPPLIED * TRADEQTY * ( BOOKTYPE / INSTRUMENT )),
       TURNOVER=Sum(( STRIKE_PRICE + PRICE ) * TRADEQTY * ( BOOKTYPE / INSTRUMENT ))
FROM   (SELECT DISTINCT PARTY_CODE,
                        BSE_CODE,
                        NTRADEDORDERNUMBER,
                        NTRADENUMBER
        FROM   EBROKING_TRADES
        WHERE
         NMARKETSEGMENTID = '2048'
         AND DCURRENTTIME >=@FDATE+' 00:00:00' AND DCURRENTTIME <=@FDATE+' 23:59:59' 
         AND PARTY_CODE <> SDEALERID) A,
       (SELECT TRADE_NO,
               SAUDA_DATE,
               PARTY_CODE,
               SYMBOL,
               STRIKE_PRICE,
               INST_TYPE,
               SEC_NAME,
               EXPIRYDATE,
               OPTION_TYPE,
               BOOKTYPE,
               INSTRUMENT,
               ORDER_NO,
               TRADEQTY,
               BROKAPPLIED,
               PRICE
        FROM   ANGELFO.NSECURFO.DBO.FOSETTLEMENT WITH(NOLOCK)
       WHERE SAUDA_DATE >=@FDATE+' 00:00:00' AND SAUDA_DATE <=@FDATE+' 23:59:59'                            
       ) B
WHERE
  A.PARTY_CODE = B.PARTY_CODE
  AND DBO.Get_trade_num(B.TRADE_NO) = A.NTRADENUMBER
  AND B.ORDER_NO = A.NTRADEDORDERNUMBER
GROUP  BY
  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)),
  B.PARTY_CODE 

      
--------------------------------------------------------------------------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebrokingOfflineTrades_seg_bak_08_14_2012
-- --------------------------------------------------
CREATE proc ebrokingOfflineTrades_seg_bak_08_14_2012 (@fdate as varchar(11))                            
as                          
if @fdate='%'                                                                                         
BEGIN                                                                                        
 --declare @fdate as varchar(11)                                                                                                      
 select @fdate=max(sauda_date) from mis.remisior.dbo.comb_co                                                                              
--print @fdate                                                                                                            
END                            
----- SP for BSE                            
delete from ebrokingOfflineTrades where sauda_date >=@fdate and sauda_date<=@fdate+' 23:59:59'                          
                          
insert into ebrokingOfflineTrades                            
select segment='BSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                            
--MarketValue=sum(MarketRate*tradeqty),                            
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTrades                            
Turnover=sum(MarketRate*tradeqty)                
from                            
(  
select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='8'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59'  and party_code<>sdealerid                        
) a,                            
(                            
select                             
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate ,Trade_no                           
from anand.bsedb_Ab.dbo.settlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'         
) b                             
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code       
and b.Order_no=a.nTradedOrderNumber                          
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
                            
----- SP for NSE                            
insert into ebrokingOfflineTrades                            
select segment='NSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                            
--MarketValue=sum(MarketRate*tradeqty),                            
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTrades                            
Turnover=sum(MarketRate*tradeqty)                          
from                            
(select distinct party_Code,BSE_Code=ssymbol,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='1'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid  ) a,                            
(                            
select                             
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate,Trade_no                            
from anand1.msajag.dbo.settlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code      
and b.Order_no=a.nTradedOrderNumber                                               
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
            
          
                 
----- SP for FO                            
select b.*,BSE_Code,nTradedOrderNumber,nTradeNumber,          
Turnover=(strike_price+ price)* tradeqty,                     
Brokerage=case when left(inst_type,3)='FUT' then tradeqty*brokapplied else 0 end                  
into #fofile from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='2'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select   Trade_no,                         
sauda_date,Party_code,symbol,inst_type,Sec_name,expirydate,option_type,nBrokApp,Order_no,Tradeqty,brokapplied  ,price,strike_price                          
from angelfo.nsefo.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                           
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber      
and b.Order_no=a.nTradedOrderNumber                                           
--group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
                  
select trade_no,order_no,party_code,                  
brokerage=sum(cd_tot_brok)                                  
into #nsefo_opt                                              
from                                               
#fofile a,                                               
angelfo.nsefo.dbo.charges_detail b                                              
where                                     
a.trade_no=b.cd_auctionPart+b.CD_trade_no                                     
--a.trade_no=b.cd_trade_no                                              
and a.order_no=b.cd_order_no                                              
and a.party_Code=b.cd_party_code                                              
and b.cd_sauda_DATE >=@fdate and b.cd_sauda_Date <= @fdate+' 23:59:59'                                                        
group by trade_no,order_no,party_code                  
                  
update #fofile set Brokerage=b.brokerage from #nsefo_opt b where (#fofile.trade_no)=b.trade_no                  
and #fofile.order_no=b.order_no and #fofile.party_code=b.party_code                  
                  
insert into ebrokingOfflineTrades                            
select segment='FO', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
Party_code,Total_Brok=sum(Brokerage),                            
--MarketValue=sum(MarketRate*tradeqty),                            
Turnover=sum(Turnover)                  
from #fofile                            
group by convert(Datetime,convert(varchar(11),sauda_date)),Party_code                  
                     
                            
----- SP for MCX – 12685                            
insert into ebrokingOfflineTrades                            
select segment='MCX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                       
from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='16'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                                  
from angelcommodity.mcdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber          
and b.Order_no=a.nTradedOrderNumber                                             
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
                            
----- SP for NCDEX – 00220                            
insert into ebrokingOfflineTrades                            
select segment='NCDEX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                                      
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                       
from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='64'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                                  
from angelcommodity.ncdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber         
and b.Order_no=a.nTradedOrderNumber                                              
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
                  
----- SP for MCXSX – 10500                            
insert into ebrokingOfflineTrades                            
select segment='MCXSX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                       
from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='1024'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                                  
from angelcommodity.mcdxcds.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber            
and b.Order_no=a.nTradedOrderNumber                                           
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebrokingOfflineTrades_seg_test
-- --------------------------------------------------
CREATE proc ebrokingOfflineTrades_seg_test (@fdate as varchar(11))                            
as                          
                       
                          
--insert into ebrokingOfflineTrades                            
select segment='BSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                            
--MarketValue=sum(MarketRate*tradeqty),                            
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTrades                            
Turnover=sum(MarketRate*tradeqty)                
from                            
(  
select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='8'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59'  and party_code<>sdealerid                        
) a,                            
(                            
select                             
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate ,Trade_no                           
from anand.bsedb_Ab.dbo.settlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'         
) b                             
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code       
and b.Order_no=a.nTradedOrderNumber                          
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
                            
----- SP for NSE                            
insert into ebrokingOfflineTrades                            
select segment='NSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                            
--MarketValue=sum(MarketRate*tradeqty),                            
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTrades                            
Turnover=sum(MarketRate*tradeqty)                          
from                            
(select distinct party_Code,BSE_Code=ssymbol,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='1'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid  ) a,                            
(                            
select                             
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate,Trade_no                            
from anand1.msajag.dbo.settlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code      
and b.Order_no=a.nTradedOrderNumber                                               
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
            
          
                 
----- SP for FO                            
select b.*,BSE_Code,nTradedOrderNumber,nTradeNumber,          
Turnover=(strike_price+ price)* tradeqty,                     
Brokerage=case when left(inst_type,3)='FUT' then tradeqty*brokapplied else 0 end                  
into #fofile from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='2'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select   Trade_no,                         
sauda_date,Party_code,symbol,inst_type,Sec_name,expirydate,option_type,nBrokApp,Order_no,Tradeqty,brokapplied  ,price,strike_price                          
from angelfo.nsefo.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                           
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber      
and b.Order_no=a.nTradedOrderNumber                                           
--group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
                  
select trade_no,order_no,party_code,                  
brokerage=sum(cd_tot_brok)                                  
into #nsefo_opt                                              
from                                               
#fofile a,                                               
angelfo.nsefo.dbo.charges_detail b                                              
where                                     
a.trade_no=b.cd_auctionPart+b.CD_trade_no                                     
--a.trade_no=b.cd_trade_no                                              
and a.order_no=b.cd_order_no                                              
and a.party_Code=b.cd_party_code                                              
and b.cd_sauda_DATE >=@fdate and b.cd_sauda_Date <= @fdate+' 23:59:59'                                                        
group by trade_no,order_no,party_code                  
                  
update #fofile set Brokerage=b.brokerage from #nsefo_opt b where (#fofile.trade_no)=b.trade_no                  
and #fofile.order_no=b.order_no and #fofile.party_code=b.party_code                  
                  
insert into ebrokingOfflineTrades                            
select segment='FO', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
Party_code,Total_Brok=sum(Brokerage),                            
--MarketValue=sum(MarketRate*tradeqty),                            
Turnover=sum(Turnover)                  
from #fofile                            
group by convert(Datetime,convert(varchar(11),sauda_date)),Party_code                  
                     
                            
----- SP for MCX – 12685                            
insert into ebrokingOfflineTrades                            
select segment='MCX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                       
from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='16'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                                  
from angelcommodity.mcdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber          
and b.Order_no=a.nTradedOrderNumber                                             
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
                            
----- SP for NCDEX – 00220                            
insert into ebrokingOfflineTrades                            
select segment='NCDEX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                                      
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                       
from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='64'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                                  
from angelcommodity.ncdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber         
and b.Order_no=a.nTradedOrderNumber                                              
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                            
                  
----- SP for MCXSX – 10500                            
insert into ebrokingOfflineTrades                            
select segment='MCXSX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                       
from                            
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='1024'                          
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59' and party_code<>sdealerid ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                                  
from angelcommodity.mcdxcds.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber            
and b.Order_no=a.nTradedOrderNumber                                           
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code   
  
--------------------------------------------------------------------------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebrokingOfflineTrades_seg_test_11012011
-- --------------------------------------------------
--ebrokingOfflineTrades_seg_test_11012011 'dec 01 2010'
CREATE proc ebrokingOfflineTrades_seg_test_11012011 (@fdate as varchar(11))                            
as                          
                
                
insert into ebrokingOfflineTradestest                            
select  segment='BSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                            
--MarketValue=sum(MarketRate*tradeqty),                            
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTradestest                            
Turnover=sum(MarketRate*tradeqty),terminalid  
from                            
(  
select distinct ltrim(rtrim(Clinet_Code1)) as party_Code,ScripCd as BSE_Code,Order_Number as nTradedOrderNumber,TradeNo as nTradeNumber 
from ebroking.dbo.tblBSETrade where                          
date >=@fdate+' 00:00:00' and date <=@fdate+' 23:59:59'  and ltrim(rtrim(ClientCode_DealerID))<>ltrim(rtrim(Clinet_Code1))                        
) a,                            
(                            
select                             
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate ,Trade_no,User_id as terminalid                           
from anand.bsedb_Ab.dbo.history where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'         
) b                             
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code       
and b.Order_no=a.nTradedOrderNumber                          
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code,terminalid                            
                            
----- SP for NSE                            
insert into ebrokingOfflineTradestest                            
select segment='NSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                            
--MarketValue=sum(MarketRate*tradeqty),                            
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTradestest                            
Turnover=sum(MarketRate*tradeqty),terminalid                          
from                            
(select distinct ltrim(rtrim(ClinetCode1)) as party_Code,BSE_Code=Symbol,nTradedOrderNumber=OrderNumber, TradeNo as nTradeNumber 
from ebroking.dbo.tblNSETrade 
where TradeDateTime >=@fdate+' 00:00:00' and TradeDateTime <=@fdate+' 23:59:59' 
and ltrim(rtrim(ClinetCode_DealerID))<>ltrim(rtrim(ClinetCode1))  ) a,                            
(                            
select                             
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate,Trade_no,User_id as terminalid                             
from anand1.msajag.dbo.history where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code      
and b.Order_no=a.nTradedOrderNumber                                               
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code ,terminalid                           
            
          
                 
----- SP for FO                            
select b.*,BSE_Code,nTradedOrderNumber,nTradeNumber,          
Turnover=(strike_price+ price)* tradeqty,                     
Brokerage=case when left(inst_type,3)='FUT' then tradeqty*brokapplied else 0 end                
into #fofile from                            
(select distinct party_Code=ltrim(rtrim(Clinet_Code1)),BSE_Code=Symbol,nTradedOrderNumber=OrderNo,nTradeNumber=TradeNo 
from ebroking.dbo.tblNSEFOTrade  
where TradeDateTime >=@fdate+' 00:00:00' and TradeDateTime <=@fdate+' 23:59:59' 
and ltrim(rtrim(Clinet_Code1))<>ClinetCode_DealerID ) a,                            
(                            
select   Trade_no,                         
sauda_date,Party_code,symbol,inst_type,Sec_name,expirydate,option_type,nBrokApp,Order_no,Tradeqty,brokapplied ,
price,strike_price ,User_id as terminalid                        
from angelfo.nsefo.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                           
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber      
and b.Order_no=a.nTradedOrderNumber                                           
--group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
                  
select trade_no,order_no,party_code,                  
brokerage=sum(cd_tot_brok)                                  
into #nsefo_opt                                              
from                                               
#fofile a,                                               
angelfo.nsefo.dbo.charges_detail b                                              
where                                     
a.trade_no=b.cd_auctionPart+b.CD_trade_no                                     
--a.trade_no=b.cd_trade_no                                              
and a.order_no=b.cd_order_no                                              
and a.party_Code=b.cd_party_code                                              
and b.cd_sauda_DATE >=@fdate and b.cd_sauda_Date <= @fdate+' 23:59:59'                                                        
group by trade_no,order_no,party_code             
                  
update #fofile set Brokerage=b.brokerage from #nsefo_opt b where (#fofile.trade_no)=b.trade_no                  
and #fofile.order_no=b.order_no and #fofile.party_code=b.party_code                  
                  
insert into ebrokingOfflineTradestest                            
select segment='FO', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
Party_code,Total_Brok=sum(Brokerage),                            
--MarketValue=sum(MarketRate*tradeqty),                            
Turnover=sum(Turnover) ,terminalid                 
from #fofile                            
group by convert(Datetime,convert(varchar(11),sauda_date)),Party_code ,terminalid                      
                     
                            
----- SP for MCX – 12685                            
insert into ebrokingOfflineTradestest                            
select segment='MCX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument)), terminalid                          
from                            
(select distinct party_Code=ltrim(rtrim(ClinetCode)),BSE_Code=Symbol,nTradedOrderNumber=orderno,nTradeNumber=TradeNo
 from ebroking.dbo.tblMCXTrade  where                    
TradeDateTime >=@fdate+' 00:00:00' and TradeDateTime <=@fdate+' 23:59:59' and ltrim(rtrim(ClinetCode))<>ltrim(rtrim(ClinetCode_DealerID)) ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,
Order_no,Tradeqty,brokapplied  ,price   ,User_id as terminalid                                  
from angelcommodity.mcdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber          
and b.Order_no=a.nTradedOrderNumber                                             
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code ,terminalid                           
                            
----- SP for NCDEX – 00220                            
insert into ebrokingOfflineTradestest                            
select segment='NCDEX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                                      
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument)), terminalid                          
from                            
(select distinct party_Code=ltrim(rtrim(ClinetCode)),BSE_Code=Symbol,nTradedOrderNumber=OrderNo,nTradeNumber=TradeNo 
from ebroking.dbo.tblNSDEXTrade  where 
TradeDateTime >=@fdate+' 00:00:00' and TradeDateTime <=@fdate+' 23:59:59' 
and ltrim(rtrim(ClinetCode))<>ltrim(rtrim(ClinetCode_DealerID)) ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,
expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price,User_id as terminalid                                     
from angelcommodity.ncdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber         
and b.Order_no=a.nTradedOrderNumber                                              
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code , terminalid                              
                  
----- SP for MCXSX – 10500                            
insert into ebrokingOfflineTradestest                            
select segment='MCXSX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                      
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument)),terminalid                       
from                            
(select distinct party_Code=ltrim(rtrim(ClinetCode)),BSE_Code=Symbol1,nTradedOrderNumber=OrderNo,nTradeNumber=TradeNo
 from ebroking.dbo.tblMCXSXTrade where 
 TradeDateTime1 >=@fdate+' 00:00:00' and TradeDateTime1 <=@fdate+' 23:59:59' and ltrim(rtrim(ClinetCode))<>ltrim(rtrim(ClinetCode_DealerID)) ) a,                            
(                            
select Trade_no,                         
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,
Order_no,Tradeqty,brokapplied  ,price,User_id as terminalid                                   
from angelcommodity.mcdxcds.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                            
) b                             
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber            
and b.Order_no=a.nTradedOrderNumber                                           
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code ,terminalid  
  
--------------------------------------------------------------------------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ebrokingOfflineTrades_temp_seg
-- --------------------------------------------------
CREATE proc ebrokingOfflineTrades_temp_seg (@fdate as varchar(11))                  
as                
if @fdate='%'                                                                               
BEGIN                                                                              
 --declare @fdate as varchar(11)                                                                                            
 select @fdate=max(sauda_date) from mis.remisior.dbo.comb_co                                                                    
--print @fdate                                                                                                  
END                  
----- SP for BSE                  
delete from ebrokingOfflineTrades_temp where sauda_date >=@fdate and sauda_date<=@fdate+' 23:59:59'                
                
insert into ebrokingOfflineTrades_temp                  
select segment='BSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                  
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                  
--MarketValue=sum(MarketRate*tradeqty),                  
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTrades_temp                  
Turnover=sum(MarketRate*tradeqty)      
from                  
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='8'                
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59'                
) a,                  
(                  
select                   
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate ,Trade_no                 
from remisior.dbo.BSEDATA_monthend_Jan_feB where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                  
) b                   
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code                 
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
                  
----- SP for NSE                  
insert into ebrokingOfflineTrades_temp                  
select segment='NSECM', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                  
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                  
--MarketValue=sum(MarketRate*tradeqty),                  
--Turnover=sum(N_netRate*tradeqty) --into ebrokingOfflineTrades_temp                  
Turnover=sum(MarketRate*tradeqty)                
from                  
(select distinct party_Code,BSE_Code=ssymbol,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='1'                
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59') a,                  
(                  
select                   
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate,Trade_no                  
from  remisior.dbo.NSEDATA_monthend_Jan_feB  where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                  
) b                   
where dbo.get_trade_num(b.Trade_no)=a.nTradeNumber and b.scrip_Cd=a.bse_Code and a.party_code=b.party_code                 
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
             
----- SP for FO                  
select b.*,BSE_Code,nTradedOrderNumber,nTradeNumber,Turnover=(price* tradeqty),             
Brokerage=case when left(inst_type,3)='FUT' then tradeqty*brokapplied else 0 end        
into #fofile from                  
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='2'                
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59') a,                  
(                  
select   Trade_no,               
sauda_date,Party_code,symbol,inst_type,Sec_name,expirydate,option_type,nBrokApp,Order_no,Tradeqty,brokapplied  ,price                
from angelfo.nsefo.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                 
) b                   
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber             
--group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code        
        
select trade_no,order_no,party_code,        
brokerage=sum(cd_tot_brok)                        
into #nsefo_opt                                    
from                                     
#fofile a,                                     
angelfo.nsefo.dbo.charges_detail b                                    
where                           
a.trade_no=b.cd_auctionPart+b.CD_trade_no                           
--a.trade_no=b.cd_trade_no                                    
and a.order_no=b.cd_order_no                                    
and a.party_Code=b.cd_party_code                                    
and b.cd_sauda_DATE >=@fdate and b.cd_sauda_Date <= @fdate+' 23:59:59'                                              
group by trade_no,order_no,party_code        
        
update #fofile set Brokerage=b.brokerage from #nsefo_opt b where dbo.get_trade_num(#fofile.trade_no)=b.trade_no        
and #fofile.order_no=b.order_no and #fofile.party_code=b.party_code        
        
insert into ebrokingOfflineTrades_temp                  
select segment='FO', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                  
Party_code,Total_Brok=sum(Brokerage),                  
--MarketValue=sum(MarketRate*tradeqty),                  
Turnover=sum(Turnover)        
from #fofile                  
group by convert(Datetime,convert(varchar(11),sauda_date)),Party_code        
           
                  
----- SP for MCX – 12685                  
insert into ebrokingOfflineTrades_temp                  
select segment='MCX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                  
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),            
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))             
from                  
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='16'                
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59') a,                  
(                  
select Trade_no,               
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                        
from angelcommodity.mcdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                  
) b                   
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber                   
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
                  
----- SP for NCDEX – 00220                  
insert into ebrokingOfflineTrades_temp                  
select segment='NCDEX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                            
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),            
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))             
from                  
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='64'                
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59') a,                  
(                  
select Trade_no,               
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                        
from angelcommodity.ncdx.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                  
) b                   
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber                   
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code                  
        
----- SP for MCXSX – 10500                  
insert into ebrokingOfflineTrades_temp                  
select segment='MCXSX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                  
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),            
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))             
from                  
(select distinct party_Code,BSE_Code,nTradedOrderNumber,nTradeNumber from ebroking_Trades where nmarketsegmentid='1024'                
and dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime <=@fdate+' 23:59:59') a,                  
(                  
select Trade_no,               
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price                        
from angelcommodity.mcdxcds.dbo.fosettlement where sauda_date >=@fdate+' 00:00:00' and sauda_DAte <=@fdate+' 23:59:59'                  
) b                   
where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.nTradeNumber                   
group by convert(Datetime,convert(varchar(11),sauda_date)),b.Party_code

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
-- PROCEDURE dbo.sp_add_exchangesegment
-- --------------------------------------------------

CREATE
PROC 
	sp_add_exchangesegment
	(
		@strExchange varchar(50),
		@strSegment varchar(50),
		@strDisplayValue varchar(25)
	)
as
	set @strExchange = upper(ltrim(rtrim(@strExchange)))
	set @strSegment = upper(ltrim(rtrim(@strSegment)))
	set @strDisplayValue = upper(ltrim(rtrim(@strDisplayValue)))
	
	begin tran

	/* Since exchsegid is autoincreamented it is not inserted here. */

	insert into
		tbl_mst_exchangesegment
		(
			exchange,
			segment,
			displayvalue
		)
		values
		(
			@strExchange,
			@strSegment,
			@strDisplayValue
		)

		if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_add_terminal
-- --------------------------------------------------

CREATE PROCEDURE sp_add_terminal
(
	@strTerminal_ID varchar(25),
	@dtActivationDate varchar(11),
	@dtDeactivationDate varchar(11),
	@nTrade_ID numeric,
	@nExchSegID numeric
)
as
	set @strTerminal_ID = upper(ltrim(rtrim(@strTerminal_ID)))

	Declare
		@ActivationDate datetime,
		@DeactivationDate datetime
		
	if( len(ltrim(rtrim(@dtActivationDate))) > 0 )
	begin
		set @ActivationDate = @dtActivationDate + ' 00:00:00' 
	end

	if( len(ltrim(rtrim(@dtDeactivationDate))) > 0 )
	begin
		set @DeactivationDate = @dtDeactivationDate + ' 23:59:00' 
	end


	begin tran

	insert into
		tbl_mst_terminals
		(
			terminal_id,
			activation_date,
			deactivation_date,
			trade_id,
			exchsegid
		)
		values
		(
			@strTerminal_ID,
			@ActivationDate,
			@DeactivationDate,
			@nTrade_ID,
			@nExchSegID
		)

		if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_add_trade
-- --------------------------------------------------

CREATE
PROC 
	sp_add_trade
	(
		@strTradeType varchar(25)
	)
as
	set @strTradeType = upper(ltrim(rtrim(@strTradeType)))
	
	begin tran

	/* Since trade_id is autoincreamented it is not inserted here. */

	insert into
		tbl_mst_trades
		(
			trade_type
		)
		values
		(
			@strTradeType
		)

		if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_chk_exists_terminal_id
-- --------------------------------------------------

CREATE
proc
	sp_chk_exists_terminal_id
	(
		@strTerminalID varchar(25)
	)

as

	set @strTerminalID = upper(ltrim(rtrim(@strTerminalID)))

	select top 1 
		terminal_id
	from
		tbl_mst_terminals
	where
		terminal_id = @strTerminalID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_delete_exchangesegment
-- --------------------------------------------------

CREATE
PROC
	sp_delete_exchangesegment
	(
		@nExchSegID numeric
	)

as

	begin tran

	delete from
		tbl_mst_exchangesegment
	where
		exchsegid = @nExchSegID

	if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_delete_terminal
-- --------------------------------------------------

CREATE
proc
	sp_delete_terminal
	(
		@strTerminalID varchar(25)
	)

as

	set @strTerminalID = upper(ltrim(rtrim(@strTerminalID)))

	begin tran

	delete from
		tbl_mst_terminals
	where
		terminal_id = @strTerminalID

	if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_delete_trade
-- --------------------------------------------------

CREATE
PROC
	sp_delete_trade
	(
		@nTradeID numeric
	)

as

	begin tran

	delete from
		tbl_mst_trades
	where
		trade_id = @nTradeID

	if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_edit_exchangesegment
-- --------------------------------------------------

CREATE
PROC
	sp_edit_exchangesegment
	(
		@nExchSegID numeric,
		@strNewExchange varchar(50),
		@strNewSegment varchar(50),
		@strNewDisplayValue varchar(25)
	)
as

	set @strNewExchange = upper(ltrim(rtrim(@strNewExchange)))
	set @strNewSegment = upper(ltrim(rtrim(@strNewSegment)))
	set @strNewDisplayValue = upper(ltrim(rtrim(@strNewDisplayValue)))

	begin tran

	update
		tbl_mst_exchangesegment
	set
		exchange = @strNewExchange,
		segment = @strNewSegment,
		displayvalue = @strNewDisplayValue

	where
		exchsegid = @nExchSegID

	if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_edit_terminal
-- --------------------------------------------------

CREATE
PROC
	sp_edit_terminal
	(
		@strTerminalID varchar(25),
		@dtNewActivationDate varchar(11),
		@dtNewDeactivationDate varchar(11),
		@nNewTradeID numeric,
		@nNewExchSegID numeric
	)
as
begin
	set @strTerminalID = upper(ltrim(rtrim(@strTerminalID)))

	Declare
		@ActivationDate datetime,
		@DeactivationDate datetime

	
		
	if( len(ltrim(rtrim(@dtNewActivationDate))) > 0 )
	begin
		set @ActivationDate = @dtNewActivationDate + ' 00:00:00' 
	end

	if( len(ltrim(rtrim(@dtNewDeactivationDate))) > 0 )
	begin
		set @DeactivationDate = @dtNewDeactivationDate + ' 23:59:00' 
	end

	begin tran

	update
		tbl_mst_terminals
	set
		activation_date = @ActivationDate,
		deactivation_date = @DeactivationDate,
		trade_id = @nNewTradeID,
		exchsegid = @nNewExchSegID

	where
		terminal_id = @strTerminalID

	if @@error = 0 commit tran else rollback tran
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_edit_trade
-- --------------------------------------------------

CREATE
PROC
	sp_edit_trade
	(
		@nTradeID numeric,
		@strNewTradeType varchar(25)
	)
as

	set @strNewTradeType = upper(ltrim(rtrim(@strNewTradeType)))

	begin tran

	update
		tbl_mst_trades
	set
		trade_type = @strNewTradeType

	where
		trade_id = @nTradeID

	if @@error = 0 commit tran else rollback tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_list_exchangesegment
-- --------------------------------------------------

CREATE
PROC
	sp_list_exchangesegment

as
	select
		exchsegid as exchsegid,
		upper(ltrim(rtrim(exchange))) as exchange,
		upper(ltrim(rtrim(segment))) as segment,
		upper(ltrim(rtrim(displayvalue))) as displayvalue

	from
		tbl_mst_exchangesegment

	order by
		exchsegid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_list_terminal
-- --------------------------------------------------

CREATE
PROC
	sp_list_terminal

as
	select
		upper(ltrim(rtrim(terminal_id))) as terminal_id,

		activation_date = 
			case when activation_date is null then '&nbsp;'
			else
			convert(varchar, activation_date, 103)
			end,

		deactivation_date = 
			case when deactivation_date is null then '&nbsp;'
			else
			convert(varchar, deactivation_date, 103)
			end,

		upper(ltrim(rtrim(t.trade_id))) as trade_id,
		upper(ltrim(rtrim(tr.trade_type))) as trade_type,
		upper(ltrim(rtrim(t.exchsegid))) as exchsegid,
		upper(ltrim(rtrim(e.displayvalue))) as displayvalue

	from
		tbl_mst_terminals t,
		tbl_mst_exchangesegment e,
		tbl_mst_trades tr
	where
		t.exchsegid = e.exchsegid and
		t.trade_id = tr.trade_id
	order by
		terminal_id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_list_trade
-- --------------------------------------------------

CREATE
PROC
	sp_list_trade

as
	select
		trade_id as trade_id,
		upper(ltrim(rtrim(trade_type))) as trade_type

	from
		tbl_mst_trades

	order by
		trade_id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ebrok_clientwise
-- --------------------------------------------------
CREATE procedure usp_ebrok_clientwise  (@fdate as varchar(11),@tdate as varchar(11),@access_to as varchar(15),@access_code as varchar(15))  
 as  
select segment,sauda_date=convert(varchar(11),convert(datetime,convert(varchar(11),sauda_date)),103),Party_code,Total_Brok,Turnover  
from ebrokingOfflineTrades   
where sauda_date>=convert(datetime,@fdate,103) and sauda_date<=convert(datetime,@tdate,103)  
group by segment,sauda_date,party_code,total_brok,turnover

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Fetch_ebrok_Dealer_trades
-- --------------------------------------------------
CREATE procedure usp_Fetch_ebrok_Dealer_trades(@serverIP as varchar(15),@tdate as varchar(10))
as

--usp_Fetch_ebrok_Dealer_trades '172.31.15.38','07/31/2009'

delete from ebroking_Trades  where dcurrenttime >=@tdate+' 00:00' and dcurrenttime >=@tdate+ ' 23:59' and ServerIP=@serverIP

insert into ebroking_Trades  
select ServerIP=@serverIP,sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber,sBrokerID,nUserID,sAccountCode,
nMarketSegmentId,sRemarks,dCurrentTime,nProductType,b.sDealerId from [172.31.15.38].INTEGRATED_ODIN.dbo.tbl_DailyTrades a, 
(SELECT sDealerCode,sDealerId FROM [172.31.15.38].INTEGRATED_ODIN.dbo.tbl_DealerMaster WHERE sDealerId
not in (select party_Code from intranet.risk.dbo.client_details )) b
where substring(a.sAccountCode,1,charindex('0',a.sAccountCode)-1)=b.sDealerCode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Fetch_ebrok_Dealer_trades_comm
-- --------------------------------------------------
CREATE procedure DBO.usp_Fetch_ebrok_Dealer_trades_comm (@fdate as varchar(11) )                                         
as                                          
                                          
--usp_Fetch_ebrok_Dealer_trades '172.31.15.38','07/31/2009'                                          
DECLARE @server varchar(50),@str as varchar(3000)                   
declare @msg as varchar(200)                                     
set @str=''                                                       
                                    
if @fdate='%'                                                                                                         
BEGIN                                                                                                        
-- declare @fdate as varchar(11)                                                                                                                      
 select @fdate=max(sauda_date) from mis.remisior.dbo.comb_co                                                                                              
--print @fdate                                                                                                                            
END                                           
                                                       
                                          
DECLARE fetch_ebrok_trade_comm CURSOR FOR                                          
                                          
select distinct fld_manager_ip=fld_manager_ip                                     
from mis.genodinlimit.dbo.v_Tbl_Ebrok_Manager_Master where fld_manager_ip not in ('172.31.15.13','172.31.15.51','172.31.15.81','172.31.15.18')                                  
and fld_segment<>'Equity'                                          
                                          
OPEN fetch_ebrok_trade_comm                                           
                                          
                                                                                                
                                                                                                      
FETCH NEXT FROM fetch_ebrok_trade_comm                                                                                                       
INTO @server                                                                                       
                                                                                                      
WHILE @@FETCH_STATUS = 0                                                                                                      
BEGIN                                                                
                                                  
set @str=''                                          
--select * from ebroking_Trades                                          
delete from ebroking_Trades  where dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59' and ServerIP=@server                                          
delete from ebrok_trades_21122010  where dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59' and ServerIP=@server                                                    
  
     begin try                                       
                                         
                                          
/*set @str=' insert into ebroking_Trades select ServerIP='''+@server+''',sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber=cast(nTradedOrderNumber as bigint),sBrokerID,nUserID,sAccountCode,                       
  
    
        
                 
nMarketSegmentId,sRemarks=rtrim(ltrim(substring(sRemarks,1,charindex('' '',sRemarks)-1))),dCurrentTime,nProductType,b.sDealerId,sInstrumentName,nExpiryDate,nStrikePrice,SoptionType from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DailyTradesMR a,               
  
    
      
        
                            
(SELECT sDealerCode,sDealerId FROM ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DealerMaster WHERE sDealerId collate SQL_Latin1_General_CP1_CI_AS                                          
not in (select party_Code from intranet.risk.dbo.client_details )) b                                          
where substring(a.sAccountCode,1,charindex(''0'',a.sAccountCode)-1)=b.sDealerCode'                                    */      
set @str=' insert into ebroking_Trades select distinct ServerIP='''+@server+''',sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber=cast(nTradedOrderNumber as bigint),sBrokerID,nUserID,sAccountCode,                         
  
    
      
                             
nMarketSegmentId,sRemarks=rtrim(ltrim(substring(sRemarks,1,charindex('' '',sRemarks)-1))),dCurrentTime,nProductType,b.sDealerId,sInstrumentName,nExpiryDate,nStrikePrice,SoptionType from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DailyTradesMR a left outer join
  
    
                     
(SELECT sDealerCode,sDealerId FROM ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DealerMaster /*WHERE sDealerId collate SQL_Latin1_General_CP1_CI_AS                                                
not in (select party_Code from intranet.risk.dbo.client_details )*/) b                                 
on substring(a.sAccountCode,1,charindex(''0'',a.sAccountCode)-1)=b.sDealerCode '                                                  
    
set @str=@str + ' insert into ebrok_trades_21122010     
select ServerIP='''+@server+''',*,''S'' from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DailyTradesMR   
update ebrok_trades_21122010 set dealer=b.sDealerId from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DealerMaster b  
 where substring(sAccountCode,1,charindex(''0'',sAccountCode)-1)=sDealerCode collate SQL_Latin1_General_CP1_CI_AS  
 '    
--insert into ebroking_Trades              
--print @str                                           
exec(@str)                            
end try                            
begin catch                            
                
set @msg='Process failed on server '+@server+'. Error Message : '+ERROR_MESSAGE()                      
EXEC mis.master.dbo.xp_smtp_sendmail                            
   @TO = 'Shweta.tiwari@angeltrade.com;Rozinar.Raje@angeltrade.com',                             
   @from = 'Soft@angeltrade.com',                             
   @subject = 'e-broking offline trades commodity',                             
   @server = 'angelmail.angelbroking.com',                            
   @message=@msg                       
end catch                                       
  FETCH NEXT FROM fetch_ebrok_trade_comm                                                                                                       
  INTO @server                                                      
                                                                                                      
END                                                                             
                                                                       
CLOSE fetch_ebrok_trade_comm                                       
DEALLOCATE fetch_ebrok_trade_comm                   
                
/*begin try                                     
                                    
 insert into ebroking_Trades select ServerIP='172.31.15.20',sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber,sBrokerID,nUserID,sAccountCode,                                           
 nMarketSegmentId,sRemarks,dCurrentTime,nProductType,b.sDealerId,sInstrumentName,nExpiryDate,nStrikePrice,SoptionType from [172.31.15.96].INTEGRATED_ODIN.dbo.tbl_DailyTradesMR a,                                                         
 (SELECT sDealerCode,sDealerId FROM [172.31.15.96].INTEGRATED_ODIN.dbo.tbl_DealerMaster WHERE sDealerId collate SQL_Latin1_General_CP1_CI_AS                                                        
 not in (select party_Code from intranet.risk.dbo.client_details )) b               
 where substring(a.sAccountCode,1,charindex('0',a.sAccountCode)-1)=b.sDealerCode                 
                      
end try                   
begin catch                            
 set @msg='Process failed on server 172.31.15.20. Error Message : '+ERROR_MESSAGE()                      
 EXEC mis.master.dbo.xp_smtp_sendmail                            
    @TO = 'Shweta.tiwari@angeltrade.com;Rozinar.Raje@angeltrade.com;',                             
    @from = 'Soft@angeltrade.com',                             
    @subject = 'e-broking offline trades commodity',                             
    @server = 'angelmail.angelbroking.com',                            
    @message=@msg                       
end catch                 
                
begin try                         
                
  insert into ebroking_Trades select ServerIP='172.31.15.15',sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber,sBrokerID,nUserID,sAccountCode,                                           
 nMarketSegmentId,sRemarks,dCurrentTime,nProductType,b.sDealerId,sInstrumentName,nExpiryDate,nStrikePrice,SoptionType from [172.31.15.96].INTEGRATED15.dbo.tbl_DailyTradesMR a,                                                         
 (SELECT sDealerCode,sDealerId FROM [172.31.15.96].INTEGRATED15.dbo.tbl_DealerMaster WHERE sDealerId collate SQL_Latin1_General_CP1_CI_AS                                                        
 not in (select party_Code from intranet.risk.dbo.client_details )) b                                                        
 where substring(a.sAccountCode,1,charindex('0',a.sAccountCode)-1)=b.sDealerCode                 
end try                  
begin catch                            
 set @msg='Process failed on server 172.31.15.15. Error Message : '+ERROR_MESSAGE()                      
 EXEC mis.master.dbo.xp_smtp_sendmail                            
    @TO = 'Shweta.tiwari@angeltrade.com;Rozinar.Raje@angeltrade.com',                             
    @from = 'Soft@angeltrade.com',                             
    @subject = 'e-broking offline trades commodity',                             
    @server = 'angelmail.angelbroking.com',                            
    @message=@msg                       
end catch                 
  */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Fetch_ebrok_Dealer_trades_equity
-- --------------------------------------------------
CREATE procedure DBO.usp_Fetch_ebrok_Dealer_trades_equity (@fdate as varchar(11) )                                                   
as                                                    
                                                    
--usp_Fetch_ebrok_Dealer_trades '172.31.15.38','07/31/2009'                                                    
DECLARE @server varchar(50),@str as varchar(3000)           
declare @msg as varchar(200)                                                 
set @str=''                    
                                                               
 --declare @fdate as varchar(11)                                               
if @fdate='%'                                                                                                                   
BEGIN                                                                                                                  
                                                                                                                            
select @fdate=max(sauda_date)+1 from mis.remisior.dbo.comb_co                                           
                                                                                                    
--print @fdate                                                                                                                                      
END                                                     
                                                                 
                                                    
DECLARE fetch_ebrok_trade_equity CURSOR FOR                                                    
                                                    
select distinct fld_manager_ip=fld_manager_ip                                               
from mis.genodinlimit.dbo.v_Tbl_Ebrok_Manager_Master                           
where fld_manager_ip not in ('172.31.15.65','172.31.15.13','172.31.15.51','172.31.15.18','172.31.15.35','172.31.15.41','172.31.15.32','172.31.15.16','172.31.15.28')                                            
and fld_segment='Equity'                   
          
select  * from mis.genodinlimit.dbo.v_Tbl_Ebrok_Manager_Master              
--union                       
--select '172.31.15.96'                                                  
                                                    
OPEN fetch_ebrok_trade_equity                                                     
                                                    
                                                                                                          
                                                                                                                
FETCH NEXT FROM fetch_ebrok_trade_equity                                                                                                                 
INTO @server                                                                                                 
                                                                                                                
WHILE @@FETCH_STATUS = 0                                                                                                                
BEGIN                                                                          
                                                            
set @str=''                   
          
begin try                                                   
delete from ebroking_Trades  where dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59' and ServerIP=@server                                                    
delete from ebrok_trades_21122010  where dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59' and ServerIP=@server                                                    
                                                     
                                                    
set @str=' insert into ebroking_Trades select distinct ServerIP='''+@server+''',sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber=cast(nTradedOrderNumber as bigint),sBrokerID,nUserID,sAccountCode,                         
  
    
                           
nMarketSegmentId,sRemarks=rtrim(ltrim(substring(sRemarks,1,charindex('' '',sRemarks)-1))),dCurrentTime,nProductType,b.sDealerId,sInstrumentName,nExpiryDate,nStrikePrice,SoptionType from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DailyTradesMR a left outer join
  
                   
(SELECT sDealerCode,sDealerId FROM ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DealerMaster /*WHERE sDealerId collate SQL_Latin1_General_CP1_CI_AS                                              
not in (select party_Code from intranet.risk.dbo.client_details )*/) b                               
on substring(a.sAccountCode,1,charindex(''0'',a.sAccountCode)-1)=b.sDealerCode   
'                                                
set @str=@str + ' insert into ebrok_trades_21122010     
select ServerIP='''+@server+''',*,''S'' from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DailyTradesMR   
update ebrok_trades_21122010 set dealer=b.sDealerId from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DealerMaster b  
where substring(sAccountCode,1,charindex(''0'',sAccountCode)-1)=sDealerCode collate SQL_Latin1_General_CP1_CI_AS  
 '    
          
                          
end try                      
begin catch                      
          
 set @msg='Process failed on server '+@server+'. Error Message : '+ERROR_MESSAGE()                
 EXEC mis.master.dbo.xp_smtp_sendmail                      
    @TO = 'Shweta.tiwari@angeltrade.com;Rozinar.Raje@angeltrade.com',                       
    @from = 'Soft@angeltrade.com',                       
    @subject = 'e-broking offline trades Equity',                       
    @server = 'angelmail.angelbroking.com',                      
    @message=@msg                 
end catch                     
--print (@str)                                                                 
exec(@str)                                                
  FETCH NEXT FROM fetch_ebrok_trade_equity                                                                                         
  INTO @server                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Fetch_ebrok_Dealer_trades1
-- --------------------------------------------------

CREATE procedure DBO.usp_Fetch_ebrok_Dealer_trades1 (@fdate as varchar(11) )     
as      
      
--usp_Fetch_ebrok_Dealer_trades '172.31.15.38','07/31/2009'      
DECLARE @server varchar(50),@str as varchar(3000) 
set @str=''                   

if @fdate='%'                                                                     
BEGIN                                                                    
 --declare @fdate as varchar(11)                                                                                  
 select @fdate=max(sauda_date) from mis.remisior.dbo.comb_co                                                          
--print @fdate                                                                                        
END       
                   
      
DECLARE fetch_ebrok_trade CURSOR FOR      
      
select distinct fld_manager_ip=fld_manager_ip  
from mis.genodinlimit.dbo.v_Tbl_Ebrok_Manager_Master where fld_manager_ip not in ('172.31.15.13','172.31.15.51')      
      
OPEN fetch_ebrok_trade       
      
                                                            
                                                                  
FETCH NEXT FROM fetch_ebrok_trade                                                                   
INTO @server                                                   
                                                                  
WHILE @@FETCH_STATUS = 0                                                                  
BEGIN                            
              
set @str=''      
--select * from ebroking_Trades      
delete from ebroking_Trades  where dcurrenttime >=@fdate+' 00:00:00' and dcurrenttime >=@fdate+ ' 23:59:59' and ServerIP=@server      
       
      
set @str=' insert into ebroking_Trades select ServerIP='''+@server+''',sSymbol,nTokenNumber,nQuantityTraded,nTradedPrice,nTradeNumber,nBuyOrSell,nTradedOrderNumber,sBrokerID,nUserID,sAccountCode,      
nMarketSegmentId,sRemarks,dCurrentTime,nProductType,b.sDealerId from ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DailyTrades a,       
(SELECT sDealerCode,sDealerId FROM ['+@server+'].INTEGRATED_ODIN.dbo.tbl_DealerMaster WHERE sDealerId collate SQL_Latin1_General_CP1_CI_AS      
not in (select party_Code from intranet.risk.dbo.client_details )) b      
where substring(a.sAccountCode,1,charindex(''0'',a.sAccountCode)-1)=b.sDealerCode'      
--insert into ebroking_Trades        
exec(@str)      
      
  FETCH NEXT FROM fetch_ebrok_trade                                                                   
  INTO @server                                           
                                                                  
END                                         
                                                    
CLOSE fetch_ebrok_trade                                                      
DEALLOCATE fetch_ebrok_trade

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------

CREATE PROCEDURE usp_findInUSP          
@dbname varchar(500),        
@srcstr varchar(500)          
AS          
          
 set nocount on        
 set @srcstr  = '%' + @srcstr + '%'          
        
 declare @str as varchar(1000)        
 set @str=''        
 if @dbname <>''        
 Begin        
 set @dbname=@dbname+'.dbo.'        
 End        
 else        
 begin        
 set @dbname=db_name()+'.dbo.'        
 End        
 print @dbname        
        
 set @str='select distinct O.name,O.xtype from '+@dbname+'sysComments  C '         
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id '         
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''          
 print @str        
  exec(@str)        
set nocount off

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
-- TABLE dbo.aa
-- --------------------------------------------------
CREATE TABLE [dbo].[aa]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NOT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NOT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] CHAR(12) NULL,
    [sClearingMemberId] VARCHAR(12) NULL,
    [sCPClearingMemberId] VARCHAR(12) NULL,
    [sRemarks] VARCHAR(25) NULL,
    [sUserRemarks] VARCHAR(25) NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.E05913ebrokingOfflineTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[E05913ebrokingOfflineTrades]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrok_trades_21122010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrok_trades_21122010]
(
    [ServerIP] VARCHAR(12) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NOT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NOT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] CHAR(12) NULL,
    [sClearingMemberId] VARCHAR(12) NULL,
    [sCPClearingMemberId] VARCHAR(12) NULL,
    [sRemarks] VARCHAR(25) NULL,
    [sUserRemarks] VARCHAR(25) NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL,
    [nPreMarket] TINYINT NULL,
    [dealer] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebroking_Trades
-- --------------------------------------------------
CREATE TABLE [dbo].[ebroking_Trades]
(
    [ServerIP] VARCHAR(15) NULL,
    [sSymbol] VARCHAR(50) NULL,
    [BSE_Code] VARCHAR(50) NULL,
    [nQuantityTraded] INT NULL,
    [nTradedPrice] MONEY NULL,
    [nTradeNumber] VARCHAR(35) NULL,
    [nBuyOrSell] VARCHAR(5) NULL,
    [nTradedOrderNumber] VARCHAR(50) NULL,
    [sBrokerID] VARCHAR(15) NULL,
    [nUserID] VARCHAR(15) NULL,
    [sAccountCode] VARCHAR(15) NULL,
    [nMarketSegmentId] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(50) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] VARCHAR(30) NULL,
    [sDealerId] VARCHAR(15) NULL,
    [sInstrumentName] VARCHAR(60) NULL,
    [nExpiryDate] VARCHAR(60) NULL,
    [nStrikePrice] MONEY NULL,
    [SoptionType] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_02032010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_02032010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_02122010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_02122010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_03032010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_03032010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_15022010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_15022010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_3122010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_3122010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_9122010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_9122010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_Oct14_30_2010
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_Oct14_30_2010]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_temp]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_temp_adj
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_temp_adj]
(
    [segment] VARCHAR(5) NULL,
    [sauda_date] DATETIME NULL,
    [party_code] VARCHAR(10) NULL,
    [turonover] NUMERIC(38, 4) NULL,
    [total_brok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTrades_terminal
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTrades_terminal]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL,
    [terminal_Id] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrokingOfflineTradestest
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrokingOfflineTradestest]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL,
    [terminalid] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Oct142010
-- --------------------------------------------------
CREATE TABLE [dbo].[Oct142010]
(
    [ServerIP] VARCHAR(15) NULL,
    [sSymbol] VARCHAR(50) NULL,
    [BSE_Code] VARCHAR(50) NULL,
    [nQuantityTraded] INT NULL,
    [nTradedPrice] MONEY NULL,
    [nTradeNumber] VARCHAR(35) NULL,
    [nBuyOrSell] VARCHAR(5) NULL,
    [nTradedOrderNumber] VARCHAR(50) NULL,
    [sBrokerID] VARCHAR(15) NULL,
    [nUserID] VARCHAR(15) NULL,
    [sAccountCode] VARCHAR(15) NULL,
    [nMarketSegmentId] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(50) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] VARCHAR(30) NULL,
    [sDealerId] VARCHAR(15) NULL,
    [sInstrumentName] VARCHAR(60) NULL,
    [nExpiryDate] VARCHAR(60) NULL,
    [nStrikePrice] MONEY NULL,
    [SoptionType] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ebrok_detail_cli
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ebrok_detail_cli]
(
    [segment] VARCHAR(10) NULL,
    [branch] VARCHAR(10) NULL,
    [sub_Broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [sauda_date] DATETIME NULL,
    [Overall_turnover] MONEY NOT NULL,
    [ebrok_Turnover] MONEY NOT NULL,
    [TO_percent] MONEY NOT NULL,
    [Overall_brok_earned] MONEY NOT NULL,
    [Overall_Angel_share] MONEY NOT NULL,
    [Overall_percent] MONEY NOT NULL,
    [ebrok_brok_earned] MONEY NOT NULL,
    [ebrok_Angel_share] MONEY NOT NULL,
    [ebrok_percent] MONEY NOT NULL,
    [b2c_overall_turnover] MONEY NOT NULL,
    [b2c_overall_brok_earned] MONEY NOT NULL,
    [b2c_overall_angel_share] MONEY NOT NULL,
    [b2c_ebrok_turnover] MONEY NOT NULL,
    [b2c_ebrok_brok_earned] MONEY NOT NULL,
    [b2c_ebrok_angel_share] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_10
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_10]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_15
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_15]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_16
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_16]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_18
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_18]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_20
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_20]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_24
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_24]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_28
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_28]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_30
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_30]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_32
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_32]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_34
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_34]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_35
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_35]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_38
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_38]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades_172_31_15_41
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades_172_31_15_41]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(13) NOT NULL,
    [sSeries] CHAR(3) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] INT NULL,
    [sAccountCode] CHAR(13) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] INT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(13) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBSEServerOrderNo] VARCHAR(20) NULL,
    [cRiskReducing] CHAR(1) NULL,
    [sCPParticipant] VARCHAR(12) NOT NULL,
    [sClearingMemberId] VARCHAR(12) NOT NULL,
    [sCPClearingMemberId] VARCHAR(12) NOT NULL,
    [sRemarks] VARCHAR(25) NOT NULL,
    [sUserRemarks] VARCHAR(25) NOT NULL,
    [sExchangeReplyText] VARCHAR(128) NULL,
    [dCurrentTime] DATETIME NULL,
    [nProductType] INT NULL,
    [sAmoID] VARCHAR(20) NULL,
    [sGroupAdminCode] VARCHAR(6) NULL,
    [nLegIndicator] SMALLINT NULL,
    [nFirstLegPrice] INT NULL,
    [nSecondLegPrice] INT NULL,
    [nSequenceNumber] INT NULL,
    [nOrderSequenceNumber] INT NULL,
    [sExchangeAccountCode] VARCHAR(13) NOT NULL,
    [nOMSId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mst_ExchangeSegment
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mst_ExchangeSegment]
(
    [ExchSegID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Exchange] VARCHAR(50) NULL,
    [Segment] VARCHAR(50) NULL,
    [DisplayValue] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mst_Terminals
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mst_Terminals]
(
    [Terminal_Id] VARCHAR(50) NOT NULL,
    [Activation_Date] DATETIME NULL,
    [DeActivation_Date] DATETIME NULL,
    [Trade_ID] NUMERIC(18, 0) NULL,
    [ExchSegID] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mst_Terminals_21032007
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mst_Terminals_21032007]
(
    [Terminal_Id] VARCHAR(50) NOT NULL,
    [Activation_Date] DATETIME NULL,
    [DeActivation_Date] DATETIME NULL,
    [Trade_ID] NUMERIC(18, 0) NULL,
    [ExchSegID] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mst_Trades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mst_Trades]
(
    [Trade_ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Trade_Type] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [term] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ebrokingOfflineTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ebrokingOfflineTrades]
(
    [segment] VARCHAR(5) NOT NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] NUMERIC(38, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_t
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_t]
(
    [term] NUMERIC(18, 0) NULL
);

GO

