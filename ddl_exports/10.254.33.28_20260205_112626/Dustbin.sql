-- DDL Export
-- Server: 10.254.33.28
-- Database: Dustbin
-- Exported: 2026-02-05T11:26:34.594541

USE Dustbin;
GO

-- --------------------------------------------------
-- INDEX dbo.Brokchangenew
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Ix_party] ON [dbo].[Brokchangenew] ([partycode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Sett_Mst
-- --------------------------------------------------
ALTER TABLE [dbo].[Sett_Mst] ADD CONSTRAINT [PK_Sett_Mst_bsecm] PRIMARY KEY ([Sett_Type], [Sett_No])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BSENRIDETAIL_T1_15may2023
-- --------------------------------------------------

CREATE PROC  [dbo].[BSENRIDETAIL_T1_15may2023] (@SDATE AS VARCHAR(11),@SELL_BUY AS VARCHAR(1))                                      
AS                                        
                      
DECLARE @@SETT_NO VARCHAR(8) ,@@SETT_NO1 VARCHAR(8)                     
                      
SELECT @@SETT_NO = SETT_NO FROM BSEDB_AB.DBO.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE IN('D','C')            
SELECT @@SETT_NO1 = SETT_NO FROM BSEDB_AB.DBO.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE in ('RD','RC')            
                    
SELECT  'BSECM' AS EXCHANGE,PARTY_CODE,SAUDA_DATE,CONTRACTNO,                                      
CASE WHEN SELL_BUY = 1 THEN 'P' ELSE 'S' END TRANSACTION_TYPE,                                      
B.ISIN,sum(PQTY+SQTY) AS QTY,sum(PAMT-SAMT)/sum(PQTY+SQTY) RATE,sum(ROUND(BROKERAGE,2)) AS BROK_PERSCRIP,sum(PAMT+SAMT)                                       
AS TRANACTIONAMT,Scripname,CONTRACT_DATA.Scrip_cd ,SETT_NO,(PRate+SRATE) TRATE   ,SERVICE_TAX as OtherCharges,INS_CHRG as STT ,  
(CONTRACT_DATA.broker_chrg+CONTRACT_DATA.Turn_Tax+CONTRACT_DATA.sebi_tax) OtherTax 
INTO #DATA
from BSEDB_AB.DBO.CONTRACT_DATA,[AngelDemat].BSEDB.DBO.MULTIISIN AS B WHERE CONTRACT_DATA.SCRIP_CD <>'BRKSCR'                                
AND PARTY_CODE IN (SELECT cl_code FROM BSEDB_AB.DBO.Client1 WHERE Cl_type ='NRI')                                
AND CONTRACT_DATA.SCRIP_CD=B.SCRIP_CD                              
--AND CONTRACT_DATA.SERIES=B.Series                               
AND B.VALID=1                    
AND SETT_NO in(@@SETT_NO,@@SETT_NO1)  AND SELL_BUY = @SELL_BUY and  (PQTY+SQTY)! = 0                    
group by PARTY_CODE,SAUDA_DATE,CONTRACTNO, SELL_BUY,b.ISIN,Scripname,CONTRACT_DATA.Scrip_cd,SETT_NO,(PRate+SRATE),SERVICE_TAX,INS_CHRG,  
CONTRACT_DATA.broker_chrg,CONTRACT_DATA.Turn_Tax,CONTRACT_DATA.sebi_tax


--DECLARE @SDATE AS VARCHAR(11)='MAR 19 2025' , @SELL_BUY AS VARCHAR(1)='2'     
SELECT EXCHANGE,PARTY_CODE, SAUDA_DATE, MAX(CONTRACTNO) AS CONTRACTNO,TRANSACTION_TYPE,ISIN,SUM(QTY) AS QTY,MAX(RATE) AS RATE,MAX(BROK_PERSCRIP) AS BROK_PERSCRIP,
--CASE WHEN @SELL_BUY='1' THEN SUM(TRANACTIONAMT) ELSE SUM(BROK_PERSCRIP)+SUM(TRANACTIONAMT) END AS TRANACTIONAMT,
SUM(TRANACTIONAMT) AS TRANACTIONAMT,
SCRIPNAME,SCRIP_CD,SETT_NO,
MAX(TRATE) AS TRATE, SUM(OTHERCHARGES) AS OTHERCHARGES, SUM(STT) AS STT, SUM(OTHERTAX) AS OTHERTAX
INTO #MAIN_DATA
FROM #DATA
--WHERE PARTY_CODE IN ('ZR1529R','ZR73') --and ISIN='INE732I01013'
GROUP BY EXCHANGE,PARTY_CODE, SAUDA_DATE,TRANSACTION_TYPE,ISIN,SCRIPNAME,SCRIP_CD,SETT_NO

SELECT EXCHANGE,PARTY_CODE,SAUDA_DATE,CONTRACTNO,TRANSACTION_TYPE,ISIN,QTY,RATE,BROK_PERSCRIP,TRANACTIONAMT,SCRIPNAME,SCRIP_CD,SETT_NO,TRATE,OTHERCHARGES,STT,OTHERTAX
FROM #MAIN_DATA  --- FINAL DATA
--WHERE PARTY_CODE IN ('ZR1529R','ZR73')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BSENRIHEADER_T1
-- --------------------------------------------------

CREATE PROC  [dbo].[BSENRIHEADER_T1] (@SDATE AS VARCHAR(11),@SELL_BUY AS VARCHAR(1))                      
      
AS                        
DECLARE @@SETT_NO VARCHAR(8),@@SETT_NO1 VARCHAR(8)       
      
SELECT @@SETT_NO = SETT_NO FROM BSEDB_AB.DBO.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE in ('D','C')     
SELECT @@SETT_NO1 = SETT_NO FROM BSEDB_AB.DBO.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE in ('RD','RC')     
      
CREATE TABLE #DATA (EXCHANGE VARCHAR(50), PARTY_CODE VARCHAR(50),SAUDA_DATE VARCHAR(50), SELL_BUY INT, CONTRACTNO VARCHAR(50),SERVICE_TAX MONEY    ----- ADDED ON 18 FEB 2025 SRE-34258
, EDUCESS MONEY, EXCHAGE_LEVIES MONEY,STT MONEY,STAMPDUTY MONEY,MINBROKERAGE MONEY,OTHER_CHARGES MONEY,NO_OF_TRANSACTIONS INT, TOTALAMT MONEY, SETT_NO VARCHAR(50))

 INSERT INTO #DATA														----- ADDED ON 18 FEB 2025 SRE-34258
 SELECT EXCHANGE,A.PARTY_CODE,SAUDA_DATE,SELL_BUY,CONTRACTNO,SUM(SERVICE_TAX+ISNULL(NSERTAX,0))SERVICE_TAX,                      
 EDUCESS,EXCHAGE_LEVIES,STT,STAMPDUTY,ISNULL(MINBROKERAGE,0)MINBROKERAGE,OTHER_CHARGES,NO_OF_TRANSACTIONS,                    
 ROUND((TOTALAMT+ISNULL(MINBROKERAGE,0)+ISNULL(NSERTAX,0)),2)TOTALAMT ,a.SETT_NO                      
 FROM                      
(SELECT  'BSECM' AS EXCHANGE,PARTY_CODE,SAUDA_DATE,SELL_BUY, CONTRACTNO,       ----- CHANGES ON 18 FEB 2025 SRE-34258                 
SUM(NSERTAX)AS SERVICE_TAX,0 AS EDUCESS,ROUND(SUM(TURN_TAX),2) AS EXCHAGE_LEVIES,SUM(INS_CHRG)AS STT,                        
ROUND(SUM(BROKER_CHRG),2) AS STAMPDUTY,                        
ROUND(SUM(SEBI_TAX),2) AS OTHER_CHARGES,COUNT(PARTY_CODE) AS NO_OF_TRANSACTIONS,                        
case when @SELL_BUY=1 then SUM(PAMT+SAMT)+SUM(INS_CHRG+NSERTAX+BROKER_CHRG+TURN_TAX+SEBI_TAX)  
else SUM(PAMT+SAMT)-SUM(INS_CHRG+NSERTAX+BROKER_CHRG+TURN_TAX+SEBI_TAX) end AS TOTALAMT ,SETT_NO                        
from BSEDB_AB.DBO.CONTRACT_DATA WHERE SETT_NO in(@@SETT_NO, @@SETT_NO1) AND SELL_BUY = @SELL_BUY  AND SETT_TYPE IN ('D','C','RD','RC')  and  (PQTY+SQTY)! = 0                       
And SCRIP_CD <>'BRKSCR'  AND PARTY_CODE IN (                    
SELECT cl_code FROM BSEDB_AB.DBO.Client1 WHERE Cl_type ='NRI')                    
GROUP BY PARTY_CODE,SAUDA_DATE,SELL_BUY,CONTRACTNO ,SETT_NO ) A                      
LEFT OUTER JOIN                       
(SELECT  PARTY_CODE,NSERTAX,BROKERAGE AS MINBROKERAGE ,SETT_NO                       
from BSEDB_AB.DBO.CONTRACT_DATA WHERE SETT_NO in (@@SETT_NO,@@SETT_NO1) AND SELL_BUY = @SELL_BUY AND SETT_TYPE IN ('D','C','RD','RC')                     
AND PARTY_CODE IN (SELECT cl_code FROM BSEDB_AB.DBO.Client1 WHERE Cl_type ='NRI')                    
and SCRIP_CD = 'BRKSCR')B                      
ON A.PARTY_CODE=B.PARTY_CODE  and a.sett_no=b.sett_no                    
GROUP BY EXCHANGE,A.PARTY_CODE,SAUDA_DATE,SELL_BUY,CONTRACTNO,                      
 EDUCESS,EXCHAGE_LEVIES,STT,STAMPDUTY,MINBROKERAGE,OTHER_CHARGES,NO_OF_TRANSACTIONS,TOTALAMT,NSERTAX ,            
 SERVICE_TAX,a.SETT_NO 

 --SELECT * FROM #DATA

SELECT * INTO #MAIN_DATA FROM #DATA WHERE CONTRACTNO<>'0'
SELECT * INTO #C_ZERO FROM #DATA WHERE CONTRACTNO='0'

--DECLARE @SDATE AS VARCHAR(11)='MAR  5 2025' , @SELL_BUY AS VARCHAR(1)='2'
SELECT M.EXCHANGE,M.PARTY_CODE,M.SAUDA_DATE,M.SELL_BUY,M.CONTRACTNO, (M.SERVICE_TAX+Z.SERVICE_TAX) AS SERVICE_TAX,(M.EDUCESS+Z.EDUCESS) AS EDUCESS,
(M.EXCHAGE_LEVIES+Z.EXCHAGE_LEVIES) AS EXCHAGE_LEVIES, (M.STT+Z.STT) AS STT, (M.STAMPDUTY+Z.STAMPDUTY) AS STAMPDUTY, (M.MINBROKERAGE+Z.MINBROKERAGE) AS MINBROKERAGE,
(M.OTHER_CHARGES+Z.OTHER_CHARGES) AS OTHER_CHARGES,M.NO_OF_TRANSACTIONS, CASE WHEN @SELL_BUY='1' THEN M.TOTALAMT+Z.TOTALAMT ELSE M.TOTALAMT END AS TOTALAMT,M.SETT_NO
INTO #CONTRACT_ZERO
FROM #MAIN_DATA M INNER JOIN #C_ZERO Z ON Z.PARTY_CODE=M.PARTY_CODE

--SELECT M.EXCHANGE,M.PARTY_CODE,M.SAUDA_DATE,M.SELL_BUY,M.CONTRACTNO, (M.SERVICE_TAX+Z.SERVICE_TAX) AS SERVICE_TAX,(M.EDUCESS+Z.EDUCESS) AS EDUCESS,
--(M.EXCHAGE_LEVIES+Z.EXCHAGE_LEVIES) AS EXCHAGE_LEVIES, (M.STT+Z.STT) AS STT, (M.STAMPDUTY+Z.STAMPDUTY) AS STAMPDUTY, (M.MINBROKERAGE+Z.MINBROKERAGE) AS MINBROKERAGE,
--(M.OTHER_CHARGES+Z.OTHER_CHARGES) AS OTHER_CHARGES,M.NO_OF_TRANSACTIONS, (M.TOTALAMT+Z.TOTALAMT) AS TOTALAMT,M.SETT_NO
----INTO #CONTRACT_ZERO
--FROM #MAIN_DATA M INNER JOIN #C_ZERO Z ON Z.PARTY_CODE=M.PARTY_CODE

DELETE FROM #MAIN_DATA WHERE PARTY_CODE IN (SELECT PARTY_CODE FROM #C_ZERO)
 
INSERT INTO #MAIN_DATA
SELECT * FROM #CONTRACT_ZERO

SELECT * FROM #MAIN_DATA --- FINAL DATA

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_FUNDTRANSFER_ENTRIES_bkp10may2025
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[GET_FUNDTRANSFER_ENTRIES_bkp10may2025]              
 @START_DATE VARCHAR(11),              
 @CLTCODE_FR VARCHAR(10),              
 @CLTCODE_TO VARCHAR(10),              
 @BRANCHCODE VARCHAR(10),              
 @EXCH_FR VARCHAR(10),              
 @EXCH_TO VARCHAR(10),              
 @SOURCE_SERVER VARCHAR(25),              
 @SOURCE_DB  VARCHAR(25),              
 @SOURCE_SHAREDB  VARCHAR(25),              
 @DESTINATION_SERVER VARCHAR(25),              
 @DESTINATION_DB  VARCHAR(25),              
 @DESTINATION_SHAREDB  VARCHAR(25),              
 @SESSIONID VARCHAR(20),              
 @MIN_AMT MONEY,        
 @ACTION CHAR(2) -- DA - DEBIT ADJUSTMENT / CT - CREDIT TRANSFER        
              
AS              
            
/*            
            
EXEC GET_FUNDTRANSFER_ENTRIES 'APR  7 2014','A','ZZZZZZ','', 'MCX','NCDEX','[ANGELCOMMODITY]','ACCOUNTMCDX','MCDX','[ANGELCOMMODITY]','ACCOUNTNCDX','NCDX','738966266442014', 1             
            
EXEC GET_FUNDTRANSFER_ENTRIES_NEW 'APR  7 2014','A','ZZZZ','', 'NCDEX','MCX','[ANGELCOMMODITY]','ACCOUNTNCDX','NCDX','[ANGELCOMMODITY]','ACCOUNTMCDX','MCDX','7005666554162014', 1            
            
EXEC GET_FUNDTRANSFER_ENTRIES 'APR  7 2014','A','ZZZZ','', 'NCDEX','MCX','[ANGELCOMMODITY]','ACCOUNTNCDX','NCDX','[ANGELCOMMODITY]','ACCOUNTMCDX','MCDX','7005666554162014', 1            
            
*/            
               
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED               
SET NOCOUNT ON               
              
             
            
CREATE TABLE #FUND_TRF_CLIENT              
(              
 CLTCODE VARCHAR(10),              
 ACNAME VARCHAR(100),              
 BRANCHCODE VARCHAR(10)              
)              
              
            
CREATE NONCLUSTERED INDEX [IDXCLTCODE] ON [DBO].[#FUND_TRF_CLIENT]                     
(                    
 CLTCODE                  
)                    
              
              
DECLARE            
@START_DATENEW VARCHAR(11)  ,            
@START_DATEM VARCHAR(11)              
              
SELECT @START_DATENEW = @START_DATE              
              
SELECT @START_DATE=CONVERT(VARCHAR(11),SDTCUR,109) FROM PARAMETER   WHERE @START_DATE BETWEEN SDTCUR AND LDTCUR              
              
SET  @START_DATEM = @START_DATE             
            
EXEC ANGELCOMMODITY.MCDX.DBO.MAR_INSERTMCDX @START_DATENEW            
            
EXEC ANGELCOMMODITY.NCDX.DBO.MAR_INSERTNCDX @START_DATENEW           
          
EXEC ANGELCOMMODITY.MCDXCDS.DBO.MAR_INSERTMCDXCDS @START_DATENEW        
      
EXEC ANGELCOMMODITY.BSEFO.DBO.MAR_INSERTBSEFO @START_DATENEW          
        
EXEC ANGELFO.NSEFO.DBO.MAR_INSERTNSEFO @START_DATENEW        
          
EXEC ANGELFO.NSECURFO.DBO.MAR_INSERTNSECURFO @START_DATENEW           
            
        
              
DECLARE              
 @SQL VARCHAR(MAX)              
              
SET @SQL = "INSERT INTO #FUND_TRF_CLIENT "              
SET @SQL = @SQL + "SELECT "              
SET @SQL = @SQL + " A.CLTCODE, "              
SET @SQL = @SQL + " A.ACNAME, "              
SET @SQL = @SQL + " A.BRANCHCODE "              
SET @SQL = @SQL + "FROM "              
SET @SQL = @SQL + " " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.ACMAST A  , "              
SET @SQL = @SQL + " " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.ACMAST AA   "              
SET @SQL = @SQL + "WHERE "              
SET @SQL = @SQL + " A.ACCAT = 4 "              
SET @SQL = @SQL + " AND A.CLTCODE BETWEEN '" + @CLTCODE_FR + "' AND '" + @CLTCODE_TO + "'"              
SET @SQL = @SQL + " AND A.BRANCHCODE LIKE '" + @BRANCHCODE + "%' "              
SET @SQL = @SQL + " AND A.CLTCODE = AA.CLTCODE"              
              
EXEC (@SQL)              
              
--PRINT @SQL              
              
SET @SQL = "DELETE L "              
SET @SQL = @SQL + " FROM   #FUND_TRF_CLIENT L, "              
SET @SQL = @SQL + " (SELECT CL_CODE, INACTIVEFROM FROM " + @SOURCE_SERVER + "." + @SOURCE_SHAREDB + ".DBO.CLIENT5   WHERE CL_CODE >= '" + @CLTCODE_FR + "' AND CL_CODE <= '" + @CLTCODE_TO + "') C5 "              
SET @SQL = @SQL + " WHERE  CLTCODE = CL_CODE "              
SET @SQL = @SQL + "       AND INACTIVEFROM < '" + @START_DATENEW + "'"                           
              
EXEC (@SQL)              
              
--PRINT @SQL              
              
SET @SQL = "DELETE L "              
SET @SQL = @SQL + "FROM   #FUND_TRF_CLIENT L, "              
SET @SQL = @SQL + "  (SELECT CL_CODE, INACTIVEFROM FROM " + @DESTINATION_SERVER + "." + @DESTINATION_SHAREDB + ".DBO.CLIENT5    WHERE CL_CODE >= '" + @CLTCODE_FR + "' AND CL_CODE <= '" + @CLTCODE_TO + "') C5  "              
SET @SQL = @SQL + " WHERE  CLTCODE = CL_CODE "              
SET @SQL = @SQL + "       AND INACTIVEFROM < '" + @START_DATENEW + "'"              
           
EXEC (@SQL)              
              
--PRINT @EXCH_FR            
            
IF @EXCH_FR NOT IN ('MCX','NCDEX')            
            
BEGIN             
            
DELETE F               
FROM   #FUND_TRF_CLIENT F,               
       MSAJAG.DBO.CLIENT_DETAILS O                 
WHERE  CLTCODE = CL_CODE               
       AND CL_TYPE IN ( 'NBF', 'TMF','NRI','NRE','NRO' )       
	   
/***Exception of MTF Clients***/   
END      

 DECLARE @MTF INT

 /*IF (@EXCH_FR='NSECM' AND @EXCH_TO ='BSECM') OR (@EXCH_FR='BSECM' AND @EXCH_TO ='NSECM') Changes done 16/03/2018 */ 
 IF  (@EXCH_FR IN ('NSECM','BSECM') AND   @EXCH_TO  IN ('NSEFO','BSEFO','NSX','MCD') ) 
    BEGIN 
	SET @MTF =1 
	END  
 ELSE 
   BEGIN 
    SET @MTF =0
   END 
	   
 IF (@MTF  =1)
    
	BEGIN 
				DELETE F               
				FROM   #FUND_TRF_CLIENT F,               
					   ANAND1.MTFTRADE.DBO.TblClientMargin O                 
				WHERE  CLTCODE = O.PARTY_CODE                
					   AND TO_DATE >GETDATE() 
  	END
	
/****/ 
	          
      

/*** EXCEPTION CLIENTS ADDED ON 27012017 ***/            
DELETE F               
FROM   #FUND_TRF_CLIENT F,               
       FUND_EXP_TRANSFER  O                 
WHERE  F.CLTCODE = O.CLTCODE                  
/***     ***/                           
             
CREATE TABLE [DBO].[#LEDGERTRANSFER]               
  (               
     [BRANCHCODE]    [VARCHAR](10) NULL,               
     [CLTCODE]       [VARCHAR](10) NOT NULL,               
     [ACNAME]        [CHAR](100) NOT NULL,               
     [LEDGERBALANCE] [MONEY] NULL,               
     [AMOUNT]        [MONEY] NULL               
  )               
ON [PRIMARY]            
            
              
SET @SQL = "INSERT INTO #LEDGERTRANSFER "              
SET @SQL = @SQL + "SELECT BRANCHCODE, "              
SET @SQL = @SQL + "       CLTCODE, "              
SET @SQL = @SQL + "       ACNAME, "              
SET @SQL = @SQL + "       LEDGERBALANCE = SUM(LEDGERBALANCE), "              
SET @SQL = @SQL + "       AMOUNT = 0 "              
SET @SQL = @SQL + "FROM   (SELECT A.BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               LEDGERBALANCE = SUM(CASE "              
SET @SQL = @SQL + "                                     WHEN L.DRCR = 'C' THEN L.VAMT "              
SET @SQL = @SQL + "                                     ELSE -L.VAMT "              
SET @SQL = @SQL + "                                   END) "              
SET @SQL = @SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE "              
SET @SQL = @SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.EDT <= '" + @START_DATENEW + "' "              
SET @SQL = @SQL + "                            + ' 23:59:59' "              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  A.BRANCHCODE "              
              
SET @SQL = @SQL + "        UNION ALL "              
SET @SQL = @SQL + "        SELECT A.BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               LEDGERBALANCE = SUM(CASE "              
SET @SQL = @SQL + "                                     WHEN L.DRCR = 'D' THEN L.VAMT "              
SET @SQL = @SQL + "                                     ELSE -L.VAMT "              
SET @SQL = @SQL + "                                   END) "              
SET @SQL = @SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A  "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE  "              
SET @SQL = @SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.VDT < '" + @START_DATE + "'"              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  A.BRANCHCODE "              
              
SET @SQL = @SQL + "        UNION ALL "              
SET @SQL = @SQL + "        SELECT A.BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               LEDGERBALANCE = -SUM(CASE "              
SET @SQL = @SQL + "           WHEN L.DRCR = 'C' THEN L.VAMT "              
SET @SQL = @SQL + "                                      ELSE 0 "              
SET @SQL = @SQL + "                                    END) "              
SET @SQL = @SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A, "              
SET @SQL = @SQL + "               " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER1 L1   "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE "              
SET @SQL = @SQL + "               AND L.VDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.VDT <= '" + @START_DATENEW + "' "              
SET @SQL = @SQL + "                            + ' 23:59:59' "              
SET @SQL = @SQL + "               AND L.VTYP = 2 "              
SET @SQL = @SQL + "               AND L.VNO = L1.VNO "              
SET @SQL = @SQL + "               AND L.VTYP = L1.VTYP "              
SET @SQL = @SQL + "               AND L.BOOKTYPE = L1.BOOKTYPE "              
SET @SQL = @SQL + "               AND L.LNO = L1.LNO "              
SET @SQL = @SQL + "               AND L1.RELDT = '' "              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  A.BRANCHCODE "              
              
SET @SQL = @SQL + "        UNION ALL "              
SET @SQL = @SQL + "        SELECT A.BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               LEDGERBALANCE = SUM(CASE "              
SET @SQL = @SQL + "                                     WHEN L.DRCR = 'C' THEN 0 "              
SET @SQL = @SQL + "                                     ELSE -L.VAMT "              
SET @SQL = @SQL + "                                   END) "              
SET @SQL = @SQL + "        FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE  "              
SET @SQL = @SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.VDT <= '" + @START_DATENEW + "' "              
SET @SQL = @SQL + "                            + ' 23:59:59' "              
SET @SQL = @SQL + "               AND L.EDT >= CONVERT(DATETIME,'" + @START_DATENEW + "') + 1 "              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  A.BRANCHCODE "              
SET @SQL = @SQL + "       ) F "              
SET @SQL = @SQL + "GROUP  BY CLTCODE, "              
SET @SQL = @SQL + "          ACNAME, "              
SET @SQL = @SQL + "          BRANCHCODE "              
SET @SQL = @SQL + "HAVING SUM(LEDGERBALANCE) > 0 "              
            
              
EXEC (@SQL)               
PRINT (@SQL)               
              
            
              
DELETE FROM #LEDGERTRANSFER WHERE LEDGERBALANCE <= @MIN_AMT              
            
SET @SQL = "INSERT INTO #LEDGERTRANSFER "              
SET @SQL = @SQL + "SELECT BRANCHCODE, "              
SET @SQL = @SQL + "       CLTCODE, "              
SET @SQL = @SQL + "       ACNAME, "              
SET @SQL = @SQL + "       LEDGERBALANCE = 0, "              
SET @SQL = @SQL + "       AMOUNT = SUM(AMOUNT) "              
SET @SQL = @SQL + "FROM   (SELECT BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "         
SET @SQL = @SQL + "               AMOUNT = SUM(CASE "              
SET @SQL = @SQL + "                              WHEN L.DRCR = 'C' THEN L.VAMT "              
SET @SQL = @SQL + "                              ELSE -L.VAMT "              
SET @SQL = @SQL + "                            END) "              
SET @SQL = @SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A "            
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE "              
SET @SQL = @SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.EDT <= '" + @START_DATENEW + "'"              
SET @SQL = @SQL + "                            + ' 23:59:59' "              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  BRANCHCODE "              
              
SET @SQL = @SQL + "        UNION ALL "              
SET @SQL = @SQL + "     SELECT BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               AMOUNT = SUM(CASE "              
SET @SQL = @SQL + "                              WHEN L.DRCR = 'D' THEN L.VAMT "              
SET @SQL = @SQL + "                              ELSE -L.VAMT "              
SET @SQL = @SQL + "                            END) "              
SET @SQL = @SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE  "              
SET @SQL = @SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.VDT < '" + @START_DATE + "'"              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  BRANCHCODE "              
              
SET @SQL = @SQL + "        UNION ALL "              
SET @SQL = @SQL + "        SELECT BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               AMOUNT = -SUM(CASE "              
SET @SQL = @SQL + "                               WHEN L.DRCR = 'C' THEN L.VAMT "              
SET @SQL = @SQL + "                               ELSE 0 "              
SET @SQL = @SQL + "                             END) "              
SET @SQL = @SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A, "              
SET @SQL = @SQL + "               " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER1 L1   "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE "              
SET @SQL = @SQL + "               AND L.VDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.VDT <= '" +  @START_DATENEW + "'"              
SET @SQL = @SQL + "                            + ' 23:59:59' "              
SET @SQL = @SQL + "               AND L.VTYP = 2 "              
SET @SQL = @SQL + "               AND L.VNO = L1.VNO "              
SET @SQL = @SQL + "    AND L.VTYP = L1.VTYP "              
SET @SQL = @SQL + "               AND L.BOOKTYPE = L1.BOOKTYPE "              
SET @SQL = @SQL + "               AND L.LNO = L1.LNO "              
SET @SQL = @SQL + "       AND L1.RELDT = '' "              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  BRANCHCODE "              
              
SET @SQL = @SQL + "        UNION ALL "              
SET @SQL = @SQL + "        SELECT BRANCHCODE, "              
SET @SQL = @SQL + "               A.CLTCODE, "              
SET @SQL = @SQL + "               A.ACNAME, "              
SET @SQL = @SQL + "               AMOUNT = SUM(CASE "              
SET @SQL = @SQL + "                              WHEN L.DRCR = 'C' THEN 0 "              
SET @SQL = @SQL + "                              ELSE -L.VAMT "              
SET @SQL = @SQL + "                            END) "              
SET @SQL = @SQL + "        FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.LEDGER L  , "              
SET @SQL = @SQL + "               #FUND_TRF_CLIENT A "              
SET @SQL = @SQL + "        WHERE  L.CLTCODE = A.CLTCODE  "              
SET @SQL = @SQL + "               AND L.EDT >= '" + @START_DATE + " 00:00:00' "              
SET @SQL = @SQL + "               AND L.EDT <= '" +  @START_DATENEW + "'"              
SET @SQL = @SQL + "                            + ' 23:59:59' "              
SET @SQL = @SQL + "               AND L.EDT >= CONVERT (DATETIME , '" +  @START_DATENEW + "') + 1 "              
SET @SQL = @SQL + "        GROUP  BY A.CLTCODE, "              
SET @SQL = @SQL + "                  A.ACNAME, "              
SET @SQL = @SQL + "                  BRANCHCODE "              
SET @SQL = @SQL + "       ) F "              
SET @SQL = @SQL + "GROUP  BY CLTCODE, "              
SET @SQL = @SQL + "          ACNAME, "              
SET @SQL = @SQL + "          BRANCHCODE"              
      
PRINT (@SQL)      
EXEC (@SQL)              
            
            
/* CHANGES DONE BY VINAY FOR BOTH SIDE CREDIT DATA POSTED*/            
            
--DELETE FROM #LEDGERTRANSFER WHERE AMOUNT <= @MIN_AMT AND LEDGERBALANCE = 0            
            
            
--DELETE FROM #LEDGERTRANSFER WHERE AMOUNT >= @MIN_AMT AND LEDGERBALANCE = 0              
            
            
/* CHANGES DONE BY VINAY FOR BOTH SIDE CREDIT DATA POSTED*/             
             
DECLARE              
 @SEGMENT_F VARCHAR(50),              
 @SEGMENT_D VARCHAR(50)              
              
CREATE TABLE #SEGMENT              
(              
 SEGMENT VARCHAR(50)              
)              
              
SET @SQL = "INSERT INTO #SEGMENT SELECT SEGMENT FROM   " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.OWNER L   "              
              
EXEC (@SQL)               
              
SELECT @SEGMENT_F = SEGMENT FROM #SEGMENT              
              
TRUNCATE TABLE #SEGMENT              
              
SET @SQL = "INSERT INTO #SEGMENT SELECT SEGMENT FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.OWNER L   "              
              
EXEC (@SQL)               
              
SELECT @SEGMENT_D = SEGMENT FROM #SEGMENT              
              
SET @SQL = ''              
              
              
IF @SEGMENT_F = 'FUTURES'              
BEGIN              
 SET @SQL = "INSERT INTO #LEDGERTRANSFER "              
 SET @SQL = @SQL + "SELECT BRANCHCODE = '', "              
 SET @SQL = @SQL + "    PARTY_CODE, "              
 SET @SQL = @SQL + "    ACNAME = '', "              
 SET @SQL = @SQL + "    LEDGERBALANCE = ( ( INITIALMARGIN + MTMMARGIN+PREMIUM_MARGIN+ADDMARGIN ) - ( "              
 SET @SQL = @SQL + "       CASH_COLL + MRG_REP_COLL_NCASH ) ) "              
 SET @SQL = @SQL + "       * -1, "              
 SET @SQL = @SQL + "    AMOUNT = 0 "              
 SET @SQL = @SQL + "FROM   " + @SOURCE_SERVER + "." + @SOURCE_SHAREDB + ".DBO.TBL_CLIENTMARGIN_JV   "              
 SET @SQL = @SQL + "WHERE  "      
 --SET @SQL = @SQL + " MARGINDATE = (SELECT TOP 1 MARGINDATE "              
 --SET @SQL = @SQL + "      FROM   " + @SOURCE_SERVER + "." + @SOURCE_SHAREDB + ".DBO.TBL_CLIENTMARGIN_JV   "              
 --SET @SQL = @SQL + "      ORDER  BY MARGINDATE DESC) "              
 SET @SQL = @SQL + "     ( INITIALMARGIN + MTMMARGIN+PREMIUM_MARGIN+ADDMARGIN ) - ( CASH_COLL + MRG_REP_COLL_NCASH ) > 0 "              
 SET @SQL = @SQL + "    AND EXISTS (SELECT CLTCODE "              
 SET @SQL = @SQL + "        FROM   #LEDGERTRANSFER "              
 SET @SQL = @SQL + "        WHERE  LEDGERBALANCE <> 0 AND CLTCODE = PARTY_CODE)  "              
            
 EXEC (@SQL)              
PRINT (@SQL)            
            
            
           
END              
              
SET @SQL = ''              
            
IF @SEGMENT_D = 'FUTURES'              
BEGIN              
 SET @SQL = "INSERT INTO #LEDGERTRANSFER "              
 SET @SQL = @SQL + "SELECT BRANCHCODE = '', "              
 SET @SQL = @SQL + "    PARTY_CODE, "              
 SET @SQL = @SQL + "    ACNAME = '', "              
 SET @SQL = @SQL + "    LEDGERBALANCE = 0, "              
 SET @SQL = @SQL + "    AMOUNT = ( ( INITIALMARGIN + MTMMARGIN+PREMIUM_MARGIN+ADDMARGIN ) - ( CASH_COLL + MRG_REP_COLL_NCASH ) ) "              
 SET @SQL = @SQL + "    * -1 "              
-- SET @SQL = @SQL + "    LEDGERBALANCE = ( ( INITIALMARGIN + MTMMARGIN ) - ( CASH_COLL + MRG_REP_COLL_NCASH ) ) , "              
-- SET @SQL = @SQL + "    * -1 "              
-- SET @SQL = @SQL + "    AMOUNT = 0"              
 SET @SQL = @SQL + "FROM   " + @DESTINATION_SERVER + "." + @DESTINATION_SHAREDB + ".DBO.TBL_CLIENTMARGIN_JV   "           
 SET @SQL = @SQL + "    WHERE ( INITIALMARGIN + MTMMARGIN+PREMIUM_MARGIN +ADDMARGIN) - ( CASH_COLL + MRG_REP_COLL_NCASH ) > 0 "              
       
 SET @SQL = @SQL + "    AND EXISTS (SELECT CLTCODE "              
 SET @SQL = @SQL + "       FROM   #LEDGERTRANSFER "              
 SET @SQL = @SQL + "       WHERE  CLTCODE = PARTY_CODE "              
 SET @SQL = @SQL + "        AND (AMOUNT <> 0 OR LEDGERBALANCE <>0) )  "              
               
 EXEC (@SQL)              
              
PRINT (@SQL)              
            
END              
              
              
--DELETE FROM #LEDGERTRANSFER WHERE AMOUNT >= @MIN_AMT AND LEDGERBALANCE = 0              
              
              
CREATE TABLE #LEDGERTRANSFER_F              
(              
 BRANCHCODE VARCHAR(10),              
 CLTCODE VARCHAR(10),              
 ACNAME VARCHAR(100),              
 LEDGERBALANCE MONEY,              
 AMOUNT MONEY              
)              
            
                      
INSERT INTO #LEDGERTRANSFER_F              
SELECT BRANCHCODE = MAX(BRANCHCODE),               
       A.CLTCODE,               
       ACNAME = MAX(A.ACNAME),               
       LEDGERBALANCE = SUM(LEDGERBALANCE),               
       AMOUNT = ABS(SUM(AMOUNT))               
FROM   #LEDGERTRANSFER A               
GROUP  BY A.CLTCODE               
--ADDED BY VINAY FOR MARGIN REQUIRED ENTRIES INCLUDE            
HAVING SUM(AMOUNT) < -1            
--ADDED BY VINAY FOR MARGIN REQUIRED ENTRIES INCLUDE            
ORDER  BY BRANCHCODE,               
          A.CLTCODE               
            
INSERT INTO FUNDSTRANSFER_LOG               
SELECT PARTYCODE = CLTCODE,               
       EXCH_FR = @EXCH_FR,               
       EXCH_TO = @EXCH_TO,               
       TRF_DT = @START_DATENEW,               
       EXCHFR_AMT = SUM(LEDGERBALANCE),               
       EXCHTO_AMT = SUM(CASE               
                          WHEN ACNAME <> '' THEN AMOUNT               
    ELSE 0               
                        END),               
       TOTAMT_LED_MAR_COL = SUM(AMOUNT),               
       CHK_BY = @CLTCODE_TO,               
       CHK_DT = @START_DATENEW               
FROM   #LEDGERTRANSFER               
GROUP  BY CLTCODE               
              
              
/*              
SELECT BRANCHCODE,               
       CLTCODE,               
       ACNAME,               
       LEDGERBALANCE,              
       AMOUNT               
FROM   #LEDGERTRANSFER_F               
WHERE LEDGERBALANCE >= 100 AND AMOUNT >= 100               
ORDER  BY BRANCHCODE,               
          CLTCODE               
*/              
              
DELETE LEDGERTRANSFER               
WHERE  SESSIONID = @SESSIONID               
              
INSERT INTO LEDGERTRANSFER               
SELECT *,               
       @SESSIONID               
FROM   #LEDGERTRANSFER_F               
              
SELECT         
 BRANCHCODE,        
 CLTCODE,        
 ACNAME,        
 LEDGERBALANCE,        
 AMOUNT1 = CASE WHEN @ACTION = 'DA' AND AMOUNT > LEDGERBALANCE THEN LEDGERBALANCE ELSE AMOUNT END,        
 AMOUNT,      
 SESSIONID        
FROM         
 LEDGERTRANSFER               
WHERE         
 LEDGERBALANCE >= @MIN_AMT         
 AND AMOUNT >= @MIN_AMT         
 AND SESSIONID = @SESSIONID          
ORDER BY        
 BRANCHCODE,               
    CLTCODE        
            
DROP TABLE #LEDGERTRANSFER_F               
       
DROP TABLE #LEDGERTRANSFER

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RDB_BSE_MASTAR_SYNC_BKP_03Sep2024
-- --------------------------------------------------

CREATE PROC [dbo].[USP_RDB_BSE_MASTAR_SYNC_BKP_03Sep2024]  
(@DATE AS DATETIME)  
AS BEGIN 

DELETE FROM BSEDB_AB.DBO.SETTLEMENT WHERE SAUDA_DATE >=@DATE AND SAUDA_DATE <=@DATE +' 23:59' AND Sett_type in ('D','C','RD','RC')
 
INSERT INTO   SETTLEMENT ([CONTRACTNO] ,[BILLNO] ,[TRADE_NO] ,[PARTY_CODE] ,[SCRIP_CD] ,[USER_ID] ,[TRADEQTY] ,[AUCTIONPART] ,[MARKETTYPE] ,[SERIES] ,[ORDER_NO] ,
[MARKETRATE] ,[SAUDA_DATE] ,[TABLE_NO] ,[LINE_NO] ,[VAL_PERC] ,[NORMAL] ,[DAY_PUC] ,[DAY_SALES] ,[SETT_PURCH] ,[SETT_SALES] ,[SELL_BUY] ,[SETTFLAG] ,
[BROKAPPLIED] ,[NETRATE] ,[AMOUNT] ,[INS_CHRG] ,[TURN_TAX] ,[OTHER_CHRG] ,[SEBI_TAX] ,[BROKER_CHRG] ,[SERVICE_TAX] ,[TRADE_AMOUNT] ,[BILLFLAG] ,[SETT_NO] ,
[NBROKAPP] ,[NSERTAX] ,[N_NETRATE] ,[SETT_TYPE] ,[PARTICIPANTCODE] ,[STATUS] ,[PRO_CLI] ,[CPID] ,[INSTRUMENT] ,[BOOKTYPE] ,[BRANCH_ID] ,[TMARK] ,[SCHEME] ,
[DUMMY1] ,[DUMMY2]) 
SELECT CONTRACTNO=CONTRACTNO_SEG,BILLNO=DENSE_RANK()OVER(ORDER BY SETT_NO,SETT_DESC,PARTY_CODE),TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID=USERID,TRADEQTY=QTY,
AUCTIONPART='N',MARKETTYPE='0',
SERIES ='BSE',ORDER_NO,  
MARKETRATE=MARKET_RATE, SAUDA_DATE=CONVERT(DATETIME,TRADE_TIME),   
TABLE_NO=0,LINE_NO=0,VAL_PERC=0,NORMAL=0,DAY_PUC=0,DAY_SALES=0, SETT_PURCH=0, SETT_SALES=0,SELL_BUY=BUYSELL,  
SETTFLAG=(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL+1 ELSE BUYSELL+3 END),BROKAPPLIED=NET_RATE_PER_UNIT,  
NETRATE=(CASE WHEN BUYSELL = 1 THEN MARKET_RATE+NET_RATE_PER_UNIT  
ELSE MARKET_RATE-NET_RATE_PER_UNIT END),  
AMOUNT=QTY*MARKET_RATE,INS_CHRG=STT,TURN_TAX,OTHER_CHRG=0,SEBI_TAX=SEBIFEE,BROKER_CHRG=STAMPDUTY,SERVICE_TAX,TRADE_AMOUNT=QTY*MARKET_RATE,  
BILLFLAG=(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL+1 ELSE BUYSELL+3 END),SETT_NO,NBROKAPP=NET_RATE_PER_UNIT,  
NSERTAX=SERVICE_TAX,N_NETRATE=(CASE WHEN BUYSELL = 1 THEN MARKET_RATE+NET_RATE_PER_UNIT ELSE MARKET_RATE-NET_RATE_PER_UNIT END),  
SETT_TYPE=SETT_DESC,PARTIPANTCODE=MEMID,STATUS='11',PRO_CLI='1',CPID=CONVERT(VARCHAR(8),CONVERT(DATETIME ,ORDER_TIME),108),INSTRUMENT=1,BOOKTYPE=1,
BRANCH_ID=PARTY_CODE,TMARK=TRADE_TYPE,  
SCHEME=0,DUMMY1=0,  
DUMMY2=MARKET_RATE  
FROM ANGELNSECM.MSAJAG.DBO.PCNORDERDETAILS_RTB WITH(NOLOCK) WHERE TRADE_DATE=@DATE  AND  SEGMENT ='BSE CM'  AND SETT_DESC in ('D','C','RD','RC')



DELETE FROM  CHARGES_DETAIL WHERE CD_SAUDA_DATE = @DATE  AND CD_Sett_type in ('D','C','RD','RC')

-- PRINT ('ADDITIONAL 2')  
INSERT INTO  CHARGES_DETAIL  ([CD_PARTY_CODE] ,[CD_SETT_NO] ,[CD_SETT_TYPE] ,[CD_SAUDA_DATE] ,[CD_CONTRACTNO] ,[CD_TRADE_NO] ,[CD_ORDER_NO] ,[CD_SCRIP_CD] ,
[CD_SERIES] ,[CD_BUYRATE] ,[CD_SELLRATE] ,[CD_TRDBUY_QTY] ,[CD_TRDSELL_QTY] ,[CD_DELBUY_QTY] ,[CD_DELSELL_QTY] ,[CD_TRDBUYBROKERAGE] ,[CD_TRDSELLBROKERAGE] ,
[CD_DELBUYBROKERAGE] ,[CD_DELSELLBROKERAGE] ,[CD_TOTALBROKERAGE] ,[CD_TRDBUYSERTAX] ,[CD_TRDSELLSERTAX] ,[CD_DELBUYSERTAX] ,[CD_DELSELLSERTAX] ,[CD_TOTALSERTAX] ,
[CD_TRDBUY_TURNOVER] ,[CD_TRDSELL_TURNOVER] ,[CD_DELBUY_TURNOVER] ,[CD_DELSELL_TURNOVER] ,[CD_COMPUTATION_LEVEL] ,[CD_MIN_BROKAMT] ,[CD_MAX_BROKAMT] ,
[CD_MIN_SCRIPAMT] ,[CD_MAX_SCRIPAMT] ,[CD_TIMESTAMP])
SELECT CD_PARTY_CODE =PARTY_CODE,CD_SETT_NO=SETT_NO,CD_SETT_TYPE=SETT_TYPE ,CD_SAUDA_DATE=TRADE_DATE,CD_CONTRACTNO=CONTRACTNO,CD_TRADE_NO='',  
CD_ORDER_NO =P.ORDER_NO,  
CD_SCRIP_CD =SCRIP_CD,CD_SERIES='BSE',  
CD_BUYRATE=(CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(TRADE_PRICE AS MONEY) ELSE  0 END ),  
CD_SELLRATE=(CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(TRADE_PRICE AS MONEY) ELSE 0 END ) ,  
CD_TRDBUY_QTY= (CASE WHEN INTRA_DELFLAG ='T' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_TRDSELL_QTY=(CASE WHEN INTRA_DELFLAG ='T' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_DELBUY_QTY =(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_DELSELL_QTY=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_TRDBUYBROKERAGE=(CASE WHEN INTRA_DELFLAG ='T' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(BROKERAGE AS MONEY)  ELSE 0 END )ELSE 0 END),  
CD_TRDSELLBROKERAGE=(CASE WHEN INTRA_DELFLAG ='T' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(BROKERAGE AS MONEY) ELSE 0 END )ELSE 0 END),  
CD_DELBUYBROKERAGE =(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(BROKERAGE AS MONEY)  ELSE 0 END )ELSE 0 END),  
CD_DELSELLBROKERAGE=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(BROKERAGE AS MONEY)  ELSE 0 END )ELSE 0 END),  
CD_TOTALBROKERAGE=BROKERAGE,CD_TRDBUYSERTAX=(CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(BROKERAGE AS MONEY)*18/100 ELSE 0 END ),  
CD_TRDSELLSERTAX=(CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(BROKERAGE AS MONEY)*18/100 ELSE 0 END ),CD_DELBUYSERTAX=0,CD_DELSELLSERTAX=0,  
CD_TOTALSERTAX=CAST(BROKERAGE AS MONEY)*18/100,  
CD_TRDBUY_TURNOVER= (CASE WHEN INTRA_DELFLAG ='T' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_TRDSELL_TURNOVER= (CASE WHEN INTRA_DELFLAG ='T' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_DELBUY_TURNOVER=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_DELSELL_TURNOVER=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_COMPUTATION_LEVEL=(CASE WHEN ORDER_NO <>'' THEN 'O'ELSE '' END),  
CD_MIN_BROKAMT='0',CD_MAX_BROKAMT='0',CD_MIN_SCRIPAMT='0',CD_MAX_SCRIPAMT='0',CD_TIMESTAMP=GETDATE()  
 FROM ANGELNSECM.MSAJAG.DBO.PRORDERWISEDETAILS_RTB P WHERE TRADE_DATE =@DATE  AND SETT_TYPE in ('D','C','RD','RC') 
AND  SEGMENT ='BSE CM'



-- PRINT ('ADDITIONAL 3')  
INSERT INTO  CHARGES_DETAIL  ([CD_PARTY_CODE] ,[CD_SETT_NO] ,[CD_SETT_TYPE] ,[CD_SAUDA_DATE] ,[CD_CONTRACTNO] ,[CD_TRADE_NO] ,[CD_ORDER_NO] ,[CD_SCRIP_CD] ,
[CD_SERIES] ,[CD_BUYRATE] ,[CD_SELLRATE] ,[CD_TRDBUY_QTY] ,[CD_TRDSELL_QTY] ,[CD_DELBUY_QTY] ,[CD_DELSELL_QTY] ,[CD_TRDBUYBROKERAGE] ,[CD_TRDSELLBROKERAGE] ,
[CD_DELBUYBROKERAGE] ,[CD_DELSELLBROKERAGE] ,[CD_TOTALBROKERAGE] ,[CD_TRDBUYSERTAX] ,[CD_TRDSELLSERTAX] ,[CD_DELBUYSERTAX] ,[CD_DELSELLSERTAX] ,[CD_TOTALSERTAX] ,
[CD_TRDBUY_TURNOVER] ,[CD_TRDSELL_TURNOVER] ,[CD_DELBUY_TURNOVER] ,[CD_DELSELL_TURNOVER] ,[CD_COMPUTATION_LEVEL] ,[CD_MIN_BROKAMT] ,[CD_MAX_BROKAMT] ,
[CD_MIN_SCRIPAMT] ,[CD_MAX_SCRIPAMT] ,[CD_TIMESTAMP])
SELECT  CD_PARTY_CODE =PARTY_CODE,CD_SETT_NO=SETT_NO,CD_SETT_TYPE=SETT_TYPE ,CD_SAUDA_DATE=TRADE_DATE,CD_CONTRACTNO=CONTRACTNO,CD_TRADE_NO='',  
CD_ORDER_NO =P.ORDER_NO,  
CD_SCRIP_CD ='BRKSCR',CD_SERIES='BSE',  
CD_BUYRATE=(CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(TRADE_PRICE AS MONEY) ELSE  0 END ),  
CD_SELLRATE=(CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(TRADE_PRICE AS MONEY) ELSE 0 END ) ,  
CD_TRDBUY_QTY= (CASE WHEN INTRA_DELFLAG ='I' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_TRDSELL_QTY=(CASE WHEN INTRA_DELFLAG ='I' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_DELBUY_QTY =(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_DELSELL_QTY=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT) ELSE 0 END ) ELSE 0 END),  
CD_TRDBUYBROKERAGE=(CASE WHEN INTRA_DELFLAG ='I' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(BROKERAGE AS MONEY)  ELSE 0 END )ELSE 0 END),  
CD_TRDSELLBROKERAGE=(CASE WHEN INTRA_DELFLAG ='I' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(BROKERAGE AS MONEY) ELSE 0 END )ELSE 0 END),  
CD_DELBUYBROKERAGE =CAST(BROKERAGE AS MONEY),  
CD_DELSELLBROKERAGE=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(BROKERAGE AS MONEY)  ELSE 0 END )ELSE 0 END),  
CD_TOTALBROKERAGE=BROKERAGE,CD_TRDBUYSERTAX=(CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(BROKERAGE AS MONEY)*18/100 ELSE 0 END ),  
CD_TRDSELLSERTAX=(CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(BROKERAGE AS MONEY)*18/100 ELSE 0 END ),
CD_DELBUYSERTAX=CAST(BROKERAGE AS MONEY)*18/100,CD_DELSELLSERTAX=0,  
CD_TOTALSERTAX=CAST(BROKERAGE AS MONEY)*18/100,  
CD_TRDBUY_TURNOVER= (CASE WHEN INTRA_DELFLAG ='I' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_TRDSELL_TURNOVER= (CASE WHEN INTRA_DELFLAG ='I' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_DELBUY_TURNOVER=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='1' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_DELSELL_TURNOVER=(CASE WHEN INTRA_DELFLAG ='D' THEN (CASE WHEN BUY_SELL_FLAG ='2' THEN CAST(QTY AS FLOAT)*CAST(TRADE_PRICE AS MONEY)  ELSE 0 END ) ELSE 0 END),  
CD_COMPUTATION_LEVEL=(CASE WHEN ORDER_NO <>'' THEN 'O'ELSE '' END),  
CD_MIN_BROKAMT='0',CD_MAX_BROKAMT='0',CD_MIN_SCRIPAMT='0',CD_MAX_SCRIPAMT='0',CD_TIMESTAMP=GETDATE()  
 FROM ANGELNSECM.MSAJAG.DBO.PRORDERWISEDETAILS_RTB P WHERE TRADE_DATE =@DATE   
AND  SEGMENT ='BSE CM' AND SECURITY_NAME LIKE '%ADDITIONAL%'  AND SETT_TYPE in ('D','C','RD','RC') 



DELETE FROM  TBL_STAMP_DATA WHERE CAST (SAUDA_DATE AS DATE)=@DATE AND SETT_TYPE IN ('C','D','RD','RC')  
DELETE FROM   STT_CLIENTDETAIL WHERE CAST (SAUDA_DATE AS DATE)=@DATE AND SETT_TYPE IN ('C','D','RD','RC')  

INSERT INTO  STT_CLIENTDETAIL
SELECT *  FROM ANGELNSECM.MSAJAG.DBO.STT_CLIENTDETAIL_RTB WHERE CAST (SAUDA_DATE AS DATE)=@DATE AND SETT_TYPE  IN ('C','D','RD','RC')  

INSERT INTO TBL_STAMP_DATA
SELECT *  FROM ANGELNSECM.MSAJAG.DBO.TBL_STAMP_DATA WHERE SAUDA_DATE=@DATE AND SETT_TYPE  IN ('C','D','RD','RC')  
 
 INSERT INTO TBL_TOT_DETAIL
SELECT SETT_NO,		SETT_TYPE,		SAUDA_DATE,		CONTRACTNO,		PARTY_CODE,		SCRIP_CD,		SERIES='BSE',		
TURN_TAX,		CHARGE_TYPE='',	CHARGE_PER=ISNULL(CHARGE_PER,'0.0001')
FROM ANGELNSECM.MSAJAG.DBO.TBL_TOT_DETAIL_RTB WHERE SAUDA_DATE=@DATE AND SETT_TYPE  IN ('C','D','RD','RC')  


DELETE FROM  BSEDB_AB.DBO.CHARGES_DETAIL
WHERE CD_SAUDA_DATE =@DATE AND ISNULL(CD_SCRIP_CD,'')=''

DECLARE @CONTNO VARCHAR(8)
SELECT @CONTNO=MAX(CONVERT(INT,CONTRACTNO)) FROM   SETTLEMENT WHERE SAUDA_DATE >=@DATE AND SAUDA_DATE <=@DATE +' 23:59'
 

UPDATE  CONTGEN SET CONTRACTNO=@CONTNO  WHERE GETDATE() BETWEEN START_DATE AND END_DATE 



SELECT * INTO #ORDER FROM ANGELNSECM.MSAJAG.DBO.TRADE_CUSTOM_BROKERAGE T  (NOLOCK) WHERE SAUDA_DATE =@DATE AND T.TABLE_NO >0 AND EXCHANGE ='BSE' 

CREATE INDEX #PARTY ON #ORDER(PARTY_CODE,ORDER_NO,TRADE_NO,SETT_TYPE,SETT_NO)

UPDATE H SET TABLE_NO=	T.TABLE_NO, LINE_NO	= T.LINE_NO, VAL_PERC=T.VAL_PERC,	NORMAL=T.NORMAL,	DAY_PUC	= T.DAY_PUC ,DAY_SALES=T.DAY_SALES,
SETT_PURCH=	T.SETT_PURCH ,SETT_SALES=T.SETT_SALES
  FROM #ORDER T  (NOLOCK),
 SETTLEMENT H (NOLOCK) WHERE 
 H.PARTY_CODE=T.PARTY_CODE  AND T.SETT_NO=H.SETT_NO AND H.SETT_TYPE =T.SETT_TYPE 
 AND H.ORDER_NO =T.ORDER_NO AND H.TRADE_NO =T.TRADE_NO 
AND T.SAUDA_DATE =@DATE AND H.TABLE_NO ='0'
 
END


---Added logic below for NRI to update contgen number

 Select party_code ,row_number()over(order by party_code) sno into #temp  from (
Select Distinct party_code,sell_buy  from settlement (Nolock) where sauda_date >=@DATE and sauda_date <=@DATE + ' 23:59'
and party_code in (select cl_code from client1 where cl_type ='NRI') )a
Group by party_code
having count(1) >1


IF ((select count(1) from #temp)=0)

BEGIN
PRINT 'No Record Found'
END

ELSE

BEGIN
 Alter table #temp
 add contno int

Declare @curcontno int
 Select @curcontno=ContractNo from Contgen where getdate() between Start_Date and end_date
 update #temp set contno =@curcontno +sno


update N set ContractNo =contno  from settlement n (Nolock) , #temp t where sauda_date >=@DATE and sauda_date <=@DATE + ' 23:59'
and n.party_code=t.party_code and sell_buy =2


 DECLAre @maxsno int
 select @maxsno = (Select max(contno) from #temp)
update  Contgen  set ContractNo= @maxsno where getdate() between Start_Date and end_date

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
-- TABLE dbo.Account_AB_BKP_09Aug2024
-- --------------------------------------------------
CREATE TABLE [dbo].[Account_AB_BKP_09Aug2024]
(
    [COSTNAME] CHAR(35) NOT NULL,
    [COSTCODE] SMALLINT NOT NULL,
    [CATCODE] SMALLINT NULL,
    [grpcode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SCHEME_MAPPING_12062023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_12062023]
(
    [SP_SrNo] INT IDENTITY(1,1) NOT NULL,
    [SP_Party_Code] VARCHAR(10) NOT NULL,
    [SP_Computation_Level] CHAR(1) NOT NULL,
    [SP_Inst_Type] VARCHAR(3) NOT NULL,
    [SP_Scrip] VARCHAR(12) NOT NULL,
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
    [SP_Date_From] DATETIME NOT NULL,
    [SP_Date_To] DATETIME NOT NULL,
    [SP_CreatedBy] VARCHAR(20) NOT NULL,
    [SP_CreatedOn] DATETIME NOT NULL,
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
    [SP_Date_From] DATETIME NOT NULL,
    [SP_Date_To] DATETIME NOT NULL,
    [SP_CreatedBy] VARCHAR(20) NOT NULL,
    [SP_CreatedOn] DATETIME NOT NULL,
    [SP_ModifiedBy] VARCHAR(20) NOT NULL,
    [SP_ModifiedOn] DATETIME NOT NULL
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
-- TABLE dbo.BSEDB_AB_Sett_MST_FULL_BKUP_23MAR2025
-- --------------------------------------------------
CREATE TABLE [dbo].[BSEDB_AB_Sett_MST_FULL_BKUP_23MAR2025]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CHARGES_DETAIL_BKUP_03APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[CHARGES_DETAIL_BKUP_03APR2023]
(
    [CD_SrNo] INT IDENTITY(1,1) NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sett_No] VARCHAR(7) NOT NULL,
    [CD_Sett_Type] VARCHAR(2) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_ContractNo] VARCHAR(7) NOT NULL,
    [CD_Trade_No] VARCHAR(14) NOT NULL,
    [CD_Order_No] VARCHAR(20) NULL,
    [CD_Scrip_Cd] VARCHAR(12) NOT NULL,
    [CD_Series] VARCHAR(3) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_TrdBuy_Qty] INT NOT NULL,
    [CD_TrdSell_Qty] INT NOT NULL,
    [CD_DelBuy_Qty] INT NOT NULL,
    [CD_DelSell_Qty] INT NOT NULL,
    [CD_TrdBuyBrokerage] MONEY NOT NULL,
    [CD_TrdSellBrokerage] MONEY NOT NULL,
    [CD_DelBuyBrokerage] MONEY NOT NULL,
    [CD_DelSellBrokerage] MONEY NOT NULL,
    [CD_TotalBrokerage] MONEY NOT NULL,
    [CD_TrdBuySerTax] MONEY NOT NULL,
    [CD_TrdSellSerTax] MONEY NOT NULL,
    [CD_DelBuySerTax] MONEY NOT NULL,
    [CD_DelSellSerTax] MONEY NOT NULL,
    [CD_TotalSerTax] MONEY NOT NULL,
    [CD_TrdBuy_TurnOver] MONEY NOT NULL,
    [CD_TrdSell_TurnOver] MONEY NOT NULL,
    [CD_DelBuy_TurnOver] MONEY NOT NULL,
    [CD_DelSell_TurnOver] MONEY NOT NULL,
    [CD_Computation_Level] CHAR(1) NOT NULL,
    [CD_Min_BrokAmt] MONEY NOT NULL,
    [CD_Max_BrokAmt] MONEY NOT NULL,
    [CD_Min_ScripAmt] MONEY NOT NULL,
    [CD_Max_ScripAmt] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client4_201_BSEDB_AB_bkp_20220114
-- --------------------------------------------------
CREATE TABLE [dbo].[client4_201_BSEDB_AB_bkp_20220114]
(
    [Cl_code] VARCHAR(10) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client4_201_BSEDB_AB_bkp_20220120
-- --------------------------------------------------
CREATE TABLE [dbo].[client4_201_BSEDB_AB_bkp_20220120]
(
    [Cl_code] VARCHAR(10) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Client4_rajeev_200123
-- --------------------------------------------------
CREATE TABLE [dbo].[Client4_rajeev_200123]
(
    [Cl_code] VARCHAR(10) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ContGen_15062023
-- --------------------------------------------------
CREATE TABLE [dbo].[ContGen_15062023]
(
    [ContractNo] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NOT NULL,
    [End_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.deliverydp_12DEC2023
-- --------------------------------------------------
CREATE TABLE [dbo].[deliverydp_12DEC2023]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [DpType] VARCHAR(4) NULL,
    [DpId] VARCHAR(16) NULL,
    [DpCltNo] VARCHAR(16) NULL,
    [Description] VARCHAR(50) NULL,
    [ACCOUNTTYPE] VARCHAR(4) NULL,
    [LICENCENO] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [DIVACNO] VARCHAR(10) NULL,
    [STATUS_FLAG] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fin_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[fin_temp]
(
    [f_numeber] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNT_AB_bkup_01DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNT_AB_bkup_01DEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
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
-- TABLE dbo.generate_sno_29092025
-- --------------------------------------------------
CREATE TABLE [dbo].[generate_sno_29092025]
(
    [SRNO] INT NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GLOBALS_BKUP_30SEP2024
-- --------------------------------------------------
CREATE TABLE [dbo].[GLOBALS_BKUP_30SEP2024]
(
    [year] VARCHAR(4) NOT NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] NUMERIC(10, 4) NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] INT NULL,
    [sebi_turn_ac] INT NULL,
    [broker_note_ac] INT NULL,
    [other_chrg_ac] INT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NOT NULL,
    [year_end_dt] DATETIME NOT NULL,
    [CESS_Tax] NUMERIC(10, 4) NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NULL,
    [DelBuyTrans] NUMERIC(18, 4) NULL,
    [DelSellTrans] NUMERIC(18, 4) NULL,
    [EDUCESSTAX] NUMERIC(18, 4) NULL,
    [STT_TAX_AC] INT NULL,
    [TOTTAXES_LESS] NUMERIC(18, 6) NULL,
    [TOTTAXES_HIGH] NUMERIC(18, 6) NULL,
    [ETFSELLTRANS] NUMERIC(18, 4) NULL,
    [SBCCHARGE] NUMERIC(18, 4) NULL,
    [KRISHICHARGE] NUMERIC(18, 4) NULL,
    [RTSELLTRANS] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.grpmast_250625
-- --------------------------------------------------
CREATE TABLE [dbo].[grpmast_250625]
(
    [grpname] VARCHAR(60) NULL,
    [grpmain] VARCHAR(13) NULL,
    [grpcode] VARCHAR(13) NULL,
    [vtyp] FLOAT NULL,
    [dispdetail] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.grpmast_test
-- --------------------------------------------------
CREATE TABLE [dbo].[grpmast_test]
(
    [grpname] VARCHAR(60) NULL,
    [grpmain] VARCHAR(13) NULL,
    [grpcode] VARCHAR(13) NULL,
    [vtyp] FLOAT NULL,
    [dispdetail] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.history_12022023
-- --------------------------------------------------
CREATE TABLE [dbo].[history_12022023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
    [Sauda_date] DATETIME NULL,
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
    [sett_no] VARCHAR(7) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(15) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL
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
-- TABLE dbo.LEDGER_BKP_20220802
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER_BKP_20220802]
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
-- TABLE dbo.LEDGER1_BKP_20220802
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER1_BKP_20220802]
(
    [bnkname] VARCHAR(100) NULL,
    [brnname] VARCHAR(100) NULL,
    [dd] CHAR(1) NULL,
    [ddno] VARCHAR(30) NULL,
    [dddt] DATETIME NULL,
    [reldt] DATETIME NULL,
    [relamt] MONEY NULL,
    [refno] CHAR(12) NOT NULL,
    [receiptno] INT NULL,
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] INT NULL,
    [drcr] CHAR(1) NULL,
    [BookType] CHAR(2) NULL,
    [MicrNo] INT NULL,
    [SlipNo] INT NULL,
    [slipdate] DATETIME NULL,
    [ChequeInName] VARCHAR(100) NULL,
    [Chqprinted] TINYINT NULL,
    [clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicltid_201_BSEDB_AB_bkp_20220114
-- --------------------------------------------------
CREATE TABLE [dbo].[multicltid_201_BSEDB_AB_bkp_20220114]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NOT NULL,
    [DpId] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NOT NULL,
    [Def] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicltid_201_BSEDB_AB_bkp_20220120
-- --------------------------------------------------
CREATE TABLE [dbo].[multicltid_201_BSEDB_AB_bkp_20220120]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NOT NULL,
    [DpId] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NOT NULL,
    [Def] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICLTID_BKP_19MAR2024
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICLTID_BKP_19MAR2024]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NOT NULL,
    [DpId] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NOT NULL,
    [Def] INT NOT NULL,
    [DDPIFLAG] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicltid_rajeev_200123
-- --------------------------------------------------
CREATE TABLE [dbo].[multicltid_rajeev_200123]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NOT NULL,
    [DpId] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NOT NULL,
    [Def] INT NOT NULL,
    [DDPIFLAG] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicltid02052024
-- --------------------------------------------------
CREATE TABLE [dbo].[multicltid02052024]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NOT NULL,
    [DpId] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NOT NULL,
    [Def] INT NOT NULL,
    [DDPIFLAG] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicltid30042024
-- --------------------------------------------------
CREATE TABLE [dbo].[multicltid30042024]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NOT NULL,
    [DpId] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NOT NULL,
    [Def] INT NOT NULL,
    [DDPIFLAG] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_23FEB2024
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_23FEB2024]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_bkup_18Dec2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_bkup_18Dec2023]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MultiIsin_INE870B01016
-- --------------------------------------------------
CREATE TABLE [dbo].[MultiIsin_INE870B01016]
(
    [Scrip_cd] VARCHAR(12) NOT NULL,
    [Series] CHAR(3) NULL,
    [Isin] VARCHAR(20) NOT NULL,
    [Valid] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCSANNEXURE_A_31aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCSANNEXURE_A_31aug2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_BAL] MONEY NULL,
    [UNENCUMBERED_MARGIN] MONEY NULL,
    [VALUE_SECURITIESTDAY] MONEY NULL,
    [FUNDS_RETAINED] MONEY NULL,
    [VALUE_SECURITIESRETAINED] MONEY NULL,
    [FUNDS_RELEASED] MONEY NULL,
    [SECURITIES_RELEASED] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCSANNEXURE_B_31aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCSANNEXURE_B_31aug2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_DEBITBAL] NUMERIC(2, 2) NOT NULL,
    [TDAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_BSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_BSECM] MONEY NULL,
    [TDAY_TURNOVER_BSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NSECM] MONEY NULL,
    [TDAY_TURNOVER_NSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSEFO] MONEY NULL,
    [TDAY_MARGIN_NSEFO] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSX] MONEY NULL,
    [TDAY_MARGIN_NSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_MCD] MONEY NULL,
    [TDAY_MARGIN_MCD] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [ACCRUALAMT] MONEY NULL,
    [UPDATEDON] DATETIME NULL,
    [Tday_FundsPayin_MCX] MONEY NULL,
    [Tday_FundsPayin_NCDX] MONEY NULL,
    [Tday_Margin_MCX] MONEY NULL,
    [Tday_Margin_NCDX] MONEY NULL,
    [Tday_Margin_BSECM] MONEY NULL,
    [Tday_Margin_NSECM] MONEY NULL,
    [Tday_Margin_BSX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCSANNEXURE_C_31aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCSANNEXURE_C_31aug2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(200) NULL,
    [ISIN] VARCHAR(50) NULL,
    [QUANTITY] FLOAT NULL,
    [CLOSING_RATE] MONEY NULL,
    [HAIRCUT] MONEY NULL,
    [VALUE] MONEY NULL,
    [SEGMENT] VARCHAR(50) NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCSANNEXURE_D_31aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCSANNEXURE_D_31aug2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(200) NULL,
    [ISIN] VARCHAR(50) NULL,
    [QUANTITY] FLOAT NULL,
    [CLOSING_RATE] MONEY NULL,
    [HAIRCUT] MONEY NULL,
    [VALUE] MONEY NULL,
    [SEGMENT] VARCHAR(50) NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCSANNEXURE_E_31aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCSANNEXURE_E_31aug2023]
(
    [PARTY_CODE] VARCHAR(30) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [COLL_TYPE] VARCHAR(15) NULL,
    [BANK_CODE] VARCHAR(50) NULL,
    [FD_BGNO] VARCHAR(75) NULL,
    [MATURITY_DATE] DATETIME NULL,
    [FINALAMOUNT] MONEY NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_Mst
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_Mst]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_19042025_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_19042025_bsedbAB_FULLBACKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_19052025_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_19052025_bsedbAB_FULLBACKUP]
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
    [Series] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_19052025bse_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_19052025bse_bsedbAB_FULLBACKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_19072025_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_19072025_bsedbAB_FULLBACKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_mst_2023747
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_mst_2023747]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_21JUN2025
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_21JUN2025]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_22022025_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_22022025_bsedbAB_FULLBACKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_22042025_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_22042025_bsedbAB_FULLBACKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_23032025_bsedbAB_FULLBACKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_23032025_bsedbAB_FULLBACKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_27apr2024
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_27apr2024]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_27Jan2026
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_27Jan2026]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst_bak_19012024
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst_bak_19012024]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MST_BKP_13NOV2024
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MST_BKP_13NOV2024]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_Mst_BKP_31032023
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_Mst_BKP_31032023]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_Mst_BKUP_26JUL2024
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_Mst_BKUP_26JUL2024]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MST_BSEDB_AB_bkup_27JAN2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MST_BSEDB_AB_bkup_27JAN2023]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_MSt_FEB2023_BKUP
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_MSt_FEB2023_BKUP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_Mst_sre39736_26082025
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_Mst_sre39736_26082025]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_MstBKP_29NOV2024
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_MstBKP_29NOV2024]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sett_no_2024106
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_no_2024106]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] SMALLDATETIME NULL,
    [Funds_Payout] SMALLDATETIME NULL,
    [Sec_Payin] SMALLDATETIME NULL,
    [Sec_Payout] SMALLDATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_18102022
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_18102022]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
    [Sauda_date] DATETIME NULL,
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
    [sett_no] VARCHAR(7) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(15) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Settlement_22JUL2024_513250
