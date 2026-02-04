-- DDL Export
-- Server: 10.253.33.233
-- Database: Dustbin
-- Exported: 2026-02-05T02:37:50.015103

USE Dustbin;
GO

-- --------------------------------------------------
-- INDEX dbo.Brokchangenew
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Dx] ON [dbo].[Brokchangenew] ([partycode])

GO

-- --------------------------------------------------
-- INDEX dbo.mapp_comm
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [mapp] ON [dbo].[mapp_comm] ([party_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.LEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[LEDGER] ADD CONSTRAINT [PK1_LEDGER] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ClientMargin_Upd_BKUP_13MAR2025
-- --------------------------------------------------




CREATE PROC [dbo].[ClientMargin_Upd_BKUP_13MAR2025]
(
           @mdate VARCHAR(11)
)
AS

  DECLARE  @@opendate  AS VARCHAR(11)
                          
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  SELECT *
  INTO   #TBL_CLIENTMARGIN
  FROM   TBL_CLIENTMARGIN
  WHERE  1 = 2
             
  INSERT INTO #TBL_CLIENTMARGIN
  SELECT DISTINCT C2.PARTY_CODE,
                  @mdate + ' 00:00',
                  0,
                  0,
                  0,
                  0,
                  0,
                  GETDATE(),
                  C1.SHORT_NAME,
                  LEFT(C1.LONG_NAME,50),
                  LTRIM(RTRIM(C1.BRANCH_CD)),
                  LTRIM(RTRIM(C1.FAMILY)),
                  LTRIM(RTRIM(C1.SUB_BROKER)),
                  LTRIM(RTRIM(C1.TRADER)),
                  0,
                  0
  FROM   CLIENT2 C2,
         CLIENT1 C1
  WHERE  C1.CL_CODE = C2.CL_CODE
                      
  UPDATE T
  SET    BILLAMOUNT = AMOUNT
  FROM   #TBL_CLIENTMARGIN T,
         (SELECT   PARTY_CODE,
                   AMOUNT = ISNULL(SUM((CASE 
                                          WHEN SELL_BUY = 2 THEN ISNULL(AMOUNT,0)
                                          ELSE (0 - ISNULL(AMOUNT,0))
                                        END)),0)
          FROM     FOACCBILL
          WHERE    BILLDATE LIKE @mdate + '%'
          GROUP BY PARTY_CODE) P
  WHERE  P.PARTY_CODE = T.PARTY_CODE
                        
  /*Getting Closing balance from Ledger with out  today's bill*/
  SELECT *
  INTO   #LEDGER
  FROM   ACCOUNTNCE.DBO.LEDGER
  WHERE  CLTCODE IN (SELECT DISTINCT PARTY_CODE
                     FROM   #TBL_CLIENTMARGIN)
                    
  SELECT @@opendate = (SELECT LEFT(CONVERT(VARCHAR,ISNULL(MAX(VDT),0),109),11)
                       FROM   #LEDGER
                       WHERE  VTYP = 18
                              AND VDT <= @mdate + ' 23:59')
                      
  SELECT CLTCODE,
         OPPBAL = VAMT
  INTO   #OPPBALANCE
  FROM   #LEDGER
  WHERE  1 = 2
             
  IF @@opendate <> ''
    BEGIN
      INSERT INTO #OPPBALANCE
                  
      SELECT   CLTCODE,
               SUM(OPPBAL)  OPPBAL
      FROM     (SELECT   CLTCODE,
                         OPPBAL = ISNULL(SUM(CASE 
                                               WHEN UPPER(B.DRCR) = 'C' THEN B.VAMT
                                               ELSE -B.VAMT
                                             END),0)
                FROM     #LEDGER B
                WHERE    B.VDT LIKE @@opendate + '%'
                         AND VTYP = 18
                GROUP BY CLTCODE
                         
                UNION ALL
               
                SELECT   CLTCODE,
                         OPPBAL = ISNULL(SUM(CASE 
                                               WHEN UPPER(B.DRCR) = 'C' THEN B.VAMT
                                               ELSE -B.VAMT
                                             END),0)
                FROM     #LEDGER B
                WHERE    B.VDT >= @@opendate
                         AND VDT < @mdate
                         AND VTYP <> 18
                GROUP BY CLTCODE) T
      GROUP BY CLTCODE
    END
  ELSE
    BEGIN
      INSERT INTO #OPPBALANCE
      SELECT   CLTCODE,
               OPPBAL = ISNULL(SUM(CASE 
                                     WHEN UPPER(B.DRCR) = 'C' THEN B.VAMT
                                     ELSE -B.VAMT
                                   END),0)
      FROM     #LEDGER B
      WHERE    VDT < @mdate
      GROUP BY CLTCODE
    END
    
  SELECT   CLTCODE,
           ROUND(SUM(OPPBAL),2)  OPPBAL
  INTO     #OPPBALANCEFINAL
  FROM     (SELECT   CLTCODE,
                     SUM(OPPBAL)  OPPBAL
            FROM     #OPPBALANCE
            GROUP BY CLTCODE
                     
            UNION ALL
           
            SELECT   CLTCODE,
                     OPPBAL = ISNULL(SUM(CASE 
                                           WHEN UPPER(B.DRCR) = 'C' THEN B.VAMT
                                           ELSE -B.VAMT
                                         END),0)
            FROM     #LEDGER B
            WHERE    VDT LIKE @mdate + '%'
                     AND (VTYP <> '15'
                           OR (NARRATION LIKE 'Settno=%'
                               AND VTYP = '15')
			   OR (narration not like 'NCE'+@mdate + '%' and vtyp  ='15')
			) AND VTYP <> '18' 

            GROUP BY CLTCODE) T
  GROUP BY CLTCODE
           
  UPDATE T
  SET    LEDGERAMOUNT = OPPBAL
  FROM   #TBL_CLIENTMARGIN T,
         #OPPBALANCEFINAL P
  WHERE  P.CLTCODE = T.PARTY_CODE
                     
  /*getting collateral from msajag*/
  UPDATE T
  SET    CASH_COLL = ACTCASH,
         NONCASH_COLL = ACTNONCASH
  FROM   #TBL_CLIENTMARGIN T,
         (SELECT PARTY_CODE,
                 ACTCASH = ISNULL(CASH,0),
                 ACTNONCASH = ISNULL(NONCASH,0)
          FROM   MSAJAG.DBO.COLLATERAL
          WHERE  EXCHANGE = 'NCE'
                 AND SEGMENT LIKE 'FUT%'
                 AND TRANS_DATE LIKE @mdate + '%') P
  WHERE  P.PARTY_CODE = T.PARTY_CODE
                        
  /*getting margin details*/
/*
  UPDATE T
  SET    INITIALMARGIN = P.MARGINAMOUNT,
         MTMMARGIN = P.MTMMARGIN,
         ADDMARGIN = P.ADDMARGIN
  FROM   #TBL_CLIENTMARGIN T,
         (SELECT   PARTY_CODE,
                   SUM(TOTALMARGIN - ADDMARGIN) MARGINAMOUNT,
                   MTMMARGIN = SUM(MTOM),
                   ADDMARGIN = SUM(ADDMARGIN)
          FROM     FOMARGINNEW
          WHERE    CL_TYPE LIKE 'C%'
                   AND MDATE LIKE (SELECT LEFT(MAX(MDATE),11)
                                   FROM   FOMARGINNEW
                                   WHERE  MDATE <= @mdate + ' 23:59') + '%'
          GROUP BY PARTY_CODE) P
  WHERE  P.PARTY_CODE = T.PARTY_CODE
  */
            
 UPDATE T SET INITIALMARGIN=P.MARGINAMOUNT,MTMMARGIN=P.MTMMARGIN,ADDMARGIN=P.ADDMARGIN FROM #TBL_CLIENTMARGIN T,                 
(                
 SELECT  PARTY_CODE,SUM(INITIALMARGIN) MARGINAMOUNT, MTMMARGIN = SUM(MTOMMARGIN)  ,ADDMARGIN=SUM(OTHERMARGIN)                    
 FROM FOMARGINNEW_DATA                        
 WHERE  MDATE LIKE  (                
  SELECT LEFT(MAX(MDATE),11) FROM FOMARGINNEW                  
  WHERE MDATE <=  @MDATE +' 23:59') + '%'                      
 GROUP BY PARTY_CODE                
) P                
 WHERE P.PARTY_CODE = T.PARTY_CODE   
   
                        
  /*updating tbl_clientmargin*/
  DELETE TBL_CLIENTMARGIN
  WHERE  MARGINDATE LIKE @mdate + '%'
                                  
  INSERT INTO TBL_CLIENTMARGIN
  SELECT   *
  FROM     #TBL_CLIENTMARGIN
  WHERE    (BILLAMOUNT <> 0
             OR INITIALMARGIN <> 0
             OR LEDGERAMOUNT <> 0
             OR CASH_COLL <> 0
             OR NONCASH_COLL <> 0)
  ORDER BY PARTY_CODE

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
CREATE Procedure [dbo].[Fetch_CliUnreco_ForPO](@pcode as varchar(10) = null)        
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
-- PROCEDURE dbo.FETCH_GST_INVOICE
-- --------------------------------------------------







CREATE PROC [dbo].[FETCH_GST_INVOICE] 
(
	@FORTHEDAY	VARCHAR(11),
	@EXCHANGE	VARCHAR(3),
	@SEGMENT	VARCHAR(7)
)
AS

SELECT INVOICE_DATE = CONVERT(DATETIME, LEFT(SAUDA_DATE,11)),EXCHANGE=@EXCHANGE, SEGMENT=@SEGMENT, RECORDFOR='SETTLEMENT',
SUBRECORDFOR=CONVERT(VARCHAR(20),'CONTRACT'),INV_DESC = CONVERT(VARCHAR(500),'TOWARDS BROKERAGE AND CHARGES AGAINST THE TRADES EXECUTION'),
SETT_NO='', SETT_TYPE='', PARTY_CODE, CONTRACTNO, INT_REF_NO = CONVERT(VARCHAR(50), @EXCHANGE + '_' + @SEGMENT + '_' + CONTRACTNO),
TAXABLE_AMT = SUM(PBROKAMT+SBROKAMT)
			+ SUM(CASE WHEN TURNOVER_AC = 1 THEN TURN_TAX ELSE 0 END)
			+ SUM(CASE WHEN SEBI_TURN_AC = 1 THEN SEBI_TAX ELSE 0 END)
			+ SUM(CASE WHEN BROKER_NOTE_AC = 1 THEN BROKER_NOTE ELSE 0 END)
			+ SUM(CASE WHEN OTHER_CHRG_AC = 1 THEN OTHER_CHRG ELSE 0 END)
			+ SUM(CASE WHEN INSURANCE_CHRG_AC = 1 THEN INS_CHRG ELSE 0 END),
TAX_AMT = SUM(C.SERVICE_TAX),
INVOICE_TYPE = CONVERT(VARCHAR(20),'DEBIT'),
INVOICE_SUBTYPE = CONVERT(VARCHAR(20),''),
INVOICE_CATEGORY = CONVERT(VARCHAR(20),''),
REV_INT_REF_NO = CONVERT(VARCHAR(50),''),
LOCATION_CODE = CONVERT(VARCHAR(50),''),
SOURCESTATE=CONVERT(VARCHAR(50),''),
TARGETSTATE=CONVERT(VARCHAR(50),''),
STATE_CODE=CONVERT(VARCHAR(2),''),
INV_NO=CONVERT(VARCHAR(50),''),
SACCODE=CONVERT(VARCHAR(50),''),
SAC_DESC=CONVERT(VARCHAR(500),''),
BRANCH_CODE = CONVERT(VARCHAR(10),''),
IGST_RATE = CONVERT(NUMERIC(18,4),0),
IGST_AMOUNT = CONVERT(NUMERIC(18,4),0),
CGST_RATE = CONVERT(NUMERIC(18,4),0),
CGST_AMOUNT = CONVERT(NUMERIC(18,4),0),
SGST_RATE = CONVERT(NUMERIC(18,4),0),
SGST_AMOUNT = CONVERT(NUMERIC(18,4),0)
INTO #DATA 
FROM FOBILLVALAN C, FOGLOBALS G, FOOWNER O
WHERE  SAUDA_DATE BETWEEN @FORTHEDAY AND @FORTHEDAY + ' 23:59:59'
AND SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND C.SERVICE_TAX > 0 AND TRADETYPE = 'BT'
GROUP BY PARTY_CODE, CONTRACTNO, LEFT(SAUDA_DATE,11)

SELECT * FROM #DATA

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GST_SERVICE_TAX_SPLIT
-- --------------------------------------------------
CREATE PROC [dbo].[GST_SERVICE_TAX_SPLIT]      
AS      
      
DECLARE @SPLITCODE VARCHAR(10)      
      
DECLARE @GSTDATE DATETIME      
      
SET  @GSTDATE = 'MAY  3 2024'      
      
SELECT @SPLITCODE = ACCODE FROM MCDX.DBO.VALANACCOUNT      
WHERE ACNAME = 'SPLIT TAX'      
      
SELECT VNO, VTYP, BOOKTYPE,       
VDT = CONVERT(DATETIME,LEFT(VDT,11)),       
LNO=MAX(LNO)       
INTO #STAXVNO FROM Accountmcdx.dbo.LEDGER      
WHERE VDT >= @GSTDATE      
AND CLTCODE = @SPLITCODE       
GROUP BY VNO, VTYP, BOOKTYPE, CONVERT(DATETIME,LEFT(VDT,11))      
      

SELECT L.VTYP, L.VNO, L.EDT, L.LNO, L.ACNAME, L.DRCR, L.VAMT, L.VDT, L.VNO1, L.REFNO, L.BALAMT,       
    L.NODAYS, L.CDT, L.CLTCODE, L.BOOKTYPE, L.ENTEREDBY, L.PDT, L.CHECKEDBY, L.ACTNODAYS, L.NARRATION       
INTO #LEDGER       
FROM Accountmcdx.dbo.LEDGER L, #STAXVNO V      
WHERE L.VDT >= @GSTDATE       
AND LEFT(L.VDT,11) = LEFT(V.VDT,11)      
AND L.VNO = V.VNO      
AND L.VTYP = V.VTYP      
AND L.BOOKTYPE = V.BOOKTYPE      
      
SELECT VNO,VTYP,BOOKTYPE,RECCNT = COUNT(1) INTO #WRONGDATA       
FROM (SELECT DISTINCT CLTCODE, VNO,VTYP,BOOKTYPE      
FROM #LEDGER      
WHERE CLTCODE IN (SELECT CLTCODE FROM Accountmcdx.dbo.ACMAST WHERE ACCAT = 4)      
GROUP BY CLTCODE,VNO,VTYP,BOOKTYPE) A      
GROUP BY VNO,VTYP,BOOKTYPE      
HAVING COUNT(1) > 1      
      
DELETE FROM #LEDGER      
WHERE EXISTS (SELECT VNO FROM #WRONGDATA      
     WHERE #WRONGDATA.VNO = #LEDGER.VNO      
     AND #WRONGDATA.VTYP = #LEDGER.VTYP      
     AND   #WRONGDATA.BOOKTYPE = #LEDGER.BOOKTYPE)       
      
SELECT DISTINCT PARTY_CODE, SOURCESTATE = G.STATE,       
    TARGETSTATE = L_STATE, VDT = CONVERT(DATETIME,LEFT(VDT,11)), VNO, VTYP, BOOKTYPE,      
GST_PER = CONVERT(NUMERIC(18,2),0),      
CGST_PER = CONVERT(NUMERIC(18,2),0),      
SGST_PER = CONVERT(NUMERIC(18,2),0),      
IGST_PER = CONVERT(NUMERIC(18,2),0),      
UGST_PER = CONVERT(NUMERIC(18,2),0),      
STATE_CODE = CONVERT(VARCHAR(2),'')      
INTO #FINDATA      
FROM #LEDGER L, MCDX.DBO.TBL_CLIENT_GST_DATA C, MCDX.DBO.TBL_GST_LOCATION G      
WHERE L.CLTCODE = C.PARTY_CODE      
AND C.GST_LOCATION = G.LOC_CODE      
AND VDT BETWEEN EFF_FROM_DATE AND EFF_TO_DATE      
      
INSERT INTO #FINDATA      
SELECT DISTINCT CL_CODE,SOURCESTATE=OWNER.STATE,       
TARGETSTATE=L_STATE,  VDT=CONVERT(DATETIME,LEFT(VDT,11)), VNO, VTYP, BOOKTYPE,      
GST_PER = CONVERT(NUMERIC(18,2),0),      
CGST_PER = CONVERT(NUMERIC(18,2),0),      
SGST_PER = CONVERT(NUMERIC(18,2),0),      
IGST_PER = CONVERT(NUMERIC(18,2),0),      
UGST_PER = CONVERT(NUMERIC(18,2),0),      
STATE_CODE = CONVERT(VARCHAR(2),'')      
FROM #LEDGER N, MCDX.DBO.OWNER OWNER,      
--MCDX.DBO.TBL_STATE_GST_DATA T, MCDX.DBO.Client_Details G  
MCDX.DBO.TBL_STATE_GST_DATA T, MCDX.DBO.CLIENT1 G      
WHERE  OWNER.STATE = STATE_NAME      
AND VDT BETWEEN T.EFF_FROM_DATE AND T.EFF_TO_DATE         
AND G.CL_CODE NOT IN (SELECT PARTY_CODE FROM #FINDATA WHERE G.CL_CODE = #FINDATA.PARTY_CODE)      
AND G.CL_CODE = N.CLTCODE      
      
DELETE FROM #LEDGER       
WHERE NOT EXISTS (SELECT VNO FROM #FINDATA      
     WHERE #FINDATA.VNO = #LEDGER.VNO      
     AND #FINDATA.VTYP = #LEDGER.VTYP      
     AND   #FINDATA.BOOKTYPE = #LEDGER.BOOKTYPE)       

----- To check and delete entry (To ignore it) has multiple code in sigle VNO with GST SPlT GL code
		SELECT A.Vno,A.Vtyp,A.BOOKTYPE INTO #WRONGDATA1 FROM
		(  SELECT S= SUM(VAMT),VNO,VTYP,BOOKTYPE FROM #LEDGER 
		  GROUP BY VNO,VTYP,BOOKTYPE 
		  )A
		 ,(SELECT S = SUM(VAMT),VNO,VTYP,BOOKTYPE FROM LEDGER      
		WHERE VDT >= @GSTDATE      
		AND EXISTS (SELECT VNO FROM #LEDGER      
			 WHERE LEDGER.VNO = #LEDGER.VNO      
			 AND LEDGER.VTYP = #LEDGER.VTYP      
			 AND   LEDGER.BOOKTYPE = #LEDGER.BOOKTYPE)  GROUP BY VNO,VTYP,BOOKTYPE  ) B
			 WHERE A.VNO = B.VNO
			 AND A.VTYP =B.VTYP
			 AND A.BOOKTYPE =B.BOOKTYPE
			 AND A.S <> B.S
	 
		DELETE FROM #LEDGER      
		WHERE EXISTS (SELECT VNO FROM #WRONGDATA1      
			 WHERE #WRONGDATA1.VNO = #LEDGER.VNO      
			 AND #WRONGDATA1.VTYP = #LEDGER.VTYP      
			 AND   #WRONGDATA1.BOOKTYPE = #LEDGER.BOOKTYPE)   
----- To check and delete entry has multiple code in sigle VNO with GST SPlT GL code
	  
UPDATE #FINDATA SET TARGETSTATE = SOURCESTATE      
WHERE TARGETSTATE NOT IN (SELECT STATE FROM MCDX.DBO.STATE_MASTER WHERE STATE <> 'OTHER')      
      
UPDATE #FINDATA SET      
 GST_PER  = (CASE WHEN TARGETSTATE = SOURCESTATE THEN S.GST_PER ELSE 0 END),      
 CGST_PER = (CASE WHEN TARGETSTATE = SOURCESTATE THEN S.CGST_PER ELSE 0 END),      
 SGST_PER = (CASE WHEN TARGETSTATE = SOURCESTATE AND UTI_FLAG = 0 THEN S.SGST_PER ELSE 0 END),      
 IGST_PER = (CASE WHEN TARGETSTATE <> SOURCESTATE THEN S.IGST_PER ELSE 0 END),      
 UGST_PER = (CASE WHEN TARGETSTATE = SOURCESTATE AND UTI_FLAG = 1 THEN S.UGST_PER ELSE 0 END),      
 STATE_CODE = S.STATE_CODE       
FROM MCDX.DBO.TBL_STATE_GST_DATA S      
WHERE STATE_NAME = SOURCESTATE      
AND VDT BETWEEN EFF_FROM_DATE AND EFF_TO_DATE      
      
SELECT L.* INTO #SGSTLED FROM #LEDGER L, #FINDATA F       
WHERE LEFT(L.VDT,11) = LEFT(F.VDT,11)       
  AND L.VNO = F.VNO      
  AND L.VTYP = F.VTYP      
  AND L.BOOKTYPE = L.BOOKTYPE      
  AND L.CLTCODE = @SPLITCODE      
  AND (SGST_PER + UGST_PER) > 0       
      
SELECT VNO, VTYP, BOOKTYPE, LNO=MAX(LNO) + 1  
INTO #LINENO    
FROM #LEDGER  
GROUP BY VNO, VTYP, BOOKTYPE  
  
UPDATE #SGSTLED SET CLTCODE = ACCODE, VAMT = ROUND(VAMT * SGST_PER / GST_PER,2),     
LNO = L.LNO-- #SGSTLED.LNO + 1    
FROM MCDX.DBO.VALANACCOUNT V, #FINDATA F, #LINENO L    
WHERE LEFT(#SGSTLED.VDT,11) = LEFT(F.VDT,11)     
  AND #SGSTLED.VNO = F.VNO    
  AND #SGSTLED.VTYP = F.VTYP    
  AND #SGSTLED.BOOKTYPE = F.BOOKTYPE    
  AND #SGSTLED.VNO = L.VNO    
  AND #SGSTLED.VTYP = L.VTYP    
  AND #SGSTLED.BOOKTYPE = L.BOOKTYPE  
  AND V.ACNAME = STATE_CODE + '_SGST'    
  AND SGST_PER > 0     
    
UPDATE #SGSTLED SET CLTCODE = ACCODE, VAMT = ROUND(VAMT * UGST_PER / GST_PER,2),     
LNO = L.LNO-- #SGSTLED.LNO + 1   
FROM MCDX.DBO.VALANACCOUNT V, #FINDATA F, #LINENO L      
WHERE LEFT(#SGSTLED.VDT,11) = LEFT(F.VDT,11)    
  AND #SGSTLED.VNO = F.VNO    
  AND #SGSTLED.VTYP = F.VTYP    
  AND #SGSTLED.BOOKTYPE = F.BOOKTYPE    
  AND #SGSTLED.VNO = L.VNO    
  AND #SGSTLED.VTYP = L.VTYP    
  AND #SGSTLED.BOOKTYPE = L.BOOKTYPE  
  AND V.ACNAME = STATE_CODE + '_UGST'    
  AND UGST_PER > 0  
        
UPDATE #LEDGER SET VAMT = #LEDGER.VAMT - F.VAMT      
FROM #SGSTLED F      
WHERE LEFT(#LEDGER.VDT,11) = LEFT(F.VDT,11)       
  AND #LEDGER.VNO = F.VNO      
  AND #LEDGER.VTYP = F.VTYP      
  AND #LEDGER.BOOKTYPE = F.BOOKTYPE      
  AND #LEDGER.CLTCODE = @SPLITCODE      
      
UPDATE #LEDGER SET CLTCODE = ACCODE      
FROM MCDX.DBO.VALANACCOUNT V, #FINDATA F      
WHERE LEFT(#LEDGER.VDT,11) = LEFT(F.VDT,11)      
  AND #LEDGER.VNO = F.VNO      
  AND #LEDGER.VTYP = F.VTYP      
  AND #LEDGER.BOOKTYPE = F.BOOKTYPE      
  AND V.ACNAME = STATE_CODE + '_CGST'      
  AND CGST_PER > 0       
  AND #LEDGER.CLTCODE = @SPLITCODE      
      
UPDATE #LEDGER SET CLTCODE = ACCODE      
FROM MCDX.DBO.VALANACCOUNT V, #FINDATA F      
WHERE LEFT(#LEDGER.VDT,11) = LEFT(F.VDT,11)      
  AND #LEDGER.VNO = F.VNO      
  AND #LEDGER.VTYP = F.VTYP      
  AND #LEDGER.BOOKTYPE = F.BOOKTYPE      
  AND V.ACNAME = STATE_CODE + '_IGST'      
  AND IGST_PER > 0       
  AND #LEDGER.CLTCODE = @SPLITCODE      
      
INSERT INTO #LEDGER       
SELECT * FROM #SGSTLED      
      
UPDATE #LEDGER SET ACNAME = A.ACNAME      
FROM Accountmcdx.dbo.ACMAST A       
WHERE A.CLTCODE = #LEDGER.CLTCODE      
      
DECLARE @CRVAMT MONEY      
DECLARE @DRVAMT MONEY      
DECLARE @CRVAMT_NEW MONEY      
DECLARE @DRVAMT_NEW MONEY      
      
SET @CRVAMT = 0       
SET @DRVAMT = 0       
SET @CRVAMT_NEW = 0       
SET @DRVAMT_NEW = 0       
      
SELECT @CRVAMT = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),      
    @DRVAMT = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END)      
FROM LEDGER      
WHERE VDT >= @GSTDATE      
AND EXISTS (SELECT VNO FROM #LEDGER      
     WHERE LEDGER.VNO = #LEDGER.VNO      
     AND LEDGER.VTYP = #LEDGER.VTYP      
     AND   LEDGER.BOOKTYPE = #LEDGER.BOOKTYPE)      

	 Select *  FROM #LEDGER 
      
--SELECT @CRVAMT_NEW = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),      
--    @DRVAMT_NEW = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END)      
--FROM #LEDGER       
      
--IF @CRVAMT = @CRVAMT_NEW AND @DRVAMT = @DRVAMT_NEW      
--BEGIN      

 --DELETE FROM LEDGER      
 --WHERE VDT >= @GSTDATE      
 --AND EXISTS (SELECT VNO FROM #LEDGER      
 --     WHERE LEDGER.VNO = #LEDGER.VNO      
 --     AND LEDGER.VTYP = #LEDGER.VTYP      
 --     AND   LEDGER.BOOKTYPE = #LEDGER.BOOKTYPE)      

 --INSERT INTO LEDGER      
 --SELECT VTYP,VNO,EDT,LNO,ACNAME,DRCR,VAMT,VDT,VNO1,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE,ENTEREDBY,      
 --PDT,CHECKEDBY,ACTNODAYS,NARRATION       
 --FROM #LEDGER       
--END

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
-- PROCEDURE dbo.NCMS_POdet_ForRealTime_PO
-- --------------------------------------------------
CREATE Proc [dbo].[NCMS_POdet_ForRealTime_PO](@pcode as varchar(10) = null)                  
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
   /*******************Unpleadge Po Adjust*********************************/
               
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
CREATE Proc [dbo].[NCMS_POdet_Unpledge](@pcode as varchar(10) = null)                  
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
-- PROCEDURE dbo.ORDER_TURNOVER_CLIENT_COUNTS_EMAILER
-- --------------------------------------------------
CREATE PROC [dbo].[ORDER_TURNOVER_CLIENT_COUNTS_EMAILER] 
AS
IF OBJECT_ID(N'TEMPDB..#TEMP') IS NOT NULL
DROP TABLE #TEMP

Select convert(varchar(11),sauda_date,120)  sauda_date,SEGMENT='MCDX',Count(distinct order_no) as order_cnt,Turn_over=SUM(TRADEQTY*Price)/10000000
,Client_Count=count(distinct party_code) into #TEMP
from MCDX.DBO.fosettlement with(nolock) where sauda_date >= convert(varchar(11),Getdate()-90,120)
Group by convert(varchar(11),sauda_date,120) 

UNION ALL
Select convert(varchar(11),sauda_date,120)  sauda_date,SEGMENT='NCE',Count(distinct order_no) as order_cnt,Turn_over=SUM(TRADEQTY*Price)/10000000
,Client_Count=count(distinct party_code) 
from NCE.DBO.fosettlement with(nolock) where sauda_date >= convert(varchar(11),Getdate()-90,120)
Group by convert(varchar(11),sauda_date,120)
order by convert(varchar(11),sauda_date,120),SEGMENT

IF OBJECT_ID(N'DUSTBIN..ORDER_TURNOVER_CLIENT_COUNTS_TEMP') IS NOT NULL
DROP TABLE ORDER_TURNOVER_CLIENT_COUNTS_TEMP

SELECT * INTO ORDER_TURNOVER_CLIENT_COUNTS_TEMP FROM #TEMP ORDER BY SAUDA_DATE,SEGMENT

DECLARE @BODYCONTENT VARCHAR(MAX),@SUB VARCHAR(4000)        
  
SET @SUB = 'REPORT OF COMMODITIES  COUNT'
 
 DECLARE @ADNAME VARCHAR(100) = 'D:\Backoffice\BHAVIN\' + 'COMMODITIES_COUNT' + '.CSV'
 DECLARE @ALL VARCHAR(MAX)      
      
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''SAUDA_DATE'''',''''SEGMENT'''',''''ORDER_CNT'''',''''TURN_OVER(IN CR)'''',''''CLIENT_COUNT'''''      
SET @ALL = @ALL+ ' UNION ALL SELECT convert(varchar(11),sauda_date,120),SEGMENT,CONVERT(VARCHAR(MAX),ORDER_CNT),CONVERT(VARCHAR(MAX),TURN_OVER),CONVERT(VARCHAR(MAX),CLIENT_COUNT) FROM DUSTBIN.DBO.ORDER_TURNOVER_CLIENT_COUNTS_TEMP'      
--SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT * FROM DUSTBIN.DBO.TBL_CALLING_DATA'      
PRINT @ALL      
SET @ALL=@ALL+' " QUERYOUT ' +@ADNAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
PRINT @ALL      
EXEC(@ALL)      

                
            
SELECT @BODYCONTENT = '<HTML><P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">Dear Team,</SPAN></P><P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">'+ 'Please find attached order,turnover and Clients count against the traded date for MCDX and NCE segment.' + '</P>'            



EXEC MSDB.DBO.SP_SEND_DBMAIL             
@PROFILE_NAME='BO SUPPORT',             

@RECIPIENTS='bhavin@angelbroking.com', 
         
@SUBJECT=@SUB,            
@BODY=@BODYCONTENT,            
@IMPORTANCE = 'HIGH',            
@BODY_FORMAT ='HTML',
@File_attachments=@ADNAME

DROP TABLE ORDER_TURNOVER_CLIENT_COUNTS_TEMP
DROP TABLE #TEMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_ALL_RTB_ORG_COUNT
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_ALL_RTB_ORG_COUNT] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))          
          
AS

SELECT S_TABLE = 'RTB',COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, COALESCE(SUM(QTY), 0) AS T_QTY,
COALESCE(SUM(BROKERAGE),0) AS BROKERAGE,COALESCE(SUM(SERVICE_TAX),0) AS SERVICE_TAX ,COALESCE(SUM(SEBIFEE),0) AS SEBIFEE,COALESCE(SUM(TURN_TAX),0) AS TURN_TAX,
COALESCE(SUM(STAMPDUTY),0) AS SD,COALESCE(SUM(STT),0) AS STT,COALESCE(SUM(OTHER_CHRG),0) AS OTHER_CHRG FROM INHOUSE_MCDX..PCNORDERDETAILS_FO_RTB (NOLOCK)
WHERE TRADE_DATE >= cast(getdate()-1 as date) AND TRADE_DATE < cast(getdate() as date)

UNION ALL

SELECT S_TABLE = 'ORG',COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, COALESCE(SUM(TRADEQTY),0) AS T_QTY ,COALESCE(SUM(((TRADEQTY*BROKAPPLIED)*BOOKTYPE)/INSTRUMENT),0) AS BROKERAGE,
COALESCE(SUM(SERVICE_TAX),0) AS SERVICE_TAX ,
COALESCE(SUM(SEBI_TAX),0) AS SEBIFEE,COALESCE(SUM(TURN_TAX),0) AS TURN_TAX,
COALESCE(SUM(BROKER_CHRG),0) AS SD,COALESCE(SUM(INS_CHRG),0) AS STT ,COALESCE(SUM(OTHER_CHRG),0) AS OTHER_CHRG
FROM MCDX..FOSETTLEMENT (NOLOCK) WHERE SAUDA_DATE >= cast(getdate()-1 as date) AND SAUDA_DATE < cast(getdate() as date)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_NCDX_RTB_ORG_COUNT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PROC_NCDX_RTB_ORG_COUNT] (@RUNDATE VARCHAR(11),@REPORT VARCHAR(10))            
            
AS  
  
SELECT S_TABLE = 'RTB',COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, COALESCE(SUM(QTY), 0) AS T_QTY,  
COALESCE(SUM(BROKERAGE),0) AS BROKERAGE,COALESCE(SUM(SERVICE_TAX),0) AS SERVICE_TAX ,COALESCE(SUM(SEBIFEE),0) AS SEBIFEE,COALESCE(SUM(TURN_TAX),0) AS TURN_TAX,  
COALESCE(SUM(STAMPDUTY),0) AS SD,COALESCE(SUM(STT),0) AS STT,COALESCE(SUM(OTHER_CHRG),0) AS OTHER_CHRG FROM INHOUSE_NCDX..PCNORDERDETAILS_FO_RTB (NOLOCK)  
WHERE TRADE_DATE >= cast(getdate()-1 as date) AND TRADE_DATE < cast(getdate() as date)  
  
UNION ALL  
  
SELECT S_TABLE = 'ORG',COUNT(DISTINCT PARTY_CODE) AS PARTY_CODE, COALESCE(SUM(TRADEQTY),0) AS T_QTY ,COALESCE(SUM(((TRADEQTY*BROKAPPLIED)*BOOKTYPE)/INSTRUMENT),0) AS BROKERAGE,  
COALESCE(SUM(SERVICE_TAX),0) AS SERVICE_TAX ,  
COALESCE(SUM(SEBI_TAX),0) AS SEBIFEE,COALESCE(SUM(TURN_TAX),0) AS TURN_TAX,  
COALESCE(SUM(BROKER_CHRG),0) AS SD,COALESCE(SUM(INS_CHRG),0) AS STT ,COALESCE(SUM(OTHER_CHRG),0) AS OTHER_CHRG  
FROM NCDX..FOSETTLEMENT (NOLOCK) WHERE SAUDA_DATE >= cast(getdate()-1 as date) AND SAUDA_DATE < cast(getdate() as date)

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
-- PROCEDURE dbo.USP_RTB_NCDX_MASTER_SYNC_BKP_JULY02072024
-- --------------------------------------------------



CREATE PROC [dbo].[USP_RTB_NCDX_MASTER_SYNC_BKP_JULY02072024]    
(@SAUDA_DATE AS DATETIME) 

 -- USP_RTB_NCDX_MASTER_SYNC '2023-05-16'
  
 
/*
BUILD BY : SIVA KUMAR
DEPLOYED BY: DHARMESH MISTRY
CREATED ON : 16/05/2023
APPROVED BY : RAHUL SHAH
*/
   
AS BEGIN    
   
DELETE FROM FOSETTLEMENT WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE +' 23:59'    
     
 -- 
  
INSERT INTO  FOSETTLEMENT    
 SELECT   CONTRACTNO = CONTRACTNO_SEG,BILLNO = LOT_SIZE,
 TRADE_NO,PARTY_CODE,INST_TYPE,SYMBOL = LEFT(SCRIP_CD,12),  
 SEC_NAME = SECURITY_NAME,  EXPIRYDATE = REPLACE(EXPIRYDATE,'.0000000','') +' 23:59',STRIKE_PRICE = CONVERT(MONEY,STRIKE_PRICE), 
  OPTION_TYPE = (CASE WHEN OPTION_TYPE ='XX' THEN '' ELSE OPTION_TYPE END) ,USER_ID = USERID,PRO_CLI = 1,O_C_FLAG = 10,C_U_FLAG = 0,TRADEQTY = QTY,  
AUCTIONPART = '',MARKETTYPE = '10',SERIES = 0,ORDER_NO,PRICE = CONVERT(MONEY,MARKET_RATE),SAUDA_DATE = REPLACE(TRADE_TIME,'.0000000','') ,  
TABLE_NO ,LINE_NO = CONVERT(INT,LINE_NO),VAL_PERC,NORMAL = CONVERT(MONEY,NORMAL),DAY_PUC = CONVERT(MONEY,DAY_PUC),DAY_SALES = CONVERT(MONEY,DAY_SALES),  
SETT_PURCH = CONVERT(MONEY,SETT_PURCH),SETT_SALES = CONVERT(MONEY,SETT_SALES),SELL_BUY = CONVERT(INT,BUYSELL),  
SETTFLAG = CONVERT(INT,(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL+1 ELSE BUYSELL+3 END)),BROKAPPLIED = CONVERT(MONEY,NET_RATE_PER_UNIT),  
NETRATE = CONVERT(MONEY,(CASE WHEN BUYSELL = 1 THEN MARKET_RATE+NET_RATE_PER_UNIT ELSE MARKET_RATE-NET_RATE_PER_UNIT END)),  
AMOUNT = CONVERT(MONEY,QTY)*CONVERT(MONEY,MARKET_RATE),INS_CHRG = CONVERT(MONEY,STT),TURN_TAX = CONVERT(MONEY,TURN_TAX),OTHER_CHRG = OTHER_CHRG,  
SEBI_TAX = CONVERT(MONEY,SEBIFEE),BROKER_CHRG = CONVERT(MONEY,STAMPDUTY),SERVICE_TAX = CONVERT(MONEY,SERVICE_TAX),  
TRADE_AMOUNT = CONVERT(MONEY,QTY)*CONVERT(MONEY,MARKET_RATE),BILLFLAG = CONVERT(INT,(CASE WHEN TRADE_TYPE = 'T' THEN BUYSELL+1 ELSE BUYSELL+3 END)),  
SETT_NO = 0,NBROKAPP = CONVERT(MONEY,NET_RATE_PER_UNIT),NSERTAX = CONVERT(MONEY,SERVICE_TAX),  
N_NETRATE = CONVERT(MONEY,(CASE WHEN BUYSELL = 1 THEN MARKET_RATE+NET_RATE_PER_UNIT ELSE MARKET_RATE-NET_RATE_PER_UNIT END)),  
SETT_TYPE = 'F',CONVERT(MONEY,CL_RATE) CL_RATE,PARTICIPANTCODE = MEMID,STATUS = '11',  
CPID ='0' ,INSTRUMENT = isnull(DENOMINATOR,'0'),BOOKTYPE = isnull(NUMERATOR,'0'),BRANCH_ID = BRANCH_ID,  
TMARK = 0,SCHEME = 3,DUMMY1 = 0,DUMMY2 = CONVERT(INT,MARKET_RATE),RESERVED1 = 0,RESERVED2 = 0  --- INTO TEMP_SIVA  
 FROM INHOUSE_NCDX..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE
 ORDER BY PARTY_CODE

  UPDATE F SET RESERVED2 = PRICEUNIT FROM FOSETTLEMENT F,FOSCRIP2 S WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE < @SAUDA_DATE + ' 23:59'
  AND F.SYMBOL= S.SYMBOL AND S.EXPIRYDATE = F.EXPIRYDATE AND F.OPTION_TYPE = S.OPTION_TYPE AND F.INST_TYPE = S.INST_TYPE

  SELECT * INTO #FOSETT 
FROM INHOUSE_NCDX..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE


  DELETE FOTRADE_CTCLID WHERE SAUDA_DATE >= @SAUDA_DATE AND SAUDA_DATE <= @SAUDA_DATE + ' 23:59'

INSERT INTO FOTRADE_CTCLID
SELECT DISTINCT REPLACE(ORDER_TIME,'.0000000','') ,ORDER_NO,INST_TYPE,
LEFT(SCRIP_CD,12),EXPIRYDATE =  REPLACE(EXPIRYDATE,'.0000000','') +' 23:59',STRIKE_PRICE,
OPTION_TYPE,CTCLID,GETDATE()
FROM INHOUSE_NCDX..PCNORDERDETAILS_FO_RTB WITH (NOLOCK) WHERE TRADE_DATE = @SAUDA_DATE

  
DELETE TBL_STAMP_DATA WHERE  SAUDA_DATE = @SAUDA_DATE  
  
INSERT INTO TBL_STAMP_DATA  
SELECT  SAUDA_DATE,CONTRACTNO,PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE = CONVERT(DATETIME,EXPIRYDATE)+' 23:59:59',STRIKE_PRICE,OPTION_TYPE,BUYQTY,SELLQTY,  
BUYAVGRATE,SELLAVGRATE,BUYSTAMP,SELLSTAMP,TOTALSTAMP,L_STATE,LASTRUNDATE = GETDATE()   
 FROM INHOUSE_NCDX..TBL_STAMP_DATA_RTB WHERE SAUDA_DATE = @SAUDA_DATE
  ORDER BY PARTY_CODE     
   
  
DELETE STT_CLIENTDETAIL WHERE  SAUDA_DATE = @SAUDA_DATE    
  
INSERT INTO  STT_CLIENTDETAIL  
SELECT RECTYPE,SAUDA_DATE,CONTRACTNO,PARTY_CODE,INST_TYPE,OPTION_TYPE,SYMBOL,EXPIRYDATE,  
STRIKE_PRICE,TRDPRICE,PQTYTRD,PAMTTRD,PSTTTRD,SQTYTRD,SAMTTRD,SSTTTRD,TOTALSTT   
 FROM INHOUSE_NCDX..STT_CLIENTDETAIL_RTB WHERE SAUDA_DATE = @SAUDA_DATE  
  ORDER BY PARTY_CODE
    
     
DELETE FROM CHARGES_DETAIL WHERE CD_SAUDA_DATE = @SAUDA_DATE    
   
INSERT INTO CHARGES_DETAIL    
SELECT  CD_PARTY_CODE = PARTY_CODE,CD_SAUDA_DATE = SAUDA_DATE,CD_CONTRACT_NO = CONTRACT_NO,CD_TRADE_NO = TRADE_NO,CD_ORDER_NO = ORDER_NO,  
CD_INST_TYPE = INST_TYPE,CD_SYMBOL = SYMBOL,CD_EXPIRY_DATE = EXPIRY_DATE +' 23:59',  
CD_OPTION_TYPE = (CASE WHEN OPTION_TYPE = 'XX' THEN '' ELSE OPTION_TYPE END),CD_STRIKE_PRICE = STRIKE_PRICE,CD_AUCTIONPART = '',  
CD_MARKETLOT = MARKETLOT,CD_SCHEME_ID = SCHEME_ID,CD_COMPUTATIONLEVEL = COMPUTATIONLEVEL,CD_COMPUTATIONON = COMPUTATIONON,  
CD_COMPUTATIONTYPE = COMPUTATIONTYPE,CD_BUYRATE = BUYRATE,CD_SELLRATE = SELLRATE,CD_TOT_BUYQTY = TOT_BUYQTY,CD_TOT_SELLQTY = TOT_SELLQTY,  
CD_TOT_BUYTURNOVER = TOT_BUYTURNOVER,CD_TOT_SELLTURNOVER = TOT_SELLTURNOVER,CD_TOT_BUYTURNOVER_ROUNDED = TOT_BUYTURNOVER_ROUNDED,  
CD_TOT_SELLTURNOVER_ROUNDED = TOT_SELLTURNOVER_ROUNDED,CD_TOT_TURNOVER = TOT_TURNOVER,CD_TOT_TURNOVER_ROUNDED = TOT_TURNOVER_ROUNDED,CD_TOT_LOT = TOT_LOT,  
CD_TOT_RES_TURNOVER = TOT_RES_TURNOVER,CD_TOT_RES_TURNOVER_ROUNDED = TOT_RES_TURNOVER_ROUNDED,CD_TOT_RES_LOT = 0,CD_TOT_BUYBROK = TOT_BUYBROK,  
CD_TOT_SELLBROK = TOT_SELLBROK,CD_TOT_BROK = TOT_BROK,CD_TOT_BUYSERTAX = TOT_BUYSERTAX,CD_TOT_SELLSERTAX = TOT_SELLSERTAX,CD_TOT_SERTAX = TOT_SERTAX,  
CD_TOT_STT = TOT_STT,CD_TOT_TURN_TAX = TOT_TURN_TAX,CD_TOT_OTHER_CHRG = 0,CD_TOT_SEBI_TAX = 0,CD_TOT_STAMPDUTY = 0,CD_EXCH_BUYRATE = EXCH_BUYRATE,  
CD_EXCH_SELLRATE = EXCH_SELLRATE,CD_TIMESTAMP = GETDATE()   
 FROM INHOUSE_NCDX..PRORDERWISEDETAILS_FO_RTB WHERE SAUDA_DATE = @SAUDA_DATE AND SYMBOL NOT LIKE '%BROK%'   
  ORDER BY PARTY_CODE 
    
   
INSERT INTO CHARGES_DETAIL    
SELECT  CD_PARTY_CODE = PARTY_CODE,CD_SAUDA_DATE = SAUDA_DATE,CD_CONTRACT_NO = CONTRACT_NO,CD_TRADE_NO = TRADE_NO,CD_ORDER_NO = ORDER_NO,  
CD_INST_TYPE = INST_TYPE,CD_SYMBOL = 'BROKERAGE',CD_EXPIRY_DATE = EXPIRY_DATE,CD_OPTION_TYPE = OPTION_TYPE,CD_STRIKE_PRICE = STRIKE_PRICE,  
CD_AUCTIONPART = '',CD_MARKETLOT = MARKETLOT,CD_SCHEME_ID = SCHEME_ID,CD_COMPUTATIONLEVEL = COMPUTATIONLEVEL,CD_COMPUTATIONON = COMPUTATIONON,  
CD_COMPUTATIONTYPE = COMPUTATIONTYPE,CD_BUYRATE = BUYRATE,CD_SELLRATE = SELLRATE,CD_TOT_BUYQTY = TOT_BUYQTY,CD_TOT_SELLQTY = TOT_SELLQTY,  
CD_TOT_BUYTURNOVER = TOT_BUYTURNOVER,CD_TOT_SELLTURNOVER = TOT_SELLTURNOVER,CD_TOT_BUYTURNOVER_ROUNDED = TOT_BUYTURNOVER_ROUNDED,  
CD_TOT_SELLTURNOVER_ROUNDED = TOT_SELLTURNOVER_ROUNDED,CD_TOT_TURNOVER = TOT_TURNOVER,CD_TOT_TURNOVER_ROUNDED = TOT_TURNOVER_ROUNDED,CD_TOT_LOT = TOT_LOT,  
CD_TOT_RES_TURNOVER = TOT_RES_TURNOVER,CD_TOT_RES_TURNOVER_ROUNDED = TOT_RES_TURNOVER_ROUNDED,CD_TOT_RES_LOT = 0,CD_TOT_BUYBROK = TOT_BUYBROK,  
CD_TOT_SELLBROK = TOT_SELLBROK,CD_TOT_BROK = TOT_BROK,CD_TOT_BUYSERTAX = TOT_BUYSERTAX,CD_TOT_SELLSERTAX = TOT_SELLSERTAX,CD_TOT_SERTAX = TOT_SERTAX,  
CD_TOT_STT = TOT_STT,CD_TOT_TURN_TAX = TOT_TURN_TAX,CD_TOT_OTHER_CHRG = 0,CD_TOT_SEBI_TAX = 0,CD_TOT_STAMPDUTY = 0,CD_EXCH_BUYRATE = EXCH_BUYRATE,  
CD_EXCH_SELLRATE = EXCH_SELLRATE,CD_TIMESTAMP = GETDATE()    
 FROM INHOUSE_NCDX..PRORDERWISEDETAILS_FO_RTB P WHERE SAUDA_DATE = @SAUDA_DATE  AND SYMBOL LIKE '%BROK%'    
    
--DECLARE @CONTNO VARCHAR(8)
--SELECT @CONTNO= MAX(CONTRACTNO_SEG) FROM #FOSETT (NOLOCK)  

DECLARE @CONTNO VARCHAR(10)
SELECT @CONTNO= MAX(CONVERT(BIGINT,CONTRACTNO_SEG)) FROM #FOSETT (NOLOCK)
  
IF ISNULL(@CONTNO,0) <> 0 
 BEGIN 

UPDATE CONTGEN SET CONTRACTNO= @CONTNO WHERE @SAUDA_DATE BETWEEN START_DATE AND END_DATE 

END

      
    
	INSERT INTO INHOUSE_NCDX..TBL_RTB_DATA_UPD
		SELECT @SAUDA_DATE,GETDATE()

    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRADE_TUROVER_MATCH
-- --------------------------------------------------
  
CREATE PROCEDURE USP_TRADE_TUROVER_MATCH   
@date varchar(20),@flag varchar(3)=''  
AS  
BEGIN  
DECLARE @date1 varchar(20)

select @date1= CONVERT(varchar(10), max(trade_time), 23) from INHOUSE_MCDX.DBO.PCNORDERDETAILS_FO_RTB with(nolock)

  
SELECT 'TRD_TO ' AS 'TYPE'  ,SUM(((QTY*MARKET_RATE)*NUMERATOR)/DENOMINATOR) TURNOVER_MATCH_COUNT  
 
FROM INHOUSE_MCDX..PCNORDERDETAILS_FO_RTB (NOLOCK)  
WHERE TRADE_DATE =@date1  
 
 UNION ALL
SELECT 'FOTRD_TO ' AS 'TYPE' , SUM(FOEA_DAY_BUY_OPEN_VALUE+FOEA_DAY_SELL_OPEN_VALUE) FOTRD_TO  
  
FROM MCDX..FOEXERCISEALLOCATION WHERE FOEA_POSITION_DATE = @date1  
AND ( FOEA_DAY_BUY_OPEN_QUANTITY <> 0 OR FOEA_DAY_SELL_OPEN_VALUE <> 0 )  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRADE_TUROVER_NCDX
-- --------------------------------------------------
  
CREATE PROCEDURE USP_TRADE_TUROVER_NCDX
@date varchar(20),@flag varchar(3)=''  
AS  
BEGIN  
DECLARE @date1 varchar(20)

select @date1= CONVERT(varchar(10), max(trade_time), 23) from INHOUSE_NCDX.DBO.PCNORDERDETAILS_FO_RTB with(nolock)

  
SELECT 'TRD_TO ' AS 'TYPE'  ,SUM(((QTY*MARKET_RATE)*NUMERATOR)/DENOMINATOR) TURNOVER_MATCH_COUNT  
 
FROM INHOUSE_NCDX..PCNORDERDETAILS_FO_RTB (NOLOCK)  
WHERE TRADE_DATE =@date1  
 
 UNION ALL
SELECT 'FOTRD_TO ' AS 'TYPE' , SUM(FOEA_DAY_BUY_OPEN_VALUE+FOEA_DAY_SELL_OPEN_VALUE) FOTRD_TO  
  
FROM NCDX..FOEXERCISEALLOCATION WHERE FOEA_POSITION_DATE = @date1  
AND ( FOEA_DAY_BUY_OPEN_QUANTITY <> 0 OR FOEA_DAY_SELL_OPEN_VALUE <> 0 )  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_COMBINED_CONTRACTNOTE_DETAIL_Arjun
-- --------------------------------------------------

    
    
CREATE  PROCEDURE [dbo].[V2_COMBINED_CONTRACTNOTE_DETAIL_Arjun] (    
 @STATUSID VARCHAR(15),    
 @STATUSNAME VARCHAR(25),    
 @FROMDATE VARCHAR(11),    
 @TODATE VARCHAR(11),    
 @FROMPARTY VARCHAR(10),    
 @TOPARTY VARCHAR(10),    
 @FROMBRANCH VARCHAR(10),    
 @TOBRANCH VARCHAR(10),    
 @FROMSUB_BROKER VARCHAR(10),    
 @TOSUB_BROKER VARCHAR(10),    
 @FROMCONTRACT VARCHAR(10),    
 @TOCONTRACT VARCHAR(10),    
 @CONTFLAG VARCHAR(10),    
 @EXCHANGE VARCHAR(15),    
 @BOUNCEDFLAG INT = 0,    
 @PRINTFLAG VARCHAR(6),    
 @SETT_TYPE VARCHAR(2) = '',    
 @COMPANY_NAME VARCHAR(100) = '',    
 @FORPDF VARCHAR(1) = 'N'    
 )    
AS    
/*    
 EXEC [V2_COMBINED_CONTRACTNOTE_NEW] 'BROKER','BROKER','JUL 10 2012','JUL 10 2012','','ZZZZZZ','','ZZZZZZZZ','','ZZZZZZ','','99999999','','',0,''    
 EXEC [V2_COMBINED_CONTRACTNOTE_DETAIL] 'BROKER','BROKER','DEC 23 2011','DEC 23 2011','','ZZZZZZ','','ZZZZZZZZ','','ZZZZZZ','','99999999','','',0,'',''    
 exec msajag..[v2_combined_contractnote_detail] @STATUSID='Broker',@STATUSNAME='Broker',@FROMDATE='04/09/2014',@TODATE='04/09/2014',@FROMPARTY='1MA008',@TOPARTY='1MA008',@FROMBRANCH='',@TOBRANCH='',@FROMSUB_BROKER='',@TOSUB_BROKER='',@FROMCONTRACT='0',@TO
  
    
    
 CONTRACT='9999999999',@CONTFLAG='',@EXCHANGE='',@BOUNCEDFLAG='',@PRINTFLAG='',@SETT_TYPE='',@COMPANY_NAME='',@FORPDF='N'    
 */    
    
    
IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0    
BEGIN    
 SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)    
END    
IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0    
BEGIN    
 SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)    
END    
    
    
IF @TODATE = ''    
BEGIN    
 SET @TODATE = @FROMDATE    
END    
    
IF @TOPARTY = ''    
BEGIN    
 SET @TOPARTY = 'ZZZZZZZZZZ'    
END    
    
IF @TOBRANCH = ''    
BEGIN    
 SET @TOBRANCH = 'ZZZZZZZZZZ'    
END    
    
IF @TOSUB_BROKER = ''    
BEGIN    
 SET @TOSUB_BROKER = 'ZZZZZZZZZZ'    
END    
    
IF @TOCONTRACT = ''    
BEGIN    
 SET @TOCONTRACT = '9999999999'    
END    
    
DECLARE @COLNAME VARCHAR(6)    
    
SET @COLNAME = ''    
    
IF @CONTFLAG = 'CONTRACT'    
BEGIN    
 SELECT @COLNAME = RPT_CODE    
 From MCDX.dbo.V2_CONTRACTPRINT_SETTING_COMBINED (NOLOCK)    
 WHERE RPT_TYPE = 'ORDER'    
  AND RPT_PRINTFLAG = 1    
END    
ELSE    
BEGIN    
 SELECT @COLNAME = RPT_CODE    
 From MCDX.dbo.V2_CONTRACTPRINT_SETTING_COMBINED (NOLOCK)    
 WHERE RPT_TYPE = 'ORDER'    
  AND RPT_PRINTFLAG_DIGI = 1    
END    
    
DECLARE @CONTRACT_TYPE  INT    
DECLARE @FNO_CONTRACT_BILL INT,    
  @STTFLAG   INT,    
  @SERFLAG   INT    
      
-- PRINT @COMPANY_NAME    
    
    
SET @CONTRACT_TYPE = 0    
SET @FNO_CONTRACT_BILL = 0    
SET @STTFLAG = 0    
SET @SERFLAG = 0    
    
SELECT     
 @CONTRACT_TYPE = CONTRACT_TYPE,    
 @FNO_CONTRACT_BILL = FNO_CONTRACT_BILL,    
 @STTFLAG = PRINT_STT_COLUMN    
From MCDX.dbo.TBL_COMMONCONTRACT_MASTER(NOLOCK)    
WHERE @FROMDATE BETWEEN EFFECTIVE_FROM AND EFFECTIVE_TO    
    
CREATE TABLE #PARTY (PARTYCODE VARCHAR(15))    
    
IF @BOUNCEDFLAG = 0    
BEGIN    
 INSERT INTO #PARTY    
 SELECT DISTINCT PARTY_CODE    
 From MCDX.dbo.COMMON_CONTRACT_DATA WITH (NOLOCK)    
 WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'    
  AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY    
    
END    
ELSE    
BEGIN    
 IF (@EXCHANGE = '')     
 BEGIN    
  INSERT INTO #PARTY    
  SELECT DISTINCT PARTY_CODE    
  From MCDX.dbo.TBL_ECNBOUNCED WITH (NOLOCK)    
  WHERE SDate BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'    
  --AND EXCHANGE = 'ALLEQUITY'    
 END     
 ELSE    
 BEGIN    
  INSERT INTO #PARTY    
  SELECT DISTINCT PARTY_CODE    
  From MCDX.dbo.TBL_ECNBOUNCED WITH (NOLOCK)    
  WHERE SDate BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'    
  /*AND EXCHANGE = (    
  CASE    
   WHEN @EXCHANGE = 'MCXFUTURES' THEN 'MCDX'    
   WHEN @EXCHANGE = 'NCXFUTURES' THEN 'NCDX'    
   ELSE ''    
  END)*/    
 END     
END    
    
    
SELECT     
 ORDERBYFLAG = (    
 CASE     
  WHEN @COLNAME = 'ORD_N'  THEN PARTYNAME     
  WHEN @COLNAME = 'ORD_P'  THEN PARTY_CODE     
  WHEN @COLNAME = 'ORD_BP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTY_CODE))     
  WHEN @COLNAME = 'ORD_BN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))     
  WHEN @COLNAME = 'ORD_DP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))     
  WHEN @COLNAME = 'ORD_DN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))     
  ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTY_CODE))     
 END),    
 CONTRACTNO,    
 CONTRACTNO_NEW = (CASE WHEN @CONTRACT_TYPE = 1 THEN CONTRACTNO ELSE CONTRACTNO_NEW END),    
 SAUDA_DATE = CONVERT(VARCHAR, CONVERT(DATETIME, SAUDA_DATE, 109), 103),    
 SETT_NO,    
 SETT_TYPE,    
 SETT_DATE,    
 PARTY_CODE,    
 PARTYNAME,    
 L_ADDRESS1,    
 L_ADDRESS2,    
 L_ADDRESS3,    
 L_STATE,    
 L_CITY,    
 L_ZIP,    
 OFF_PHONE1,    
 OFF_PHONE2,    
 PAN_GIR_NO,    
 EXCHANGE,    
 SEGMENT,    
 ORDER_NO,    
 ORDER_TIME,    
 TRADE_NO,    
 TRADE_TIME,    
 SCRIPNAME = REPLACE(REPLACE(SCRIPNAME,'(BT)','') ,'(BF)',''),    
 QTY,    
 TMARK,    
 --SELL_BUY = (CASE WHEN SELL_BUY = 1 THEN 'BUY' ELSE 'SELL' END),    
 SELL_BUY = (CASE WHEN QTY = 0 THEN '' ELSE (CASE WHEN SELL_BUY = 1 THEN 'BUY' ELSE 'SELL' END) END),    
 MARKETRATE,    
 MARKETAMT,    
 BROKERAGE,    
 SERVICE_TAX,    
 INS_CHRG,    
 NETAMOUNT,    
 SEBI_TAX,    
 TURN_TAX,    
 BROKER_CHRG,    
 OTHER_CHRG,    
 NETAMOUNTALL,    
 PRINTF,    
 BROK,    
 NETRATE,    
 CL_RATE,    
 UCC_CODE,    
 BROKERSEBIREGNO,    
 MEMBERCODE,    
 CINNO,    
 BRANCH_CD,    
 SUB_BROKER,    
 TRADER,    
 AREA,    
 REGION,    
 FAMILY,    
 MAPIDID,    
 SEBI_NO,    
 PARTICIPANT_CODE,    
 CL_TYPE,    
 SERVICE_CHRG,    
 SETTTYPE_DESC,    
 BFCF_FLAG=CASE WHEN @FNO_CONTRACT_BILL=0 THEN '' ELSE BFCF_FLAG END ,    
 CONTRACT_HEADER_DET,    
 REMARK,    
 COMPANYNAME,    
 REMARK_ID = REMARK_ID,    
 REMARK_DESC,    
 NETOBLIGATION,    
 SETTLEMENT_DET = CONVERT(VARCHAR(600), ''),    
 CONTRACTNO_DET = CONVERT(VARCHAR(600), ''),    
 BROKERSEBIREGNO_DET = CONVERT(VARCHAR(600), ''),    
 MEMBERCODE_DET = CONVERT(VARCHAR(600), ''),    
 CIN_DET = CONVERT(VARCHAR(600), ''),    
 NETAMOUNTEX = CONVERT(NUMERIC(20, 6), 0),    
 SEBI_TAXEX = CONVERT(NUMERIC(18, 4), 0),    
 TURN_TAXEX = CONVERT(NUMERIC(18, 4), 0),    
 BROKER_CHRGEX = CONVERT(NUMERIC(18, 4), 0),    
 OTHER_CHRGEX = CONVERT(NUMERIC(18, 4), 0),    
 INS_CHRGEX = CONVERT(NUMERIC(18, 4), 0),    
 SERVICE_TAXEX = CONVERT(NUMERIC(18, 4), 0),    
 BROKERAGE_TAXEX = CONVERT(NUMERIC(18, 4), 0),    
 SCRIPNAME_NEW = CONVERT(VARCHAR(300), ''),    
 REMARK_DET = CONVERT(VARCHAR(300), ''),    
 ORDFLAG = (CASE WHEN QTY = 0 THEN 2 ELSE 1 END),    
 ISIN,    
 ORD_DATE = CONVERT(VARCHAR,SAUDA_DATE,112),    
 NUMERATOR, DENOMINATOR     
INTO #CONTRACT    
From MCDX.dbo.COMMON_CONTRACT_DATA C(NOLOCK),    
 CLIENT_PRINT_SETTINGS CP(NOLOCK),    
 #PARTY P    
WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'    
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY    
 AND CONTRACTNO BETWEEN @FROMCONTRACT AND @TOCONTRACT    
 --AND COMPANYNAME = (CASE WHEN @COMPANY_NAME <> '' THEN @COMPANY_NAME ELSE COMPANYNAME END)    
 AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH    
 AND SUB_BROKER BETWEEN @FROMSUB_BROKER AND @TOSUB_BROKER    
 AND @STATUSNAME = (    
 CASE     
  WHEN @STATUSID = 'BRANCH'  THEN BRANCH_CD     
  WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER     
  WHEN @STATUSID = 'TRADER'   THEN TRADER     
  WHEN @STATUSID = 'FAMILY'  THEN FAMILY     
  WHEN @STATUSID = 'AREA'   THEN AREA     
  WHEN @STATUSID = 'REGION'  THEN REGION     
  WHEN @STATUSID = 'CLIENT'  THEN PARTY_CODE     
  ELSE 'BROKER'     
 END)    
 AND C.PARTY_CODE = P.PARTYCODE    
 AND C.PRINTF = CP.PRINT_FLAG    
 --AND CP.VALID_REPORT LIKE (CASE WHEN @BOUNCEDFLAG = 0 THEN '%' + @CONTFLAG + '%' ELSE CP.VALID_REPORT END)    
 AND EXCHANGE + SEGMENT = (CASE WHEN @EXCHANGE <> '' THEN @EXCHANGE ELSE EXCHANGE + SEGMENT END)    
 AND LEFT(BFCF_FLAG, 2) <> (CASE WHEN @FNO_CONTRACT_BILL = 0 THEN 'BF' ELSE 'DF' END)    

    
    
/*    
CREATE CLUSTERED INDEX [IDXCONT] ON [DBO].[#CONTRACT] (    
 [PARTY_CODE],    
 [EXCHANGE],    
 [SEGMENT],    
 [SCRIPNAME]    
 )    
    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE,    
  SETTLEMENT_DET = STUFF((    
    SELECT DISTINCT EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(SETT_NO)) + '-' + LTRIM(RTRIM(SETTTYPE_DESC)) + '-' + Sett_Date + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'    
    From MCDX.dbo.#CONTRACT C    
    WHERE B.PARTY_CODE = C.PARTY_CODE    
     AND B.SAUDA_DATE = C.SAUDA_DATE    
     AND C.SEGMENT = 'CAPITAL'    
     AND C.CONTRACTNO <> 0    
    ORDER BY 1    
    FOR XML PATH('')    
    ), 1, 0, ''),    
  CONTRACTNO_DET = STUFF((    
    SELECT DISTINCT EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'    
    From MCDX.dbo.#CONTRACT C    
    WHERE B.PARTY_CODE = C.PARTY_CODE    
     AND B.SAUDA_DATE = C.SAUDA_DATE    
     AND C.CONTRACTNO <> 0    
    ORDER BY 1    
    FOR XML PATH('')    
    ), 1, 0, ''),    
  BROKERSEBIREGNO_DET = STUFF((    
    SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(BROKERSEBIREGNO)) + '#'    
    From MCDX.dbo.#CONTRACT C    
    WHERE B.PARTY_CODE = C.PARTY_CODE    
     AND B.SAUDA_DATE = C.SAUDA_DATE    
    ORDER BY 1    
    FOR XML PATH('')    
    ), 1, 0, ''),    
  MEMBERCODE_DET = STUFF((    
    SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(MEMBERCODE)) + '#'    
    From MCDX.dbo.#CONTRACT C    
    WHERE B.PARTY_CODE = C.PARTY_CODE    
     AND B.SAUDA_DATE = C.SAUDA_DATE    
    ORDER BY 1    
    FOR XML PATH('')    
    ), 1, 0, ''),    
  CIN_DET=STUFF((    
    SELECT DISTINCT EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(CINNO)) + '#'    
    FROM #CONTRACT C    
    WHERE B.PARTY_CODE = C.PARTY_CODE    
     AND B.SAUDA_DATE = C.SAUDA_DATE    
    ORDER BY 1    
    FOR XML PATH('')    
    ), 1, 0, '')      
 INTO #CONTSETT_DET    
 FROM #CONTRACT B    
 */    
    
IF (@EXCHANGE <> '')    
BEGIN    
 UPDATE #CONTRACT    
 SET SETTLEMENT_DET = EXCHANGE + '-' + 'Commodity' + '-' + LTRIM(RTRIM(SETT_NO)) + '-' + LTRIM(RTRIM(SETTTYPE_DESC)) + '-' + SETT_DATE + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#',    
  CONTRACTNO_DET = EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#',    
  BROKERSEBIREGNO_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(BROKERSEBIREGNO)) + '#',    
  MEMBERCODE_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(MEMBERCODE)) + '#',    
  CIN_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(CINNO)) + '#'    
END    
ELSE    
BEGIN    
    
 DECLARE @PARTY_CODE VARCHAR(20)    
 DECLARE @DESC VARCHAR(MAX)    
 DECLARE @SAUDA_DATE VARCHAR(20)    
    
 UPDATE #CONTRACT SET SETT_DATE = SAUDA_DATE    
 WHERE SETT_DATE = ''    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE, CONTRACTNO_NEW,    
  SETTLEMENT_DET = EXCHANGE + '-' + 'Commodity' + '-' + LTRIM(RTRIM(SETT_NO)) + '-'     
  + LTRIM(RTRIM(SETTTYPE_DESC))     
  --+ '-' + SETT_DATE + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#',    
  + '-' + SETT_DATE + '-#',    
  EXCHANGE1 = EXCHANGE, SEGMENT1 = SEGMENT    
 INTO #SETTLEMENT_DET_1    
 FROM #CONTRACT    
 --WHERE CONTRACTNO <> 0    
 ORDER BY PARTY_CODE, CONTRACTNO_NEW    
    
 IF @EXCHANGE = ''    
 BEGIN    
  INSERT INTO #SETTLEMENT_DET_1    
  SELECT PARTY_CODE, SAUDA_DATE, CONTRACTNO_NEW,    
   EXCHANGE + '-' + 'Commodity'    
   + '-' + '.' + '-'     
   --+ LTRIM(RTRIM(SETTTYPE_DESC))     
   + '-' + '.' + '-' + '.' + '#',    
   EXCHANGE, SEGMENT    
  FROM PRADNYA.DBO.MULTICOMPANY, #SETTLEMENT_DET_1 D     
  WHERE PRIMARYSERVER = 1 AND SEGMENT = 'FUTURES'    
  AND EXCHANGE IN ('MCX','NCX')    
  AND EXCHANGE NOT IN (SELECT EXCHANGE1 FROM #SETTLEMENT_DET_1     
        WHERE EXCHANGE1 = EXCHANGE AND SEGMENT = SEGMENT1    
        AND D.PARTY_CODE = #SETTLEMENT_DET_1.PARTY_CODE    
        AND D.CONTRACTNO_NEW = #SETTLEMENT_DET_1.CONTRACTNO_NEW)    
  GROUP BY PARTY_CODE, SAUDA_DATE, EXCHANGE, SEGMENT, CONTRACTNO_NEW    
  ORDER BY PARTY_CODE, SAUDA_DATE, EXCHANGE, SEGMENT, CONTRACTNO_NEW    
 END     
    
 SELECT * INTO #SETTLEMENT_DET FROM #SETTLEMENT_DET_1    
 ORDER BY PARTY_CODE, CONTRACTNO_NEW, EXCHANGE1, SEGMENT1    
    
 --SELECT * FROM #SETTLEMENT_DET    
     
 ALTER TABLE #SETTLEMENT_DET    
    
 ALTER COLUMN SETTLEMENT_DET VARCHAR(MAX)    
    
 DECLARE @CONTRACTNO_NEW VARCHAR(MAX)    
 SET @DESC = ''    
 SET @PARTY_CODE = ''    
 SET @SAUDA_DATE = ''    
 SET @CONTRACTNO_NEW = ''    
     
 --SELECT * FROM #SETTLEMENT_DET    
     
 UPDATE #SETTLEMENT_DET    
 SET @DESC = SETTLEMENT_DET = CASE WHEN @PARTY_CODE = PARTY_CODE    
    AND @SAUDA_DATE = SAUDA_DATE AND @CONTRACTNO_NEW = CONTRACTNO_NEW THEN @DESC + '' + SETTLEMENT_DET ELSE SETTLEMENT_DET END,    
  @PARTY_CODE = PARTY_CODE,    
  @SAUDA_DATE = SAUDA_DATE,    
  @CONTRACTNO_NEW = CONTRACTNO_NEW    
    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE,CONTRACTNO_NEW,    
  CONTRACTNO_DET = EXCHANGE + '-' + SEGMENT + '-' + LTRIM(RTRIM(CONTRACTNO)) + '#'    
 INTO #CONTRACTNO_DET    
 FROM #CONTRACT C    
 --WHERE CONTRACTNO <> 0    
 ORDER BY PARTY_CODE,CONTRACTNO_NEW    
    
 ALTER TABLE #CONTRACTNO_DET    
    
 ALTER COLUMN CONTRACTNO_DET VARCHAR(MAX)    
    
 SET @DESC = ''    
 SET @PARTY_CODE = ''    
 SET @SAUDA_DATE = ''    
    
 UPDATE #CONTRACTNO_DET    
 SET @DESC = CONTRACTNO_DET = CASE WHEN @PARTY_CODE = PARTY_CODE    
    AND @SAUDA_DATE = SAUDA_DATE AND @CONTRACTNO_NEW = CONTRACTNO_NEW THEN @DESC + '' + CONTRACTNO_DET ELSE CONTRACTNO_DET END,    
  @PARTY_CODE = PARTY_CODE,    
  @SAUDA_DATE = SAUDA_DATE,    
  @CONTRACTNO_NEW= CONTRACTNO_NEW    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE,    
  BROKERSEBIREGNO_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(BROKERSEBIREGNO)) + '#'    
 INTO #BROKERSEBIREGNO_DET    
 FROM #CONTRACT C    
 --WHERE CONTRACTNO <> 0    
 ORDER BY PARTY_CODE    
    
 ALTER TABLE #BROKERSEBIREGNO_DET    
    
 ALTER COLUMN BROKERSEBIREGNO_DET VARCHAR(MAX)    
    
 SET @DESC = ''    
 SET @PARTY_CODE = ''    
 SET @SAUDA_DATE = ''    
    
 UPDATE #BROKERSEBIREGNO_DET    
 SET @DESC = BROKERSEBIREGNO_DET = CASE WHEN @PARTY_CODE = PARTY_CODE    
    AND @SAUDA_DATE = SAUDA_DATE THEN @DESC + '' + BROKERSEBIREGNO_DET ELSE BROKERSEBIREGNO_DET END,    
  @PARTY_CODE = PARTY_CODE,    
  @SAUDA_DATE = SAUDA_DATE    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE,    
  MEMBERCODE_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(MEMBERCODE)) + '#'    
 INTO #MEMBERCODE_DET    
 FROM #CONTRACT C    
 --WHERE CONTRACTNO <> 0    
 ORDER BY PARTY_CODE    
    
 ALTER TABLE #MEMBERCODE_DET    
    
 ALTER COLUMN MEMBERCODE_DET VARCHAR(MAX)    
    
 SET @DESC = ''    
 SET @PARTY_CODE = ''    
 SET @SAUDA_DATE = ''    
    
 UPDATE #MEMBERCODE_DET    
 SET @DESC = MEMBERCODE_DET = CASE WHEN @PARTY_CODE = PARTY_CODE    
    AND @SAUDA_DATE = SAUDA_DATE THEN @DESC + '' + MEMBERCODE_DET ELSE MEMBERCODE_DET END,    
  @PARTY_CODE = PARTY_CODE,    
  @SAUDA_DATE = SAUDA_DATE    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE,    
  CIN_DET = EXCHANGE + ' ' + SEGMENT + '-' + LTRIM(RTRIM(CINNO)) + '#'    
 INTO #CIN_DET    
 FROM #CONTRACT    
 --WHERE CONTRACTNO <> 0    
 ORDER BY PARTY_CODE    
    
 ALTER TABLE #CIN_DET    
    
 ALTER COLUMN CIN_DET VARCHAR(MAX)    
    
 SET @DESC = ''    
 SET @PARTY_CODE = ''    
 SET @SAUDA_DATE = ''    
    
 UPDATE #CIN_DET    
 SET @DESC = CIN_DET = CASE WHEN @PARTY_CODE = PARTY_CODE    
    AND @SAUDA_DATE = SAUDA_DATE THEN @DESC + '' + CIN_DET ELSE CIN_DET END,    
  @PARTY_CODE = PARTY_CODE,    
  @SAUDA_DATE = SAUDA_DATE    
    
 SELECT DISTINCT PARTY_CODE,    
  SAUDA_DATE,    
  REMARK_DET = '(' + REMARK_ID + ')' + ':-' + REMARK_DESC + '#'    
 INTO #REMARK_DET    
 FROM #CONTRACT    
 WHERE REMARK_ID <> ''    
 ORDER BY PARTY_CODE    
     
     
 ALTER TABLE #REMARK_DET    
    
 ALTER COLUMN REMARK_DET VARCHAR(MAX)    
    
 SET @DESC = ''    
 SET @PARTY_CODE = ''    
 SET @SAUDA_DATE = ''    
    
 UPDATE #REMARK_DET    
 SET @DESC = REMARK_DET = CASE WHEN @PARTY_CODE = PARTY_CODE    
    AND @SAUDA_DATE = SAUDA_DATE THEN @DESC + ' ' + REMARK_DET ELSE REMARK_DET END,    
  @PARTY_CODE = PARTY_CODE,    
  @SAUDA_DATE = SAUDA_DATE    
    
 SELECT A1.PARTY_CODE,    
  A1.SAUDA_DATE,    
  SETTLEMENT_DET,    
  CONTRACTNO_DET,    
  BROKERSEBIREGNO_DET,    
  MEMBERCODE_DET,    
  CIN_DET,    
  REMARK_DET    
 INTO #CONTSETT_DET    
 FROM (    
  SELECT DISTINCT PARTY_CODE,    
   SAUDA_DATE    
  FROM #CONTRACT    
  ) A1    
 LEFT JOIN (    
  SELECT PARTY_CODE,    
   SAUDA_DATE,    
   SETTLEMENT_DET = MAX(SETTLEMENT_DET)    
  FROM #SETTLEMENT_DET    
  GROUP BY PARTY_CODE,    
   SAUDA_DATE    
  ) A    
  ON (    
    A1.SAUDA_DATE = A.SAUDA_DATE    
    AND A1.PARTY_CODE = A.PARTY_CODE    
    )    
 LEFT JOIN (    
  SELECT PARTY_CODE,    
   SAUDA_DATE,    
   CONTRACTNO_DET = MAX(CONTRACTNO_DET)    
  FROM #CONTRACTNO_DET    
  GROUP BY PARTY_CODE,    
   SAUDA_DATE    
  ) B    
  ON (    
    A1.SAUDA_DATE = B.SAUDA_DATE    
    AND A1.PARTY_CODE = B.PARTY_CODE    
    )    
 LEFT JOIN (    
  SELECT PARTY_CODE,    
   SAUDA_DATE,    
   BROKERSEBIREGNO_DET = MAX(BROKERSEBIREGNO_DET)    
  FROM #BROKERSEBIREGNO_DET    
  GROUP BY PARTY_CODE,    
   SAUDA_DATE    
  ) C    
  ON (    
    A1.SAUDA_DATE = C.SAUDA_DATE    
    AND A1.PARTY_CODE = C.PARTY_CODE    
    )    
 LEFT JOIN (    
  SELECT PARTY_CODE,    
   SAUDA_DATE,    
   MEMBERCODE_DET = MAX(MEMBERCODE_DET)    
  FROM #MEMBERCODE_DET    
  GROUP BY PARTY_CODE,    
   SAUDA_DATE    
  ) D    
  ON (    
    A1.SAUDA_DATE = D.SAUDA_DATE    
    AND A1.PARTY_CODE = D.PARTY_CODE    
    )    
 LEFT JOIN (    
  SELECT PARTY_CODE,    
   SAUDA_DATE,    
   CIN_DET = MAX(CIN_DET)    
  FROM #CIN_DET    
  GROUP BY PARTY_CODE,    
   SAUDA_DATE    
  ) E    
  ON (    
    A1.SAUDA_DATE = E.SAUDA_DATE    
    AND A1.PARTY_CODE = E.PARTY_CODE    
    )    
 LEFT JOIN (    
  SELECT PARTY_CODE,    
   SAUDA_DATE,    
   REMARK_DET = MAX(REMARK_DET)    
  FROM #REMARK_DET    
  GROUP BY PARTY_CODE,    
   SAUDA_DATE    
  ) F    
  ON (    
    A1.SAUDA_DATE = F.SAUDA_DATE    
    AND A1.PARTY_CODE = F.PARTY_CODE    
    )    
    
 DROP TABLE #SETTLEMENT_DET    
    
 DROP TABLE #CONTRACTNO_DET    
    
 DROP TABLE #BROKERSEBIREGNO_DET    
    
 DROP TABLE #MEMBERCODE_DET    
    
 DROP TABLE #CIN_DET    
    
 DROP TABLE #REMARK_DET    
    
 ALTER TABLE #CONTRACT    
 ALTER COLUMN SETTLEMENT_DET VARCHAR(MAX)    
    
 ALTER TABLE #CONTRACT    
 ALTER COLUMN CONTRACTNO_DET VARCHAR(MAX)    
    
 UPDATE #CONTRACT    
 SET SETTLEMENT_DET = ISNULL(C.SETTLEMENT_DET, ''),    
  CONTRACTNO_DET = ISNULL(C.CONTRACTNO_DET, ''),    
  BROKERSEBIREGNO_DET = ISNULL(C.BROKERSEBIREGNO_DET, ''),    
  MEMBERCODE_DET = ISNULL(C.MEMBERCODE_DET, ''),    
  CIN_DET = ISNULL(C.CIN_DET, ''),    
  REMARK_DET = ISNULL(C.REMARK_DET, '')    
 FROM #CONTSETT_DET C    
 WHERE #CONTRACT.PARTY_CODE = C.PARTY_CODE    
  AND #CONTRACT.SAUDA_DATE = C.SAUDA_DATE    
END    
    
UPDATE #CONTRACT SET REMARK_DET = REMARK_DET + CASE WHEN  LEFT(BFCF_FLAG, 2)  ='BF' THEN ' B/fwd' ELSE '' END    
WHERE SEGMENT ='FUTURES'    
    
UPDATE #CONTRACT SET REMARK = CASE WHEN  LEFT(BFCF_FLAG, 2) = 'BF' THEN ' B/fwd' ELSE '' END    
WHERE SEGMENT ='FUTURES'    
    
SELECT PARTY_CODE,    
 SAUDA_DATE,    
 EXCHANGE,    
 SEGMENT,    
 CONTRACTNO_NEW,    
 SERVICE_TAX = SUM(SERVICE_TAX),    
 INS_CHRG = SUM(INS_CHRG),    
 NETAMOUNT = SUM(NETAMOUNT),    
 SEBI_TAX = SUM(SEBI_TAX),    
 TURN_TAX = SUM(TURN_TAX),    
 BROKER_CHRG = SUM(BROKER_CHRG),    
 OTHER_CHRG = SUM(OTHER_CHRG),    
 NETOBLIGATION = MAX(NETOBLIGATION),    
 BROKERAGE = SUM( case when exchange='MCX' then (BROKERAGE *NUMERATOR / DENOMINATOR) else brokerage end)    
INTO #CONTRACT1    
FROM #CONTRACT    
GROUP BY PARTY_CODE,    
 SAUDA_DATE,    
 EXCHANGE,    
 SEGMENT,    
 CONTRACTNO_NEW   
 
UPDATE #CONTRACT    
--SET NETAMOUNTEX = (CASE WHEN C1.SEGMENT = 'FUTURES' THEN (CASE WHEN C1.NETOBLIGATION=0 THEN  C1.NETAMOUNT ELSE C1.NETOBLIGATION  END) ELSE C1.NETAMOUNT END),    
SET NETAMOUNTEX = (CASE WHEN C1.SEGMENT = 'FUTURES' THEN C1.NETOBLIGATION ELSE C1.NETAMOUNT END),    
 SEBI_TAXEX = C1.SEBI_TAX,    
 TURN_TAXEX = C1.TURN_TAX,    
 BROKER_CHRGEX = C1.BROKER_CHRG,    
 OTHER_CHRGEX = C1.OTHER_CHRG,    
 INS_CHRGEX = C1.INS_CHRG,    
 SERVICE_TAXEX = C1.SERVICE_TAX,    
 BROKERAGE_TAXEX = C1.BROKERAGE 
  FROM #CONTRACT C(NOLOCK),    
 #CONTRACT1 C1(NOLOCK)    
WHERE C.PARTY_CODE = C1.PARTY_CODE    
 AND C.SAUDA_DATE = C1.SAUDA_DATE    
 AND C.EXCHANGE = C1.EXCHANGE    
 AND C.SEGMENT = C1.SEGMENT    
 AND C.CONTRACTNO_NEW = C1.CONTRACTNO_NEW  
 

    
--### START GST CHANGES ###---    
    
ALTER TABLE #CONTRACT    
ADD CGST_TAXEX NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD SGST_TAXEX NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD IGST_TAXEX NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD UGST_TAXEX NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD CGST NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD SGST NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD IGST NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD UGST NUMERIC(18, 6) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD CLGSTNO VARCHAR(30) DEFAULT('')    
    
ALTER TABLE #CONTRACT    
ADD GSTFLAG INT DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD CGST_PER NUMERIC(18, 2) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD SGST_PER NUMERIC(18, 2) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD IGST_PER NUMERIC(18, 2) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD UGST_PER NUMERIC(18, 2) DEFAULT(0)    
    
ALTER TABLE #CONTRACT    
ADD TARGETSTATE VARCHAR(30)  DEFAULT('')    
    
ALTER TABLE #CONTRACT    
ADD SOURCESTATE VARCHAR(30)  DEFAULT('')    
    
ALTER TABLE #CONTRACT    
ADD STATE_CODE VARCHAR(30)  DEFAULT('')    
    
ALTER TABLE #CONTRACT    
ADD DEAL_CLIENT_ADD VARCHAR(MAX) DEFAULT('')    
    
ALTER TABLE #CONTRACT    
ADD TGST_NO VARCHAR(30)    
    
ALTER TABLE #CONTRACT    
ADD TPAN_NO VARCHAR(30)    
    
ALTER TABLE #CONTRACT    
ADD TDESC_SERVICE VARCHAR(100)    
    
ALTER TABLE #CONTRACT    
ADD TACC_SERVICE_NO VARCHAR(50)    
    
ALTER TABLE #CONTRACT    
ADD TAXABLE_VALUE NUMERIC(18,4)    
    
    
UPDATE #CONTRACT    
SET  CGST_TAXEX = 0,    
  SGST_TAXEX = 0,    
  IGST_TAXEX = 0,    
  UGST_TAXEX = 0,    
  CGST = 0,    
  SGST = 0,    
  IGST = 0,    
  UGST = 0,    
  CLGSTNO = '',    
  GSTFLAG = 1,    
  CGST_PER = 0,    
  SGST_PER = 0,    
  IGST_PER = 0,    
  UGST_PER = 0,    
  TARGETSTATE = '',    
  SOURCESTATE = '',    
  STATE_CODE = '',    
  DEAL_CLIENT_ADD = ''    
    
SELECT G.PARTY_CODE, TARGETSTATE=G.L_STATE, SOURCESTATE=STATE,    
GST_PER =CONVERT(NUMERIC(18,4),0),    
CGST_PER=CONVERT(NUMERIC(18,4),0),    
IGST_PER=CONVERT(NUMERIC(18,4),0),    
SGST_PER=CONVERT(NUMERIC(18,4),0),    
UGST_PER=CONVERT(NUMERIC(18,4),0),    
P.SAUDA_DATE,    
STATE_CODE = CONVERT(VARCHAR(20),''),     
DEAL_CLIENT_ADD = L.ADDRESS1 +' '+ L.ADDRESS2 +' '+ L.CITY +' '+ L.ZIP,    
TGST_NO = L.GST_NO    
INTO #GSTDATA    
From MCDX.dbo.TBL_CLIENT_GST_DATA G, TBL_GST_LOCATION L, #CONTRACT P    
WHERE GST_LOCATION = LOC_CODE    
AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN G.EFF_FROM_DATE AND G.EFF_TO_DATE     
AND G.PARTY_CODE = P.PARTY_CODE    
    
INSERT INTO #GSTDATA    
SELECT P.PARTY_CODE, TARGETSTATE=L_STATE, SOURCESTATE=L_STATE,    
GST_PER =CONVERT(NUMERIC(18,4),0),    
CGST_PER=CONVERT(NUMERIC(18,4),0),    
IGST_PER=CONVERT(NUMERIC(18,4),0),    
SGST_PER=CONVERT(NUMERIC(18,4),0),    
UGST_PER=CONVERT(NUMERIC(18,4),0),    
P.SAUDA_DATE,    
STATE_CODE='',    
DEAL_CLIENT_ADD = '',    
P.TGST_NO    
FROM #CONTRACT P, OWNER     
WHERE NOT EXISTS (SELECT PARTY_CODE FROM #GSTDATA G    
WHERE P.PARTY_CODE = G.PARTY_CODE    
AND P.SAUDA_DATE = G.SAUDA_DATE)    
    
UPDATE #GSTDATA SET     
TARGETSTATE = SOURCESTATE     
WHERE TARGETSTATE NOT IN (SELECT STATE From MCDX.dbo.STATE_MASTER WHERE STATE <> 'OTHER')    
    
UPDATE #GSTDATA SET     
GST_PER = D.GST_PER,     
CGST_PER=(CASE WHEN SOURCESTATE = TARGETSTATE THEN D.CGST_PER ELSE 0 END),    
IGST_PER=(CASE WHEN SOURCESTATE <> TARGETSTATE THEN D.IGST_PER ELSE 0 END),    
SGST_PER=(CASE WHEN SOURCESTATE = TARGETSTATE AND UTI_FLAG = 0 THEN D.SGST_PER ELSE 0 END),    
UGST_PER=(CASE WHEN SOURCESTATE = TARGETSTATE AND UTI_FLAG = 1 THEN D.UGST_PER ELSE 0 END),    
STATE_CODE = ISNULL(D.STATE_CODE,'')    
From MCDX.dbo.TBL_STATE_GST_DATA D    
WHERE D.STATE_NAME = SOURCESTATE    
AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN EFF_FROM_DATE AND EFF_TO_DATE    
    
    
UPDATE #CONTRACT SET     
 CGST_PER = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),ROUND(G.CGST_PER,2))),    
 IGST_PER = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),ROUND(G.IGST_PER,2))),    
 SGST_PER = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),ROUND(G.SGST_PER,2))),    
 UGST_PER = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),ROUND(G.UGST_PER,2))),    
 CGST_TAXEX = SERVICE_TAXEX * G.CGST_PER / G.GST_PER,    
 SGST_TAXEX = SERVICE_TAXEX * G.SGST_PER / G.GST_PER,    
 IGST_TAXEX = SERVICE_TAXEX * G.IGST_PER / G.GST_PER,    
 UGST_TAXEX = SERVICE_TAXEX * G.UGST_PER / G.GST_PER,    
 CGST = SERVICE_TAX * G.CGST_PER / G.GST_PER,    
 SGST = SERVICE_TAX * G.SGST_PER / G.GST_PER,    
 IGST = SERVICE_TAX * G.IGST_PER / G.GST_PER,    
 UGST = SERVICE_TAX * G.UGST_PER / G.GST_PER,    
 GSTFLAG = 1,    
 TARGETSTATE = G.TARGETSTATE,    
 SOURCESTATE = G.SOURCESTATE,    
 STATE_CODE = G.STATE_CODE,    
 DEAL_CLIENT_ADD = G.DEAL_CLIENT_ADD,    
 TGST_NO = G.TGST_NO    
FROM #GSTDATA G    
WHERE #CONTRACT.PARTY_CODE = G.PARTY_CODE    
 AND #CONTRACT.SAUDA_DATE = G.SAUDA_DATE    
 AND G.GST_PER > 0     
     
    
UPDATE #CONTRACT    
SET  L_ADDRESS1 = ISNULL(G.L_ADDRESS1,''),    
  L_ADDRESS2 = ISNULL(G.L_ADDRESS2,''),    
  L_ADDRESS3 = ISNULL(G.L_ADDRESS3,''),    
  L_STATE  = ISNULL(G.L_STATE,''),    
  L_CITY  = ISNULL(G.L_CITY,''),    
  L_ZIP  = ISNULL(G.L_ZIP,''),    
  CLGSTNO  = ISNULL(G.GST_NO,'')    
From MCDX.dbo.TBL_CLIENT_GST_DATA G (NOLOCK)    
WHERE G.PARTY_CODE = #CONTRACT.PARTY_CODE    
  AND CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN G.EFF_FROM_DATE AND G.EFF_TO_DATE     
    
    
UPDATE #CONTRACT SET SGST_TAXEX = SERVICE_TAXEX - CGST_TAXEX - IGST_TAXEX - UGST_TAXEX,    
SGST = SERVICE_TAX - CGST - IGST - UGST    
WHERE  SGST_TAXEX > 0     
    
UPDATE #CONTRACT SET UGST_TAXEX = SERVICE_TAXEX - CGST_TAXEX - IGST_TAXEX - SGST_TAXEX,    
UGST = SERVICE_TAX - CGST - IGST - SGST    
WHERE  UGST_TAXEX > 0     
    
UPDATE #CONTRACT     
SET  TPAN_NO = ISNULL(PANNO,''),    
  TDESC_SERVICE = ISNULL(SERVICE_DESCRIPTION,''),    
  TACC_SERVICE_NO = ISNULL(ACCOUNT_SERVICE_NO,'')    
From MCDX.dbo.FOOWNER (NOLOCK)    
    
    
UPDATE #CONTRACT     
SET  TAXABLE_VALUE = BROKERAGE_TAXEX + (    
  CASE    
   WHEN ISNULL(G.TURNOVER_AC,0) = 1 THEN TURN_TAXEX     
   ELSE 0    
  END) + (    
  CASE    
   WHEN ISNULL(G.SEBI_TURN_AC,0) = 1 THEN SEBI_TAXEX    
   ELSE 0    
  END) + (    
  CASE    
   WHEN ISNULL(G.BROKER_NOTE_AC,0) = 1 THEN BROKER_CHRGEX    
   ELSE 0    
  END) + (    
  CASE    
   WHEN ISNULL(G.OTHER_CHRG_AC,0) = 1 THEN OTHER_CHRGEX    
   ELSE 0    
  END) + (    
  CASE    
   WHEN ISNULL(G.INSURANCE_CHRG_AC,0) = 1 THEN INS_CHRGEX    
   ELSE 0    
  END)    
From MCDX.dbo.FOGLOBALS G (NOLOCK)    
WHERE CONVERT(DATETIME,SAUDA_DATE,103) BETWEEN YEAR_START_DT AND YEAR_END_DT    
    
--### END GST CHANGES ###---    
    
    
    
UPDATE #CONTRACT    
SET SCRIPNAME_NEW = SCRIPNAME + (CASE WHEN REMARK_ID <> '' THEN ' (' + REMARK_ID + ')' ELSE '' END)    
    
DECLARE @SEBIREGNO VARCHAR(1000)    
DECLARE @BR_CMDPID  VARCHAR(1000)    
--DECLARE @EXCHANGE_SCRIP VARCHAR(100)    
--SELECT @EXCHANGE_SCRIP = EXCHANGE_LISTING_CODE FROM OWNER (NOLOCK)    
    
IF @EXCHANGE = ''    
BEGIN    
 SELECT @SEBIREGNO = 'SEBI Registration No.:' + COMMONSEBINO From MCDX.dbo.FOOWNER (NOLOCK)     
 SELECT @BR_CMDPID = '' --'NSE Capital Market Depository :' + BR_CMDPID FROM OWNER (NOLOCK)    
 ---SELECT @BR_CMDPID = @BR_CMDPID+ ', BSE Capital Market Depository :' + BR_CMDPID FROM BSEDB..OWNER (NOLOCK)    
END    
    
IF @EXCHANGE = 'MCXFUTURES'    
BEGIN    
 SELECT @SEBIREGNO = 'SEBI Registration No.: ' + brokersebiregno FROM MCDX..FOOWNER (NOLOCK)    
 SET @BR_CMDPID =''    
END    
    
IF @EXCHANGE = 'NCXFUTURES'    
BEGIN    
 SELECT @SEBIREGNO = 'SEBI Registration No.: NSX FUTURES:' + brokersebiregno FROM NCDX..FOOWNER (NOLOCK)    
 SET @BR_CMDPID =''    
END    
    
IF (@CONTRACT_TYPE = 1 )    
BEGIN    
 UPDATE #CONTRACT    
 SET  CONTRACTNO_NEW = ISNULL(CONT,'')    
 FROM (    
   SELECT CONT = MAX(CONTRACTNO_NEW),    
     EXCHANGE, SEGMENT, PARTY_CODE    
   FROM #CONTRACT C     
   WHERE SEGMENT = 'FUTURES'    
   GROUP BY    
    EXCHANGE, SEGMENT, PARTY_CODE    
   ) A    
 WHERE A.PARTY_CODE = #CONTRACT.PARTY_CODE    
   AND A.EXCHANGE = #CONTRACT.EXCHANGE    
   AND A.SEGMENT = #CONTRACT.SEGMENT    
   AND #CONTRACT.CONTRACTNO_NEW = 0    
   AND #CONTRACT.SEGMENT = 'FUTURES'    
END    
    
--UPDATE #CONTRACT SET BROK = (BROK * DENOMINATOR / NUMERATOR)/QTY    
--WHERE BROK > 0 AND NUMERATOR > 0     
--AND QTY > 0  



UPDATE #CONTRACT SET /*BROK = (BROK *NUMERATOR / DENOMINATOR)/QTY,*/  
 BROK = (BROK *NUMERATOR / DENOMINATOR)/QTY*DENOMINATOR/NUMERATOR,
 brokerage= case when exchange='MCX' then (BROKERAGE *NUMERATOR / DENOMINATOR) else brokerage end  ---BROKERAGE=   BROKERAGE/QTY --, brok= BROKERAGE/QTY 
--  BROKERAGE_TAXEX =  case when exchange='MCX' then (BROKERAGE *NUMERATOR / DENOMINATOR) else brokerage end
WHERE BROK > 0 AND NUMERATOR > 0     
AND QTY > 0 

 
    
IF @FORPDF <> 'Y'    
 BEGIN    
  SELECT *,@SEBIREGNO as SEBIREGNO,@BR_CMDPID as BR_CMDPID,    
  CONTRACT_HEADER_DET_NEW = REPLACE(CONTRACT_HEADER_DET,SETTTYPE_DESC,''),    
  STTFLAG = @STTFLAG,    
  SERFLAG = @SERFLAG    
  /*    
  EXCHANGE_SCRIP = (    
  CASE    
   WHEN ISIN <> '' AND @EXCHANGE_SCRIP LIKE '%'+ISIN+'%' THEN  'YES'    
   ELSE 'NO'    
  END)    
  */    
  FROM #CONTRACT    
  ORDER BY    
   ORDERBYFLAG,    
   PARTY_CODE,    
   EXCHANGE,    
   SEGMENT,    
   CONTRACTNO_NEW,    
   ConTrActNo desc,    
   BFCF_FLAG,    
   SETT_TYPE,    
   SCRIPNAME,    
   SELL_BUY,    
   ORDER_NO,    
   ORDFLAG,    
   TRADE_NO    
 END    
ELSE    
 BEGIN   
 print 'suresh' 
  --CREATE TABLE #COMMON_CONTRACT    
  --(    
  -- SRNO INT IDENTITY(1, 1),    
  -- ORDERBYFLAG VARCHAR(155),    
  -- CONTRACTNO VARCHAR(10),    
  -- CONTRACTNO_NEW VARCHAR(10),    
  -- SAUDA_DATE VARCHAR(30),    
  -- SETT_NO VARCHAR(10),    
  -- SETT_TYPE VARCHAR(3),    
  -- SETT_DATE VARCHAR(11),    
  -- PARTY_CODE VARCHAR(15),    
  -- PARTYNAME VARCHAR(100),    
  -- L_ADDRESS1 VARCHAR(100),    
  -- L_ADDRESS2 VARCHAR(100),    
  -- L_ADDRESS3 VARCHAR(100),    
  -- L_STATE VARCHAR(50),    
  -- L_CITY VARCHAR(50),    
  -- L_ZIP VARCHAR(10),    
  -- OFF_PHONE1 VARCHAR(50),    
  -- OFF_PHONE2 VARCHAR(50),    
  -- PAN_GIR_NO VARCHAR(15),    
  -- EXCHANGE VARCHAR(3),    
  -- SEGMENT VARCHAR(10),    
  -- ORDER_NO VARCHAR(20),    
  -- ORDER_TIME VARCHAR(8),    
  -- TRADE_NO VARCHAR(16),    
  -- TRADE_TIME VARCHAR(8),    
  -- SCRIPNAME VARCHAR(100),    
  -- QTY BIGINT,    
  -- TMARK VARCHAR(1),    
  -- SELL_BUY VARCHAR(4),    
  -- MARKETRATE NUMERIC(19, 4),    
  -- MARKETAMT NUMERIC(19, 4),    
  -- BROKERAGE NUMERIC(19, 4),    
  -- SERVICE_TAX NUMERIC(19, 4),    
  -- INS_CHRG NUMERIC(19, 4),    
  -- NETAMOUNT NUMERIC(19, 4),    
  -- SEBI_TAX NUMERIC(19, 4),    
  -- TURN_TAX NUMERIC(19, 4),    
  -- BROKER_CHRG NUMERIC(19, 4),    
  -- OTHER_CHRG NUMERIC(19, 4),    
  -- NETAMOUNTALL NUMERIC(19, 4),    
  -- PRINTF TINYINT,    
  -- BROK NUMERIC(19, 4),    
  -- NETRATE NUMERIC(19, 4),    
  -- CL_RATE NUMERIC(19, 4),    
  -- UCC_CODE VARCHAR(20),    
  -- BROKERSEBIREGNO VARCHAR(20),    
  -- MEMBERCODE VARCHAR(50),    
  -- CINNO VARCHAR(100),    
  -- BRANCH_CD VARCHAR(15),    
  -- SUB_BROKER VARCHAR(15),    
  -- TRADER VARCHAR(25),    
  -- AREA VARCHAR(25),    
  -- REGION VARCHAR(25),    
  -- FAMILY VARCHAR(15),    
  -- MAPIDID VARCHAR(20),    
  -- SEBI_NO VARCHAR(25),    
  -- PARTICIPANT_CODE VARCHAR(16),    
  -- CL_TYPE VARCHAR(3),    
  -- SERVICE_CHRG TINYINT,    
  -- SETTTYPE_DESC VARCHAR(35),    
  -- BFCF_FLAG VARCHAR(6),    
  -- CONTRACT_HEADER_DET VARCHAR(200),    
  -- REMARK VARCHAR(100),    
  -- COMPANYNAME VARCHAR(100),    
  -- REMARK_ID VARCHAR(1),    
  -- REMARK_DESC VARCHAR(200),    
  -- NETOBLIGATION NUMERIC(19, 4),    
  -- SETTLEMENT_DET VARCHAR(600),    
  -- CONTRACTNO_DET VARCHAR(600),    
  -- BROKERSEBIREGNO_DET VARCHAR(600),    
  -- MEMBERCODE_DET VARCHAR(600),    
  -- CIN_DET VARCHAR(600),    
  -- NETAMOUNTEX NUMERIC(20, 6),    
  -- SEBI_TAXEX NUMERIC(18, 4),    
  -- TURN_TAXEX NUMERIC(18, 4),    
  -- BROKER_CHRGEX NUMERIC(18, 4),    
  -- OTHER_CHRGEX NUMERIC(18, 4),    
  -- INS_CHRGEX NUMERIC(18, 4),    
  -- SERVICE_TAXEX NUMERIC(18, 4),    
  -- SCRIPNAME_NEW VARCHAR(300),    
  -- REMARK_DET VARCHAR(300)    
  --)    
  /*INSERT INTO #COMMON_CONTRACT (ORDERBYFLAG, CONTRACTNO, CONTRACTNO_NEW, SAUDA_DATE, SETT_NO, SETT_TYPE,    
     SETT_DATE, PARTY_CODE, PARTYNAME, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_STATE, L_CITY, L_ZIP,    
     OFF_PHONE1, OFF_PHONE2, PAN_GIR_NO, EXCHANGE, SEGMENT, ORDER_NO, ORDER_TIME, TRADE_NO, TRADE_TIME,    
     SCRIPNAME, QTY, TMARK, SELL_BUY, MARKETRATE, MARKETAMT, BROKERAGE, SERVICE_TAX, INS_CHRG,    
     NETAMOUNT, SEBI_TAX, TURN_TAX, BROKER_CHRG, OTHER_CHRG, NETAMOUNTALL, PRINTF, BROK, NETRATE,    
     CL_RATE, UCC_CODE, BROKERSEBIREGNO, MEMBERCODE, CINNO, BRANCH_CD, SUB_BROKER, TRADER, AREA,    
     REGION, FAMILY, MAPIDID, SEBI_NO, PARTICIPANT_CODE, CL_TYPE, SERVICE_CHRG, SETTTYPE_DESC,    
     BFCF_FLAG, CONTRACT_HEADER_DET, REMARK, COMPANYNAME, REMARK_ID, REMARK_DESC, NETOBLIGATION,    
     SETTLEMENT_DET, CONTRACTNO_DET, BROKERSEBIREGNO_DET, MEMBERCODE_DET, CIN_DET, NETAMOUNTEX,    
     SEBI_TAXEX, TURN_TAXEX, BROKER_CHRGEX, OTHER_CHRGEX, INS_CHRGEX, SERVICE_TAXEX,    
     SCRIPNAME_NEW, REMARK_DET,    
     STTFLAG,    
     SERFLAG)*/    
  SELECT ORDERBYFLAG, CONTRACTNO, CONTRACTNO_NEW, SAUDA_DATE, SETT_NO, SETT_TYPE,    
    SETT_DATE, PARTY_CODE, PARTYNAME, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_STATE, L_CITY, L_ZIP,    
    OFF_PHONE1, OFF_PHONE2, PAN_GIR_NO, EXCHANGE, SEGMENT, ORDER_NO, ORDER_TIME, TRADE_NO, TRADE_TIME,    
    SCRIPNAME, QTY, TMARK, SELL_BUY, MARKETRATE, MARKETAMT,     
    BROKERAGE = BROKERAGE, SERVICE_TAX, INS_CHRG,    
    NETAMOUNT, SEBI_TAX, TURN_TAX, BROKER_CHRG, OTHER_CHRG, NETAMOUNTALL, PRINTF, BROK, NETRATE,    
    CL_RATE, UCC_CODE, BROKERSEBIREGNO, MEMBERCODE, CINNO, BRANCH_CD, SUB_BROKER, TRADER, AREA,    
    REGION, FAMILY, MAPIDID, SEBI_NO, PARTICIPANT_CODE, CL_TYPE, SERVICE_CHRG, SETTTYPE_DESC,    
    BFCF_FLAG, CONTRACT_HEADER_DET, REMARK, COMPANYNAME, REMARK_ID, REMARK_DESC, NETOBLIGATION,    
    SETTLEMENT_DET, CONTRACTNO_DET, BROKERSEBIREGNO_DET, MEMBERCODE_DET, CIN_DET, NETAMOUNTEX,    
    SEBI_TAXEX, TURN_TAXEX, BROKER_CHRGEX, OTHER_CHRGEX, INS_CHRGEX, SERVICE_TAXEX, BROKERAGE_TAXEX, SCRIPNAME_NEW, REMARK_DET,    
    STTFLAG = @STTFLAG,    
    SERFLAG = @SERFLAG,    
    ISIN, ORD_DATE,    
    /*    
    EXCHANGE_SCRIP = (    
    CASE    
     WHEN ISIN <> '' AND @EXCHANGE_SCRIP LIKE '%'+ISIN+'%' THEN  'YES'    
     ELSE 'NO'    
    END),    
    */    
    CGST_TAXEX,    
    SGST_TAXEX,    
    IGST_TAXEX,    
    UGST_TAXEX,    
    CGST,    
    SGST,    
    IGST,    
    UGST,    
    CLGSTNO,    
    GSTFLAG,    
    CGST_PER,    
    SGST_PER,    
    IGST_PER,    
    UGST_PER,    
    TARGETSTATE,    
    SOURCESTATE,    
    STATE_CODE,    
    DEAL_CLIENT_ADD,    
    TGST_NO,    
    TPAN_NO,    
    TDESC_SERVICE,    
    TACC_SERVICE_NO,    
    TAXABLE_VALUE    
  FROM #CONTRACT    
  ORDER BY    
   ORD_DATE,    
   ORDERBYFLAG,    
   PARTY_CODE,    
   EXCHANGE,    
   SEGMENT,    
   CONTRACTNO_NEW,    
   ConTrActNo desc,    
   BFCF_FLAG,    
   SETT_TYPE,    
   SCRIPNAME,    
   SELL_BUY,    
   ORDER_NO,    
   ORDFLAG,    
   TRADE_NO    
 END

GO

-- --------------------------------------------------
-- TABLE dbo.a1
-- --------------------------------------------------
CREATE TABLE [dbo].[a1]
(
    [fname] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AccountCURBFO_BKP_09Aug2024
-- --------------------------------------------------
CREATE TABLE [dbo].[AccountCURBFO_BKP_09Aug2024]
(
    [Costname] CHAR(35) NOT NULL,
    [Costcode] SMALLINT NOT NULL,
    [Catcode] SMALLINT NOT NULL,
    [Grpcode] VARCHAR(20) NOT NULL
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
-- TABLE dbo.BAK_SCHEME_MAPPING_26102023_BFO
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_26102023_BFO]
(
    [SP_SRNO] INT NOT NULL,
    [SP_PARTY_CODE] VARCHAR(10) NULL,
    [SP_COMPUTATION_LEVEL] CHAR(1) NULL,
    [SP_PRODUCT_TYPE] VARCHAR(3) NULL,
    [SP_PRODUCT_CODE] VARCHAR(10) NULL,
    [SP_SCHEME_ID] INT NOT NULL,
    [SP_TRD_TYPE] VARCHAR(3) NULL,
    [SP_SCHEME_TYPE] CHAR(1) NULL,
    [SP_MULTIPLIER] NUMERIC(18, 4) NOT NULL,
    [SP_BUY_BROK_TYPE] CHAR(1) NULL,
    [SP_SELL_BROK_TYPE] CHAR(1) NULL,
    [SP_BUY_BROK] NUMERIC(18, 4) NOT NULL,
    [SP_SELL_BROK] NUMERIC(18, 4) NOT NULL,
    [SP_RES_MULTIPLIER] NUMERIC(18, 4) NOT NULL,
    [SP_RES_BUY_BROK] NUMERIC(18, 4) NOT NULL,
    [SP_RES_SELL_BROK] NUMERIC(18, 4) NULL,
    [SP_VALUE_FROM] NUMERIC(18, 4) NOT NULL,
    [SP_VALUE_TO] NUMERIC(18, 4) NOT NULL,
    [SP_BROK_COMPUTEON] CHAR(1) NULL,
    [SP_BROK_COMPUTETYPE] CHAR(1) NULL,
    [SP_MIN_BROKAMT] NUMERIC(18, 4) NOT NULL,
    [SP_MAX_BROKAMT] NUMERIC(18, 4) NOT NULL,
    [SP_MIN_SCRIPAMT] NUMERIC(18, 4) NOT NULL,
    [SP_MAX_SCRIPAMT] NUMERIC(18, 4) NOT NULL,
    [SP_DATE_FROM] DATETIME NOT NULL,
    [SP_DATE_TO] DATETIME NOT NULL,
    [SP_CREATEDBY] VARCHAR(20) NULL,
    [SP_CREATEDON] DATETIME NOT NULL,
    [SP_MODIFIEDBY] VARCHAR(20) NULL,
    [SP_MODIFIEDON] DATETIME NOT NULL,
    [SP_TURNOVERON] VARCHAR(7) NULL,
    [SP_SCRIP] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SCHEME_MAPPING_26102023_BFO_1
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SCHEME_MAPPING_26102023_BFO_1]
(
    [SP_PARTY_CODE] VARCHAR(10) NULL,
    [SP_COMPUTATION_LEVEL] CHAR(1) NULL,
    [SP_PRODUCT_TYPE] VARCHAR(3) NULL,
    [SP_PRODUCT_CODE] VARCHAR(10) NULL,
    [SP_SCHEME_ID] INT NOT NULL,
    [SP_TRD_TYPE] VARCHAR(3) NULL,
    [SP_SCHEME_TYPE] CHAR(1) NULL,
    [SP_MULTIPLIER] NUMERIC(18, 4) NOT NULL,
    [SP_BUY_BROK_TYPE] CHAR(1) NULL,
    [SP_SELL_BROK_TYPE] CHAR(1) NULL,
    [SP_BUY_BROK] NUMERIC(18, 4) NOT NULL,
    [SP_SELL_BROK] NUMERIC(18, 4) NOT NULL,
    [SP_RES_MULTIPLIER] NUMERIC(18, 4) NOT NULL,
    [SP_RES_BUY_BROK] NUMERIC(18, 4) NOT NULL,
    [SP_RES_SELL_BROK] NUMERIC(18, 4) NULL,
    [SP_VALUE_FROM] NUMERIC(18, 4) NOT NULL,
    [SP_VALUE_TO] NUMERIC(18, 4) NOT NULL,
    [SP_BROK_COMPUTEON] CHAR(1) NULL,
    [SP_BROK_COMPUTETYPE] CHAR(1) NULL,
    [SP_MIN_BROKAMT] NUMERIC(18, 4) NOT NULL,
    [SP_MAX_BROKAMT] NUMERIC(18, 4) NOT NULL,
    [SP_MIN_SCRIPAMT] NUMERIC(18, 4) NOT NULL,
    [SP_MAX_SCRIPAMT] NUMERIC(18, 4) NOT NULL,
    [SP_DATE_FROM] DATETIME NOT NULL,
    [SP_DATE_TO] DATETIME NOT NULL,
    [SP_CREATEDBY] VARCHAR(20) NULL,
    [SP_CREATEDON] DATETIME NOT NULL,
    [SP_MODIFIEDBY] VARCHAR(20) NULL,
    [SP_MODIFIEDON] DATETIME NOT NULL,
    [SP_TURNOVERON] VARCHAR(7) NULL,
    [SP_SCRIP] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BFOFTTRADE_1410
-- --------------------------------------------------
CREATE TABLE [dbo].[BFOFTTRADE_1410]
(
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [TRADESTATUS] CHAR(2) NULL,
    [SEGMENT] CHAR(1) NULL,
    [SETT_TYPE] CHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(7) NULL,
    [ASSET_CODE] VARCHAR(8) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(11, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [CA_LEVEL] VARCHAR(11) NULL,
    [BUY_BROKER] VARCHAR(6) NULL,
    [SELL_BROKER] VARCHAR(6) NULL,
    [TRADE_PRICE] NUMERIC(20, 4) NULL,
    [TRADEQTY] NUMERIC(12, 0) NULL,
    [SERIES_ID] NUMERIC(10, 0) NULL,
    [BUYER_LOCATIONID] VARCHAR(16) NULL,
    [BUY_CM_CODE] VARCHAR(6) NULL,
    [SELL_CM_CODE] VARCHAR(6) NULL,
    [SELLER_LOCATIONID] VARCHAR(16) NULL,
    [BUY_PARTICIPANT] VARCHAR(12) NULL,
    [BUY_CONFIRMATION] VARCHAR(1) NULL,
    [SELL_PARTICIPANT] VARCHAR(12) NULL,
    [SELL_CONFIRMATION] VARCHAR(1) NULL,
    [BUY_OC_FLAG] VARCHAR(1) NULL,
    [SELL_OC_FLAG] VARCHAR(1) NULL,
    [BUY_OLD_PARTICIPANT] VARCHAR(12) NULL,
    [BUY_OLD_CM_CODE] VARCHAR(6) NULL,
    [SELL_OLD_PARTICIPANT] VARCHAR(12) NULL,
    [SELL_OLD_CM_CODE] VARCHAR(6) NULL,
    [BUY_TERMINALID] VARCHAR(20) NULL,
    [SELL_TERMINALID] VARCHAR(20) NULL,
    [BUY_ORDER_NO] VARCHAR(20) NULL,
    [SELL_ORDER_NO] VARCHAR(20) NULL,
    [BUY_CLIENT_CODE] VARCHAR(12) NULL,
    [SELL_CLIENT_CODE] VARCHAR(12) NULL,
    [BUY_REMARKS] VARCHAR(24) NULL,
    [SELL_REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [BUY_PRO_CLI] VARCHAR(1) NULL,
    [SELL_PRO_CLI] VARCHAR(1) NULL,
    [BUY_ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [SELL_ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [BUY_ORDER_ACTIVEFLAG] CHAR(1) NULL,
    [SELL_ORDER_ACTIVEFLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BFOFTTRADE_IMP_BKUP_06OCT2023
-- --------------------------------------------------
CREATE TABLE [dbo].[BFOFTTRADE_IMP_BKUP_06OCT2023]
(
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] VARCHAR(20) NULL,
    [TRADESTATUS] CHAR(2) NULL,
    [SEGMENT] CHAR(1) NULL,
    [SETT_TYPE] CHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(15) NULL,
    [ASSET_CODE] VARCHAR(12) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(11, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [CA_LEVEL] VARCHAR(11) NULL,
    [BUY_BROKER] VARCHAR(6) NULL,
    [SELL_BROKER] VARCHAR(6) NULL,
    [TRADE_PRICE] NUMERIC(20, 4) NULL,
    [TRADEQTY] NUMERIC(12, 0) NULL,
    [SERIES_ID] NUMERIC(10, 0) NULL,
    [BUYER_LOCATIONID] VARCHAR(16) NULL,
    [BUY_CM_CODE] VARCHAR(6) NULL,
    [SELL_CM_CODE] VARCHAR(6) NULL,
    [SELLER_LOCATIONID] VARCHAR(16) NULL,
    [BUY_PARTICIPANT] VARCHAR(12) NULL,
    [BUY_CONFIRMATION] VARCHAR(1) NULL,
    [SELL_PARTICIPANT] VARCHAR(12) NULL,
    [SELL_CONFIRMATION] VARCHAR(1) NULL,
    [BUY_OC_FLAG] VARCHAR(1) NULL,
    [SELL_OC_FLAG] VARCHAR(1) NULL,
    [BUY_OLD_PARTICIPANT] VARCHAR(12) NULL,
    [BUY_OLD_CM_CODE] VARCHAR(6) NULL,
    [SELL_OLD_PARTICIPANT] VARCHAR(12) NULL,
    [SELL_OLD_CM_CODE] VARCHAR(6) NULL,
    [BUY_TERMINALID] VARCHAR(20) NULL,
    [SELL_TERMINALID] VARCHAR(20) NULL,
    [BUY_ORDER_NO] VARCHAR(20) NULL,
    [SELL_ORDER_NO] VARCHAR(20) NULL,
    [BUY_CLIENT_CODE] VARCHAR(12) NULL,
    [SELL_CLIENT_CODE] VARCHAR(12) NULL,
    [BUY_REMARKS] VARCHAR(24) NULL,
    [SELL_REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [BUY_PRO_CLI] VARCHAR(1) NULL,
    [SELL_PRO_CLI] VARCHAR(1) NULL,
    [BUY_ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [SELL_ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [BUY_ORDER_ACTIVEFLAG] CHAR(1) NULL,
    [SELL_ORDER_ACTIVEFLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfoglobals_Bkup_28Aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[bfoglobals_Bkup_28Aug2023]
(
    [year] VARCHAR(4) NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] MONEY NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] SMALLINT NULL,
    [sebi_turn_ac] SMALLINT NULL,
    [broker_note_ac] SMALLINT NULL,
    [other_chrg_ac] SMALLINT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NULL,
    [year_end_dt] DATETIME NULL,
    [CESS_Tax] NUMERIC(10, 9) NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NULL,
    [EDUCESS_TAX] NUMERIC(18, 4) NULL,
    [Insurance_Chrg_Ac] SMALLINT NULL,
    [OptTrdSellTrans] NUMERIC(18, 4) NULL,
    [OptDelSellTrans] NUMERIC(18, 4) NULL,
    [STT_On] VARCHAR(7) NULL,
    [KRISHICHARGE] NUMERIC(18, 4) NULL,
    [SBCCHARGE] NUMERIC(18, 0) NULL,
    [FODELSTT] NUMERIC(18, 0) NULL,
    [IPFTCHRG_FUT] NUMERIC(18, 0) NULL,
    [IPFTCHRG_OPT] NUMERIC(18, 0) NULL,
    [IPFTCHRG_INS] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BFOSCRIP2_IMP_TEMPTEST
-- --------------------------------------------------
CREATE TABLE [dbo].[BFOSCRIP2_IMP_TEMPTEST]
(
    [SERIES_ID] VARCHAR(50) NULL,
    [PRODUCT_TYPE] VARCHAR(50) NULL,
    [PRODUCT_CODE] VARCHAR(50) NULL,
    [ASSET_CODE] VARCHAR(50) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(22, 6) NULL,
    [OPTION_TYPE] VARCHAR(50) NOT NULL,
    [SERIES_CODE] VARCHAR(50) NOT NULL,
    [UNDERLYING_ASSET] VARCHAR(50) NULL,
    [CA_LEVEL] VARCHAR(50) NULL,
    [BASE_PRICE] INT NOT NULL,
    [STARTDATE] DATETIME NULL,
    [MATURITYDATE] DATETIME NULL,
    [EXERCISE_STARTDATE] DATETIME NULL,
    [EXERCISE_ENDDATE] DATETIME NULL,
    [MINIMUM_LOT_SIZE] VARCHAR(50) NULL,
    [LOT_SIZE_MULTIPLE] VARCHAR(50) NULL,
    [PRICE_TICK] VARCHAR(50) NOT NULL,
    [MARGIN_INDICATOR] INT NOT NULL,
    [INITAIL_MARGIN_PERC] INT NOT NULL,
    [STATUS_FLAG] VARCHAR(50) NOT NULL,
    [ISIN] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfosettlement_24112023
-- --------------------------------------------------
CREATE TABLE [dbo].[bfosettlement_24112023]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(14) NOT NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [TRADESTATUS] VARCHAR(2) NULL,
    [SEGMENT] VARCHAR(1) NULL,
    [SETT_TYPE] VARCHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(7) NULL,
    [ASSET_CODE] VARCHAR(8) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(12, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [SERIES_CODE] VARCHAR(22) NULL,
    [SERIES_ID] NUMERIC(12, 0) NULL,
    [LOT_SIZE] NUMERIC(12, 0) NULL,
    [SELL_BUY] INT NULL,
    [TRADEQTY] INT NULL,
    [SETT_FLAG] INT NULL,
    [CA_LEVEL] VARCHAR(1) NULL,
    [BROKER_CD] VARCHAR(10) NULL,
    [TRADE_PRICE] NUMERIC(12, 4) NULL,
    [LOCATIONID] VARCHAR(16) NULL,
    [CM_CODE] VARCHAR(10) NULL,
    [PARTICIPANTCODE] VARCHAR(12) NULL,
    [CP_CONFIRMATION] VARCHAR(1) NULL,
    [OC_FLAG] VARCHAR(1) NULL,
    [OLD_CP_CODE] VARCHAR(12) NULL,
    [OLD_CM_CODE] VARCHAR(10) NULL,
    [TERMINALID] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [PRO_CLI] VARCHAR(1) NULL,
    [ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [ORDER_ACTIVEFLAG] VARCHAR(1) NULL,
    [TABLE_NO] SMALLINT NULL,
    [LINE_NO] DECIMAL(18, 0) NULL,
    [VAL_PERC] VARCHAR(1) NULL,
    [NORMAL] MONEY NULL,
    [DAY_PUC] MONEY NULL,
    [DAY_SALES] MONEY NULL,
    [SETT_PURCH] MONEY NULL,
    [SETT_SALES] MONEY NULL,
    [SETTFLAG] INT NULL,
    [ROFIG] INT NULL,
    [ERRNUM] NUMERIC(18, 8) NULL,
    [NOZERO] INT NULL,
    [ROUND_TO] DECIMAL(18, 0) NULL,
    [TRADE_AMOUNT] NUMERIC(18, 4) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [BROKAPPLIED] NUMERIC(18, 4) NULL,
    [INS_CHRG] NUMERIC(18, 4) NULL,
    [TURN_TAX] NUMERIC(18, 4) NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NULL,
    [SEBI_TAX] NUMERIC(18, 4) NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NULL,
    [NETRATE] NUMERIC(18, 4) NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NULL,
    [AUCTIONPART] VARCHAR(2) NULL,
    [RESERVED1] TINYINT NULL,
    [DUMMY1] INT NULL,
    [DUMMY2] NUMERIC(36, 12) NULL,
    [STATUS] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfosettlement_bak_08122023
-- --------------------------------------------------
CREATE TABLE [dbo].[bfosettlement_bak_08122023]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(14) NOT NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [TRADESTATUS] VARCHAR(2) NULL,
    [SEGMENT] VARCHAR(1) NULL,
    [SETT_TYPE] VARCHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(7) NULL,
    [ASSET_CODE] VARCHAR(8) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(12, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [SERIES_CODE] VARCHAR(22) NULL,
    [SERIES_ID] NUMERIC(12, 0) NULL,
    [LOT_SIZE] NUMERIC(12, 0) NULL,
    [SELL_BUY] INT NULL,
    [TRADEQTY] INT NULL,
    [SETT_FLAG] INT NULL,
    [CA_LEVEL] VARCHAR(1) NULL,
    [BROKER_CD] VARCHAR(10) NULL,
    [TRADE_PRICE] NUMERIC(12, 4) NULL,
    [LOCATIONID] VARCHAR(16) NULL,
    [CM_CODE] VARCHAR(10) NULL,
    [PARTICIPANTCODE] VARCHAR(12) NULL,
    [CP_CONFIRMATION] VARCHAR(1) NULL,
    [OC_FLAG] VARCHAR(1) NULL,
    [OLD_CP_CODE] VARCHAR(12) NULL,
    [OLD_CM_CODE] VARCHAR(10) NULL,
    [TERMINALID] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [PRO_CLI] VARCHAR(1) NULL,
    [ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [ORDER_ACTIVEFLAG] VARCHAR(1) NULL,
    [TABLE_NO] SMALLINT NULL,
    [LINE_NO] DECIMAL(18, 0) NULL,
    [VAL_PERC] VARCHAR(1) NULL,
    [NORMAL] MONEY NULL,
    [DAY_PUC] MONEY NULL,
    [DAY_SALES] MONEY NULL,
    [SETT_PURCH] MONEY NULL,
    [SETT_SALES] MONEY NULL,
    [SETTFLAG] INT NULL,
    [ROFIG] INT NULL,
    [ERRNUM] NUMERIC(18, 8) NULL,
    [NOZERO] INT NULL,
    [ROUND_TO] DECIMAL(18, 0) NULL,
    [TRADE_AMOUNT] NUMERIC(18, 4) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [BROKAPPLIED] NUMERIC(18, 4) NULL,
    [INS_CHRG] NUMERIC(18, 4) NULL,
    [TURN_TAX] NUMERIC(18, 4) NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NULL,
    [SEBI_TAX] NUMERIC(18, 4) NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NULL,
    [NETRATE] NUMERIC(18, 4) NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NULL,
    [AUCTIONPART] VARCHAR(2) NULL,
    [RESERVED1] TINYINT NULL,
    [DUMMY1] INT NULL,
    [DUMMY2] NUMERIC(36, 12) NULL,
    [STATUS] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfosettlement_bak_17112023
-- --------------------------------------------------
CREATE TABLE [dbo].[bfosettlement_bak_17112023]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(14) NOT NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [TRADESTATUS] VARCHAR(2) NULL,
    [SEGMENT] VARCHAR(1) NULL,
    [SETT_TYPE] VARCHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(7) NULL,
    [ASSET_CODE] VARCHAR(8) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(12, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [SERIES_CODE] VARCHAR(22) NULL,
    [SERIES_ID] NUMERIC(12, 0) NULL,
    [LOT_SIZE] NUMERIC(12, 0) NULL,
    [SELL_BUY] INT NULL,
    [TRADEQTY] INT NULL,
    [SETT_FLAG] INT NULL,
    [CA_LEVEL] VARCHAR(1) NULL,
    [BROKER_CD] VARCHAR(10) NULL,
    [TRADE_PRICE] NUMERIC(12, 4) NULL,
    [LOCATIONID] VARCHAR(16) NULL,
    [CM_CODE] VARCHAR(10) NULL,
    [PARTICIPANTCODE] VARCHAR(12) NULL,
    [CP_CONFIRMATION] VARCHAR(1) NULL,
    [OC_FLAG] VARCHAR(1) NULL,
    [OLD_CP_CODE] VARCHAR(12) NULL,
    [OLD_CM_CODE] VARCHAR(10) NULL,
    [TERMINALID] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [PRO_CLI] VARCHAR(1) NULL,
    [ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [ORDER_ACTIVEFLAG] VARCHAR(1) NULL,
    [TABLE_NO] SMALLINT NULL,
    [LINE_NO] DECIMAL(18, 0) NULL,
    [VAL_PERC] VARCHAR(1) NULL,
    [NORMAL] DECIMAL(18, 0) NULL,
    [DAY_PUC] DECIMAL(18, 0) NULL,
    [DAY_SALES] DECIMAL(18, 0) NULL,
    [SETT_PURCH] DECIMAL(18, 0) NULL,
    [SETT_SALES] DECIMAL(18, 0) NULL,
    [SETTFLAG] INT NULL,
    [ROFIG] INT NULL,
    [ERRNUM] NUMERIC(18, 8) NULL,
    [NOZERO] INT NULL,
    [ROUND_TO] DECIMAL(18, 0) NULL,
    [TRADE_AMOUNT] NUMERIC(18, 4) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [BROKAPPLIED] NUMERIC(18, 4) NULL,
    [INS_CHRG] NUMERIC(18, 4) NULL,
    [TURN_TAX] NUMERIC(18, 4) NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NULL,
    [SEBI_TAX] NUMERIC(18, 4) NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NULL,
    [NETRATE] NUMERIC(18, 4) NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NULL,
    [AUCTIONPART] VARCHAR(2) NULL,
    [RESERVED1] TINYINT NULL,
    [DUMMY1] INT NULL,
    [DUMMY2] NUMERIC(36, 12) NULL,
    [STATUS] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BFOTRADE_1410
-- --------------------------------------------------
CREATE TABLE [dbo].[BFOTRADE_1410]
(
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [TRADESTATUS] CHAR(2) NULL,
    [SEGMENT] CHAR(1) NULL,
    [SETT_TYPE] CHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(7) NULL,
    [ASSET_CODE] VARCHAR(8) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(11, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [SERIES_CODE] VARCHAR(22) NULL,
    [SERIES_ID] NUMERIC(10, 0) NULL,
    [LOT_SIZE] NUMERIC(12, 0) NULL,
    [SELL_BUY] INT NULL,
    [TRADEQTY] INT NULL,
    [SETTFLAG] INT NULL,
    [CA_LEVEL] VARCHAR(11) NULL,
    [BROKER_CD] VARCHAR(6) NULL,
    [TRADE_PRICE] NUMERIC(20, 4) NULL,
    [LOCATIONID] VARCHAR(16) NULL,
    [CM_CODE] VARCHAR(6) NULL,
    [PARTICIPANTCODE] VARCHAR(12) NULL,
    [CP_CONFIRMATION] VARCHAR(1) NULL,
    [OC_FLAG] VARCHAR(1) NULL,
    [OLD_CP_CODE] VARCHAR(12) NULL,
    [OLD_CM_CODE] VARCHAR(6) NULL,
    [TERMINALID] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [PARTY_CODE] VARCHAR(12) NULL,
    [REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [PRO_CLI] VARCHAR(1) NULL,
    [ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [ORDER_ACTIVEFLAG] CHAR(1) NULL,
    [RESERVED1] TINYINT NULL,
    [RESERVED2] TINYINT NULL,
    [RESERVED3] TINYINT NULL,
    [RESERVED4] TINYINT NULL,
    [RESERVED5] TINYINT NULL,
    [DUMMY1] TINYINT NULL,
    [DUMMY2] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfotrd_1410
-- --------------------------------------------------
CREATE TABLE [dbo].[bfotrd_1410]
(
    [TRADE_NO] VARCHAR(16) NULL,
    [SAUDA_DATE] VARCHAR(20) NULL,
    [TRADESTATUS] CHAR(2) NULL,
    [SEGMENT] CHAR(1) NULL,
    [SETT_TYPE] CHAR(1) NULL,
    [PRODUCT_TYPE] VARCHAR(3) NULL,
    [PRODUCT_CODE] VARCHAR(15) NULL,
    [ASSET_CODE] VARCHAR(12) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(11, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [CA_LEVEL] VARCHAR(11) NULL,
    [BUY_BROKER] VARCHAR(6) NULL,
    [SELL_BROKER] VARCHAR(6) NULL,
    [TRADE_PRICE] NUMERIC(20, 4) NULL,
    [TRADEQTY] NUMERIC(12, 0) NULL,
    [SERIES_ID] NUMERIC(10, 0) NULL,
    [BUYER_LOCATIONID] VARCHAR(16) NULL,
    [BUY_CM_CODE] VARCHAR(6) NULL,
    [SELL_CM_CODE] VARCHAR(6) NULL,
    [SELLER_LOCATIONID] VARCHAR(16) NULL,
    [BUY_PARTICIPANT] VARCHAR(12) NULL,
    [BUY_CONFIRMATION] VARCHAR(1) NULL,
    [SELL_PARTICIPANT] VARCHAR(12) NULL,
    [SELL_CONFIRMATION] VARCHAR(1) NULL,
    [BUY_OC_FLAG] VARCHAR(1) NULL,
    [SELL_OC_FLAG] VARCHAR(1) NULL,
    [BUY_OLD_PARTICIPANT] VARCHAR(12) NULL,
    [BUY_OLD_CM_CODE] VARCHAR(6) NULL,
    [SELL_OLD_PARTICIPANT] VARCHAR(12) NULL,
    [SELL_OLD_CM_CODE] VARCHAR(6) NULL,
    [BUY_TERMINALID] VARCHAR(20) NULL,
    [SELL_TERMINALID] VARCHAR(20) NULL,
    [BUY_ORDER_NO] VARCHAR(20) NULL,
    [SELL_ORDER_NO] VARCHAR(20) NULL,
    [BUY_CLIENT_CODE] VARCHAR(12) NULL,
    [SELL_CLIENT_CODE] VARCHAR(12) NULL,
    [BUY_REMARKS] VARCHAR(24) NULL,
    [SELL_REMARKS] VARCHAR(24) NULL,
    [BUY_POSITION] VARCHAR(1) NULL,
    [SELL_POSITION] VARCHAR(1) NULL,
    [BUY_PRO_CLI] VARCHAR(1) NULL,
    [SELL_PRO_CLI] VARCHAR(1) NULL,
    [BUY_ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [SELL_ORDER_TIMESTAMP] VARCHAR(20) NULL,
    [BUY_ORDER_ACTIVEFLAG] CHAR(1) NULL,
    [SELL_ORDER_ACTIVEFLAG] CHAR(1) NULL
);

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
-- TABLE dbo.Brokchangenew
-- --------------------------------------------------
CREATE TABLE [dbo].[Brokchangenew]
(
    [partycode] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.check_01Aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[check_01Aug2023]
(
    [UCC_Code] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.comm_bulk_process
-- --------------------------------------------------
CREATE TABLE [dbo].[comm_bulk_process]
(
    [party_code] VARCHAR(12) NULL,
    [sno] VARCHAR(5) NULL,
    [Data_text] VARCHAR(MAX) NULL,
    [SRNO] INT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SEGMENT] VARCHAR(11) NULL,
    [SCRIP_CD] VARCHAR(100) NULL,
    [OD_TIME] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.COMMON_CONTRACT_DATA_31OCT2025
-- --------------------------------------------------
CREATE TABLE [dbo].[COMMON_CONTRACT_DATA_31OCT2025]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(10) NULL,
    [CONTRACTNO_NEW] VARCHAR(10) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [SETT_DATE] VARCHAR(11) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [ORDER_TIME] VARCHAR(8) NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [TRADE_TIME] VARCHAR(8) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [QTY] BIGINT NULL,
    [TMARK] VARCHAR(1) NULL,
    [SELL_BUY] VARCHAR(1) NULL,
    [MARKETRATE] MONEY NULL,
    [MARKETAMT] MONEY NULL,
    [BROKERAGE] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [NETAMOUNT] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [NETAMOUNTALL] MONEY NULL,
    [BROK] MONEY NULL,
    [NETRATE] MONEY NULL,
    [CL_RATE] MONEY NULL,
    [BROKERSEBIREGNO] VARCHAR(20) NULL,
    [MEMBERCODE] VARCHAR(50) NULL,
    [CINNO] VARCHAR(100) NULL,
    [SETTTYPE_DESC] VARCHAR(35) NULL,
    [BFCF_FLAG] VARCHAR(6) NULL,
    [CONTRACT_HEADER_DET] VARCHAR(200) NULL,
    [REMARK] VARCHAR(100) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [USER_ID] VARCHAR(20) NULL,
    [REMARK_ID] VARCHAR(1) NULL,
    [REMARK_DESC] VARCHAR(200) NULL,
    [NETOBLIGATION] MONEY NULL,
    [BRANCH_CD] VARCHAR(15) NULL,
    [SUB_BROKER] VARCHAR(15) NULL,
    [TRADER] VARCHAR(25) NULL,
    [AREA] VARCHAR(25) NULL,
    [REGION] VARCHAR(25) NULL,
    [FAMILY] VARCHAR(15) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [PARTYNAME] VARCHAR(100) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_STATE] VARCHAR(50) NULL,
    [L_CITY] VARCHAR(50) NULL,
    [L_ZIP] VARCHAR(10) NULL,
    [OFF_PHONE1] VARCHAR(50) NULL,
    [OFF_PHONE2] VARCHAR(50) NULL,
    [PAN_GIR_NO] VARCHAR(15) NULL,
    [MAPIDID] VARCHAR(20) NULL,
    [UCC_CODE] VARCHAR(20) NULL,
    [SEBI_NO] VARCHAR(25) NULL,
    [PARTICIPANT_CODE] VARCHAR(16) NULL,
    [CL_TYPE] VARCHAR(3) NULL,
    [SERVICE_CHRG] TINYINT NULL,
    [PRINTF] TINYINT NULL,
    [ISIN] VARCHAR(12) NULL,
    [NUMERATOR] NUMERIC(18, 4) NULL,
    [DENOMINATOR] NUMERIC(18, 4) NULL,
    [IPFT_CHRG] NUMERIC(9, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.COMMON_CONTRACT_DATA_BKP_04FEB2025
-- --------------------------------------------------
CREATE TABLE [dbo].[COMMON_CONTRACT_DATA_BKP_04FEB2025]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(10) NULL,
    [CONTRACTNO_NEW] VARCHAR(10) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [SETT_DATE] VARCHAR(11) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [ORDER_TIME] VARCHAR(8) NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [TRADE_TIME] VARCHAR(8) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [QTY] BIGINT NULL,
    [TMARK] VARCHAR(1) NULL,
    [SELL_BUY] VARCHAR(1) NULL,
    [MARKETRATE] MONEY NULL,
    [MARKETAMT] MONEY NULL,
    [BROKERAGE] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [NETAMOUNT] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [NETAMOUNTALL] MONEY NULL,
    [BROK] MONEY NULL,
    [NETRATE] MONEY NULL,
    [CL_RATE] MONEY NULL,
    [BROKERSEBIREGNO] VARCHAR(20) NULL,
    [MEMBERCODE] VARCHAR(50) NULL,
    [CINNO] VARCHAR(100) NULL,
    [SETTTYPE_DESC] VARCHAR(35) NULL,
    [BFCF_FLAG] VARCHAR(6) NULL,
    [CONTRACT_HEADER_DET] VARCHAR(200) NULL,
    [REMARK] VARCHAR(100) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [USER_ID] VARCHAR(20) NULL,
    [REMARK_ID] VARCHAR(1) NULL,
    [REMARK_DESC] VARCHAR(200) NULL,
    [NETOBLIGATION] MONEY NULL,
    [BRANCH_CD] VARCHAR(15) NULL,
    [SUB_BROKER] VARCHAR(15) NULL,
    [TRADER] VARCHAR(25) NULL,
    [AREA] VARCHAR(25) NULL,
    [REGION] VARCHAR(25) NULL,
    [FAMILY] VARCHAR(15) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [PARTYNAME] VARCHAR(100) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_STATE] VARCHAR(50) NULL,
    [L_CITY] VARCHAR(50) NULL,
    [L_ZIP] VARCHAR(10) NULL,
    [OFF_PHONE1] VARCHAR(50) NULL,
    [OFF_PHONE2] VARCHAR(50) NULL,
    [PAN_GIR_NO] VARCHAR(15) NULL,
    [MAPIDID] VARCHAR(20) NULL,
    [UCC_CODE] VARCHAR(20) NULL,
    [SEBI_NO] VARCHAR(25) NULL,
    [PARTICIPANT_CODE] VARCHAR(16) NULL,
    [CL_TYPE] VARCHAR(3) NULL,
    [SERVICE_CHRG] TINYINT NULL,
    [PRINTF] TINYINT NULL,
    [ISIN] VARCHAR(12) NULL,
    [NUMERATOR] NUMERIC(18, 4) NULL,
    [DENOMINATOR] NUMERIC(18, 4) NULL,
    [IPFT_CHRG] NUMERIC(9, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.COMMON_CONTRACT_DATA_BKP_05FEB2025
-- --------------------------------------------------
CREATE TABLE [dbo].[COMMON_CONTRACT_DATA_BKP_05FEB2025]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(10) NULL,
    [CONTRACTNO_NEW] VARCHAR(10) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [SETT_DATE] VARCHAR(11) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [ORDER_TIME] VARCHAR(8) NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [TRADE_TIME] VARCHAR(8) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [QTY] BIGINT NULL,
    [TMARK] VARCHAR(1) NULL,
    [SELL_BUY] VARCHAR(1) NULL,
    [MARKETRATE] MONEY NULL,
    [MARKETAMT] MONEY NULL,
    [BROKERAGE] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [NETAMOUNT] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [NETAMOUNTALL] MONEY NULL,
    [BROK] MONEY NULL,
    [NETRATE] MONEY NULL,
    [CL_RATE] MONEY NULL,
    [BROKERSEBIREGNO] VARCHAR(20) NULL,
    [MEMBERCODE] VARCHAR(50) NULL,
    [CINNO] VARCHAR(100) NULL,
    [SETTTYPE_DESC] VARCHAR(35) NULL,
    [BFCF_FLAG] VARCHAR(6) NULL,
    [CONTRACT_HEADER_DET] VARCHAR(200) NULL,
    [REMARK] VARCHAR(100) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [USER_ID] VARCHAR(20) NULL,
    [REMARK_ID] VARCHAR(1) NULL,
    [REMARK_DESC] VARCHAR(200) NULL,
    [NETOBLIGATION] MONEY NULL,
    [BRANCH_CD] VARCHAR(15) NULL,
    [SUB_BROKER] VARCHAR(15) NULL,
    [TRADER] VARCHAR(25) NULL,
    [AREA] VARCHAR(25) NULL,
    [REGION] VARCHAR(25) NULL,
    [FAMILY] VARCHAR(15) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [PARTYNAME] VARCHAR(100) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_STATE] VARCHAR(50) NULL,
    [L_CITY] VARCHAR(50) NULL,
    [L_ZIP] VARCHAR(10) NULL,
    [OFF_PHONE1] VARCHAR(50) NULL,
    [OFF_PHONE2] VARCHAR(50) NULL,
    [PAN_GIR_NO] VARCHAR(15) NULL,
    [MAPIDID] VARCHAR(20) NULL,
    [UCC_CODE] VARCHAR(20) NULL,
    [SEBI_NO] VARCHAR(25) NULL,
    [PARTICIPANT_CODE] VARCHAR(16) NULL,
    [CL_TYPE] VARCHAR(3) NULL,
    [SERVICE_CHRG] TINYINT NULL,
    [PRINTF] TINYINT NULL,
    [ISIN] VARCHAR(12) NULL,
    [NUMERATOR] NUMERIC(18, 4) NULL,
    [DENOMINATOR] NUMERIC(18, 4) NULL,
    [IPFT_CHRG] NUMERIC(9, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.COMMON_CONTRACT_DATA_BKUP_03NOV2025
-- --------------------------------------------------
CREATE TABLE [dbo].[COMMON_CONTRACT_DATA_BKUP_03NOV2025]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(10) NULL,
    [CONTRACTNO_NEW] VARCHAR(10) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [SETT_DATE] VARCHAR(11) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [ORDER_TIME] VARCHAR(8) NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [TRADE_TIME] VARCHAR(8) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [QTY] BIGINT NULL,
    [TMARK] VARCHAR(1) NULL,
    [SELL_BUY] VARCHAR(1) NULL,
    [MARKETRATE] MONEY NULL,
    [MARKETAMT] MONEY NULL,
    [BROKERAGE] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [NETAMOUNT] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [NETAMOUNTALL] MONEY NULL,
    [BROK] MONEY NULL,
    [NETRATE] MONEY NULL,
    [CL_RATE] MONEY NULL,
    [BROKERSEBIREGNO] VARCHAR(20) NULL,
    [MEMBERCODE] VARCHAR(50) NULL,
    [CINNO] VARCHAR(100) NULL,
    [SETTTYPE_DESC] VARCHAR(35) NULL,
    [BFCF_FLAG] VARCHAR(6) NULL,
    [CONTRACT_HEADER_DET] VARCHAR(200) NULL,
    [REMARK] VARCHAR(100) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [USER_ID] VARCHAR(20) NULL,
    [REMARK_ID] VARCHAR(1) NULL,
    [REMARK_DESC] VARCHAR(200) NULL,
    [NETOBLIGATION] MONEY NULL,
    [BRANCH_CD] VARCHAR(15) NULL,
    [SUB_BROKER] VARCHAR(15) NULL,
    [TRADER] VARCHAR(25) NULL,
    [AREA] VARCHAR(25) NULL,
    [REGION] VARCHAR(25) NULL,
    [FAMILY] VARCHAR(15) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [PARTYNAME] VARCHAR(100) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_STATE] VARCHAR(50) NULL,
    [L_CITY] VARCHAR(50) NULL,
    [L_ZIP] VARCHAR(10) NULL,
    [OFF_PHONE1] VARCHAR(50) NULL,
    [OFF_PHONE2] VARCHAR(50) NULL,
    [PAN_GIR_NO] VARCHAR(15) NULL,
    [MAPIDID] VARCHAR(20) NULL,
    [UCC_CODE] VARCHAR(20) NULL,
    [SEBI_NO] VARCHAR(25) NULL,
    [PARTICIPANT_CODE] VARCHAR(16) NULL,
    [CL_TYPE] VARCHAR(3) NULL,
    [SERVICE_CHRG] TINYINT NULL,
    [PRINTF] TINYINT NULL,
    [ISIN] VARCHAR(12) NULL,
    [NUMERATOR] NUMERIC(18, 4) NULL,
    [DENOMINATOR] NUMERIC(18, 4) NULL,
    [IPFT_CHRG] NUMERIC(9, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CONTRACT_DATA_BKUP_03NOV2025
-- --------------------------------------------------
CREATE TABLE [dbo].[CONTRACT_DATA_BKUP_03NOV2025]
(
    [CONTRACTNO] VARCHAR(14) NULL,
    [ORDER_NO] VARCHAR(15) NULL,
    [ORDER_TIME] VARCHAR(10) NULL,
    [TRADE_NO] VARCHAR(20) NULL,
    [TRADETIME] VARCHAR(10) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [SYMBOL] VARCHAR(12) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] MONEY NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [AUCTIONPART] VARCHAR(2) NULL,
    [QTY] INT NULL,
    [PQTY] INT NULL,
    [SQTY] INT NULL,
    [PRICE] MONEY NULL,
    [PRATE] MONEY NULL,
    [SRATE] MONEY NULL,
    [PBROK] MONEY NULL,
    [SBROK] MONEY NULL,
    [PNETRATE] MONEY NULL,
    [SNETRATE] MONEY NULL,
    [NETAMOUNT] MONEY NULL,
    [AMOUNT] MONEY NULL,
    [PAMT] MONEY NULL,
    [SAMT] MONEY NULL,
    [SELL_BUY] INT NULL,
    [PSERVICE_TAX] MONEY NULL,
    [SSERVICE_TAX] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [NSERTAX] MONEY NULL,
    [BROKERAGE] MONEY NULL,
    [ORDFLG] INT NULL,
    [PRICEUNIT] VARCHAR(20) NULL,
    [QTY_UNIT] VARCHAR(10) NULL,
    [CONT_CL_RATE] NUMERIC(18, 4) NULL,
    [CONT_USER_ID] VARCHAR(20) NULL,
    [CONT_REMARK_ID] VARCHAR(1) NULL,
    [CONT_REMARK_DESC] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Contractnote_comm_Daily_MCDX_18DEC2025
-- --------------------------------------------------
CREATE TABLE [dbo].[Contractnote_comm_Daily_MCDX_18DEC2025]
(
    [ORDERBYFLAG] VARCHAR(155) NULL,
    [CONTRACTNO] VARCHAR(10) NULL,
    [CONTRACTNO_NEW] VARCHAR(10) NULL,
    [SAUDA_DATE] VARCHAR(30) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [SETT_DATE] VARCHAR(11) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [PARTYNAME] VARCHAR(100) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_STATE] VARCHAR(50) NULL,
    [L_CITY] VARCHAR(50) NULL,
    [L_ZIP] VARCHAR(10) NULL,
    [OFF_PHONE1] VARCHAR(50) NULL,
    [OFF_PHONE2] VARCHAR(50) NULL,
    [PAN_GIR_NO] VARCHAR(15) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [ORDER_TIME] VARCHAR(8) NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [TRADE_TIME] VARCHAR(8) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [QTY] BIGINT NULL,
    [TMARK] VARCHAR(1) NULL,
    [SELL_BUY] VARCHAR(4) NOT NULL,
    [MARKETRATE] MONEY NULL,
    [MARKETAMT] MONEY NULL,
    [BROKERAGE] MONEY NULL,
    [SERVICE_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [NETAMOUNT] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [NETAMOUNTALL] MONEY NULL,
    [PRINTF] TINYINT NULL,
    [BROK] MONEY NULL,
    [NETRATE] MONEY NULL,
    [CL_RATE] MONEY NULL,
    [UCC_CODE] VARCHAR(20) NULL,
    [BROKERSEBIREGNO] VARCHAR(20) NULL,
    [MEMBERCODE] VARCHAR(50) NULL,
    [CINNO] VARCHAR(100) NULL,
    [BRANCH_CD] VARCHAR(15) NULL,
    [SUB_BROKER] VARCHAR(15) NULL,
    [TRADER] VARCHAR(25) NULL,
    [AREA] VARCHAR(25) NULL,
    [REGION] VARCHAR(25) NULL,
    [FAMILY] VARCHAR(15) NULL,
    [MAPIDID] VARCHAR(20) NULL,
    [SEBI_NO] VARCHAR(25) NULL,
    [PARTICIPANT_CODE] VARCHAR(16) NULL,
    [CL_TYPE] VARCHAR(3) NULL,
    [SERVICE_CHRG] TINYINT NULL,
    [SETTTYPE_DESC] VARCHAR(35) NULL,
    [BFCF_FLAG] VARCHAR(6) NULL,
    [CONTRACT_HEADER_DET] VARCHAR(200) NULL,
    [REMARK] VARCHAR(20) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [REMARK_ID] VARCHAR(1) NULL,
    [REMARK_DESC] VARCHAR(200) NULL,
    [NETOBLIGATION] MONEY NULL,
    [SETTLEMENT_DET] VARCHAR(600) NULL,
    [CONTRACTNO_DET] VARCHAR(600) NULL,
    [BROKERSEBIREGNO_DET] VARCHAR(600) NULL,
    [MEMBERCODE_DET] VARCHAR(600) NULL,
    [CIN_DET] VARCHAR(600) NULL,
    [NETAMOUNTEX] NUMERIC(20, 6) NULL,
    [SEBI_TAXEX] NUMERIC(18, 4) NULL,
    [TURN_TAXEX] NUMERIC(18, 4) NULL,
    [BROKER_CHRGEX] NUMERIC(18, 4) NULL,
    [OTHER_CHRGEX] NUMERIC(18, 4) NULL,
    [INS_CHRGEX] NUMERIC(18, 4) NULL,
    [SERVICE_TAXEX] NUMERIC(18, 4) NULL,
    [BROKERAGE_TAXEX] NUMERIC(18, 4) NULL,
    [SCRIPNAME_NEW] VARCHAR(300) NULL,
    [REMARK_DET] VARCHAR(300) NULL,
    [ORDFLAG] VARCHAR(5) NULL,
    [ISIN] VARCHAR(12) NULL,
    [ORD_DATE] VARCHAR(14) NULL,
    [NUMERATOR] INT NULL,
    [DENOMINATOR] INT NULL,
    [CGST_TAXEX] NUMERIC(18, 6) NULL,
    [SGST_TAXEX] NUMERIC(18, 6) NULL,
    [IGST_TAXEX] NUMERIC(18, 6) NULL,
    [UGST_TAXEX] NUMERIC(18, 6) NULL,
    [CGST] NUMERIC(18, 6) NULL,
    [SGST] NUMERIC(18, 6) NULL,
    [IGST] NUMERIC(18, 6) NULL,
    [UGST] NUMERIC(18, 6) NULL,
    [CLGSTNO] VARCHAR(30) NULL,
    [GSTFLAG] INT NULL,
    [CGST_PER] NUMERIC(18, 2) NULL,
    [SGST_PER] NUMERIC(18, 2) NULL,
    [IGST_PER] NUMERIC(18, 2) NULL,
    [UGST_PER] NUMERIC(18, 2) NULL,
    [TARGETSTATE] VARCHAR(30) NULL,
    [SOURCESTATE] VARCHAR(30) NULL,
    [STATE_CODE] VARCHAR(30) NULL,
    [DEAL_CLIENT_ADD] VARCHAR(500) NULL,
    [TGST_NO] VARCHAR(30) NULL,
    [TPAN_NO] VARCHAR(30) NULL,
    [TDESC_SERVICE] VARCHAR(100) NULL,
    [TACC_SERVICE_NO] VARCHAR(50) NULL,
    [TAXABLE_VALUE] NUMERIC(18, 4) NULL,
    [SEBIREGNO] VARCHAR(100) NULL,
    [BR_CMDPID] VARCHAR(100) NULL,
    [CONTRACT_HEADER_DET_NEW] VARCHAR(100) NULL,
    [STTFLAG] INT NULL,
    [SERFLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast_MCDX_BKP_09AUG2024
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast_MCDX_BKP_09AUG2024]
(
    [COSTNAME] CHAR(35) NOT NULL,
    [COSTCODE] SMALLINT NOT NULL,
    [CATCODE] SMALLINT NOT NULL,
    [GrpCode] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast_MCDXCDS_BKP_09AUG2024
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast_MCDXCDS_BKP_09AUG2024]
(
    [Costname] CHAR(35) NOT NULL,
    [Costcode] SMALLINT NOT NULL,
    [Catcode] SMALLINT NOT NULL,
    [Grpcode] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast_NCDX_BKP_09AUG2024
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast_NCDX_BKP_09AUG2024]
(
    [COSTNAME] CHAR(35) NOT NULL,
    [COSTCODE] SMALLINT NOT NULL,
    [CATCODE] SMALLINT NOT NULL,
    [GrpCode] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast_NCE_BKP_09AUG2024
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast_NCE_BKP_09AUG2024]
(
    [Costname] CHAR(35) NOT NULL,
    [Costcode] SMALLINT NOT NULL,
    [Catcode] SMALLINT NOT NULL,
    [Grpcode] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.duplicatecharges
-- --------------------------------------------------
CREATE TABLE [dbo].[duplicatecharges]
(
    [cd_party_code] VARCHAR(10) NULL,
    [cd_order_no] VARCHAR(20) NULL,
    [cd_sell_buy] INT NOT NULL,
    [order_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo
-- --------------------------------------------------
CREATE TABLE [dbo].[fo]
(
    [Trade_no] VARCHAR(20) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [sec_name] VARCHAR(50) NULL,
    [expirydate] SMALLDATETIME NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(2) NULL,
    [tradeqty] INT NULL,
    [MarketType] VARCHAR(10) NULL,
    [user_id] VARCHAR(15) NULL,
    [order_no] VARCHAR(20) NULL,
    [Price] MONEY NULL,
    [Pro_cli] INT NULL,
    [O_C_flag] VARCHAR(5) NULL,
    [C_U_flag] VARCHAR(7) NULL,
    [activitytime] DATETIME NULL,
    [Table_No] SMALLINT NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] DECIMAL(10, 6) NULL,
    [day_puc] NUMERIC(18, 4) NULL,
    [day_sales] NUMERIC(18, 4) NULL,
    [Sett_purch] NUMERIC(18, 4) NULL,
    [Sett_sales] NUMERIC(18, 4) NULL,
    [Sell_buy] INT NULL,
    [settflag] INT NULL,
    [Insurance_chrg] DECIMAL(5, 4) NULL,
    [turnover_tax] DECIMAL(5, 4) NULL,
    [sebiturn_tax] DECIMAL(5, 4) NULL,
    [broker_note] DECIMAL(6, 4) NULL,
    [SerTax] MONEY NULL,
    [year] VARCHAR(4) NOT NULL,
    [exchange] VARCHAR(3) NOT NULL,
    [off_phone1] VARCHAR(15) NULL,
    [BrokApplied] NUMERIC(38, 6) NULL,
    [NetRate] NUMERIC(38, 6) NULL,
    [Amount] NUMERIC(38, 6) NULL,
    [Ins_chrg] NUMERIC(38, 6) NULL,
    [turn_tax] NUMERIC(38, 6) NULL,
    [other_chrg] NUMERIC(38, 6) NULL,
    [sebi_tax] NUMERIC(38, 6) NULL,
    [Broker_chrg] INT NOT NULL,
    [Service_tax] NUMERIC(38, 6) NULL,
    [Trade_amount] NUMERIC(38, 6) NULL,
    [auctionpart] VARCHAR(1) NOT NULL,
    [ParticipantCode] VARCHAR(50) NULL,
    [Status] VARCHAR(3) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] NUMERIC(18, 0) NULL,
    [BookType] NUMERIC(18, 0) NULL,
    [BookTypeName] NUMERIC(18, 0) NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NOT NULL,
    [Scheme] TINYINT NULL,
    [Dummy1] INT NOT NULL,
    [Dummy2] NUMERIC(38, 6) NULL,
    [Reserved1] MONEY NULL,
    [Reserved2] VARCHAR(20) NULL,
    [cl_type] VARCHAR(3) NULL,
    [C_Regular_Lot] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foclientbrokscheme_BKP_20220430_KKLE1461
-- --------------------------------------------------
CREATE TABLE [dbo].[foclientbrokscheme_BKP_20220430_KKLE1461]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [DATE_FROM] DATETIME NULL,
    [DATE_TO] DATETIME NULL,
    [FUT_BROKTABLE] INT NULL,
    [OPT_BROKTABLE] INT NULL,
    [FUT_EXP_BROKTABLE] INT NULL,
    [OPT_EXC_BROKTABLE] INT NULL,
    [COMM_DEL_BROKTABLE] INT NULL,
    [BROK_SCHEME] TINYINT NULL,
    [OPT_BROK_COMPUTEON] VARCHAR(7) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOCLIENTBROKSCHEME_BKP_20220618
-- --------------------------------------------------
CREATE TABLE [dbo].[FOCLIENTBROKSCHEME_BKP_20220618]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [DATE_FROM] DATETIME NULL,
    [DATE_TO] DATETIME NULL,
    [FUT_BROKTABLE] INT NULL,
    [OPT_BROKTABLE] INT NULL,
    [FUT_EXP_BROKTABLE] INT NULL,
    [OPT_EXC_BROKTABLE] INT NULL,
    [COMM_DEL_BROKTABLE] INT NULL,
    [BROK_SCHEME] TINYINT NULL,
    [OPT_BROK_COMPUTEON] VARCHAR(7) NULL,
    [RNK] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOCLIENTTAXES_30APR2024
-- --------------------------------------------------
CREATE TABLE [dbo].[FOCLIENTTAXES_30APR2024]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Date_From] DATETIME NULL,
    [Date_To] DATETIME NULL,
    [Fut_Insurance_Chrg] DECIMAL(18, 5) NULL,
    [Fut_Turnover_Tax] DECIMAL(18, 5) NULL,
    [Fut_Other_Chrg] DECIMAL(18, 5) NULL,
    [Fut_Sebiturn_Tax] DECIMAL(18, 5) NULL,
    [Fut_Broker_Note] DECIMAL(18, 5) NULL,
    [Opt_Insurance_Chrg] DECIMAL(18, 5) NULL,
    [Opt_Turnover_Tax] DECIMAL(18, 5) NULL,
    [Opt_Other_Chrg] DECIMAL(18, 5) NULL,
    [Opt_Sebiturn_Tax] DECIMAL(18, 5) NULL,
    [Opt_Broker_Note] DECIMAL(18, 5) NULL,
    [Round_To] DECIMAL(18, 0) NULL,
    [RoFig] INT NULL,
    [ErrNum] NUMERIC(18, 10) NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOGLOBALS_BKUP_30SEP2024
-- --------------------------------------------------
CREATE TABLE [dbo].[FOGLOBALS_BKUP_30SEP2024]
(
    [year] VARCHAR(4) NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] MONEY NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] SMALLINT NULL,
    [sebi_turn_ac] SMALLINT NULL,
    [broker_note_ac] SMALLINT NULL,
    [other_chrg_ac] SMALLINT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NULL,
    [year_end_dt] DATETIME NULL,
    [CESS_Tax] NUMERIC(10, 9) NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NULL,
    [EDUCESS_TAX] NUMERIC(18, 4) NULL,
    [Insurance_Chrg_Ac] SMALLINT NULL,
    [OptTrdSellTrans] NUMERIC(18, 4) NULL,
    [OptDelSellTrans] NUMERIC(18, 4) NULL,
    [STT_On] VARCHAR(7) NULL,
    [KRISHICHARGE] NUMERIC(18, 4) NULL,
    [SBCCHARGE] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_INTRADAY
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_INTRADAY]
(
    [FILECOUNTER] INT NOT NULL,
    [MDATE] DATETIME NULL,
    [FILETIME] VARCHAR(20) NULL,
    [CMCODE] VARCHAR(12) NULL,
    [TMCODE] VARCHAR(12) NULL,
    [PARTY_CODE] VARCHAR(12) NULL,
    [INITIALMARGIN] MONEY NULL,
    [EXTREAMELOSSMARGIN] MONEY NULL,
    [NETBUYPREMIUM] MONEY NULL,
    [TOTALMARGIN] MONEY NULL,
    [UPLOADBY] VARCHAR(50) NULL,
    [UPLOAD_ON] DATETIME NOT NULL,
    [CLIENT_MAR_ALLOC] NUMERIC(18, 4) NULL,
    [CLIENT_OTHER_COLL] NUMERIC(18, 4) NULL,
    [SHORT_ALLOC] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_INTRADAY_11JUL2024
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_INTRADAY_11JUL2024]
(
    [FILECOUNTER] INT NOT NULL,
    [MDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(12) NULL,
    [PORTFOLIO_BASED_MARGIN] MONEY NULL,
    [NET_BUY_PREMIUM] MONEY NULL,
    [INITIAL_MARGIN] MONEY NULL,
    [ELM_MARGIN] MONEY NULL,
    [PRE_EXPIRY_MARGIN] MONEY NULL,
    [DELIVERY_MARGIN] MONEY NULL,
    [UNIDIRECTIONAL_MARGIN] MONEY NULL,
    [CONCENTRATION_MARGIN] MONEY NULL,
    [ADHOC_MARGIN] MONEY NULL,
    [CASH_MARGIN] MONEY NULL,
    [CRYSTALLIZED_LOSS_MARGIN] MONEY NULL,
    [MTOM_LOSS] MONEY NULL,
    [CL_TYPE] VARCHAR(1) NOT NULL,
    [UPLOADBY] VARCHAR(50) NULL,
    [UPLOAD_ON] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_INTRADAY_22APR2025
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_INTRADAY_22APR2025]
(
    [FILECOUNTER] INT NOT NULL,
    [MDATE] DATETIME NULL,
    [FILETIME] VARCHAR(20) NULL,
    [CMCODE] VARCHAR(12) NULL,
    [TMCODE] VARCHAR(12) NULL,
    [PARTY_CODE] VARCHAR(12) NULL,
    [INITIALMARGIN] MONEY NULL,
    [EXTREAMELOSSMARGIN] MONEY NULL,
    [NETBUYPREMIUM] MONEY NULL,
    [TOTALMARGIN] MONEY NULL,
    [UPLOADBY] VARCHAR(50) NULL,
    [UPLOAD_ON] DATETIME NOT NULL,
    [CLIENT_MAR_ALLOC] NUMERIC(18, 4) NULL,
    [CLIENT_OTHER_COLL] NUMERIC(18, 4) NULL,
    [SHORT_ALLOC] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNTBFO_bkup_01DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNTBFO_bkup_01DEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNTCURBFO_bkup_01DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNTCURBFO_bkup_01DEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_AccountMCDX_bkup_01DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_AccountMCDX_bkup_01DEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNTMCDXCDS_bkup_01DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNTMCDXCDS_bkup_01DEC2022]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_ACCOUNTNCDX_bkup_01DEC2022
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_ACCOUNTNCDX_bkup_01DEC2022]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountBFO
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountBFO]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountCURBFO
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountCURBFO]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountMCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountMCDX]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountMCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountMCDXCDS]
(
    [SRNO] BIGINT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountNCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINNEW_LEDGERBAL_BKP_20221125_AccountNCDX]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [MARGINDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LEDBAL] MONEY NULL,
    [UPDATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOSCRIP2_BKUP_CRUDEOIL
-- --------------------------------------------------
CREATE TABLE [dbo].[FOSCRIP2_BKUP_CRUDEOIL]
(
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
    [C_U_CAL] INT NULL,
    [PriceUnit] VARCHAR(20) NULL,
    [Numerator] MONEY NULL,
    [Denominator] MONEY NULL,
    [RegularLot] MONEY NULL,
    [Qty_Unit] VARCHAR(10) NULL,
    [Delivery_Lot] NUMERIC(18, 4) NULL,
    [Delivery_Unit] VARCHAR(10) NULL,
    [P_Key] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fosettlement_bak_17112023
-- --------------------------------------------------
CREATE TABLE [dbo].[fosettlement_bak_17112023]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(14) NOT NULL,
    [BILLNO] NUMERIC(12, 0) NULL,
    [TRADE_NO] VARCHAR(16) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [INST_TYPE] VARCHAR(7) NULL,
    [SYMBOL] VARCHAR(22) NULL,
    [SEC_NAME] VARCHAR(22) NULL,
    [EXPIRYDATE] DATETIME NULL,
    [STRIKE_PRICE] NUMERIC(12, 4) NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [USER_ID] VARCHAR(16) NULL,
    [PRO_CLI] VARCHAR(1) NULL,
    [O_C_FLAG] INT NOT NULL,
    [C_U_FLAG] INT NOT NULL,
    [TRADEQTY] INT NULL,
    [AUCTIONPART] VARCHAR(2) NULL,
    [MARKETTYPE] VARCHAR(1) NOT NULL,
    [SERIES] INT NOT NULL,
    [ORDER_NO] VARCHAR(20) NULL,
    [PRICE] NUMERIC(12, 4) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [TABLE_NO] SMALLINT NULL,
    [LINE_NO] DECIMAL(18, 0) NULL,
    [VAL_PERC] VARCHAR(1) NULL,
    [NORMAL] DECIMAL(18, 0) NULL,
    [DAY_PUC] DECIMAL(18, 0) NULL,
    [DAY_SALES] DECIMAL(18, 0) NULL,
    [SETT_PURCH] DECIMAL(18, 0) NULL,
    [SETT_SALES] DECIMAL(18, 0) NULL,
    [SELL_BUY] INT NULL,
    [SETTFLAG] INT NULL,
    [BROKAPPLIED] NUMERIC(18, 4) NULL,
    [NETRATE] NUMERIC(18, 4) NULL,
    [AMOUNT] NUMERIC(23, 4) NULL,
    [INS_CHRG] NUMERIC(18, 4) NULL,
    [TURN_TAX] NUMERIC(18, 4) NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NULL,
    [SEBI_TAX] NUMERIC(18, 4) NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NULL,
    [TRADE_AMOUNT] NUMERIC(18, 4) NULL,
    [BILLFLAG] INT NOT NULL,
    [SETT_NO] INT NOT NULL,
    [NBROKAPP] NUMERIC(18, 4) NULL,
    [NSERTAX] NUMERIC(18, 4) NULL,
    [N_NETRATE] NUMERIC(18, 4) NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [CL_RATE] INT NOT NULL,
    [PARTICIPANTCODE] VARCHAR(12) NULL,
    [STATUS] VARCHAR(2) NULL,
    [CPID] VARCHAR(8) NULL,
    [INSTRUMENT] INT NOT NULL,
    [BOOKTYPE] INT NOT NULL,
    [BRANCH_ID] VARCHAR(10) NULL,
    [TMARK] VARCHAR(1) NOT NULL,
    [SCHEME] INT NOT NULL,
    [DUMMY1] INT NULL,
    [DUMMY2] NUMERIC(36, 12) NULL,
    [RESERVED1] TINYINT NULL,
    [RESERVED2] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GENERATE_SNO_bkup_05Oct2023
-- --------------------------------------------------
CREATE TABLE [dbo].[GENERATE_SNO_bkup_05Oct2023]
(
    [SRNO] INT NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER]
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
-- TABLE dbo.ledger_BKP_20220609_NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_BKP_20220609_NCDX]
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
-- TABLE dbo.Ledger_BKUP_28Jan2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Ledger_BKUP_28Jan2023]
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
-- TABLE dbo.Ledger_Delivery_31Aug25
-- --------------------------------------------------
CREATE TABLE [dbo].[Ledger_Delivery_31Aug25]
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
-- TABLE dbo.ledger_NCE
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger_NCE]
(
    [Vtyp] SMALLINT NOT NULL,
    [Vno] VARCHAR(12) NOT NULL,
    [Edt] DATETIME NULL,
    [Lno] INT NOT NULL,
    [Acname] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Vamt] MONEY NULL,
    [Vdt] DATETIME NOT NULL,
    [Vno1] VARCHAR(12) NULL,
    [Refno] CHAR(12) NULL,
    [Balamt] MONEY NOT NULL,
    [Nodays] INT NULL,
    [Cdt] DATETIME NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Booktype] CHAR(2) NOT NULL,
    [Enteredby] VARCHAR(25) NULL,
    [Pdt] DATETIME NULL,
    [Checkedby] VARCHAR(25) NULL,
    [Actnodays] INT NULL,
    [Narration] VARCHAR(500) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger1_NCE
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger1_NCE]
(
    [Bnkname] VARCHAR(50) NULL,
    [Brnname] VARCHAR(20) NULL,
    [Dd] CHAR(1) NULL,
    [Ddno] VARCHAR(30) NULL,
    [Dddt] DATETIME NULL,
    [Reldt] DATETIME NULL,
    [Relamt] MONEY NULL,
    [Refno] CHAR(12) NOT NULL,
    [Receiptno] INT NULL,
    [Vtyp] SMALLINT NULL,
    [Vno] VARCHAR(12) NULL,
    [Lno] INT NULL,
    [Drcr] CHAR(1) NULL,
    [Booktype] CHAR(2) NULL,
    [Micrno] INT NULL,
    [Slipno] INT NULL,
    [Slipdate] DATETIME NULL,
    [Chequeinname] VARCHAR(100) NULL,
    [Chqprinted] TINYINT NULL,
    [Clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger2_NCE
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger2_NCE]
(
    [Vtype] SMALLINT NULL,
    [Vno] VARCHAR(12) NULL,
    [Lno] INT NULL,
    [Drcr] CHAR(1) NULL,
    [Camt] MONEY NULL,
    [Costcode] SMALLINT NULL,
    [Booktype] CHAR(2) NULL,
    [Cltcode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger3_NCE
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger3_NCE]
(
    [Naratno] INT NOT NULL,
    [Narr] VARCHAR(500) NULL,
    [Refno] CHAR(12) NULL,
    [Vtyp] SMALLINT NULL,
    [Vno] VARCHAR(12) NULL,
    [Booktype] CHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapp_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[mapp_comm]
(
    [party_code] VARCHAR(20) NOT NULL,
    [OmneManagerID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcdx_pos
-- --------------------------------------------------
CREATE TABLE [dbo].[mcdx_pos]
(
    [party_code] VARCHAR(10) NOT NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NOT NULL,
    [expirydate] SMALLDATETIME NOT NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(2) NULL,
    [pqty] INT NOT NULL,
    [sqty] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_bkup_18Dec2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_bkup_18Dec2023]
(
    [BrokerId] VARCHAR(6) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL,
    [MemberType] VARCHAR(3) NOT NULL,
    [MemberCode] VARCHAR(15) NOT NULL,
    [ShareDb] VARCHAR(20) NOT NULL,
    [ShareServer] VARCHAR(15) NOT NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NOT NULL,
    [AccountServer] VARCHAR(15) NOT NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NOT NULL,
    [DefaultDbServer] VARCHAR(15) NOT NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [primaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
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
-- TABLE dbo.owner_bkup_16Dec2023
-- --------------------------------------------------
CREATE TABLE [dbo].[owner_bkup_16Dec2023]
(
    [Companyname] VARCHAR(200) NOT NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Sharedb] VARCHAR(10) NOT NULL,
    [Accountdb] VARCHAR(12) NULL,
    [Clientgroup] VARCHAR(35) NULL,
    [Balsign] TINYINT NULL,
    [Conpath] VARCHAR(50) NULL,
    [Segment] VARCHAR(20) NULL,
    [Membertype] VARCHAR(15) NULL,
    [Panno] VARCHAR(40) NULL,
    [RecoFlag] CHAR(1) NOT NULL,
    [MULTI_MARGIN] CHAR(1) NULL,
    [ActiveDays] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCHEME_02NOV2024
-- --------------------------------------------------
CREATE TABLE [dbo].[SCHEME_02NOV2024]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [A] VARCHAR(1) NOT NULL,
    [B] VARCHAR(3) NOT NULL,
    [V] VARCHAR(3) NOT NULL,
    [E] NUMERIC(18, 0) NULL,
    [SM_Trd_Type] VARCHAR(3) NOT NULL,
    [SR] INT NOT NULL,
    [SM_Multiplier] NUMERIC(18, 4) NOT NULL,
    [SM_Buy_Brok_Type] CHAR(1) NOT NULL,
    [SM_Sell_Brok_Type] CHAR(10) NOT NULL,
    [SM_Buy_Brok] NUMERIC(18, 4) NOT NULL,
    [SM_Sell_Brok] NUMERIC(18, 4) NOT NULL,
    [SM_Res_Multiplier] VARCHAR(6) NOT NULL,
    [SM_Res_Buy_Brok] NUMERIC(18, 4) NOT NULL,
    [SM_Res_Sell_Brok] NUMERIC(18, 4) NOT NULL,
    [SM_Value_From] NUMERIC(18, 4) NOT NULL,
    [SM_Value_To] NUMERIC(18, 4) NOT NULL,
    [SM_TurnOverOn] VARCHAR(7) NOT NULL,
    [SM_ComputationOn] CHAR(1) NOT NULL,
    [SM_ComputationType] CHAR(1) NOT NULL,
    [MIN_BROK] NUMERIC(18, 9) NULL,
    [MAX_BROK] NUMERIC(18, 9) NULL,
    [S] VARCHAR(6) NOT NULL,
    [T] VARCHAR(7) NOT NULL,
    [ERE] VARCHAR(11) NULL,
    [U] VARCHAR(23) NOT NULL,
    [VX] VARCHAR(4) NOT NULL,
    [RE] DATETIME NOT NULL,
    [Z] VARCHAR(1) NOT NULL,
    [R] DATETIME NOT NULL
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
-- TABLE dbo.Stt_Clientdetail_BKUP_25Aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Stt_Clientdetail_BKUP_25Aug2023]
(
    [Rectype] INT NOT NULL,
    [Sauda_Date] DATETIME NOT NULL,
    [Contractno] VARCHAR(7) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [product_type] VARCHAR(5) NULL,
    [product_code] VARCHAR(10) NULL,
    [Series_code] VARCHAR(13) NULL,
    [Series_id] INT NULL,
    [Expirydate] DATETIME NOT NULL,
    [Trdprice] MONEY NULL,
    [Pqtytrd] INT NULL,
    [Pamttrd] MONEY NULL,
    [Pstttrd] MONEY NULL,
    [Sqtytrd] INT NULL,
    [Samttrd] MONEY NULL,
    [Sstttrd] MONEY NULL,
    [Totalstt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ARCHIVAL_COUNT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ARCHIVAL_COUNT]
(
    [TBLNAME] VARCHAR(50) NULL,
    [CNT] BIGINT NULL,
    [DBType] VARCHAR(50) NULL,
    [DBNAME] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_BKUP_20May2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_BKUP_20May2024]
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
-- TABLE dbo.tbl_auto_process_master_BKUP_MCDX_21DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_MCDX_21DEC2024]
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
-- TABLE dbo.tbl_auto_process_master_BKUP_NCDX_21DEC2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_auto_process_master_BKUP_NCDX_21DEC2024]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_MCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_MCDX]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_MCDX_BKUP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_MCDX_BKUP_13MAY2024]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_MCDXCDS]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_NCDX]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_NCDX_BKUP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_NCDX_BKUP_13MAY2024]
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
-- TABLE dbo.TBL_AUTO_PROCESS_MASTER_NCDX_BKUP_20May2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AUTO_PROCESS_MASTER_NCDX_BKUP_20May2024]
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
-- TABLE dbo.TBL_COMMONCONTRACT_MASTER_BKUP_01NOV2025
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_COMMONCONTRACT_MASTER_BKUP_01NOV2025]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACT_TYPE] INT NULL,
    [FNO_CONTRACT_BILL] INT NULL,
    [EFFECTIVE_FROM] DATETIME NULL,
    [EFFECTIVE_TO] DATETIME NULL,
    [CREATED_BY] VARCHAR(20) NULL,
    [CREATED_ON] DATETIME NULL,
    [PRINT_SUB_TOT] INT NULL,
    [PRINT_NET_TOT] INT NULL,
    [PRINT_DEALING] VARCHAR(100) NULL,
    [PRINT_STT_COLUMN] INT NULL,
    [CONTRACTGROUP] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_TURNOVER_SLAB_SYMBOL_BKP_13MAY2024
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_TURNOVER_SLAB_SYMBOL_BKP_13MAY2024]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [INST_TYPE] VARCHAR(3) NULL,
    [SYMBOL] VARCHAR(20) NULL,
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
-- TABLE dbo.tblPradnyausers_T0_Series_data_MCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[tblPradnyausers_T0_Series_data_MCDX]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldusername] NVARCHAR(25) NULL,
    [fldpassword] NVARCHAR(15) NULL,
    [fldfirstname] NVARCHAR(25) NULL,
    [fldmiddlename] NVARCHAR(25) NULL,
    [fldlastname] NVARCHAR(25) NULL,
    [fldsex] NVARCHAR(8) NULL,
    [fldaddress1] NVARCHAR(40) NULL,
    [fldaddress2] NVARCHAR(40) NULL,
    [fldphone1] NVARCHAR(10) NULL,
    [fldphone2] NVARCHAR(10) NULL,
    [fldcategory] NVARCHAR(10) NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldstname] NVARCHAR(50) NULL,
    [PWD_EXPIRY_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblPradnyausers_T0_Series_data_NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[tblPradnyausers_T0_Series_data_NCDX]
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

