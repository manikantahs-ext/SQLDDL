-- DDL Export
-- Server: 10.253.33.93
-- Database: Dustbin
-- Exported: 2026-02-05T02:40:13.320037

USE Dustbin;
GO

-- --------------------------------------------------
-- INDEX dbo.Brokchangenew
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_code] ON [dbo].[Brokchangenew] ([partycode])

GO

-- --------------------------------------------------
-- INDEX dbo.FNO_PNL_RCS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [PARTYCODE] ON [dbo].[FNO_PNL_RCS] ([cltcode])

GO

-- --------------------------------------------------
-- INDEX dbo.Omnesys_order
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party] ON [dbo].[Omnesys_order] ([party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.PNLFO_EXCh
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Party_year] ON [dbo].[PNLFO_EXCh] ([Party_code], [Finyear], [inst_type]) INCLUDE ([PNL], [Brokerage], [turn_tax], [Stamp_Duty], [sebi_tax], [STT], [GST])

GO

-- --------------------------------------------------
-- INDEX dbo.rcs_del_2223
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Party] ON [dbo].[rcs_del_2223] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.rcs_Eq_del2122
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Party] ON [dbo].[rcs_Eq_del2122] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.RCS_OMN_WORKING
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party] ON [dbo].[RCS_OMN_WORKING] ([party_code], [Order_no])

GO

-- --------------------------------------------------
-- INDEX dbo.rcs_pnl_optopn_mis
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_party] ON [dbo].[rcs_pnl_optopn_mis] ([party_code], [Finyear], [Inst_type])

GO

-- --------------------------------------------------
-- INDEX dbo.rcs_SPI_client_list
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [a] ON [dbo].[rcs_SPI_client_list] ([Party_Code])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_Noncash_coll
-- --------------------------------------------------
CREATE  proc NCMS_Noncash_coll
as
Begin
  select distinct party_code into #PO_client from  INTRANET.cms.dbo.NCMS_PO_Request_ForPayout with(nolock)   

    select a.* into #NewcollNSEFO from msajag.dbo.CollateralDetails a WITH (NOLOCK)     
   where exchange='NSE' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK)       
   where effDate <= getdate() and exchange='NSE' and segment='FUTURES')   

   
select a.*, case when haircut<20 then 20.00 else haircut end Var_margin,CONVERT(MONEY, 0) as Value_BHC,      
CONVERT(MONEY, 0) as Value_AHC      
into #we  from #NewcollNSEFO a  

 
update #we set Value_BHC=  qty*cl_rate      
update #we set Value_AHC=isnull(Value_BHC,0)-(isnull(Value_BHC,0)*isnull(Var_Margin,0)/100)     
 

select a.party_code, sum(Value_AHC) noncash into #qq from #we a ,#PO_client p           
 where  a.party_code=p.party_code  group by a.party_code  

 
--truncate table tbl_NCMS_Coll    
    
insert into inhouse.dbo.tbl_NCMS_Coll    
select party_code,0,sum(noncash) from #qq group by party_code    
 
 
 --select a.* into #NCMS_Colleteralq from NCMS_Colleteral a,#PO_client p   where a.party_Code=p.party_code   

 --select a.party_code,a.noncashcoll as CurrentNonCash,b.noncash as NewNonCash from #NCMS_Colleteralq a join #qq b on a.party_Code
 --=b.party_code

 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.POP_CONTRACTDATA_bkp_23march2024_SRE-23891
-- --------------------------------------------------


--Exec POP_CONTRACTDATA 'Dec 22 2020', 'e73799'

CREATE PROC [dbo].[POP_CONTRACTDATA_bkp_23march2024_SRE-23891]          
(            
 @SAUDA_DATE VARCHAR(11),          
 @USERNAME VARCHAR(11)=''          
)          
          
AS             
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
          
/* ------------------------------------------------------------------------          
      REMOVING THE EXISTING RECORDS          
---------------------------------------------------------------------------*/          
          
DELETE CONTRACT_MASTER           
WHERE          
 TRADE_DATE >= @SAUDA_DATE AND           
 TRADE_DATE <= @SAUDA_DATE +' 23:59'          
          
DELETE CONTRACT_DATA          
WHERE          
 SAUDA_DATE >= @SAUDA_DATE AND           
 SAUDA_DATE <= @SAUDA_DATE +' 23:59'          
          
DELETE CONTRACT_DATA_DET          
WHERE          
 SAUDA_DATE >= @SAUDA_DATE AND           
 SAUDA_DATE <= @SAUDA_DATE +' 23:59'          
          
/* ------------------------------------------------------------------------          
     TAKING FILTERD TRADES TO TEMPORARY TABLE          
---------------------------------------------------------------------------*/          
          
CREATE TABLE #FOSETTLEMENT          
(          
 CONTRACTNO VARCHAR(14),          
 ORDER_NO VARCHAR(16),          
 CPID VARCHAR(15),          
 TRADE_NO VARCHAR(15),          
 SAUDA_DATE DATETIME,          
 PARTY_CODE VARCHAR(10),          
 INST_TYPE VARCHAR(6),          
 SYMBOL VARCHAR(12),          
 EXPIRYDATE DATETIME,          
 STRIKE_PRICE MONEY,          
 OPTION_TYPE VARCHAR(2),          
 AUCTIONPART VARCHAR(2),          
 SELL_BUY INT,          
 TRADEQTY NUMERIC(36,0),          
 PRICE NUMERIC (36,12),          
 BROKAPPLIED NUMERIC (36,12),          
 NETRATE NUMERIC (36,12),          
 AMOUNT NUMERIC (36,12),          
 SERVICE_TAX NUMERIC (36,12),          
 BROKER_CHRG NUMERIC (36,12),          
 TURN_TAX NUMERIC (36,12),          
 SEBI_TAX NUMERIC (36,12),          
 OTHER_CHRG NUMERIC (36,12),          
 INS_CHRG NUMERIC (36,12),          
 ORDFLG INT          
)          
          
SELECT * INTO #FOSETTLEMENT_1 FROM #FOSETTLEMENT          
          
CREATE INDEX [IDXPARTY] ON [DBO].[#FOSETTLEMENT_1] ([PARTY_CODE])             
          
INSERT INTO #FOSETTLEMENT          
SELECT           
 CONTRACTNO,ORDER_NO,CPID,TRADE_NO,SAUDA_DATE,PARTY_CODE,          
 INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,          
 SELL_BUY,TRADEQTY,PRICE,BROKAPPLIED,NETRATE,AMOUNT,          
 SERVICE_TAX,BROKER_CHRG,TURN_TAX,SEBI_TAX,OTHER_CHRG,          
 INS_CHRG,ORDFLAG=1          
FROM FOSETTLEMENT                           
WHERE           
 SAUDA_DATE >= @SAUDA_DATE AND           
 SAUDA_DATE <= @SAUDA_DATE +' 23:59' AND           
 AUCTIONPART <> 'CA' AND          
 TRADEQTY > 0  AND           
 PRICE > 0           
          
UPDATE #FOSETTLEMENT SET TRADE_NO = PRADNYA.DBO.REPLACETRADENO(TRADE_NO)           
WHERE UPPER(LEFT(TRADE_NO,1)) BETWEEN 'A' AND 'Z'           
          
UPDATE #FOSETTLEMENT SET CPID = (CASE WHEN CPID = 'NIL' OR CPID   = '0' THEN '' ELSE RIGHT(CPID,8) END)          
        
        
INSERT INTO #FOSETTLEMENT_1          
SELECT           
 CONTRACTNO,ORDER_NO,CPID ,TRADE_NO,SAUDA_DATE,          
 PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,          
 OPTION_TYPE,AUCTIONPART,SELL_BUY,          
 TRADEQTY = SUM(TRADEQTY),          
 PRICE = SUM(TRADEQTY*PRICE)/ SUM(TRADEQTY),          
 BROKAPPLIED = SUM(BROKAPPLIED*TRADEQTY),          
 NETRATE= SUM(NETRATE*TRADEQTY)/ SUM(TRADEQTY),          
 AMOUNT = SUM(AMOUNT),          
 SERVICE_TAX = SUM(SERVICE_TAX),          
 BROKER_CHRG = SUM(BROKER_CHRG),          
 TURN_TAX = SUM(TURN_TAX),          
 SEBI_TAX = SUM(SEBI_TAX),          
 OTHER_CHRG = SUM(OTHER_CHRG),          
 INS_CHRG = SUM(INS_CHRG),          
 ORDFLAG=1          
FROM  #FOSETTLEMENT          
GROUP BY          
 CONTRACTNO,          
 ORDER_NO,          
 CPID,          
 TRADE_NO,          
 SAUDA_DATE,          
 PARTY_CODE,          
 INST_TYPE,          
 SYMBOL,          
 EXPIRYDATE,          
 STRIKE_PRICE,          
 OPTION_TYPE,          
 AUCTIONPART,          
 SELL_BUY          
          
/* ------------------------------------------------------------------------          
        VBB UPDATE          
---------------------------------------------------------------------------*/ 

SELECT * INTO #CHARGES_DETAIL FROM CHARGES_DETAIL
WHERE CD_SAUDA_DATE >= @SAUDA_DATE AND           
 CD_SAUDA_DATE <= @SAUDA_DATE +' 23:59'

CREATE INDEX [IDXPARTY] ON [DBO].[#CHARGES_DETAIL] ([CD_PARTY_CODE]) 

SELECT * INTO #CLIENT2 FROM CLIENT2
WHERE EXISTS (SELECT Party_code FROM #FOSETTLEMENT_1 WHERE #FOSETTLEMENT_1.PARTY_CODE = CLIENT2.Cl_Code)

INSERT INTO #CLIENT2 
SELECT DISTINCT C.* FROM CLIENT2 C, #CLIENT2 C2
WHERE C.CL_CODE = C2.PARENTCODE 
AND C.CL_CODE NOT IN (SELECT CL_CODE FROM #CLIENT2 WHERE C.CL_CODE = #CLIENT2.CL_CODE)

CREATE INDEX [IDXPARTY] ON [DBO].[#CLIENT2] ([CL_CODE]) 

SELECT * INTO #CLIENT1 FROM CLIENT1
WHERE EXISTS (SELECT cl_code FROM #CLIENT2 WHERE #CLIENT2.Cl_Code = CLIENT1.Cl_Code)

CREATE INDEX [IDXPARTY] ON [DBO].[#CLIENT1] ([CL_CODE]) 
                
UPDATE             
 #FOSETTLEMENT_1            
SET            
 BROKAPPLIED = CASE WHEN SELL_BUY =1 THEN CD_TOT_BUYBROK ELSE CD_TOT_SELLBROK END            
     + (CASE WHEN SERVICE_CHRG = 1 THEN       
     CASE WHEN SELL_BUY =1 THEN CD_TOT_BUYSERTAX ELSE CD_TOT_SELLSERTAX END            
     ELSE 0 END),            
 SERVICE_TAX = SERVICE_TAX + (CASE WHEN SERVICE_CHRG = 0 THEN             
      CASE WHEN SELL_BUY =1 THEN CD_TOT_BUYSERTAX ELSE CD_TOT_SELLSERTAX END           
      ELSE 0 END)          
FROM            
 #CHARGES_DETAIL, #CLIENT2          
WHERE            
 #CLIENT2.CL_CODE = #FOSETTLEMENT_1.PARTY_CODE          
 AND CONVERT(VARCHAR,CD_SAUDA_DATE,103) = CONVERT(VARCHAR,SAUDA_DATE,103)            
 AND CD_PARTY_CODE = #FOSETTLEMENT_1.PARTY_CODE             
 AND CD_INST_TYPE = INST_TYPE          
 AND CD_SYMBOL = SYMBOL            
 AND CONVERT(VARCHAR,CD_EXPIRY_DATE,106) = CONVERT(VARCHAR,EXPIRYDATE,106)            
 AND CD_OPTION_TYPE = OPTION_TYPE            
 AND CD_STRIKE_PRICE = STRIKE_PRICE            
 AND CD_TRADE_NO = TRADE_NO            
 AND CD_ORDER_NO = ORDER_NO            
        
        
INSERT INTO #FOSETTLEMENT_1          
SELECT            
 CD_CONTRACT_NO,          
 CD_ORDER_NO,             
 CPID = '00:00:00',             
 CD_TRADE_NO,             
 --CONVERT(VARCHAR,CD_SAUDA_DATE,103) AS SAUDA_DATE,        
 CD_SAUDA_DATE,        
 CD_PARTY_CODE,            
 CD_INST_TYPE,             
 CD_SYMBOL= (CASE WHEN CD_SYMBOL = '' THEN 'CONT BROK' ELSE CD_SYMBOL END),             
 EXPIRYDATE = (CASE WHEN CD_SYMBOL = '' THEN '' ELSE           
      CONVERT(DATETIME,(LEFT(CONVERT(VARCHAR,CD_EXPIRY_DATE,106),11))) END),        
 --EXPIRYDATE = CD_EXPIRY_DATE,            
 STRIKE_PRICE = ISNULL(CD_STRIKE_PRICE,0),             
 CD_OPTION_TYPE,          
 CD_AUCTIONPART,          
 SELL_BUY = CASE WHEN CD_TOT_BUYBROK > 0 THEN 1 ELSE 2 END,          
 TRADEQTY = 0,          
 PRICE = 0,          
 BROKAPPLIED = CD_TOT_BUYBROK + CD_TOT_SELLBROK          
     + (CASE WHEN SERVICE_CHRG = 1 THEN             
     CD_TOT_BUYSERTAX + CD_TOT_SELLSERTAX  ELSE 0 END),          
 NETRATE= CD_TOT_BUYBROK + CD_TOT_SELLBROK,          
 AMOUNT = 0,          
 SERVICE_TAX = (CASE WHEN SERVICE_CHRG = 0 THEN             
     CD_TOT_BUYSERTAX + CD_TOT_SELLSERTAX  ELSE 0 END),          
 BROKER_CHRG = 0,          
 TURN_TAX = 0,          
 SEBI_TAX = 0,          
 OTHER_CHRG = 0,          
 INS_CHRG = 0,          
 ORDFLG = (CASE WHEN CD_ORDER_NO <> '' THEN 1            
    WHEN CD_SYMBOL <> '' THEN 2            
    ELSE 3 END)            
FROM          
 #CHARGES_DETAIL F, #CLIENT2          
WHERE          
 CL_CODE = CD_PARTY_CODE          
 AND CD_SAUDA_DATE >= @SAUDA_DATE          
 AND CD_SAUDA_DATE <= @SAUDA_DATE + ' 23:59:59'          
 AND CD_TRADE_NO = ''            
 AND CD_TOT_BUYBROK + CD_TOT_SELLBROK > 0              
        
        
/* PARENTCODE LEVEL UPDATE */      
      
UPDATE #FOSETTLEMENT_1 SET PARTY_CODE = PARENTCODE      
FROM CLIENT2_VIEW       
WHERE #FOSETTLEMENT_1.PARTY_CODE = CLIENT2_VIEW.PARTY_CODE      
      
/* PARENTCODE LEVEL UPDATE */      
          
/* ------------------------------------------------------------------------          
     TAKING FILTERD CLIENT DETAILS TO TEMPORARY TABLE          
---------------------------------------------------------------------------*/          
INSERT INTO  CONTRACT_MASTER          
SELECT            
 @SAUDA_DATE,          
 C2.PARTY_CODE,             
 C1.LONG_NAME,             
 C1.L_ADDRESS1,             
 C1.L_ADDRESS2,             
 C1.L_ADDRESS3,     
 C1.L_CITY,             
 C1.L_STATE,             
 C1.L_ZIP,             
 C1.BRANCH_CD ,             
 C1.SUB_BROKER,             
 C1.TRADER,            
 C1.AREA,            
 C1.REGION,            
 C1.FAMILY,             
 C1.PAN_GIR_NO,             
 C1.OFF_PHONE1,             
 OFF_PHONE2 = Mobile_Pager,             
 PRINTF,             
 MAPIDID,             
 UCC_CODE,            
 C2.SERVICE_CHRG,             
 BROKERNOTE,             
 TURNOVER_TAX,             
 SEBI_TURN_TAX,             
 C2.OTHER_CHRG,             
 INSURANCE_CHRG,            
 SEBI_NO = FD_CODE            
FROM    #CLIENT1 C1             
WITH             
        (             
                NOLOCK             
        )             
        ,             
        #CLIENT2 C2             
WITH             
        (             
                NOLOCK             
        )             
LEFT OUTER JOIN UCC_CLIENT UC             
WITH             
        (             
                NOLOCK             
        )             
        ON C2.Cl_Code = UC.PARTY_CODE             
WHERE   C2.CL_CODE       = C1.CL_CODE
          
          
/* ------------------------------------------------------------------------          
   TAKING CONTRACT DATA TO THE FINAL TEMP TABLE (NON SUMMARISED)          
---------------------------------------------------------------------------*/          
          
INSERT INTO CONTRACT_DATA          
SELECT            
        CONTRACTNO,             
  ORDER_NO,             
        ORDER_TIME=CPID,             
        TRADE_NO,             
        LEFT(CONVERT(VARCHAR,SAUDA_DATE,108),11) AS TRADETIME,             
        @SAUDA_DATE,             
        F.PARTY_CODE,             
        INST_TYPE,             
       SYMBOL,             
        LEFT(CONVERT(VARCHAR,EXPIRYDATE,106),11) AS EXPIRYDATE,             
        ISNULL(STRIKE_PRICE,0) STRIKE_PRICE,           
        OPTION_TYPE,             
   AUCTIONPART,           
        PQTY = (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN TRADEQTY             
                ELSE 0 END),             
        SQTY = (             
        CASE             
                WHEN SELL_BUY = 2             
                THEN TRADEQTY             
                ELSE 0 END),             
        PRATE = (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN ISNULL(PRICE,0)             
                ELSE 0 END),             
        SRATE = (             
   CASE             
                WHEN SELL_BUY = 2             
                THEN ISNULL(PRICE,0)             
                ELSE 0 END),             
        PBROK =(             
        CASE             
                WHEN SELL_BUY = 1             
                THEN ISNULL((BROKAPPLIED /(CASE WHEN TRADEQTY > 0 THEN TRADEQTY ELSE 1 END) + (             
                CASE             
                        WHEN C.SERVICE_CHRG=1 AND TRADEQTY > 0             
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)             
                        ELSE 0 END )),0)             
                ELSE 0 END),             
        SBROK =(             
        CASE             
                WHEN SELL_BUY = 2             
                THEN ISNULL((BROKAPPLIED / (CASE WHEN TRADEQTY > 0 THEN TRADEQTY ELSE 1 END)+ (             
                CASE             
         WHEN C.SERVICE_CHRG=1 AND TRADEQTY > 0             
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)             
                        ELSE 0 END )),0)             
                ELSE 0 END),             
        PNETRATE = (             
        CASE             
                WHEN SELL_BUY =1             
                THEN ISNULL(NETRATE + (             
                CASE             
      WHEN C.SERVICE_CHRG = 1 AND TRADEQTY > 0            
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)             
                        ELSE 0 END),0)             
                ELSE 0 END),             
        SNETRATE = (             
        CASE             
                WHEN SELL_BUY =2             
                THEN ISNULL(NETRATE - (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1 AND TRADEQTY > 0         
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)             
                        ELSE 0 END),0)             
                ELSE 0 END),             
        ISNULL(AMOUNT,0) AMOUNT ,             
        PAMT=(             
        CASE             
                WHEN SELL_BUY = 1             
                THEN ((CASE WHEN TRADEQTY > 0 THEN TRADEQTY * NETRATE ELSE NETRATE END)) + (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1             
                        THEN ISNULL((F.SERVICE_TAX),0)        
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG = 0             
           THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG = 2        
                          THEN 0             
                                        ELSE 0 END) END ) END )             
                ELSE 0 END),             
        SAMT=(             
        CASE             
                WHEN SELL_BUY = 2             
                THEN((CASE WHEN TRADEQTY > 0 THEN TRADEQTY * NETRATE ELSE NETRATE END)) - (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1             
                        THEN ISNULL((F.SERVICE_TAX),0)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG = 0             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG = 2             
                                        THEN 0             
                      ELSE 0 END ) END ) END)             
                ELSE 0 END),             
        SELL_BUY,             
        PSERVICE_TAX= (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN (             
                CASE             
                        WHEN C.SERVICE_CHRG=0             
                        THEN (F.SERVICE_TAX)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG=1             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG=2             
                                        THEN 0 END) END) END)             
                ELSE 0 END),             
        SSERVICE_TAX= (             
     CASE             
                WHEN SELL_BUY = 2             
                THEN (             
                CASE             
                        WHEN C.SERVICE_CHRG=0             
                        THEN (F.SERVICE_TAX)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG=1             
    THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG=2             
                                        THEN 0 END) END) END)             
       ELSE 0 END),             
        BROKER_CHRG = (             
        CASE             
                WHEN BROKERNOTE = 1             
                THEN BROKER_CHRG             
                ELSE 0 END ),             
        TURN_TAX = (             
        CASE             
                WHEN TURNOVER_TAX = 1             
                THEN TURN_TAX             
                ELSE 0 END),             
        SEBI_TAX = (             
        CASE             
                WHEN SEBI_TURN_TAX = 1             
                THEN SEBI_TAX             
                ELSE 0 END),             
        OTHER_CHRG = (             
        CASE             
                WHEN C.OTHER_CHRG = 1             
                THEN F.OTHER_CHRG             
                ELSE 0 END) ,             
        INS_CHRG = (             
        CASE             
               WHEN INSURANCE_CHRG = 1             
                THEN INS_CHRG             
                ELSE 0 END ),             
        SERVICE_TAX = (             
        CASE             
                WHEN SERVICE_CHRG = 0             
                THEN SERVICE_TAX             
                ELSE 0 END ),             
        NSERTAX= (             
        CASE             
                WHEN SERVICE_CHRG = 0             
                THEN SERVICE_TAX            
                ELSE 0 END ),             
   BROKERAGE = (CASE WHEN TRADEQTY > 0 THEN ISNULL(BROKAPPLIED,0) ELSE BROKAPPLIED END),        
   ORDFLG = 1          
