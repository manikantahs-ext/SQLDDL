-- DDL Export
-- Server: 10.253.33.232
-- Database: INHOUSE
-- Exported: 2026-02-05T12:29:21.013833

USE INHOUSE;
GO

-- --------------------------------------------------
-- FUNCTION dbo.PIECE
-- --------------------------------------------------
  
   
  
   
  
CREATE FUNCTION [dbo].[PIECE] ( @CHARACTEREXPRESSION VARCHAR(8000), @DELIMITER CHAR(1), @POSITION INTEGER)  
  
RETURNS VARCHAR(8000)  
  
AS  
  
BEGIN  
  
      IF @POSITION<1 RETURN NULL  
  
      IF LEN(@DELIMITER)<>1 RETURN NULL  
  
      DECLARE @START INTEGER  
  
      SET @START=1  
  
      WHILE @POSITION>1  
  
            BEGIN  
  
                  SET @START=ISNULL(CHARINDEX(@DELIMITER, @CHARACTEREXPRESSION, @START),0)  
  
                  IF @START=0 RETURN NULL  
  
                  SET @POSITION= @POSITION-1  
  
                  SET @START=@START+1  
  
            END  
  
      DECLARE @END INTEGER  
  
      SET @END= ISNULL(CHARINDEX(@DELIMITER, @CHARACTEREXPRESSION, @START),0)  
  
      IF @END=0 SET @END=LEN(@CHARACTEREXPRESSION)+1  
  
      RETURN SUBSTRING(@CHARACTEREXPRESSION, @START, @END-@START)  
  
END

GO

-- --------------------------------------------------
-- INDEX dbo.BAK_Deltrans_report_EXE_21092023
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [CLIIDX] ON [dbo].[BAK_Deltrans_report_EXE_21092023] ([BCltDpId])

GO

-- --------------------------------------------------
-- INDEX dbo.BAK_Deltrans_report_EXE_21092023
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [CLIIDX1] ON [dbo].[BAK_Deltrans_report_EXE_21092023] ([CertNo])

GO

-- --------------------------------------------------
-- INDEX dbo.BAK_Deltrans_report_EXE_21092023
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [CLIIDX2] ON [dbo].[BAK_Deltrans_report_EXE_21092023] ([Party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.BAL_CLIENTDATA_21112023
-- --------------------------------------------------
CREATE CLUSTERED INDEX [CLIIDX1] ON [dbo].[BAL_CLIENTDATA_21112023] ([CLTCODE])

GO

-- --------------------------------------------------
-- INDEX dbo.DP_Holding_Balance
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ix_dt] ON [dbo].[DP_Holding_Balance] ([File_Date], [File_Number])

GO

-- --------------------------------------------------
-- INDEX dbo.DP_Holding_Balance
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Party] ON [dbo].[DP_Holding_Balance] ([BO_ID], [ISIN], [Party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.DP_Holding_Balance_dummy
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ix_dt] ON [dbo].[DP_Holding_Balance_dummy] ([File_Date], [File_Number])

GO

-- --------------------------------------------------
-- INDEX dbo.DP_Holding_Balance_dummy
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Party] ON [dbo].[DP_Holding_Balance_dummy] ([BO_ID], [ISIN], [Party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.E_Dis_Trxn_Data
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_CLient] ON [dbo].[E_Dis_Trxn_Data] ([Partycode], [BOID], [Request_date], [dummy2])

GO

-- --------------------------------------------------
-- INDEX dbo.e_dis_trxn_data_New_stg
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDX_BOID] ON [dbo].[e_dis_trxn_data_New_stg] ([BOID], [dummy2], [ISIN], [CDSL_Response_Id], [Request_Id])

GO

-- --------------------------------------------------
-- INDEX dbo.INVOCATION_STG_AWS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DATE] ON [dbo].[INVOCATION_STG_AWS] ([PARTY_CODE], [TRANSDATE], [ISIN])

GO

-- --------------------------------------------------
-- INDEX dbo.IPO_Raw
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_PARTY] ON [dbo].[IPO_Raw] ([trans_date], [party_code], [isin])

GO

-- --------------------------------------------------
-- INDEX dbo.Non_POA_Hold_Hst
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Ix_dt] ON [dbo].[Non_POA_Hold_Hst] ([Dt_time], [party_code], [isin])

GO

-- --------------------------------------------------
-- INDEX dbo.NON_POA_SMS_DATA
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Sms_Cl] ON [dbo].[NON_POA_SMS_DATA] ([Sett_NO], [sett_type], [PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.SEBI_Colletral
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_SEBIColl_Party] ON [dbo].[SEBI_Colletral] ([Party_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Exch_hold_reporting_archival
-- --------------------------------------------------
ALTER TABLE [dbo].[Exch_hold_reporting_archival] ADD CONSTRAINT [PK__Exch_hol__11A3DB6C151B244E] PRIMARY KEY ([ArchivalID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_BACKUP_PROCESS_STATUS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_BACKUP_PROCESS_STATUS] ADD CONSTRAINT [PK__TBL_BACK__CA1EE06C74AE54BC] PRIMARY KEY ([SNO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_CUSPA_Release_Status
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_CUSPA_Release_Status] ADD CONSTRAINT [PK_CRS] PRIMARY KEY ([transaction_date], [party_code], [pledgee_bo_id], [pledgor_bo_id], [pledge_sequence_number], [isin], [reference_number])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_MARGIN_Release_Status
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_MARGIN_Release_Status] ADD CONSTRAINT [PK_MRS] PRIMARY KEY ([transaction_date], [party_code], [pledgee_bo_id], [pledgor_bo_id], [pledge_sequence_number], [isin], [reference_number])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a
-- --------------------------------------------------

CREATE proc a
(@a as varchar='')
as
begin
print @a
end

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
-- PROCEDURE dbo.AUTO_NON_POA_SMS_PROCESS
-- --------------------------------------------------
  --AUTO_NON_POA_SMS_PROCESS '2021079'
  
CREATE  PROC [dbo].[AUTO_NON_POA_SMS_PROCESS] (@S_NO VARCHAR(11) )  
AS   
  
  BEGIN
  TRUNCATE TABLE NON_POA_SMS_PROCESS_PARA
   INSERT INTO NON_POA_SMS_PROCESS_PARA
   SELECT @S_NO

		EXEC msdb.DBO.SP_START_JOB 'NON_POA_SMS_PROCESS' 
		WAITFOR DELAY '00:1:15'; 
	  
	  SELECT 'PROCESS COMPLETED...!!!' AS STATUS
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CMSVER_SHORTAGE_ONLINE
-- --------------------------------------------------
CREATE PROCEDURE CMSVER_SHORTAGE_ONLINE(@segment as varchar(10))  
AS  
  
set nocount on  
  
declare @SETTMST TABLE(  
SRNO INT,  
SEGMENT VARCHAR(10),  
SETT_TYPE VARCHAR(2),  
SETT_NO VARCHAR(10)  
)  

DECLARE @CTR AS INT = 1, @TOTCNT AS INT = 0,@sett_no AS VARCHAR(10) = '',@sett_type AS VARCHAR(2) = ''  

IF @segment='BSECM'
BEGIN
  
	INSERT INTO @SETTMST  
	SELECT   
	ROW_NUMBER() OVER ( ORDER BY SETT_TYPE,SETT_NO) AS [SrNo] ,   
	Segment='BSECM',SETT_TYPE,SETT_NO        
	FROM bsedb.dbo.sett_mst --(NOLOCK)                               
	WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE()-1)+' 00:00:00'                       
	AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'                      
  
	select @TOTCNT=MAX(SRNO) from @SETTMST  

	truncate table inhouse.dbo.BSECM_shortage_online                   

  
	WHILE @CTR <= @TOTCNT  
	BEGIN  
		select @sett_no=SETT_NO,@sett_type=SETT_TYPE from @SETTMST WHERE SRNO=@CTR  
		exec INHOUSE.DBO.Rpt_Delpayinmatch_online 'broker','BROKER',@sett_no,@sett_type,'%',2                              
		SET @CTR=@CTR + 1  
	END  
END

IF @segment='NSECM'
BEGIN
  
	INSERT INTO @SETTMST  
	SELECT   
	ROW_NUMBER() OVER ( ORDER BY SETT_TYPE,SETT_NO) AS [SrNo] ,   
	Segment='NSECM',SETT_TYPE,SETT_NO        
	FROM MSAJAG.dbo.sett_mst --(NOLOCK)                               
	WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE()-1)+' 00:00:00'                       
	AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'                      
  
	select @TOTCNT=MAX(SRNO) from @SETTMST  

	truncate table inhouse.dbo.NSECM_shortage_online                   
  
	WHILE @CTR <= @TOTCNT  
	BEGIN  
		select @sett_no=SETT_NO,@sett_type=SETT_TYPE from @SETTMST WHERE SRNO=@CTR  
		exec INHOUSE.DBO.Rpt_NSE_Delpayinmatch_online 'broker','BROKER',@sett_no,@sett_type,'%',2                              
		SET @CTR=@CTR + 1  
	END  
END
	  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.current_process
-- --------------------------------------------------
CREATE PROC [dbo].[current_process] (@paraid as int)      
AS      
/*--------------------------------------------------------------------      
Purpose: Shows what individual SQL statements are currently executing.      
----------------------------------------------------------------------      
Parameters: None.      
Revision History:      
 24/07/2008  Ian_Stirk@yahoo.com Initial version      
Example Usage:      
 1. exec YourServerName.master.dbo.dba_WhatSQLIsExecuting                     
---------------------------------------------------------------------*/      
BEGIN      
    -- Do not lock anything, and do not get held up by any locks.      
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
    -- What SQL Statements Are Currently Running?      
    
if @paraid<>0    
BEGIN    
    SELECT [Spid] = session_Id      
 , ecid      
 , [Database] = DB_NAME(sp.dbid)      
 , [User] = nt_username      
 , [Status] = er.status      
 , [Wait] = wait_type      
 , [Individual Query] = SUBSTRING (qt.text,       
             er.statement_start_offset/2,      
 (CASE WHEN er.statement_end_offset = -1      
        THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2      
  ELSE er.statement_end_offset END -       
                                er.statement_start_offset)/2)      
 ,[Parent Query] = qt.text      
 , Program = program_name      
 , Hostname      
 , nt_domain      
 , start_time      
    FROM sys.dm_exec_requests er      
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid      
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)as qt      
    WHERE session_Id > 50              -- Ignore system spids.      
    AND session_Id NOT IN (@@SPID)     -- Ignore this current statement.      
 AND session_id = @paraid    
    ORDER BY 1, 2      
END    
ELSE    
BEGIN    
    SELECT [Spid] = session_Id      
 , ecid      
 , [Database] = DB_NAME(sp.dbid)      
 , [User] = nt_username      
 , [Status] = er.status      
 , [Wait] = wait_type      
 , [Individual Query] = SUBSTRING (qt.text,       
             er.statement_start_offset/2,      
 (CASE WHEN er.statement_end_offset = -1      
        THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2      
  ELSE er.statement_end_offset END -       
                                er.statement_start_offset)/2)      
 ,[Parent Query] = qt.text      
 , Program = program_name      
 , Hostname      
 , nt_domain      
 , start_time      
    FROM sys.dm_exec_requests er      
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid      
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)as qt      
    WHERE session_Id > 50              -- Ignore system spids.      
    AND session_Id NOT IN (@@SPID)     -- Ignore this current statement.      
    ORDER BY 1, 2      
END    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Cusa_Holding_Dtwise
-- --------------------------------------------------


Create Proc Cusa_Holding_Dtwise 
as 
DECLARE @SDATE DATETIME 

SET @SDATE = CONVERT(VARCHAR(11),GETDATE(),120)

DELETE FROM CUSA_HOLDING WHERE PROCESS_DATE >=@SDATE AND PROCESS_DATE <=@SDATE +' 23:59'

INSERT INTO CUSA_HOLDING 
SELECT SETT_NO,PARTY_CODE,CERTNO,SCRIP_CD,SERIES,SUM(QTY) AS QTY ,BCLTDPID,PROCESS_DATE =GETDATE()
FROM MSAJAG.DBO.DELTRANS WHERE DRCR = 'D'  AND DELIVERED = '0' AND BCLTDPID IN ('1203320018512051','20130005') AND FILLER2 ='1'
GROUP BY SETT_NO,PARTY_CODE,CERTNO,SCRIP_CD,SERIES ,BCLTDPID
UNION ALL
SELECT SETT_NO,PARTY_CODE,CERTNO,SCRIP_CD,SERIES,SUM(QTY) AS QTY ,BCLTDPID,PROCESS_DATE =GETDATE()
FROM BSEDB.DBO.DELTRANS WHERE DRCR = 'D'  AND DELIVERED = '0' AND BCLTDPID IN ('1203320018512051','20130005') AND FILLER2 ='1'
GROUP BY SETT_NO,PARTY_CODE,CERTNO,SCRIP_CD,SERIES ,BCLTDPID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DP_HOLD_POA_MKT
-- --------------------------------------------------
         
CREATE PROC [dbo].[DP_HOLD_POA_MKT] --(@SETT_NO VARCHAR(12),@SETT_TYPE VARCHAR(3))          
AS           
          
    
    
SELECT SETT_NO,SETT_TYPE INTO #SETT  FROM MSAJAG.DBO.SETT_MST  WITH(NOLOCK)       
WHERE SEC_PAYIN >=CONVERT(VARCHAR(11),GETDATE(),120)        
AND START_DATE <=CONVERT(VARCHAR(11),GETDATE(),120)        
        
CREATE INDEX #S ON #SETT(SETT_NO,SETT_TYPE)         
      
SELECT DISTINCT M.PARTY_CODE,M.CLTDPNO,I_ISIN INTO #CLT1  FROM MSAJAG.DBO.MULTICLTID M WITH(NOLOCK),          
MSAJAG.DBO.DELIVERYCLT D  WITH(NOLOCK)  ,#SETT S  WITH(NOLOCK)       
WHERE D.SETT_NO=S.SETT_NO  AND D.PARTY_CODE=M.PARTY_CODE AND D.SETT_TYPE=S.SETT_TYPE           
 AND INOUT ='I'        
          
CREATE INDEX #CL ON #CLT1 ( CLTDPNO,I_ISIN)  
 

SELECT BO_ID,ISIN,MAX(FILE_NUMBER)FILE_NUMBER INTO #CN  FROM DP_HOLDING_BALANCE D WITH(NOLOCK)
WHERE EXISTS (SELECT * FROM #CLT1 C WHERE D.BO_ID=C.CLTDPNO )
GROUP BY BO_ID,ISIN

CREATE INDEX #CL1 ON #CN ( BO_ID,ISIN,FILE_NUMBER)

SELECT BO_ID,ISIN,FREE_BALANCE,FILE_DATE INTO #DPHOLD FROM DP_HOLDING_BALANCE D
WHERE EXISTS (SELECT BO_ID FROM #CN C WHERE D.BO_ID=C.BO_ID AND D.ISIN=C.ISIN AND D.FILE_NUMBER=C.FILE_NUMBER )

CREATE INDEX #DP ON #DPHOLD ( BO_ID,ISIN )

          
--SELECT  PARTY_CODE='PARTY',DPID=LEFT(HLD_AC_CODE,8),CLTDPID=HLD_AC_CODE,SCRIP_CD=NULL,SERIES=NULL,ISIN=HLD_ISIN_CODE,          
--FREEBAL=FLOOR(FREE_QTY),CURRBAL=0,FREEZEBAL=0,LOCKINBAL=0,PLEDGEBAL=0,DPVBAL=0,DPCBAL=0,RPCBAL=0,ELIMBAL=0,EARMARKBAL=0,          
--REMLOCKBAL=0,TOTALBALANCE=FLOOR(FREE_QTY),  TRDATE=          
--LEFT(HLD_HOLD_DATE,4) + '-' + SUBSTRING(HLD_HOLD_DATE,5,2) + '-' + RIGHT(HLD_HOLD_DATE,2) FROM  HOLDING   H WITH(NOLOCK),          
--#CLT1 C WITH(NOLOCK)          
--WHERE FREE_QTY>0    AND HLD_AC_CODE =CLTDPNO AND HLD_ISIN_CODE =I_ISIN 

SELECT  PARTY_CODE='PARTY',DPID=LEFT(BO_ID,8),CLTDPID=BO_ID,SCRIP_CD=NULL,SERIES=NULL,ISIN=ISIN,          
FREEBAL=CAST(FREE_BALANCE AS FLOAT),CURRBAL=0,FREEZEBAL=0,LOCKINBAL=0,PLEDGEBAL=0,DPVBAL=0,DPCBAL=0,RPCBAL=0,ELIMBAL=0,EARMARKBAL=0,          
REMLOCKBAL=0,TOTALBALANCE=CAST(FREE_BALANCE AS FLOAT),  TRDATE=FILE_DATE FROM  #DPHOLD   H WITH(NOLOCK),          
#CLT1 C WITH(NOLOCK)          
WHERE FREE_BALANCE>0    AND BO_ID =CLTDPNO AND  ISIN  =I_ISIN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DP_HOLD_POA_MKT_DPM3
-- --------------------------------------------------
         
CREATE PROC [dbo].[DP_HOLD_POA_MKT_DPM3] --(@SETT_NO VARCHAR(12),@SETT_TYPE VARCHAR(3))          
AS           
          
    
    
SELECT SETT_NO,SETT_TYPE INTO #SETT  FROM MSAJAG.DBO.SETT_MST  WITH(NOLOCK)       
WHERE SEC_PAYIN >=CONVERT(VARCHAR(11),GETDATE(),120)        
AND START_DATE <=CONVERT(VARCHAR(11),GETDATE(),120)        
        
CREATE INDEX #S ON #SETT(SETT_NO,SETT_TYPE)         
      
SELECT DISTINCT M.PARTY_CODE,M.CLTDPNO,I_ISIN INTO #CLT1  FROM MSAJAG.DBO.MULTICLTID M WITH(NOLOCK),          
MSAJAG.DBO.DELIVERYCLT D  WITH(NOLOCK)  ,#SETT S  WITH(NOLOCK)       
WHERE D.SETT_NO=S.SETT_NO  AND D.PARTY_CODE=M.PARTY_CODE AND D.SETT_TYPE=S.SETT_TYPE           
 AND INOUT ='I'        
          
CREATE INDEX #CL ON #CLT1 ( CLTDPNO,I_ISIN)  
 

SELECT BO_ID,ISIN,MAX(FILE_NUMBER)FILE_NUMBER INTO #CN  FROM DP_HOLDING_BALANCE D WITH(NOLOCK)
WHERE EXISTS (SELECT * FROM #CLT1 C WHERE D.BO_ID=C.CLTDPNO )
GROUP BY BO_ID,ISIN

CREATE INDEX #CL1 ON #CN ( BO_ID,ISIN,FILE_NUMBER)

SELECT BO_ID,ISIN,FREE_BALANCE,FILE_DATE INTO #DPHOLD FROM DP_HOLDING_BALANCE D
WHERE EXISTS (SELECT BO_ID FROM #CN C WHERE D.BO_ID=C.BO_ID AND D.ISIN=C.ISIN AND D.FILE_NUMBER=C.FILE_NUMBER )

CREATE INDEX #DP ON #DPHOLD ( BO_ID,ISIN )

          
--SELECT  PARTY_CODE='PARTY',DPID=LEFT(HLD_AC_CODE,8),CLTDPID=HLD_AC_CODE,SCRIP_CD=NULL,SERIES=NULL,ISIN=HLD_ISIN_CODE,          
--FREEBAL=FLOOR(FREE_QTY),CURRBAL=0,FREEZEBAL=0,LOCKINBAL=0,PLEDGEBAL=0,DPVBAL=0,DPCBAL=0,RPCBAL=0,ELIMBAL=0,EARMARKBAL=0,          
--REMLOCKBAL=0,TOTALBALANCE=FLOOR(FREE_QTY),  TRDATE=          
--LEFT(HLD_HOLD_DATE,4) + '-' + SUBSTRING(HLD_HOLD_DATE,5,2) + '-' + RIGHT(HLD_HOLD_DATE,2) FROM  HOLDING   H WITH(NOLOCK),          
--#CLT1 C WITH(NOLOCK)          
--WHERE FREE_QTY>0    AND HLD_AC_CODE =CLTDPNO AND HLD_ISIN_CODE =I_ISIN 

SELECT  PARTY_CODE='PARTY',DPID=LEFT(BO_ID,8),CLTDPID=BO_ID,SCRIP_CD=NULL,SERIES=NULL,ISIN=ISIN,          
FREEBAL=CAST(FREE_BALANCE AS FLOAT),CURRBAL=0,FREEZEBAL=0,LOCKINBAL=0,PLEDGEBAL=0,DPVBAL=0,DPCBAL=0,RPCBAL=0,ELIMBAL=0,EARMARKBAL=0,          
REMLOCKBAL=0,TOTALBALANCE=CAST(FREE_BALANCE AS FLOAT),  TRDATE=FILE_DATE FROM  #DPHOLD   H WITH(NOLOCK),          
#CLT1 C WITH(NOLOCK)          
WHERE FREE_BALANCE>0    AND BO_ID =CLTDPNO AND  ISIN  =I_ISIN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DP_TRANFERS_OFFMKT
-- --------------------------------------------------
	
	CREATE PROC [dbo].[DP_TRANFERS_OFFMKT]
	AS

	DECLARE @TODATE DATETIME
	SET @TODATE =CONVERT(VARCHAR(11),GETDATE(),120)
	
	SELECT DISTINCT DPID+DPCLTNO AS DP_COUNTER 
		INTO #EXCLUDEDP
		FROM (
			SELECT DPTYPE,DPID,DPCLTNO FROM   MSAJAG.DBO.DELIVERYDP
			UNION ALL
			SELECT DPTYPE,DPID,DPCLTNO FROM  BSEDB.DBO.DELIVERYDP
			) V WHERE DPTYPE ='NSDL'



 



	--SELECT MAX(TRANS_DATE) FROM #OFFMKT_RAW
	
	---TRUNCATE TABLE #OFFMKT_RAW 
	--INSERT INTO OFFMKT_RAW SELECT *  FROM #OFFMKT_RAW WHERE TRANS_DATE >='2023-06-08'

 
		SELECT	CAST('' AS VARCHAR(20)) AS PARTY_CODE, TD_CURDATE AS TRANS_DATE, TD_ISIN_CODE AS ISIN
				, CAST(0 AS INT) AS BSE_CODE, CAST('' AS VARCHAR(200)) AS NSE_SYMBOL, CAST('' AS VARCHAR(10)) AS NSESERIES
				, TD_QTY AS TRN_QTY, TD_DEBIT_CREDIT AS DR_CR, CAST(0 AS DECIMAL(18, 4)) AS MKT_RATE
				, TD_DESCRIPTION, ISNULL(TD_AC_CODE,'') AS TD_AC_CODE,ISNULL(TD_BENEFICIERY,'') AS TD_BENEFICIERY,ISNULL(TD_COUNTERDP,'') AS TD_COUNTERDP
				, CAST(0 AS INT) AS SL_ANGEL_CODE, GETDATE() AS UPDDATE, CAST('' AS VARCHAR(20)) AS COCODE,
				CONVERT(
					VARCHAR(32), 
					HASHBYTES('MD5', CONVERT(VARCHAR(10),TD_CURDATE,120)+TD_AC_CODE+TD_ISIN_CODE+CONVERT(VARCHAR(25),TD_QTY)+TD_DESCRIPTION+TD_DEBIT_CREDIT+TD_TRXNO+CONVERT(VARCHAR(20),TD_REFERENCE)+ISNULL(TD_REMARKS,'')), 2
				) AS OFFMKTID INTO #OFFMKT_RAW
		
		FROM	AGMUBODPL3.DMAT.CITRUS_USR.SYNERGY_TRXN_DETAILS_CURRENT WITH(NOLOCK)
		WHERE	TD_CURDATE >= @TODATE
				AND TD_MARKET_TYPE NOT IN ('111056','121155','111057')
				 AND(
						TD_DESCRIPTION IN ('ON-CR', 'OF-DR', 'TRANSMISSION', 'INTDEP-CR', 'ON-DR', 'OF-CR', 'INTDEP-DR', 'REMAT', 'PAY-IN FROM BO') 
						OR (TD_DESCRIPTION='DEMAT' AND TD_REMARKS LIKE '%CONFIRMED BALANCE')
						OR (TD_DESCRIPTION='DEMAT' AND TD_REMARKS LIKE '%BY DESTAT CONFIRM')
					)

					AND (TD_REMARKS NOT LIKE '%IN301151 13326100%' OR  TD_REMARKS NOT LIKE '%1203320000002291%')
--AND 					TD_MARKET_TYPE NOT IN ('111057')
					--TD_ISIN_CODE LIKE 'INF%'
				AND ISNULL(TD_COUNTERDP,'') NOT IN 
				(
					SELECT DP_COUNTER FROM #EXCLUDEDP
					UNION
					SELECT 'IN606125'
					UNION
					SELECT 'IN556929'
				)
				AND ISNULL(TD_BENEFICIERY,'') NOT IN (SELECT DISTINCT DPCLTNO FROM 
				(
					SELECT DPCLTNO FROM  MSAJAG.DBO.DELIVERYDP WITH(NOLOCK) WHERE DPCLTNO<>'1203320000072218'
					UNION ALL
					SELECT DPCLTNO FROM  BSEDB.DBO.DELIVERYDP WITH(NOLOCK) WHERE DPCLTNO<>'1203320000072218'
					UNION ALL
					SELECT DP_COUNTER FROM #EXCLUDEDP
					UNION
					SELECT '1203320007719863'
				) V)  --TD_AC_CODE ACCOUNT CODE ADDED BY RAM ANUJ ON 09-JAN-2018
				
				AND TD_AC_CODE NOT IN ('1203320000000051','1203320000006579','1203320000510609','1203320000551327','1203320003690030','1203320003713534','1203320003758618',
		'1203320005370789','1203320005406375','1203320005537073','1203320006562188','1203320006951435','1203320007132281','1203320008226164','1203320009673843')


		INSERT INTO	#OFFMKT_RAW

			SELECT	CAST('' AS VARCHAR(20)) AS PARTY_CODE, TD_CURDATE AS TRANS_DATE, TD_ISIN_CODE AS ISIN
				, CAST(0 AS INT) AS BSE_CODE, CAST('' AS VARCHAR(200)) AS NSE_SYMBOL, CAST('' AS VARCHAR(10)) AS NSESERIES
				, TD_QTY AS TRN_QTY, TD_DEBIT_CREDIT AS DR_CR, CAST(0 AS DECIMAL(18, 4)) AS MKT_RATE
				, TD_DESCRIPTION, ISNULL(TD_AC_CODE,'') AS TD_AC_CODE,ISNULL(TD_BENEFICIERY,'') AS TD_BENEFICIERY,ISNULL(TD_COUNTERDP,'') AS TD_COUNTERDP
				, CAST(0 AS INT) AS SL_ANGEL_CODE, GETDATE() AS UPDDATE, CAST('' AS VARCHAR(20)) AS COCODE,
				CONVERT(
					VARCHAR(32), 
					HASHBYTES('MD5', CONVERT(VARCHAR(10),TD_CURDATE,120)+TD_AC_CODE+TD_ISIN_CODE+CONVERT(VARCHAR(25),TD_QTY)+TD_DESCRIPTION+TD_DEBIT_CREDIT+TD_TRXNO+CONVERT(VARCHAR(20),TD_REFERENCE)+ISNULL(TD_REMARKS,'')), 2
				) AS OFFMKTID
		
		FROM	AngelDP5.DMAT.CITRUS_USR.SYNERGY_TRXN_DETAILS WITH(NOLOCK)
		WHERE	TD_CURDATE >= @TODATE
				AND TD_MARKET_TYPE NOT IN ('111056','121155','111057')
				 AND(
						TD_DESCRIPTION IN ('ON-CR', 'OF-DR', 'TRANSMISSION', 'INTDEP-CR', 'ON-DR', 'OF-CR', 'INTDEP-DR', 'REMAT', 'PAY-IN FROM BO') 
						OR (TD_DESCRIPTION='DEMAT' AND TD_REMARKS LIKE '%CONFIRMED BALANCE')
						OR (TD_DESCRIPTION='DEMAT' AND TD_REMARKS LIKE '%BY DESTAT CONFIRM')
					)

					AND (TD_REMARKS NOT LIKE '%IN301151 13326100%' OR  TD_REMARKS NOT LIKE '%1203320000002291%')
--AND 					TD_MARKET_TYPE NOT IN ('111057')
					--TD_ISIN_CODE LIKE 'INF%'
				AND ISNULL(TD_COUNTERDP,'') NOT IN 
				(
					SELECT DP_COUNTER FROM #EXCLUDEDP
					UNION
					SELECT 'IN606125'
					UNION
					SELECT 'IN556929'
				)
				AND ISNULL(TD_BENEFICIERY,'') NOT IN (SELECT DISTINCT DPCLTNO FROM 
				(
					SELECT DPCLTNO FROM  MSAJAG.DBO.DELIVERYDP WITH(NOLOCK) WHERE DPCLTNO<>'1203320000072218'
					UNION ALL
					SELECT DPCLTNO FROM  BSEDB.DBO.DELIVERYDP WITH(NOLOCK) WHERE DPCLTNO<>'1203320000072218'
					UNION ALL
					SELECT DP_COUNTER FROM #EXCLUDEDP
					UNION
					SELECT '1203320007719863'
				) V)  --TD_AC_CODE ACCOUNT CODE ADDED BY RAM ANUJ ON 09-JAN-2018
				
				AND TD_AC_CODE NOT IN ('1203320000000051','1203320000006579','1203320000510609','1203320000551327','1203320003690030','1203320003713534','1203320003758618',
		'1203320005370789','1203320005406375','1203320005537073','1203320006562188','1203320006951435','1203320007132281','1203320008226164','1203320009673843')

		
		
	   UPDATE O SET party_code=NISE_PARTY_CODE  FROM OffMkt_Raw  O,AngelDP4.dmat.citrus_usr.tbl_client_master t
			WHERE ISNULL(party_code, '') = '' and TD_AC_CODE=CLIENT_CODE
		
		TRUNCATE TABLE OFFMKT_RAW

		INSERT INTO OFFMKT_RAW
		SELECT * FROM #OFFMKT_RAW

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DPM_File_Insert_log
-- --------------------------------------------------

--exec DPM_File_Insert_log 'SOH_EXP_033203_456_I_202407031626_1_C_0'

CREATE PROCEDURE [dbo].[DPM_File_Insert_log] 

@FileName_DPM_File varchar (200)      

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF  EXISTS (select * from [tbl_DPM_File_Insert_log] where Convert (Date, created_date) <> Convert (Date, GETDATE()))    
	BEGIN   
	
	 Truncate table [tbl_DPM_File_Insert_log]    
	     
	END  

    declare @Delimiter char(1) = '_'
	;with cte as
	(
	    select @FileName_DPM_File C
	)
	select FileN, EXP, Right(DPID,3)DPID, ReqId, FileType, Filedate, SeqNo,col1 into #temp
	from cte T
	cross apply (values (CHARINDEX(@Delimiter,T.C))) AS c1(DelimPos)
	cross apply (values (LEFT(T.C,ABS(c1.DelimPos-1)),SUBSTRING(T.C,c1.DelimPos+1,8000))) t1(FileN,RHS)
	cross apply (values (CHARINDEX(@Delimiter,t1.RHS))) c2(DelimPos)
	cross apply (values (LEFT(t1.RHS,ABS(c2.DelimPos-1)),SUBSTRING(t1.RHS,c2.DelimPos+1,8000))) t2(EXP,RHS)
	cross apply (values (CHARINDEX(@Delimiter,t2.RHS))) c3(DelimPos)
	cross apply (values (LEFT(t2.RHS,ABS(c3.DelimPos-1)),SUBSTRING(t2.RHS,c3.DelimPos+1,8000))) t3(DPID,RHS)
	cross apply (values (CHARINDEX(@Delimiter,t3.RHS))) c4(DelimPos)
	cross apply (values (LEFT(t3.RHS,ABS(c4.DelimPos-1)),SUBSTRING(t3.RHS,c4.DelimPos+1,8000))) t4(ReqId,RHS)
	cross apply (values (CHARINDEX(@Delimiter,t4.RHS))) c5(DelimPos)
	cross apply (values (LEFT(t4.RHS,ABS(c5.DelimPos-1)),SUBSTRING(t4.RHS,c5.DelimPos+1,8000))) t5(FileType,RHS)
	cross apply (values (CHARINDEX(@Delimiter,t5.RHS))) c6(DelimPos)
	cross apply (values (LEFT(t5.RHS,ABS(c6.DelimPos-1)),SUBSTRING(t5.RHS,c6.DelimPos+1,8000))) t6(Filedate,RHS)
	cross apply (values (CHARINDEX(@Delimiter,t6.RHS))) c7(DelimPos)
	cross apply (values (LEFT(t6.RHS,ABS(c7.DelimPos-1)),SUBSTRING(t6.RHS,c6.DelimPos+1,8000))) t7(SeqNo,col1)
	END


	insert into [tbl_DPM_File_Insert_log]([FileN],[EXP],[DPID],[ReqId],[FileType],[Filedate],[SeqNo],[FileName])
	select [FileN],[EXP],[DPID],[ReqId],[FileType],[Filedate],[SeqNo],@FileName_DPM_File as [FileName] from #temp

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dw_asp_dsp_demat_transactions
-- --------------------------------------------------
CREATE PROCEDURE dw_asp_dsp_demat_transactions
	@party_code	VARCHAR(500),
	@from_date	DATETIME,
	@to_date	DATETIME,
	@Error_Msg VARCHAR(4000) = '' OUTPUT
AS
BEGIN
	SET NOCOUNT ON 

	BEGIN TRY
		DECLARE @PartyList TABLE(PartyCode VARCHAR(100))
		DECLARE @TallyLoop INT = 1
		IF OBJECT_ID('TempDB..#Tally') IS NOT NULL
			DROP TABLE #Tally
		CREATE TABLE #Tally (TID INT)
		WHILE @TallyLoop < = 100
			BEGIN
				INSERT INTO #Tally (TID)
				VALUES(@TallyLoop)

				SELECT @TallyLoop = @TallyLoop + 1
			END

		IF @from_date IS NULL OR @to_date IS NULL
			BEGIN
				RAISERROR('From_Date and To_Date are Mandatory..', 16, 1)
			END
		ELSE
			BEGIN
				IF ISNULL(@party_code, '') IN ('ALL', '')
					BEGIN
						IF DATEDIFF(DAY, @From_Date, @To_Date) NOT BETWEEN 1 AND 10
							BEGIN
								RAISERROR('Difference between From_Date and To_Date cannot be more than 10 Days..', 16, 1)
							END
						ELSE
							BEGIN
								INSERT INTO @PartyList (PartyCode)
								VALUES ('ALL')
							END
					END
				ELSE
					BEGIN
						IF DATEDIFF(DAY, @From_Date, @To_Date) NOT BETWEEN 1 AND 365
							BEGIN
								RAISERROR('Difference between From_Date and To_Date cannot be more than 1 Years..', 16, 1)
							END
						ELSE
							BEGIN
								SELECT @party_code = ','+@party_code

								INSERT INTO @PartyList ( PartyCode )
								SELECT	DISTINCT LTRIM(RTRIM(SUBSTRING(@party_code, TID+1, (ABS(CHARINDEX(',', @party_code, TID+1)-TID))-1))) AS PartyCode
								FROM	#Tally
								WHERE	SUBSTRING(@party_code, TID, 1) = ','
								
								IF @@ROWCOUNT > 10
									BEGIN
										RAISERROR('ClientList cannot contain more than 10 codes..', 16, 1)
									END
							END
					END
			END

		SELECT party_code, scrip_cd, Sett_No, Sett_type, transdate, Qty, CertNo, series, holdername, DpId, 
				CltDpId, BDpId, BCltDpId, reason, DrCr, TrType, Filler2, Delivered, TrType
		FROM deltrans_report dr WITH (NOLOCK)
				INNER JOIN @PartyList PL ON dr.Party_Code = ISNULL(NULLIF(PL.PartyCode, 'ALL'), dr.Party_Code)
		WHERE	TransDate >= @from_date AND TransDate <= @to_date
	END TRY

	BEGIN CATCH
		SELECT @Error_Msg = ERROR_MESSAGE()
	END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dw_asp_dsp_demat_transactionsBseDb
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[dw_asp_dsp_demat_transactionsBseDb]
	@party_code	VARCHAR(500),
	@from_date	DATETIME,
	@to_date	DATETIME,
	@Error_Msg VARCHAR(4000) = '' OUTPUT
AS
BEGIN
	SET NOCOUNT ON 

	BEGIN TRY
		DECLARE @PartyList TABLE(PartyCode VARCHAR(100))
		DECLARE @TallyLoop INT = 1
		IF OBJECT_ID('TempDB..#Tally') IS NOT NULL
			DROP TABLE #Tally
		CREATE TABLE #Tally (TID INT)
		;with CTE AS
		( 
			SELECT 1 AS TID
			UNION ALL
			SELECT TID + 1
			FROM CTE
			where TID < 8000
		)
		INSERT INTO #Tally (TID)
		SELECT * FROM CTE OPTION (MAXRECURSION 8000)

		IF @from_date IS NULL OR @to_date IS NULL
			BEGIN
				RAISERROR('From_Date and To_Date are Mandatory..', 16, 1)
			END
		ELSE
			BEGIN
				IF ISNULL(@party_code, '') IN ('ALL', '')
					BEGIN
						IF DATEDIFF(DAY, @From_Date, @To_Date) NOT BETWEEN 0 AND 9
							BEGIN
								RAISERROR('Difference between From_Date and To_Date cannot be more than 10 Days..', 16, 1)
							END
						ELSE
							BEGIN
								INSERT INTO @PartyList (PartyCode)
								VALUES ('ALL')
							END
					END
				ELSE
					BEGIN
						IF DATEDIFF(DAY, @From_Date, @To_Date) NOT BETWEEN 0 AND 365
							BEGIN
								RAISERROR('Difference between From_Date and To_Date cannot be more than 1 Years..', 16, 1)
							END
						ELSE
							BEGIN
								SELECT @party_code = ','+@party_code

								INSERT INTO @PartyList ( PartyCode )
								SELECT	DISTINCT SUBSTRING(@party_code, TID+1, ISNULL(NULLIF(CHARINDEX(',', @party_code, TID+1), 0), 6000) - TID-1) AS PartyCode
								FROM	#Tally
								WHERE	SUBSTRING(@party_code, TID, 1) = ','
								
								IF (SELECT COUNT(1) FROM @PartyList) > 20
									BEGIN
										RAISERROR('ClientList cannot contain more than 20 codes..', 16, 1)
									END
							END
					END
			END

		SELECT	  dr.party_code, dr.scrip_cd, dr.Sett_No, dr.Sett_type, dr.transdate, dr.Qty, dr.CertNo, dr.series, dr.holdername
				, dr.DpId, dr.CltDpId, dr.BDpId, dr.BCltDpId, dr.reason, dr.DrCr, dr.TrType, dr.Filler2, dr.Delivered, dr.TrType
		FROM bsedb.dbo.deltrans_report dr WITH (NOLOCK)
				INNER JOIN @PartyList PL ON dr.Party_Code = ISNULL(NULLIF(PL.PartyCode, 'ALL'), dr.Party_Code)
		WHERE	TransDate >= @from_date AND TransDate <= @to_date
	END TRY

	BEGIN CATCH
		SELECT @Error_Msg = ERROR_MESSAGE()
		SELECT TOP 0 party_code, scrip_cd, Sett_No, Sett_type, transdate, Qty, CertNo, series, holdername, DpId, 
				CltDpId, BDpId, BCltDpId, reason, DrCr, TrType, Filler2, Delivered, TrType
		FROM bsedb.dbo.deltrans_report WITH (NOLOCK)
	END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dw_asp_dsp_demat_transactionsMsajag
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[dw_asp_dsp_demat_transactionsMsajag]
	@party_code	VARCHAR(500),
	@from_date	DATETIME,
	@to_date	DATETIME,
	@Error_Msg VARCHAR(4000) = '' OUTPUT
AS
BEGIN
	SET NOCOUNT ON 

	BEGIN TRY
		DECLARE @PartyList TABLE(PartyCode VARCHAR(100))
		DECLARE @TallyLoop INT = 1
		IF OBJECT_ID('TempDB..#Tally') IS NOT NULL
			DROP TABLE #Tally
		CREATE TABLE #Tally (TID INT)
		;with CTE AS
		( 
			SELECT 1 AS TID
			UNION ALL
			SELECT TID + 1
			FROM CTE
			where TID < 8000
		)
		INSERT INTO #Tally (TID)
		SELECT * FROM CTE OPTION (MAXRECURSION 8000)

		IF @from_date IS NULL OR @to_date IS NULL
			BEGIN
				RAISERROR('From_Date and To_Date are Mandatory..', 16, 1)
			END
		ELSE
			BEGIN
				IF ISNULL(@party_code, '') IN ('ALL', '')
					BEGIN
						IF DATEDIFF(DAY, @From_Date, @To_Date) NOT BETWEEN 0 AND 9
							BEGIN
								RAISERROR('Difference between From_Date and To_Date cannot be more than 10 Days..', 16, 1)
							END
						ELSE
							BEGIN
								INSERT INTO @PartyList (PartyCode)
								VALUES ('ALL')
							END
					END
				ELSE
					BEGIN
						IF DATEDIFF(DAY, @From_Date, @To_Date) NOT BETWEEN 0 AND 365
							BEGIN
								RAISERROR('Difference between From_Date and To_Date cannot be more than 1 Years..', 16, 1)
							END
						ELSE
							BEGIN
								SELECT @party_code = ','+@party_code

								INSERT INTO @PartyList ( PartyCode )
								SELECT	DISTINCT SUBSTRING(@party_code, TID+1, ISNULL(NULLIF(CHARINDEX(',', @party_code, TID+1), 0), 6000) - TID-1) AS PartyCode
								FROM	#Tally
								WHERE	SUBSTRING(@party_code, TID, 1) = ','
								
								IF (SELECT COUNT(1) FROM @PartyList) > 20
									BEGIN
										RAISERROR('ClientList cannot contain more than 20 codes..', 16, 1)
									END
							END
					END
			END

		SELECT	  dr.party_code, dr.scrip_cd, dr.Sett_No, dr.Sett_type, dr.transdate, dr.Qty, dr.CertNo, dr.series, dr.holdername
				, dr.DpId, dr.CltDpId, dr.BDpId, dr.BCltDpId, dr.reason, dr.DrCr, dr.TrType, dr.Filler2, dr.Delivered, dr.TrType
		FROM msajag.dbo.deltrans_report dr WITH (NOLOCK)
				INNER JOIN @PartyList PL ON dr.Party_Code = ISNULL(NULLIF(PL.PartyCode, 'ALL'), dr.Party_Code)
		WHERE	TransDate >= @from_date AND TransDate <= @to_date
	END TRY

	BEGIN CATCH
		SELECT @Error_Msg = ERROR_MESSAGE()
		SELECT	TOP 0  dr.party_code, dr.scrip_cd, dr.Sett_No, dr.Sett_type, dr.transdate, dr.Qty, dr.CertNo, dr.series, dr.holdername
				, dr.DpId, dr.CltDpId, dr.BDpId, dr.BCltDpId, dr.reason, dr.DrCr, dr.TrType, dr.Filler2, dr.Delivered, dr.TrType
		FROM msajag.dbo.deltrans_report dr WITH (NOLOCK)
	END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.EXCH_HOLD_REPORT
-- --------------------------------------------------



CREATE PROC [dbo].[EXCH_HOLD_REPORT]

AS 

 Declare @date datetime
  set @date=CONVERT(VARCHAR(11),GETDATE(),120)

  delete Exch_hold_reporting  wHERE HoldingDate =CONVERT(VARCHAR(11),GETDATE(),120)
 
   INSERT INTO   Exch_hold_reporting           
   SELECT CONVERT(VARCHAR(11),GETDATE(),120) as 'HoldingDate', PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID,                          
   SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
   SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
   SUM(QTY) 'TotalHolding'    ,'NSE' AS EXCHANGE ,'0','','',''                      
   FROM MSAJAG.dbo.DELTRANS NOLOCK                         
   WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                           
   and party_code not in ('BSE','EXE','BROKER')                          
   and Left(CERTNO,2) = 'IN'                  
   GROUP BY  PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID                          
  
   UNION ALL  
  
   SELECT CONVERT(VARCHAR(11),GETDATE(),120) as 'HoldingDate', PARTY_CODE,SCRIP_CD,'BSE',CERTNO,BCLTDPID,                          
   SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
   SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
   SUM(QTY) 'TotalHolding'    ,'BSE' AS EXCHANGE   ,'0','','',''                                    
    FROM BSEDB.dbo.DELTRANS    NOLOCK                      
    WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                           
    and party_code not in ('BSE','EXE','BROKER')                      
    and Left(CERTNO,2) = 'IN'                      
    GROUP BY  PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID                          
           

----	  INSERT INTO   Exch_hold_reporting  
UNION ALL
  
   SELECT CONVERT(VARCHAR(11),GETDATE(),120) as 'HoldingDate', PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID,                          
   SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
   SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
   SUM(QTY) 'TotalHolding'    ,'NSE' AS EXCHANGE ,BatchNo,TransDate,'',''                      
   FROM MSAJAG.dbo.DELTRANS NOLOCK                         
   WHERE DRCR = 'D' AND FILLER2 = '1'    AND TransDate > CONVERT(VARCHAR(11),GETDATE(),120)                       
   and party_code not in ('BSE','EXE','BROKER')                          
   and Left(CERTNO,2) = 'IN'                  
   GROUP BY  PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID ,BatchNo,TransDate                         
 UNION ALL
   --- INSERT INTO   Exch_hold_reporting  
   SELECT CONVERT(VARCHAR(11),GETDATE(),120) as 'HoldingDate', PARTY_CODE,SCRIP_CD,'BSE',CERTNO,BCLTDPID,                          
   SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
   SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
   SUM(QTY) 'TotalHolding'    ,'BSE' AS EXCHANGE   ,BatchNo,TransDate,'',''                          
    FROM BSEDB.dbo.DELTRANS    NOLOCK                      
    WHERE DRCR = 'D' AND FILLER2 = '1'     AND TransDate > CONVERT(VARCHAR(11),GETDATE(),120)                              
    and party_code not in ('BSE','EXE','BROKER')                      
    and Left(CERTNO,2) = 'IN'                      
    GROUP BY  PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID   ,BatchNo,TransDate                       
 
 
 Select tradingid,Hld_isin_code,HLD_AC_CODE,Netqty-Pledge_Qty as Free_qty,Pledge_Qty,Netqty into #temp from AGMUBODPL3.DMAT.CITRUS_USR.hOLDING
 where hld_ac_code in ('1203320007447075','1203320005370789','1203320000551327','1203320000510609')
 
Alter table #temp
 Add Scrip_cd varchar(15),series varchar(5)

 update t set scrip_cd=m.Scrip_cd,series=m.series from  #temp t,angeldemat.msajag.dbo.multiisin m
 where  isin=Hld_isin_code and valid=1

 INSERT INTO   Exch_hold_reporting 
 select @date,tradingid,scrip_cd,series,Hld_isin_code,HLD_AC_CODE,Free_qty,Pledge_Qty,Netqty,'DP',0,'','','' from #temp

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindslowDiskIoFiles
-- --------------------------------------------------
CREATE Procedure [dbo].[FindslowDiskIoFiles] 
As
 Insert into SlowIoDiskfiles  SELECT DB_NAME(fs.database_id) AS [Database Name], mf.physical_name, io_stall_read_ms, num_of_reads,
CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms],io_stall_write_ms, 
num_of_writes,CAST(io_stall_write_ms/(1.0+num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms],
io_stall_read_ms + io_stall_write_ms AS [io_stalls], num_of_reads + num_of_writes AS [total_io],
CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
AS [avg_io_stall_ms],Reportdate = Getdate()
FROM sys.dm_io_virtual_file_stats(null,null) AS fs
INNER JOIN sys.master_files AS mf
ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
and DB_NAME(fs.database_id) <>'master'
--ORDER BY avg_io_stall_ms DESC OPTION (RECOMPILE);

GO

-- --------------------------------------------------
-- PROCEDURE dbo.HOLDING_DATA
-- --------------------------------------------------
 



---HOLDING_DATA '03/09/2019','03/09/2019'

CREATE PROCEDURE [dbo].[HOLDING_DATA]

(

 

@Fdate varchar(15)  ,

@Tdate varchar(15)  



)

AS

BEGIN

DECLARE @FromDate DATETIME=CAST(@Fdate  AS DATETIME)

DECLARE @ToDate DATETIME=dateadd(ms, -3, (dateadd(day, +1, convert(varchar, @Tdate, 101))))--DATEADD(DD, -1, DATEADD(D, 1, CONVERT(DATETIME2, @Tdate)))  

SELECT convert(varchar,HOLDINGDATE,103)as HOLDINGDATE,BCLTDPID,SCRIP_CD,CERTNO,SUM(FREE_HOLDING) AS FREE_HLD,SUM(PLEDGE_HOLD) AS PLD_HLD,SUM(TOTAL_HOLD) AS TOTAL_HLD
FROM  EXCH_HOLD_REPORTING WITH (NOLOCK) WHERE HOLDINGDATE >= @FromDate AND HOLDINGDATE<=@ToDate
GROUP BY HOLDINGDATE,BCLTDPID,SCRIP_CD,CERTNO
ORDER BY HOLDINGDATE,BCLTDPID,SCRIP_CD,CERTNO


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_DATA_POPULATE
-- --------------------------------------------------
 

 CREATE PROC [dbo].[IPO_DATA_POPULATE]
 AS

 TRUNCATE TABLE IPO_Raw

 DECLARE @FROMDATE DATETIME
 SET @FromDate = CAST(GETDATE()-5 AS DATE)

IF OBJECT_ID('tempdb..#IPO_Raw') IS NOT NULL
	DROP TABLE #IPO_Raw
	SELECT	TD_CURDATE AS trans_date, CAST('' AS VARCHAR(20)) AS party_code, CAST(0 AS INT) AS bse_code
			, CAST('' AS VARCHAR(200)) AS nse_symbol, CAST(0 AS INT) AS co_code, TD_ISIN_CODE AS isin
			, TD_QTY AS trn_qty, TD_DEBIT_CREDIT AS dr_cr, TD_REMARKS AS Remarks, GETDATE() AS UpdDate
			, TD_AC_CODE, CAST(0 AS INT) AS sl_angel_code, CAST(0 AS DECIMAL(18, 4)) AS mkt_rate
	INTO	#IPO_Raw
	FROM	AGMUBODPL3.DMAT.CITRUS_USR.SYNERGY_TRXN_DETAILS WITH(NOLOCK)
	WHERE	TD_DESCRIPTION = 'INITIALPUBLIC OFFERING'
			AND TD_CURDATE >= @FROMDATE
			and isnull(TD_ISIN_CODE,'') <>''	

	INSERT INTO #IPO_Raw
	SELECT	TD_CURDATE AS trans_date, CAST('' AS VARCHAR(20)) AS party_code, CAST(0 AS INT) AS bse_code
			, CAST('' AS VARCHAR(200)) AS nse_symbol, CAST(0 AS INT) AS co_code, TD_ISIN_CODE AS isin
			, TD_QTY AS trn_qty, TD_DEBIT_CREDIT AS dr_cr, TD_REMARKS AS Remarks, GETDATE() AS UpdDate
			, TD_AC_CODE, CAST(0 AS INT) AS sl_angel_code, CAST(0 AS DECIMAL(18, 4)) AS mkt_rate
	FROM	AngelDP5.DMAT.CITRUS_USR.SYNERGY_TRXN_DETAILS WITH(NOLOCK)
	WHERE	TD_DESCRIPTION = 'INITIALPUBLIC OFFERING'
			AND TD_CURDATE >= @FROMDATE
			and isnull(TD_ISIN_CODE,'') <>''	


	INSERT INTO #IPO_Raw
	SELECT	TD_CURDATE AS trans_date, CAST('' AS VARCHAR(20)) AS party_code, CAST(0 AS INT) AS bse_code
			, CAST('' AS VARCHAR(200)) AS nse_symbol, CAST(0 AS INT) AS co_code, TD_ISIN_CODE AS isin
			, TD_QTY AS trn_qty, TD_DEBIT_CREDIT AS dr_cr, TD_REMARKS AS Remarks, GETDATE() AS UpdDate
			, TD_AC_CODE, CAST(0 AS INT) AS sl_angel_code, CAST(0 AS DECIMAL(18, 4)) AS mkt_rate
	FROM	Angeldp202.DMAT.CITRUS_USR.SYNERGY_TRXN_DETAILS WITH(NOLOCK)
	WHERE	TD_DESCRIPTION = 'INITIALPUBLIC OFFERING'
			AND TD_CURDATE >= @FROMDATE
			and isnull(TD_ISIN_CODE,'') <>''	

     
	 CREATE INDEX #ACCODE ON  #IPO_RAW (TD_AC_CODE)


	 INSERT INTO IPO_Raw
	 SELECT trans_date,	party_code=NISE_PARTY_CODE,
	 bse_code,	nse_symbol,	co_code	,isin,	trn_qty,	dr_cr,	Remarks,	UpdDate,	
	 TD_AC_CODE,	sl_angel_code,	mkt_rate 
	 FROM #IPO_Raw I  WITH(NOLOCK) ,AngelDP4.DMAT.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)
	 WHERE I.TD_AC_CODE=CLIENT_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MTF_Pledge_req
-- --------------------------------------------------

Create Proc MTF_Pledge_req
as
select party_code,scrip_cd,series,certno,sum(qty) qty ,convert(varchar(10),TRANSDATE,120) trdate,payqty  into #temp
from  msajag.dbo.TBL_POA_PLD_ADNL where TRANSDATE>=convert(varchar(11),getdate()-10,120)
and DELIVERED<>'0'
group by party_code,scrip_cd,series,certno,convert(varchar(10),TRANSDATE,120) ,payqty
 

create index #x on #temp  (scrip_cd,series)
alter table #temp
add cl_rate money


update t set cl_rate=c.cl_rate from  msajag.dbo.closing c,#temp t
where c.SCRIP_CD=t.SCRIP_CD and c.SERIES=t.SERIES
and SysDate=trdate

select a.*,b.instrunctions,b.value,b.cli_cnt from 
(
select trdate,count(1)as instrunctions,round(sum(qty*cl_rate)/10000000,2) as value,count(distinct party_code) cli_cnt  from #temp
group by trdate )A
left outer join 
(select trdate,count(1)as instrunctions,round(sum(qty*cl_rate)/10000000,2) as value,count(distinct party_code) cli_cnt  from #temp
where  payqty <>0
group by trdate 
)b  on a.trdate=b.trdate
order by a.trdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.non_poa_flag_reset_client
-- --------------------------------------------------


CREATE Proc [dbo].[non_poa_flag_reset_client] (@sdate datetime )
as 
If @sdate=''
	begin 
	set @sdate =convert(varchar(11),getdate(),120)
	end 


select BOID CLIENT_CODE,BBOCODE NISE_PARTY_CODE  into #DUMP from AGMUBODPL3.dmat.Citrus_usr.vw_nonpoaclient t
where isnull(BBOCODE,'')<>'' --and status='ACTIVE'

Create index #party on  #DUMP
(nise_party_code )

select sett_no ,sett_type,Start_date into #sett_no from msajag.dbo.sett_mst where Start_date = @sdate--and sett_type ='N'

select distinct party_Code from msajag.dbo.deliveryclt d,#DUMP Y,#sett_no s
where d.party_code=NISE_PARTY_CODE
and d.sett_no=s.sett_no and d.sett_type=s.sett_type
and inout='O'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NON_POA_SMS_PROCESS
-- --------------------------------------------------
  
  
CREATE PROC [dbo].[NON_POA_SMS_PROCESS] 
 
AS   
  DECLARE @SETT_NO VARCHAR(11)

  SELECT @SETT_NO = SETT_NO FROM NON_POA_SMS_PROCESS_PARA
  BEGIN
CREATE TABLE #DIY_REPROCESS_LOG  
  (SETT_NO VARCHAR(11),SETT_TYPE VARCHAR(2),PARTY_CODE VARCHAR(15),SHORT_NAME VARCHAR(200),BRANCH_CD VARCHAR(20),SUB_BROKER VARCHAR(20)  
  ,SCRIP_CD VARCHAR(15),CERTNO VARCHAR(20), DELQTY INT, RECQTY INT, ISETTQTYPRINT INT, ISETTQTYMARK INT,  
   IBENQTYPRINT INT, IBENQTYMARK INT, HOLD INT, PLEDGE  INT, BSEHOLD INT , BSEPLEDGE INT ,CL_TYPE VARCHAR(15), COLLATERAL INT  
   )  
      
 DECLARE @PAYOUT VARCHAR(11)  
    
SET @PAYOUT = (  
SELECT REPLACE(LEFT(CONVERT(VARCHAR,SEC_PAYIN, 104), 10),'.','')   
FROM MSAJAG.DBO.SETT_MST  
WHERE SETT_NO=@SETT_NO  AND SETT_TYPE='M' )  
  
  INSERT  INTO #DIY_REPROCESS_LOG  
  EXEC MSAJAG.DBO.RPT_DELPAYINMATCH 'BROKER', 'BROKER', @SETT_NO,'M','ALL','%',2  
  
  INSERT  INTO #DIY_REPROCESS_LOG  
  EXEC  MSAJAG.DBO.RPT_DELPAYINMATCH 'BROKER', 'BROKER', @SETT_NO,'Z','ALL','%',2  
  
  
      
   SELECT SETT_NO,SETT_TYPE,PARTY_CODE,  
   SELL_SHORTAGE =(CASE WHEN DELQTY  -  RECQTY -  ISETTQTYPRINT -  IBENQTYPRINT>0   
   THEN DELQTY  -  RECQTY -  ISETTQTYPRINT -  IBENQTYPRINT  
   ELSE 0 END)  
   ,DP_ID='',ISIN=CERTNO,PROCESS_DATE=GETDATE()  INTO #NONPOA  
   FROM #DIY_REPROCESS_LOG D  
   WHERE NOT EXISTS (SELECT PARTY_CODE FROM AGMUBODPL3.DMAT.CITRUS_USR.E_DIS_TRXN_DATA T   
   WHERE PARTY_CODE =T.PARTYCODE AND D.CERTNO=T.ISIN AND DUMMY2=@PAYOUT AND REQUEST_DATE >GETDATE()-15  
   AND ISNULL(VALID,0)=0 AND ISNULL(DUMMY3,'')='')  
   --AND GETDATE() BETWEEN REQUEST_DATE  
  
   ALTER TABLE #NONPOA  
   ALTER COLUMN DP_ID VARCHAR(16)  
  
   UPDATE #NONPOA SET DP_ID = CLTDPNO  
   FROM MSAJAG.DBO.MULTICLTID M  WHERE DEF=0 AND #NONPOA.PARTY_CODE =M.PARTY_CODE  
   AND DPID in ('12033200'  ,'12033201' )
  
   SELECT N.*,ISNULL(FREE_QTY,0) AS DP_QTY INTO #FINAL  FROM #NONPOA N  
   LEFT OUTER JOIN   
   AGMUBODPL3.DMAT.CITRUS_USR.HOLDING H with (nolock) ON  DP_ID= HLD_AC_CODE AND FREE_QTY<>0   
   AND HLD_ISIN_CODE=ISIN  
   WHERE  DP_ID <>''  
   INSERT INTO #FINAL
   SELECT N.*,ISNULL(FREE_QTY,0) AS DP_QTY    FROM #NONPOA N  
   LEFT OUTER JOIN   
   AngelDP5.DMAT.CITRUS_USR.HOLDING H with (nolock) ON  DP_ID= HLD_AC_CODE AND FREE_QTY<>0   
   AND HLD_ISIN_CODE=ISIN  
   WHERE  DP_ID <>''  
   
  
   SELECT F.*, B2C INTO #F1 FROM #FINAL F,INTRANET.RISK.DBO.CLIENT_DETAILS C  
   WHERE F.PARTY_CODE =C.CL_CODE   
   
 --   DECLARE @FVALID DATE

	--SELECT @FVALID= MAX(PROCESS_DATE) FROM #F1  
	--WHERE CONVERT(VARCHAR(11),PROCESS_DATE,120)=CONVERT(VARCHAR(11),GETDATE(),120)
 
   INSERT INTO  NON_POA_SMS_DATA_LOG
   SELECT * ,GETDATE() FROM NON_POA_SMS_DATA --WHERE PROCESS_DATE  < @FVALID

   --DELETE FROM NON_POA_SMS_DATA  WHERE PROCESS_DATE  < @FVALID

   Truncate table NON_POA_SMS_DATA

   

   INSERT INTO NON_POA_SMS_DATA  
   SELECT PARTY_CODE,SCRIP_CD,M.SERIES,SELL_SHORTAGE,DP_ID,DP_QTY, SEC_PAYIN  AS PAYINDATE,
   PROCESS_DATE,MOBILE_PAGER,F.SETT_NO,F.SETT_TYPE ,  
   SMS_QTY=(CASE WHEN SELL_SHORTAGE>DP_QTY THEN DP_QTY ELSE SELL_SHORTAGE END)  ,F.ISIN 
   FROM #F1 F,MSAJAG.DBO.MULTIISIN M,MSAJAG.DBO.SETT_MST S,MSAJAG.DBO.CLIENT1 C WHERE F.ISIN =M.ISIN AND VALID=1  
   AND F.SETT_NO=S.SETT_NO AND F.SETT_TYPE =S.SETT_TYPE AND PARTY_CODE=CL_CODE   
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NONPOA_HOLDING_MKT
-- --------------------------------------------------
  
CREATE PROC [dbo].[NONPOA_HOLDING_MKT]     
AS    
    
     
SELECT *  INTO #SETT  FROM  MSAJAG.DBO.SETT_MST     
WHERE SEC_PAYIN >=CONVERT(VARCHAR(11),GETDATE(),120)    
AND START_DATE <=CONVERT(VARCHAR(11),GETDATE(),120)   ---AND Sett_TYPE='M'  
    
CREATE INDEX #S ON #SETT(SETT_NO,SETT_TYPE)     
  
SELECT DISTINCT M.PARTY_CODE,M.CLTDPNO,I_ISIN,    
REPLACE(LEFT(CONVERT(VARCHAR,SEC_PAYIN, 104), 10),'.','') AS PAYINDATE,START_DATE AS TRADE_DATE,    
SEC_PAYIN AS SEC_PAYIN    
INTO #CLT1  FROM   MSAJAG.DBO.MULTICLTID M WITH(NOLOCK),      
 MSAJAG.DBO.DELIVERYCLT D  WITH(NOLOCK)  ,#SETT S    
WHERE D.SETT_NO=S.SETT_NO  AND D.PARTY_CODE=M.PARTY_CODE AND D.SETT_TYPE=S.SETT_TYPE       
 AND INOUT ='I'   AND DEF <>1      
      
  CREATE INDEX #C ON #CLT1(PARTY_CODE,CLTDPNO,I_ISIN )    
   CREATE INDEX #F ON #CLT1(PAYINDATE,TRADE_DATE )    
    
 DECLARE @REQUEST_DATE DATETIME    
 SET @REQUEST_DATE = (Select min(start_date) from #SETT)  
    
SELECT * INTO #EDISDATA    
FROM  E_DIS_TRXN_DATA T (NOLOCK) WHERE REQUEST_DATE>=@REQUEST_DATE AND EXISTS(SELECT PARTY_CODE FROM #CLT1 C (NOLOCK) WHERE     
 C.PARTY_CODE=PARTYCODE )    
    
SELECT PARTY_CODE=PARTYCODE, DPID=LEFT(CLIENT_ID,8), CLIENT_ID, ISIN, REF_NO,TRADEQTY=TRADEQTY,      
 REQUESTEDDATE=REQUESTEDDATE,INSTQTY=0,BATCHNO=0,BATCH_DATE='',SETTLEMENT_NO='',SETT_TYPE='',FLAG  Into #Final FROM (    
SELECT DISTINCT CLIENT_ID=BOID,ISIN,    
TRADEQTY=(CASE WHEN CAST(ISNULL(PEND_QTY,0)AS FLOAT)>0 THEN CAST(ISNULL(PEND_QTY,0) AS FLOAT) ELSE QTY END )              
,FLAG,REQUESTEDDATE=TRADE_DATE,NO_OF_DAYS ,DIS_TRXN_STATUS=ISNULL(DUMMY3,''),REF_NO=CDSL_TRXN_ID   ,SEC_PAYIN ,PARTYCODE    
FROM  #EDISDATA T (NOLOCK)  ,#CLT1 C (NOLOCK) WHERE     
REQUEST_DATE>=@REQUEST_DATE AND C.PARTY_CODE=PARTYCODE    
AND I_ISIN=ISIN AND DUMMY2 =PAYINDATE     
AND ISNULL(VALID,0)=0 ) A WHERE  ISNULL(REF_NO,'') <> ''       
    
SELECT * FROM #FINAL With(Nolock)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PLEDGE_HOLDING_FOR_CCEALLOCATION
-- --------------------------------------------------

CREATE PROC PLEDGE_HOLDING_FOR_CCEALLOCATION
AS

DeCLARE @RUNDATE VARCHAR(11),  @DEFEXCHG VARCHAR(3),@CURFLAG INT

SET @RUNDATE =CONVERT(VARCHAR(12),GETDATE()-1,109)

SET @CURFLAG=0

SELECT @DEFEXCHG=(CASE WHEN CLEARINGCODE = 'ICCL' THEN 'BSE' ELSE 'NSE' END) FROM ANGELNSECM.MSAJAG.DBO.TBL_INTEROP_SETTING  
WHERE @RUNDATE BETWEEN FROM_DATE AND TO_DATE  

EXEC  MSAJAG.DBO.RPT_DELPLD_DATA_NEW @RUNDATE, @DEFEXCHG, @CURFLAG  

INSERT INTO tbl_PLDDATA_NEW
SELECT *,@RUNDATE from MSAJAG.DBO.tbl_PLDDATA_NEW

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
-- PROCEDURE dbo.Rpt_BSE_Delpayinmatch_CMSPRO_cli_LimitALG
-- --------------------------------------------------


CREATE Proc [dbo].[Rpt_BSE_Delpayinmatch_CMSPRO_cli_LimitALG](@pcode as varchar(10)= null)              
AS              
    
Set nocount on    
    
-------------------------------------BSECM shortage -----------------------------------------------   
 
 --declare @pcode as varchar(10)= null
    
 SELECT Segment='BSECM',SETT_TYPE,SETT_NO             
 into #SEttMST    
 FROM bsedb.dbo.sett_mst (NOLOCK)              
 WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'              
 AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'     
    
 select a.Sett_no,a.Sett_Type,a.scrip_cd,a.series,a.Party_code,a.Qty,a.Inout,a.Branch_Cd,a.PartiPantCode     
 Into #DeliveryClt               
 from    
 (    
  Select Sett_no,Sett_Type,scrip_cd,series,Party_code,Qty,Inout,Branch_Cd,PartiPantCode     
  From BSEDB.dbo.DeliveryClt with (nolock) Where Party_code=@pcode and InOut = 'I'     
 ) a    
 join #SETTMST b on a.Sett_no=b.sett_no and a.Sett_Type=b.sett_type     
               
    
 Select               
 a.Sett_No,a.Sett_Type,a.Scrip_Cd,a.Series,a.Party_Code,a.Drcr,a.Recqty,a.Filler2              
 Into #Deltrans              
 from    
 (              
 select C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Qty,c.Filler2              
 From BSEDB.dbo.Deltrans C with (nolock)              
 Where Party_code=@pcode And Drcr = 'C' And Filler2 = 1 And TrType <> 906              
 ) a join #SETTMST b on a.Sett_no=b.sett_no and a.Sett_Type=b.sett_type     
    
    
 select @pcode as party_code,Short_Name=SPACE(1), Branch_Cd=SPACE(1), sub_broker=SPACE(1)       
 INTO #CLIENT               
               
 Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(D.Recqty, 0)), Isettqty = 0, Ibenqty = 0,              
 Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')             
 Into #delpayinmatch              
 From  
 (  
 select d.*,c.Recqty from              
 (  
   select D.Sett_No,D.Sett_Type,D.Scrip_Cd,D.Series,D.Party_Code,D.Qty,D.inout    
   from #Deliveryclt D with (nolock) where Inout = 'I'  
  )D              
  Left Outer Join               
  (  
   select Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,Drcr,Recqty=Recqty,Filler2    
   from  #Deltrans with (nolock)  
   where Filler2 = 1 and Drcr = 'C'  
  )C              
 On  D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type              
 And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series              
 And D.Party_Code = C.Party_Code   
 )D              
 inner join               
  BSEDB.dbo.Multiisin M with (nolock)  on              
 M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series               
 Where m.Valid = 1              
 Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin           
 Having D.Qty > 0              
               
 Delete From #delpayinmatch Where Delqty <= Recqty              
               
 Insert Into #delpayinmatch              
    
 Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0,Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then  D.Qty Else 0 End),              
 Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then  D.Qty Else 0 End),              
 Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then  D.Qty Else 0 End) ,              
 Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')            
 from    
 (    
 select Sett_No,Sett_type,TrType,Party_Code,Qty,CertNo,Delivered,ISett_No,ISett_Type,Filler2    
 From BSEDB.dbo.Deltrans D with (nolock)              
 Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)              
 and party_code=@pcode    
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type            
 Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno             
    
 union all              
    
 Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,              
 Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')           
 from    
 (    
 select Sett_No,Sett_type,TrType,Party_Code,Qty,CertNo,Delivered,ISett_No,ISett_Type,Filler2    
 From msajag.Dbo.Deltrans D with(nolock)   
 Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)              
 and party_code=@pcode    
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type          
 Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno              
    
               
 Update #delpayinmatch     
 Set Hold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),              
 Pledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End)     
 From (              
 Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),              
 Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)              
 From BSEDB.dbo.Deltrans D with(nolock) inner join BSEDB.dbo.Deliverydp Dp with(nolock)             
 on D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno              
 Where D.party_code=@pcode and D.Filler2 = 1 And D.Drcr = 'D'              
 And D.Delivered = '0' And D.Trtype In (904, 909, 905) And  DP.[Description] Not Like '%pool%'              
 Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code              
 And A.Certno = #delpayinmatch.Certno              
               
 Update #delpayinmatch Set Nsehold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),              
 Nsepledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From (              
 Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),              
 Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)     
 From msajag.Dbo.Deltrans D with(nolock), msajag.Dbo.Deliverydp Dp  with(nolock)            
 Where D.party_code=@pcode and D.Filler2 = 1 And D.Drcr = 'D'              
 And D.Delivered = '0' And D.Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid              
 And D.Bcltdpid = Dp.Dpcltno And DP.[Description] Not Like '%pool%'              
 Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno              
               
 Update #delpayinmatch              
 Set Scrip_Cd = M.Scrip_Cd              
 From BSEDB.dbo.Scrip2 S2 with(nolock) INNER JOIN  BSEDB.dbo.MultiIsIn M  with(nolock)            
 on S2.BseCode = M.Scrip_Cd              
 where M.IsIn = #delpayinmatch.CertNo              
    
 --delete from INTRANET.RISK.DBO.BSECM_shortage Where party_Code=@pcode 
 
 --select top 0 * into tbl_BSECM_Shortage_LimitALG from INTRANET.RISK.DBO.BSECM_shortage            
    
 --insert into tbl_BSECM_Shortage_LimitALG              
 Select Sett_No, Sett_Type, R.Party_Code, convert(varchar(10),GETDATE(),103)+' '+convert(varchar(10),GETDATE(),108) as Short_Name,     
 '' as Branch_Cd, '' as sub_broker, Scrip_Cd, Certno,      
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),              
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),              
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge              
 From #delpayinmatch R (nolock)              
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, Scrip_Cd, Certno, Hold, Pledge, Nsehold,    Nsepledge              
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )              
 Order By Branch_Cd, R.Party_Code, Scrip_Cd              
               
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_BondPRO_cli
-- --------------------------------------------------

Create Proc [dbo].[Rpt_Delpayinmatch_BondPRO_cli](@pcode as varchar(10)= null)              
AS              
    
Set nocount on    
    
-------------------- BSECM shortage    
    
 SELECT Segment='BSECM',SETT_TYPE,SETT_NO             
 into #SEttMST    
 FROM bsedb.dbo.sett_mst (NOLOCK)              
 WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'              
 AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'     
    
 select a.Sett_no,a.Sett_Type,a.scrip_cd,a.series,a.Party_code,a.Qty,a.Inout,a.Branch_Cd,a.PartiPantCode     
 Into #DeliveryClt               
 from    
 (    
  Select Sett_no,Sett_Type,scrip_cd,series,Party_code,Qty,Inout,Branch_Cd,PartiPantCode     
  From BSEDB.dbo.DeliveryClt with (nolock) Where Party_code=@pcode and InOut = 'I'     
 ) a    
 join #SETTMST b on a.Sett_no=b.sett_no and a.Sett_Type=b.sett_type     
               
    
 Select               
 a.Sett_No,a.Sett_Type,a.Scrip_Cd,a.Series,a.Party_Code,a.Drcr,a.Recqty,a.Filler2              
 Into #Deltrans              
 from    
 (              
 select C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Qty,c.Filler2              
 From BSEDB.dbo.Deltrans C with (nolock)              
 Where Party_code=@pcode And Drcr = 'C' And Filler2 = 1 And TrType <> 906              
 ) a join #SETTMST b on a.Sett_no=b.sett_no and a.Sett_Type=b.sett_type     
    
    
 select @pcode as party_code,Short_Name=SPACE(1), Branch_Cd=SPACE(1), sub_broker=SPACE(1)       
 INTO #CLIENT               
               
 Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(D.Recqty, 0)), Isettqty = 0, Ibenqty = 0,              
 Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')             
 Into #delpayinmatch              
 From  
 (  
 select d.*,c.Recqty from              
 (  
   select D.Sett_No,D.Sett_Type,D.Scrip_Cd,D.Series,D.Party_Code,D.Qty,D.inout    
   from #Deliveryclt D with (nolock) where Inout = 'I'  
  )D              
  Left Outer Join               
  (  
   select Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,Drcr,Recqty=Recqty,Filler2    
   from  #Deltrans with (nolock)  
   where Filler2 = 1 and Drcr = 'C'  
  )C              
 On  D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type              
 And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series              
 And D.Party_Code = C.Party_Code   
 )D              
 inner join               
  BSEDB.dbo.Multiisin M with (nolock)  on              
 M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series               
 Where m.Valid = 1              
 Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin           
 Having D.Qty > 0              
               
 Delete From #delpayinmatch Where Delqty <= Recqty              
               
 Insert Into #delpayinmatch              
    
 Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0,Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then  D.Qty Else 0 End),              
 Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then  D.Qty Else 0 End),              
 Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then  D.Qty Else 0 End) ,              
 Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')            
 from    
 (    
 select Sett_No,Sett_type,TrType,Party_Code,Qty,CertNo,Delivered,ISett_No,ISett_Type,Filler2    
 From BSEDB.dbo.Deltrans D with (nolock)              
 Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)              
 and party_code=@pcode    
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type            
 Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno             
    
 union all              
    
 Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,              
 Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')           
 from    
 (    
 select Sett_No,Sett_type,TrType,Party_Code,Qty,CertNo,Delivered,ISett_No,ISett_Type,Filler2    
 From msajag.Dbo.Deltrans D    
 Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)              
 and party_code=@pcode    
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type          
 Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno              
    
               
 Update #delpayinmatch     
 Set Hold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),              
 Pledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End)     
 From (              
 Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),              
 Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)              
 From BSEDB.dbo.Deltrans D  inner join BSEDB.dbo.Deliverydp Dp              
 on D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno              
 Where D.party_code=@pcode and D.Filler2 = 1 And D.Drcr = 'D'              
 And D.Delivered = '0' And D.Trtype In (904, 909, 905) And  DP.[Description] Not Like '%pool%'              
 Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code              
 And A.Certno = #delpayinmatch.Certno              
               
 Update #delpayinmatch Set Nsehold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),              
 Nsepledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From (              
 Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),              
 Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)     
 From msajag.Dbo.Deltrans D, msajag.Dbo.Deliverydp Dp              
 Where D.party_code=@pcode and D.Filler2 = 1 And D.Drcr = 'D'              
 And D.Delivered = '0' And D.Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid              
 And D.Bcltdpid = Dp.Dpcltno And DP.[Description] Not Like '%pool%'              
 Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno              
               
 Update #delpayinmatch              
 Set Scrip_Cd = M.Scrip_Cd              
 From BSEDB.dbo.Scrip2 S2 INNER JOIN  BSEDB.dbo.MultiIsIn M              
 on S2.BseCode = M.Scrip_Cd              
 where M.IsIn = #delpayinmatch.CertNo              
    
 delete from INTRANET.BOND.DBO.BSECM_shortage Where party_Code=@pcode             
    
 insert into INTRANET.BOND.DBO.BSECM_shortage              
 Select Sett_No, Sett_Type, R.Party_Code, convert(varchar(10),GETDATE(),103)+' '+convert(varchar(10),GETDATE(),108) as Short_Name,     
 '' as Branch_Cd, '' as sub_broker, Scrip_Cd, Certno,      
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),              
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),              
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge              
 From #delpayinmatch R (nolock)              
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, Scrip_Cd, Certno, Hold, Pledge, Nsehold,    Nsepledge              
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )              
 Order By Branch_Cd, R.Party_Code, Scrip_Cd              
               
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_BSE
-- --------------------------------------------------

CREATE Proc Rpt_Delpayinmatch_BSE
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)       
AS                              
      
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                
        
Select * Into #DeliveryClt From angeldemat.bsedb.dbo.DeliveryClt        
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type        
And InOut = 'I'        
        
Select * Into #Deltrans From angeldemat.bsedb.dbo.Deltrans       
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type        
And Party_Code <> 'BROKER' And Drcr = 'C'                                 
And Filler2 = 1 And Sharetype <> 'Auction'        
And TrType <> 906        
      
      
SELECT PARTY_CODE, Short_Name, Branch_Cd, sub_broker        
INTO #CLIENT FROM anand1.msajag.dbo.CLIENT_details with (nolock)      
WHERE PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)            
      
set transaction isolation level read uncommitted                    
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                                
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,        
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
Into #delpayinmatch                                
From #CLIENT C1, angeldemat.bsedb.dbo.Multiisin M  ,       
#Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                 
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
From angeldemat.bsedb.dbo.Deltrans D , #Client C1 (nolock)      
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
From angeldemat.Msajag.Dbo.Deltrans D, #Client C1      
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                
And C1.Party_Code = D.Party_Code                            
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
        
set transaction isolation level read uncommitted                                
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                   
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0)       
From angeldemat.bsedb.dbo.Deltrans D , angeldemat.bsedb.dbo.Deliverydp Dp           
Where Filler2 = 1 And Drcr = 'D'                                 
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                 
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                 
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code       
And A.Certno = #delpayinmatch.Certno                                
                                
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                   
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From angeldemat.Msajag.Dbo.Deltrans D, angeldemat.Msajag.Dbo.Deliverydp Dp                                 
Where Filler2 = 1 And Drcr = 'D'                   
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid             
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                 
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                
            
Update #delpayinmatch       
--Set Scrip_Cd = S2.Scrip_Cd + ' ( ' + M.Scrip_Cd + ' )'        
Set Scrip_Cd = M.Scrip_Cd      
From angeldemat.bsedb.dbo.Scrip2 S2, angeldemat.bsedb.dbo.MultiIsIn M        
Where S2.BseCode = M.Scrip_Cd        
And M.IsIn = CertNo        
        
If Upper(@Branchcd) = 'All'                                 
begin                    
 Select @Branchcd = '%'                          
end                    
If @Opt = 1                    
begin                    
 set transaction isolation level read uncommitted                                 
 delete from BSECM_shortage Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                 
-- truncate table   BSECM_shortage     
 insert into BSECM_shortage       
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
      
-- delete from BSECM_shortage Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                 
-- truncate table   BSECM_shortage     
insert into BSECM_shortage_Temp     
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

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_CMSPRO
-- --------------------------------------------------
CREATE Proc Rpt_Delpayinmatch_CMSPRO  
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)        
AS        
        
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)        
/*        
/*added to check with parameters**/        
--BSECM AC  2012136        
DECLARE @segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
set @segment ='BSECM'        
set @sett_Type ='AC'        
set @sett_no='2012136'        
    
    */    
Select Sett_no,Sett_Type,scrip_cd,series,Party_code,Qty,Inout,Branch_Cd,PartiPantCode Into #DeliveryClt         
From BSEDB.dbo.DeliveryClt with (nolock)        
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type        
And InOut = 'I'---Explicitly added column names        
        
Select         
C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Qty,c.Filler2        
 Into #Deltrans        
 From BSEDB.dbo.Deltrans C with (nolock)        
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type        
And Party_Code <> 'BROKER' And Drcr = 'C'        
And Filler2 = 1 /*And Sharetype <> 'Auction'*/        
And TrType <> 906        
        
        
/*        
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
INTO #CLIENT FROM CLIENT1 C1, CLIENT2 C2        
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
*/        
        
        
--changed from in to exists and distinct to group by        
SELECT PARTY_CODE, Short_Name, Branch_Cd, sub_broker        
INTO #CLIENT         
FROM INTRANET.RISK.DBO.CLIENT_details cd with  (nolock)        
WHERE exists        
(        
select cl.party_code from         
(SELECT  PARTY_CODE FROM #DeliveryClt group by PARTY_CODE        
UNION         
SELECT PARTY_CODE FROM #Deltrans group by PARTY_CODE)CL         
where cl.party_code=cd.party_code        
)        
        
        
set transaction isolation level read uncommitted        
/*        
DECLARE @segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
set @segment ='BSECM'        
set @sett_Type ='AC'        
set @sett_no='2012136'        
*/        
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(D.Recqty, 0)), Isettqty = 0, Ibenqty = 0,        
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,        
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
Into #delpayinmatch        
From #CLIENT C1         
inner join          
(select d.*,c.Recqty from        
(select D.Sett_No,D.Sett_Type,D.Scrip_Cd,D.Series,D.Party_Code,D.Qty,D.inout  from #Deliveryclt D with (nolock) )D        
Left Outer Join         
(select C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Recqty,c.Filler2  from  #Deltrans C (nolock))C        
On  D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type        
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series        
And D.Party_Code = C.Party_Code And C.Drcr = 'C'        
And C.Filler2 = 1 /*And Sharetype <> 'Auction'*/)D        
on C1.Party_Code = D.Party_Code        
inner join         
 BSEDB.dbo.Multiisin M with (nolock)  on        
M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series         
Where D.Inout = 'I'  And m.Valid = 1        
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type        
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
Having D.Qty > 0        
        
        
If @Opt <> 1        
Begin        
 Delete From #delpayinmatch Where Delqty <= Recqty        
End        
        
set transaction isolation level read uncommitted        
        
/*        
DECLARE @segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
set @segment ='BSECM'        
set @sett_Type ='AC'        
set @sett_no='2012136'        
*/        
        
        
Insert Into #delpayinmatch        
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0,Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),        
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),        
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),        
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then  D.Qty Else 0 End),        
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then  D.Qty Else 0 End),        
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then  D.Qty Else 0 End) ,        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,        
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
From BSEDB.dbo.Deltrans D with (nolock)        
inner join #Client C1 (nolock) on C1.Party_Code = D.Party_Code        
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)        
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type        
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
union all        
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),        
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),        
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),        
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),        
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),        
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,        
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
From msajag.Dbo.Deltrans D, #Client C1        
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)        
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type        
And C1.Party_Code = D.Party_Code        
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker        
        
        
        
set transaction isolation level read uncommitted        
        
/*        
 DECLARE @StatusId VARCHAR(15)        
SET  @StatusId = 'broker'        
*/        
        
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),        
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (        
Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),        
Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)        
From BSEDB.dbo.Deltrans D  inner join BSEDB.dbo.Deliverydp Dp        
on D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno        
Where D.Filler2 = 1 And D.Drcr = 'D'        
And D.Delivered = '0' And D.Trtype In (904, 909, 905) And  DP.[Description] Not Like '%pool%'        
Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code        
And A.Certno = #delpayinmatch.Certno        
        
/*        
 DECLARE @StatusId VARCHAR(15)        
SET  @StatusId = 'broker'        
*/        
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),        
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (        
Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),        
Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0) From msajag.Dbo.Deltrans D, msajag.Dbo.Deliverydp Dp        
Where D.Filler2 = 1 And D.Drcr = 'D'        
And D.Delivered = '0' And D.Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid        
And D.Bcltdpid = Dp.Dpcltno And DP.[Description] Not Like '%pool%'        
Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno        
        
Update #delpayinmatch        
--Set Scrip_Cd = S2.Scrip_Cd + ' ( ' + M.Scrip_Cd + ' )'        
Set Scrip_Cd = M.Scrip_Cd        
From BSEDB.dbo.Scrip2 S2 INNER JOIN  BSEDB.dbo.MultiIsIn M        
on S2.BseCode = M.Scrip_Cd        
where M.IsIn = #delpayinmatch.CertNo        
      
  
        
If Upper(@Branchcd) = 'All'        
begin        
 Select @Branchcd = '%'        
end        
        
If @Opt = 1        
begin        
 set transaction isolation level read uncommitted        
delete from INTRANET.RISK.DBO.BSECM_shortage Where Sett_No = @Sett_No And Sett_Type = @Sett_Type        
       
insert into INTRANET.RISK.DBO.BSECM_shortage        
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
         
  delete from INTRANET.RISK.DBO.BSECM_shortage Where Sett_No = @Sett_No And Sett_Type = @Sett_Type        
   
        
  insert into INTRANET.RISK.DBO.BSECM_shortage        
  Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,        
  Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),        
  Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),        
  Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge        
  From #delpayinmatch R (nolock)        
  Where R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type        
  And R.Branch_Cd Like @Branchcd        
  Group By R.Sett_No, R.Sett_Type, R.Party_Code, R.Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold,    Nsepledge        
  Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )        
  Order By Branch_Cd, R.Party_Code, Scrip_Cd        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_CMSPRO_cli
-- --------------------------------------------------

CREATE Proc [dbo].[Rpt_Delpayinmatch_CMSPRO_cli](@pcode as varchar(10)= null)              
AS              
    
Set nocount on    
    
-------------------- BSECM shortage    
    
 SELECT Segment='BSECM',SETT_TYPE,SETT_NO             
 into #SEttMST    
 FROM bsedb.dbo.sett_mst (NOLOCK)              
 WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'              
 AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'     
    
 select a.Sett_no,a.Sett_Type,a.scrip_cd,a.series,a.Party_code,a.Qty,a.Inout,a.Branch_Cd,a.PartiPantCode     
 Into #DeliveryClt               
 from    
 (    
  Select Sett_no,Sett_Type,scrip_cd,series,Party_code,Qty,Inout,Branch_Cd,PartiPantCode     
  From BSEDB.dbo.DeliveryClt with (nolock) Where Party_code=@pcode and InOut = 'I'     
 ) a    
 join #SETTMST b on a.Sett_no=b.sett_no and a.Sett_Type=b.sett_type     
               
    
 Select               
 a.Sett_No,a.Sett_Type,a.Scrip_Cd,a.Series,a.Party_Code,a.Drcr,a.Recqty,a.Filler2              
 Into #Deltrans              
 from    
 (              
 select C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Qty,c.Filler2              
 From BSEDB.dbo.Deltrans C with (nolock)              
 Where Party_code=@pcode And Drcr = 'C' And Filler2 = 1 And TrType <> 906              
 ) a join #SETTMST b on a.Sett_no=b.sett_no and a.Sett_Type=b.sett_type     
    
    
 select @pcode as party_code,Short_Name=SPACE(1), Branch_Cd=SPACE(1), sub_broker=SPACE(1)       
 INTO #CLIENT               
               
 Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(D.Recqty, 0)), Isettqty = 0, Ibenqty = 0,              
 Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')             
 Into #delpayinmatch              
 From  
 (  
 select d.*,c.Recqty from              
 (  
   select D.Sett_No,D.Sett_Type,D.Scrip_Cd,D.Series,D.Party_Code,D.Qty,D.inout    
   from #Deliveryclt D with (nolock) where Inout = 'I'  
  )D              
  Left Outer Join               
  (  
   select Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,Drcr,Recqty=Recqty,Filler2    
   from  #Deltrans with (nolock)  
   where Filler2 = 1 and Drcr = 'C'  
  )C              
 On  D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type              
 And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series              
 And D.Party_Code = C.Party_Code   
 )D              
 inner join               
  BSEDB.dbo.Multiisin M with (nolock)  on              
 M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series               
 Where m.Valid = 1              
 Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin           
 Having D.Qty > 0              
               
 Delete From #delpayinmatch Where Delqty <= Recqty              
               
 Insert Into #delpayinmatch              
    
 Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0,Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then  D.Qty Else 0 End),              
 Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then  D.Qty Else 0 End),              
 Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then  D.Qty Else 0 End) ,              
 Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')            
 from    
 (    
 select Sett_No,Sett_type,TrType,Party_Code,Qty,CertNo,Delivered,ISett_No,ISett_Type,Filler2    
 From BSEDB.dbo.Deltrans D with (nolock)              
 Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)              
 and party_code=@pcode    
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type            
 Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno             
    
 union all              
    
 Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),              
 Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),              
 Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,              
 Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
 Scrip_Cd = Convert(Varchar(50), '')           
 from    
 (    
 select Sett_No,Sett_type,TrType,Party_Code,Qty,CertNo,Delivered,ISett_No,ISett_Type,Filler2    
 From msajag.Dbo.Deltrans D with(nolock)   
 Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)              
 and party_code=@pcode    
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type          
 Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno              
    
               
 Update #delpayinmatch     
 Set Hold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),              
 Pledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End)     
 From (              
 Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),              
 Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)              
 From BSEDB.dbo.Deltrans D with(nolock) inner join BSEDB.dbo.Deliverydp Dp with(nolock)             
 on D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno              
 Where D.party_code=@pcode and D.Filler2 = 1 And D.Drcr = 'D'              
 And D.Delivered = '0' And D.Trtype In (904, 909, 905) And  DP.[Description] Not Like '%pool%'              
 Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code              
 And A.Certno = #delpayinmatch.Certno              
               
 Update #delpayinmatch Set Nsehold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),              
 Nsepledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From (              
 Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),              
 Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)     
 From msajag.Dbo.Deltrans D with(nolock), msajag.Dbo.Deliverydp Dp  with(nolock)            
 Where D.party_code=@pcode and D.Filler2 = 1 And D.Drcr = 'D'              
 And D.Delivered = '0' And D.Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid              
 And D.Bcltdpid = Dp.Dpcltno And DP.[Description] Not Like '%pool%'              
 Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno              
               
 Update #delpayinmatch              
 Set Scrip_Cd = M.Scrip_Cd              
 From BSEDB.dbo.Scrip2 S2 with(nolock) INNER JOIN  BSEDB.dbo.MultiIsIn M  with(nolock)            
 on S2.BseCode = M.Scrip_Cd              
 where M.IsIn = #delpayinmatch.CertNo              
    
 delete from INTRANET.RISK.DBO.BSECM_shortage Where party_Code=@pcode             
    
 insert into INTRANET.RISK.DBO.BSECM_shortage              
 Select Sett_No, Sett_Type, R.Party_Code, convert(varchar(10),GETDATE(),103)+' '+convert(varchar(10),GETDATE(),108) as Short_Name,     
 '' as Branch_Cd, '' as sub_broker, Scrip_Cd, Certno,      
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),              
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),              
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge              
 From #delpayinmatch R (nolock)              
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, Scrip_Cd, Certno, Hold, Pledge, Nsehold,    Nsepledge              
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )              
 Order By Branch_Cd, R.Party_Code, Scrip_Cd              
               
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_nbfc
-- --------------------------------------------------
CREATE Proc Rpt_Delpayinmatch_nbfc
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)                 
AS                                        
                
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                          
                  
Select * Into #DeliveryClt From bsedb.dbo.DeliveryClt                  
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                  
And InOut = 'I'                  
                  
Select * Into #Deltrans From bsedb.dbo.Deltrans (nolock)                 
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                  
And Party_Code <> 'BROKER' And Drcr = 'C'                                           
And Filler2 = 1 And Sharetype <> 'Auction'                  
And TrType <> 906                
        
/*Added For online CLIENTS*/          
        
delete from #DeliveryClt where PARTY_CODE not in (select cltcode from INTRANET.risk.dbo.angel_miles_ledger with (nolock))        
delete from #Deltrans where PARTY_CODE not in (select cltcode from INTRANET.risk.dbo.angel_miles_ledger with (nolock))        
                
/*                
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                  
INTO #CLIENT FROM CLIENT1 C1, CLIENT2 C2                
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
*/                
                
                
                
/*SELECT PARTY_CODE, Short_Name, Branch_Cd, sub_broker                  
INTO #CLIENT FROM INTRANET.risk.dbo.client_details with (nolock)                
WHERE PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)   
*/  
  
select PARTY_CODE, Short_Name='', Branch_Cd='', sub_broker=''   INTO #CLIENT
from  
(  
SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans               
) a                
                
set transaction isolation level read uncommitted                              
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                                          
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                  
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                  
Into #delpayinmatch                                          
From #CLIENT C1, bsedb.dbo.Multiisin M  (nolock)      ,                 
#Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                           
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
From bsedb.dbo.Deltrans D (nolock)     , #Client C1 (nolock)                
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
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0)                 
From bsedb.dbo.Deltrans D (nolock)     , bsedb.dbo.Deliverydp Dp (nolock)                          
Where Filler2 = 1 And Drcr = 'D'                                           
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                           
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                           
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code                 
And A.Certno = #delpayinmatch.Certno                                          
                                          
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                             
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                          
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                          
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D (nolock)      , Msajag.Dbo.Deliverydp Dp  (nolock)                                               
Where Filler2 = 1 And Drcr = 'D'                             
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                       
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                           
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                          
                      
Update #delpayinmatch                 
--Set Scrip_Cd = S2.Scrip_Cd + ' ( ' + M.Scrip_Cd + ' )'                  
Set Scrip_Cd = M.Scrip_Cd                
From bsedb.dbo.Scrip2 S2, bsedb.dbo.MultiIsIn M                  
Where S2.BseCode = M.Scrip_Cd                  
And M.IsIn = CertNo                  
                  
If Upper(@Branchcd) = 'All'                                           
begin                              
 Select @Branchcd = '%'                                    
end                              
If @Opt = 1                              
begin                              
 set transaction isolation level read uncommitted                                           
 delete from BSECM_shortage_nbfc Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                           
-- truncate table   BSECM_shortage_nbfc               
 insert into BSECM_shortage_nbfc                 
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
                
 delete from BSECM_shortage_nbfc Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                           
-- truncate table   BSECM_shortage_nbfc               
 insert into BSECM_shortage_nbfc                 
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

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_online
-- --------------------------------------------------
CREATE Proc Rpt_Delpayinmatch_online                
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)                 
AS                                        
                
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                          
                  
Select * Into #DeliveryClt From bsedb.dbo.DeliveryClt                  
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                  
And InOut = 'I'                  
                  
Select * Into #Deltrans From bsedb.dbo.Deltrans (nolock)                 
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                  
And Party_Code <> 'BROKER' And Drcr = 'C'                                           
And Filler2 = 1 And Sharetype <> 'Auction'                  
And TrType <> 906                
        
/*Added For online CLIENTS*/          
        
delete from #DeliveryClt where PARTY_CODE not in (select cltcode from INTRANET.cms.dbo.cms_online_marked with (nolock))        
delete from #Deltrans where PARTY_CODE not in (select cltcode from INTRANET.cms.dbo.cms_online_marked with (nolock))        
                
/*                
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                  
INTO #CLIENT FROM CLIENT1 C1, CLIENT2 C2                
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
*/                
                
                
                
/*SELECT PARTY_CODE, Short_Name, Branch_Cd, sub_broker                  
INTO #CLIENT FROM INTRANET.risk.dbo.client_details with (nolock)                
WHERE PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)   
*/  
  
select PARTY_CODE, Short_Name='', Branch_Cd='', sub_broker=''   INTO #CLIENT
from  
(  
SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans               
) a                
                
set transaction isolation level read uncommitted                              
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                                          
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                  
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                  
Into #delpayinmatch                                          
From #CLIENT C1, bsedb.dbo.Multiisin M  (nolock)      ,                 
#Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                           
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
From bsedb.dbo.Deltrans D (nolock)     , #Client C1 (nolock)                
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
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0)                 
From bsedb.dbo.Deltrans D (nolock)     , bsedb.dbo.Deliverydp Dp (nolock)                          
Where Filler2 = 1 And Drcr = 'D'                                           
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                           
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                           
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code                 
And A.Certno = #delpayinmatch.Certno                                          
                                          
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                             
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                          
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                          
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D (nolock)      , Msajag.Dbo.Deliverydp Dp  (nolock)                                               
Where Filler2 = 1 And Drcr = 'D'                             
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                       
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                           
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                          
                      
Update #delpayinmatch                 
--Set Scrip_Cd = S2.Scrip_Cd + ' ( ' + M.Scrip_Cd + ' )'                  
Set Scrip_Cd = M.Scrip_Cd                
From bsedb.dbo.Scrip2 S2, bsedb.dbo.MultiIsIn M                  
Where S2.BseCode = M.Scrip_Cd                  
And M.IsIn = CertNo                  
                  
If Upper(@Branchcd) = 'All'                                           
begin                              
 Select @Branchcd = '%'                                    
end                              
If @Opt = 1                              
begin                              
 set transaction isolation level read uncommitted                                           
 delete from BSECM_shortage_online Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                           
-- truncate table   BSECM_shortage_online               
 insert into BSECM_shortage_online                 
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
                
 delete from BSECM_shortage_online Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                           
-- truncate table   BSECM_shortage_online               
 insert into BSECM_shortage_online                 
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

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSE_DELPAYINMATCH_BONDPRO_cli
-- --------------------------------------------------
Create Proc [dbo].[RPT_NSE_DELPAYINMATCH_BONDPRO_cli](@pcode as varchar(10) = null)       
AS      
      
SET NOCOUNT ON

SELECT SETT_TYPE,SETT_NO         
into #SEttMST
FROM msajag.dbo.sett_mst (NOLOCK)          
WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'          
AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00' 

Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = M.Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),      
Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,      
Pledge = 0, BSEHold = 0, BSEPledge = 0      
Into #delpayinmatch      
From      
(
	select a.Sett_No,a.Sett_Type,a.Party_Code,a.Qty,a.Series,a.Scrip_Cd from
	(
		select Sett_No,Sett_Type,Party_Code,Qty,Series,Scrip_Cd 
		from msajag.dbo.Deliveryclt with (nolock) 
		where party_code=@pcode and Inout = 'I'
	) a join #SEttMST b on a.sett_no=b.sett_no and a.sett_Type=b.sett_type

) D       
inner join       
(select ISIn,Scrip_Cd,Series from msajag.dbo.Multiisin with (nolock) where Valid = 1) M      
ON M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series       
Left Outer Join      
(Select Qty,Sett_No,Sett_Type,Party_Code,Series,Scrip_Cd from msajag.dbo.Deltrans with (nolock) where party_code=@pcode and drcr='C' and Filler2 = 1) C      
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type      
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series      
And D.Party_Code = C.Party_Code ) 
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, M.Isin      
Having D.Qty > 0
      
Delete From #delpayinmatch Where Delqty <= Recqty      
      
Insert Into #delpayinmatch      

Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
(
	select Isett_No,Isett_Type,Party_Code,Certno,Trtype,Qty,Delivered
	from
	msajag.Dbo.Deltrans C with (nolock)    
	Where party_Code=@pcode and Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)      
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type
Group By D.Isett_No, D.Isett_Type, D.Party_Code,D. Certno      

Insert Into #delpayinmatch      
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
(
	select Isett_No,Isett_Type,Party_Code,Certno,Trtype,Qty,Delivered
	from
	BSEDB.Dbo.Deltrans D with (nolock)      
	Where party_Code=@pcode and Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)      
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno--:03      
      
Update #delpayinmatch Set Hold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),      
Pledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From       
(      
	Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
	Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)     
	from
	(
		Select party_code,Certno,TrType,Qty,Bdpid,Bcltdpid,Filler2,Delivered
		From msajag.dbo.Deltrans with (nolock) 
		where party_Code=@pcode and Drcr = 'D' and Filler2 = 1 and Delivered = '0' and Trtype In (904, 909) 
	) D     
	inner join       
	msajag.dbo.Deliverydp Dp with (nolock)      
	on D.Bdpid = Dp.Dpid      
	And D.Bcltdpid = Dp.Dpcltno       
	And DP.[Description] Not Like '%pool%'      
	Group By D.Party_Code, D.Certno       
) A       
Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno     

      
Update #delpayinmatch Set Bsehold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),      
Bsepledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From       
(      
	Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
	Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)      
	From
	(
		Select party_code,Certno,TrType,Qty,Bdpid,Bcltdpid,Filler2,Delivered
		From BSEDB.Dbo.Deltrans with (nolock) 
		where party_Code=@pcode and Drcr = 'D' and Filler2 = 1 and Delivered = '0' and Trtype In (904, 909) 
	) D   
	inner join       
	 BSEDB.Dbo.Deliverydp Dp with (nolock)      
	ON D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno      
	Where DP.[Description] Not Like '%pool%'      
	Group By D.Party_Code, D.Certno       

) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno      
      
 delete from INTRANET.BOND.DBO.NSECM_Shortage where party_code=@pcode
 
        
insert into INTRANET.BOND.DBO.NSECM_Shortage       
Select R.Sett_No, R.Sett_Type, R.Party_Code, convert(varchar(10),GETDATE(),103)+' '+convert(varchar(10),GETDATE(),108)  as Short_Name, 
Branch_Cd='', Sub_Broker='', M.Scrip_Cd, R.Certno,      
Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),      
Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),      
Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge      
From         
#delpayinmatch R (nolock)      
inner join       
msajag.dbo.Multiisin M with (nolock)      
on  M.Isin = R.Certno      
Group By R.Sett_No, R.Sett_Type, R.Party_Code,M.Scrip_Cd, R.Certno,      
R.Hold, R.Pledge, R.BSEHold, R.BSEPledge      
Having Sum(R.Delqty) > (Sum(R.Recqty) + Sum(R.Isettqtyprint) + Sum(R.Ibenqtyprint) )      

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSE_DELPAYINMATCH_CMSPRO
-- --------------------------------------------------

CREATE Proc [dbo].[RPT_NSE_DELPAYINMATCH_CMSPRO]     
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)     
with recompile
AS    
    
    
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)    
    
set transaction isolation level read uncommitted    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
 Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = M.Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),    
 Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,    
 Pledge = 0, BSEHold = 0, BSEPledge = 0    
 Into #delpayinmatch    
 From    
 msajag.dbo.Client1 C1 with (nolock)    
 inner join msajag.dbo.Client2 C2 with (nolock)    
 on C1.Cl_Code = C2.Cl_Code     
 inner join     
 msajag.dbo.Deliveryclt D with (nolock)     
 ON  C2.Party_Code = D.Party_Code    
 inner join     
  msajag.dbo.Multiisin M with (nolock)     
 ON M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series     
 Left Outer Join    
 msajag.dbo.Deltrans C with (nolock)    
 On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type    
 And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series    
 And D.Party_Code = C.Party_Code And C.Drcr = 'C'    
 And c.Filler2 = 1 /*And Sharetype <> 'Auction'*/)    
 Where D.Inout = 'I' And M.Valid = 1    
 And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type      
 And @Statusname=    
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
 Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, M.Isin    
 Having D.Qty > 0--:4    
    
If @Opt <> 1    
Begin    
 Delete From #delpayinmatch Where Delqty <= Recqty    
End    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
    
    
set transaction isolation level read uncommitted    
Insert Into #delpayinmatch    
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,    
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0    
From     
 msajag.DBO.Client1 C1 with (nolock)    
inner join     
  msajag.DBO.Client2 C2 with (nolock)    
  on C1.Cl_Code = C2.Cl_Code    
  inner join     
  msajag.Dbo.Deltrans D with (nolock)    
  on C2.Party_Code = D.Party_Code      
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)    
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type    
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
Group By D.Isett_No, D.Isett_Type, D.Party_Code,D. Certno    
union all    
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,    
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0    
From     
 BSEDB.DBO.Client1 C1 with (nolock)    
inner join    
  BSEDB.DBO.Client2 C2 with (nolock)    
  on C1.Cl_Code = C2.Cl_Code    
  inner join     
  BSEDB.Dbo.Deltrans D with (nolock)    
  on C2.Party_Code = D.Party_Code      
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)    
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type    
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
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno--:03    
    
set transaction isolation level read uncommitted    
    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
    
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),    
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From     
(    
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),    
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)    
From msajag.dbo.Deltrans D with (nolock)    
inner join     
msajag.dbo.Deliverydp Dp with (nolock)    
on D.Bdpid = Dp.Dpid    
And D.Bcltdpid = Dp.Dpcltno     
Where D.Filler2 = 1 And D.Drcr = 'D'    
And D.Delivered = '0' And D.Trtype In (904, 909) And DP.[Description] Not Like '%pool%'    
Group By D.Party_Code, D.Certno     
) A     
Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno    
    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
    
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),    
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From     
(    
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),    
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)    
From BSEDB.Dbo.Deltrans D with (nolock)     
inner join     
 BSEDB.Dbo.Deliverydp Dp with (nolock)    
ON D.Bdpid = Dp.Dpid    
And D.Bcltdpid = Dp.Dpcltno    
Where D.Filler2 = 1 And D.Drcr = 'D'    
And D.Delivered = '0' And D.Trtype In (904, 909) And DP.[Description] Not Like '%pool%'    
Group By D.Party_Code, D.Certno     
) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10) ,    
 @Opt INT ,@BranchCD VARCHAR(30)    
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
    
    
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)    
SET @Opt =0    
*/    
  
If Upper(@Branchcd) = 'All'    
begin    
 Select @Branchcd = '%'    
end    
    
If @Opt = 1    
begin    
delete from INTRANET.RISK.DBO.NSECM_Shortage where sett_no=@sett_no and sett_type=@sett_type    
  
     
 set transaction isolation level read uncommitted    
     
     
insert into INTRANET.RISK.DBO.NSECM_Shortage    
 Select R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,    
 Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),    
 Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),    
 Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge    
 From      
  msajag.dbo.Client1 C1 with (nolock)    
  inner join     
 msajag.dbo.Client2 C2 with (nolock)    
 on C1.Cl_Code = C2.Cl_Code    
 inner join     
 #delpayinmatch R  with (nolock)    
 on R.Party_Code = C2.Party_Code     
 inner join     
 msajag.dbo.Multiisin M with (nolock)    
 on M.Isin = R.Certno     
 Where R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type    
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
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,    
 R.Certno, R.Hold, R.Pledge, R.BSEHold, R.BSEPledge    
 Having Sum(R.Delqty) > 0    
 --Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd    
end    
Else    
begin    
    
 delete from INTRANET.RISK.DBO.NSECM_Shortage where sett_no=@sett_no and sett_type=@sett_type    
   
     
 set transaction isolation level read uncommitted    
     
 insert into INTRANET.RISK.DBO.NSECM_Shortage     
 Select R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,    
 Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),    
 Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),    
 Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge    
 From       
  msajag.dbo.Client1 C1 with (nolock)    
  inner join     
 msajag.dbo.Client2 C2 with (nolock)    
 on C1.Cl_Code = C2.Cl_Code    
 inner join     
 #delpayinmatch R (nolock)    
 on R.Party_Code = C2.Party_Code    
 inner join     
 msajag.dbo.Multiisin M with (nolock)    
 on  M.Isin = R.Certno    
 Where  R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type     
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
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,    
 R.Hold, R.Pledge, R.BSEHold, R.BSEPledge    
 Having Sum(R.Delqty) > (Sum(R.Recqty) + Sum(R.Isettqtyprint) + Sum(R.Ibenqtyprint) )    
 --Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSE_DELPAYINMATCH_CMSPRO_cli
-- --------------------------------------------------
CREATE Proc RPT_NSE_DELPAYINMATCH_CMSPRO_cli(@pcode as varchar(10) = null)       
AS      
      
SET NOCOUNT ON

SELECT SETT_TYPE,SETT_NO         
into #SEttMST
FROM msajag.dbo.sett_mst (NOLOCK)          
WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'          
AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00' 

Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = M.Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),      
Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,      
Pledge = 0, BSEHold = 0, BSEPledge = 0      
Into #delpayinmatch      
From      
(
	select a.Sett_No,a.Sett_Type,a.Party_Code,a.Qty,a.Series,a.Scrip_Cd from
	(
		select Sett_No,Sett_Type,Party_Code,Qty,Series,Scrip_Cd 
		from msajag.dbo.Deliveryclt with (nolock) 
		where party_code=@pcode and Inout = 'I'
	) a join #SEttMST b on a.sett_no=b.sett_no and a.sett_Type=b.sett_type

) D       
inner join       
(select ISIn,Scrip_Cd,Series from msajag.dbo.Multiisin with (nolock) where Valid = 1) M      
ON M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series       
Left Outer Join      
(Select Qty,Sett_No,Sett_Type,Party_Code,Series,Scrip_Cd from msajag.dbo.Deltrans with (nolock) where party_code=@pcode and drcr='C' and Filler2 = 1) C      
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type      
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series      
And D.Party_Code = C.Party_Code ) 
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, M.Isin      
Having D.Qty > 0
      
Delete From #delpayinmatch Where Delqty <= Recqty      
      
Insert Into #delpayinmatch      

Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
(
	select Isett_No,Isett_Type,Party_Code,Certno,Trtype,Qty,Delivered
	from
	msajag.Dbo.Deltrans C with (nolock)    
	Where party_Code=@pcode and Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)      
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type
Group By D.Isett_No, D.Isett_Type, D.Party_Code,D. Certno      

Insert Into #delpayinmatch      
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
(
	select Isett_No,Isett_Type,Party_Code,Certno,Trtype,Qty,Delivered
	from
	BSEDB.Dbo.Deltrans D with (nolock)      
	Where party_Code=@pcode and Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)      
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno--:03      
      
Update #delpayinmatch Set Hold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),      
Pledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From       
(      
	Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
	Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)     
	from
	(
		Select party_code,Certno,TrType,Qty,Bdpid,Bcltdpid,Filler2,Delivered
		From msajag.dbo.Deltrans with (nolock) 
		where party_Code=@pcode and Drcr = 'D' and Filler2 = 1 and Delivered = '0' and Trtype In (904, 909) 
	) D     
	inner join       
	msajag.dbo.Deliverydp Dp with (nolock)      
	on D.Bdpid = Dp.Dpid      
	And D.Bcltdpid = Dp.Dpcltno       
	And DP.[Description] Not Like '%pool%'      
	Group By D.Party_Code, D.Certno       
) A       
Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno     

      
Update #delpayinmatch Set Bsehold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),      
Bsepledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From       
(      
	Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
	Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)      
	From
	(
		Select party_code,Certno,TrType,Qty,Bdpid,Bcltdpid,Filler2,Delivered
		From BSEDB.Dbo.Deltrans with (nolock) 
		where party_Code=@pcode and Drcr = 'D' and Filler2 = 1 and Delivered = '0' and Trtype In (904, 909) 
	) D   
	inner join       
	 BSEDB.Dbo.Deliverydp Dp with (nolock)      
	ON D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno      
	Where DP.[Description] Not Like '%pool%'      
	Group By D.Party_Code, D.Certno       

) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno      
      
 delete from INTRANET.RISK.DBO.NSECM_Shortage where party_code=@pcode
       
insert into INTRANET.RISK.DBO.NSECM_Shortage       
Select R.Sett_No, R.Sett_Type, R.Party_Code, convert(varchar(10),GETDATE(),103)+' '+convert(varchar(10),GETDATE(),108)  as Short_Name, 
Branch_Cd='', Sub_Broker='', M.Scrip_Cd, R.Certno,      
Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),      
Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),      
Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge      
From         
#delpayinmatch R (nolock)      
inner join       
msajag.dbo.Multiisin M with (nolock)      
on  M.Isin = R.Certno      
Group By R.Sett_No, R.Sett_Type, R.Party_Code,M.Scrip_Cd, R.Certno,      
R.Hold, R.Pledge, R.BSEHold, R.BSEPledge      
Having Sum(R.Delqty) > (Sum(R.Recqty) + Sum(R.Isettqtyprint) + Sum(R.Ibenqtyprint) )      

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSE_DELPAYINMATCH_CMSPRO_cli_LimitALG
-- --------------------------------------------------


CREATE Proc [dbo].[RPT_NSE_DELPAYINMATCH_CMSPRO_cli_LimitALG](@pcode as varchar(10) = null)       
AS      
      
SET NOCOUNT ON

--declare @pcode as varchar(10)= null

SELECT SETT_TYPE,SETT_NO         
into #SEttMST
FROM msajag.dbo.sett_mst (NOLOCK)          
WHERE SEC_PAYIN >= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00'          
AND START_DATE <= CONVERT(VARCHAR(11),GETDATE())+' 00:00:00' 

Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = M.Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),      
Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,      
Pledge = 0, BSEHold = 0, BSEPledge = 0      
Into #delpayinmatch      
From      
(
	select a.Sett_No,a.Sett_Type,a.Party_Code,a.Qty,a.Series,a.Scrip_Cd from
	(
		select Sett_No,Sett_Type,Party_Code,Qty,Series,Scrip_Cd 
		from msajag.dbo.Deliveryclt with (nolock) 
		where party_code=@pcode and Inout = 'I'
	) a join #SEttMST b on a.sett_no=b.sett_no and a.sett_Type=b.sett_type

) D       
inner join       
(select ISIn,Scrip_Cd,Series from msajag.dbo.Multiisin with (nolock) where Valid = 1) M      
ON M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series       
Left Outer Join      
(Select Qty,Sett_No,Sett_Type,Party_Code,Series,Scrip_Cd from msajag.dbo.Deltrans with (nolock) where party_code=@pcode and drcr='C' and Filler2 = 1) C      
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type      
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series      
And D.Party_Code = C.Party_Code ) 
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, M.Isin      
Having D.Qty > 0
      
Delete From #delpayinmatch Where Delqty <= Recqty      
      
Insert Into #delpayinmatch      

Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
(
	select Isett_No,Isett_Type,Party_Code,Certno,Trtype,Qty,Delivered
	from
	msajag.Dbo.Deltrans C with (nolock)    
	Where party_Code=@pcode and Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)      
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type
Group By D.Isett_No, D.Isett_Type, D.Party_Code,D. Certno      

Insert Into #delpayinmatch      
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
(
	select Isett_No,Isett_Type,Party_Code,Certno,Trtype,Qty,Delivered
	from
	BSEDB.Dbo.Deltrans D with (nolock)      
	Where party_Code=@pcode and Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)      
) D join  #SEttMST  b on D.Isett_No=b.sett_no and D.Isett_Type=b.sett_type
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno--:03      
      
Update #delpayinmatch Set Hold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),      
Pledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From       
(      
	Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
	Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)     
	from
	(
		Select party_code,Certno,TrType,Qty,Bdpid,Bcltdpid,Filler2,Delivered
		From msajag.dbo.Deltrans with (nolock) 
		where party_Code=@pcode and Drcr = 'D' and Filler2 = 1 and Delivered = '0' and Trtype In (904, 909) 
	) D     
	inner join       
	msajag.dbo.Deliverydp Dp with (nolock)      
	on D.Bdpid = Dp.Dpid      
	And D.Bcltdpid = Dp.Dpcltno       
	And DP.[Description] Not Like '%pool%'      
	Group By D.Party_Code, D.Certno       
) A       
Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno     

      
Update #delpayinmatch Set Bsehold = A.Hold + (Case When 'broker' <> 'broker' then A.Pledge Else 0 End),      
Bsepledge = (Case When 'broker' = 'broker' then A.Pledge Else 0 End) From       
(      
	Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
	Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)      
	From
	(
		Select party_code,Certno,TrType,Qty,Bdpid,Bcltdpid,Filler2,Delivered
		From BSEDB.Dbo.Deltrans with (nolock) 
		where party_Code=@pcode and Drcr = 'D' and Filler2 = 1 and Delivered = '0' and Trtype In (904, 909) 
	) D   
	inner join       
	 BSEDB.Dbo.Deliverydp Dp with (nolock)      
	ON D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno      
	Where DP.[Description] Not Like '%pool%'      
	Group By D.Party_Code, D.Certno       

) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno 

          
-- delete from NSECM_Shortage where party_code=@pcode
       
--insert into NSECM_Shortage       
Select R.Sett_No, R.Sett_Type, R.Party_Code, convert(varchar(10),GETDATE(),103)+' '+convert(varchar(10),GETDATE(),108)  as Short_Name, 
Branch_Cd='', Sub_Broker='', M.Scrip_Cd, R.Certno,      
Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),      
Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),      
Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge      
From         
#delpayinmatch R (nolock)      
inner join       
msajag.dbo.Multiisin M with (nolock)      
on  M.Isin = R.Certno      
Group By R.Sett_No, R.Sett_Type, R.Party_Code,M.Scrip_Cd, R.Certno,      
R.Hold, R.Pledge, R.BSEHold, R.BSEPledge      
Having Sum(R.Delqty) > (Sum(R.Recqty) + Sum(R.Isettqtyprint) + Sum(R.Ibenqtyprint) )      

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSE_DELPAYINMATCH_CMSPRO_GPX
-- --------------------------------------------------

create Proc [dbo].[RPT_NSE_DELPAYINMATCH_CMSPRO_GPX]     
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)     
with recompile
AS    
    
    
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)    
    
set transaction isolation level read uncommitted    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
 Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = M.Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),    
 Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,    
 Pledge = 0, BSEHold = 0, BSEPledge = 0    
 Into #delpayinmatch    
 From    
 msajag.dbo.Client1 C1 with (nolock)    
 inner join msajag.dbo.Client2 C2 with (nolock)    
 on C1.Cl_Code = C2.Cl_Code     
 inner join     
 msajag.dbo.Deliveryclt D with (nolock)     
 ON  C2.Party_Code = D.Party_Code    
 inner join     
  msajag.dbo.Multiisin M with (nolock)     
 ON M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series     
 Left Outer Join    
 msajag.dbo.Deltrans C with (nolock)    
 On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type    
 And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series    
 And D.Party_Code = C.Party_Code And C.Drcr = 'C'    
 And c.Filler2 = 1 /*And Sharetype <> 'Auction'*/)    
 Where D.Inout = 'I' And M.Valid = 1    
 And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type      
 And @Statusname=    
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
 Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, M.Isin    
 Having D.Qty > 0--:4    
    
If @Opt <> 1    
Begin    
 Delete From #delpayinmatch Where Delqty <= Recqty    
End    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
    
    
set transaction isolation level read uncommitted    
Insert Into #delpayinmatch    
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,    
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0    
From     
 msajag.DBO.Client1 C1 with (nolock)    
inner join     
  msajag.DBO.Client2 C2 with (nolock)    
  on C1.Cl_Code = C2.Cl_Code    
  inner join     
  msajag.Dbo.Deltrans D with (nolock)    
  on C2.Party_Code = D.Party_Code      
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)    
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type    
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
Group By D.Isett_No, D.Isett_Type, D.Party_Code,D. Certno    
union all    
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),    
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),    
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,    
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0    
From     
 BSEDB.DBO.Client1 C1 with (nolock)    
inner join    
  BSEDB.DBO.Client2 C2 with (nolock)    
  on C1.Cl_Code = C2.Cl_Code    
  inner join     
  BSEDB.Dbo.Deltrans D with (nolock)    
  on C2.Party_Code = D.Party_Code      
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)    
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type    
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
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno--:03    
    
set transaction isolation level read uncommitted    
    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
    
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),    
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From     
(    
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),    
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)    
From msajag.dbo.Deltrans D with (nolock)    
inner join     
msajag.dbo.Deliverydp Dp with (nolock)    
on D.Bdpid = Dp.Dpid    
And D.Bcltdpid = Dp.Dpcltno     
Where D.Filler2 = 1 And D.Drcr = 'D'    
And D.Delivered = '0' And D.Trtype In (904, 909) And DP.[Description] Not Like '%pool%'    
Group By D.Party_Code, D.Certno     
) A     
Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno    
    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)      
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
*/    
    
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),    
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From     
(    
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),    
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)    
From BSEDB.Dbo.Deltrans D with (nolock)     
inner join     
 BSEDB.Dbo.Deliverydp Dp with (nolock)    
ON D.Bdpid = Dp.Dpid    
And D.Bcltdpid = Dp.Dpcltno    
Where D.Filler2 = 1 And D.Drcr = 'D'    
And D.Delivered = '0' And D.Trtype In (904, 909) And DP.[Description] Not Like '%pool%'    
Group By D.Party_Code, D.Certno     
) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno    
    
/*    
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10) ,    
 @Opt INT ,@BranchCD VARCHAR(30)    
    
 set @StatusId ='broker'    
 set @Statusname='BROKER'     
 set @segment ='BSECM'      
 set @sett_Type ='A'      
 set @sett_no='2012191'    
    
    
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)    
SET @Opt =0    
*/    
  
If Upper(@Branchcd) = 'All'    
begin    
 Select @Branchcd = '%'    
end    
    
If @Opt = 1    
begin    
delete from [10.253.33.29].RISK.DBO.NSECM_Shortage where sett_no=@sett_no and sett_type=@sett_type    
  
     
 set transaction isolation level read uncommitted    
     
     
insert into [10.253.33.29].RISK.DBO.NSECM_Shortage    
 Select R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,    
 Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),    
 Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),    
 Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge    
 From      
  msajag.dbo.Client1 C1 with (nolock)    
  inner join     
 msajag.dbo.Client2 C2 with (nolock)    
 on C1.Cl_Code = C2.Cl_Code    
 inner join     
 #delpayinmatch R  with (nolock)    
 on R.Party_Code = C2.Party_Code     
 inner join     
 msajag.dbo.Multiisin M with (nolock)    
 on M.Isin = R.Certno     
 Where R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type    
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
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,    
 R.Certno, R.Hold, R.Pledge, R.BSEHold, R.BSEPledge    
 Having Sum(R.Delqty) > 0    
 --Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd    
end    
Else    
begin    
    
 delete from [10.253.33.29].RISK.DBO.NSECM_Shortage where sett_no=@sett_no and sett_type=@sett_type    
   
     
 set transaction isolation level read uncommitted    
     
 insert into [10.253.33.29].RISK.DBO.NSECM_Shortage     
 Select R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,    
 Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),    
 Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),    
 Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge    
 From       
  msajag.dbo.Client1 C1 with (nolock)    
  inner join     
 msajag.dbo.Client2 C2 with (nolock)    
 on C1.Cl_Code = C2.Cl_Code    
 inner join     
 #delpayinmatch R (nolock)    
 on R.Party_Code = C2.Party_Code    
 inner join     
 msajag.dbo.Multiisin M with (nolock)    
 on  M.Isin = R.Certno    
 Where  R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type     
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
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,    
 R.Hold, R.Pledge, R.BSEHold, R.BSEPledge    
 Having Sum(R.Delqty) > (Sum(R.Recqty) + Sum(R.Isettqtyprint) + Sum(R.Ibenqtyprint) )    
 --Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSE_Delpayinmatch_nbfc
-- --------------------------------------------------
CREATE Proc Rpt_NSE_Delpayinmatch_nbfc
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int) AS                            
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                    
          
set transaction isolation level read uncommitted    
  
--select cl_code=cltcode,Party_Code=cltcode into #client2 from INTRANET.risk.dbo.angel_miles_ledger with (nolock)  

select cl_code=cltcode,Party_Code=cltcode, Short_Name='', Branch_Cd='', sub_broker=''   
into #client2 from INTRANET.risk.dbo.angel_miles_ledger with (nolock)


                            
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),           
Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,           
Pledge = 0, BSEHold = 0, BSEPledge = 0           
Into #delpayinmatch          
From           
#client2 C1 , #client2 C2  ,           
msajag.dbo.Multiisin M (NOLOCK), msajag.dbo.Deliveryclt D (NOLOCK)          
Left Outer Join           
msajag.dbo.Deltrans C           
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                              
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                               
And D.Party_Code = C.Party_Code And Drcr = 'C'                               
And Filler2 = 1 And Sharetype <> 'Auction')                              
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                              
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                              
And C1.Cl_Code = C2.Cl_Code                          
And C2.Party_Code = D.Party_Code                          
And @StatusName ='BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */
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
From Msajag.Dbo.Deltrans D (NOLOCK), #client2 C1 , #client2 C2                    
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                              
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                              
And C1.Cl_Code = C2.Cl_Code                          
And C2.Party_Code = D.Party_Code                          
And @StatusName ='BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                     
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
From BSEDB.Dbo.Deltrans D (NOLOCK) , #client2 C1  , #client2 C2                               
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                              
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                              
And C1.Cl_Code = C2.Cl_Code                          
And C2.Party_Code = D.Party_Code                          
And @StatusName = 'BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                        
Group By Isett_No, Isett_Type, D.Party_Code, Certno                              
                    
set transaction isolation level read uncommitted                    
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),            
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                          
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                              
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)             
From msajag.dbo.Deltrans D (NOLOCK) , msajag.dbo.Deliverydp Dp (NOLOCK)          
Where Filler2 = 1 And Drcr = 'D'                               
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                               
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                               
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                              
                  
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                   
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                 
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                              
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                         
From BSEDB.Dbo.Deltrans D (NOLOCK), BSEDB.Dbo.Deliverydp Dp  (NOLOCK)          
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
delete from NSECM_Shortage_nbfc where sett_no=@sett_no and sett_type=@sett_type          
set transaction isolation level read uncommitted                              
insert into NSECM_Shortage_nbfc          
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                              
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                              
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                              
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                              
From #delpayinmatch R (nolock), msajag.dbo.Multiisin M  (NOLOCK),           
#client2 C2  , #client2 C1          
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                               
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                               
And C1.Branch_Cd Like @Branchcd                                
And @StatusName = 'BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                 End)                           */                       
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,                           
Certno, Hold, Pledge, BSEHold, BSEPledge                        
Having Sum(Delqty) > 0                               
--Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                               
end                    
Else                    
begin                    
          
delete from NSECM_Shortage_nbfc where sett_no=@sett_no and sett_type=@sett_type          
set transaction isolation level read uncommitted                              
insert into NSECM_Shortage_nbfc          
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                              
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                              
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                              
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                              
From #delpayinmatch R (nolock), msajag.dbo.Multiisin M  (NOLOCK),           
#client2 C2  , #client2 C1           
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                               
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                 
--And C1.Branch_Cd Like @Branchcd                                
And @StatusName ='BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                         
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                           
Hold, Pledge, BSEHold, BSEPledge                              
Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                               
--Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSE_Delpayinmatch_NSE
-- --------------------------------------------------

CREATE Proc Rpt_NSE_Delpayinmatch_NSE                     
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int) AS                    
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)            
  
set transaction isolation level read uncommitted                      
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),   
Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,   
Pledge = 0, BSEHold = 0, BSEPledge = 0   
Into #delpayinmatch  
From   
angeldemat.msajag.dbo.Client1 C1, angeldemat.msajag.dbo.Client2 C2,   
angeldemat.msajag.dbo.Multiisin M, angeldemat.msajag.dbo.Deliveryclt D   
Left Outer Join   
angeldemat.msajag.dbo.Deltrans C   
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
From angeldemat.Msajag.Dbo.Deltrans D, angeldemat.MSAJAG.DBO.Client1 C1, angeldemat.MSAJAG.DBO.Client2 C2                       
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
From angeldemat.BSEDB.Dbo.Deltrans D, angeldemat.BSEDB.DBO.Client1 C1, angeldemat.BSEDB.DBO.Client2 C2                       
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
From angeldemat.msajag.dbo.Deltrans D , angeldemat.msajag.dbo.Deliverydp Dp   
Where Filler2 = 1 And Drcr = 'D'                       
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                       
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                       
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                      
          
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),           
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                      
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                 
From angeldemat.BSEDB.Dbo.Deltrans D , angeldemat.BSEDB.Dbo.Deliverydp Dp    
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
delete from NSECM_Shortage where sett_no=@sett_no and sett_type=@sett_type  
set transaction isolation level read uncommitted                      
insert into NSECM_Shortage  
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                      
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                      
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                      
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                      
From #delpayinmatch R (nolock), angeldemat.msajag.dbo.Multiisin M ,   
angeldemat.msajag.dbo.Client2 C2 , angeldemat.msajag.dbo.Client1 C1   
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
--Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                       
end            
Else            
begin            
  
delete from NSECM_Shortage_temp where sett_no=@sett_no and sett_type=@sett_type 
 
set transaction isolation level read uncommitted                      
insert into NSECM_Shortage_temp  
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                      
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                      
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                      
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                      
From #delpayinmatch R (nolock), angeldemat.msajag.dbo.Multiisin M ,   
angeldemat.msajag.dbo.Client2 C2 , angeldemat.msajag.dbo.Client1 C1   
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
--Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSE_Delpayinmatch_online
-- --------------------------------------------------
  
CREATE Proc Rpt_NSE_Delpayinmatch_online                             
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int) AS                            
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                    
          
set transaction isolation level read uncommitted    
  
--select cl_code=cltcode,Party_Code=cltcode into #client2 from INTRANET.cms.dbo.cms_online_marked with (nolock)  

select cl_code=cltcode,Party_Code=cltcode, Short_Name='', Branch_Cd='', sub_broker=''   
into #client2 from INTRANET.cms.dbo.cms_online_marked with (nolock)


                            
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),           
Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,           
Pledge = 0, BSEHold = 0, BSEPledge = 0           
Into #delpayinmatch          
From           
#client2 C1 , #client2 C2  ,           
msajag.dbo.Multiisin M (NOLOCK), msajag.dbo.Deliveryclt D (NOLOCK)          
Left Outer Join           
msajag.dbo.Deltrans C           
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                              
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                               
And D.Party_Code = C.Party_Code And Drcr = 'C'                               
And Filler2 = 1 And Sharetype <> 'Auction')                              
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                              
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                              
And C1.Cl_Code = C2.Cl_Code                          
And C2.Party_Code = D.Party_Code                          
And @StatusName ='BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */
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
From Msajag.Dbo.Deltrans D (NOLOCK), #client2 C1 , #client2 C2                    
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                              
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                              
And C1.Cl_Code = C2.Cl_Code                          
And C2.Party_Code = D.Party_Code                          
And @StatusName ='BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                     
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
From BSEDB.Dbo.Deltrans D (NOLOCK) , #client2 C1  , #client2 C2                               
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                              
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                              
And C1.Cl_Code = C2.Cl_Code                          
And C2.Party_Code = D.Party_Code                          
And @StatusName = 'BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                        
Group By Isett_No, Isett_Type, D.Party_Code, Certno                              
                    
set transaction isolation level read uncommitted                    
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                   
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                          
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                              
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)             
From msajag.dbo.Deltrans D (NOLOCK) , msajag.dbo.Deliverydp Dp (NOLOCK)          
Where Filler2 = 1 And Drcr = 'D'                               
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                               
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                               
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                              
                  
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                   
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                 
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                              
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                         
From BSEDB.Dbo.Deltrans D (NOLOCK), BSEDB.Dbo.Deliverydp Dp  (NOLOCK)          
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
delete from NSECM_Shortage_online where sett_no=@sett_no and sett_type=@sett_type          
set transaction isolation level read uncommitted                              
insert into NSECM_Shortage_online          
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                              
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                              
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                              
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                              
From #delpayinmatch R (nolock), msajag.dbo.Multiisin M  (NOLOCK),           
#client2 C2  , #client2 C1          
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                               
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                               
And C1.Branch_Cd Like @Branchcd                                
And @StatusName = 'BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                       
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,                           
Certno, Hold, Pledge, BSEHold, BSEPledge                        
Having Sum(Delqty) > 0                               
--Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                               
end                    
Else                    
begin                    
          
delete from NSECM_Shortage_online where sett_no=@sett_no and sett_type=@sett_type          
set transaction isolation level read uncommitted                              
insert into NSECM_Shortage_online          
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                              
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                              
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                              
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                              
From #delpayinmatch R (nolock), msajag.dbo.Multiisin M  (NOLOCK),           
#client2 C2  , #client2 C1           
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                               
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                 
--And C1.Branch_Cd Like @Branchcd                                
And @StatusName ='BROKER'                                
                /*  (case                         
                        when @StatusId = 'BRANCH' then c1.branch_cd                        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                        
                        when @StatusId = 'Trader' then c1.Trader                        
                        when @StatusId = 'Family' then c1.Family                        
                        when @StatusId = 'Area' then c1.Area                        
                        when @StatusId = 'Region' then c1.Region                        
                        when @StatusId = 'Client' then c2.party_code                        
                  else                         
                        'BROKER'                        
                  End)                           */                         
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                           
Hold, Pledge, BSEHold, BSEPledge                              
Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                               
--Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEARCHINALL
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[SEARCHINALL] 
(@STRFIND AS VARCHAR(MAX))
AS



BEGIN
    SET NOCOUNT ON; 
    --TO FIND STRING IN ALL PROCEDURES        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) SP_NAME
              ,OBJECT_DEFINITION(OBJECT_ID) SP_DEFINITION
        FROM   SYS.PROCEDURES
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@STRFIND+'%'
    END 

    --TO FIND STRING IN ALL VIEWS        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) VIEW_NAME
              ,OBJECT_DEFINITION(OBJECT_ID) VIEW_DEFINITION
        FROM   SYS.VIEWS
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@STRFIND+'%'
    END 

    --TO FIND STRING IN ALL FUNCTION        
    BEGIN
        SELECT ROUTINE_NAME           FUNCTION_NAME
              ,ROUTINE_DEFINITION     FUNCTION_DEFINITION
        FROM   INFORMATION_SCHEMA.ROUTINES
        WHERE  ROUTINE_DEFINITION LIKE '%'+@STRFIND+'%'
               AND ROUTINE_TYPE = 'FUNCTION'
        ORDER BY
               ROUTINE_NAME
    END

    --TO FIND STRING IN ALL TABLES OF DATABASE.    
    BEGIN
        SELECT T.NAME      AS TABLE_NAME
              ,C.NAME      AS COLUMN_NAME
        FROM   SYS.TABLES  AS T
               INNER JOIN SYS.COLUMNS C
                    ON  T.OBJECT_ID = C.OBJECT_ID
        WHERE  C.NAME LIKE '%'+@STRFIND+'%'
        ORDER BY
               TABLE_NAME
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Shortage_process
-- --------------------------------------------------

CREATE PROC SHORTAGE_PROCESS   
AS  
  
CREATE TABLE #DIY_REPROCESS_LOG  
  (SETT_NO VARCHAR(11),SETT_TYPE VARCHAR(2),PARTY_CODE VARCHAR(15),SHORT_NAME VARCHAR(200),BRANCH_CD VARCHAR(20),SUB_BROKER VARCHAR(20)  
  ,SCRIP_CD VARCHAR(15),CERTNO VARCHAR(20), DELQTY INT, RECQTY INT, ISETTQTYPRINT INT, ISETTQTYMARK INT,  
   IBENQTYPRINT INT, IBENQTYMARK INT, HOLD INT, PLEDGE  INT, BSEHOLD INT , BSEPLEDGE INT ,CL_TYPE VARCHAR(15), COLLATERAL INT  
   )  
      
  
   
SELECT SETT_NO,SETT_TYPE ,ROW_NUMBER()OVER(ORDER BY SETT_NO,SETT_TYPE DESC) SR_NO INTO #SETT   FROM MSAJAG.DBO.SETT_MST  
WHERE START_DATE <=CONVERT(VARCHAR(11),GETDATE(),120) AND SEC_PAYIN >=CONVERT(VARCHAR(11),GETDATE(),120) AND SETT_TYPE IN ('N','W','A','X','M','Z')   
     
 DECLARE @SETT_NO VARCHAR(8),@SETT_TYPE VARCHAR(3)  
 DECLARE @CNT INT,@ID INT  
   
  
 SELECT @CNT=COUNT(*) FROM #SETT   
  
  SET @ID =1  
  
WHILE (@ID<=@CNT)  
  
   BEGIN   --SELECT * FROM #PLD1  
             
    SELECT @SETT_NO=SETT_NO,@SETT_TYPE =SETT_TYPE FROM #SETT  WHERE SR_NO =@ID   
             
   INSERT  INTO #DIY_REPROCESS_LOG  
  ---EXEC [AngelDemat].MSAJAG.DBO.RPT_SHORTAGEPAYIN 'BROKER','BROKER','2020018','2020018','N','%',-1  
  EXEC  MSAJAG.DBO.RPT_DELPAYINMATCH 'BROKER', 'BROKER', @SETT_NO,@SETT_TYPE,'ALL','%',2  
  
      SET @ID =@ID +1   
   PRINT @ID  
 END     
  
   
 INSERT INTO SHORTAGE_DETAILS  
 SELECT * , SELL_SHORTAGE =(CASE WHEN DELQTY  -  RECQTY -  ISETTQTYPRINT -  IBENQTYPRINT>0   
   THEN DELQTY  -  RECQTY -  ISETTQTYPRINT -  IBENQTYPRINT   
   ELSE 0 END) ,GETDATE() AS PROCESS_DATE   
   FROM #DIY_REPROCESS_LOG  
  
   DROP TABLE #DIY_REPROCESS_LOG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_CUSA_Unsett_Filegenretion
-- --------------------------------------------------
-- exec  [dbo].[SP_CUSA_Unsett_Filegenretion]  


CREATE Proc [dbo].[SP_CUSA_Unsett_Filegenretion]                          
as                                          
begin      
     
      Select * into #cusa from INTRANET.cms.dbo.Vw_CUSA_Unsetteled_file with(nolock)

--Select * from #cusa

Create index #party on #cusa (party_code,isin)

Select Sett_no,sett_type,start_date,sec_payout into #sec  
from  msajag.dbo.sett_mst where sec_payin =convert(varchar(11),getdate(),120) and sett_type in ('N','w','M','Z')

 

Select Dptype,DPID,dpcltno into #dp from msajag.dbo.deliverydp where accounttype ='Pool'

Select d.party_code,scrip_cd,d.series,certno,sum(Qty) as qty ,d.bdpid,d.bcltdpid,d.cltdpid,d.dpid,'BTC' TR_TYPE into #POOLQty
from  MSAJAG.dbo.deltrans d with(nolock),#dp dp with(nolock) ,#sec S with(nolock)
where dp.dpcltno=Bcltdpid and dp.DPID=BDPID and BDPTYpe=dp.Dptype and s.sett_no=d.sett_no and s.sett_type =d.sett_type
and filler2=1 and drcr='d' and delivered ='0'
group by d.party_code,scrip_cd,d.series,certno ,d.bdpid,d.bcltdpid,d.cltdpid,d.dpid
 
 Create index #Py on #POOLQty (party_code,certno)
 
Select d.party_code,scrip_cd,d.series,certno,Qty =(Case when MarkedQty>Qty Then Qty else markedqty end) ,d.bdpid,d.bcltdpid,d.dpid,
d.cltdpid,'BTC' Tr_Type
from  #POOLQty d,#cusa C
where  
d.party_code=c.party_code  and
d.certno=c.ISIN
 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_CUSA_Unsett_Filegenretion1
-- --------------------------------------------------
-- exec  [dbo].[SP_CUSA_Unsett_Filegenretion1]  


CREATE Proc [dbo].[SP_CUSA_Unsett_Filegenretion1]                          
as                                          
begin      
     
      Select * into #cusa from INTRANET.cms.dbo.Vw_CUSA_Unsetteled_file

Select  top 10000 * from #cusa

--Create index #party on #cusa (party_code,isin)

--Select Sett_no,sett_type,start_date,sec_payout into #sec  
--from angeldemat.msajag.dbo.sett_mst where sec_payin =convert(varchar(11),getdate(),120) and sett_type in ('N','w','M','Z')

 

--Select Dptype,DPID,dpcltno into #dp from angeldemat.msajag.dbo.deliverydp where accounttype ='Pool'

--Select    d.party_code,scrip_cd,d.series,certno,sum(Qty) as qty ,d.bdpid,d.bcltdpid,d.cltdpid,d.dpid,'BTC' TR_TYPE into #POOLQty
--from  MSAJAG.dbo.deltrans d with(nolock),#dp dp with(nolock) ,#sec S with(nolock)
--where dp.dpcltno=Bcltdpid and dp.DPID=BDPID and BDPTYpe=dp.Dptype and s.sett_no=d.sett_no and s.sett_type =d.sett_type
--and filler2=1 and drcr='d' and delivered ='0'
--group by d.party_code,scrip_cd,d.series,certno ,d.bdpid,d.bcltdpid,d.cltdpid,d.dpid
 
-- Create index #Py on #POOLQty (party_code,certno)
 
--Select d.party_code,scrip_cd,d.series,certno,Qty =(Case when MarkedQty>Qty Then Qty else markedqty end) ,d.bdpid,d.bcltdpid,d.dpid,
--d.cltdpid,'BTC' Tr_Type
--from  #POOLQty d,#cusa C
--where  
--d.party_code=c.party_code  
----and 
----d.certno=c.ISIN
 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_Non_poa_Daily_Pos
-- --------------------------------------------------

CREATE PROC [DBO].[SP_NON_POA_DAILY_POS]
AS

INSERT  INTO  NON_POA_DAILY_CLIENTS_HIST
SELECT * ,GETDATE() FROM NON_POA_DAILY_CLIENTS

TRUNCATE TABLE NON_POA_DAILY_CLIENTS

INSERT INTO NON_POA_DAILY_CLIENTS
SELECT DISTINCT UPPER(LTRIM(RTRIM(PARTY_CODE))) AS PARTY_CODE ,GETDATE() AS TRANSDATE   FROM (
SELECT * FROM MSAJAG.DBO.DELIVERYCLT WHERE SETT_NO IN (SELECT SETT_NO FROM MSAJAG.DBO.SETT_MST WHERE START_DATE =CONVERT(VARCHAR(11),GETDATE(),120) AND SETT_TYPE ='M') 
AND INOUT='O' )A
WHERE EXISTS  (
SELECT  DISTINCT PARTY_CODE FROM MSAJAG.DBO.MULTICLTID M WHERE DEF=0 AND DPID IN ('12033200','12033201') 
UNION
SELECT  DISTINCT PARTY_CODE  FROM BSEDB.DBO.MULTICLTID M WHERE DEF=0 AND DPID IN ('12033200','12033201') )
GROUP BY PARTY_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_Non_poa_hld
-- --------------------------------------------------

CREATE Proc [dbo].[SP_Non_poa_hld]
as

SELECT PARTY_CODE,CltDpId,CERTNO,SUM(QTY) AS QTY,'pool' as Hold_type INTO #TEMP FROM (
SELECT PARTY_CODE,CltDpId,CERTNO,SUM(QTY) AS QTY FROM msajag.dbo.DELTRANS WHERE DRCR='D' AND Delivered ='0' AND Filler2=1
GROUP BY PARTY_CODE,CltDpId,CERTNO
UNION ALL
SELECT PARTY_CODE,CltDpId,CERTNO,SUM(QTY) AS QTY FROM BSEDB.DBO.DELTRANS WHERE DRCR='D' AND Delivered ='0' AND Filler2=1
GROUP BY PARTY_CODE,CltDpId,CERTNO) A
where EXISTS  (
select  distinct Party_code from msajag.dbo.multicltid m where def=0 AND DPID IN ('12033200','12033201')  AND A.CltDpId=M.CltDpNo
union
select  distinct Party_code  from bsedb.dbo.multicltid m where def=0 AND DPID IN ('12033200','12033201') AND A.CltDpId=M.CltDpNo)
GROUP BY PARTY_CODE,CltDpId,CERTNO

Alter table #TEMP
Alter column qty float
 
 declare @cnt int,@sett_no varchar(11),@sett_cnt int
 select @cnt=count(1) from msajag.dbo.sett_mst where Start_date=convert(varchar(11),getdate(),120) and Sett_type='M'

 select @sett_no=Sett_No from msajag.dbo.sett_mst where Start_date=convert(varchar(11),getdate(),120) and Sett_type='M'

 select @sett_cnt =count(1) from msajag.dbo.deliveryclt where Sett_no=@sett_no

  
  If (@cnt=0 or @sett_cnt=0)

	  begin

		insert into #TEMP
		select party_code,'',isin,sum(qty),'UNSe' as Hold_type  from [CSOKYC-6].general.dbo.rms_holding where accno ='unsettled'
		and  party_code in (
		select  distinct Party_code from msajag.dbo.multicltid m where def=0 and DPID IN ('12033200','12033201')
		union
		select  distinct Party_code  from bsedb.dbo.multicltid m where def=0 and DPID IN ('12033200','12033201'))
		group by party_code,isin

	  End
else 	
	Begin
 
		 select top 2 Sett_No into #sett from msajag.dbo.sett_mst where Start_date<=convert(varchar(11),getdate(),120) and Sett_type='M' order by Start_date desc

		insert into #TEMP
		select party_code,'',I_ISIN,sum(qty),'UNSe' as Hold_type  from msajag.dbo.deliveryclt where inout='O'
		and sett_no in (Select * from #sett) and sett_type in ('n','w')
		and  party_code in (
		select  distinct Party_code from msajag.dbo.multicltid m where def=0 and DPID IN ('12033200','12033201')
		union
		select  distinct Party_code  from bsedb.dbo.multicltid m where def=0 and DPID IN ('12033200','12033201'))
		group by party_code,I_ISIN

	End


 
select BOID CLIENT_CODE,BBOCODE NISE_PARTY_CODE  into #DUMP from AngelDP4.dmat.Citrus_usr.vw_nonpoaclient t
where isnull(BBOCODE,'')<>'' --and status='ACTIVE'
 

SELECT NISE_PARTY_CODE bbocode,hld_ac_code,hld_isin_code,FREE_QTY,'DP' AS DP_HOLD
INTO #cli 
FROM AngelDP4.DMAT.CITRUS_USR.HOLDING  h,#DUMP c
where hld_ac_code=CLIENT_CODE

--1203320002004967
insert into #TEMP
select *  from #cli

SELECT * INTO #DP FROM (
select  distinct Party_code, CltDpNo from msajag.dbo.multicltid m where def=0 and DPID IN ('12033200','12033201')
union
select  distinct Party_code ,CltDpNo  from bsedb.dbo.multicltid m where def=0 and  DPID IN ('12033200','12033201') )A 
 

update t set CltDpId=CltDpNo from  #TEMP t, #DP d
where t.Party_Code =d.Party_code
and CltDpId ='' 

delete  t  from    #TEMP t, #DP d
where t.Party_Code =d.Party_code
and CltDpId<>CltDpNo

insert into Non_POA_Hold_HST
select * from Non_POA_Hold
 
Truncate table Non_POA_Hold

 insert into Non_POA_Hold
select distinct party_code,CltDpId,'',certno,0,0,0,0 ,''   from #TEMP 
 
 

 update n set pool_qty =qty 
 from #TEMP t,Non_POA_Hold  n where Hold_type ='pool' and n.party_code =t.party_code and n.CltDpId=t.cltdpid and certno=isin 

  update n set dp_hold =qty 
 from #TEMP t,Non_POA_Hold  n where Hold_type ='DP' and n.party_code =t.party_code and n.CltDpId=t.cltdpid and certno=isin 

  update n set unsett =qty 
 from #TEMP t,Non_POA_Hold  n where Hold_type ='UNSe' and n.party_code =t.party_code and n.CltDpId=t.cltdpid and certno=isin 


 update  Non_POA_Hold set Total_Hold =  pool_qty	+unsett+	dp_hold	 


update n set scrip_cd =m.Scrip_cd from  Non_POA_Hold n,msajag.dbo.MultiIsin m
 where n.isin=m.isin and m.Valid= 1 
 

 update n set scrip_cd =m.Scrip_cd from  Non_POA_Hold n,BSEDB.dbo.MultiIsin m
 where n.isin=m.isin and m.Valid= 1  and n.scrip_cd =''

 update Non_POA_Hold set Dt_time=getdate()

delete  FROM Non_POA_Hold where Total_Hold=0

delete from Non_POA_Hold where party_Code in ('broker','0')

----select distinct party_Code from Non_POA_Hold order by party_Code --where party_Code ='broker'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_update_region_CN
-- --------------------------------------------------
CREATE proc dbo.sp_update_region_CN      
as      
    
insert into region (Regioncode,Description,Branch_code,flag)  
Select Regioncode,Description,Branch_code,'' from anand1.msajag.dbo.region where Branch_code not in      
(Select Branch_code from region)    
    
Select Branch_Code AS BrCd,replace(Reg_Code,'MUM','CSO')Reg_Code into #region from    
(Select * from region)x    
left outer join    
(Select Code,Reg_Code from intranet.risk.dbo.region)y    
on x.Branch_Code=y.Code    
where Fld_AccessCode = '' or Fld_AccessCode is null  
    
update region set Fld_AccessCode= Reg_Code from #region where Branch_Code=Brcd and Fld_AccessCode = '' or Fld_AccessCode is null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spLogIops197
-- --------------------------------------------------
create proc spLogIops197  
as  
  
insert into LogIops204  
select db_name(mf.database_id) as database_name, mf.physical_name,   
left(mf.physical_name, 1) as drive_letter,   
vfs.num_of_writes, vfs.num_of_bytes_written, vfs.io_stall_write_ms,   
mf.type_desc, vfs.num_of_reads, vfs.num_of_bytes_read, vfs.io_stall_read_ms,  
vfs.io_stall, vfs.size_on_disk_bytes,Recordtime = Getdate()  
from sys.master_files mf  
join sys.dm_io_virtual_file_stats(NULL, NULL) vfs  
on mf.database_id=vfs.database_id and mf.file_id=vfs.file_id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_DUMP_197BSEDB_CLIENT4_MULTICLTID
-- --------------------------------------------------

-- =============================================
-- AUTHOR:		<SOFTWARE>
-- CREATE DATE: <JUN 22,2013>
-- DESCRIPTION:	<BACKUP CLIENT4 AND MULTICLTID DATA FROM 197/BSEDB TO 197/INHOUSE DATABASE>
-- =============================================


CREATE PROC [dbo].[SPX_DUMP_197BSEDB_CLIENT4_MULTICLTID]
AS

DECLARE @ROWSCLT4 BIGINT,@ROWSMULTICLT BIGINT

SET @ROWSCLT4=0
SET @ROWSMULTICLT=0
--DELETE 7 DAYS OLD RECORDS---

DELETE FROM BSEDB_CLIENT4_DUMP WHERE DATE<=GETDATE()-7

DELETE FROM BSEDB_MULTICLTID_DUMP WHERE DATE<=GETDATE()-7
------------------------------

--INSERT DATA-----------------

INSERT INTO BSEDB_CLIENT4_DUMP(Cl_code,Party_code,Instru,BankID,Cltdpid,Depository,DefDp,date)
SELECT Cl_code,Party_code,Instru,BankID,Cltdpid,Depository,DefDp,GETDATE() FROM BSEDB.DBO.CLIENT4 WITH(NOLOCK)

SET @ROWSCLT4=@@ROWCOUNT 

INSERT INTO TBL_BACKUP_PROCESS_STATUS(ProcessName ,Status,RowsCount)
VALUES('197BSEDB_CLIENT4_BK','SUCCESS',@ROWSCLT4)


INSERT INTO BSEDB_MULTICLTID_DUMP(Party_code,CltDpNo,DpId,Introducer,DpType,Def,date)
SELECT Party_code, CltDpNo, DpId, Introducer, DpType, Def, GETDATE() FROM bsedb.DBO.MULTICLTID WITH(NOLOCK) --DDPIFLAG, 

SET @ROWSMULTICLT=@@ROWCOUNT 

INSERT INTO TBL_BACKUP_PROCESS_STATUS(ProcessName ,Status,RowsCount)
VALUES('196BSEDB_MULTICLTID_BK','SUCCESS',@ROWSMULTICLT)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_DUMP_197MSAJAG_CLIENT4_MULTICLTID
-- --------------------------------------------------
-- =============================================
-- AUTHOR:		<SOFTWARE>
-- CREATE DATE: <JUN 22,2013>
-- DESCRIPTION:	<BACKUP CLIENT4 AND MULTICLTID DATA FROM 197/MSAJAG TO 197/INHOUSE DATABASE>
-- =============================================


CREATE PROC [dbo].[SPX_DUMP_197MSAJAG_CLIENT4_MULTICLTID]
AS

--DELETE 7 DAYS OLD RECORDS---

DELETE FROM MSAJAG_CLIENT4_DUMP WHERE DATE<=GETDATE()-7

DELETE FROM MSAJAG_MULTICLTID_DUMP WHERE DATE<=GETDATE()-7
------------------------------

--INSERT DATA-----------------

INSERT INTO MSAJAG_CLIENT4_DUMP(Cl_code, Party_code, Instru, BankID, Cltdpid, Depository, DefDp, date)
SELECT Cl_code,Party_code,Instru,BankID,Cltdpid, Depository, DefDp, GETDATE() FROM MSAJAG.DBO.CLIENT4 WITH(NOLOCK)

INSERT INTO MSAJAG_MULTICLTID_DUMP(Party_code,CltDpNo,DpId,Introducer,DpType,Def,date)
SELECT Party_code,CltDpNo	,DpId,	Introducer,	DpType,	Def ,GETDATE() FROM MSAJAG.DBO.MULTICLTID WITH(NOLOCK)

-----------------------------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPS_Commodities_Shortage_File
-- --------------------------------------------------
CREATE PROC [dbo].[UPS_Commodities_Shortage_File](@B_sett_No as varchar(7),@N_sett_No as varchar(7))                                
as                                
                                
/*declare @B_sett_No as varchar(7),@N_sett_No as varchar(7)                                
set @B_sett_No = '2008181'                                
set @N_sett_No = '2008241'*/                  
                          
                                
DECLARE @s AS VARCHAR(500)                                
DECLARE @s1 AS VARCHAR(500)                                
DECLARE @file AS VARCHAR(100)                                
set @file = 'D:\upload1\Shortage_Commodites\PPShort'+replace(convert(varchar(11),getdate(),3),'/','')+'.csv'                                
                                
Select * from tbl_shortage_commodities                  
truncate table tbl_shortage_commodities                                
--*truncate table tbl_temp                          
                          
--*insert into tbl_temp                        
insert into tbl_shortage_commodities                           
exec bsedb.dbo.rpt_delpayinmatch 'broker','broker',@B_sett_No,'C','ALL','%%',2                      
                      
--*insert into tbl_temp                      
insert into tbl_shortage_commodities                      
exec bsedb.dbo.rpt_delpayinmatch 'broker','broker',@B_sett_No,'D','ALL','%%',2                      
                          
--*insert into tbl_shortage_commodities                      
--*select *,'' from tbl_temp                      
                                
insert into tbl_shortage_commodities                      
exec msajag.dbo.rpt_delpayinmatch 'broker','broker',@N_sett_No,'N','ALL','%%',2                      
                                
insert into tbl_shortage_commodities                                
exec msajag.dbo.rpt_delpayinmatch 'broker','broker',@N_sett_No,'W','ALL','%%',2                                
                                
select Sett_No,Sett_Type,substring(party_code,charindex('_',Party_Code)+1,10) as party_code,Short_Name,Branch_Cd,          
Sub_Broker,Scrip_Cd,Certno,Delqty-Recqty as shortage into #shortage1 from tbl_shortage_commodities                                  
          
/*-------------------- Query For buy of share on Previous Sett -------------*/          
          
declare @BSett_No AS VARCHAR(50)        
declare @NSett_No AS VARCHAR(50)        
        
set @BSett_No=(Select max(Sett_No) from sett_mst where Sett_No < @B_sett_No)        
set @NSett_No=(Select max(Sett_No) from msajag.dbo.sett_mst where Sett_No < @N_sett_No)        
        
select x.*,     
case when x.sett_type in ('C','D') then isnull(y.qty,0) else 0 end BSEQty,    
case when x.sett_type in ('N','W') then isnull(z.qty,0) else 0 end NSEQty into #shortage    
  from     
(Select * from #shortage1) x    
left outer join    
(Select * from intranet.risk.dbo.cumm_holding where sett_no = @BSett_No and bs = 'B')y     
/*and Party_code = 'M2095' and Isin = 'INE293A01013'*/    
on x.party_code = y.party_code and x.CertNo = y.isin    
left outer join    
(Select * from intranet.risk.dbo.cumm_holding where sett_no = @NSett_No and bs = 'B')z     
on x.party_code = z.party_code and x.CertNo = z.isin    
/*--------------------------------End--------------------------------------*/          
                                
select dpclcode,dpref5,accountid,sum(dpqty) as qty into #dpholding from mimansa.bits.dbo.angeldptran where dpflag = 'g' and dptrftag = '' and accountid in                            
('11198145','11198647') group by dpclcode,dpref5,accountid                                
                                
select x.*,y.accountid, y.qty into #short_final from                                 
(select * from #shortage)x                                 
left outer join                                
(select * from #dpholding) y on                                 
x.certNo =  y.dpref5  and x.party_code = y.dpclcode                                
                                
truncate table tbl_commdities_gen_shortage                                
truncate table tbl_commodities_short                                
                                
insert into tbl_commdities_gen_shortage                                
select 'Sett_No'+','+'Sett_Type'+','+'Party_Code'+','+'Short_Name'+','+'Branch_Cd'+','+'Sub_Broker'+','+'BSE_CODE'+','+'NSE_CODE'+','+'Scrip_Name'+','+'Certno'+','+'shortage'+','+'accountid'+','+'qty'+','+'BSEQty'+','+'NSEQty'          
                              
/*                              
insert into tbl_commdities_gen_shortage                                
select 'Sett_No'+','+'Sett_Type'+','+'Party_Code'+','+'Short_Name'+','+'Branch_Cd'+','+'Sub_Broker'+','+'Scrip_code'+','+'Scrip_Name'+','+'Certno'+','+'shortage'+','+'accountid'+','+'qty'                                
                              
insert into tbl_commodities_short                                
select Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,Sub_Broker,                                
case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_cd),charindex(')',reverse(scrip_cd))+1,7)) else scrip_cd end as scrip_code,                                
Scrip_Cd as Scrip_Name,Certno,shortage,accountid,qty from #short_final where accountid is not null                                
                                
insert into tbl_commdities_gen_shortage                                
select rtrim(ltrim(Sett_No))+','+rtrim(ltrim(Sett_Type))+','+rtrim(ltrim(Party_Code))+','+                                
rtrim(ltrim(Short_Name))+','+rtrim(ltrim(Branch_Cd))+','+rtrim(ltrim(Sub_Broker))+','+case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_cd),charindex(')',reverse(scrip_cd))+1,7)) else scrip_cd end+','+rtrim(ltrim(Scrip_Cd))+','+     
  
     
     
         
          
            
rtrim(ltrim(Certno))+','+ltrim(rtrim(convert(varchar,shortage)))+','+                                
rtrim(ltrim(convert(varchar,accountid)))+','+rtrim(ltrim(convert(varchar,qty))) from #short_final                                 
where accountid is not null                                
*/                              
                              
insert into tbl_commodities_short                                
select Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,Sub_Broker,                                
case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_cd),charindex(')',reverse(scrip_cd))+1,7)) else scrip_cd end as scrip_code,                                
Scrip_Cd as Scrip_Name,Certno,shortage,accountid,qty,BSEQty,NSEQty from #short_final where accountid is not null                                
                            
/*                                
insert into tbl_commdities_gen_shortage                                
select rtrim(ltrim(Sett_No))+','+rtrim(ltrim(Sett_Type))+','+rtrim(ltrim(Party_Code))+','+                                
rtrim(ltrim(Short_Name))+','+rtrim(ltrim(Branch_Cd))+','+rtrim(ltrim(Sub_Broker))+','+                              
case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_code),charindex(')',reverse(scrip_code))+1,7)) else scrip_code end+','+' '+','+rtrim(ltrim(scrip_name))+','+                                
rtrim(ltrim(Certno))+','+ltrim(rtrim(convert(varchar,shortage)))+','+                                
rtrim(ltrim(convert(varchar,accountid)))+','+rtrim(ltrim(convert(varchar,qty))) from tbl_commodities_short where sett_type in ('D','C')                                 
*/                            
insert into tbl_commdities_gen_shortage                                
select rtrim(ltrim(x.Sett_No))+','+rtrim(ltrim(x.Sett_Type))+','+rtrim(ltrim(x.Party_Code))+','+                                
rtrim(ltrim(x.Short_Name))+','+rtrim(ltrim(x.Branch_Cd))+','+rtrim(ltrim(x.Sub_Broker))+','+                              
case when  x.sett_type in ('C','D') then reverse(substring(reverse(x.scrip_code),charindex(')',                              
reverse(rtrim(ltrim(x.scrip_code))))+1,7)) else rtrim(ltrim(x.scrip_code)) end+','+isnull(rtrim(ltrim(y.NSEScrip_cd)),'')+','+rtrim(ltrim(x.scrip_name))+','+                                
rtrim(ltrim(x.Certno))+','+ltrim(rtrim(convert(varchar,x.shortage)))+','+                  
rtrim(ltrim(convert(varchar,x.accountid)))+','+rtrim(ltrim(convert(varchar,x.qty)))+','+rtrim(ltrim(convert(varchar,x.BSEQty)))+','+rtrim(ltrim(convert(varchar,x.NSEQty)))                                                  
 from                              
(select * from tbl_commodities_short where sett_type in ('C','D')) x left outer join mimansa.angelcs.dbo.angelscrip y on x.scrip_code = y.Scrip_cd and x.CertNo = y.ISIN                              
                            
                              
insert into tbl_commdities_gen_shortage                              
select rtrim(ltrim(x.Sett_No))+','+rtrim(ltrim(x.Sett_Type))+','+rtrim(ltrim(x.Party_Code))+','+                                
rtrim(ltrim(x.Short_Name))+','+rtrim(ltrim(x.Branch_Cd))+','+rtrim(ltrim(x.Sub_Broker))+','+y.Scrip_cd+','+                              
case when  x.sett_type in ('D','C') then reverse(substring(reverse(x.scrip_code),charindex(')',                              
reverse(x.scrip_code))+1,7)) else x.scrip_code end+','+rtrim(ltrim(x.scrip_name))+','+                                
rtrim(ltrim(x.Certno))+','+ltrim(rtrim(convert(varchar,x.shortage)))+','+                                
rtrim(ltrim(convert(varchar,x.accountid)))+','+rtrim(ltrim(convert(varchar,x.qty)))+','+rtrim(ltrim(convert(varchar,x.BSEQty)))+','+rtrim(ltrim(convert(varchar,x.NSEQty)))                               
 from                              
(select * from tbl_commodities_short where sett_type in ('N','W')) x left outer join mimansa.angelcs.dbo.angelscrip y on x.scrip_code = y.NSEScrip_cd and x.CertNo = y.ISIN                              
                              
                                
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Head FROM ANGELDEMAT.BSEDB.DBO.tbl_commdities_gen_shortage" queryout '+@file+' -c -SANGELDEMAT -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'            
set @s1= @s+''''                                                                                  
exec(@s1)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPS_Shortage_File
-- --------------------------------------------------
CREATE PROC [dbo].[UPS_Shortage_File](@B_sett_No as varchar(7),@N_sett_No as varchar(7))                            
as                            
                            
/*declare @B_sett_No as varchar(7),@N_sett_No as varchar(7)                            
set @B_sett_No = '2008160'                            
set @N_sett_No = '2008220'*/                
                      
                            
DECLARE @s AS VARCHAR(500)                            
DECLARE @s1 AS VARCHAR(500)                            
DECLARE @file AS VARCHAR(100)                            
set @file = 'D:\upload1\Shortage\PPShort'+replace(convert(varchar(11),getdate(),3),'/','')+'.csv'                            
                            
truncate table tbl_shortage                            
--*truncate table tbl_temp                      
                      
--*insert into tbl_temp                    
insert into tbl_shortage                       
exec bsedb.dbo.rpt_delpayinmatch 'broker','broker',@B_sett_No,'C','ALL','%%',2                  
                  
--*insert into tbl_temp                  
insert into tbl_shortage                  
exec bsedb.dbo.rpt_delpayinmatch 'broker','broker',@B_sett_No,'D','ALL','%%',2                  
                      
--*insert into tbl_shortage                  
--*select *,'' from tbl_temp                  
                            
insert into tbl_shortage                  
exec msajag.dbo.rpt_delpayinmatch 'broker','broker',@N_sett_No,'N','ALL','%%',2                  
                            
insert into tbl_shortage                            
exec msajag.dbo.rpt_delpayinmatch 'broker','broker',@N_sett_No,'W','ALL','%%',2                            
                            
select Sett_No,Sett_Type,substring(party_code,charindex('_',Party_Code)+1,10) as party_code,Short_Name,Branch_Cd,          
Sub_Broker,Scrip_Cd,Certno,Delqty-Recqty as shortage into #shortage1 from tbl_shortage           
          
/*-------------------- Query For buy of share on Previous Sett -------------*/          
          
declare @BSett_No AS VARCHAR(50)          
declare @NSett_No AS VARCHAR(50)          
          
set @BSett_No=(Select max(Sett_No) from sett_mst where Sett_No < @B_sett_No)          
set @NSett_No=(Select max(Sett_No) from msajag.dbo.sett_mst where Sett_No < @N_sett_No)          
          
select x.*,     
case when x.sett_type in ('C','D') then isnull(y.qty,0) else 0 end BSEQty,    
case when x.sett_type in ('N','W') then isnull(z.qty,0) else 0 end NSEQty into #shortage    
  from     
(Select * from #shortage1) x    
left outer join    
(Select * from intranet.risk.dbo.cumm_holding where sett_no = @BSett_No and bs = 'B')y     
/*and Party_code = 'M2095' and Isin = 'INE293A01013'*/    
on x.party_code = y.party_code and x.CertNo = y.isin    
left outer join    
(Select * from intranet.risk.dbo.cumm_holding where sett_no = @NSett_No and bs = 'B')z     
on x.party_code = z.party_code and x.CertNo = z.isin    
    
/*--------------------------------End--------------------------------------*/          
                            
select dpclcode,dpref5,accountid,sum(dpqty) as qty into #dpholding from mimansa.bits.dbo.angeldptran where dpflag = 'g' and dptrftag = '' and accountid in                            
('15464303','14216209','13326100') group by dpclcode,dpref5,accountid                            
                            
select x.*,y.accountid, y.qty into #short_final from                             
(select * from #shortage)x                             
left outer join                            
(select * from #dpholding) y on                             
x.certNo =  y.dpref5  and x.party_code = y.dpclcode                             
                            
truncate table tbl_gen_shortage                            
truncate table tbl_short                     
        
insert into tbl_gen_shortage                            
select 'Sett_No'+','+'Sett_Type'+','+'Party_Code'+','+'Short_Name'+','+'Branch_Cd'+','+'Sub_Broker'+','+'BSE_CODE'+','+'NSE_CODE'+','+'Scrip_Name'+','+'Certno'+','+'shortage'+','+'accountid'+','+'qty'+','+'BSEQty'+','+'NSEQty'          
              
/*                          
insert into tbl_gen_shortage                            
select 'Sett_No'+','+'Sett_Type'+','+'Party_Code'+','+'Short_Name'+','+'Branch_Cd'+','+'Sub_Broker'+','+'Scrip_code'+','+'Scrip_Name'+','+'Certno'+','+'shortage'+','+'accountid'+','+'qty'                            
                          
insert into tbl_short                            
select Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,Sub_Broker,                            
case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_cd),charindex(')',reverse(scrip_cd))+1,7)) else scrip_cd end as scrip_code,                            
Scrip_Cd as Scrip_Name,Certno,shortage,accountid,qty from #short_final where accountid is not null                            
                            
insert into tbl_gen_shortage                            
select rtrim(ltrim(Sett_No))+','+rtrim(ltrim(Sett_Type))+','+rtrim(ltrim(Party_Code))+','+                            
rtrim(ltrim(Short_Name))+','+rtrim(ltrim(Branch_Cd))+','+rtrim(ltrim(Sub_Broker))+','+case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_cd),charindex(')',reverse(scrip_cd))+1,7)) else scrip_cd end+','+rtrim(ltrim(Scrip_Cd))+','+      
  
    
      
        
          
                     
rtrim(ltrim(Certno))+','+ltrim(rtrim(convert(varchar,shortage)))+','+                            
rtrim(ltrim(convert(varchar,accountid)))+','+rtrim(ltrim(convert(varchar,qty))) from #short_final                             
where accountid is not null              
*/                          
                
insert into tbl_short                            
select Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,Sub_Broker,                         
case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_cd),charindex(')',reverse(scrip_cd))+1,7)) else scrip_cd end as scrip_code,                            
Scrip_Cd as Scrip_Name,Certno,shortage,accountid,qty,BSEQty,NSEQty from #short_final where accountid is not null                            
                        
/*                            
insert into tbl_gen_shortage                            
select rtrim(ltrim(Sett_No))+','+rtrim(ltrim(Sett_Type))+','+rtrim(ltrim(Party_Code))+','+                            
rtrim(ltrim(Short_Name))+','+rtrim(ltrim(Branch_Cd))+','+rtrim(ltrim(Sub_Broker))+','+                          
case when  sett_type in ('D','C') then reverse(substring(reverse(scrip_code),charindex(')',reverse(scrip_code))+1,7)) else scrip_code end+','+' '+','+rtrim(ltrim(scrip_name))+','+                            
rtrim(ltrim(Certno))+','+ltrim(rtrim(convert(varchar,shortage)))+','+                            
rtrim(ltrim(convert(varchar,accountid)))+','+rtrim(ltrim(convert(varchar,qty))) from tbl_short where sett_type in ('D','C')                             
*/                        
insert into tbl_gen_shortage                            
select rtrim(ltrim(x.Sett_No))+','+rtrim(ltrim(x.Sett_Type))+','+rtrim(ltrim(x.Party_Code))+','+                            
rtrim(ltrim(x.Short_Name))+','+rtrim(ltrim(x.Branch_Cd))+','+rtrim(ltrim(x.Sub_Broker))+','+                          
case when  x.sett_type in ('C','D') then reverse(substring(reverse(x.scrip_code),charindex(')',                          
reverse(rtrim(ltrim(x.scrip_code))))+1,7)) else rtrim(ltrim(x.scrip_code)) end+','+isnull(rtrim(ltrim(y.NSEScrip_cd)),'')+','+rtrim(ltrim(x.scrip_name))+','+                            
rtrim(ltrim(x.Certno))+','+ltrim(rtrim(convert(varchar,x.shortage)))+','+                            
rtrim(ltrim(convert(varchar,x.accountid)))+','+rtrim(ltrim(convert(varchar,x.qty)))+','+rtrim(ltrim(convert(varchar,x.BSEQty)))+','+rtrim(ltrim(convert(varchar,x.NSEQty)))                           
 from                          
(select * from tbl_short where sett_type in ('C','D')) x left outer join mimansa.angelcs.dbo.angelscrip y on x.scrip_code = y.Scrip_cd and x.CertNo = y.ISIN                          
                        
                          
insert into tbl_gen_shortage           
select rtrim(ltrim(x.Sett_No))+','+rtrim(ltrim(x.Sett_Type))+','+rtrim(ltrim(x.Party_Code))+','+                            
rtrim(ltrim(x.Short_Name))+','+rtrim(ltrim(x.Branch_Cd))+','+rtrim(ltrim(x.Sub_Broker))+','+y.Scrip_cd+','+                          
case when  x.sett_type in ('D','C') then reverse(substring(reverse(x.scrip_code),charindex(')',                          
reverse(x.scrip_code))+1,7)) else x.scrip_code end+','+rtrim(ltrim(x.scrip_name))+','+                            
rtrim(ltrim(x.Certno))+','+ltrim(rtrim(convert(varchar,x.shortage)))+','+                            
rtrim(ltrim(convert(varchar,x.accountid)))+','+rtrim(ltrim(convert(varchar,x.qty)))+','+rtrim(ltrim(convert(varchar,x.BSEQty)))+','+rtrim(ltrim(convert(varchar,x.NSEQty)))                           
 from                          
(select distinct * from tbl_short where sett_type in ('N','W')) x left outer join mimansa.angelcs.dbo.angelscrip y on x.scrip_code = y.NSEScrip_cd and x.CertNo = y.ISIN                          
                          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Head FROM ANGELDEMAT.BSEDB.DBO.tbl_gen_shortage" queryout '+@file+' -c -SANGELDEMAT -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'            
set @s1= @s+''''                                                                              
exec(@s1)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSECM_SHORTAGE_FORNBFC_SP
-- --------------------------------------------------
CREATE Proc USP_BSECM_SHORTAGE_FORNBFC_SP
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)          
AS          
          
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)          
/*          
/*added to check with parameters**/          
--BSECM AC  2012136          
DECLARE @segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)          
set @segment ='BSECM'          
set @sett_Type ='AC'          
set @sett_no='2012136'          
      
    */      
Select Sett_no,Sett_Type,scrip_cd,series,Party_code,Qty,Inout,Branch_Cd,PartiPantCode Into #DeliveryClt           
From BSEDB.dbo.DeliveryClt with (nolock)          
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type          
And InOut = 'I'---Explicitly added column names          
          
Select           
C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Qty,c.Filler2          
 Into #Deltrans          
 From BSEDB.dbo.Deltrans C with (nolock)          
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type          
And Party_Code <> 'BROKER' And Drcr = 'C'          
And Filler2 = 1 /*And Sharetype <> 'Auction'*/          
And TrType <> 906          
          
          
/*          
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
INTO #CLIENT FROM CLIENT1 C1, CLIENT2 C2          
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
*/          
          
          
--changed from in to exists and distinct to group by          
SELECT PARTY_CODE, Short_Name, Branch_Cd, sub_broker          
INTO #CLIENT           
FROM INTRANET.RISK.DBO.CLIENT_details cd with  (nolock)          
WHERE exists          
(          
select cl.party_code from           
(SELECT  PARTY_CODE FROM #DeliveryClt group by PARTY_CODE          
UNION           
SELECT PARTY_CODE FROM #Deltrans group by PARTY_CODE)CL           
where cl.party_code=cd.party_code          
)          
          
          
set transaction isolation level read uncommitted          
/*          
DECLARE @segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)          
set @segment ='BSECM'          
set @sett_Type ='AC'          
set @sett_no='2012136'          
*/          
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(D.Recqty, 0)), Isettqty = 0, Ibenqty = 0,          
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,          
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
Into #delpayinmatch          
From #CLIENT C1           
inner join            
(select d.*,c.Recqty from          
(select D.Sett_No,D.Sett_Type,D.Scrip_Cd,D.Series,D.Party_Code,D.Qty,D.inout  from #Deliveryclt D with (nolock) )D          
Left Outer Join           
(select C.Sett_No,C.Sett_Type,C.Scrip_Cd,C.Series,C.Party_Code,C.Drcr,Recqty=C.Recqty,c.Filler2  from  #Deltrans C (nolock))C          
On  D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type          
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series          
And D.Party_Code = C.Party_Code And C.Drcr = 'C'          
And C.Filler2 = 1 /*And Sharetype <> 'Auction'*/)D          
on C1.Party_Code = D.Party_Code          
inner join           
 BSEDB.dbo.Multiisin M with (nolock)  on          
M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series           
Where D.Inout = 'I'  And m.Valid = 1          
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type          
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
Having D.Qty > 0          
          
          
If @Opt <> 1          
Begin          
 Delete From #delpayinmatch Where Delqty <= Recqty          
End          
          
set transaction isolation level read uncommitted          
          
/*          
DECLARE @segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)          
set @segment ='BSECM'          
set @sett_Type ='AC'          
set @sett_no='2012136'          
*/          
          
          
Insert Into #delpayinmatch          
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0,Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),          
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),          
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),          
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then  D.Qty Else 0 End),          
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then  D.Qty Else 0 End),          
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then  D.Qty Else 0 End) ,          
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,          
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
From BSEDB.dbo.Deltrans D with (nolock)          
inner join #Client C1 (nolock) on C1.Party_Code = D.Party_Code          
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)          
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type          
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
union all          
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),          
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),          
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),          
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),          
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),          
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,          
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,          
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
From msajag.Dbo.Deltrans D, #Client C1          
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)          
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type          
And C1.Party_Code = D.Party_Code          
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker          
          
          
          
set transaction isolation level read uncommitted          
          
/*          
 DECLARE @StatusId VARCHAR(15)          
SET  @StatusId = 'broker'          
*/          
          
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),          
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (          
Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),          
Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0)          
From BSEDB.dbo.Deltrans D  inner join BSEDB.dbo.Deliverydp Dp          
on D.Bdpid = Dp.Dpid And D.Bcltdpid = Dp.Dpcltno          
Where D.Filler2 = 1 And D.Drcr = 'D'          
And D.Delivered = '0' And D.Trtype In (904, 909, 905) And  DP.[Description] Not Like '%pool%'          
Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code          
And A.Certno = #delpayinmatch.Certno          
          
/*          
 DECLARE @StatusId VARCHAR(15)          
SET  @StatusId = 'broker'          
*/          
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),          
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (          
Select D.Party_Code, D.Certno, Hold = Isnull(Sum(Case When D.TrType = 904 And DP.[Description] Not Like '%pledge%' Then D.Qty Else 0 End), 0),          
Pledge = Isnull(Sum(Case When D.TrType = 909 Or DP.[Description] Like '%pledge%' Then D.Qty Else 0 End), 0) From msajag.Dbo.Deltrans D, msajag.Dbo.Deliverydp Dp          
Where D.Filler2 = 1 And D.Drcr = 'D'          
And D.Delivered = '0' And D.Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid          
And D.Bcltdpid = Dp.Dpcltno And DP.[Description] Not Like '%pool%'          
Group By D.Party_Code, D.Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno          
          
Update #delpayinmatch          
--Set Scrip_Cd = S2.Scrip_Cd + ' ( ' + M.Scrip_Cd + ' )'          
Set Scrip_Cd = M.Scrip_Cd          
From BSEDB.dbo.Scrip2 S2 INNER JOIN  BSEDB.dbo.MultiIsIn M          
on S2.BseCode = M.Scrip_Cd          
where M.IsIn = #delpayinmatch.CertNo          
        
    
          
If Upper(@Branchcd) = 'All'          
begin          
 Select @Branchcd = '%'          
end          
          
If @Opt = 1          
begin          
 set transaction isolation level read uncommitted
           
delete from [196.1.115.219].TEST_DATA.DBO.BSECM_SHORTAGE_FORNBFC_SP Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
         
insert into [196.1.115.219].TEST_DATA.DBO.BSECM_SHORTAGE_FORNBFC_SP         
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
           
  delete from [196.1.115.219].TEST_DATA.DBO.BSECM_SHORTAGE_FORNBFC_SP  Where Sett_No = @Sett_No And Sett_Type = @Sett_Type          
     
          
  insert into [196.1.115.219].TEST_DATA.DBO.BSECM_SHORTAGE_FORNBFC_SP
  Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,          
  Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),          
  Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),          
  Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge          
  From #delpayinmatch R (nolock)          
  Where R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type          
  And R.Branch_Cd Like @Branchcd          
  Group By R.Sett_No, R.Sett_Type, R.Party_Code, R.Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold,    Nsepledge          
  Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )          
  Order By Branch_Cd, R.Party_Code, Scrip_Cd          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CollateralDetails_SEBIPayout
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_CollateralDetails_SEBIPayout]          
AS          
BEGIN        
      
EXEC('      
      
DECLARE @SYSDATE date=(SELECT CAST(MAX(SYSDATE) as date) FROM ANAND1.MSAJAG.DBO.CLOSING_mtm WITH(NOLOCK) WHERE       
CAST(SYSDATE as date)< (SELECT CAST(MAX(SYSDATE) as date) FROM ANAND1.MSAJAG.DBO.CLOSING_mtm WITH(NOLOCK) ))      
      
DECLARE @ProcessDate VARCHAR(10)=''''      
      
----SET @ProcessDate= (SELECT REPLACE(CONVERT(VARCHAR(10),@SYSDATE,103),''/'',''''))             
  
SET @ProcessDate= (SELECT REPLACE(CONVERT(VARCHAR(10),CAST(MAX(SYSDATE) as date),103),''/'','''')   FROM ANAND1.MSAJAG.DBO.CLOSING_mtm WITH(NOLOCK))      
      
SELECT Party_Code,scrip_cd,SUM(Qty) ''Qty'',CertNo INTO #ClientDetails      
FROM MSAJAG.dbo.DELTRANS_REPORT WITH(NOLOCK)       
WHERE  bcltdpid =''1203320030135814'' AND drcr=''d'' and delivered =''0''      
AND filler2 =''1'' AND party_code NOT IN (''broker'',''exe'',''nse'')      
----AND series IN(''EQ'',''BE'')      
GROUP BY Party_Code,scrip_cd,CertNo      
      
CREATE INDEX ix_SEBIPayout_ISIN          
ON #ClientDetails(CertNo)       
      
      
SELECT DISTINCT AMDMTM.ISIN,(SYSDATE) ''SYSDATE'',AMDMTM.CL_RATE INTO  #ClosingRateDetails          
FROM ANAND1.MSAJAG.DBO.CLOSING_mtm AMDMTM WITH(NOLOCK)          
JOIN #ClientDetails CD          
ON AMDMTM.ISIN = CD.CertNo       
WHERE -----AMDMTM.series IN(''EQ'',''BE'')  AND             
CAST(SYSDATE as date) = @SYSDATE      
-----(SELECT CAST(MAX(SYSDATE)-1 as date) FROM ANAND1.MSAJAG.DBO.CLOSING_mtm WITH(NOLOCK))         
          
      
CREATE INDEX ix_SEBIPayout_ClosingRate          
ON #ClosingRateDetails(ISIN)               
            
SELECT DISTINCT ISIN,nav_date,BSEMFS.nav_value INTO #MF_ISINDetails            
FROM ANAND1.msajag.DBO.MFSS_NAV01 BSEMFS WITH(NOLOCK)              
JOIN #ClientDetails CD              
ON BSEMFS.ISIN = CD.CertNo        
WHERE NAV_DATE=@SYSDATE           
----WHERE NAV_DATE=(SELECT MAX(NAV_DATE) FROM  ANAND1.msajag.DBO.MFSS_NAV01 WITH(NOLOCK) )            
      
----SET @ProcessDate= (SELECT REPLACE(CONVERT(VARCHAR(10),MAX(SYSDATE-1),103),''/'','''') FROM ANAND1.MSAJAG.DBO.CLOSING_mtm WITH(NOLOCK))      
              
              
SELECT DISTINCT *,       
CAST((Amount - ((Amount * HairCut) /100)) as decimal(17,2)) ''FinalAmount''      
INTO #FinalDetails FROM(          
SELECT CD.Party_Code, ''NSE'' Exchange, ''FUTURES'' Segment,CD.Scrip_Cd,CD.CertNo ''Isin''      
----,CASE WHEN ISNULL(MFCRD.ISIN,'''') <>'''' THEN ISNULL(MFCRD.nav_value,0) ELSE ISNULL(CRD.CL_RATE,0) END ''CL_RATE'',          
,CASE WHEN ISNULL(CRD.ISIN,'''')<>'''' THEN ISNULL(CRD.CL_RATE,0) ELSE ISNULL(MFCRD.nav_value,0)  END ''CL_RATE'',
CD.Qty,            
----CASE WHEN ISNULL(MFCRD.ISIN,'''') <>'''' THEN 10 ELSE ISNULL(AMVARD.AppVar,0) END ''HairCut''            
----ISNULL(AMVARD.AppVar,0) ''HairCut''        
CASE WHEN AMVARD.AppVar is null THEN    
CASE WHEN ISNULL(MFCRD.ISIN,'''')<>'''' THEN 10 ELSE 100 END ELSE AMVARD.AppVar END ''HairCut''      
, CAST(ISNULL(( (CASE WHEN ISNULL(MFCRD.ISIN,'''') <>'''' THEN MFCRD.nav_value ELSE ISNULL(CRD.CL_RATE,0) END)* CD.Qty),0) as decimal(17,2)) ''Amount''        
FROM #ClientDetails CD          
LEFT JOIN #ClosingRateDetails CRD          
ON CD.CertNo = CRD.ISIN             
LEFT JOIN #MF_ISINDetails MFCRD            
ON CD.CertNo = MFCRD.ISIN            
LEFT JOIN ANAND1.MSAJAG.DBO.VARDETAIL AMVARD WITH(NOLOCK)      
ON CD.CertNo = AMVARD.ISIN       
AND DetailKey = @ProcessDate      
      
)AA          
      
TRUNCATE TABLE SEBI_Colletral      
      
INSERT INTO SEBI_Colletral      
SELECT * FROM #FinalDetails      
        
IF(DATENAME(WEEKDAY, GETDATE()) = ''Saturday'')        
BEGIN        
        
DELETE FROM SEBI_Colletral_Hist WHERE CAST(ProcessDate as date) = CAST(GETDATE() as date)        
        
INSERT INTO SEBI_Colletral_Hist        
SELECT *,GETDATE() FROM #FinalDetails      
        
END        
      
')      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DMP_GRID_Show
-- --------------------------------------------------
  
CREATE proc [dbo].[USP_DMP_GRID_Show]      
as       
begin      
--select distinct  (FileName),cast(File_Date as Date) as FileDate ,Process_Date from  DP_Holding_Balance with (nolock)      
--group by FileName,File_Date,Process_Date   

--select distinct  File_Number,(FileName),cast(File_Date as Date) as FileDate ,Process_Date from  DP_Holding_Balance with (nolock)      
--group by File_Number,FileName,File_Date,Process_Date 

select distinct  File_Number,(FileName),Convert(varchar(10),CONVERT(date,File_Date,105),105) as FileDate ,Process_Date from  DP_Holding_Balance with (nolock)      
group by File_Number,FileName,File_Date,Process_Date order by Process_Date

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DMP_GRID_Show_new
-- --------------------------------------------------

CREATE proc [dbo].[USP_DMP_GRID_Show_new]      
as       
begin 

IF  EXISTS (select * from [tbl_DPM_File_Insert_log] where Convert (Date, created_date) <> Convert (Date, GETDATE()))    
BEGIN   

 Truncate table [tbl_DPM_File_Insert_log]    
     
END  

select distinct FileName into #temp from DP_Holding_Balance

SELECT FileN,EXP,DPID,ReqId,FileType,Filedate,SeqNo,B.FileName,A.created_date 
FROM tbl_DPM_File_Insert_log A
inner join #temp B on A.FileName = B.FileName
order by created_date 

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DMP_GRID_Show_test
-- --------------------------------------------------
  
create proc [dbo].[USP_DMP_GRID_Show_test]      
as       
begin      
select distinct  File_Number,(FileName),cast(File_Date as Date) as FileDate ,Process_Date from  DP_Holding_Balance_test with (nolock)      
group by File_Number,FileName,File_Date,Process_Date      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPK7UploadFile_New
-- --------------------------------------------------

--exec Usp_DPK7UploadFile_New 'SOH_EXP_033203_123_F_202408200000_999_C_0_0_P0.csv','','',''
CREATE Proc [dbo].[Usp_DPK7UploadFile_New]      
(      
	@FileName_DPM_File varchar (200),
	@DPID varchar (10),
	@FileType varchar(2),
	@FileSequence varchar(2),
	@FilePath varchar(500)
)      
AS      
BEGIN      
 
IF  EXISTS (select * from DP_Holding_Balance where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))    
BEGIN     
    
 insert into DP_Holding_Balance_hist  
 select *,GETDATE () from DP_Holding_Balance  
 Truncate table DP_Holding_Balance  
     
END  

IF  EXISTS (select top 1 FileName from DP_Holding_Balance where FileName = @FileName_DPM_File)    
BEGIN     
  select '' as blank  
  select 'File Already Exists.' as Status 
  return
END

Declare @FileNumber int

If (@DPID = '033200')
BEGIN
set @FileNumber = 101
END
If (@DPID = '033201')
BEGIN
set @FileNumber = 102
END
If (@DPID = '033202')
BEGIN
set @FileNumber = 103
END
If (@DPID = '033203')
BEGIN
set @FileNumber = 104
END
If (@DPID = '033204')
BEGIN
set @FileNumber = 105
END
   
BEGIN  
IF  EXISTS (select top 1 * from dpholdingfile_stg)    
BEGIN  
Truncate table dpholdingfile_stg
END 
begin
   	Declare @filename varchar(200) 
	--if(@DPID = '033201')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else if (@DPID = '033200')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else if (@DPID = '033202')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else if (@DPID = '033203')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else
	--begin
	--set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID +'\'+ @FileName_DPM_File 
	--end

	set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER('BULK INSERT dpholdingfile_stg FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = '','',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
 end


       
 insert into  DP_Holding_Balance(Party_Code,
 BO_ID,
 ISIN,
 Free_Balance,
 Lock_Balance,
 Pledge_Balance,
 Earmark_Balance,
 Safe_Balance,  
 Pending_Remat_balance,
 Available_Lend_Balance,
 Remat_Lockin_Balance,
 Current_Balance,
 Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,  
 Lending_Balance,
 Borrowed_Balance,
 ISIN_Freeze,
 BOID_Freeze,
 BOISIN,
 Settlement_ID,
 Dummy1,
 File_Date,
 Process_Date,
 File_Number,
 [FileName])       
 
 Select  '',
 BnfclOwnrId,
 ISIN,
 cast(BnfcryAcctPos as numeric(16,3)), 
 cast(LckdInBal as numeric(16,3)),
 cast(PldgdBal as numeric(16,3)),       
 cast(EarmrkdBal as numeric(16,3)), 
 cast(SkfpBal as numeric(16,3)), 
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)),  
 cast(RmtrlstnPdgBal as numeric(16,3)), 
 cast(CurBal as numeric(16,3)),       
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)), 
 cast(LndBal as numeric(16,3)) , 
 cast(BrrwdBal as numeric(16,3)),       
 0, 
 0,
 0,
 0,
 1,
 getdate(),
 getdate(),
 --cast(@DPID as int),
 @FileNumber,
 @FileName_DPM_File      
 from dpholdingfile_stg  where ISIN != 'ISIN' 


 IF  EXISTS (select distinct FileName from DP_Holding_Balance where FileName = @FileName_DPM_File)  
 begin
	exec DPM_File_Insert_log @FileName_DPM_File
 end
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status      
  End     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPK7UploadFile_New_02012024
-- --------------------------------------------------

--exec Usp_DPK7UploadFile_New 'SOH_EXP_033203_123_F_202408200000_999_C_0_0_P0.csv','','',''
create Proc [dbo].[Usp_DPK7UploadFile_New_02012024]      
(      
	@FileName_DPM_File varchar (200),
	@DPID varchar (10),
	@FileType varchar(2),
	@FileSequence varchar(2),
	@FilePath varchar(500)
)      
AS      
BEGIN      
 
IF  EXISTS (select * from DP_Holding_Balance where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))    
BEGIN     
    
 insert into DP_Holding_Balance_hist  
 select *,GETDATE () from DP_Holding_Balance  
 Truncate table DP_Holding_Balance  
     
END  

IF  EXISTS (select top 1 FileName from DP_Holding_Balance where File_Number = @DPID and FileName = @FileName_DPM_File)    
BEGIN     
  select '' as blank  
  select 'File Already Exists.' as Status 
  return
END
   
BEGIN  
IF  EXISTS (select top 1 * from dpholdingfile_stg)    
BEGIN  
Truncate table dpholdingfile_stg
END 
begin
   	Declare @filename varchar(200) 
	--if(@DPID = '033201')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else if (@DPID = '033200')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else if (@DPID = '033202')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else if (@DPID = '033203')
	--begin
 --   set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	--end
	--else
	--begin
	--set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID +'\'+ @FileName_DPM_File 
	--end

	set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK7_fileuploader\' + @DPID + '\' + @DPID +'\'+ @FileName_DPM_File 
	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER('BULK INSERT dpholdingfile_stg FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = '','',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
 end


       
 insert into  DP_Holding_Balance(Party_Code,
 BO_ID,
 ISIN,
 Free_Balance,
 Lock_Balance,
 Pledge_Balance,
 Earmark_Balance,
 Safe_Balance,  
 Pending_Remat_balance,
 Available_Lend_Balance,
 Remat_Lockin_Balance,
 Current_Balance,
 Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,  
 Lending_Balance,
 Borrowed_Balance,
 ISIN_Freeze,
 BOID_Freeze,
 BOISIN,
 Settlement_ID,
 Dummy1,
 File_Date,
 Process_Date,
 File_Number,
 [FileName])       
 
 Select  '',
 BnfclOwnrId,
 ISIN,
 cast(BnfcryAcctPos as numeric(16,3)), 
 cast(LckdInBal as numeric(16,3)),
 cast(PldgdBal as numeric(16,3)),       
 cast(EarmrkdBal as numeric(16,3)), 
 cast(SkfpBal as numeric(16,3)), 
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)),  
 cast(RmtrlstnPdgBal as numeric(16,3)), 
 cast(CurBal as numeric(16,3)),       
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)), 
 cast(LndBal as numeric(16,3)) , 
 cast(BrrwdBal as numeric(16,3)),       
 0, 
 0,
 0,
 0,
 1,
 getdate(),
 getdate(),
 cast(@DPID as int),
 @FileName_DPM_File      
 from dpholdingfile_stg  where ISIN != 'ISIN' 


 IF  EXISTS (select distinct FileName from DP_Holding_Balance where FileName = @FileName_DPM_File)  
 begin
	exec DPM_File_Insert_log @FileName_DPM_File
 end
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status      
  End     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPK8UploadFile_New
-- --------------------------------------------------

--exec Usp_DPM8UploadFile_New 'SOH_EXP_033203_123_F_202408200000_999_C_0_0_P0.csv','','',''
CREATE Proc [dbo].[Usp_DPK8UploadFile_New]      
(      
	@FileName_DPM_File varchar (200),
	@DPID varchar (10),
	@FileType varchar(2),
	@FileSequence varchar(2)
)      
AS      
BEGIN      
 

IF  EXISTS (select top 1 FileName from DP_Holding_Balance where FileName = @FileName_DPM_File)    
BEGIN     
  select '' as blank  
  select 'File Already Exists.' as Status 
  return
END

Declare @FileNumber int

If (@DPID = '033200')
BEGIN
set @FileNumber = 200 + cast(@FileSequence as int)
END
If (@DPID = '033201')
BEGIN
set @FileNumber = 300 + cast(@FileSequence as int)
END
If (@DPID = '033202')
BEGIN
set @FileNumber = 400 + cast(@FileSequence as int)
END
If (@DPID = '033203')
BEGIN
set @FileNumber = 500 + cast(@FileSequence as int)
END
If (@DPID = '033204')
BEGIN
set @FileNumber = 600 + cast(@FileSequence as int)
END
   
BEGIN  
IF  EXISTS (select top 1 * from dpholdingfile_stg)    
BEGIN  
Truncate table dpholdingfile_stg
END 
begin
   	Declare @filename varchar(200)  
    set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK8_fileuploader\'+ @FileName_DPM_File 

	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER('BULK INSERT dpholdingfile_stg FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = '','',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
 end


       
 insert into  DP_Holding_Balance (Party_Code,
 BO_ID,
 ISIN,
 Free_Balance,
 Lock_Balance,
 Pledge_Balance,
 Earmark_Balance,
 Safe_Balance,  
 Pending_Remat_balance,
 Available_Lend_Balance,
 Remat_Lockin_Balance,
 Current_Balance,
 Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,  
 Lending_Balance,
 Borrowed_Balance,
 ISIN_Freeze,
 BOID_Freeze,
 BOISIN,
 Settlement_ID,
 Dummy1,
 File_Date,
 Process_Date,
 File_Number,
 [FileName])       
 
 Select  '',
 BnfclOwnrId,
 ISIN,
 cast(BnfcryAcctPos as numeric(16,3)), 
 cast(LckdInBal as numeric(16,3)),
 cast(PldgdBal as numeric(16,3)),       
 cast(EarmrkdBal as numeric(16,3)), 
 cast(SkfpBal as numeric(16,3)), 
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)),  
 cast(RmtrlstnPdgBal as numeric(16,3)), 
 cast(CurBal as numeric(16,3)),       
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)), 
 cast(LndBal as numeric(16,3)) , 
 cast(BrrwdBal as numeric(16,3)),       
 0, 
 0,
 0,
 0,
 1,
 getdate(),
 getdate(),
 --cast(@DPID as int),
 @FileNumber,
 @FileName_DPM_File      
 from dpholdingfile_stg  where ISIN != 'ISIN' 


 IF  EXISTS (select * from DP_Holding_Balance where FileName = @FileName_DPM_File)  
 begin
	exec DPM_File_Insert_log @FileName_DPM_File
 end
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status      
  End     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPK8UploadFile_New_02012024
-- --------------------------------------------------

--exec Usp_DPM8UploadFile_New 'SOH_EXP_033203_123_F_202408200000_999_C_0_0_P0.csv','','',''
Create Proc [dbo].[Usp_DPK8UploadFile_New_02012024]      
(      
	@FileName_DPM_File varchar (200),
	@DPID varchar (10),
	@FileType varchar(2),
	@FileSequence varchar(2)
)      
AS      
BEGIN      
 

IF  EXISTS (select top 1 FileName from DP_Holding_Balance where File_Number = @DPID and FileName = @FileName_DPM_File)    
BEGIN     
  select '' as blank  
  select 'File Already Exists.' as Status 
  return
END
   
BEGIN  
IF  EXISTS (select top 1 * from dpholdingfile_stg)    
BEGIN  
Truncate table dpholdingfile_stg
END 
begin
   	Declare @filename varchar(200)  
    set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DPK8_fileuploader\'+ @FileName_DPM_File 

	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER('BULK INSERT dpholdingfile_stg FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = '','',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
 end


       
 insert into  DP_Holding_Balance (Party_Code,
 BO_ID,
 ISIN,
 Free_Balance,
 Lock_Balance,
 Pledge_Balance,
 Earmark_Balance,
 Safe_Balance,  
 Pending_Remat_balance,
 Available_Lend_Balance,
 Remat_Lockin_Balance,
 Current_Balance,
 Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,  
 Lending_Balance,
 Borrowed_Balance,
 ISIN_Freeze,
 BOID_Freeze,
 BOISIN,
 Settlement_ID,
 Dummy1,
 File_Date,
 Process_Date,
 File_Number,
 [FileName])       
 
 Select  '',
 BnfclOwnrId,
 ISIN,
 cast(BnfcryAcctPos as numeric(16,3)), 
 cast(LckdInBal as numeric(16,3)),
 cast(PldgdBal as numeric(16,3)),       
 cast(EarmrkdBal as numeric(16,3)), 
 cast(SkfpBal as numeric(16,3)), 
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)),  
 cast(RmtrlstnPdgBal as numeric(16,3)), 
 cast(CurBal as numeric(16,3)),       
 cast(DmtrlstnPdgVrfctnBal as numeric(16,3)), 
 cast(DmtrlstnPdgConfBal as numeric(16,3)), 
 cast(LndBal as numeric(16,3)) , 
 cast(BrrwdBal as numeric(16,3)),       
 0, 
 0,
 0,
 0,
 1,
 getdate(),
 getdate(),
 cast(@DPID as int),
 @FileName_DPM_File      
 from dpholdingfile_stg  where ISIN != 'ISIN' 


 IF  EXISTS (select * from DP_Holding_Balance where FileName = @FileName_DPM_File)  
 begin
	exec DPM_File_Insert_log @FileName_DPM_File
 end
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status      
  End     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile
-- --------------------------------------------------
    
    
--exec Usp_DPM3UploadFile '11DPM3UX.25012024062659.EOD'     
CREATE Proc [dbo].[Usp_DPM3UploadFile]      
(      
@FileName_DPM4 varchar (200)      
)      
AS      
BEGIN      
    
    
IF  EXISTS (select * from DP_Holding_Balance where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))    
BEGIN     
    
 insert into DP_Holding_Balance_hist    
 select *,GETDATE () from DP_Holding_Balance    
 Truncate table DP_Holding_Balance    
     
END    
      
if exists(select top 1 [fileName] from DP_Holding_Balance where file_number=101)      
begin     
    
select '' as blank      
select 'EOD File already exits.' as Status      
return;      
end      
else    
BEGIN      
 CREATE TABLE #TEMP      
 (      
  FILLER1  VARCHAR(MAX),      
  FILLER2  VARCHAR(MAX),      
  FILLER3  VARCHAR(MAX),      
  FILLER4  VARCHAR(MAX),      
  FILLER5  VARCHAR(MAX),      
  FILLER6  VARCHAR(MAX),      
  FILLER7  VARCHAR(MAX),      
  FILLER8  VARCHAR(MAX),      
  FILLER9  VARCHAR(MAX),      
  FILLER10 VARCHAR(MAX),      
  FILLER11 VARCHAR(MAX),      
  FILLER12 VARCHAR(MAX),      
  FILLER13 VARCHAR(MAX),      
  FILLER14 VARCHAR(MAX),      
  FILLER15 VARCHAR(MAX),      
  FILLER16 VARCHAR(MAX),      
  FILLER17 VARCHAR(MAX),      
  FILLER18 VARCHAR(MAX),      
  FILLER19 VARCHAR(MAX),      
  FILLER20 VARCHAR(MAX)      
 )     
     
      
 Declare @filename varchar(200)      
       
 --Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'      
      
 --Declare @filename varchar(200)      
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'    
 set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\'+ @FileName_DPM4    
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4          
           
      
 DECLARE @CMD VARCHAR(MAX)      
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')      
 EXEC (@CMD)      
       
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,  
 Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,  
 Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])       
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),       
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)),  
 cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),       
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),       
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),      
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),101,@FileName_DPM4       
  from #temp      
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status      
    End     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_05012022
-- --------------------------------------------------
  
  
--exec Usp_DPM3UploadFile    
CREATE Proc [dbo].[Usp_DPM3UploadFile_05012022]    
(    
@FileName_DPM4 varchar (200)    
)    
AS    
BEGIN    
  
    
if exists(select top 1 [fileName] from DP_Holding_Balance where [FileName] like '%.EOD%')    
begin   
  
select '' as blank    
select 'EOD File already exits.' as Status    
return;    
end    
else  
BEGIN    
 CREATE TABLE #TEMP    
 (    
  FILLER1  VARCHAR(MAX),    
  FILLER2  VARCHAR(MAX),    
  FILLER3  VARCHAR(MAX),    
  FILLER4  VARCHAR(MAX),    
  FILLER5  VARCHAR(MAX),    
  FILLER6  VARCHAR(MAX),    
  FILLER7  VARCHAR(MAX),    
  FILLER8  VARCHAR(MAX),    
  FILLER9  VARCHAR(MAX),    
  FILLER10 VARCHAR(MAX),    
  FILLER11 VARCHAR(MAX),    
  FILLER12 VARCHAR(MAX),    
  FILLER13 VARCHAR(MAX),    
  FILLER14 VARCHAR(MAX),    
  FILLER15 VARCHAR(MAX),    
  FILLER16 VARCHAR(MAX),    
  FILLER17 VARCHAR(MAX),    
  FILLER18 VARCHAR(MAX),    
  FILLER19 VARCHAR(MAX),    
  FILLER20 VARCHAR(MAX)    
 )   
   
    
 Declare @filename varchar(200)    
     
 Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'     
    
 --Declare @filename varchar(200)    
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'  
 set @filename ='\\196.1.115.147\d\upload1\DMP_fileuploader\'+ @FileName_DPM4  
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4        
         
    
 DECLARE @CMD VARCHAR(MAX)    
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')    
 EXEC (@CMD)    
     
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])     
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),     
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),     
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),     
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),    
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,'2021-12-24',getdate(),0,@FileName_DPM4     
  from #temp    
  
  select 'File Inserted Successfully.' as Status    
    End   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_17082023
-- --------------------------------------------------
    
    
--exec Usp_DPM3UploadFile      
Create Proc [dbo].[Usp_DPM3UploadFile_17082023]      
(      
@FileName_DPM4 varchar (200)      
)      
AS      
BEGIN      
    
    
IF  EXISTS (select * from DP_Holding_Balance where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))    
BEGIN     
    
 insert into DP_Holding_Balance_hist    
 select *,GETDATE () from DP_Holding_Balance    
 Truncate table DP_Holding_Balance    
     
END    
      
if exists(select top 1 [fileName] from DP_Holding_Balance where file_number=101)      
begin     
    
select '' as blank      
select 'EOD File already exits.' as Status      
return;      
end      
else    
BEGIN      
 CREATE TABLE #TEMP      
 (      
  FILLER1  VARCHAR(MAX),      
  FILLER2  VARCHAR(MAX),      
  FILLER3  VARCHAR(MAX),      
  FILLER4  VARCHAR(MAX),      
  FILLER5  VARCHAR(MAX),      
  FILLER6  VARCHAR(MAX),      
  FILLER7  VARCHAR(MAX),      
  FILLER8  VARCHAR(MAX),      
  FILLER9  VARCHAR(MAX),      
  FILLER10 VARCHAR(MAX),      
  FILLER11 VARCHAR(MAX),      
  FILLER12 VARCHAR(MAX),      
  FILLER13 VARCHAR(MAX),      
  FILLER14 VARCHAR(MAX),      
  FILLER15 VARCHAR(MAX),      
  FILLER16 VARCHAR(MAX),      
  FILLER17 VARCHAR(MAX),      
  FILLER18 VARCHAR(MAX),      
  FILLER19 VARCHAR(MAX),      
  FILLER20 VARCHAR(MAX)      
 )     
     
      
 Declare @filename varchar(200)      
       
 Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'       
      
 --Declare @filename varchar(200)      
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'    
 set @filename ='\\196.1.115.147\d\upload1\DMP_fileuploader\'+ @FileName_DPM4    
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4          
           
      
 DECLARE @CMD VARCHAR(MAX)      
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')      
 EXEC (@CMD)      
       
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,  
 Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,  
 Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])       
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),       
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)),  
 cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),       
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),       
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),      
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),101,@FileName_DPM4       
  from #temp      
    
  select 'File Inserted Successfully.' as Status      
    End     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_18012022
-- --------------------------------------------------
  
  
--exec Usp_DPM3UploadFile    
CREATE Proc [dbo].[Usp_DPM3UploadFile_18012022]    
(    
@FileName_DPM4 varchar (200)    
)    
AS    
BEGIN    
  
  
IF  EXISTS (select * from DP_Holding_Balance where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))  
BEGIN   
  
 insert into DP_Holding_Balance_hist  
 select *,GETDATE () from DP_Holding_Balance  
 Truncate table DP_Holding_Balance  
   
END  
    
if exists(select top 1 [fileName] from DP_Holding_Balance where [FileName] like '%.EOD%')    
begin   
  
select '' as blank    
select 'EOD File already exits.' as Status    
return;    
end    
else  
BEGIN    
 CREATE TABLE #TEMP    
 (    
  FILLER1  VARCHAR(MAX),    
  FILLER2  VARCHAR(MAX),    
  FILLER3  VARCHAR(MAX),    
  FILLER4  VARCHAR(MAX),    
  FILLER5  VARCHAR(MAX),    
  FILLER6  VARCHAR(MAX),    
  FILLER7  VARCHAR(MAX),    
  FILLER8  VARCHAR(MAX),    
  FILLER9  VARCHAR(MAX),    
  FILLER10 VARCHAR(MAX),    
  FILLER11 VARCHAR(MAX),    
  FILLER12 VARCHAR(MAX),    
  FILLER13 VARCHAR(MAX),    
  FILLER14 VARCHAR(MAX),    
  FILLER15 VARCHAR(MAX),    
  FILLER16 VARCHAR(MAX),    
  FILLER17 VARCHAR(MAX),    
  FILLER18 VARCHAR(MAX),    
  FILLER19 VARCHAR(MAX),    
  FILLER20 VARCHAR(MAX)    
 )   
   
    
 Declare @filename varchar(200)    
     
 Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'     
    
 --Declare @filename varchar(200)    
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'  
 set @filename ='\\196.1.115.147\d\upload1\DMP_fileuploader\'+ @FileName_DPM4  
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4        
         
    
 DECLARE @CMD VARCHAR(MAX)    
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')    
 EXEC (@CMD)    
     
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])     
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),     
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),     
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),     
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),    
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),0,@FileName_DPM4     
  from #temp    
  
  select 'File Inserted Successfully.' as Status    
    End   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId
-- --------------------------------------------------
          
          
--exec Usp_DPM3UploadFile_NewDPId            
CREATE Proc [dbo].[Usp_DPM3UploadFile_NewDPId]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
if exists(select top 1 file_number from DP_Holding_Balance where file_number=102)            
begin           
          
select '' as blank            
select 'New DP EOD File already exits.' as Status            
return;            
end            
else          
BEGIN 
 truncate table tbl_DPM3File_2       
 Declare @filename varchar(200)            
             
  --Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'           
            
	--Declare @filename varchar(200)            
	--Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
	set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\DPM3NewDPID\'+ @FileName_DPM4_NewDPId          
	--set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4  declare @fs int, @ole_response int

	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT tbl_DPM3File_2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
   
 
             
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),102,@FileName_DPM4_NewDPId             
 from tbl_DPM3File_2            
   
 select '' as blank   
 select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId_02102023
-- --------------------------------------------------
          
          
--exec Usp_DPM3UploadFile_NewDPId            
Create Proc [dbo].[Usp_DPM3UploadFile_NewDPId_02102023]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
if exists(select top 1 file_number from DP_Holding_Balance where file_number=102)            
begin           
          
select '' as blank            
select 'New DP EOD File already exits.' as Status            
return;            
end            
else          
BEGIN      
Create Table #temp2    
(    
Filedata varchar(max)    
)    
        
        
 Declare @filename varchar(200)            
             
 Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'             
            
 --Declare @filename varchar(200)            
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
 set @filename ='\\196.1.115.147\d\upload1\DMP_fileuploader\DPM3NewDPID\'+ @FileName_DPM4_NewDPId          
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4   
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')            
 EXEC (@CMD)  
   
 Delete #temp2 where len(filedata)<=40   
   
 CREATE TABLE #TEMP            
 (            
  FILLER1  VARCHAR(MAX),            
  FILLER2  VARCHAR(MAX),            
  FILLER3  VARCHAR(MAX),            
  FILLER4  VARCHAR(MAX),            
  FILLER5  VARCHAR(MAX),            
  FILLER6  VARCHAR(MAX),            
  FILLER7  VARCHAR(MAX),            
  FILLER8  VARCHAR(MAX),            
  FILLER9  VARCHAR(MAX),            
  FILLER10 VARCHAR(MAX),            
  FILLER11 VARCHAR(MAX),            
  FILLER12 VARCHAR(MAX),            
  FILLER13 VARCHAR(MAX),            
  FILLER14 VARCHAR(MAX),            
  FILLER15 VARCHAR(MAX),            
  FILLER16 VARCHAR(MAX),            
  FILLER17 VARCHAR(MAX),            
  FILLER18 VARCHAR(MAX),            
  FILLER19 VARCHAR(MAX),            
  FILLER20 VARCHAR(MAX)            
 )     
   
 Insert into #TEMP    
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))    
from #temp2                  
                 
            
            
             
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),102,@FileName_DPM4_NewDPId             
  from #temp            
          
  select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId_20012022
-- --------------------------------------------------
          
          
--exec Usp_DPM3UploadFile_NewDPId            
CREATE Proc [dbo].[Usp_DPM3UploadFile_NewDPId_20012022]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
if exists(select top 1 file_number from DP_Holding_Balance where file_number=102)            
begin           
          
select '' as blank            
select 'New DP EOD File already exits.' as Status            
return;            
end            
else          
BEGIN            
 CREATE TABLE #TEMP            
 (            
  FILLER1  VARCHAR(MAX),            
  FILLER2  VARCHAR(MAX),            
  FILLER3  VARCHAR(MAX),            
  FILLER4  VARCHAR(MAX),            
  FILLER5  VARCHAR(MAX),            
  FILLER6  VARCHAR(MAX),            
  FILLER7  VARCHAR(MAX),            
  FILLER8  VARCHAR(MAX),            
  FILLER9  VARCHAR(MAX),            
  FILLER10 VARCHAR(MAX),            
  FILLER11 VARCHAR(MAX),            
  FILLER12 VARCHAR(MAX),            
  FILLER13 VARCHAR(MAX),            
  FILLER14 VARCHAR(MAX),            
  FILLER15 VARCHAR(MAX),            
  FILLER16 VARCHAR(MAX),            
  FILLER17 VARCHAR(MAX),            
  FILLER18 VARCHAR(MAX),            
  FILLER19 VARCHAR(MAX),            
  FILLER20 VARCHAR(MAX)            
 )           
           
            
 Declare @filename varchar(200)            
             
 Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'             
            
 --Declare @filename varchar(200)            
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
 set @filename ='\\196.1.115.147\d\upload1\DMP_fileuploader\DPM3NewDPID\'+ @FileName_DPM4_NewDPId          
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4                
                 
            
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')            
 EXEC (@CMD)            
             
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),102,@FileName_DPM4_NewDPId             
  from #temp            
          
  select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId_File3
-- --------------------------------------------------
  
          
--exec Usp_DPM3UploadFile_NewDPId_File3            
CREATE Proc [dbo].[Usp_DPM3UploadFile_NewDPId_File3]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
if exists(select top 1 file_number from DP_Holding_Balance where file_number=103)            
begin           
          
select '' as blank            
select 'New DP EOD File already exits.' as Status            
return;            
end            
else          
BEGIN      
Create Table #temp2    
(    
Filedata varchar(max)    
)    
        
        
 Declare @filename varchar(200)            
             
 --Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'          
            
 --Declare @filename varchar(200)            
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
 set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\DPM3NewDPIDFile3\'+ @FileName_DPM4_NewDPId          
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4   
   
-- DECLARE @CMD VARCHAR(MAX)            
-- SET @CMD = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')            
-- EXEC (@CMD)  
   
-- Delete #temp2 where len(filedata)<=40   
   
 CREATE TABLE #TEMP            
 (            
  FILLER1  VARCHAR(MAX),            
  FILLER2  VARCHAR(MAX),            
  FILLER3  VARCHAR(MAX),            
  FILLER4  VARCHAR(MAX),            
  FILLER5  VARCHAR(MAX),            
  FILLER6  VARCHAR(MAX),            
  FILLER7  VARCHAR(MAX),            
  FILLER8  VARCHAR(MAX),            
  FILLER9  VARCHAR(MAX),            
  FILLER10 VARCHAR(MAX),            
  FILLER11 VARCHAR(MAX),            
  FILLER12 VARCHAR(MAX),            
  FILLER13 VARCHAR(MAX),            
  FILLER14 VARCHAR(MAX),            
  FILLER15 VARCHAR(MAX),            
  FILLER16 VARCHAR(MAX),            
  FILLER17 VARCHAR(MAX),            
  FILLER18 VARCHAR(MAX),            
  FILLER19 VARCHAR(MAX),            
  FILLER20 VARCHAR(MAX)            
 )     
   
-- Insert into #TEMP    
--Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))    
--from #temp2  


	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #TEMP FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
   
                 
            
            
             
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),103,@FileName_DPM4_NewDPId             
  from #TEMP            
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId_File3_08022024
-- --------------------------------------------------
  
          
--exec Usp_DPM3UploadFile_NewDPId_File3            
Create Proc [dbo].[Usp_DPM3UploadFile_NewDPId_File3_08022024]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
if exists(select top 1 file_number from DP_Holding_Balance where file_number=103)            
begin           
          
select '' as blank            
select 'New DP EOD File already exits.' as Status            
return;            
end            
else          
BEGIN      
Create Table #temp2    
(    
Filedata varchar(max)    
)    
        
        
 Declare @filename varchar(200)            
             
 Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'          
            
 --Declare @filename varchar(200)            
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
 set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\DPM3NewDPIDFile3\'+ @FileName_DPM4_NewDPId          
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4   
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')            
 EXEC (@CMD)  
   
 Delete #temp2 where len(filedata)<=40   
   
 CREATE TABLE #TEMP            
 (            
  FILLER1  VARCHAR(MAX),            
  FILLER2  VARCHAR(MAX),            
  FILLER3  VARCHAR(MAX),            
  FILLER4  VARCHAR(MAX),            
  FILLER5  VARCHAR(MAX),            
  FILLER6  VARCHAR(MAX),            
  FILLER7  VARCHAR(MAX),            
  FILLER8  VARCHAR(MAX),            
  FILLER9  VARCHAR(MAX),            
  FILLER10 VARCHAR(MAX),            
  FILLER11 VARCHAR(MAX),            
  FILLER12 VARCHAR(MAX),            
  FILLER13 VARCHAR(MAX),            
  FILLER14 VARCHAR(MAX),            
  FILLER15 VARCHAR(MAX),            
  FILLER16 VARCHAR(MAX),            
  FILLER17 VARCHAR(MAX),            
  FILLER18 VARCHAR(MAX),            
  FILLER19 VARCHAR(MAX),            
  FILLER20 VARCHAR(MAX)            
 )     
   
 Insert into #TEMP    
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),    
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))    
from #temp2                  
                 
            
            
             
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),103,@FileName_DPM4_NewDPId             
  from #temp            
          
  select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId_File4
-- --------------------------------------------------
  
          
--exec Usp_DPM3UploadFile_NewDPId_File3            
Create Proc [dbo].[Usp_DPM3UploadFile_NewDPId_File4]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
if exists(select top 1 file_number from DP_Holding_Balance where file_number=104)            
begin           
          
select '' as blank            
select 'New DP EOD File already exits.' as Status            
return;            
end            
else          
BEGIN      
Create Table #temp2    
(    
Filedata varchar(max)    
)    
        
        
 Declare @filename varchar(200)            
             
 --Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'          
            
 --Declare @filename varchar(200)            
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
 set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\DPM3NewDPIDFile4\'+ @FileName_DPM4_NewDPId          
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4   
   
-- DECLARE @CMD VARCHAR(MAX)            
-- SET @CMD = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')            
-- EXEC (@CMD)  
   
-- Delete #temp2 where len(filedata)<=40   
   
 CREATE TABLE #TEMP            
 (            
  FILLER1  VARCHAR(MAX),            
  FILLER2  VARCHAR(MAX),            
  FILLER3  VARCHAR(MAX),            
  FILLER4  VARCHAR(MAX),            
  FILLER5  VARCHAR(MAX),            
  FILLER6  VARCHAR(MAX),            
  FILLER7  VARCHAR(MAX),            
  FILLER8  VARCHAR(MAX),            
  FILLER9  VARCHAR(MAX),            
  FILLER10 VARCHAR(MAX),            
  FILLER11 VARCHAR(MAX),            
  FILLER12 VARCHAR(MAX),            
  FILLER13 VARCHAR(MAX),            
  FILLER14 VARCHAR(MAX),            
  FILLER15 VARCHAR(MAX),            
  FILLER16 VARCHAR(MAX),            
  FILLER17 VARCHAR(MAX),            
  FILLER18 VARCHAR(MAX),            
  FILLER19 VARCHAR(MAX),            
  FILLER20 VARCHAR(MAX)            
 )     
   
-- Insert into #TEMP    
--Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),    
--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))    
--from #temp2  


	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #TEMP FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
   
                 
            
            
             
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),104,@FileName_DPM4_NewDPId             
  from #TEMP            
   
  select '' as blank  
  select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_NewDPId_UAT
-- --------------------------------------------------
          
          
--exec Usp_DPM3UploadFile_NewDPId            
CREATE Proc [dbo].[Usp_DPM3UploadFile_NewDPId_UAT]            
(            
@FileName_DPM4_NewDPId varchar (200)            
)            
AS            
BEGIN            
          
          
--IF  EXISTS (select * from DP_Holding_Balance where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))          
--BEGIN           
          
-- insert into DP_Holding_Balance_hist          
-- select *,GETDATE () from DP_Holding_Balance          
-- Truncate table DP_Holding_Balance          
           
--END          
            
--if exists(select top 1 [fileName] from DP_Holding_Balance_test where [FileName] like '%.EOD%')            
if exists(select top 1 file_number from DP_Holding_Balance_test where file_number='102')            
begin           
          
select '' as blank            
select 'EOD File already exits.' as Status            
return;            
end            
else          
BEGIN            
 CREATE TABLE #TEMP            
 (            
  FILLER1  VARCHAR(MAX),            
  FILLER2  VARCHAR(MAX),            
  FILLER3  VARCHAR(MAX),            
  FILLER4  VARCHAR(MAX),            
  FILLER5  VARCHAR(MAX),            
  FILLER6  VARCHAR(MAX),            
  FILLER7  VARCHAR(MAX),            
  FILLER8  VARCHAR(MAX),            
  FILLER9  VARCHAR(MAX),            
  FILLER10 VARCHAR(MAX),            
  FILLER11 VARCHAR(MAX),            
  FILLER12 VARCHAR(MAX),            
  FILLER13 VARCHAR(MAX),            
  FILLER14 VARCHAR(MAX),            
  FILLER15 VARCHAR(MAX),            
  FILLER16 VARCHAR(MAX),            
  FILLER17 VARCHAR(MAX),            
  FILLER18 VARCHAR(MAX),            
  FILLER19 VARCHAR(MAX),            
  FILLER20 VARCHAR(MAX)            
 )           
           
            
 Declare @filename varchar(200)            
             
 Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:Administrator Winw0rld@1604'             
            
 --Declare @filename varchar(200)            
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'          
 set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\'+ @FileName_DPM4_NewDPId          
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4                
                 
            
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')            
 EXEC (@CMD)            
             
 insert into  DP_Holding_Balance_test (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,
 Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])             
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),             
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),             
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),             
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),            
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),102,@FileName_DPM4_NewDPId             
  from #temp            
          
  select 'File Inserted Successfully.' as Status            
          
  End           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM3UploadFile_UAT
-- --------------------------------------------------
        
        
--exec Usp_DPM3UploadFile_UAT          
CREATE Proc [dbo].[Usp_DPM3UploadFile_UAT]          
(          
@FileName_DPM4 varchar (200)          
)          
AS          
BEGIN          
        
        
IF  EXISTS (select * from DP_Holding_Balance_test  where Convert (Date, Process_Date) <>Convert (Date, GETDATE()))        
BEGIN         
        
 select 'Hi'       
         
END        
          
--if exists(select top 1 [fileName] from DP_Holding_Balance_test where [FileName] like '%.EOD%')    
if exists(select top 1 file_number from DP_Holding_Balance_test where file_number='101')             
begin         
        
select '' as blank          
select 'EOD File already exits.' as Status          
return;          
end          
else        
BEGIN          
 CREATE TABLE #TEMP          
 (          
  FILLER1  VARCHAR(MAX),          
  FILLER2  VARCHAR(MAX),          
  FILLER3  VARCHAR(MAX),          
  FILLER4  VARCHAR(MAX),          
  FILLER5  VARCHAR(MAX),          
  FILLER6  VARCHAR(MAX),          
  FILLER7  VARCHAR(MAX),          
  FILLER8  VARCHAR(MAX),          
  FILLER9  VARCHAR(MAX),          
  FILLER10 VARCHAR(MAX),          
  FILLER11 VARCHAR(MAX),          
  FILLER12 VARCHAR(MAX),          
  FILLER13 VARCHAR(MAX),          
  FILLER14 VARCHAR(MAX),          
  FILLER15 VARCHAR(MAX),          
  FILLER16 VARCHAR(MAX),          
  FILLER17 VARCHAR(MAX),          
  FILLER18 VARCHAR(MAX),          
  FILLER19 VARCHAR(MAX),          
  FILLER20 VARCHAR(MAX)          
 )         
         
          
 Declare @filename varchar(200)          
           
 Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:Administrator Winw0rld@1604'           
          
 --Declare @filename varchar(200)          
 --Set @filename ='D:\Backoffice\DPM3\11DPM3UX.23122021055942.EOD'        
 set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\'+ @FileName_DPM4        
 --set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4              
               
          
 DECLARE @CMD VARCHAR(MAX)          
 SET @CMD = LOWER( ' BULK INSERT #temp FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'') ')          
 EXEC (@CMD)          
           
 insert into  DP_Holding_Balance_test (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,
 Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])           
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),           
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),           
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),           
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),          
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),101,@FileName_DPM4           
  from #temp          
        
  select 'File Inserted Successfully.' as Status          
    End         
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
CREATE Proc [dbo].[Usp_DPM4UploadFile]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


	if(@maxCount <= 3) 
	Begin
		
	insert into tbl_demo_dpm4
	select '1'
	
	if(@maxCount = 0)
	begin
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),1
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
		print @fileextn
	end
	if(@maxCount = 1)
	begin
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 
		print @fileextn
	end
	if(@maxCount = 2)
	begin
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),3
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+400 
		print @fileextn
	end
	if(@maxCount = 3)
	begin
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),4
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+500 
		print @fileextn
	end


--if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
--begin 
	    
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--BEGIN 
--		--	insert into tbl_demo_dpm4
--		--	select '3'
--		--	select '' as blank  
--		--	select 'Incorrect File Sequence.' as Status  
--		--	return;
--		--End
--		insert into tbl_demo_dpm4	     
--		select '2'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),2
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

--End	
--ELSE	
--Begin 
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--	BEGIN 
--		--		insert into tbl_demo_dpm4
--		--		select '5'
--		--		select '' as blank  
--		--		select 'Incorrect File Sequence.' as Status  
--		--		return;
--		--	End	

--		insert into tbl_demo_dpm4
--	    select '3'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),1
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
--END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 



BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	
	--Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'


	  
	--Create Table #temp2  
	--(  
	--Filedata varchar(max)  
	--)  
	  
	 Declare @filename varchar(200)  
	
	--set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	--DECLARE @CMD1 VARCHAR(MAX)  
	--SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	--EXEC (@CMD1)  
	  
	  
	--Delete #temp2 where len(filedata)<=40  
	   
	--Insert into #temp1  
	--Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	--from #temp2   
  
    set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4         
	--set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4  declare @fs int, @ole_response int

	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #TEMP1 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
    
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #TEMP1   

	 select '' as blank  
	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_04102023
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile_04102023 ''  
CREATE Proc [dbo].[Usp_DPM4UploadFile_04102023]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


if(@maxCount <= 2) 
Begin
	
insert into tbl_demo_dpm4
select '1'

if(@maxCount = 0)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),1
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
print @fileextn
end
if(@maxCount = 1)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),2
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 
print @fileextn
end
if(@maxCount = 2)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),3
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+400 
print @fileextn
end

--if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
--begin 
	    
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--BEGIN 
--		--	insert into tbl_demo_dpm4
--		--	select '3'
--		--	select '' as blank  
--		--	select 'Incorrect File Sequence.' as Status  
--		--	return;
--		--End
--		insert into tbl_demo_dpm4	     
--		select '2'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),2
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

--End	
--ELSE	
--Begin 
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--	BEGIN 
--		--		insert into tbl_demo_dpm4
--		--		select '5'
--		--		select '' as blank  
--		--		select 'Incorrect File Sequence.' as Status  
--		--		return;
--		--	End	

--		insert into tbl_demo_dpm4
--	    select '3'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),1
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
--END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	--Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

	set @filename ='D:\Backoffice\DPM3\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_05012022
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_05012022]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.002'

Declare @fileextn int
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)

Declare @maxfileno int
select @maxfileno = max(File_Number) from DP_Holding_Balance

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin 
select '' as blank  
select 'File already exits.' as Status  
return;  
end  
else 

if(@fileextn !=  @maxfileno + 1)
Begin 
select '' as blank  
select 'Incorrect File Sequence.' as Status  
return; 
End

else 
BEGIN  
  
CREATE TABLE #TEMP1  
(  
 FILLER1 VARCHAR(MAX),  
 FILLER2 VARCHAR(MAX),  
 FILLER3 VARCHAR(MAX),  
 FILLER4 VARCHAR(MAX),  
 FILLER5 VARCHAR(MAX),  
 FILLER6 VARCHAR(MAX),  
 FILLER7 VARCHAR(MAX),  
 FILLER8 VARCHAR(MAX),  
 FILLER9 VARCHAR(MAX),  
 FILLER10 VARCHAR(MAX),  
 FILLER11  VARCHAR(MAX),  
 FILLER12 VARCHAR(MAX),  
 FILLER13 VARCHAR(MAX),  
 FILLER14 VARCHAR(MAX),  
 FILLER15  VARCHAR(MAX),  
 FILLER16 VARCHAR(MAX),  
 FILLER17 VARCHAR(MAX),  
 FILLER18 VARCHAR(MAX),  
 FILLER19 VARCHAR(MAX),  
 FILLER20 VARCHAR(MAX)  
)  
  
  
Create Table #temp2  
(  
Filedata varchar(max)  
)  
  
Declare @filename varchar(200)  
Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
  
DECLARE @CMD1 VARCHAR(MAX)  
SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
EXEC (@CMD1)  
  
  
Delete #temp2 where len(filedata)<=40  
   
Insert into #temp1  
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
from #temp2   
  
  
 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
 --and exists (   
 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
  
 --Select  * from #temp1 t  where    
 -- Not exists (   
 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
 --Select * from DP_Holding_Balanc  
    
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,'2021-12-24',getdate(),cast(RIGHT(@FileName_DPM4,3)as int),@FileName_DPM4    
 from #temp1   

  select 'File Inserted Successfully.' as Status 
  
End
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_08022024
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_08022024]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


if(@maxCount <= 2) 
Begin
	
insert into tbl_demo_dpm4
select '1'

if(@maxCount = 0)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),1
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
print @fileextn
end
if(@maxCount = 1)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),2
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 
print @fileextn
end
if(@maxCount = 2)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),3
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+400 
print @fileextn
end

--if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
--begin 
	    
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--BEGIN 
--		--	insert into tbl_demo_dpm4
--		--	select '3'
--		--	select '' as blank  
--		--	select 'Incorrect File Sequence.' as Status  
--		--	return;
--		--End
--		insert into tbl_demo_dpm4	     
--		select '2'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),2
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

--End	
--ELSE	
--Begin 
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--	BEGIN 
--		--		insert into tbl_demo_dpm4
--		--		select '5'
--		--		select '' as blank  
--		--		select 'Incorrect File Sequence.' as Status  
--		--		return;
--		--	End	

--		insert into tbl_demo_dpm4
--	    select '3'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),1
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
--END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'

	set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_12062024
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_12062024]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


if(@maxCount <= 2) 
Begin
	
insert into tbl_demo_dpm4
select '1'

if(@maxCount = 0)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),1
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
print @fileextn
end
if(@maxCount = 1)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),2
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 
print @fileextn
end
if(@maxCount = 2)
begin
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),3
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+400 
print @fileextn
end

--if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
--begin 
	    
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--BEGIN 
--		--	insert into tbl_demo_dpm4
--		--	select '3'
--		--	select '' as blank  
--		--	select 'Incorrect File Sequence.' as Status  
--		--	return;
--		--End
--		insert into tbl_demo_dpm4	     
--		select '2'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),2
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

--End	
--ELSE	
--Begin 
--		--if(@fileextn !=  (@maxfileno + 100) + 1)
--		--	BEGIN 
--		--		insert into tbl_demo_dpm4
--		--		select '5'
--		--		select '' as blank  
--		--		select 'Incorrect File Sequence.' as Status  
--		--		return;
--		--	End	

--		insert into tbl_demo_dpm4
--	    select '3'
--		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
--		select @FileName_DPM4,@fileextn,GETDATE(),1
--		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
--END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	
	--Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'


	  
	--Create Table #temp2  
	--(  
	--Filedata varchar(max)  
	--)  
	  
	 Declare @filename varchar(200)  
	
	--set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	--DECLARE @CMD1 VARCHAR(MAX)  
	--SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	--EXEC (@CMD1)  
	  
	  
	--Delete #temp2 where len(filedata)<=40  
	   
	--Insert into #temp1  
	--Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	--LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	--from #temp2   
  
    set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4         
	--set @filename ='\\AngelDemat\d$\Backoffice\DPM3\DPM3_EOD_File\'+ @FileName_DPM4  declare @fs int, @ole_response int

	declare @fs int, @ole_response int
	execute @ole_response = sp_OACreate 'Scripting.FileSystemObject', @fs out
	if @ole_response <> 0 RAISERROR('Error creating FileSystemObject.', 16, 1)
	
	declare @fobj int
	execute @ole_response = sp_OAMethod @fs, 'GetFile', @fobj out, @filename
	if @ole_response <> 0 RAISERROR('Error GetFile.', 16, 1)
	
	declare @fstream int
	execute @ole_response = sp_OAMethod @fobj, 'OpenAsTextStream', @fstream out, 8 --ForAppending
	if @ole_response <> 0 RAISERROR('Error OpenAsTextStream.', 16, 1)
	
	declare @last_row int
	execute @ole_response = sp_OAGetProperty @fstream, 'Line', @last_row output
	if @ole_response <> 0 RAISERROR('Error reading property Line.', 16, 1)
	
	execute @ole_response = sp_OAMethod @fstream, 'Close'
	if @ole_response <> 0 RAISERROR('Error closing TextStream.', 16, 1)
	
	execute sp_OADestroy @fs
 
   
 DECLARE @CMD VARCHAR(MAX)            
 SET @CMD = LOWER( ' BULK INSERT #TEMP1 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'',FIELDTERMINATOR = ''~'',LASTROW  = ' + cast(@last_row - 1 as nvarchar(max)) + ')')      
 EXEC(@CMD)  
    
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #TEMP1   

	 select '' as blank  
	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_16082023
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_16082023]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


if(@maxCount <= 1) 
Begin
	
insert into tbl_demo_dpm4
select '1'



if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
begin 
	    
		--if(@fileextn !=  (@maxfileno + 100) + 1)
		--BEGIN 
		--	insert into tbl_demo_dpm4
		--	select '3'
		--	select '' as blank  
		--	select 'Incorrect File Sequence.' as Status  
		--	return;
		--End
		insert into tbl_demo_dpm4	     
		select '2'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

End	
ELSE	
Begin 
		--if(@fileextn !=  (@maxfileno + 100) + 1)
		--	BEGIN 
		--		insert into tbl_demo_dpm4
		--		select '5'
		--		select '' as blank  
		--		select 'Incorrect File Sequence.' as Status  
		--		return;
		--	End	

		insert into tbl_demo_dpm4
	    select '3'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),1
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

	set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_17082023
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
CREATE Proc [dbo].[Usp_DPM4UploadFile_17082023]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 


	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102,103)


if(@maxCount <= 1) 
Begin
	
insert into tbl_demo_dpm4
select '1'



if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
begin 
	    
		
		insert into tbl_demo_dpm4	     
		select '2'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

End	
else if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 3)
begin 
	    
		
		insert into tbl_demo_dpm4	     
		select '3'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+400 

End	
ELSE	
Begin 	

		insert into tbl_demo_dpm4
	    select '4'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),1
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '5' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '6'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

	set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_18082023
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_18082023]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


if(@maxCount <= 1) 
Begin
	
insert into tbl_demo_dpm4
select '1'



if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
begin 
	    
		--if(@fileextn !=  (@maxfileno + 100) + 1)
		--BEGIN 
		--	insert into tbl_demo_dpm4
		--	select '3'
		--	select '' as blank  
		--	select 'Incorrect File Sequence.' as Status  
		--	return;
		--End
		insert into tbl_demo_dpm4	     
		select '2'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

End	
ELSE	
Begin 
		--if(@fileextn !=  (@maxfileno + 100) + 1)
		--	BEGIN 
		--		insert into tbl_demo_dpm4
		--		select '5'
		--		select '' as blank  
		--		select 'Incorrect File Sequence.' as Status  
		--		return;
		--	End	

		insert into tbl_demo_dpm4
	    select '3'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),1
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

	set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_18082023_1
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_18082023_1]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4

	IF  EXISTS (select * from Tbl_DPM4_FileCount where Convert (Date, UpdateDate) <>Convert (Date, GETDATE()))  
	BEGIN  
	 Truncate table Tbl_DPM4_FileCount  	   
	END  

	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount

	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)


if(@maxCount <= 1) 
Begin
	
insert into tbl_demo_dpm4
select '1'



if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
begin 
	    
		--if(@fileextn !=  (@maxfileno + 100) + 1)
		--BEGIN 
		--	insert into tbl_demo_dpm4
		--	select '3'
		--	select '' as blank  
		--	select 'Incorrect File Sequence.' as Status  
		--	return;
		--End
		insert into tbl_demo_dpm4	     
		select '2'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 

End	
ELSE	
Begin 
		--if(@fileextn !=  (@maxfileno + 100) + 1)
		--	BEGIN 
		--		insert into tbl_demo_dpm4
		--		select '5'
		--		select '' as blank  
		--		select 'Incorrect File Sequence.' as Status  
		--		return;
		--	End	

		insert into tbl_demo_dpm4
	    select '3'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),1
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
END

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
End 


BEGIN  
	insert into tbl_demo_dpm4
	select '5'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

	set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End

END
ELSE
Begin
    select '' as blank  
	select 'File already exits.' as Status
End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_19022022
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_19022022]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'

Declare @fileextn int
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 

Declare @maxfileno int = 0
select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)

--print @maxfileno
--print @fileextn 

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin 
select '' as blank  
select 'File already exits.' as Status  
return;  
end  
else
if(@fileextn !=  @maxfileno + 1)
Begin 
select '' as blank  
select 'Incorrect File Sequence.' as Status  
return; 
End

else 
BEGIN  
  
CREATE TABLE #TEMP1  
(  
 FILLER1 VARCHAR(MAX),  
 FILLER2 VARCHAR(MAX),  
 FILLER3 VARCHAR(MAX),  
 FILLER4 VARCHAR(MAX),  
 FILLER5 VARCHAR(MAX),  
 FILLER6 VARCHAR(MAX),  
 FILLER7 VARCHAR(MAX),  
 FILLER8 VARCHAR(MAX),  
 FILLER9 VARCHAR(MAX),  
 FILLER10 VARCHAR(MAX),  
 FILLER11  VARCHAR(MAX),  
 FILLER12 VARCHAR(MAX),  
 FILLER13 VARCHAR(MAX),  
 FILLER14 VARCHAR(MAX),  
 FILLER15  VARCHAR(MAX),  
 FILLER16 VARCHAR(MAX),  
 FILLER17 VARCHAR(MAX),  
 FILLER18 VARCHAR(MAX),  
 FILLER19 VARCHAR(MAX),  
 FILLER20 VARCHAR(MAX)  
)  
  
  
Create Table #temp2  
(  
Filedata varchar(max)  
)  
  
Declare @filename varchar(200)  
Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
  
DECLARE @CMD1 VARCHAR(MAX)  
SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
EXEC (@CMD1)  
  
  
Delete #temp2 where len(filedata)<=40  
   
Insert into #temp1  
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
from #temp2   
  
  
 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
 --and exists (   
 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
  
 --Select  * from #temp1 t  where    
 -- Not exists (   
 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
 --Select * from DP_Holding_Balanc  
    
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),cast(RIGHT(@FileName_DPM4,3)as int)+200 ,@FileName_DPM4    
 from #temp1   

  select 'File Inserted Successfully.' as Status 
  
End
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_21022022
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_21022022]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'

Declare @fileextn int
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 

Declare @maxfileno int = 0
select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)

--print @maxfileno
--print @fileextn 

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin 
select '' as blank  
select 'File already exits.' as Status  
return;  
end  
else
if(@fileextn !=  @maxfileno + 1)
Begin 
select '' as blank  
select 'Incorrect File Sequence.' as Status  
return; 
End

else 
BEGIN  
  
CREATE TABLE #TEMP1  
(  
 FILLER1 VARCHAR(MAX),  
 FILLER2 VARCHAR(MAX),  
 FILLER3 VARCHAR(MAX),  
 FILLER4 VARCHAR(MAX),  
 FILLER5 VARCHAR(MAX),  
 FILLER6 VARCHAR(MAX),  
 FILLER7 VARCHAR(MAX),  
 FILLER8 VARCHAR(MAX),  
 FILLER9 VARCHAR(MAX),  
 FILLER10 VARCHAR(MAX),  
 FILLER11  VARCHAR(MAX),  
 FILLER12 VARCHAR(MAX),  
 FILLER13 VARCHAR(MAX),  
 FILLER14 VARCHAR(MAX),  
 FILLER15  VARCHAR(MAX),  
 FILLER16 VARCHAR(MAX),  
 FILLER17 VARCHAR(MAX),  
 FILLER18 VARCHAR(MAX),  
 FILLER19 VARCHAR(MAX),  
 FILLER20 VARCHAR(MAX)  
)  
  
  
Create Table #temp2  
(  
Filedata varchar(max)  
)  
  
Declare @filename varchar(200)  
Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
  
DECLARE @CMD1 VARCHAR(MAX)  
SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
EXEC (@CMD1)  
  
  
Delete #temp2 where len(filedata)<=40  
   
Insert into #temp1  
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
from #temp2   
  
  
 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
 --and exists (   
 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
  
 --Select  * from #temp1 t  where    
 -- Not exists (   
 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
 --Select * from DP_Holding_Balanc  
    
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),cast(RIGHT(@FileName_DPM4,3)as int)+200 ,@FileName_DPM4    
 from #temp1   

  select 'File Inserted Successfully.' as Status 
  
End
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_21022022_2
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_21022022_2]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

	--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'
	truncate table tbl_demo_dpm4
	Declare @fileextn int
	set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)
	--select @fileextn

	Declare @maxCount int = 0
	select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo
	--select @maxCount


if(@maxCount <= 1) 
Begin
	
	insert into tbl_demo_dpm4
	select '1'
	
	if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
	begin 
		insert into tbl_demo_dpm4
	     select '2'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),2
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 
	End
	ELSE	
		Begin 
		insert into tbl_demo_dpm4
	    select '3'
		insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
		select @FileName_DPM4,@fileextn,GETDATE(),1
		select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
	END
	
	Declare @maxfileno int = 0
	select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)



if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
	begin
	insert into tbl_demo_dpm4
	select '4' 
	select '' as blank  
	select 'File already exits.' as Status  
	return;  
	end  
ELSE
	if((@fileextn !=  @maxfileno + 1) or (@fileextn !=  @maxfileno + 2))
	BEGIN 
	insert into tbl_demo_dpm4
	select '5'
		select '' as blank  
		select 'Incorrect File Sequence.' as Status  
		return; 
	End
	ELSE
	BEGIN  
	insert into tbl_demo_dpm4
	select '6'
	CREATE TABLE #TEMP1  
	(  
	 FILLER1 VARCHAR(MAX),  
	 FILLER2 VARCHAR(MAX),  
	 FILLER3 VARCHAR(MAX),  
	 FILLER4 VARCHAR(MAX),  
	 FILLER5 VARCHAR(MAX),  
	 FILLER6 VARCHAR(MAX),  
	 FILLER7 VARCHAR(MAX),  
	 FILLER8 VARCHAR(MAX),  
	 FILLER9 VARCHAR(MAX),  
	 FILLER10 VARCHAR(MAX),  
	 FILLER11  VARCHAR(MAX),  
	 FILLER12 VARCHAR(MAX),  
	 FILLER13 VARCHAR(MAX),  
	 FILLER14 VARCHAR(MAX),  
	 FILLER15  VARCHAR(MAX),  
	 FILLER16 VARCHAR(MAX),  
	 FILLER17 VARCHAR(MAX),  
	 FILLER18 VARCHAR(MAX),  
	 FILLER19 VARCHAR(MAX),  
	 FILLER20 VARCHAR(MAX)  
	)  
	  
	  
	Create Table #temp2  
	(  
	Filedata varchar(max)  
	)  
	  
	Declare @filename varchar(200)  
	Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

	set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
	  
	DECLARE @CMD1 VARCHAR(MAX)  
	SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
	EXEC (@CMD1)  
	  
	  
	Delete #temp2 where len(filedata)<=40  
	   
	Insert into #temp1  
	Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
	LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
	from #temp2   
  
  
	 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
	 --and exists (   
	 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
	 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	  
	 --Select  * from #temp1 t  where    
	 -- Not exists (   
	 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
	 --Select * from DP_Holding_Balanc  
	    
	 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
	 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
	 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
	 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
	 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
	 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),@fileextn ,@FileName_DPM4    
	 from #temp1   

	 select 'File Inserted Successfully.' as Status 
  
End
	select '' as blank  
	select 'File already exits.' as Status
End
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_31012022
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
Create Proc [dbo].[Usp_DPM4UploadFile_31012022]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.003'

Declare @fileextn int
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)

Declare @maxfileno int = 0
select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)

--print @maxfileno
--print @fileextn 

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin 
select '' as blank  
select 'File already exits.' as Status  
return;  
end  
else
if(@fileextn !=  @maxfileno + 1)
Begin 
select '' as blank  
select 'Incorrect File Sequence.' as Status  
return; 
End

else 
BEGIN  
  
CREATE TABLE #TEMP1  
(  
 FILLER1 VARCHAR(MAX),  
 FILLER2 VARCHAR(MAX),  
 FILLER3 VARCHAR(MAX),  
 FILLER4 VARCHAR(MAX),  
 FILLER5 VARCHAR(MAX),  
 FILLER6 VARCHAR(MAX),  
 FILLER7 VARCHAR(MAX),  
 FILLER8 VARCHAR(MAX),  
 FILLER9 VARCHAR(MAX),  
 FILLER10 VARCHAR(MAX),  
 FILLER11  VARCHAR(MAX),  
 FILLER12 VARCHAR(MAX),  
 FILLER13 VARCHAR(MAX),  
 FILLER14 VARCHAR(MAX),  
 FILLER15  VARCHAR(MAX),  
 FILLER16 VARCHAR(MAX),  
 FILLER17 VARCHAR(MAX),  
 FILLER18 VARCHAR(MAX),  
 FILLER19 VARCHAR(MAX),  
 FILLER20 VARCHAR(MAX)  
)  
  
  
Create Table #temp2  
(  
Filedata varchar(max)  
)  
  
Declare @filename varchar(200)  
Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'

set @filename ='\\196.1.115.147\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
  
DECLARE @CMD1 VARCHAR(MAX)  
SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
EXEC (@CMD1)  
  
  
Delete #temp2 where len(filedata)<=40  
   
Insert into #temp1  
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
from #temp2   
  
  
 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
 --and exists (   
 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
  
 --Select  * from #temp1 t  where    
 -- Not exists (   
 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
 --Select * from DP_Holding_Balanc  
    
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),cast(RIGHT(@FileName_DPM4,3)as int),@FileName_DPM4    
 from #temp1   

  select 'File Inserted Successfully.' as Status 
  
End
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_Test
-- --------------------------------------------------

--exec Usp_DPM4UploadFile
CREATE Proc [dbo].[Usp_DPM4UploadFile_Test]
(
@FileName_DPM4_n varchar (200)
)
AS
BEGIN

--Declare @FileName_DPM4 varchar(100) = '11DPM3UX.23122021055942.EOD'
--Declare @fileExtn varchar(3) 
--select @fileExtn =  RIGHT(@FileName_DPM4,3)

if exists(select [fileName] from DP_Holding_Balance_dummy where [FileName] like '%.EOD%')
begin 
select 'EOD File already exits.' as Status
return;
end
else

Begin

CREATE TABLE #TEMP1
(
	FILLER1	VARCHAR(MAX),
	FILLER2	VARCHAR(MAX),
	FILLER3	VARCHAR(MAX),
	FILLER4	VARCHAR(MAX),
	FILLER5	VARCHAR(MAX),
	FILLER6	VARCHAR(MAX),
	FILLER7	VARCHAR(MAX),
	FILLER8	VARCHAR(MAX),
	FILLER9	VARCHAR(MAX),
	FILLER10	VARCHAR(MAX),
	FILLER11  VARCHAR(MAX),
	FILLER12	VARCHAR(MAX),
	FILLER13	VARCHAR(MAX),
	FILLER14	VARCHAR(MAX),
	FILLER15  VARCHAR(MAX),
	FILLER16	VARCHAR(MAX),
	FILLER17	VARCHAR(MAX),
	FILLER18	VARCHAR(MAX),
	FILLER19	VARCHAR(MAX),
	FILLER20	VARCHAR(MAX)
)


Create Table #temp2
(
Filedata varchar(max)
)
Declare @FileName_DPM4 varchar(100) = '11DPM3UX.23122021055942.EOD'

Declare @filename1 varchar(200)


Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:Administrator Winw0rld@1604'      
             
                        
set @filename1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP_fileuploader\'+ @FileName_DPM4  

DECLARE @CMD1 VARCHAR(MAX)
SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename1 + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')
EXEC (@CMD1)
    


Delete #temp2 where len(filedata)<=40
 
Insert into #temp1
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))
from #temp2 


 --Select  * from #temp t  where FILLER1 ='1203320046984261'
 --and exists ( 
 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'
 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)

 --Select  * from #temp1 t  where  
 -- Not exists ( 
 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)
 --Select * from DP_Holding_Balanc
  
 insert into  DP_Holding_Balance_dummy (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName]) 
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)),	cast(FILLER4 as numeric(16,3)),	cast(FILLER5 as numeric(16,3)),	
 cast(FILLER6 as numeric(16,3)),	cast(FILLER7 as numeric(16,3)),	cast(FILLER8 as numeric(16,3)),	cast(FILLER9 as numeric(16,3)),	cast(FILLER10 as numeric(16,3)),	cast(FILLER11 as numeric(16,3)),	
 cast(FILLER12 as numeric(16,3)),	cast(FILLER13 as numeric(16,3)),	cast(FILLER14 as numeric(16,3)) ,	cast(FILLER15 as numeric(16,3)),	
 cast(FILLER16 as numeric(16,3)),	cast(FILLER17	 as numeric(16,3)),
 cast(FILLER18 as numeric(16,3)),	  isnull(FILLER19,'0'),1 ,'2021-12-24',getdate(),RIGHT(@FileName_DPM4,3),@FileName_DPM4 
  from #temp1 

  End


END
 
 --select * from DP_Holding_Balance_dummy where FileName is not null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_DPM4UploadFile_testnew
-- --------------------------------------------------

  
--exec Usp_DPM4UploadFile  
CREATE Proc [dbo].[Usp_DPM4UploadFile_testnew]  
(  
@FileName_DPM4 varchar (200)  
)  
AS  
BEGIN 

--declare @FileName_DPM4 varchar(200) = '11DPM3UX.23122021055942.004'

Declare @fileextn int
set @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)

--select * from Tbl_DPM4_FileCount
--truncate table Tbl_DPM4_FileCount
Declare @maxCount int = 0
select @maxCount = max(FileCount) from Tbl_DPM4_FileCount where FileNo = @fileextn  group by FileNo



if(@maxCount <= 1) 
Begin
if Exists(select FileNo from Tbl_DPM4_FileCount where FileNo = @fileextn and FileCount < 2)
begin 
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),2
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+300 
End
else	
Begin 
insert into Tbl_DPM4_FileCount(Filename,FileNo,UpdateDate,FileCount)
select @FileName_DPM4,@fileextn,GETDATE(),1
select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 
END
End


--Declare @fileextn int
--select @fileextn = cast(RIGHT(@FileName_DPM4,3)as int)+200 

Declare @maxfileno int = 0
select @maxfileno = max(File_Number) from DP_Holding_Balance where File_Number not in (101,102)



--print @maxfileno
--print @fileextn 

if exists(select distinct File_Number from DP_Holding_Balance where File_Number = @fileextn)  
begin 
select '' as blank  
select 'File already exits.' as Status  
return;  
end  
else
if(@fileextn !=  @maxfileno + 1)
Begin 
select '' as blank  
select 'Incorrect File Sequence.' as Status  
return; 
End

else 
BEGIN  
  
CREATE TABLE #TEMP1  
(  
 FILLER1 VARCHAR(MAX),  
 FILLER2 VARCHAR(MAX),  
 FILLER3 VARCHAR(MAX),  
 FILLER4 VARCHAR(MAX),  
 FILLER5 VARCHAR(MAX),  
 FILLER6 VARCHAR(MAX),  
 FILLER7 VARCHAR(MAX),  
 FILLER8 VARCHAR(MAX),  
 FILLER9 VARCHAR(MAX),  
 FILLER10 VARCHAR(MAX),  
 FILLER11  VARCHAR(MAX),  
 FILLER12 VARCHAR(MAX),  
 FILLER13 VARCHAR(MAX),  
 FILLER14 VARCHAR(MAX),  
 FILLER15  VARCHAR(MAX),  
 FILLER16 VARCHAR(MAX),  
 FILLER17 VARCHAR(MAX),  
 FILLER18 VARCHAR(MAX),  
 FILLER19 VARCHAR(MAX),  
 FILLER20 VARCHAR(MAX)  
)  
  
  
Create Table #temp2  
(  
Filedata varchar(max)  
)  
  
Declare @filename varchar(200)  
Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:Administrator Winw0rld@1604'

set @filename ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\DMP4_fileuploader\'+ @FileName_DPM4     
  
DECLARE @CMD1 VARCHAR(MAX)  
SET @CMD1 = LOWER( ' BULK INSERT #temp2 FROM ''' + @filename + ''' WITH  (ROWTERMINATOR = ''0x0a'' ) ')  
EXEC (@CMD1)  
  
  
Delete #temp2 where len(filedata)<=40  
   
Insert into #temp1  
Select LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',1))) ,  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',2))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',3))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',4))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',5))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',6))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',7))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',8))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',9))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',10))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',11))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',12))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',13))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',14))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',15))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',16))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',17))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',18))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',19))),  
LTRIM(RTRIM(.DBO.PIECE(FILEDATA,'~',20)))  
from #temp2   
  
  
 --Select  * from #temp t  where FILLER1 ='1203320046984261'  
 --and exists (   
 --Select  FILLER1 from #temp1 s where FILLER1 ='1203320046984261'  
 --and t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
  
 --Select  * from #temp1 t  where    
 -- Not exists (   
 --Select  FILLER1 from #temp s where t.FILLER1=s.FILLER1 and t.FILLER2=S.FILLER2)  
 --Select * from DP_Holding_Balanc  
    
 insert into  DP_Holding_Balance (Party_Code,BO_ID,ISIN,Free_Balance,Lock_Balance,Pledge_Balance,Earmark_Balance,Safe_Balance,Pending_Remat_balance,Available_Lend_Balance,Remat_Lockin_Balance,Current_Balance,Demat_Pending_Veri_Balance,Demat_Pending_Conf_Balance,Lending_Balance,Borrowed_Balance,ISIN_Freeze,BOID_Freeze,BOISIN,Settlement_ID,Dummy1,File_Date,Process_Date,File_Number,[FileName])   
 Select  '',FILLER1,FILLER2, cast(FILLER3 as numeric(16,3)), cast(FILLER4 as numeric(16,3)), cast(FILLER5 as numeric(16,3)),   
 cast(FILLER6 as numeric(16,3)), cast(FILLER7 as numeric(16,3)), cast(FILLER8 as numeric(16,3)), cast(FILLER9 as numeric(16,3)), cast(FILLER10 as numeric(16,3)), cast(FILLER11 as numeric(16,3)),   
 cast(FILLER12 as numeric(16,3)), cast(FILLER13 as numeric(16,3)), cast(FILLER14 as numeric(16,3)) , cast(FILLER15 as numeric(16,3)),   
 cast(FILLER16 as numeric(16,3)), cast(FILLER17  as numeric(16,3)),  
 cast(FILLER18 as numeric(16,3)),   isnull(FILLER19,'0'),1 ,getdate(),getdate(),cast(RIGHT(@FileName_DPM4,3)as int)+200 ,@FileName_DPM4    
 from #temp1   

  select 'File Inserted Successfully.' as Status 
  
End
  
END

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
select *,case when net_def <> 0 then FreeValue end ,'ADC' from #Final1  ---------2                    
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
select *,case when net_def <> 0 then FreeValue end ,'ADC' from #FinalCalc  ---------2                    
union all                    
select *,FreeValue ,'AC' from #FinalCalc  --------------------3                    
)x

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
-- PROCEDURE dbo.USP_FINDINUSP_UD
-- --------------------------------------------------
CREATE PROCEDURE USP_FINDINUSP_UD                                   
@DBNAME VARCHAR(500),                                  
@SRCSTR VARCHAR(500)                                    
AS                                    
                                    
 SET NOCOUNT ON              
 --                                
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
-- PRINT @DBNAME                                  
                               
 SET @STR=' INSERT INTO BO_OBJECT '                      
 SET @STR=@STR+' SELECT DISTINCT O.NAME,O.XTYPE,'''+@DBNAME+''',SUBSTRING('''+@SRCSTR+''',2,100) FROM '+@DBNAME+'SYSCOMMENTS  C '                                   
 SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '                                   
 SET @STR=@STR+' WHERE O.XTYPE  IN(''P'',''V'') AND (C.TEXT LIKE ''%insert%'' or C.TEXT LIKE ''%update%'' or  C.TEXT LIKE ''%delete%'') '                        
 SET @STR=@STR+' AND REPLACE(C.TEXT,'' '','''') LIKE '''+@SRCSTR+''''                                    
                      
--PRINT @STR                                  
EXEC(@STR)                                  
SELECT * FROM  BO_OBJECT            
                        
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
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PR+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'         
                 
     
      
set @s2= @ss+''''                                        
exec(@s2)                                        
drop table Print_File                             
                            
set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                                        
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'          
                  
    
      
set @s2= @ss+''''                                        
exec(@s2)                                        
drop table Bank_File                                      
                  
----------------------Pledge BO File------------------------------------                              
Select 'Client Code, ISIN, QTY, Ben. A/c No' as Header into #BPH                              
                            
Select ltrim(rtrim(Party_Code))+' ,'+convert(varchar(100),ltrim(rtrim(CertNo)))+' ,'                              
+convert(varchar(100),ltrim(rtrim(Free_Qty)))+' ,'+ltrim(rtrim(@AccId)) as pledge                              
into #PB1 from #TempFile                                        
where Bank=@bank and P_R= @Type and condition like @condition and Free_Qty > 0 order by SrNo --and party_code = 'M709'                                        
                                        
Select * into BO_File from #BPH                              
union all                   
Select * from #PB1                              
                              
set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                        
set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.txt -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                           
   
set @b2= @bb+''''                                                                          
exec(@b2)                                        
drop table BO_File                                     
        
End                                   
--************************************************************************************************--                                                                
--------------Rlease File-------------------------------------------------------------------------                                                                      
if @Type = 'R'                                      
begin                                    
                            
set @sss_RP=@Bank+'_PrintReleaseFile'+convert(varchar,getdate(),105)                                                          
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RP+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'         
                  
    
     
set @s2= @ss+''''                                        
exec(@s2)                                      
drop table Print_File                                   
                              
set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                        
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'          
   
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
set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                           
             
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
      
if @condition = 'AC'        
begin        
set @Type = '%%'        
end      
        
      
      
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
select * into #TempFile from                             
(select * from tbl_Pledge_Data (nolock) where BcltDpId = @AccId and  P_R like @Type and condition=@condition)x                            
inner join                            
(select * from #bank)y on x.CertNo = y.isin                            
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
select CertNo,sname,case when @condition = 'PED' then sum(Fld_NewPledgeQty* @percentage /100) else          
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
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PR+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'       
                   
    
     
         
          
           
              
                 
                   
 set @s2= @ss+''''                                                      
 exec(@s2)                                                      
                                           
 if @bank = 'HDFC'                  
 begin                  
 set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                                                      
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File_hdfc" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'   
                  
    
      
        
          
            
              
                
                         
 set @s2= @ss+''''                     
 exec(@s2)                        
                  
 end                  
 else                  
 begin                  
 set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                                                      
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'         
       
            
              
                
                   
 set @s2= @ss+''''                                                      
 exec(@s2)                        
 end                  
                  
 drop table Print_File_hdfc                  
 drop table Print_File                  
 drop table Bank_File                                                      
                                 
 ----------------------Pledge BO File------------------------------------                                            
 Select 'Client Code, ISIN, QTY, Ben. A/c No' as Header into #BPH              
                                           
 Select ltrim(rtrim(Party_Code))+' ,'+convert(varchar(100),ltrim(rtrim(CertNo)))+' ,'                                            
 +convert(varchar(100),ltrim(rtrim(Free_Qty)))+' ,'+ltrim(rtrim(@AccId)) as pledge                                            
 into #PB1 from #TempFile                                                      
 where Bank=@bank and P_R like @Type and condition like @condition and Free_Qty > 0 order by SrNo --and party_code = 'M709'                                                      
                                                       
 Select * into BO_File from #BPH                                            
 union all                                 
 Select * from #PB1                                            
                                             
 set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                                      
 set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.txt -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                          
                  
 set @b2= @bb+''''                                                                                        
 exec(@b2)                                                      
 drop table BO_File                                                   
                      
End                                                 
--************************************************************************************************--                         
--------------Rlease File-------------------------------------------------------------------------                                                                                    
if @Type = 'R'                  
begin                                                  
                                          
 set @sss_RP=@Bank+'_PrintReleaseFile'+convert(varchar,getdate(),105)                                                                        
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RP+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'        
                  
    
     
        
          
             
              
               
                    
 set @s2= @ss+''''                                                      
 exec(@s2)                                                    
                  
 if @bank = 'HDFC'                  
 begin                  
                  
 set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                                      
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File_hdfc" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'   
                  
    
      
        
          
            
              
                
                        
 set @s2= @ss+''''                                                      
 exec(@s2)                                                    
                  
 end                  
 else                
 begin                  
                   
 set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                                      
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'         
                  
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
 where Bank=@bank and P_R like @Type and condition like @condition and Free_Qty > 0 order by SrNo --and party_code = 'M709'                                                      
                                                       
 /*Select * into BO_File from #br                                                      
 union all*/                                                      
 Select * into BO_File from #br1 (nolock)                                                 
                                                       
 set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                                      
 set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'\\AngelDemat\d$\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                          
                  
    
     
         
          
            
 set @b2= @bb+''''                                                                                        
 exec(@b2)                                                      
 drop table BO_File                   
                                           
end                   
                  
---------------------------------------------------------------------------------------------------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenFileFor_ContractNotes
-- --------------------------------------------------
CREATE proc USP_GenFileFor_ContractNotes
(@regcd as varchar(25),@date as varchar(11),@segment as varchar(11))          
as                        
              
/*declare @date as varchar(11),@regcd as varchar(25),@segment as varchar(11),,@brcode as varchar(5000)    
  
set @regcd='Mumbai'  
set @date = '12/12/2009'  
set @segment = 'Others'*/  
--print @brcode  

if @segment = 'BSE' or @segment = 'NSE'
begin              

select * from                        
(select               
[Sett Type]=case when @segment = 'BSE' then 'C' when @segment = 'NSE' then 'N' end              
,branch_code as[Branch Code],'ALL' as[Sub Broker],  
'A0001' as[From Party],'ZZ999' as[To Party],
@date as[Date],''as[Printing Status]
from region where RegionCode = @regcd
and  Flag <> 'B' 
----old-branch_code not in (Select Fld_BrCode from tbl_mum_reg_brcd)                    
union              
select               
case when @segment = 'BSE' then 'D' when @segment = 'NSE' then 'W' end              
,branch_code ,'ALL','A0001','ZZ999',@date,''  
from region where RegionCode = @regcd and Flag <> 'B' 
--old-branch_code not in (Select Fld_BrCode from tbl_mum_reg_brcd)                    
) x order by [Branch Code]

end              

else
begin             

select * from
(select branch_code as[Branch Code],'ALL' as[Sub Broker],'A0001' as[From Party],'ZZ999' as[To Party],
@date as[Date],''as[Printing Status] from region where RegionCode = @regcd
and Flag <> 'B' 
----old-branch_code not in (Select Fld_BrCode from tbl_mum_reg_brcd)
union
select branch_code ,'ALL','A0001','ZZ999',@date,'' from region
where RegionCode = @regcd and Flag <> 'B'
--old-branch_code not in (Select Fld_BrCode from tbl_mum_reg_brcd)
) x order by [Branch Code]

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenFileFor_ContractNotes_dummy
-- --------------------------------------------------
CREATE proc USP_GenFileFor_ContractNotes_dummy                        
(@regcd as varchar(25),@date as varchar(11),@segment as varchar(11),@brcode as varchar(5000))          
as                        
              
/*declare @date as varchar(11),@regcd as varchar(25),@segment as varchar(11),,@brcode as varchar(5000)    
  
set @regcd='Mumbai'  
set @date = '12/12/2009'  
set @segment = 'Others'*/  
  
declare @sql as varchar(1000)  
set @brcode = replace(@brcode,'|','''')        
--print @brcode  
  
if @segment = 'BSE' or @segment = 'NSE'            
begin              
             
set @sql= 'select * from                        
(select               
[Sett Type]=case when '''+@segment+''' = ''BSE'' then ''C'' when '''+@segment+''' = ''NSE'' then ''N'' end              
,branch_code as[Branch Code],''ALL'' as[Sub Broker],  
''A0001'' as[From Party],''ZZ999'' as[To Party],              
'''+@date+''' as[Date],''''as[Printing Status]                         
from anand1.msajag.dbo.region where RegionCode = '''+@regcd+'''  
and  branch_code not in ('+@brcode+')  
----old-(Select Fld_BrCode from tbl_mum_reg_brcd)                    
union              
select               
case when '''+@segment+''' = ''BSE'' then ''D'' when '''+@segment+''' = ''NSE'' then ''W'' end              
,branch_code ,''ALL'',''A0001'',''ZZ999'','''+@date+''',''''  
from anand1.msajag.dbo.region where RegionCode = '''+@regcd+''' and  
branch_code not in ('+@brcode+')  
--old-(Select Fld_BrCode from tbl_mum_reg_brcd)                    
) x order by [Branch Code]'  
--print @sql  
exec (@sql)  
end              
             
else              
begin             
set @sql=  
'select * from                        
(select branch_code as[Branch Code],''ALL'' as[Sub Broker],''A0001'' as[From Party],''ZZ999'' as[To Party],              
'''+@date+''' as[Date],''''as[Printing Status] from anand1.msajag.dbo.region where RegionCode = '''+@regcd+'''  
and  branch_code not in ('+@brcode+')  
----old-(Select Fld_BrCode from tbl_mum_reg_brcd)  
union              
select branch_code ,''ALL'',''A0001'',''ZZ999'','''+@date+''','''' from anand1.msajag.dbo.region               
where RegionCode = '''+@regcd+''' and branch_code not in ('+@brcode+')  
--old-(Select Fld_BrCode from tbl_mum_reg_brcd)  
) x order by [Branch Code]'  
--print @sql  
exec (@sql)  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_GenFileFor_ID_Converter
-- --------------------------------------------------
CREATE PROC [dbo].[Usp_GenFileFor_ID_Converter]                      
(@Name as varchar(50))                
as                      
truncate table tbl_genfilefor_ID_final                    
insert into tbl_genfilefor_ID_final                
select * from                 
(Select top 1 *  from mis.demat.dbo.tbl_genfilefor_ID                      
union                      
Select                       
left(head,8)+                      
substring(head,9,16)+                      
substring(head,25,12)+                      
substring(head,37,15)+                      
substring(head,52,2)+                 
replicate(' ',8)+                    
substring(head,62,8)+                      
substring(head,70,13)+                      
substring(head,83,16)+                      
replicate(' ',8-len(substring(head,83,16)))                      
from mis.demat.dbo.tbl_genfilefor_ID where head not like '00%' )x      
order by substring(x.head,83,16)            
                   
-----------------------------------------------------------------------                  
declare @s1 as varchar(500)                
declare @ss as varchar(500)                
declare @s2 as varchar(500)                
declare @sss as varchar(500)                
declare @ext as varchar(50)                
select @ext=substring(replace(@Name,'.txt',''),charindex('.',replace(@Name,'.txt',''))+1,len(@Name))                
/*select @ext=right(replace(convert(varchar(25),getdate(),113),':',''),4)*/                
set @sss = '04'+(Select distinct substring(head,9,16) from mis.demat.dbo.tbl_genfilefor_ID where head not like '00%')+'.'+@ext                     
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from Angeldemat.inhouse.dbo.tbl_genfilefor_ID_final" queryout '+'\\AngelDemat\d$\upload1\converter_ID_file\'+@sss+'.txt -c -SAngeldemat -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'              
              
set @s2= @ss+''''              
exec(@s2)              
-------------------------------------------------------------------------                
Select @sss

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Get_DMP_LOG_Data
-- --------------------------------------------------
CREATE Proc USP_Get_DMP_LOG_Data      
      
as      
begin      
      
select UserName,Date_Time from tbl_DMP_Logs order by Date_Time desc      
      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Get_DMP3_LOG_Data
-- --------------------------------------------------
CREATE Proc USP_Get_DMP3_LOG_Data      
      
as      
begin      
      
select top 1 Date_Time from Tbl_DMP_Logs order by Date_Time desc      
      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_NonPOA_Holding_all
-- --------------------------------------------------

-- =============================================
-- Author:		<Ruchi>
-- Create date: <18 Jun 2020>
-- Description:	<Non POA equity holding>
-- =============================================
CREATE PROCEDURE USP_GET_NonPOA_Holding_all
As
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select ltrim(rtrim(party_code)) as partyCode,ltrim(rtrim(cltdpid)) as dpId,scrip_cd as scripCD,isin,pool_qty as poolQty,unsett as unsettQty
			,dp_hold as dpHoldQty,Total_Hold as totalQty,Dt_time as lastUpdateTime, (ltrim(rtrim(party_code)) +'_' + ltrim(rtrim(cltdpid))) partyCode_dpId
	from Non_POA_Hold with(nolock) 
	order by party_code,cltdpid;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_NonPOA_Holding_deleted
-- --------------------------------------------------


-- =============================================
-- Author:		<Ruchi>
-- Create date: <18 Jun 2020>
-- Description:	<Non POA equity deleted holding>
-- =============================================
CREATE PROCEDURE USP_GET_NonPOA_Holding_deleted
As
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select distinct --a.party_code as partyCode,a.cltdpid as dpId, 
	(ltrim(rtrim(a.party_code)) +'_' + ltrim(rtrim(a.cltdpid))) partyCode_dpId --,a.scrip_cd,a.isin,a.pool_qty,a.unsett,a.dp_hold,a.Total_Hold,a.Dt_time 
	from Non_POA_Hold_HSt a With(nolock)
	left join Non_POA_Hold b with(nolock)
	on a.party_code=b.party_code
	and a.cltdpid=b.cltdpid
	where b.party_code is null and b.cltdpid is null;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_HoldinguploadAddRemove_Filegeneration
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[USP_HoldinguploadAddRemove_Filegeneration] 
 @username varchar(50) = null,
 @Total int out,  
 @Uploadeddon varchar(500)
AS
BEGIN
	
	SET NOCOUNT ON;

	declare @FileDate date	
	set @FileDate=replace(CONVERT(VARCHAR(30),convert(date, @Uploadeddon ,103)), '/', ' ') 


	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = 'ERROR' WHERE PARTY_CODE IN ('05ABLB','05ACDLR','05ASLR') 

	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = 'K111613' WHERE PARTY_CODE IN ('K11650') 
	
	UPDATE CH SET PARTY_CODE = PARENTCODE FROM BSEDB..CLIENT_HOLDING CH, ANAND1.MSAJAG.DBO.CLIENT_DETAILS B WITH (NOLOCK)
	WHERE CH.PARTY_CODE = B.CL_CODE AND CH.PARTY_CODE LIKE '98%' AND DP_DATE IN (@FileDate)
	
	UPDATE CH SET PARTY_CODE = B.NEW_CODE FROM BSEDB..CLIENT_HOLDING CH, BSEDB..TBL_OCNC B WHERE PARTY_CODE = OLD_CODE AND DP_DATE IN (@FileDate)

	DELETE FROM BSEDB..CLIENT_HOLDING_NEW WHERE DP_DATE = @FileDate

	DELETE FROM BSEDB..CLIENT_HOLDING WHERE QTY <= 0

-----


 INSERT INTO BSEDB..CLIENT_HOLDING_NEW
 SELECT * FROM BSEDB..CLIENT_HOLDING (NOLOCK) WHERE DP_DATE = @FileDate

 UPDATE BSEDB..CLIENT_HOLDING_NEW SET PARTY_CODE = REPLACE(PARTY_CODE,' ','') WHERE DP_DATE = @FileDate AND PARTY_CODE LIKE '% %'
 
 -------

 SELECT TOP 0 DP_DATE,PARTY_CODE,CLIENTID,ISIN,QTY,PLD_QTY,EXCH_PLD INTO #CLT_HS FROM BSEDB..CLIENT_HOLDING WHERE 1 = 2

INSERT INTO #CLT_HS
SELECT DP_DATE,UPPER(LTRIM(RTRIM(PARTY_CODE))) AS PARTY_CODE,CLIENTID,ISIN,SUM(QTY) AS QTY,SUM(PLD_QTY) AS PLD_QTY,SUM(EXCH_PLD) AS EXCH_PLD
 FROM BSEDB..CLIENT_HOLDING (NOLOCK) WHERE DP_DATE = @FileDate
 GROUP BY DP_DATE,PARTY_CODE,CLIENTID,ISIN
 ORDER BY DP_DATE,PARTY_CODE,CLIENTID,ISIN

 
TRUNCATE TABLE BSEDB..TBL_HOLD_RPT  

INSERT INTO BSEDB..TBL_HOLD_RPT
SELECT C.CLIENTID,'', UPPER(LTRIM(RTRIM(M.PARENTCODE))) AS PARTY_CODE,M.LONG_NAME,M.PAN_GIR_NO,C.ISIN,'','',PLDQTY = (PLD_QTY),QTY-PLD_QTY,QTY,DP_DATE
FROM #CLT_HS C 
LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT_DETAILS M WITH (NOLOCK)
ON C.PARTY_CODE = M.CL_CODE
 WHERE  DP_DATE = @FileDate
ORDER BY CLIENTID,C.PARTY_CODE,ISIN


----


UPDATE F SET UCC = 'AP_'+ B.SBTAG,CLTPAN = B.PANNO FROM MIS.SB_COMP.DBO.VW_05TAGS B WITH (NOLOCK) ,  BSEDB..TBL_HOLD_RPT F (NOLOCK) 
WHERE F.UCC = B.GLCODE AND F.UCC LIKE '05%'

UPDATE F SET ACCTYPE = DP.ACCTYPE FROM	BSEDB..TBL_HOLD_RPT F (NOLOCK), BSEDB..TBL_ACCTYP_MST DP				
		WHERE F.ACCNO = DP.ACCNO 
		
UPDATE BSEDB..TBL_HOLD_RPT SET ACCTYPE = 'OWN' WHERE ACCNO IN ('1203320000072218','1203320018512446','1203320020369832','1601430000003350','1601430000003496')

UPDATE BSEDB..TBL_HOLD_RPT SET PLDQTY = TOTQTY,FREEQTY = 0 WHERE ACCNO = '20016807' AND FREEQTY <> 0 

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'NNNNN1111N' WHERE CLTPAN IN ('PAN_EXEMPT','PAN EXEMPT') 

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'ABCDE1234F' WHERE CLTPAN = '' 

---------------

		UPDATE	BSEDB..TBL_HOLD_RPT
		SET		SECTYPE = (
				CASE
					WHEN LEFT(ISNULL(SECTYPE,''),2) = 'MF' OR LEFT(ISNULL(ISIN,''),3) = 'INF' THEN 'MF'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'N' THEN 'BOND'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'G' THEN 'DEBT'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'P' THEN 'PREF'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'W' THEN 'WT'
					---WHEN LEFT(ISNULL(SECURITY_TYPE,''),1) = 'I' THEN 'IDR'
					ELSE 'EQ'
				END) -- WHERE RPT_DATE = @FileDate

-------------------------

UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30009510184021' WHERE ACCNO ='10184021' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820016807' WHERE ACCNO ='20016807' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820057525' WHERE ACCNO ='20057525' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820090631' WHERE ACCNO ='20090631' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820057752' WHERE ACCNO ='20057752' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154914216209' WHERE ACCNO ='14216209' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30012610003588' WHERE ACCNO ='10003588' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154916921197' WHERE ACCNO ='16921197' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154932108952' WHERE ACCNO ='32108952' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30115113326100' WHERE ACCNO ='13326100' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154915464303' WHERE ACCNO ='15464303' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154915434303' WHERE ACCNO ='15434303' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820129509' WHERE ACCNO ='20129509' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820131776' WHERE ACCNO ='20131776' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820130005' WHERE ACCNO ='20130005' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820707701' WHERE ACCNO ='20707701'			-- Added new column by Vishwajeet as per Jira Ticket --https://angelbrokingpl.atlassian.net/browse/SRE-36088


UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AEVPC3010R' WHERE UCC = 'AP_SPPUNE' AND CLTNAME = 'CHANGEDIA S R'
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AFOPS1625L' WHERE UCC = 'AP_DSSFR' AND CLTNAME = 'DILIP SHRIDHAR SAWANT'

UPDATE BSEDB..TBL_HOLD_RPT SET UCC = 'AP_APOO',CLTNAME = 'APOORVA FINANCIAL SERVICE' WHERE UCC IN ('AP_APOO','AP_APOOR') AND CLTPAN = 'BELPK5411D'
UPDATE BSEDB..TBL_HOLD_RPT SET UCC = 'AP_YVM',CLTNAME = 'YATINKUMAR V MAKHECHA' WHERE UCC = 'AP_YVMG' AND CLTPAN = 'AFHPM6286J'

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AAACM6094R' WHERE UCC IN ('EEEEE','ERROR','V37421','V30521','V153','V307','V611','AL57627','A401','A404','A408')
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AAACM6094R' WHERE UCC IN ('12798')

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'ABCDE1234F' WHERE UCC IN ('R6209ZZ','A511','K012','L112')

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AEUPS4220G' WHERE UCC = 'M21725'
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'CRHPK5592B' WHERE UCC = 'M137028'
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'CMGPS5542H' WHERE UCC = 'S390466'



-----------------------****************------------------------------


-- SELECT DISTINCT ACCNO FROM BSEDB..TBL_HOLD_RPT (NOLOCK) WHERE RPT_DATE = @FileDate ORDER BY ACCNO -- 30

SELECT RPT_DATE,ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SECTYPE,SUM(PLDQTY) AS PLDQTY,SUM(FREEQTY) AS FREEQTY,SUM(TOTQTY) AS TOTQTY INTO #RPT 
FROM BSEDB..TBL_HOLD_RPT (NOLOCK)  WHERE RPT_DATE = @FileDate 
GROUP BY RPT_DATE,ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SECTYPE
ORDER BY RPT_DATE,ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SECTYPE

TRUNCATE TABLE BSEDB..TBL_HOLD_RPT

INSERT INTO BSEDB..TBL_HOLD_RPT
SELECT ACCNO = ACCNO,ACCTYPE = ACCTYPE,UCC = UCC,CLTNAME = CLTNAME,CLTPAN = CLTPAN,ISIN = ISIN ,SCRIPNAME = '', SECTYPE = SECTYPE,
PLDQTY = PLDQTY,FREEQTY = FREEQTY,TOTQTY = TOTQTY,RPT_DATE = RPT_DATE
FROM #RPT  ORDER BY UCC


----------------


SELECT ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SCRIPNAME,SECTYPE,ROUND(CONVERT(FLOAT,PLDQTY),3) PLDQTY,ROUND(CONVERT(FLOAT,FREEQTY),3) FREEQTY,
ROUND(CONVERT(FLOAT,TOTQTY),3) TOTQTY,RPT_DATE INTO #NSE FROM BSEDB..TBL_HOLD_RPT 
 ORDER BY RPT_DATE,ACCNO,UCC

 -----------

--SELECT * FROM #NSE WHERE UCC = 'BBBB'
--SELECT * FROM #NSE WHERE CLTPAN = ''
--SELECT * FROM #NSE WHERE CLTPAN IS NULL
--SELECT * FROM #NSE WHERE CLTPAN LIKE '%.%'
--SELECT * FROM #NSE WHERE CLTPAN LIKE '%,%'
--SELECT * FROM #NSE WHERE LEN(CLTPAN) <> 10


------------------ FINAL DATA ----- 


DELETE FROM BSEDB..CLIENT_HOLDING_FIN WHERE RPT_DATE = @FileDate


INSERT INTO BSEDB..CLIENT_HOLDING_FIN
SELECT *  FROM BSEDB..TBL_HOLD_RPT (NOLOCK) 

---- Files Genration SP ---


	declare @FileDate1 varchar(30) 	
	Select @FileDate1 = CONVERT(varchar,@FileDate,113)

  exec BSEDB..EXPORT_HOLDING_FILES @FileDate1
	   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_HoldinguploadAddRemove_Filegeneration_26Apr2025
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[USP_HoldinguploadAddRemove_Filegeneration_26Apr2025] 
 @username varchar(50) = null,
 @Total int out,  
 @Uploadeddon varchar(500)
AS
BEGIN
	
	SET NOCOUNT ON;

	declare @FileDate date	
	set @FileDate=replace(CONVERT(VARCHAR(30),convert(date, @Uploadeddon ,103)), '/', ' ') 


	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = 'ERROR' WHERE PARTY_CODE IN ('05ABLB','05ACDLR','05ASLR') 

	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = 'K111613' WHERE PARTY_CODE IN ('K11650') 
	
	UPDATE CH SET PARTY_CODE = PARENTCODE FROM BSEDB..CLIENT_HOLDING CH, ANAND1.MSAJAG.DBO.CLIENT_DETAILS B WITH (NOLOCK)
	WHERE CH.PARTY_CODE = B.CL_CODE AND CH.PARTY_CODE LIKE '98%' AND DP_DATE IN (@FileDate)
	
	UPDATE CH SET PARTY_CODE = B.NEW_CODE FROM BSEDB..CLIENT_HOLDING CH, BSEDB..TBL_OCNC B WHERE PARTY_CODE = OLD_CODE AND DP_DATE IN (@FileDate)

	DELETE FROM BSEDB..CLIENT_HOLDING_NEW WHERE DP_DATE = @FileDate

	DELETE FROM BSEDB..CLIENT_HOLDING WHERE QTY <= 0

-----


 INSERT INTO BSEDB..CLIENT_HOLDING_NEW
 SELECT * FROM BSEDB..CLIENT_HOLDING (NOLOCK) WHERE DP_DATE = @FileDate

 UPDATE BSEDB..CLIENT_HOLDING_NEW SET PARTY_CODE = REPLACE(PARTY_CODE,' ','') WHERE DP_DATE = @FileDate AND PARTY_CODE LIKE '% %'
 
 -------

 SELECT TOP 0 DP_DATE,PARTY_CODE,CLIENTID,ISIN,QTY,PLD_QTY,EXCH_PLD INTO #CLT_HS FROM BSEDB..CLIENT_HOLDING WHERE 1 = 2

INSERT INTO #CLT_HS
SELECT DP_DATE,UPPER(LTRIM(RTRIM(PARTY_CODE))) AS PARTY_CODE,CLIENTID,ISIN,SUM(QTY) AS QTY,SUM(PLD_QTY) AS PLD_QTY,SUM(EXCH_PLD) AS EXCH_PLD
 FROM BSEDB..CLIENT_HOLDING (NOLOCK) WHERE DP_DATE = @FileDate
 GROUP BY DP_DATE,PARTY_CODE,CLIENTID,ISIN
 ORDER BY DP_DATE,PARTY_CODE,CLIENTID,ISIN

 
TRUNCATE TABLE BSEDB..TBL_HOLD_RPT  

INSERT INTO BSEDB..TBL_HOLD_RPT
SELECT C.CLIENTID,'', UPPER(LTRIM(RTRIM(M.PARENTCODE))) AS PARTY_CODE,M.LONG_NAME,M.PAN_GIR_NO,C.ISIN,'','',PLDQTY = (PLD_QTY),QTY-PLD_QTY,QTY,DP_DATE
FROM #CLT_HS C 
LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT_DETAILS M WITH (NOLOCK)
ON C.PARTY_CODE = M.CL_CODE
 WHERE  DP_DATE = @FileDate
ORDER BY CLIENTID,C.PARTY_CODE,ISIN


----


UPDATE F SET UCC = 'AP_'+ B.SBTAG,CLTPAN = B.PANNO FROM MIS.SB_COMP.DBO.VW_05TAGS B WITH (NOLOCK) ,  BSEDB..TBL_HOLD_RPT F (NOLOCK) 
WHERE F.UCC = B.GLCODE AND F.UCC LIKE '05%'

UPDATE F SET ACCTYPE = DP.ACCTYPE FROM	BSEDB..TBL_HOLD_RPT F (NOLOCK), BSEDB..TBL_ACCTYP_MST DP				
		WHERE F.ACCNO = DP.ACCNO 
		
UPDATE BSEDB..TBL_HOLD_RPT SET ACCTYPE = 'OWN' WHERE ACCNO IN ('1203320000072218','1203320018512446','1203320020369832','1601430000003350','1601430000003496')

UPDATE BSEDB..TBL_HOLD_RPT SET PLDQTY = TOTQTY,FREEQTY = 0 WHERE ACCNO = '20016807' AND FREEQTY <> 0 

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'NNNNN1111N' WHERE CLTPAN IN ('PAN_EXEMPT','PAN EXEMPT') 

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'ABCDE1234F' WHERE CLTPAN = '' 

---------------

		UPDATE	BSEDB..TBL_HOLD_RPT
		SET		SECTYPE = (
				CASE
					WHEN LEFT(ISNULL(SECTYPE,''),2) = 'MF' OR LEFT(ISNULL(ISIN,''),3) = 'INF' THEN 'MF'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'N' THEN 'BOND'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'G' THEN 'DEBT'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'P' THEN 'PREF'
					WHEN LEFT(ISNULL(SECTYPE,''),1) = 'W' THEN 'WT'
					---WHEN LEFT(ISNULL(SECURITY_TYPE,''),1) = 'I' THEN 'IDR'
					ELSE 'EQ'
				END) -- WHERE RPT_DATE = @FileDate

-------------------------

UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30009510184021' WHERE ACCNO ='10184021' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820016807' WHERE ACCNO ='20016807' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820057525' WHERE ACCNO ='20057525' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820090631' WHERE ACCNO ='20090631' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820057752' WHERE ACCNO ='20057752' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154914216209' WHERE ACCNO ='14216209' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30012610003588' WHERE ACCNO ='10003588' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154916921197' WHERE ACCNO ='16921197' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154932108952' WHERE ACCNO ='32108952' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30115113326100' WHERE ACCNO ='13326100' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154915464303' WHERE ACCNO ='15464303' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30154915434303' WHERE ACCNO ='15434303' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820129509' WHERE ACCNO ='20129509' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820131776' WHERE ACCNO ='20131776' 
UPDATE BSEDB..TBL_HOLD_RPT SET ACCNO ='IN30134820130005' WHERE ACCNO ='20130005' 


UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AEVPC3010R' WHERE UCC = 'AP_SPPUNE' AND CLTNAME = 'CHANGEDIA S R'
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AFOPS1625L' WHERE UCC = 'AP_DSSFR' AND CLTNAME = 'DILIP SHRIDHAR SAWANT'

UPDATE BSEDB..TBL_HOLD_RPT SET UCC = 'AP_APOO',CLTNAME = 'APOORVA FINANCIAL SERVICE' WHERE UCC IN ('AP_APOO','AP_APOOR') AND CLTPAN = 'BELPK5411D'
UPDATE BSEDB..TBL_HOLD_RPT SET UCC = 'AP_YVM',CLTNAME = 'YATINKUMAR V MAKHECHA' WHERE UCC = 'AP_YVMG' AND CLTPAN = 'AFHPM6286J'

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AAACM6094R' WHERE UCC IN ('EEEEE','ERROR','V37421','V30521','V153','V307','V611','AL57627','A401','A404','A408')
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AAACM6094R' WHERE UCC IN ('12798')

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'ABCDE1234F' WHERE UCC IN ('R6209ZZ','A511','K012','L112')

UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'AEUPS4220G' WHERE UCC = 'M21725'
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'CRHPK5592B' WHERE UCC = 'M137028'
UPDATE BSEDB..TBL_HOLD_RPT SET CLTPAN = 'CMGPS5542H' WHERE UCC = 'S390466'



-----------------------****************------------------------------


-- SELECT DISTINCT ACCNO FROM BSEDB..TBL_HOLD_RPT (NOLOCK) WHERE RPT_DATE = @FileDate ORDER BY ACCNO -- 30

SELECT RPT_DATE,ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SECTYPE,SUM(PLDQTY) AS PLDQTY,SUM(FREEQTY) AS FREEQTY,SUM(TOTQTY) AS TOTQTY INTO #RPT 
FROM BSEDB..TBL_HOLD_RPT (NOLOCK)  WHERE RPT_DATE = @FileDate 
GROUP BY RPT_DATE,ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SECTYPE
ORDER BY RPT_DATE,ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SECTYPE

TRUNCATE TABLE BSEDB..TBL_HOLD_RPT

INSERT INTO BSEDB..TBL_HOLD_RPT
SELECT ACCNO = ACCNO,ACCTYPE = ACCTYPE,UCC = UCC,CLTNAME = CLTNAME,CLTPAN = CLTPAN,ISIN = ISIN ,SCRIPNAME = '', SECTYPE = SECTYPE,
PLDQTY = PLDQTY,FREEQTY = FREEQTY,TOTQTY = TOTQTY,RPT_DATE = RPT_DATE
FROM #RPT  ORDER BY UCC


----------------


SELECT ACCNO,ACCTYPE,UCC,CLTNAME,CLTPAN,ISIN,SCRIPNAME,SECTYPE,ROUND(CONVERT(FLOAT,PLDQTY),3) PLDQTY,ROUND(CONVERT(FLOAT,FREEQTY),3) FREEQTY,
ROUND(CONVERT(FLOAT,TOTQTY),3) TOTQTY,RPT_DATE INTO #NSE FROM BSEDB..TBL_HOLD_RPT 
 ORDER BY RPT_DATE,ACCNO,UCC

 -----------

--SELECT * FROM #NSE WHERE UCC = 'BBBB'
--SELECT * FROM #NSE WHERE CLTPAN = ''
--SELECT * FROM #NSE WHERE CLTPAN IS NULL
--SELECT * FROM #NSE WHERE CLTPAN LIKE '%.%'
--SELECT * FROM #NSE WHERE CLTPAN LIKE '%,%'
--SELECT * FROM #NSE WHERE LEN(CLTPAN) <> 10


------------------ FINAL DATA ----- 


DELETE FROM BSEDB..CLIENT_HOLDING_FIN WHERE RPT_DATE = @FileDate


INSERT INTO BSEDB..CLIENT_HOLDING_FIN
SELECT *  FROM BSEDB..TBL_HOLD_RPT (NOLOCK) 

---- Files Genration SP ---


	declare @FileDate1 varchar(30) 	
	Select @FileDate1 = CONVERT(varchar,@FileDate,113)

  exec BSEDB..EXPORT_HOLDING_FILES @FileDate1
	   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_HoldinguploadAddRemove_Process
-- --------------------------------------------------
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 

--exec USP_HoldinguploadAddRemove_Process 

CREATE PROCEDURE [dbo].[USP_HoldinguploadAddRemove_Process] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

	declare @Processdate date
	select @Processdate = Uploadeddon from INTRANET.[Risk].dbo.tbl_HoldongFileAddRemove

	select * into #T from INTRANET.[Risk].dbo.tbl_HoldongFileAddRemove


	INSERT INTO BSEDB..CLIENT_HOLDING
	SELECT ClientCode,'',ISIN,ClientId,QTY,convert(date,Uploadeddon),0,0,0 FROM #T
	
	INSERT INTO INHOUSE..EXCH_HOLD_REPORTING
	SELECT convert(date,Uploadeddon),ClientCode,'','',ISIN,ClientId,QTY,0,QTY,'',0,GETDATE (),'',''
	FROM #T WHERE CLIENTID NOT IN ('1203320030135814','1203320030135829','1203320051669051') 

	--DELETE FROM BSEDB..CLIENT_HOLDING WHERE DP_DATE < GETDATE () -10


	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = REPLACE(PARTY_CODE,' ','') WHERE DP_DATE = @Processdate AND PARTY_CODE LIKE '% %'
	
	UPDATE BSEDB..CLIENT_HOLDING SET ISIN = REPLACE(ISIN,' ','') WHERE DP_DATE = @Processdate AND ISIN LIKE '% %'
	
	 -- BEGIN TRAN 
	UPDATE T SET PARTY_CODE = PARENTCODE FROM BSEDB..CLIENT2 C , BSEDB..CLIENT_HOLDING T 
	WHERE T.PARTY_CODE = C.CL_CODE AND T.PARTY_CODE LIKE '98%'
		--	COMMIT

 
	SELECT UPPER(LTRIM(RTRIM(PARTY_CODE))) AS PARTY_CODE,EXCHANGE,ISIN,CLIENTID,SUM(QTY) AS QTY,DP_DATE,SUM(PLD_QTY) AS PLD_QTY,
	SUM(EXCH_PLD) AS EXCH_PLD,SUM(PLD_ADD) AS PLD_ADD 
	INTO #CLIENT_HOLDING_NEW FROM BSEDB..CLIENT_HOLDING 
	WHERE DP_DATE = @Processdate
	GROUP BY PARTY_CODE,EXCHANGE,ISIN,CLIENTID,DP_DATE
	ORDER BY PARTY_CODE,EXCHANGE,ISIN,CLIENTID
	
	--SELECT * FROM #CLIENT_HOLDING_NEW WHERE QTY < 0 -- (DATA POPUP TO GIVE IF ANY FOR CHECKING)
	
	DELETE FROM #CLIENT_HOLDING_NEW WHERE QTY <= 0 
	
	DELETE FROM BSEDB..CLIENT_HOLDING WHERE DP_DATE = @Processdate -- 92671
	
	INSERT INTO BSEDB..CLIENT_HOLDING
	SELECT * FROM #CLIENT_HOLDING_NEW (NOLOCK) WHERE DP_DATE = @Processdate
	
	 ---*************** MISMATCH ************----
	
	 
	 SELECT CLIENTID,ISIN,SUM(QTY) QTY ,SUM(PLD_QTY+PLD_ADD) PLD_QTY,SUM(EXCH_PLD) EXCH_PLD  INTO #BO
	 FROM BSEDB..CLIENT_HOLDING WITH (NOLOCK) WHERE  DP_DATE = @Processdate
	 GROUP BY CLIENTID,ISIN,DP_DATE
	
	   
	 ----  
	  
	 SELECT  HLD_AC_CODE,HLD_ISIN_CODE,SUM(DP_HOLD) DP_HOLD INTO #DP FROM BSEDB..FINAL_HOLD  WHERE  DP_DT = @Processdate
	 GROUP BY HLD_AC_CODE,HLD_ISIN_CODE
	 
	
	 
	------ Show Report ----
	
	 SELECT  * 	FROM ( 
			SELECT ISNULL(D.HLD_AC_CODE,Y.CLIENTID) AS ID ,ISNULL(D.HLD_ISIN_CODE,ISIN) ISIN 
			,ISNULL(D.DP_HOLD,0) AS_PER_DP,ISNULL(Y.QTY,0) AS_PER_BO,(ISNULL(D.DP_HOLD,0) - ISNULL(Y.QTY,0)) AS DIFF_QTY  
				FROM #DP  D
					FULL OUTER JOIN 
				#BO Y ON D.HLD_AC_CODE = CLIENTID AND D.HLD_ISIN_CODE = ISIN 
			) A
				WHERE DIFF_QTY <> 0  
		ORDER BY ISIN
	


	   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_log_dispatchfile
-- --------------------------------------------------
CREATE proc USP_log_dispatchfile
(@flag as varchar(10),@regcode as varchar(50),@brcode as varchar(50),@username as varchar(25))
as
if @flag = 'Block'
begin
insert into tbl_log_dispatchfile
values (@regcode,@brcode,getdate(),'2049-12-31',@username,'Block')
end

if @flag = 'UnBlock'
begin
update tbl_log_dispatchfile set fld_unblockdate = getdate(),fld_userid=@username,fld_flag='UnBlock'
where fld_region = @regcode and fld_brcode = @brcode and fld_flag = 'Block' and fld_unblockdate = '2049-12-31'
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_MTFData_query_BO
-- --------------------------------------------------
  
--exec Usp_MTFData_query_BO  
CREATE Proc [dbo].[Usp_MTFData_query_BO]  
AS  
BEGIN  
  
 select *  
 into #sett12  
 from msajag.dbo.sett_mst where Start_date < Convert(varchar(11),GETDATE(),120) and  Sec_Payin>= Convert(varchar(11),GETDATE(),120)  
 and Sett_Type in ('M','Z')  
 
 
 declare @maxDate datetime  
 Declare @Vardate datetime  
 Select @Vardate= max(Start_date)  from #sett12  
 select * into #VARDETAIL from AngelNSECM.msajag.dbo.VARDETAIL where DetailKey=replace(convert(varchar, @Vardate, 103),'/','')  
  
 select distinct SCRIP_CD,ISIN,CL_RATE into #tbl_closing_mtm from AngelNSECM.msajag.dbo.closing_mtm  
 where cast(sysdate as date)= (select max(sysdate)  from AngelNSECM.msajag.dbo.closing_mtm)  
 select a.Party_Code,a.scrip_cd,a.CertNo,a.OrgQty,a.Qty,a.BCltDpId,b.VarMarginRate,b.AppVar  
 into #var_deltrans  
 from deltrans a left join #VARDETAIL b on  
 a.CertNo=b.IsIN  
 where a.BCltDpId in ('1203320030135829') and DrCr='D' and Filler2='1'   and Delivered='0'  --3 58 973  
  
  
 select a.*,b.CL_RATE  
 into #closing_2_deltrans  
 from #var_deltrans a left join #tbl_closing_mtm b on  
 a.CertNo=b.IsIN  
  
 select a.*,b.[Angel scrip category],b.[BSE_VAR %],b.[NSE_VAR %],b.[ANGEL_VAR %]  
 into #final_data  
 from #closing_2_deltrans a left join [CSOKYC-6].general.dbo.TBL_NRMS_RESTRICTED_SCRIPS b  
 on a. CertNo =b.[ISIN No]  
  
 select Party_Code,scrip_cd,CertNo,sum (OrgQty) as OrgQty,sum (Qty) as Qty,BCltDpId,VarMarginRate,AppVar,CL_RATE,[Angel scrip category],[BSE_VAR %],[NSE_VAR %],[ANGEL_VAR %]  
 into #final_value1 from #final_data  
 group by Party_Code,scrip_cd,CertNo,BCltDpId,VarMarginRate,AppVar,CL_RATE,[Angel scrip category],[BSE_VAR %],[NSE_VAR %],[ANGEL_VAR %]  
  
 update #final_value1  
 set VarMarginRate='100.00'  
 where [Angel scrip category]='Poor'  
  
 update #final_value1  
 set VarMarginRate='20.00'  
 where VarMarginRate <=20  
  
 select *,Qty*CL_RATE as total_value, (Qty*CL_RATE)*VarMarginRate/100 as haircut_value,(Qty*CL_RATE)-((Qty*CL_RATE)*VarMarginRate/100) as final_value into #tbl_final_data  from #final_value1  
  
 select Party_Code,sum (final_value) as final_value  from #tbl_final_data group by Party_Code   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSECM_SHORTAGE_FORNBFC_SP
-- --------------------------------------------------
CREATE Proc USP_NSECM_SHORTAGE_FORNBFC_SP
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int)       
AS      
      
      
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)      
      
set transaction isolation level read uncommitted      
/*      
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
      
 set @StatusId ='broker'      
 set @Statusname='BROKER'       
 set @segment ='BSECM'        
 set @sett_Type ='A'        
 set @sett_no='2012191'      
*/      
 Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = M.Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),      
 Isettqty = 0, Ibenqty = 0, Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0,      
 Pledge = 0, BSEHold = 0, BSEPledge = 0      
 Into #delpayinmatch      
 From      
 msajag.dbo.Client1 C1 with (nolock)      
 inner join msajag.dbo.Client2 C2 with (nolock)      
 on C1.Cl_Code = C2.Cl_Code       
 inner join       
 msajag.dbo.Deliveryclt D with (nolock)       
 ON  C2.Party_Code = D.Party_Code      
 inner join       
  msajag.dbo.Multiisin M with (nolock)       
 ON M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series       
 Left Outer Join      
 msajag.dbo.Deltrans C with (nolock)      
 On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type      
 And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series      
 And D.Party_Code = C.Party_Code And C.Drcr = 'C'      
 And c.Filler2 = 1 /*And Sharetype <> 'Auction'*/)      
 Where D.Inout = 'I' And M.Valid = 1      
 And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type        
 And @Statusname=      
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
 Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, M.Isin      
 Having D.Qty > 0--:4      
      
If @Opt <> 1      
Begin      
 Delete From #delpayinmatch Where Delqty <= Recqty      
End      
      
/*      
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
      
 set @StatusId ='broker'      
 set @Statusname='BROKER'       
 set @segment ='BSECM'        
 set @sett_Type ='A'        
 set @sett_no='2012191'      
*/      
      
      
set transaction isolation level read uncommitted      
Insert Into #delpayinmatch      
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
 msajag.DBO.Client1 C1 with (nolock)      
inner join       
  msajag.DBO.Client2 C2 with (nolock)      
  on C1.Cl_Code = C2.Cl_Code      
  inner join       
  msajag.Dbo.Deltrans D with (nolock)      
  on C2.Party_Code = D.Party_Code        
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)      
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type      
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
Group By D.Isett_No, D.Isett_Type, D.Party_Code,D. Certno      
union all      
Select D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqty = Sum(Case When D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtyprint = Sum(Case When D.Delivered = 'G' And D.Trtype = 1000 Then D.Qty Else 0 End),      
Isettqtymark = Sum(Case When D.Delivered = '0' And D.Trtype <> 1000 Then D.Qty Else 0 End),      
Ibenqtymark = Sum(Case When D.Delivered = '0' And D.Trtype = 1000 Then D.Qty Else 0 End) ,      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0      
From       
 BSEDB.DBO.Client1 C1 with (nolock)      
inner join      
  BSEDB.DBO.Client2 C2 with (nolock)      
  on C1.Cl_Code = C2.Cl_Code      
  inner join       
  BSEDB.Dbo.Deltrans D with (nolock)      
  on C2.Party_Code = D.Party_Code        
Where D.Filler2 = 1 And D.Drcr = 'D' And D.Delivered <> 'D' And D.Trtype In (907, 908, 1000)      
And D.Isett_No = @Sett_No And D.Isett_Type = @Sett_Type      
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
Group By D.Isett_No, D.Isett_Type, D.Party_Code, D.Certno--:03      
      
set transaction isolation level read uncommitted      
      
      
/*      
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
      
 set @StatusId ='broker'      
 set @Statusname='BROKER'       
 set @segment ='BSECM'        
 set @sett_Type ='A'        
 set @sett_no='2012191'      
*/      
      
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),      
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From       
(      
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)      
From msajag.dbo.Deltrans D with (nolock)      
inner join       
msajag.dbo.Deliverydp Dp with (nolock)      
on D.Bdpid = Dp.Dpid      
And D.Bcltdpid = Dp.Dpcltno       
Where D.Filler2 = 1 And D.Drcr = 'D'      
And D.Delivered = '0' And D.Trtype In (904, 909) And DP.[Description] Not Like '%pool%'      
Group By D.Party_Code, D.Certno       
) A       
Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno      


/*      
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10)        
      
 set @StatusId ='broker'      
 set @Statusname='BROKER'       
 set @segment ='BSECM'        
 set @sett_Type ='A'        
 set @sett_no='2012191'      
*/      
      
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),      
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From       
(      
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),      
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)      
From BSEDB.Dbo.Deltrans D with (nolock)       
inner join       
 BSEDB.Dbo.Deliverydp Dp with (nolock)      
ON D.Bdpid = Dp.Dpid      
And D.Bcltdpid = Dp.Dpcltno      
Where D.Filler2 = 1 And D.Drcr = 'D'      
And D.Delivered = '0' And D.Trtype In (904, 909) And DP.[Description] Not Like '%pool%'      
Group By D.Party_Code, D.Certno       
) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno      
      
/*      
 declare @StatusId Varchar(15),@Statusname Varchar(25),@segment varchar(10),@sett_Type as varchar(2),@sett_no as varchar(10) ,      
 @Opt INT ,@BranchCD VARCHAR(30)      
      
 set @StatusId ='broker'      
 set @Statusname='BROKER'       
 set @segment ='BSECM'        
 set @sett_Type ='A'        
 set @sett_no='2012191'      
      
      
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)      
SET @Opt =0      
*/      
    
If Upper(@Branchcd) = 'All'      
begin      
 Select @Branchcd = '%'      
end      
      
If @Opt = 1      
begin      

delete from [196.1.115.219].TEST_DATA.DBO.NSECM_SHORTAGE_FORNBFC_SP where sett_no=@sett_no and sett_type=@sett_type      
    
       
 set transaction isolation level read uncommitted      
       
       
insert into [196.1.115.219].TEST_DATA.DBO.NSECM_SHORTAGE_FORNBFC_SP     
 Select R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,      
 Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),      
 Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),      
 Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge      
 From        
  msajag.dbo.Client1 C1 with (nolock)      
  inner join       
 msajag.dbo.Client2 C2 with (nolock)      
 on C1.Cl_Code = C2.Cl_Code      
 inner join       
 #delpayinmatch R  with (nolock)      
 on R.Party_Code = C2.Party_Code       
 inner join       
 msajag.dbo.Multiisin M with (nolock)      
 on M.Isin = R.Certno       
 Where R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type      
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
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,      
 R.Certno, R.Hold, R.Pledge, R.BSEHold, R.BSEPledge      
 Having Sum(R.Delqty) > 0      
 --Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd      
end      
Else      
begin      
      
 delete from [196.1.115.219].TEST_DATA.DBO.NSECM_SHORTAGE_FORNBFC_SP where sett_no=@sett_no and sett_type=@sett_type      
     
       
 set transaction isolation level read uncommitted      
       
 insert into [196.1.115.219].TEST_DATA.DBO.NSECM_SHORTAGE_FORNBFC_SP
 Select R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,      
 Delqty = Sum(R.Delqty), Recqty = Sum(R.Recqty), Isettqtyprint = Sum(R.Isettqtyprint), Isettqtymark = Sum(R.Isettqtymark),      
 Ibenqtyprint = Sum(R.Ibenqtyprint), Ibenqtymark = Sum(R.Ibenqtymark),      
 Hold = R.Hold, Pledge = R.Pledge, BSEHold = R.BSEHold, BSEPledge = R.BSEPledge      
 From         
  msajag.dbo.Client1 C1 with (nolock)      
  inner join       
 msajag.dbo.Client2 C2 with (nolock)      
 on C1.Cl_Code = C2.Cl_Code      
 inner join       
 #delpayinmatch R (nolock)      
 on R.Party_Code = C2.Party_Code      
 inner join       
 msajag.dbo.Multiisin M with (nolock)      
 on  M.Isin = R.Certno      
 Where  R.Sett_No = @Sett_No And R.Sett_Type = @Sett_Type       
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
 Group By R.Sett_No, R.Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, R.Certno,      
 R.Hold, R.Pledge, R.BSEHold, R.BSEPledge      
 Having Sum(R.Delqty) > (Sum(R.Recqty) + Sum(R.Isettqtyprint) + Sum(R.Ibenqtyprint) )      
 --Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_PoolDPMismatchRpt
-- --------------------------------------------------

-- USP_PoolDPMismatchRpt '12/04/2019','Broker','CSO'
CREATE proc [dbo].[USP_PoolDPMismatchRpt](@FromDate varchar(11),@access_to varchar(30),                  
@access_code varchar(30)   )  
as  
Begin  

Declare @filterdate as varchar(15),@deletedate as varchar(15)--,@FromDate  varchar(11) --'2019-04-12'
--set @FromDate = '12/04/2019'
set @filterdate =  CONVERT(varchar(10),CONVERT(date, @FromDate, 103), 120) 
set @deletedate = CONVERT(varchar(10),DATEADD(day, DATEDIFF(day, 10, @filterdate), 0) , 120) 
--replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', '-')+' 00:00:00' 
--select @FromDate
--select @filterdate

Select * into #DP_NSDLHOLD_log from INTRANET.risk.dbo.DP_NSDLHOLD_log with(nolock) where Uploadeddon = @filterdate 
Select * into #DP_CSDLHOLD_MISSING_log from INTRANET.risk.dbo.DP_CSDLHOLD_MISSING_log with(nolock) where Uploadeddon = @filterdate

TRUNCATE TABLE NSE_DA
TRUNCATE TABLE BSE_DA

DELETE FROM INHOUSE.DBO.EXCH_HOLD_REPORTING WHERE EXCHANGE = '' AND HOLDINGDATE = @filterdate 

 INSERT INTO  NSE_DA  
 SELECT PARTY_CODE,LONG_NAME = '',SCRIP_CD,SERIES,BDPID = '',BCLTDPID,ISIN = CERTNO,SETT_NO = '',SETT_TYPE = '',TOTAL_HOLD QTY,0,TOTAL_HOLD QTY   
    FROM INHOUSE.DBO.EXCH_HOLD_REPORTING WHERE EXCHANGE = 'NSE' AND HOLDINGDATE = @filterdate -- '2019-03-20'  
		-- AND BCLTDPID NOT IN ('1203320000006579','10003588','1203320006951435','10184021','1203320030135814','1203320030135829','1203320051669051',
		-- '1203320186015090','20306643')
		AND BCLTDPID NOT IN ('1203320030135814','1203320030135829','1203320051669051','1203320186015090','20306643')
	   	
	UPDATE NSE_DA SET ISIN = 'INE528G01035' WHERE ISIN = 'INX528G01035'

	UPDATE NSE_DA SET ISIN = 'INE425B01027' WHERE ISIN = 'INX425B01027'
     
   
 INSERT INTO BSE_DA  
 SELECT PARTY_CODE,LONG_NAME = '',SCRIP_CD,SERIES,BDPID = '',BCLTDPID,ISIN = CERTNO,SETT_NO = '',SETT_TYPE = '',TOTAL_HOLD QTY,0,TOTAL_HOLD QTY   
    FROM INHOUSE.DBO.EXCH_HOLD_REPORTING WHERE EXCHANGE = 'BSE' AND HOLDINGDATE = @filterdate --'2019-03-20'  
		-- AND BCLTDPID NOT IN ('1203320000006579','10003588','1203320006951435','10184021','1203320030135814','1203320030135829','1203320051669051',
		-- '1203320186015090','20306643')
		AND BCLTDPID NOT IN ('1203320030135814','1203320030135829','1203320051669051','1203320186015090','20306643')

INSERT INTO BSE_DA
	SELECT PARTY_CODE,LONG_NAME = '',SCRIP_CD,SERIES,BDPID = '',BCLTDPID,ISIN = CERTNO,SETT_NO = '',SETT_TYPE = '',TOTAL_HOLD QTY,0,TOTAL_HOLD QTY 
        FROM INHOUSE.DBO.EXCH_HOLD_REPORTING (NOLOCK) WHERE EXCHANGE IN ('DP') AND HOLDINGDATE = @filterdate --'2019-03-20' 
  
 SELECT T.*,PARENTCODE INTO #MAPCL  FROM (SELECT DISTINCT PARTY_CODE FROM BSE_DA WHERE PARTY_CODE LIKE '98%' ) T, BSEDB.dbo.CLIENT2 C  
    WHERE T.PARTY_CODE = C.CL_CODE   
   
    UPDATE BSE_DA SET PARTY_CODE = PARENTCODE   
    FROM  #MAPCL M WHERE BSE_DA.PARTY_CODE= M.PARTY_CODE 

	SELECT T.*,PARENTCODE INTO #MAPCLN  FROM (SELECT DISTINCT PARTY_CODE FROM NSE_DA WHERE PARTY_CODE LIKE '98%' ) T, BSEDB.dbo.CLIENT2 C
			WHERE T.PARTY_CODE = C.CL_CODE 
			
		 UPDATE NSE_DA SET PARTY_CODE = PARENTCODE 
				FROM  #MAPCLN M WHERE NSE_DA.PARTY_CODE= M.PARTY_CODE
   
  CREATE TABLE #POOL_ACC  
 (SETT_NO  VARCHAR(125),SETT_TYPE VARCHAR(125), PARTY_CODE VARCHAR(125), LONG_NAME VARCHAR(125), SCRIPNAME VARCHAR(100), SCRIP_CD VARCHAR(125),  
  SERIES VARCHAR(125), ISIN VARCHAR(125), QTY VARCHAR(125), BDPID VARCHAR(125), BCLTDPID VARCHAR(125), CL_RATE VARCHAR(125),  
  BRANCH_CD VARCHAR(125),  SUB_BROKER VARCHAR(125), CL_TYPE VARCHAR(125),  CL_STATUS VARCHAR(125), VAR_RATE VARCHAR(125),  
  AMOUNT VARCHAR(125), VAR_RATE1 VARCHAR(125), FINALAMOUNT VARCHAR(125))  
  
  
 CREATE TABLE #POLL_NSE  
 (SETT_NO VARCHAR(125), SETT_TYPE VARCHAR(125), PARTY_CODE VARCHAR(125),LONG_NAME VARCHAR(125), SCRIPNAME VARCHAR(125),   
 SCRIP_CD VARCHAR(125), SERIES VARCHAR(125),ISIN VARCHAR(125),QTY VARCHAR(125),BDPID VARCHAR(125),BCLTDPID VARCHAR(125),CL_RATE VARCHAR(125),BRANCH_CD  
 VARCHAR(125), SUB_BROKER VARCHAR(125), CL_TYPE VARCHAR(125),CL_STATUS VARCHAR(125),AMOUNT VARCHAR(125))  
     

 DELETE FROM POOL_HOLD WHERE PD_DATE = @filterdate --'20/03/2019'  
  
 DELETE FROM FINAL_HOLD WHERE DP_DT = @filterdate --'2019-03-20'  

 DELETE FROM BSEDB..FINAL_HOLD WHERE DP_DT = @filterdate --'2019-03-20'  
   
 /************/  

 	 /* -- Changed on 16-SEP-2023 by Dharmesh Mistry --

 INSERT INTO #POOL_ACC  
 EXEC BSEDB.DBO.RPT_DELHOLDINGASONDATE 'BROKER', 'BROKER', @filterdate,'12033200','1203320000006579','0  ','ZZZZZZZZZZ','0','ZZZZZZZZ', '1','D'   
  
 INSERT INTO #POOL_ACC  
 EXEC BSEDB.DBO.RPT_DELHOLDINGASONDATE 'BROKER', 'BROKER', @filterdate,'IN300126','10003588','0  ','ZZZZZZZZZZ','0','ZZZZZZZZZZ', '1','D'   
  
 INSERT INTO #POLL_NSE  
 EXEC MSAJAG.DBO.RPT_DELHOLDINGASONDATE_OPT_NEW 'BROKER', 'BROKER', @filterdate,'12033200','1203320006951435','0','ZZZZZZZZZZ','0','ZZZZZZZZZZ', '1','D'   
  
 INSERT INTO #POLL_NSE  
 EXEC  MSAJAG.DBO.RPT_DELHOLDINGASONDATE_OPT_NEW 'BROKER', 'BROKER', @filterdate,'IN300095','10184021','0  ','ZZZZZZZZZZ','0','ZZZZZZZZZZ', '1','D'    
  
 /****/  

 ---- ADDED BY DHARMESH MISTRY ON 12-JAN-2023 ---
 

	SELECT DISTINCT SETT_NO,SETT_TYPE INTO #SB FROM #POOL_ACC


	SELECT D.PARTY_CODE,DRCR,CERTNO,SUM(QTY) AS QTY,D.SETT_NO,S.SETT_TYPE,BCLTDPID INTO #EPN_B 
	FROM BSEDB..DELTRANS_REPORT D (NOLOCK), #SB S WHERE D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE AND TRANSDATE <= @filterdate
	AND BCLTDPID IN ('1203320000006579') AND PARTY_CODE NOT IN ('EXE','NSE','BROKER') AND DRCR = 'C' AND FILLER2 = 1
		AND TCODE  IN ( 
	SELECT TCODE FROM BSEDB..DELTRANS_REPORT D (NOLOCK), #SB S  WHERE D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE AND FILLER1 = 'EARLY PAYIN'
	AND BCLTDPID IN ('1203320000006579') AND PARTY_CODE IN ('EXE') AND TRTYPE = '906' AND DRCR = 'D' AND TRANSDATE <= @filterdate
	)
		GROUP BY D.PARTY_CODE,DRCR,CERTNO,D.SETT_NO,S.SETT_TYPE ,BCLTDPID

	--- NON POA CLIENTS ---

	--BEGIN TRAN 
	--DELETE FROM #POOL_ACC WHERE PARTY_CODE+ISIN IN
	--(SELECT PARTY_CODE+CERTNO FROM DELTRANS (NOLOCK) WHERE DRCR = 'C' AND Reason = 'Early Pay-In' AND Filler1 = 'Direct Pay-In' 
	--AND SETT_NO+SETT_TYPE IN 
	--(SELECT SETT_NO+SETT_TYPE FROM #SB WHERE  ))

	UPDATE P SET BCLTDPID = '1100001000014641' FROM #EPN_B E, #POOL_ACC P
	WHERE E.SETT_NO = P.SETT_NO AND E.SETT_TYPE = P.SETT_TYPE AND E.PARTY_CODE = P.PARTY_CODE AND P.QTY = E.QTY
	AND E.BCLTDPID = P.BCLTDPID AND E.CERTNO = P.ISIN --AND E.DRCR = 'C'


	---- NSE ----

	SELECT DISTINCT SETT_NO,SETT_TYPE INTO #SN FROM #POLL_NSE

	SELECT TCODE  INTO #TCODE FROM MSAJAG.DBO.DELTRANS D (NOLOCK), #SN S (NOLOCK) WHERE D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE
	 AND FILLER1 = 'EARLY PAYIN' AND BCLTDPID IN ('1203320006951435') AND PARTY_CODE IN ('EXE') AND TRTYPE = '906' 
	 AND DRCR = 'D' AND TRANSDATE <= @filterdate
 

	SELECT D.PARTY_CODE,DRCR,CERTNO,SUM(QTY) AS QTY,D.SETT_NO,S.SETT_TYPE,BCLTDPID INTO #EPN_N
	FROM MSAJAG.DBO.DELTRANS D (NOLOCK), #SN S (NOLOCK) WHERE D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE AND TRANSDATE <= @filterdate
		AND BCLTDPID IN ('1203320006951435') AND PARTY_CODE NOT IN ('EXE','NSE','BROKER') AND DRCR = 'C' AND FILLER2 = 1
		AND TCODE  IN ( SELECT  TCODE FROM #TCODE )
			GROUP BY D.PARTY_CODE,DRCR,CERTNO,D.SETT_NO,S.SETT_TYPE ,BCLTDPID


	--SELECT D.PARTY_CODE,DRCR,CERTNO,SUM(QTY) AS QTY,D.SETT_NO,S.SETT_TYPE,BCLTDPID INTO #EPN_N
	--FROM MSAJAG.DBO.DELTRANS D (NOLOCK), #SN S (NOLOCK) WHERE D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE AND TRANSDATE <= 'JAN 10 2023'
	--AND BCLTDPID IN ('1203320006951435') AND PARTY_CODE NOT IN ('EXE','NSE','BROKER') AND DRCR = 'C' AND FILLER2 = 1
	--AND TCODE  IN ( 
	--SELECT TCODE,FILLER1 FROM MSAJAG.DBO.DELTRANS D (NOLOCK), #SN S (NOLOCK) WHERE D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE 
	-- AND FILLER1 = 'EARLY PAYIN'
	--AND BCLTDPID IN ('1203320006951435') AND PARTY_CODE IN ('EXE') AND TRTYPE = '906' AND DRCR = 'D' AND TRANSDATE <= 'JAN 10 2023'
	--)
	--GROUP BY D.PARTY_CODE,DRCR,CERTNO,D.SETT_NO,S.SETT_TYPE ,BCLTDPID

	----- NON POA CLIENTS ---
	/*


	SELECT * FROM #POLL_NSE WHERE  PARTY_CODE+ISIN IN
	(SELECT PARTY_CODE+CERTNO FROM MSAJAG..DELTRANS (NOLOCK) WHERE PARTY_CODE = 'S722198' AND DRCR = 'C' AND CERTNO = 'INF204KB15V2' 
	AND Reason = 'Early Pay-In' AND Filler1 = 'Direct Pay-In' AND SETT_NO+SETT_TYPE IN 
	(SELECT SETT_NO+SETT_TYPE FROM #SN ))

	*/



	--- DROP TABLE #EPN

	SELECT PARTY_CODE,CERTNO,SETT_NO,SETT_TYPE,SUM(QTY) AS QTY INTO #EPN FROM MSAJAG..DELTRANS D (NOLOCK) WHERE  DRCR = 'C'
	 --AND CERTNO = 'INF204KB15V2' PARTY_CODE = 'S722198' AND
	AND REASON = 'EARLY PAY-IN' AND FILLER1 = 'DIRECT PAY-IN' AND TRANSDATE <= @filterdate 
	 AND SETT_NO+SETT_TYPE IN 
		(SELECT SETT_NO+SETT_TYPE FROM #SN )
			GROUP BY PARTY_CODE,CERTNO,SETT_NO,SETT_TYPE

	Create index #p on  #poll_NSe (Party_Code,isin,sett_no,sett_type )
	Create index #E on  #EPN (Party_Code,CERTNO,sett_no,sett_type )

	-- BEGIN TRAN

	UPDATE P SET P.QTY=P.QTY-E.QTY FROM #POLL_NSE P , #EPN  E WHERE 
	 P.PARTY_CODE = E.PARTY_CODE AND P.ISIN = E.CERTNO
	 AND P.SETT_NO = E.SETT_NO AND P.SETT_TYPE = E.SETT_TYPE
 
	 DELETE P FROM #POLL_NSE P WHERE QTY <= 0

	 -- COMMIT

	-- SELECT * FROM #POLL_NSE WHERE PARTY_CODE = 'A451846' AND ISIN = 'INE062A01020'

	--BEGIN TRAN 
	--DELETE FROM #POLL_NSE WHERE PARTY_CODE+ISIN IN
	--(SELECT PARTY_CODE+CERTNO FROM MSAJAG..DELTRANS (NOLOCK) WHERE DRCR = 'C' AND Reason = 'Early Pay-In' AND Filler1 = 'Direct Pay-In' 
	--AND SETT_NO+SETT_TYPE IN 
	--(SELECT SETT_NO+SETT_TYPE FROM #SN WHERE SETT_TYPE IN ('N','W','F')))
	----ROLLBACK


	--UPDATE P SET BCLTDPID = '1100001100017670' FROM #EPN_N E, #POLL_NSE P
	--WHERE E.SETT_NO = P.SETT_NO AND E.SETT_TYPE = P.SETT_TYPE AND E.PARTY_CODE = P.PARTY_CODE AND P.QTY = E.QTY
	--AND E.BCLTDPID = P.BCLTDPID AND E.CERTNO = P.ISIN --AND E.DRCR = 'C'

	----- END FOR NEW ADDED ----
  
   INSERT INTO  POOL_HOLD   
   SELECT @filterdate,SETT_NO,SETT_TYPE,PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,ISIN,QTY,BDPID,BCLTDPID ,'BSE' FROM #POOL_ACC   
   UNION ALL   
   SELECT @filterdate,SETT_NO,SETT_TYPE,PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,ISIN,QTY,BDPID,BCLTDPID,'NSE' FROM  #POLL_NSE  
   
    SELECT T.*,PARENTCODE INTO #MAPCL1  FROM (SELECT DISTINCT PARTY_CODE FROM POOL_HOLD WHERE PARTY_CODE LIKE '98%' ) T, BSEDB.DBO.CLIENT2 C with (NOLOCK) 
		WHERE T.PARTY_CODE = C.CL_CODE   
  
   
    UPDATE POOL_HOLD SET PARTY_CODE = PARENTCODE   
		 FROM  #MAPCL1 M WHERE POOL_HOLD.PARTY_CODE= M.PARTY_CODE  
   
       
 INSERT INTO  NSE_DA    
	SELECT PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,BDPID,BCLTDPID,ISIN,Sett_No,Sett_TyPE ,QTY,0,QTY   
		FROM POOL_HOLD WHERE EXCHANGE ='NSE' AND PD_DATE = @filterdate--'20/03/2019'  
     
   
 INSERT INTO BSE_DA  
	 SELECT PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,BDPID,BCLTDPID,ISIN,Sett_No,Sett_TyPE ,QTY,0,QTY   
		 FROM POOL_HOLD WHERE EXCHANGE ='BSE' AND PD_DATE = @filterdate--'20/03/2019'  

	 -- End (16-SEP-2023)	  */
	 	
SELECT BCLTDPID,CERTNO,PARTY_CODE,SUM(QTY) AS QTY INTO #INTB_SETT FROM MSAJAG.DBO.DELTRANS_REPORT (NOLOCK) WHERE TRANSDATE <= @filterdate  -- '2023-09-11' 
AND FILLER2  = 1   AND DRCR = 'C' AND REASON = 'DEMAT' AND SETT_TYPE <> 'A'
AND SETT_NO IN (SELECT DISTINCT SETT_NO FROM MSAJAG.DBO.SETT_MST WHERE SEC_PAYIN > @filterdate -- '2023-09-11'
 AND SETT_TYPE IN ('M','F') AND START_DATE <= @filterdate ) -- '2023-09-11'
GROUP BY BCLTDPID,CERTNO,PARTY_CODE

INSERT INTO NSE_DA
SELECT PARTY_CODE,'','' ,'','',BCLTDPID,CERTNO,'','',QTY,0,QTY FROM #INTB_SETT

   /*** DP HOLDING  ***/
      
 SELECT HLD_AC_CODE,HLD_ISIN_CODE,SUM(DP_HOLD) DP_HOLD,HLD_HOLD_DATE INTO #DP FROM (   
 SELECT HLD_AC_CODE=DP_ID,HLD_ISIN_CODE = REPLACE(ISIN,'Á',''),SUM(QYANTITY) DP_HOLD,HLD_HOLD_DATE = @filterdate
  FROM #DP_NSDLHOLD_log GROUP BY DP_ID,ISIN  
 UNION ALL  
 SELECT DP_ID,REPLACE(ISIN,'Á','') ,SUM(QYANTITY),HLD_HOLD_DATE = @filterdate FROM #DP_CSDLHOLD_MISSING_log
 GROUP BY DP_ID,ISIN )A  
 GROUP BY HLD_AC_CODE,HLD_ISIN_CODE,HLD_HOLD_DATE  
   
   --- DELETE FINAL_HOLD WHERE  DP_DT = (SELECT MAX(HLD_HOLD_DATE) FROM #DP)  
  
   INSERT INTO FINAL_HOLD   
	SELECT * FROM #DP  

		DELETE FROM FINAL_HOLD WHERE DP_HOLD = 0

   INSERT INTO BSEDB..FINAL_HOLD   
	SELECT * FROM #DP  

		DELETE FROM BSEDB..FINAL_HOLD WHERE DP_HOLD = 0
     
  SELECT  PARTY_CODE,ISIN,CLIENTID,SUM(TOTAL_HLD) QTY INTO  #CLIENTWISE  
   FROM (  
 SELECT *  FROM NSE_DA ---where CLIENTID='1203320004574264' and  ISIN ='IN0020150085'  
 UNION ALL  
 SELECT *  FROM BSE_DA  ----where CLIENTID='1203320004574264' and  ISIN = 'IN0020150085'  
   )X   
 GROUP BY PARTY_CODE,ISIN,CLIENTID   
 ORDER BY QTY DESC  

 ---


 ALTER TABLE #CLIENTWISE
 ALTER COLUMN QTY FLOAT
 
 DELETE FROM BSEDB..CLIENT_HOLDING WHERE DP_DATE IN
(SELECT DISTINCT DP_DATE FROM BSEDB..CLIENT_HOLDING WHERE CONVERT(varchar(10),DP_DATE, 120)  <= @deletedate  )

  DELETE FROM BSEDB..CLIENT_HOLDING WHERE DP_DATE = @filterdate  

 SELECT * INTO #TF FROM BSEDB..CLIENT_HOLDING (NOLOCK) WHERE
  DP_DATE = ( SELECT MAX(DP_DATE) FROM BSEDB..CLIENT_HOLDING (NOLOCK) WHERE DP_DATE < @filterdate )
	 AND CLIENTID IN ('1203320030135814','1203320030135829','1203320020369832','1203320186015090','20306643')

 UPDATE #TF SET DP_DATE = @filterdate

 INSERT INTO #CLIENTWISE
 SELECT PARTY_CODE,ISIN,CLIENTID,QTY FROM #TF

 DROP TABLE #TF


 ---- DELETE FROM BSEDB..CLIENT_HOLDING WHERE DP_DATE = @filterdate

	DELETE FROM #CLIENTWISE
     WHERE QTY <= 0

	  UPDATE #CLIENTWISE SET PARTY_CODE = REPLACE(PARTY_CODE,' ','') WHERE PARTY_CODE LIKE '% %'

	  UPDATE #CLIENTWISE SET ISIN = REPLACE(ISIN,' ','') WHERE ISIN LIKE '% %'
	 
	INSERT INTO BSEDB..CLIENT_HOLDING 
	SELECT  UPPER(LTRIM(RTRIM(PARTY_CODE))) AS PARTY_CODE,EXCHANGE = '',ISIN,CLIENTID,SUM(QTY),@filterdate,0,0,0 AS DP_DATE ---INTO CLIENT_HOLDING 
	FROM #CLIENTWISE
	GROUP BY PARTY_CODE,ISIN,CLIENTID


	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = 'ERROR' WHERE PARTY_CODE IN ('05ABLB','05ACDLR','05ASLR')

	DELETE FROM BSEDB..CLIENT_HOLDING WHERE CLIENTID = ''

	---

	/*

	UPDATE BSEDB..CLIENT_HOLDING SET PARTY_CODE = REPLACE(PARTY_CODE,' ','') WHERE DP_DATE = @filterdate AND PARTY_CODE LIKE '% %'

	 UPDATE BSEDB..CLIENT_HOLDING SET ISIN = REPLACE(ISIN,' ','') WHERE DP_DATE = @filterdate AND ISIN LIKE '% %'

 -- BEGIN TRAN 
	UPDATE T SET PARTY_CODE = PARENTCODE FROM BSEDB..CLIENT2 C , BSEDB..CLIENT_HOLDING T 
 		 	WHERE T.PARTY_CODE = C.CL_CODE AND T.PARTY_CODE LIKE '98%'
	--	COMMIT

 
SELECT UPPER(LTRIM(RTRIM(PARTY_CODE))) AS PARTY_CODE,EXCHANGE,ISIN,CLIENTID,SUM(QTY) AS QTY,DP_DATE,SUM(PLD_QTY) AS PLD_QTY,
SUM(EXCH_PLD) AS EXCH_PLD,SUM(PLD_ADD) AS PLD_ADD 
INTO #CLIENT_HOLDING_NEW FROM BSEDB..CLIENT_HOLDING 
WHERE DP_DATE = @filterdate
GROUP BY PARTY_CODE,EXCHANGE,ISIN,CLIENTID,DP_DATE
ORDER BY PARTY_CODE,EXCHANGE,ISIN,CLIENTID

DELETE FROM #CLIENT_HOLDING_NEW WHERE QTY <= 0 -- 2 

DELETE FROM BSEDB..CLIENT_HOLDING WHERE DP_DATE = @filterdate -- 95038

 INSERT INTO BSEDB..CLIENT_HOLDING
 SELECT * FROM #CLIENT_HOLDING_NEW (NOLOCK) WHERE DP_DATE = @filterdate

 DROP TABLE #CLIENT_HOLDING_NEW

 */
 ---

SELECT ISIN,CLIENTID,SUM(QTY) QTY INTO #TEMP FROM #CLIENTWISE  GROUP BY ISIN,CLIENTID  
   
  
 SELECT ISNULL(D.HLD_AC_CODE,Y.CLIENTID) AS ID ,ISNULL(D.HLD_ISIN_CODE,ISIN) ISIN   
 ,ISNULL(D.DP_HOLD,0) AS_PER_DP,ISNULL(Y.QTY,0) AS_PER_BO,(ISNULL(D.DP_HOLD,0)  -ISNULL(Y.QTY,0)) AS DIFF_QTY INTO #HOLDMATCH  
 FROM #DP  D  
 FULL OUTER JOIN   
 #TEMP Y ON D.HLD_AC_CODE = CLIENTID AND D.HLD_ISIN_CODE = ISIN   

  
/**************MISMATCH DATA**************************/  
   
 SELECT  *    
   FROM (   
   
 SELECT ISNULL(D.HLD_AC_CODE,Y.CLIENTID) AS ID ,ISNULL(D.HLD_ISIN_CODE,ISIN) ISIN   
 ,ISNULL(D.DP_HOLD,0) AS_PER_DP,ISNULL(Y.QTY,0) AS_PER_BO,(ISNULL(D.DP_HOLD,0)  -ISNULL(Y.QTY,0)) AS DIFF_QTY    
 FROM #DP  D  
 FULL OUTER JOIN   
 #TEMP Y ON D.HLD_AC_CODE = CLIENTID AND D.HLD_ISIN_CODE = ISIN   
  
 ) A  
 WHERE DIFF_QTY <> 0  /*AND ID NOT IN ('1203320000072218')  */
 AND ISIN   IN (  
 SELECT ISIN  FROM #HOLDMATCH  
 GROUP BY ISIN   
 HAVING SUM(DIFF_QTY) <> 0)  
 ORDER BY ISIN   
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_PoolDPMismatchRpt_bak120123
-- --------------------------------------------------
--USP_PoolDPMismatchRpt '12/04/2019','Broker','CSO'
CREATE proc [dbo].[USP_PoolDPMismatchRpt_bak120123](@FromDate varchar(11),@access_to varchar(30),                  
@access_code varchar(30)   )  
as  
Begin  

declare @filterdate as varchar(15)--,@FromDate  varchar(11) --'2019-04-12'
--set @FromDate ='12/04/2019'
set @filterdate=  CONVERT(varchar(10), CONVERT(date, @FromDate, 103), 120)
 --replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', '-')+' 00:00:00' 
--select @FromDate
--select @filterdate

Select * into #DP_NSDLHOLD_log from  [196.1.115.132].risk.dbo.DP_NSDLHOLD_log with(nolock) where Uploadeddon=@filterdate 
Select * into #DP_CSDLHOLD_MISSING_log from  [196.1.115.132].risk.dbo.DP_CSDLHOLD_MISSING_log with(nolock) where Uploadeddon=@filterdate

TRUNCATE TABLE NSE_DA
TRUNCATE TABLE BSE_DA

 INSERT INTO  NSE_DA  
 SELECT PARTY_CODE,LONG_NAME = '',SCRIP_CD,SERIES,BDPID = '',BCLTDPID,ISIN = CERTNO,SETT_NO = '',SETT_TYPE = '',TOTAL_HOLD QTY,0,TOTAL_HOLD QTY   
    FROM INHOUSE.DBO.EXCH_HOLD_REPORTING WHERE EXCHANGE = 'NSE' AND HOLDINGDATE =@filterdate-- '2019-03-20'  
     
   
 INSERT INTO BSE_DA  
 SELECT PARTY_CODE,LONG_NAME = '',SCRIP_CD,SERIES,BDPID = '',BCLTDPID,ISIN = CERTNO,SETT_NO = '',SETT_TYPE = '',TOTAL_HOLD QTY,0,TOTAL_HOLD QTY   
    FROM INHOUSE.DBO.EXCH_HOLD_REPORTING WHERE EXCHANGE = 'BSE' AND HOLDINGDATE = @filterdate--'2019-03-20'  
  
 SELECT T.*,PARENTCODE INTO #MAPCL   FROM (SELECT DISTINCT PARTY_CODE FROM bSE_DA WHERE PARTY_CODE LIKE '98%' ) T, BSEDB.dbo.CLIENT2 C  
    WHERE T.PARTY_CODE = C.CL_CODE   
   
    UPDATE BSE_DA SET PARTY_CODE = PARENTCODE   
    FROM  #MAPCL M WHERE bSE_DA.PARTY_CODE= M.PARTY_CODe  
   
  CREATE TABLE #POOL_ACC  
 (SETT_NO  VARCHAR(125),SETT_TYPE VARCHAR(125), PARTY_CODE VARCHAR(125), LONG_NAME VARCHAR(125), SCRIPNAME VARCHAR(100), SCRIP_CD VARCHAR(125),  
  SERIES VARCHAR(125), ISIN VARCHAR(125), QTY VARCHAR(125), BDPID VARCHAR(125), BCLTDPID VARCHAR(125), CL_RATE VARCHAR(125),  
  BRANCH_CD VARCHAR(125),  SUB_BROKER VARCHAR(125), CL_TYPE VARCHAR(125),  CL_STATUS VARCHAR(125), VAR_RATE VARCHAR(125),  
  AMOUNT VARCHAR(125), VAR_RATE1 VARCHAR(125), FINALAMOUNT VARCHAR(125))  
  
  
 CREATE TABLE #POLL_NSE  
 (SETT_NO VARCHAR(125), SETT_TYPE VARCHAR(125), PARTY_CODE VARCHAR(125),LONG_NAME VARCHAR(125), SCRIPNAME VARCHAR(125),   
 SCRIP_CD VARCHAR(125), SERIES VARCHAR(125),ISIN VARCHAR(125),QTY VARCHAR(125),BDPID VARCHAR(125),BCLTDPID VARCHAR(125),CL_RATE VARCHAR(125),BRANCH_CD  
 VARCHAR(125), SUB_BROKER VARCHAR(125), CL_TYPE VARCHAR(125),CL_STATUS VARCHAR(125),AMOUNT VARCHAR(125))  
     

 DELETE FROM POOL_HOLD WHERE PD_DATE =@filterdate --'20/03/2019'  
  
 DELETE FROM FINAL_HOLD WHERE DP_DT = @filterdate --'2019-03-20'  
   
 /************/  
 INSERT INTO #POOL_ACC  
 EXEC BSEDB.DBO.RPT_DELHOLDINGASONDATE 'BROKER', 'BROKER', @filterdate,'12033200','1203320000006579','0  ','ZZZZZZZZZZ','0','ZZZZZZZZ', '1','D'   
  
 INSERT INTO #POOL_ACC  
 EXEC BSEDB.DBO.RPT_DELHOLDINGASONDATE 'BROKER', 'BROKER', @filterdate,'IN300126','10003588','0  ','ZZZZZZZZZZ','0','ZZZZZZZZZZ', '1','D'   
  
 INSERT INTO #POLL_NSE  
 EXEC MSAJAG.DBO.RPT_DELHOLDINGASONDATE 'BROKER', 'BROKER', @filterdate,'12033200','1203320006951435','0','ZZZZZZZZZZ','0','ZZZZZZZZZZ', '1','D'   
  
 INSERT INTO #POLL_NSE  
 EXEC  MSAJAG.DBO.RPT_DELHOLDINGASONDATE 'BROKER', 'BROKER', @filterdate,'IN300095','10184021','0  ','ZZZZZZZZZZ','0','ZZZZZZZZZZ', '1','D'    
  
 /****/  
  
   INSERT INTO  POOL_HOLD   
   SELECT @filterdate,SETT_NO,SETT_TYPE,PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,ISIN,QTY,BDPID,BCLTDPID ,'BSE' FROM #POOL_ACC   
   UNION ALL   
   SELECT @filterdate,SETT_NO,SETT_TYPE,PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,ISIN,QTY,BDPID,BCLTDPID,'NSE' FROM  #POLL_NSE  
   
    SELECT T.*,PARENTCODE INTO #MAPCL1  FROM (SELECT DISTINCT PARTY_CODE FROM POOL_HOLD WHERE PARTY_CODE LIKE '98%' ) T, BSEDB.DBO.CLIENT2 C with(nolock) 
 WHERE T.PARTY_CODE = C.CL_CODE   
  
   
    UPDATE POOL_HOLD SET PARTY_CODE = PARENTCODE   
 FROM  #MAPCL1 M WHERE POOL_HOLD.PARTY_CODE= M.PARTY_CODE  
   
       
 INSERT INTO  NSE_DA  
  
 SELECT PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,BDPID,BCLTDPID,ISIN,Sett_No,Sett_TyPE ,QTY,0,QTY   
 FROM POOL_HOLD WHERE EXCHANGE ='NSE' AND PD_DATE =@filterdate--'20/03/2019'  
     
   
 INSERT INTO BSE_DA  
 SELECT PARTY_CODE,LONG_NAME,SCRIP_CD,SERIES,BDPID,BCLTDPID,ISIN,Sett_No,Sett_TyPE ,QTY,0,QTY   
 FROM POOL_HOLD WHERE EXCHANGE ='BSE' AND PD_DATE =@filterdate--'20/03/2019'  
  
      
 SELECT HLD_AC_CODE,HLD_ISIN_CODE,SUM(DP_HOLD) DP_HOLD,HLD_HOLD_DATE INTO #DP  FROM (   
 SELECT HLD_AC_CODE=DP_ID,HLD_ISIN_CODE = REPLACE(ISIN,'Á',''),SUM(QYANTITY) DP_HOLD,HLD_HOLD_DATE = @filterdate
  FROM #DP_NSDLHOLD_log GROUP BY DP_ID,ISIN  
 UNION ALL  
 SELECT DP_ID,REPLACE(ISIN,'Á','') ,SUM(QYANTITY),HLD_HOLD_DATE = @filterdate FROM #DP_CSDLHOLD_MISSING_log
 GROUP BY DP_ID,ISIN )A  
 GROUP BY HLD_AC_CODE,HLD_ISIN_CODE,HLD_HOLD_DATE  
   
   --- DELETE FINAL_HOLD WHERE  DP_DT = (SELECT MAX(HLD_HOLD_DATE) FROM #DP)  
  
   INSERT INTO FINAL_HOLD   
   SELECT * FROM #DP  
     
    SELECT  PARTY_CODE,ISIN,CLIENTID,SUM(TOTAL_HLD) QTY INTO  #CLIENTWISE  
   FROM (  
 SELECT *  FROM NSE_DA ---where CLIENTID='1203320004574264' and  ISIN ='IN0020150085'  
 UNION ALL  
 SELECT *  FROM BSE_DA  ----where CLIENTID='1203320004574264' and  ISIN ='IN0020150085'  
  
 )X   
 GROUP BY PARTY_CODE,ISIN,CLIENTID   
 ORDER BY QTY DESC  
  
 SELECT ISIN,CLIENTID,SUM(QTY) QTY INTO #TEMP FROM #CLIENTWISE  GROUP BY ISIN,CLIENTID  
   
  
 SELECT ISNULL(D.HLD_AC_CODE,Y.CLIENTID) AS ID ,ISNULL(D.HLD_ISIN_CODE,ISIN) ISIN   
 ,ISNULL(D.DP_HOLD,0) AS_PER_DP,ISNULL(Y.QTY,0) AS_PER_BO,(ISNULL(D.DP_HOLD,0)  -ISNULL(Y.QTY,0)) AS DIFF_QTY INTO #HOLDMATCH  
 FROM #DP  D  
 FULL OUTER JOIN   
 #TEMP Y ON D.HLD_AC_CODE = CLIENTID AND D.HLD_ISIN_CODE = ISIN   
  
/**************MISMATCH DATA**************************/  
   
 SELECT  *    
   FROM (   
   
 SELECT ISNULL(D.HLD_AC_CODE,Y.CLIENTID) AS ID ,ISNULL(D.HLD_ISIN_CODE,ISIN) ISIN   
 ,ISNULL(D.DP_HOLD,0) AS_PER_DP,ISNULL(Y.QTY,0) AS_PER_BO,(ISNULL(D.DP_HOLD,0)  -ISNULL(Y.QTY,0)) AS DIFF_QTY    
 FROM #DP  D  
 FULL OUTER JOIN   
 #TEMP Y ON D.HLD_AC_CODE = CLIENTID AND D.HLD_ISIN_CODE = ISIN   
  
 ) A  
 WHERE DIFF_QTY <> 0  /*AND ID NOT IN ('1203320000072218')  */
 AND ISIN   IN (  
 SELECT ISIN  FROM #HOLDMATCH  
 GROUP BY ISIN   
 HAVING SUM(DIFF_QTY) <> 0)  
 ORDER BY ISIN   
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REPORTING_HOLDING_DATA
-- --------------------------------------------------

--// CREATED BY HRISHI ON .232 USE INHOUSE FOR HOLDING REPORT AUTOMATION ORE-3310
--ALTERED THIS SP by AKSHAY UNDER SRE-39840
CREATE PROC [dbo].[USP_REPORTING_HOLDING_DATA]
AS

DECLARE @DATE VARCHAR(20)
SET @DATE =FORMAT(GETDATE()-1, 'MMM dd yyyy')
--@DATE VARCHAR(20)='MAY 28 2024'


IF OBJECT_ID(N'DUSTBIN..TBL_HOLDING_DATA') IS NOT NULL                      
DROP TABLE DUSTBIN.DBO.TBL_HOLDING_DATA

  SELECT DPAM_SBA_NO,DPHMC_ISIN,CONVERT(VARCHAR,[DPHMC_CURR_QTY]) AS DP_HLD INTO DUSTBIN.DBO.TBL_HOLDING_DATA   from [AGMUBODPL3].DMAT.[CITRUS_USR].DP_HLDG_MSTR_CDSL with(nolock),[AGMUBODPL3].DMAT.[CITRUS_USR].DP_ACCT_MSTR with(nolock) where DPHMC_DPAM_ID=DPAM_ID
  AND 
  EXISTS (SELECT CLIENT_CODE FROM [AGMUBODPL3].DMAT.[CITRUS_USR].CLIENT_CODE_DND WHERE DPAM_SBA_NO=CLIENT_CODE) AND DPHMC_HOLDING_DT=@DATE
  order by DPAM_SBA_NO,DPHMC_ISIN

--SELECT * FROM DUSTBIN.DBO.TBL_HOLDING_DATA

DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(11),@DATE,3),' ','')
DECLARE @FILENAME VARCHAR(100) = 'D:\Backoffice\SWAPNIL_HOLDING_AUTO\' +'HOLDING_DATA_' + @RPT_DATE + '.CSV'
DECLARE @ALL VARCHAR(MAX)

SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''DPAM_SBA_NO'''',''''DPHMCD_ISIN'''',''''DP_HLD'''''

SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_HOLDING_DATA'
PRINT @ALL
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
PRINT @ALL
EXEC(@ALL)

DROP TABLE DUSTBIN.DBO.TBL_HOLDING_DATA

--DROP TABLE #TMPHLDG

SELECT 'FILE HAS BEEN CREATED FOR '+@DATE+' IN "\\10.253.33.232\D:\Backoffice\SWAPNIL_HOLDING_AUTO\" PATH'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REPORTING_HOLDING_DATA_BKP_01SEP2025_SRE-39840
-- --------------------------------------------------

--// CREATED BY HRISHI ON .232 USE INHOUSE FOR HOLDING REPORT AUTOMATION ORE-3310

CREATE PROC [dbo].[USP_REPORTING_HOLDING_DATA_BKP_01SEP2025_SRE-39840]
AS

DECLARE @DATE VARCHAR(20)
SET @DATE =FORMAT(GETDATE()-1, 'MMM dd yyyy')
--@DATE VARCHAR(20)='MAY 28 2024'

CREATE TABLE #TMPHLDG
(
 [DPHMCD_DPM_ID] [NUMERIC](18, 0) NOT NULL,  
 [DPHMCD_DPAM_ID] [NUMERIC](10, 0) NOT NULL,  
 [DPHMCD_ISIN] [VARCHAR](20) NOT NULL,  
 [DPHMCD_CURR_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_FREE_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_FREEZE_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_PLEDGE_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_DEMAT_PND_VER_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_REMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_DEMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_SAFE_KEEPING_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_LOCKIN_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_ELIMINATION_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_EARMARK_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_AVAIL_LEND_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_LEND_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_BORROW_QTY] [NUMERIC](18, 3) NULL,  
 [DPHMCD_HOLDING_DT] DATETIME
)

CREATE INDEX IX_ID_TEMP
ON #TMPHLDG (DPHMCD_DPM_ID,DPHMCD_DPAM_ID); 

INSERT INTO #TMPHLDG  
EXEC [AGMUBODPL3].DMAT.[CITRUS_USR].[PR_GET_HOLDING_FIX_LATEST_REPORT] 3,@DATE,@DATE,'0','9999999999999999',''

IF OBJECT_ID(N'DUSTBIN..TBL_HOLDING_DATA') IS NOT NULL                      
DROP TABLE DUSTBIN.DBO.TBL_HOLDING_DATA

SELECT DISTINCT DPAM_SBA_NO AS DPAM_SBA_NO, [DPHMCD_ISIN], CONVERT(VARCHAR,T.[DPHMCD_CURR_QTY]) AS DP_HLD INTO DUSTBIN.DBO.TBL_HOLDING_DATA
FROM #TMPHLDG T,[AGMUBODPL3].DMAT.[CITRUS_USR].DP_ACCT_MSTR D  
WHERE DPHMCD_DPAM_ID=DPAM_ID   
ORDER BY DPAM_SBA_NO,[DPHMCD_ISIN]

--SELECT * FROM DUSTBIN.DBO.TBL_HOLDING_DATA

DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(11),@DATE,3),' ','')
DECLARE @FILENAME VARCHAR(100) = 'D:\Backoffice\SWAPNIL_HOLDING_AUTO\' +'HOLDING_DATA_' + @RPT_DATE + '.CSV'
DECLARE @ALL VARCHAR(MAX)

SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''DPAM_SBA_NO'''',''''DPHMCD_ISIN'''',''''DP_HLD'''''

SET @ALL = @ALL+ ' UNION ALL SELECT * FROM DUSTBIN.DBO.TBL_HOLDING_DATA'
PRINT @ALL
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
PRINT @ALL
EXEC(@ALL)

--DROP TABLE #TMPHLDG

SELECT 'FILE HAS BEEN CREATED FOR '+@DATE+' IN "\\10.253.33.232\D:\Backoffice\SWAPNIL_HOLDING_AUTO\" PATH'

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
  from tbl_Pledge_Data (nolock) where BcltDpId =@accno and  P_R like @type and condition = @condition      
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
 (select * from tbl_Pledge_Data (nolock) where BcltDpId = @accno and  P_R like @type and condition=@condition)x                  
 inner join                  
 (select * from #bank)y on x.CertNo = y.isin --and x.Scrip_cd=y.scode              
 group by Scrip_cd,sname,cls              
 order by Scrip_cd              
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_tbl_DMP_Logs
-- --------------------------------------------------
 CREATE Proc USP_tbl_DMP_Logs      
@username varchar(250)     
    
As      
Begin      
      
insert into Tbl_DMP_Downlod_Logs     
values(@username,GETDATE())      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_tbl_DMP3_Logs
-- --------------------------------------------------
 CREATE Proc USP_tbl_DMP3_Logs        
@username varchar(250)       
      
As        
Begin        
        
insert into Tbl_DMP_Logs       
values(@username,GETDATE())        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateHoldingMismatch
-- --------------------------------------------------

-- Author:		Neha NAiwar
-- Create date: 01 JUL 2019
-- Description:	For Holding File Upload
-- =============================================
CREATE PROCEDURE [dbo].[USP_UpdateHoldingMismatch]
(
		@HOLDINGDATE datetime
)
AS
BEGIN

		SELECT 
			HOLDINGDATE, PARTY_CODE, SCRIP_CD, SERIES, CERTNO, BCLTDPID, FREE_HOLDING, PLEDGE_HOLD, TOTAL_HOLD, EXCHANGE, BATCHNO, BATCH_DATE, DUMMY1, DUMMY2
		INTO #MAIN 
		FROM INTRANET.RISK.DBO.EXCH_HOLD_REPORTING_NEW WITH(NOLOCK)
		WHERE HOLDINGDATE = @HOLDINGDATE



		--Add holding whose client records are not found in source table (As per BRS)
		INSERT INTO EXCH_HOLD_REPORTING
		SELECT 
			A.HOLDINGDATE, A.PARTY_CODE, A.SCRIP_CD, A.SERIES, A.CERTNO, A.BCLTDPID, A.FREE_HOLDING, A.PLEDGE_HOLD, A.TOTAL_HOLD, A.EXCHANGE, A.BATCHNO, A.BATCH_DATE, A.DUMMY1, A.DUMMY2 
		FROM #MAIN A
		WHERE A.HOLDINGDATE = @holdingdate 
		AND NOT EXISTS (SELECT 
							1 
						FROM EXCH_HOLD_REPORTING B WITH(NOLOCK)
						WHERE B.PARTY_CODE = A.PARTY_CODE AND 
							  B.CERTNO = A.CERTNO AND 
							  B.BCLTDPID = A.BCLTDPID AND 
							  B.EXCHANGE = A.EXCHANGE AND 
							  B.HOLDINGDATE = A.HOLDINGDATE)
			



		--Modify holding means Add/Less whose client records are incorrect found in source table (As per BRS)
		UPDATE B 
		SET
			B.TOTAL_HOLD = (CASE
								WHEN A.DUMMY1 = 'Add' THEN B.TOTAL_HOLD + a.TOTAL_HOLD
								WHEN A.DUMMY1 = 'Less' THEN B.TOTAL_HOLD - a.TOTAL_HOLD
							END)
		FROM #MAIN A WITH(NOLOCK) 
		INNER JOIN EXCH_HOLD_REPORTING B WITH(NOLOCK) ON  B.PARTY_CODE = A.PARTY_CODE 
														AND B.CERTNO = A.CERTNO 
														AND B.BCLTDPID = A.BCLTDPID 
														AND B.EXCHANGE = A.EXCHANGE 
														AND A.HOLDINGDATE = B.HOLDINGDATE
		WHERE A.HOLDINGDATE = @HOLDINGDATE



		--Delete ZERO holding records after Modify (As per BRS)
		--SELECT
		--	B.TOTAL_HOLD				
		--FROM #MAIN A WITH(NOLOCK) 
		--INNER JOIN EXCH_HOLD_REPORTING B WITH(NOLOCK) ON  B.PARTY_CODE = A.PARTY_CODE 
		--											  AND B.CERTNO = A.CERTNO 
		--											  AND B.BCLTDPID = A.BCLTDPID 
		--											  AND B.EXCHANGE = A.EXCHANGE 
		--											  AND A.HOLDINGDATE = B.HOLDINGDATE
		--WHERE A.HOLDINGDATE = @HOLDINGDATE 
		--AND B.TOTAL_HOLD = 0

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateHoldingMismatch_15Jan2020
-- --------------------------------------------------

-- Author:		Neha NAiwar
-- Create date: 01 JUL 2019
-- Description:	For Holding File Upload
-- =============================================
CREATE PROCEDURE [dbo].[USP_UpdateHoldingMismatch_15Jan2020](
 @holdingdate datetime
	)
AS
BEGIN


 --select a.*,b.TOTAL_HOLD as updatedQty into #aa1 from EXCH_HOLD_REPORTING a join  [196.1.115.132].risk.dbo.EXCH_HOLD_REPORTING_new b with(nolock)
 -- on a.PARTY_CODE=b.PARTY_CODE and a.CERTNO=b.CERTNO and a.BCLTDPID=b.BCLTDPID
 --             and a.EXCHANGE=b.EXCHANGE where a.holdingdate='2019-06-24 00:00:00.000'

select HOLDINGDATE,PARTY_CODE,SCRIP_CD,SERIES,CERTNO,BCLTDPID,FREE_HOLDING,PLEDGE_HOLD,TOTAL_HOLD,EXCHANGE,BATCHNO,BATCH_DATE,DUMMY1,DUMMY2
	into #main from [196.1.115.132].risk.dbo.EXCH_HOLD_REPORTING_new with(nolock)  where holdingdate='2019-06-24 00:00:00.000'

   --update  EXCH_HOLD_REPORTING  set TOTAL_HOLD=(case when b.DUMMY1='Add' then EXCH_HOLD_REPORTING.TOTAL_HOLD+b.TOTAL_HOLD
			--		 when EXCH_HOLD_REPORTING.DUMMY1='less' then EXCH_HOLD_REPORTING.TOTAL_HOLD-b.TOTAL_HOLD	else EXCH_HOLD_REPORTING.TOTAL_HOLD end)
		 --from                        
		 --(                        
		 -- select HOLDINGDATE,PARTY_CODE,SCRIP_CD,SERIES,CERTNO,BCLTDPID,FREE_HOLDING,PLEDGE_HOLD,TOTAL_HOLD,EXCHANGE,BATCHNO,BATCH_DATE,DUMMY1,DUMMY2
		 -- from [196.1.115.132].risk.dbo.EXCH_HOLD_REPORTING_new with(nolock)                   
		 --) b where   
		 --EXCH_HOLD_REPORTING.holdingdate='2019-06-24 00:00:00.000' and
		 --EXCH_HOLD_REPORTING.PARTY_CODE=b.PARTY_CODE  
		 --and EXCH_HOLD_REPORTING.CERTNO=b.CERTNO        
		 --and EXCH_HOLD_REPORTING.BCLTDPID=b.BCLTDPID         
		 --and EXCH_HOLD_REPORTING.EXCHANGE=b.EXCHANGE   
		  

		 UPDATE a                                                    
		 set TOTAL_HOLD=(case when b.DUMMY1='Add' then a.TOTAL_HOLD+b.TOTAL_HOLD
							 when b.DUMMY1='less' then a.TOTAL_HOLD-b.TOTAL_HOLD	else a.TOTAL_HOLD end)                       
		 FROM EXCH_HOLD_REPORTING a                                         
		 JOIN                                                    
		 ( select HOLDINGDATE,PARTY_CODE,SCRIP_CD,SERIES,CERTNO,BCLTDPID,FREE_HOLDING,PLEDGE_HOLD,TOTAL_HOLD,EXCHANGE,BATCHNO,BATCH_DATE,DUMMY1,DUMMY2
				  from #main ) b                                         
		 ON  a.PARTY_CODE=b.PARTY_CODE  
		 and a.CERTNO=b.CERTNO        
		 and a.BCLTDPID=b.BCLTDPID         
		 and a.EXCHANGE=b.EXCHANGE   
		 where a.holdingdate='2019-06-24 00:00:00.000' 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UploadHoldingFile
-- --------------------------------------------------

-- Author:		Neha NAiwar
-- Create date: 16 Apr2019
-- Description:	For Holding File Upload
-- =============================================
CREATE PROCEDURE [dbo].[USP_UploadHoldingFile](
 @FileName VARCHAR(50) = NULL ,        
 @Total int out,  
 @username varchar(50)
	)
AS
BEGIN

			Declare @filePath varchar(500)=''      
			--Declare @FileName varchar(500)='DRF SMS PATTERN_test.csv'          
			set @filePath ='\\INHOUSELIVEAPP2-FS.angelone.in\D$\UploadAdvChart\'+@FileName+''          
			--set @filePath ='\\196.1.115.183\D$\UploadAdvChart\CallAndTrade.csv'        
			DECLARE @sql NVARCHAR(4000) = 'BULK INSERT EXCH_HOLD_REPORTING_temp FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=2 )';          
			EXEC(@sql)          
			print (@sql)          
			print @filePath      
					
			--insert into EXCH_HOLD_REPORTING
			--select HOLDINGDATE,PARTY_CODE,SCRIP_CD,SERIES,CERTNO,BCLTDPID,FREE_HOLDING,PLEDGE_HOLD,TOTAL_HOLD,EXCHANGE,'0',getdate(),DUMMY1,'' 
			--from EXCH_HOLD_REPORTING_temp
			
			--truncate table EXCH_HOLD_REPORTING_temp

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_UserHolding_Data
-- --------------------------------------------------
--exec Usp_UserHolding_Data
CREATE Proc [dbo].[Usp_UserHolding_Data]
AS
BEGIN

	Truncate table tbl_usr_holding_for_DP
	
	insert into tbl_usr_holding_for_DP
	select tradingid,hld_isin_code,netqty,PLEDGE_QTY,Rate,FREE_QTY,FREEZE_QTY,hld_hold_date,GETDATE() from AngelDP4.dmat.citrus_usr.holding

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
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL
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
-- TABLE dbo.BAK_DELSLIP_ABL
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_DELSLIP_ABL]
(
    [SlipType] VARCHAR(10) NULL,
    [SlipNo] NUMERIC(18, 0) NULL,
    [SlFlag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_Deltrans_report_EXE_21092023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_Deltrans_report_EXE_21092023]
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
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAL_CLIENTDATA_21112023
-- --------------------------------------------------
CREATE TABLE [dbo].[BAL_CLIENTDATA_21112023]
(
    [CLTCODE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BO_OBJECT
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_OBJECT]
(
    [ObjName] VARCHAR(500) NULL,
    [ObjType] VARCHAR(10) NULL,
    [ObjDbName] VARCHAR(100) NULL,
    [ObjComdType] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branches
-- --------------------------------------------------
CREATE TABLE [dbo].[branches]
(
    [Branch_cd] VARCHAR(10) NULL,
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
    [Contact_Person] CHAR(100) NULL,
    [Com_Perc] MONEY NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [DefTrader] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[Broktable]
(
    [Table_No] INT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] NUMERIC(10, 2) NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [Table_name] CHAR(30) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_DA
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_DA]
(
    [Party_Code] VARCHAR(25) NULL,
    [Party_Name] VARCHAR(125) NULL,
    [Scrip_Cd] VARCHAR(25) NULL,
    [SCRIP_NAME] VARCHAR(25) NULL,
    [DPID] VARCHAR(25) NULL,
    [ClientId] VARCHAR(25) NULL,
    [Isin] VARCHAR(25) NULL,
    [Sett_No] VARCHAR(25) NULL,
    [Sett_TyE] VARCHAR(25) NULL,
    [FREE_QTY] INT NULL,
    [PLEDGE_QTY] INT NULL,
    [TOTAL_HLD] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bse_hold_data
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_hold_data]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSECM_shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[BSECM_shortage]
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
-- TABLE dbo.BSECM_shortage_nbfc
-- --------------------------------------------------
CREATE TABLE [dbo].[BSECM_shortage_nbfc]
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
-- TABLE dbo.BSECM_shortage_online
-- --------------------------------------------------
CREATE TABLE [dbo].[BSECM_shortage_online]
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
-- TABLE dbo.BSECM_shortage_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[BSECM_shortage_Temp]
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
-- TABLE dbo.bsedb_client4_dump
-- --------------------------------------------------
CREATE TABLE [dbo].[bsedb_client4_dump]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL,
    [date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsedb_multicltid_dump
-- --------------------------------------------------
CREATE TABLE [dbo].[bsedb_multicltid_dump]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NULL,
    [DpId] VARCHAR(16) NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NULL,
    [Def] INT NULL,
    [date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Client_Payment_reco_BSE
-- --------------------------------------------------
CREATE TABLE [dbo].[Client_Payment_reco_BSE]
(
    [vtyp] SMALLINT NOT NULL,
    [booktype] CHAR(2) NOT NULL,
    [vno] VARCHAR(12) NOT NULL,
    [vdt] DATETIME NULL,
    [tdate] VARCHAR(30) NULL,
    [ddno] VARCHAR(15) NOT NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [acname] VARCHAR(100) NOT NULL,
    [drcr] CHAR(1) NULL,
    [Dramt] MONEY NULL,
    [Cramt] MONEY NULL,
    [treldt] VARCHAR(30) NOT NULL,
    [refno] CHAR(12) NULL,
    [last_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client1
-- --------------------------------------------------
CREATE TABLE [dbo].[client1]
(
    [Cl_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Long_Name] VARCHAR(100) NULL,
    [L_Address1] VARCHAR(40) NOT NULL,
    [L_Address2] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_State] VARCHAR(50) NULL,
    [L_Nation] VARCHAR(15) NULL,
    [L_Zip] VARCHAR(10) NULL,
    [Fax] VARCHAR(15) NULL,
    [Res_Phone1] VARCHAR(15) NULL,
    [Res_Phone2] VARCHAR(15) NULL,
    [Off_Phone1] VARCHAR(15) NULL,
    [Off_Phone2] VARCHAR(15) NULL,
    [Email] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Credit_Limit] NUMERIC(13, 2) NULL,
    [Cl_type] VARCHAR(3) NOT NULL,
    [Cl_Status] VARCHAR(3) NOT NULL,
    [Gl_Code] VARCHAR(6) NULL,
    [Fd_Code] VARCHAR(25) NULL,
    [Family] VARCHAR(10) NOT NULL,
    [Penalty] NUMERIC(6, 0) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Confirm_fax] TINYINT NOT NULL,
    [PhoneOld] VARCHAR(40) NULL,
    [L_Address3] VARCHAR(40) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [trader] VARCHAR(20) NULL,
    [Ward_No] VARCHAR(50) NULL,
    [Region] VARCHAR(50) NULL,
    [Area] VARCHAR(10) NULL,
    [Clrating] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client2
-- --------------------------------------------------
CREATE TABLE [dbo].[client2]
(
    [Cl_Code] VARCHAR(10) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Tran_Cat] CHAR(3) NOT NULL,
    [Scrip_cat] NUMERIC(18, 4) NULL,
    [Party_code] VARCHAR(10) NOT NULL,
    [Table_no] INT NULL,
    [Sub_TableNo] INT NULL,
    [Margin] TINYINT NOT NULL,
    [Turnover_tax] TINYINT NOT NULL,
    [Sebi_Turn_tax] TINYINT NOT NULL,
    [Insurance_Chrg] TINYINT NOT NULL,
    [Service_chrg] TINYINT NOT NULL,
    [Std_rate] INT NULL,
    [P_To_P] INT NULL,
    [exposure_lim] NUMERIC(12, 2) NOT NULL,
    [demat_tableno] INT NULL,
    [BankId] VARCHAR(15) NULL,
    [CltDpNo] VARCHAR(15) NULL,
    [Printf] TINYINT NOT NULL,
    [ALBMDelchrg] TINYINT NULL,
    [ALBMDelivery] TINYINT NULL,
    [AlbmCF_tableno] SMALLINT NULL,
    [MF_tableno] INT NULL,
    [SB_tableno] INT NULL,
    [brok1_tableno] INT NULL,
    [brok2_tableno] INT NULL,
    [brok3_tableno] INT NULL,
    [BrokerNote] TINYINT NULL,
    [Other_chrg] TINYINT NULL,
    [brok_scheme] TINYINT NULL,
    [contcharge] TINYINT NULL,
    [mincontamt] TINYINT NULL,
    [AddLedgerBal] TINYINT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [InsCont] CHAR(1) NULL,
    [SerTaxMethod] INT NULL,
    [dummy6] VARCHAR(5) NULL,
    [dummy7] VARCHAR(4) NULL,
    [dummy8] VARCHAR(20) NULL,
    [dummy9] VARCHAR(20) NULL,
    [dummy10] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client3
-- --------------------------------------------------
CREATE TABLE [dbo].[client3]
(
    [cl_code] VARCHAR(10) NULL,
    [party_code] CHAR(10) NOT NULL,
    [exchange] CHAR(3) NOT NULL,
    [markettype] VARCHAR(15) NOT NULL,
    [margin] MONEY NOT NULL,
    [nooftimes] NUMERIC(2, 0) NOT NULL,
    [margin_recd] NUMERIC(18, 4) NULL,
    [MtoM] NUMERIC(18, 4) NULL,
    [pmarginrate] NUMERIC(5, 2) NULL,
    [MtoMdate] DATETIME NULL,
    [InitialMargin] NUMERIC(18, 4) NULL,
    [MainenancetMargin] NUMERIC(18, 4) NULL,
    [MarginExchange] NUMERIC(18, 4) NULL,
    [MarginBroker] NUMERIC(18, 4) NULL,
    [Dummy1] VARCHAR(4) NULL,
    [Dummy2] VARCHAR(4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client4
-- --------------------------------------------------
CREATE TABLE [dbo].[client4]
(
    [Cl_code] VARCHAR(10) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Depository] VARCHAR(7) NULL,
    [DefDp] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client5
-- --------------------------------------------------
CREATE TABLE [dbo].[client5]
(
    [cl_code] VARCHAR(10) NULL,
    [BirthDate] DATETIME NULL,
    [Sex] CHAR(1) NULL,
    [ActiveFrom] DATETIME NULL,
    [InteractMode] TINYINT NULL,
    [RepatriatAC] TINYINT NULL,
    [RepatriatBank] TINYINT NULL,
    [RepatriatACNO] VARCHAR(30) NULL,
    [Introducer] VARCHAR(30) NULL,
    [Approver] VARCHAR(30) NULL,
    [KYCForm] TINYINT NULL,
    [BankCert] TINYINT NULL,
    [Passport] TINYINT NULL,
    [Passportdtl] VARCHAR(30) NULL,
    [VotersID] TINYINT NULL,
    [VotersIDdtl] VARCHAR(30) NULL,
    [ITReturn] TINYINT NULL,
    [ITReturndtl] VARCHAR(30) NULL,
    [Drivelicen] TINYINT NULL,
    [Drivelicendtl] VARCHAR(30) NULL,
    [Rationcard] TINYINT NULL,
    [Rationcarddtl] VARCHAR(30) NULL,
    [Corpdtlrecd] TINYINT NULL,
    [Corpdeed] TINYINT NULL,
    [Anualreport] TINYINT NULL,
    [Networthcert] TINYINT NULL,
    [InactiveFrom] DATETIME NULL,
    [P_Address1] VARCHAR(50) NULL,
    [P_Address2] VARCHAR(50) NULL,
    [P_Address3] VARCHAR(50) NULL,
    [P_City] VARCHAR(20) NULL,
    [P_State] VARCHAR(50) NULL,
    [P_Nation] VARCHAR(15) NULL,
    [P_Phone] VARCHAR(15) NULL,
    [P_Zip] VARCHAR(10) NULL,
    [addemailid] VARCHAR(230) NULL,
    [PassportDateOfIssue] DATETIME NULL,
    [PassportPlaceOfIssue] VARCHAR(30) NULL,
    [VoterIdDateOfIssue] DATETIME NULL,
    [VoterIdPlaceOfIssue] VARCHAR(30) NULL,
    [ITReturnDateOfFiling] DATETIME NULL,
    [LicenceNoDateOfIssue] DATETIME NULL,
    [LicenceNoPlaceOfIssue] VARCHAR(30) NULL,
    [RationCardDateOfIssue] DATETIME NULL,
    [RationCardPlaceOfIssue] VARCHAR(30) NULL,
    [Client_Agre_Dt] DATETIME NULL,
    [Regr_No] VARCHAR(50) NULL,
    [Regr_Place] VARCHAR(50) NULL,
    [Regr_Date] DATETIME NULL,
    [Regr_Auth] VARCHAR(50) NULL,
    [Introd_Client_Id] VARCHAR(50) NULL,
    [Introd_Relation] VARCHAR(50) NULL,
    [Any_Other_Acc] VARCHAR(50) NULL,
    [Sett_Mode] VARCHAR(50) NULL,
    [Dealing_With_Othrer_Tm] VARCHAR(50) NULL,
    [Systumdate] DATETIME NULL,
    [Passportexpdate] DATETIME NULL,
    [Driveexpdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client6
-- --------------------------------------------------
CREATE TABLE [dbo].[client6]
(
    [Cl_Code] VARCHAR(10) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Tran_Cat] CHAR(3) NOT NULL,
    [Scrip_cat] NUMERIC(18, 4) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Table_no] SMALLINT NOT NULL,
    [Sub_TableNo] SMALLINT NOT NULL,
    [Margin] TINYINT NOT NULL,
    [Turnover_tax] TINYINT NOT NULL,
    [Sebi_Turn_tax] TINYINT NOT NULL,
    [Insurance_Chrg] TINYINT NOT NULL,
    [Service_chrg] TINYINT NOT NULL,
    [Std_rate] SMALLINT NOT NULL,
    [P_To_P] SMALLINT NOT NULL,
    [exposure_lim] NUMERIC(12, 2) NOT NULL,
    [demat_tableno] SMALLINT NOT NULL,
    [BankId] VARCHAR(15) NULL,
    [CltDpNo] VARCHAR(15) NULL,
    [Printf] TINYINT NOT NULL,
    [ALBMDelchrg] TINYINT NULL,
    [ALBMDelivery] TINYINT NULL,
    [AlbmCF_tableno] SMALLINT NULL,
    [MF_tableno] SMALLINT NULL,
    [SB_tableno] SMALLINT NULL,
    [brok1_tableno] SMALLINT NULL,
    [brok2_tableno] SMALLINT NULL,
    [brok3_tableno] SMALLINT NULL,
    [BrokerNote] TINYINT NULL,
    [Other_chrg] TINYINT NULL,
    [brok_scheme] TINYINT NULL,
    [Contcharge] TINYINT NULL,
    [MinContAmt] TINYINT NULL,
    [AddLedgerBal] TINYINT NULL,
    [Dummy1] TINYINT NULL,
    [Dummy2] TINYINT NULL,
    [InsCont] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENTDPDATAOUTSIDE_10072023
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENTDPDATAOUTSIDE_10072023]
(
    [BCLTDPID] VARCHAR(16) NULL,
    [CLTDPID] VARCHAR(20) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [CERTNO] VARCHAR(16) NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(38, 0) NULL,
    [CLOSING] NUMERIC(18, 2) NULL,
    [TOTAL] NUMERIC(18, 2) NULL,
    [NETBALANCE_WITHOUTMTF] NUMERIC(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cmbillvalan
-- --------------------------------------------------
CREATE TABLE [dbo].[cmbillvalan]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Family] VARCHAR(10) NULL,
    [Family_Name] VARCHAR(100) NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [ClientType] VARCHAR(10) NULL,
    [TradeType] VARCHAR(3) NULL,
    [Trader] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Pamt] MONEY NOT NULL,
    [Samt] MONEY NOT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [TrdAmt] MONEY NULL,
    [DelAmt] MONEY NULL,
    [SerInEx] SMALLINT NULL,
    [Service_Tax] MONEY NULL,
    [ExService_Tax] MONEY NULL,
    [Turn_Tax] MONEY NULL,
    [Sebi_Tax] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Broker_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [Region] VARCHAR(50) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [Update_Date] VARCHAR(11) NULL,
    [Status_Name] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(3) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL,
    [Dummy3] VARCHAR(1) NULL,
    [Dummy4] MONEY NULL,
    [Dummy5] MONEY NULL,
    [Area] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast]
(
    [COSTNAME] CHAR(35) NOT NULL,
    [COSTCODE] SMALLINT NOT NULL,
    [CATCODE] SMALLINT NULL,
    [grpcode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CUSA_HOLDING
-- --------------------------------------------------
CREATE TABLE [dbo].[CUSA_HOLDING]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [SETT_NO] VARCHAR(15) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(15) NULL,
    [SERIES] VARCHAR(10) NULL,
    [QTY] NUMERIC(18, 9) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [PROCESS_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.dd.1
-- --------------------------------------------------
CREATE TABLE [dbo].[dd.1]
(
    [fr_name] VARCHAR(50) NULL,
    [mob_no] INT NULL,
    [addr] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELTRANS_2024021
-- --------------------------------------------------
CREATE TABLE [dbo].[DELTRANS_2024021]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
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
    [ISett_No] VARCHAR(16) NULL,
    [ISett_Type] VARCHAR(16) NULL,
    [ShareType] VARCHAR(8) NULL,
    [TransDate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [BDpType] VARCHAR(10) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.deltrans_error_30012024
-- --------------------------------------------------
CREATE TABLE [dbo].[deltrans_error_30012024]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
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
    [ISett_No] VARCHAR(16) NULL,
    [ISett_Type] VARCHAR(16) NULL,
    [ShareType] VARCHAR(8) NULL,
    [TransDate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [BDpType] VARCHAR(10) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltrans_isett_2024021
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltrans_isett_2024021]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
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
    [ISett_No] VARCHAR(16) NULL,
    [ISett_Type] VARCHAR(16) NULL,
    [ShareType] VARCHAR(8) NULL,
    [TransDate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [BDpType] VARCHAR(10) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_02072024
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_02072024]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_02082024
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_02082024]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_04102023
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_04102023]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_05052025
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_05052025]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_18082023
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_18082023]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_21082024
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_21082024]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_21122024
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_21122024]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_28092023
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_28092023]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_29082024
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_29082024]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_29sep2023
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_29sep2023]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_30nov2024
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_30nov2024]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_30nov20241
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_30nov20241]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_dummy
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_dummy]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_Hist]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL,
    [Update_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_Holding_Balance_test
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_Holding_Balance_test]
(
    [Party_Code] VARCHAR(15) NULL,
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Free_Balance] NUMERIC(16, 3) NULL,
    [Lock_Balance] NUMERIC(16, 3) NULL,
    [Pledge_Balance] NUMERIC(16, 3) NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [Safe_Balance] NUMERIC(16, 3) NULL,
    [Pending_Remat_balance] NUMERIC(16, 3) NULL,
    [Available_Lend_Balance] NUMERIC(16, 3) NULL,
    [Remat_Lockin_Balance] NUMERIC(16, 3) NULL,
    [Current_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Veri_Balance] NUMERIC(16, 3) NULL,
    [Demat_Pending_Conf_Balance] NUMERIC(16, 3) NULL,
    [Lending_Balance] NUMERIC(16, 3) NULL,
    [Borrowed_Balance] NUMERIC(16, 3) NULL,
    [ISIN_Freeze] NUMERIC(1, 0) NULL,
    [BOID_Freeze] NUMERIC(1, 0) NULL,
    [BOISIN] NUMERIC(1, 0) NULL,
    [Settlement_ID] VARCHAR(13) NULL,
    [Dummy1] NUMERIC(16, 3) NULL,
    [File_Date] DATETIME NULL,
    [Process_Date] DATETIME NULL,
    [File_Number] INT NULL,
    [FileName] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.dpholdingfile_stg
-- --------------------------------------------------
CREATE TABLE [dbo].[dpholdingfile_stg]
(
    [Src] VARCHAR(MAX) NULL,
    [CntrlSctiesDpstryPtcpt] VARCHAR(MAX) NULL,
    [BrnchId] VARCHAR(MAX) NULL,
    [LineNb] VARCHAR(MAX) NULL,
    [BnfclTyp] VARCHAR(MAX) NULL,
    [BnfclOwnrId] VARCHAR(MAX) NULL,
    [ISIN] VARCHAR(MAX) NULL,
    [MktTpAndId] VARCHAR(MAX) NULL,
    [SctiesSttlmTxId] VARCHAR(MAX) NULL,
    [RcrdTp] VARCHAR(MAX) NULL,
    [CurBal] VARCHAR(MAX) NULL,
    [BnfcryAcctPos] VARCHAR(MAX) NULL,
    [DmtrlstnPdgVrfctnBal] VARCHAR(MAX) NULL,
    [DmtrlstnPdgConfBal] VARCHAR(MAX) NULL,
    [LndBal] VARCHAR(MAX) NULL,
    [BrrwdBal] VARCHAR(MAX) NULL,
    [LckdInBalUdrRmtrlstn] VARCHAR(MAX) NULL,
    [ISINFrzForDbtOrCdtBoth] VARCHAR(MAX) NULL,
    [BOIdFrzForDbtOrCdtBoth] VARCHAR(MAX) NULL,
    [BOISINFrzForDbtOrCdtBoth] VARCHAR(MAX) NULL,
    [RpldgBal] VARCHAR(MAX) NULL,
    [ClrSysId] VARCHAR(MAX) NULL,
    [BlckOrLckFlg] VARCHAR(MAX) NULL,
    [BlckOrLckCd] VARCHAR(MAX) NULL,
    [LckdInBal] VARCHAR(MAX) NULL,
    [LckInRlsDt] VARCHAR(MAX) NULL,
    [PldgdBal] VARCHAR(MAX) NULL,
    [EarmrkdBal] VARCHAR(MAX) NULL,
    [SkfpBal] VARCHAR(MAX) NULL,
    [RmtrlstnPdgBal] VARCHAR(MAX) NULL,
    [AvlblForLndBal] VARCHAR(MAX) NULL,
    [CmDlry] VARCHAR(MAX) NULL,
    [CmRcpt] VARCHAR(MAX) NULL,
    [BeneficiaryHldTrnNHse] VARCHAR(MAX) NULL,
    [BeneficiaryHldNHse] VARCHAR(MAX) NULL,
    [CmPool] VARCHAR(MAX) NULL,
    [CmTrns] VARCHAR(MAX) NULL,
    [TrnsNHse] VARCHAR(MAX) NULL,
    [StmtDt] VARCHAR(MAX) NULL,
    [Rmks] VARCHAR(MAX) NULL,
    [Rsvd1] VARCHAR(MAX) NULL,
    [Rsvd2] VARCHAR(MAX) NULL,
    [Rsvd3] VARCHAR(MAX) NULL,
    [Rsvd4] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DPM3_TMP
-- --------------------------------------------------
CREATE TABLE [dbo].[DPM3_TMP]
(
    [Filedata] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.E_Dis_Trxn_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[E_Dis_Trxn_Data]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [Refno] BIGINT NULL,
    [Partycode] VARCHAR(15) NULL,
    [BOID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Qty] MONEY NULL,
    [NO_of_days] INT NULL,
    [status] VARCHAR(10) NULL,
    [FLAG] VARCHAR(10) NULL,
    [updatedatetime] DATETIME NULL,
    [Request_date] DATETIME NULL,
    [Request_Id] VARCHAR(50) NULL,
    [ANGEL_TRXN_ID] VARCHAR(50) NULL,
    [CDSL_TRXN_Id] VARCHAR(50) NULL,
    [CDSL_Response_Id] VARCHAR(50) NULL,
    [Ex_qty] VARCHAR(50) NULL,
    [valid] VARCHAR(50) NULL,
    [Pend_qty] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [dummy2] VARCHAR(50) NULL,
    [dummy3] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.e_dis_trxn_data_New_stg
-- --------------------------------------------------
CREATE TABLE [dbo].[e_dis_trxn_data_New_stg]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [Refno] BIGINT NULL,
    [Partycode] VARCHAR(15) NULL,
    [BOID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Qty] MONEY NULL,
    [NO_of_days] INT NULL,
    [status] VARCHAR(10) NULL,
    [FLAG] VARCHAR(10) NULL,
    [updatedatetime] DATETIME NULL,
    [Request_date] DATETIME NULL,
    [Request_Id] VARCHAR(50) NULL,
    [ANGEL_TRXN_ID] VARCHAR(50) NULL,
    [CDSL_TRXN_Id] VARCHAR(50) NULL,
    [CDSL_Response_Id] VARCHAR(50) NULL,
    [Ex_qty] VARCHAR(50) NULL,
    [valid] VARCHAR(50) NULL,
    [Pend_qty] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [dummy2] VARCHAR(50) NULL,
    [dummy3] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Excess_payin
-- --------------------------------------------------
CREATE TABLE [dbo].[Excess_payin]
(
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [FREE_BALANCE] NUMERIC(16, 3) NULL,
    [FILE_DATE] DATETIME NULL,
    [Earmark_Balance] NUMERIC(16, 3) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [CLTDPNO] VARCHAR(16) NULL,
    [I_ISIN] VARCHAR(12) NULL,
    [Qty] INT NULL,
    [sett_no] VARCHAR(7) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Exch_hold_reporting
-- --------------------------------------------------
CREATE TABLE [dbo].[Exch_hold_reporting]
(
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [BATCHNO] VARCHAR(15) NULL,
    [BATCH_DATE] DATETIME NULL,
    [DUMMY1] VARCHAR(15) NULL,
    [DUMMY2] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Exch_hold_reporting_archival
-- --------------------------------------------------
CREATE TABLE [dbo].[Exch_hold_reporting_archival]
(
    [ArchivalID] INT IDENTITY(1,1) NOT NULL,
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [BATCHNO] VARCHAR(15) NULL,
    [BATCH_DATE] DATETIME NULL,
    [DUMMY1] VARCHAR(15) NULL,
    [DUMMY2] VARCHAR(15) NULL,
    [Archival_Date] DATETIME NULL,
    [Archival_By] VARCHAR(15) NULL,
    [Archival_Comment] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Exch_hold_reporting_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[Exch_hold_reporting_Hist]
(
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [BATCHNO] VARCHAR(15) NULL,
    [BATCH_DATE] DATETIME NULL,
    [DUMMY1] VARCHAR(15) NULL,
    [DUMMY2] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXCH_HOLD_REPORTING_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[EXCH_HOLD_REPORTING_temp]
(
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [DUMMY1] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXCH_HOLD_REPORTING_TEST
-- --------------------------------------------------
CREATE TABLE [dbo].[EXCH_HOLD_REPORTING_TEST]
(
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [BATCHNO] VARCHAR(15) NULL,
    [BATCH_DATE] DATETIME NULL,
    [DUMMY1] VARCHAR(15) NULL,
    [DUMMY2] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXCH_HOLD_REPORTING_TEST_insert
-- --------------------------------------------------
CREATE TABLE [dbo].[EXCH_HOLD_REPORTING_TEST_insert]
(
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [BATCHNO] VARCHAR(15) NULL,
    [BATCH_DATE] DATETIME NULL,
    [DUMMY1] VARCHAR(15) NULL,
    [DUMMY2] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINAL_HOLD
-- --------------------------------------------------
CREATE TABLE [dbo].[FINAL_HOLD]
(
    [HLD_AC_CODE] VARCHAR(125) NULL,
    [HLD_ISIN_CODE] VARCHAR(125) NULL,
    [DP_HOLD] FLOAT NULL,
    [DP_DT] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.globals
-- --------------------------------------------------
CREATE TABLE [dbo].[globals]
(
    [year] VARCHAR(4) NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] NUMERIC(10, 4) NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] INT NULL,
    [sebi_turn_ac] INT NULL,
    [broker_note_ac] INT NULL,
    [other_chrg_ac] INT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NULL,
    [year_end_dt] DATETIME NULL,
    [CESS_Tax] NUMERIC(10, 4) NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NULL,
    [DelBuyTrans] NUMERIC(18, 4) NULL,
    [DelSellTrans] NUMERIC(18, 4) NULL,
    [EDUCESSTAX] NUMERIC(18, 4) NULL,
    [STT_TAX_AC] INT NULL,
    [TOTTAXES_LESS] NUMERIC(18, 6) NULL,
    [TOTTAXES_HIGH] NUMERIC(18, 6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GoldETF
-- --------------------------------------------------
CREATE TABLE [dbo].[GoldETF]
(
    [Symbol] VARCHAR(10) NULL DEFAULT NULL,
    [Series] VARCHAR(2) NULL DEFAULT NULL,
    [Name] VARCHAR(25) NULL DEFAULT NULL,
    [ISIN] VARCHAR(12) NULL DEFAULT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HOLD_DATA_INSERT
-- --------------------------------------------------
CREATE TABLE [dbo].[HOLD_DATA_INSERT]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hold_duplicate
-- --------------------------------------------------
CREATE TABLE [dbo].[hold_duplicate]
(
    [HOLDINGDATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [CERTNO] VARCHAR(15) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [FREE_HOLDING] FLOAT NULL,
    [PLEDGE_HOLD] FLOAT NULL,
    [TOTAL_HOLD] FLOAT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [BATCHNO] VARCHAR(15) NULL,
    [BATCH_DATE] DATETIME NULL,
    [DUMMY1] VARCHAR(15) NULL,
    [DUMMY2] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.holding_compare
-- --------------------------------------------------
CREATE TABLE [dbo].[holding_compare]
(
    [TD_AC_CODE] VARCHAR(16) NULL,
    [TD_ISIN_code] VARCHAR(20) NULL,
    [TD_QTY] NUMERIC(20, 5) NULL,
    [TD_DESCRIPTION] VARCHAR(100) NULL,
    [cusa_hold] INT NULL,
    [mtf_hold] INT NULL,
    [pledge_qty] INT NULL,
    [free_qty] INT NULL,
    [CUSA_29] INT NULL,
    [MARGIN_PLD] INT NULL,
    [MTF_PLD] INT NULL,
    [Cl_code] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.INSERT_HOLD_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[INSERT_HOLD_DATA]
(
    [holdingdate] VARCHAR(23) NOT NULL,
    [PARTY_cODE] VARCHAR(50) NULL,
    [SCRIP_CD] VARCHAR(50) NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [CERTNO] VARCHAR(50) NULL,
    [BCLTDPID] VARCHAR(50) NULL,
    [FREE_HOLDING] VARCHAR(50) NULL,
    [PLEDGE_HOLD] VARCHAR(50) NULL,
    [TOTAL_HOLD] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(3) NOT NULL,
    [BATCHNO] INT NOT NULL,
    [BATCH_DATE] VARCHAR(23) NOT NULL,
    [DUMMY1] VARCHAR(1) NOT NULL,
    [DUMMY2] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.INVOCATION_STG_AWS
-- --------------------------------------------------
CREATE TABLE [dbo].[INVOCATION_STG_AWS]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [ISIN] VARCHAR(25) NULL,
    [QTY] NUMERIC(18, 4) NULL,
    [PSNNO] VARCHAR(50) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [TRANSDATE] DATETIME NULL,
    [ISETT_NO] VARCHAR(15) NULL,
    [ISEETT_TYPE] VARCHAR(15) NULL,
    [PROCESSDATE] DATETIME NULL,
    [VALID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_Raw
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_Raw]
(
    [trans_date] DATETIME NULL,
    [party_code] VARCHAR(20) NULL,
    [bse_code] INT NULL,
    [nse_symbol] VARCHAR(200) NULL,
    [co_code] INT NULL,
    [isin] VARCHAR(20) NULL,
    [trn_qty] NUMERIC(20, 5) NULL,
    [dr_cr] VARCHAR(1) NOT NULL,
    [Remarks] VARCHAR(8000) NULL,
    [UpdDate] DATETIME NOT NULL,
    [TD_AC_CODE] VARCHAR(16) NULL,
    [sl_angel_code] INT NULL,
    [mkt_rate] DECIMAL(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger]
(
    [vtyp] SMALLINT NOT NULL,
    [vno] VARCHAR(12) NOT NULL,
    [edt] DATETIME NULL,
    [lno] INT NOT NULL,
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
    [BookType] CHAR(2) NOT NULL,
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
    [lno] INT NULL,
    [drcr] CHAR(1) NULL,
    [BookType] CHAR(2) NULL,
    [MicrNo] INT NULL,
    [SlipNo] INT NULL,
    [slipdate] DATETIME NULL,
    [ChequeInName] VARCHAR(100) NULL,
    [Chqprinted] TINYINT NULL,
    [clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LogIops204
-- --------------------------------------------------
CREATE TABLE [dbo].[LogIops204]
(
    [database_name] VARCHAR(50) NULL,
    [physical_name] VARCHAR(120) NOT NULL,
    [drive_letter] NVARCHAR(1) NULL,
    [num_of_writes] BIGINT NOT NULL,
    [num_of_bytes_written] BIGINT NOT NULL,
    [io_stall_write_ms] BIGINT NOT NULL,
    [type_desc] VARCHAR(10) NULL,
    [num_of_reads] BIGINT NOT NULL,
    [num_of_bytes_read] BIGINT NOT NULL,
    [io_stall_read_ms] BIGINT NOT NULL,
    [io_stall] BIGINT NOT NULL,
    [size_on_disk_bytes] BIGINT NOT NULL,
    [Recordtime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.msajag_client4_dump
-- --------------------------------------------------
CREATE TABLE [dbo].[msajag_client4_dump]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL,
    [date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.msajag_multicltid_dump
-- --------------------------------------------------
CREATE TABLE [dbo].[msajag_multicltid_dump]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [CltDpNo] VARCHAR(16) NULL,
    [DpId] VARCHAR(16) NULL,
    [Introducer] VARCHAR(100) NULL,
    [DpType] VARCHAR(4) NULL,
    [Def] INT NULL,
    [date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NOn_poa_Daily_Clients
-- --------------------------------------------------
CREATE TABLE [dbo].[NOn_poa_Daily_Clients]
(
    [Party_COde] VARCHAR(10) NULL,
    [Transdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NOn_poa_Daily_Clients_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[NOn_poa_Daily_Clients_Hist]
(
    [Party_COde] VARCHAR(10) NULL,
    [Transdate] DATETIME NOT NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Non_POA_Hold
-- --------------------------------------------------
CREATE TABLE [dbo].[Non_POA_Hold]
(
    [party_code] VARCHAR(11) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [isin] VARCHAR(20) NULL,
    [pool_qty] FLOAT NULL,
    [unsett] FLOAT NULL,
    [dp_hold] FLOAT NULL,
    [Total_Hold] FLOAT NULL,
    [Dt_time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Non_POA_Hold_Hst
-- --------------------------------------------------
CREATE TABLE [dbo].[Non_POA_Hold_Hst]
(
    [party_code] VARCHAR(11) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [isin] VARCHAR(20) NULL,
    [pool_qty] FLOAT NULL,
    [unsett] FLOAT NULL,
    [dp_hold] FLOAT NULL,
    [Total_Hold] FLOAT NULL,
    [Dt_time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NON_POA_NON_TPIN
-- --------------------------------------------------
CREATE TABLE [dbo].[NON_POA_NON_TPIN]
(
    [party_Code] VARCHAR(10) NOT NULL,
    [certno] VARCHAR(16) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [qty] NUMERIC(38, 0) NULL,
    [cl_rate] MONEY NULL,
    [amount] MONEY NULL,
    [b2c] VARCHAR(1) NULL,
    [comb_LAST_DATE] DATETIME NULL,
    [trd_type] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NON_POA_SMS_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[NON_POA_SMS_DATA]
(
    [PARTY_CODE] VARCHAR(15) NULL,
    [Scrip_cd] VARCHAR(12) NULL,
    [Series] CHAR(2) NULL,
    [Sell_shortage] INT NULL,
    [DP_ID] VARCHAR(16) NULL,
    [DP_Qty] NUMERIC(18, 5) NOT NULL,
    [Payindate] DATETIME NULL,
    [PROCESS_DATE] DATETIME NOT NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [Sett_NO] VARCHAR(11) NULL,
    [sett_type] VARCHAR(2) NULL,
    [SMS_Qty] INT NULL,
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NON_POA_SMS_DATA_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[NON_POA_SMS_DATA_LOG]
(
    [PARTY_CODE] VARCHAR(15) NULL,
    [Scrip_cd] VARCHAR(12) NULL,
    [Series] CHAR(2) NULL,
    [Sell_shortage] INT NULL,
    [DP_ID] VARCHAR(16) NULL,
    [DP_Qty] NUMERIC(18, 5) NOT NULL,
    [Payindate] DATETIME NULL,
    [PROCESS_DATE] DATETIME NOT NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [Sett_NO] VARCHAR(11) NULL,
    [sett_type] VARCHAR(2) NULL,
    [SMS_Qty] INT NULL,
    [ISIN] VARCHAR(20) NULL,
    [rundate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NON_POA_SMS_PROCESS_PARA
-- --------------------------------------------------
CREATE TABLE [dbo].[NON_POA_SMS_PROCESS_PARA]
(
    [SETT_NO] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_DA
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_DA]
(
    [Party_Code] VARCHAR(25) NULL,
    [Party_Name] VARCHAR(125) NULL,
    [Scrip_Cd] VARCHAR(25) NULL,
    [SCRIP_NAME] VARCHAR(25) NULL,
    [DPID] VARCHAR(25) NULL,
    [ClientId] VARCHAR(25) NULL,
    [Isin] VARCHAR(25) NULL,
    [Sett_No] VARCHAR(25) NULL,
    [Sett_TyE] VARCHAR(25) NULL,
    [FREE_QTY] INT NULL,
    [PLEDGE_QTY] INT NULL,
    [TOTAL_HLD] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_hold_data
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_hold_data]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSECM_shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[NSECM_shortage]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSECM_shortage_nbfc
-- --------------------------------------------------
CREATE TABLE [dbo].[NSECM_shortage_nbfc]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSECM_shortage_online
-- --------------------------------------------------
CREATE TABLE [dbo].[NSECM_shortage_online]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSECM_Shortage_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[NSECM_Shortage_temp]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OffMkt_Raw
-- --------------------------------------------------
CREATE TABLE [dbo].[OffMkt_Raw]
(
    [party_code] VARCHAR(20) NULL,
    [trans_date] DATETIME NULL,
    [isin] VARCHAR(20) NULL,
    [bse_code] INT NULL,
    [nse_symbol] VARCHAR(200) NULL,
    [NSESeries] VARCHAR(10) NULL,
    [trn_qty] NUMERIC(20, 5) NULL,
    [dr_cr] VARCHAR(1) NOT NULL,
    [mkt_rate] DECIMAL(18, 4) NULL,
    [TD_DESCRIPTION] VARCHAR(100) NULL,
    [TD_AC_CODE] VARCHAR(16) NOT NULL,
    [TD_BENEFICIERY] VARCHAR(16) NOT NULL,
    [TD_COUNTERDP] VARCHAR(16) NOT NULL,
    [sl_angel_code] INT NULL,
    [UpdDate] DATETIME NOT NULL,
    [CoCode] VARCHAR(20) NULL,
    [OffMktId] VARCHAR(32) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Pain_2024209
-- --------------------------------------------------
CREATE TABLE [dbo].[Pain_2024209]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
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
    [Maker_Checker] SMALLINT NULL,
    [branchflag] TINYINT NULL,
    [voucherprintflag] TINYINT NULL,
    [reportdays] INT NULL,
    [FLDAUTO] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Payin_data_Daily
-- --------------------------------------------------
CREATE TABLE [dbo].[Payin_data_Daily]
(
    [Srno] BIGINT IDENTITY(1,1) NOT NULL,
    [Party_code] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(15) NULL,
    [Series] VARCHAR(10) NULL,
    [Qty] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3228
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3228]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3249
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3249]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3253
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3253]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3255
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3255]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3256
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3256]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3318
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3318]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3341
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3341]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pbsehold3419
-- --------------------------------------------------
CREATE TABLE [dbo].[pbsehold3419]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3228
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3228]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3249
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3249]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3253
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3253]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3255
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3255]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3256
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3256]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3318
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3318]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3341
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3341]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pnsehold3419
-- --------------------------------------------------
CREATE TABLE [dbo].[pnsehold3419]
(
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POOL_HOLD
-- --------------------------------------------------
CREATE TABLE [dbo].[POOL_HOLD]
(
    [PD_DATE] VARCHAR(125) NULL,
    [SETT_NO] VARCHAR(125) NULL,
    [SETT_TYPE] VARCHAR(125) NULL,
    [PARTY_CODE] VARCHAR(125) NULL,
    [LONG_NAME] VARCHAR(125) NULL,
    [SCRIP_CD] VARCHAR(125) NULL,
    [SERIES] VARCHAR(125) NULL,
    [ISIN] VARCHAR(125) NULL,
    [QTY] VARCHAR(125) NULL,
    [BDPID] VARCHAR(125) NULL,
    [BCLTDPID] VARCHAR(125) NULL,
    [EXCHANGE] VARCHAR(125) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_bajafinsv_split
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_bajafinsv_split]
(
    [Sett_no] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Actual_Qty] VARCHAR(50) NULL,
    [Inout] VARCHAR(50) NULL,
    [I_ISIN] VARCHAR(50) NULL,
    [NEW_qty_shortage] VARCHAR(50) NULL,
    [Remarks] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_bajafinsv_split_1
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_bajafinsv_split_1]
(
    [Sett_no] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Actual_Qty] VARCHAR(50) NULL,
    [Inout] VARCHAR(50) NULL,
    [I_ISIN] VARCHAR(50) NULL,
    [NEW_qty_shortage] VARCHAR(50) NULL,
    [Remarks] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_btst_143
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_btst_143]
(
    [Sett_no] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL,
    [Inout] VARCHAR(50) NULL,
    [Branch_Cd] VARCHAR(50) NULL,
    [PartipantCode] VARCHAR(50) NULL,
    [I_ISIN] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_tata_steel_split
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_tata_steel_split]
(
    [Sett_no] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Actual_Qty] VARCHAR(50) NULL,
    [Inout] VARCHAR(50) NULL,
    [I_ISIN] VARCHAR(50) NULL,
    [NEW_qty_shortage] VARCHAR(50) NULL,
    [Remarks] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.region
-- --------------------------------------------------
CREATE TABLE [dbo].[region]
(
    [Regioncode] VARCHAR(20) NULL,
    [Description] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Flag] VARCHAR(2) NULL,
    [Fld_AccessCode] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.region_dummy
-- --------------------------------------------------
CREATE TABLE [dbo].[region_dummy]
(
    [Regioncode] VARCHAR(10) NULL,
    [Description] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Flag] VARCHAR(2) NULL,
    [Fld_AccessCode] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scrip1
-- --------------------------------------------------
CREATE TABLE [dbo].[scrip1]
(
    [co_code] INT NULL,
    [series] VARCHAR(3) NOT NULL,
    [short_name] VARCHAR(50) NULL,
    [long_name] VARCHAR(50) NULL,
    [market_lot] INT NULL,
    [face_val] FLOAT NULL,
    [book_cl_dt] DATETIME NULL,
    [ex_div_dt] DATETIME NULL,
    [ex_bon_dt] DATETIME NULL,
    [ex_rit_dt] DATETIME NULL,
    [eqt_type] VARCHAR(3) NULL,
    [sub_type] VARCHAR(3) NULL,
    [agent_cd] VARCHAR(6) NULL,
    [demat_flag] SMALLINT NULL,
    [demat_date] DATETIME NULL,
    [rec1] VARCHAR(10) NULL,
    [rec2] VARCHAR(10) NULL,
    [rec3] VARCHAR(10) NULL,
    [rec4] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scrip2
-- --------------------------------------------------
CREATE TABLE [dbo].[scrip2]
(
    [co_code] INT NULL,
    [series] VARCHAR(3) NOT NULL,
    [exchange] VARCHAR(3) NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [scrip_cat] VARCHAR(3) NULL,
    [no_del_fr] DATETIME NULL,
    [no_del_to] DATETIME NULL,
    [cl_rate] FLOAT NULL,
    [clos_rate_dt] DATETIME NULL,
    [min_trd_qty] INT NULL,
    [BseCode] VARCHAR(10) NULL,
    [Isin] VARCHAR(20) NULL,
    [delsc_cat] VARCHAR(3) NULL,
    [Sector] VARCHAR(10) NULL,
    [Track] VARCHAR(1) NULL,
    [CDOL_No] VARCHAR(15) NULL,
    [Res1] VARCHAR(10) NULL,
    [Res2] VARCHAR(10) NULL,
    [Res3] VARCHAR(10) NULL,
    [Res4] VARCHAR(10) NULL,
    [Globalcustodian] VARCHAR(25) NULL,
    [common_code] VARCHAR(25) NULL,
    [IndexName] VARCHAR(10) NULL,
    [Industry] VARCHAR(10) NULL,
    [Bloomberg] VARCHAR(10) NULL,
    [RicCode] VARCHAR(10) NULL,
    [Reuters] VARCHAR(10) NULL,
    [IES] VARCHAR(10) NULL,
    [NoofIssuedshares] NUMERIC(18, 4) NULL,
    [Status] VARCHAR(10) NULL,
    [ADRGDRRatio] NUMERIC(18, 4) NULL,
    [GEMultiple] NUMERIC(18, 4) NULL,
    [GroupforGE] INT NULL,
    [RBICeilingIndicatorFlag] VARCHAR(2) NULL,
    [RBICeilingIndicatorValue] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SEBI_Colletral
-- --------------------------------------------------
CREATE TABLE [dbo].[SEBI_Colletral]
(
    [Party_code] VARCHAR(50) NULL,
    [exchange] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Cl_rate] MONEY NULL,
    [qty] INT NULL,
    [Haircut] MONEY NULL,
    [Amount] MONEY NULL,
    [FinalAmount] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SEBI_Colletral_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[SEBI_Colletral_Hist]
(
    [Party_code] VARCHAR(50) NULL,
    [exchange] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Cl_rate] MONEY NULL,
    [qty] INT NULL,
    [Haircut] MONEY NULL,
    [Amount] MONEY NULL,
    [FinalAmount] MONEY NULL,
    [ProcessDate] DATETIME NOT NULL
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
-- TABLE dbo.Sett_no_2024213_recon
-- --------------------------------------------------
CREATE TABLE [dbo].[Sett_no_2024213_recon]
(
    [Sett_no] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL,
    [I_ISIN] VARCHAR(50) NULL,
    [pos_recd] VARCHAR(50) NULL,
    [cuspa_qty] VARCHAR(50) NULL,
    [mtf_qty] VARCHAR(50) NULL,
    [DP_Free_qty] VARCHAR(50) NULL,
    [Shortage_214] VARCHAR(50) NULL,
    [Pos_recd_12] VARCHAR(50) NULL,
    [POOL_QTY] VARCHAR(50) NULL,
    [Total_recd_qty] VARCHAR(50) NULL,
    [Shortage] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.settlement
-- --------------------------------------------------
CREATE TABLE [dbo].[settlement]
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
    [Order_no] VARCHAR(16) NULL,
    [MarketRate] MONEY NULL,
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
    [Scheme] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Shortage_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[Shortage_Details]
(
    [sett_no] VARCHAR(11) NULL,
    [sett_type] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SHORT_NAME] VARCHAR(200) NULL,
    [BRANCH_CD] VARCHAR(20) NULL,
    [SUB_BROKER] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(15) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [DELQTY] INT NULL,
    [RECQTY] INT NULL,
    [ISETTQTYPRINT] INT NULL,
    [ISETTQTYMARK] INT NULL,
    [IBENQTYPRINT] INT NULL,
    [IBENQTYMARK] INT NULL,
    [HOLD] INT NULL,
    [PLEDGE] INT NULL,
    [BSEHOLD] INT NULL,
    [BSEPLEDGE] INT NULL,
    [CL_TYPE] VARCHAR(15) NULL,
    [COLLATERAL] INT NULL,
    [Sell_shortage] INT NULL,
    [Process_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SlowIoDiskfiles
-- --------------------------------------------------
CREATE TABLE [dbo].[SlowIoDiskfiles]
(
    [Database Name] VARCHAR(50) NULL,
    [physical_name] VARCHAR(150) NULL,
    [io_stall_read_ms] BIGINT NOT NULL,
    [num_of_reads] BIGINT NOT NULL,
    [avg_read_stall_ms] NUMERIC(10, 1) NULL,
    [io_stall_write_ms] BIGINT NOT NULL,
    [num_of_writes] BIGINT NOT NULL,
    [avg_write_stall_ms] NUMERIC(10, 1) NULL,
    [io_stalls] BIGINT NULL,
    [total_io] BIGINT NULL,
    [avg_io_stall_ms] NUMERIC(10, 1) NULL,
    [ReportDate] DATETIME NULL
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
    [branch_code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BACKUP_PROCESS_STATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BACKUP_PROCESS_STATUS]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [ProcessName] VARCHAR(100) NULL,
    [Status] VARCHAR(15) NULL,
    [Date] DATETIME NULL DEFAULT (getdate()),
    [RowsCount] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSECM_Shortage_LimitALG
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSECM_Shortage_LimitALG]
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
-- TABLE dbo.tbl_CN_Region
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CN_Region]
(
    [fld_regcode] VARCHAR(100) NULL,
    [fld_regname] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_commdities_gen_shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_commdities_gen_shortage]
(
    [Head] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_commodities_short
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_commodities_short]
(
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Short_Name] VARCHAR(50) NULL,
    [Branch_Cd] VARCHAR(50) NULL,
    [Sub_Broker] VARCHAR(50) NULL,
    [scrip_code] VARCHAR(50) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Certno] VARCHAR(50) NULL,
    [shortage] VARCHAR(50) NULL,
    [accountid] VARCHAR(50) NULL,
    [qty] VARCHAR(50) NULL,
    [BSEQty] VARCHAR(50) NULL,
    [NSEQty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_CUSPA_Release_Status
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_CUSPA_Release_Status]
(
    [transaction_date] DATE NOT NULL,
    [party_code] VARCHAR(50) NOT NULL,
    [pledgee_bo_id] VARCHAR(50) NOT NULL,
    [pledgor_bo_id] VARCHAR(50) NOT NULL,
    [pledge_sequence_number] BIGINT NOT NULL DEFAULT ((0)),
    [isin] VARCHAR(20) NOT NULL,
    [qty] INT NOT NULL DEFAULT ((0)),
    [last_updated_at] DATETIME NOT NULL DEFAULT (getdate()),
    [reference_number] VARCHAR(32) NOT NULL,
    [Upd_Status] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_CUSPA_Release_Status_Trig
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_CUSPA_Release_Status_Trig]
(
    [transaction_date] DATE NOT NULL,
    [party_code] VARCHAR(50) NOT NULL,
    [pledgee_bo_id] VARCHAR(50) NOT NULL,
    [pledgor_bo_id] VARCHAR(50) NOT NULL,
    [pledge_sequence_number] BIGINT NOT NULL,
    [isin] VARCHAR(20) NOT NULL,
    [qty] INT NOT NULL,
    [last_updated_at] DATETIME NOT NULL,
    [reference_number] VARCHAR(32) NOT NULL,
    [Upd_Status] INT NULL,
    [INsert_time] DATETIME NULL,
    [USerid] VARCHAR(50) NULL,
    [Record_type] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_demo_dpm4
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_demo_dpm4]
(
    [Sqanance_No] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_DMP_Downlod_Logs
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_DMP_Downlod_Logs]
(
    [Session_id] INT IDENTITY(1,1) NOT NULL,
    [UserName] VARCHAR(100) NULL,
    [Date_Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_DMP_Logs
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_DMP_Logs]
(
    [Session_id] INT IDENTITY(1,1) NOT NULL,
    [UserName] VARCHAR(100) NULL,
    [Date_Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DP_M3_Holding_Balance_tmp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DP_M3_Holding_Balance_tmp]
(
    [FILLER1] VARCHAR(MAX) NULL,
    [FILLER2] VARCHAR(MAX) NULL,
    [FILLER3] VARCHAR(MAX) NULL,
    [FILLER4] VARCHAR(MAX) NULL,
    [FILLER5] VARCHAR(MAX) NULL,
    [FILLER6] VARCHAR(MAX) NULL,
    [FILLER7] VARCHAR(MAX) NULL,
    [FILLER8] VARCHAR(MAX) NULL,
    [FILLER9] VARCHAR(MAX) NULL,
    [FILLER10] VARCHAR(MAX) NULL,
    [FILLER11] VARCHAR(MAX) NULL,
    [FILLER12] VARCHAR(MAX) NULL,
    [FILLER13] VARCHAR(MAX) NULL,
    [FILLER14] VARCHAR(MAX) NULL,
    [FILLER15] VARCHAR(MAX) NULL,
    [FILLER16] VARCHAR(MAX) NULL,
    [FILLER17] VARCHAR(MAX) NULL,
    [FILLER18] VARCHAR(MAX) NULL,
    [FILLER19] VARCHAR(MAX) NULL,
    [FILLER20] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DP_M4_Holding_Balance_tmp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DP_M4_Holding_Balance_tmp]
(
    [FILLER1] VARCHAR(MAX) NULL,
    [FILLER2] VARCHAR(MAX) NULL,
    [FILLER3] VARCHAR(MAX) NULL,
    [FILLER4] VARCHAR(MAX) NULL,
    [FILLER5] VARCHAR(MAX) NULL,
    [FILLER6] VARCHAR(MAX) NULL,
    [FILLER7] VARCHAR(MAX) NULL,
    [FILLER8] VARCHAR(MAX) NULL,
    [FILLER9] VARCHAR(MAX) NULL,
    [FILLER10] VARCHAR(MAX) NULL,
    [FILLER11] VARCHAR(MAX) NULL,
    [FILLER12] VARCHAR(MAX) NULL,
    [FILLER13] VARCHAR(MAX) NULL,
    [FILLER14] VARCHAR(MAX) NULL,
    [FILLER15] VARCHAR(MAX) NULL,
    [FILLER16] VARCHAR(MAX) NULL,
    [FILLER17] VARCHAR(MAX) NULL,
    [FILLER18] VARCHAR(MAX) NULL,
    [FILLER19] VARCHAR(MAX) NULL,
    [FILLER20] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPHOLD_15062023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPHOLD_15062023]
(
    [BO_ID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(12) NULL,
    [FREE_BALANCE] NUMERIC(16, 3) NULL,
    [FILE_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM_File_Insert_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM_File_Insert_log]
(
    [FileN] VARCHAR(5) NULL,
    [EXP] VARCHAR(5) NULL,
    [DPID] VARCHAR(5) NULL,
    [ReqId] VARCHAR(5) NULL,
    [FileType] VARCHAR(2) NULL,
    [Filedate] VARCHAR(20) NULL,
    [SeqNo] VARCHAR(5) NULL,
    [FileName] VARCHAR(50) NULL,
    [created_date] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM_File_Insert_log_02092024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM_File_Insert_log_02092024]
(
    [FileN] VARCHAR(5) NULL,
    [EXP] VARCHAR(5) NULL,
    [DPID] VARCHAR(5) NULL,
    [ReqId] VARCHAR(5) NULL,
    [FileType] VARCHAR(2) NULL,
    [Filedate] VARCHAR(20) NULL,
    [SeqNo] VARCHAR(5) NULL,
    [FileName] VARCHAR(50) NULL,
    [created_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM_File_Insert_log_11112024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM_File_Insert_log_11112024]
(
    [FileN] VARCHAR(5) NULL,
    [EXP] VARCHAR(5) NULL,
    [DPID] VARCHAR(5) NULL,
    [ReqId] VARCHAR(5) NULL,
    [FileType] VARCHAR(2) NULL,
    [Filedate] VARCHAR(20) NULL,
    [SeqNo] VARCHAR(5) NULL,
    [FileName] VARCHAR(50) NULL,
    [created_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM_File_Insert_log_12112024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM_File_Insert_log_12112024]
(
    [FileN] VARCHAR(5) NULL,
    [EXP] VARCHAR(5) NULL,
    [DPID] VARCHAR(5) NULL,
    [ReqId] VARCHAR(5) NULL,
    [FileType] VARCHAR(2) NULL,
    [Filedate] VARCHAR(20) NULL,
    [SeqNo] VARCHAR(5) NULL,
    [FileName] VARCHAR(50) NULL,
    [created_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM_File_Insert_log_12112024_1
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM_File_Insert_log_12112024_1]
(
    [FileN] VARCHAR(5) NULL,
    [EXP] VARCHAR(5) NULL,
    [DPID] VARCHAR(5) NULL,
    [ReqId] VARCHAR(5) NULL,
    [FileType] VARCHAR(2) NULL,
    [Filedate] VARCHAR(20) NULL,
    [SeqNo] VARCHAR(5) NULL,
    [FileName] VARCHAR(50) NULL,
    [created_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM_File_Insert_log_bkp30112024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM_File_Insert_log_bkp30112024]
(
    [FileN] VARCHAR(5) NULL,
    [EXP] VARCHAR(5) NULL,
    [DPID] VARCHAR(5) NULL,
    [ReqId] VARCHAR(5) NULL,
    [FileType] VARCHAR(2) NULL,
    [Filedate] VARCHAR(20) NULL,
    [SeqNo] VARCHAR(5) NULL,
    [FileName] VARCHAR(50) NULL,
    [created_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DPM3File_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DPM3File_2]
(
    [FILLER1] VARCHAR(MAX) NULL,
    [FILLER2] VARCHAR(MAX) NULL,
    [FILLER3] VARCHAR(MAX) NULL,
    [FILLER4] VARCHAR(MAX) NULL,
    [FILLER5] VARCHAR(MAX) NULL,
    [FILLER6] VARCHAR(MAX) NULL,
    [FILLER7] VARCHAR(MAX) NULL,
    [FILLER8] VARCHAR(MAX) NULL,
    [FILLER9] VARCHAR(MAX) NULL,
    [FILLER10] VARCHAR(MAX) NULL,
    [FILLER11] VARCHAR(MAX) NULL,
    [FILLER12] VARCHAR(MAX) NULL,
    [FILLER13] VARCHAR(MAX) NULL,
    [FILLER14] VARCHAR(MAX) NULL,
    [FILLER15] VARCHAR(MAX) NULL,
    [FILLER16] VARCHAR(MAX) NULL,
    [FILLER17] VARCHAR(MAX) NULL,
    [FILLER18] VARCHAR(MAX) NULL,
    [FILLER19] VARCHAR(MAX) NULL,
    [FILLER20] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_DPM4_FileCount
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_DPM4_FileCount]
(
    [Filename] VARCHAR(200) NULL,
    [FileNo] VARCHAR(10) NULL,
    [UpdateDate] DATETIME NULL,
    [FileCount] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_gen_shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_gen_shortage]
(
    [Head] VARCHAR(236) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_genfilefor_EP
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_genfilefor_EP]
(
    [head] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_genfilefor_ID
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_genfilefor_ID]
(
    [head] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_genfilefor_ID_final
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_genfilefor_ID_final]
(
    [head] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_log_dispatchfile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_log_dispatchfile]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [fld_region] VARCHAR(50) NULL,
    [fld_brcode] VARCHAR(50) NULL,
    [fld_blockdate] VARCHAR(30) NULL,
    [fld_unblockdate] VARCHAR(30) NULL,
    [fld_userid] VARCHAR(15) NULL,
    [fld_flag] NCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_MARGIN_Release_Status
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_MARGIN_Release_Status]
(
    [transaction_date] DATE NOT NULL,
    [party_code] VARCHAR(50) NOT NULL,
    [pledgee_bo_id] VARCHAR(50) NOT NULL,
    [pledgor_bo_id] VARCHAR(50) NOT NULL,
    [pledge_sequence_number] BIGINT NOT NULL DEFAULT ((0)),
    [isin] VARCHAR(20) NOT NULL,
    [qty] INT NOT NULL DEFAULT ((0)),
    [last_updated_at] DATETIME NOT NULL DEFAULT (getdate()),
    [reference_number] VARCHAR(32) NOT NULL,
    [Upd_Status] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Margin_Release_Status_Trig
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Margin_Release_Status_Trig]
(
    [transaction_date] DATE NOT NULL,
    [party_code] VARCHAR(50) NOT NULL,
    [pledgee_bo_id] VARCHAR(50) NOT NULL,
    [pledgor_bo_id] VARCHAR(50) NOT NULL,
    [pledge_sequence_number] BIGINT NOT NULL,
    [isin] VARCHAR(20) NOT NULL,
    [qty] INT NOT NULL,
    [last_updated_at] DATETIME NOT NULL,
    [reference_number] VARCHAR(32) NOT NULL,
    [Upd_Status] INT NULL,
    [INsert_time] DATETIME NULL,
    [USerid] VARCHAR(50) NULL,
    [Record_type] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mum_reg_brcd
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mum_reg_brcd]
(
    [Fld_BrCode] VARCHAR(50) NULL,
    [Fld_BrName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_my_data
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_my_data]
(
    [Sl No] FLOAT NULL,
    [Employer_Code] NVARCHAR(255) NULL,
    [Code] NVARCHAR(255) NULL,
    [ID] NVARCHAR(255) NULL,
    [Category_pk] FLOAT NULL,
    [Factory_Establishment] NVARCHAR(255) NULL,
    [Type_of_Unit] NVARCHAR(255) NULL,
    [Status_of_the_Factory_Establishment] NVARCHAR(255) NULL,
    [Name_of_Unit] NVARCHAR(255) NULL,
    [Address_1_of_Unit] NVARCHAR(255) NULL,
    [Address_2_of_Unit] NVARCHAR(255) NULL,
    [Address_3_of_Unit] NVARCHAR(255) NULL,
    [State_Name] NVARCHAR(255) NULL,
    [State_Code] NVARCHAR(255) NULL,
    [District_Name] NVARCHAR(255) NULL,
    [District_Code] FLOAT NULL,
    [Pin_code] FLOAT NULL,
    [Nature_of_Work] NVARCHAR(255) NULL,
    [Category_of_Work] NVARCHAR(255) NULL,
    [Provisional_Date_of_Coverage] DATETIME NULL,
    [Final_date_of_coverage] DATETIME NULL,
    [Constitution_of_Ownership] NVARCHAR(255) NULL,
    [Controlling_Ministry] NVARCHAR(255) NULL,
    [Type_of_Principal_Employer] NVARCHAR(255) NULL,
    [Principal_Employer_name] NVARCHAR(255) NULL,
    [Designation_of_Principal_Employer] NVARCHAR(255) NULL,
    [Principal_Employer_present_address] NVARCHAR(255) NULL,
    [Branch_Office_Name] NVARCHAR(255) NULL,
    [Branch_Office_Code] NVARCHAR(255) NULL,
    [Inspection_Division ] NVARCHAR(255) NULL,
    [Inspection_Division_Code] NVARCHAR(255) NULL,
    [F32] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mydata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mydata]
(
    [Sl No] FLOAT NULL,
    [Employer_Code] NVARCHAR(255) NULL,
    [Code] NVARCHAR(255) NULL,
    [ID] NVARCHAR(255) NULL,
    [Category_pk] FLOAT NULL,
    [Factory_Establishment] NVARCHAR(255) NULL,
    [Type_of_Unit] NVARCHAR(255) NULL,
    [Status_of_the_Factory_Establishment] NVARCHAR(255) NULL,
    [Name_of_Unit] NVARCHAR(255) NULL,
    [Address_1_of_Unit] NVARCHAR(255) NULL,
    [Address_2_of_Unit] NVARCHAR(255) NULL,
    [Address_3_of_Unit] NVARCHAR(255) NULL,
    [State_Name] NVARCHAR(255) NULL,
    [State_Code] NVARCHAR(255) NULL,
    [District_Name] NVARCHAR(255) NULL,
    [District_Code] FLOAT NULL,
    [Pin_code] FLOAT NULL,
    [Nature_of_Work] NVARCHAR(255) NULL,
    [Category_of_Work] NVARCHAR(255) NULL,
    [Provisional_Date_of_Coverage] DATETIME NULL,
    [Final_date_of_coverage] DATETIME NULL,
    [Constitution_of_Ownership] NVARCHAR(255) NULL,
    [Controlling_Ministry] NVARCHAR(255) NULL,
    [Type_of_Principal_Employer] NVARCHAR(255) NULL,
    [Principal_Employer_name] NVARCHAR(255) NULL,
    [Designation_of_Principal_Employer] NVARCHAR(255) NULL,
    [Principal_Employer_present_address] NVARCHAR(255) NULL,
    [Branch_Office_Name] NVARCHAR(255) NULL,
    [Branch_Office_Code] NVARCHAR(255) NULL,
    [Inspection_Division ] NVARCHAR(255) NULL,
    [Inspection_Division_Code] NVARCHAR(255) NULL,
    [F32] NVARCHAR(255) NULL
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
-- TABLE dbo.tbl_NSECM_Shortage_LimitALG
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECM_Shortage_LimitALG]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_payout_Marking
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_payout_Marking]
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
-- TABLE dbo.tbl_PLDDATA_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PLDDATA_NEW]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [SERIES] VARCHAR(3) NULL,
    [BSECODE] VARCHAR(6) NULL,
    [ISIN] VARCHAR(16) NULL,
    [QTY] NUMERIC(38, 0) NULL,
    [PLDQTY] INT NULL,
    [REPLDQTY] INT NULL,
    [CL_RATE] NUMERIC(18, 4) NULL,
    [HAIRCUT] NUMERIC(18, 4) NULL,
    [BDPID] VARCHAR(16) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [BDPID1] VARCHAR(8) NULL,
    [BCLTDPID1] VARCHAR(16) NULL,
    [BDPID2] VARCHAR(8) NULL,
    [BCLTDPID2] VARCHAR(16) NULL,
    [PSNNO1] VARCHAR(16) NULL,
    [PSNNO2] VARCHAR(20) NULL,
    [PSNNO3] VARCHAR(20) NULL,
    [SEC_TYPE] VARCHAR(7) NOT NULL,
    [TM_APP_FLAG] VARCHAR(1) NOT NULL,
    [CM_APP_FLAG] VARCHAR(1) NOT NULL,
    [CC_APP_FLAG] VARCHAR(1) NOT NULL,
    [EXCHG_SEC] VARCHAR(50) NULL,
    [PLDEXCHG_SEC] VARCHAR(50) NULL,
    [REPLDEXCHG_SEC] VARCHAR(50) NULL,
    [rundate] DATETIME NULL
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
    [Fld_NewPledgeQty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_POA_PLD_ADNL_RMTF
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_POA_PLD_ADNL_RMTF]
(
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(50) NULL,
    [SERIES] VARCHAR(3) NOT NULL,
    [CERTNO] VARCHAR(16) NULL,
    [DPID] VARCHAR(16) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [QTY] NUMERIC(18, 0) NOT NULL,
    [DELIVERED] CHAR(1) NOT NULL,
    [FOLIONO] VARCHAR(16) NULL,
    [SLIPNO] NUMERIC(18, 0) NULL,
    [BATCHNO] VARCHAR(10) NULL,
    [EXEDATE] DATETIME NOT NULL,
    [TRANSDATE] DATETIME NOT NULL,
    [PROCESSDATE] DATETIME NOT NULL,
    [INST_TYPE] VARCHAR(20) NULL,
    [CL_RATE] NUMERIC(18, 2) NULL,
    [VARRATE] NUMERIC(18, 2) NULL,
    [BOID] VARCHAR(16) NULL,
    [PLDNO] VARCHAR(20) NULL,
    [UPLOAD_STATUS] VARCHAR(1) NOT NULL,
    [SUCCESSFLAG] VARCHAR(1) NOT NULL,
    [PAYQTY] NUMERIC(18, 3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_POA_PLD_ADNL_RMTF_STG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_POA_PLD_ADNL_RMTF_STG]
(
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(50) NULL,
    [SERIES] VARCHAR(3) NOT NULL,
    [CERTNO] VARCHAR(16) NULL,
    [DPID] VARCHAR(16) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [QTY] NUMERIC(18, 0) NOT NULL,
    [DELIVERED] CHAR(1) NOT NULL,
    [FOLIONO] VARCHAR(16) NULL,
    [SLIPNO] NUMERIC(18, 0) NULL,
    [BATCHNO] VARCHAR(10) NULL,
    [EXEDATE] DATETIME NOT NULL,
    [TRANSDATE] DATETIME NOT NULL,
    [PROCESSDATE] DATETIME NOT NULL,
    [INST_TYPE] VARCHAR(20) NULL,
    [CL_RATE] NUMERIC(18, 2) NULL,
    [VARRATE] NUMERIC(18, 2) NULL,
    [BOID] VARCHAR(16) NULL,
    [PLDNO] VARCHAR(20) NULL,
    [UPLOAD_STATUS] VARCHAR(1) NOT NULL,
    [SUCCESSFLAG] VARCHAR(1) NOT NULL,
    [PAYQTY] NUMERIC(18, 3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_short
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_short]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [scrip_code] VARCHAR(50) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Certno] VARCHAR(20) NULL,
    [shortage] NUMERIC(38, 0) NULL,
    [accountid] CHAR(16) NULL,
    [qty] BIGINT NULL,
    [BSEQty] VARCHAR(50) NULL,
    [NSEQty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(15) NOT NULL,
    [Short_Name] VARCHAR(25) NOT NULL,
    [Branch_Cd] VARCHAR(15) NULL,
    [sub_broker] VARCHAR(15) NOT NULL,
    [Scrip_Cd] VARCHAR(55) NULL,
    [Certno] VARCHAR(25) NULL,
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
    [Cl_Type] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_commodities
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_commodities]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(15) NULL,
    [Short_Name] VARCHAR(25) NULL,
    [Branch_Cd] VARCHAR(15) NULL,
    [sub_broker] VARCHAR(15) NULL,
    [Scrip_Cd] VARCHAR(55) NULL,
    [Certno] VARCHAR(25) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NULL,
    [Pledge] INT NULL,
    [Nsehold] INT NULL,
    [Nsepledge] INT NULL,
    [Cl_Type] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_usr_holding_for_DP
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_usr_holding_for_DP]
(
    [tradingid] VARCHAR(100) NULL,
    [hld_isin_code] VARCHAR(20) NULL,
    [netqty] NUMERIC(30, 5) NULL,
    [PLEDGE_QTY] NUMERIC(18, 5) NULL,
    [Rate] NUMERIC(18, 3) NOT NULL,
    [FREE_QTY] NUMERIC(18, 5) NULL,
    [FREEZE_QTY] NUMERIC(18, 5) NULL,
    [hld_hold_date] VARCHAR(8) NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_practice
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_practice]
(
    [Sorty] INT NULL,
    [CategoryName] VARCHAR(50) NULL,
    [ProductName] VARCHAR(50) NULL,
    [ProductSales] REAL NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempbse
-- --------------------------------------------------
CREATE TABLE [dbo].[tempbse]
(
    [cltcode] VARCHAR(10) NULL,
    [vtyp] SMALLINT NOT NULL,
    [drcr] CHAR(1) NULL,
    [camt] MONEY NULL,
    [costcode] SMALLINT NULL
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
    [DispFlag] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.YESBANK_HLD1403
-- --------------------------------------------------
CREATE TABLE [dbo].[YESBANK_HLD1403]
(
    [PARTY_CODE] NVARCHAR(255) NULL,
    [POOL_Hld_1403_Old] FLOAT NULL,
    [POOL_Hld_1403_New] FLOAT NULL,
    [Sett_No_N51] FLOAT NULL,
    [Sett_No_N52] FLOAT NULL,
    [Net_before_CA] FLOAT NULL,
    [InterSett_1803 ] FLOAT NULL,
    [PayOut2Clt] FLOAT NULL,
    [Hld_before_CA] FLOAT NULL,
    [Free_Hld_after_CA] FLOAT NULL,
    [Sett_No_A51] FLOAT NULL,
    [Net_After_Sett_No_A51] FLOAT NULL,
    [Sett_No_A52] FLOAT NULL,
    [Net_After_Sett_No_A52] FLOAT NULL,
    [Sett_No_N53] FLOAT NULL,
    [Net_After_Sett_No_N53] FLOAT NULL,
    [Sett_No_A53] FLOAT NULL,
    [RECD_CLT_53] FLOAT NULL,
    [EXCESS_SOLD_53] FLOAT NULL,
    [Net_After_Sett_No_A53] FLOAT NULL,
    [Sett_No_N54] FLOAT NULL,
    [Net_After_Sett_No_N54] FLOAT NULL,
    [Sett_No_A54] FLOAT NULL,
    [Net_After_Sett_No_A54] FLOAT NULL,
    [Sett_No_N55] FLOAT NULL,
    [Net_After_Sett_No_N55] FLOAT NULL,
    [Sett_No_A55] FLOAT NULL,
    [Net_After_Sett_No_A55] FLOAT NULL,
    [Sett_No_N56] FLOAT NULL,
    [Net_After_Sett_No_N56] FLOAT NULL,
    [Sett_No_A56] FLOAT NULL,
    [Net_After_Sett_No_A56] FLOAT NULL,
    [Sett_No_N57] FLOAT NULL,
    [Net_After_Sett_No_N57] FLOAT NULL,
    [Sett_No_A57] FLOAT NULL,
    [Net_After_Sett_No_A57] FLOAT NULL,
    [Sett_No_N58] FLOAT NULL,
    [Net_After_Sett_No_N58] FLOAT NULL,
    [Sett_No_A58] FLOAT NULL,
    [Net_After_Sett_No_A58] FLOAT NULL,
    [Sett_No_N59] FLOAT NULL,
    [Net_After_Sett_No_N59] FLOAT NULL,
    [Sett_No_A59] FLOAT NULL,
    [Net_After_Sett_No_A59] FLOAT NULL,
    [Sett_No_N60] FLOAT NULL,
    [Net_After_Sett_No_N60] FLOAT NULL,
    [Sett_No_A60] FLOAT NULL,
    [Net_After_Sett_No_A60] FLOAT NULL,
    [Sett_No_N61] FLOAT NULL,
    [Net_After_Sett_No_N61] FLOAT NULL,
    [Sett_No_A61] FLOAT NULL,
    [Net_After_Sett_No_A61] FLOAT NULL,
    [Sett_No_N62_SELL] FLOAT NULL,
    [Net_After_Sett_No_N62] FLOAT NULL,
    [Recd_CLT_53_62] FLOAT NULL,
    [PayIN_53_onwards] FLOAT NULL,
    [Payout2CLT_53_onwards] FLOAT NULL,
    [FINAL_HLD] FLOAT NULL,
    [AsOnDate_ 3103_Hld_NEW] FLOAT NULL,
    [AsOnDate_ 3103_Hld_OLD] FLOAT NULL,
    [Lockin_CDSL_1403] FLOAT NULL,
    [Free_CDSL_1403] FLOAT NULL,
    [Lockin_NDSL_1403] FLOAT NULL,
    [Free_NDSL_1403] FLOAT NULL,
    [CA_ApplIED_On_1403] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.YesBankPortfolio
-- --------------------------------------------------
CREATE TABLE [dbo].[YesBankPortfolio]
(
    [Party_code] VARCHAR(10) NULL,
    [BseCode] VARCHAR(10) NULL,
    [NseScrip_cd] VARCHAR(10) NULL,
    [NseSeries] VARCHAR(10) NULL,
    [Isin] VARCHAR(20) NULL,
    [ScripName] VARCHAR(80) NULL,
    [Position] BIGINT NULL,
    [AvgPrice] MONEY NULL,
    [ClientId] BIGINT NULL,
    [MapId] BIGINT NULL,
    [FreePosition] BIGINT NULL,
    [BlockPosition] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.TR_CRS
-- --------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[TR_CRS]
   ON  [dbo].[Tbl_CUSPA_Release_Status] 
  AFTER INSERT, UPDATE, DELETE
AS 

IF (SELECT COUNT(1) FROM INSERTED) > 0   
	BEGIN   
		-- if update operation
		IF (SELECT COUNT(*) FROM DELETED) > 0   
		BEGIN   
			INSERT INTO dbo.Tbl_CUSPA_Release_Status_Trig
			SELECT *, Getdate(),SUSER_NAME(), 'U'    
			FROM DELETED
		END   
		ELSE   -- insert operation
		BEGIN  
			INSERT INTO dbo.Tbl_CUSPA_Release_Status_Trig
			SELECT *, Getdate(),SUSER_NAME(), 'I'  
			FROM INSERTED
		END   
    END   
  ELSE  -- delete operation 
    BEGIN   
		INSERT INTO dbo.Tbl_CUSPA_Release_Status_Trig
		SELECT *, Getdate(),SUSER_NAME(), 'D'  
		FROM DELETED
    END

GO

-- --------------------------------------------------
-- TRIGGER dbo.TR_MRS
-- --------------------------------------------------
CREATE TRIGGER [dbo].[TR_MRS]
   ON  [dbo].[Tbl_Margin_Release_Status]
  AFTER INSERT, UPDATE, DELETE
AS
IF (SELECT COUNT(1) FROM INSERTED) > 0
	BEGIN
		-- if update operation
		IF (SELECT COUNT(*) FROM DELETED) > 0
		BEGIN
			INSERT INTO dbo.Tbl_CUSPA_Release_Status_Trig
			SELECT *, Getdate(),SUSER_NAME(), 'U'
			FROM DELETED
		END
		ELSE   -- insert operation
		BEGIN
			INSERT INTO dbo.Tbl_CUSPA_Release_Status_Trig
			SELECT *, Getdate(),SUSER_NAME(), 'I'
			FROM INSERTED
		END
    END
  ELSE  -- delete operation
    BEGIN
		INSERT INTO dbo.Tbl_CUSPA_Release_Status_Trig
		SELECT *, Getdate(),SUSER_NAME(), 'D'
		FROM DELETED
    END

GO

-- --------------------------------------------------
-- VIEW dbo.TPIN_SHORTAGE_PAYIN
-- --------------------------------------------------


CREATE VIEW [dbo].[TPIN_SHORTAGE_PAYIN]
AS

SELECT PARTY_CODE,
SCRIP_CD,
SERIES,
SELL_SHORTAGE,
DP_ID,
DP_QTY,
PAYINDATE,
PROCESS_DATE,
MOBILE_PAGER,
SETT_NO,
SETT_TYPE,
SMS_QTY,
ISIN FROM NON_POA_SMS_DATA
WHERE SMS_QTY <>0 
--AND PROCESS_DATE BETWEEN CONVERT(VARCHAR(11),GETDATE(),120)
--AND   CONVERT(VARCHAR(11),GETDATE(),120) +' 23:59'
Union all
SELECT TOP 1 PARTY_CODE =Cl_CODE,
SCRIP_CD ='RELIANCE',
SERIES='EQ',
SELL_SHORTAGE='11',
DP_ID='1203320100000011',
DP_QTY='20',
PAYINDATE,
PROCESS_DATE,
MOBILE_PAGER ='9619040060',
SETT_NO,
SETT_TYPE,
SMS_QTY,
ISIN='INE002A01018'
FROM NON_POA_SMS_DATA N,msajag.dbo.CLIENT1 C
WHERE SMS_QTY <>0  AND Cl_CODE ='RP61'

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