-- --------------------------------------------------
CREATE TABLE [dbo].[Settlement_22JUL2024_513250]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkp_06MAR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkp_06MAR2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_02FEB2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_02FEB2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Settlement_BKUP_03APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Settlement_BKUP_03APR2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Settlement_BKUP_06APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Settlement_BKUP_06APR2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_06MAR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_06MAR2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_12DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_12DEC2022]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_16JAN2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_16JAN2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Settlement_BKUP_16MAY2025
-- --------------------------------------------------
CREATE TABLE [dbo].[Settlement_BKUP_16MAY2025]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_17APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_17APR2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETTLEMENT_BKUP_17DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[SETTLEMENT_BKUP_17DEC2024]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_17JAN2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_17JAN2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Settlement_BKUP_18JAN2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Settlement_BKUP_18JAN2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement_bkup_25JAN2023
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement_bkup_25JAN2023]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(20) NULL,
    [MarketRate] MONEY NULL,
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
    [NetRate] NUMERIC(18, 4) NULL,
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
    [N_NetRate] NUMERIC(18, 4) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STT_CLIENTDETAIL_BKUP_03APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[STT_CLIENTDETAIL_BKUP_03APR2023]
(
    [RecType] INT NOT NULL,
    [Sett_no] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [ContractNo] VARCHAR(7) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] CHAR(3) NOT NULL,
    [Sauda_Date] DATETIME NOT NULL,
    [Branch_Id] VARCHAR(10) NOT NULL,
    [PDelPrice] MONEY NOT NULL,
    [PQtyDel] INT NOT NULL,
    [PAmtDel] MONEY NOT NULL,
    [PSTTDel] MONEY NOT NULL,
    [SDelPrice] MONEY NOT NULL,
    [SQtyDel] INT NOT NULL,
    [SAmtDel] MONEY NOT NULL,
    [SSTTDel] MONEY NOT NULL,
    [STrdPrice] MONEY NOT NULL,
    [SQtyTrd] INT NOT NULL,
    [SAmtTrd] MONEY NOT NULL,
    [SSTTTrd] MONEY NOT NULL,
    [TotalSTT] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.subbroker_b2b_19062023