FROM    #FOSETTLEMENT_1 F, #CLIENT2 C          
WHERE                    
  C.Cl_Code = F.PARTY_CODE       
  AND PRINTF <> '3'          
          
/* ------------------------------------------------------------------------          
   TAKING CONTRACT DATA TO THE FINAL TABLE (SUMMARISED)          
---------------------------------------------------------------------------*/          
          
          
INSERT INTO CONTRACT_DATA          
SELECT            
        CONTRACTNO,             
   ORDER_NO = '0000000000000000',      
        ORDER_TIME      = '00:00:00',          
        TRADE_NO        = '0000000',          
        TRADETIME       = '00:00:00',          
        @SAUDA_DATE,          
        F.PARTY_CODE,          
        INST_TYPE,          
        SYMBOL,          
        EXPIRYDATE,          
        STRIKE_PRICE,          
        OPTION_TYPE,          
   AUCTIONPART,          
        PQTY = (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN SUM(TRADEQTY)          
                ELSE 0 END),             
        SQTY = (             
        CASE             
                WHEN SELL_BUY = 2             
                THEN SUM(TRADEQTY)          
                ELSE 0 END),             
        PRATE = (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN SUM(ISNULL(TRADEQTY*PRICE,0))/CASE WHEN SUM(TRADEQTY)>0 THEN SUM(TRADEQTY) ELSE 1 END          
                ELSE 0 END),             
        SRATE = (             
   CASE             
                WHEN SELL_BUY = 2             
                THEN SUM(ISNULL(TRADEQTY*PRICE,0))/CASE WHEN SUM(TRADEQTY)>0 THEN SUM(TRADEQTY) ELSE 1 END          
                ELSE 0 END),             
        PBROK =(             
        CASE             
                WHEN SELL_BUY = 1             
                THEN SUM(ISNULL((BROKAPPLIED / (CASE WHEN TRADEQTY > 0 THEN TRADEQTY ELSE 1 END) + (             
                CASE             
                        WHEN C.SERVICE_CHRG=1 AND TRADEQTY > 0                
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)             
                        ELSE 0 END )),0)  )          
                ELSE 0 END),             
        SBROK =(             
        CASE             
                WHEN SELL_BUY = 2             
                THEN SUM(ISNULL((BROKAPPLIED / (CASE WHEN TRADEQTY > 0 THEN TRADEQTY ELSE 1 END) + (             
                CASE           
         WHEN C.SERVICE_CHRG=1 AND TRADEQTY > 0            
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)             
                        ELSE 0 END )),0))          
                ELSE 0 END),             
        PNETRATE = (             
        CASE             
                WHEN SELL_BUY =1             
                THEN SUM(ISNULL(NETRATE + (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1  AND TRADEQTY > 0               
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)             
                        ELSE 0 END),0))/(CASE WHEN SUM(TRADEQTY) >0 THEN SUM(TRADEQTY) ELSE 1 END)              
                ELSE 0 END),             
        SNETRATE = (             
        CASE             
                WHEN SELL_BUY =2             
                THEN SUM(ISNULL(NETRATE - (             
                CASE             
      WHEN C.SERVICE_CHRG = 1 AND TRADEQTY > 0            
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)             
                        ELSE 0 END),0))/(CASE WHEN SUM(TRADEQTY) >0 THEN SUM(TRADEQTY) ELSE 1 END)         
                ELSE 0 END),             
        AMOUNT = SUM(ISNULL(AMOUNT,0)),             
        PAMT= SUM(             
        CASE             
                WHEN SELL_BUY = 1             
                THEN ((CASE WHEN TRADEQTY > 0 THEN TRADEQTY * NETRATE ELSE NETRATE END)) + (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1             
                        THEN ISNULL((F.SERVICE_TAX),0)             
          
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG = 0             
           THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG = 2             
                                        THEN 0             
                                        ELSE 0 END) END ) END )             
                ELSE 0 END),             
        SAMT= SUM(             
        CASE             
                WHEN SELL_BUY = 2             
               THEN((CASE WHEN TRADEQTY > 0 THEN TRADEQTY * NETRATE ELSE NETRATE END)) - (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1             
                        THEN ISNULL((F.SERVICE_TAX),0)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG = 0             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG = 2             
                                        THEN 0             
                                        ELSE 0 END ) END ) END)             
                ELSE 0 END),             
        SELL_BUY,             
        PSERVICE_TAX= SUM(             
        CASE             
                WHEN SELL_BUY = 1             
                THEN (             
                CASE             
                        WHEN C.SERVICE_CHRG=0             
                        THEN (F.SERVICE_TAX)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG=1             
                                THEN 0             
                                ELSE (             
                          CASE            
                                        WHEN C.SERVICE_CHRG=2             
                                        THEN 0 END) END) END)             
                ELSE 0 END),             
        SSERVICE_TAX= SUM(            
     CASE             
                WHEN SELL_BUY = 2             
                THEN (             
                CASE             
       WHEN C.SERVICE_CHRG=0             
                        THEN (F.SERVICE_TAX)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG=1             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG=2             
                                        THEN 0 END) END) END)             
                ELSE 0 END),             
        BROKER_CHRG = SUM(             
        CASE             
                WHEN BROKERNOTE = 1             
                THEN BROKER_CHRG             
                ELSE 0 END ),             
        TURN_TAX = SUM(             
        CASE             
                WHEN TURNOVER_TAX = 1             
                THEN TURN_TAX             
                ELSE 0 END),             
        SEBI_TAX = SUM(             
        CASE             
                WHEN SEBI_TURN_TAX = 1             
                THEN SEBI_TAX             
                ELSE 0 END),             
        OTHER_CHRG = SUM(             
        CASE          
                WHEN C.OTHER_CHRG = 1             
                THEN F.OTHER_CHRG             
                ELSE 0 END) ,             
        INS_CHRG = SUM(             
        CASE             
                WHEN INSURANCE_CHRG = 1             
                THEN INS_CHRG             
                ELSE 0 END ),             
        SERVICE_TAX = SUM(             
        CASE             
                WHEN SERVICE_CHRG = 0             
                THEN SERVICE_TAX             
                ELSE 0 END ),             
        NSERTAX= SUM(             
        CASE             
                WHEN SERVICE_CHRG = 0             
                THEN SERVICE_TAX            
                ELSE 0 END ),             
  BROKERAGE = SUM(ISNULL(BROKAPPLIED,0)),          
  ORDFLG          
FROM          
  #FOSETTLEMENT_1 F,#client2 C          
WHERE                    
  C.Cl_Code = F.PARTY_CODE             
  AND PRINTF = '3'          
GROUP BY           
        CONTRACTNO,             
        F.PARTY_CODE,          
        INST_TYPE,          
        SYMBOL,          
        EXPIRYDATE,          
        STRIKE_PRICE,          
        OPTION_TYPE,          
  AUCTIONPART,          
  SELL_BUY,          
  ORDFLG            
  
SELECT * INTO #CONTRACT_DATA_TODAY FROM   
CONTRACT_DATA WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59'  
  
DELETE CONTRACT_DATA WHERE SAUDA_DATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59'  
          
UPDATE #CONTRACT_DATA_TODAY         
SET ORDER_NO = F.ORDER_NO,        
TRADE_NO = F.TRADE_NO,        
ORDER_TIME = F.CPID,        
TRADETIME = LEFT(CONVERT(VARCHAR,F.SAUDA_DATE,108),11)        
FROM #FOSETTLEMENT_1 F        
WHERE  #CONTRACT_DATA_TODAY.PARTY_CODE = F.PARTY_CODE        
AND #CONTRACT_DATA_TODAY.INST_TYPE = F.INST_TYPE        
AND #CONTRACT_DATA_TODAY.SYMBOL = F.SYMBOL        
AND #CONTRACT_DATA_TODAY.EXPIRYDATE = F.EXPIRYDATE        
AND #CONTRACT_DATA_TODAY.STRIKE_PRICE = F.STRIKE_PRICE        
AND #CONTRACT_DATA_TODAY.OPTION_TYPE = F.OPTION_TYPE        
AND #CONTRACT_DATA_TODAY.AUCTIONPART = F.AUCTIONPART        
AND #CONTRACT_DATA_TODAY.SELL_BUY = F.SELL_BUY        
AND #CONTRACT_DATA_TODAY.ORDER_NO = '0000000000000000'        
AND F.SAUDA_DATE = (SELECT SAUDA_DATE=MIN(SAUDA_DATE)        
     FROM #FOSETTLEMENT_1 F1        
     WHERE F1.PARTY_CODE = F.PARTY_CODE        
     AND F1.INST_TYPE = F.INST_TYPE        
     AND F1.SYMBOL = F.SYMBOL        
     AND F1.EXPIRYDATE = F.EXPIRYDATE        
     AND F1.STRIKE_PRICE = F.STRIKE_PRICE        
     AND F1.OPTION_TYPE = F.OPTION_TYPE        
     AND F1.AUCTIONPART = F.AUCTIONPART        
     AND F1.SELL_BUY = F.SELL_BUY)            
       
INSERT INTO CONTRACT_DATA  
SELECT * FROM #CONTRACT_DATA_TODAY  
  
DROP TABLE #CONTRACT_DATA_TODAY  
          
/* ------------------------------------------------------------------------          
   TAKING CONTRACT DATA TO THE FINAL ARCHIVAL TABLE (SUMMARISED)          
---------------------------------------------------------------------------*/          
          
INSERT INTO CONTRACT_DATA_DET          
SELECT            
        CONTRACTNO,             
   ORDER_NO,             
        ORDER_TIME=CPID,             
        TRADE_NO,             
        LEFT(CONVERT(VARCHAR,SAUDA_DATE,108),11) AS TRADETIME,             
        @SAUDA_DATE,             
        F.PARTY_CODE,             
        INST_TYPE,             
        SYMBOL,             
        LEFT(CONVERT(VARCHAR,EXPIRYDATE,106),11) AS EXPIRYDATE,             
        ISNULL(STRIKE_PRICE,0) STRIKE_PRICE,             
        OPTION_TYPE,          
   AUCTIONPART ,          
        PQTY = (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN TRADEQTY             
                ELSE 0 END),             
        SQTY = (             
        CASE             
                WHEN SELL_BUY = 2             
                THEN TRADEQTY             
                ELSE 0 END),             
        PRATE = (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN ISNULL(PRICE,0)             
                ELSE 0 END),             
        SRATE = (             
   CASE             
                WHEN SELL_BUY = 2             
                THEN ISNULL(PRICE,0)             
                ELSE 0 END),             
        PBROK =(             
        CASE             
                WHEN SELL_BUY = 1             
				THEN ISNULL((BROKAPPLIED + (             
                CASE             
                        WHEN C.SERVICE_CHRG=1 AND TRADEQTY > 0             
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)             
                        ELSE 0 END )),0)             
                ELSE 0 END),             
        SBROK =(             
        CASE             
                WHEN SELL_BUY = 2             
                THEN ISNULL((BROKAPPLIED + (             
                CASE             
         WHEN C.SERVICE_CHRG=1 AND TRADEQTY > 0             
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)             
                        ELSE 0 END )),0)             
                ELSE 0 END),             
        PNETRATE = (             
        CASE             
                WHEN SELL_BUY =1             
                THEN ISNULL(NETRATE + (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1 AND TRADEQTY > 0             
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)             
                        ELSE 0 END),0)             
                ELSE 0 END),             
        SNETRATE = (             
        CASE             
                WHEN SELL_BUY =2             
                THEN ISNULL(NETRATE - (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1 AND TRADEQTY > 0             
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)             
                        ELSE 0 END),0)             
                ELSE 0 END),             
  ISNULL(AMOUNT,0) AMOUNT ,             
        PAMT=(             
        CASE             
                WHEN SELL_BUY = 1             
                THEN ((CASE WHEN TRADEQTY > 0 THEN TRADEQTY * NETRATE ELSE NETRATE END)) + (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1             
                        THEN ISNULL((F.SERVICE_TAX),0)             
          
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG = 0             
       THEN 0             
                                ELSE (             
                                CASE             
           WHEN C.SERVICE_CHRG = 2             
                                        THEN 0             
                                        ELSE 0 END) END ) END )             
                ELSE 0 END),             
        SAMT=(             
        CASE             
                WHEN SELL_BUY = 2             
    THEN((CASE WHEN TRADEQTY > 0 THEN TRADEQTY * NETRATE ELSE NETRATE END)) - (             
                CASE             
                        WHEN C.SERVICE_CHRG = 1             
                        THEN ISNULL((F.SERVICE_TAX),0)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG = 0             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG = 2             
                                        THEN 0             
                                        ELSE 0 END ) END ) END)             
                ELSE 0 END),             
        SELL_BUY,               PSERVICE_TAX= (             
        CASE             
                WHEN SELL_BUY = 1             
                THEN (             
                CASE             
                        WHEN C.SERVICE_CHRG=0             
                        THEN (F.SERVICE_TAX)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG=1             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG=2             
                                        THEN 0 END) END) END)             
                ELSE 0 END),             
        SSERVICE_TAX= (             
     CASE             
                WHEN SELL_BUY = 2             
                THEN (             
                CASE             
                        WHEN C.SERVICE_CHRG=0             
                        THEN (F.SERVICE_TAX)             
                        ELSE (             
                        CASE             
                                WHEN C.SERVICE_CHRG=1             
                                THEN 0             
                                ELSE (             
                                CASE             
                                        WHEN C.SERVICE_CHRG=2             
                                        THEN 0 END) END) END)             
                ELSE 0 END),             
        BROKER_CHRG = (             
        CASE             
                WHEN BROKERNOTE = 1             
                THEN BROKER_CHRG             
                ELSE 0 END ),             
        TURN_TAX = (             
        CASE             
                WHEN TURNOVER_TAX = 1             
                THEN TURN_TAX             
                ELSE 0 END),             
        SEBI_TAX = (             
        CASE             
                WHEN SEBI_TURN_TAX = 1             
                THEN SEBI_TAX             
                ELSE 0 END),             
        OTHER_CHRG = (             
        CASE             
                WHEN C.OTHER_CHRG = 1             
                THEN F.OTHER_CHRG             
                ELSE 0 END) ,             
        INS_CHRG = (             
        CASE             
                WHEN INSURANCE_CHRG = 1             
                THEN INS_CHRG             
  ELSE 0 END ),            
SERVICE_TAX = (             
        CASE             
                WHEN SERVICE_CHRG = 0             
                THEN SERVICE_TAX             
                ELSE 0 END ),             
        NSERTAX= (             
        CASE             
                WHEN SERVICE_CHRG = 0             
                THEN SERVICE_TAX      
                ELSE 0 END ),             
  BROKERAGE = ISNULL(TRADEQTY*BROKAPPLIED,0),             
  ORDFLG          
FROM    #FOSETTLEMENT_1 F, #CLIENT2 C          
WHERE                    
  C.cl_CODE = F.PARTY_CODE          
  AND PRINTF = '3'          
        
          
/* ------------------------------------------------------------------------          
     CLEANING TEMPORARY TABLES          
---------------------------------------------------------------------------*/          
          
DROP TABLE #FOSETTLEMENT          
DROP TABLE #FOSETTLEMENT_1          
          
        
/*------------------------------------------------------        
 UPDATE FOR EXPIRED, ASSIGNMENT, EXPIRY CLOSED        
--------------------------------------------------------*/        
        
UPDATE CONTRACT_DATA SET        
ORDER_NO = 'EXPIRED',        
ORDER_TIME = '',        
TRADE_NO = '',        
TRADETIME = ''        
WHERE SAUDA_DATE >= @SAUDA_DATE And SAUDA_DATE <= @SAUDA_DATE +' 23:59:59'        
AND LEFT(INST_TYPE,3) = 'FUT' AND AUCTIONPART = 'EA'        
        
UPDATE CONTRACT_DATA SET        
ORDER_NO = 'ASSIGNMENT',        
ORDER_TIME = '',        
TRADE_NO = '',        
TRADETIME = ''        
WHERE SAUDA_DATE >= @SAUDA_DATE And SAUDA_DATE <= @SAUDA_DATE +' 23:59:59'        
AND LEFT(INST_TYPE,3) = 'OPT' AND AUCTIONPART = 'EA' AND SELL_BUY = 1        
        
UPDATE CONTRACT_DATA SET        
ORDER_NO = 'EXPIRY CLOSED',        
ORDER_TIME = '',        
TRADE_NO = '',        
TRADETIME = ''        
WHERE SAUDA_DATE >= @SAUDA_DATE And SAUDA_DATE <= @SAUDA_DATE +' 23:59:59'        
AND LEFT(INST_TYPE,3) = 'OPT' AND AUCTIONPART = 'EA' AND SELL_BUY = 2        
        
          
  
 DECLARE @PROCESS_TIME DATETIME,@CCNT INT,@PQTY Money,@SQTY Money
 SELECT @PROCESS_TIME =GETDATE()
 
 SELECT @CCNT=COUNT(DISTINCT PARTY_CODE),@PQTY=SUM(PQTY) ,@SQTY =SUM(SQTY) FROM FOBILLVALAN WITH(NOLOCK)
 WHERE SAUDA_DATE >=@SAUDA_DATE AND SAUDA_DATE <=@SAUDA_DATE + ' 23:59'
 AND TRADETYPE='BT'

 --Exec [172.31.13.132].Portfolio_21_22.DBO.Usp_Auto_Populate_Derivative_Portfolio    
 

 INSERT INTO TBL_PORTFOILO_PROCESS_LOG (PROCESS_START_TIME,PROCESS_END_TIME,CLIENT_COUNT,PQTY_BT,SQTY_BT)
 SELECT @PROCESS_TIME,GETDATE(), @CCNT,@PQTY,@SQTY



          
/* ------------------------------------------------------------------------          
        END OF PROCEDURE          
---------------------------------------------------------------------------*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.POP_CONTRACTDATA_bkp23march2024_SRE-23891
-- --------------------------------------------------



    
    
         
CREATE  PROC [dbo].[POP_CONTRACTDATA_bkp23march2024_SRE-23891]            
(              
 @SAUDA_DATE VARCHAR(11),            
 @USERNAME VARCHAR(11)=''            
)            
            
AS               
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
            
            
/* ------------------------------------------------------------------------            
      REMOVING THE EXISTING RECORDS            
---------------------------------------------------------------------------*/            
            
DELETE CONTRACT_MASTER             
WHERE            
 TRADE_DATE >= @SAUDA_DATE AND             
 TRADE_DATE <= @SAUDA_DATE +' 23:59'            
            
DELETE CONTRACT_DATA            
WHERE            
 SAUDA_DATE >= @SAUDA_DATE AND             
 SAUDA_DATE <= @SAUDA_DATE +' 23:59'            
            
DELETE CONTRACT_DATA_DET            
WHERE            
 SAUDA_DATE >= @SAUDA_DATE AND             
 SAUDA_DATE <= @SAUDA_DATE +' 23:59'            
            
/* ------------------------------------------------------------------------            
     TAKING FILTERD TRADES TO TEMPORARY TABLE            
---------------------------------------------------------------------------*/            
            
CREATE TABLE #FOSETTLEMENT            
(            
 CONTRACTNO VARCHAR(14),            
 ORDER_NO VARCHAR(16),            
 CPID VARCHAR(12),            
 TRADE_NO VARCHAR(20),            
 SAUDA_DATE DATETIME,            
 PARTY_CODE VARCHAR(10),            
 INST_TYPE VARCHAR(6),            
 SYMBOL VARCHAR(12),            
 EXPIRYDATE DATETIME,            
 STRIKE_PRICE MONEY,            
 OPTION_TYPE VARCHAR(2),            
 AUCTIONPART VARCHAR(2),            
 SELL_BUY INT,            
 TRADEQTY NUMERIC(36,0),            
 PRICE NUMERIC (36,12),            
 BROKAPPLIED NUMERIC (36,12),            
 NETRATE NUMERIC (36,12),            
 AMOUNT NUMERIC (36,12),            
 SERVICE_TAX NUMERIC (36,12),            
 BROKER_CHRG NUMERIC (36,12),            
 TURN_TAX NUMERIC (36,12),            
 SEBI_TAX NUMERIC (36,12),            
 OTHER_CHRG NUMERIC (36,12),            
 INS_CHRG NUMERIC (36,12),            
 ORDFLG INT            
)            
      
      
SELECT * INTO #FOSETTLEMENT_1 FROM #FOSETTLEMENT            
            
