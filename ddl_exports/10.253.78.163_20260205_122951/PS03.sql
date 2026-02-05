-- DDL Export
-- Server: 10.253.78.163
-- Database: PS03
-- Exported: 2026-02-05T12:30:02.666121

USE PS03;
GO

-- --------------------------------------------------
-- INDEX dbo.AlternateBranchSB
-- --------------------------------------------------
CREATE CLUSTERED INDEX [alt_termid] ON [dbo].[AlternateBranchSB] ([alt_termid], [alt_Exchange])

GO

-- --------------------------------------------------
-- INDEX dbo.fotrd
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party_code] ON [dbo].[fotrd] ([party_code], [termid])

GO

-- --------------------------------------------------
-- INDEX dbo.margin_short
-- --------------------------------------------------
CREATE CLUSTERED INDEX [sauda_date] ON [dbo].[margin_short] ([sauda_date], [Party_code])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECK_PS03
-- --------------------------------------------------
CREATE PROCEDURE CHECK_PS03
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

select distinct party_code INTO #FOCLI FROM 
--INTRANET.RISK.DBO.FO_client2
angelfo.nsefo.dbo.client2


select distinct trd.party_code  , termid.branch_cd, termid.branch_name, termid.sub_broker
from (sELECT * FROM fotrd WHERE party_code not in (SELECT PARTY_cODE FROM #FOCLI) )trd left join fo_termid_list termid
on trd.termid = termid.termid
order by trd.party_code

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CURRENCY_MARGIN_DEBITNOTE_JV
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[CURRENCY_MARGIN_DEBITNOTE_JV] --'may 21 2011' ,'may 25 2011' ,'A' ,'Z'  
(  
    @SSAUDA_DATE varchar(11),  
    @ESAUDA_DATE varchar(11),  
    @SPCODE VARCHAR(25),  
    @EPCODE VARCHAR(25)  
)  
AS  
begin  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
/*  
DECLARE @SSAUDA_DATE VARCHAR(11),@ESAUDA_DATE VARCHAR(11), @SPCODE VARCHAR(25), @EPCODE VARCHAR(25)  
SET @SSAUDA_DATE = '13/06/2011'  
SET @ESAUDA_DATE = '13/06/2011'  
SET @SPCODE = 'A'  
SET @EPCODE = 'Z'  
*/       
                             
    SELECT SAUDA_DATE,PARTY_CODE = ISNULL(MS.PARTY_CODE,'NO DATA') ,  
    PARTY_NAME = C1.LONG_NAME ,  
    BRANCH_CD = ISNULL(C1.BRANCH_CD,'NO DATA') ,-- BRANCH_NAME = BR.BRANCH ,  
    ADD1=C1.L_ADDRESS1,ADD2=C1.L_ADDRESS2,ADD3=C1.L_ADDRESS3,  
    CITY=C1.L_CITY,STATE=C1.L_STATE, PIN=C1.L_ZIP,  
    SPAN = CONVERT(VARCHAR,SUM(SPAN)) , PREMIUM =CONVERT(VARCHAR,SUM(PREMIUM)) ,  
    SPAN_PREM = CONVERT(VARCHAR,SUM(SPAN_PREM)),  
    MTM_VALUE = CONVERT(VARCHAR,SUM(MTM_VALUE)) ,  
    COLLECTED = CONVERT(VARCHAR,SUM(COLLECTED)) ,  
    SHORTAGE = CONVERT(VARCHAR,SUM(SHORTAGE)) --,PERC_SHORTAGE = CONVERT(VARCHAR,ROUND(SUM(SHORTAGE)*100/SUM(SPAN_PREM)+1,2))  
    INTO #AA  
    FROM currencyFoTemp MS (NOLOCK) LEFT JOIN  
    INTRANET.RISK.DBO.CLIENT_DETAILS C1  
    ON MS.PARTY_CODE = C1.PARTY_CODE  
    WHERE SAUDA_DATE >= convert(datetime,@SSAUDA_DATE,103) AND SAUDA_DATE <= convert(datetime,@ESAUDA_DATE,103)  
    AND MS.PARTY_CODE >= @SPCODE AND MS.PARTY_CODE <= @EPCODE  
    GROUP BY MS.SAUDA_DATE,MS.PARTY_CODE , C1.LONG_NAME, C1.L_ADDRESS1, C1.BRANCH_CD,  
    C1.L_ADDRESS2,C1.L_ADDRESS3,C1.L_CITY,C1.L_STATE,C1.L_ZIP                                             
           
    DECLARE @PERCEN MONEY  
    SELECT @PERCEN=SUM(CONVERT(MONEY,SHORTAGE)*-1)*100/SUM(CONVERT(MONEY,SPAN_PREM)) FROM #AA  
    --SELECT @PERCEN  
  
    SELECT SAUDA_DATE,PARTY_CODE,SHORTAGE=CONVERT(MONEY,SHORTAGE)*-1,  
    PENALTY=(CASE WHEN @PERCEN>=10 AND @PERCEN<20   
                THEN CONVERT(DECIMAL(18,2),(CONVERT(MONEY,SHORTAGE)*-1)*0.0005)  
                WHEN @PERCEN>=20   
                THEN CONVERT(DECIMAL(18,2),(CONVERT(MONEY,SHORTAGE)*-1)*0.0010)  
                ELSE 0  
             END)  
    INTO #BB  
    FROM #AA  
    ORDER BY PARTY_CODE , SAUDA_DATE  
  
    IF(@PERCEN<10)  
    BEGIN  
    TRUNCATE TABLE #BB  
    end  
  
    DECLARE @SERVICE_TAX NUMERIC(18,2)  
    DECLARE @CESS_TAX NUMERIC(18,2)  
    DECLARE @SHE_TAX NUMERIC(18,2)  
    SELECT @SERVICE_TAX=SERVICE_TAX,@CESS_TAX=CESS_TAX,@SHE_TAX=SHE_TAX  
    FROM INTRANET.RISK.DBO.PP_SERVICETAX_MASTER WHERE FLD_STATUS='A'                              
                             
                            
    SELECT PARTY_CODE,CLTCODE=PARTY_CODE,DRCR='D',  
    AMOUNT=PENALTY+  
            CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100))+  
            CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100))+  
            CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100)),  
    NARRATION=CONVERT(VARCHAR(250),  
    'BEING MARGIN SHORTAGE PENALTY DTD '+CONVERT(VARCHAR(11),SAUDA_DATE,103))INTO #CC  
    FROM #BB  
    where (PENALTY+CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100))+  
            CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100))+  
            CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100)))>0  
    UNION  
    SELECT PARTY_CODE,CLTCODE='51000001',DRCR='C',  
    AMOUNT=CONVERT(DECIMAL(18,2),PENALTY),  
    NARRATION='BEING MARGIN SHORTAGE PENALTY DTD '+ CONVERT(VARCHAR(11),SAUDA_DATE,103) FROM #BB  
    where (CONVERT(DECIMAL(18,2),PENALTY)) >0  
    UNION  
    SELECT PARTY_CODE,CLTCODE='99961',DRCR='C',  
    AMOUNT=CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100)),  
    NARRATION='SERVICE TAX @10% ON MARGIN SHORTAGE PENALTY' FROM #BB  
    where (CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100))) >0  
    UNION  
    SELECT PARTY_CODE,CLTCODE='99962',DRCR='C',  
    AMOUNT=CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100)),  
    NARRATION='CESS TAX @ 0.20%ON MARGIN SHORTAGE PENALTY ' FROM #BB  
    where (CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100))) >0  
    UNION  
    SELECT PARTY_CODE,CLTCODE='99963',DRCR='C',  
    AMOUNT=CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100)),  
    NARRATION='EDU CESS @ 0.10% ON MARGIN SHORTAGE PENALTY ' FROM #BB  
    where (CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100))) >0  
    ORDER BY PARTY_CODE,DRCR DESC                            
                           
                            
    SELECT DISTINCT PARTY_CODE,SRNO=ROW_NUMBER() OVER(ORDER BY PARTY_CODE)INTO #PARTY  
    FROM #CC GROUP BY PARTY_CODE  
  
    DELETE FROM CurrencyMarginShortage_JV  
  
    INSERT INTO CurrencyMarginShortage_JV  
    SELECT SRNO=B.SRNO,VDATE=CONVERT(VARCHAR(11),GETDATE(),103),EDATE=CONVERT(VARCHAR(11),GETDATE(),103),  
    CLTCODE,DRCR,AMOUNT,NARRATION,BRANCHCODE='ALL'  
    FROM #CC A  
    INNER JOIN #PARTY B  
    ON A.PARTY_CODE=B.PARTY_CODE  
    ORDER BY B.SRNO  
  
    DECLARE @S AS VARCHAR(5000),@S1 AS VARCHAR(5000)  
    SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL '+ '''' +'BCP "SELECT * FROM Ps03.dbo.CurrencyMarginShortage_JV" QUERYOUT '+'\\INHOUSELIVEAPP2-FS.angelone.in\D$\UPLOAD1\UPDATION\currency_mARGIN_PENALTY.XLS -c -SMIS -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'  
    SET @S1= @S+''''  
    EXEC(@S1)                         
                             
  SET NOCOUNT OFF   
  end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fo_ser_tax
-- --------------------------------------------------
CREATE proc fo_ser_tax(@pcode as varchar(20),@sdate as varchar(20),@edate as varchar(20))

as
select 
--turntax = (sum((Strike_Price+convert(float,Price))*Tradeqty)* 0.000042) 
turntax = (sum((Strike_Price+convert(float,Price))*Tradeqty)* 0.00005) 
from newfotrd 
where convert(datetime,left(sauda_date,11)) 
between @sdate and @edate 
and party_code = @pcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote
-- --------------------------------------------------
CREATE procedure margin_debitnote ( @ssauda_date datetime,@esauda_date datetime, @spcode varchar(25), @epcode varchar(25))        
as        
---drop table #aa    

set nocount on
/*
declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)        
set @ssauda_Date = 'Jan 21 2008'        
set @esauda_Date = 'Jan 25 2008'        
set @spcode = 'A10110'        
set @epcode = 'a10110'      
*/
---'A2168'      
--'A2199'        
--set @epcode = @epcode + 'ZZZ'        

set transaction isolation level read uncommitted
 
        
select sauda_Date,party_code = isnull(ms.party_code,'no data') , 
 party_name = c1.long_name ,         
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch ,         
 add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3, 
 city=c1.l_city,state=c1.l_state, pin=c1.l_zip,        
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,        
 span_prem = convert(varchar,sum(span_prem))         
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,        
 shortage = convert(varchar,sum(shortage)) --,perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem)+1,2))        
 into #aa    
 from margin_short ms (nolock) left join        
 --angelfo.nsefo.dbo.client2 c2         
  intranet.risk.dbo.client_Details c1
 on ms.party_code = c1.party_code        
-- left join angelfo.nsefo.dbo.client1 c1         
-- on c1.cl_code = c2.cl_code        
-- left join angelfo.nsefo.dbo.branch br        
-- on c1.branch_cd = br.branch_code        
-- left join angelfo.nsefo.dbo.subbrokers sb        
-- on c1.sub_broker = sb.sub_broker        
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date         
and ms.party_code >= @spcode and ms.party_Code <= @epcode        
--and c1.branch_Cd = @branch_Cd        
--and c1.sub_broker = @sub_broker        
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,        
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip        
--having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 used if opp values are to be displayed        
--having sum(shortage)*100/(sum(span_prem)+1) <= -20         
--having sum(shortage)<= -50000.00 and sum(shortage) <> 0    
--order by ms.party_Code , ms.sauda_date      

select * from #aa  where (convert(money,shortage)*-1)*0.0005 > 10  
order by party_Code , sauda_date      

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote_jv
-- --------------------------------------------------
CREATE procedure [dbo].[margin_debitnote_jv] ( @ssauda_date datetime,@esauda_date datetime, @spcode varchar(25), @epcode varchar(25))                    
as                    
              
            
set nocount on            
          
set transaction isolation level read uncommitted            
        
--declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)                  
--set @ssauda_Date = 'apr 07 2011'                  
--set @esauda_Date = 'apr 07 2011'                  
--set @spcode = 'A'                  
--set @epcode = 'z'                 
                  
select sauda_Date,party_code = isnull(ms.party_code,'no data') ,             
 party_name = c1.long_name ,                     
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch ,                     
 add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3,             
 city=c1.l_city,state=c1.l_state, pin=c1.l_zip,                    
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,                    
 span_prem = convert(varchar,sum(span_prem))                     
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,                    
 shortage = convert(varchar,sum(shortage)) --,perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem)+1,2))                    
 into #aa                
 from margin_short ms (nolock) left join                    
 --angelfo.nsefo.dbo.client2 c2                     
  intranet.risk.dbo.client_Details c1            
 on ms.party_code = c1.party_code                    
-- left join angelfo.nsefo.dbo.client1 c1                     
-- on c1.cl_code = c2.cl_code                    
-- left join angelfo.nsefo.dbo.branch br                    
-- on c1.branch_cd = br.branch_code                    
-- left join angelfo.nsefo.dbo.subbrokers sb                    
-- on c1.sub_broker = sb.sub_broker                    
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date                     
and ms.party_code >= @spcode and ms.party_Code <= @epcode                    
--and c1.branch_Cd = @branch_Cd                    
--and c1.sub_broker = @sub_broker                    
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,                    
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip                    
--having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 used if opp values are to be displayed                    
--having sum(shortage)*100/(sum(span_prem)+1) <= -20                     
--having sum(shortage)<= -50000.00 and sum(shortage) <> 0                
--order by ms.party_Code , ms.sauda_date                  
            
select sauda_date,party_Code,shortage=convert(money,shortage)*-1,        
penalty=convert(decimal(18,2),(convert(money,shortage)*-1)*0.0005)        
into #bb        
from #aa  where (convert(money,shortage)*-1)*0.0005 > 10              
order by party_Code , sauda_date            
        
declare @service_tax numeric(18,2)                
declare @cess_tax numeric(18,2)        
declare @She_tax numeric(18,2)                 
select @service_tax=Service_Tax,@cess_tax=Cess_Tax,@She_tax=She_tax         
 from intranet.risk.dbo.PP_ServiceTax_Master where Fld_Status='A'            
            
        
select party_code,cltcode=party_code,drcr='D',amount=penalty+        
convert(decimal(18,2),(penalty*@service_tax/100))+        
convert(decimal(18,2),(penalty*@cess_tax/100))+        
convert(decimal(18,2),(penalty*@She_tax/100)),      
narration=convert(varchar(250),'BEING MARGIN SHORTAGE PENALTY DTD '+ convert(varchar(11),sauda_date,103))into #cc       
from #bb        
union         
select party_code,cltcode='51000001',drcr='C',        
amount=convert(decimal(18,2),penalty),      
narration='BEING MARGIN SHORTAGE PENALTY DTD '+ convert(varchar(11),sauda_date,103) from #bb        
union         
select party_code,cltcode='99961',drcr='C',        
amount=convert(decimal(18,2),(penalty*@service_tax/100)),      
narration='SERVICE TAX @10% ON MARGIN SHORTAGE PENALTY' from #bb        
union     
select party_code,cltcode='99962',drcr='C',        
amount=convert(decimal(18,2),(penalty*@cess_tax/100)),      
narration='CESS TAX @ 0.20%ON MARGIN SHORTAGE PENALTY ' from #bb        
union        
select party_code,cltcode='99963',drcr='C',        
amount=convert(decimal(18,2),(penalty*@She_tax/100)),      
narration='Edu cess @ 0.10% On Margin shortage penalty ' from #bb        
order by party_Code,drcr desc    
    
     
select distinct party_code,SRNO=ROW_NUMBER() OVER(ORDER BY party_code)into #party       
from #cc GROUP BY party_code       
  
truncate table FoMarginShortage_JV  
  
insert into FoMarginShortage_JV      
SELECT SRNO=B.SRNO,VDATE=CONVERT(VARCHAR(11),GETDATE(),103),EDATE=CONVERT(VARCHAR(11),GETDATE(),103),      
CLTCODE,DRCR,AMOUNT,NARRATION,BRANCHCODE='ALL'   
FROM #CC A      
INNER JOIN #PARTY B      
ON A.PARTY_CODE=B.PARTY_CODE      
ORDER BY B.SRNO        
  