-- --------------------------------------------------
CREATE TABLE [dbo].[subbroker_b2b_19062023]
(
    [Sub_broker] VARCHAR(10) NOT NULL,
    [b2c] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_11Mar2023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_11Mar2023]
(
    [SNo] FLOAT NULL,
    [CltCode] NVARCHAR(255) NULL,
    [DebitAmt] FLOAT NULL
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
-- TABLE dbo.tbl_auto_process_master_BKUP_BSEDB_AB_21DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_BSEDB_AB_21DEC2024]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_BSEDB_AB_BKUP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_BSEDB_AB_BKUP_13MAY2024]
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
-- TABLE dbo.tbl_ClientNotigrated_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientNotigrated_Log]
(
    [ClCode] VARCHAR(20) NULL,
    [SNo] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_DRIP
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_DRIP]
(
    [GPXIP] VARCHAR(50) NULL,
    [NTTIP] VARCHAR(13) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_HOLDING_USER_DT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_HOLDING_USER_DT]
(
    [LOGINID] VARCHAR(50) NULL,
    [PASSWORDKEY] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_HOLDING_USER_DT_BKP_20220718
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_HOLDING_USER_DT_BKP_20220718]
(
    [LOGINID] VARCHAR(50) NULL,
    [PASSWORDKEY] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_HOLDING_USER_DT_bkup_29AUG2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_HOLDING_USER_DT_bkup_29AUG2023]