CREATE INDEX [IDXPARTY] ON [DBO].[#FOSETTLEMENT_1] ([PARTY_CODE])               
            
INSERT INTO #FOSETTLEMENT            
SELECT             
 CONTRACTNO,ORDER_NO,CPID,TRADE_NO,SAUDA_DATE,PARTY_CODE,            
 INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,            
 SELL_BUY,TRADEQTY,PRICE,BROKAPPLIED,NETRATE,AMOUNT,            
 SERVICE_TAX,BROKER_CHRG,TURN_TAX,SEBI_TAX,OTHER_CHRG,            
 INS_CHRG,ORDFLAG=1            
FROM FOSETTLEMENT                             
WHERE             
 SAUDA_DATE >= @SAUDA_DATE AND             
 SAUDA_DATE <= @SAUDA_DATE +' 23:59' AND             
 AUCTIONPART <> 'CA' AND            
 TRADEQTY > 0  AND             
 PRICE > 0    
   
       
            
UPDATE #FOSETTLEMENT SET TRADE_NO = PRADNYA.DBO.REPLACETRADENO(TRADE_NO)             
WHERE UPPER(LEFT(TRADE_NO,1)) BETWEEN 'A' AND 'Z'     
     
            
UPDATE #FOSETTLEMENT SET CPID = (CASE WHEN CPID = 'NIL' OR CPID   = '0' THEN '' ELSE RIGHT(CPID,8) END)    
            
INSERT INTO #FOSETTLEMENT_1            
SELECT             
 CONTRACTNO,ORDER_NO,CPID ,TRADE_NO,SAUDA_DATE,            
 PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,            
 OPTION_TYPE,AUCTIONPART,SELL_BUY,            
 TRADEQTY = SUM(TRADEQTY),            
 PRICE = SUM(TRADEQTY*PRICE)/ SUM(TRADEQTY),            
 BROKAPPLIED = sum(BROKAPPLIED*TRADEQTY)/ SUM(TRADEQTY),
 NETRATE= SUM(NETRATE*TRADEQTY)/ SUM(TRADEQTY),            
 AMOUNT = SUM(AMOUNT),            
 SERVICE_TAX = SUM(SERVICE_TAX),            
 BROKER_CHRG = SUM(BROKER_CHRG),            
 TURN_TAX = SUM(TURN_TAX),            
 SEBI_TAX = SUM(SEBI_TAX),            
 OTHER_CHRG = SUM(OTHER_CHRG),            
 INS_CHRG = SUM(INS_CHRG),            
 ORDFLAG=1            
FROM  #FOSETTLEMENT           
GROUP BY            
 CONTRACTNO,            
 ORDER_NO,            
 CPID,            
 TRADE_NO,            
 SAUDA_DATE,            
 PARTY_CODE,            
 INST_TYPE,            
 SYMBOL,         
 EXPIRYDATE,     
 STRIKE_PRICE,            
 OPTION_TYPE,            
 AUCTIONPART,            
 SELL_BUY-- , 
-- BROKAPPLIED   
   
   
   
            
/* ------------------------------------------------------------------------            
        VBB UPDATE            
---------------------------------------------------------------------------*/            
UPDATE               
 #FOSETTLEMENT_1              
SET              
 BROKAPPLIED = CASE WHEN SELL_BUY =1 THEN CD_TOT_BUYBROK/CD_TOT_BUYQTY ELSE CD_TOT_SELLBROK/CD_TOT_SELLQTY END      
    + (CASE WHEN SERVICE_CHRG = 1 THEN       
       CASE WHEN SELL_BUY =1 THEN CD_TOT_BUYSERTAX ELSE CD_TOT_SELLSERTAX END      
    ELSE 0 END),    
 SERVICE_TAX = SERVICE_TAX + (CASE WHEN SERVICE_CHRG = 0 THEN               
      CASE WHEN SELL_BUY =1 THEN CD_TOT_BUYSERTAX ELSE CD_TOT_SELLSERTAX END              
 ELSE 0 END)            
FROM              
 CHARGES_DETAIL, CLIENT2            
WHERE              
 CLIENT2.PARTY_CODE = #FOSETTLEMENT_1.PARTY_CODE            
 AND CONVERT(VARCHAR,CHARGES_DETAIL.CD_SAUDA_DATE,103) = CONVERT(VARCHAR,#FOSETTLEMENT_1.SAUDA_DATE,103)              
 AND CD_PARTY_CODE = #FOSETTLEMENT_1.PARTY_CODE               
 AND CD_INST_TYPE = #FOSETTLEMENT_1.INST_TYPE            
 AND CD_SYMBOL = #FOSETTLEMENT_1.SYMBOL        
  AND CONVERT(VARCHAR,CD_EXPIRY_DATE,103) = CONVERT(VARCHAR,#FOSETTLEMENT_1.EXPIRYDATE,103)             
-- AND CONVERT(VARCHAR,CD_EXPIRY_DATE,106) = #FOSETTLEMENT_1.EXPIRYDATE              
 AND CD_OPTION_TYPE = #FOSETTLEMENT_1.OPTION_TYPE              
 AND CD_STRIKE_PRICE = #FOSETTLEMENT_1.STRIKE_PRICE              
 AND CD_TRADE_NO = #FOSETTLEMENT_1.TRADE_NO              
 AND CD_ORDER_NO = #FOSETTLEMENT_1.ORDER_NO        
  
  
    
UPDATE #FOSETTLEMENT_1      
SET NETRATE = PRICE + CASE WHEN SELL_BUY =1  THEN BROKAPPLIED ELSE - BROKAPPLIED END    
WHERE BROKAPPLIED <> 0 AND NETRATE = PRICE  


      
             
INSERT INTO #FOSETTLEMENT_1            
SELECT              
 CD_CONTRACT_NO,            
 CD_ORDER_NO,               
 CPID = '',               
 CD_TRADE_NO,          
 CD_SAUDA_DATE,               
 --CONVERT(VARCHAR,CD_SAUDA_DATE,103) AS SAUDA_DATE,               
 CD_PARTY_CODE,              
 CD_INST_TYPE,               
 CD_SYMBOL= (CASE WHEN CD_SYMBOL = '' THEN 'CONT BROK' ELSE CD_SYMBOL END),               
 EXPIRYDATE = (CASE WHEN CD_SYMBOL = '' THEN '' ELSE             
      LEFT(CONVERT(VARCHAR,CD_EXPIRY_DATE,106),11) END)  ,               
 STRIKE_PRICE = ISNULL(CD_STRIKE_PRICE,0),               
 CD_OPTION_TYPE,            
 CD_AUCTIONPART,            
 SELL_BUY = CASE WHEN CD_TOT_BUYBROK > 0 THEN 1 ELSE 2 END,            
 TRADEQTY = 0,            
 PRICE = 0,            
 BROKAPPLIED = CD_TOT_BUYBROK + CD_TOT_SELLBROK            
     + (CASE WHEN SERVICE_CHRG = 1 THEN               
     CD_TOT_BUYSERTAX + CD_TOT_SELLSERTAX  ELSE 0 END),            
 NETRATE= 0,            
 AMOUNT = 0,            
 SERVICE_TAX = (CASE WHEN SERVICE_CHRG = 0 THEN               
     CD_TOT_BUYSERTAX + CD_TOT_SELLSERTAX  ELSE 0 END),            
 BROKER_CHRG = 0,            
 TURN_TAX = 0,            
 SEBI_TAX = 0,            
 OTHER_CHRG = 0,            
 INS_CHRG = 0,            
 ORDFLG = (CASE WHEN CD_ORDER_NO <> '' THEN 1              
    WHEN CD_SYMBOL <> '' THEN 2              
    ELSE 3 END)              
FROM            
 CHARGES_DETAIL F, CLIENT2            
WHERE            
 PARTY_CODE = CD_PARTY_CODE            
 AND CD_SAUDA_DATE >= @SAUDA_DATE            
 AND CD_SAUDA_DATE <= @SAUDA_DATE + ' 23:59:59'            
 AND CD_TRADE_NO = ''              
 AND CD_TOT_BUYBROK + CD_TOT_SELLBROK > 0                
 AND CD_PARTY_CODE IN             
 (            
  SELECT             
   DISTINCT PARTY_CODE             
  FROM            
   #FOSETTLEMENT (NOLOCK)        
         
      
 )      
       
      
       
            
/* ------------------------------------------------------------------------            
     TAKING FILTERD CLIENT DETAILS TO TEMPORARY TABLE            
---------------------------------------------------------------------------*/            
INSERT INTO  CONTRACT_MASTER            
SELECT              
 @SAUDA_DATE,            
 C2.PARTY_CODE,               
 C1.LONG_NAME,               
 C1.L_ADDRESS1,               
 C1.L_ADDRESS2,               
 C1.L_ADDRESS3,               
 C1.L_CITY,               
 C1.L_STATE,               
 C1.L_ZIP,               
 C1.BRANCH_CD ,               
 C1.SUB_BROKER,               
 C1.TRADER,              
 C1.AREA,              
 C1.REGION,              
 C1.FAMILY,               
 C1.PAN_GIR_NO,               
 C1.OFF_PHONE1,               
 C1.MOBILE_PAGER,               
 PRINTF,               
 MAPIDID,               
 UCC_CODE,              
 C2.SERVICE_CHRG,               
 BROKERNOTE,               
 TURNOVER_TAX,               
 SEBI_TURN_TAX,               
 C2.OTHER_CHRG,               
 INSURANCE_CHRG,              
 SEBI_NO = FD_CODE              
FROM    CLIENT1 C1               
WITH               
        (               
                NOLOCK               
        )               
        ,               
        CLIENT2 C2               
WITH               
        (               
                NOLOCK               
        )               
LEFT OUTER JOIN UCC_CLIENT UC               
WITH               
        (               
                NOLOCK               
        )               
        ON C2.PARTY_CODE = UC.PARTY_CODE               
WHERE   C2.CL_CODE       = C1.CL_CODE               
 AND C2.PARTY_CODE IN             
 (            
  SELECT             
   DISTINCT PARTY_CODE             
  FROM            
   #FOSETTLEMENT (NOLOCK)            
 )            
            
            
/* ------------------------------------------------------------------------            
   TAKING CONTRACT DATA TO THE FINAL TEMP TABLE (NON SUMMARISED)            
---------------------------------------------------------------------------*/            
            
INSERT INTO CONTRACT_DATA            
SELECT              
        CONTRACTNO,               
  ORDER_NO,               
        ORDER_TIME=CPID,               
        TRADE_NO,               
        LEFT(CONVERT(VARCHAR,SAUDA_DATE,108),11) AS TRADETIME,               
        @SAUDA_DATE,               
        F.PARTY_CODE,               
        INST_TYPE,               
        SYMBOL,               
        LEFT(CONVERT(VARCHAR,EXPIRYDATE,106),11) AS EXPIRYDATE,               
        ISNULL(STRIKE_PRICE,0) STRIKE_PRICE,             
  AUCTIONPART ,             
        OPTION_TYPE,               
        PQTY = (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN TRADEQTY               
                ELSE 0 END),               
        SQTY = (               
        CASE               
                WHEN SELL_BUY = 2               
                THEN TRADEQTY               
                ELSE 0 END),               
        PRATE = (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN ISNULL(PRICE,0)               
                ELSE 0 END),               
        SRATE = (               
  CASE               
                WHEN SELL_BUY = 2               
                THEN ISNULL(PRICE,0)               
                ELSE 0 END),               
        PBROK =(               
        CASE               
                WHEN SELL_BUY = 1               
                THEN ISNULL((BROKAPPLIED + (               
                CASE               
                        WHEN C.SERVICE_CHRG=1               
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)               
                        ELSE 0 END )),0)               
                ELSE 0 END),               
        SBROK =(               
        CASE               
     WHEN SELL_BUY = 2               
                THEN ISNULL((BROKAPPLIED + (               
                CASE               
         WHEN C.SERVICE_CHRG=1               
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)               
                        ELSE 0 END )),0)               
                ELSE 0 END),               
        PNETRATE = (               
        CASE               
                WHEN SELL_BUY =1               
                THEN ISNULL(NETRATE + (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
            THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)               
                        ELSE 0 END),0)               
                ELSE 0 END),               
        SNETRATE = (               
        CASE               
                WHEN SELL_BUY =2               
                THEN ISNULL(NETRATE - (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)               
                        ELSE 0 END),0)               
                ELSE 0 END),               
        ISNULL(AMOUNT,0) AMOUNT ,               
        PAMT=(               
        CASE               
                WHEN SELL_BUY = 1               
                THEN (TRADEQTY * NETRATE) + (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX),0)               
            
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG = 0               
        THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG = 2               
                                        THEN 0               
                                        ELSE 0 END) END ) END )               
                ELSE 0 END),               
        SAMT=(               
        CASE               
                WHEN SELL_BUY = 2               
                THEN(TRADEQTY * NETRATE) - (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX),0)               
                        ELSE (               
                        CASE          
                                WHEN C.SERVICE_CHRG = 0               
                                THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG = 2               
                                        THEN 0               
                                        ELSE 0 END ) END ) END)               
                ELSE 0 END),               
        SELL_BUY,               
        PSERVICE_TAX= (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN (               
                CASE               
                        WHEN C.SERVICE_CHRG=0               
                        THEN (F.SERVICE_TAX)               
                        ELSE (               
      CASE               
                               WHEN C.SERVICE_CHRG=1               
                                THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG=2               
                                        THEN 0 END) END) END)               
                ELSE 0 END),               
        SSERVICE_TAX= (               
    CASE               
                WHEN SELL_BUY = 2               
                THEN (               
                CASE               
                        WHEN C.SERVICE_CHRG=0               
                        THEN (F.SERVICE_TAX)               
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG=1               
THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG=2               
                                        THEN 0 END) END) END)               
                ELSE 0 END),               
        BROKER_CHRG = (               
        CASE               
                WHEN BROKERNOTE = 1               
THEN BROKER_CHRG               
                ELSE 0 END ),               
        TURN_TAX = (               
        CASE               
                WHEN TURNOVER_TAX = 1               
                THEN TURN_TAX               
                ELSE 0 END),               
        SEBI_TAX = (               
        CASE               
                WHEN SEBI_TURN_TAX = 1               
                THEN SEBI_TAX               
                ELSE 0 END),               
        OTHER_CHRG = (               
        CASE               
                WHEN C.OTHER_CHRG = 1               
                THEN F.OTHER_CHRG               
                ELSE 0 END) ,               
        INS_CHRG = (               
        CASE               
                WHEN INSURANCE_CHRG = 1               
          THEN INS_CHRG               
                ELSE 0 END ),               
        SERVICE_TAX = (               
        CASE               
                WHEN SERVICE_CHRG = 0               
                THEN SERVICE_TAX               
                ELSE 0 END ),               
        NSERTAX= (               
        CASE               
                WHEN SERVICE_CHRG = 0               
                THEN SERVICE_TAX              
                ELSE 0 END ),               
  ---BROKERAGE = ISNULL(TRADEQTY*BROKAPPLIED,0),    
 --- BROKERAGE = (CASE WHEN TRADEQTY > 0 THEN ISNULL(BROKAPPLIED,0) ELSE BROKAPPLIED END), 
 BROKERAGE = (CASE WHEN TRADEQTY > 0 THEN ISNULL(TRADEQTY*BROKAPPLIED,0)  ELSE ISNULL(BROKAPPLIED,0) END),            
  ORDFLG = 1            
FROM    #FOSETTLEMENT_1 F, CONTRACT_MASTER C            
WHERE                      
  C.PARTY_CODE = F.PARTY_CODE            
  AND LEFT(SAUDA_DATE,11) = LEFT(TRADE_DATE,11)            
  AND PRINTF <> '3'            
            
/* ------------------------------------------------------------------------            
   TAKING CONTRACT DATA TO THE FINAL TABLE (SUMMARISED)            
---------------------------------------------------------------------------*/            
            
            
INSERT INTO CONTRACT_DATA            
SELECT              
        CONTRACTNO,               
  ORDER_NO='000000000000000',               
        ORDER_TIME      = '00:00:00',            
        TRADE_NO        ='0000000',            
        TRADETIME       ='00:00:00',            
        @SAUDA_DATE,            
        F.PARTY_CODE,            
        INST_TYPE,            
        SYMBOL,            
        EXPIRYDATE,            
        STRIKE_PRICE,            
        OPTION_TYPE,            
  AUCTIONPART,            
   PQTY = (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN SUM(TRADEQTY)            
                ELSE 0 END),               
        SQTY = (               
        CASE               
                WHEN SELL_BUY = 2               
                THEN SUM(TRADEQTY)            
                ELSE 0 END),               
        PRATE = (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN SUM(ISNULL(TRADEQTY*PRICE,0))/SUM(TRADEQTY)            
                ELSE 0 END),               
        SRATE = (               
  CASE               
                WHEN SELL_BUY = 2               
                THEN SUM(ISNULL(TRADEQTY*PRICE,0))/SUM(TRADEQTY)            
                ELSE 0 END),               
        PBROK =(               
        CASE               
                WHEN SELL_BUY = 1               
                THEN SUM(ISNULL((BROKAPPLIED + (               
                CASE               
                        WHEN C.SERVICE_CHRG=1               
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)              
             ELSE 0 END )),0)  )            
                ELSE 0 END),               
        SBROK =(               
        CASE               
                WHEN SELL_BUY = 2               
                THEN SUM(ISNULL((BROKAPPLIED + (               
                CASE               
         WHEN C.SERVICE_CHRG=1               
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)               
                        ELSE 0 END )),0))            
                ELSE 0 END),               
        PNETRATE = (               
        CASE               
                WHEN SELL_BUY =1               
                THEN SUM(ISNULL(NETRATE + (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)               
                        ELSE 0 END),0))/SUM(TRADEQTY)               
                ELSE 0 END),               
        SNETRATE = (               
        CASE               
                WHEN SELL_BUY =2               
                THEN SUM(ISNULL(NETRATE - (               
                CASE               
    WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)               
                        ELSE 0 END),0))/SUM(TRADEQTY)            
                ELSE 0 END),               
        AMOUNT = SUM(ISNULL(AMOUNT,0)),               
        PAMT= SUM(               
        CASE               
                WHEN SELL_BUY = 1               
                THEN (TRADEQTY * NETRATE) + (               
                CASE               
                       WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX),0)               
            
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG = 0               
        THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG = 2               
                                        THEN 0               
                                        ELSE 0 END) END ) END )               
                ELSE 0 END),               
        SAMT= SUM(               
        CASE               
                WHEN SELL_BUY = 2               
                THEN(TRADEQTY * NETRATE) - (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX),0)               
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG = 0               
                                THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG = 2               
                                        THEN 0               
                                        ELSE 0 END ) END ) END)               
                ELSE 0 END),               
        SELL_BUY,               
        PSERVICE_TAX= SUM(               
        CASE               
                WHEN SELL_BUY = 1               
        THEN (               
                CASE               
                        WHEN C.SERVICE_CHRG=0               
                        THEN (F.SERVICE_TAX)               
                        ELSE (               
                        CASE               
                       WHEN C.SERVICE_CHRG=1               
                                THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG=2               
                                        THEN 0 END) END) END)               
                ELSE 0 END),               
        SSERVICE_TAX= SUM(               
    CASE               
                WHEN SELL_BUY = 2               
                THEN (               
                CASE               
                        WHEN C.SERVICE_CHRG=0               
                        THEN (F.SERVICE_TAX)               
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG=1               
                                THEN 0               
                                ELSE (               
                                CASE               
         WHEN C.SERVICE_CHRG=2               
                         THEN 0 END) END) END)      
                ELSE 0 END),               
        BROKER_CHRG = SUM(               
        CASE               
                WHEN BROKERNOTE = 1               
                THEN BROKER_CHRG               
                ELSE 0 END ),               
        TURN_TAX = SUM(               
        CASE               
                WHEN TURNOVER_TAX = 1               
                THEN TURN_TAX               
                ELSE 0 END),               
        SEBI_TAX = SUM(               
        CASE               
                WHEN SEBI_TURN_TAX = 1               
                THEN SEBI_TAX               
                ELSE 0 END),               
        OTHER_CHRG = SUM(               
        CASE               
                WHEN C.OTHER_CHRG = 1               
                THEN F.OTHER_CHRG               
                ELSE 0 END) ,               
        INS_CHRG = SUM(               
        CASE               
                WHEN INSURANCE_CHRG = 1               
                THEN INS_CHRG               
                ELSE 0 END ),               
        SERVICE_TAX = SUM(               
        CASE               
                WHEN SERVICE_CHRG = 0               
             THEN SERVICE_TAX               
                ELSE 0 END ),               
        NSERTAX= SUM(               
        CASE               
                WHEN SERVICE_CHRG = 0               
                THEN SERVICE_TAX              
                ELSE 0 END ),               
  BROKERAGE = SUM(ISNULL(TRADEQTY*BROKAPPLIED,0)),            
  ORDFLG            
FROM            
  #FOSETTLEMENT_1 F,CONTRACT_MASTER C            
WHERE                      
  C.PARTY_CODE = F.PARTY_CODE               
  AND LEFT(SAUDA_DATE,11) = LEFT(TRADE_DATE,11)            
  AND PRINTF = '3'            
GROUP BY             
        CONTRACTNO,               
        F.PARTY_CODE,            
        INST_TYPE,            
        SYMBOL,            
        EXPIRYDATE,            
        STRIKE_PRICE,            
        OPTION_TYPE,            
  AUCTIONPART,            
  SELL_BUY,            
  ORDFLG              
            
UPDATE CONTRACT_DATA           
SET ORDER_NO = F.ORDER_NO,          
TRADE_NO = F.TRADE_NO,          
ORDER_TIME = F.CPID,          
TRADETIME = LEFT(CONVERT(VARCHAR,F.SAUDA_DATE,108),11)          
FROM #FOSETTLEMENT_1 F          
WHERE LEFT(CONTRACT_DATA.SAUDA_DATE,11) = LEFT(F.SAUDA_DATE,11)          
AND CONTRACT_DATA.PARTY_CODE = F.PARTY_CODE          
AND CONTRACT_DATA.INST_TYPE = F.INST_TYPE          
AND CONTRACT_DATA.SYMBOL = F.SYMBOL          
AND CONTRACT_DATA.EXPIRYDATE = F.EXPIRYDATE          
AND CONTRACT_DATA.STRIKE_PRICE = F.STRIKE_PRICE          
AND CONTRACT_DATA.OPTION_TYPE = F.OPTION_TYPE          
AND CONTRACT_DATA.AUCTIONPART = F.AUCTIONPART          
AND CONTRACT_DATA.SELL_BUY = F.SELL_BUY          
AND CONTRACT_DATA.ORDER_NO = '00000000000000000000'          
AND F.SAUDA_DATE = (SELECT SAUDA_DATE=MIN(SAUDA_DATE)          
     FROM #FOSETTLEMENT_1 F1          
     WHERE F1.PARTY_CODE = F.PARTY_CODE          
     AND F1.INST_TYPE = F.INST_TYPE          
     AND F1.SYMBOL = F.SYMBOL          
     AND F1.EXPIRYDATE = F.EXPIRYDATE          
     AND F1.STRIKE_PRICE = F.STRIKE_PRICE         AND F1.OPTION_TYPE = F.OPTION_TYPE          
     AND F1.AUCTIONPART = F.AUCTIONPART          
     AND F1.SELL_BUY = F.SELL_BUY)              
            
/* ------------------------------------------------------------------------            
   TAKING CONTRACT DATA TO THE FINAL ARCHIVAL TABLE (SUMMARISED)            
---------------------------------------------------------------------------*/            
            