declare @s as varchar(5000),@s1 as varchar(5000)                
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "SELECT * FROM ps03.DBO.FoMarginShortage_JV" queryout '+'\\INHOUSELIVEAPP2-FS.angelone.in\d$\upload1\Updation\Fo_Margin_Penalty.xls -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'
set @s1= @s+''''                        
exec(@s1)      
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote_New1
-- --------------------------------------------------
CREATE procedure margin_debitnote_New1 ( @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25))            
as            
---drop table #aa        
    
set nocount on    
/*    
declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)            
set @ssauda_Date = 'Jan 21 2008'            
set @esauda_Date = 'Jan 25 2008'            
set @spcode = 'A10110'            
set @epcode = 'a10110'          
*/    
---'A2168'          
--'A2199'            
--set @epcode = @epcode + 'ZZZ'            


set @ssauda_date = convert(varchar(11),convert(datetime,@ssauda_date,103))
set @esauda_date = convert(varchar(11),convert(datetime,@esauda_date,103))
    
set transaction isolation level read uncommitted    
     
            
select sauda_Date,party_code = isnull(ms.party_code,'no data') ,     
 party_name = c1.long_name ,             
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch ,             
 add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3,     
 city=c1.l_city,state=c1.l_state, pin=c1.l_zip,            
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,            
 span_prem = convert(varchar,sum(span_prem))             
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,            
 shortage = convert(varchar,sum(shortage)) --,perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem)+1,2))            
 into #aa        
 from margin_short ms (nolock) left join            
 --angelfo.nsefo.dbo.client2 c2             
  intranet.risk.dbo.client_Details c1    
 on ms.party_code = c1.party_code            
-- left join angelfo.nsefo.dbo.client1 c1             
-- on c1.cl_code = c2.cl_code            
-- left join angelfo.nsefo.dbo.branch br            
-- on c1.branch_cd = br.branch_code            
-- left join angelfo.nsefo.dbo.subbrokers sb            
-- on c1.sub_broker = sb.sub_broker            
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date             
and ms.party_code >= @spcode and ms.party_Code <= @epcode            
--and c1.branch_Cd = @branch_Cd            
--and c1.sub_broker = @sub_broker            
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,            
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip            
--having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 used if opp values are to be displayed            
--having sum(shortage)*100/(sum(span_prem)+1) <= -20             
--having sum(shortage)<= -50000.00 and sum(shortage) <> 0        
--order by ms.party_Code , ms.sauda_date          
    
select * from #aa  where (convert(money,shortage)*-1)*0.0005 > 10      
order by branch_Cd,party_Code, sauda_date          
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote_New2
-- --------------------------------------------------
CREATE procedure margin_debitnote_New2 (@ssauda_date varchar(11),@esauda_date varchar(11), @branch_cd varchar(25))            
as            
---drop table #aa        

set @ssauda_date = convert(varchar(11),convert(datetime,@ssauda_date,103))
set @esauda_date = convert(varchar(11),convert(datetime,@esauda_date,103))
    
set nocount on    
/*    
declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)            
set @ssauda_Date = 'Jan 21 2008'            
set @esauda_Date = 'Jan 25 2008'            
set @spcode = 'A10110'            
set @epcode = 'a10110'          
*/    
---'A2168'          
--'A2199'            
--set @epcode = @epcode + 'ZZZ'         

   
    
set transaction isolation level read uncommitted    
     
            
select sauda_Date,party_code = isnull(ms.party_code,'no data') ,     
 party_name = c1.long_name ,             
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch ,             
 add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3,     
 city=c1.l_city,state=c1.l_state, pin=c1.l_zip,            
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,            
 span_prem = convert(varchar,sum(span_prem))             
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,            
 shortage = convert(varchar,sum(shortage)) --,perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem)+1,2))            
into #aa        
from margin_short ms (nolock) left join            
intranet.risk.dbo.client_Details c1    
on ms.party_code = c1.party_code            
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date             
--where sauda_date >= 'Feb 01 2008' and sauda_date <= 'Feb 10 2008'             
and c1.branch_cd = @branch_cd      
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,            
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip            

    
select * from #aa  where (convert(money,shortage)*-1)*0.0005 > 10      
order by branch_Cd,party_Code, sauda_date          
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote_opp
-- --------------------------------------------------
CREATE procedure margin_debitnote_opp ( @ssauda_date datetime,@esauda_date datetime, @spcode varchar(25), @epcode varchar(25))
as
--declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)
--set @ssauda_Date = 'May 1 2004'
--set @esauda_Date = 'May 1 2004'
--set @spcode = 'A001'
--set @epcode = 'Z999'


select sauda_Date,party_code = isnull(ms.party_code,'no data') , party_name = c1.long_name , 
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch , 
add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3, city=c1.l_city,state=c1.l_state, pin=c1.l_zip,
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,
 span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2))
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date 
and ms.party_code >= @spcode and ms.party_Code <= @epcode
--and c1.branch_Cd = @branch_Cd
--and c1.sub_broker = @sub_broker
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip
having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 
--used if opp values are to be displayed
--having sum(shortage)*100/sum(span_prem) <= -20 
order by ms.party_Code , ms.sauda_date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote_test
-- --------------------------------------------------
CREATE procedure margin_debitnote_test ( @ssauda_date datetime,@esauda_date datetime, @spcode varchar(25), @epcode varchar(25))          
as          
---drop table #aa      
  
set nocount on  
/*  
declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)          
set @ssauda_Date = 'Jan 21 2008'          
set @esauda_Date = 'Jan 25 2008'          
set @spcode = 'A10110'          
set @epcode = 'a10110'        
*/  
---'A2168'        
--'A2199'          
--set @epcode = @epcode + 'ZZZ'          
  
set transaction isolation level read uncommitted  
   
          
select sauda_Date,party_code = isnull(ms.party_code,'no data') ,   
 party_name = c1.long_name ,           
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch ,           
 add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3,   
 city=c1.l_city,state=c1.l_state, pin=c1.l_zip,          
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,          
 span_prem = convert(varchar,sum(span_prem))           
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,          
 shortage = convert(varchar,sum(shortage)) --,perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem)+1,2))          
 into #aa      
 from margin_short ms (nolock) left join          
 --angelfo.nsefo.dbo.client2 c2           
  angelfo.nsefo.dbo.activeclient1 c1  
 on ms.party_code = c1.cl_code          
-- left join angelfo.nsefo.dbo.client1 c1           
-- on c1.cl_code = c2.cl_code          
-- left join angelfo.nsefo.dbo.branch br          
-- on c1.branch_cd = br.branch_code          
-- left join angelfo.nsefo.dbo.subbrokers sb          
-- on c1.sub_broker = sb.sub_broker          
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date           
and ms.party_code >= @spcode and ms.party_Code <= @epcode          
--and c1.branch_Cd = @branch_Cd          
--and c1.sub_broker = @sub_broker          
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,          
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip          
--having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 used if opp values are to be displayed          
--having sum(shortage)*100/(sum(span_prem)+1) <= -20           
--having sum(shortage)<= -50000.00 and sum(shortage) <> 0      
--order by ms.party_Code , ms.sauda_date        
  
select * from #aa  where (convert(money,shortage)*-1)*0.0005 > 10    
order by party_Code , sauda_date        
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_branch
-- --------------------------------------------------
CREATE procedure margin_report_branch (@sauda_date as varchar(11))          
as          
---query to view shortage report branch wise        
--select cl_code,party_code into #client2 from angelfo.nsefo.dbo.client2    
--select cl_code,branch_cd into #client1 from angelfo.nsefo.dbo.client1    
--select * into #branch from angelfo.nsefo.dbo.branch      
        
--set @sauda_date= substring(@sauda_date,4,2)+'/'+left(@sauda_date,2)+right(@sauda_date,5)        
if @sauda_date = ''          
 set @sauda_date = convert(datetime , left(getdate(),11))          
select @sauda_date = convert(varchar(11),@sauda_date)          
select branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch ,           
Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , span_prem = convert(varchar,sum(span_prem))           
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,          
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2))           
 from margin_short ms left join          
 angelfo.nsefo.dbo.client2 c2           
 on ms.party_code = c2.party_code          
 left join angelfo.nsefo.dbo.client1  c1           
 on c1.cl_code = c2.cl_code          
 left join angelfo.nsefo.dbo.branch br          
 on c1.branch_cd = br.branch_code          
where sauda_date = @sauda_date          
group by c1.branch_cd , br.branch          
          
union          
          
select branch_Cd = 'zzzz', ' Total : ' , Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) ,           
span_prem = convert(varchar,sum(span_prem))           
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,          
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round((sum(shortage)*100/sum(span_prem)),2))           
 from margin_short           
where sauda_date = @sauda_date          
order by branch_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Margin_report_branch_new
-- --------------------------------------------------
CREATE PROCEDURE Margin_report_branch_new(   
                @sauda_date AS VARCHAR(11))   
AS   
  ---query to view shortage report branch wise   
  SET @sauda_date = Substring(@sauda_date,4,2) + '/' + Left(@sauda_date,2) + Right(@sauda_date,5)   
     
  IF @sauda_date = ''   
    SET @sauda_date = Convert(DATETIME,Left(Getdate(),11))   
     
  SELECT @sauda_date = Convert(VARCHAR(11),@sauda_date)   
     
  SELECT   branch_cd = Isnull(c1.branch_cd,'no data'),   
           branch_name = br.branch,   
           span = Convert(VARCHAR,Sum(span)),   
           premium = Convert(VARCHAR,Sum(premium)),   
           span_prem = Convert(VARCHAR,Sum(span_prem)),   
           mtm_value = Convert(VARCHAR,Sum(mtm_value)),   
           collected = Convert(VARCHAR,Sum(collected)),   
           shortage = Convert(VARCHAR,Sum(shortage)),   
           perc_shortage = Convert(VARCHAR,Round(Sum(shortage) * 100 / Sum(span_prem),2))   
  FROM     margin_short ms   
           LEFT JOIN angelfo.nsefo.dbo.client2 c2   
             ON ms.party_code = c2.party_code   
           LEFT JOIN angelfo.nsefo.dbo.client1 c1   
             ON c1.cl_code = c2.cl_code   
           LEFT JOIN angelfo.nsefo.dbo.branch br   
             ON c1.branch_cd = br.branch_code   
  WHERE    sauda_date = @sauda_date   
  GROUP BY c1.branch_cd,   
           br.branch   
  UNION   
  SELECT branch_cd = 'zzzz',   
         ' Total : ',   
         span = Convert(VARCHAR,Sum(span)),   
         premium = Convert(VARCHAR,Sum(premium)),   
         span_prem = Convert(VARCHAR,Sum(span_prem)),   
         mtm_value = Convert(VARCHAR,Sum(mtm_value)),   
         collected = Convert(VARCHAR,Sum(collected)),   
         shortage = Convert(VARCHAR,Sum(shortage)),   
         perc_shortage = Convert(VARCHAR,Round((Sum(shortage) * 100 / Sum(span_prem)),2))   
  FROM   margin_short   
  WHERE  sauda_date = @sauda_date   
  ORDER BY branch_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_party_code
-- --------------------------------------------------
CREATE procedure margin_report_party_code (@sauda_date as datetime , @branch_Cd as varchar(25) , @sub_broker as varchar(25))
as
---query to view shortage report branch wise
if @sauda_date = ''
	set @sauda_date = convert(datetime , left(getdate(),11))
select @sauda_date = convert(varchar(11),@sauda_date)
select party_code = isnull(ms.party_code,'no data') , party_name = c1.long_name , 
-- branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,
 span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2))
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
and c1.sub_broker = @sub_broker
group by ms.party_code , c1.long_name
--, c1.branch_cd , br.branch

union

select 'zzzz', ' Total : ' , 
 --branch_Cd = c1.branch_cd , ' ' , 
 Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round((sum(shortage)*100/sum(span_prem)),2))
 from margin_short ms
 left join angelfo.nsefo.dbo.client2 c2 
 on c2.party_code = ms.party_code
 join angelfo.nsefo.dbo.client1 c1
 on c1.cl_code = c2.cl_code
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
and c1.sub_broker = @sub_broker
--group by c1.branch_Cd
order by party_code , c1.long_name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_party_code_new
-- --------------------------------------------------

CREATE PROCEDURE Margin_report_party_code_new( 
                @sauda_date AS VARCHAR(11), 
                @branch_Cd  AS VARCHAR(25), 
                @sub_broker AS VARCHAR(25)) 
AS 
  ---query to view shortage report branch wise 
  SET @sauda_date = Substring(@sauda_date,4,2) + '/' + Left(@sauda_date,2) + Right(@sauda_date,5) 
   
  IF @sauda_date = '' 
    SET @sauda_date = Convert(DATETIME,Left(Getdate(),11)) 
   
  SELECT @sauda_date = Convert(VARCHAR(11),@sauda_date) 
   
  SELECT   party_code = Isnull(ms.party_code,'no data'), 
           party_name = c1.long_name, 
           -- branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
           span = Convert(VARCHAR,Sum(span)), 
           premium = Convert(VARCHAR,Sum(premium)), 
           span_prem = Convert(VARCHAR,Sum(span_prem)), 
           mtm_value = Convert(VARCHAR,Sum(mtm_value)), 
           collected = Convert(VARCHAR,Sum(collected)), 
           shortage = Convert(VARCHAR,Sum(shortage)) 
  --,           perc_shortage = Convert(VARCHAR,Round(Sum(shortage) * 100 / Sum(span_prem),2)) 
  INTO #tttt 
  FROM     margin_short ms 
           LEFT JOIN angelfo.nsefo.dbo.client2 c2 
             ON ms.party_code = c2.party_code 
           LEFT JOIN angelfo.nsefo.dbo.client1 c1 
             ON c1.cl_code = c2.cl_code 
           LEFT JOIN angelfo.nsefo.dbo.branch br 
             ON c1.branch_cd = br.branch_code 
           LEFT JOIN angelfo.nsefo.dbo.subbrokers sb 
             ON c1.sub_broker = sb.sub_broker 
  WHERE    sauda_date = @sauda_date 
           AND c1.branch_cd = @branch_Cd 
           AND c1.sub_broker = @sub_broker 
  GROUP BY ms.party_code, 
           c1.long_name 
   
  --, c1.branch_cd , br.branch      
  --UNION 
  SELECT --'zzzz',      
   --' Total : ',      
   --branch_Cd = c1.branch_cd , ' ' , 
   span = Convert(VARCHAR,Sum(span)), 
   premium = Convert(VARCHAR,Sum(premium)), 
   span_prem = Convert(VARCHAR,Sum(span_prem)), 
   mtm_value = Convert(VARCHAR,Sum(mtm_value)), 
   collected = Convert(VARCHAR,Sum(collected)), 
   shortage = Convert(VARCHAR,Sum(shortage)) 
  --,perc_shortage = Convert(VARCHAR,Round((Sum(shortage) * 100 / Sum(span_prem)),2)) 
  INTO #ttttt 
  FROM     margin_short ms 
           LEFT JOIN angelfo.nsefo.dbo.client2 c2 
             ON c2.party_code = ms.party_code 
           JOIN angelfo.nsefo.dbo.client1 c1 
             ON c1.cl_code = c2.cl_code 
  WHERE    sauda_date = @sauda_date 
           AND c1.branch_cd = @branch_Cd 
           AND c1.sub_broker = @sub_broker 
  GROUP BY c1.branch_cd 
   
  --ORDER BY party_code,      
  --       c1.long_name 
  SELECT party_code, 
         party_name, 
         span, 
         premium, 
         span_prem, 
         mtm_value, 
         collected, 
         shortage, 
         perc_shortage = CASE 
                           WHEN shortage = '0.00' 
                                AND span_prem = '0.00' 
                           THEN '0.00' 
                           ELSE Convert(DECIMAL(14,2),Convert(DECIMAL(14,2),shortage) * 100 / Convert(DECIMAL(14,2),span_prem)) 
                         END 
  FROM   #tttt 
  UNION 
  SELECT 'zzzz', 
         ' Total : ', 
         span, 
         premium, 
         span_prem, 
         mtm_value, 
         collected, 
         shortage, 
         perc_shortage = CASE 
                           WHEN shortage = '0.00' 
                                AND span_prem = '0.00' 
                           THEN '0.00' 
                           ELSE Convert(DECIMAL(14,2),Convert(DECIMAL(14,2),shortage) * 100 / Convert(DECIMAL(14,2),span_prem)) 
                         END 
  FROM   #ttttt 
   
  DROP TABLE #tttt 
   
  DROP TABLE #ttttt

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_sub_broker
-- --------------------------------------------------
CREATE procedure margin_report_sub_broker (@sauda_date as datetime , @branch_Cd as varchar(25))
as
---query to view shortage report branch wise
if @sauda_date = ''
	set @sauda_date = convert(datetime , left(getdate(),11))
select @sauda_date = convert(varchar(11),@sauda_date)
select sub_broker = isnull(c1.sub_broker,'no data') , sub_broker_name = sb.name , 
-- branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
 Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2)) 
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
group by c1.sub_broker , sb.name 
--, c1.branch_cd , br.branch

union

select 'zzzz', ' Total : ' , 
 --branch_Cd = c1.branch_cd , ' ' , 
 Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round((sum(shortage)*100/sum(span_prem)),2)) 
 from margin_short ms
 left join angelfo.nsefo.dbo.client2 c2 
 on c2.party_code = ms.party_code
 join angelfo.nsefo.dbo.client1 c1
 on c1.cl_code = c2.cl_code
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
group by c1.branch_Cd
order by sub_broker , name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_sub_broker_new
-- --------------------------------------------------
CREATE PROCEDURE Margin_report_sub_broker_new( 
                @sauda_date AS VARCHAR(11), 
                @branch_Cd  AS VARCHAR(25)) 
AS 
  ---query to view shortage report branch wise 
  SET @sauda_date = Substring(@sauda_date,4,2) + '/' + Left(@sauda_date,2) + Right(@sauda_date,5) 
   
  IF @sauda_date = '' 
    SET @sauda_date = Convert(DATETIME,Left(Getdate(),11)) 
   
  SELECT @sauda_date = Convert(VARCHAR(11),@sauda_date) 
   
  SELECT   sub_broker = Isnull(c1.sub_broker,'no data'), 
           sub_broker_name = sb.name, 
           -- branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
           span = Convert(VARCHAR,Sum(span)), 
           premium = Convert(VARCHAR,Sum(premium)), 
           span_prem = Convert(VARCHAR,Sum(span_prem)), 
           mtm_value = Convert(VARCHAR,Sum(mtm_value)), 
           collected = Convert(VARCHAR,Sum(collected)), 
           shortage = Convert(VARCHAR,Sum(shortage)) 
  -- ,perc_shortage = Convert(VARCHAR,Round(Sum(shortage) * 100 / Sum(span_prem),2)) 
  INTO #ttttt 
  FROM     margin_short ms 
           LEFT JOIN angelfo.nsefo.dbo.client2 c2 
             ON ms.party_code = c2.party_code 
           LEFT JOIN angelfo.nsefo.dbo.client1 c1 
             ON c1.cl_code = c2.cl_code 
           LEFT JOIN angelfo.nsefo.dbo.branch br 
             ON c1.branch_cd = br.branch_code 
           LEFT JOIN angelfo.nsefo.dbo.subbrokers sb 
             ON c1.sub_broker = sb.sub_broker 
  WHERE    sauda_date = @sauda_date 
           AND c1.branch_cd = @branch_Cd 
  GROUP BY c1.sub_broker, 
           sb.name 
   
  SELECT sub_broker, 
         sub_broker_name, 
         span, 
         premium, 
         span_prem, 
         mtm_value, 
         collected, 
         shortage, 
         perc_shortage = CASE 
                           WHEN shortage = '0.00' 
                                AND span_prem = '0.00' 
                           THEN '0.00' 
                           ELSE Convert(DECIMAL(14,2),Convert(DECIMAL(14,2),shortage) * 100 / Convert(DECIMAL(14,2),span_prem)) 
                         END 
  FROM   #ttttt 
  UNION 
  SELECT   'zzzz', 
           ' Total : ', 
           --branch_Cd = c1.branch_cd , ' ' , 
           span = Convert(VARCHAR,Sum(span)), 
           premium = Convert(VARCHAR,Sum(premium)), 
           span_prem = Convert(VARCHAR,Sum(span_prem)), 
           mtm_value = Convert(VARCHAR,Sum(mtm_value)), 
           collected = Convert(VARCHAR,Sum(collected)), 
           shortage = Convert(VARCHAR,Sum(shortage)), 
           perc_shortage = Convert(VARCHAR,Round((Sum(shortage) * 100 / Sum(span_prem)),2)) 
  FROM     margin_short ms 
           LEFT JOIN angelfo.nsefo.dbo.client2 c2 
             ON c2.party_code = ms.party_code 
           JOIN angelfo.nsefo.dbo.client1 c1 
             ON c1.cl_code = c2.cl_code 
  WHERE    sauda_date = @sauda_date 
           AND c1.branch_cd = @branch_Cd 
  GROUP BY c1.branch_cd 
  ORDER BY sub_broker 
   
  DROP TABLE #ttttt

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MCX_MARGIN_DEBITNOTE_JV
-- --------------------------------------------------
   CREATE PROCEDURE [dbo].[MCX_MARGIN_DEBITNOTE_JV] -- '14/07/2011' ,'14/07/2011' ,'A' ,'Z'        
   (        
   @SSAUDA_DATE varchar(11),        
   @ESAUDA_DATE varchar(11),        
   @SPCODE VARCHAR(25),        
   @EPCODE VARCHAR(25)        
   )        
   AS        
   SET NOCOUNT ON        
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
   /*        
   DECLARE @SSAUDA_DATE VARCHAR(11),@ESAUDA_DATE VARCHAR(11), @SPCODE VARCHAR(25), @EPCODE VARCHAR(25)        
   SET @SSAUDA_DATE = ' 14/06/2011'        
   SET @ESAUDA_DATE = '14/06/2011'        
   SET @SPCODE = 'A'        
   SET @EPCODE = 'Z'        
   */        
        
        
        
        
        
   SELECT SAUDA_DATE,PARTY_CODE = ISNULL(MS.PARTY_CODE,'NO DATA') ,        
   PARTY_NAME = C1.LONG_NAME ,        
   BRANCH_CD = ISNULL(C1.BRANCH_CD,'NO DATA') ,-- BRANCH_NAME = BR.BRANCH ,        
   ADD1=C1.L_ADDRESS1,ADD2=C1.L_ADDRESS2,ADD3=C1.L_ADDRESS3,        
   CITY=C1.L_CITY,STATE=C1.L_STATE, PIN=C1.L_ZIP,        
   SPAN = CONVERT(VARCHAR,SUM(SPAN_margin)) , Exp_margin =CONVERT(VARCHAR,SUM(exp_margin)) ,        
   MTM_VALUE = CONVERT(VARCHAR,SUM(reserved1)) , COLLECTED = CONVERT(VARCHAR,SUM(reserved2)) ,        
   FMS = CONVERT(VARCHAR,SUM(fsm)), Total_Margin = CONVERT(VARCHAR,SUM(Total_Margin)) ,        
   Collection = CONVERT(VARCHAR,SUM(Collection)), shortage = CONVERT(VARCHAR,SUM(shortage))        
   INTO #AA        
   FROM MCx_Sortage MS (NOLOCK) LEFT JOIN        
   INTRANET.RISK.DBO.CLIENT_DETAILS C1        
   ON MS.PARTY_CODE = C1.PARTY_CODE        
   WHERE SAUDA_DATE >= convert(datetime,@SSAUDA_DATE,103) AND SAUDA_DATE <= convert(datetime,@ESAUDA_DATE,103)        
   AND MS.PARTY_CODE >= @SPCODE AND MS.PARTY_CODE <= @EPCODE        
   GROUP BY MS.SAUDA_DATE,MS.PARTY_CODE , C1.LONG_NAME, C1.L_ADDRESS1, C1.BRANCH_CD,        
   C1.L_ADDRESS2,C1.L_ADDRESS3,C1.L_CITY,C1.L_STATE,C1.L_ZIP        
        
   DECLARE @PERCEN MONEY        
   SELECT @PERCEN=SUM(CONVERT(MONEY,SHORTAGE)*-1)*100/SUM(CONVERT(MONEY,Total_Margin)) FROM #AA        
   --SELECT @PERCEN        
        
   SELECT SAUDA_DATE,PARTY_CODE,SHORTAGE=CONVERT(MONEY,SHORTAGE)*-1,        
   PENALTY=CASE WHEN @PERCEN>=10 AND @PERCEN<20 THEN        
   CONVERT(DECIMAL(18,2),(CONVERT(MONEY,SHORTAGE)*-1)*0.0005)        
   WHEN @PERCEN>=20 THEN        
   CONVERT(DECIMAL(18,2),(CONVERT(MONEY,SHORTAGE)*-1)*0.0010)        
   ELSE 0        
   END        
   INTO #BB        
   FROM #AA        
   ORDER BY PARTY_CODE , SAUDA_DATE        
        
   IF(@PERCEN<10)        
   BEGIN        
   TRUNCATE TABLE #BB        
   end        
        
        
   DECLARE @SERVICE_TAX NUMERIC(18,2)        
   DECLARE @CESS_TAX NUMERIC(18,2)        
   DECLARE @SHE_TAX NUMERIC(18,2)        
   SELECT @SERVICE_TAX=SERVICE_TAX,@CESS_TAX=CESS_TAX,@SHE_TAX=SHE_TAX        
   FROM INTRANET.RISK.DBO.PP_SERVICETAX_MASTER WHERE FLD_STATUS='A'        
        
        
   SELECT PARTY_CODE,CLTCODE=PARTY_CODE,DRCR='D',        
   AMOUNT=PENALTY+        
   CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100))+        
   CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100))+        
   CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100)),        
   NARRATION=CONVERT(VARCHAR(250),'BEING MARGIN SHORTAGE PENALTY DTD'+CONVERT(VARCHAR(11),SAUDA_DATE,103))INTO #CC        
   FROM #BB        
   where (PENALTY+CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100))+        
   CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100))+        
   CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100)))>0        
   UNION        
   SELECT PARTY_CODE,CLTCODE='51000001',DRCR='C',        
   AMOUNT=CONVERT(DECIMAL(18,2),PENALTY),        
   NARRATION='BEING MARGIN SHORTAGE PENALTY DTD '+ CONVERT(VARCHAR(11),SAUDA_DATE,103) FROM #BB        
   where (CONVERT(DECIMAL(18,2),PENALTY)) >0        
   UNION        
   SELECT PARTY_CODE,CLTCODE='99961',DRCR='C',        
   AMOUNT=CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100)),        
   NARRATION='SERVICE TAX @10% ON MARGIN SHORTAGE PENALTY' FROM #BB        
   where (CONVERT(DECIMAL(18,2),(PENALTY*@SERVICE_TAX/100))) >0        
   UNION        
   SELECT PARTY_CODE,CLTCODE='99962',DRCR='C',        
   AMOUNT=CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100)),        
   NARRATION='CESS TAX @ 0.20%ON MARGIN SHORTAGE PENALTY ' FROM #BB        
   where (CONVERT(DECIMAL(18,2),(PENALTY*@CESS_TAX/100))) >0        
   UNION        
   SELECT PARTY_CODE,CLTCODE='99963',DRCR='C',        
   AMOUNT=CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100)),        
   NARRATION='EDU CESS @ 0.10% ON MARGIN SHORTAGE PENALTY ' FROM #BB        
   where (CONVERT(DECIMAL(18,2),(PENALTY*@SHE_TAX/100))) >0        
   ORDER BY PARTY_CODE,DRCR DESC        
        
        
        
        
        
        
   SELECT DISTINCT PARTY_CODE,SRNO=ROW_NUMBER() OVER(ORDER BY PARTY_CODE)INTO #PARTY        
   FROM #CC GROUP BY PARTY_CODE        
        
   delete from MCXMarginShortage_JV        
        
   INSERT INTO MCXMarginShortage_JV       
   SELECT SRNO=B.SRNO,VDATE=CONVERT(VARCHAR(11),GETDATE(),103),EDATE=CONVERT(VARCHAR(11),GETDATE(),103),        
   CLTCODE,DRCR,AMOUNT,NARRATION,BRANCHCODE='ALL'        
   FROM #CC A        
   INNER JOIN #PARTY B        
   ON A.PARTY_CODE=B.PARTY_CODE        
   ORDER BY B.SRNO        
        
   DECLARE @S AS VARCHAR(5000),@S1 AS VARCHAR(5000)        
   SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL '+ '''' +'BCP "SELECT * FROM PS03.DBO.MCXMarginShortage_JV ORDER BY SRNO" QUERYOUT '+'\\INHOUSELIVEAPP2-FS.angelone.in\D$\UPLOAD1\UPDATION\MCX_mARGIN_PENALTY.XLS -c -SMIS -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'        
   SET @S1= @S+''''        
   EXEC(@S1)        
   drop table #party        
   SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mismatch_notin_bo
-- --------------------------------------------------
CREATE procedure mismatch_notin_bo @pos_date varchar(11)
as
--query to list data in nse but not in boffice
select @pos_date = convert(varchar(11),convert(datetime,@pos_date),100)
select status= 'Not in BOffice',
Client_Account_Code, 
Symbol, Instrument_Type, 
Expiry_date, 
Strike_price=convert(float,Strike_Price), 
Option_type=(case when Option_Type='' then 'FF' else Option_Type end),
NET_Qty =(case when Post_Ex_Asgmnt_Long_Quantity = 0 then -1*Post_Ex_Asgmnt_Short_Quantity else Post_Ex_Asgmnt_Long_Quantity end),
Position_Date 
from nseps03 
where  (Post_Ex_Asgmnt_Long_Quantity>0 or Post_Ex_Asgmnt_Short_Quantity>0) 
and convert(datetime,position_date) = @pos_date
and not exists
(
select 
Party_Code, Symbol, Inst_type, Exp_date, 
Strike_price = convert(float,Strike_price),Option_type, NETQty,Position_Date
from bofficeps03 
where convert(datetime,position_date) = @pos_date
and party_code= nseps03.Client_Account_Code
and bofficeps03.Symbol = nseps03.Symbol
and inst_type = nseps03.Instrument_Type
and convert(datetime,exp_date,103)= convert(datetime,nseps03.expiry_date)
and convert(float,bofficeps03.strike_price)= convert(float,nseps03.strike_price)
and bofficeps03.Option_type= (case when nseps03.Option_type='FF' then '' else nseps03.Option_type end)
and bofficeps03.netqty= (case when nseps03.Post_Ex_Asgmnt_Long_Quantity = 0 then -1*nseps03.Post_Ex_Asgmnt_Short_Quantity else nseps03.Post_Ex_Asgmnt_Long_Quantity end)
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mismatch_notin_bo1
-- --------------------------------------------------
CREATE procedure mismatch_notin_bo1(@pos_date as varchar(11)  )
as  
set transaction isolation level read uncommitted
set nocount on
--query to list data in nse but not in boffice  
/*declare @pos_date as varchar(11)
set @pos_date='03/29/2006'*/
select @pos_date = convert(varchar(11),convert(datetime,@pos_date),100)  

select status= 'Not in BOffice',  
Client_Account_Code,   
Symbol, Instrument_Type,   
Expiry_date,   
Strike_price=convert(float,Strike_Price),   
Option_type=(case when Option_Type='' then 'FF' else Option_Type end),  
NET_Qty =(case when Post_Ex_Asgmnt_Long_Quantity = 0 then -1*Post_Ex_Asgmnt_Short_Quantity else Post_Ex_Asgmnt_Long_Quantity end),  
Position_Date, Post_Ex_Asgmnt_Short_Quantity ,Post_Ex_Asgmnt_Long_Quantity
into #temp1_ps03 
from nseps03   
where  (Post_Ex_Asgmnt_Long_Quantity>0 or Post_Ex_Asgmnt_Short_Quantity>0)   
and convert(datetime,position_date) = @pos_date  

--select * into #file1 from bofficeps03 where convert(datetime,position_date) = '03/29/2006'

--drop table #temp1_ps03
insert into temp_ps03
select 
status,Client_Account_Code, Symbol, Instrument_Type,Expiry_date,   
Strike_price,Option_type,NET_Qty ,Position_Date
 from #temp1_ps03 nseps03
where not exists 
(  
select   
Party_Code, Symbol, Inst_type, Exp_date,   
Strike_price = convert(float,Strike_price),Option_type, NETQty,Position_Date  
from bofficeps03   
where convert(datetime,position_date) = @pos_date
--@pos_date  
and party_code= nseps03.Client_Account_Code  
and bofficeps03.Symbol = nseps03.Symbol  
and inst_type = nseps03.Instrument_Type  
and convert(datetime,exp_date,103)= convert(datetime,nseps03.expiry_date)  
and convert(float,bofficeps03.strike_price)= convert(float,nseps03.strike_price)  
and bofficeps03.Option_type= (case when nseps03.Option_type='FF' then '' else nseps03.Option_type end)  
and bofficeps03.netqty= (case when nseps03.Post_Ex_Asgmnt_Long_Quantity = 0 then -1*nseps03.Post_Ex_Asgmnt_Short_Quantity else nseps03.Post_Ex_Asgmnt_Long_Quantity end)  
)  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mismatch_notin_nse
-- --------------------------------------------------
CREATE procedure mismatch_notin_nse @pos_date varchar(11)
as
--query to list data in boffice but not in nse
select @pos_date = convert(varchar(11),convert(datetime,@pos_date),100)
select status='Not in NSE',
Party_Code, Symbol, Inst_type, Exp_date, 
Strike_price = convert(float,Strike_price),
Option_type=(case when Option_Type='' then 'FF' else Option_Type end), 
NETQty,Position_Date
from bofficeps03 where convert(datetime,position_date) = @pos_date
and not exists
(
select 
Client_Account_Code, 
Symbol, Instrument_Type, 
Expiry_date, 
Strike_price=convert(float,Strike_Price), 
option_type,
NET_Qty =(case when Post_Ex_Asgmnt_Long_Quantity = 0 then -1*Post_Ex_Asgmnt_Short_Quantity else Post_Ex_Asgmnt_Long_Quantity end),
Position_Date 
from nseps03 
where  (Post_Ex_Asgmnt_Long_Quantity>0 or Post_Ex_Asgmnt_Short_Quantity>0) 
and convert(datetime,position_date) = @pos_date
--and bo.inst_type = Instrument_Type
--and bo.Symbol = nseps03.Symbol
--and bo.party_code= nseps03.Client_Account_Code
and party_code= nseps03.Client_Account_Code
and bofficeps03.Symbol = nseps03.Symbol
and inst_type = nseps03.Instrument_Type
and convert(datetime,exp_date,103)= convert(datetime,nseps03.expiry_date)
and convert(float,bofficeps03.strike_price)= convert(float,nseps03.strike_price)
and bofficeps03.Option_type= (case when nseps03.Option_type='FF' then '' else nseps03.Option_type end)
and bofficeps03.netqty= (case when nseps03.Post_Ex_Asgmnt_Long_Quantity = 0 then -1*nseps03.Post_Ex_Asgmnt_Short_Quantity else nseps03.Post_Ex_Asgmnt_Long_Quantity end)
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MISMATCHDATA
-- --------------------------------------------------
--select position_date,count(P_Code)
--from temp_ps03
--group by position_date
--having COUNT(position_date)>1
--order by convert(datetime,position_date)desc



CREATE PROCEDURE MISMATCHDATA(
@SEGMENT VARCHAR(50),
@DATE VARCHAR(50)
)
AS
BEGIN
IF(@SEGMENT='NSEFO')
	BEGIN
	INSERT INTO TEMPMISMATCHDATA
		select * 
		from  temp_ps03 (nolock) 
		where  Status= 'NOT IN BO' and position_date=convert(datetime,'20/09/2013',103) 
		order by Symbol,Inst_Type,Exp_date,Str_Pr,Opt_Type,p_code
	END






END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.nsefo_mismatch
-- --------------------------------------------------
create procedure nsefo_mismatch  
(@USER AS VARCHAR(11),@CODE AS VARCHAR(11))          
as          
set nocount on          
        
select         
distinct trd.party_code,c1.branch_cd,c1.sub_broker, trd.termid,term.branch_cd         
AS 'Branch',term.sub_broker as 'SubBroker',term.branch_cd_alt as 'AltBranch',term.sub_broker_alt as 'AltSubBroker'         
into #MisMatch          
-- select distinct trd.party_code,c1.branch_cd,c1.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt         
from fotrd trd , ps03.dbo.fo_termid_list term , angelfo.nsefo.dbo.client2 c2 , angelfo.nsefo.dbo.client1 c1         
where trd.party_code=c2.party_code and trd.party_code         
not in         
(select distinct party_code from pcode_exception (nolock))         
and c2.cl_code=c1.cl_code and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL'         
and not         
( (c1.branch_cd = term.branch_cd and term.sub_broker='') or (c1.branch_cd = term.branch_cd and c1.sub_broker = term.sub_broker and term.sub_broker<>'') or (c1.branch_cd = term.branch_cd_alt and term.sub_broker_alt = '') or 
(c1.branch_cd = term.branch_cd_alt and c1.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )         
order by trd.termid,trd.party_code        
        
        
Select * into #final from #MisMatch           
where Branch_Cd+Sub_Broker not in             
(Select LTrim(RTrim(alt_BranchSB))+LTrim(RTrim(alt_BranchSBCode)) from AlternateBranchSB (nolock) where alt_termid = termid and alt_Exchange = 'NSE FO')        
and Branch_cd not in           
(Select LTrim(RTrim(alt_BranchSB)) from AlternateBranchSB (nolock) where alt_BranchSBCode = '' and alt_termid = termid and alt_Exchange = 'NSE FO')          
        
--Select * from #final  
  
    
IF @USER='BROKER'    
BEGIN    
select * from #final    
END    
    
IF @USER='BRANCH'    
BEGIN    
select * from #final where branch=@code    
END    
 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.nsefo_mismatch_deepak
-- --------------------------------------------------
CREATE procedure nsefo_mismatch_deepak      
--(@USER AS VARCHAR(11),@CODE AS VARCHAR(11))              
as              
set nocount on              
select cl_code,branch_cd,sub_broker into #C1 from angelfo.nsefo.dbo.client1 c1  
select cl_code,party_code into #C2 from angelfo.nsefo.dbo.client2 c2  
            
select             
distinct trd.party_code,c1.branch_cd,c1.sub_broker, trd.termid,term.branch_cd             
AS 'Branch',term.sub_broker as 'SubBroker',term.branch_cd_alt as 'AltBranch',term.sub_broker_alt as 'AltSubBroker'             
into #MisMatch              
from fotrd trd , ps03.dbo.fo_termid_list term ,   
#C2 c2 ,   
#C1 c1             
where trd.party_code=c2.party_code and trd.party_code             
not in             
(select distinct party_code from pcode_exception (nolock))             
and c2.cl_code=c1.cl_code and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL'             
and not             
( (c1.branch_cd = term.branch_cd and term.sub_broker='') or (c1.branch_cd = term.branch_cd and c1.sub_broker = term.sub_broker and term.sub_broker<>'') or (c1.branch_cd = term.branch_cd_alt and term.sub_broker_alt = '') or     
(c1.branch_cd = term.branch_cd_alt and c1.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )             
order by trd.termid,trd.party_code            
            
            
Select * into #final from #MisMatch               
where Branch_Cd+Sub_Broker not in                 
(Select LTrim(RTrim(alt_BranchSB))+LTrim(RTrim(alt_BranchSBCode)) from AlternateBranchSB (nolock) where alt_termid = termid and alt_Exchange = 'NSE FO')            
and Branch_cd not in               
(Select LTrim(RTrim(alt_BranchSB)) from AlternateBranchSB (nolock) where alt_BranchSBCode = '' and alt_termid = termid and alt_Exchange = 'NSE FO')              
            
Select * from #final      
      
        
/*IF @USER='BROKER'        
BEGIN        
select * from #final        
END        
        
IF @USER='BRANCH'        
BEGIN        
select * from #final where branch=@code        
END        
 */    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.nsefo_mismatch_deepak_old
-- --------------------------------------------------
CREATE procedure nsefo_mismatch_deepak_old    
--(@USER AS VARCHAR(11),@CODE AS VARCHAR(11))            
as            
set nocount on            
          
select           
distinct trd.party_code,c1.branch_cd,c1.sub_broker, trd.termid,term.branch_cd           
AS 'Branch',term.sub_broker as 'SubBroker',term.branch_cd_alt as 'AltBranch',term.sub_broker_alt as 'AltSubBroker'           
into #MisMatch            
-- select distinct trd.party_code,c1.branch_cd,c1.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt           
from fotrd trd , ps03.dbo.fo_termid_list term , angelfo.nsefo.dbo.client2 c2 , angelfo.nsefo.dbo.client1 c1           
where trd.party_code=c2.party_code and trd.party_code           
not in           
(select distinct party_code from pcode_exception (nolock))           
and c2.cl_code=c1.cl_code and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL'           
and not           
( (c1.branch_cd = term.branch_cd and term.sub_broker='') or (c1.branch_cd = term.branch_cd and c1.sub_broker = term.sub_broker and term.sub_broker<>'') or (c1.branch_cd = term.branch_cd_alt and term.sub_broker_alt = '') or   
(c1.branch_cd = term.branch_cd_alt and c1.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )           
order by trd.termid,trd.party_code          
          
          
Select * into #final from #MisMatch             
where Branch_Cd+Sub_Broker not in               
(Select LTrim(RTrim(alt_BranchSB))+LTrim(RTrim(alt_BranchSBCode)) from AlternateBranchSB (nolock) where alt_termid = termid and alt_Exchange = 'NSE FO')          
and Branch_cd not in             
(Select LTrim(RTrim(alt_BranchSB)) from AlternateBranchSB (nolock) where alt_BranchSBCode = '' and alt_termid = termid and alt_Exchange = 'NSE FO')            
          
Select * from #final    
    
      
/*IF @USER='BROKER'      
BEGIN      
select * from #final      
END      
      
IF @USER='BRANCH'      
BEGIN      
select * from #final where branch=@code      
END      
 */  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.POSITIONFILE_SEGMENTWISE_MISMATCHDATA
-- --------------------------------------------------
CREATE PROCEDURE POSITIONFILE_SEGMENTWISE_MISMATCHDATA --'MCX COMMODITY','07/11/2013','BROKER','CSO'
(            
 @SEGMENT VARCHAR(50),            
 @DATE VARCHAR(50),            
 @ACCESS_TO VARCHAR(50),            
 @ACCESS_CODE VARCHAR(50)            
)            
AS            
BEGIN            
TRUNCATE TABLE TEMP_MISMATCH_DATA            
DECLARE @COUNT INT            
IF(@SEGMENT='NSEFO')            
BEGIN            
            
 SELECT @COUNT=COUNT(1)             
  FROM  TEMP_PS03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO' AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)             
              
             
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN BACK OFFICE = '+ CONVERT(VARCHAR,@COUNT),'',' ',' ',' ',' ',' ',' ',' ')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT *             
  FROM  TEMP_PS03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO' AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)             
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
              
 SELECT @COUNT=COUNT(1)            
  FROM  TEMP_PS03             
  WHERE  STATUS= 'NOT IN NSE'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
              
             
             
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN NSE FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT DISTINCT *             
  FROM  TEMP_PS03             
  WHERE  STATUS= 'NOT IN NSE'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)             
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
              
END            
ELSE IF(@SEGMENT='NSE CURRENCY')            
BEGIN            
            
  SELECT @COUNT=COUNT(1)            
  FROM  TBL_temp_NSECURR_ps03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)           
            
INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT *             
  FROM  TBL_temp_NSECURR_ps03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)             
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
              
             
  SELECT @COUNT=COUNT(1)             
  FROM  TBL_temp_NSECURR_ps03             
  WHERE  STATUS= 'NOT IN NSE-CURR'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
             
             
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN NSE CURRENCY FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT DISTINCT *             
  FROM  TBL_temp_NSECURR_ps03             
  WHERE  STATUS= 'NOT IN NSE-CURR'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)             
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
END            
ELSE IF(@SEGMENT='NCDEX')            
BEGIN            
            
  SELECT @COUNT=COUNT(1)            
  FROM  TBL_temp_NCDEX_ps03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)           
            
INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT *             
  FROM  TBL_temp_NCDEX_ps03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110) =CONVERT(DATETIME,@date,103)            
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
              
              
  SELECT @COUNT=COUNT(1)             
  FROM  TBL_temp_NCDEX_ps03            
  WHERE  STATUS= 'NOT IN NCDEX'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)          
              
              
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN NCDEX FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT DISTINCT *             
  FROM  TBL_temp_NCDEX_ps03            
  WHERE  STATUS= 'NOT IN NCDEX'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
END            
ELSE IF(@SEGMENT='MCX CURRENCY')            
BEGIN            
            
  SELECT @COUNT=COUNT(1)             
  FROM  TBL_TEMP_MCXSX_PS03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)           
             
            
INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT *             
  FROM  TBL_TEMP_MCXSX_PS03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)             
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
              
              
  SELECT @COUNT=COUNT(1)             
  FROM  TBL_TEMP_MCXSX_PS03             
  WHERE  STATUS LIKE 'NOT IN MCXSX'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
              
              
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN MCX CURRENCY FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT DISTINCT *             
  FROM  TBL_TEMP_MCXSX_PS03             
  WHERE  STATUS LIKE 'NOT IN MCXSX'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)           
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
END            
ELSE IF(@SEGMENT='MCX COMMODITY')            
BEGIN            
            
  SELECT @COUNT=COUNT(1)             
  FROM  TBL_temp_MCX_ps03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
             
            
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT *             
  FROM  TBL_temp_MCX_ps03 (NOLOCK)             
  WHERE  STATUS= 'NOT IN BO'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
              
  SELECT @COUNT=COUNT(1)            
  FROM  TBL_temp_MCX_ps03             
  WHERE  STATUS= 'NOT IN MCX'             
  AND  CONVERT(DATETIME,position_date,110)=CONVERT(DATETIME,@date,103)            
              
              
              
 INSERT INTO TEMP_MISMATCH_DATA            
 VALUES('MISSING RECORDS IN MCX COMMODITY FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')            
             
 INSERT INTO TEMP_MISMATCH_DATA            
  SELECT DISTINCT *             
  FROM  TBL_temp_MCX_ps03             
  WHERE  STATUS= 'NOT IN MCX'             
  AND  CONVERT(DATETIME,position_date,110) =CONVERT(DATETIME,@date,103)           
  ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE            
END            
            
SELECT ROW_NUMBER() OVER(ORDER BY(SELECT 0)) AS 'SRNO',* FROM TEMP_MISMATCH_DATA     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.POSITIONFILE_SEGMENTWISE_MISMATCHDATA_JOB
-- --------------------------------------------------
CREATE PROCEDURE POSITIONFILE_SEGMENTWISE_MISMATCHDATA_JOB
AS
BEGIN
TRUNCATE TABLE TEMP_MISMATCH_DATA  
DECLARE @COUNT INT 
DECLARE @SEGMENT AS VARCHAR(50)
SET @COUNT = 5
WHILE @COUNT>0
	BEGIN
	SELECT @SEGMENT=SEGMENT FROM POSITIONFILE_SEGMENT WHERE SRNO=@COUNT

	IF(@SEGMENT='NSEFO')  
		BEGIN  
  
		SELECT @COUNT=COUNT(1)   
		FROM  TEMP_PS03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO' AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
    
   
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN BACK OFFICE = '+ CONVERT(VARCHAR,@COUNT),'',' ',' ',' ',' ',' ',' ',' ')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT *   
		FROM  TEMP_PS03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO' AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
    
		SELECT @COUNT=COUNT(1)  
		FROM  TEMP_PS03   
		WHERE  STATUS= 'NOT IN NSE'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
    
   
   
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN NSE FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT DISTINCT *   
		FROM  TEMP_PS03   
		WHERE  STATUS= 'NOT IN NSE'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
    
	END  
	ELSE IF(@SEGMENT='NSE CURRENCY')  
		BEGIN  
  
		SELECT @COUNT=COUNT(1)  
		FROM  TBL_temp_NSECURR_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
	  
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT *   
		FROM  TBL_temp_NSECURR_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
    
   
		SELECT @COUNT=COUNT(1)   
		FROM  TBL_temp_NSECURR_ps03   
		WHERE  STATUS= 'NOT IN NSE-CURR'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
   
   
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN NSE CURRENCY FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')  
		   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT DISTINCT *   
		FROM  TBL_temp_NSECURR_ps03   
		WHERE  STATUS= 'NOT IN NSE-CURR'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
		END  
	ELSE IF(@SEGMENT='NCDEX')  
	BEGIN  
  
		SELECT @COUNT=COUNT(1)  
		FROM  TBL_temp_NCDEX_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
  
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT *   
		FROM  TBL_temp_NCDEX_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
    
    
		SELECT @COUNT=COUNT(1)   
		FROM  TBL_temp_NCDEX_ps03  
		WHERE  STATUS= 'NOT IN NCDEX'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
    
    
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN NCDEX FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT DISTINCT *   
		FROM  TBL_temp_NCDEX_ps03  
		WHERE  STATUS= 'NOT IN NCDEX'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
	END  
	ELSE IF(@SEGMENT='MCX CURRENCY')  
	BEGIN  
  
		SELECT @COUNT=COUNT(1)   
		FROM  TBL_temp_MCX_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
   
  
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT *   
		FROM  TBL_temp_MCX_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)  
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
    
    
		SELECT @COUNT=COUNT(1)   
		FROM  TBL_temp_MCX_ps03   
		WHERE  STATUS LIKE 'NOT IN MCX'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
    
    
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN MCX CURRENCY FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT DISTINCT *   
		FROM  TBL_temp_MCX_ps03   
		WHERE  STATUS LIKE 'NOT IN MCX'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)   
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
	END  
	ELSE IF(@SEGMENT='MCX COMMODITY')  
	BEGIN  
  
		SELECT @COUNT=COUNT(1)   
		FROM  TBL_temp_MCXSX_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)  
   
  
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN BACK OFFICE = '+CONVERT(VARCHAR,@COUNT),' ',' ',' ',' ',' ',' ',' ',' ')	
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT *   
		FROM  TBL_temp_MCXSX_ps03 (NOLOCK)   
		WHERE  STATUS= 'NOT IN BO'   
		AND POSITION_DATE=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)  
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE  
    
		SELECT @COUNT=COUNT(1)  
		FROM  TBL_temp_MCXSX_ps03   
		WHERE  STATUS= 'NOT IN MCXSX'		
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103)  
    
    
    
		INSERT INTO TEMP_MISMATCH_DATA  
		VALUES('MISSING RECORDS IN MCX COMMODITY FILE = '+CONVERT(VARCHAR,@COUNT),'','','','','','','','')  
   
		INSERT INTO TEMP_MISMATCH_DATA  
		SELECT DISTINCT *   
		FROM  TBL_temp_MCXSX_ps03   
		WHERE  STATUS= 'NOT IN MCXSX'   
		AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),110),103) 
		ORDER BY SYMBOL,INST_TYPE,EXP_DATE,STR_PR,OPT_TYPE,P_CODE		
		END  
	END 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.POSITIONFILE_UPLOADED_DATA_RPT
-- --------------------------------------------------
CREATE procedure POSITIONFILE_UPLOADED_DATA_RPT(@access_to varchar(20), @access_code varchar(20))
as
begin
select ROW_NUMBER() over (order by (select 0)) as 'SRNO',SEGMENT,MISMATCH,UPLOAD_DATETIME as 'UPLOAD TIME',UPLOADED_BY as 'EMPLOYEE DETAILS' 
from(
select SEGMENT,MISMATCH,UPLOAD_DATETIME,UPLOADED_BY 
from POSITIONFILE_UPLOADED_DATA
GROUP BY SEGMENT,MISMATCH,UPLOAD_DATETIME,UPLOADED_BY 
) a
order by CONVERT(datetime,UPLOAD_DATETIME) desc
end

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
-- PROCEDURE dbo.ret_cl_rate
-- --------------------------------------------------
CREATE proc ret_cl_rate 
@symbol varchar(15),
@inst_type varchar(10),
@expirydate varchar(15),
@option_type varchar(5),
@strike_price varchar(10),
@trade_date varchar(15)
as
if Len(@trade_date) = 10
Begin
	set @trade_date = STUFF(@trade_date, 4, 1,'  ')
End 
select cl_rate,inst_type,expirydate,symbol,option_type ,strike_price 
from angelfo.nsefo.dbo.foclosing 
where symbol = @symbol
and inst_type = @inst_type
and expirydate = convert(datetime,@expirydate) +' 23:59:00.000' 
and (case when option_type='' then 'XX' else option_type end) = @option_type 
and strike_price = convert(money,@strike_price) 
and convert(varchar(11),trade_date) like @trade_date+'%' 
--exec ret_cl_rate 'SATYAMCOMP', 'FUTSTK', '24 DEC 2003', 'XX', '0.00', 'Dec 5 2003'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_margin_report_branch_new
-- --------------------------------------------------
create proc sp_margin_report_branch_new
as
exec angelfo.inhouse.dbo.margin_report_branch_new '11/12/2009'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CurrencyUpload
-- --------------------------------------------------
CREATE proc usp_CurrencyUpload          
(          
 @server varchar(300),          
 @filename varchar(100)    
)          
          
as          
 begin         
 set nocount  on          
 declare @filepath as varchar(200),@sql as varchar(max)           
 --declare @server varchar(20),@filename varchar(100)           
 --set @server='172.29.19.10'        
 --set @filename='focurr.CSV'         
 set @filepath='\\'+@server+'\d$\upload\'+ @filename           
 truncate table currencyFoTemp                                    
 set @sql=''                                    
 set @sql=@sql+' bulk insert currencyFoTemp from '                                    
 set @sql=@sql+''''+ @filepath +''''                                    
 set @sql=@sql+' with '                                    
 set @sql=@sql+' ( '                
 set @sql=@sql+' fieldterminator = '','','            
 set @sql=@sql+' FIRSTROW  = 1,'                                  
 set @sql=@sql+' rowterminator = ''\n'''                                    
 set @sql=@sql+' ) '                             
   --print(@sql)                                  
 exec(@sql)          
            
 --delete from CurrencyFo where FName=@filename          
 --insert into CurrencyFo Select *,@filename,getdate() from currencyFoTemp         
 select [count]=count(*) from currencyFoTemp        
 set nocount off        
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_fo_error_report_insert
-- --------------------------------------------------