(
    [LOGINID] VARCHAR(50) NULL,
    [PASSWORDKEY] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_A_TEMP_11jul2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_A_TEMP_11jul2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_BAL] MONEY NULL,
    [UNENCUMBERED_MARGIN] MONEY NULL,
    [VALUE_SECURITIESTDAY] MONEY NULL,
    [FUNDS_RETAINED] MONEY NULL,
    [VALUE_SECURITIESRETAINED] MONEY NULL,
    [FUNDS_RELEASED] MONEY NULL,
    [SECURITIES_RELEASED] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_B_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_B_TEMP]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_DEBITBAL] NUMERIC(2, 2) NOT NULL,
    [TDAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_BSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_BSECM] MONEY NULL,
    [TDAY_TURNOVER_BSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NSECM] MONEY NULL,
    [TDAY_TURNOVER_NSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSEFO] MONEY NULL,
    [TDAY_MARGIN_NSEFO] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSX] MONEY NULL,
    [TDAY_MARGIN_NSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_MCD] MONEY NULL,
    [TDAY_MARGIN_MCD] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [ACCRUALAMT] MONEY NULL,
    [UPDATEDON] DATETIME NULL,
    [Tday_FundsPayin_MCX] MONEY NULL,
    [Tday_FundsPayin_NCDX] MONEY NULL,
    [Tday_Margin_MCX] MONEY NULL,
    [Tday_Margin_NCDX] MONEY NULL,
    [Tday_Margin_BSECM] MONEY NULL,
    [Tday_Margin_NSECM] MONEY NULL,
    [Tday_Margin_BSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_NCE] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NCE] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NCE] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NCE] MONEY NULL,
    [TDAY_TURNOVER_NCE] MONEY NULL,
    [Tday_Margin_NCE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_B_TEMP_05jan2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_B_TEMP_05jan2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_DEBITBAL] NUMERIC(2, 2) NOT NULL,
    [TDAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_BSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_BSECM] MONEY NULL,
    [TDAY_TURNOVER_BSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NSECM] MONEY NULL,
    [TDAY_TURNOVER_NSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSEFO] MONEY NULL,
    [TDAY_MARGIN_NSEFO] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSX] MONEY NULL,
    [TDAY_MARGIN_NSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_MCD] MONEY NULL,
    [TDAY_MARGIN_MCD] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [ACCRUALAMT] MONEY NULL,
    [UPDATEDON] DATETIME NULL,
    [Tday_FundsPayin_MCX] MONEY NULL,
    [Tday_FundsPayin_NCDX] MONEY NULL,
    [Tday_Margin_MCX] MONEY NULL,
    [Tday_Margin_NCDX] MONEY NULL,
    [Tday_Margin_BSECM] MONEY NULL,
    [Tday_Margin_NSECM] MONEY NULL,
    [Tday_Margin_BSX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_B_TEMP_09jan2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_B_TEMP_09jan2024]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_DEBITBAL] NUMERIC(2, 2) NOT NULL,
    [TDAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_BSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_BSECM] MONEY NULL,
    [TDAY_TURNOVER_BSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NSECM] MONEY NULL,
    [TDAY_TURNOVER_NSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSEFO] MONEY NULL,
    [TDAY_MARGIN_NSEFO] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSX] MONEY NULL,
    [TDAY_MARGIN_NSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_MCD] MONEY NULL,
    [TDAY_MARGIN_MCD] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [ACCRUALAMT] MONEY NULL,
    [UPDATEDON] DATETIME NULL,
    [Tday_FundsPayin_MCX] MONEY NULL,
    [Tday_FundsPayin_NCDX] MONEY NULL,
    [Tday_Margin_MCX] MONEY NULL,
    [Tday_Margin_NCDX] MONEY NULL,
    [Tday_Margin_BSECM] MONEY NULL,
    [Tday_Margin_NSECM] MONEY NULL,
    [Tday_Margin_BSX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_B_TEMP_09Jan2024_2
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_B_TEMP_09Jan2024_2]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_DEBITBAL] NUMERIC(2, 2) NOT NULL,
    [TDAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_BSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_BSECM] MONEY NULL,
    [TDAY_TURNOVER_BSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NSECM] MONEY NULL,
    [TDAY_TURNOVER_NSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSEFO] MONEY NULL,
    [TDAY_MARGIN_NSEFO] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSX] MONEY NULL,
    [TDAY_MARGIN_NSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_MCD] MONEY NULL,
    [TDAY_MARGIN_MCD] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [ACCRUALAMT] MONEY NULL,
    [UPDATEDON] DATETIME NULL,
    [Tday_FundsPayin_MCX] MONEY NULL,
    [Tday_FundsPayin_NCDX] MONEY NULL,
    [Tday_Margin_MCX] MONEY NULL,
    [Tday_Margin_NCDX] MONEY NULL,
    [Tday_Margin_BSECM] MONEY NULL,
    [Tday_Margin_NSECM] MONEY NULL,
    [Tday_Margin_BSX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_B_TEMP_11jul2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_B_TEMP_11jul2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [UNENCUMBERED_DEBITBAL] NUMERIC(2, 2) NOT NULL,
    [TDAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_BSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_BSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_BSECM] MONEY NULL,
    [TDAY_TURNOVER_BSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [T_1DAY_FUNDSPAYIN_NSECM] MONEY NULL,
    [TDAY_SECURITIESPAYIN_NSECM] MONEY NULL,
    [T_1DAY_SECURITESPAYIN_NSECM] MONEY NULL,
    [TDAY_TURNOVER_NSECM] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSEFO] MONEY NULL,
    [TDAY_MARGIN_NSEFO] MONEY NULL,
    [TDAY_FUNDSPAYIN_NSX] MONEY NULL,
    [TDAY_MARGIN_NSX] MONEY NULL,
    [TDAY_FUNDSPAYIN_MCD] MONEY NULL,
    [TDAY_MARGIN_MCD] MONEY NULL,
    [OTHERSEGMENTDEBIT] MONEY NULL,
    [ACCRUALAMT] MONEY NULL,
    [UPDATEDON] DATETIME NULL,
    [Tday_FundsPayin_MCX] MONEY NULL,
    [Tday_FundsPayin_NCDX] MONEY NULL,
    [Tday_Margin_MCX] MONEY NULL,
    [Tday_Margin_NCDX] MONEY NULL,
    [Tday_Margin_BSECM] MONEY NULL,
    [Tday_Margin_NSECM] MONEY NULL,
    [Tday_Margin_BSX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_C_TEMP_11jul2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_C_TEMP_11jul2023]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(200) NULL,
    [ISIN] VARCHAR(50) NULL,
    [QUANTITY] FLOAT NULL,
    [CLOSING_RATE] MONEY NULL,
    [HAIRCUT] MONEY NULL,
    [VALUE] MONEY NULL,
    [SEGMENT] VARCHAR(50) NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSANNEXURE_E_TEMP_11jul2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSANNEXURE_E_TEMP_11jul2023]