INSERT INTO CONTRACT_DATA_DET            
SELECT              
        CONTRACTNO,               
  ORDER_NO,               
        ORDER_TIME=CPID,               
        TRADE_NO,               
        LEFT(CONVERT(VARCHAR,SAUDA_DATE,108),11) AS TRADETIME,               
        @SAUDA_DATE,               
        F.PARTY_CODE,               
        INST_TYPE,               
        SYMBOL,               
        LEFT(CONVERT(VARCHAR,EXPIRYDATE,106),11) AS EXPIRYDATE,               
        ISNULL(STRIKE_PRICE,0) STRIKE_PRICE,               
        OPTION_TYPE,            
  AUCTIONPART ,            
        PQTY = (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN TRADEQTY               
                ELSE 0 END),               
        SQTY = (               
        CASE               
                WHEN SELL_BUY = 2               
                THEN TRADEQTY               
                ELSE 0 END),               
        PRATE = (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN ISNULL(PRICE,0)               
                ELSE 0 END),               
        SRATE = (               
  CASE           
 WHEN SELL_BUY = 2               
                THEN ISNULL(PRICE,0)               
                ELSE 0 END),               
        PBROK =(               
        CASE               
                WHEN SELL_BUY = 1               
                THEN ISNULL((BROKAPPLIED + (               
                CASE               
                        WHEN C.SERVICE_CHRG=1               
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)               
                        ELSE 0 END )),0)               
                ELSE 0 END),               
        SBROK =(               
        CASE               
                WHEN SELL_BUY = 2               
                THEN ISNULL((BROKAPPLIED + (               
 CASE               
         WHEN C.SERVICE_CHRG=1               
                        THEN ISNULL(F.SERVICE_TAX/TRADEQTY,0)               
                        ELSE 0 END )),0)               
                ELSE 0 END),               
        PNETRATE = (               
        CASE               
                WHEN SELL_BUY =1               
                THEN ISNULL(NETRATE + (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)               
                        ELSE 0 END),0)               
                ELSE 0 END),               
        SNETRATE = (               
        CASE               
                WHEN SELL_BUY =2               
                THEN ISNULL(NETRATE - (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX/TRADEQTY),0)               
                        ELSE 0 END),0)               
                ELSE 0 END),               
        ISNULL(AMOUNT,0) AMOUNT ,               
        PAMT=(               
        CASE               
                WHEN SELL_BUY = 1               
   THEN (TRADEQTY * NETRATE) + (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX),0)               
            
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG = 0               
   THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG = 2               
                                        THEN 0               
                                        ELSE 0 END) END ) END )               
                ELSE 0 END),               
        SAMT=(               
        CASE               
                WHEN SELL_BUY = 2               
  THEN(TRADEQTY * NETRATE) - (               
                CASE               
                        WHEN C.SERVICE_CHRG = 1               
                        THEN ISNULL((F.SERVICE_TAX),0)               
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG = 0               
                                THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG = 2               
                  THEN 0               
                                        ELSE 0 END ) END ) END)               
                ELSE 0 END),               
        SELL_BUY,               
        PSERVICE_TAX= (               
        CASE               
                WHEN SELL_BUY = 1               
                THEN (               
                CASE               
                        WHEN C.SERVICE_CHRG=0               
                        THEN (F.SERVICE_TAX)               
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG=1               
                                THEN 0               
                                ELSE (               
                                CASE               
                                        WHEN C.SERVICE_CHRG=2               
                                        THEN 0 END) END) END)               
                ELSE 0 END),               
        SSERVICE_TAX= (               
    CASE               
                WHEN SELL_BUY = 2               
                THEN (               
                CASE               
      WHEN C.SERVICE_CHRG=0               
                        THEN (F.SERVICE_TAX)               
                        ELSE (               
                        CASE               
                                WHEN C.SERVICE_CHRG=1               
                                THEN 0               
                                ELSE (               
 CASE               
                                        WHEN C.SERVICE_CHRG=2               
                                        THEN 0 END) END) END)               
                ELSE 0 END),               
        BROKER_CHRG = (               
        CASE               
                WHEN BROKERNOTE = 1               
                THEN BROKER_CHRG               
                ELSE 0 END ),               
        TURN_TAX = (               
        CASE               
                WHEN TURNOVER_TAX = 1               
                THEN TURN_TAX               
                ELSE 0 END),               
        SEBI_TAX = (               
        CASE               
                WHEN SEBI_TURN_TAX = 1               
                THEN SEBI_TAX               
                ELSE 0 END),               
        OTHER_CHRG = (               
        CASE               
                WHEN C.OTHER_CHRG = 1               
                THEN F.OTHER_CHRG               
                ELSE 0 END) ,               
        INS_CHRG = (               
        CASE               
                WHEN INSURANCE_CHRG = 1               
                THEN INS_CHRG               
                ELSE 0 END ),               
        SERVICE_TAX = (               
        CASE               
                WHEN SERVICE_CHRG = 0               
                THEN SERVICE_TAX               
                ELSE 0 END ),               
        NSERTAX= (               
        CASE               
                WHEN SERVICE_CHRG = 0               
                THEN SERVICE_TAX              
                ELSE 0 END ),               
  BROKERAGE = ISNULL(TRADEQTY*BROKAPPLIED,0),               
  ORDFLG            
FROM    #FOSETTLEMENT_1 F, CONTRACT_MASTER C            
WHERE                      
  C.PARTY_CODE = F.PARTY_CODE            
  AND LEFT(SAUDA_DATE,11) = LEFT(TRADE_DATE,11)            
  AND PRINTF = '3'            
            
/* ------------------------------------------------------------------------            
     CLEANING TEMPORARY TABLES            
---------------------------------------------------------------------------*/            
            
DROP TABLE #FOSETTLEMENT            
DROP TABLE #FOSETTLEMENT_1            
            
            
/* ------------------------------------------------------------------------            
  UPDATING PROCESS TRACKER            
---------------------------------------------------------------------------*/            
            
 UPDATE             
  V2_BUSINESS_PROCESS             
 SET             
  CONTRACT = CONTRACT + 1 ,            
  LASTUPDATEDATE = GETDATE()               
 WHERE             
  LEFT(BUSINESS_DATE,11) = @SAUDA_DATE            
            
 INSERT INTO V2_PROCESS_STATUS_LOG             
 (             
  EXCHANGE,SEGMENT,BUSINESSDATE,PROCESSID,PROCESSNAME,            
  FILENAME,START_END_FLAG,PROCESSDATE,PROCESSBY,MACHINEIP            
 )            
 SELECT            
  EXCHANGE=(SELECT TOP 1 EXCHANGE FROM FOTAXES),            
  SEGMENT='FUTURES',            
  BUSINESSDATE=@SAUDA_DATE,            
  PROCESSID = 'CONTRACT',            
  PROCESSNAME = 'CONTRACT POPUP',            
  FILENAME='',            
  START_END_FLAG=1,            
  PROCESSDATE=GETDATE(),            
  PROCESSBY=@USERNAME,            
  MACHINEIP=''               
 

 DECLARE @PROCESS_TIME DATETIME,@CCNT INT
 SELECT @PROCESS_TIME =GETDATE()
 
 SELECT @CCNT=COUNT(DISTINCT PARTY_CODE) FROM FOBILLVALAN WITH(NOLOCK)
 WHERE SAUDA_DATE >=@SAUDA_DATE AND SAUDA_DATE <=@SAUDA_DATE + ' 23:59'

 EXEC [172.31.13.132].PORTFOLIO_21_22.DBO.USP_AUTO_POPULATE_CURRENCY_PORTFOLIO  
 

 INSERT INTO TBL_PORTFOILO_PROCESS_LOG (PROCESS_START_TIME,PROCESS_END_TIME,CLIENT_COUNT)
 SELECT @PROCESS_TIME,GETDATE(), @CCNT


/* ------------------------------------------------------------------------            
        END OF PROCEDURE            
---------------------------------------------------------------------------*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_NSECURFO_RTB_COUNT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PROC_NSECURFO_RTB_COUNT] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))            
            
AS  

SELECT TABLE_NAME = 'SETTLEMENT DATA RTB',count(1) AS RECORDS FROM INHOUSE_CURFO..PCNORDERDETAILS_FO_RTB WITH (NOLOCK)   
   WHERE TRADE_DATE =cast(getdate() as date)     

  
UNION ALL  
SELECT TABLE_NAME = 'STAMP DATA RTB',count(1) AS RECORDS FROM INHOUSE_CURFO..TBL_STAMP_DATA_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date)     

   UNION ALL  
SELECT TABLE_NAME = 'STT DATA RTB',count(1) AS RECORDS FROM INHOUSE_CURFO..STT_CLIENTDETAIL_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date)   

      UNION ALL  
SELECT TABLE_NAME = 'CHARGES DETAIL RTB',count(1) AS RECORDS FROM INHOUSE_CURFO..PRORDERWISEDETAILS_FO_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date)   

       UNION ALL  
SELECT TABLE_NAME = 'VALAN DATA RTB',count(1) AS RECORDS FROM INHOUSE_CURFO..FOBILLVALANDATA_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE=cast(getdate() as date)

     UNION ALL  
SELECT TABLE_NAME = 'ACCBILL RTB',count(1) AS RECORDS FROM INHOUSE_CURFO..FOACCBILLDATA_RTB WITH (NOLOCK)   
   WHERE BILLDATE=cast(getdate() as date)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_NSEFO_RTB_COUNT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PROC_NSEFO_RTB_COUNT] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))            
            
AS  

SELECT TABLE_NAME = 'SETTLEMENT DATA RTB',count(1) AS RECORDS FROM INHOUSE..PCNORDERDETAILS_FO_RTB WITH (NOLOCK)   
   WHERE TRADE_DATE =cast(getdate() as date)      
UNION ALL  
SELECT TABLE_NAME = 'SETTLEMENT DATA BO',count(1) AS RECORDS  FROM NSEFO..fosettlement WITH (NOLOCK)   
   WHERE Sauda_date> =cast(getdate() as date)
UNION ALL 
SELECT TABLE_NAME = 'STAMP DATA RTB',count(1) AS RECORDS FROM INHOUSE..TBL_STAMP_DATA_RTB WITH (NOLOCK)   
WHERE SAUDA_DATE =cast(getdate() as date) 
   UNION ALL 
SELECT TABLE_NAME = 'STAMP DATA BO',count(1) AS RECORDS FROM NSEFO..TBL_STAMP_DATA WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date) 

UNION ALL  
SELECT TABLE_NAME = 'STT DATA RTB',count(1) AS RECORDS FROM INHOUSE..STT_CLIENTDETAIL_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date)   

 UNION ALL  
SELECT TABLE_NAME = 'STT DATA BO',count(1) AS RECORDS FROM NSEFO..STT_CLIENTDETAIL WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date)   

  UNION ALL  
SELECT TABLE_NAME = 'CHARGES DETAIL RTB',count(1) AS RECORDS FROM INHOUSE..PRORDERWISEDETAILS_FO_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE =cast(getdate() as date) 
    UNION ALL  
SELECT TABLE_NAME = 'CHARGES DETAIL BO',count(1) AS RECORDS FROM NSEFO..Charges_Detail WITH (NOLOCK)   
   WHERE CD_Sauda_Date =cast(getdate() as date)   
   
       UNION ALL  
SELECT TABLE_NAME = 'VALAN DATA RTB',count(1) AS RECORDS FROM INHOUSE..FOBILLVALANDATA_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE=cast(getdate() as date)
     UNION ALL  
SELECT TABLE_NAME = 'VALAN DATA BO',count(1) AS RECORDS FROM NSEFO..FoBillValan WITH (NOLOCK)   
   WHERE SAUDA_DATE>=cast(getdate() as date)

     UNION ALL  
SELECT TABLE_NAME = 'ACCBILL RTB',count(1) AS RECORDS FROM INHOUSE..FOACCBILLDATA_RTB WITH (NOLOCK)   
   WHERE BILLDATE=cast(getdate() as date)
     UNION ALL  
SELECT TABLE_NAME = 'ACCBILL BO',count(1) AS RECORDS FROM NSEFO..foaccbill WITH (NOLOCK)   
   WHERE BILLDATE>=cast(getdate() as date)

    UNION ALL  
SELECT TABLE_NAME = 'IPFT RTB',count(1) AS RECORDS FROM INHOUSE..TBL_ADDITIONAL_TAX_DATA_RTB WITH (NOLOCK)   
   WHERE SAUDA_DATE=cast(getdate() as date)
    UNION ALL  
	SELECT TABLE_NAME = 'IPFT BO',count(1) AS RECORDS FROM NSEFO..TBL_ADDITIONAL_TAX_DATA WITH (NOLOCK)   
   WHERE SAUDA_DATE=cast(getdate() as date)

   UNION ALL

--SELECT TABLE_NAME = 'MTF PLEDGE COUNT' ,Count(1) AS RECORDS FROM ANGELDEMAT.MSAJAG.DBO.TBL_POA_PLD_ADNL WITH (NOLOCK)  
--WHERE TRANSDATE=CONVERT(VARCHAR(11),@RUNDATE,120) AND SUCCESSFLAG ='Y' and Sett_no<>'2000000'

SELECT TABLE_NAME = 'MTF PLEDGE COUNT' ,Count(1) AS RECORDS FROM ANGELDEMAT.MSAJAG.DBO.TBL_POA_PLD_ADNL WITH (NOLOCK)  
WHERE CONVERT(VARCHAR(11) , TRANSDATE , 120 ) =CONVERT(datetime,@RUNDATE) AND SUCCESSFLAG ='Y' and Sett_no<>'2000000'

 UNION ALL


SELECT TABLE_NAME = 'MTF PURCHASE COUNT' ,Count(1) AS RECORDS FROM ANAND1.MTFTRADE.DBO.MTF_PURCHASE_DATA WITH (NOLOCK)  
WHERE TRADEDATE=CONVERT(VARCHAR(11),@RUNDATE,120)

 UNION ALL

SELECT TABLE_NAME = 'MTF_bill' ,Count(1) AS RECORDS FROM ANAND1.MTFTRADE.DBO.LEDGER WITH (NOLOCK)  
WHERE VDT=CONVERT(VARCHAR(11),@RUNDATE,120) AND VTYP=35
 UNION ALL

SELECT TABLE_NAME = 'Cash_bill' ,Count(1) AS RECORDS FROM ANAND1.ACCOUNT.DBO.LEDGER WITH (NOLOCK)  
WHERE VDT=CONVERT(VARCHAR(11),@RUNDATE,120) AND VTYP=35

UNION ALL

SELECT TABLE_NAME = 'MTF_JV' ,Count(1) AS RECORDS FROM ANAND1.MTFTRADE.DBO.LEDGER WITH (NOLOCK)  
WHERE VDT=CONVERT(VARCHAR(11),@RUNDATE,120) AND VTYP=6
UNION ALL

SELECT TABLE_NAME = 'CASH_JV' ,SUM(CNT) AS RECORDS FROM (
SELECT CNT=COUNT(1) FROM  ANAND1.ACCOUNT.DBO.LEDGER WHERE VDT =CONVERT(VARCHAR(11),@RUNDATE,120) AND VTYP=6
UNION ALL
SELECT CNT=COUNT(1) FROM  ANGELFO.ACCOUNTFO.DBO.LEDGER WHERE VDT =CONVERT(VARCHAR(11),@RUNDATE,120) AND VTYP=6 )A

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------
/*

Proc Created by Amit kumar Bhatta on 27th feb 2013 for rebuilding the indexes of database passed as paremeter for the proc.

*/
create procedure [dbo].[rebuild_index]
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
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

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
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        IF @frag < 30.0
            SET @command = N'use '+@database + N' ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
        IF @frag >= 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
        IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
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
-- PROCEDURE dbo.sp_AddEditScrip_Execute
-- --------------------------------------------------
CREATE PROC [dbo].[sp_AddEditScrip_Execute]
@strSQL VarChar(8000)
AS
SET NOCOUNT ON;
-- Print @strSQL
 Exec (@strSQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FO_VALAN_CHECK
-- --------------------------------------------------

CREATE PROC USP_FO_VALAN_CHECK (@DATE VARCHAR(20))

AS    

----DECLARE @DATE VARCHAR(20)='2024-01-03'
BEGIN

 SELECT SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE 0 END) - SUM(CASE WHEN SELL_BUY = 2 THEN AMOUNT ELSE 0 END) AS 'ROUNDING OFF DIFFERENCE'
	 FROM  (
	SELECT * FROM INHOUSE.DBO.FOACCBILLDATA_RTB (NOLOCK) WHERE BILLDATE  = @DATE  AND BRANCHCD <> 'ZZZ' 
				AND PARTY_CODE >= 'A' AND PARTY_CODE NOT LIKE '%_%ST'
		UNION ALL
	SELECT *  FROM INHOUSE.DBO.FOACCBILLDATA_RTB (NOLOCK) WHERE BILLDATE  = @DATE AND BRANCHCD = 'ZZZ'
		)X

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RDB_NSEFO_MASTER_SYNC_BKP_SRE-30317
-- --------------------------------------------------


CREATE PROC [dbo].[USP_RDB_NSEFO_MASTER_SYNC_BKP_SRE-30317]  (@SAUDA_DATE AS DATETIME) 
 
/*
BUILD BY : SIVA KUMAR
DEPLOYED BY: DHARMESH MISTRY
CREATED ON : 13/04/2023
APPROVED BY : RAHUL SHAH
*/


AS BEGIN  
 
DELETE FROM FOSETTLEMENT WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE + ' 23:59'
		--- AND AUCTIONPART = ''
   
-- DROP TABLE #FOSETTLEMENT
 
SELECT  CONTRACTNO =  CONTRACTNO_SEG ,BILLNO = CONVERT(INT,LOT_SIZE),TRADE_NO,PARTY_CODE,INST_TYPE,
SYMBOL = LEFT(SCRIP_CD,12),SEC_NAME = SECURITY_NAME,EXPIRYDATE =  REPLACE(EXPIRYDATE,'.0000000','') +' 23:59',STRIKE_PRICE = CONVERT(MONEY,STRIKE_PRICE),
OPTION_TYPE = (CASE WHEN OPTION_TYPE ='XX' THEN '' ELSE OPTION_TYPE END) ,  USER_ID = USERID ,PRO_CLI = 1,O_C_FLAG = '10',C_U_FLAG = 'COVER',
TRADEQTY = QTY,AUCTIONPART ,MARKETTYPE = '1',SERIES = '0',ORDER_NO,PRICE = CONVERT(MONEY,MARKET_RATE),SAUDA_DATE = REPLACE(TRADE_TIME,'.0000000','') ,
TABLE_NO ,LINE_NO = CONVERT(INT,LINE_NO),VAL_PERC,NORMAL = CONVERT(MONEY,NORMAL),DAY_PUC = CONVERT(MONEY,DAY_PUC),DAY_SALES = CONVERT(MONEY,DAY_SALES),
SETT_PURCH = CONVERT(MONEY,SETT_PURCH),SETT_SALES = CONVERT(MONEY,SETT_SALES),SELL_BUY = CONVERT(INT,BUYSELL),
SETTFLAG = CONVERT(INT,(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL + 1 ELSE BUYSELL + 1 END)),BROKAPPLIED = CONVERT(MONEY,NET_RATE_PER_UNIT),
NETRATE = CONVERT(MONEY,(CASE WHEN BUYSELL = 1 THEN MARKET_RATE + NET_RATE_PER_UNIT ELSE MARKET_RATE - NET_RATE_PER_UNIT END)),
AMOUNT = CONVERT(MONEY,QTY) * CONVERT(MONEY,MARKET_RATE),INS_CHRG = CONVERT(MONEY,STT),TURN_TAX = CONVERT(MONEY,TURN_TAX),OTHER_CHRG = '0',
SEBI_TAX = CONVERT(MONEY,SEBIFEE),BROKER_CHRG = CONVERT(MONEY,STAMPDUTY),SERVICE_TAX = CONVERT(MONEY,SERVICE_TAX),
TRADE_AMOUNT = CONVERT(MONEY,QTY) * CONVERT(MONEY,MARKET_RATE),BILLFLAG = CONVERT(INT,(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL + 1 ELSE BUYSELL + 1 END)),
SETT_NO = '',NBROKAPP = CONVERT(MONEY,NET_RATE_PER_UNIT),NSERTAX = CONVERT(MONEY,SERVICE_TAX),
N_NETRATE = CONVERT(MONEY,(CASE WHEN BUYSELL = 1 THEN MARKET_RATE + NET_RATE_PER_UNIT ELSE MARKET_RATE - NET_RATE_PER_UNIT END)),SETT_TYPE = 'F',
 CL_RATE = 0,PARTICIPANTCODE = MEMID,STATUS = '11',CPID = REPLACE(CONVERT(TIME,REPLACE(ORDER_TIME,'.0000000','') ),'.0000000','') ,
INSTRUMENT = 1,BOOKTYPE = 1,BRANCH_ID = PARTY_CODE,TMARK = 0,SCHEME = 3,DUMMY1 = 0,DUMMY2 = CONVERT(INT,MARKET_RATE),RESERVED1 = 0,RESERVED2 = 0 
INTO #FOSETTLEMENT
		FROM INHOUSE..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) 
			WHERE TRADE_DATE = @SAUDA_DATE 

CREATE INDEX #P ON #FOSETTLEMENT(PARTY_CODE)

INSERT INTO FOSETTLEMENT 
SELECT * FROM #FOSETTLEMENT ORDER BY PARTY_CODE

  DELETE FOTRADE_CTCLID WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE+ ' 23:59'

INSERT INTO FOTRADE_CTCLID
SELECT DISTINCT REPLACE(ORDER_TIME,'.0000000','') ,ORDER_NO,INST_TYPE,
LEFT(SCRIP_CD,12),EXPIRYDATE =  REPLACE(EXPIRYDATE,'.0000000','') +' 23:59',STRIKE_PRICE,
OPTION_TYPE,CTCLID,GETDATE()
FROM INHOUSE..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE
 

   

  -- DECLARE @EXPDATE DATETIME
  --SET @EXPDATE = ISNULL((SELECT  TOP 1 MATURITYDATE FROM FOSCRIP2 (NOLOCK) WHERE MATURITYDATE BETWEEN @SAUDA_DATE AND @SAUDA_DATE + ' 23:59'),'')
  -- IF CONVERT(VARCHAR(11),@EXPDATE,109) <> @SAUDA_DATE 

  -- BEGIN 

   

DELETE TBL_STAMP_DATA WHERE SAUDA_DATE = @SAUDA_DATE