create proc USP_fo_error_report_insert    
(    
@termid as varchar(25),    
@remark as varchar(500),    
@saudate as varchar(25)    
)    
as     
    
insert into fo_error_report (termid,remark,sauda_date)    
values(@termid,@remark,convert(datetime,@saudate,103))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_fo_error_report_insert1
-- --------------------------------------------------
    
create proc USP_fo_error_report_insert1        
(        
@partycode as varchar(25),  
@branch as varchar(25),  
@subbroker as varchar(25),  
@termid as varchar(25),        
@termid_branch as varchar(25),  
@termid_sub_broker as varchar(25),  
@termid_branch_alt as varchar(25),  
@termid_sub_broker_alt as varchar(25),       
@saudate as varchar(25)        
)        
as         
        
insert into fo_error_report (party_code,pcode_branch_cd,pcode_sub_broker,termid,termid_branch_cd,termid_sub_broker,termid_branch_cd_alt,termid_sub_broker_alt,sauda_date)        
values(@partycode,@branch,@subbroker,@termid,@termid_branch,@termid_sub_broker,@termid_branch_alt,@termid_sub_broker_alt,convert(datetime,@saudate,103))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_fo_error_report_temp_ViewedLast
-- --------------------------------------------------

CREATE proc usp_fo_error_report_temp_ViewedLast        
(        
@saudadate as varchar(25)        
)        
as        
declare @count int         
set @count = (select count(*) from fo_error_report where sauda_date = convert(datetime,@saudadate,103))        
        