(
    [PARTY_CODE] VARCHAR(30) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [COLL_TYPE] VARCHAR(15) NULL,
    [BANK_CODE] VARCHAR(50) NULL,
    [FD_BGNO] VARCHAR(75) NULL,
    [MATURITY_DATE] DATETIME NULL,
    [FINALAMOUNT] MONEY NULL,
    [UPDATEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Server_DBServerAccess_01112025
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Server_DBServerAccess_01112025]
(
    [DBServerId] INT IDENTITY(1,1) NOT NULL,
    [IPAdd] VARCHAR(50) NULL,
    [Port] INT NULL,
    [Segment] VARCHAR(50) NULL,
    [DB] VARCHAR(100) NULL,
    [Remarks] VARCHAR(100) NULL,
    [OwnerShipTeam] VARCHAR(20) NULL,
    [ServerOwner] VARCHAR(50) NULL,
    [CreateDate] DATETIME NULL,
    [DBUserName] VARCHAR(10) NULL,
    [DBPass] VARCHAR(20) NULL,
    [DBUserName_Citrus] VARCHAR(10) NULL,
    [DBPass_Citrus] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Server_DBServerAccess_bkp27072025
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Server_DBServerAccess_bkp27072025]
(
    [DBServerId] INT IDENTITY(1,1) NOT NULL,
    [IPAdd] VARCHAR(50) NULL,
    [Port] INT NULL,
    [Segment] VARCHAR(50) NULL,
    [DB] VARCHAR(100) NULL,
    [Remarks] VARCHAR(100) NULL,
    [OwnerShipTeam] VARCHAR(20) NULL,
    [ServerOwner] VARCHAR(50) NULL,
    [CreateDate] DATETIME NULL,
    [DBUserName] VARCHAR(10) NULL,
    [DBPass] VARCHAR(20) NULL,
    [DBUserName_Citrus] VARCHAR(10) NULL,
    [DBPass_Citrus] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_STAMP_DATA_BKUP_03APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_STAMP_DATA_BKUP_03APR2023]
(
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(3) NOT NULL,
    [CONTRACTNO] VARCHAR(7) NULL,
    [TRADE_TYPE] VARCHAR(1) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(10) NOT NULL,
    [SERIES] CHAR(3) NOT NULL,
    [BUYSQQTY] INT NULL,
    [SELLSQQTY] INT NULL,
    [BUYDELQTY] INT NULL,
    [SELLDELQTY] INT NULL,
    [BUYAVGRATE] NUMERIC(38, 2) NULL,
    [SELLAVGRATE] NUMERIC(38, 2) NULL,
    [BUYSQSTAMP] NUMERIC(38, 2) NULL,
    [SELLSQSTAMP] NUMERIC(38, 2) NULL,
    [BUYDELSTAMP] NUMERIC(38, 2) NULL,
    [SELLDELSTAMP] NUMERIC(38, 2) NULL,
    [TOTALSTAMP] NUMERIC(38, 2) NULL,
    [L_STATE] VARCHAR(100) NULL,
    [LASTRUNDATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_TOT_DETAIL_BKUP_03APR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_TOT_DETAIL_BKUP_03APR2023]
(
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(3) NOT NULL,
    [SAUDA_DATE] DATETIME NULL,
    [CONTRACTNO] VARCHAR(7) NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(10) NOT NULL,
    [SERIES] CHAR(3) NOT NULL,
    [TURN_TAX] MONEY NULL,
    [CHARGE_TYPE] VARCHAR(5) NULL,
    [CHARGE_PER] NUMERIC(18, 6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblcatmenu_BKP_04072023
-- --------------------------------------------------
CREATE TABLE [dbo].[tblcatmenu_BKP_04072023]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldreportcode] INT NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldcategorycode] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblcatmenu_BKP_04July2023
-- --------------------------------------------------
CREATE TABLE [dbo].[tblcatmenu_BKP_04July2023]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldreportcode] INT NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldcategorycode] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblPradnyausers_T0_Series_data
-- --------------------------------------------------
CREATE TABLE [dbo].[tblPradnyausers_T0_Series_data]
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
-- TABLE dbo.tblusercontrolmaster_BKP_02MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tblusercontrolmaster_BKP_02MAY2024]
(
    [FLDAUTO] BIGINT NOT NULL,
    [FLDUSERID] INT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDSTATUS] SMALLINT NULL,
    [FLDLOGINFLAG] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL,
    [FLD_MAC_ID] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Business_Process_12JAN2024
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Business_Process_12JAN2024]
(
    [Business_Date] SMALLDATETIME NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Import_Trade] INT NULL,
    [Billing] INT NULL,
    [VBB] INT NULL,
    [STT] INT NULL,
    [Valan] INT NULL,
    [Contract] INT NULL,
    [Posting] INT NULL,
    [Open_Close] INT NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(20) NULL,
    [LastUpdateDate] DATETIME NULL,
    [LastUpdateBy] VARCHAR(20) NULL,
    [MachineIP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Business_Process_bkp27122023
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Business_Process_bkp27122023]
(
    [Business_Date] SMALLDATETIME NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Import_Trade] INT NULL,
    [Billing] INT NULL,
    [VBB] INT NULL,
    [STT] INT NULL,
    [Valan] INT NULL,
    [Contract] INT NULL,
    [Posting] INT NULL,
    [Open_Close] INT NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(20) NULL,
    [LastUpdateDate] DATETIME NULL,
    [LastUpdateBy] VARCHAR(20) NULL,
    [MachineIP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.v2_Login_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[v2_Login_Log]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [UserId] INT NULL,
    [UserName] VARCHAR(64) NULL,
    [Category] VARCHAR(64) NULL,
    [StatusName] VARCHAR(32) NULL,
    [StatusId] VARCHAR(32) NULL,
    [IPADD] VARCHAR(20) NULL,
    [Action] VARCHAR(6) NULL,
    [AddDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Offline_Ledger_Entries_06mAR2023
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Offline_Ledger_Entries_06mAR2023]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] VARCHAR(2) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] VARCHAR(10) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(10) NULL,
    [MarginCode] VARCHAR(10) NULL,
    [BankName] VARCHAR(100) NULL,
    [BranchName] VARCHAR(100) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [DDNo] VARCHAR(30) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(100) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(20) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(25) NULL,
    [StatusID] VARCHAR(25) NULL,
    [StatusName] VARCHAR(25) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(25) NULL,
    [VoucherNo] VARCHAR(12) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(12) NULL,
    [ClientName] VARCHAR(100) NULL,
    [OppCodeName] VARCHAR(100) NULL,
    [MarginCodeName] VARCHAR(100) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [ProductType] VARCHAR(3) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(10) NULL,
    [MICR] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Offline_Ledger_Entries_AWS_DPC_Test_17062023
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Offline_Ledger_Entries_AWS_DPC_Test_17062023]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] VARCHAR(2) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] VARCHAR(10) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(10) NULL,
    [MarginCode] VARCHAR(10) NULL,
    [BankName] VARCHAR(100) NULL,
    [BranchName] VARCHAR(100) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [DDNo] VARCHAR(30) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(100) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(20) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(25) NULL,
    [StatusID] VARCHAR(25) NULL,
    [StatusName] VARCHAR(25) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(25) NULL,
    [VoucherNo] VARCHAR(12) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(12) NULL,
    [ClientName] VARCHAR(100) NULL,
    [OppCodeName] VARCHAR(100) NULL,
    [MarginCodeName] VARCHAR(100) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [ProductType] VARCHAR(3) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(10) NULL,
    [MICR] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Process_Status_Log_07March2024
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Process_Status_Log_07March2024]
(
    [SNO] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [BusinessDate] SMALLDATETIME NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [ProcessName] VARCHAR(50) NULL,
    [FileName] VARCHAR(255) NULL,
    [Start_End_Flag] INT NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(64) NULL,
    [MachineIP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Process_Status_Log_bkp27122023
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Process_Status_Log_bkp27122023]
(
    [SNO] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [BusinessDate] SMALLDATETIME NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [ProcessName] VARCHAR(50) NULL,
    [FileName] VARCHAR(255) NULL,
    [Start_End_Flag] INT NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(64) NULL,
    [MachineIP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Report_Access_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Report_Access_Log]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [RepPath] VARCHAR(4000) NULL,
    [UserId] INT NULL,
    [UserName] VARCHAR(64) NULL,
    [StatusName] VARCHAR(32) NULL,
    [StatusID] VARCHAR(32) NULL,
    [IPAdd] VARCHAR(20) NULL,
    [AddDt] DATETIME NULL
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