INSERT INTO TBL_STAMP_DATA
SELECT  SAUDA_DATE,CONTRACTNO = CONTRACTNO ,PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE = CONVERT(DATETIME,EXPIRYDATE) + ' 23:59:59',
STRIKE_PRICE,OPTION_TYPE,BUYQTY,SELLQTY,BUYAVGRATE,SELLAVGRATE,BUYSTAMP,SELLSTAMP,TOTALSTAMP,L_STATE,LASTRUNDATE = GETDATE() 
		FROM INHOUSE..TBL_STAMP_DATA_RTB WITH (NOLOCK)
				WHERE SAUDA_DATE = @SAUDA_DATE   
 

DELETE STT_CLIENTDETAIL WHERE  SAUDA_DATE= @SAUDA_DATE  

INSERT INTO STT_CLIENTDETAIL
SELECT RECTYPE,SAUDA_DATE,CONTRACTNO = CONTRACTNO,PARTY_CODE,INST_TYPE,OPTION_TYPE,SYMBOL,EXPIRYDATE,
STRIKE_PRICE,TRDPRICE,PQTYTRD,PAMTTRD,PSTTTRD,SQTYTRD,SAMTTRD,SSTTTRD,TOTALSTT 
	FROM INHOUSE..STT_CLIENTDETAIL_RTB WITH (NOLOCK)
		WHERE SAUDA_DATE = @SAUDA_DATE
  
   
DELETE FROM CHARGES_DETAIL WHERE CD_SAUDA_DATE = @SAUDA_DATE --AND CD_AUCTIONPART = ''
 
INSERT INTO CHARGES_DETAIL  
	SELECT CD_PARTY_CODE = PARTY_CODE,CD_SAUDA_DATE = SAUDA_DATE,CD_CONTRACT_NO =  CONTRACT_NO ,CD_TRADE_NO = TRADE_NO,
	CD_ORDER_NO = ORDER_NO,
CD_INST_TYPE = INST_TYPE,CD_SYMBOL = SYMBOL,CD_EXPIRY_DATE = EXPIRY_DATE +' 23:59',CD_OPTION_TYPE = 
	(CASE WHEN OPTION_TYPE ='XX' THEN ''  ELSE OPTION_TYPE END),CD_STRIKE_PRICE = STRIKE_PRICE,CD_AUCTIONPART=AUCTIONPART,CD_MARKETLOT = MARKETLOT,
CD_SCHEME_ID = SCHEME_ID,CD_COMPUTATIONLEVEL = COMPUTATIONLEVEL,CD_COMPUTATIONON = COMPUTATIONON,CD_COMPUTATIONTYPE = COMPUTATIONTYPE,CD_BUYRATE = BUYRATE,
CD_SELLRATE = SELLRATE,CD_TOT_BUYQTY = TOT_BUYQTY,CD_TOT_SELLQTY = TOT_SELLQTY,CD_TOT_BUYTURNOVER = TOT_BUYTURNOVER,CD_TOT_SELLTURNOVER = TOT_SELLTURNOVER,
CD_TOT_BUYTURNOVER_ROUNDED = TOT_BUYTURNOVER_ROUNDED,CD_TOT_SELLTURNOVER_ROUNDED = TOT_SELLTURNOVER_ROUNDED,CD_TOT_TURNOVER = TOT_TURNOVER,
CD_TOT_TURNOVER_ROUNDED = TOT_TURNOVER_ROUNDED,CD_TOT_LOT = TOT_LOT,CD_TOT_RES_TURNOVER = TOT_RES_TURNOVER,
CD_TOT_RES_TURNOVER_ROUNDED = TOT_RES_TURNOVER_ROUNDED,CD_TOT_RES_LOT = 0,CD_TOT_BUYBROK = TOT_BUYBROK,CD_TOT_SELLBROK = TOT_SELLBROK,
CD_TOT_BROK = TOT_BROK,CD_TOT_BUYSERTAX = TOT_BUYSERTAX,CD_TOT_SELLSERTAX = TOT_SELLSERTAX,CD_TOT_SERTAX = TOT_SERTAX,CD_TOT_STT = TOT_STT,
CD_TOT_TURN_TAX = TOT_TURN_TAX,CD_TOT_OTHER_CHRG = 0,CD_TOT_SEBI_TAX = 0,CD_TOT_STAMPDUTY = 0,CD_EXCH_BUYRATE = EXCH_BUYRATE,
CD_EXCH_SELLRATE = EXCH_SELLRATE,CD_TIMESTAMP = GETDATE() 
		FROM INHOUSE..PRORDERWISEDETAILS_FO_RTB WITH (NOLOCK)
			WHERE SAUDA_DATE = @SAUDA_DATE AND SYMBOL NOT LIKE '%BROK%'  

			 
  
 
INSERT INTO CHARGES_DETAIL  
SELECT  CD_PARTY_CODE = PARTY_CODE,CD_SAUDA_DATE = SAUDA_DATE,CD_CONTRACT_NO = '0',CD_TRADE_NO = TRADE_NO,CD_ORDER_NO = ORDER_NO,
CD_INST_TYPE = INST_TYPE,CD_SYMBOL = 'BROKERAGE',CD_EXPIRY_DATE = EXPIRY_DATE,CD_OPTION_TYPE = OPTION_TYPE,CD_STRIKE_PRICE = STRIKE_PRICE,
CD_AUCTIONPART = '',CD_MARKETLOT = MARKETLOT,CD_SCHEME_ID = SCHEME_ID,CD_COMPUTATIONLEVEL = COMPUTATIONLEVEL,CD_COMPUTATIONON = COMPUTATIONON,
CD_COMPUTATIONTYPE = COMPUTATIONTYPE,CD_BUYRATE = BUYRATE,CD_SELLRATE = SELLRATE,CD_TOT_BUYQTY = TOT_BUYQTY,CD_TOT_SELLQTY = TOT_SELLQTY,
CD_TOT_BUYTURNOVER = TOT_BUYTURNOVER,CD_TOT_SELLTURNOVER = TOT_SELLTURNOVER,CD_TOT_BUYTURNOVER_ROUNDED = TOT_BUYTURNOVER_ROUNDED,
CD_TOT_SELLTURNOVER_ROUNDED = TOT_SELLTURNOVER_ROUNDED,CD_TOT_TURNOVER = TOT_TURNOVER,CD_TOT_TURNOVER_ROUNDED = TOT_TURNOVER_ROUNDED,
CD_TOT_LOT = TOT_LOT,CD_TOT_RES_TURNOVER = TOT_RES_TURNOVER,CD_TOT_RES_TURNOVER_ROUNDED = TOT_RES_TURNOVER_ROUNDED,CD_TOT_RES_LOT = 0,
CD_TOT_BUYBROK = TOT_BUYBROK,CD_TOT_SELLBROK = TOT_SELLBROK,CD_TOT_BROK = TOT_BROK,CD_TOT_BUYSERTAX = TOT_BUYSERTAX,CD_TOT_SELLSERTAX = TOT_SELLSERTAX,
CD_TOT_SERTAX = TOT_SERTAX,CD_TOT_STT = TOT_STT,CD_TOT_TURN_TAX = TOT_TURN_TAX,CD_TOT_OTHER_CHRG = 0,CD_TOT_SEBI_TAX = 0,CD_TOT_STAMPDUTY = 0,
CD_EXCH_BUYRATE = EXCH_BUYRATE,CD_EXCH_SELLRATE = EXCH_SELLRATE,CD_TIMESTAMP = GETDATE()  
	FROM INHOUSE..PRORDERWISEDETAILS_FO_RTB P WITH (NOLOCK)
		WHERE SAUDA_DATE = @SAUDA_DATE  AND SYMBOL LIKE '%BROK%'  

/* Billing Process Start*/ 

SELECT DISTINCT PARTY_CODE INTO #FOPARTY  FROM INHOUSE.DBO.FOBILLVALANDATA_RTB WHERE SAUDA_DATE>= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE + ' 23:59'  
CREATE INDEX #P ON #FOPARTY(PARTY_CODE)

SELECT DISTINCT CL_CODE,Email INTO #FOClient  FROM CLIENT1 WHERE EXISTS (SELECT PARTY_CODE FROM #FOPARTY WHERE CL_CODE=PARTY_CODE )
CREATE INDEX #P ON #FOClient(CL_CODE)

 SELECT  PARTY_CODE,	PARTY_NAME,	CLIENT_TYPE,	BILLNO,	CONTRACTNO,	INST_TYPE,	SYMBOL,
 EXPIRYDATE=CONVERT(DATETIME,CONVERT(VARCHAR(11),EXPIRYDATE)+' 23:59') ,	OPTION_TYPE,	STRIKE_PRICE,	AUCTIONPART,	
 MATURITYDATE=CONVERT(DATETIME,CONVERT(VARCHAR(11),MATURITYDATE)+' 23:59'),	
 SAUDA_DATE=CONVERT(DATETIME,CONVERT(VARCHAR(11),SAUDA_DATE)+' 23:59'),	ISIN,	PQTY,	SQTY,	PRATE,	SRATE,	PAMT,	SAMT,
 PBROKAMT,	SBROKAMT,	PBILLAMT,	SBILLAMT,	CL_RATE,	CL_CHRG,	EXCL_CHRG,	SERVICE_TAX,	EXSER_TAX,	
 INEXSERFLAG,	SEBI_TAX,	TURN_TAX	,BROKER_NOTE,	INS_CHRG,	OTHER_CHRG,	TRADETYPE,	PARTICIPANTCODE	,TERMINAL_ID,	FAMILY,	FAMILYNAME,	TRADER,	BRANCH_CODE,	SUB_BROKER,
 STATUSNAME,	EXCHANGE,	SEGMENT,	MEMBERTYPE,	COMPANYNAME	,REGION	,UPDATEDATE	,EMAIL= C.EMAIL,	DUMMY2,	DUMMY3,	DUMMY4,	DUMMY5	,CMCLOSING,	TRACK	,AREA INTO #FOBILLVALAN
 FROM INHOUSE.DBO.FOBILLVALANDATA_RTB  B
 LEFT OUTER JOIN #FOCLIENT C ON PARTY_CODE=CL_CODE  
 WHERE SAUDA_DATE>= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE + ' 23:59'



DELETE FROM FOBILLVALAN WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE + ' 23:59'
 
 INSERT INTO FOBILLVALAN
 SELECT * FROM #FOBILLVALAN

 
 DELETE FROM FOACCBILL WHERE BILLDATE >= @SAUDA_DATE AND BILLDATE <= @SAUDA_DATE + ' 23:59'
 
 INSERT INTO FOACCBILL
 SELECT *
 FROM INHOUSE.DBO.FOACCBILLDATA_RTB WHERE BILLDATE>= @SAUDA_DATE AND BILLDATE <= @SAUDA_DATE + ' 23:59'

 
UPDATE V SET BILLING =BILLING+1 FROM V2_BUSINESS_PROCESS  V WHERE BUSINESS_DATE =@SAUDA_DATE 

/* Billing Process End*/ 
  
 --END

DECLARE @CONTNO VARCHAR(10)
SELECT @CONTNO = MAX(CONVERT(BIGINT,CONTRACTNO)) FROM #FOSETTLEMENT WITH (NOLOCK) 
	WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 

UPDATE CONTGEN SET CONTRACTNO = @CONTNO 
	WHERE @SAUDA_DATE BETWEEN START_DATE AND END_DATE  
 
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RTB_NSECURFO_MASTER_SYNC_BKP_27JUNE2024
-- --------------------------------------------------

CREATE PROC [dbo].[USP_RTB_NSECURFO_MASTER_SYNC_BKP_27JUNE2024]  
(@SAUDA_DATE AS DATETIME)  

--Create backup for SRE-27122
 -- USP_RTB_NSECURFO_MASTER_SYNC '2023-05-16'


/*
BUILD BY : SIVA KUMAR
DEPLOYED BY: DHARMESH MISTRY
CREATED ON : 16/05/2023
APPROVED BY : RAHUL SHAH

*/

AS BEGIN  
 
DELETE FROM FOSETTLEMENT WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE +' 23:59'  
 

INSERT INTO  FOSETTLEMENT  
 SELECT -- SRNO = ROW_NUMBER() OVER(ORDER BY PARTY_CODE), 
 CONTRACTNO = LEFT(CONTRACTNO_SEG,14),BILLNO = CONVERT(INT,LOT_SIZE),TRADE_NO,PARTY_CODE,INST_TYPE,
  SYMBOL = SCRIP_CD,SEC_NAME = SECURITY_NAME, EXPIRYDATE = CONVERT(SMALLDATETIME, REPLACE(EXPIRYDATE,'.0000000','') +' 23:59'),
  STRIKE_PRICE = CONVERT(MONEY,STRIKE_PRICE),
 OPTION_TYPE = (CASE WHEN OPTION_TYPE ='XX' THEN '' ELSE OPTION_TYPE END), USER_ID = USERID ,PRO_CLI = 1,O_C_FLAG = 10,C_U_FLAG = 'COVER',TRADEQTY = QTY,
AUCTIONPART = '',MARKETTYPE = '1',SERIES = 0 ,ORDER_NO,PRICE = CONVERT(MONEY,MARKET_RATE),
SAUDA_DATE =  CONVERT(DATETIME,REPLACE(TRADE_TIME,'.0000000','')) ,TABLE_NO,LINE_NO = CONVERT(INT,LINE_NO),
VAL_PERC,NORMAL = CONVERT(MONEY,NORMAL),DAY_PUC = CONVERT(MONEY,DAY_PUC),DAY_SALES = CONVERT(MONEY,DAY_SALES),
SETT_PURCH = CONVERT(MONEY,SETT_PURCH),SETT_SALES = CONVERT(MONEY,SETT_SALES),SELL_BUY = CONVERT(INT,BUYSELL),
SETTFLAG = CONVERT(INT,(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL + 1 ELSE BUYSELL + 3 END)),BROKAPPLIED = CONVERT(MONEY,NET_RATE_PER_UNIT),
NETRATE = CONVERT(MONEY,(CASE WHEN BUYSELL = 1 THEN MARKET_RATE+NET_RATE_PER_UNIT ELSE MARKET_RATE-NET_RATE_PER_UNIT END)),
AMOUNT = CONVERT(MONEY,QTY)*CONVERT(MONEY,MARKET_RATE),INS_CHRG = CONVERT(MONEY,STT),TURN_TAX = CONVERT(MONEY,TURN_TAX),OTHER_CHRG = '0',
SEBI_TAX = CONVERT(MONEY,SEBIFEE),BROKER_CHRG = CONVERT(MONEY,STAMPDUTY),SERVICE_TAX = CONVERT(MONEY,SERVICE_TAX),
TRADE_AMOUNT = CONVERT(MONEY,QTY)*CONVERT(MONEY,MARKET_RATE),BILLFLAG = CONVERT(INT,(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL + 1 ELSE BUYSELL + 3 END)),
SETT_NO = 0,NBROKAPP = CONVERT(MONEY,NET_RATE_PER_UNIT),NSERTAX = CONVERT(MONEY,SERVICE_TAX),
N_NETRATE = CONVERT(MONEY,(CASE WHEN BUYSELL = 1 THEN MARKET_RATE + NET_RATE_PER_UNIT ELSE MARKET_RATE - NET_RATE_PER_UNIT END)),
SETT_TYPE = 'F',CL_RATE = CONVERT(MONEY,CL_RATE) ,PARTICIPANTCODE = MEMID,STATUS = '11',
CPID = CONVERT(VARCHAR(20),REPLACE(CONVERT(TIME,REPLACE(ORDER_TIME,'.0000000','') ),'.0000000','')),INSTRUMENT = ISNULL(DENOMINATOR,'0'),
BOOKTYPE = LEFT(CONVERT(VARCHAR,ISNULL(NUMERATOR,'0')),5),BRANCH_ID = PARTY_CODE,TMARK = 0,SCHEME = 3,DUMMY1 = 0,DUMMY2 = CONVERT(INT,MARKET_RATE),
RESERVED1 = 0,RESERVED2 = 0 
FROM INHOUSE_CURFO..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE
ORDER BY PARTY_CODE

SELECT * INTO #FOSETT 
FROM INHOUSE_CURFO..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE
 ORDER BY PARTY_CODE

  DELETE FOTRADE_CTCLID WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE+ ' 23:59'

INSERT INTO FOTRADE_CTCLID
SELECT DISTINCT CONVERT(DATETIME,REPLACE(ORDER_TIME,'.0000000','')) ,ORDER_NO,INST_TYPE,
LEFT(SCRIP_CD,12),EXPIRYDATE = CONVERT(SMALLDATETIME, REPLACE(EXPIRYDATE,'.0000000','') +' 23:59'),STRIKE_PRICE,
OPTION_TYPE,CTCLID,GETDATE()
FROM INHOUSE_CURFO..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE

   
DELETE TBL_STAMP_DATA WHERE SAUDA_DATE= @SAUDA_DATE

INSERT INTO TBL_STAMP_DATA
SELECT  SAUDA_DATE,CONTRACTNO,PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE = CONVERT(DATETIME,EXPIRYDATE)+' 23:59:59',STRIKE_PRICE,OPTION_TYPE,BUYQTY,SELLQTY,
BUYAVGRATE,SELLAVGRATE,BUYSTAMP,SELLSTAMP,TOTALSTAMP,L_STATE,LASTRUNDATE = GETDATE() 
FROM INHOUSE_CURFO..TBL_STAMP_DATA_RTB WHERE SAUDA_DATE = @SAUDA_DATE   
ORDER BY PARTY_CODE
 

--DELETE STT_CLIENTDETAIL WHERE  SAUDA_DATE= @SAUDA_DATE  

--INSERT INTO  STT_CLIENTDETAIL
--SELECT RECTYPE,SAUDA_DATE,CONTRACTNO,PARTY_CODE,INST_TYPE,OPTION_TYPE,SYMBOL,EXPIRYDATE,
--STRIKE_PRICE,TRDPRICE,PQTYTRD,PAMTTRD,PSTTTRD,SQTYTRD,SAMTTRD,SSTTTRD,TOTALSTT 
--FROM INHOUSE_CURFO..STT_CLIENTDETAIL_RTB WHERE  SAUDA_DATE= @SAUDA_DATE
  
   
DELETE FROM CHARGES_DETAIL WHERE CD_SAUDA_DATE = @SAUDA_DATE  
 
INSERT INTO CHARGES_DETAIL  
SELECT CD_PARTY_CODE = PARTY_CODE,CD_SAUDA_DATE = SAUDA_DATE,CD_CONTRACT_NO = CONTRACT_NO,CD_TRADE_NO = TRADE_NO,CD_ORDER_NO = ORDER_NO,
CD_INST_TYPE = INST_TYPE,
CD_SYMBOL = SYMBOL,CD_EXPIRY_DATE = EXPIRY_DATE +' 23:59',CD_OPTION_TYPE = (CASE WHEN OPTION_TYPE = 'XX' THEN '' ELSE OPTION_TYPE END),
CD_STRIKE_PRICE = STRIKE_PRICE,CD_AUCTIONPART = '',CD_MARKETLOT = MARKETLOT,CD_SCHEME_ID = SCHEME_ID,CD_COMPUTATIONLEVEL = COMPUTATIONLEVEL,
CD_COMPUTATIONON = COMPUTATIONON,CD_COMPUTATIONTYPE = COMPUTATIONTYPE,CD_BUYRATE = BUYRATE,CD_SELLRATE = SELLRATE,CD_TOT_BUYQTY = TOT_BUYQTY,
CD_TOT_SELLQTY = TOT_SELLQTY,CD_TOT_BUYTURNOVER = TOT_BUYTURNOVER,CD_TOT_SELLTURNOVER = TOT_SELLTURNOVER,CD_TOT_BUYTURNOVER_ROUNDED = TOT_BUYTURNOVER_ROUNDED,
CD_TOT_SELLTURNOVER_ROUNDED = TOT_SELLTURNOVER_ROUNDED,CD_TOT_TURNOVER = TOT_TURNOVER,CD_TOT_TURNOVER_ROUNDED = TOT_TURNOVER_ROUNDED,CD_TOT_LOT = TOT_LOT,
CD_TOT_RES_TURNOVER = TOT_RES_TURNOVER,CD_TOT_RES_TURNOVER_ROUNDED = TOT_RES_TURNOVER_ROUNDED,CD_TOT_RES_LOT = 0,CD_TOT_BUYBROK = TOT_BUYBROK,
CD_TOT_SELLBROK = TOT_SELLBROK,CD_TOT_BROK = TOT_BROK,CD_TOT_BUYSERTAX = TOT_BUYSERTAX,CD_TOT_SELLSERTAX = TOT_SELLSERTAX,CD_TOT_SERTAX = TOT_SERTAX,
CD_TOT_STT = TOT_STT,CD_TOT_TURN_TAX = TOT_TURN_TAX,CD_TOT_OTHER_CHRG = 0,CD_TOT_SEBI_TAX = 0,CD_TOT_STAMPDUTY = 0,CD_EXCH_BUYRATE = EXCH_BUYRATE,
CD_EXCH_SELLRATE = EXCH_SELLRATE,CD_TIMESTAMP = GETDATE() 
FROM INHOUSE_CURFO..PRORDERWISEDETAILS_FO_RTB WHERE SAUDA_DATE =@SAUDA_DATE AND SYMBOL NOT LIKE '%BROK%' 

  
 