if @count = 0        
insert into fo_error_report(party_code,remark,sauda_date)Values('Viewed Last:',getdate(),convert(datetime,@saudadate,103))        
else        
update fo_error_report set remark = getdate() where sauda_date = convert(datetime,@saudadate,103)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FO_TRADECHANGES
-- --------------------------------------------------
CREATE Proc USP_FO_TRADECHANGES(@fdate as varchar(11))  
as  
  
-- declare @fdate as varchar(11)  
-- set @fdate = 'Nov 09 2007'  
  
delete temp_ps03 where CONVERT(DATETIME,position_date) = CONVERT(DATETIME,@fdate)  
  
insert into temp_ps03  
select * from   
(  
select 'NOT IN BO' as Status,Client_Account_Code,Symbol,Instrument_Type,Expiry_date,Strike_Price,Option_Type,  
case when Post_Ex_Asgmnt_Long_Quantity = 0 then Post_Ex_Asgmnt_Short_Quantity*-1 else   
Post_Ex_Asgmnt_Long_Quantity end as  Net,Position_Date from nseps03 x (nolock) where position_date = @fdate and   
 Account_Type = 'C' and not exists (select * from  angelfo.nsefo.dbo.fobillvalan y where y.sauda_date >= @fdate   
and y.sauda_date <= @fdate + ' 23:59:59' and x.Client_Account_Code = y.Party_Code and x.Symbol = y.Symbol)  
) x where Net <> 0  
  
  
insert into temp_ps03  
select * from   
(  
select 'NOT IN NSE' as Status,Party_Code,Symbol,Inst_type,Expirydate,  
convert(varchar,Strike_Price) as Strike_Price,Option_type,sum(PQty)-sum(SQty) as Net,  
UpdateDate from angelfo.nsefo.dbo.fobillvalan where  
sauda_date >= @fdate and sauda_date <= @fdate + ' 23:59:59'  
group by Party_Code,Symbol,Inst_type,Expirydate,Strike_Price,Option_type,UpdateDate  
) X where not exists  
(  
select * from   
(  
select Client_Account_Code,Symbol,case when Post_Ex_Asgmnt_Long_Quantity = 0 then Post_Ex_Asgmnt_Short_Quantity*-1 else   
Post_Ex_Asgmnt_Long_Quantity end as  Net from nseps03 y (nolock) where position_date = @fdate  
) y where x.Party_Code = y.Client_Account_Code and x.Symbol = y.Symbol and x.Net = y.net) and net <> 0

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
-- PROCEDURE dbo.USP_globalfobrk_report1
-- --------------------------------------------------
CREATE procedure USP_globalfobrk_report1(@wh as varchar(10)--,@access_to as varchar(20),@access_code as varchar(20)
)              
as              
              
set nocount on              
set transaction isolation level read uncommitted              
select a.*,pcode=b.party_Code,sbtag=b.branch_cd,subgroup=b.sub_Broker into #file1 from mis.fobkg.dbo.fo_margin a (nolock) left outer join         
 intranet.risk.dbo.client_details b             
on a.party_Code=b.party_Code        
         
if @wh='WHC'              
Begin              
 set transaction isolation level read uncommitted              
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,               
 coll=case when (Ledgeramount+Cash_coll+Col_after_haircut) > 0               
 and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable               
 then (Ledgeramount+Cash_coll+Col_after_haircut)               
 when (Ledgeramount+Cash_coll+Col_after_haircut) > 0               
 and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable               
 then Spanmargin_Prepayable else 0 end,               
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut   into #data            
 from (select * from #file1) a left outer join fomargin b               
 on a.party_code=b.party_code               
 order by a.party_code               
          
 Select          
Date=DT,--[Branch Code]=sbtag,[Sub-Broker]=subgroup,    
[Party code]=Party_code,[Span margin]=Span_margin,          
[Pre payable]=Pre_payable,Addition=Spanmargin_Prepayable,MTM,Client_tag,coll          
 from  #data              
           
          
select            
DT='',--sbtag='',subgroup='',    
Party_code='',Span_margin=sum(Span_margin),Pre_payable=sum(Pre_payable)          
,Spanmargin_Prepayable=sum(Spanmargin_Prepayable),MTM=sum(MTM),Client_tag='',coll=sum(coll)          
 from #data          
          
end              
else              
begin              
 set transaction isolation level read uncommitted              
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,               
 coll=case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0               
 and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable               
 then (Ledgeramount+Cash_coll+col_without_haircut)               
 when (Ledgeramount+Cash_coll+col_without_haircut) > 0               
 and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable               
 then Spanmargin_Prepayable else 0 end,               
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut into #data1               
 from (select * from #file1) a left outer join fomargin b               
 on a.party_code=b.party_code               
 order by a.party_code               
          
   Select          
Date=DT,--[Branch Code]=sbtag,[Sub-Broker]=subgroup,    
[Party code]=Party_code,[Span margin]=Span_margin,          
[Pre payable]=Pre_payable,Addition=Spanmargin_Prepayable,MTM,Client_tag,coll          
 from  #data1              
           
          
select            
DT='',--sbtag='',subgroup='',    
Party_code='',Span_margin=sum(Span_margin),Pre_payable=sum(Pre_payable)          
,Spanmargin_Prepayable=sum(Spanmargin_Prepayable),MTM=sum(MTM),Client_tag='',coll=sum(coll)          
 from #data1          
end              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_McxUpload
-- --------------------------------------------------
CREATE proc usp_McxUpload                
(                
@server varchar(300),                
@filename varchar(100),            
@accessto varchar(25),            
@accesscode varchar(25)                
                
)                
                
as                
 begin               
 set nocount  on                
 declare @filepath as varchar(200),@sql as varchar(max)                 
 --declare @server varchar(20),@filename varchar(100)                 
 --set @server='172.29.19.10'              
 --set @filename='focurr.CSV'               
 set @filepath='\\'+@server+'\d$\upload\'+ @filename                 
 truncate table MCx_Sortage                                          
 set @sql=''                                          
 set @sql=@sql+' bulk insert MCx_Sortage from '                                          
 set @sql=@sql+''''+ @filepath +''''                                          
 set @sql=@sql+' with '                                          
 set @sql=@sql+' ( '                      
 set @sql=@sql+' fieldterminator = '','','                  
 set @sql=@sql+' FIRSTROW  = 1,'                                        
 set @sql=@sql+' rowterminator = ''\n'''                                          
 set @sql=@sql+' ) '                                   
  print(@sql)                                        
 exec(@sql)                
                  
 --delete from CurrencyFo where FName=@filename                
 --insert into CurrencyFo Select *,@filename,getdate() from currencyFoTemp               
 select [count]=count(*) from MCx_Sortage              
 set nocount off              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_POSITIONFILE_UPLOADED_DATA
-- --------------------------------------------------
CREATE PROCEDURE USP_POSITIONFILE_UPLOADED_DATA(  
@SEGMENT VARCHAR(20),  
@UPLOADED_BY VARCHAR(10)  
)  
AS  
BEGIN  
DECLARE @COUNT INT  
DECLARE @MISMATCH CHAR(1)

IF @SEGMENT='MCX CURRENCY'
BEGIN
	SELECT @COUNT=COUNT(1) FROM POSITIONFILE_UPLOADED_DATA
	WHERE SEGMENT = @SEGMENT 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,UPLOAD_DATETIME),103)= CONVERT(VARCHAR,GETDATE(),103)
	IF EXISTS(SELECT STATUS FROM TBL_temp_MCX_ps03 WHERE CONVERT(VARCHAR,CONVERT(DATETIME,POSITION_DATE),103)= CONVERT(VARCHAR,GETDATE(),103))
	BEGIN
		SET @MISMATCH='Y'
	END
	ELSE
	BEGIN
		SET @MISMATCH='N'
	END
	IF @COUNT=0
	BEGIN
		INSERT INTO POSITIONFILE_UPLOADED_DATA(SEGMENT,MISMATCH,UPLOADED_BY,UPLOAD_DATETIME)  
		VALUES(@SEGMENT,@MISMATCH,@UPLOADED_BY,GETDATE())  
	END
	ELSE
	BEGIN
		UPDATE POSITIONFILE_UPLOADED_DATA
		SET  MISMATCH=@MISMATCH,UPLOADED_BY=@UPLOADED_BY,UPLOAD_DATETIME=GETDATE()
	END
END
ELSE IF @SEGMENT='MCX COMMODITY'
BEGIN
	SELECT @COUNT=COUNT(1) FROM POSITIONFILE_UPLOADED_DATA
	WHERE SEGMENT = @SEGMENT 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,UPLOAD_DATETIME),103)= CONVERT(VARCHAR,GETDATE(),103)
	IF EXISTS(SELECT STATUS FROM TBL_temp_MCXSX_ps03 WHERE CONVERT(VARCHAR,CONVERT(DATETIME,POSITION_DATE),103)= CONVERT(VARCHAR,GETDATE(),103))
	BEGIN
		SET @MISMATCH='Y'
	END
	ELSE
	BEGIN
		SET @MISMATCH='N'
	END
	IF @COUNT=0
	BEGIN
		INSERT INTO POSITIONFILE_UPLOADED_DATA(SEGMENT,MISMATCH,UPLOADED_BY,UPLOAD_DATETIME)  
		VALUES(@SEGMENT,@MISMATCH,@UPLOADED_BY,GETDATE())  
	END
	ELSE
	BEGIN
		UPDATE POSITIONFILE_UPLOADED_DATA
		SET  MISMATCH=@MISMATCH,UPLOADED_BY=@UPLOADED_BY,UPLOAD_DATETIME=GETDATE()
	END