INSERT INTO CHARGES_DETAIL  
SELECT  CD_PARTY_CODE = PARTY_CODE,CD_SAUDA_DATE = SAUDA_DATE,CD_CONTRACT_NO = CONTRACT_NO,CD_TRADE_NO = TRADE_NO,CD_ORDER_NO = ORDER_NO,
CD_INST_TYPE = INST_TYPE,CD_SYMBOL = 'BROKERAGE',CD_EXPIRY_DATE = EXPIRY_DATE,CD_OPTION_TYPE = OPTION_TYPE,CD_STRIKE_PRICE = STRIKE_PRICE,
CD_AUCTIONPART = '',CD_MARKETLOT = MARKETLOT,CD_SCHEME_ID = SCHEME_ID,CD_COMPUTATIONLEVEL = COMPUTATIONLEVEL,CD_COMPUTATIONON = COMPUTATIONON,
CD_COMPUTATIONTYPE = COMPUTATIONTYPE,CD_BUYRATE = BUYRATE,CD_SELLRATE = SELLRATE,CD_TOT_BUYQTY = TOT_BUYQTY,CD_TOT_SELLQTY = TOT_SELLQTY,
CD_TOT_BUYTURNOVER = TOT_BUYTURNOVER,CD_TOT_SELLTURNOVER = TOT_SELLTURNOVER,CD_TOT_BUYTURNOVER_ROUNDED = TOT_BUYTURNOVER_ROUNDED,
CD_TOT_SELLTURNOVER_ROUNDED = TOT_SELLTURNOVER_ROUNDED,CD_TOT_TURNOVER = TOT_TURNOVER,CD_TOT_TURNOVER_ROUNDED = TOT_TURNOVER_ROUNDED,
CD_TOT_LOT = TOT_LOT,CD_TOT_RES_TURNOVER = TOT_RES_TURNOVER,CD_TOT_RES_TURNOVER_ROUNDED=TOT_RES_TURNOVER_ROUNDED,CD_TOT_RES_LOT=0,
CD_TOT_BUYBROK = TOT_BUYBROK,CD_TOT_SELLBROK = TOT_SELLBROK,CD_TOT_BROK = TOT_BROK,CD_TOT_BUYSERTAX = TOT_BUYSERTAX,CD_TOT_SELLSERTAX = TOT_SELLSERTAX,
CD_TOT_SERTAX = TOT_SERTAX,CD_TOT_STT = TOT_STT,CD_TOT_TURN_TAX = TOT_TURN_TAX,CD_TOT_OTHER_CHRG = 0,CD_TOT_SEBI_TAX = 0,CD_TOT_STAMPDUTY = 0,
CD_EXCH_BUYRATE = EXCH_BUYRATE,CD_EXCH_SELLRATE = EXCH_SELLRATE,CD_TIMESTAMP = GETDATE()  
 FROM INHOUSE_CURFO..PRORDERWISEDETAILS_FO_RTB P WHERE SAUDA_DATE = @SAUDA_DATE  AND SYMBOL LIKE '%BROK%'  
  
 


DECLARE @CONTNO VARCHAR(10)
SELECT @CONTNO= MAX(CONVERT(BIGINT,CONTRACTNO_SEG)) FROM #FOSETT (NOLOCK)

IF ISNULL(@CONTNO,0) <> 0 
 BEGIN 

UPDATE CONTGEN SET CONTRACTNO= @CONTNO WHERE @SAUDA_DATE BETWEEN START_DATE AND END_DATE 

END

  INSERT INTO INHOUSE_CURFO..TBL_RTB_NSX_UPD
	SELECT @SAUDA_DATE,GETDATE()
  
END

GO

-- --------------------------------------------------
-- TABLE dbo.abc
-- --------------------------------------------------
CREATE TABLE [dbo].[abc]
(
    [fld1] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220109
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220109]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220202
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220202]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220202_221000823543
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220202_221000823543]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_BKP_20220207
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_BKP_20220207]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220209
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220209]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220209_221000846727
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220209_221000846727]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220211
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220211]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220214_221000861091
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220214_221000861091]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220516
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220516]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_bkp_20220518
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_bkp_20220518]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_BKP_20220714
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_BKP_20220714]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL1_BKP_20220714_222000038146
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL1_BKP_20220714_222000038146]
(
    [VNO] VARCHAR(12) NOT NULL,
    [VTYPE] SMALLINT NOT NULL,
    [BOOKTYPE] VARCHAR(2) NOT NULL,
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [VDT] NUMERIC(8, 0) NOT NULL,
    [FINYEAR_ID] INT NOT NULL,
    [MKCKFLAG] TINYINT NULL,
    [VNO_MK] VARCHAR(12) NULL,
    [SNO] BIGINT NOT NULL,
    [REMARK] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [POSTED_ON] DATETIME NOT NULL,
    [POSTED_BY] VARCHAR(50) NULL,
    [CHECKED_ON] DATETIME NULL,
    [CHECKED_BY] VARCHAR(50) NULL,
    [ENTRY_AMT] MONEY NOT NULL,
    [SOURCE_MODULE] VARCHAR(100) NOT NULL,
    [ENTRY_TYPE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [BILL_NO] INT NULL,
    [SELL_BUY] TINYINT NULL,
    [LOCK_FLAG] BIT NOT NULL,
    [DISPLAY_FLAG] BIT NOT NULL,
    [RESERVED_1] VARCHAR(20) NULL,
    [RESERVED_2] VARCHAR(20) NULL,
    [RESERVED_3] VARCHAR(20) NULL,
    [RESERVED_4] VARCHAR(20) NULL,
    [RESERVED_5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_bkp_20220109
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_bkp_20220109]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_bkp_20220202
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_bkp_20220202]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_bkp_20220202_221000823543
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_bkp_20220202_221000823543]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_BKP_20220207
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_BKP_20220207]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_bkp_20220516
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_bkp_20220516]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_bkp_20220518
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_bkp_20220518]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_BKP_20220714
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_BKP_20220714]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL2_BKP_20220714_222000038146
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL2_BKP_20220714_222000038146]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_bkp_20220109
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_bkp_20220109]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_bkp_20220202
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_bkp_20220202]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_bkp_20220202_221000823543
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_bkp_20220202_221000823543]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_BKP_20220207
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_BKP_20220207]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_bkp_20220516
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_bkp_20220516]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_bkp_20220518
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_bkp_20220518]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_BKP_20220714
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_BKP_20220714]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL3_BKP_20220714_222000038146
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL3_BKP_20220714_222000038146]
(
    [MASTERSNO] BIGINT NOT NULL,
    [EDT] DATETIME NOT NULL,
    [DRAMOUNT] MONEY NOT NULL,
    [CRAMOUNT] MONEY NOT NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [ACNAME] VARCHAR(100) NULL,
    [MAINLEDGER] VARCHAR(20) NULL,
    [MAINLEDGERNAME] VARCHAR(100) NULL,
    [MAINACCAT] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(234) NULL,
    [REFSNO] BIGINT NOT NULL,
    [BALAMT] MONEY NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [REFCODE] VARCHAR(10) NULL,
    [ACCAT] VARCHAR(10) NULL,
    [OPP_BANK] VARCHAR(20) NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [CURRENCY] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_bkp_20220109
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_bkp_20220109]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_bkp_20220202
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_bkp_20220202]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_bkp_20220202_221000823543
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_bkp_20220202_221000823543]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_BKP_20220207
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_BKP_20220207]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_bkp_20220516
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_bkp_20220516]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_bkp_20220518
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_bkp_20220518]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_BKP_20220714
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_BKP_20220714]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_TBL4_BKP_20220714_222000038146
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_TBL4_BKP_20220714_222000038146]
(
    [BNKNAME] VARCHAR(35) NULL,
    [BRNNAME] VARCHAR(20) NULL,
    [CHQDD] VARCHAR(1) NULL,
    [INSTNO] VARCHAR(30) NULL,
    [INSTDATE] DATETIME NULL,
    [DR_RELDT] DATETIME NULL,
    [CR_RELDT] DATETIME NULL,
    [DR_RELAMT] MONEY NULL,
    [CR_RELAMT] MONEY NULL,
    [DR_REFNO] VARCHAR(12) NULL,
    [CR_REFNO] VARCHAR(12) NULL,
    [RECEIPTNO] INT NULL,
    [DR_MICRNO] BIGINT NULL,
    [CR_MICRNO] BIGINT NULL,
    [SLIP_NO] INT NULL,
    [SLIP_DATE] DATETIME NULL,
    [CHQINNAME] VARCHAR(100) NULL,
    [CHQPRINTED] BIT NULL,
    [CLEARMODE] CHAR(1) NULL,
    [MASTERSNO] BIGINT NULL,
    [RESERVED1] VARCHAR(20) NULL,
    [RESERVED2] VARCHAR(20) NULL,
    [RESERVED3] VARCHAR(20) NULL,
    [RESERVED4] VARCHAR(20) NULL,
    [RESERVED5] VARCHAR(20) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_18032024
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_18032024]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_A433235
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_A433235]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_A902478
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_A902478]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_AUNM1014
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_AUNM1014]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_bkp21022023
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_bkp21022023]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_G72796
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_G72796]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_H44897
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_H44897]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_J47798
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_J47798]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_J84969
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_J84969]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_KCKI1125
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_KCKI1125]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_KUAR1379
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_KUAR1379]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_M203812
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_M203812]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_M326392
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_M326392]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Acmast_MFSS
-- --------------------------------------------------
CREATE TABLE [dbo].[Acmast_MFSS]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_N339048
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_N339048]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_P182890
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_P182890]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_P295327
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_P295327]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_PUNK1024
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_PUNK1024]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_R205955
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_R205955]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_R205955new
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_R205955new]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_R340640
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_R340640]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_R340691
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_R340691]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_R735000
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_R735000]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_RJKW1017
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_RJKW1017]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_S1295592
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_S1295592]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast_S641161
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast_S641161]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACMAST_V212504
-- --------------------------------------------------
CREATE TABLE [dbo].[ACMAST_V212504]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmsat_J53011
-- --------------------------------------------------
CREATE TABLE [dbo].[acmsat_J53011]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NOT NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(12) NULL,
    [Branchcode] VARCHAR(35) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Angel_OptionPL_BKP_15OCT2025
-- --------------------------------------------------
CREATE TABLE [dbo].[Angel_OptionPL_BKP_15OCT2025]
(
    [sauda_date] DATETIME NULL,
    [branch_code] VARCHAR(10) NULL,
    [sub_Broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(50) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [option_type] VARCHAR(2) NULL,
    [expirydate] VARCHAR(11) NULL,
    [Strike_Price] MONEY NULL,
    [pqty] INT NULL,
    [prate] MONEY NULL,
    [pval] MONEY NULL,
    [sqty] INT NULL,
    [srate] MONEY NULL,
    [sval] MONEY NULL,
    [pl] MONEY NULL,
    [stat] VARCHAR(25) NULL,
    [cls_rate] MONEY NULL,
    [terminal_id] VARCHAR(10) NULL,
    [PercMktGross] MONEY NULL,
    [TimeGap] INT NULL,
    [PriceVariation] MONEY NULL,
    [SellPriceVariation] MONEY NULL,
    [Min_Time] DATETIME NULL,
    [Max_Time] DATETIME NULL,
    [NOD30Days] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Auto_RECON_20220214
-- --------------------------------------------------
CREATE TABLE [dbo].[Auto_RECON_20220214]
(
    [CLTCODE] VARCHAR(100) NULL,
    [VDT] VARCHAR(100) NULL,
    [BANK_CODE] VARCHAR(100) NULL,
    [RELDT] VARCHAR(100) NULL,
    [VNO] VARCHAR(100) NULL,
    [NARRATION] VARCHAR(100) NULL,
    [EXCHANGE] VARCHAR(100) NULL,
    [VAMT] VARCHAR(100) NULL,
    [DRCR] VARCHAR(100) NULL,
    [DDNO] VARCHAR(100) NULL,
    [VTYP] VARCHAR(100) NULL,
    [Entry_DAte] VARCHAR(100) NULL,
    [ENTEREDBY] VARCHAR(100) NULL,
    [RELDT2] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Auto_RECON_20220215
-- --------------------------------------------------
CREATE TABLE [dbo].[Auto_RECON_20220215]
(
    [CLTCODE] NVARCHAR(50) NULL,
    [VDT] DATE NULL,
    [BANK_CODE] SMALLINT NULL,
    [RELDT] DATE NULL,
    [VNO] BIGINT NULL,
    [NARRATION] NVARCHAR(50) NULL,
    [EXCHANGE] NVARCHAR(50) NULL,
    [VAMT] INT NULL,
    [DRCR] NVARCHAR(50) NULL,
    [DDNO] NVARCHAR(50) NULL,
    [VTYP] TINYINT NULL,
    [Entry_DAte] DATETIME2 NULL,
    [ENTEREDBY] NVARCHAR(50) NULL,
    [RELDT2] DATE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SCHEME_MAPPING_03072023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_03072023]
(
    [SP_SrNo] INT NOT NULL,
    [SP_Party_Code] VARCHAR(10) NOT NULL,
    [SP_Computation_Level] CHAR(1) NOT NULL,
    [SP_Inst_Type] VARCHAR(3) NOT NULL,
    [SP_Scrip] VARCHAR(12) NOT NULL,
    [SP_Scheme_Id] INT NOT NULL,
    [SP_Trd_Type] VARCHAR(3) NOT NULL,
    [SP_Scheme_Type] CHAR(1) NOT NULL,
    [SP_Multiplier] NUMERIC(36, 12) NULL,
    [SP_Buy_Brok_Type] CHAR(1) NULL,
    [SP_Sell_Brok_Type] CHAR(1) NULL,
    [SP_Buy_Brok] NUMERIC(18, 10) NOT NULL,
    [SP_Sell_Brok] NUMERIC(18, 10) NOT NULL,
    [SP_Res_Multiplier] NUMERIC(36, 12) NULL,
    [SP_Res_Buy_Brok] NUMERIC(18, 10) NOT NULL,
    [SP_Res_Sell_Brok] NUMERIC(36, 12) NULL,
    [SP_Value_From] NUMERIC(36, 12) NULL,
    [SP_Value_To] NUMERIC(36, 12) NULL,
    [SP_TurnOverOn] VARCHAR(7) NOT NULL,
    [SP_Brok_ComputeOn] CHAR(1) NOT NULL,
    [SP_Brok_ComputeType] CHAR(1) NOT NULL,
    [SP_Min_BrokAmt] NUMERIC(36, 12) NULL,
    [SP_Max_BrokAmt] NUMERIC(36, 12) NULL,
    [SP_Min_ScripAmt] NUMERIC(36, 12) NULL,
    [SP_Max_ScripAmt] NUMERIC(36, 12) NULL,
    [SP_Date_From] DATETIME NOT NULL,
    [SP_Date_To] DATETIME NOT NULL,
    [SP_CreatedBy] VARCHAR(20) NOT NULL,
    [SP_CreatedOn] DATETIME NOT NULL,
    [SP_ModifiedBy] VARCHAR(20) NOT NULL,
    [SP_ModifiedOn] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SCHEME_MAPPING_10012023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_10012023]
(
    [SP_Party_Code] VARCHAR(10) NOT NULL,
    [SP_Computation_Level] CHAR(1) NOT NULL,
    [SP_Inst_Type] VARCHAR(3) NOT NULL,
    [SP_Scrip] VARCHAR(8) NOT NULL,
    [SP_Scheme_Id] INT NOT NULL,
    [SP_Trd_Type] VARCHAR(3) NOT NULL,
    [SP_Scheme_Type] CHAR(1) NOT NULL,
    [SP_Multiplier] NUMERIC(18, 4) NOT NULL,
    [SP_Buy_Brok_Type] CHAR(1) NULL,
    [SP_Sell_Brok_Type] CHAR(1) NULL,
    [SP_Buy_Brok] NUMERIC(18, 4) NOT NULL,
    [SP_Sell_Brok] NUMERIC(18, 4) NOT NULL,
    [SP_Res_Multiplier] NUMERIC(18, 4) NOT NULL,
    [SP_Res_Buy_Brok] NUMERIC(18, 4) NOT NULL,
    [SP_Res_Sell_Brok] NUMERIC(18, 4) NULL,
    [SP_Value_From] NUMERIC(18, 4) NOT NULL,
    [SP_Value_To] NUMERIC(18, 4) NOT NULL,
    [SP_TurnOverOn] VARCHAR(7) NOT NULL,
    [SP_Brok_ComputeOn] CHAR(1) NOT NULL,
    [SP_Brok_ComputeType] CHAR(1) NOT NULL,
    [SP_Min_BrokAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Max_BrokAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Min_ScripAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Max_ScripAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Date_From] DATE NULL,
    [SP_Date_To] DATETIME NOT NULL,
    [SP_CreatedBy] VARCHAR(20) NOT NULL,
    [SP_CreatedOn] DATE NULL,
    [SP_ModifiedBy] VARCHAR(20) NOT NULL,
    [SP_ModifiedOn] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SCHEME_MAPPING_13062023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_13062023]
(
    [SP_SrNo] INT IDENTITY(1,1) NOT NULL,
    [SP_Party_Code] VARCHAR(10) NOT NULL,
    [SP_Computation_Level] CHAR(1) NOT NULL,
    [SP_Inst_Type] VARCHAR(3) NOT NULL,
    [SP_Scrip] VARCHAR(12) NOT NULL,
    [SP_Scheme_Id] INT NOT NULL,
    [SP_Trd_Type] VARCHAR(3) NOT NULL,
    [SP_Scheme_Type] CHAR(1) NOT NULL,
    [SP_Multiplier] NUMERIC(36, 12) NULL,
    [SP_Buy_Brok_Type] CHAR(1) NULL,
    [SP_Sell_Brok_Type] CHAR(1) NULL,
    [SP_Buy_Brok] NUMERIC(18, 10) NOT NULL,
    [SP_Sell_Brok] NUMERIC(18, 10) NOT NULL,
    [SP_Res_Multiplier] NUMERIC(36, 12) NULL,
    [SP_Res_Buy_Brok] NUMERIC(18, 10) NOT NULL,
    [SP_Res_Sell_Brok] NUMERIC(36, 12) NULL,
    [SP_Value_From] NUMERIC(36, 12) NULL,
    [SP_Value_To] NUMERIC(36, 12) NULL,
    [SP_TurnOverOn] VARCHAR(7) NOT NULL,
    [SP_Brok_ComputeOn] CHAR(1) NOT NULL,
    [SP_Brok_ComputeType] CHAR(1) NOT NULL,
    [SP_Min_BrokAmt] NUMERIC(36, 12) NULL,
    [SP_Max_BrokAmt] NUMERIC(36, 12) NULL,
    [SP_Min_ScripAmt] NUMERIC(36, 12) NULL,
    [SP_Max_ScripAmt] NUMERIC(36, 12) NULL,
    [SP_Date_From] DATETIME NOT NULL,
    [SP_Date_To] DATETIME NOT NULL,
    [SP_CreatedBy] VARCHAR(20) NOT NULL,
    [SP_CreatedOn] DATETIME NOT NULL,
    [SP_ModifiedBy] VARCHAR(20) NOT NULL,
    [SP_ModifiedOn] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SCHEME_MAPPING_FINNIFTY_19012023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_FINNIFTY_19012023]
(
    [SP_Party_Code] VARCHAR(10) NOT NULL,
    [SP_Computation_Level] CHAR(1) NOT NULL,
    [SP_Inst_Type] VARCHAR(3) NOT NULL,
    [SP_Scrip] VARCHAR(8) NOT NULL,
    [SP_Scheme_Id] INT NOT NULL,
    [SP_Trd_Type] VARCHAR(3) NOT NULL,
    [SP_Scheme_Type] CHAR(1) NOT NULL,
    [SP_Multiplier] NUMERIC(18, 4) NOT NULL,
    [SP_Buy_Brok_Type] CHAR(1) NULL,
    [SP_Sell_Brok_Type] CHAR(1) NULL,
    [SP_Buy_Brok] NUMERIC(18, 4) NOT NULL,
    [SP_Sell_Brok] NUMERIC(18, 4) NOT NULL,
    [SP_Res_Multiplier] NUMERIC(18, 4) NOT NULL,
    [SP_Res_Buy_Brok] NUMERIC(18, 4) NOT NULL,
    [SP_Res_Sell_Brok] NUMERIC(18, 4) NULL,
    [SP_Value_From] NUMERIC(18, 4) NOT NULL,
    [SP_Value_To] NUMERIC(18, 4) NOT NULL,
    [SP_TurnOverOn] VARCHAR(7) NOT NULL,
    [SP_Brok_ComputeOn] CHAR(1) NOT NULL,
    [SP_Brok_ComputeType] CHAR(1) NOT NULL,
    [SP_Min_BrokAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Max_BrokAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Min_ScripAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Max_ScripAmt] NUMERIC(18, 4) NOT NULL,
    [SP_Date_From] DATE NULL,
    [SP_Date_To] DATETIME NOT NULL,
    [SP_CreatedBy] VARCHAR(20) NOT NULL,
    [SP_CreatedOn] DATE NULL,
    [SP_ModifiedBy] VARCHAR(20) NOT NULL,
    [SP_ModifiedOn] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bkp_12MAY2025_FINAL_TURN_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[bkp_12MAY2025_FINAL_TURN_DATA]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [cl_status] VARCHAR(3) NOT NULL,
    [cl_type] VARCHAR(3) NOT NULL,
    [B2B_B2C] VARCHAR(10) NULL,
    [NSECM_TURN] MONEY NULL,
    [BSECM_TURN] MONEY NULL,
    [FO_TURN] MONEY NULL,
    [CD_TURN] MONEY NULL,
    [MCX_TURN] MONEY NULL,
    [NCX_TURN] MONEY NULL,
    [BFO_TURN] MONEY NULL,
    [NFOD_TURN] MONEY NULL,
    [NCE_TURN] MONEY NULL,
    [TOTAL] MONEY NULL,
    [SRNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Brokchangenew
-- --------------------------------------------------
CREATE TABLE [dbo].[Brokchangenew]
(
    [partycode] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_MFSS_duplication_20220109
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_MFSS_duplication_20220109]
(
    [CLTCODE] NVARCHAR(50) NULL,
    [VDATE] DATE NULL,
    [EDATE] DATE NULL,
    [AMOUNT] INT NULL,
    [NARRATION] NVARCHAR(100) NULL,
    [BANKCODE] NVARCHAR(1) NULL,
    [MARGINCODE] NVARCHAR(1) NULL,
    [DDNO] NVARCHAR(1) NULL,
    [VNO] BIGINT NULL,
    [column10] NVARCHAR(1) NULL,
    [column11] NVARCHAR(1) NULL,
    [column12] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Charges_Detail_17082023
-- --------------------------------------------------
CREATE TABLE [dbo].[Charges_Detail_17082023]
(
    [CD_SrNo] BIGINT IDENTITY(1,1) NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_Contract_No] VARCHAR(14) NOT NULL,
    [CD_Trade_No] VARCHAR(15) NOT NULL,
    [CD_Order_No] VARCHAR(16) NULL,
    [CD_Inst_Type] VARCHAR(6) NOT NULL,
    [CD_Symbol] VARCHAR(12) NOT NULL,
    [CD_Expiry_Date] DATETIME NOT NULL,
    [CD_Option_Type] VARCHAR(2) NOT NULL,
    [CD_Strike_Price] MONEY NOT NULL,
    [CD_AuctionPart] VARCHAR(2) NOT NULL,
    [CD_MarketLot] INT NOT NULL,
    [CD_Scheme_Id] INT NOT NULL,
    [CD_ComputationLevel] CHAR(1) NOT NULL,
    [CD_ComputationOn] CHAR(1) NOT NULL,
    [CD_ComputationType] CHAR(1) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_Tot_BuyQty] INT NOT NULL,
    [CD_Tot_SellQty] INT NOT NULL,
    [CD_Tot_BuyTurnOver] MONEY NOT NULL,
    [CD_Tot_SellTurnOver] MONEY NOT NULL,
    [CD_Tot_BuyTurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_SellTurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_TurnOver] MONEY NOT NULL,
    [CD_Tot_TurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_Lot] INT NOT NULL,
    [CD_Tot_Res_TurnOver] MONEY NOT NULL,
    [CD_Tot_Res_TurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_Res_Lot] INT NOT NULL,
    [CD_Tot_BuyBrok] MONEY NOT NULL,
    [CD_Tot_SellBrok] MONEY NOT NULL,
    [CD_Tot_Brok] MONEY NOT NULL,
    [CD_Tot_BuySerTax] MONEY NOT NULL,
    [CD_Tot_SellSerTax] MONEY NOT NULL,
    [CD_Tot_SerTax] MONEY NOT NULL,
    [CD_Tot_Stt] MONEY NOT NULL,
    [CD_Tot_Turn_Tax] MONEY NOT NULL,
    [CD_Tot_Other_Chrg] MONEY NOT NULL,
    [CD_Tot_Sebi_Tax] MONEY NOT NULL,
    [CD_Tot_StampDuty] MONEY NOT NULL,
    [CD_Exch_BuyRate] MONEY NOT NULL,
    [CD_Exch_SellRate] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast_accountCURFO_BKP_09AUG2024
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast_accountCURFO_BKP_09AUG2024]
(
    [Costname] CHAR(35) NOT NULL,
    [Costcode] SMALLINT NOT NULL,
    [Catcode] SMALLINT NOT NULL,
    [Grpcode] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast_accountFO_BKP_09AUG2024
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast_accountFO_BKP_09AUG2024]
(
    [COSTNAME] CHAR(35) NOT NULL,
    [COSTCODE] SMALLINT NOT NULL,
    [CATCODE] SMALLINT NOT NULL,
    [GrpCode] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.final_fno_cnt
-- --------------------------------------------------
CREATE TABLE [dbo].[final_fno_cnt]
(
    [PArty_code] VARCHAR(10) NULL,
    [Sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [CNT] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.final_fno_cnt1
-- --------------------------------------------------
CREATE TABLE [dbo].[final_fno_cnt1]
(
    [PArty_code] VARCHAR(10) NULL,
    [Sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [CNT] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FNO_PNL_RCS
-- --------------------------------------------------
CREATE TABLE [dbo].[FNO_PNL_RCS]
(
    [cltcode] VARCHAR(20) NULL,
    [BF_2223] MONEY NULL,
    [PNL_2324] MONEY NULL,
    [BF_2324] MONEY NULL,
    [PNL_2425] MONEY NULL,
    [sub_broker] VARCHAR(10) NULL,
    [b2c] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foaccbill_17082023
-- --------------------------------------------------
CREATE TABLE [dbo].[foaccbill_17082023]
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
-- TABLE dbo.foaccbill_bak_20230825
-- --------------------------------------------------
CREATE TABLE [dbo].[foaccbill_bak_20230825]
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
-- TABLE dbo.foaccbill_bkp_28082023
-- --------------------------------------------------
CREATE TABLE [dbo].[foaccbill_bkp_28082023]
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
-- TABLE dbo.FOACCBILL_BKP_AUG122024
-- --------------------------------------------------
CREATE TABLE [dbo].[FOACCBILL_BKP_AUG122024]
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
-- TABLE dbo.FOBILLVALAN_HINDUNILVR_041225
-- --------------------------------------------------
CREATE TABLE [dbo].[FOBILLVALAN_HINDUNILVR_041225]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Client_Type] VARCHAR(10) NULL,
    [BillNo] INT NULL,
    [ContractNo] VARCHAR(10) NULL,
    [inst_type] VARCHAR(7) NULL,
    [symbol] VARCHAR(50) NULL,
    [expirydate] SMALLDATETIME NULL,
    [Option_type] VARCHAR(2) NULL,
    [Strike_Price] MONEY NULL,
    [AuctionPart] VARCHAR(20) NULL,
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
    [TradeType] VARCHAR(20) NULL,
    [ParticiPantCode] VARCHAR(15) NULL,
    [Terminal_Id] VARCHAR(15) NULL,
    [Family] VARCHAR(10) NULL,
    [FamilyName] VARCHAR(100) NULL,
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
    [EMAIL] VARCHAR(100) NULL,
    [Dummy2] VARCHAR(1) NULL,
    [Dummy3] VARCHAR(1) NULL,
    [Dummy4] MONEY NULL,
    [Dummy5] MONEY NULL,
    [CMCLOSING] MONEY NULL,
    [Track] CHAR(1) NULL,
    [Area] CHAR(10) NULL,
    [FILTERCOLS] VARCHAR(199) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foexallocsettlement_BKUP_28SEP2023
-- --------------------------------------------------
CREATE TABLE [dbo].[foexallocsettlement_BKUP_28SEP2023]
(
    [ContractNo] VARCHAR(14) NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Strike_price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NULL,
    [Order_no] VARCHAR(16) NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NULL,
    [Line_No] DECIMAL(3, 0) NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] INT NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foexerciseallocation_BKUP_28SEP2023
-- --------------------------------------------------
CREATE TABLE [dbo].[foexerciseallocation_BKUP_28SEP2023]
(
    [foea_table_no] INT NULL,
    [foea_position_date] DATETIME NULL,
    [foea_desc] VARCHAR(50) NULL,
    [foea_segment_ind] VARCHAR(5) NULL,
    [foea_sett_type] VARCHAR(2) NULL,
    [foea_cm_code] VARCHAR(13) NULL,
    [foea_mem_type] VARCHAR(1) NULL,
    [foea_tm_code] VARCHAR(13) NULL,
    [foea_acc_type] VARCHAR(2) NULL,
    [foea_party_code] VARCHAR(15) NULL,
    [foea_inst_type] VARCHAR(6) NULL,
    [foea_symbol] VARCHAR(12) NULL,
    [foea_expirydate] DATETIME NULL,
    [foea_strike_price] MONEY NULL,
    [foea_option_type] VARCHAR(2) NULL,
    [foea_cor_act_level] INT NULL,
    [foea_preexall_longqty] INT NULL,
    [foea_preexall_shortqty] INT NULL,
    [foea_exercise_qty] INT NULL,
    [foea_alloc_qty] INT NULL,
    [foea_postexall_longqty] INT NULL,
    [foea_postexall_shortqty] INT NULL,
    [foea_Brought_Forward_long_Quantity] INT NULL,
    [foea_Brought_Forward_long_Value] MONEY NULL,
    [foea_Brought_Forward_Short_Quantity] INT NULL,
    [foea_Brought_Forward_Short_Value] MONEY NULL,
    [foea_Day_Buy_Open_Quantity] INT NULL,
    [foea_Day_Buy_Open_Value] MONEY NULL,
    [foea_Day_Sell_Open_Quantity] INT NULL,
    [foea_Day_Sell_Open_Value] MONEY NULL,
    [foea_preexall_longValue] MONEY NULL,
    [foea_preexall_ShortValue] MONEY NULL,
    [foea_postexall_longValue] MONEY NULL,
    [foea_postexall_shortvalue] MONEY NULL,
    [foea_SettlementPrice] MONEY NULL,
    [foea_NetPremium] MONEY NULL,
    [foea_Daily_MTM_Settlement_Value] MONEY NULL,
    [foea_Futures_Final_Settlement_Value] MONEY NULL,
    [foea_Exercised_Assigned_Value] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOGLOBALS_bak_01042023
-- --------------------------------------------------
CREATE TABLE [dbo].[FOGLOBALS_bak_01042023]
(
    [year] VARCHAR(4) NOT NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] MONEY NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] SMALLINT NULL,
    [sebi_turn_ac] SMALLINT NULL,
    [broker_note_ac] SMALLINT NULL,
    [other_chrg_ac] SMALLINT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NOT NULL,
    [year_end_dt] DATETIME NOT NULL,
    [CESS_Tax] NUMERIC(10, 9) NOT NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NOT NULL,
    [Insurance_Chrg_Ac] SMALLINT NULL,
    [EDUCESS_TAX] NUMERIC(18, 4) NOT NULL,
    [OptTrdSellTrans] NUMERIC(18, 4) NOT NULL,
    [OptDelSellTrans] NUMERIC(18, 4) NULL,
    [STT_On] VARCHAR(7) NOT NULL,
    [SBCCHARGE] NUMERIC(18, 4) NULL,
    [KRISHICHARGE] NUMERIC(18, 4) NULL,
    [FODELSTT] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOGLOBALS_BKUP_30SEP2024
-- --------------------------------------------------
CREATE TABLE [dbo].[FOGLOBALS_BKUP_30SEP2024]
(
    [year] VARCHAR(4) NOT NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] MONEY NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] SMALLINT NULL,
    [sebi_turn_ac] SMALLINT NULL,
    [broker_note_ac] SMALLINT NULL,
    [other_chrg_ac] SMALLINT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NOT NULL,
    [year_end_dt] DATETIME NOT NULL,
    [CESS_Tax] NUMERIC(10, 9) NOT NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NOT NULL,
    [Insurance_Chrg_Ac] SMALLINT NULL,
    [EDUCESS_TAX] NUMERIC(18, 4) NOT NULL,
    [OptTrdSellTrans] NUMERIC(18, 4) NOT NULL,
    [OptDelSellTrans] NUMERIC(18, 4) NULL,
    [STT_On] VARCHAR(7) NOT NULL,
    [SBCCHARGE] NUMERIC(18, 4) NULL,
    [KRISHICHARGE] NUMERIC(18, 4) NULL,
    [FODELSTT] NUMERIC(18, 4) NULL,
    [IPFTCHRG_FUT] NUMERIC(18, 0) NULL,
    [IPFTCHRG_OPT] NUMERIC(18, 0) NULL,
    [IPFTCHRG_INS] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOGLOBALS_NSECURFO_BKUP_30SEP2024
-- --------------------------------------------------
CREATE TABLE [dbo].[FOGLOBALS_NSECURFO_BKUP_30SEP2024]
(
    [Year] VARCHAR(4) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Service_Tax] MONEY NULL,
    [Service_Tax_Ac] VARCHAR(30) NULL,
    [Turnover_Ac] SMALLINT NULL,
    [Sebi_Turn_Ac] SMALLINT NULL,
    [Broker_Note_Ac] SMALLINT NULL,
    [Other_Chrg_Ac] SMALLINT NULL,
    [Exchange_Gl_Ac] VARCHAR(30) NULL,
    [Year_Start_Dt] DATETIME NOT NULL,
    [Year_End_Dt] DATETIME NOT NULL,
    [Cess_Tax] NUMERIC(10, 9) NULL,
    [Trdbuytrans] NUMERIC(18, 4) NULL,
    [Trdselltrans] NUMERIC(18, 4) NULL,
    [Insurance_Chrg_Ac] SMALLINT NULL,
    [EDUCESS_TAX] NUMERIC(18, 4) NULL,
    [OptTrdSellTrans] NUMERIC(18, 4) NULL,
    [OptDelSellTrans] NUMERIC(18, 4) NULL,
    [STT_On] VARCHAR(7) NULL,
    [SBCCHARGE] NUMERIC(18, 4) NULL,
    [KRISHICHARGE] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNTCURFO_bkup_01SEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNTCURFO_bkup_01SEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNTFO_bkup_01SEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNTFO_bkup_01SEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountCURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountCURFO]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountFO
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountFO]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foposition
-- --------------------------------------------------
CREATE TABLE [dbo].[foposition]
(
    [foea_party_code] VARCHAR(15) NULL,
    [foea_NetPremium] MONEY NULL,
    [foea_Daily_MTM_Settlement_Value] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Foscrip2_MIDCPNIFTY_27SEP2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Foscrip2_MIDCPNIFTY_27SEP2023]
(
    [P_Key] INT NOT NULL,
    [Inst_Type] VARCHAR(6) NOT NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_Name] VARCHAR(25) NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NULL,
    [Startdate] SMALLDATETIME NULL,
    [Maturitydate] SMALLDATETIME NULL,
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
    [C_U_CAL] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fosettlement_27_Nov_2020_HP
-- --------------------------------------------------
CREATE TABLE [dbo].[fosettlement_27_Nov_2020_HP]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] DECIMAL(18, 4) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NOT NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME2 NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [SrNo] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fosettlement_BKUP_13APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Fosettlement_BKUP_13APR2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] NUMERIC(18, 4) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NOT NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [SrNo] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FoSettlement_BKUP_28SEP2023
-- --------------------------------------------------
CREATE TABLE [dbo].[FoSettlement_BKUP_28SEP2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] NUMERIC(18, 4) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NOT NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [SrNo] BIGINT IDENTITY(1,1) NOT NULL
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
-- TABLE dbo.generate_sno_21012026
-- --------------------------------------------------
CREATE TABLE [dbo].[generate_sno_21012026]
(
    [SRNO] INT NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_09082024
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_09082024]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_20241002
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_20241002]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_2211_mtf
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_2211_mtf]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_88
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_88]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_bak_0403
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_bak_0403]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_BKP_20220609
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_BKP_20220609]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_BKP_20220609_ACCOUNTCURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_BKP_20220609_ACCOUNTCURFO]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_bkp_20220818
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_bkp_20220818]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger_mtf_04122023
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_mtf_04122023]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfclient
-- --------------------------------------------------
CREATE TABLE [dbo].[mfclient]
(
    [Party_code] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_BAK_12092022
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_BAK_12092022]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(12) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_BKP_12NOV2024
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_BKP_12NOV2024]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(50) NULL,
    [CODE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_bkp_17122024
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_bkp_17122024]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_BKP_23JAN2025
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_BKP_23JAN2025]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_BKP_26JUN2025
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_BKP_26JUN2025]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_AACB076292
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_AACB076292]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_J47798
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_J47798]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_KUAR1379
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_KUAR1379]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_R340640
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_R340640]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_RJKW1017
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_RJKW1017]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_order_SBD675G_GR_bkp2
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_order_SBD675G_GR_bkp2]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [User_Id] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(10) NULL,
    [REJECT_REASON] VARCHAR(125) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [INT_REF_NO] VARCHAR(20) NULL,
    [SETTLEMENT_TYPE] VARCHAR(2) NULL,
    [ORDER_TYPE] VARCHAR(3) NULL,
    [SIP_REGN_NO] INT NULL,
    [SIP_REGN_DATE] DATETIME NULL,
    [FIRST_ORDER_FLAG] VARCHAR(1) NULL,
    [PUR_REDEEM_STATUS] VARCHAR(10) NULL,
    [MEMBER_REMARKS] VARCHAR(200) NULL,
    [KYC_FLAG] VARCHAR(1) NULL,
    [MIN_REDEEM_FLAG] VARCHAR(1) NULL,
    [SUB_BROKER_ARN] VARCHAR(20) NULL,
    [SUBBRCODE] VARCHAR(50) NULL,
    [EUIN] VARCHAR(15) NULL,
    [EUIN_DECL] VARCHAR(1) NULL,
    [ALL_Units_Flag] VARCHAR(1) NULL,
    [ORD_DPC_FLAG] VARCHAR(1) NULL,
    [ORD_SUB_TYPE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER11042023
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER11042023]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [User_Id] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(10) NULL,
    [REJECT_REASON] VARCHAR(125) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [INT_REF_NO] VARCHAR(20) NULL,
    [SETTLEMENT_TYPE] VARCHAR(2) NULL,
    [ORDER_TYPE] VARCHAR(3) NULL,
    [SIP_REGN_NO] INT NULL,
    [SIP_REGN_DATE] DATETIME NULL,
    [FIRST_ORDER_FLAG] VARCHAR(1) NULL,
    [PUR_REDEEM_STATUS] VARCHAR(10) NULL,
    [MEMBER_REMARKS] VARCHAR(200) NULL,
    [KYC_FLAG] VARCHAR(1) NULL,
    [MIN_REDEEM_FLAG] VARCHAR(1) NULL,
    [SUB_BROKER_ARN] VARCHAR(20) NULL,
    [SUBBRCODE] VARCHAR(50) NULL,
    [EUIN] VARCHAR(15) NULL,
    [EUIN_DECL] VARCHAR(1) NULL,
    [ALL_Units_Flag] VARCHAR(1) NULL,
    [ORD_DPC_FLAG] VARCHAR(1) NULL,
    [ORD_SUB_TYPE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_TRADE_06062023
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_TRADE_06062023]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [USER_ID] VARCHAR(20) NOT NULL,
    [CONF_FLAG] VARCHAR(10) NOT NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [FILLER1] VARCHAR(20) NULL,
    [FILLER2] VARCHAR(20) NULL,
    [FILLER3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_TRADE_BKP_03042023
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_TRADE_BKP_03042023]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [USER_ID] VARCHAR(20) NOT NULL,
    [CONF_FLAG] VARCHAR(10) NOT NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [FILLER1] VARCHAR(20) NULL,
    [FILLER2] VARCHAR(20) NULL,
    [FILLER3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_trade_bkp20feb2023
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_trade_bkp20feb2023]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [USER_ID] VARCHAR(20) NOT NULL,
    [CONF_FLAG] VARCHAR(10) NOT NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [FILLER1] VARCHAR(20) NULL,
    [FILLER2] VARCHAR(20) NULL,
    [FILLER3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_trade_bkp21feb2023
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_trade_bkp21feb2023]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [USER_ID] VARCHAR(20) NOT NULL,
    [CONF_FLAG] VARCHAR(10) NOT NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [FILLER1] VARCHAR(20) NULL,
    [FILLER2] VARCHAR(20) NULL,
    [FILLER3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_trade_bkp21mar2023
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_trade_bkp21mar2023]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [USER_ID] VARCHAR(20) NOT NULL,
    [CONF_FLAG] VARCHAR(10) NOT NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [FILLER1] VARCHAR(20) NULL,
    [FILLER2] VARCHAR(20) NULL,
    [FILLER3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_trade_SBD675G_GR_bkp
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_trade_SBD675G_GR_bkp]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [USER_ID] VARCHAR(20) NOT NULL,
    [CONF_FLAG] VARCHAR(10) NOT NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [FILLER1] VARCHAR(20) NULL,
    [FILLER2] VARCHAR(20) NULL,
    [FILLER3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_trade_SBD675G_GR_bkp2
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_trade_SBD675G_GR_bkp2]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [User_Id] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(10) NULL,
    [REJECT_REASON] VARCHAR(125) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [INT_REF_NO] VARCHAR(20) NULL,
    [SETTLEMENT_TYPE] VARCHAR(2) NULL,
    [ORDER_TYPE] VARCHAR(3) NULL,
    [SIP_REGN_NO] INT NULL,
    [SIP_REGN_DATE] DATETIME NULL,
    [FIRST_ORDER_FLAG] VARCHAR(1) NULL,
    [PUR_REDEEM_STATUS] VARCHAR(10) NULL,
    [MEMBER_REMARKS] VARCHAR(200) NULL,
    [KYC_FLAG] VARCHAR(1) NULL,
    [MIN_REDEEM_FLAG] VARCHAR(1) NULL,
    [SUB_BROKER_ARN] VARCHAR(20) NULL,
    [SUBBRCODE] VARCHAR(50) NULL,
    [EUIN] VARCHAR(15) NULL,
    [EUIN_DECL] VARCHAR(1) NULL,
    [ALL_Units_Flag] VARCHAR(1) NULL,
    [ORD_DPC_FLAG] VARCHAR(1) NULL,
    [ORD_SUB_TYPE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSSVOUCHER14072022
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSSVOUCHER14072022]
(
    [CLTCODE] NVARCHAR(50) NULL,
    [VDATE] DATE NULL,
    [EDATE] DATE NULL,
    [AMOUNT] SMALLINT NULL,
    [NARRATION] NVARCHAR(50) NULL,
    [BANKCODE] NVARCHAR(1) NULL,
    [MARGINCODE] NVARCHAR(1) NULL,
    [DDNO] NVARCHAR(1) NULL,
    [VNO] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OACCBILL_new_bkp_20230825
-- --------------------------------------------------
CREATE TABLE [dbo].[OACCBILL_new_bkp_20230825]
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
-- TABLE dbo.Omnesys_ord_final
-- --------------------------------------------------
CREATE TABLE [dbo].[Omnesys_ord_final]
(
    [join] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [sell_buy] VARCHAR(50) NULL,
    [tradeqty] VARCHAR(50) NULL,
    [auctionpart] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [sec_name] VARCHAR(50) NULL,
    [Net_qty] VARCHAR(50) NULL,
    [remarks] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Filler] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Omnesys_order
-- --------------------------------------------------
CREATE TABLE [dbo].[Omnesys_order]
(
    [SEGEMNT] VARCHAR(50) NULL,
    [Trading symbol] VARCHAR(50) NULL,
    [party_Code] VARCHAR(50) NULL,
    [ORDER_NO] VARCHAR(50) NULL,
    [Remarks] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [BUY_SELL] VARCHAR(50) NULL,
    [QTY] VARCHAR(50) NULL,
    [Column 8] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Other_taxes_02022026
-- --------------------------------------------------
CREATE TABLE [dbo].[Other_taxes_02022026]
(
    [Party_code] VARCHAR(10) NULL,
    [year_fy] INT NULL,
    [Month_FY] INT NULL,
    [inst_type] VARCHAR(3) NULL,
    [Brokerage] MONEY NULL,
    [Service_Tax] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [Broker_note] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [ipft_charges] MONEY NULL,
    [b2c_flag] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PNL_2223
-- --------------------------------------------------
CREATE TABLE [dbo].[PNL_2223]
(
    [CLIENT CODE] VARCHAR(10) NULL,
    [INST TYPE] VARCHAR(7) NULL,
    [PROFIT OR LOSS] MONEY NULL,
    [Brokerage] MONEY NULL,
    [GST] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [BROKER_NOTE] MONEY NULL,
    [STT] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PNLFO_EXCh
-- --------------------------------------------------
CREATE TABLE [dbo].[PNLFO_EXCh]
(
    [Party_code] VARCHAR(10) NULL,
    [Finyear] VARCHAR(9) NOT NULL,
    [Symbol] VARCHAR(12) NULL,
    [expirydate] SMALLDATETIME NULL,
    [inst_type] VARCHAR(6) NULL,
    [Option_type] VARCHAR(2) NULL,
    [Strike_Price] MONEY NULL,
    [PNL] MONEY NULL,
    [Brokerage] MONEY NULL,
    [turn_tax] MONEY NULL,
    [Stamp_Duty] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [STT] MONEY NULL,
    [GST] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_bse1
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_bse1]
(
    [sauda_date] DATETIME NOT NULL,
    [sett_no] VARCHAR(7) NOT NULL,
    [sett_type] VARCHAR(3) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [ISIN] VARCHAR(12) NULL,
    [PQTYTRD] INT NULL,
    [PAMTTRD] MONEY NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [SQTYTRD] INT NULL,
    [SAMTTRD] MONEY NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [PBROKTRD] MONEY NULL,
    [SBROKTRD] MONEY NULL,
    [PBROKDEL] MONEY NULL,
    [SBROKDEL] MONEY NULL,
    [TRDAMT] MONEY NULL,
    [DELAMT] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [DUMMY5] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_cmbillBse
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_cmbillBse]
(
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(3) NOT NULL,
    [BILLNO] VARCHAR(10) NULL,
    [CONTRACTNO] VARCHAR(15) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(3) NOT NULL,
    [SCRIP_NAME] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [SAUDA_DATE] DATETIME NOT NULL,
    [PQTYTRD] INT NULL,
    [PAMTTRD] MONEY NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [SQTYTRD] INT NULL,
    [SAMTTRD] MONEY NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [PBROKTRD] MONEY NULL,
    [SBROKTRD] MONEY NULL,
    [PBROKDEL] MONEY NULL,
    [SBROKDEL] MONEY NULL,
    [FAMILY] VARCHAR(10) NULL,
    [FAMILY_NAME] VARCHAR(100) NULL,
    [TERMINAL_ID] VARCHAR(10) NOT NULL,
    [CLIENTTYPE] VARCHAR(10) NULL,
    [TRADETYPE] VARCHAR(3) NOT NULL,
    [TRADER] VARCHAR(20) NULL,
    [SUB_BROKER] VARCHAR(10) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [PARTICIPANTCODE] VARCHAR(15) NULL,
    [PAMT] MONEY NOT NULL,
    [SAMT] MONEY NOT NULL,
    [PRATE] MONEY NULL,
    [SRATE] MONEY NULL,
    [TRDAMT] MONEY NULL,
    [DELAMT] MONEY NULL,
    [SERINEX] SMALLINT NULL,
    [SERVICE_TAX] MONEY NULL,
    [EXSERVICE_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [REGION] VARCHAR(50) NULL,
    [START_DATE] VARCHAR(11) NULL,
    [END_DATE] VARCHAR(11) NULL,
    [UPDATE_DATE] VARCHAR(11) NULL,
    [STATUS_NAME] VARCHAR(15) NULL,
    [EXCHANGE] VARCHAR(5) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [MEMBERTYPE] VARCHAR(3) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [DUMMY1] VARCHAR(1) NULL,
    [DUMMY2] VARCHAR(1) NULL,
    [DUMMY3] VARCHAR(1) NULL,
    [DUMMY4] MONEY NULL,
    [DUMMY5] MONEY NULL,
    [AREA] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_curr_bill
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_curr_bill]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_del_2223
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_del_2223]
(
    [party_code] VARCHAR(10) NOT NULL,
    [delamt] MONEY NOT NULL,
    [trdpnl] MONEY NOT NULL,
    [delamt_delsqrup1] MONEY NOT NULL,
    [delsqramt] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_DPhld_31mar2022
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_DPhld_31mar2022]
(
    [HLD_HOLD_DATE] SMALLDATETIME NULL,
    [HLD_AC_CODE] VARCHAR(16) NULL,
    [HLD_CAT] VARCHAR(2) NULL,
    [HLD_ISIN_CODE] VARCHAR(12) NULL,
    [HLD_AC_TYPE] VARCHAR(4) NULL,
    [HLD_AC_POS] MONEY NULL,
    [HLD_CCID] VARCHAR(8) NULL,
    [HLD_MARKET_TYPE] VARCHAR(2) NULL,
    [HLD_SETTLEMENT] VARCHAR(13) NULL,
    [HLD_BLF] VARCHAR(1) NULL,
    [HLD_BLC] VARCHAR(2) NULL,
    [HLD_LRD] VARCHAR(8) NULL,
    [HLD_PENDINGDT] VARCHAR(8) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_Eq_del2122
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_Eq_del2122]
(
    [party_code] VARCHAR(10) NOT NULL,
    [delamt] MONEY NOT NULL,
    [trdpnl] MONEY NOT NULL,
    [delamt_delsqrup1] MONEY NOT NULL,
    [delsqramt] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_Eq_del2324
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_Eq_del2324]
(
    [party_code] VARCHAR(10) NOT NULL,
    [delamt] MONEY NOT NULL,
    [trdpnl] MONEY NOT NULL,
    [delamt_delsqrup1] MONEY NOT NULL,
    [delsqramt] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_fno_analysis
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_fno_analysis]
(
    [client_code] VARCHAR(16) NULL,
    [NISE_PARTY_CODE] VARCHAR(10) NULL,
    [active_date] DATETIME NULL,
    [hodling_value] MONEY NULL,
    [Net_cash_2122] MONEY NULL,
    [Options_2122] MONEY NULL,
    [Futures_2122] MONEY NULL,
    [Net_PNL_2122] MONEY NULL,
    [Closing_Bal_2122] MONEY NULL,
    [Net_cash_2223] MONEY NULL,
    [Options_2223] MONEY NULL,
    [Futures_2223] MONEY NULL,
    [Net_PNL_2223] MONEY NULL,
    [Closing_Bal_2223] MONEY NULL,
    [holding_value_2223] MONEY NULL,
    [holding_value_2310] MONEY NULL,
    [Options_2310] MONEY NULL,
    [Futures_2310] MONEY NULL,
    [Net_PNL_2310] MONEY NULL,
    [Closing_Bal_2310] MONEY NULL,
    [net_cash_2310] MONEY NULL,
    [Open_Pos_Opt_23] MONEY NULL,
    [Open_Pos_Fut_23] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_fno_analysis_wiouthold
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_fno_analysis_wiouthold]
(
    [client_code] VARCHAR(16) NULL,
    [NISE_PARTY_CODE] VARCHAR(10) NULL,
    [active_date] DATETIME NULL,
    [hodling_value] MONEY NULL,
    [Net_cash_2122] MONEY NULL,
    [Options_2122] MONEY NULL,
    [Futures_2122] MONEY NULL,
    [Net_PNL_2122] MONEY NULL,
    [Closing_Bal_2122] MONEY NULL,
    [Net_cash_2223] MONEY NULL,
    [Options_2223] MONEY NULL,
    [Futures_2223] MONEY NULL,
    [Net_PNL_2223] MONEY NULL,
    [Closing_Bal_2223] MONEY NULL,
    [holding_value_2223] MONEY NULL,
    [holding_value_2310] MONEY NULL,
    [Options_2310] MONEY NULL,
    [Futures_2310] MONEY NULL,
    [Net_PNL_2310] MONEY NULL,
    [Closing_Bal_2310] MONEY NULL,
    [net_cash_2310] MONEY NULL,
    [Open_Pos_Opt_23] MONEY NULL,
    [Open_Pos_Fut_23] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rcs_FO_open_pos
-- --------------------------------------------------
CREATE TABLE [dbo].[Rcs_FO_open_pos]
(
    [foea_party_code] VARCHAR(15) NULL,
    [foea_inst_type] VARCHAR(6) NULL,
    [foea_symbol] VARCHAR(12) NULL,
    [foea_expirydate] DATETIME NULL,
    [foea_strike_price] MONEY NULL,
    [foea_option_type] VARCHAR(2) NULL,
    [net_Qty] INT NULL,
    [foea_SettlementPrice] MONEY NULL,
    [trade_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_ipo_FY21_22
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_ipo_FY21_22]
(
    [party_code] VARCHAR(50) NULL,
    [Invest_Amount] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_ipo_FY22_23
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_ipo_FY22_23]
(
    [party_code] VARCHAR(50) NULL,
    [Invest_amount] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_ipo_FY23_24
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_ipo_FY23_24]
(
    [party_code] VARCHAR(50) NULL,
    [Invest_amount] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_MCX_bill
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_MCX_bill]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_ncdx_bill
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_ncdx_bill]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_nse1
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_nse1]
(
    [sauda_date] DATETIME NOT NULL,
    [sett_no] VARCHAR(7) NOT NULL,
    [sett_type] VARCHAR(3) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [ISIN] VARCHAR(12) NULL,
    [PQTYTRD] INT NULL,
    [PAMTTRD] MONEY NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [SQTYTRD] INT NULL,
    [SAMTTRD] MONEY NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [PBROKTRD] MONEY NULL,
    [SBROKTRD] MONEY NULL,
    [PBROKDEL] MONEY NULL,
    [SBROKDEL] MONEY NULL,
    [TRDAMT] MONEY NULL,
    [DELAMT] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [DUMMY5] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_nsecmbill_2
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_nsecmbill_2]
(
    [sauda_date] DATETIME NOT NULL,
    [sett_no] VARCHAR(7) NOT NULL,
    [sett_type] VARCHAR(3) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [ISIN] VARCHAR(12) NULL,
    [PQTYTRD] INT NULL,
    [PAMTTRD] MONEY NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [SQTYTRD] INT NULL,
    [SAMTTRD] MONEY NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [PBROKTRD] MONEY NULL,
    [SBROKTRD] MONEY NULL,
    [PBROKDEL] MONEY NULL,
    [SBROKDEL] MONEY NULL,
    [TRDAMT] MONEY NULL,
    [DELAMT] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [EXSERVICE_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [DUMMY5] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_nsefO_bill
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_nsefO_bill]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_o_ord1
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_o_ord1]
(
    [joint_data] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [sell_buy] VARCHAR(50) NULL,
    [tradeqty] VARCHAR(50) NULL,
    [auctionpart] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [sec_name] VARCHAR(50) NULL,
    [SaturdayName] VARCHAR(50) NULL,
    [NEWname] VARCHAR(50) NULL,
    [Net_qty] VARCHAR(50) NULL,
    [remarks] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Filler1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_omn_order
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_omn_order]
(
    [join] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [sell_buy] VARCHAR(50) NULL,
    [tradeqty] VARCHAR(50) NULL,
    [auctionpart] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [sec_name] VARCHAR(50) NULL,
    [Net_qty] VARCHAR(50) NULL,
    [remarks] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Filler1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RCS_OMN_WORKING
-- --------------------------------------------------
CREATE TABLE [dbo].[RCS_OMN_WORKING]
(
    [join] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [sell_buy] VARCHAR(50) NULL,
    [tradeqty] VARCHAR(50) NULL,
    [auctionpart] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [sec_name] VARCHAR(50) NULL,
    [Net_qty] VARCHAR(50) NULL,
    [remarks] VARCHAR(50) NULL,
    [Column 14] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_omni_working_v1
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_omni_working_v1]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] NUMERIC(18, 4) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NOT NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [SrNo] BIGINT IDENTITY(1,1) NOT NULL,
    [Join_check] VARCHAR(31) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_omni_working_v2
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_omni_working_v2]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] NUMERIC(18, 4) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NOT NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [SrNo] BIGINT IDENTITY(1,1) NOT NULL,
    [Join_check] VARCHAR(31) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_omni_working_v3
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_omni_working_v3]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] NUMERIC(18, 4) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NOT NULL,
    [Strike_price] MONEY NOT NULL,
    [Option_type] VARCHAR(2) NOT NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
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
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [SrNo] BIGINT IDENTITY(1,1) NOT NULL,
    [Join_check] VARCHAR(31) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RCs_PARTIAL_TEST