END
ELSE IF @SEGMENT='NCDEX'
BEGIN
	SELECT @COUNT=COUNT(1) FROM POSITIONFILE_UPLOADED_DATA
	WHERE SEGMENT = @SEGMENT 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,UPLOAD_DATETIME),103)= CONVERT(VARCHAR,GETDATE(),103)
	IF EXISTS(SELECT STATUS FROM TBL_temp_NCDEX_ps03 WHERE CONVERT(VARCHAR,CONVERT(DATETIME,POSITION_DATE),103)= CONVERT(VARCHAR,GETDATE(),103))
	BEGIN
		SET @MISMATCH='Y'
	END
	ELSE
	BEGIN
		SET @MISMATCH='N'
	END
	IF @COUNT=0
	BEGIN
		INSERT INTO POSITIONFILE_UPLOADED_DATA(SEGMENT,MISMATCH,UPLOADED_BY,UPLOAD_DATETIME)  
		VALUES(@SEGMENT,@MISMATCH,@UPLOADED_BY,GETDATE())  
	END
	ELSE
	BEGIN
		UPDATE POSITIONFILE_UPLOADED_DATA
		SET  MISMATCH=@MISMATCH,UPLOADED_BY=@UPLOADED_BY,UPLOAD_DATETIME=GETDATE()
	END
END
ELSE IF @SEGMENT='NSE CURRENCY'
BEGIN
	SELECT @COUNT=COUNT(1) FROM POSITIONFILE_UPLOADED_DATA
	WHERE SEGMENT = @SEGMENT 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,UPLOAD_DATETIME),103)= CONVERT(VARCHAR,GETDATE(),103)
	IF EXISTS(SELECT STATUS FROM TBL_temp_NSECURR_ps03 WHERE CONVERT(VARCHAR,CONVERT(DATETIME,POSITION_DATE),103)= CONVERT(VARCHAR,GETDATE(),103))
	BEGIN
		SET @MISMATCH='Y'
	END
	ELSE
	BEGIN
		SET @MISMATCH='N'
	END
	IF @COUNT=0
	BEGIN
		INSERT INTO POSITIONFILE_UPLOADED_DATA(SEGMENT,MISMATCH,UPLOADED_BY,UPLOAD_DATETIME)  
		VALUES(@SEGMENT,@MISMATCH,@UPLOADED_BY,GETDATE())  
	END
	ELSE
	BEGIN
		UPDATE POSITIONFILE_UPLOADED_DATA
		SET  MISMATCH=@MISMATCH,UPLOADED_BY=@UPLOADED_BY,UPLOAD_DATETIME=GETDATE()
	END
END
ELSE IF @SEGMENT='NSEFO'
BEGIN
	SELECT @COUNT=COUNT(1) FROM POSITIONFILE_UPLOADED_DATA
	WHERE SEGMENT = @SEGMENT 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,UPLOAD_DATETIME),103)= CONVERT(VARCHAR,GETDATE(),103)
	IF EXISTS(SELECT STATUS FROM temp_ps03 WHERE CONVERT(VARCHAR,CONVERT(DATETIME,POSITION_DATE),103)= CONVERT(VARCHAR,GETDATE(),103))
	BEGIN
		SET @MISMATCH='Y'
	END
	ELSE
	BEGIN
		SET @MISMATCH='N'
	END
	IF @COUNT=0
	BEGIN
		INSERT INTO POSITIONFILE_UPLOADED_DATA(SEGMENT,MISMATCH,UPLOADED_BY,UPLOAD_DATETIME)  
		VALUES(@SEGMENT,@MISMATCH,@UPLOADED_BY,GETDATE())  
	END
	ELSE
	BEGIN
		UPDATE POSITIONFILE_UPLOADED_DATA
		SET  MISMATCH=@MISMATCH,UPLOADED_BY=@UPLOADED_BY,UPLOAD_DATETIME=GETDATE()
	END
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRD_CHANGES
-- --------------------------------------------------
CREATE Proc USP_TRD_CHANGES(@fdate as varchar(11))  
as  
  
set @fdate = convert(varchar(11),convert(datetime,@fdate))  
  
select * into #BO from  
(  
select   
case when x.party_code is null then y.party_code else x.party_code end as party_code,  
case when x.symbol is null then y.symbol else x.symbol end as symbol,  
case when x.expirydate is null then y.expirydate else x.expirydate end as expirydate,  
case when x.strike_price is null then y.strike_price else x.strike_price end as strike_price,  
case when x.option_type is null then y.option_type else x.option_type end as option_type,  
isnull(x.buy,0) as buy,  
isnull(y.sell,0) as sell   
from  
(  
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,  
option_type,sum(isnull(tradeqty,0)) as Buy from angelfo.nsefo.dbo.fosettlement  where sauda_date >= @fdate   
and sauda_date <= @fdate+' 23:59:59' and sell_buy = 1 and auctionpart = '' group by party_code,  
symbol,expirydate,strike_price,option_type) x  
full outer join  
(  
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,  
option_type,sum(isnull(tradeqty,0)) as Sell from angelfo.nsefo.dbo.fosettlement    
where sauda_date >= @fdate and sauda_date <= @fdate+' 23:59:59' and sell_buy = 2 and auctionpart = '' group by party_code,  
symbol,expirydate,strike_price,option_type  
) y  
on x.party_code = y.party_code and x.expirydate = y.expirydate and x.strike_price = y.strike_price   
and x.symbol = y.symbol and x.option_type = y.option_type  
) y   
  
SELECT client_account_code,symbol,convert(varchar(11),convert(datetime,expiry_date)) as expiry_date,  
strike_price,option_type,day_buy_open_Quantity,day_sell_open_Quantity into #ps FROM NSEPS03 x (nolock)  
WHERE convert(varchar(11),convert(datetime,position_date)) = @fdate   
  
update #BO set option_type = 'FF' where  option_type = ''   
  
delete tbl_trdchanges where Fld_date = @fdate  
  
insert into tbl_trdchanges  
select distinct 'NOT IN NSE',*,@fdate from #BO y where  not exists  
(select * from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and   
x.client_account_code = y.party_code and x.symbol = y.symbol  
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type  
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))  
  
insert into tbl_trdchanges  
select distinct 'NOT IN BO',*,@fdate from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and not exists  
(select * from #Bo y where x.client_account_code = y.party_code and x.symbol = y.symbol  
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type  
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRD_MCX_CHANGES
-- --------------------------------------------------
CREATE Proc [dbo].[USP_TRD_MCX_CHANGES](@fdate as varchar(11))        
as        
BEGIN        
set @fdate = convert(varchar(11),convert(datetime,@fdate))        


select *     
into #BO     
from        
(        
select         
case when x.party_code is null then y.party_code else x.party_code end as party_code,        
case when x.symbol is null then y.symbol else x.symbol end as symbol,        
case when x.expirydate is null then y.expirydate else x.expirydate end as expirydate,        
case when x.strike_price is null then y.strike_price else x.strike_price end as strike_price,        
case when x.option_type is null then y.option_type else x.option_type end as option_type,        
isnull(x.buy,0) as buy,        
isnull(y.sell,0) as sell         
from        
(        
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,        
option_type,sum(isnull(tradeqty,0)) as Buy   
from AngelCommodity.MCDX.DBO.FOSETTLEMENT    
where sauda_date >= @fdate         
and sauda_date <= @fdate+' 23:59:59' and sell_buy = 1 and auctionpart = '' group by party_code,        
symbol,expirydate,strike_price,option_type) x        
full outer join        
(        
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,        
option_type,sum(isnull(tradeqty,0)) as Sell 
from AngelCommodity.MCDX.DBO.FOSETTLEMENT          
where sauda_date >= @fdate and sauda_date <= @fdate+' 23:59:59' and sell_buy = 2 and auctionpart = ''   
group by party_code,symbol,expirydate,strike_price,option_type        
) y        
on x.party_code = y.party_code and x.expirydate = y.expirydate and x.strike_price = y.strike_price         
and x.symbol = y.symbol and x.option_type = y.option_type        
) y         


SELECT client_account_code,symbol,convert(varchar(11),convert(datetime,expiry_date)) as expiry_date,        
strike_price,option_type,day_buy_open_Quantity,day_sell_open_Quantity     
into #ps     
FROM MCXPSO3 x (nolock)        
WHERE convert(varchar(11),convert(datetime,position_date)) = @fdate         
  
  
update #BO set option_type = 'FF' where  option_type = ''         
  
  
delete FROM tbl_MCX_trdchanges where Fld_date = @fdate        
  
  
insert into tbl_MCX_trdchanges     
select distinct 'NOT IN MCX',*,@fdate from #BO y where  not exists        
(select * from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and         
x.client_account_code = y.party_code and x.symbol = y.symbol        
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type        
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))        
  
  
insert into tbl_MCX_trdchanges     
select distinct 'NOT IN BO',*,@fdate from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and not exists        
(select * from #Bo y where x.client_account_code = y.party_code and x.symbol = y.symbol        
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type        
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))        
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRD_MCXSX_CHANGES
-- --------------------------------------------------

CREATE Proc [dbo].[USP_TRD_MCXSX_CHANGES](@fdate as varchar(11))      
as      
BEGIN      
set @fdate = convert(varchar(11),convert(datetime,@fdate))      

select *   
into #BO   
from      
(      
select       
case when x.party_code is null then y.party_code else x.party_code end as party_code,      
case when x.symbol is null then y.symbol else x.symbol end as symbol,      
case when x.expirydate is null then y.expirydate else x.expirydate end as expirydate,      
case when x.strike_price is null then y.strike_price else x.strike_price end as strike_price,      
case when x.option_type is null then y.option_type else x.option_type end as option_type,      
isnull(x.buy,0) as buy,      
isnull(y.sell,0) as sell       
from      
(      
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,      
option_type,sum(isnull(tradeqty,0)) as Buy 
from AngelCommodity.MCDXCDS.DBO.FOSETTLEMENT  
where sauda_date >= @fdate       
and sauda_date <= @fdate+' 23:59:59' and sell_buy = 1 and auctionpart = '' group by party_code,      
symbol,expirydate,strike_price,option_type) x      
full outer join      
(      
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,      
option_type,sum(isnull(tradeqty,0)) as Sell from AngelCommodity.MCDXCDS.DBO.FOSETTLEMENT        
where sauda_date >= @fdate and sauda_date <= @fdate+' 23:59:59' and sell_buy = 2 and auctionpart = '' 
group by party_code,symbol,expirydate,strike_price,option_type      
) y      
on x.party_code = y.party_code and x.expirydate = y.expirydate and x.strike_price = y.strike_price       
and x.symbol = y.symbol and x.option_type = y.option_type      
) y       


SELECT client_account_code,symbol,convert(varchar(11),convert(datetime,expiry_date)) as expiry_date,      
strike_price,option_type,day_buy_open_Quantity,day_sell_open_Quantity   
into #ps   
FROM MCXSXPSO3 x (nolock)      
WHERE convert(varchar(11),convert(datetime,position_date)) = @fdate       


update #BO set option_type = 'FF' where  option_type = ''       


delete FROM tbl_MCXSX_trdchanges where Fld_date = @fdate      


insert into tbl_MCXSX_trdchanges   
select distinct 'NOT IN MCXSX',*,@fdate from #BO y where  not exists      
(select * from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and       
x.client_account_code = y.party_code and x.symbol = y.symbol      
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type      
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))      


insert into tbl_MCXSX_trdchanges   
select distinct 'NOT IN BO',*,@fdate from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and not exists      
(select * from #Bo y where x.client_account_code = y.party_code and x.symbol = y.symbol      
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type      
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))      

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRD_NCDEX_CHANGES
-- --------------------------------------------------
CREATE Proc [dbo].[USP_TRD_NCDEX_CHANGES](@fdate as varchar(11))    
as    
BEGIN    
set @fdate = convert(varchar(11),convert(datetime,@fdate))    
    
select * 
into #BO 
from    
(    
select     
case when x.party_code is null then y.party_code else x.party_code end as party_code,    
case when x.symbol is null then y.symbol else x.symbol end as symbol,    
case when x.expirydate is null then y.expirydate else x.expirydate end as expirydate,    
case when x.strike_price is null then y.strike_price else x.strike_price end as strike_price,    
case when x.option_type is null then y.option_type else x.option_type end as option_type,    
isnull(x.buy,0) as buy,    
isnull(y.sell,0) as sell     
from    
(    
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,    
option_type,sum(isnull(tradeqty,0)) as Buy from AngelCommodity.NCDX.DBO.FOSETTLEMENT  where sauda_date >= @fdate     
and sauda_date <= @fdate+' 23:59:59' and sell_buy = 1 and auctionpart = '' group by party_code,    
symbol,expirydate,strike_price,option_type) x    
full outer join    
(    
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,    
option_type,sum(isnull(tradeqty,0)) as Sell from AngelCommodity.NCDX.DBO.FOSETTLEMENT      
where sauda_date >= @fdate and sauda_date <= @fdate+' 23:59:59' and sell_buy = 2 and auctionpart = '' group by party_code,    
symbol,expirydate,strike_price,option_type    
) y    
on x.party_code = y.party_code and x.expirydate = y.expirydate and x.strike_price = y.strike_price     
and x.symbol = y.symbol and x.option_type = y.option_type    
) y     
    



SELECT client_account_code,symbol,convert(varchar(11),convert(datetime,expiry_date)) as expiry_date,    
strike_price,option_type,day_buy_open_Quantity,day_sell_open_Quantity 
into #ps 
FROM NCDEXPSO3 x (nolock)    
WHERE convert(varchar(11),convert(datetime,position_date)) = @fdate     
    
update #BO set option_type = 'FF' where  option_type = ''     
    
delete FROM tbl_NCDEX_trdchanges where Fld_date = @fdate    
    
insert into tbl_NCDEX_trdchanges
select distinct 'NOT IN NCDX',*,@fdate from #BO y where  not exists    
(select * from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and     
x.client_account_code = y.party_code and x.symbol = y.symbol    
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type    
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))    
    
insert into tbl_NCDEX_trdchanges    
select distinct 'NOT IN BO',*,@fdate from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and not exists    
(select * from #Bo y where x.client_account_code = y.party_code and x.symbol = y.symbol    
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type    
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))    
    
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TRD_NSECURR_CHANGES
-- --------------------------------------------------
CREATE Proc [dbo].[USP_TRD_NSECURR_CHANGES](@fdate as varchar(11))        
as            
BEGIN            
set @fdate = convert(varchar(11),convert(datetime,@fdate))            
            
select *         
into #BO         
from            
(            
select             
case when x.party_code is null then y.party_code else x.party_code end as party_code,            
case when x.symbol is null then y.symbol else x.symbol end as symbol,            
case when x.expirydate is null then y.expirydate else x.expirydate end as expirydate,            
case when x.strike_price is null then y.strike_price else x.strike_price end as strike_price,            
case when x.option_type is null then y.option_type else x.option_type end as option_type,            
isnull(x.buy,0) as buy,            
isnull(y.sell,0) as sell             
from            
(            
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,            
option_type,sum(isnull(tradeqty,0)) as Buy from AngelFO.NSECURFO.DBO.FOSETTLEMENT  where sauda_date >= @fdate             
and sauda_date <= @fdate+' 23:59:59' and sell_buy = 1 and auctionpart = '' group by party_code,            
symbol,expirydate,strike_price,option_type) x            
full outer join            
(            
select party_code,symbol,convert(varchar(11),convert(datetime,expirydate)) as expirydate,strike_price,            
option_type,sum(isnull(tradeqty,0)) as Sell from [196.1.115.200].NSECURFO.DBO.FOSETTLEMENT              
where sauda_date >= @fdate and sauda_date <= @fdate+' 23:59:59' and sell_buy = 2 and auctionpart = '' group by party_code,            
symbol,expirydate,strike_price,option_type            
) y            
on x.party_code = y.party_code and x.expirydate = y.expirydate and x.strike_price = y.strike_price             
and x.symbol = y.symbol and x.option_type = y.option_type            
) y             
            
        
        
        
SELECT client_account_code,symbol,convert(varchar(11),convert(datetime,expiry_date)) as expiry_date,            
strike_price,option_type,day_buy_open_Quantity,day_sell_open_Quantity         
into #ps         
FROM NSECURRPSO3 x (nolock)            
WHERE convert(varchar(11),convert(datetime,position_date)) = @fdate             
            
update #BO set option_type = 'FF' where  option_type = ''             
            
delete FROM tbl_NSECURR_trdchanges where Fld_date = @fdate            
            
insert into tbl_NSECURR_trdchanges        
select distinct 'NOT IN NCDX',*,@fdate from #BO y where  not exists            
(select * from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and             
x.client_account_code = y.party_code and x.symbol = y.symbol            
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type            
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))            
            
insert into tbl_NSECURR_trdchanges            
select distinct 'NOT IN BO',*,@fdate from #ps x where (day_buy_open_Quantity <> 0 or day_sell_open_Quantity <> 0) and not exists            
(select * from #Bo y where x.client_account_code = y.party_code and x.symbol = y.symbol            
and x.day_buy_open_Quantity = y.buy and x.day_sell_open_Quantity = y.sell and x.option_type = y.option_type            
and convert(varchar(11),convert(datetime,x.expiry_date)) = convert(varchar(11),convert(datetime,y.expirydate)))            
            
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_MCX_POSITION_FILE
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UPLOAD_MCX_POSITION_FILE]                      
AS                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
BEGIN                      
DECLARE @PATH AS VARCHAR(100)                                                    
DECLARE @SQL AS VARCHAR(1000)                                                        
                                            
TRUNCATE TABLE TBL_MCX_12685                     
                                            