-- --------------------------------------------------
CREATE TABLE [dbo].[RCs_PARTIAL_TEST]
(
    [party_code] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [tradeqty] VARCHAR(50) NULL,
    [NVALUE] VARCHAR(50) NULL,
    [filler1] VARCHAR(50) NULL,
    [REQqty] NUMERIC(18, 0) NULL,
    [REQvalue] NUMERIC(18, 0) NULL,
    [Check] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_pnl_Future_mis
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_pnl_Future_mis]
(
    [Finyear] VARCHAR(9) NOT NULL,
    [Inst_type] VARCHAR(6) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [Gross_PNL] MONEY NULL,
    [Brokerage] MONEY NULL,
    [Turn_tax] MONEY NULL,
    [Stampduty] MONEY NULL,
    [STT] MONEY NULL,
    [Sebi_tax] MONEY NULL,
    [GST] MONEY NULL,
    [NET_PNL] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_pnl_optopn_mis
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_pnl_optopn_mis]
(
    [Finyear] VARCHAR(9) NOT NULL,
    [Inst_type] VARCHAR(6) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [Gross_PNL] MONEY NULL,
    [Brokerage] MONEY NULL,
    [Turn_tax] MONEY NULL,
    [Stampduty] MONEY NULL,
    [STT] MONEY NULL,
    [Sebi_tax] MONEY NULL,
    [GST] MONEY NULL,
    [NET_PNL] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_sip_eq_2020_21
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_sip_eq_2020_21]
(
    [party_code] VARCHAR(10) NOT NULL,
    [delamt] MONEY NOT NULL,
    [trdpnl] MONEY NOT NULL,
    [delamt_delsqrup1] MONEY NOT NULL,
    [delsqramt] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_sip_eq_2020_23
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_sip_eq_2020_23]
(
    [party_code] VARCHAR(10) NOT NULL,
    [delamt] MONEY NOT NULL,
    [trdpnl] MONEY NOT NULL,
    [delamt_delsqrup1] MONEY NOT NULL,
    [delsqramt] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_sip_eq_2021_22
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_sip_eq_2021_22]
(
    [party_code] VARCHAR(10) NOT NULL,
    [delamt] MONEY NOT NULL,
    [trdpnl] MONEY NOT NULL,
    [delamt_delsqrup1] MONEY NOT NULL,
    [delsqramt] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_SPI_client_list
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_SPI_client_list]
(
    [Party_Code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MST_BKP_27062023
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MST_BKP_27062023]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sip_clients_dp
-- --------------------------------------------------
CREATE TABLE [dbo].[sip_clients_dp]
(
    [nise_party_code] VARCHAR(10) NULL,
    [client_code] VARCHAR(16) NULL,
    [active_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sip_clients_pnl_detail
-- --------------------------------------------------
CREATE TABLE [dbo].[sip_clients_pnl_detail]
(
    [client_code] VARCHAR(16) NULL,
    [active_date] DATETIME NULL,
    [nise_party_code] VARCHAR(10) NULL,
    [fin_year] VARCHAR(9) NOT NULL,
    [hold_val_2021] MONEY NULL,
    [hold_val_2122] MONEY NULL,
    [hold_val_2223] MONEY NULL,
    [net_cash_2021] MONEY NULL,
    [Net_cash_2122] MONEY NULL,
    [Net_cash_2223] MONEY NULL,
    [Net_PNL_2021] MONEY NULL,
    [Net_PNL_2122] MONEY NULL,
    [Net_PNL_2223] MONEY NULL,
    [Closing_Bal_2021] MONEY NULL,
    [Closing_Bal_2122] MONEY NULL,
    [Closing_Bal_2223] MONEY NULL,
    [DUPLICATE] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_20230318
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_20230318]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_BKP_23SEP2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_BKP_23SEP2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_auto_process_master_BKUP_25JAN2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_25JAN2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_auto_process_master_BKUP_BSEMFSS_21DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_BSEMFSS_21DEC2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_auto_process_master_BKUP_NSECURFO_21DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_NSECURFO_21DEC2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_auto_process_master_BKUP_NSEFO_21DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_NSEFO_21DEC2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_BSEMFSS_BKUP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_BSEMFSS_BKUP_13MAY2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_NSECURFO_BKUP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_NSECURFO_BKUP_13MAY2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_NSEFO_BKUP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_NSEFO_BKUP_13MAY2024]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [PROCESS_TYPE] VARCHAR(30) NULL,
    [PROCESS_FOR] VARCHAR(30) NULL,
    [PROCESS_ID] INT NULL,
    [INTERNAL_PROCESS_ID] INT NULL,
    [SETT_NO] VARCHAR(20) NULL,
    [SETT_TYPE] VARCHAR(20) NULL,
    [IS_FILE_BASED] VARCHAR(1) NULL,
    [PROCESS_FREQ] VARCHAR(10) NULL,
    [PROCESS_START_TIME] VARCHAR(10) NULL,
    [PROCESS_END_TIME] VARCHAR(10) NULL,
    [PROCESS_REPEAT_INTERVAL] VARCHAR(10) NULL,
    [FILE_DWLOAD_LOCATION] VARBINARY(8000) NULL,
    [FILE_DWLOAD_NAME] VARBINARY(8000) NULL,
    [FILE_DWLOAD_USERID] VARBINARY(8000) NULL,
    [FILE_DWLOAD_PWD] VARBINARY(8000) NULL,
    [FILE_DWLOAD_MAP_DRIVE] VARCHAR(100) NULL,
    [PROCESS_FILE_PATH] VARBINARY(8000) NULL,
    [PROCESS_FILE_NAME] VARBINARY(8000) NULL,
    [PROCESS_FILE_MOVE_PATH] VARBINARY(8000) NULL,
    [PROCESS_SP_NAME] VARBINARY(8000) NULL,
    [PROCESS_CHECK_QUERY] VARBINARY(8000) NULL,
    [IS_DEPEND_ON] VARCHAR(20) NULL,
    [WAIT_PERIOD] VARCHAR(10) NULL,
    [APPROX_END_TIME] VARCHAR(10) NULL,
    [PROCESS_STATUS_ALERT] INT NULL,
    [PROCESS_STATUS_ALERT_INTERVAL] VARCHAR(10) NULL,
    [FILE_INTERNET_LOCATION] VARCHAR(500) NULL,
    [FILE_INTERNAL_ISS_PATH] VARCHAR(500) NULL,
    [PROCESS_OUTPUT_QUERY] VARCHAR(MAX) NULL,
    [IS_ATTACHEMENT] INT NULL,
    [OTHER_DBDETAILS] VARCHAR(200) NULL,
    [OTHER_PROCESS_FOR] VARCHAR(200) NULL,
    [PROCESS_ORDER_ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_TURNOVER_SLAB_BKUP_01APR2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_TURNOVER_SLAB_BKUP_01APR2024]
(
    [INST_TYPE] VARCHAR(3) NULL,
    [TRADE_TYPE] VARCHAR(3) NULL,
    [CHARGE_ON] INT NULL,
    [FROM_TOT] NUMERIC(18, 4) NULL,
    [TO_TOT] NUMERIC(18, 4) NULL,
    [CHARGE_PER] NUMERIC(18, 6) NULL,
    [FROMDATE] DATETIME NULL,
    [TODATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_TURNOVER_SLAB_BKUP_03APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_TURNOVER_SLAB_BKUP_03APR2023]
(
    [INST_TYPE] VARCHAR(3) NULL,
    [TRADE_TYPE] VARCHAR(3) NULL,
    [CHARGE_ON] INT NULL,
    [FROM_TOT] NUMERIC(18, 4) NULL,
    [TO_TOT] NUMERIC(18, 4) NULL,
    [CHARGE_PER] NUMERIC(18, 6) NULL,
    [FROMDATE] DATETIME NULL,
    [TODATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VoucherDelete
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VoucherDelete]
(
    [VNO] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblPradnyausers_T0_Series_data_NSECURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[tblPradnyausers_T0_Series_data_NSECURFO]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldusername] VARCHAR(25) NULL,
    [Fldpassword] VARCHAR(15) NULL,
    [Fldfirstname] VARCHAR(25) NULL,
    [Fldmiddlename] VARCHAR(25) NULL,
    [Fldlastname] VARCHAR(25) NULL,
    [Fldsex] VARCHAR(8) NULL,
    [Fldaddress1] VARCHAR(100) NULL,
    [Fldaddress2] VARCHAR(100) NULL,
    [Fldphone1] VARCHAR(10) NULL,
    [Fldphone2] VARCHAR(10) NULL,
    [Fldcategory] VARCHAR(10) NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Pwd_Expiry_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblPradnyausers_T0_Series_data_NSEFO
-- --------------------------------------------------
CREATE TABLE [dbo].[tblPradnyausers_T0_Series_data_NSEFO]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldusername] VARCHAR(25) NULL,
    [fldpassword] VARCHAR(15) NULL,
    [fldfirstname] VARCHAR(25) NULL,
    [fldmiddlename] VARCHAR(25) NULL,
    [fldlastname] VARCHAR(25) NULL,
    [fldsex] VARCHAR(8) NULL,
    [fldaddress1] VARCHAR(40) NULL,
    [fldaddress2] VARCHAR(40) NULL,
    [fldphone1] VARCHAR(10) NULL,
    [fldphone2] VARCHAR(10) NULL,
    [fldcategory] VARCHAR(10) NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldstname] VARCHAR(50) NULL,
    [PWD_EXPIRY_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test
-- --------------------------------------------------
CREATE TABLE [dbo].[test]
(
    [name] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tran_CNT
-- --------------------------------------------------
CREATE TABLE [dbo].[Tran_CNT]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SaUDA_DATE] VARCHAR(11) NULL,
    [Inst_type] VARCHAR(6) NULL,
    [CNT] INT NULL
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