SET @PATH='\\INHOUSEALLAPP-FS.angelone.in\UPLOAD1\MCX_POSITION_12685_'+REPLACE(CONVERT(VARCHAR,GETDATE(),111),'/','')+'.CSV'                                            
SET @SQL = 'BULK INSERT TBL_MCX_12685  FROM '''+@PATH+''' WITH (FIELDTERMINATOR = '','', FIRSTROW=1,KEEPNULLS)'                                                    
EXEC (@SQL)                      
                    
                    
DECLARE @FDATE AS VARCHAR(11)                                            
SET @FDATE = (SELECT DISTINCT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)) FROM TBL_MCX_12685 (NOLOCK))                                            
                    
DELETE TBL_MCX_HIST WHERE POSITION_DATE IN  (SELECT TOP 1 POSITION_DATE FROM MCXPSO3)                              
INSERT INTO TBL_MCX_HIST SELECT * FROM MCXPSO3                    
                    
                    
TRUNCATE TABLE MCXPSO3                    
                    
                    
                    
INSERT INTO MCXPSO3                                              
SELECT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)),                      
CLEARING_MEMBER_CODE,TRADING_MEMBER_CODE,ACCOUNT_TYPE,CLIENT_ACCOUNT_CODE,INSTRUMENT_TYPE,SYMBOL,                        
EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,BROUGHT_FORWARD_LONG_QUANTITY,BROUGHT_FORWARD_LONG_VALUE,                        
BROUGHT_FORWARD_SHORT_QUANTITY,BROUGHT_FORWARD_SHORT_VALUE,DAY_BUY_OPEN_QUANTITY,DAY_BUY_OPEN_VALUE,                        
DAY_SELL_OPEN_QUANTITY,DAY_SELL_OPEN_VALUE,PRE_EX_ASGMNT_LONG_QUANTITY,PRE_EX_ASGMNT_LONG_VALUE,                        
PRE_EX_ASGMNT_SHORT_QUANTITY,PRE_EX_ASGMNT_SHORT_VALUE,EXERCISED_QUANTITY,ASSIGNED_QUANTITY,                        
POST_EX_ASGMNT_LONG_QUANTITY,POST_EX_ASGMNT_LONG_VALUE,POST_EX_ASGMNT_SHORT_QUANTITY,POST_EX_ASGMNT_SHORT_VALUE,                                    
NET_PREMIUM,DAILY_MTM_SETTLEMENT_VALUE,                      
EXERCISED_ASSIGNED_VALUE,RESERVED                         
FROM TBL_MCX_12685 (NOLOCK)                         
                    
                    
DELETE FROM TBL_temp_MCX_ps03                          
WHERE POSITION_DATE = @FDATE                     
                    
                    
--SELECT CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,                                  
--EXPIRY_DATE=CONVERT(DATETIME,SUBSTRING(EXPIRY_DATE,4,3)+' '+SUBSTRING(EXPIRY_DATE,1,2)+' '+SUBSTRING(EXPIRY_DATE,8,4)+' 23:59')                                  
--,STRIKE_PRICE,OPTION_TYPE,                                                
--CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN POST_EX_ASGMNT_SHORT_QUANTITY*-1 ELSE                                                 
--POST_EX_ASGMNT_LONG_QUANTITY END AS  NET,POSITION_DATE                                   
--INTO #FILE1X                                  
--FROM MCXPSO3 X (NOLOCK)                       
--WHERE POSITION_DATE = @FDATE AND ACCOUNT_TYPE = 'C'                
                
                
SELECT SYMBOL, MULTIPLIER = (C_REGULAR_LOT*LOTNUMERATOR)/LOTDENOMINATOR,expirydate,strike_price,option_type                 
INTO #MULTIPLIER                
FROM AngelCommodity.MCDX.DBO.FOSCRIP2                
WHERE EXPIRYDATE >GETDATE()                 
ORDER BY SYMBOL                
                
                
                
SELECT CLIENT_ACCOUNT_CODE,X.SYMBOL,INSTRUMENT_TYPE,                                  
CASE WHEN LEN(EXPIRY_DATE)=11 THEN        
CONVERT(DATETIME,SUBSTRING(X.EXPIRY_DATE,4,3)+' '+SUBSTRING(X.EXPIRY_DATE,1,2)+' '+SUBSTRING(X.EXPIRY_DATE,8,4)+' 23:59')        
ELSE        
CONVERT(DATETIME,SUBSTRING(X.EXPIRY_DATE,3,3)+' '+SUBSTRING(X.EXPIRY_DATE,1,1)+' '+SUBSTRING(X.EXPIRY_DATE,7,4)+' 23:59')        
END AS 'EXPIRY_DATE',                
CAST(X.STRIKE_PRICE AS DECIMAL(5,2)) AS 'STRIKE_PRICE',ISNULL(X.OPTION_TYPE,'') AS 'OPTION_TYPE',                                                
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)* convert(int,MULTIPLIER) ELSE                                                 
POST_EX_ASGMNT_LONG_QUANTITY * convert(int,MULTIPLIER)  END AS  NET,POSITION_DATE                                   
INTO #FILE1X                                  
FROM                 
MCXPSO3 X                
left outer join                
#MULTIPLIER MX                
ON X.SYMBOL=MX.SYMBOL AND CAST(X.STRIKE_PRICE AS DECIMAL(5,2))=MX.STRIKE_PRICE and convert(varchar,convert(datetime,x.Expiry_date),103)= convert(varchar,mx.expirydate,103)                
AND isnull(replace(x.OPTION_TYPE,'FF',''),'')= MX.OPTION_TYPE                  
WHERE POSITION_DATE = @FDATE AND ACCOUNT_TYPE = 'C'                
                     
                    
SELECT PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE,NQTY=SUM(PQTY-SQTY)                        
INTO #FILE2X                                   
FROM  AngelCommodity.MCDX.DBO.FOBILLVALAN                       
WHERE SAUDA_DATE = @FDATE + ' 23:59:00'                                  
GROUP BY PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE                    
                    
                    
INSERT INTO TBL_TEMP_MCX_PS03                        
SELECT * FROM                                                 
(                                                
SELECT 'NOT IN BO' AS STATUS,CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,NET,POSITION_DATE                                   
FROM #FILE1X  X (NOLOCK)                                   
WHERE NOT EXISTS                                   
(SELECT * FROM  #FILE2X Y                                   
WHERE X.CLIENT_ACCOUNT_CODE = Y.PARTY_CODE AND X.SYMBOL = Y.SYMBOL AND X.EXPIRY_DATE=Y.EXPIRYDATE AND X.INSTRUMENT_TYPE=Y.INST_TYPE                                   
AND REPLACE(X.OPTION_TYPE,'FF','')=Y.OPTION_TYPE AND X.NET=Y.NQTY)                                    
) Y WHERE NET <> 0.00                      
                    
                                 
                    
SELECT 'NOT IN MCX' AS STATUS,PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,                                                
CONVERT(VARCHAR,STRIKE_PRICE) AS STRIKE_PRICE,OPTION_TYPE,SUM(PQTY)-SUM(SQTY) AS NET,                                                
UPDATEDATE INTO #FILE1 FROM AngelCommodity.MCDX.DBO.FOBILLVALAN WHERE                                                
SAUDA_DATE >= @FDATE AND SAUDA_DATE <= @FDATE + ' 23:59:59'                                                
GROUP BY PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,UPDATEDATE                 
HAVING (SUM(PQTY)-SUM(SQTY))<>0                               
                    
                    
SELECT CLIENT_ACCOUNT_CODE,x.SYMBOL,                        
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*MULTIPLIER ELSE                                                 
POST_EX_ASGMNT_LONG_QUANTITY*MULTIPLIER END AS  NET                 
INTO #FILE2                                    
FROM MCXPSO3 x                
left outer join                
#multiplier mx                
ON X.SYMBOL=MX.SYMBOL AND CAST(X.STRIKE_PRICE AS DECIMAL(5,2))=MX.STRIKE_PRICE and convert(varchar,convert(datetime,x.Expiry_date),103)= convert(varchar,mx.expirydate,103)                 
AND isnull(replace(x.OPTION_TYPE,'FF',''),'')= MX.OPTION_TYPE                  
WHERE POSITION_DATE =  @FDATE                                               
                    
                    
                    
INSERT INTO TBL_TEMP_MCX_PS03                                                
SELECT  DISTINCT A.STATUS,A.PARTY_CODE,A.SYMBOL,A.INST_TYPE,A.EXPIRYDATE,A.STRIKE_PRICE,A.OPTION_TYPE,NET=B.NET_QTY,A.UPDATEDATE FROM                                    
(                                
SELECT * FROM                                     
(                                    
SELECT X.*,Y.CLIENT_ACCOUNT_CODE,YNET=Y.NET                                    
FROM                                     
(SELECT * FROM #FILE1 /*WHERE SYMBOL='DLF' AND PARTY_CODE='D8243'*/) X                                     
LEFT OUTER JOIN                                     
(                                    
SELECT * FROM #FILE2 /*WHERE SYMBOL='DLF' AND CLIENT_ACCOUNT_CODE='8243'*/                                    
--WHERE SYMBOL IN (SELECT SYMBOL FROM #FILE1)                                    
) Y                                     
ON (X.SYMBOL=ISNULL(Y.SYMBOL,'~!@#') AND X.PARTY_CODE=ISNULL(Y.CLIENT_ACCOUNT_CODE,'~!@#') AND CONVERT(INT,X.NET) = CONVERT(INT,ISNULL(Y.NET,-1)))                                    
) Z                                    
WHERE CLIENT_ACCOUNT_CODE IS NULL                                    
) A,                                     
(                
SELECT * FROM TBL_TEMP_MCX_PS03 WHERE STATUS= 'NOT IN BO'                                     
AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(VARCHAR,@FDATE,101)                                     
) B WHERE A.SYMBOL=B.SYMBOL                                    
                      
    EXEC USP_TRD_MCX_CHANGES @FDATE                  
                      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_MCXSX_POSITION_FILE
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_UPLOAD_MCXSX_POSITION_FILE]              
AS               
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
BEGIN              
DECLARE @PATH AS VARCHAR(100)                                            
DECLARE @SQL AS VARCHAR(1000)                                                
                                    
TRUNCATE TABLE TBL_MCXSX_10500              
          
SET @PATH='\\INHOUSEALLAPP-FS.angelone.in\UPLOAD1\MCX-SX_POSITION_10500_'+REPLACE(CONVERT(VARCHAR,GETDATE(),111),'/','')+'.CSV'                                    
SET @SQL = 'BULK INSERT TBL_MCXSX_10500 FROM '''+@PATH+''' WITH (FIELDTERMINATOR = '','', FIRSTROW=1,KEEPNULLS)'                                            
EXEC (@SQL)            
            
DECLARE @FDATE AS VARCHAR(11)                                    
SET @FDATE = (SELECT DISTINCT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)) FROM TBL_MCXSX_10500 (NOLOCK))                                    
            
            
          
          
          
DELETE TBL_MCXSX_HIST  WHERE POSITION_DATE IN  (SELECT TOP 1 POSITION_DATE FROM MCXSXPSO3)                      
INSERT INTO TBL_MCXSX_HIST SELECT * FROM MCXSXPSO3            
            
          
          
TRUNCATE TABLE MCXSXPSO3                      
            
          
INSERT INTO MCXSXPSO3                                    
SELECT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)),            
CLEARING_MEMBER_CODE,TRADING_MEMBER_CODE,ACCOUNT_TYPE,CLIENT_ACCOUNT_CODE,INSTRUMENT_TYPE,SYMBOL,              
EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,BROUGHT_FORWARD_LONG_QUANTITY,BROUGHT_FORWARD_LONG_VALUE,              
BROUGHT_FORWARD_SHORT_QUANTITY,BROUGHT_FORWARD_SHORT_VALUE,DAY_BUY_OPEN_QUANTITY,DAY_BUY_OPEN_VALUE,              
DAY_SELL_OPEN_QUANTITY,DAY_SELL_OPEN_VALUE,PRE_EX_ASGMNT_LONG_QUANTITY,PRE_EX_ASGMNT_LONG_VALUE,              
PRE_EX_ASGMNT_SHORT_QUANTITY,PRE_EX_ASGMNT_SHORT_VALUE,EXERCISED_QUANTITY,ASSIGNED_QUANTITY,              
POST_EX_ASGMNT_LONG_QUANTITY,POST_EX_ASGMNT_LONG_VALUE,POST_EX_ASGMNT_SHORT_QUANTITY,POST_EX_ASGMNT_SHORT_VALUE,                          
NET_PREMIUM,DAILY_MTM_SETTLEMENT_VALUE,            
EXERCISED_ASSIGNED_VALUE,RESERVED               
FROM TBL_MCXSX_10500 (NOLOCK)                 
            
            
DELETE FROM TBL_temp_MCXSX_ps03                
WHERE POSITION_DATE = @FDATE               
            
            
--DROP TABLE #FILE1X                        
--SELECT CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,                        
--EXPIRY_DATE=CONVERT(DATETIME,SUBSTRING(EXPIRY_DATE,3,3)+' '+SUBSTRING(EXPIRY_DATE,1,2)+' '+SUBSTRING(EXPIRY_DATE,7,4)+' 23:59')                                      
--,STRIKE_PRICE,ISNULL(OPTION_TYPE,'') as OPTION_TYPE,        
--CASE WHEN SYMBOL='JPYINR' THEN                                     
--(CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*100000 ELSE                                       
--POST_EX_ASGMNT_LONG_QUANTITY*100000 END)        
--ELSE        
--(        
--CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                       
--POST_EX_ASGMNT_LONG_QUANTITY*1000 END        
--)END AS  NET,POSITION_DATE        
--INTO #FILE1X                        
--FROM MCXSXPSO3 X (NOLOCK)             
--WHERE POSITION_DATE = @FDATE AND ACCOUNT_TYPE = 'C'          
            
            
SELECT CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,                        
EXPIRY_DATE=CONVERT(DATETIME,SUBSTRING(EXPIRY_DATE,4,3)+' '+SUBSTRING(EXPIRY_DATE,1,2)+' '+SUBSTRING(EXPIRY_DATE,8,4)+' 23:59')                                      
,STRIKE_PRICE,ISNULL(OPTION_TYPE,'') as OPTION_TYPE,        
CASE WHEN SYMBOL='JPYINR' THEN                                     
(CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*100000 ELSE                                       
POST_EX_ASGMNT_LONG_QUANTITY*100000 END)        
ELSE        
(        
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                       
POST_EX_ASGMNT_LONG_QUANTITY*1000 END        
)END AS  NET,POSITION_DATE        
INTO #FILE1X                        
FROM MCXSXPSO3 X (NOLOCK)             
WHERE POSITION_DATE = @FDATE AND ACCOUNT_TYPE = 'C'            
            
            
            
            
SELECT PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE,NQTY=SUM(PQTY-SQTY)                
INTO  #FILE2X                         
FROM  [196.1.115.204].MCDXCDS.DBO.FOBILLVALAN             
WHERE SAUDA_DATE = @FDATE + ' 23:59:00'                        
GROUP BY PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE                       
            
            
            
INSERT INTO TBL_TEMP_MCXSX_PS03              
SELECT * FROM                                       
(                                      
SELECT 'NOT IN BO' AS STATUS,CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,NET,POSITION_DATE                         
FROM  #FILE1X  X (NOLOCK)                         
WHERE NOT EXISTS                         
(SELECT * FROM  #FILE2X Y                         
WHERE X.CLIENT_ACCOUNT_CODE = Y.PARTY_CODE AND X.SYMBOL = Y.SYMBOL AND X.EXPIRY_DATE=Y.EXPIRYDATE AND X.INSTRUMENT_TYPE=Y.INST_TYPE                         
AND REPLACE(X.OPTION_TYPE,'FF','')=Y.OPTION_TYPE AND X.NET=Y.NQTY)                          
) Y WHERE NET <> 0            
            
            
            
SELECT 'NOT IN MCXSX' AS STATUS,PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,                                      
CONVERT(VARCHAR,STRIKE_PRICE) AS STRIKE_PRICE,OPTION_TYPE,SUM(PQTY)-SUM(SQTY) AS NET,                                      
UPDATEDATE         
INTO #FILE1         
FROM AngelCommodity.MCDXCDS.DBO.FOBILLVALAN WHERE                                      
SAUDA_DATE >= @FDATE AND SAUDA_DATE <= @FDATE + ' 23:59:59'                                      
GROUP BY PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,UPDATEDATE               
having (SUM(PQTY)-SUM(SQTY))<>0            
            
            
            
SELECT CLIENT_ACCOUNT_CODE,SYMBOL,        
CASE WHEN SYMBOL = 'JPYINR' THEN        
(              
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*100000 ELSE                                       
POST_EX_ASGMNT_LONG_QUANTITY*100000 END        
)        
ELSE        
(        
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                       
POST_EX_ASGMNT_LONG_QUANTITY*1000 END        
)        
END AS NET          
INTO #FILE2                          
FROM MCXSXPSO3 Y (NOLOCK)           
WHERE POSITION_DATE = @FDATE        
            
            
            
INSERT INTO TBL_TEMP_MCXSX_PS03                                      
SELECT  DISTINCT A.STATUS,A.PARTY_CODE,A.SYMBOL,A.INST_TYPE,A.EXPIRYDATE,A.STRIKE_PRICE,A.OPTION_TYPE,NET=B.NET_QTY,A.UPDATEDATE FROM                          
(                          
SELECT * FROM                           
(                          
SELECT X.*,Y.CLIENT_ACCOUNT_CODE,YNET=Y.NET                          
FROM                           
(SELECT * FROM #FILE1 /*WHERE SYMBOL='DLF' AND PARTY_CODE='D8243'*/) X                           
LEFT OUTER JOIN                           
(                          
SELECT * FROM #FILE2 /*WHERE SYMBOL='DLF' AND CLIENT_ACCOUNT_CODE='8243'*/                          
--WHERE SYMBOL IN (SELECT SYMBOL FROM #FILE1)                          
) Y                           
ON (X.SYMBOL=ISNULL(Y.SYMBOL,'~!@#') AND X.PARTY_CODE=ISNULL(Y.CLIENT_ACCOUNT_CODE,'~!@#') AND CONVERT(INT,X.NET) = CONVERT(INT,ISNULL(Y.NET,-1)))                          
) Z                          
WHERE CLIENT_ACCOUNT_CODE IS NULL                          
) A,                           
(                          
SELECT * FROM TBL_TEMP_MCXSX_PS03 WHERE STATUS= 'NOT IN BO'                           
AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(VARCHAR,@FDATE,101)                           
) B WHERE A.SYMBOL=B.SYMBOL                          
            
            
EXEC USP_TRD_MCXSX_CHANGES @FDATE               
            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_NCDEX_POSITION_FILE
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_UPLOAD_NCDEX_POSITION_FILE]         
AS          
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
BEGIN          
DECLARE @PATH AS VARCHAR(100)                                        
DECLARE @SQL AS VARCHAR(1000)                                            
                                
TRUNCATE TABLE TBL_NCDEX_00220          
        
        
      
SET @PATH='\\INHOUSEALLAPP-FS.angelone.in\UPLOAD1\NCDEX_PS03_00220_'+REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/','')+'.CSV'                                
SET @SQL = 'BULK INSERT TBL_NCDEX_00220 FROM '''+@PATH+''' WITH (FIELDTERMINATOR = '','', FIRSTROW=1,KEEPNULLS)'                                        
EXEC (@SQL)                                 
      
      
          
DECLARE @FDATE AS VARCHAR(11)                                
SET @FDATE = (SELECT DISTINCT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)) FROM TBL_NCDEX_00220 (NOLOCK))                                
          
          
          
          
DELETE TBL_NCDEX_HIST WHERE POSITION_DATE IN  (SELECT TOP 1 POSITION_DATE FROM NCDEXPSO3)                  
INSERT INTO TBL_NCDEX_HIST SELECT * FROM NCDEXPSO3                  
          
          
          
TRUNCATE TABLE NCDEXPSO3                  
          
          
INSERT INTO NCDEXPSO3                                
SELECT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)),SEGMENT_INDICATOR,SETTLEMENT_TYPE,          
CLEARING_MEMBER_CODE,MEMBER_TYPE,TRADING_MEMBER_CODE,ACCOUNT_TYPE,CLIENT_ACCOUNT_CODE,INSTRUMENT_TYPE,SYMBOL,          
EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,CA_LEVEL,BROUGHT_FORWARD_LONG_QUANTITY,BROUGHT_FORWARD_LONG_VALUE,          
BROUGHT_FORWARD_SHORT_QUANTITY,BROUGHT_FORWARD_SHORT_VALUE,DAY_BUY_OPEN_QUANTITY,DAY_BUY_OPEN_VALUE,          
DAY_SELL_OPEN_QUANTITY,DAY_SELL_OPEN_VALUE,PRE_EX_ASGMNT_LONG_QUANTITY,PRE_EX_ASGMNT_LONG_VALUE,          
PRE_EX_ASGMNT_SHORT_QUANTITY,PRE_EX_ASGMNT_SHORT_VALUE,EXERCISED_QUANTITY,ASSIGNED_QUANTITY,          
POST_EX_ASGMNT_LONG_QUANTITY,POST_EX_ASGMNT_LONG_VALUE,POST_EX_ASGMNT_SHORT_QUANTITY,POST_EX_ASGMNT_SHORT_VALUE,                      
SETTLEMENT_PRICE,NET_PREMIUM,DAILY_MTM_SETTLEMENT_VALUE,FUTURES_FINAL_SETTLEMENT_VALUE,          
EXERCISED_ASSIGNED_VALUE           
FROM TBL_NCDEX_00220 (NOLOCK)                                
          
          
          
DELETE FROM TBL_TEMP_NCDEX_PS03            
WHERE POSITION_DATE = @FDATE           
          
          
          
          
SELECT CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,                    
CASE WHEN LEN(EXPIRY_DATE)=11 THEN          
CONVERT(DATETIME,SUBSTRING(X.EXPIRY_DATE,4,3)+' '+SUBSTRING(X.EXPIRY_DATE,1,2)+' '+SUBSTRING(X.EXPIRY_DATE,8,4)+' 23:59')          
ELSE          
CONVERT(DATETIME,SUBSTRING(X.EXPIRY_DATE,3,3)+' '+SUBSTRING(X.EXPIRY_DATE,1,1)+' '+SUBSTRING(X.EXPIRY_DATE,7,4)+' 23:59')          
END AS 'EXPIRY_DATE'  
,STRIKE_PRICE,OPTION_TYPE,                                  
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN POST_EX_ASGMNT_SHORT_QUANTITY*-1 ELSE                                   
POST_EX_ASGMNT_LONG_QUANTITY END AS  NET,POSITION_DATE                     
INTO #FILE1X                    
FROM NCDEXPSO3 X (NOLOCK) WHERE POSITION_DATE = @FDATE AND                                   
ACCOUNT_TYPE = 'C'             
          
          
SELECT PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE,NQTY=SUM(PQTY-SQTY)            
INTO #FILE2X                     
FROM  [196.1.115.204].NCDX.DBO.FOBILLVALAN WHERE SAUDA_DATE = @FDATE + ' 23:59:00'                    
GROUP BY PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE                   
          
          
          
          
INSERT INTO TBL_TEMP_NCDEX_PS03          
SELECT * FROM                                   
(                                  
SELECT 'NOT IN BO' AS STATUS,CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,NET,POSITION_DATE                     
FROM #FILE1X  X (NOLOCK)                     
WHERE NOT EXISTS            
(SELECT * FROM  #FILE2X Y                     
WHERE X.CLIENT_ACCOUNT_CODE = Y.PARTY_CODE AND X.SYMBOL = Y.SYMBOL AND X.EXPIRY_DATE=Y.EXPIRYDATE AND X.INSTRUMENT_TYPE=Y.INST_TYPE                     
AND REPLACE(X.OPTION_TYPE,'FF','')=Y.OPTION_TYPE AND X.NET=Y.NQTY)                      
) Y WHERE NET <> 0            
          
          
SELECT 'NOT IN NCDEX' AS STATUS,PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,                                  
CONVERT(VARCHAR,STRIKE_PRICE) AS STRIKE_PRICE,OPTION_TYPE,SUM(PQTY)-SUM(SQTY) AS NET,                                  
UPDATEDATE INTO #FILE1 FROM AngelCommodity.NCDX.DBO.FOBILLVALAN WHERE                                  
SAUDA_DATE >= @FDATE AND SAUDA_DATE <= @FDATE + ' 23:59:59'                                  
GROUP BY PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,UPDATEDATE       
having    SUM(PQTY)-SUM(SQTY) <>0    
          
          
          
SELECT CLIENT_ACCOUNT_CODE,SYMBOL,          
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN POST_EX_ASGMNT_SHORT_QUANTITY*-1 ELSE                                   
POST_EX_ASGMNT_LONG_QUANTITY END AS  NET INTO #FILE2                      
FROM NCDEXPSO3 Y (NOLOCK) WHERE POSITION_DATE = @FDATE                                  
          
          
          
          
INSERT INTO TBL_TEMP_NCDEX_PS03                                  
SELECT  DISTINCT A.STATUS,A.PARTY_CODE,A.SYMBOL,A.INST_TYPE,A.EXPIRYDATE,A.STRIKE_PRICE,A.OPTION_TYPE,NET=B.NET_QTY,A.UPDATEDATE FROM                      
(                      
SELECT * FROM                       
(                      
SELECT X.*,Y.CLIENT_ACCOUNT_CODE,YNET=Y.NET                      
FROM                       
(SELECT * FROM #FILE1 /*WHERE SYMBOL='DLF' AND PARTY_CODE='D8243'*/) X                       
LEFT OUTER JOIN                       
(                      
SELECT * FROM #FILE2 /*WHERE SYMBOL='DLF' AND CLIENT_ACCOUNT_CODE='8243'*/                      
--WHERE SYMBOL IN (SELECT SYMBOL FROM #FILE1)                      
) Y                       
ON (X.SYMBOL=ISNULL(Y.SYMBOL,'~!@#') AND X.PARTY_CODE=ISNULL(Y.CLIENT_ACCOUNT_CODE,'~!@#') AND CONVERT(INT,X.NET) = CONVERT(INT,ISNULL(Y.NET,-1)))                      
) Z                      
WHERE CLIENT_ACCOUNT_CODE IS NULL                      
) A,                       
(                      
SELECT * FROM TBL_TEMP_NCDEX_PS03 WHERE STATUS= 'NOT IN BO'                       
AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(VARCHAR,@FDATE,101)                       
) B WHERE A.SYMBOL=B.SYMBOL                      
          
          
          
EXEC USP_TRD_NCDEX_CHANGES @FDATE            
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_NSECURR_POSITION_FILE
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UPLOAD_NSECURR_POSITION_FILE]                          
AS                          
                          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                          
BEGIN                          
DECLARE @PATH AS VARCHAR(100)                                                        
DECLARE @SQL AS VARCHAR(1000)                                                            
                                                
TRUNCATE TABLE TBL_NSECURR_00220                          
                                                
SET @PATH='\\INHOUSEALLAPP-FS.angelone.in\UPLOAD1\X_PS03_12798_'+REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/','')+'.CSV'                                                
SET @SQL = 'BULK INSERT TBL_NSECURR_00220 FROM '''+@PATH+''' WITH (FIELDTERMINATOR = '','', FIRSTROW=1,KEEPNULLS)'                                                        
EXEC (@SQL)                                                 
                          
                          
DECLARE @FDATE AS VARCHAR(11)                                                
SET @FDATE = (SELECT DISTINCT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)) FROM TBL_NSECURR_00220 (NOLOCK))                                                
                       
                          
                          
                          
                          
DELETE TBL_NSECURR_HIST WHERE POSITION_DATE IN  (SELECT TOP 1 POSITION_DATE FROM NSECURRPSO3)                                  
INSERT INTO TBL_NSECURR_HIST SELECT * FROM NSECURRPSO3                                  
                          
                          
                          
TRUNCATE TABLE NSECURRPSO3                                  
                          
                          
INSERT INTO NSECURRPSO3                                                
SELECT CONVERT(VARCHAR(11),CONVERT(DATETIME,POSITION_DATE)),SEGMENT_INDICATOR,SETTLEMENT_TYPE,                          
CLEARING_MEMBER_CODE,MEMBER_TYPE,TRADING_MEMBER_CODE,ACCOUNT_TYPE,CLIENT_ACCOUNT_CODE,INSTRUMENT_TYPE,SYMBOL,                          
EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,CA_LEVEL,BROUGHT_FORWARD_LONG_QUANTITY,BROUGHT_FORWARD_LONG_VALUE,                          
BROUGHT_FORWARD_SHORT_QUANTITY,BROUGHT_FORWARD_SHORT_VALUE,DAY_BUY_OPEN_QUANTITY,DAY_BUY_OPEN_VALUE,                          
DAY_SELL_OPEN_QUANTITY,DAY_SELL_OPEN_VALUE,PRE_EX_ASGMNT_LONG_QUANTITY,PRE_EX_ASGMNT_LONG_VALUE,                          
PRE_EX_ASGMNT_SHORT_QUANTITY,PRE_EX_ASGMNT_SHORT_VALUE,EXERCISED_QUANTITY,ASSIGNED_QUANTITY,                          
POST_EX_ASGMNT_LONG_QUANTITY,POST_EX_ASGMNT_LONG_VALUE,POST_EX_ASGMNT_SHORT_QUANTITY,POST_EX_ASGMNT_SHORT_VALUE,                                      
SETTLEMENT_PRICE,NET_PREMIUM,DAILY_MTM_SETTLEMENT_VALUE,FUTURES_FINAL_SETTLEMENT_VALUE,                          
EXERCISED_ASSIGNED_VALUE                           
FROM TBL_NSECURR_00220 (NOLOCK)                                                
                          
                          
                          
DELETE FROM TBL_temp_NSECURR_ps03                            
WHERE POSITION_DATE = @FDATE                           
                          
                          
                          
                          
SELECT CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,                                    
EXPIRY_DATE=CONVERT(DATETIME,SUBSTRING(EXPIRY_DATE,4,3)+' '+SUBSTRING(EXPIRY_DATE,1,2)+' '+SUBSTRING(EXPIRY_DATE,8,4)+' 23:59')                                    
,STRIKE_PRICE,OPTION_TYPE,        
        
CASE WHEN SYMBOL='JPYINR' THEN        
(        
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                                   
POST_EX_ASGMNT_LONG_QUANTITY*1000 END        
)        
ELSE        
(        
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                                   
POST_EX_ASGMNT_LONG_QUANTITY*1000 END        
)        
END AS NET,POSITION_DATE                                     
INTO #FILE1X                 
FROM NSECURRPSO3 X (NOLOCK) WHERE POSITION_DATE = @FDATE AND                                                   
ACCOUNT_TYPE = 'C'                             
        
        
        
        
        
                          
                          
SELECT PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE,NQTY=SUM(PQTY-SQTY)                            
INTO #FILE2X                                     
FROM  AngelFO.NSECURFO.DBO.FOBILLVALAN WHERE SAUDA_DATE = @FDATE + ' 23:59:00'                                    
GROUP BY PARTY_CODE,SYMBOL,OPTION_TYPE,STRIKE_PRICE,INST_TYPE,EXPIRYDATE                                   
                          
                    
                          
                          
INSERT INTO TBL_temp_NSECURR_ps03                          
SELECT * FROM                          
(                                                  
SELECT 'NOT IN BO' AS STATUS,CLIENT_ACCOUNT_CODE,SYMBOL,INSTRUMENT_TYPE,EXPIRY_DATE,STRIKE_PRICE,OPTION_TYPE,NET,POSITION_DATE                                     
FROM #FILE1X  X (NOLOCK)                                     
WHERE NOT EXISTS                      
(SELECT * FROM  #FILE2X Y                                     
WHERE X.CLIENT_ACCOUNT_CODE = Y.PARTY_CODE AND X.SYMBOL = Y.SYMBOL AND X.EXPIRY_DATE=Y.EXPIRYDATE AND X.INSTRUMENT_TYPE=Y.INST_TYPE                                     
AND REPLACE(X.OPTION_TYPE,'FF','')=Y.OPTION_TYPE AND X.NET=Y.NQTY)                                      
) Y WHERE NET <> 0                            
                          
                          
SELECT 'NOT IN NSE-CURR' AS STATUS,PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,                                                  
CONVERT(VARCHAR,STRIKE_PRICE) AS STRIKE_PRICE,OPTION_TYPE,SUM(PQTY)-SUM(SQTY) AS 'NET',                                                  
UPDATEDATE                   
INTO #FILE1                   
FROM AngelFO.NSECURFO.DBO.FOBILLVALAN                   
WHERE                                                  
SAUDA_DATE >= @FDATE AND SAUDA_DATE <= @FDATE + ' 23:59:59'                                                 
GROUP BY PARTY_CODE,SYMBOL,INST_TYPE,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,UPDATEDATE                           
having (SUM(PQTY)-SUM(SQTY))<>0          
                          
                          
                          
SELECT CLIENT_ACCOUNT_CODE,SYMBOL,      
CASE WHEN SYMBOL = 'JPYINR' THEN            
(                                      
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                                   
POST_EX_ASGMNT_LONG_QUANTITY*1000 END       
)      
ELSE      
(      
CASE WHEN POST_EX_ASGMNT_LONG_QUANTITY = 0 THEN (POST_EX_ASGMNT_SHORT_QUANTITY*-1)*1000 ELSE                                                   
POST_EX_ASGMNT_LONG_QUANTITY*1000 END       
)      
END AS NET      
      
INTO #FILE2                                      
FROM NSECURRPSO3 Y (NOLOCK)                   
WHERE POSITION_DATE = @FDATE                                                  
                          
                          
                          
                          
INSERT INTO TBL_temp_NSECURR_ps03                                                  
SELECT  DISTINCT A.STATUS,A.PARTY_CODE,A.SYMBOL,A.INST_TYPE,A.EXPIRYDATE,A.STRIKE_PRICE,A.OPTION_TYPE,NET=B.NET_QTY,A.UPDATEDATE FROM                                      
(                                      
SELECT * FROM                                       
(                                      
SELECT X.*,Y.CLIENT_ACCOUNT_CODE,YNET=Y.NET                                      
FROM                                       
 (SELECT * FROM #FILE1 /*WHERE SYMBOL='DLF' AND PARTY_CODE='D8243'*/) X                                       
LEFT OUTER JOIN                                       
 (SELECT * FROM #FILE2) Y                                       
ON (X.SYMBOL=ISNULL(Y.SYMBOL,'~!@#') AND X.PARTY_CODE=ISNULL(Y.CLIENT_ACCOUNT_CODE,'~!@#') AND CONVERT(INT,X.NET) = CONVERT(INT,ISNULL(Y.NET,-1)))                                      
) Z                        
WHERE CLIENT_ACCOUNT_CODE IS NULL                                      
) A,                                       
(                                      
SELECT * FROM TBL_temp_NSECURR_ps03 WHERE STATUS= 'NOT IN BO'                                       
AND CONVERT(DATETIME,POSITION_DATE,100)=CONVERT(VARCHAR,@FDATE,101)                                       
) B WHERE A.SYMBOL=B.SYMBOL                                      
                          
                          
                          
EXEC USP_TRD_NSECURR_CHANGES @FDATE                            
                          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPload_Position_File
-- --------------------------------------------------
CREATE Proc [dbo].[USP_UPload_Position_File]                        
/*(@filename as varchar(100))*/                                 
as                        
                        
set transaction  isolation  level read uncommitted                          
                        
/*Exec oldintranet.upload.dbo.USP_bulkupload_postionfile /*@filename*/*/                        
                        
declare @path as varchar(100)                                
declare @sql as varchar(1000)                                    
                        
truncate table tbl_nseps03                        
                        
set @path='\\INHOUSEALLAPP-FS.angelone.in\upload1\F_PS03_12798_'+REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/','')+'.CSV'                        
SET @SQL = 'BULK INSERT tbl_nseps03 FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=1,KeepNULLS)'                                
exec (@sql)                         
                        
declare @fdate as varchar(11)                        
set @fdate = (select distinct convert(varchar(11),convert(datetime,position_date)) from tbl_nseps03 (nolock))                        
          
          
delete nseps03_hist where position_date IN  (SELECT TOP 1 POSITION_dATE FROM nseps03)          
INSERT into nseps03_hist SELECT * from nseps03          
      
      
TRUNCATE TABLE   nseps03          
--delete nseps03 where position_date = @fdate                        
                        
insert into nseps03                        
select convert(varchar(11),convert(datetime,Position_Date)),Segment_Indicator,Settlement_Type,Clearing_Member_Code,Member_Type,Trading_Member_Code,Account_Type,Client_Account_Code,Instrument_Type,Symbol,Expiry_date,Strike_Price,Option_Type,CA_Level,      
  
    
        
Brought_Forward_Long_Quantity,Brought_Forward_Long_Value,Brought_Forward_Short_Quantity,Brought_Forward_Short_Value,Day_Buy_Open_Quantity,Day_Buy_Open_Value,Day_Sell_Open_Quantity,Day_Sell_Open_Value,Pre_Ex_Asgmnt_Long_Quantity,              
Pre_Ex_Asgmnt_Long_Value,Pre_Ex_Asgmnt_Short_Quantity,Pre_Ex_Asgmnt_Short_Value,Exercised_Quantity,Assigned_Quantity,Post_Ex_Asgmnt_Long_Quantity,Post_Ex_Asgmnt_Long_Value,Post_Ex_Asgmnt_Short_Quantity,Post_Ex_Asgmnt_Short_Value,              
Settlement_Price,Net_Premium,Daily_MTM_Settlement_Value,Futures_Final_Settlement_Value,Exercised_Assigned_Value from tbl_nseps03 (nolock)                        
                          
delete temp_ps03 where position_date = @fdate                          
            
            
-------------- New Process modified by Manesh mukherjee on 28-03-2008            
            
SELECT Client_Account_Code,Symbol,Instrument_Type,            
Expiry_date=convert(datetime,substring(expiry_DAte,4,3)+' '+substring(expiry_DAte,1,2)+' '+substring(expiry_DAte,8,4)+' 23:59')            
,Strike_Price,Option_Type,                          
case when Post_Ex_Asgmnt_Long_Quantity = 0 then Post_Ex_Asgmnt_Short_Quantity*-1 else                           
Post_Ex_Asgmnt_Long_Quantity end as  Net,Position_Date             
INTO #FILE1x            
from nseps03 x (nolock) where position_date = @fdate and                           
Account_Type = 'C'            
            
            
select Party_Code,symbol,option_type,Strike_price,inst_type,expirydate,NQty=sum(Pqty-Sqty)  into #file2x             
from  angelfo.nsefo.dbo.fobillvalan WHERE sauda_date = @fdate + ' 23:59:00'            
group by Party_Code,symbol,option_type,Strike_price,inst_type,expirydate            
            
            
insert into temp_ps03            
select * from                           
(                          
select 'NOT IN BO' as Status,Client_Account_Code,Symbol,Instrument_Type,Expiry_date,Strike_Price,Option_Type,Net,Position_Date             
from #FILE1x  x (nolock)             
where not exists             
(select * from  #file2x y             
where x.Client_Account_Code = y.Party_Code and x.Symbol = y.Symbol  and x.expiry_date=y.expirydate and x.instrument_type=y.inst_type          
and replace(x.option_type,'FF','')=y.option_type and x.net=y.nqty)              
) y where net <> 0            
            
            
/*                          
insert into temp_ps03                      
select * from                           
(                          
select 'NOT IN BO' as Status,Client_Account_Code,Symbol,Instrument_Type,Expiry_date,Strike_Price,Option_Type,                          
case when Post_Ex_Asgmnt_Long_Quantity = 0 then Post_Ex_Asgmnt_Short_Quantity*-1 else                          
Post_Ex_Asgmnt_Long_Quantity end as  Net,Position_Date from nseps03 x (nolock) where position_date = @fdate and                  
Account_Type = 'C' and not exists (select * from  angelfo.nsefo.dbo.fobillvalan y where y.sauda_date >= @fdate                           
and y.sauda_date <= @fdate + ' 23:59:59' and x.Client_Account_Code = y.Party_Code and x.Symbol = y.Symbol)                          
) x where Net <> 0                     
*/                          
              
----------------------- NOT IN NSE              
              
select 'NOT IN NSE' as Status,Party_Code,Symbol,Inst_type,Expirydate,                          
convert(varchar,Strike_Price) as Strike_Price,Option_type,sum(PQty)-sum(SQty) as Net,                          
UpdateDate into #file1 from angelfo.nsefo.dbo.fobillvalan where                          
sauda_date >= @fdate and sauda_date <= @fdate + ' 23:59:59'                          
group by Party_Code,Symbol,Inst_type,Expirydate,Strike_Price,Option_type,UpdateDate                          
              
select Client_Account_Code,Symbol,case when Post_Ex_Asgmnt_Long_Quantity = 0 then Post_Ex_Asgmnt_Short_Quantity*-1 else                           
Post_Ex_Asgmnt_Long_Quantity end as  Net into #file2              
from nseps03 y (nolock) where position_date = @fdate                          
              
insert into temp_ps03                          
select  distinct a.Status,a.Party_Code,a.Symbol,a.Inst_type,a.Expirydate,a.Strike_Price,a.Option_type,Net=b.net_qty,a.UpdateDate from              
(              
select * from               
(              
select x.*,y.client_account_Code,ynet=y.net              
from               
(select * from #file1 /*where symbol='DLF' and party_Code='D8243'*/) x               
left outer join               
(              
select * from #file2 /*where symbol='DLF' and Client_Account_Code='8243'*/              
--where symbol in (select symbol from #file1)              
) y               
on (x.symbol=isnull(y.symbol,'~!@#') and x.party_code=isnull(y.Client_Account_Code,'~!@#') and convert(int,x.net) = convert(int,isnull(y.net,-1)))              
) z              
where Client_Account_Code is null              
) a,               
(              
select * from temp_ps03 where Status= 'NOT IN BO'               
and convert(datetime,position_date,100)=convert(varchar,@fdate,101)               
) b where a.symbol=b.symbol              
              
              
              
              
              
/*              
insert into temp_ps03                          
select * from                           
(                          
select 'NOT IN NSE' as Status,Party_Code,Symbol,Inst_type,Expirydate,                          
convert(varchar,Strike_Price) as Strike_Price,Option_type,sum(PQty)-sum(SQty) as Net,                          
UpdateDate from angelfo.nsefo.dbo.fobillvalan where                          
sauda_date >= @fdate and sauda_date <= @fdate + ' 23:59:59'                          
group by Party_Code,Symbol,Inst_type,Expirydate,Strike_Price,Option_type,UpdateDate                          
) X where not exists                          
(                          
select * from                           
(                          
select Client_Account_Code,Symbol,case when Post_Ex_Asgmnt_Long_Quantity = 0 then Post_Ex_Asgmnt_Short_Quantity*-1 else                           
Post_Ex_Asgmnt_Long_Quantity end as  Net from nseps03 y (nolock) where position_date = @fdate                          
) y where (x.Party_Code = y.Client_Account_Code and x.Symbol = y.Symbol) or (x.Net <> y.net))/* and net <> 0 */                         
*/              
                    
-------------------------------Trade changes in backoffice----------------                     
exec USP_TRD_CHANGES @fdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPJV_TradeUpload_FO
-- --------------------------------------------------
CREATE proc [dbo].[USPJV_TradeUpload_FO]                   
as                            
set transaction  isolation  level read uncommitted                            
                
declare @filename as varchar(100)                        
declare @path as varchar(100)                        
declare @sql as varchar(1000)                    
declare @cnt as int                
                
set @filename = (select replace(convert(varchar(15),getdate(),103),'/','') + '_12798.txt')                
                  
truncate table fotrd                
                        
--set @path='\\INHOUSEALLAPP-FS.angelone.in\d$\upload1\FoTrade\' + @filename                        
set @path='\\INHOUSELIVEAPP2-FS.angelone.in\d$\upload1\FoTrade\' + @filename                        
SET @SQL = 'BULK INSERT fotrd FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=1,KeepNULLS)'                
exec (@sql)                        
                
truncate table tbl_upd                
set @cnt = (select Total=count(*) from fotrd)                
                
insert into tbl_upd values (getdate(),@cnt)

GO

-- --------------------------------------------------
-- TABLE dbo.AlternateBranchSB
-- --------------------------------------------------
CREATE TABLE [dbo].[AlternateBranchSB]
(
    [alt_Exchange] VARCHAR(8) NOT NULL,
    [alt_termid] VARCHAR(15) NULL,
    [alt_BranchSB] VARCHAR(25) NULL,
    [alt_BranchSBCode] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bofficeps03
-- --------------------------------------------------
CREATE TABLE [dbo].[bofficeps03]
(
    [Party_Code] CHAR(11) NULL,
    [Party_Name] CHAR(22) NULL,
    [cli_type] CHAR(5) NULL,
    [Symbol] CHAR(11) NULL,
    [Inst_type] CHAR(7) NULL,
    [Exp_date] CHAR(10) NULL,
    [Strike_price] CHAR(5) NULL,
    [Option_type] CHAR(6) NULL,
    [BuyQty] CHAR(7) NULL,
    [Buy_Rate] CHAR(16) NULL,
    [Selqty] CHAR(7) NULL,
    [Sell_Rate] CHAR(16) NULL,
    [NETQty] CHAR(7) NULL,
    [Net_Value] CHAR(16) NULL,
    [Avg_Price] CHAR(16) NULL,
    [Net_Cl_Val] CHAR(16) NULL,
    [Cl_Price] CHAR(16) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bofficeps03_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[bofficeps03_hist]
(
    [Party_Code] CHAR(11) NULL,
    [Party_Name] CHAR(22) NULL,
    [cli_type] CHAR(5) NULL,
    [Symbol] CHAR(11) NULL,
    [Inst_type] CHAR(7) NULL,
    [Exp_date] CHAR(10) NULL,
    [Strike_price] CHAR(5) NULL,
    [Option_type] CHAR(6) NULL,
    [BuyQty] CHAR(7) NULL,
    [Buy_Rate] CHAR(16) NULL,
    [Selqty] CHAR(7) NULL,
    [Sell_Rate] CHAR(16) NULL,
    [NETQty] CHAR(7) NULL,
    [Net_Value] CHAR(16) NULL,
    [Avg_Price] CHAR(16) NULL,
    [Net_Cl_Val] CHAR(16) NULL,
    [Cl_Price] CHAR(16) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clrates
-- --------------------------------------------------
CREATE TABLE [dbo].[clrates]
(
    [type] VARCHAR(25) NULL,
    [inst_type] VARCHAR(25) NULL,
    [symbol] VARCHAR(50) NULL,
    [expirydate] VARCHAR(25) NULL,
    [strike_price] VARCHAR(25) NULL,
    [option_type] VARCHAR(25) NULL,
    [cl_price] VARCHAR(25) NULL,
    [Col008] VARCHAR(25) NULL,
    [Col009] VARCHAR(25) NULL,
    [Col010] VARCHAR(25) NULL,
    [cl_price1] VARCHAR(25) NULL,
    [Col012] VARCHAR(25) NULL,
    [Col013] VARCHAR(25) NULL,
    [Col014] VARCHAR(25) NULL,
    [Col015] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.currency_termid_list
-- --------------------------------------------------
CREATE TABLE [dbo].[currency_termid_list]
(
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL,
    [user_email] VARCHAR(100) NULL,
    [user_emailcc] VARCHAR(100) NULL,
    [contact_person] VARCHAR(250) NULL,
    [contact_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.currencyFoTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[currencyFoTemp]
(
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(25) NULL,
    [Span] MONEY NULL,
    [Premium] MONEY NULL,
    [span_prem] MONEY NULL,
    [Mtm_Value] MONEY NULL,
    [Cl_Type] VARCHAR(25) NULL,
    [Collected] MONEY NULL,
    [Shortage] MONEY NULL,
    [Error_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CurrencyMarginShortage_JV
-- --------------------------------------------------
CREATE TABLE [dbo].[CurrencyMarginShortage_JV]
(
    [SRNO] BIGINT NULL,
    [VDATE] VARCHAR(11) NULL,
    [EDATE] VARCHAR(11) NULL,
    [CLTCODE] VARCHAR(25) NOT NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(21, 2) NULL,
    [NARRATION] VARCHAR(250) NULL,
    [BRANCHCODE] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_error_report
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_error_report]
(
    [party_code] VARCHAR(20) NULL,
    [pcode_branch_cd] VARCHAR(10) NULL,
    [pcode_sub_broker] VARCHAR(10) NULL,
    [termid] VARCHAR(20) NULL,
    [termid_branch_cd] VARCHAR(10) NULL,
    [termid_sub_broker] VARCHAR(10) NULL,
    [termid_branch_cd_alt] VARCHAR(10) NULL,
    [termid_sub_broker_alt] VARCHAR(10) NULL,
    [remark] VARCHAR(255) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_termid_list
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_termid_list]
(
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL,
    [user_email] VARCHAR(100) NULL,
    [user_emailcc] VARCHAR(100) NULL,
    [contact_person] VARCHAR(250) NULL,
    [contact_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGINSHORTAGE_JV
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGINSHORTAGE_JV]
(
    [SRNO] BIGINT NULL,
    [VDATE] VARCHAR(11) NULL,
    [EDATE] VARCHAR(11) NULL,
    [CLTCODE] VARCHAR(25) NOT NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [AMOUNT] DECIMAL(21, 2) NULL,
    [NARRATION] VARCHAR(250) NULL,
    [BRANCHCODE] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[fotrd]
(
    [scripno] VARCHAR(50) NULL,
    [svalue11] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Sec_name] VARCHAR(50) NULL,
    [svalue1] VARCHAR(50) NULL,
    [svalue_1] VARCHAR(50) NULL,
    [termid] VARCHAR(50) NULL,
    [termid_location] VARCHAR(50) NULL,
    [Sell_buy] VARCHAR(50) NULL,
    [Tradeqty] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokerid] VARCHAR(50) NULL,
    [svalue10] VARCHAR(50) NULL,
    [sauda_date] VARCHAR(50) NULL,
    [sauda_date1] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [svaluenil] VARCHAR(50) NULL,
    [order_time] VARCHAR(25) NULL,
    [ctclid] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledgertrial
-- --------------------------------------------------
CREATE TABLE [dbo].[ledgertrial]
(
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [acname] VARCHAR(35) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NULL,
    [refno] CHAR(12) NULL,
    [balamt] MONEY NULL,
    [cdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.margin_short
-- --------------------------------------------------
CREATE TABLE [dbo].[margin_short]
(
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(25) NULL,
    [Span] MONEY NULL,
    [Premium] MONEY NULL,
    [span_prem] MONEY NULL,
    [Mtm_Value] MONEY NULL,
    [Cl_Type] VARCHAR(25) NULL,
    [Collected] MONEY NULL,
    [Shortage] MONEY NULL,
    [Error_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCx_Sortage
-- --------------------------------------------------
CREATE TABLE [dbo].[MCx_Sortage]
(
    [sauda_date] DATETIME NULL,
    [batch_no] INT NULL,
    [member_code] INT NULL,
    [client_tag] VARCHAR(20) NULL,
    [Party_code] VARCHAR(20) NULL,
    [span_margin] MONEY NULL,
    [exp_margin] MONEY NULL,
    [reserved1] MONEY NULL,
    [reserved2] MONEY NULL,
    [fsm] MONEY NULL,
    [total_margin] MONEY NULL,
    [collection] MONEY NULL,
    [shortage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcxMarginShortage_JV
-- --------------------------------------------------
CREATE TABLE [dbo].[mcxMarginShortage_JV]
(
    [SRNO] BIGINT NULL,
    [VDATE] VARCHAR(11) NULL,
    [EDATE] VARCHAR(11) NULL,
    [CLTCODE] VARCHAR(25) NOT NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(21, 2) NULL,
    [NARRATION] VARCHAR(250) NULL,
    [BRANCHCODE] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXPSO3
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXPSO3]
(
    [Position_Date] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(225) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL,
    [RESERVED] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXSXPSO3
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXSXPSO3]
(
    [Position_Date] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(225) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL,
    [RESERVED] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEXPSO3
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEXPSO3]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Settlement_Price] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Futures_Final_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.netpos_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[netpos_temp]
(
    [party_code] CHAR(11) NULL,
    [inst_type] CHAR(10) NULL,
    [symbol] CHAR(13) NULL,
    [sec_name] CHAR(66) NULL,
    [expirydate] CHAR(12) NULL,
    [pqty] INT NULL,
    [sqty] INT NULL,
    [strike_price] CHAR(14) NULL,
    [option_type] CHAR(10) NULL,
    [price] CHAR(8) NULL,
    [clrate] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfosettlement
-- --------------------------------------------------
CREATE TABLE [dbo].[newfosettlement]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] DATETIME NULL,
    [Strike_price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
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
    [Status] VARCHAR(2) NULL,
    [CpId] INT NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd_closing
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd_closing]
(
    [tradeno] VARCHAR(50) NULL,
    [svalue11] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Sec_name] VARCHAR(50) NULL,
    [svalue1] VARCHAR(50) NULL,
    [svalue_1] VARCHAR(50) NULL,
    [termid] VARCHAR(50) NULL,
    [termid_location] VARCHAR(50) NULL,
    [Sell_buy] VARCHAR(50) NULL,
    [Tradeqty] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokerid] VARCHAR(50) NULL,
    [svalue10] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(50) NULL,
    [svaluenil] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd_error
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd_error]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd_temp]
(
    [tradeno] VARCHAR(50) NULL,
    [svalue11] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Sec_name] VARCHAR(50) NULL,
    [svalue1] VARCHAR(50) NULL,
    [svalue_1] VARCHAR(50) NULL,
    [termid] VARCHAR(50) NULL,
    [termid_location] VARCHAR(50) NULL,
    [Sell_buy] VARCHAR(50) NULL,
    [Tradeqty] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokerid] VARCHAR(50) NULL,
    [svalue10] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(50) NULL,
    [svaluenil] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd1
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd1]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrdbackup
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrdbackup]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrdbackup1
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrdbackup1]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newtermid
-- --------------------------------------------------
CREATE TABLE [dbo].[newtermid]
(
    [termid] VARCHAR(15) NULL,
    [party_code] VARCHAR(15) NULL,
    [party_name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSECURRPSO3
-- --------------------------------------------------
CREATE TABLE [dbo].[NSECURRPSO3]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Settlement_Price] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Futures_Final_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nseps03
-- --------------------------------------------------
CREATE TABLE [dbo].[nseps03]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] FLOAT NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] FLOAT NULL,
    [Brought_Forward_Long_Value] FLOAT NULL,
    [Brought_Forward_Short_Quantity] FLOAT NULL,
    [Brought_Forward_Short_Value] FLOAT NULL,
    [Day_Buy_Open_Quantity] FLOAT NULL,
    [Day_Buy_Open_Value] FLOAT NULL,
    [Day_Sell_Open_Quantity] FLOAT NULL,
    [Day_Sell_Open_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Exercised_Quantity] FLOAT NULL,
    [Assigned_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Settlement_Price] FLOAT NULL,
    [Net_Premium] FLOAT NULL,
    [Daily_MTM_Settlement_Value] FLOAT NULL,
    [Futures_Final_Settlement_Value] FLOAT NULL,
    [Exercised_Assigned_Value] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nseps03_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[nseps03_hist]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] FLOAT NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] FLOAT NULL,
    [Brought_Forward_Long_Value] FLOAT NULL,
    [Brought_Forward_Short_Quantity] FLOAT NULL,
    [Brought_Forward_Short_Value] FLOAT NULL,
    [Day_Buy_Open_Quantity] FLOAT NULL,
    [Day_Buy_Open_Value] FLOAT NULL,
    [Day_Sell_Open_Quantity] FLOAT NULL,
    [Day_Sell_Open_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Exercised_Quantity] FLOAT NULL,
    [Assigned_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Settlement_Price] FLOAT NULL,
    [Net_Premium] FLOAT NULL,
    [Daily_MTM_Settlement_Value] FLOAT NULL,
    [Futures_Final_Settlement_Value] FLOAT NULL,
    [Exercised_Assigned_Value] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception]
(
    [party_code] VARCHAR(30) NULL,
    [segment] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception_currency
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception_currency]
(
    [party_code] VARCHAR(30) NULL,
    [segment] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POSITIONFILE_SEGMENT
-- --------------------------------------------------
CREATE TABLE [dbo].[POSITIONFILE_SEGMENT]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [SEGMENT] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POSITIONFILE_UPLOADED_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[POSITIONFILE_UPLOADED_DATA]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MISMATCH] CHAR(1) NULL,
    [UPLOAD_DATETIME] VARCHAR(20) NULL,
    [UPLOADED_BY] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MCX_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MCX_HIST]
(
    [Position_Date] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(225) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL,
    [RESERVED] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MCX_trdchanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MCX_trdchanges]
(
    [status] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] VARCHAR(11) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(MAX) NULL,
    [buy] INT NULL,
    [sell] INT NULL,
    [Fld_date] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MCXSX_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MCXSX_HIST]
(
    [Position_Date] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(225) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL,
    [RESERVED] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MCXSX_trdchanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MCXSX_trdchanges]
(
    [status] VARCHAR(15) NULL,
    [party_code] VARCHAR(10) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] VARCHAR(11) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(MAX) NULL,
    [buy] INT NULL,
    [sell] INT NULL,
    [Fld_date] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NCDEX_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NCDEX_HIST]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Settlement_Price] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Futures_Final_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NCDEX_trdchanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NCDEX_trdchanges]
(
    [status] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] VARCHAR(11) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(MAX) NULL,
    [buy] INT NULL,
    [sell] INT NULL,
    [Fld_date] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NSECURR_00220
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NSECURR_00220]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] DECIMAL(15, 2) NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] DECIMAL(15, 2) NULL,
    [Brought_Forward_Long_Value] DECIMAL(15, 2) NULL,
    [Brought_Forward_Short_Quantity] DECIMAL(15, 2) NULL,
    [Brought_Forward_Short_Value] DECIMAL(15, 2) NULL,
    [Day_Buy_Open_Quantity] DECIMAL(15, 2) NULL,
    [Day_Buy_Open_Value] DECIMAL(15, 2) NULL,
    [Day_Sell_Open_Quantity] DECIMAL(15, 2) NULL,
    [Day_Sell_Open_Value] DECIMAL(15, 2) NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] DECIMAL(15, 2) NULL,
    [Pre_Ex_Asgmnt_Long_Value] DECIMAL(15, 2) NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] DECIMAL(15, 2) NULL,
    [Pre_Ex_Asgmnt_Short_Value] DECIMAL(15, 2) NULL,
    [Exercised_Quantity] DECIMAL(15, 2) NULL,
    [Assigned_Quantity] DECIMAL(15, 2) NULL,
    [Post_Ex_Asgmnt_Long_Quantity] DECIMAL(15, 2) NULL,
    [Post_Ex_Asgmnt_Long_Value] DECIMAL(15, 2) NULL,
    [Post_Ex_Asgmnt_Short_Quantity] DECIMAL(15, 2) NULL,
    [Post_Ex_Asgmnt_Short_Value] DECIMAL(15, 2) NULL,
    [Settlement_Price] DECIMAL(15, 2) NULL,
    [Net_Premium] DECIMAL(15, 2) NULL,
    [Daily_MTM_Settlement_Value] DECIMAL(15, 2) NULL,
    [Futures_Final_Settlement_Value] DECIMAL(15, 2) NULL,
    [Exercised_Assigned_Value] DECIMAL(15, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NSECURR_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NSECURR_HIST]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] REAL NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] REAL NULL,
    [Brought_Forward_Long_Value] REAL NULL,
    [Brought_Forward_Short_Quantity] REAL NULL,
    [Brought_Forward_Short_Value] REAL NULL,
    [Day_Buy_Open_Quantity] REAL NULL,
    [Day_Buy_Open_Value] REAL NULL,
    [Day_Sell_Open_Quantity] REAL NULL,
    [Day_Sell_Open_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Long_Value] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Pre_Ex_Asgmnt_Short_Value] REAL NULL,
    [Exercised_Quantity] REAL NULL,
    [Assigned_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Long_Value] REAL NULL,
    [Post_Ex_Asgmnt_Short_Quantity] REAL NULL,
    [Post_Ex_Asgmnt_Short_Value] REAL NULL,
    [Settlement_Price] REAL NULL,
    [Net_Premium] REAL NULL,
    [Daily_MTM_Settlement_Value] REAL NULL,
    [Futures_Final_Settlement_Value] REAL NULL,
    [Exercised_Assigned_Value] REAL NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECURR_trdchanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECURR_trdchanges]
(
    [status] VARCHAR(20) NULL,
    [party_code] VARCHAR(10) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] VARCHAR(11) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(MAX) NULL,
    [buy] INT NULL,
    [sell] INT NULL,
    [Fld_date] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nseps03
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nseps03]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] FLOAT NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] FLOAT NULL,
    [Brought_Forward_Long_Value] FLOAT NULL,
    [Brought_Forward_Short_Quantity] FLOAT NULL,
    [Brought_Forward_Short_Value] FLOAT NULL,
    [Day_Buy_Open_Quantity] FLOAT NULL,
    [Day_Buy_Open_Value] FLOAT NULL,
    [Day_Sell_Open_Quantity] FLOAT NULL,
    [Day_Sell_Open_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Exercised_Quantity] FLOAT NULL,
    [Assigned_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Settlement_Price] FLOAT NULL,
    [Net_Premium] FLOAT NULL,
    [Daily_MTM_Settlement_Value] FLOAT NULL,
    [Futures_Final_Settlement_Value] FLOAT NULL,
    [Exercised_Assigned_Value] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nseps03_25082019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nseps03_25082019]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] FLOAT NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] FLOAT NULL,
    [Brought_Forward_Long_Value] FLOAT NULL,
    [Brought_Forward_Short_Quantity] FLOAT NULL,
    [Brought_Forward_Short_Value] FLOAT NULL,
    [Day_Buy_Open_Quantity] FLOAT NULL,
    [Day_Buy_Open_Value] FLOAT NULL,
    [Day_Sell_Open_Quantity] FLOAT NULL,
    [Day_Sell_Open_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Exercised_Quantity] FLOAT NULL,
    [Assigned_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Settlement_Price] FLOAT NULL,
    [Net_Premium] FLOAT NULL,
    [Daily_MTM_Settlement_Value] FLOAT NULL,
    [Futures_Final_Settlement_Value] FLOAT NULL,
    [Exercised_Assigned_Value] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_temp_MCX_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_temp_MCX_ps03]
(
    [Status] VARCHAR(50) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_temp_MCXSX_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_temp_MCXSX_ps03]
(
    [Status] VARCHAR(50) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_temp_NCDEX_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_temp_NCDEX_ps03]
(
    [Status] VARCHAR(50) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_temp_NSECURR_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_temp_NSECURR_ps03]
(
    [Status] VARCHAR(50) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_trdchanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_trdchanges]
(
    [status] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] VARCHAR(11) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(8000) NULL,
    [buy] INT NOT NULL,
    [sell] INT NOT NULL,
    [Fld_date] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_upd
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_upd]
(
    [upd_time] DATETIME NULL,
    [records] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_fotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_fotrd]
(
    [termid] FLOAT NULL,
    [turnover] FLOAT NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_MISMATCH_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_MISMATCH_DATA]
(
    [Status] VARCHAR(MAX) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ps03]
(
    [Status] VARCHAR(50) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Term_id
-- --------------------------------------------------
CREATE TABLE [dbo].[Term_id]
(
    [Old] VARCHAR(8000) NULL,
    [New] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Term_id_1
-- --------------------------------------------------
CREATE TABLE [dbo].[Term_id_1]
(
    [Old] VARCHAR(8000) NULL,
    [New] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.termid_mapping
-- --------------------------------------------------
CREATE TABLE [dbo].[termid_mapping]
(
    [new_termid] VARCHAR(15) NULL,
    [old_termid] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trade15
-- --------------------------------------------------
CREATE TABLE [dbo].[trade15]
(
    [Col001] VARCHAR(50) NULL,
    [Col002] VARCHAR(50) NULL,
    [Col003] VARCHAR(50) NULL,
    [Col004] VARCHAR(50) NULL,
    [Col005] VARCHAR(50) NULL,
    [Col006] VARCHAR(50) NULL,
    [Col007] VARCHAR(50) NULL,
    [Col008] VARCHAR(50) NULL,
    [Col009] VARCHAR(50) NULL,
    [Col010] VARCHAR(50) NULL,
    [Col011] VARCHAR(50) NULL,
    [Col012] VARCHAR(50) NULL,
    [Col013] VARCHAR(50) NULL,
    [Col014] VARCHAR(50) NULL,
    [Col015] VARCHAR(50) NULL,
    [Col016] VARCHAR(50) NULL,
    [Col017] VARCHAR(50) NULL,
    [Col018] VARCHAR(50) NULL,
    [Col019] VARCHAR(50) NULL,
    [Col020] VARCHAR(50) NULL,
    [Col021] VARCHAR(50) NULL,
    [Col022] VARCHAR(50) NULL,
    [Col023] VARCHAR(50) NULL
);

GO

