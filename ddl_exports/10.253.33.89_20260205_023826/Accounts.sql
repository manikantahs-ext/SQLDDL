-- DDL Export
-- Server: 10.253.33.89
-- Database: Accounts
-- Exported: 2026-02-05T02:38:27.755167

USE Accounts;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UPDATE_CLIENT_CHECK_DETAIL
-- --------------------------------------------------
ALTER TABLE [dbo].[UPDATE_CLIENT_CHECK_DETAIL] ADD CONSTRAINT [FK__chq_clien__clien__22AA2996] FOREIGN KEY ([clientid]) REFERENCES [dbo].[tbl_ChqRtn_BO_Entries] ([id])

GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_diagramobjects
-- --------------------------------------------------

	CREATE FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_AgreegatorPaynetzTechResponse
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_tbl_AgreegatorPaynetzTechResponse_rectype] ON [dbo].[tbl_AgreegatorPaynetzTechResponse] ([rectype])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_AgreegatorPaynetzTechResponse
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_tbl_AgreegatorPaynetzTechResponse_verificationType_rectype_TranVerificationStatus] ON [dbo].[tbl_AgreegatorPaynetzTechResponse] ([verificationType], [rectype], [TranVerificationStatus]) INCLUDE ([requestID], [vendor], [merchantID], [TranAtomRefNo], [TranTechRefNo], [TranBankName])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_ChqRtn_BO_Entries
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_segvno] ON [dbo].[tbl_ChqRtn_BO_Entries] ([Segment], [vno])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_ChqRtn_BO_Entries
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxt_dt_Vno] ON [dbo].[tbl_ChqRtn_BO_Entries] ([vdt], [vno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.chq_status
-- --------------------------------------------------
ALTER TABLE [dbo].[chq_status] ADD CONSTRAINT [PK__chq_status__1DE57479] PRIMARY KEY ([srno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B61ACF11041] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ChqRtn_BO_Entries
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ChqRtn_BO_Entries] ADD CONSTRAINT [p_ChqRtn] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_checkDuplicatesRecInBO
-- --------------------------------------------------
/*PROCEDURE IS CREATED BY ROHIT PATIL   
TO FIND OUT THE DUPLICATE RECORDS IN TBL_POST_DATA TO TAKE QUICK ACTION.  
*/  
 CREATE PROC [dbo].[Agg_checkDuplicatesRecInBO]  
 AS  
 BEGIN   
 DECLARE @MESS VARCHAR(MAX)=''  
 --DROP TABLE #TEMP  
 select * into #TEMP from(   
 select VDATE,EDATE,CLTCODE,CREDITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHCODE,DDNO,  
 CHEQUEMODE,CHEQUEDATE,CHEQUENAME,TPACCOUNTNUMBER,EXCHANGE,SEGMENT  
 from  angelBSECM.MKTAPI.DBO.TBL_POST_DATA with(nolock)  
 where convert(varchar(12),vdate,106) =convert(varchar(12),getdate(),106) and VOUCHERTYPE=2 
 group by  VDATE,EDATE,CLTCODE,CREDITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHCODE,  
 DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,TPACCOUNTNUMBER,EXCHANGE,SEGMENT  
 having count(ddno)>1  
   )a  
     
 IF(SELECT COUNT(*) FROM #TEMP) > 0  
  BEGIN  
           
  DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX)                                               
  SET @TO = 'sajeev@angelbroking.com;pay-inbanking@angelbroking.com ;neha.naiwar@angelbroking.com'                                         
   SET @CC = 'fundspayout@angelbroking.com;pay-inbanking@angelbroking.com;fundspayout@angelbroking.com'                       
    
  --SET @BCC = 'manesh@angelbroking.com;renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;            
  --Rohit.Patil@angelbroking.com'                                                              
  SET @MESS = 'Dear Team,<br /> <br />  There is Duplicate Entry occured in <b> MKT TBL_POST_DATA </b> table  kindly check.             
  <br /> <br/>'              
                   
   /*Sending SMS */             
   create table #MobNo              
   (              
   mobno numeric(10,0)              
   )          
              
   insert into #MobNo             
   select 8976552188--neha              
   /*union all              
   select 9892953949--manesh sir   */      
   union all  
   select 9820556259             
   union all              
   select 7709733841                               
  --print @MESS  
  
  --Trigger SMS.                 
    insert into intranet.sms.dbo.sms         
    --@MessBody               
    select a.mobno,'Duplicate Entry IN MKT TBL_POST_DATA',convert(varchar(10), getdate(), 103),              
    ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +              
    ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),              
    'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12              
    then 'PM' else 'AM' end,'Agg Duplicate Entry in MKTAPI'              
    from #MobNo a                                      
            
  EXEC MSDB.DBO.SP_SEND_DBMAIL               
  @RECIPIENTS = @TO,                                                      
  @COPY_RECIPIENTS = @CC,                                                      
  --@BLIND_COPY_RECIPIENTS = @BCC,                                        
  @PROFILE_NAME = 'Angelbroking',                                                      
  @BODY_FORMAT ='HTML',                                                      
  @SUBJECT = 'Aggregator: Duplicate Entry IN MKT TBL_POST_DATA.' ,                                                      
  @BODY =@MESS  
                 
   END    
    
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_Email_Rejected_From_BO
-- --------------------------------------------------
   
CREATE Proc [dbo].[AGG_Email_Rejected_From_BO]                      
AS                        
BEGIN                        
                   
                         
 DECLARE @HTMLBODY1 VARCHAR(8000), @MESS AS VARCHAR(4000),@filename as varchar(100)                  
 select @filename='I:\upload1\Aggregator\FundsPayinNotInBO\FundsRejectedInBO_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                  
 /*print @filename */                  
             
 truncate table AGG_MKTAPI_NotPostedIn_BO         
 insert into AGG_MKTAPI_NotPostedIn_BO 
 (FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,
 CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,
 RETURN_FLD5,ROWSTATE
 ) 
 SELECT FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,T.CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,T.DDNO,
 CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,T.EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,
 RETURN_FLD5,ROWSTATE FROM AngelBSECM.MKTAPI.DBO.TBL_POST_DATA T 
LEFT OUTER JOIN 
(

SELECT CLTCODE,L.DRCR,VAMT,L.VTYP,L1.DDNO,'BSE-CAPITAL' AS EXCHANGE FROM AngelBSECM.ACCOUNT_aB.DBO.LEDGER L,AngelBSECM.ACCOUNT_aB.DBO.LEDGER1 L1 
WHERE L.VNO=L1.VNO AND L.VTYP =L1.VTYP AND L.BOOKTYPE=L1.BookType
AND VDT>=CONVERT(VARCHAR(10),GETDATE()-1,120) AND L.VTYP=2 AND L.DRCR='C'
UNION ALL
SELECT CLTCODE,L.DRCR,VAMT,L.VTYP,L1.DDNO ,'NSE-CAPITAL' FROM AngelNSECM.ACCOUNT.DBO.LEDGER L,AngelNSECM.ACCOUNT.DBO.LEDGER1 L1 
WHERE L.VNO=L1.VNO AND L.VTYP =L1.VTYP AND L.BOOKTYPE=L1.BookType
AND VDT>=CONVERT(VARCHAR(10),GETDATE()-1,120) AND L.VTYP=2 AND L.DRCR='C'
UNION ALL
SELECT CLTCODE,L.DRCR,VAMT,L.VTYP,L1.DDNO,'NSE-FUTURES' FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L,ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 
WHERE L.VNO=L1.VNO AND L.VTYP =L1.VTYP AND L.BOOKTYPE=L1.BookType
AND VDT>=CONVERT(VARCHAR(10),GETDATE()-1,120)  AND L.VTYP=2 AND L.DRCR='C'
UNION ALL
SELECT CLTCODE,L.DRCR,VAMT,L.VTYP,L1.DDNO,'NSE-CURRENCY' FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L,ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 
WHERE L.VNO=L1.VNO AND L.VTYP =L1.VTYP AND L.BOOKTYPE=L1.BookType
AND VDT>=CONVERT(VARCHAR(10),GETDATE()-1,120)  AND L.VTYP=2 AND L.DRCR='C'
UNION ALL
SELECT CLTCODE,L.DRCR,VAMT,L.VTYP,L1.DDNO, 'MCDX' FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L, ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 
WHERE L.VNO=L1.VNO AND L.VTYP =L1.VTYP AND L.BOOKTYPE=L1.BookType
AND VDT>=CONVERT(VARCHAR(10),GETDATE()-1,120) AND L.VTYP=2 AND L.DRCR='C'
UNION ALL
SELECT CLTCODE,L.DRCR,VAMT,L.VTYP,L1.DDNO,'NCDX'  FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L, ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 
WHERE L.VNO=L1.VNO AND L.VTYP =L1.VTYP AND L.BOOKTYPE=L1.BookType
AND VDT>=CONVERT(VARCHAR(10),GETDATE()-1,120) AND L.VTYP=2 AND L.DRCR='C'
)V
ON T.CLTCODE=V.CLTCODE AND T.DDNO=V.ddno AND T.CREDITAMT=V.VAMT 
WHERE VDATE>=CONVERT(VARCHAR(10),GETDATE()-1,120) AND ROWSTATE =99 AND VOUCHERTYPE =2  
AND V.EXCHANGE IS NULL and T.EXCHANGE='' and T.SEGMENT=''

 /*                    
 select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,        
 BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,        
 MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE        
 from AngelBSECM.MKTAPI.dbo.tbl_post_data  where EXCHANGE='' and SEGMENT=''  
  and rowstate =99 
  and return_fld5='IH_Aggregator' and vdate >= CONVERT(varchar(11),getdate())        
 order by Segment,cltcode                      
   */                   
 if (select count(1) from AGG_MKTAPI_NotPostedIn_BO)  > 0                      
 Begin                      
                  
  BEGIN TRY                   
   declare @s1 as varchar(1000)                  
   set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE FROM INTRANET.accounts.dbo.AGG_MKTAPI_NotPostedIn_BO order by Segment,cltcode" queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                           
  
   set @s1= @s1+''''                      
   Exec (@s1)                   
                                        
                            
    DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX)                          
    SET @TO = 'pay-inbanking@angelbroking.com;archana.shah@angelbroking.com;sagar.soner@angelbroking.com;prashant.padhi@angelbroking.com'                      
    SET @CC = 'sajeev@angelbroking.com'                      
    SET @BCC = 'renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com'                      
      
    SET @MESS = 'Dear All,<BR /><BR /> Incremental Funds Payin Details rejected from BO for your reference.<br><Br>Angel Broking'                        
    EXEC MSDB.DBO.SP_SEND_DBMAIL                        
    @RECIPIENTS = @TO,                        
    @COPY_RECIPIENTS = @CC,                        
   -- @BLIND_COPY_RECIPIENTS = @BCC,          
    @PROFILE_NAME = 'Angelbroking',                        
    @BODY_FORMAT ='HTML',                        
    @SUBJECT = 'Aggregator:Online Entry not updated into BO due to File splitting issue' ,                        
    @BODY =@mess,                        
    @file_attachments = @filename                  
                         
  END TRY                            
  BEGIN CATCH                   
   SET @MESS='<BR><BR> ERROR in triggering email for Funds Payin (Aggregator). Kindly contract System Adminstrator to resolve the issue.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                  
   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
   @RECIPIENTS ='renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com',                  
   @COPY_RECIPIENTS = 'renil.pillai@angelbroking.com',                           
   @PROFILE_NAME = 'Angelbroking',                        
   @BODY_FORMAT ='HTML',                        
   @SUBJECT = 'ERROR !! Aggregator: Online Entry not updated into BO due to File splitting issue',                            
   @FILE_ATTACHMENTS ='',                          
   @BODY =@MESS                            
  END CATCH                       
                  
 End                      
                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_for_testing
-- --------------------------------------------------

CREATE proc Agg_for_testing(@currentdate as datetime)          
as          
begin          
 insert into agg_For_checking (Requestdate)          
 select @currentdate         
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_get_H2H_Transaction_WEBAPI_Existing
-- --------------------------------------------------
--Agg_get_H2H_Transaction_WEBAPI_Existing 'DMVPD1548A','18/12/2017'  
CREATE proc [dbo].[Agg_get_H2H_Transaction_WEBAPI_Existing](@Party_code varchar(100),@date varchar(100))        
as        
begin        
 --'18/12/2017     
if exists( select * from Agg_TechTrnasctionSplitData where  SUBSTRING(clnt_rqst_meta,0,CHARINDEX('_',clnt_rqst_meta,0))=@Party_code  and   
convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 00:00:00' and  
 convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 23:59:59' )        
   begin      
    
     select txn_msg,clnt_txn_ref,tpsl_bank_cd,tpsl_txn_id,txn_amt,clnt_rqst_meta,tpsl_txn_time,BankTransactionID  
  from Agg_TechTrnasctionSplitData where  SUBSTRING(clnt_rqst_meta,0,CHARINDEX('_',clnt_rqst_meta,0))=@Party_code  and   
 convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 00:00:00' and  
  convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 23:59:59'     
     
   end    
 else        
   select 'Not Exist' as msg           
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_get_H2H_Transaction_WEBAPI_New
-- --------------------------------------------------
--Agg_get_H2H_Transaction_WEBAPI_New 'DMVPD1548A','18/12/2017'
CREATE proc [dbo].[Agg_get_H2H_Transaction_WEBAPI_New](@PanNo varchar(100),@date varchar(100))      
as      
begin      
 --'18/12/2017   
if exists( select * from Agg_TechTrnasctionSplitData where  SUBSTRING(clnt_rqst_meta,0,CHARINDEX('_',clnt_rqst_meta,0))=@PanNo  and 
convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 00:00:00' and
 convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 23:59:59' )      
   begin    
  
     select txn_msg,clnt_txn_ref,tpsl_bank_cd,tpsl_txn_id,txn_amt,clnt_rqst_meta,tpsl_txn_time,BankTransactionID
	 from Agg_TechTrnasctionSplitData where  SUBSTRING(clnt_rqst_meta,0,CHARINDEX('_',clnt_rqst_meta,0))=@PanNo  and 
	convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 00:00:00' and
	 convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@date,103),106), '/', ' ')+' 23:59:59'   
   
   end  
 else      
   select 'Not Exist' as msg         
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_insert_TechTransaction
-- --------------------------------------------------
CREATE proc Agg_insert_TechTransaction(@msg as varchar(max),@Res as varchar(max),@MerchantId as varchar(50),@currentdate as datetime)          
as          
begin          
 insert into Agg_TechTrnasction (Req_String,Response_string,LogDate,VendorMerchantId,Requestdate)          
 select @msg,@Res,getdate(),@MerchantId,@currentdate          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_insert_TechTransaction_27Dec2017
-- --------------------------------------------------
CREATE proc Agg_insert_TechTransaction_27Dec2017(@msg as varchar(max),@Res as varchar(max),@tpsl_clnt_cd as varchar(500),@clnt_txn_ref as varchar(500))    
as    
begin    
 insert into Agg_TechTrnasction (Req_String,Response_string,LogDate,tpsl_clnt_cd,clnt_txn_ref)    
 select @msg,@Res,getdate(),@tpsl_clnt_cd,@clnt_txn_ref     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_insert_transMarchant
-- --------------------------------------------------
CREATE proc Agg_insert_transMarchant(@cltcd as varchar(max))      
as      
begin      
 insert into Agg_Techvend (tpsl_clnt_cd)      
 select @cltcd     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_Segment_Missing_In_BO
-- --------------------------------------------------
CREATE Procedure [dbo].[Agg_Segment_Missing_In_BO]                          
as                          
                          
set nocount on                          


     
select * into #aa from tbl_AngelPGIMBOTransactionLog with(nolock) where Segment='EQUITY+FNO+CURRENCY' and 
logdate>=convert(varchar(10), getdate()-1,120) and VerificationRemark='SUCCESS' /* order by logdate desc*/
 
/*Ended by sandeep on 11 Apr 2017*/        

 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select party_code collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
       
 if(select count(1) from #Client) >0  /*Added on 24 jun 2016*/ 
 Begin 
	select   * into #client_Details from risk.dbo.client_Details with (nolock) where cl_code in (select party_code from #aa)
	
 	/* EQUITY+FNO+CURRENCY'*/  
	select party_Code,Entity,c.Segment,SeqId into #eq   
	from        
	(select Segment,party_Code from #aa where Segment='EQUITY+FNO+CURRENCY') a join  
	(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
	on a.party_Code=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
	join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
	on a.Segment=c.entity collate SQL_Latin1_General_CP1_CI_AS  

	insert into #eq   
	select party_Code,Entity,c.Segment,SeqId 
	from          
	(select Segment,party_Code from #aa where Segment='EQUITY+FNO+CURRENCY' and party_Code not in (select party_Code from #eq))
	 a join  
	(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
	on a.party_Code=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
	join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
	on a.Segment=c.entity collate SQL_Latin1_General_CP1_CI_AS  

	insert into #eq   
	select party_Code,Entity,c.Segment,SeqId    
	from          
	(select Segment,party_Code from #aa where Segment='EQUITY+FNO+CURRENCY' and party_Code not in (select party_Code from #eq)) a join  
	(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
	on a.party_Code=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
	join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
	on a.Segment=c.entity collate SQL_Latin1_General_CP1_CI_AS 
	  
	insert into #eq   
	select party_Code,Entity,c.Segment,SeqId 
	from          
	(select Segment,party_Code from #aa where Segment='EQUITY+FNO+CURRENCY' and party_Code not in (select party_Code from #eq)) a join  
	(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
	on a.party_Code=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
	join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
	on a.Segment=c.entity collate SQL_Latin1_General_CP1_CI_AS  
	  
	insert into #eq   
	select party_Code,Entity,c.Segment,SeqId  
	from          
	(select Segment,party_Code from #aa where Segment='EQUITY+FNO+CURRENCY' and party_Code not in (select party_Code from #eq)) a join  
	(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
	on a.party_Code=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
	join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
	on a.Segment=c.entity collate SQL_Latin1_General_CP1_CI_AS  
	  
	  
	update #aa set Segment=b.Segment   
	from #eq b where #aa.party_Code=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
	and #aa.Segment=b.entity  

	/*****Insert into History table ********************/
	insert into tbl_AngelPGIMBOTransactionLog_EQ_FNO_CURR(RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,VerificationRemark,VerificationDate,LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,ReVerificationRemark,ReVerificationDate,ExtraField1,ExtraField2,ExtraField3,ExtraField4,ExtraField5,UpdatedDate)
	select RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,VerificationRemark,VerificationDate,LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,ReVerificationRemark,ReVerificationDate,ExtraField1,ExtraField2,ExtraField3,ExtraField4,ExtraField5,getdate()
	  from  tbl_AngelPGIMBOTransactionLog where Segment='EQUITY+FNO+CURRENCY' and 
	logdate>=convert(varchar(10), getdate()-1,120) and VerificationRemark='SUCCESS' 

	/******Update Main Log Table***************************************************/
	update tbl_AngelPGIMBOTransactionLog set Segment=b.Segment   
	from #eq b where tbl_AngelPGIMBOTransactionLog.party_Code=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
	and tbl_AngelPGIMBOTransactionLog.Segment=b.entity  

	select a.*,b.ddno into #qq from #aa a join anand.MKTAPI.dbo.tbl_post_data b on a.party_code=b.cltcode and a.TransactionReferenceNo=b.ddno 
	and RETURN_FLD1='ACCOUNT NO MISSING' and 
	ROWSTATE=99 and RETURN_FLD5='IH_Aggregator' and EXCHANGE='' and b.SEGMENT='' and  a.Segment<>'EQUITY+FNO+CURRENCY'

	----////Delete //-------

	select a.* into #main from  
	anand.MKTAPI.dbo.tbl_post_data a
	INNER JOIN #qq b
	on a.ddno=b.DDNO
	and a.CLTCODE=b.party_code

	DELETE a
	FROM anand.MKTAPI.dbo.tbl_post_data a
	INNER JOIN #qq b
	on a.ddno=b.DDNO
	and a.CLTCODE=b.party_code


	update #main set exchange=(Case                               
	When b.segment='BSE EQUITIES' then 'BSE'                                                                                                                           
	When b.segment='NSE DERIVATIVES' then 'NSE'                                
	When b.segment='NSE EQUITIES' then 'NSE'                                                                                                  
	else '' end),
	segment=(Case                               
	when b.segment='BSE EQUITIES' then 'CAPITAL'                               
	when b.segment='NSE EQUITIES' then 'CAPITAL'                               
	when b.segment='NSE DERIVATIVES' then 'FUTURES'                                                                                              
	else '' end)
	,RETURN_FLD1=null,rowstate=0
	from #qq b where #main.cltcode=b.party_Code 
	and #main.ddno=b.TransactionReferenceNo  

	--------////Again Insert main table//////----------
	insert into anand.MKTAPI.dbo.tbl_post_data   
	(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,ROWSTATE)                    
	select   
	VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,  
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD4,RETURN_FLD5,  
	ROWSTATE from #main  

	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'Agg_Segment_Missing_In_BO',getdate()

	drop table #client_Details
	drop table #aa
	drop table #main
	drop table #qq	
                        
end                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_SEND_Email_BankReceiptFile
-- --------------------------------------------------
CREATE Proc [dbo].[AGG_SEND_Email_BankReceiptFile]                
AS                  
BEGIN                  
             
                   
 DECLARE @HTMLBODY1 VARCHAR(8000), @MESS AS VARCHAR(4000),@filename as varchar(100)            
 /*select @filename='d:\upload1\Aggregator\FundsPayinJV_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'       */
 
 select @filename='I:\upload1\Aggregator\FundsPayinJV_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                 
 
 
 /*print @filename */            
            
 truncate table AGG_BO_BankReceipt_temp                  
 insert into AGG_BO_BankReceipt_temp                  
 select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,            
 Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo                
 from AGG_BO_BankReceipt with (nolock) where updation_status is null and responsecode is not null   
 order by Segment,cltcode                
                
 if (select count(1) from AGG_BO_BankReceipt_temp)  > 0                
 Begin                
            
  BEGIN TRY             
   declare @s1 as varchar(1000)            
   set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Segment,CliAccountNo FROM INTRANET.accounts.dbo.AGG_BO_BankReceipt_temp order by Segment,cltcode" queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                                         
   set @s1= @s1+''''                
   Exec (@s1)             
                  
   /*            
    EXEC MASTER.dbo.xp_cmdshell                  
    ' bcp "SELECT [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Segment,CliAccountNo FROM INTRANET.accounts.dbo.AGG_BO_BankReceipt_temp   where updation_status is null order 
  
    
      
        
          
by Segment,cltcode " queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '                  
   */            
                      
    DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX)                    
    SET @TO = 'pay-inbanking@angelbroking.com'                
    SET @CC = 'hirakp.parikh@angelbroking.com'                
    SET @BCC = 'renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com'                
                      
    SET @MESS = 'Dear All,<BR /><BR /> Incremental Funds Payin Details for all segment for your reference.<br><Br>Angel Broking'                  
    EXEC MSDB.DBO.SP_SEND_DBMAIL                  
    @RECIPIENTS = @TO,                  
    @COPY_RECIPIENTS = @CC,                  
   -- @BLIND_COPY_RECIPIENTS = @BCC,    
    @PROFILE_NAME = 'Angelbroking',                  
    @BODY_FORMAT ='HTML',                  
    @SUBJECT = 'Aggregator: Funds Payin Details (BO Posted)' ,                  
    @BODY =@mess,                  
    @file_attachments = @filename            
                   
            
    update AGG_BO_BankReceipt set Updation_status ='emailed',Updation_Flag='Y',updation_time=getdate() from                 
    AGG_BO_BankReceipt_temp b where   AGG_BO_BankReceipt.DDno=B.ddno                
    and AGG_BO_BankReceipt.cltcode=b.cltcode               
                        
  END TRY                      
  BEGIN CATCH             
   SET @MESS='<BR><BR> ERROR in triggering email for Funds Payin (Aggregator). Kindly contract System Adminstrator to resolve the issue.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'            
   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                      
   @RECIPIENTS ='neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com',            
   @COPY_RECIPIENTS = 'renil.pillai@angelbroking.com',                      
   @PROFILE_NAME = 'Angelbroking',             
   @BODY_FORMAT ='HTML',                  
   @SUBJECT = 'ERROR !! Aggregator: Funds Payin Details.',                      
   @FILE_ATTACHMENTS ='',                    
   @BODY =@MESS                      
  END CATCH                 
            
 End                
                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_SEND_Email_BankReceiptFile_Rejected
-- --------------------------------------------------
   
CREATE Proc [dbo].[AGG_SEND_Email_BankReceiptFile_Rejected]                      
AS                        
BEGIN                        
                   
                         
 DECLARE @HTMLBODY1 VARCHAR(8000), @MESS AS VARCHAR(4000),@filename as varchar(100)                  
 /*select @filename='d:\upload1\Aggregator\FundsPayinRejected_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'             */     
 select @filename='I:\upload1\Aggregator\FundsPayinRejected_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                  
 /*print @filename */                  
                  
 truncate table AGG_MKTAPI_tblpostdate         
 insert into AGG_MKTAPI_tblpostdate                      
 select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,        
 BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,        
 MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE        
 from tbl_post_data with (nolock)         
 --where rowstate <> 2
  where rowstate =99 --and SEGMENT <> '' 
  and return_fld5='IH_Aggregator' and vdate >= CONVERT(varchar(11),getdate())        
 order by Segment,cltcode                      
                      
 if (select count(1) from AGG_MKTAPI_tblpostdate)  > 0                      
 Begin                      
                  
  BEGIN TRY                   
   declare @s1 as varchar(1000)                  
   set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE FROM INTRANET.accounts.dbo.AGG_MKTAPI_tblpostdate order by Segment,cltcode" queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                           
  
   set @s1= @s1+''''                      
   Exec (@s1)                   
                        
   /*                  
    EXEC MASTER.dbo.xp_cmdshell                        
    ' bcp "SELECT [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Segment,CliAccountNo FROM INTRANET.accounts.dbo.AGG_BO_BankReceipt_temp   where updation_status is null order 
  
    
      
        
          
            
              
                
by Segment,cltcode " queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '                        
   */                  
                            
    DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX)                          
    SET @TO = 'pay-inbanking@angelbroking.com'                      
    SET @CC = 'hirakp.parikh@angelbroking.com;pranita@angelbroking.com;sajeev@angelbroking.com'                      
    SET @BCC = 'renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com'                      
      
    SET @MESS = 'Dear All,<BR /><BR /> Incremental Funds Payin Details for all segment for your reference.<br><Br>Angel Broking'                        
    EXEC MSDB.DBO.SP_SEND_DBMAIL                        
    @RECIPIENTS = @TO,                        
    @COPY_RECIPIENTS = @CC,                        
  --  @BLIND_COPY_RECIPIENTS = @BCC,          
    @PROFILE_NAME = 'Angelbroking',                        
    @BODY_FORMAT ='HTML',                        
    @SUBJECT = 'Aggregator: Funds Payin Details (BO Rejected)' ,                        
    @BODY =@mess,                        
    @file_attachments = @filename                  
                         
  END TRY                            
  BEGIN CATCH                   
   SET @MESS='<BR><BR> ERROR in triggering email for Funds Payin (Aggregator). Kindly contract System Adminstrator to resolve the issue.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                  
   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
   @RECIPIENTS ='renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com',                  
   @COPY_RECIPIENTS = 'renil.pillai@angelbroking.com',                           
   @PROFILE_NAME = 'Angelbroking',                        
   @BODY_FORMAT ='HTML',                        
   @SUBJECT = 'ERROR !! Aggregator: Funds Payin Details.  (BO Rejected)',                            
   @FILE_ATTACHMENTS ='',                          
   @BODY =@MESS                            
  END CATCH                       
                  
 End                      
                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_SEND_Email_BO_Rejected
-- --------------------------------------------------
   
CREATE Proc [dbo].[AGG_SEND_Email_BO_Rejected]                      
AS                        
BEGIN                        
                   
                         
 DECLARE @HTMLBODY1 VARCHAR(8000), @MESS AS VARCHAR(4000),@filename as varchar(100)                  
 select @filename='I:\upload1\Aggregator\FundsPayinNotInBO\FundsRejectedInBO_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                  
 /*print @filename */                  
             
 truncate table AGG_MKTAPI_NotPostedIn_BO         
 insert into AGG_MKTAPI_NotPostedIn_BO                      
 select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,        
 BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,        
 MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE        
 from anand.MKTAPI.dbo.tbl_post_data  where EXCHANGE='' and SEGMENT=''  
 --where rowstate <> 2
  and rowstate =99 --and SEGMENT <> '' 
  and return_fld5='IH_Aggregator' and vdate >= CONVERT(varchar(11),getdate())        
 order by Segment,cltcode                      
                      
 if (select count(1) from AGG_MKTAPI_NotPostedIn_BO)  > 0                      
 Begin                      
                  
  BEGIN TRY                   
   declare @s1 as varchar(1000)                  
   set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE FROM INTRANET.accounts.dbo.AGG_MKTAPI_NotPostedIn_BO order by Segment,cltcode" queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                           
  
   set @s1= @s1+''''                      
   Exec (@s1)                   
                        
   /*                  
    EXEC MASTER.dbo.xp_cmdshell                        
    ' bcp "SELECT [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Segment,CliAccountNo FROM INTRANET.accounts.dbo.AGG_BO_BankReceipt_temp   where updation_status is null order 
  
    
      
        
          
            
              
                
by Segment,cltcode " queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '                        
   */                  
                            
    DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX)                          
    SET @TO = 'pay-inbanking@angelbroking.com;archana.shah@angelbroking.com;sagar.soner@angelbroking.com;prashant.padhi@angelbroking.com'                      
    SET @CC = 'dinesh.g@angelbroking.com;sajeev@angelbroking.com'                      
    SET @BCC = 'renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com'                      
      
    SET @MESS = 'Dear All,<BR /><BR /> Incremental Funds Payin Details rejected from BO for your reference.<br><Br>Angel Broking'                        
    EXEC MSDB.DBO.SP_SEND_DBMAIL                        
    @RECIPIENTS = @TO,                        
    @COPY_RECIPIENTS = @CC,                        
   -- @BLIND_COPY_RECIPIENTS = @BCC,          
    @PROFILE_NAME = 'Angelbroking',                        
    @BODY_FORMAT ='HTML',                        
    @SUBJECT = 'Aggregator:Online Entry not updated into BO due to File splitting issue' ,                        
    @BODY =@mess,                        
    @file_attachments = @filename                  
                         
  END TRY                            
  BEGIN CATCH                   
   SET @MESS='<BR><BR> ERROR in triggering email for Funds Payin (Aggregator). Kindly contract System Adminstrator to resolve the issue.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                  
   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
   @RECIPIENTS ='renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com',                  
   @COPY_RECIPIENTS = 'Rohit.Patil@angelbroking.com',                           
   @PROFILE_NAME = 'Angelbroking',                        
   @BODY_FORMAT ='HTML',                        
   @SUBJECT = 'ERROR !! Aggregator: Online Entry not updated into BO due to File splitting issue',                            
   @FILE_ATTACHMENTS ='',                          
   @BODY =@MESS                            
  END CATCH                       
                  
 End                      
                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_SEND_Email_RejectedFileWithRowState0
-- --------------------------------------------------
CREATE Proc [dbo].[AGG_SEND_Email_RejectedFileWithRowState0]                        
AS                          
BEGIN                          
                     
                           
 DECLARE @HTMLBODY1 VARCHAR(8000), @MESS AS VARCHAR(4000),@filename as varchar(100)                    
 /*select @filename='d:\upload1\Aggregator\FundsPayinRejectedRowStateWise_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'             */
 select @filename='I:\upload1\Aggregator\FundsPayinRejectedRowStateWise_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                    
 /*print @filename */                    

                    
 truncate table AGG_tblpostdataWithZeroRowState           
 insert into AGG_tblpostdataWithZeroRowState                        
 select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,          
 BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,          
 MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE          
 from tbl_post_data with (nolock)           
 where rowstate = 0 and return_fld5='IH_Aggregator' and vdate >= CONVERT(varchar(11),getdate())          
 order by Segment,cltcode                        
                        
 if (select count(1) from AGG_tblpostdataWithZeroRowState)  > 0                        
 Begin                        
                    
  BEGIN TRY                     
   declare @s1 as varchar(1000)                    
   set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE FROM INTRANET.accounts.dbo.AGG_tblpostdataWithZeroRowState order by Segment,cltcode" queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                  

           
    
    
    
   set @s1= @s1+''''                        
   Exec (@s1)                     
                          
   /*                    
    EXEC MASTER.dbo.xp_cmdshell                          
    ' bcp "SELECT [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Segment,CliAccountNo FROM INTRANET.accounts.dbo.AGG_BO_BankReceipt_temp   where updation_status is null order 

  
    
      
        
          
            
              
                
                  
by Segment,cltcode " queryout '+@filename+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '                          
   */                    
                              
    DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX)                            
    SET @TO ='neha.naiwar@angelbroking.com'--'pay-inbanking@angelbroking.com'                        
    SET @CC ='neha.naiwar@angelbroking.com' --'hirakp.parikh@angelbroking.com;pranita@angelbroking.com;sajeev@angelbroking.com'                        
    SET @BCC = 'renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com'                        
        
    SET @MESS = 'Dear All,<BR /><BR /> Incremental Funds Payin Details for all segment for your reference with row state 0.<br><Br>Angel Broking'                          
    EXEC MSDB.DBO.SP_SEND_DBMAIL                          
    @RECIPIENTS = @TO,                          
    @COPY_RECIPIENTS = @CC,                          
    @BLIND_COPY_RECIPIENTS = @BCC,            
    @PROFILE_NAME = 'Angelbroking',                          
    @BODY_FORMAT ='HTML',                          
    @SUBJECT = 'ALERT !! Aggregator: Funds Payin Details(BO Rejected With RowState 0).',  
    @BODY =@mess,                          
    @file_attachments = @filename                    
 
  END TRY                              
  BEGIN CATCH                     
   SET @MESS='<BR><BR> ERROR in triggering email for Funds Payin (Aggregator). Kindly contract System Adminstrator to resolve the issue.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                    
   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
   @RECIPIENTS ='neha.naiwar@angelbroking.com;Rohit.Patil@angelbroking.com',                    
   @COPY_RECIPIENTS = 'renil.pillai@angelbroking.com',                             
   @PROFILE_NAME = 'Angelbroking',                          
   @BODY_FORMAT ='HTML',                          
   @SUBJECT = 'ERROR !! Aggregator: Funds Payin Details.  (BO Rejected With RowState 0)',                              
   @FILE_ATTACHMENTS ='',                            
   @BODY =@MESS                              
  END CATCH                         
                    
 End                        
                          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_TechH2HReport
-- --------------------------------------------------
  
CREATE proc [dbo].[Agg_TechH2HReport]  
(  
@FromDate varchar(25),   
@ToDate varchar(25),              
@access_to varchar(30),                      
@access_code varchar(30)  
)  
as   
BEGIN  
  select distinct * into #bb from Agg_TechTrnasctionSplitData with(nolock) where  
  convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and  
  convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'      
  order by tpsl_txn_time    
    
  select Party_Code,Amount,LogDate,Vendor,TransactionMerchantID,TransactionReferenceNo into #aa from   
 tbl_AngelPGIMBOTransactionLog with(nolock) where  LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'   
 and  LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'  
 union all  
 select Party_Code,Amount,LogDate,Vendor,TransactionMerchantID,TransactionReferenceNo from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog with(nolock)  
 where LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'   
 and  LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'  
 union all  
 select Client_Code,Amount,TransReq_dtm,'Direct' as Vendor,InternalRef_No as TransactionMerchantID,BankRef_No as TransactionReferenceNo  
 from [ABVSAWUARQ1].Angel_Admin.dbo.PG_Transaction with(nolock) WHERE    
 TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'  
 and TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'   
   
 select a.*,b.logdate into #main from #bb a left join #aa b on  a.clnt_txn_ref=b.TransactionMerchantID /*a.tpsl_txn_id=b.TransactionReferenceNo*/  
    
  select distinct txn_msg As [Status],clnt_txn_ref as [Transaction Marchent ID],tpsl_bank_cd as [TPSL BankCode],tpsl_txn_id as [Transaction ReferanceNo.],  
  txn_amt as [Amount],clnt_rqst_meta as [Clientcode],tpsl_txn_time as [Transaction(Actual) Datetime],[LastUpDateTime] as [Updated Datetime],tpsl_rfnd_id as [RefID],bal_amt as [Bal amount],  
  BankTransactionID,LID  
  from #main  ---where  logdate is not  null      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_TechH2HReport_21Feb2018
-- --------------------------------------------------

CREATE proc [dbo].[Agg_TechH2HReport_21Feb2018]
(
@FromDate varchar(25), 
@ToDate varchar(25),            
@access_to varchar(30),                    
@access_code varchar(30)
)
as 
BEGIN
	 select distinct * into #main from Agg_TechTrnasctionSplitData where
	 convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and
	 convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'    
	 order by tpsl_txn_time  
	 
	 select distinct txn_msg As [Status],clnt_txn_ref as [Transaction Marchent ID],tpsl_bank_cd as [TPSL BankCode],tpsl_txn_id as [Transaction ReferanceNo.],
	 txn_amt as [Amount],clnt_rqst_meta as [Clientcode],tpsl_txn_time as [Transaction Datetime],tpsl_rfnd_id as [RefID],bal_amt as [Bal amount],
	 BankTransactionID
	 from #main     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Agg_TechH2HReport_backup05March2018
-- --------------------------------------------------

create proc [dbo].[Agg_TechH2HReport_backup05March2018]
(
@FromDate varchar(25), 
@ToDate varchar(25),            
@access_to varchar(30),                    
@access_code varchar(30)
)
as 
BEGIN
	 select distinct * into #bb from Agg_TechTrnasctionSplitData with(nolock) where
	 convert(datetime,tpsl_txn_time,103)>=replace(CONVERT(VARCHAR(19),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and
	 convert(datetime,tpsl_txn_time,103) <=replace(CONVERT(VARCHAR(19),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'    
	 order by tpsl_txn_time  
	 
	 select Party_Code,Amount,LogDate,Vendor,TransactionMerchantID,TransactionReferenceNo into #aa from 
	tbl_AngelPGIMBOTransactionLog with(nolock) where  LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
	and  LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
	union all
	select Party_Code,Amount,LogDate,Vendor,TransactionMerchantID,TransactionReferenceNo from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog with(nolock)
	where LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
	and  LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
	union all
	select Client_Code,Amount,TransReq_dtm,'Direct' as Vendor,InternalRef_No as TransactionMerchantID,BankRef_No as TransactionReferenceNo
	from [172.31.16.75].Angel_Admin.dbo.PG_Transaction with(nolock) WHERE  
	TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
	and TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
	
	select a.*,b.logdate into #main from #bb a left join #aa b on  a.clnt_txn_ref=b.TransactionMerchantID /*a.tpsl_txn_id=b.TransactionReferenceNo*/
	 
	 select distinct txn_msg As [Status],clnt_txn_ref as [Transaction Marchent ID],tpsl_bank_cd as [TPSL BankCode],tpsl_txn_id as [Transaction ReferanceNo.],
	 txn_amt as [Amount],clnt_rqst_meta as [Clientcode],logdate as [Transaction(Actual) Datetime],tpsl_txn_time as [Updated Datetime],tpsl_rfnd_id as [RefID],bal_amt as [Bal amount],
	 BankTransactionID
	 from #main  where  logdate is not  null    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_BOstatingTable_BankReceipt
-- --------------------------------------------------
      
CREATE Procedure [dbo].[AGG_UPD_BOstatingTable_BankReceipt]                              
as                              
Set Nocount on  
SEt Xact_abort on  
BEGIN TRY                          
              
/* 11 secs */                      
exec testdb.dbo.Update_CliFundsTrf                      
                
select * into #file1                               
from testdb.dbo.temp_mis_file1a with (nolock)                              
where sDateTime>= convert(varchar(11),getdate()-2)                       
/* and product not in ('Angeltrade','AngelDiet') */                      
                    
/*                              
insert into #file1(sLoginId,sUserDefinedExchangeName,nAmount,sDateTime,nTxnRefNo,sBankId,sAgencyId,sFromAccNo)                              
select                               
PArty_Code,                              
(Case                               
When segment='BSE EQUITIES' then 'BSECM'                              
When segment='MCX FUTURES' then 'MCX'                              
When segment='MCXSX CURRENCY FUTURES' then 'MCXSX'                              
When segment='NCDEX FUTURES' then 'NCDEX'                              
When segment='NSE DERIVATIVES' then 'NSEFO'                              
When segment='NSE EQUITIES' then 'NSECM'                              
When segment='NSECDS' then 'NSECD'                              
else '' end) as segment,Amount,Logdate,TransactionReferenceNo,BankName,vendor,BankAccountNo                              
from tbl_AngelPGIMBOTransactionLog where transactionStatus='Success' and logdate>=convert(varchar(11),getdate())                              
and TransactionReferenceNo not in (select nTxnRefNo from #file1)                              
*/                              
              
delete from #file1 where sdateTime < 'Oct  8 2014'                                      
/*              
select * from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                              
select b.* into AGG_BO_BankReceipt_08102014 from #file1 a, AGG_BO_BankReceipt b where a.NtxnRefNo=b.ddno              
delete from AGG_BO_BankReceipt where ddno in (select NtxnRefNo from #file1 )              
select * from AGG_BO_BankReceipt where ddno in (select NtxnRefNo from #file1 )              
select* into tbl_post_data_08102014 from tbl_post_data where vdate>='Oct  8 2014'            
delete from tbl_post_data where vdate>='Oct  8 2014'            
            
*/              
delete from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                                   
/*-----*/                              
/*                      
select * from AGG_BO_BankReceipt with (nolock)                      
                      
update AGG_BO_BankReceipt set AGG_BO_BankReceipt.DDno=b.DDNO from                      
(                      
select *,                       
DDNO=(case when vendor='PAYNETZ' then ExtraField2 else transactionMerchantID end)                       
from Accounts.dbo.tbl_AngelPGIMBOTransactionLog with (nolock)                       
where logdate>=convert(varchar(11),getdate()) and verificationRemark='Success'                       
and TransactionVerified='Y'                      
) b                       
where b.transactionMerchantID=AGG_BO_BankReceipt.ddno                      
and temp_mis_file1a.sBankId='ATOMPG'                  
                
*/                      
select * into #BOFile from AGG_BO_BankReceipt where 'a'='b'                              
                        
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                              
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                              
convert(varchar(10),sdateTime,103) as Edate,                              
convert(varchar(10),sdateTime,103) as Vdate,         
sLoginid as Cltcode,                              
nAmount as Amount,                              
'C' as DRCR,                   
/* 'BEING AMT RECD TECH PROCESS' as Narration,  */        
/*'BEING AMT RECD TECH PROCESS' as Narration,*/ /*commented on 11 dec 2014*/    
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,                        
/*'03014' as BankCode,*/                 
(case                
When sUserDefinedExchangeName='MCXSX' then '03032'                
when sUserDefinedExchangeName='NSECD' then '03032' 
when sUserDefinedExchangeName='BSEMFSS' then '03014'             
when sUserDefinedExchangeName='IPO' then '03027' 
when sUserDefinedExchangeName='NBFC' then '300003'   
else '03014' end) as BankCode,                           
/* 'ICICI BANK' as  BankName, */                          
sbankid as BankName,                          
nTxnRefNo as DDno,                      
'HO' as Branchcode,                              
'ALL' as Chqmode,                              
convert(varchar(10),sdateTime,103) as chqdate,                            
/* 'ICICI BANK' as chqname, */                          
sbankid as chqname,                          
'L' as Clmode,                              
GeneratedOn=getdate(),                              
Updation_Type='O',                              
Updation_flag='N',                              
getdate(),                              
sUserDefinedExchangeName,                              
sFromAccno                              
from #file1 where sAgencyID='TECHPROCESS'                              
                          
                          
                              
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                              
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                              
convert(varchar(10),sdateTime,103) as Edate,                              
convert(varchar(10),sdateTime,103) as Vdate,                              
sLoginid as Cltcode,                              
nAmount as Amount,                              
'C' as DRCR,                              
/*'BEING AMT RECD PAYNETZ' as Narration,   */               
/*'BEING AMT RECD TECH PROCESS' as Narration,*/    
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,  /*commented on 11 dec 2014*/                  
--'02020' as BankCode,                
 (case                
 When sUserDefinedExchangeName='MCXSX' then '02014'                
 when sUserDefinedExchangeName='NSECD' then '02014'                
 when sUserDefinedExchangeName='NSEFO' then '1000005'
 when sUserDefinedExchangeName='BSEMFSS' then '02014'    
 when sUserDefinedExchangeName='IPO' then '02019' 
 when sUserDefinedExchangeName='NBFC' then '300002'                          
 else '02020' end) as BankCode,                             
 /* 'HDFC BANK' as  BankName, */                          
sbankid as BankName,                           
nTxnRefNo as DDno,                              
'HO' as Branchcode,                              
'ALL' as Chqmode,                              
convert(varchar(10),sdateTime,103) as chqdate,                              
/* 'HDFC BANK' as chqname, */                          
sbankid as chqname,                             
'L' as Clmode,                      
GeneratedOn=getdate(),                              
Updation_Type='O',                              
Updation_flag='N',                              
getdate(),                              
sUserDefinedExchangeName,                              
sFromAccno                              
from #file1 where sAgencyID='PAYNETZ'                              

/*Added to handle duplicate entries by Renil Pillai on 15th June 2015*/
delete x from  #BOFile x  where exists
(select * from AGG_BO_BankReceipt y where x.vdate=y.vdate and x.edate=y.edate and x.cltcode=y.cltcode
and x.amount=y.amount and x.drcr=y.drcr and x.ddno=y.ddno and x.chqdate=y.chqdate and x.chqname=y.chqname 
and x.segment=y.segment and x.cliaccountno=y.cliaccountno)
                              
insert into AGG_BO_BankReceipt select * from #BOFile  

                              
/* insert into anand1.msajag.dbo.tbl_post_data */                              
/* delete from tbl_post_data where VDATE>='Oct  1 2014' */              
                          
insert into tbl_post_data                               
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,
BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld5,ROWSTATE)                        
  
     
     
select                               
VoucherType=2,[Sr no],                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as VDATE,                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as EDATE,                              
CLTCODE,                          
(Case when DRCR='C' then Amount else 0 end) as CreditAmt,                              
(Case when DRCR='D' then Amount else 0 end) as DebitAmt,                              
Narration,BankCode,'',BankName,'',Branchcode,DDno,'A' as Chqmode,                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as ChequeDate,                              
chqname,Clmode,CliAccountNo,                              
(Case                               
when segment='BSECM' then 'BSE'                               
when segment='NSECM' then 'NSE'                               
when segment='NSEFO' then 'NSE'                               
when segment='BSEFO' then 'BSE'                               
when segment='MCX' then 'MCX'                               
when segment='NCDEX' then 'NCX'                               
when segment='NSECD' then 'NSX'                               
when segment='MCXSX' then 'MCD'
when segment='BSEMFSS' then 'BSE' 
when segment='NSEMFSS' then 'NSE'
when segment='IPO' then 'NSE' 
when segment='NBFC' then 'NBF'                                                                 
else '' end) as exchange,                              
(Case                               
when segment='BSECM' then 'CAPITAL'                               
when segment='NSECM' then 'CAPITAL'                               
when segment='NSEFO' then 'FUTURES'                               
when segment='BSEFO' then 'FUTURES'                               
when segment='MCX' then 'FUTURES'                               
when segment='NCDEX' then 'FUTURES'                               
when segment='NSECD' then 'FUTURES'                               
when segment='MCXSX' then 'FUTURES'
when segment='BSEMFSS' then 'MFSS' 
when segment='NSEMFSS' then 'MFSS'
when segment='IPO' then 'CAPITAL'
when segment='NBFC' then 'NBFC'                                    
else '' end) as segment,MKCK_FLAG=1,                          
'IH_Aggregator' as TAG,0                             
from                               
#BOFile with (nolock)                              
                          
              
---Insert data into Backoffice API  :: START                          
  
--Added by Neha --Start    
--declare @fileNametest as varchar(max)    
    
--  select @fileNametest='d:\AggretorTest\agg'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'    
    
--      declare @s1test as varchar(1000)                  
--   set @s1test = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from  accounts.dbo.Temp_BOFile" queryout '+@fileNametest+' -T -c -t,'                                                                               
--   set @s1test= @s1test+''''                      
--   exec (@s1test)  
insert into Temp_BOFile_test([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo,Uploaded_date)          
 select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,
 Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,
 Updation_Time,ResponseCode,Segment,CliAccountNo,getdate()  from #BOFile                       
----Added by Neha --end    
          
truncate table Temp_BOFile          
insert into Temp_BOFile([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo)          
select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,
chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo from #BOFile a
/*Added on 04/07/2016 to handle duplicated entries in MKT API*/
where not exists (select * from Temp_BOFile b with (nolock) where a.Cltcode=b.Cltcode and a.DDno=b.DDno)            
              
exec GBL_PushLedgerAPIinBO                          
                          
update AGG_BO_BankReceipt set ResponseCode=b.Return_fld3 from tbl_post_data b with (nolock)            
where AGG_BO_BankReceipt.cltcode=b.cltcode             
and AGG_BO_BankReceipt.ddno=b.ddno and /* AGG_BO_BankReceipt.vdate=b.vdate */                          
convert(datetime,substring(AGG_BO_BankReceipt.vdate,4,3)+substring(AGG_BO_BankReceipt.vdate,1,3)+substring(AGG_BO_BankReceipt.vdate,7,4))=b.vdate                          
            
---Insert data into Backoffice API  :: END               
              
                            
exec AGG_SEND_Email_BankReceiptFile                   
exec AGG_SEND_Email_BankReceiptFile_Rejected            
                  
                  
 --UPDATE VERIFICATION PROCCESS END DATE AFTER COMPLITION OF VERIFICATION SERVICE.                   
                     
   DECLARE @SRNO INT                     
   DECLARE @LatestCnt INT                  
                      
 --IT TAKES THE LATEST COUNT OF TODAY'S VERIFICATION RECORDS FROM tbl_AngelPGIMBOTransactionLog.                   
                      
   SET @LatestCnt = (SELECT COUNT(*)a FROM tbl_AngelPGIMBOTransactionLog                   
   WHERE LogDate >= CONVERT( DATETIME, (CONVERT(VARCHAR(10),GETDATE(),21)+ ' 00:00:00.000')))                  
                   
 --IT WILL TAKE THE LAST INSERTED RECORD'S SRNO.                     
   SET  @SRNO  = (select MAX(SRNO)SRNO from tbl_VERIFICATION_STATUS)                  
                   
 --UPDATE THE Service End Date AND Verification Count into tbl_VERIFICATION_STATUS.                  
   UPDATE tbl_VERIFICATION_STATUS                  
   SET Service_End_Date=GETDATE(),Verification_Cnt=@LatestCnt WHERE SRNO= @SRNO                            
                      
End try               
BEGIN CATCH                  
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                    
 select GETDATE(),'GBL_NSECM_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                    
    
 DECLARE @ErrorMessage NVARCHAR(4000);                                  
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                  
 RAISERROR (@ErrorMessage , 16, 1);           
                                       
End catch              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_BOstatingTable_BankReceipt_04072016
-- --------------------------------------------------
      
Create Procedure [dbo].[AGG_UPD_BOstatingTable_BankReceipt_04072016]                              
as                              
Set Nocount on  
SEt Xact_abort on  
BEGIN TRY                          
              
/* 11 secs */                      
exec testdb.dbo.Update_CliFundsTrf                      
                
select * into #file1                               
from testdb.dbo.temp_mis_file1a with (nolock)                              
where sDateTime>= convert(varchar(11),getdate()-2)                       
/* and product not in ('Angeltrade','AngelDiet') */                      
                    
/*                              
insert into #file1(sLoginId,sUserDefinedExchangeName,nAmount,sDateTime,nTxnRefNo,sBankId,sAgencyId,sFromAccNo)                              
select                               
PArty_Code,                              
(Case                               
When segment='BSE EQUITIES' then 'BSECM'                              
When segment='MCX FUTURES' then 'MCX'                              
When segment='MCXSX CURRENCY FUTURES' then 'MCXSX'                              
When segment='NCDEX FUTURES' then 'NCDEX'                              
When segment='NSE DERIVATIVES' then 'NSEFO'                              
When segment='NSE EQUITIES' then 'NSECM'                              
When segment='NSECDS' then 'NSECD'                              
else '' end) as segment,Amount,Logdate,TransactionReferenceNo,BankName,vendor,BankAccountNo                              
from tbl_AngelPGIMBOTransactionLog where transactionStatus='Success' and logdate>=convert(varchar(11),getdate())                              
and TransactionReferenceNo not in (select nTxnRefNo from #file1)                              
*/                              
              
delete from #file1 where sdateTime < 'Oct  8 2014'                                      
/*              
select * from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                              
select b.* into AGG_BO_BankReceipt_08102014 from #file1 a, AGG_BO_BankReceipt b where a.NtxnRefNo=b.ddno              
delete from AGG_BO_BankReceipt where ddno in (select NtxnRefNo from #file1 )              
select * from AGG_BO_BankReceipt where ddno in (select NtxnRefNo from #file1 )              
select* into tbl_post_data_08102014 from tbl_post_data where vdate>='Oct  8 2014'            
delete from tbl_post_data where vdate>='Oct  8 2014'            
            
*/              
delete from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                                   
/*-----*/                              
/*                      
select * from AGG_BO_BankReceipt with (nolock)                      
                      
update AGG_BO_BankReceipt set AGG_BO_BankReceipt.DDno=b.DDNO from                      
(                      
select *,                       
DDNO=(case when vendor='PAYNETZ' then ExtraField2 else transactionMerchantID end)                       
from Accounts.dbo.tbl_AngelPGIMBOTransactionLog with (nolock)                       
where logdate>=convert(varchar(11),getdate()) and verificationRemark='Success'                       
and TransactionVerified='Y'                      
) b                       
where b.transactionMerchantID=AGG_BO_BankReceipt.ddno                      
and temp_mis_file1a.sBankId='ATOMPG'                  
                
*/                      
select * into #BOFile from AGG_BO_BankReceipt where 'a'='b'                              
                        
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                              
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                              
convert(varchar(10),sdateTime,103) as Edate,                              
convert(varchar(10),sdateTime,103) as Vdate,         
sLoginid as Cltcode,                              
nAmount as Amount,                              
'C' as DRCR,                   
/* 'BEING AMT RECD TECH PROCESS' as Narration,  */        
/*'BEING AMT RECD TECH PROCESS' as Narration,*/ /*commented on 11 dec 2014*/    
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,                        
/*'03014' as BankCode,*/                 
(case                
When sUserDefinedExchangeName='MCXSX' then '03032'                
when sUserDefinedExchangeName='NSECD' then '03032' 
when sUserDefinedExchangeName='BSEMFSS' then '03014'             
when sUserDefinedExchangeName='IPO' then '03027' 
when sUserDefinedExchangeName='NBFC' then '300003'   
else '03014' end) as BankCode,                           
/* 'ICICI BANK' as  BankName, */                          
sbankid as BankName,                          
nTxnRefNo as DDno,                      
'HO' as Branchcode,                              
'ALL' as Chqmode,                              
convert(varchar(10),sdateTime,103) as chqdate,                            
/* 'ICICI BANK' as chqname, */                          
sbankid as chqname,                          
'L' as Clmode,                              
GeneratedOn=getdate(),                              
Updation_Type='O',                              
Updation_flag='N',                              
getdate(),                              
sUserDefinedExchangeName,                              
sFromAccno                              
from #file1 where sAgencyID='TECHPROCESS'                              
                          
                          
                              
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                              
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                              
convert(varchar(10),sdateTime,103) as Edate,                              
convert(varchar(10),sdateTime,103) as Vdate,                              
sLoginid as Cltcode,                              
nAmount as Amount,                              
'C' as DRCR,                              
/*'BEING AMT RECD PAYNETZ' as Narration,   */               
/*'BEING AMT RECD TECH PROCESS' as Narration,*/    
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,  /*commented on 11 dec 2014*/                  
--'02020' as BankCode,                
 (case                
 When sUserDefinedExchangeName='MCXSX' then '02014'                
 when sUserDefinedExchangeName='NSECD' then '02014'                
 when sUserDefinedExchangeName='NSEFO' then '1000005'
 when sUserDefinedExchangeName='BSEMFSS' then '02014'    
 when sUserDefinedExchangeName='IPO' then '02019' 
 when sUserDefinedExchangeName='NBFC' then '300002'                          
 else '02020' end) as BankCode,                             
 /* 'HDFC BANK' as  BankName, */                          
sbankid as BankName,                           
nTxnRefNo as DDno,                              
'HO' as Branchcode,                              
'ALL' as Chqmode,                              
convert(varchar(10),sdateTime,103) as chqdate,                              
/* 'HDFC BANK' as chqname, */                          
sbankid as chqname,                             
'L' as Clmode,                      
GeneratedOn=getdate(),                              
Updation_Type='O',                              
Updation_flag='N',                              
getdate(),                              
sUserDefinedExchangeName,                              
sFromAccno                              
from #file1 where sAgencyID='PAYNETZ'                              

/*Added to handle duplicate entries by Renil Pillai on 15th June 2015*/
delete x from  #BOFile x  where exists
(select * from AGG_BO_BankReceipt y where x.vdate=y.vdate and x.edate=y.edate and x.cltcode=y.cltcode
and x.amount=y.amount and x.drcr=y.drcr and x.ddno=y.ddno and x.chqdate=y.chqdate and x.chqname=y.chqname 
and x.segment=y.segment and x.cliaccountno=y.cliaccountno)
                              
insert into AGG_BO_BankReceipt select * from #BOFile  

                              
/* insert into anand1.msajag.dbo.tbl_post_data */                              
/* delete from tbl_post_data where VDATE>='Oct  1 2014' */              
                          
insert into tbl_post_data                               
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld5,ROWSTATE)                        
  
     
     
select                               
VoucherType=2,[Sr no],                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as VDATE,                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as EDATE,                              
CLTCODE,                          
(Case when DRCR='C' then Amount else 0 end) as CreditAmt,                              
(Case when DRCR='D' then Amount else 0 end) as DebitAmt,                              
Narration,BankCode,'',BankName,'',Branchcode,DDno,'A' as Chqmode,                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as ChequeDate,                              
chqname,Clmode,CliAccountNo,                              
(Case                               
when segment='BSECM' then 'BSE'                               
when segment='NSECM' then 'NSE'                               
when segment='NSEFO' then 'NSE'                               
when segment='BSEFO' then 'BSE'                               
when segment='MCX' then 'MCX'                               
when segment='NCDEX' then 'NCX'                               
when segment='NSECD' then 'NSX'                               
when segment='MCXSX' then 'MCD'
when segment='BSEMFSS' then 'BSE' 
when segment='NSEMFSS' then 'NSE'
when segment='IPO' then 'NSE' 
when segment='NBFC' then 'NBF'                                                                 
else '' end) as exchange,                              
(Case                               
when segment='BSECM' then 'CAPITAL'                               
when segment='NSECM' then 'CAPITAL'                               
when segment='NSEFO' then 'FUTURES'                               
when segment='BSEFO' then 'FUTURES'                               
when segment='MCX' then 'FUTURES'                               
when segment='NCDEX' then 'FUTURES'                               
when segment='NSECD' then 'FUTURES'                               
when segment='MCXSX' then 'FUTURES'
when segment='BSEMFSS' then 'MFSS' 
when segment='NSEMFSS' then 'MFSS'
when segment='IPO' then 'CAPITAL'
when segment='NBFC' then 'NBFC'                                    
else '' end) as segment,MKCK_FLAG=1,                          
'IH_Aggregator' as TAG,0                             
from                               
#BOFile with (nolock)                              
                          
              
---Insert data into Backoffice API  :: START                          
  
--Added by Neha --Start    
--declare @fileNametest as varchar(max)    
    
--  select @fileNametest='d:\AggretorTest\agg'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'    
    
--      declare @s1test as varchar(1000)                  
--   set @s1test = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from  accounts.dbo.Temp_BOFile" queryout '+@fileNametest+' -T -c -t,'                                                                               
--   set @s1test= @s1test+''''                      
--   exec (@s1test)  
insert into Temp_BOFile_test([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo,Uploaded_date)          
 select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo,getdate()  from #BOFile                       
----Added by Neha --end    
          
truncate table Temp_BOFile          
insert into Temp_BOFile([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo)          
select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo from #BOFile              
              
exec GBL_PushLedgerAPIinBO                          
                          
update AGG_BO_BankReceipt set ResponseCode=b.Return_fld3 from tbl_post_data b with (nolock)            
where AGG_BO_BankReceipt.cltcode=b.cltcode             
and AGG_BO_BankReceipt.ddno=b.ddno and /* AGG_BO_BankReceipt.vdate=b.vdate */                          
convert(datetime,substring(AGG_BO_BankReceipt.vdate,4,3)+substring(AGG_BO_BankReceipt.vdate,1,3)+substring(AGG_BO_BankReceipt.vdate,7,4))=b.vdate                          
            
---Insert data into Backoffice API  :: END               
              
                            
exec AGG_SEND_Email_BankReceiptFile                   
exec AGG_SEND_Email_BankReceiptFile_Rejected            
                  
                  
 --UPDATE VERIFICATION PROCCESS END DATE AFTER COMPLITION OF VERIFICATION SERVICE.                   
                     
   DECLARE @SRNO INT                     
   DECLARE @LatestCnt INT                  
                      
 --IT TAKES THE LATEST COUNT OF TODAY'S VERIFICATION RECORDS FROM tbl_AngelPGIMBOTransactionLog.                   
                      
   SET @LatestCnt = (SELECT COUNT(*)a FROM tbl_AngelPGIMBOTransactionLog                   
   WHERE LogDate >= CONVERT( DATETIME, (CONVERT(VARCHAR(10),GETDATE(),21)+ ' 00:00:00.000')))                  
                   
 --IT WILL TAKE THE LAST INSERTED RECORD'S SRNO.                     
   SET  @SRNO  = (select MAX(SRNO)SRNO from tbl_VERIFICATION_STATUS)                  
                   
 --UPDATE THE Service End Date AND Verification Count into tbl_VERIFICATION_STATUS.                  
   UPDATE tbl_VERIFICATION_STATUS                  
   SET Service_End_Date=GETDATE(),Verification_Cnt=@LatestCnt WHERE SRNO= @SRNO                            
                      
End try               
BEGIN CATCH                  
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                    
 select GETDATE(),'GBL_NSECM_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                    
    
 DECLARE @ErrorMessage NVARCHAR(4000);                                  
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                  
 RAISERROR (@ErrorMessage , 16, 1);           
                                       
End catch              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_BOstatingTable_BankReceipt_Atom
-- --------------------------------------------------
CREATE Procedure AGG_UPD_BOstatingTable_BankReceipt_Atom  
as  
set nocount on  
  
/*  
  
Get requried data into #file1  
  
*/  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,
'BEING AMT RECEIVED BY ONLINE TRF' as Narration, 
/*'BEING AMT RECD TECH PROCESS' as Narration,  */ /*commented on 17 dec 2014*/
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sAgencyID='PAYNETZ'  
  
/*  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NSECD' and sAgencyID='PAYNETZ'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='MCXSX' and sAgencyID='PAYNETZ'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='BSECM' and sAgencyID='PAYNETZ'   
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NSECM' and sAgencyID='PAYNETZ'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NCDEX' and sAgencyID='PAYNETZ'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='MCX' and sAgencyID='PAYNETZ'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'02020' as BankCode,  
'HDFC BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'HDFC BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NSEFO' and sAgencyID='PAYNETZ'  
*/  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_BOstatingTable_BankReceipt_pramod
-- --------------------------------------------------
    
CREATE Procedure [dbo].[AGG_UPD_BOstatingTable_BankReceipt_pramod]                            
as                            
set nocount on                       
            
/* 11 secs */                    
exec testdb.dbo.Update_CliFundsTrf                    
              
select * into #file1                             
from testdb.dbo.temp_mis_file1a with (nolock)                            
where sDateTime>= convert(varchar(11),getdate()-2)                     
/* and product not in ('Angeltrade','AngelDiet') */                    
                  
/*                            
insert into #file1(sLoginId,sUserDefinedExchangeName,nAmount,sDateTime,nTxnRefNo,sBankId,sAgencyId,sFromAccNo)                            
select                             
PArty_Code,                            
(Case                             
When segment='BSE EQUITIES' then 'BSECM'                            
When segment='MCX FUTURES' then 'MCX'                            
When segment='MCXSX CURRENCY FUTURES' then 'MCXSX'                            
When segment='NCDEX FUTURES' then 'NCDEX'                            
When segment='NSE DERIVATIVES' then 'NSEFO'                            
When segment='NSE EQUITIES' then 'NSECM'                            
When segment='NSECDS' then 'NSECD'                            
else '' end) as segment,Amount,Logdate,TransactionReferenceNo,BankName,vendor,BankAccountNo                            
from tbl_AngelPGIMBOTransactionLog where transactionStatus='Success' and logdate>=convert(varchar(11),getdate())                            
and TransactionReferenceNo not in (select nTxnRefNo from #file1)                            
*/                            
            
delete from #file1 where sdateTime < 'Oct  8 2014'                                    
/*            
select * from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                            
select b.* into AGG_BO_BankReceipt_08102014 from #file1 a, AGG_BO_BankReceipt b where a.NtxnRefNo=b.ddno            
delete from AGG_BO_BankReceipt where ddno in (select NtxnRefNo from #file1 )            
select * from AGG_BO_BankReceipt where ddno in (select NtxnRefNo from #file1 )            
select* into tbl_post_data_08102014 from tbl_post_data where vdate>='Oct  8 2014'          
delete from tbl_post_data where vdate>='Oct  8 2014'          
          
*/            
delete from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                                 
/*-----*/                            
/*                    
select * from AGG_BO_BankReceipt with (nolock)                    
                    
update AGG_BO_BankReceipt set AGG_BO_BankReceipt.DDno=b.DDNO from                    
(                    
select *,                     
DDNO=(case when vendor='PAYNETZ' then ExtraField2 else transactionMerchantID end)                     
from Accounts.dbo.tbl_AngelPGIMBOTransactionLog with (nolock)                     
where logdate>=convert(varchar(11),getdate()) and verificationRemark='Success'                     
and TransactionVerified='Y'                    
) b                     
where b.transactionMerchantID=AGG_BO_BankReceipt.ddno                    
and temp_mis_file1a.sBankId='ATOMPG'                
              
*/                    
select * into #BOFile from AGG_BO_BankReceipt where 'a'='b'                            
                      
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                            
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                            
convert(varchar(10),sdateTime,103) as Edate,                            
convert(varchar(10),sdateTime,103) as Vdate,                            
sLoginid as Cltcode,                            
nAmount as Amount,                            
'C' as DRCR,                 
/* 'BEING AMT RECD TECH PROCESS' as Narration,  */      
/*'BEING AMT RECD TECH PROCESS' as Narration,*/ /*commented on 11 dec 2014*/  
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,                      
/*'03014' as BankCode,*/               
(case              
When sUserDefinedExchangeName='MCXSX' then '03032'              
when sUserDefinedExchangeName='NSECD' then '03032'              
else '03014' end) as BankCode,                         
/* 'ICICI BANK' as  BankName, */                        
sbankid as BankName,                        
nTxnRefNo as DDno,                    
'HO' as Branchcode,                            
'ALL' as Chqmode,                            
convert(varchar(10),sdateTime,103) as chqdate,                          
/* 'ICICI BANK' as chqname, */                        
sbankid as chqname,                        
'L' as Clmode,                            
GeneratedOn=getdate(),                            
Updation_Type='O',                            
Updation_flag='N',                            
getdate(),                            
sUserDefinedExchangeName,                            
sFromAccno                            
from #file1 where sAgencyID='TECHPROCESS'                            
                        
                        
                            
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                            
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                            
convert(varchar(10),sdateTime,103) as Edate,                            
convert(varchar(10),sdateTime,103) as Vdate,                            
sLoginid as Cltcode,                            
nAmount as Amount,                            
'C' as DRCR,                            
/*'BEING AMT RECD PAYNETZ' as Narration,   */             
/*'BEING AMT RECD TECH PROCESS' as Narration,*/  
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,  /*commented on 11 dec 2014*/                
--'02020' as BankCode,              
 (case              
 When sUserDefinedExchangeName='MCXSX' then '02014'              
 when sUserDefinedExchangeName='NSECD' then '02014'              
 when sUserDefinedExchangeName='NSEFO' then '1000005'              
 else '02020' end) as BankCode,                           
 /* 'HDFC BANK' as  BankName, */                        
sbankid as BankName,                         
nTxnRefNo as DDno,                            
'HO' as Branchcode,                            
'ALL' as Chqmode,                            
convert(varchar(10),sdateTime,103) as chqdate,                            
/* 'HDFC BANK' as chqname, */                        
sbankid as chqname,                           
'L' as Clmode,                    
GeneratedOn=getdate(),                            
Updation_Type='O',                            
Updation_flag='N',                            
getdate(),                            
sUserDefinedExchangeName,                            
sFromAccno                            
from #file1 where sAgencyID='PAYNETZ'                            
                            
insert into AGG_BO_BankReceipt select * from #BOFile                             
                            
/* insert into anand1.msajag.dbo.tbl_post_data */                            
/* delete from tbl_post_data where VDATE>='Oct  1 2014' */            
                        
insert into tbl_post_data                             
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld5,ROWSTATE)                        
   
   
select                             
VoucherType=2,[Sr no],                            
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as VDATE,                            
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as EDATE,                            
CLTCODE,                        
(Case when DRCR='C' then Amount else 0 end) as CreditAmt,                            
(Case when DRCR='D' then Amount else 0 end) as DebitAmt,                            
Narration,BankCode,'',BankName,'',Branchcode,DDno,'A' as Chqmode,                            
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as ChequeDate,                            
chqname,Clmode,CliAccountNo,                            
(Case                             
when segment='BSECM' then 'BSE'                             
when segment='NSECM' then 'NSE'                             
when segment='NSEFO' then 'NSE'                             
when segment='BSEFO' then 'BSE'                             
when segment='MCX' then 'MCX'                             
when segment='NCDEX' then 'NCX'                             
when segment='NSECD' then 'NSX'                             
when segment='MCXSX' then 'MCD'                             
else '' end) as exchange,                            
(Case                             
when segment='BSECM' then 'CAPITAL'                             
when segment='NSECM' then 'CAPITAL'                             
when segment='NSEFO' then 'FUTURES'                             
when segment='BSEFO' then 'FUTURES'                             
when segment='MCX' then 'FUTURES'                             
when segment='NCDEX' then 'FUTURES'                             
when segment='NSECD' then 'FUTURES'                             
when segment='MCXSX' then 'FUTURES'                             
else '' end) as segment,MKCK_FLAG=1,                        
'IH_Aggregator' as TAG,0                           
from                             
#BOFile with (nolock)                            
                        
            
---Insert data into Backoffice API  :: START    
--Added by Pramod --Start
declare @fileNametest as varchar(max)

  /*select @fileNametest='d:\AggretorTest\agg'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'*/
  
  select @fileNametest='I:\AggretorTest\agg'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'

      declare @s1test as varchar(1000)              
   set @s1test = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from  accounts.dbo.Temp_BOFile" queryout '+@fileNametest+' -T -c -t,'                                                                           
   set @s1test= @s1test+''''                  
   exec (@s1test)                      
----Added by Pramod --end        
truncate table Temp_BOFile        
insert into Temp_BOFile([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo)        
select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo from #BOFile            
            
exec GBL_PushLedgerAPIinBO                        
                        
update AGG_BO_BankReceipt set ResponseCode=b.Return_fld3 from tbl_post_data b with (nolock)          
where AGG_BO_BankReceipt.cltcode=b.cltcode           
and AGG_BO_BankReceipt.ddno=b.ddno and /* AGG_BO_BankReceipt.vdate=b.vdate */                        
convert(datetime,substring(AGG_BO_BankReceipt.vdate,4,3)+substring(AGG_BO_BankReceipt.vdate,1,3)+substring(AGG_BO_BankReceipt.vdate,7,4))=b.vdate                        
          
---Insert data into Backoffice API  :: END             
            
                          
exec AGG_SEND_Email_BankReceiptFile                 
exec AGG_SEND_Email_BankReceiptFile_Rejected          
                
                
 --UPDATE VERIFICATION PROCCESS END DATE AFTER COMPLITION OF VERIFICATION SERVICE.                 
                   
   DECLARE @SRNO INT                   
   DECLARE @LatestCnt INT                
                    
 --IT TAKES THE LATEST COUNT OF TODAY'S VERIFICATION RECORDS FROM tbl_AngelPGIMBOTransactionLog.                 
                    
   SET @LatestCnt = (SELECT COUNT(*)a FROM tbl_AngelPGIMBOTransactionLog                 
   WHERE LogDate >= CONVERT( DATETIME, (CONVERT(VARCHAR(10),GETDATE(),21)+ ' 00:00:00.000')))                
                 
 --IT WILL TAKE THE LAST INSERTED RECORD'S SRNO.                   
   SET  @SRNO  = (select MAX(SRNO)SRNO from tbl_VERIFICATION_STATUS)                
                 
 --UPDATE THE Service End Date AND Verification Count into tbl_VERIFICATION_STATUS.                
   UPDATE tbl_VERIFICATION_STATUS                
   SET Service_End_Date=GETDATE(),Verification_Cnt=@LatestCnt WHERE SRNO= @SRNO                          
                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_BOstatingTable_BankReceipt_successtransaction
-- --------------------------------------------------
CREATE Procedure [dbo].[AGG_UPD_BOstatingTable_BankReceipt_successtransaction]                              
as                              
Set Nocount on  
SEt Xact_abort on  
BEGIN TRY                          
              
/* 11 secs */                      
exec testdb.dbo.Update_CliFundsTrf                      
                
select * into #file1                               
from testdb.dbo.temp_mis_file1a with (nolock)                              
where sDateTime>= convert(varchar(11),getdate()-2)                       
/* and product not in ('Angeltrade','AngelDiet') */                      
                    
                        
              
delete from #file1 where sdateTime < 'Oct  8 2014'                                      
             
delete from #file1 where NtxnRefNo in (select DDNO from AGG_BO_BankReceipt with (nolock))                                   
                      
select * into #BOFile from AGG_BO_BankReceipt where 'a'='b'                              
                        
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                              
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                        
convert(varchar(10),sdateTime,103) as Edate,                              
convert(varchar(10),sdateTime,103) as Vdate,         
sLoginid as Cltcode,                              
nAmount as Amount,                              
'C' as DRCR,                   
/* 'BEING AMT RECD TECH PROCESS' as Narration,  */        
/*'BEING AMT RECD TECH PROCESS' as Narration,*/ /*commented on 11 dec 2014*/    
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,                        
/*'03014' as BankCode,*/                 
(case                
When sUserDefinedExchangeName='MCXSX' then '03032'                
when sUserDefinedExchangeName='NSECD' then '03032' 
when sUserDefinedExchangeName='BSEMFSS' then '03014'             
when sUserDefinedExchangeName='IPO' then '03027' 
when sUserDefinedExchangeName='NBFC' then '300003'   
else '03014' end) as BankCode,                           
/* 'ICICI BANK' as  BankName, */                          
sbankid as BankName,                          
nTxnRefNo as DDno,                      
'HO' as Branchcode,                              
'ALL' as Chqmode,                              
convert(varchar(10),sdateTime,103) as chqdate,                            
/* 'ICICI BANK' as chqname, */                          
sbankid as chqname,                          
'L' as Clmode,                              
GeneratedOn=getdate(),                              
Updation_Type='O',                              
Updation_flag='N',                              
getdate(),                              
sUserDefinedExchangeName,                              
sFromAccno                              
from #file1 where sAgencyID='TECHPROCESS'                              
                          
                          
                              
insert into #BOFile  ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)                              
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],                              
convert(varchar(10),sdateTime,103) as Edate,                              
convert(varchar(10),sdateTime,103) as Vdate,                              
sLoginid as Cltcode,                              
nAmount as Amount,                              
'C' as DRCR,                              
/*'BEING AMT RECD PAYNETZ' as Narration,   */               
/*'BEING AMT RECD TECH PROCESS' as Narration,*/    
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,  /*commented on 11 dec 2014*/                  
--'02020' as BankCode,                
 (case                
 When sUserDefinedExchangeName='MCXSX' then '02014'                
 when sUserDefinedExchangeName='NSECD' then '02014'                
 when sUserDefinedExchangeName='NSEFO' then '1000005'
 when sUserDefinedExchangeName='BSEMFSS' then '02014'    
 when sUserDefinedExchangeName='IPO' then '02019' 
 when sUserDefinedExchangeName='NBFC' then '300002'                          
 else '02020' end) as BankCode,                             
 /* 'HDFC BANK' as  BankName, */                          
sbankid as BankName,                           
nTxnRefNo as DDno,                              
'HO' as Branchcode,                              
'ALL' as Chqmode,                              
convert(varchar(10),sdateTime,103) as chqdate,                              
/* 'HDFC BANK' as chqname, */                          
sbankid as chqname,                             
'L' as Clmode,                      
GeneratedOn=getdate(),                              
Updation_Type='O',                              
Updation_flag='N',                              
getdate(),                              
sUserDefinedExchangeName,                              
sFromAccno                              
from #file1 where sAgencyID='PAYNETZ'                              

/*Added to handle duplicate entries by Renil Pillai on 15th June 2015*/
delete x from  #BOFile x  where exists
(select * from AGG_BO_BankReceipt y where x.vdate=y.vdate and x.edate=y.edate and x.cltcode=y.cltcode
and x.amount=y.amount and x.drcr=y.drcr and x.ddno=y.ddno and x.chqdate=y.chqdate and x.chqname=y.chqname 
and x.segment=y.segment and x.cliaccountno=y.cliaccountno)
                              
insert into AGG_BO_BankReceipt select * from #BOFile  

                              
/* insert into anand1.msajag.dbo.tbl_post_data */                              
/* delete from tbl_post_data where VDATE>='Oct  1 2014' */              
                          
insert into tbl_post_data                               
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,
BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld5,ROWSTATE)                        
  
     
     
select                               
VoucherType=2,[Sr no],                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as VDATE,                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as EDATE,                              
CLTCODE,                          
(Case when DRCR='C' then Amount else 0 end) as CreditAmt,                              
(Case when DRCR='D' then Amount else 0 end) as DebitAmt,                              
Narration,BankCode,'',BankName,'',Branchcode,DDno,'A' as Chqmode,                              
convert(datetime,substring(vdate,4,3)+substring(vdate,1,3)+substring(vdate,7,4)) as ChequeDate,                              
chqname,Clmode,CliAccountNo,                              
(Case                               
when segment='BSECM' then 'BSE'                               
when segment='NSECM' then 'NSE'                               
when segment='NSEFO' then 'NSE'                               
when segment='BSEFO' then 'BSE'                               
when segment='MCX' then 'MCX'                               
when segment='NCDEX' then 'NCX'                               
when segment='NSECD' then 'NSX'                               
when segment='MCXSX' then 'MCD'
when segment='BSEMFSS' then 'BSE' 
when segment='NSEMFSS' then 'NSE'
when segment='IPO' then 'NSE' 
when segment='NBFC' then 'NBF'                                                                 
else '' end) as exchange,                              
(Case                               
when segment='BSECM' then 'CAPITAL'                               
when segment='NSECM' then 'CAPITAL'                               
when segment='NSEFO' then 'FUTURES'                               
when segment='BSEFO' then 'FUTURES'                               
when segment='MCX' then 'FUTURES'                               
when segment='NCDEX' then 'FUTURES'                               
when segment='NSECD' then 'FUTURES'                               
when segment='MCXSX' then 'FUTURES'
when segment='BSEMFSS' then 'MFSS' 
when segment='NSEMFSS' then 'MFSS'
when segment='IPO' then 'CAPITAL'
when segment='NBFC' then 'NBFC'                                    
else '' end) as segment,MKCK_FLAG=1,                          
'IH_Aggregator' as TAG,0                             
from                               
#BOFile with (nolock)                              
                          
              

insert into Temp_BOFile_test([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo,Uploaded_date)          
 select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,
 Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,
 Updation_Time,ResponseCode,Segment,CliAccountNo,getdate()  from #BOFile                       
----Added by Neha --end    
          
truncate table Temp_BOFile          
insert into Temp_BOFile([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo)          
select [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,
chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo from #BOFile a
/*Added on 04/07/2016 to handle duplicated entries in MKT API*/
where not exists (select * from Temp_BOFile b with (nolock) where a.Cltcode=b.Cltcode and a.DDno=b.DDno)            
              
exec GBL_PushLedgerAPIinBO                          
                          
update AGG_BO_BankReceipt set ResponseCode=b.Return_fld3 from tbl_post_data b with (nolock)            
where AGG_BO_BankReceipt.cltcode=b.cltcode             
and AGG_BO_BankReceipt.ddno=b.ddno and /* AGG_BO_BankReceipt.vdate=b.vdate */                          
convert(datetime,substring(AGG_BO_BankReceipt.vdate,4,3)+substring(AGG_BO_BankReceipt.vdate,1,3)+substring(AGG_BO_BankReceipt.vdate,7,4))=b.vdate                          
            
---Insert data into Backoffice API  :: END               
              
                            
exec AGG_SEND_Email_BankReceiptFile                   
exec AGG_SEND_Email_BankReceiptFile_Rejected            
                  
                  
 --UPDATE VERIFICATION PROCCESS END DATE AFTER COMPLITION OF VERIFICATION SERVICE.                   
                     
   DECLARE @SRNO INT                     
   DECLARE @LatestCnt INT                  
                      
 --IT TAKES THE LATEST COUNT OF TODAY'S VERIFICATION RECORDS FROM tbl_AngelPGIMBOTransactionLog.                   
                      
   SET @LatestCnt = (SELECT COUNT(*)a FROM tbl_AngelPGIMBOTransactionLog                   
   WHERE LogDate >= CONVERT( DATETIME, (CONVERT(VARCHAR(10),GETDATE()-1,21)+ ' 00:00:00.000')))                  
                   
 --IT WILL TAKE THE LAST INSERTED RECORD'S SRNO.                     
   SET  @SRNO  = (select MAX(SRNO)SRNO from tbl_SUCCESS_TRANSACTION_VERIFICATION_STATUS)                  
                   
 --UPDATE THE Service End Date AND Verification Count into tbl_VERIFICATION_STATUS.                  
   UPDATE tbl_SUCCESS_TRANSACTION_VERIFICATION_STATUS                  
   SET Service_End_Date=GETDATE(),Verification_Count=@LatestCnt WHERE SRNO= @SRNO                            
                      
End try               
BEGIN CATCH                  
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                    
 select GETDATE(),'AGG_UPD_BOstatingTable_BankReceipt_successtransaction',ERROR_LINE(),ERROR_MESSAGE()                                    
    
 DECLARE @ErrorMessage NVARCHAR(4000);                                  
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                 
 RAISERROR (@ErrorMessage , 16, 1);           
                                       
End catch              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_BOstatingTable_BankReceipt_TechProcess
-- --------------------------------------------------
CREATE Procedure AGG_UPD_BOstatingTable_BankReceipt_TechProcess  
as  
set nocount on  
  
/*  
  
Get requried data into #file1  
  
*/  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR, 
'BEING AMT RECEIVED BY ONLINE TRF' as Narration,  
/*'BEING AMT RECD TECH PROCESS' as Narration,  */ /* Commented on 17 Dec 2014 */
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sAgencyID='TECHPROCESS'  
  
/*  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NSECD' and sAgencyID='TECHPROCESS'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='MCXSX' and sAgencyID='TECHPROCESS'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='BSECM' and sAgencyID='TECHPROCESS'  
  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NSECM' and sAgencyID='TECHPROCESS'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NCDEX' and sAgencyID='TECHPROCESS'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='MCX' and sAgencyID='TECHPROCESS'  
  
insert into AGG_BO_BankReceipt ([Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_Time,Segment,CliAccountNo)  
select ROW_NUMBER() OVER ( ORDER BY sLoginId ) AS [Sr No],  
convert(varchar(10),sdateTime,103) as Edate,  
convert(varchar(10),sdateTime,103) as Vdate,  
sLoginid as Cltcode,  
nAmount as Amount,  
'C' as DRCR,  
'BEING AMT RECD TECH PROCESS' as Narration,  
'03014' as BankCode,  
'ICICI BANK' as  BankName,  
nTxnRefNo as DDno,  
'HO' as Branchcode,  
'ALL' as Chqmode,  
convert(varchar(10),sdateTime,103) as chqdate,  
'ICICI BANK' as chqname,  
'L' as Clmode,  
GeneratedOn=getdate(),  
Updation_Type='O',  
Updation_flag='N',  
getdate(),  
sUserDefinedExchangeName,  
sFromAccno  
from #file1 where sUserDefinedExchangeName='NSEFO' and sAgencyID='TECHPROCESS'  
*/  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx
-- --------------------------------------------------
CREATE Procedure AGG_UPD_OnlineTrx      
as      
set nocount on      
      
 DECLARE @JobRunningStatus INT,@JOB_ID uniqueidentifier      
 SET @JobRunningStatus = 0      
      
 SELECT @JOB_ID = job_id       
 FROM INTRANET.msdb.dbo.sysjobs       
 WHERE name = 'ORMS_Client_Details'      
      
 create table #jobstatus      
 (      
  [Job ID] uniqueidentifier,       
  [last run date] int,      
  [last run time] int,      
  [next run date] int,      
  [next run time] int,      
  [next run schedule id] int,      
  [request to run] int,      
  [request source] int,      
  [request source id] varchar(100),      
  [running] int,      
  [current step] int,      
  [current retry attempt] int,      
  [state] int      
 )      
      
 INSERT INTO #jobstatus      
 EXEC INTRANET.master.dbo.xp_sqlagent_enum_jobs 1, sa,@JOB_ID      
      
 IF (SELECT COUNT(*) FROM #jobstatus) > 0      
  SELECT TOP 1 @JobRunningStatus = RUNNING FROM #jobstatus      
 ELSE      
  SELECT @JobRunningStatus = -1      

 DROP TABLE #jobstatus

 IF @JobRunningStatus = 0      
 BEGIN      
  EXEC AGG_UPD_OnlineTrx_PROCESS   
 END      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_Daily
-- --------------------------------------------------
CREATE Procedure AGG_UPD_OnlineTrx_Daily        
as        
set nocount on        
        
 DECLARE @JobRunningStatus INT,@JOB_ID uniqueidentifier        
 SET @JobRunningStatus = 0        
        
 SELECT @JOB_ID = job_id         
 FROM INTRANET.msdb.dbo.sysjobs         
 WHERE name = 'ORMS_Client_Details'        
        
 create table #jobstatus        
 (        
  [Job ID] uniqueidentifier,         
  [last run date] int,        
  [last run time] int,        
  [next run date] int,        
  [next run time] int,        
  [next run schedule id] int,        
  [request to run] int,        
  [request source] int,        
  [request source id] varchar(100),        
  [running] int,        
  [current step] int,        
  [current retry attempt] int,        
  [state] int        
 )        
        
 INSERT INTO #jobstatus        
 EXEC INTRANET.master.dbo.xp_sqlagent_enum_jobs 1, sa,@JOB_ID        
        
 IF (SELECT COUNT(*) FROM #jobstatus) > 0        
  SELECT TOP 1 @JobRunningStatus = RUNNING FROM #jobstatus        
 ELSE        
  SELECT @JobRunningStatus = -1        
  
 DROP TABLE #jobstatus  
  
 IF @JobRunningStatus = 0        
 BEGIN        
  EXEC AGG_UPD_OnlineTrx_PROCESS_Daily     
 END        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PreviousDay
-- --------------------------------------------------
CREATE Procedure AGG_UPD_OnlineTrx_PreviousDay       
as        
set nocount on        
        
 DECLARE @JobRunningStatus INT,@JOB_ID uniqueidentifier        
 SET @JobRunningStatus = 0        
        
 SELECT @JOB_ID = job_id         
 FROM INTRANET.msdb.dbo.sysjobs         
 WHERE name = 'ORMS_Client_Details'        
        
 create table #jobstatus        
 (        
  [Job ID] uniqueidentifier,         
  [last run date] int,        
  [last run time] int,        
  [next run date] int,        
  [next run time] int,        
  [next run schedule id] int,        
  [request to run] int,        
  [request source] int,        
  [request source id] varchar(100),        
  [running] int,        
  [current step] int,        
  [current retry attempt] int,        
  [state] int        
 )        
        
 INSERT INTO #jobstatus        
 EXEC INTRANET.master.dbo.xp_sqlagent_enum_jobs 1, sa,@JOB_ID        
        
 IF (SELECT COUNT(*) FROM #jobstatus) > 0        
  SELECT TOP 1 @JobRunningStatus = RUNNING FROM #jobstatus        
 ELSE        
  SELECT @JobRunningStatus = -1        
  
 DROP TABLE #jobstatus  
  
 IF @JobRunningStatus = 0        
 BEGIN        
  EXEC AGG_UPD_OnlineTrx_PROCESS_PreviousDay     
 END        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS
-- --------------------------------------------------
CREATE Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        

 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103) AND sbankid = 'ATOMPG' 
                  
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

 select * into #yesterday from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103) AND sbankid = 'ATOMPG' 

--insert into #yesterday(nTxnRefNo,sDateTime)
--select nTxnRefNo,sDateTime from Agg_temp_upp_17Nov2017 
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(/*select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)*/
select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
and nTxnRefNo not in (select nTxnRefNo from #yesterday) ) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

/*added on 18 May 2017*******/
insert into tbl_checkingAggregatorData(sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,UpdatedOn)
select sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,getdate() from #aa
/********************/

 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join  
--(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
--insert into #commo  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
--(  
--select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'  
--and SloginId not in (select SloginId from #commo)  
--) a join  
--(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
--(select party_Code,nsefo from #client_Details with (nolock) where nsefo='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsx from #client_Details with (nolock) where nsx='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq 
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)  ) a join              
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=3)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
insert into #eq              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(              
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'              
and SloginId not in (select SloginId from #eq)              
) a join              
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,mcd from #client_Details with (nolock) where mcd='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsecm from #client_Details with (nolock) where nsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
/*
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
*/

--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS


/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  



/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
--update #aa set suserDefinedExchangeName=b.Segment   
--from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
--and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
/*Commented by sandeep on 11 Apr 2017 to avoid not in query*/
/*
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
*/

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_03Sep_2016
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_03Sep_2016]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    
    
                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select party_Code,mcdx,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select party_Code,mcdx,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            
              
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_06Jun2017
-- --------------------------------------------------
CREATE Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_06Jun2017]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        

 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
                  
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

 select * into #yesterday from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

/*added on 18 May 2017*******/
insert into tbl_checkingAggregatorData(sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,UpdatedOn)
select sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,getdate() from #aa
/********************/

 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
--(select party_Code,nsefo from #client_Details with (nolock) where nsefo='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsx from #client_Details with (nolock) where nsx='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,mcd from #client_Details with (nolock) where mcd='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsecm from #client_Details with (nolock) where nsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
/*
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
*/

--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS


/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
/*Commented by sandeep on 11 Apr 2017 to avoid not in query*/
/*
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
*/

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_11Apr2017
-- --------------------------------------------------
Create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_11Apr2017]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
 
 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from #client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsx from #client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,mcd from #client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsecm from #client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
/*Commented by sandeep on 11 Apr 2017 to avoid not in query*/
/*
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
*/

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_11Feb2016
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_11Feb2016]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    
    
                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select party_Code,mcdx,ncdx from risk.dbo.client_Details with (nolock) where mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select party_Code,mcdx,ncdx from risk.dbo.client_Details with (nolock) where mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from risk.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsx from risk.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,mcd from risk.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsecm from risk.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsecm from risk.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            
              
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_15Nov2016
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_15Nov2016]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    
    
                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select party_Code,mcdx,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select party_Code,mcdx,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_16Nov2015
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_16Nov2015]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    
    
                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
 
 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_16Nov2016Bak
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_16Nov2016Bak]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    
    
                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select party_Code,mcdx,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select party_Code,mcdx,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select party_Code,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsx='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where mcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging 
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and 
SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
insert into tbl_Aggregator_Staging
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from [196.1.115.182].GENERAL.dbo.client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_BKP24Feb2018
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_BKP24Feb2018]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        

 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103) AND sbankid = 'ATOMPG' 
                  
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

 select * into #yesterday from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103) AND sbankid = 'ATOMPG' 

--insert into #yesterday(nTxnRefNo,sDateTime)
--select nTxnRefNo,sDateTime from Agg_temp_upp_17Nov2017 
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(/*select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)*/
select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
and nTxnRefNo not in (select nTxnRefNo from #yesterday) ) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

/*added on 18 May 2017*******/
insert into tbl_checkingAggregatorData(sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,UpdatedOn)
select sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,getdate() from #aa
/********************/

 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
--(select party_Code,nsefo from #client_Details with (nolock) where nsefo='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsx from #client_Details with (nolock) where nsx='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,mcd from #client_Details with (nolock) where mcd='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsecm from #client_Details with (nolock) where nsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
/*
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
*/

--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS


/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
/*Commented by sandeep on 11 Apr 2017 to avoid not in query*/
/*
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
*/

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_Daily
-- --------------------------------------------------
CREATE Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_Daily]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        

 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103) AND sbankid = 'ATOMPG' 
                  
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

 /*
 select * into #yesterday from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103) AND sbankid = 'ATOMPG' 

insert into #yesterday(nTxnRefNo,sDateTime)
select nTxnRefNo,sDateTime from Agg_temp_upp_17Nov2017 
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(/*select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)*/
select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
and nTxnRefNo not in (select nTxnRefNo from #yesterday) ) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

*/
 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details with (nolock) where cl_code in 
 (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* All Segments */  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join  
--(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
--insert into #commo  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
--(  
--select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'  
--and SloginId not in (select SloginId from #commo)  
--) a join  
--(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              

insert into #eq 
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)  ) a join              
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=3)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
insert into #eq              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(              
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'              
and SloginId not in (select SloginId from #eq)              
) a join              
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                  
                      
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=6)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS     

insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=9)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS             
            
/*NBFC*/            
            
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join              
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and mcdx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS   

insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and ncdx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS     

--update #aa set suserDefinedExchangeName=b.Segment   
--from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
--and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
        
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
                         
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
 

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            


insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
 

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_Daily_BKP24Feb2018
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_Daily_BKP24Feb2018]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        

 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103) AND sbankid = 'ATOMPG' 
                  
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

 /*
 select * into #yesterday from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103) AND sbankid = 'ATOMPG' 

insert into #yesterday(nTxnRefNo,sDateTime)
select nTxnRefNo,sDateTime from Agg_temp_upp_17Nov2017 
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(/*select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)*/
select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
and nTxnRefNo not in (select nTxnRefNo from #yesterday) ) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

*/
 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details with (nolock) where cl_code in 
 (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 


  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
        
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
                         
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
 

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            


insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
 

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_Live_14Jun2017
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_Live_14Jun2017]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/                          
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           
        
insert into #aa        
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:') c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

/*added on 18 May 2017*******/
insert into tbl_checkingAggregatorData(sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,UpdatedOn)
select sLoginId,nMarketSegmentId,sUserDefinedExchangeName,nAmount,nServiceCharge,sDateTime,nTxnRefNo,sGroupId,nProcessFlag,sBankId,sAgencyId,sFromAccNo,sToAccNo,product,getdate() from #aa
/********************/

 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsefo,'nsefo',getdate()    
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
--(select party_Code,nsefo from #client_Details with (nolock) where nsefo='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/ 

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
/***********************start*************************/ 
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsx,'nsx',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsx from #client_Details with (nolock) where nsx='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
/***********************end*************************/  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.mcd,'mcd',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,mcd from #client_Details with (nolock) where mcd='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging 
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.nsecm,'nsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,nsecm from #client_Details with (nolock) where nsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
/***********************end*************************/
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/
--insert into tbl_Aggregator_Staging
/*
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and
 SloginId not in (select SloginId from tbl_Aggregator_Staging)) a join  
(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS
*/

--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId,b.bsecm,'bsecm',getdate()   
--from          
--(select #aa.sUserDefinedExchangeName,#aa.SloginId from #aa 
--left join tbl_Aggregator_Staging a with(nolock) on #aa.SloginId=a.SloginId 
--where #aa.sUserDefinedExchangeName='EQUITY+FNO+CURRENCY'  and a.SloginId is null ) a join  
--(select party_Code,bsecm from #client_Details with (nolock) where bsecm='Y' ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS


/***********************End*************************/  
  
/* --- NOT ACTIVE   
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bsefo from risk.dbo.client_Details with (nolock) where bsefo='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=6)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #eq   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select party_Code,bcd from risk.dbo.client_Details with (nolock) where bcd='Y' ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
*/  
 

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/*not active*/
/*insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsefo from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=8)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli from risk.dbo.client_Details with (nolock) where nbfc_cli='Y' and bcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 */ 
update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
  
/*          
select * from #aa a, AGG_PG_VMID b where b.defaultid=1 and a.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
*/          
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
          
/*          
update #aa set sBankid='TECHPROCESS',sAgencyid='L1668' where sbankid='TechView1'        /* 2423 */                  
update #aa set sBankid='PAYNETZ',sAgencyid='167' where sbankid='ATOMPG'                          
*/          
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          
/*Commented by sandeep on 11 Apr 2017 to avoid not in query*/
/*
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                          
from #aa where nTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                           
not in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
*/

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null


/*Ended by sandeep*/              
/* CAPTURE ATOM Transaction ID */              
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            

/*Added on 17 Oct 2016 by */              
insert into tbl_checkingForSegment select * from #t1              
/***************************/
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               
/*                          
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                    
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                          
(                          
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                           
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                          
) b                          
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                          
*/

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_PreviousDay
-- --------------------------------------------------
CREATE Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_PreviousDay]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        


/* 
 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103) AND sbankid = 'ATOMPG' 

                 
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

*/

 select * into #yesterday 
 from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103) AND sbankid = 'ATOMPG' 

             
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
 into #aa from                                          
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(/*select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)*/
select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
and nTxnRefNo not in (select nTxnRefNo from #yesterday) ) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

  
 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details with (nolock) where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
--/* Commodity */  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join  
--(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
--insert into #commo  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
--(  
--select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'  
--and SloginId not in (select SloginId from #commo)  
--) a join  
--(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
--/* EQUITY+FNO+CURRENCY'*/  
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join  
--(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
--insert into #eq   
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
--(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  

--insert into #eq   
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
--(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=3)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
 
  
--insert into #eq   
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
--(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=4)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


--insert into #eq   
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join  
--(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=5)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

--/***********************start*************************/

--/*NBFC*/

--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
--(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

--insert into #nbfc   
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
--(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

--insert into #nbfc   
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
--(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

--insert into #nbfc   
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
--(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

--insert into #nbfc   
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
--(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

--insert into #nbfc   
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
--(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

--insert into #nbfc   
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
--from          
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
--(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


--update #aa set suserDefinedExchangeName=b.Segment   
--from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
--and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
 
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              

insert into #eq 
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)  ) a join              
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=3)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
insert into #eq              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(              
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'              
and SloginId not in (select SloginId from #eq)              
) a join              
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                  
                      
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=6)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS     

insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=9)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS             
            
/*NBFC*/            
            
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join              
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and mcdx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS   

insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and ncdx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS      
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
        
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
        
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null
             
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            
 
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_UPD_OnlineTrx_PROCESS_PreviousDay_BKP24Feb2018
-- --------------------------------------------------
create Procedure [dbo].[AGG_UPD_OnlineTrx_PROCESS_PreviousDay_BKP24Feb2018]                          
as                          
                          
set nocount on                          
    
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.     
       
INSERT INTO tbl_VERIFICATION_STATUS VALUES(GETDATE(),'',0)    


/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/

select   * into #client_Details from risk.dbo.client_Details with (nolock)
    
/*Ended by sandeep on 11 Apr 2017*/        


/* 
 select * into #today from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate(),103) AND sbankid = 'ATOMPG' 

                 
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
into #aa                          
from                                           
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate(),103)
and nTxnRefNo not in (select nTxnRefNo from #today)) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

*/

 select * into #yesterday 
 from [172.31.15.22].PG.dbo.tbl_BankResponse where sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')
 and left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103) AND sbankid = 'ATOMPG' 

             
select                                           
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                          
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                          
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end)                          
 into #aa from                                          
[172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                           
(/*select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,14) = CONVERT(varchar(10),getdate()-1,103)+' 23:'
and nTxnRefNo not in (select nTxnRefNo from #yesterday)*/
select * from [172.31.15.22].PG.dbo.tbl_BankRequest with (nolock) where left(sDateTime,10) = CONVERT(varchar(10),getdate()-1,103)
and nTxnRefNo not in (select nTxnRefNo from #yesterday) ) c,                                    
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                    
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                           

  
 select * into #Client from anand1.MsaJAg.dbo.client_brok_Details with (nolock) where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()  
        
/* Commodity */  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join  
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
insert into #commo  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from          
(  
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'  
and SloginId not in (select SloginId from #commo)  
) a join  
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  
  
/* EQUITY+FNO+CURRENCY'*/  
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
 
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  
  

insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 
 
  
insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


insert into #eq   
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join  
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b    
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

/***********************start*************************/

/*NBFC*/

select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join  
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS    

insert into #nbfc   
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId   
from          
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join  
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b    
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS  
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c   
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS  


update #aa set suserDefinedExchangeName=b.Segment   
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  
  
update #aa set suserDefinedExchangeName=b.Segment   
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName  

update #aa set suserDefinedExchangeName=b.Segment   
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS  
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName
        
          
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b           
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS          
        
                          
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'              
              
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified)                          

select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N'                         
from #aa left join tbl_AngelPGIMBOTransactionLog t
on #aa.nTxnRefNo=t.Transactionmerchantid collate SQL_Latin1_General_CP1_CI_AS
where t.Transactionmerchantid is null
             
              
 SELECT stxnrefno,              
 sTemp1 AS ATOMtransID              
 INTO #ATI             
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */              
 WHERE  Isnull(sTemp1, '') <> ''               
            
 UPDATE #t1               
 SET ExtraField2=b.ATOMtransID               
 FROM #ATI b              
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 and Vendor='PAYNETZ'               
            
 update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID             
 FROM #ATI b              
 WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS              
 AND Vendor='PAYNETZ' AND ExtraField2 IS NULL            
 
insert into tbl_AngelPGIMBOTransactionLog select * from #t1               

drop table #client_Details
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.agg_upd_onlinetrx_process_successtransactions
-- --------------------------------------------------
CREATE Procedure [dbo].[agg_upd_onlinetrx_process_successtransactions]            
as                                        
                           
set nocount on                                      
                
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.                 
                   
INSERT INTO tbl_SUCCESS_TRANSACTION_VERIFICATION_STATUS VALUES(GETDATE(),'',0)                
            
            
/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/            
            
select   * into #client_Details from risk.dbo.client_Details with (nolock)            
                
/*Ended by sandeep on 11 Apr 2017*/  
declare @date varchar(30)
set @date = CONVERT(date,getdate()-1 ,103)
set @date =@date +' 00:00:00.000'
--print @date
                                    
select                                                       
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                                      
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                                      
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,  
product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end),c.bankname  
into #aa                                      
from                                                       
 [172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                                       
(select x.sBankId,x.sFromAccNo,x.sProductType,x.nTxnRefNo,x.sToAccNo, z.bankname             
 from [172.31.15.22].PG.dbo.tbl_BankRequest x WITH (NOLOCK)            
 JOIN [172.31.15.22].PG.dbo.tbl_BankResponse  y WITH(NOLOCK)            
 ON x.nTxnRefNo = y.nTxnRefNo            
 JOIN tbl_ft_atomtechbankmapping z      
 ON z.bankid = SUBSTRING(x.svendorbankid ,CHARINDEX('-',x.svendorbankid) + 1 , LEN(x.svendorbankid) - CHARINDEX('-',x.svendorbankid) + 1)      
 /*where left(x.sDateTime,10) >= CONVERT(varchar(10),getdate(),103)*//*Commented On 01 Dec 2017 by Neha*/
 where convert(datetime,isnull(x.sDateTime,'1900-01-01'),103) >=  @date
 AND y.sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')    
 AND x.sbankid = 'ATOMPG'    
) c,                                                
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                                
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                                       
            
delete a            
from #aa a            
JOIN             
tbl_AngelPGIMBOTransactionLog b             
ON a.nTxnRefNo = b.TransactionMerchantID collate SQL_Latin1_General_CP1_CI_AS              
where b.TransactionMerchantID  is not null            
            
select * into #Client             
from anand1.MsaJAg.dbo.client_brok_Details             
where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()              
                    
/* Commodity */              
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from                      
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join              
--(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b                
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
--insert into #commo              
--select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
--(              
--select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'              
--and SloginId not in (select SloginId from #commo)              
--) a join              
--(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b                
--on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
--join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c               
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
              
/* EQUITY+FNO+CURRENCY'*/              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments') a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              

insert into #eq 
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)  ) a join              
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=3)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
insert into #eq              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(              
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments'              
and SloginId not in (select SloginId from #eq)              
) a join              
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                  
                      
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=6)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS     

insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='All Segments' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='All Segments' and seqid=9)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS             
            
/*NBFC*/            
            
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join              
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS 

insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and mcdx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS   

insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and ncdx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=9)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
--insert into #nbfc               
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
--from                      
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
--(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b                
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c               
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS   
                         
--insert into #nbfc               
--select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
--from                      
--(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
--(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b                
--on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
--join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c               
--on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
--update #aa set suserDefinedExchangeName=b.Segment               
--from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS              
--and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName              
              
update #aa set suserDefinedExchangeName=b.Segment               
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS              
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName              
            
update #aa set suserDefinedExchangeName=b.Segment               
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS              
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName            
              
                      
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b                       
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS                      
                      
                     
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'                          
                          
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified,BankName)                                      
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N',bankname  
from #aa            
            
/*Ended by sandeep*/                          
/* CAPTURE ATOM Transaction ID */                          
                          
 SELECT stxnrefno,                          
 sTemp1 AS ATOMtransID                          
 INTO #ATI                         
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */                          
 WHERE  Isnull(sTemp1, '') <> ''                           
                        
 --UPDATE #t1                           
 --SET ExtraField2=b.ATOMtransID,TransactionReferenceNo =  b.ATOMtransID,VerificationRemark = 'SUCCESS',  TransactionStatus= 'SUCCESS',TransactionVerified = 'Y', VerificationDate = GETDATE()            
 --FROM #ATI b                          
 --WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 --and Vendor='PAYNETZ'                  
         
 UPDATE #t1                           
 SET ExtraField2=b.ATOMtransID, TransactionReferenceNo =  b.ATOMtransID,VerificationRemark = 'SUCCESS',  TransactionStatus= 'SUCCESS',TransactionVerified = 'Y', VerificationDate = GETDATE()            
 FROM #ATI b                          
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 and Vendor='PAYNETZ'                    
         
             
 --UPDATE #t1                           
 --SET TransactionStatus= 'SUCCESS',VerificationRemark = 'SUCCESS', TransactionVerified = 'N'            
 --FROM #ATI b                          
 --WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 --and Vendor='TECHPROCESS'                     
           
                  
                        
 --update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID            
 --FROM #ATI b                          
 --WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 --AND Vendor='PAYNETZ' AND ExtraField2 IS NULL                        
            
insert into tbl_AngelPGIMBOTransactionLog select * from #t1                           
/*                                      
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                                
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                                      
(                                      
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                                       
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                                      
) b                                      
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                                      
*/            
            
drop table #client_Details            
                                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.agg_upd_onlinetrx_process_successtransactions_BKP24Feb2018
-- --------------------------------------------------
create Procedure [dbo].[agg_upd_onlinetrx_process_successtransactions_BKP24Feb2018]            
as                                        
                           
set nocount on                                      
                
 --DATA SAVE INTO tbl_VERIFICATION_STATUS TABLE WHEN VERIFICATION PROCCESS IS START.                 
                   
INSERT INTO tbl_SUCCESS_TRANSACTION_VERIFICATION_STATUS VALUES(GETDATE(),'',0)                
            
            
/*added by sandeep on 11 April 2017 first time fetch client details from 196.1.115.182*/            
            
select   * into #client_Details from risk.dbo.client_Details with (nolock)            
                
/*Ended by sandeep on 11 Apr 2017*/  
declare @date varchar(30)
set @date = CONVERT(date,getdate()-1 ,103)
set @date =@date +' 00:00:00.000'
--print @date
                                    
select                                                       
a.sLoginId,nMarketSegmentId=a.sproductId,sUserDefinedExchangeName=d.sproductname,                                      
a.nAmount,a.nServiceCharge,a.sDateTime,a.nTxnRefNo,a.sGroupId,a.nProcessFlag,                                                      
c.sBankId+space(10) as sBankId,sAgencyId=space(10),c.sFromAccNo,c.sToAccNo,  
product=(Case when sProductType='diet' then 'AngelDiet' else 'AngelTrade' end),c.bankname  
into #aa                                      
from                                                       
 [172.31.15.22].PG.dbo.tbl_FundsAllocation a with (nolock),                                                       
(select x.sBankId,x.sFromAccNo,x.sProductType,x.nTxnRefNo,x.sToAccNo, z.bankname             
 from [172.31.15.22].PG.dbo.tbl_BankRequest x WITH (NOLOCK)            
 JOIN [172.31.15.22].PG.dbo.tbl_BankResponse  y WITH(NOLOCK)            
 ON x.nTxnRefNo = y.nTxnRefNo            
 JOIN tbl_ft_atomtechbankmapping z      
 ON z.bankid = SUBSTRING(x.svendorbankid ,CHARINDEX('-',x.svendorbankid) + 1 , LEN(x.svendorbankid) - CHARINDEX('-',x.svendorbankid) + 1)      
 /*where left(x.sDateTime,10) >= CONVERT(varchar(10),getdate(),103)*//*Commented On 01 Dec 2017 by Neha*/
 where convert(datetime,isnull(x.sDateTime,'1900-01-01'),103) >=  @date
 AND y.sresponsemsg in  ('SUCCESS','Success','Successful','Transaction Completed Successfully.','Transaction completed successfully')    
 AND x.sbankid = 'ATOMPG'    
) c,                                                
(select sproductid,sproductName from [172.31.15.22].PG.dbo.tbl_ProductMaster with (nolock) where sactive=1 group by sproductid,sproductName) d                                                
where a.nTxnRefNo=c.nTxnRefNo and a.sproductId=d.sproductId                                                       
            
delete a            
from #aa a            
JOIN             
tbl_AngelPGIMBOTransactionLog b             
ON a.nTxnRefNo = b.TransactionMerchantID collate SQL_Latin1_General_CP1_CI_AS              
where b.TransactionMerchantID  is not null            
            
select * into #Client             
from anand1.MsaJAg.dbo.client_brok_Details             
where cl_code in (select sLoginId collate SQL_Latin1_General_CP1_CI_AS  from #aa ) and InActive_from>getdate()              
                    
/* Commodity */              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #commo from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY') a join              
(select cl_code from #Client with (nolock) where Exchange='MCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=1)c on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
insert into #commo              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId from                      
(              
select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='COMMODITY'              
and SloginId not in (select SloginId from #commo)              
) a join              
(select cl_code from #Client with (nolock) where Exchange='NCX' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='Commodity' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
              
              
/* EQUITY+FNO+CURRENCY'*/              
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId into #eq               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY') a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='FUTURES') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSX' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
             
            
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='MCD' and Segment='FUTURES' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=3)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS             
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='NSE' and Segment='CAPITAL' ) b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
              
insert into #eq               
select suserdefinedExchangeName,SloginId,cl_code as party_Code,Entity,c.Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='EQUITY+FNO+CURRENCY' and SloginId not in (select SloginId from #eq)) a join              
(select cl_code from #Client with (nolock) where Exchange='BSE' and Segment='CAPITAL') b                
on a.SloginId=b.cl_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='EQUITY+FNO+CURRENCY' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS               
            
/*NBFC*/            
            
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId into #nbfc               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC') a join              
(select party_Code,nbfc_cli,nsefo from #client_Details with (nolock) where nbfc_cli='Y' and  nsefo='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=1)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsx from #client_Details with (nolock) where nbfc_cli='Y' and nsx='Y'  ) b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=2)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,mcd from #client_Details with (nolock) where nbfc_cli='Y' and mcd='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=3)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,nsecm from #client_Details with (nolock) where nbfc_cli='Y' and nsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=4)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,bsecm from #client_Details with (nolock) where nbfc_cli='Y' and  bsecm='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=5)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,mcdx from #client_Details with (nolock) where nbfc_cli='Y' and  mcdx='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=6 )c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS                            
insert into #nbfc               
select suserdefinedExchangeName,SloginId,party_Code,Entity,Segment,SeqId               
from                      
(select suserdefinedExchangeName,SloginId from #aa where suserdefinedExchangeName='NBFC' and SloginId not in (select SloginId from #nbfc)) a join              
(select party_Code,nbfc_cli,ncdx from #client_Details with (nolock) where nbfc_cli='Y'  and  ncdx='Y') b                
on a.SloginId=b.party_code collate SQL_Latin1_General_CP1_CI_AS              
join (select * from GBL_Entity_segment where entity='NBFC' and seqid=7)c               
on a.suserdefinedExchangeName=c.entity collate SQL_Latin1_General_CP1_CI_AS              
            
update #aa set suserDefinedExchangeName=b.Segment               
from #commo b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS              
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName              
              
update #aa set suserDefinedExchangeName=b.Segment               
from #eq b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS              
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName              
            
update #aa set suserDefinedExchangeName=b.Segment               
from #nbfc b where #aa.SloginId=b.party_Code collate SQL_Latin1_General_CP1_CI_AS              
and #aa.suserdefinedExchangeName=b.suserdefinedExchangeName            
              
                      
update #aa set #aa.sBankid=b.Vendor,sAgencyid=b.VendorMerchantID from AGG_PG_VMID b                       
where b.defaultid=1 and #aa.sbankid=b.sbankid collate SQL_Latin1_General_CP1_CI_AS                      
                      
                     
select * into #t1 from tbl_AngelPGIMBOTransactionLog with (nolock) where 'a'='b'                          
                          
insert into #t1 (Requestid,AppName,Party_Code,Segment,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,Transactionmerchantid,TransactionVerified,BankName)                                      
select Newid(),product,sLoginId,sUserDefinedExchangeName,sFromAccno,nAmount,sDatetime,sBankid,sAgencyid,nTxnRefNo,'N',bankname  
from #aa            
            
/*Ended by sandeep*/                          
/* CAPTURE ATOM Transaction ID */                          
                          
 SELECT stxnrefno,                          
 sTemp1 AS ATOMtransID                          
 INTO #ATI                         
 FROM   [172.31.15.22].PG.dbo.tbl_PGATOMResponse WITH (nolock) /* CASE SENSITIVE */                          
 WHERE  Isnull(sTemp1, '') <> ''                           
                        
 --UPDATE #t1                           
 --SET ExtraField2=b.ATOMtransID,TransactionReferenceNo =  b.ATOMtransID,VerificationRemark = 'SUCCESS',  TransactionStatus= 'SUCCESS',TransactionVerified = 'Y', VerificationDate = GETDATE()            
 --FROM #ATI b                          
 --WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 --and Vendor='PAYNETZ'                  
         
 UPDATE #t1                           
 SET ExtraField2=b.ATOMtransID, TransactionReferenceNo =  b.ATOMtransID,VerificationRemark = 'SUCCESS',  TransactionStatus= 'SUCCESS',TransactionVerified = 'Y', VerificationDate = GETDATE()            
 FROM #ATI b                          
 WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 and Vendor='PAYNETZ'                    
         
             
 --UPDATE #t1                           
 --SET TransactionStatus= 'SUCCESS',VerificationRemark = 'SUCCESS', TransactionVerified = 'N'            
 --FROM #ATI b                          
 --WHERE #t1.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 --and Vendor='TECHPROCESS'                     
           
                  
                        
 --update tbl_AngelPGIMBOTransactionLog  SET ExtraField2=b.ATOMtransID            
 --FROM #ATI b                          
 --WHERE tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.sTxnRefNo collate SQL_Latin1_General_CP1_CI_AS                          
 --AND Vendor='PAYNETZ' AND ExtraField2 IS NULL                        
            
insert into tbl_AngelPGIMBOTransactionLog select * from #t1                           
/*                                      
update tbl_AngelPGIMBOTransactionLog set TransactionVerified='Y',VerificationRemark=b.sResponseMsg,VerificationDate=sDAtetime,                                
TransactionStatus=b.sResponseMsg,TransactionReferenceNo=b.sBankRefNo from                                      
(                                      
select * from [172.31.15.22].PG.dbo.tbl_BankResponse with (nolock) where nResponseCode=0                                       
and ntxnRefno  collate SQL_Latin1_General_CP1_CI_AS  in (select Transactionmerchantid from tbl_AngelPGIMBOTransactionLog with (nolock))                                      
) b                                      
where tbl_AngelPGIMBOTransactionLog.Transactionmerchantid=b.ntxnRefno collate SQL_Latin1_General_CP1_CI_AS                                      
*/            
            
drop table #client_Details            
                                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AGG_Upd_RecoData
-- --------------------------------------------------

CREATE Procedure AGG_Upd_RecoData  
as  

insert into tbl_AngelPGIMBOTransactionLog
(RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,
VerificationRemark,VerificationDate,LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,
ReVerificationRemark,ReVerificationDate,ExtraField1,ExtraField2,ExtraField3,ExtraField4,ExtraField5)   
select RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,VerificationRemark,
VerificationDate,LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,ReVerificationRemark,ReVerificationDate,
ExtraField1,ExtraField2,ExtraField3,ExtraField4,ExtraField5  
from Agg_Reco_FormatedData

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AngelPgim_TechProcessVerificationResponseValidate
-- --------------------------------------------------
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
create procedure [dbo].[AngelPgim_TechProcessVerificationResponseValidate]
(
       @str_msg varchar(5000)
)
as
begin
/* This sp is used for the Checking the error log of Verification Process.*/
 
       --exec response_verification 'Merchant Code should not be blank.'
       --exec response_verification 'MERCHANT_ID=T968|MERCHANT_TX_ID=222222|MERCHANT_TX_AMT=10|TX_DATE=29122010|TPSL_TX_ID=11415078|VERIFIED_TX_ID=11415096|VERIFIED_TX_AMT=10|VERIFIED_TX_STATUS=Y|VERIFIED_TX_DATE=15122010|VERIFIED_BANK_ID=470|VERIFIED_BANK_NAME=TEST BANK|VERIFIED_ITC=B1303_BSE_B'
       -- <?xml version="1.0" encoding="UTF-8"?><TPSL_DATA><TPSL id="1"><MRCTTXNID>4001</MRCTTXNID><TPSLTXNID>79651307</TPSLTXNID><MERITC>K45650_NSE_B</MERITC><SRCAMT>201.0</SRCAMT><BANKTXNID/><TXNDATE>2013-08-13 14:39:41.457</TXNDATE><BANKNAME>Bank of Baroda</BANKNAME><PAYMENTDATE>2013-08-13 15:30:01.0</PAYMENTDATE><TXNSTATUS>P</TXNSTATUS><MRCTCODE>L1668</MRCTCODE></TPSL></TPSL_DATA>
      
      
       if len(@str_msg) =0
       begin
              select 1
              return
       end
      
       --Declare @@count as int
 
       ----set @@count = (select count(*) from validation_response   where upper(message)=upper(@str_msg))
       --set @@count = CHARINDEX('|',@str_msg,0)
       --print @@count
       --if @@count =0
       --            select 1
       --else
       --     select 0
      
       if(
          (@str_msg like '%MERCHANT CODE IS MANDATORY%') or
          (@str_msg like '%MERCHANT CODE SHOULD BE ALPHANUMERIC%') or
          (@str_msg like '%USER ID CANNOT BE BLANK OR NULL%') or
          (@str_msg like '%PASSWORD FILED CANNOT BE BLANK OR NULL%') or    
          (@str_msg like '%MANDATORY FIELD IS MISSING%') or  
          (@str_msg like '%NO TRANSACTIONS AVAILABLE%') or   
          (@str_msg like '%ERROR IN INPUT DATA%')
          )
          begin
              select 1
              return
          end
       else if(@str_msg like '%<MRCTCODE>L1668</MRCTCODE>%')
       begin
              select 0
       end 
      
                    
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECK_VERIFICATIONSTATUS
-- --------------------------------------------------
 CREATE PROC CHECK_VERIFICATIONSTATUS  
 AS  
   
 DECLARE @EndDate as DATETIME  
   DECLARE @DCHECK AS INT  
   SET  @EndDate =(select top 1 (Service_End_Date) from tbl_VERIFICATION_STATUS ORDER BY SRNO DESC)  
     
      
   SET   @DCHECK = (SELECT datepart(mi,getdate()-@EndDate) AS DiffDate )  
     
   IF @DCHECK < 30    
   BEGIN      
   
	 DECLARE @MessBody VARCHAR(4000), @MESS AS VARCHAR(4000),@filename as varchar(100)          
	 declare @Count int,@CountEnd int   
	 DECLARE @VerificationData VARCHAR(8000)   
	 DECLARE @AsliSrno INT  
	 DECLARE @Service_Start_Date DATETIME  
	 DECLARE @Service_End_Date DATETIME   
	 DECLARE @Verification_Cnt BIGINT  
	 set @MessBody=''  
	 set @MESS=''  
	 set @VerificationData=''  
	 set @Count=1  
	 set @CountEnd=10  
	 --DROP TABLE #tp  
	 select row_number()over (order by SrNO) AsliSrno, SrNO, Service_Start_Date, Service_End_Date, Verification_Cnt   
	 into #tp from (  
		select top 10 SrNO, Service_Start_Date, Service_End_Date, Verification_Cnt from tbl_VERIFICATION_STATUS ORDER BY SrNO Desc)a   
		order by srno asc  
	      
		SET @MESS=  
	   '<table border="1">  
				<tr>  
					<th>  
						SrNo  
					</th>  
					<th>  
						Service start Date  
					</th>  
					<th>  
						service End Date  
					</th>  
					<th>  
						Verification Count  
					</th>  
				</tr>'  
	      
	  --PRINT @Count      
	  --PRINT @CountEnd      
	  WHILE @Count <= @CountEnd      
	  BEGIN  
	  
		SELECT @AsliSrno=AsliSrno, @Service_Start_Date=Service_Start_Date,@Service_End_Date=Service_End_Date,@Verification_Cnt=Verification_Cnt FROM #tp WHERE aslisrno=@count           
		set @VerificationData=@VerificationData+   
			 '<tr>  
			 <td>  
			  '+  
			   CONVERT(VARCHAR,@AsliSrno)  
			   +  
			  '  
			 </td>  
			 <td>  
			  '+  
			   CONVERT(VARCHAR,@Service_Start_Date)  
			   +  
			  '  
			 </td>  
			 <td>  
			  '+  
			   CONVERT(VARCHAR,@Service_End_Date)  
			   +  
			  '  
			 </td>  
			 <td>  
			  '+  
			   CONVERT(VARCHAR,@Verification_Cnt)  
			   +  
			  '  
			 </td>  
			</tr>'  
		SET   @Count=@Count+1            
	  END                      
	         
		   --PRINT  @MESS  
	         
	              
	  SET @MessBody =  '<b>Dear Team,</br></br>'+  
		  ' Verification service is not running from past 30 minutes. <b></br></br>'+  
		   @MESS + @VerificationData + '</Table>'   
	       
	    --PRINT @MessBody  
	      
		--DROP TABLE #tp     
	     
		EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                    
		@RECIPIENTS ='rohit.patil@angelbroking.com',--'renil.pillai@angelbroking.com',          
		@COPY_RECIPIENTS = '',--'manesh@angelbroking.com',                    
		@PROFILE_NAME = 'Angelbroking',                
		@BODY_FORMAT ='HTML',                
		@SUBJECT = 'ALERT !! Aggregator: Funds Payin Details.',                    
		@FILE_ATTACHMENTS ='',                    
		@BODY =@MessBody   
     
   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fil_Levels
-- --------------------------------------------------
  create proc Fil_Levels
  as
  select * from Filter_Levels

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_BatchProJobExecutor
-- --------------------------------------------------

CREATE Procedure [dbo].[GBL_BatchProJobExecutor]      
as      
/*  
set nocount on      
BEGIN TRY          
 DECLARE @JobRunningStatus INT,@JOB_ID uniqueidentifier      
 SET @JobRunningStatus = 0      
  
 SELECT @JOB_ID = job_id       
 FROM INTRANET.msdb.dbo.sysjobs       
 WHERE name = 'Aggregator BO Push'      
  
 create table #jobstatus      
 (      
 [Job ID] uniqueidentifier,       
 [last run date] int,      
 [last run time] int,      
 [next run date] int,      
 [next run time] int,      
 [next run schedule id] int,      
 [request to run] int,      
 [request source] int,      
 [request source id] varchar(100),      
 [running] int,      
 [current step] int,      
 [current retry attempt] int,      
 [state] int      
 )      
  
 INSERT INTO #jobstatus      
 EXEC INTRANET.master.dbo.xp_sqlagent_enum_jobs 1, sa,@JOB_ID      
  
 IF (SELECT COUNT(*) FROM #jobstatus) > 0      
 SELECT TOP 1 @JobRunningStatus = RUNNING FROM #jobstatus      
 ELSE      
 SELECT @JobRunningStatus = -1      
  
 IF @JobRunningStatus = 0      
 BEGIN      
 EXEC [INTRANET].msdb.dbo.sp_start_job 'Aggregator BO Push'      
 END      
  
End try               
BEGIN CATCH                  
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                    
 select GETDATE(),'GBL_BatchProJobExecutor',ERROR_LINE(),ERROR_MESSAGE()                                    
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                  
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                  
 RAISERROR (@ErrorMessage , 16, 1);   
End catch              
set nocount off   
*/  
Set nocount on                                  
SET XACT_ABORT ON                                     
BEGIN TRY         
declare @cmd varchar(1000)          
declare @ssispath varchar(1000)         

insert into cms.dbo.tbl_DTSX_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                
select GETDATE(),'DTSX Package',0,'StartTime' 
 
/*set @ssispath = 'D:\CMS PKG\CMSBOPushPackage\CMSBOPushPackage\Package.dtsx'  */        

set @ssispath = 'I:\CMS PKG\CMSBOPushPackage\CMSBOPushPackage\Package.dtsx'  
--select @cmd = 'dtexec /F "' + @ssispath + '"'          
select @cmd = 'dtexec /F "' + @ssispath + '" /DECRYPT "pass@123"'          
      
select @cmd --= @cmd          

exec master..xp_cmdshell @cmd         
             
insert into cms.dbo.tbl_DTSX_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                
select GETDATE(),'DTSX Package',0,'EndTime'  
      
END TRY                
                
 BEGIN CATCH                
 insert into cms.dbo.tbl_DTSX_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                
  select GETDATE(),'DTSX Package',ERROR_LINE(),ERROR_MESSAGE()                                                                
                          
  DECLARE @ErrorMessage NVARCHAR(4000);                       
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                            
  RAISERROR (@ErrorMessage , 16, 1);                        
                              
 END CATCH                         
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_BatchProJobExecutor_07042017
-- --------------------------------------------------
create Procedure [dbo].[GBL_BatchProJobExecutor_07042017]    
as    
set nocount on    
BEGIN TRY        
	DECLARE @JobRunningStatus INT,@JOB_ID uniqueidentifier    
	SET @JobRunningStatus = 0    

	SELECT @JOB_ID = job_id     
	FROM INTRANET.msdb.dbo.sysjobs     
	WHERE name = 'Aggregator BO Push'    

	create table #jobstatus    
	(    
	[Job ID] uniqueidentifier,     
	[last run date] int,    
	[last run time] int,    
	[next run date] int,    
	[next run time] int,    
	[next run schedule id] int,    
	[request to run] int,    
	[request source] int,    
	[request source id] varchar(100),    
	[running] int,    
	[current step] int,    
	[current retry attempt] int,    
	[state] int    
	)    

	INSERT INTO #jobstatus    
	EXEC INTRANET.master.dbo.xp_sqlagent_enum_jobs 1, sa,@JOB_ID    

	IF (SELECT COUNT(*) FROM #jobstatus) > 0    
	SELECT TOP 1 @JobRunningStatus = RUNNING FROM #jobstatus    
	ELSE    
	SELECT @JobRunningStatus = -1    

	IF @JobRunningStatus = 0    
	BEGIN    
	EXEC [INTRANET].msdb.dbo.sp_start_job 'Aggregator BO Push'    
	END    

End try             
BEGIN CATCH                
	insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
	select GETDATE(),'GBL_BatchProJobExecutor',ERROR_LINE(),ERROR_MESSAGE()                                  

	DECLARE @ErrorMessage NVARCHAR(4000);                                
	SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
	RAISERROR (@ErrorMessage , 16, 1); 
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_BOpostUpdate
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[GBL_BOpostUpdate]
as

Set Nocount on
SEt Xact_abort on
 BEGIN TRY 
 return 0
	--update tbl_post_data set tbl_post_data.Return_fld1=x.Return_fld1,tbl_post_data.Return_fld3=x.Return_fld3,tbl_post_data.Return_fld4=x.Return_fld4,tbl_post_data.Return_fld5=x.Return_fld5,tbl_post_data.ROWSTATE=x.ROWSTATE                  
	--from (select VOUCHERTYPE,Return_fld1,Return_fld5,Return_fld4,Return_fld3,ROWSTATE from AngelBSECM.MKTAPI.dbo.tbl_post_data   
	--with (nolock) where RETURN_FLD5='IH_Aggregator' ) x                  
	--where tbl_post_data.fldauto=convert(int,x.Return_fld4) and tbl_post_data.VOUCHERTYPE=x.VOUCHERTYPE                  
	--and tbl_post_data.Return_fld5=x.Return_fld5             

	--/*Added by Neha 02 Jan 2014 */            
	--insert into AGG_BO_BankReceipt_bk            
	--select * from AGG_BO_BankReceipt where ddno in (select ddno from tbl_post_data            
	--where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date))            

	--insert into tbl_post_data_bk             
	--select * from tbl_post_data            
	--where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date)             


	--delete AGG_BO_BankReceipt where ddno in (select ddno from tbl_post_data            
	--where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date))            

	--delete tbl_post_data            
	--where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date) 

End try             
BEGIN CATCH                
            
  
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'GBL_BOpostUpdate',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
 RAISERROR (@ErrorMessage , 16, 1);         
                                     
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_BSECM_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_BSECM_APIPostProcessOnline]
as

Set Nocount on
SEt Xact_abort on
BEGIN TRY 
	EXEC AngelBSECM.account_Ab.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'BSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'                  
	
	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_BSECM_APIPostProcessOnline',getdate() 
End try             
BEGIN CATCH                
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'GBL_BSECM_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
 RAISERROR (@ErrorMessage , 16, 1);         
                                     
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_CommMCDX_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_CommMCDX_APIPostProcessOnline]    
as    
    
Set Nocount on    
SEt Xact_abort on    
BEGIN TRY     
 EXEC ANGELCOMMODITY.accountmcdx.dbo.OFFLINE_POST_LEDGER  @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'MCX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /*  04 secs */                  
 
 	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_CommMCDX_APIPostProcessOnline',getdate()
End try                 
BEGIN CATCH                    
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                      
 select GETDATE(),'GBL_CommMCDX_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                      
      
 DECLARE @ErrorMessage NVARCHAR(4000);                                    
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                    
 RAISERROR (@ErrorMessage , 16, 1);             
                                         
End catch                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_CommMCDXCDS_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_CommMCDXCDS_APIPostProcessOnline]      
as      
      
Set Nocount on      
SEt Xact_abort on      
BEGIN TRY       
 EXEC ANGELCOMMODITY.accountmcdxcds.dbo.OFFLINE_POST_LEDGER @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'MCD', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* 02 secs */                    
	
	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_CommMCDXCDS_APIPostProcessOnline',getdate() 
End try                   
BEGIN CATCH                      
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                        
 select GETDATE(),'GBL_CommMCDXCDS_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                        
        
 DECLARE @ErrorMessage NVARCHAR(4000);                                      
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                      
 RAISERROR (@ErrorMessage , 16, 1);               
                                           
End catch                  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_CommNCDX_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_CommNCDX_APIPostProcessOnline]    
as    
    
Set Nocount on    
SEt Xact_abort on    
BEGIN TRY     
 EXEC ANGELCOMMODITY.accountncdx.dbo.OFFLINE_POST_LEDGER  @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NCX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* */                  

	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_CommNCDX_APIPostProcessOnline',getdate() 
End try                 
BEGIN CATCH                    
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                      
 select GETDATE(),'GBL_CommNCDX_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                      
      
 DECLARE @ErrorMessage NVARCHAR(4000);                                    
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                    
 RAISERROR (@ErrorMessage , 16, 1);             
                                         
End catch                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_Curr_APIPostProcessOnline
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[GBL_Curr_APIPostProcessOnline]    
as    
    
Set Nocount on    
SEt Xact_abort on    
BEGIN TRY     
 EXEC angelfo.Accountcurfo.dbo.OFFLINE_POST_LEDGER   @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* */                  
 	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_Curr_APIPostProcessOnline',getdate() 
End try                 
BEGIN CATCH                    
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                      
 select GETDATE(),'GBL_Curr_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                      
      
 DECLARE @ErrorMessage NVARCHAR(4000);                                    
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                    
 RAISERROR (@ErrorMessage , 16, 1);             
                                         
End catch                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_FO_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_FO_APIPostProcessOnline]    
as    
    
Set Nocount on    
SEt Xact_abort on    
BEGIN TRY     
 EXEC angelfo.accountfo.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* 05 secs */                  
 
 	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_FO_APIPostProcessOnline',getdate()
End try                 
BEGIN CATCH                    
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                      
 select GETDATE(),'GBL_FO_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                      
      
 DECLARE @ErrorMessage NVARCHAR(4000);                                    
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                    
 RAISERROR (@ErrorMessage , 16, 1);             
                                         
End catch                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_MFSS_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_MFSS_APIPostProcessOnline]
as

Set Nocount on
SEt Xact_abort on
BEGIN TRY 
    Exec AngelFO.BBO_FA.dbo.FA_POSTING_OFFLINE  
    /*Added for Payout entries*/
    Exec AngelFO.BBO_FA.dbo.FA_POSTING_OfflINE_Payout
    
    Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_MFSS_APIPostProcessOnline',getdate()
End try             
BEGIN CATCH                
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'GBL_MFSS_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
 RAISERROR (@ErrorMessage , 16, 1);         
                                     
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_NBFC_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_NBFC_APIPostProcessOnline]
as

Set Nocount on
SEt Xact_abort on
BEGIN TRY 
	EXEC ABVSCITRUS.AccountNBFC.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NBF', @SEGMENT = 'NBFC', @RECOFLAG = 'N'                  
	    Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
		select 'GBL_NBFC_APIPostProcessOnline',getdate()
End try             
BEGIN CATCH                
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'GBL_NBFC_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
 RAISERROR (@ErrorMessage , 16, 1);         
                                     
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_NotUpdatedinBO
-- --------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE procedure [dbo].[GBL_NotUpdatedinBO]          
AS          
SET nocount ON            
          
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)                      
DECLARE @emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                                
                             
SELECT @emailto='fundspayout@angelbroking.com;pay-inbanking@angelbroking.com;pranita@angelbroking.com;vishal.doshi@angelbroking.com'   --Vijay.Thakkar@48fitness.in                 
SELECT @emailcc='bo.support@angelbroking.com'--'fundspayout@angelbroking.com'--'radisson@48fitness.in'                      
SELECT @emailbcc='sajeev@angelbroking.com'  
BEGIN try   
  
  
 declare @Count int,@CountEnd int,@EXCHANGE as varchar(20)='',@Segment as varchar(20)='',@VoucherType int,@Pending_Records int             
  DECLARE @MessBody NVARCHAR(MAX) ,@MESS NVARCHAR(MAX) ,@MessBody1 as varchar(4000)=''           
  DECLARE @xml NVARCHAR(MAX)              
   DECLARE @Data NVARCHAR(MAX) ,  @totctrOT as int=0          
           
    set @Data=''                
    set @MessBody=''                          
    set @MESS=''          
    set @Count=1                                    
    
    SELECT Row_number()over (order by EXCHANGE) As Srno,EXCHANGE,SEGMENT,VoucherType,COUNT(*) Pending_Records  into #aa 
    FROM AngelBSECM.Account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES WHERE VDATE >=convert(VARCHAR(11),getdate(),120) And VoucherType in (2,3,8)
	AND ROWSTATE =0 AND ADDBY ='TPR'   AND EXCHANGE <>'NBF'
	GROUP BY EXCHANGE,Vouchertype,SEGMENT 
if( select count(*) from #aa)>0  
Begin             
     SELECT @totctrOT=count(1) from #aa           
   SET @MESS=                            
   '<table border="1">                            
   <tr>                       
    <th> EXCHANGE </th>
    <th> SEGMENT </th> 
    <th> VoucherType </th> 
    <th> Pending_Records </th>                                                    
   </tr>'          
--print @MESS          
   WHILE @Count <= @totctrOT                              
     BEGIN                        
      SELECT @EXCHANGE=EXCHANGE,@SEGMENT=SEGMENT,@VoucherType=VoucherType,@Pending_Records=Pending_Records FROM #aa WHERE Srno=@count                                   
      set @Data=@Data+                           
     '<tr>                          
     <td> '+ CONVERT(VARCHAR,@EXCHANGE) +' </td>                          
     <td> '+ CONVERT(VARCHAR,@SEGMENT) +' </td>                          
     <td> '+ CONVERT(VARCHAR,@VoucherType) +' </td>                          
     <td> '+ CONVERT(VARCHAR,@Pending_Records) +' </td>                          
       </tr>'              
       --print @Data                         
      SET   @Count=@Count+1                                    
     END             
  
SET @MessBody =  'Dear Team,<br/><br/>'+'Number of records not updated in BO: <br/><br/>'+ @MESS + @Data + '</Table>'       
SET @MessBody=@MessBody+'<BR><BR>This is a System generated Message. Please do not Reply.'                                    
                   
                          
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                    
 @RECIPIENTS =@emailto,--'neha.naiwar@angelbroking.com' ,                                    
 @COPY_RECIPIENTS = @emailcc,                                    
 @blind_copy_recipients =@emailbcc,--'neha.naiwar@angelbroking.com' ,                
 @PROFILE_NAME = 'AngelBroking',                                    
 @BODY_FORMAT ='HTML',                                    
 @SUBJECT = 'Not Updated in BO',                                    
 @FILE_ATTACHMENTS ='',                                    
 @BODY =@MessBody       
 
 drop table #aa                              
End                          
END try                
          
  BEGIN catch                          
      SET @MessBody=                          
'<BR><BR> ERROR in triggering email<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                          
                          
    EXEC intranet.msdb.dbo.Sp_send_dbmail                          
      @RECIPIENTS =@emailto,                          
      @COPY_RECIPIENTS = @emailcc,                          
      @PROFILE_NAME = 'AngelBroking',                          
      @BODY_FORMAT ='HTML',                          
      @SUBJECT = 'ERROR: Not Updated in BO',                          
      @FILE_ATTACHMENTS ='',                          
      @BODY =@MESS                          
END catch                          
                          
SET nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_NSECM_APIPostProcessOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_NSECM_APIPostProcessOnline]
as

Set Nocount on
SEt Xact_abort on
BEGIN TRY 
	Declare  @Date varchar(11)=convert(varchar(11),getdate(),109)
	EXEC AngelNseCM.account.dbo.V2_OFFLINE_PAYMENTUPLOAD_OPT     @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'CAPITAL' ,@IP_VDATE= @Date , @RECOFLAG = 'N'
	EXEC AngelNseCM.account.dbo.OFFLINE_POST_LEDGER     @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'
	
	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_NSECM_APIPostProcessOnline',getdate()
End try             
BEGIN CATCH                
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'GBL_NSECM_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
 RAISERROR (@ErrorMessage , 16, 1);         
                                     
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_NSECM_APIPostProcessOnline_for SEBIPO_07Oct2023
-- --------------------------------------------------
create PROCEDURE [dbo].[GBL_NSECM_APIPostProcessOnline_for SEBIPO_07Oct2023]
as

Set Nocount on
SEt Xact_abort on
BEGIN TRY 
	Declare  @Date varchar(11)=convert(varchar(11),getdate()-1,109)
	EXEC AngelNseCM.account.dbo.V2_OFFLINE_PAYMENTUPLOAD_OPT     @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'CAPITAL' ,@IP_VDATE= @Date , @RECOFLAG = 'N'
	EXEC AngelNseCM.account.dbo.OFFLINE_POST_LEDGER     @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'
	
	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'GBL_NSECM_APIPostProcessOnline',getdate()
End try             
BEGIN CATCH                
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'GBL_NSECM_APIPostProcessOnline',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                
 RAISERROR (@ErrorMessage , 16, 1);         
                                     
End catch            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_Offline_APILedgerPostOnline
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GBL_Offline_APILedgerPostOnline]    
as    
    
Set Nocount on    
SEt Xact_abort on    
BEGIN TRY     
 Exec AngelBSECM.account_Ab.dbo.OFFLINE_LEDGER_POSTING_MF_API
 EXEC AngelBSECM.account_Ab.dbo.OFFLINE_LEDGER_POSTING_API  /* 6 secs */
/*Added on 31 Jan 2017 for removal of duplicate entries SP given by siva */
 EXEC AngelBSECM.ACCOUNT_ab.dbo.CHECK_DUP_ENTRIES                  
End try                 
BEGIN CATCH                    
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                      
 select GETDATE(),'GBL_Offline_APILedgerPostOnline',ERROR_LINE(),ERROR_MESSAGE()                                      
      
 DECLARE @ErrorMessage NVARCHAR(4000);                                    
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                    
 RAISERROR (@ErrorMessage , 16, 1);             
                                         
End catch                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_PushLedgerAPIinBO
-- --------------------------------------------------
CREATE Procedure [dbo].[GBL_PushLedgerAPIinBO]                 
as                 
                  
set nocount on                 
SEt Xact_abort on
BEGIN TRY           
 
       --change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table   
       /*insert into anand.MKTAPI.dbo.tbl_post_data                 
       (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                    
       */
       select   DISTINCT               
       a.VOUCHERTYPE,a.SNO,a.VDATE,a.EDATE,a.CLTCODE,a.CREDITAMT,a.DEBITAMT,a.NARRATION,a.BANKCODE,a.MARGINCODE,a.BANKNAME,a.BRANCHNAME,a.BRANCHCODE,a.DDNO,a.CHEQUEMODE,a.CHEQUEDATE,a.CHEQUENAME,a.CLEAR_MODE,a.TPACCOUNTNUMBER,a.EXCHANGE,a.SEGMENT,a.MKCK_FLAG, 
       a.fldauto,Return_fld5                                                    
       into #ForChecking from tbl_post_data a join Temp_BOFile b on a.cltcode=b.cltcode and a.ddno=b.ddno and a.vdate=                
       convert(datetime,substring(b.vdate,4,3)+substring(b.vdate,1,3)+substring(b.vdate,7,4))   
       where a.DDNO not in (select DDNO from tbl_ChkPost with(nolock) ) and b.DDno not in (select DDNO from tbl_ChkPost with(nolock))  ;              
       --Ended change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table   
       
/*Added by Neha for removing duplication in anand.MKTAPI.dbo.tbl_post_data on 21 Aug 2015*/
WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
       RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM /*anand.MKTAPI.dbo.tbl_post_data*/ #ForChecking where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate()-1,103),103)
   and VOUCHERTYPE=2
)
insert into tbl_post_data_deletelog
select *,getdate() FROM CTE WHERE RN > 1;

WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
       RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM /*anand.MKTAPI.dbo.tbl_post_data*/ #ForChecking where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate()-1,103),103)
   and VOUCHERTYPE=2
)
delete from CTE WHERE RN > 1 ;

insert into anand.MKTAPI.dbo.tbl_post_data                 
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                    
select VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,fldauto,Return_fld5
from #ForChecking;

WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
    RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM anand.MKTAPI.dbo.tbl_post_data where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate()-1,103),103)
   and VOUCHERTYPE=2
)
delete from CTE WHERE RN > 1 ;
/*-----------------------------------------------------------------------*/      
drop table #ForChecking

       
exec GBL_BatchProJobExecutor

/************************Added On 23 Oct 2017****************/
exec USP_OnlineFund_DirectLimitToODIN
/***********************************************************/
 
End try            
            
BEGIN CATCH               
            
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                 
 select GETDATE(),'GBL_PushLedgerAPIinBO',ERROR_LINE(),ERROR_MESSAGE()                                 
  
 DECLARE @ErrorMessage NVARCHAR(4000);                               
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                               
 RAISERROR (@ErrorMessage , 16, 1);
    
End catch           
 --exec AGG_UPD_BOstatingTable_BankReceipt           
/*Added by Neha 02 Jan 2014 */           
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_PushLedgerAPIinBO_02Jan2014
-- --------------------------------------------------
  
CREATE Procedure GBL_PushLedgerAPIinBO_02Jan2014      
as      
      
set nocount on      
      
insert into anand.MKTAPI.dbo.tbl_post_data      
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)          
select       
a.VOUCHERTYPE,a.SNO,a.VDATE,a.EDATE,a.CLTCODE,a.CREDITAMT,a.DEBITAMT,a.NARRATION,a.BANKCODE,a.MARGINCODE,a.BANKNAME,a.BRANCHNAME,a.BRANCHCODE,a.DDNO,a.CHEQUEMODE,a.CHEQUEDATE,a.CHEQUENAME,a.CLEAR_MODE,a.TPACCOUNTNUMBER,a.EXCHANGE,a.SEGMENT,a.MKCK_FLAG,   
 
a.fldauto,Return_fld5      
from tbl_post_data a join Temp_BOFile b on a.cltcode=b.cltcode and a.ddno=b.ddno and a.vdate=    
convert(datetime,substring(b.vdate,4,3)+substring(b.vdate,1,3)+substring(b.vdate,7,4))    
  
  
      
EXEC anand.account_Ab.dbo.OFFLINE_LEDGER_POSTING_API  /* 6 secs */    
EXEC anand.account_Ab.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'BSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'      
EXEC anand1.account.dbo.OFFLINE_POST_LEDGER     @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'  /* 11 secs */    
EXEC angelfo.accountfo.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* 05 secs */    
EXEC angelfo.Accountcurfo.dbo.OFFLINE_POST_LEDGER   @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* */    
EXEC ANGELCOMMODITY.accountmcdxcds.dbo.OFFLINE_POST_LEDGER @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'MCD', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* 02 secs */    
EXEC ANGELCOMMODITY.accountmcdx.dbo.OFFLINE_POST_LEDGER  @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'MCX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /*  04 secs */    
EXEC ANGELCOMMODITY.accountncdx.dbo.OFFLINE_POST_LEDGER  @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NCX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* */    
--EXEC ANGELCOMMODITY.accountbfo.dbo.OFFLINE_POST_LEDGER  @UNAME = 'OFFLINE', @USERCAT = 61, @EXCHANGE = 'BSE', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'      
        
update tbl_post_data set tbl_post_data.Return_fld1=x.Return_fld1,tbl_post_data.Return_fld3=x.Return_fld3,tbl_post_data.Return_fld4=x.Return_fld4,tbl_post_data.Return_fld5=x.Return_fld5,tbl_post_data.ROWSTATE=x.ROWSTATE      
from (select VOUCHERTYPE,Return_fld1,Return_fld5,Return_fld4,Return_fld3,ROWSTATE from anand.MKTAPI.dbo.tbl_post_data with (nolock)) x      
where tbl_post_data.fldauto=convert(int,x.Return_fld4) and tbl_post_data.VOUCHERTYPE=x.VOUCHERTYPE      
and tbl_post_data.Return_fld5=x.Return_fld5      
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_PushLedgerAPIinBO_10Nov2017
-- --------------------------------------------------
create Procedure [dbo].[GBL_PushLedgerAPIinBO_10Nov2017]                 
as                 
                  
set nocount on                 
SEt Xact_abort on
BEGIN TRY           
 
       --change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table   
      insert into anand.MKTAPI.dbo.tbl_post_data                 
       (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                    
       select   DISTINCT               
       a.VOUCHERTYPE,a.SNO,a.VDATE,a.EDATE,a.CLTCODE,a.CREDITAMT,a.DEBITAMT,a.NARRATION,a.BANKCODE,a.MARGINCODE,a.BANKNAME,a.BRANCHNAME,a.BRANCHCODE,a.DDNO,a.CHEQUEMODE,a.CHEQUEDATE,a.CHEQUENAME,a.CLEAR_MODE,a.TPACCOUNTNUMBER,a.EXCHANGE,a.SEGMENT,a.MKCK_FLAG, 
       a.fldauto,Return_fld5                                                    
       from tbl_post_data a join Temp_BOFile b on a.cltcode=b.cltcode and a.ddno=b.ddno and a.vdate=                
       convert(datetime,substring(b.vdate,4,3)+substring(b.vdate,1,3)+substring(b.vdate,7,4))   
       where a.DDNO not in (select DDNO from tbl_ChkPost with(nolock) ) and b.DDno not in (select DDNO from tbl_ChkPost with(nolock))  ;              
       --Ended change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table   
       
/*Added by Neha for removing duplication in anand.MKTAPI.dbo.tbl_post_data on 21 Aug 2015*/
WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
       RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM anand.MKTAPI.dbo.tbl_post_data  where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate(),103),103)
   and VOUCHERTYPE=2
)
insert into tbl_post_data_deletelog
select *,getdate() FROM CTE WHERE RN > 1;

WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
       RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM anand.MKTAPI.dbo.tbl_post_data where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate(),103),103)
   and VOUCHERTYPE=2
)
delete from CTE WHERE RN > 1 ;

insert into anand.MKTAPI.dbo.tbl_post_data                 
(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                    
select VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,fldauto,Return_fld5
from #ForChecking

/*-----------------------------------------------------------------------*/      
drop table #ForChecking

       
exec GBL_BatchProJobExecutor

/************************Added On 23 Oct 2017****************/
	exec USP_OnlineFund_DirectLimitToODIN
/***********************************************************/
 
End try            
            
BEGIN CATCH               
            
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                 
 select GETDATE(),'GBL_PushLedgerAPIinBO',ERROR_LINE(),ERROR_MESSAGE()                                 
  
 DECLARE @ErrorMessage NVARCHAR(4000);                               
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                               
 RAISERROR (@ErrorMessage , 16, 1);
    
End catch           
 --exec AGG_UPD_BOstatingTable_BankReceipt           
/*Added by Neha 02 Jan 2014 */           
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_PushLedgerAPIinBO_24062015
-- --------------------------------------------------
CREATE Procedure [dbo].[GBL_PushLedgerAPIinBO_24062015]                  
as                  
                  
set nocount on                  
 BEGIN TRY            
 /* Added by neha */            
         
 /*        
 insert into anand.MKTAPI.dbo.tbl_post_data        
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                     
 
        
 select distinct * from(        
 select                   
 a.VOUCHERTYPE,a.SNO,a.VDATE,a.EDATE,a.CLTCODE,a.CREDITAMT,a.DEBITAMT,a.NARRATION,a.BANKCODE,a.MARGINCODE,a.BANKNAME,a.BRANCHNAME,a.BRANCHCODE,a.DDNO,a.CHEQUEMODE,a.CHEQUEDATE,a.CHEQUENAME,a.CLEAR_MODE,a.TPACCOUNTNUMBER,a.EXCHANGE,a.SEGMENT,a.MKCK_FLAG,  
  
    
      
         
 a.fldauto,Return_fld5 --into #testdata                                                    
 from tbl_post_data a join Temp_BOFile_test b on a.cltcode=b.cltcode and a.ddno=b.ddno and a.vdate=                
 convert(datetime,substring(b.vdate,4,3)+substring(b.vdate,1,3)+substring(b.vdate,7,4))          
 )a        
    */        
            
 /* Added by neha */            
     
  --change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table    
 insert into anand.MKTAPI.dbo.tbl_post_data                  
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                     
 
 select   DISTINCT                
 a.VOUCHERTYPE,a.SNO,a.VDATE,a.EDATE,a.CLTCODE,a.CREDITAMT,a.DEBITAMT,a.NARRATION,a.BANKCODE,a.MARGINCODE,a.BANKNAME,a.BRANCHNAME,a.BRANCHCODE,a.DDNO,a.CHEQUEMODE,a.CHEQUEDATE,a.CHEQUENAME,a.CLEAR_MODE,a.TPACCOUNTNUMBER,a.EXCHANGE,a.SEGMENT,a.MKCK_FLAG,  
  
     
 a.fldauto,Return_fld5                                                     
 from tbl_post_data a join Temp_BOFile b on a.cltcode=b.cltcode and a.ddno=b.ddno and a.vdate=                
 convert(datetime,substring(b.vdate,4,3)+substring(b.vdate,1,3)+substring(b.vdate,7,4))    
 where a.DDNO not in (select DDNO from tbl_ChkPost with(nolock) ) and b.DDno not in (select DDNO from tbl_ChkPost with(nolock))                 
  --Ended change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table    
          
                  
EXEC anand.account_Ab.dbo.OFFLINE_LEDGER_POSTING_API  /* 6 secs */                
EXEC anand.account_Ab.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'BSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'                  
EXEC anand1.account.dbo.OFFLINE_POST_LEDGER     @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'CAPITAL', @RECOFLAG = 'N'  /* 11 secs */                
EXEC angelfo.accountfo.dbo.OFFLINE_POST_LEDGER    @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSE', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* 05 secs */                
EXEC angelfo.Accountcurfo.dbo.OFFLINE_POST_LEDGER   @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NSX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* */                
EXEC ANGELCOMMODITY.accountmcdxcds.dbo.OFFLINE_POST_LEDGER @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'MCD', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* 02 secs */                
EXEC ANGELCOMMODITY.accountmcdx.dbo.OFFLINE_POST_LEDGER  @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'MCX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /*  04 secs */                
EXEC ANGELCOMMODITY.accountncdx.dbo.OFFLINE_POST_LEDGER  @UNAME = 'ONLINE', @USERCAT = 61, @EXCHANGE = 'NCX', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'  /* */                
--EXEC ANGELCOMMODITY.accountbfo.dbo.OFFLINE_POST_LEDGER  @UNAME = 'OFFLINE', @USERCAT = 61, @EXCHANGE = 'BSE', @SEGMENT = 'FUTURES', @RECOFLAG = 'N'                  
                    
update tbl_post_data set tbl_post_data.Return_fld1=x.Return_fld1,tbl_post_data.Return_fld3=x.Return_fld3,tbl_post_data.Return_fld4=x.Return_fld4,tbl_post_data.Return_fld5=x.Return_fld5,tbl_post_data.ROWSTATE=x.ROWSTATE                  
from (select VOUCHERTYPE,Return_fld1,Return_fld5,Return_fld4,Return_fld3,ROWSTATE from anand.MKTAPI.dbo.tbl_post_data   
with (nolock) where RETURN_FLD5='IH_Aggregator' ) x                  
where tbl_post_data.fldauto=convert(int,x.Return_fld4) and tbl_post_data.VOUCHERTYPE=x.VOUCHERTYPE                  
and tbl_post_data.Return_fld5=x.Return_fld5             
            
/*Added by Neha 02 Jan 2014 */            
insert into AGG_BO_BankReceipt_bk            
select * from AGG_BO_BankReceipt where ddno in (select ddno from tbl_post_data            
 where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date))            
            
insert into tbl_post_data_bk             
select * from tbl_post_data            
where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date)             
            
            
delete AGG_BO_BankReceipt where ddno in (select ddno from tbl_post_data            
 where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date))            
             
 delete tbl_post_data            
 where ROWSTATE =0 and cast (edate as date)  = cast( cast ( getdate() as varchar(50)) as date)             
          
      
                
End try             
            
BEGIN CATCH                
            
insert into AggError (ErrorNumber,ErrorSeverity,ErrorLine,ErrorMessage,UpdatedOn)            
values (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_LINE(),ERROR_MESSAGE(),getdate())            
            
End catch            
 --exec AGG_UPD_BOstatingTable_BankReceipt            
/*Added by Neha 02 Jan 2014 */            
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GBL_PushLedgerAPIinBO_Bak29Jan2015
-- --------------------------------------------------
create Procedure [dbo].[GBL_PushLedgerAPIinBO_Bak29Jan2015]                 
as                 
                  
set nocount on                 
SEt Xact_abort on
BEGIN TRY           
 
       --change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table   
       insert into anand.MKTAPI.dbo.tbl_post_data                 
       (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5)                    
       select   DISTINCT               
       a.VOUCHERTYPE,a.SNO,a.VDATE,a.EDATE,a.CLTCODE,a.CREDITAMT,a.DEBITAMT,a.NARRATION,a.BANKCODE,a.MARGINCODE,a.BANKNAME,a.BRANCHNAME,a.BRANCHCODE,a.DDNO,a.CHEQUEMODE,a.CHEQUEDATE,a.CHEQUENAME,a.CLEAR_MODE,a.TPACCOUNTNUMBER,a.EXCHANGE,a.SEGMENT,a.MKCK_FLAG, 
       a.fldauto,Return_fld5                                                    
       from tbl_post_data a join Temp_BOFile b on a.cltcode=b.cltcode and a.ddno=b.ddno and a.vdate=                
       convert(datetime,substring(b.vdate,4,3)+substring(b.vdate,1,3)+substring(b.vdate,7,4))   
       where a.DDNO not in (select DDNO from tbl_ChkPost with(nolock) ) and b.DDno not in (select DDNO from tbl_ChkPost with(nolock))  ;              
       --Ended change by neha on 23 Feb 2015 for Manual check of 52 Record should not be inserted in Back office table   
       
/*Added by Neha for removing duplication in anand.MKTAPI.dbo.tbl_post_data on 21 Aug 2015*/
WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
       RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM anand.MKTAPI.dbo.tbl_post_data where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate(),103),103)
   and VOUCHERTYPE=2
)
insert into tbl_post_data_deletelog
select *,getdate() FROM CTE WHERE RN > 1;

WITH CTE AS
(
   SELECT VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
       RN = ROW_NUMBER()OVER(PARTITION BY DDNO,bankcode ORDER BY DDNO,bankcode)
   FROM anand.MKTAPI.dbo.tbl_post_data where ddno <> '' and vdate>=Convert(datetime,Convert(varchar(11),getdate(),103),103)
   and VOUCHERTYPE=2
)
delete from CTE WHERE RN > 1 ;
/*-----------------------------------------------------------------------*/      
       
exec GBL_BatchProJobExecutor
 
End try            
            
BEGIN CATCH               
            
 insert into GBL_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                 
 select GETDATE(),'GBL_PushLedgerAPIinBO',ERROR_LINE(),ERROR_MESSAGE()                                 
  
 DECLARE @ErrorMessage NVARCHAR(4000);                               
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                               
 RAISERROR (@ErrorMessage , 16, 1);
    
End catch           
 --exec AGG_UPD_BOstatingTable_BankReceipt           
/*Added by Neha 02 Jan 2014 */           
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetFltLevel
-- --------------------------------------------------
  
  
CREATE PROCEDURE GETFLTLEVEL -- 'REGION','REGION','MUM'
(   
    @RPT_LEVEL AS VARCHAR(25),  
    @ACCESS_TO AS VARCHAR(25),  
    @ACCESS_CODE AS VARCHAR(25)  
)                              
AS  
BEGIN                               
SET NOCOUNT ON                                           
--DECLARE @ACCESS_CODE AS VARCHAR(25),@ACCESS_TO AS VARCHAR(25),@RPT_LEVEL AS VARCHAR(25)                      
DECLARE @STR AS VARCHAR(1000)                    
/*                        
 SET @ACCESS_TO ='REGION'                              
SET @ACCESS_CODE ='MUM'                              
SET @RPT_LEVEL ='REGION'                          
*/              
                                                          
    SET @STR=''                              
    IF @ACCESS_TO ='BROKER'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+' AS FILTER_VAL FROM RISK.DBO.VW_RMS_CLIENT_VERTICAL '                              
    END                            
    ELSE IF @ACCESS_TO ='BRMAST'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+' AS FILTER_VAL FROM RISK.DBO.VW_RMS_CLIENT_VERTICAL_BRMAST WHERE '+@ACCESS_TO+' = '''+@ACCESS_CODE+''''                               
    END                         
        ELSE IF @ACCESS_TO ='SBMAST'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+' AS FILTER_VAL FROM RISK.DBO.VW_RMS_CLIENT_VERTICAL_SBMAST WHERE '+@ACCESS_TO+' = '''+@ACCESS_CODE+''''                               
    END                        
    ELSE IF @ACCESS_TO ='ZONE'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+' AS FILTER_VAL FROM RISK.DBO.ZONE WHERE '+@ACCESS_TO+' = '''+@ACCESS_CODE+''''                               
    END                       
    ELSE IF @ACCESS_TO ='ZNMAST'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+' AS FILTER_VAL FROM RISK.DBO.ZONE WHERE '+@ACCESS_TO+' = '''+@ACCESS_CODE+''''                               
    END       
    /*  COMMENTED BY RASHMI FOR CHANGE IN VIEW                    
    ELSE IF @ACCESS_TO ='REGION'                               
    BEGIN                              
     SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+'_CODE AS FILTER_VAL FROM VW_REGION_GROUP_BRANCHES WHERE '+@ACCESS_TO+'_CODE = '''+@ACCESS_CODE+''''                               
    END        */      
      
    ELSE IF @ACCESS_TO ='REGION'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+'_CODE AS FILTER_VAL FROM RISK.DBO.VW_REGION WHERE '+@ACCESS_TO+'_CODE = '''+@ACCESS_CODE+''''                               
    END                       
               
    ELSE IF @ACCESS_TO ='RGMAST'                               
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+'_CODE AS FILTER_VAL FROM RISK.DBO.VW_REGION_GROUP_BRANCHES WHERE '+@ACCESS_TO+'_CODE = '''+@ACCESS_CODE+''''                               
    END                                               
    ELSE                              
    BEGIN                              
        SET @STR=@STR + ' SELECT DISTINCT '+@RPT_LEVEL+' AS FILTER_VAL FROM RISK.DBO.VW_RMS_CLIENT_VERTICAL WHERE '+@ACCESS_TO+' = '''+@ACCESS_CODE+''''                               
    END                              
                              
    EXEC(@STR)                              
                              
    PRINT @STR                              
                              
    SET NOCOUNT OFF   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_CMSIns
-- --------------------------------------------------
Create Procedure Prc_CMSIns
As
Begin               
insert into cms.dbo.tbl_DTSX_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                  
select GETDATE(),'DTSX Package',0,'Test'  
End

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
-- PROCEDURE dbo.sp_alterdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_CHECK_VERIFICATIONSTATUS
-- --------------------------------------------------
 --use accounts            
             
 CREATE PROC [dbo].[SP_CHECK_VERIFICATIONSTATUS]                
 AS                
                 
   DECLARE @EndDate as DATETIME             
   DECLARE @StartDate as DATETIME            
   DECLARE @START_DCHECK AS INT               
   DECLARE @END_DCHECK AS INT             
   DECLARE @EmailBCC varchar(max)        
            
   SET @START_DCHECK  = 0         
   SET @END_DCHECK = 0          
   SET @EmailBCC =  MISC.DBO.FN_GETGLOBALEMAIL('SP_CHECK_VERIFICATIONSTATUS','BCC')             
                
                
   SET  @StartDate =(select top 1 (Service_Start_Date) from tbl_VERIFICATION_STATUS ORDER BY SRNO DESC)               
   SET  @EndDate =(select top 1 (Service_End_Date) from tbl_VERIFICATION_STATUS ORDER BY SRNO DESC)                
                 
   --PRINT @EndDate            
               
   -- IT WILL CHECK DEFAULT TIME MEANS PROCCESS IS RUNNING THEN KEEP @DCHECK = 0            
                   
   IF @EndDate <> '1900-01-01 00:00:00.000'               
   BEGIN            
  SET   @END_DCHECK = (SELECT datepart(mi,getdate()-@EndDate) AS DiffDate )             
   END            
   ELSE            
   BEGIN            
  SET @START_DCHECK= (SELECT datepart(mi,getdate()-@StartDate) AS DiffDate )            
   END               
                   
   --print @END_DCHECK            
               
   ----------- COMMON PART -----            
               
   DECLARE @MessBody VARCHAR(4000), @MESS AS VARCHAR(4000),@filename as varchar(100)                        
    declare @Count int,@CountEnd int                 
    DECLARE @VerificationData VARCHAR(8000)                 
    DECLARE @AsliSrno INT                
    DECLARE @Service_Start_Date DATETIME                
    DECLARE @Service_End_Date DATETIME                 
    DECLARE @Verification_Cnt BIGINT                
    set @MessBody=''                
    set @MESS=''                
    set @VerificationData=''                
    set @Count=1                
    set @CountEnd=10                
    --DROP TABLE #tp                
    select row_number()over (order by SrNO) AsliSrno, SrNO, Service_Start_Date, Service_End_Date, Verification_Cnt                 
    into #tp from (                
    select top 10 SrNO, Service_Start_Date, Service_End_Date, Verification_Cnt from tbl_VERIFICATION_STATUS ORDER BY SrNO Desc)a                 
    order by srno asc                
                       
    SET @MESS=                
   '<table border="1">                
   <tr>             
    <th> SrNo </th>                
       <th> Service start Date  </th>                
       <th> service End Date  </th>                
       <th> Verification Count/Day </th>                
   </tr>'                
                       
     --PRINT @Count                    
     --PRINT @CountEnd                    
     WHILE @Count <= @CountEnd                    
     BEGIN              
      SELECT @AsliSrno=AsliSrno, @Service_Start_Date=Service_Start_Date,@Service_End_Date=Service_End_Date,@Verification_Cnt=Verification_Cnt FROM #tp WHERE aslisrno=@count                         
      set @VerificationData=@VerificationData+                 
     '<tr>                
     <td> '+ CONVERT(VARCHAR,@AsliSrno) +' </td>                
     <td> '+ CONVERT(VARCHAR,@Service_Start_Date) +' </td>                
     <td> '+ CONVERT(VARCHAR,@Service_End_Date) +' </td>                
     <td> '+ CONVERT(VARCHAR,@Verification_Cnt) +' </td>                
       </tr>'                
      SET   @Count=@Count+1                          
     END            
   -----------------------------            
               
   IF @END_DCHECK > 30                  
   BEGIN               
                               
    SET @MessBody =  '<b>Dear Team</b>,<br/><br/>'+                
         '<b> Verification service is not running from past '+ convert (varchar(10),@END_DCHECK )+' minutes. <b><br/><br/>'+                
         @MESS + @VerificationData + '</Table>'                 
                        
    --PRINT @MessBody    
        
      /*Sending SMS */           
  create table #MobNo1            
  (            
  mobno numeric(10,0)            
  )        
           
  insert into #MobNo1            
  select 8976552188            
  union all            
  select 9892953949       
  union all            
  select 9820556259            
  union all            
  select 7709733841   
  union all  
   select 9833550995 --pooja  
   union all  
   select 9773982517 --sneha  
   union all  
   select 9322836335 --sajeevan  
   union all  
   select 9322258304      
        
  --Trigger SMS.         
           
   insert into intranet.sms.dbo.sms            
   --@MessBody    
   select a.mobno,'Verification service is not running',convert(varchar(10), getdate(), 103),            
   ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +            
   ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),            
   'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12            
   then 'PM' else 'AM' end,'Aggregator Verification Stop'            
   from #MobNo1 a          
         
  /*------------------------------------------------*/                        
                      
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                  
    @RECIPIENTS ='pay-inbanking@angelbroking.com',                        
    @COPY_RECIPIENTS = '',         
 @blind_copy_recipients=@EmailBCC,         
    @PROFILE_NAME = 'Angelbroking',                              
    @BODY_FORMAT ='HTML',                              
    @SUBJECT = 'ALERT !! Aggregator: Funds Payin Details.',                                  
    @FILE_ATTACHMENTS ='',                                 
    @BODY =@MessBody                 
         
    drop table #MobNo1     
                   
   END             
               
   IF @START_DCHECK > 30                  
   BEGIN            
   SET @MessBody =  '<b>Dear Team</b>,<br/><br/>'+                
        '<b> Verification service is running but it takes more than 30 minutes. <b><br/><br/>'+                
        @MESS + @VerificationData + '</Table>'                 
         
       /*Sending SMS */           
   create table #MobNo            
   (            
   mobno numeric(10,0)            
   )        
            
   insert into #MobNo           
   select 8976552188--neha            
   union all            
   select 9892953949--manesh sir       
   union all            
   select 9820556259--           
   union all            
   select 7709733841--  
   union all  
   select 9833550995 --pooja  
   union all  
   select 9773982517 --sneha  
   union all  
   select 9322836335 --sajeevan  
   union all  
   select 9322258304 --hirakh      
         
   --Trigger SMS.               
    insert into intranet.sms.dbo.sms       
    --@MessBody             
    select a.mobno,'Verification service is running slowly',convert(varchar(10), getdate(), 103),            
    ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +            
    ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),            
    'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12            
    then 'PM' else 'AM' end,'Aggregator Verification Stop'            
    from #MobNo a        
   /*------------------------------------------------*/                       
                      
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                  
    @RECIPIENTS ='pay-inbanking@angelbroking.com',                        
    @COPY_RECIPIENTS = '',         
    @blind_copy_recipients=@EmailBCC,         
    @PROFILE_NAME = 'Angelbroking',                              
    @BODY_FORMAT ='HTML',                              
    @SUBJECT = 'ALERT !! Delay in Aggregator Service: Funds Payin Details.',                                  
    @FILE_ATTACHMENTS ='',                                  
    @BODY =@MessBody       
        
     drop table #MobNo     
               
   END      
        
         
   exec AGG_SEND_Email_RejectedFileWithRowState0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_CHECK_VERIFICATIONSTATUS_bkp
-- --------------------------------------------------
 CREATE PROC SP_CHECK_VERIFICATIONSTATUS_bkp      
 AS      
       
 DECLARE @EndDate as DATETIME      
   DECLARE @DCHECK AS INT      
   SET  @EndDate =(select top 1 (Service_End_Date) from tbl_VERIFICATION_STATUS ORDER BY SRNO DESC)      
         
          
   SET   @DCHECK = (SELECT datepart(mi,getdate()-@EndDate) AS DiffDate )      
         
   --print @DCHECK   
     
   IF @DCHECK > 30        
   BEGIN          
       
  DECLARE @MessBody VARCHAR(4000), @MESS AS VARCHAR(4000),@filename as varchar(100)              
  declare @Count int,@CountEnd int       
  DECLARE @VerificationData VARCHAR(8000)       
  DECLARE @AsliSrno INT      
  DECLARE @Service_Start_Date DATETIME      
  DECLARE @Service_End_Date DATETIME       
  DECLARE @Verification_Cnt BIGINT      
  set @MessBody=''      
  set @MESS=''      
  set @VerificationData=''      
  set @Count=1      
  set @CountEnd=10      
  --DROP TABLE #tp      
  select row_number()over (order by SrNO) AsliSrno, SrNO, Service_Start_Date, Service_End_Date, Verification_Cnt       
  into #tp from (      
  select top 10 SrNO, Service_Start_Date, Service_End_Date, Verification_Cnt from tbl_VERIFICATION_STATUS ORDER BY SrNO Desc)a       
  order by srno asc      
           
  SET @MESS=      
    '<table border="1">      
    <tr>      
     <th>      
      SrNo      
     </th>      
     <th>      
      Service start Date      
     </th>      
     <th>      
      service End Date      
     </th>      
     <th>      
      Verification Count/Day     
     </th>      
    </tr>'      
           
   --PRINT @Count          
   --PRINT @CountEnd          
   WHILE @Count <= @CountEnd          
   BEGIN      
       
  SELECT @AsliSrno=AsliSrno, @Service_Start_Date=Service_Start_Date,@Service_End_Date=Service_End_Date,@Verification_Cnt=Verification_Cnt FROM #tp WHERE aslisrno=@count               
  set @VerificationData=@VerificationData+       
    '<tr>      
    <td>      
     '+      
      CONVERT(VARCHAR,@AsliSrno)      
      +      
     '      
    </td>      
    <td>      
     '+      
      CONVERT(VARCHAR,@Service_Start_Date)      
      +      
     '      
    </td>      
    <td>      
     '+      
      CONVERT(VARCHAR,@Service_End_Date)      
      +      
     '      
    </td>      
    <td>      
     '+      
      CONVERT(VARCHAR,@Verification_Cnt)      
      +      
     '      
    </td>      
   </tr>'      
  SET   @Count=@Count+1                
   END                          
              
     --PRINT  @MESS      
              
                   
   SET @MessBody =  '<b>Dear Team</b>,</br></br>'+      
    '<b> Verification service is not running from past 30 minutes. <b></br></br>'+      
     @MESS + @VerificationData + '</Table>'       
            
     --PRINT @MessBody      
           
  --DROP TABLE #tp         
          
  EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                        
  @RECIPIENTS ='rohit.patil@angelbroking.com,neha.naiwar@angelbroking.com',              
  @COPY_RECIPIENTS = 'manesh@angelbroking.com,renil.pillai@angelbroking.com,',                        
  @PROFILE_NAME = 'Angelbroking',                    
  @BODY_FORMAT ='HTML',                    
  @SUBJECT = 'ALERT !! Aggregator: Funds Payin Details.',                        
  @FILE_ATTACHMENTS ='',                        
  @BODY =@MessBody       
         
   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_creatediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_dropdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_findstring
-- --------------------------------------------------
create procedure [dbo].[sp_findstring]
@string varchar(max)
as
begin
select distinct A.name  from sys.objects A
inner join sys .syscomments B
on A.object_id=B.id
where CHARINDEX (@string,B.text)>0
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagramdefinition
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_InsertDDNO
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[sp_InsertDDNO]  
(   
    @DDNO AS varchar(200)='',
    @EnteredBy AS varchar(200)=''       
)                              
AS  
BEGIN
  insert into tbl_chkpost values(@DDNO,getdate(),@EnteredBy)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_renamediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ShowDataInGrid
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SP_ShowDataInGrid]       
 -- Add the parameters for the stored procedure here      
       
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
      
    -- Insert statements for procedure here      
 /*
 select SRNO,BANK_ID,BANK_NAME,TRAN_ID,substring(src_prn,3,(LEN(src_prn)-3)) as SRC_PRN,SRC_AMT,TOTCOMM,SERVICE_TAX,      
 AMT_GIVE_TO_SUBMER,TXN_DATE,TXN_TIME,PAYMENT_DATE,SRC_ITC,STATUS_DESC       
 into #CombineData from tbl_TechFile      
 UNION ALL      
 select  SRNO,BANKID,BANKNAME,TRANSID,SMTXNID,ACTUALTOTAMT,TOTCOMM,SERVICETAX,      
 NETAMOUNT,TXNDATE,TXNTIME,PAYMENTDATE,ITC,STATUS_DESC from tbl_AtomFile      
*/

 --select * from AGG_BO_BankReceipt where ddno='4894695'      
 /*
 select tf.BANK_ID,tf.BANK_NAME,tf.TRAN_ID,tf.SRC_PRN,tf.SRC_AMT,tf.TOTCOMM,tf.SERVICE_TAX,      
 tf.AMT_GIVE_TO_SUBMER,tf.TXN_DATE,tf.TXN_TIME,tf.PAYMENT_DATE,tf.SRC_ITC,tf.STATUS_DESC,
 tf.SRVPRO as NARRATION,
 /*ab.branchcode BRANCH_CODE,ab.generatedon GENERATED_ON,*/
 TXN_date+' '+Txn_time as GENERATED_ON,
 AB.CLIACCOUNTNO CLI_ACCOUNTNO 
 from 
 (
 select SRNO,BANK_ID,BANK_NAME,TRAN_ID,SRC_PRN,SRC_AMT,TOTCOMM,SERVICE_TAX,AMT_GIVE_TO_SUBMER,TXN_DATE,TXN_TIME,PAYMENT_DATE,SRC_ITC,STATUS_DESC,SRVPRO
 from AGG_AtomTechUploadedData where status_desc like  '%success%' and SRC_ITC not like '%NBFC%'
 )   tf      
 left join      
 (
 select 
 [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo
 from AGG_BO_BankReceipt_test where Segment <> 'NBFC'
 )ab 
 on (tf.TRAN_ID=ab.ddno or tf.SRC_PRN=ab.ddno)   
 where /*ab.ddno is null */ 
 ab.ResponseCode is null 
 order by tf.TRAN_ID      
 */
 Select 
 BANK_ID,BANK_NAME,TRAN_ID,SRC_PRN,SRC_AMT,TOTCOMM,SERVICE_TAX,AMT_GIVE_TO_SUBMER,TXN_DATE,TXN_TIME,PAYMENT_DATE,SRC_ITC,STATUS_DESC,NARRATION,GENERATED_ON,CLI_ACCOUNTNO
 From AGG_Reco_View
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_test
-- --------------------------------------------------
CREATE proc sp_test
as
begin
  
 select distinct                  
   Requestid=b1.Requestid,                    
   Vendor,                    
   Merchantid=VendorMerchantID,                    
   MerchantTransactionid=TransactionMerchantID,                     
   Amount=convert(decimal(20,2),Amount),                    
   LogDate,            
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),      
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),      
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')          
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                  
   RequestTime=getdate(),                    
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                  
    ,b1.TransactionVerified      
  from                     
   Test b1 with(nolock)      
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                      
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                  
  where            
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                  
  and (isnull(b1.TransactionVerified,'') <> 'Y')           
  AND B1.VendorMerchantID in ('167','L1668' )   
  AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   Test ),106)     
 --and logDate > convert(varchar(11),getdate(),109)       
 --and Vendor <> 'TECHPROCESS'       
 --and Vendor = 'TECHPROCESS'      
  order by LogDate   DESC  

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_upgraddiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_who4
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[sp_who4]   
@loginame sysname = NULL,   
/* NEW PARAMETER ADDED BY CHB */   
@hostname sysname = NULL,   
/* NEW PARAMETER ADDED BY The Indoctrinator!!*/  
@PRG_NAME as varchar(50) = ''   
as   
  
set nocount on   
  
if @hostname is null set @hostname = '0'   
  
declare   
@retcode int   
  
declare   
@sidlow varbinary(85)   
,@sidhigh varbinary(85)   
,@sid1 varbinary(85)   
,@spidlow int   
,@spidhigh int   
  
declare   
@charMaxLenLoginName varchar(6)   
,@charMaxLenDBName varchar(6)   
,@charMaxLenCPUTime varchar(10)   
,@charMaxLenDiskIO varchar(10)   
,@charMaxLenHostName varchar(10)   
,@charMaxLenProgramName varchar(10)   
,@charMaxLenLastBatch varchar(10)   
,@charMaxLenCommand varchar(10)   
  
declare   
@charsidlow varchar(85)   
,@charsidhigh varchar(85)   
,@charspidlow varchar(11)   
,@charspidhigh varchar(11)   
DECLARE @strQUERY as varchar(7000)   
set @strQUERY = ''  
--------   
  
select   
@retcode = 0 -- 0=good ,1=bad.   
  
--------defaults   
select @sidlow = convert(varbinary(85), (replicate(char(0), 85)))   
select @sidhigh = convert(varbinary(85), (replicate(char(1), 85)))   
  
select   
@spidlow = 0   
,@spidhigh= 32767   
  
----------------------------------------  
----------------------   
IF (@loginame IS NULL) --Simple default to all LoginNames.   
GOTO LABEL_17PARM1EDITED   
  
--------   
  
-- select @sid1 = suser_sid(@loginame)   
select @sid1 = null   
if exists(select * from master.dbo.syslogins where loginname = @loginame)   
select @sid1 = sid from master.dbo.syslogins where loginname = @loginame   
  
IF (@sid1 IS NOT NULL) --Parm is a recognized login name.   
   
begin   
select @sidlow = suser_sid(@loginame)   
,@sidhigh = suser_sid(@loginame)   
GOTO LABEL_17PARM1EDITED   
end   
  
--------   
  
IF (lower(@loginame) IN ('active')) --Special action, not sleeping.   
   
begin   
select @loginame = lower(@loginame)   
GOTO LABEL_17PARM1EDITED   
end   
  
--------   
  
IF (patindex ('%[^0-9]%' , isnull(@loginame,'z')) = 0) --Is a number.   
   
begin   
select   
@spidlow= convert(int, @loginame)   
,@spidhigh = convert(int, @loginame)   
GOTO LABEL_17PARM1EDITED   
end   
  
--------   
  
RaisError(15007,-1,-1,@loginame)   
select @retcode = 1   
GOTO LABEL_86RETURN   
  
  
LABEL_17PARM1EDITED:   
  
  
-------------------- Capture consistent   
-- sysprocesses. -------------------   
  
SELECT   
  
spid   
,CAST(null AS VARCHAR(5000)) as commandtext   
,status   
,sid   
,hostname   
,program_name   
,cmd   
,cpu   
,physical_io   
,blocked   
,dbid   
,convert(sysname, rtrim(loginame))   
as loginname   
,spid as 'spid_sort'   
  
, substring( convert(varchar,last_batch,111) ,6 ,5 ) + ' '   
+ substring( convert(varchar,last_batch,113) ,13 ,8 )   
as 'last_batch_char'   
  
INTO #tb1_sysprocesses   
from master.dbo.sysprocesses(nolock)  
  
/*******************************************   
  
FOLLOWING SECTION ADDED BY CHB 05/06/2004   
  
RETURNS LAST COMMAND EXECUTED BY EACH SPID   
  
********************************************/   
  
CREATE TABLE #spid_cmds   
(SQLID INT IDENTITY, spid INT, EventType VARCHAR(100), Parameters INT, Command VARCHAR(8000))   
  
DECLARE spids CURSOR FOR   
SELECT spid FROM #tb1_sysprocesses   
  
DECLARE @spid INT, @sqlid INT   
  
OPEN spids   
FETCH NEXT FROM spids  
INTO @spid   
  
/*   
EXECUTE DBCC INPUTBUFFER FOR EACH SPID   
*/   
  
WHILE (@@FETCH_STATUS = 0)   
   
BEGIN   
INSERT INTO #spid_cmds (EventType, Parameters, Command)   
EXEC('DBCC INPUTBUFFER( ' + @spid + ')')   
  
SELECT @sqlid = MAX(SQLID) FROM #spid_cmds   
  
UPDATE #spid_cmds SET spid = @spid WHERE SQLID = @sqlid  
  
FETCH NEXT FROM spids INTO @spid   
  
END   
  
CLOSE spids   
DEALLOCATE spids   
  
UPDATE p   
SET p.commandtext = s.command   
FROM #tb1_sysprocesses P   
JOIN #spid_cmds s   
ON p.spid = s.spid   
  
----------------------------------------  
-----   
  
--------Screen out any rows?   
  
IF (@loginame IN ('active'))   
DELETE #tb1_sysprocesses   
where lower(status) = 'sleeping'   
and upper(cmd)IN (   
'AWAITING COMMAND'   
,'MIRROR HANDLER'   
,'LAZY WRITER'   
,'CHECKPOINT SLEEP'   
,'RA MANAGER'   
)   
  and blocked= 0   
  
  
  
--------Prepare to dynamically optimize   
-- column widths.   
  
  
Select   
@charsidlow = convert(varchar(85),@sidlow)   
,@charsidhigh= convert(varchar(85),@sidhigh)   
,@charspidlow = convert(varchar,@spidlow)   
,@charspidhigh= convert(varchar,@spidhigh)   
  
  
  
SELECT   
@charMaxLenLoginName =   
convert( varchar   
,isnull( max( datalength(loginname)) ,5)   
)   
  
,@charMaxLenDBName=   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),db_name(dbid))))) ,6)   
)   
  
,@charMaxLenCPUTime=   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),cpu)))) ,7)   
)   
  
,@charMaxLenDiskIO=   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),physical_io)))) ,6)   
)   
  
,@charMaxLenCommand =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),cmd)))) ,7)   
)   
  
,@charMaxLenHostName =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),hostname)))) ,8)   
)   
  
,@charMaxLenProgramName =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),program_name)))) ,11)   
)   
  
,@charMaxLenLastBatch =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),last_batch_char)))) ,9)   
)   
from   
#tb1_sysprocesses   
where   
-- sid >= @sidlow   
-- andsid <= @sidhigh   
-- and   
spid >= @spidlow   
and spid <= @spidhigh   
  
  
  
--------Output the report.   
  
  
--EXECUTE(   
set @strQUERY= '   
SET nocount off   
  
SELECT   
SPID = convert(char(5),spid)   
,CommandText  
  
,Status=   
CASE lower(status)   
When ''sleeping'' Then lower(status)   
Else upper(status)   
END   
  
,Login = substring(loginname,1,' + @charMaxLenLoginName + ')   
  
,HostName =   
CASE hostname   
When Null Then '' .''   
When '' '' Then '' .''   
Else substring(hostname,1,' + @charMaxLenHostName + ')   
END   
  
,BlkBy =   
CASE isnull(convert(char(5),blocked),''0'')   
When ''0'' Then '' .''   
Else isnull(convert(char(5),blocked),''0'')   
END   
  
,DBName= substring(case when dbid = 0 then null when dbid <> 0 then db_name(dbid) end,1,' + @charMaxLenDBName + ')   
,Command= substring(cmd,1,' + @charMaxLenCommand + ')   
  
,CPUTime= substring(convert(varchar,cpu),1,' + @charMaxLenCPUTime + ')   
,DiskIO= substring(convert(varchar,physical_io),1,' + @charMaxLenDiskIO + ')   
  
,LastBatch = substring(last_batch_char,1,' + @charMaxLenLastBatch + ')   
  
,ProgramName= substring(program_name,1,' + @charMaxLenProgramName + ')   
,SPID = convert(char(5),spid) --Handy extra for right-scrolling users.   
from   
#tb1_sysprocesses --Usually DB qualification is needed in exec().   
where   
spid >= ' + @charspidlow + '   
and spid <= ' + @charspidhigh + '   
and (HostName like ''' + @hostname + '%'' or ''' + @hostname + ''' = ''0'')   
AND substring(program_name,1,' + @charMaxLenProgramName + ') like(''%' + @PRG_NAME + '%'')  
  
  
-- (Seems always auto sorted.)order by   
-- spid_sort   
  
SET nocount on   
'   
--print @strQUERY  
EXECUTE (@strQUERY)   
/*****AKUNDONE: removed from where-clause in above EXEC sqlstr   
sid >= ' + @charsidlow + '   
andsid <= ' + @charsidhigh + '   
and   
**************/   
  
  
LABEL_86RETURN:   
  
  
if (object_id('tempdb..#tb1_sysprocesses') is not null)   
drop table #tb1_sysprocesses   
  
return @retcode -- sp_who4

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_GetFTMimansaPGDetailsForMF360Summary
-- --------------------------------------------------

CREATE PROC stp_GetFTMimansaPGDetailsForMF360Summary

(
@CLIENT_CODE VARCHAR(50)
)

AS
BEGIN
--set @CLIENT_CODE ='J48812'

SELECT 'FT' as PaymentGateway,AppName	,Party_Code	,Segment	,BankName	,BankAccountNo	,Amount	,LogDate	,Vendor	,VendorMerchantID	,TransactionMerchantID	
,TransactionReferenceNo	,TransactionStatus	,TransactionRemark	,TransactionDate	,TransactionVerified	,VerificationRemark	,VerificationDate

from [dbo].[tbl_AngelPGIMBOTransactionLog] with (nolock)
where Party_Code= @CLIENT_CODE 

UNION

SELECT 'MIMANSA' as PaymentGateway, AppName	,Party_Code	,Segment	,BankName	,BankAccountNo	,Amount	,LogDate	,Vendor	,VendorMerchantID	,TransactionMerchantID	
,TransactionReferenceNo	,TransactionStatus	,TransactionRemark	,TransactionDate	,TransactionVerified	,VerificationRemark	,VerificationDate
from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog  with (nolock)
where Party_Code= @CLIENT_CODE 


order by LogDate desc

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TestPackageCall
-- --------------------------------------------------
CREATE Procedure [dbo].[TestPackageCall]        
as        
    
Set nocount on                                    
SET XACT_ABORT ON                                       
BEGIN TRY           
declare @cmd varchar(1000)            
declare @ssispath varchar(1000)           
/*set @ssispath = 'D:\Test\TestPackage\TestPackage\Package.dtsx'        */

set @ssispath = 'I:\Test\TestPackage\TestPackage\Package.dtsx'      
    
--select @cmd = 'dtexec /F "' + @ssispath + '"'            
select @cmd = 'dtexec /F "' + @ssispath + '" /DECRYPT "pass@123"'            
        
select @cmd --= @cmd            
exec master..xp_cmdshell @cmd           
               
insert into cms.dbo.tbl_DTSX_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                  
select GETDATE(),'DTSX Package',0,'TestABC'    
        
END TRY                  
                  
 BEGIN CATCH                  
 insert into cms.dbo.tbl_DTSX_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                  
  select GETDATE(),'DTSX Package',ERROR_LINE(),ERROR_MESSAGE()                                                                  
                            
  DECLARE @ErrorMessage NVARCHAR(4000);                         
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                              
  RAISERROR (@ErrorMessage , 16, 1);                          
                                
 END CATCH                           
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_access_level_1
-- --------------------------------------------------
	
	
	
CREATE PROCEDURE USP_ACCESS_LEVEL_1  --'BRANCH'               
(            
		@ACEESS_TO AS VARCHAR(50)  
)                           
AS 
BEGIN                                        
SET NOCOUNT ON                                     
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                              

	SELECT ACCESS_LEVEL_VALUE,
		   ACCESS_LEVEL_NAME 
     FROM RISK.DBO.ACCESS_LEVEL 
     WHERE ACCESS_LEVEL_CODE >= (SELECT ACCESS_LEVEL_CODE 
								 FROM RISK.DBO.ACCESS_LEVEL 
								 WHERE ACCESS_LEVEL_VALUE=@ACEESS_TO )                    
									   AND ACCESS_LEVEL_ACTIVE=1 
									   AND ACCESS_LEVEL_CODE > 0 
									   AND ACCESS_LEVEL_VALUE NOT IN ('RGMAST','ZNMAST','ZONE')        
	ORDER BY ACCESS_LEVEL_CODE 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Agg_MKTAPI_AccMissing
-- --------------------------------------------------
CREATE PROC [dbo].[Usp_Agg_MKTAPI_AccMissing]         
AS               
BEGIN  
  
	----------///// RETURN_FLD1='ACCOUNT NO MISSING'///--------------  
	insert into Agg_tbl_AccMissing_Data  
	(FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,  
	BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,  
	RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE)   
	select  
	FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,  
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,  
	ROWSTATE from AngelBSECM.MKTAPI.dbo.tbl_post_data where VDATE=convert(varchar(10), getdate(),120) and RETURN_FLD1='ACCOUNT NO MISSING' and 
	ROWSTATE=99 and RETURN_FLD5='IH_Aggregator' and EXCHANGE<>'' and SEGMENT<>'' 
	
	-----------//////////////insert Hist Table///------------  
	--insert into Agg_tbl_AccMissing_Data_Hist  
	--(FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,  
	--BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,  
	--RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,ROWSTATE,LastUpdateDate)  
	--select  
	--FLDAUTO,VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,  
	--CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,RETURN_FLD4,RETURN_FLD5,  
	--ROWSTATE,GETDATE() from Agg_tbl_AccMissing_Data   
	
	-------------////////Update table ////////////-----------------  
	Update Agg_tbl_AccMissing_Data  
	set RETURN_FLD1=NULL,ROWSTATE=0  
	  
	--------------------/////Delete From AngelBSECM.MKTAPI.dbo.tbl_post_data///////-------------------    
	Delete from AngelBSECM.MKTAPI.dbo.tbl_post_data where VDATE=convert(varchar(10), getdate(),120) and RETURN_FLD1='ACCOUNT NO MISSING' and 
	ROWSTATE=99  and RETURN_FLD5='IH_Aggregator' 
	  
	--------------------/////Again Insert main table ///////-------------------  
	insert into AngelBSECM.MKTAPI.dbo.tbl_post_data   
	(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,ROWSTATE)                    
	select   
	VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,  
	CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD4,RETURN_FLD5,  
	ROWSTATE from Agg_tbl_AccMissing_Data  
	  
	truncate table Agg_tbl_AccMissing_Data  
	
	--exec Agg_Segment_Missing_In_BO
	
	Insert GBL_Temp_checking_pkg(sp_name,UpdatedOn)
	select 'Usp_Agg_MKTAPI_AccMissing',getdate()
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_agreegator_Error_Mailer
-- --------------------------------------------------
CREATE PROC [dbo].[usp_agreegator_Error_Mailer]  
(  
@request varchar(500),  
@methodname varchar(200),  
@errormessage varchar(max),  
@status varchar(200)  
)  
as  
begin  
DECLARE @msgBody AS VARCHAR(MAX)      
DECLARE @Sub as varchar(100)  
SET @msgbody = ''      
  
  
--IF(ISNULL(@status ,'') = 'success')  
--BEGIN  
-- SET @msgbody ='<html><head>                                                
-- <title>Agreegator Success Mailer</title></head><body><form><div>request : -  ' + @request  + ' method  Name : - ' + @methodname  +  ' Error message : - '+@errormessage +'<br/><br/>'    
-- set @Sub = 'Agreegator Mailer'  
--END  
--ELSE  
--BEGIN  
-- SET @msgbody ='<html><head>                                                
-- <title>Agreegator Failure Mailer</title></head><body><form><div>request : -  ' + @request  + ' method  Name : - ' + @methodname  +  ' Error message : - '+@errormessage +'<br/><br/>'    
-- set @Sub = 'Agreegator Mailer'  
--end  
  
  
  
  
    
--IF(NULLIF(@msgbody,'') IS NOT NULL)      
--BEGIN      
-- DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX) ,@MESS varchar(max)                                     
-- SET @TO = 'rohit.patil@angelbroking.com'                                  
-- SET @CC = 'neha.naiwar@angelbroking.com;'         
-- SET @MESS = @msgbody + '</table></form></body></html>'      
       
-- PRINT @msgbody                      
-- PRINT LEN(@msgbody)      
      
-- EXEC MSDB.DBO.SP_SEND_DBMAIL                                    
-- @RECIPIENTS = @TO,                                    
--@COPY_RECIPIENTS = @CC,                                    
-- --@BLIND_COPY_RECIPIENTS = @BCC,                      
-- @PROFILE_NAME = 'Angelbroking',                                    
-- @BODY_FORMAT ='HTML',                                    
-- @SUBJECT = @sub,                                    
-- @BODY =@mess                                    
--END    
  
INSERT INTO TBLAGREEGATORVERIFICATIONERRORLOG(REQUEST,METHODNAME,ERRORMESSAGE,status,INSERTEDON)  
SELECT @REQUEST,@METHODNAME,@ERRORMESSAGE,@status,GETDATE()  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_agreegator_Error_Mailer_successtransaction
-- --------------------------------------------------
CREATE PROC [dbo].[usp_agreegator_Error_Mailer_successtransaction]    
(    
@request varchar(500),    
@methodname varchar(200),    
@errormessage varchar(max),    
@status varchar(200)    
)    
as    
begin    
DECLARE @msgBody AS VARCHAR(MAX)        
DECLARE @Sub as varchar(100)    
SET @msgbody = ''        
    
    
--IF(ISNULL(@status ,'') = 'success')    
--BEGIN    
-- SET @msgbody ='<html><head>                                                  
-- <title>Agreegator Success Mailer</title></head><body><form><div>request : -  ' + @request  + ' method  Name : - ' + @methodname  +  ' Error message : - '+@errormessage +'<br/><br/>'      
-- set @Sub = 'Agreegator Success Transaction Mailer'    
--END    
--ELSE    
--BEGIN    
-- SET @msgbody ='<html><head>                                                  
-- <title>Agreegator Failure Mailer</title></head><body><form><div>request : -  ' + @request  + ' method  Name : - ' + @methodname  +  ' Error message : - '+@errormessage +'<br/><br/>'      
-- set @Sub = 'Agreegator Success Transaction Mailer'    
--end    
    
    
    
    
      
--IF(NULLIF(@msgbody,'') IS NOT NULL)        
--BEGIN        
-- DECLARE @TO VARCHAR(MAX),@CC VARCHAR(MAX),@BCC VARCHAR(MAX) ,@MESS varchar(max)                                       
-- SET @TO = 'rohit.patil@angelbroking.com'                                    
-- SET @CC = 'neha.naiwar@angelbroking.com;'           
-- SET @MESS = @msgbody + '</table></form></body></html>'        
         
-- PRINT @msgbody                        
-- PRINT LEN(@msgbody)        
        
-- EXEC MSDB.DBO.SP_SEND_DBMAIL                                      
-- @RECIPIENTS = @TO,                                      
-- @COPY_RECIPIENTS = @CC,                                      
-- --@BLIND_COPY_RECIPIENTS = @BCC,                        
-- @PROFILE_NAME = 'Angelbroking',                                      
-- @BODY_FORMAT ='HTML',                                      
-- @SUBJECT = @sub,                                      
-- @BODY =@mess                                      
--END      
    
INSERT INTO TBLAGREEGATORVERIFICATIONERRORLOG(REQUEST,METHODNAME,ERRORMESSAGE,status,INSERTEDON)    
SELECT @REQUEST,@METHODNAME,@ERRORMESSAGE,@status,GETDATE()    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AgreegatorTranPaynetTechRequestResponse
-- --------------------------------------------------
CREATE proc usp_AgreegatorTranPaynetTechRequestResponse(
@vendor varchar(50),
@request varchar(max),
@response varchar(max)
)
as
begin
insert into AgreegatorTranPaynetTechRequestResponse
select @vendor,@request,@response,getdate()
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_AMD_tbl_AngelPGIMBOTransactionLog
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_AMD_tbl_AngelPGIMBOTransactionLog]
AS
BEGIN	
	TRUNCATE TABLE tbl_AngelPGIMBOTransactionLog
	
	INSERT INTO tbl_AngelPGIMBOTransactionLog
	(
RequestID
,AppName
,Party_Code
,Segment
,BankName
,BankAccountNo
,Amount
,LogDate
,Vendor
,VendorMerchantID
,TransactionMerchantID
,TransactionReferenceNo
,TransactionStatus
,TransactionRemark
,TransactionDate
,TransactionVerified
,VerificationRemark
,VerificationDate
,LimitUpdateStatus
,LimitUpdateRequestInitiatedAt
,LimitUpdateResponseRecvdAt
,LimitUpdateResponse
,LimitUpdationDoneBy
,LimitUpdationAPIStatus
,LimitUpdationAPIMessage
,TransactionReVerified
,ReVerificationRemark
,ReVerificationDate
,ExtraField1
,ExtraField2
,ExtraField3
,ExtraField4
,ExtraField5
	)
	SELECT 
RequestID
,AppName
,Party_Code
,Segment
,BankName
,BankAccountNo
,Amount
,LogDate
,Vendor
,VendorMerchantID
,TransactionMerchantID
,TransactionReferenceNo
,TransactionStatus
,TransactionRemark
,TransactionDate
,TransactionVerified
,VerificationRemark
,VerificationDate
,LimitUpdateStatus
,LimitUpdateRequestInitiatedAt
,LimitUpdateResponseRecvdAt
,LimitUpdateResponse
,LimitUpdationDoneBy
,LimitUpdationAPIStatus
,LimitUpdationAPIMessage
,TransactionReVerified
,ReVerificationRemark
,ReVerificationDate
,ExtraField1
,ExtraField2
,ExtraField3
,ExtraField4
,ExtraField5

FROM  Accounts.dbo.tbl_AngelPGIMBOTransactionLog with (nolock) 
	
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMGetTransactionForVerification
-- --------------------------------------------------
CREATE procedure [dbo].[usp_AngelPGIMGetTransactionForVerification]                
(                
 @option varchar(50)                
)                      
as                   
/*                
                
[usp_AngelPGIMGetTransactionForVerification] 'VERIFICATION'               
        
[usp_AngelPGIMGetTransactionForVerification] 'reVERIFICATION'             
        
*/                   
begin                      

 DECLARE @Date VARCHAR(12),@InsDate DATETIME                                                              
 DECLARE @Days VARCHAR(20)               
 
 
                                              
 SET @Days = (                                              
   SELECT DATENAME(dw, GETDATE())                                              
   )                                              
                                              
 IF (@Days = 'Monday')                                              
 BEGIN                                             
 /* 
  SET @InsDate = (select Max(SAUDA_DATE)                                                                
				  FROM   MIS.REMISIOR.DBO.COMB_CO with(nolock)  
					WHERE Isnull(BROK_EARNED, 0) > 0)
 */					
 SET @InsDate = GETDATE()-3 
 							
 END 
 else
 BEGIN                                                                                   
SET @InsDate = GETDATE() - 2                                              
 END                                     
                                      
                      
        
 if(upper(@option)='VERIFICATION')                
 begin              
 /*            
 select distinct                    
   Requestid=b1.Requestid,                      
   Vendor,                      
   Merchantid=VendorMerchantID,                      
   MerchantTransactionid=TransactionMerchantID,                       
   Amount=convert(decimal(20,2),Amount),                      
   LogDate,              
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),        
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),        
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')            
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                    
   RequestTime=getdate(),                      
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                    
    ,b1.TransactionVerified        
  from                       
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)        
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                        
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                    
  where              
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                    
  and (isnull(b1.TransactionVerified,'') <> 'Y')             
  AND B1.VendorMerchantID in ('167','L1668' )     
  AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)       
 --and logDate > convert(varchar(11),getdate(),109)         
 --and Vendor <> 'TECHPROCESS'         
 --and Vendor = 'TECHPROCESS'        
  order by LogDate   DESC      
  */    
      
   select distinct                    
    Requestid=b1.Requestid,                      
    Vendor,                      
    Merchantid=VendorMerchantID,                      
    MerchantTransactionid=TransactionMerchantID,                       
    Amount=convert(decimal(20,2),Amount),                      
    LogDate,              
    TransactionReferenceNo=isnull(TransactionReferenceNo,''),                  
    RequestTime=convert(varchar,getdate()),    
/*    date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                    */
	date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,LogDate,106),' ',''))  end   
  ,b1.TransactionVerified        
   from                       
    tbl_AngelPGIMBoTransactionLog b1 with(nolock)        
   where              
   VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                    
   and (isnull(b1.TransactionVerified,'') <> 'Y')             
   AND B1.VendorMerchantID in ('167','L1668' )     
   AND  Logdate >  convert(varchar(12),@InsDate,106)          
      union    
    select distinct                      
    Requestid=b1.Requestid,                        
    Vendor,                        
    Merchantid=VendorMerchantID,                        
    MerchantTransactionid=TransactionMerchantID,                         
    Amount=convert(decimal(20,2),Amount),                        
    LogDate,                
    TransactionReferenceNo=isnull(TransactionReferenceNo,''),          
    RequestTime=convert(varchar,getdate()),    
   /* date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end*/ /*Commented on 23 Nov 2017 by Neha*/
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,LogDate,106),' ',''))  end                      
  ,b1.TransactionVerified        
   from                         
    tbl_AngelPGIMBoTransactionLog b1 with(nolock)          
   where                
   VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                      
   and (isnull(b1.TransactionVerified,'') = 'Y')   and  VerificationRemark = 'FAIL'            
   AND B1.VendorMerchantID in ('167','L1668' )       
   AND Logdate >  convert(varchar(12),@InsDate,106)      
   -- and Logdate>='08 mar 2017'    
   order by LogDate   DESC               
                     
 end                    
                
 if(upper(@option)='REVERIFICATION')                
 begin               
             
 select distinct            
   Requestid=b1.Requestid,                      
   Vendor,                      
   Merchantid=VendorMerchantID,                      
   MerchantTransactionid=TransactionMerchantID,                       
   Amount=convert(decimal(20,2),Amount),                      
   LogDate,              
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),                    
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),                    
                       
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')            
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                    
   RequestTime=convert(varchar,getdate()),    
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,LogDate,106),' ',''))  end                   
  from                       
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)              
                  
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                        
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                  
                 
  where               
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                    
    AND (B1.VendorMerchantID ='225' or B1.VendorMerchantID ='L1668' )                  
    --and (isnull(b1.TransactionReVerified,'') <> 'Y' )                
   and logDate >= left(dateadd(dd,-3,getdate()),11) + ' 00:00'                 
   and logDate <  left(getdate(),11) + ' 00:00:00.000'           
   --and Vendor <> 'TECHPROCESS'         
   --and Vendor = 'TECHPROCESS'             
         
 order by LogDate DESC         
 end                    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMGetTransactionForVerification_03Mar2017
-- --------------------------------------------------
 --[usp_AngelPGIMGetTransactionForVerification]  
create procedure [dbo].[usp_AngelPGIMGetTransactionForVerification_03Mar2017]            
(            
 @option varchar(50)            
)                  
as               
/*            
            
[usp_AngelPGIMGetTransactionForVerification] 'VERIFICATION'           
    
[usp_AngelPGIMGetTransactionForVerification] 'reVERIFICATION'         
    
*/               
begin                  
                  
    
 if(upper(@option)='VERIFICATION')            
 begin          
         
 select distinct                
   Requestid=b1.Requestid,                  
   Vendor,                  
   Merchantid=VendorMerchantID,                  
   MerchantTransactionid=TransactionMerchantID,                   
   Amount=convert(decimal(20,2),Amount),                  
   LogDate,          
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),    
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),    
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')        
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                
   RequestTime=getdate(),                  
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                
    ,b1.TransactionVerified    
  from                   
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)    
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                    
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                
  where          
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                
  and (isnull(b1.TransactionVerified,'') <> 'Y')         
  AND B1.VendorMerchantID in ('167','L1668' ) 
  AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)   
 --and logDate > convert(varchar(11),getdate(),109)     
 --and Vendor <> 'TECHPROCESS'     
 --and Vendor = 'TECHPROCESS'    
  order by LogDate   DESC      
                 
 end                
            
 if(upper(@option)='REVERIFICATION')            
 begin           
         
 select distinct        
   Requestid=b1.Requestid,                  
   Vendor,                  
   Merchantid=VendorMerchantID,                  
   MerchantTransactionid=TransactionMerchantID,                   
   Amount=convert(decimal(20,2),Amount),                  
   LogDate,          
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),                
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),                
                   
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')        
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                
   RequestTime=getdate(),                
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end               
  from                   
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)          
              
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                    
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid              
             
  where           
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                
    AND (B1.VendorMerchantID ='225' or B1.VendorMerchantID ='L1668' )              
    --and (isnull(b1.TransactionReVerified,'') <> 'Y' )            
   and logDate >= left(dateadd(dd,-3,getdate()),11) + ' 00:00'             
   and logDate <  left(getdate(),11) + ' 00:00:00.000'       
   --and Vendor <> 'TECHPROCESS'     
   --and Vendor = 'TECHPROCESS'         
     
 order by LogDate DESC     
 end                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMGetTransactionForVerification_development
-- --------------------------------------------------
CREATE procedure [dbo].[usp_AngelPGIMGetTransactionForVerification_development]                
(                
 @option varchar(50)                
)                      
as                   
/*                
                
[usp_AngelPGIMGetTransactionForVerification] 'VERIFICATION'               
        
[usp_AngelPGIMGetTransactionForVerification] 'reVERIFICATION'             
        
*/                   
begin                      
                      
        
 if(upper(@option)='VERIFICATION')                
 begin                   
   select distinct                    
    Requestid=b1.Requestid,                      
    Vendor,                      
    Merchantid=VendorMerchantID,                      
    MerchantTransactionid=TransactionMerchantID,                       
    Amount=convert(decimal(20,2),Amount),                      
    LogDate,              
    TransactionReferenceNo=isnull(TransactionReferenceNo,''),                  
    RequestTime=convert(varchar,getdate()),    
    date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                    
  ,b1.TransactionVerified        
   from                       
    tbl_AngelPGIMBoTransactionLog b1 with(nolock)        
   where              
   VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                    
   and (isnull(b1.TransactionVerified,'') <> 'Y') 
   AND TransactionStatus <> 'SUCCESS'            
   AND B1.VendorMerchantID in ('167','L1668' )     
   AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)          
      union    
    select distinct                      
    Requestid=b1.Requestid,                        
    Vendor,                        
    Merchantid=VendorMerchantID,                        
    MerchantTransactionid=TransactionMerchantID,                         
    Amount=convert(decimal(20,2),Amount),                        
    LogDate,                
    TransactionReferenceNo=isnull(TransactionReferenceNo,''),          
    RequestTime=convert(varchar,getdate()),    
    date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                      
  ,b1.TransactionVerified        
   from                         
    tbl_AngelPGIMBoTransactionLog b1 with(nolock)          
   where                
   VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                      
   and (isnull(b1.TransactionVerified,'') = 'Y')   and  VerificationRemark = 'FAIL'            
   AND B1.VendorMerchantID in ('167','L1668' )       
   AND Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)      
   -- and Logdate>='08 mar 2017'    
   order by LogDate   DESC               
                     
 end                    
                
 if(upper(@option)='REVERIFICATION')                
 begin               
             
 select distinct            
   Requestid=b1.Requestid,                      
   Vendor,                      
   Merchantid=VendorMerchantID,                      
   MerchantTransactionid=TransactionMerchantID,                       
   Amount=convert(decimal(20,2),Amount),                      
   LogDate,              
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),                    
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),                    
                       
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')            
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                    
   RequestTime=convert(varchar,getdate()),    
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                   
  from                       
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)              
                  
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                        
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                  
                 
  where               
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                    
    AND (B1.VendorMerchantID ='225' or B1.VendorMerchantID ='L1668' )                  
    --and (isnull(b1.TransactionReVerified,'') <> 'Y' )                
   and logDate >= left(dateadd(dd,-3,getdate()),11) + ' 00:00'                 
   and logDate <  left(getdate(),11) + ' 00:00:00.000'           
   --and Vendor <> 'TECHPROCESS'         
   --and Vendor = 'TECHPROCESS'             
         
 order by LogDate DESC         
 end                    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMGetTransactionForVerification_newlogic
-- --------------------------------------------------

CREATE procedure [dbo].[usp_AngelPGIMGetTransactionForVerification_newlogic]              
(              
 @option varchar(50)              
)                    
as                 
/*              
              
[usp_AngelPGIMGetTransactionForVerification] 'VERIFICATION'             
      
[usp_AngelPGIMGetTransactionForVerification] 'reVERIFICATION'           
      
*/                 
begin                    
                    
      
 if(upper(@option)='VERIFICATION')              
 begin            
 /*          
 select distinct                  
   Requestid=b1.Requestid,                    
   Vendor,                    
   Merchantid=VendorMerchantID,                    
   MerchantTransactionid=TransactionMerchantID,                     
   Amount=convert(decimal(20,2),Amount),                    
   LogDate,            
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),      
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),      
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')          
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                  
   RequestTime=getdate(),                    
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                  
    ,b1.TransactionVerified      
  from                     
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)      
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                      
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                  
  where            
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                  
  and (isnull(b1.TransactionVerified,'') <> 'Y')           
  AND B1.VendorMerchantID in ('167','L1668' )   
  AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)     
 --and logDate > convert(varchar(11),getdate(),109)       
 --and Vendor <> 'TECHPROCESS'       
 --and Vendor = 'TECHPROCESS'      
  order by LogDate   DESC    
  */  
    
   select distinct                  
    Requestid=b1.Requestid,                    
    Vendor,                    
    Merchantid=VendorMerchantID,                    
    MerchantTransactionid=TransactionMerchantID,                     
    Amount=convert(decimal(20,2),Amount),                    
    LogDate,            
    TransactionReferenceNo=isnull(TransactionReferenceNo,''),                
    RequestTime=getdate(),                    
    date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                  
  ,b1.TransactionVerified      
   from                     
    tbl_AngelPGIMBoTransactionLog_newlogic b1 with(nolock)      
   where            
   VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                  
   and (isnull(b1.TransactionVerified,'') <> 'Y')           
   AND B1.VendorMerchantID in ('167','L1668' )   
   AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog_newlogic ),106)        
  --    union  
  --  select distinct                    
  --  Requestid=b1.Requestid,                      
  --  Vendor,                      
  --  Merchantid=VendorMerchantID,                      
  --  MerchantTransactionid=TransactionMerchantID,                       
  --  Amount=convert(decimal(20,2),Amount),                      
  --  LogDate,              
  --  TransactionReferenceNo=isnull(TransactionReferenceNo,''),        
  --  RequestTime=getdate(),                      
  --  date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                    
  --,b1.TransactionVerified        
  -- from                       
  --  tbl_AngelPGIMBoTransactionLog_newlogic b1 with(nolock)        
  -- where              
  -- VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                    
  -- and (isnull(b1.TransactionVerified,'') = 'Y')   and  VerificationRemark = 'FAIL'          
  -- AND B1.VendorMerchantID in ('167','L1668' )     
  -- AND Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog_newlogic ),106)    
   -- and Logdate>='08 mar 2017'  
   order by LogDate   DESC             
                   
 end                  
              
 if(upper(@option)='REVERIFICATION')              
 begin             
           
 select distinct          
   Requestid=b1.Requestid,                    
   Vendor,                    
   Merchantid=VendorMerchantID,                    
   MerchantTransactionid=TransactionMerchantID,                     
   Amount=convert(decimal(20,2),Amount),                    
   LogDate,            
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),                  
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),                  
                     
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')          
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                  
   RequestTime=getdate(),                  
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                 
  from                     
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)            
                
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                      
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                
               
  where             
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                  
    AND (B1.VendorMerchantID ='225' or B1.VendorMerchantID ='L1668' )                
    --and (isnull(b1.TransactionReVerified,'') <> 'Y' )              
   and logDate >= left(dateadd(dd,-3,getdate()),11) + ' 00:00'               
   and logDate <  left(getdate(),11) + ' 00:00:00.000'         
   --and Vendor <> 'TECHPROCESS'       
   --and Vendor = 'TECHPROCESS'           
       
 order by LogDate DESC       
 end                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMGetTransactionForVerification_SuccessTransaction
-- --------------------------------------------------
CREATE PROC usp_AngelPGIMGetTransactionForVerification_SuccessTransaction    
AS    
BEGIN    
 select distinct                        
 Requestid=b1.Requestid,                          
 Vendor,                          
 Merchantid=VendorMerchantID,                          
 MerchantTransactionid=TransactionMerchantID,                           
 Amount=convert(decimal(20,2),Amount),                          
 LogDate,                  
 TransactionReferenceNo=isnull(TransactionReferenceNo,''),                      
 RequestTime=convert(varchar,getdate()),        
 date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                        
 ,b1.TransactionVerified            
 from                           
 tbl_AngelPGIMBoTransactionLog b1 with(nolock)            
 where                  
 VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                        
 and (isnull(b1.TransactionVerified,'') <> 'Y')     
 AND TransactionStatus = 'SUCCESS'                
 AND B1.VendorMerchantID in ('167','L1668' )      
 AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMGetTransactionForVerification_temps
-- --------------------------------------------------
CREATE procedure [dbo].[usp_AngelPGIMGetTransactionForVerification_temps]                  
(                  
 @option varchar(50)                  
)                        
as                     
/*                  
                  
[usp_AngelPGIMGetTransactionForVerification] 'VERIFICATION'                 
          
[usp_AngelPGIMGetTransactionForVerification] 'reVERIFICATION'               
          
*/                     
begin                        
                        
          
 if(upper(@option)='VERIFICATION')                  
 begin                
 /*              
 select distinct                      
   Requestid=b1.Requestid,                        
   Vendor,                        
   Merchantid=VendorMerchantID,                        
   MerchantTransactionid=TransactionMerchantID,                         
   Amount=convert(decimal(20,2),Amount),                        
   LogDate,                
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),          
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),          
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')              
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                      
   RequestTime=getdate(),                        
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                      
    ,b1.TransactionVerified          
  from                         
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)          
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                          
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                      
  where                
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                      
  and (isnull(b1.TransactionVerified,'') <> 'Y')               
  AND B1.VendorMerchantID in ('167','L1668' )       
  AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)         
 --and logDate > convert(varchar(11),getdate(),109)           
 --and Vendor <> 'TECHPROCESS'           
 --and Vendor = 'TECHPROCESS'          
  order by LogDate   DESC        
  */      
        
   select distinct                      
    Requestid=b1.Requestid,                        
    Vendor,                        
    Merchantid=VendorMerchantID,                        
    MerchantTransactionid=TransactionMerchantID,                         
    Amount=convert(decimal(20,2),Amount),                        
    LogDate,                
    TransactionReferenceNo=isnull(TransactionReferenceNo,''),                    
    RequestTime=convert(varchar,getdate()),      
    date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                      
  ,b1.TransactionVerified          
   from                         
    tbl_AngelPGIMBoTransactionLog b1 with(nolock)          
   where                
   VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                      
   and (isnull(b1.TransactionVerified,'') <> 'Y')               
   AND B1.VendorMerchantID in ('167','L1668' )       
   AND  Logdate >  convert(varchar(12),(select max(Logdate-2) from   tbl_AngelPGIMBoTransactionLog ),106)            
   AND TransactionMerchantID = '170807003461'
 
   order by LogDate   DESC                 
                       
 end                      
                  
 if(upper(@option)='REVERIFICATION')                  
 begin                 
               
 select distinct              
   Requestid=b1.Requestid,                        
   Vendor,                        
   Merchantid=VendorMerchantID,                        
   MerchantTransactionid=TransactionMerchantID,                         
   Amount=convert(decimal(20,2),Amount),                        
   LogDate,                
   --BankTransactionReferenceNo=isnull(TransactionReferenceNo,''),                      
   TransactionReferenceNo=isnull(TransactionReferenceNo,''),                      
                         
   --TransactionReferenceNo=case when ISNULL(Vendor,'') ='PAYNETZ' then   isnull(p1.Response_VendorReferenceNo,'')              
   --     when ISNULL(Vendor,'') ='TECHPROCESS' then   isnull(T1.Response_VendorReferenceNo,'') ELSE '0' end,                      
   RequestTime=convert(varchar,getdate()),      
   date=  case when Vendor ='PAYNETZ' then CONVERT(char(10), LogDate,126) else  upper(replace(convert(varchar,getdate(),106),' ',''))  end                     
  from                         
   tbl_AngelPGIMBoTransactionLog b1 with(nolock)                
                    
   --left outer join tbl_AngelPGIMTransactionLogPaynetz p1 with(nolock) on b1.Requestid=p1.Requestid                          
   --left outer join  tbl_AngelPGIMTransactionLogTechProcess t1 with(nolock) on b1.Requestid=t1.Requestid                    
                   
  where                 
  VendorMerchantID IS NOT NULL and TransactionMerchantID is not null                      
    AND (B1.VendorMerchantID ='225' or B1.VendorMerchantID ='L1668' )                    
    --and (isnull(b1.TransactionReVerified,'') <> 'Y' )                  
   and logDate >= left(dateadd(dd,-3,getdate()),11) + ' 00:00'                   
   and logDate <  left(getdate(),11) + ' 00:00:00.000'             
   --and Vendor <> 'TECHPROCESS'           
   --and Vendor = 'TECHPROCESS'               
           
 order by LogDate DESC           
 end                      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMInsertVerificationReponse
-- --------------------------------------------------
--usp_AngelPGIMInsertVerificationReponse      
--[usp_AngelPGIMInsertVerificationReponse]        
CREATE procedure [dbo].[usp_AngelPGIMInsertVerificationReponse]                  
(                  
 @RequestId varchar(50),                  
 @RequestString varchar(5000),                  
 @RequestTime datetime,                  
 @RsponseString varchar(5000),                  
 @verificationStatus varchar(50),                  
 @VerficationType varchar(50),          
 @TransactionReferenceNo varchar(50),        
 @strBankName  varchar(100),      
 @atomtxnId  varchar(100),  
 @Merchent_id varchar(50)    
)                  
              
as                  
begin                  
                  
--select * from tbl_ANGELPGIMBOTransactionLog                  
                  
 declare @@date datetime                  
 set @@date=getdate()                  
                  
 declare @@RequestId varchar(50)                  
 declare @@RequestString varchar(5000)                  
 declare @@RequestTime datetime                  
 declare @@RsponseString varchar(5000)                  
 declare @@verificationStatus varchar(50)                
 declare @@VerficationType varchar(50)           
 Declare @@TransactionReferenceNo varchar(50)        
 declare @@strBankName varchar(100)    
 declare @@atomtxnId varchar(100)  
 declare @@Merchent_id varchar(50)               
                  
 set @@RequestId=@RequestId                  
 set @@RequestString=@RequestString                  
 set @@RequestTime=@RequestTime                  
 set @@RsponseString=@RsponseString                  
 set @@verificationStatus=@verificationStatus                  
 set @@VerficationType=@VerficationType           
 set @@TransactionReferenceNo=@TransactionReferenceNo        
 set @@strBankName=@strBankName     
 set @@atomtxnId=@atomtxnId   
 set @@Merchent_id=@Merchent_id          
          
           
  declare @@TransactionStatus varchar(10)                
             
             
                
 --Verification Table            
                    
 insert into tbl_AngelPGIMVerificationProcess_Log                  
 (RequestID, RequestString, Requesttime, ResponseString, VerificationStatus,VerficationType,TransactionReferenceNo, BankName)                  
 values( @@RequestId, @@RequestString, @@RequestTime, @@RsponseString, @@verificationStatus, @@VerficationType, @@TransactionReferenceNo, @@strBankName )      
                   
            
  select @@TransactionStatus=isnull(TransactionStatus,'')          
  from tbl_ANGELPGIMBOTransactionLog with(nolock)  where requestid=@@RequestId           
            
 --Live Table                  
 if(@@verificationStatus='SUCCESS' or @@verificationStatus='FAIL')                
 begin                
                   
                
    if(@@VerficationType='VERIFICATION')              
    begin          
   update tbl_ANGELPGIMBOTransactionLog set VendorMerchantID= @@Merchent_id, TransactionVerified='Y', VerificationRemark=@@verificationStatus,VerificationDate=@@date,BankName=@@strBankName,TransactionReferenceNo=@@TransactionReferenceNo,ExtraField2=@@atomtxnId where requestid=@@RequestId               
   
    end            
          
  if(@@VerficationType='REVERIFICATION')              
  begin           
   update tbl_ANGELPGIMBOTransactionLog set VendorMerchantID= @@Merchent_id, TransactionReVerified='Y', ReVerificationRemark=@@verificationStatus, ReVerificationDate=@@date,BankName=@@strBankName,TransactionReferenceNo=@@TransactionReferenceNo,ExtraField2=@@atomtxnId where requestid=@@RequestId        
          
  end               
 end                
            
  if(ISNULL(@@TransactionStatus,'')<>'OK' and @@verificationStatus='SUCCESS')          
  --if(ISNULL(@@TransactionStatus,'')='OK' and @@verificationStatus='SUCCESS')          
  begin          
   declare @Subject varchar(1000),@MailMessage varchar(max)          
            
   set @Subject='Change of Transaction Status(Fail - Success)'          
            
    set @MailMessage='<table><tr><td colspan="2">Transaction status change Fail To Success for the transaction done by '+ @@RequestId +' at '+convert(varchar(26),@@date,109)+'</td><tr>'            
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Request String</td><td align="left" nowrap="nowrap">'+ @@RequestString +'</td></tr>'            
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Response String</td><td align="left" nowrap="nowrap">'+ @@RsponseString +'</td></tr>'            
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Verification Status</td><td align="left" nowrap="nowrap">'+ @verificationStatus +'</td></tr>'            
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Verfication Type</td><td align="left" nowrap="nowrap">'+ @@VerficationType +'</td></tr></table>'           
            
 --COMMENTED BY ROHIT (usp_SendEmailNotification_New Sp IS not Included in Account Database.)          
    --exec usp_SendEmailNotification_New @Subject=@Subject, @MessageType='INFORMATION',             
    --@Message =@MailMessage, @Applicationname='ANGELPGIM', @MailerType='ERRORNOTIFICATION'           
             
             
  end          
                 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMInsertVerificationReponse_Apr_04_2014
-- --------------------------------------------------
--usp_AngelPGIMInsertVerificationReponse    
--[usp_AngelPGIMInsertVerificationReponse]      
CREATE procedure usp_AngelPGIMInsertVerificationReponse_Apr_04_2014                
(                
 @RequestId varchar(50),                
 @RequestString varchar(5000),                
 @RequestTime datetime,                
 @RsponseString varchar(5000),                
 @verificationStatus varchar(50),                
 @VerficationType varchar(50),        
 @TransactionReferenceNo varchar(50),      
 @strBankName  varchar(100),    
 @atomtxnId  varchar(100)  
)                
            
as                
begin                
                
--select * from tbl_ANGELPGIMBOTransactionLog                
                
 declare @@date datetime                
 set @@date=getdate()                
                
 declare @@RequestId varchar(50)                
 declare @@RequestString varchar(5000)                
 declare @@RequestTime datetime                
 declare @@RsponseString varchar(5000)                
 declare @@verificationStatus varchar(50)              
 declare @@VerficationType varchar(50)         
 Declare @@TransactionReferenceNo varchar(50)      
 declare @@strBankName varchar(100)  
 declare @@atomtxnId varchar(100)             
                
 set @@RequestId=@RequestId                
 set @@RequestString=@RequestString                
 set @@RequestTime=@RequestTime                
 set @@RsponseString=@RsponseString                
 set @@verificationStatus=@verificationStatus                
 set @@VerficationType=@VerficationType         
 set @@TransactionReferenceNo=@TransactionReferenceNo      
 set @@strBankName=@strBankName   
 set @@atomtxnId=@atomtxnId         
        
         
  declare @@TransactionStatus varchar(10)              
           
           
              
 --Verification Table          
                  
 insert into tbl_AngelPGIMVerificationProcess_Log                
 (RequestID, RequestString, Requesttime, ResponseString, VerificationStatus,VerficationType,TransactionReferenceNo, BankName)                
 values( @@RequestId, @@RequestString, @@RequestTime, @@RsponseString, @@verificationStatus, @@VerficationType, @@TransactionReferenceNo, @@strBankName )    
                 
          
  select @@TransactionStatus=isnull(TransactionStatus,'')        
  from tbl_ANGELPGIMBOTransactionLog with(nolock)  where requestid=@@RequestId         
          
 --Live Table                
 if(@@verificationStatus='SUCCESS' or @@verificationStatus='FAIL')              
 begin              
                 
              
    if(@@VerficationType='VERIFICATION')            
    begin        
   update tbl_ANGELPGIMBOTransactionLog set TransactionVerified='Y', VerificationRemark=@@verificationStatus,VerificationDate=@@date,BankName=@@strBankName,ExtraField2=@@atomtxnId where requestid=@@RequestId                
    end          
        
  if(@@VerficationType='REVERIFICATION')            
  begin         
   update tbl_ANGELPGIMBOTransactionLog set TransactionReVerified='Y', ReVerificationRemark=@@verificationStatus, ReVerificationDate=@@date,BankName=@@strBankName,ExtraField2=@@atomtxnId where requestid=@@RequestId                
  end             
 end              
          
  if(ISNULL(@@TransactionStatus,'')<>'OK' and @@verificationStatus='SUCCESS')        
  --if(ISNULL(@@TransactionStatus,'')='OK' and @@verificationStatus='SUCCESS')        
  begin        
   declare @Subject varchar(1000),@MailMessage varchar(max)        
          
   set @Subject='Change of Transaction Status(Fail - Success)'        
          
    set @MailMessage='<table><tr><td colspan="2">Transaction status change Fail To Success for the transaction done by '+ @@RequestId +' at '+convert(varchar(26),@@date,109)+'</td><tr>'          
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Request String</td><td align="left" nowrap="nowrap">'+ @@RequestString +'</td></tr>'          
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Response String</td><td align="left" nowrap="nowrap">'+ @@RsponseString +'</td></tr>'          
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Verification Status</td><td align="left" nowrap="nowrap">'+ @verificationStatus +'</td></tr>'          
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Verfication Type</td><td align="left" nowrap="nowrap">'+ @@VerficationType +'</td></tr></table>'         
          
 --COMMENTED BY ROHIT (usp_SendEmailNotification_New Sp IS not Included in Account Database.)        
    --exec usp_SendEmailNotification_New @Subject=@Subject, @MessageType='INFORMATION',           
    --@Message =@MailMessage, @Applicationname='ANGELPGIM', @MailerType='ERRORNOTIFICATION'         
           
           
  end        
               
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMInsertVerificationReponse_new
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_AngelPGIMInsertVerificationReponse_new]                            
(                            
 @aggregator AS [dbo].[AgreegatorPaynetzTechResponse] READONLY              
)                            
                        
AS                            
BEGIN                            
DECLARE @ERRORMESSAGE NVARCHAR(4000);                     
DECLARE @Query VARCHAR(max),@SQLSTATEMENT VARCHAR(100) ,@TITLE VARCHAR(100) ,@ENTITYTYPE VARCHAR(50) ,  @Filename as varchar(100), @filepath as varchar(100)      
BEGIN TRY              
      
  INSERT INTO tbl_AgreegatorPaynetzTechResponse        
  SELECT distinct *,GETDATE(),'new'      
  FROM @aggregator        
         
  INSERT INTO tbl_AngelPGIMVerificationProcess_Log(RequestID, RequestString, Requesttime, ResponseString,         
  VerificationStatus,VerficationType,TransactionReferenceNo, BankName)        
  SELECT requestid,requeststring,requesttime,verificationresponse,tranverificationstatus,VerificationType,        
  CASE WHEN vendor = 'PAYNETZ' THEN tranatomrefno ELSE trantechrefno END,tranbankname        
  FROM tbl_AgreegatorPaynetzTechResponse where rectype = 'new'        
         
  --verification        
          
  UPDATE a        
  SET a.VendorMerchantID = b.merchantid, a.TransactionVerified = 'Y', a.VerificationRemark = b.tranverificationstatus,        
  a.VerificationDate = GETDATE(),a.BankName = b.tranbankname, a.TransactionReferenceNo = CASE WHEN b.vendor = 'PAYNETZ' THEN b.tranatomrefno ELSE b.trantechrefno END,        
  a.ExtraField2 = CASE WHEN b.vendor = 'PAYNETZ' THEN b.tranatomrefno ELSE b.trantechrefno END        
  FROM tbl_ANGELPGIMBOTransactionLog a        
  JOIN tbl_AgreegatorPaynetzTechResponse b ON a.requestid = b.requestid        
  WHERE tranverificationstatus IN ('SUCCESS','FAIL')       
  AND rectype = 'NEW'      
  AND verificationtype = 'VERIFICATION'        
          
          
  --reverification        
  UPDATE a        
  SET a.VendorMerchantID = b.merchantid, a.TransactionVerified = 'Y', a.VerificationRemark = b.tranverificationstatus,        
  a.VerificationDate = GETDATE(),a.BankName = b.tranbankname, a.TransactionReferenceNo = CASE WHEN b.vendor = 'PAYNETZ' THEN b.tranatomrefno ELSE b.trantechrefno END,        
  a.ExtraField2 = CASE WHEN b.vendor = 'PAYNETZ' THEN b.tranatomrefno ELSE b.trantechrefno END        
  FROM tbl_ANGELPGIMBOTransactionLog a        
  JOIN tbl_AgreegatorPaynetzTechResponse b ON a.requestid = b.requestid        
  WHERE tranverificationstatus IN ('SUCCESS','FAIL')       
  AND rectype = 'NEW'      
  AND verificationtype = 'REVERIFICATION'        
        
  TRUNCATE TABLE tbl_agreegator_mailer_structure      
        
  INSERT INTO tbl_agreegator_mailer_structure       
  select 'Request Id','vendor','Merchant ID','Merchant Tran ID','Tran Amount','Log Date','Verification Status','Tran Ref No','Bank Name',      
  'Verification Date'      
  INSERT INTO tbl_agreegator_mailer_structure       
  SELECT b.requestid,b.vendor,b.merchantid,b.merchanttranid,b.merchanttranamount,b.logdate,b.tranverificationstatus,      
  case when b.vendor = 'paynetz' then b.tranatomrefno else b.trantechrefno end,b.tranbankname,convert(varchar,convert(datetime,a.verificationdate,103),100)      
  FROM tbl_ANGELPGIMBOTransactionLog a        
  JOIN tbl_AgreegatorPaynetzTechResponse b ON a.requestid = b.requestid        
  WHERE tranverificationstatus IN ('SUCCESS','FAIL')       
  AND rectype = 'NEW'      
  --AND a.verificationdate = '2017-04-18 23:40:26.960'      
  AND b.verificationtype = 'VERIFICATION'        
       
 IF((select count(1) from tbl_agreegator_mailer_structure) > 1)      
 BEGIN      
      
 SET @Filename = 'verification_' + convert(varchar,getdate(),112)  + '_' + REPLACE(CONVERT(VARCHAR(5),getdate(),108),':','')      
 set @filepath = '\\INHOUSELIVEAPP2-FS.angelone.in\d$\Mfss_Export\' + @Filename + '.xls'      
 PRINT @Filename       
 SET @ENTITYTYPE = 'Agreegator'        
 SET @SQLSTATEMENT = 'select * from accounts.dbo.tbl_agreegator_mailer_structure'        
 SET @Query = 'exec MASTER.dbo.xp_cmdshell '' bcp  "' + @SQLStatement        
 SET @Query = @Query + ' " queryout \\INHOUSELIVEAPP2-FS.angelone.in\d$\Mfss_Export\' + @Filename + '.xls -c -F1 -SABVSNCMS.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '''        
 PRINT @Query       
 EXEC (@Query)      
       
        
 EXEC msdb..sp_send_dbmail                                       
 @profile_name='SOFTWARE',                                      
 @recipients='yagnesh.rajput@angelbroking.com;bhumika.keswani@angelbroking.com;neha.naiwar@angelbroking.com;',                        
 -- @recipients='vasudha.mahana@angelbroking.com',                              
 @subject ='Agreegator Verification File',                                     
 @body_format = 'HTML',                                      
 @body= 'Kindly find the attached file containing the records which are verified in this process',          
 @file_attachments= @filepath      
 END      
  UPDATE tbl_AgreegatorPaynetzTechResponse      
  SET rectype = 'old' where rectype = 'new'       
        
        
 END TRY       
 BEGIN CATCH         
 SELECT @ERRORMESSAGE = ERROR_MESSAGE() + CONVERT(VARCHAR(10), ERROR_LINE());        
 EXEC MSDB.DBO.SP_SEND_DBMAIL                                      
 @RECIPIENTS = 'yagnesh.rajput@angelbroking.com;',                                                                     
 --@BLIND_COPY_RECIPIENTS = @BCC,                        
 @PROFILE_NAME = 'Angelbroking',                                      
 @BODY_FORMAT ='HTML',                                      
 @SUBJECT = 'Error in proc usp_AngelPGIMInsertVerificationReponse_new' ,    
 @BODY =@ERRORMESSAGE     
     
     
  RAISERROR (@ERRORMESSAGE,16,1);              
END CATCH        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AngelPGIMInsertVerificationReponse_newlogic
-- --------------------------------------------------
--usp_AngelPGIMInsertVerificationReponse        
--[usp_AngelPGIMInsertVerificationReponse]          
CREATE procedure [dbo].[usp_AngelPGIMInsertVerificationReponse_newlogic]
(                    
 @RequestId varchar(50),                    
 @RequestString varchar(5000),                    
 @RequestTime datetime,                    
 @RsponseString varchar(5000),                    
 @verificationStatus varchar(50),                    
 @VerficationType varchar(50),            
 @TransactionReferenceNo varchar(50),          
 @strBankName  varchar(100),        
 @atomtxnId  varchar(100),    
 @Merchent_id varchar(50)      
)                    
                
as                    
begin                    
                    
--select * from tbl_ANGELPGIMBOTransactionLog                    
                    
 declare @@date datetime                    
 set @@date=getdate()                    
                    
 declare @@RequestId varchar(50)                    
 declare @@RequestString varchar(5000)                    
 declare @@RequestTime datetime                    
 declare @@RsponseString varchar(5000)                    
 declare @@verificationStatus varchar(50)                  
 declare @@VerficationType varchar(50)             
 Declare @@TransactionReferenceNo varchar(50)          
 declare @@strBankName varchar(100)      
 declare @@atomtxnId varchar(100)    
 declare @@Merchent_id varchar(50)                 
                    
 set @@RequestId=@RequestId                    
 set @@RequestString=@RequestString                    
 set @@RequestTime=@RequestTime                    
 set @@RsponseString=@RsponseString                    
 set @@verificationStatus=@verificationStatus                    
 set @@VerficationType=@VerficationType             
 set @@TransactionReferenceNo=@TransactionReferenceNo          
 set @@strBankName=@strBankName       
 set @@atomtxnId=@atomtxnId     
 set @@Merchent_id=@Merchent_id            
            
             
  declare @@TransactionStatus varchar(10)                  
               
               
                  
 --Verification Table              
                      
 insert into tbl_AngelPGIMVerificationProcess_Log_newlogic                    
 (RequestID, RequestString, Requesttime, ResponseString, VerificationStatus,VerficationType,TransactionReferenceNo, BankName)                    
 values( @@RequestId, @@RequestString, @@RequestTime, @@RsponseString, @@verificationStatus, @@VerficationType, @@TransactionReferenceNo, @@strBankName )        
                     
              
  select @@TransactionStatus=isnull(TransactionStatus,'')            
  from tbl_ANGELPGIMBOTransactionLog_newlogic with(nolock)  where requestid=@@RequestId             
              
 --Live Table                    
 if(@@verificationStatus='SUCCESS' or @@verificationStatus='FAIL')                  
 begin                  
                     
                  
    if(@@VerficationType='VERIFICATION')                
    begin            
   update tbl_ANGELPGIMBOTransactionLog_newlogic set VendorMerchantID= @@Merchent_id, TransactionVerified='Y', VerificationRemark=@@verificationStatus,VerificationDate=@@date,BankName=@@strBankName,TransactionReferenceNo=@@TransactionReferenceNo,ExtraField2=@@atomtxnId where requestid=@@RequestId                 
     
    end              
            
  if(@@VerficationType='REVERIFICATION')                
  begin             
   update tbl_ANGELPGIMBOTransactionLog_newlogic set VendorMerchantID= @@Merchent_id, TransactionReVerified='Y', ReVerificationRemark=@@verificationStatus, ReVerificationDate=@@date,BankName=@@strBankName,TransactionReferenceNo=@@TransactionReferenceNo,ExtraField2
=@@atomtxnId where requestid=@@RequestId          
            
  end                 
 end                  
              
  if(ISNULL(@@TransactionStatus,'')<>'OK' and @@verificationStatus='SUCCESS')            
  --if(ISNULL(@@TransactionStatus,'')='OK' and @@verificationStatus='SUCCESS')            
  begin            
   declare @Subject varchar(1000),@MailMessage varchar(max)            
              
   set @Subject='Change of Transaction Status(Fail - Success)'            
              
    set @MailMessage='<table><tr><td colspan="2">Transaction status change Fail To Success for the transaction done by '+ @@RequestId +' at '+convert(varchar(26),@@date,109)+'</td><tr>'              
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Request String</td><td align="left" nowrap="nowrap">'+ @@RequestString +'</td></tr>'              
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Response String</td><td align="left" nowrap="nowrap">'+ @@RsponseString +'</td></tr>'              
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Verification Status</td><td align="left" nowrap="nowrap">'+ @verificationStatus +'</td></tr>'              
    set @MailMessage=@MailMessage+'<tr><td nowrap="nowrap">Verfication Type</td><td align="left" nowrap="nowrap">'+ @@VerficationType +'</td></tr></table>'             
              
 --COMMENTED BY ROHIT (usp_SendEmailNotification_New Sp IS not Included in Account Database.)            
    --exec usp_SendEmailNotification_New @Subject=@Subject, @MessageType='INFORMATION',               
    --@Message =@MailMessage, @Applicationname='ANGELPGIM', @MailerType='ERRORNOTIFICATION'             
               
               
  end            
                   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CHECK_IMAGE
-- --------------------------------------------------
       CREATE PROC USP_CHECK_IMAGE             
       (          
           @CLIENTID VARCHAR(10)          
       )          
       AS          
       BEGIN          
            IF EXISTS(SELECT IMAGE FROM TBL_CLIENT_CHECK_DETAILS WHERE CLIENTID =@CLIENTID)           
            BEGIN          
                 SELECT COUNT(IMAGE)AS COUNT FROM TBL_CLIENT_CHECK_DETAILS WHERE CLIENTID =@CLIENTID      
            END          
            ELSE    
            BEGIN    
                     SELECT  0 AS COUNT     
            END    
                    
       END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ChqRtn_Fetch
-- --------------------------------------------------
CREATE Proc USP_ChqRtn_Fetch      
as      
/*  
select Branch=space(12),sub_broker=space(10),Segment=convert(varchar(10),'ABLCM'),vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
into #file      
from anand.account_ab.dbo.ledger a with (nolock) join anand.account_ab.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
    
insert into #file     
select Branch=space(12),sub_broker=space(10),Segment='ACDLCM',vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
from anand1.account.dbo.ledger a with (nolock) join anand1.account.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
    
insert into #file     
select Branch=space(12),sub_broker=space(10),Segment='ACDLFO',vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
from angelfo.accountfo.dbo.ledger a with (nolock) join angelfo.accountfo.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
    
insert into #file     
select Branch=space(12),sub_broker=space(10),Segment='MCDX',vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
from angelcommodity.accountmcdx.dbo.ledger a with (nolock) join angelcommodity.accountmcdx.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
    
insert into #file     
select Branch=space(12),sub_broker=space(10),Segment='NCDEX',vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
from angelcommodity.accountncdx.dbo.ledger a with (nolock) join angelcommodity.accountncdx.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
    
insert into #file     
select Branch=space(12),sub_broker=space(10),Segment='MCD',vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
from angelcommodity.accountmcdxcds.dbo.ledger a with (nolock) join angelcommodity.accountmcdxcds.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
    
insert into #file     
select Branch=space(12),sub_broker=space(10),Segment='NSX',vdt,cltcode,Name=acname,vamt,a.vno,ddno,narration,cms_cheque='N',Process_Date=getdate()       
from angelfo.accountcurfo.dbo.ledger a with (nolock) join angelfo.accountcurfo.dbo.ledger1 b with (nolock)      
on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype and a.lno=b.lno      
where vdt>=convert(varchar(11),getdate()-5)      
and a.vtyp=17 and isnumeric(cltcode)=0    
*/  
select Branch,sub_broker=subbroker,Segment=convert(varchar(10),Segment),vdt,cltcode,Name=acname,vamt,vno,ddno,narration,cms_cheque='N',Process_Date=getdate()    
into #file from intranet.risk.dbo.TBL_Cheque_Return where vdt>=convert(varchar(11),getdate()-30)  
  
update #file set Segment='ABLCM' where Segment='BSECM'  
update #file set Segment='ACDLCM' where Segment='NSECM'  
update #file set Segment='ACDLFO' where Segment='NSEFO'  
update #file set Segment='NCDEX' where Segment='NCDX'  
  
  
    
update #file set cms_cheque='Y'     
from [196.1.115.235].BRS.dbo.CMSStatus b    
where #file.cltcode=b.l_cltcode and vdt=b.l_vdt and #file.vno=b.vno and b.cms_status='CMS'    
  
select data=cltcode+'|'+segment+'|'+vno into #old from tbl_ChqRtn_BO_Entries   (nolock)   
where vdt>=convert(varchar(11),getdate()-30)  
      
insert into tbl_ChqRtn_BO_Entries      
select * from #file where cltcode+'|'+segment+'|'+vno not in (select data from #old)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CLIENT_DETAILS
-- --------------------------------------------------
  CREATE PROC USP_CLIENT_DETAILS -- '1013'          
 (            
    @ID VARCHAR(10)            
  )            
 AS            
 BEGIN            
  SELECT A.CLTCODE,A.NAME,A.SEGMENT,A.CHEQUENO,STATUS=    
   CASE  WHEN B.STATUS IS NULL THEN 'Pending'     
         WHEN B.STATUS = '' THEN 'Pending'    
         ELSE B.STATUS    
      END    
   ,PHYCOPY_STATUS=ISNULL(PHYCOPY_STATUS,'')       
   ,REMARK=ISNULL(REMARK,'')            
  FROM TBL_CHQRTN_BO_ENTRIES A            
        LEFT JOIN   DBO.TBL_CLIENT_CHECK_DETAILS B            
  ON A.ID = B.CLIENTID    
  WHERE  A.ID=@ID            
              
              
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CLIENT_EXISTS
-- --------------------------------------------------

 CREATE PROC USP_CLIENT_EXISTS --'G18060'    
 (    
    @CLCODE VARCHAR(10)    
 )    
 AS    
 SELECT * FROM DBO.TBL_CHQRTN_BO_ENTRIES     
 WHERE CLTCODE =@CLCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DDNo_BulkUpload
-- --------------------------------------------------

     
CREATE PROC [dbo].[USP_DDNo_BulkUpload]       
(        
 @FileName VARCHAR(50) = NULL ,      
 @Total int out,
 @username varchar(50)         
)                   
AS             
BEGIN     
  
    Declare @filePath varchar(500)=''        
    --Declare @FileName varchar(500)='uploadAdvChart.csv'        
    set @filePath ='\\INHOUSELIVEAPP2-FS.angelone.in\D$\UploadAdvChart\'+@FileName+''        
    --set @filePath ='\\INHOUSELIVEAPP2-FS.angelone.in\D$\UploadAdvChart\CallAndTrade.csv'      
    DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_chkpost_Temp FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=2 )';        
    EXEC(@sql)        
    print (@sql)        
    print @filePath   
    
   insert into tbl_chkpost     -- where    DDNO='152717997'
   select DDNO,GETDATE(),@username from  tbl_chkpost_Temp
   
   truncate table tbl_chkpost_Temp
   
   
    
          
END

--tbl_chkpost where ddno='123456789' order by Inserted_date desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findinJobs
-- --------------------------------------------------
Create Procedure usp_findinJobs(@Str as varchar(500))  
as  
select b.name,  
Case when b.enabled=1 then 'Active' else 'Deactive' end as Status,  
date_created,date_modified,a.step_id,a.step_name,a.command  
from msdb.dbo.sysjobsteps a, msdb.dbo.sysjobs b  
where command like '%'+@Str+'%'  
and a.job_id=b.job_id

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
-- PRINT @STR              
  EXEC(@STR)              
      
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IMAGE_CHECK
-- --------------------------------------------------
CREATE PROC USP_IMAGE_CHECK
(
	@CLIENTID varchar(10)
)
AS
BEGIN 
	SELECT IMAGE
	FROM TBL_CLIENT_CHECK_DETAILS
	WHERE CLIENTID=@CLIENTID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_insert_AgreegatorPaynetzTechResponse
-- --------------------------------------------------

CREATE proc usp_insert_AgreegatorPaynetzTechResponse(
@aggregator As [dbo].[AgreegatorPaynetzTechResponse] Readonly
)
as
begin
insert into tbl_AgreegatorPaynetzTechResponse
select *,getdate()
from @aggregator
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_OnlineFund_DirectLimitToODIN
-- --------------------------------------------------
CREATE PROC [dbo].[USP_OnlineFund_DirectLimitToODIN]      
  
  /*    
 @CLIENTCODE AS VARCHAR(MAX) = '',      
 @AMOUNT VARCHAR(200)='',    
 @MFTRansactionNo varchar(100)=''      
    */  
    
AS 
Set nocount on                   
SET XACT_ABORT ON                             
BEGIN TRY     
BEGIN      
      
      
		DECLARE @Object AS INT;      
		DECLARE @ResponseText AS VARCHAR(8000);      
		DECLARE @Body AS VARCHAR(8000) = ''      
		DECLARE @GROUPCODE AS VARCHAR(50)=''      
		DECLARE @IPO MONEY=0,@MF MONEY=0,@TRADINGAMT MONEY=0    

		declare @mdat as datetime  ,@mdat1 as datetime  

		select @mdat=MIN(start_date) from                     
		(              
		select distinct top 2 * from risk.dbo.sett_mst where Start_date<GETDATE()-1 and Sett_Type='D'              
		order by start_Date desc              
		) x 

		print @mdat
		/*  Commented On 23 Oct 2017 
		set @mdat1=@mdat+1
		select @mdat1= CONVERT(DATETIME, CONVERT(varchar(11),@mdat1, 111 ) + ' 23:59', 111)
		*/
		set @mdat1= CONVERT(DATETIME, CONVERT(varchar(11),getdate()-1, 111 ) + ' 23:59', 111)
		print @mdat1
			
		insert into ACC_OnlineODIN_tbl
		select RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,
		TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,VerificationRemark,VerificationDate,
		LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,
		LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,ReVerificationRemark,ReVerificationDate,ExtraField1
		,ExtraField2,ExtraField3,ExtraField4,ExtraField5 from dbo.tbl_AngelPGIMBOTransactionLog a where a.LogDate between convert(varchar(11),@mdat)
		 and convert(varchar(50),@mdat1 )
		and a.VerificationRemark <> 'FAIL' 
		and a.TransactionReferenceNo not in(select ddno from tbl_chkpost)  
		and a.VerificationDate>= CONVERT(DATETIME, CONVERT(varchar(11),getdate(), 111 ) + ' 00:00:00', 111) and
		not exists (select * from ACC_OnlineODIN_tbl_hist z where a.RequestID=z.RequestID and a.TransactionReferenceNo=z.TransactionReferenceNo)

		select * into #aa from ACC_OnlineODIN_tbl
		select  ROW_NUMBER() OVER ( ORDER BY party_code) AS srno,*  into #bb from #aa
		
		DECLARE @totctr1 as int = 0,@ctr1 as int = 1  

		SELECT @totctr1=count(1) from #aa
		if(select count(1) from #aa) >0 
		BEGIN
		While @ctr1 <= @totctr1    
		BEGIN  
			
			declare @Cltcode1 varchar(50)='',@email1 varchar(100)='',@Amount1  money=0.00 ,@segment varchar(100)='' 
			
			select @Cltcode1=party_code,@Amount1=amount,@segment=segment 
			from #bb where srno=@ctr1 
		     
			SELECT @GROUPCODE=A.tag FROM (SELECT TOP 1   tag   FROM [mis].dbo.odinclientinfo WHERE pcode = @Cltcode1 AND  
			servermapped <> '192.168.3.186')A      
			  
			/*SET @Body = '{"UserId" : "'+@Cltcode1+'","Amount":"'+@Amount1+'","ordertype":"MF","decIPOLimits":"'+CAST(@IPO AS VARCHAR)+'","GroupId" : "'+@GROUPCODE+'","decTradingLimits" : "'+CAST(@TRADINGAMT AS VARCHAR)+'","decMFLimits":"'+CAST(@MF AS VARCHAR)+'"}'  */      
			      
			If(@segment='NSE DERIVATIVES' or @segment='NSECDS' or @segment='MCXSX CURRENCY FUTURES' or @segment='NSE EQUITIES' or @segment='BSE EQUITIES' or   @segment='BSE Derivatives' or @segment='BSE Currency'  )         
			Begin
			   SET @Body = '{"UserId" : "'+@Cltcode1+'","Amount":"'+CAST(@Amount1 AS VARCHAR)+'","ordertype":"MF","GroupId" : "'+@GROUPCODE+'","decTradingLimits" : "'+CAST(@Amount1 AS VARCHAR)+'"}'	
			End
			If (@segment='MCX FUTURES' or  @segment='NCDEX FUTURES')
			Begin
				SET @Body = '{"UserId" : "'+@Cltcode1+'","Amount":"'+CAST(@Amount1 AS VARCHAR)+'","ordertype":"MF","GroupId" : "'+@GROUPCODE+'","decCommLimits" : "'+CAST(@Amount1 AS VARCHAR)+'"}'  
			End
			    
			print @Body      
			      
			EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;      
			EXEC sp_OAMethod @Object, 'open', NULL, 'post','http://196.1.115.183:120/Service1.svc/UpdatePGLimits', 'false'      
			      
			EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'text/plain'      
			EXEC sp_OAMethod @Object, 'send', null, @body      
			      
			EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT      
			SELECT @ResponseText as [RESPONSE]      
			      
			EXEC sp_OADestroy @Object
			
			insert into ACC_OnlineFundResponse(InsertedString,Response,UpdatedOn)
			select @Body,@ResponseText,getdate()
			
			set  @ctr1=@ctr1+1  
		END	
		
		END
		
		insert into  ACC_OnlineODIN_tbl_hist(RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,
		TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,VerificationRemark,VerificationDate,
		LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,
		LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,ReVerificationRemark,ReVerificationDate,ExtraField1
		,ExtraField2,ExtraField3,ExtraField4,ExtraField5,Updatedon)
		select  RequestID,AppName,Party_Code,Segment,BankName,BankAccountNo,Amount,LogDate,Vendor,VendorMerchantID,TransactionMerchantID,
		TransactionReferenceNo,TransactionStatus,TransactionRemark,TransactionDate,TransactionVerified,VerificationRemark,VerificationDate,
		LimitUpdateStatus,LimitUpdateRequestInitiatedAt,LimitUpdateResponseRecvdAt,LimitUpdateResponse,LimitUpdationDoneBy,
		LimitUpdationAPIStatus,LimitUpdationAPIMessage,TransactionReVerified,ReVerificationRemark,ReVerificationDate,ExtraField1
		,ExtraField2,ExtraField3,ExtraField4,ExtraField5,getdate() from ACC_OnlineODIN_tbl
		
		truncate table ACC_OnlineODIN_tbl
 
END 
End try                               
BEGIN CATCH                                  
                              
  insert into cms.dbo.NCMS_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                        
  select GETDATE(),'USP_OnlineFund_DirectLimitToODIN',ERROR_LINE(),ERROR_MESSAGE()                                        
                              
End catch                              
                                
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt
-- --------------------------------------------------

--exec Usp_PaynInRpt '12/01/2018','12/01/2018','Broker','CSO'

CREATE Procedure [dbo].[Usp_PaynInRpt]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
@Party_Code varchar(25),
@DDNO varchar(50),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN

return 0

--if (@Party_Code='')
--set @Party_Code='%%'
--if (@DDNO='')
--set @DDNO='%%'

--				select * into #client_details from risk.dbo.client_details with(nolock)

--				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
--				into  #UPI
--				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
--				from
--				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
--				Risk.dbo.tbl_BoPostUPITransaction  b 
--				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
--				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
--				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
--				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
--				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
--				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
--				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
--				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
--				-----//////  ATOM and TECH  \\\\\-----
--				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
--				case when a.vendor='PAYNETZ' then 'ATOM' else  a.vendor end as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
--				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
--				a.BankAccountNo,a.BankName,a.TransactionMerchantID
--				into #main
--				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
--				left join #client_details b on
--				a.Party_Code =b.party_code  
--				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
--				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and 
--				a.VerificationRemark<>'FAIL' and a.Party_Code like @Party_Code and a.TransactionReferenceNo like @DDNO
					
--				UNION
				
--				--//////  ATOM and TECH  with (mimansa)\\\\\---
--				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
--				case when a.vendor='PAYNETZ' then 'ATOM' else  a.vendor end as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
--				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
--				a.BankAccountNo,a.BankName,a.TransactionMerchantID
--				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
--				left join #client_details b on
--				a.Party_Code =b.party_code  
--				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
--				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and 
--				a.VerificationRemark<>'FAIL' and a.Vendor<>'KYC'  and a.Party_Code like @Party_Code and
--				 a.TransactionReferenceNo like @DDNO
				
--				UNION
				
--				----////UPI\\\--------
			
--				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
--				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
--				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
--				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
--				space(500) as BankName,'N/A' as TransactionMerchantID
--				from #UPI a left join 
--				#client_details b (nolock)                        
--				ON a.ClientCode =b.party_code where  
--				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
--				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
--				 and a.ClientCode like @Party_Code and a.ftbankrefno like @DDNO
				
--				UNION
--				---////Finox\\\------
--				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
--				'DIRECT' as PaymentMode,BankRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
--				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
--				 'N/A' as [Changed Transaction Status],
--				AccountNo as BankAccountNo,space(500) as BankName,'N/A' as TransactionMerchantID
--				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a
--				left Join 
--				#client_details b (nolock)                        
--				ON a.client_code =b.party_code
--				WHERE  
--				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
--				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
--				and a.Status<>'FAILED' and a.Client_Code like @Party_Code and a.BankRef_No like @DDNO
				
--				/***For Checcking ledger Posting****/
--				--select * into #tbl_Post_data from anand.MKTAPI.dbo.tbl_post_data where VDATE>=getdate()-3 

--				select EDate,Vdate,CltCode,CreditAmt,Narration,DDNo,Exchange,Segment,ApprovalDate,LedgerVNO into #tbl_Post_data from anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES with(nolock)    
--				where 
--				AddDt >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
--				and AddDt <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and VoucherType='2'
--				and cltcode like @Party_Code and DDNO like @DDNO
--				union all
--				select replace(CONVERT(VARCHAR(12),convert(datetime,EFFECTIVE_DATE,103),106), '/', ' '),
--				replace(CONVERT(VARCHAR(12),convert(datetime,VOUCHER_DATE,103),106), '/', ' '),CLIENT_CODE,AMOUNT,NARRATION,REFERENCE_NO,EXCHANGE,SEGMENT,POST_DATE,POST_STATUS
--                from Anand.APIDetails.dbo.API_PAYMENT_DETAILS with(nolock)  where  
--				POST_DATE >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
--				and POST_DATE <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
--				and Client_Code like @Party_Code and REFERENCE_NO like @DDNO			

				
--				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
--				m.[Segment],[Transaction Status],[Transaction status Date and time],
--				/*[Changed Transaction Date And Time],[Changed Transaction Status],*/
--				m.BankAccountNo,m.BankName,TransactionMerchantID,
--				case when isnull(LedgerVNO ,'')<>'' then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
--				ApprovalDate as  [Date Updated in ledger] 
--				from #main m 
--				left join #tbl_Post_data  a with (nolock) on 
--				m.[ClientCode]=a.CLTCODE and 
--				m.TransactionReferenceNo=a.DDNO
		
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt_11Jan2018
-- --------------------------------------------------

--exec Usp_PaynInRpt '13/12/2017','13/12/2017','Broker','CSO'

CREATE Procedure [dbo].[Usp_PaynInRpt_11Jan2018]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN

				select * into #client_details from risk.dbo.client_details with(nolock)

				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
				into  #UPI
				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
				from
				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
				Risk.dbo.tbl_BoPostUPITransaction  b 
				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
				-----//////  ATOM and TECH  \\\\\-----
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				into #main
				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
					
				UNION
				
				--//////  ATOM and TECH  with (mimansa)\\\\\---
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
				UNION
				
				----////UPI\\\--------
			
				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
				space(500) as BankName,'N/A' as TransactionMerchantID
				from #UPI a left join 
				#client_details b (nolock)                        
				ON a.ClientCode =b.party_code where  
				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
		
				
				UNION
				---////Finox\\\------
				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'DIRECT' as PaymentMode,InternalRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],
				AccountNo as BankAccountNo,space(500) as BankName,'N/A' as TransactionMerchantID
				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a
				left Join 
				#client_details b (nolock)                        
				ON a.client_code =b.party_code
				WHERE  
				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				/***For Checcking ledger Posting****/
				select * into #tbl_Post_data from anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES with(nolock)
				WHERE  vouchertype=2 and
				VDATE >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and VDATE <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
				m.[Segment],[Transaction Status],[Transaction status Date and time],[Changed Transaction Date And Time],[Changed Transaction Status]
				,m.BankAccountNo,m.BankName,TransactionMerchantID,
				/*case when ROWSTATE=2 then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				isnull (convert( varchar(11),a.vdate),'N/A') as  [Date Updated in ledger] */
				case when ROWSTATE=2 then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				adddt  as  [Date Updated in ledger],
				addBy as [Inserted By]
				from #main m 
				left join #tbl_Post_data  a with (nolock) on 
				m.[ClientCode]=a.CLTCODE and 
				m.TransactionReferenceNo=a.DDNO
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt_12012018
-- --------------------------------------------------

--exec Usp_PaynInRpt '13/12/2017','13/12/2017','Broker','CSO'

Create Procedure [dbo].[Usp_PaynInRpt_12012018]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN

				select * into #client_details from risk.dbo.client_details with(nolock)

				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
				into  #UPI
				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
				from
				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
				Risk.dbo.tbl_BoPostUPITransaction  b 
				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
				-----//////  ATOM and TECH  \\\\\-----
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				into #main
				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
					
				UNION
				
				--//////  ATOM and TECH  with (mimansa)\\\\\---
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
				UNION
				
				----////UPI\\\--------
			
				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
				space(500) as BankName,'N/A' as TransactionMerchantID
				from #UPI a left join 
				#client_details b (nolock)                        
				ON a.ClientCode =b.party_code where  
				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
		
				
				UNION
				---////Finox\\\------
				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'DIRECT' as PaymentMode,InternalRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],
				AccountNo as BankAccountNo,space(500) as BankName,'N/A' as TransactionMerchantID
				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a
				left Join 
				#client_details b (nolock)                        
				ON a.client_code =b.party_code
				WHERE  
				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				/***For Checcking ledger Posting****/
				select * into #tbl_Post_data from anand.MKTAPI.dbo.tbl_post_data where VDATE>=getdate()-3 
				
				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
				m.[Segment],[Transaction Status],[Transaction status Date and time],[Changed Transaction Date And Time],[Changed Transaction Status]
				,m.BankAccountNo,m.BankName,TransactionMerchantID,
				case when ROWSTATE=2 then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				isnull (convert( varchar(11),a.vdate),'N/A') as  [Date Updated in ledger] 
				from #main m 
				left join #tbl_Post_data  a with (nolock) on 
				m.[ClientCode]=a.CLTCODE and 
				m.TransactionReferenceNo=a.DDNO
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt_20Feb2018
-- --------------------------------------------------

--exec Usp_PaynInRpt '12/01/2018','12/01/2018','Broker','CSO'

CREATE Procedure [dbo].[Usp_PaynInRpt_20Feb2018]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN

				select * into #client_details from risk.dbo.client_details with(nolock)

				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
				into  #UPI
				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
				from
				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
				Risk.dbo.tbl_BoPostUPITransaction  b 
				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
				-----//////  ATOM and TECH  \\\\\-----
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				case when a.vendor='PAYNETZ' then 'ATOM' else  a.vendor end as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				into #main
				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and 
				a.VerificationRemark<>'FAIL'
					
				UNION
				
				--//////  ATOM and TECH  with (mimansa)\\\\\---
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				case when a.vendor='PAYNETZ' then 'ATOM' else  a.vendor end as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and 
				a.VerificationRemark<>'FAIL' and a.Vendor<>'KYC'
				
				UNION
				
				----////UPI\\\--------
			
				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
				space(500) as BankName,'N/A' as TransactionMerchantID
				from #UPI a left join 
				#client_details b (nolock)                        
				ON a.ClientCode =b.party_code where  
				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
		
				
				UNION
				---////Finox\\\------
				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'DIRECT' as PaymentMode,BankRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],
				AccountNo as BankAccountNo,space(500) as BankName,'N/A' as TransactionMerchantID
				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a
				left Join 
				#client_details b (nolock)                        
				ON a.client_code =b.party_code
				WHERE  
				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				and a.Status<>'FAILED'
				
				/***For Checcking ledger Posting****/
				--select * into #tbl_Post_data from anand.MKTAPI.dbo.tbl_post_data where VDATE>=getdate()-3 

				select * into #tbl_Post_data from anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES with(nolock)    
				where 
				AddDt >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and AddDt <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and VoucherType='2'
				
				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
				m.[Segment],[Transaction Status],[Transaction status Date and time],
				/*[Changed Transaction Date And Time],[Changed Transaction Status],*/
				m.BankAccountNo,m.BankName,TransactionMerchantID,
				case when isnull(LedgerVNO ,'')<>'' then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				ApprovalDate as  [Date Updated in ledger] 
				from #main m 
				left join #tbl_Post_data  a with (nolock) on 
				m.[ClientCode]=a.CLTCODE and 
				m.TransactionReferenceNo=a.DDNO
		
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt_21Feb2018
-- --------------------------------------------------

--exec Usp_PaynInRpt '12/01/2018','12/01/2018','Broker','CSO'

CREATE Procedure [dbo].[Usp_PaynInRpt_21Feb2018]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
@Party_Code varchar(25),
@DDNO varchar(50),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN
if (@Party_Code='')
set @Party_Code='%%'
if (@DDNO='')
set @DDNO='%%'

				select * into #client_details from risk.dbo.client_details with(nolock)

				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
				into  #UPI
				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
				from
				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
				Risk.dbo.tbl_BoPostUPITransaction  b 
				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
				-----//////  ATOM and TECH  \\\\\-----
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				case when a.vendor='PAYNETZ' then 'ATOM' else  a.vendor end as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				into #main
				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and 
				a.VerificationRemark<>'FAIL' and a.Party_Code like @Party_Code and a.TransactionReferenceNo like @DDNO
					
				UNION
				
				--//////  ATOM and TECH  with (mimansa)\\\\\---
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				case when a.vendor='PAYNETZ' then 'ATOM' else  a.vendor end as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName,a.TransactionMerchantID
				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and 
				a.VerificationRemark<>'FAIL' and a.Vendor<>'KYC'  and a.Party_Code like @Party_Code and
				 a.TransactionReferenceNo like @DDNO
				
				UNION
				
				----////UPI\\\--------
			
				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
				space(500) as BankName,'N/A' as TransactionMerchantID
				from #UPI a left join 
				#client_details b (nolock)                        
				ON a.ClientCode =b.party_code where  
				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				 and a.ClientCode like @Party_Code and a.ftbankrefno like @DDNO
				
				UNION
				---////Finox\\\------
				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'DIRECT' as PaymentMode,BankRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],
				AccountNo as BankAccountNo,space(500) as BankName,'N/A' as TransactionMerchantID
				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a
				left Join 
				#client_details b (nolock)                        
				ON a.client_code =b.party_code
				WHERE  
				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				and a.Status<>'FAILED' and a.Client_Code like @Party_Code and a.BankRef_No like @DDNO
				
				/***For Checcking ledger Posting****/
				--select * into #tbl_Post_data from anand.MKTAPI.dbo.tbl_post_data where VDATE>=getdate()-3 

				select * into #tbl_Post_data from anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES with(nolock)    
				where 
				AddDt >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and AddDt <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' and VoucherType='2'
				and cltcode like @Party_Code and DDNO like @DDNO
				
				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
				m.[Segment],[Transaction Status],[Transaction status Date and time],
				/*[Changed Transaction Date And Time],[Changed Transaction Status],*/
				m.BankAccountNo,m.BankName,TransactionMerchantID,
				case when isnull(LedgerVNO ,'')<>'' then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				ApprovalDate as  [Date Updated in ledger] 
				from #main m 
				left join #tbl_Post_data  a with (nolock) on 
				m.[ClientCode]=a.CLTCODE and 
				m.TransactionReferenceNo=a.DDNO
		
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt_22Dec2017
-- --------------------------------------------------

--exec Usp_PaynInRpt '13/12/2017','13/12/2017','Broker','CSO'

CREATE Procedure [dbo].[Usp_PaynInRpt_22Dec2017]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN

				select * into #client_details from risk.dbo.client_details with(nolock)

				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
				into  #UPI
				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
				from
				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
				Risk.dbo.tbl_BoPostUPITransaction  b 
				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
				-----//////  ATOM and TECH  \\\\\-----
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName into #main
				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
				inner join risk.dbo.client_details b on
				a.Party_Code =b.party_code  
				and  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
					
				UNION
				
				--//////  ATOM and TECH  with (mimansa)\\\\\---
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName
				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
				inner join risk.dbo.client_details b on
				a.Party_Code =b.party_code  
				and  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
				UNION
				
				----////UPI\\\--------
			
				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
				space(500) as BankName
				from #UPI a, risk.dbo.client_details b (nolock)                        
				where a.ClientCode =b.party_code and 
				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
		
				
				UNION
				---////Finox\\\------
				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'DIRECT' as PaymentMode,BankRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],
				AccountNo as BankAccountNo,space(500) as BankName
				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a,
				risk.dbo.client_details b (nolock)                        
				where a.client_code =b.party_code
				and 
				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				/***For Checcking ledger Posting****/
				select * into #tbl_Post_data from anand.MKTAPI.dbo.tbl_post_data where VDATE>=getdate()-3 
				
				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
				m.[Segment],[Transaction Status],[Transaction status Date and time],[Changed Transaction Date And Time],[Changed Transaction Status]
				,m.BankAccountNo,m.BankName,
				case when ROWSTATE=2 then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				isnull (convert( varchar(11),a.vdate),'N/A') as  [Date Updated in ledger] 
				from #main m 
				left join #tbl_Post_data  a with (nolock) on 
				m.[ClientCode]=a.CLTCODE and 
				m.TransactionReferenceNo=a.DDNO
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PaynInRpt_27122017
-- --------------------------------------------------

--exec Usp_PaynInRpt '13/12/2017','13/12/2017','Broker','CSO'

Create Procedure [dbo].[Usp_PaynInRpt_27122017]                   
(        
@FromDate varchar(25), 
@ToDate varchar(25),
--@ClientCode varchar(10),      
--@Status varchar(20),  
--@Source varchar(20),              
@access_to varchar(30),                    
@access_code varchar(30)
--@username as varchar(30) username                   
)                   
as 
BEGIN

				select * into #client_details from risk.dbo.client_details with(nolock)

				select a.clientcode,a.ftsessionid,a.ftrequestid,a.ftbankrefno,a.amount,a.productid,a.entity,a.segment,a.segid,a.insertedon,b.PostStatus
				into  #UPI
				--a.ftBankRefNo,a.ClientCode,a.AMount,b.PostStatus,a.InsertedOn,b.InsertedOn as ddate,a.entity,a.segment 
				from
				Risk.dbo.MSIL_MKTAPIBOPOSTDATA  a join 
				Risk.dbo.tbl_BoPostUPITransaction  b 
				on a.ftbankrefno=b.BankRefNo and a.ClientCode=b.ClientCode
				where a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				SELECT * into #ff FROM Risk.dbo.MSIL_MKTAPIBOPOSTDATA a where ftbankrefno not in(select ftbankrefno from #UPI) 
				and a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'

				
				insert into #UPI(clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,PostStatus)
				select clientcode,ftsessionid,ftrequestid,ftbankrefno,amount,productid,entity,segment,segid,insertedon,'Success' from #ff 
				
				-----//////  ATOM and TECH  \\\\\-----
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName into #main
				from Accounts.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
					
				UNION
				
				--//////  ATOM and TECH  with (mimansa)\\\\\---
				select a.LogDate as [Date Of Transaction],a.Party_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				a.vendor as PaymentMode,a.TransactionReferenceNo,a.Amount,a.Segment,a.VerificationRemark as [Transaction Status],
				a.VerificationDate as [Transaction status Date and time],isnull (convert( varchar(11),a.ReVerificationDate),'N/A') as [Changed Transaction Date And Time],isnull( a.ReVerificationRemark,'N/A') as [Changed Transaction Status],
				a.BankAccountNo,a.BankName
				from mimansa.general.dbo.tbl_AngelPGIMBOTransactionLog a
				left join #client_details b on
				a.Party_Code =b.party_code  
				where  a.LogDate >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' 
				and  a.LogDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59'
				
				UNION
				
				----////UPI\\\--------
			
				select insertedon as [Date Of Transaction],ClientCode as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'UPI' as PaymentMode,ftbankrefno as TransactionReferenceNo,Amount,Entity as Segment, 
				PostStatus  as [Transaction Status], insertedon as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],space(500) as BankAccountNo,
				space(500) as BankName
				from #UPI a, #client_details b (nolock)                        
				where a.ClientCode =b.party_code and 
				a.insertedon >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.insertedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
		
				
				UNION
				---////Finox\\\------
				select  TransReq_dtm as [Date Of Transaction],Client_Code as [ClientCode],b.branch_cd as [Br.Code],b.Sub_Broker as [SB.Code],
				'DIRECT' as PaymentMode,BankRef_No as TransactionReferenceNo,Amount,SegmentCode as Segment,a.Status as [Transaction Status] ,
				TransResp_dtm as  [Transaction status Date and time],'N/A' as [Changed Transaction Date And Time],
				 'N/A' as [Changed Transaction Status],
				AccountNo as BankAccountNo,space(500) as BankName
				from [172.31.16.75].Angel_Admin.dbo.PG_Transaction a,
				#client_details b (nolock)                        
				where a.client_code =b.party_code
				and 
				a.TransReq_dtm >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
				and a.TransReq_dtm <=replace(CONVERT(VARCHAR(12),convert(datetime,@ToDate,103),106), '/', ' ')+' 23:59:59' 
				
				/***For Checcking ledger Posting****/
				select * into #tbl_Post_data from anand.MKTAPI.dbo.tbl_post_data where VDATE>=getdate()-3 
				
				select distinct [Date Of Transaction],[ClientCode],[Br.Code],[SB.Code],[PaymentMode],[TransactionReferenceNo],[Amount],
				m.[Segment],[Transaction Status],[Transaction status Date and time],[Changed Transaction Date And Time],[Changed Transaction Status]
				,m.BankAccountNo,m.BankName,
				case when ROWSTATE=2 then 'Y' else 'N' END  as [Receipt Entry updated in ledger],
				isnull (convert( varchar(11),a.vdate),'N/A') as  [Date Updated in ledger] 
				from #main m 
				left join #tbl_Post_data  a with (nolock) on 
				m.[ClientCode]=a.CLTCODE and 
				m.TransactionReferenceNo=a.DDNO
				
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_physical_copy
-- --------------------------------------------------
/******************************************************************************
CREATED BY: SHIVAKUMAR LAKKAMPELLI
DATE: 02 JUNE 2011
PURPOSE: used to display the physical copy details

MODIFIED BY: PROGRAMMER NAME
DATED: DD/MM/YYYY
REASON: REASON TO CHANGE STORE PROCEDURE
******************************************************************************/
CREATE PROCEDURE usp_physical_copy 
AS
BEGIN
      select * from Physical_copy_details

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Status
-- --------------------------------------------------

    CREATE PROC USP_STATUS          
    AS          
    BEGIN
		SELECT *
		FROM  RISK.DBO.CHQ_STATUS 
		ORDER BY SR_NO  DESC
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_status1
-- --------------------------------------------------

CREATE PROC USP_STATUS1          
AS   
BEGIN          
    SELECT *   
    FROM  RISK.DBO.CHQ_STATUS    
    WHERE STATUS_TEXT <> 'ALL'   
    ORDER BY STATUS_TEXT  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SubBroker_EXISTS
-- --------------------------------------------------
 CREATE PROC USP_SubBroker_EXISTS  --'SHWM'      
 (      
    @Sbcode VARCHAR(10)      
 )      
 AS      
 SELECT * FROM  TBL_CHQRTN_BO_ENTRIES       
 WHERE sub_broker=@sbcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_update_check_details
-- --------------------------------------------------
	CREATE PROC USP_UPDATE_CHECK_DETAILS
	(
		@CLIENTID VARCHAR(10) ,
		@STATUS VARCHAR(10),
		@REMARK VARCHAR(200),
		@IMAGE VARBINARY(MAX),
		@PHYSICALCOPY_STATUS VARCHAR(25),
		@UPDATED_BY VARCHAR(15)
	)
	AS
	BEGIN
			IF EXISTS (SELECT TOP 1 * FROM TBL_CLIENT_CHECK_DETAILS WHERE CLIENTID =@CLIENTID)
			BEGIN
				IF EXISTS (SELECT IMAGE FROM TBL_CLIENT_CHECK_DETAILS WHERE CLIENTID =@CLIENTID)
				BEGIN
					IF (@IMAGE='')
					BEGIN
						UPDATE TBL_CLIENT_CHECK_DETAILS
								SET STATUS =@STATUS,REMARK =@REMARK,PHYCOPY_STATUS=@PHYSICALCOPY_STATUS ,
									UPDATED_BY= @UPDATED_BY ,UPDATE_ON = GETDATE()
									WHERE CLIENTID=@CLIENTID
					END
				
				ELSE
					BEGIN
						UPDATE TBL_CLIENT_CHECK_DETAILS
						SET STATUS =@STATUS,REMARK =@REMARK,PHYCOPY_STATUS=@PHYSICALCOPY_STATUS ,
						IMAGE =@IMAGE ,UPDATED_BY= @UPDATED_BY ,UPDATE_ON = GETDATE()
						WHERE CLIENTID=@CLIENTID

					END
				  END	
	          End
			ELSE
				BEGIN
					INSERT INTO TBL_CLIENT_CHECK_DETAILS (CLIENTID,STATUS,REMARK,IMAGE,PHYCOPY_STATUS,UPDATED_BY,UPDATE_ON)
					VALUES (@CLIENTID, @STATUS ,@REMARK,@IMAGE,@PHYSICALCOPY_STATUS,@UPDATED_BY,GETDATE())
				END
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_update_check_status
-- --------------------------------------------------
     CREATE PROC USP_UPDATE_CHECK_STATUS -- '1254','TEST','TESTBYSHIVA'          
       (            
         @ID VARCHAR(10) ,           
         @STATUS VARCHAR(10),            
         @REMARK VARCHAR(200),  
         @PHYSICALCOPY_STATUS VARCHAR(25)            
        )            
       AS            
       BEGIN       
       IF EXISTS (SELECT ID FROM Tbl_Client_Check_details WHERE ID =@ID)         
          UPDATE  Tbl_Client_Check_details SET STATUS =@STATUS,REMARK =@REMARK,PHYCOPY_STATUS=@PHYSICALCOPY_STATUS WHERE ID=@ID      
       ELSE      
          SELECT 'NO_ENTRY'         
         
                
       END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usptesttaskproc
-- --------------------------------------------------
CREATE proc usptesttaskproc
as
begin

insert into testtaskproc
select getdate()

WAITFOR DELAY '00:00:10';
end

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_Entity_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_Entity_Master]
(
    [Entity] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [SeqId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Acc_MF_entry
-- --------------------------------------------------
CREATE TABLE [dbo].[Acc_MF_entry]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [BOOKTYPE] VARCHAR(2) NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [OPPCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(20) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(30) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [TPFLAG] TINYINT NULL,
    [ADDDT] DATETIME NULL,
    [ADDBY] VARCHAR(25) NULL,
    [STATUSID] VARCHAR(25) NULL,
    [STATUSNAME] VARCHAR(25) NULL,
    [ROWSTATE] TINYINT NULL,
    [APPROVALFLAG] TINYINT NULL,
    [APPROVALDATE] DATETIME NULL,
    [APPROVEDBY] VARCHAR(25) NULL,
    [VOUCHERNO] VARCHAR(12) NULL,
    [UPLOADDT] DATETIME NULL,
    [LEDGERVNO] VARCHAR(12) NULL,
    [CLIENTNAME] VARCHAR(100) NULL,
    [OPPCODENAME] VARCHAR(100) NULL,
    [MARGINCODENAME] VARCHAR(100) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [PRODUCTTYPE] VARCHAR(3) NULL,
    [REVAMT] MONEY NULL,
    [REVCODE] VARCHAR(21) NULL,
    [MICR] VARCHAR(12) NULL,
    [REL_DATE] DATETIME NULL,
    [DISPLAY_FLAG] BIT NULL,
    [RESERVED1] VARCHAR(10) NULL,
    [RESERVED2] VARCHAR(10) NULL,
    [RESERVED3] VARCHAR(10) NULL,
    [RESERVED4] VARCHAR(10) NULL,
    [RESERVED5] VARCHAR(10) NULL,
    [RESERVED6] VARCHAR(10) NULL,
    [RESERVED7] VARCHAR(10) NULL,
    [RESERVED8] VARCHAR(10) NULL,
    [RESERVED9] VARCHAR(10) NULL,
    [RESERVED10] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_OnlineFundResponse
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_OnlineFundResponse]
(
    [InsertedString] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACC_OnlineODIN_tbl
-- --------------------------------------------------
CREATE TABLE [dbo].[ACC_OnlineODIN_tbl]
(
    [RequestID] VARCHAR(50) NULL,
    [AppName] VARCHAR(100) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Segment] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL,
    [BankAccountNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [LogDate] DATETIME NULL,
    [Vendor] VARCHAR(20) NULL,
    [VendorMerchantID] VARCHAR(50) NULL,
    [TransactionMerchantID] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [TransactionStatus] VARCHAR(50) NULL,
    [TransactionRemark] VARCHAR(MAX) NULL,
    [TransactionDate] DATETIME NULL,
    [TransactionVerified] VARCHAR(10) NULL,
    [VerificationRemark] VARCHAR(100) NULL,
    [VerificationDate] DATETIME NULL,
    [LimitUpdateStatus] VARCHAR(20) NULL,
    [LimitUpdateRequestInitiatedAt] DATETIME NULL,
    [LimitUpdateResponseRecvdAt] DATETIME NULL,
    [LimitUpdateResponse] VARCHAR(MAX) NULL,
    [LimitUpdationDoneBy] VARCHAR(50) NULL,
    [LimitUpdationAPIStatus] VARCHAR(50) NULL,
    [LimitUpdationAPIMessage] VARCHAR(1000) NULL,
    [TransactionReVerified] VARCHAR(10) NULL,
    [ReVerificationRemark] VARCHAR(100) NULL,
    [ReVerificationDate] DATETIME NULL,
    [ExtraField1] VARCHAR(MAX) NULL,
    [ExtraField2] VARCHAR(MAX) NULL,
    [ExtraField3] VARCHAR(MAX) NULL,
    [ExtraField4] VARCHAR(MAX) NULL,
    [ExtraField5] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AGG_BO_BankReceipt_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[AGG_BO_BankReceipt_temp]
(
    [Sr No] BIGINT NULL,
    [Edate] VARCHAR(10) NULL,
    [Vdate] VARCHAR(10) NULL,
    [Cltcode] VARCHAR(10) NULL,
    [Amount] NUMERIC(18, 2) NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [Narration] VARCHAR(50) NULL,
    [BankCode] VARCHAR(10) NOT NULL,
    [BankName] VARCHAR(100) NULL,
    [DDno] VARCHAR(50) NULL,
    [Branchcode] VARCHAR(2) NOT NULL,
    [Chqmode] VARCHAR(3) NOT NULL,
    [chqdate] VARCHAR(10) NULL,
    [chqname] VARCHAR(100) NULL,
    [Clmode] VARCHAR(1) NOT NULL,
    [GeneratedOn] DATETIME NOT NULL,
    [Updation_Type] VARCHAR(1) NOT NULL,
    [Updation_flag] VARCHAR(1) NOT NULL,
    [Updation_status] VARCHAR(25) NULL,
    [Updation_Time] DATETIME NOT NULL,
    [ResponseCode] VARCHAR(25) NULL,
    [Segment] VARCHAR(10) NULL,
    [CliAccountNo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.agg_For_checking
-- --------------------------------------------------
CREATE TABLE [dbo].[agg_For_checking]
(
    [Requestdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AGG_MKTAPI_NotPostedIn_BO
-- --------------------------------------------------
CREATE TABLE [dbo].[AGG_MKTAPI_NotPostedIn_BO]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(30) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AGG_MKTAPI_tblpostdate
-- --------------------------------------------------
CREATE TABLE [dbo].[AGG_MKTAPI_tblpostdate]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(30) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AGG_PG_VMID
-- --------------------------------------------------
CREATE TABLE [dbo].[AGG_PG_VMID]
(
    [sBankId] VARCHAR(50) NULL,
    [Vendor] VARCHAR(50) NULL,
    [VendorMerchantID] VARCHAR(10) NULL,
    [Active] INT NULL,
    [defaultID] INT NULL,
    [NextVendorMID] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Agg_tbl_AccMissing_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[Agg_tbl_AccMissing_Data]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AGG_tblpostdataWithZeroRowState
-- --------------------------------------------------
CREATE TABLE [dbo].[AGG_tblpostdataWithZeroRowState]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(50) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Agg_TechTrnasction
-- --------------------------------------------------
CREATE TABLE [dbo].[Agg_TechTrnasction]
(
    [Req_string] VARCHAR(MAX) NULL,
    [Response_string] VARCHAR(MAX) NULL,
    [LogDate] DATETIME NULL,
    [tpsl_clnt_cd] VARCHAR(500) NULL,
    [clnt_txn_ref] VARCHAR(500) NULL,
    [VendorMerchantId] VARCHAR(50) NULL,
    [Requestdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Agg_TechTrnasctionSplitData
-- --------------------------------------------------
CREATE TABLE [dbo].[Agg_TechTrnasctionSplitData]
(
    [txn_status] VARCHAR(50) NULL,
    [txn_msg] VARCHAR(50) NULL,
    [txn_err_msg] VARCHAR(50) NULL,
    [clnt_txn_ref] VARCHAR(50) NULL,
    [tpsl_bank_cd] VARCHAR(50) NULL,
    [tpsl_txn_id] VARCHAR(50) NULL,
    [txn_amt] VARCHAR(50) NULL,
    [clnt_rqst_meta] VARCHAR(50) NULL,
    [tpsl_txn_time] VARCHAR(50) NULL,
    [tpsl_rfnd_id] VARCHAR(50) NULL,
    [bal_amt] VARCHAR(50) NULL,
    [BankTransactionID] VARCHAR(50) NULL,
    [rqst_token] VARCHAR(50) NULL,
    [hash] VARCHAR(500) NULL,
    [lid] VARCHAR(50) NULL,
    [LastUpDateTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.Agg_Techvend
-- --------------------------------------------------
CREATE TABLE [dbo].[Agg_Techvend]
(
    [tpsl_clnt_cd] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AggError
-- --------------------------------------------------
CREATE TABLE [dbo].[AggError]
(
    [ErrorNumber] BIGINT NULL,
    [ErrorSeverity] VARCHAR(200) NULL,
    [ErrorLine] VARCHAR(500) NULL,
    [ErrorMessage] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AgreegatorTranPaynetTechRequestResponse
-- --------------------------------------------------
CREATE TABLE [dbo].[AgreegatorTranPaynetTechRequestResponse]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [vendor] VARCHAR(50) NULL,
    [request] VARCHAR(MAX) NULL,
    [response] VARCHAR(MAX) NULL,
    [insertedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.chq_status
-- --------------------------------------------------
CREATE TABLE [dbo].[chq_status]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [status_value] VARCHAR(15) NULL,
    [status_text] VARCHAR(15) NULL,
    [status_flag] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ddd
-- --------------------------------------------------
CREATE TABLE [dbo].[ddd]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(20) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(100) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(30) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(30) NULL,
    [RETURN_FLD2] VARCHAR(40) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Filter_Levels
-- --------------------------------------------------
CREATE TABLE [dbo].[Filter_Levels]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Leveltype] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GBL_Entity_segment
-- --------------------------------------------------
CREATE TABLE [dbo].[GBL_Entity_segment]
(
    [Entity] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [SeqId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GBL_Entity_segment_Merger
-- --------------------------------------------------
CREATE TABLE [dbo].[GBL_Entity_segment_Merger]
(
    [Entity] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [SeqId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GBL_ERROR
-- --------------------------------------------------
CREATE TABLE [dbo].[GBL_ERROR]
(
    [ErrID] INT IDENTITY(1,1) NOT NULL,
    [ErrTime] DATETIME NULL,
    [ErrObject] VARCHAR(MAX) NULL,
    [ErrLine] INT NULL,
    [ErrMessage] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GBL_Temp_checking_pkg
-- --------------------------------------------------
CREATE TABLE [dbo].[GBL_Temp_checking_pkg]
(
    [sp_name] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Levels
-- --------------------------------------------------
CREATE TABLE [dbo].[Levels]
(
    [id] INT NULL,
    [Level] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.main
-- --------------------------------------------------
CREATE TABLE [dbo].[main]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sample
-- --------------------------------------------------
CREATE TABLE [dbo].[sample]
(
    [name] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Status_Types
-- --------------------------------------------------
CREATE TABLE [dbo].[Status_Types]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Status_t] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysdiagrams
-- --------------------------------------------------
CREATE TABLE [dbo].[sysdiagrams]
(
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT IDENTITY(1,1) NOT NULL,
    [version] INT NULL,
    [definition] VARBINARY(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Aggregator_Staging
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Aggregator_Staging]
(
    [suserdefinedExchangeName] VARCHAR(50) NULL,
    [SloginId] VARCHAR(10) NULL,
    [party_Code] VARCHAR(10) NOT NULL,
    [Entity] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [SeqId] INT NULL,
    [status] VARCHAR(1) NULL,
    [seg] VARCHAR(5) NOT NULL,
    [updatedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_agreegator_mailer_structure
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_agreegator_mailer_structure]
(
    [Request Id] VARCHAR(70) NULL,
    [vendor] VARCHAR(70) NULL,
    [Merchant ID] VARCHAR(20) NULL,
    [Merchant Tran ID] VARCHAR(100) NULL,
    [Tran Amount] VARCHAR(100) NULL,
    [Log Date] VARCHAR(100) NULL,
    [Verification Status] VARCHAR(100) NULL,
    [Tran Ref No] VARCHAR(50) NULL,
    [Bank Name] VARCHAR(500) NULL,
    [Verification Date] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AgreegatorPaynetzTechResponse
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AgreegatorPaynetzTechResponse]
(
    [requestID] VARCHAR(50) NULL,
    [vendor] VARCHAR(50) NULL,
    [merchantID] VARCHAR(50) NULL,
    [merchantTranID] VARCHAR(60) NULL,
    [merchantTranAmount] DECIMAL(18, 4) NULL,
    [logDate] VARCHAR(50) NULL,
    [TranRefNo] VARCHAR(50) NULL,
    [requestTime] DATETIME NULL,
    [strdate] VARCHAR(50) NULL,
    [transactionVerified] VARCHAR(10) NULL,
    [TranVerificationStatus] VARCHAR(50) NULL,
    [TranAtomRefNo] VARCHAR(100) NULL,
    [TranTechRefNo] VARCHAR(100) NULL,
    [TranBankName] VARCHAR(100) NULL,
    [transactionStatus] VARCHAR(100) NULL,
    [VerificationResponse] VARCHAR(5000) NULL,
    [requestString] VARCHAR(5000) NULL,
    [verificationType] VARCHAR(50) NULL,
    [insertedon] DATETIME NULL,
    [rectype] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ANGELPGIMBOTransactionLog_deleteddata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ANGELPGIMBOTransactionLog_deleteddata]
(
    [RequestID] VARCHAR(50) NULL,
    [AppName] VARCHAR(100) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Segment] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL,
    [BankAccountNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [LogDate] DATETIME NULL,
    [Vendor] VARCHAR(20) NULL,
    [VendorMerchantID] VARCHAR(50) NULL,
    [TransactionMerchantID] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [TransactionStatus] VARCHAR(50) NULL,
    [TransactionRemark] VARCHAR(MAX) NULL,
    [TransactionDate] DATETIME NULL,
    [TransactionVerified] VARCHAR(10) NULL,
    [VerificationRemark] VARCHAR(100) NULL,
    [VerificationDate] DATETIME NULL,
    [LimitUpdateStatus] VARCHAR(20) NULL,
    [LimitUpdateRequestInitiatedAt] DATETIME NULL,
    [LimitUpdateResponseRecvdAt] DATETIME NULL,
    [LimitUpdateResponse] VARCHAR(MAX) NULL,
    [LimitUpdationDoneBy] VARCHAR(50) NULL,
    [LimitUpdationAPIStatus] VARCHAR(50) NULL,
    [LimitUpdationAPIMessage] VARCHAR(1000) NULL,
    [TransactionReVerified] VARCHAR(10) NULL,
    [ReVerificationRemark] VARCHAR(100) NULL,
    [ReVerificationDate] DATETIME NULL,
    [ExtraField1] VARCHAR(MAX) NULL,
    [ExtraField2] VARCHAR(MAX) NULL,
    [ExtraField3] VARCHAR(MAX) NULL,
    [ExtraField4] VARCHAR(MAX) NULL,
    [ExtraField5] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AngelPGIMBOTransactionLog_EQ_FNO_CURR
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AngelPGIMBOTransactionLog_EQ_FNO_CURR]
(
    [RequestID] VARCHAR(50) NULL,
    [AppName] VARCHAR(100) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Segment] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL,
    [BankAccountNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [LogDate] DATETIME NULL,
    [Vendor] VARCHAR(20) NULL,
    [VendorMerchantID] VARCHAR(50) NULL,
    [TransactionMerchantID] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [TransactionStatus] VARCHAR(50) NULL,
    [TransactionRemark] VARCHAR(MAX) NULL,
    [TransactionDate] DATETIME NULL,
    [TransactionVerified] VARCHAR(10) NULL,
    [VerificationRemark] VARCHAR(100) NULL,
    [VerificationDate] DATETIME NULL,
    [LimitUpdateStatus] VARCHAR(20) NULL,
    [LimitUpdateRequestInitiatedAt] DATETIME NULL,
    [LimitUpdateResponseRecvdAt] DATETIME NULL,
    [LimitUpdateResponse] VARCHAR(MAX) NULL,
    [LimitUpdationDoneBy] VARCHAR(50) NULL,
    [LimitUpdationAPIStatus] VARCHAR(50) NULL,
    [LimitUpdationAPIMessage] VARCHAR(1000) NULL,
    [TransactionReVerified] VARCHAR(10) NULL,
    [ReVerificationRemark] VARCHAR(100) NULL,
    [ReVerificationDate] DATETIME NULL,
    [ExtraField1] VARCHAR(MAX) NULL,
    [ExtraField2] VARCHAR(MAX) NULL,
    [ExtraField3] VARCHAR(MAX) NULL,
    [ExtraField4] VARCHAR(MAX) NULL,
    [ExtraField5] VARCHAR(MAX) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ANGELPGIMBOTransactionLog_newlogic
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ANGELPGIMBOTransactionLog_newlogic]
(
    [RequestID] VARCHAR(50) NULL,
    [AppName] VARCHAR(100) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Segment] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL,
    [BankAccountNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [LogDate] DATETIME NULL,
    [Vendor] VARCHAR(20) NULL,
    [VendorMerchantID] VARCHAR(50) NULL,
    [TransactionMerchantID] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [TransactionStatus] VARCHAR(50) NULL,
    [TransactionRemark] VARCHAR(MAX) NULL,
    [TransactionDate] DATETIME NULL,
    [TransactionVerified] VARCHAR(10) NULL,
    [VerificationRemark] VARCHAR(100) NULL,
    [VerificationDate] DATETIME NULL,
    [LimitUpdateStatus] VARCHAR(20) NULL,
    [LimitUpdateRequestInitiatedAt] DATETIME NULL,
    [LimitUpdateResponseRecvdAt] DATETIME NULL,
    [LimitUpdateResponse] VARCHAR(MAX) NULL,
    [LimitUpdationDoneBy] VARCHAR(50) NULL,
    [LimitUpdationAPIStatus] VARCHAR(50) NULL,
    [LimitUpdationAPIMessage] VARCHAR(1000) NULL,
    [TransactionReVerified] VARCHAR(10) NULL,
    [ReVerificationRemark] VARCHAR(100) NULL,
    [ReVerificationDate] DATETIME NULL,
    [ExtraField1] VARCHAR(MAX) NULL,
    [ExtraField2] VARCHAR(MAX) NULL,
    [ExtraField3] VARCHAR(MAX) NULL,
    [ExtraField4] VARCHAR(MAX) NULL,
    [ExtraField5] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AngelPGIMVerificationProcess_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AngelPGIMVerificationProcess_Log]
(
    [RequestId] VARCHAR(50) NULL,
    [RequestString] VARCHAR(5000) NULL,
    [RequestTime] DATETIME NULL,
    [ResponseString] VARCHAR(5000) NULL,
    [verificationStatus] VARCHAR(50) NULL,
    [VerficationType] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AngelPGIMVerificationProcess_Log_newlogic
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AngelPGIMVerificationProcess_Log_newlogic]
(
    [RequestId] VARCHAR(50) NULL,
    [RequestString] VARCHAR(5000) NULL,
    [RequestTime] DATETIME NULL,
    [ResponseString] VARCHAR(5000) NULL,
    [verificationStatus] VARCHAR(50) NULL,
    [VerficationType] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AtomFile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AtomFile]
(
    [SRNO] INT NOT NULL,
    [BANKID] VARCHAR(50) NOT NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [TRANSID] VARCHAR(50) NULL,
    [SMTXNID] VARCHAR(50) NOT NULL,
    [ACTUALTOTAMT] DECIMAL(18, 2) NULL,
    [TOTCOMM] VARCHAR(50) NULL,
    [SERVICETAX] DECIMAL(18, 4) NULL,
    [NETAMOUNT] DECIMAL(18, 2) NULL,
    [TXNDATE] VARCHAR(50) NULL,
    [TXNTIME] VARCHAR(50) NULL,
    [PAYMENTDATE] VARCHAR(50) NULL,
    [ITC] VARCHAR(50) NULL,
    [STATUS_DESC] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_checkingAggregatorData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_checkingAggregatorData]
(
    [sLoginId] VARCHAR(10) NULL,
    [nMarketSegmentId] VARCHAR(10) NULL,
    [sUserDefinedExchangeName] VARCHAR(50) NULL,
    [nAmount] NUMERIC(18, 2) NULL,
    [nServiceCharge] NUMERIC(18, 2) NULL,
    [sDateTime] DATETIME NULL,
    [nTxnRefNo] VARCHAR(13) NULL,
    [sGroupId] VARCHAR(40) NULL,
    [nProcessFlag] INT NULL,
    [sBankId] VARCHAR(30) NULL,
    [sAgencyId] VARCHAR(10) NULL,
    [sFromAccNo] VARCHAR(20) NULL,
    [sToAccNo] VARCHAR(20) NULL,
    [product] VARCHAR(10) NOT NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_checkingForSegment
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_checkingForSegment]
(
    [RequestID] VARCHAR(50) NULL,
    [AppName] VARCHAR(100) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Segment] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL,
    [BankAccountNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [LogDate] DATETIME NULL,
    [Vendor] VARCHAR(20) NULL,
    [VendorMerchantID] VARCHAR(50) NULL,
    [TransactionMerchantID] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [TransactionStatus] VARCHAR(50) NULL,
    [TransactionRemark] VARCHAR(MAX) NULL,
    [TransactionDate] DATETIME NULL,
    [TransactionVerified] VARCHAR(10) NULL,
    [VerificationRemark] VARCHAR(100) NULL,
    [VerificationDate] DATETIME NULL,
    [LimitUpdateStatus] VARCHAR(20) NULL,
    [LimitUpdateRequestInitiatedAt] DATETIME NULL,
    [LimitUpdateResponseRecvdAt] DATETIME NULL,
    [LimitUpdateResponse] VARCHAR(MAX) NULL,
    [LimitUpdationDoneBy] VARCHAR(50) NULL,
    [LimitUpdationAPIStatus] VARCHAR(50) NULL,
    [LimitUpdationAPIMessage] VARCHAR(1000) NULL,
    [TransactionReVerified] VARCHAR(10) NULL,
    [ReVerificationRemark] VARCHAR(100) NULL,
    [ReVerificationDate] DATETIME NULL,
    [ExtraField1] VARCHAR(MAX) NULL,
    [ExtraField2] VARCHAR(MAX) NULL,
    [ExtraField3] VARCHAR(MAX) NULL,
    [ExtraField4] VARCHAR(MAX) NULL,
    [ExtraField5] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ChkPost
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ChkPost]
(
    [DDNO] VARCHAR(15) NULL,
    [Inserted_date] DATETIME NULL,
    [EnteredBy] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_chkpost_1082017_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_chkpost_1082017_Hist]
(
    [DDNO] VARCHAR(15) NULL,
    [Inserted_date] DATETIME NULL,
    [EnteredBy] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_chkpost_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_chkpost_Temp]
(
    [DDNO] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ChqRtn_BO_Entries
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ChqRtn_BO_Entries]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Branch] VARCHAR(12) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [vdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(100) NULL,
    [vamt] MONEY NULL,
    [vno] VARCHAR(12) NOT NULL,
    [ChequeNo] VARCHAR(15) NULL,
    [narration] VARCHAR(234) NULL,
    [CMS_cheque] VARCHAR(1) NULL,
    [Process_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CHQRTN_BO_ENTRIES_log
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CHQRTN_BO_ENTRIES_log]
(
    [id] INT NOT NULL,
    [Branch] VARCHAR(12) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [vdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(100) NULL,
    [vamt] MONEY NULL,
    [vno] VARCHAR(12) NOT NULL,
    [ChequeNo] VARCHAR(10) NULL,
    [narration] VARCHAR(234) NULL,
    [CMS_cheque] VARCHAR(1) NULL,
    [Process_Date] DATETIME NOT NULL,
    [action_type] VARCHAR(8) NOT NULL,
    [action_date] DATETIME NOT NULL,
    [action_by] VARCHAR(50) NULL,
    [action_location] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Client_Check_details
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Client_Check_details]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [clientid] INT NULL,
    [Status] VARCHAR(10) NULL,
    [Remark] VARCHAR(200) NULL,
    [image] VARBINARY(MAX) NULL,
    [phycopy_status] VARCHAR(25) NULL,
    [updated_by] VARCHAR(12) NULL,
    [update_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_client_checkdetails_backup
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_client_checkdetails_backup]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [clientid] INT NULL,
    [Status] VARCHAR(10) NULL,
    [Remark] VARCHAR(200) NULL,
    [image] VARBINARY(MAX) NULL,
    [phycopy_status] VARCHAR(25) NULL,
    [updated_by] VARCHAR(12) NULL,
    [update_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ft_atomtechbankmapping
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ft_atomtechbankmapping]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [bankid] INT NULL,
    [bankname] VARCHAR(250) NULL,
    [vendorType] VARCHAR(40) NULL,
    [isactive] BIT NULL,
    [insertedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_post_AccMissing_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_post_AccMissing_Data]
(
    [FLDAUTO] INT NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SUCCESS_TRANSACTION_VERIFICATION_STATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SUCCESS_TRANSACTION_VERIFICATION_STATUS]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [service_start_date] DATETIME NULL,
    [service_end_date] DATETIME NULL,
    [verification_count] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TechFile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TechFile]
(
    [SRNO] INT NOT NULL,
    [BANK_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NULL,
    [TRAN_ID] VARCHAR(MAX) NULL,
    [SRC_PRN] VARCHAR(MAX) NULL,
    [SRC_AMT] DECIMAL(18, 2) NULL,
    [TOTCOMM] VARCHAR(50) NULL,
    [SERVICE_TAX] DECIMAL(18, 4) NULL,
    [AMT_GIVE_TO_SUBMER] DECIMAL(18, 5) NULL,
    [TXN_DATE] VARCHAR(50) NULL,
    [TXN_TIME] VARCHAR(50) NULL,
    [PAYMENT_DATE] VARCHAR(50) NULL,
    [SRC_ITC] VARCHAR(MAX) NULL,
    [STATUS_DESC] VARCHAR(MAX) NULL,
    [Blank] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TechFile_pramod
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TechFile_pramod]
(
    [SRNO] INT NOT NULL,
    [BANK_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NULL,
    [TRAN_ID] VARCHAR(MAX) NULL,
    [SRC_PRN] VARCHAR(MAX) NULL,
    [SRC_AMT] DECIMAL(18, 2) NULL,
    [TOTCOMM] VARCHAR(50) NULL,
    [SERVICE_TAX] DECIMAL(18, 4) NULL,
    [AMT_GIVE_TO_SUBMER] DECIMAL(18, 5) NULL,
    [TXN_DATE] VARCHAR(50) NULL,
    [TXN_TIME] VARCHAR(50) NULL,
    [PAYMENT_DATE] VARCHAR(50) NULL,
    [SRC_ITC] VARCHAR(MAX) NULL,
    [STATUS_DESC] VARCHAR(MAX) NULL,
    [Blank] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VERIFICATION_STATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VERIFICATION_STATUS]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [Service_Start_Date] DATETIME NULL,
    [Service_End_Date] DATETIME NULL,
    [Verification_Cnt] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VERIFICATION_SUCESSTRAN
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VERIFICATION_SUCESSTRAN]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [startdate] DATETIME NULL,
    [enddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblAgreegatorVerificationErrorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tblAgreegatorVerificationErrorLog]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [request] VARCHAR(200) NULL,
    [methodname] VARCHAR(200) NULL,
    [errormessage] VARCHAR(MAX) NULL,
    [status] VARCHAR(20) NULL,
    [insertedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_BOFile
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_BOFile]
(
    [Sr No] BIGINT NULL,
    [Edate] VARCHAR(10) NULL,
    [Vdate] VARCHAR(10) NULL,
    [Cltcode] VARCHAR(10) NULL,
    [Amount] NUMERIC(18, 2) NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [Narration] VARCHAR(50) NULL,
    [BankCode] VARCHAR(10) NOT NULL,
    [BankName] VARCHAR(100) NULL,
    [DDno] VARCHAR(50) NULL,
    [Branchcode] VARCHAR(2) NOT NULL,
    [Chqmode] VARCHAR(3) NOT NULL,
    [chqdate] VARCHAR(10) NULL,
    [chqname] VARCHAR(100) NULL,
    [Clmode] VARCHAR(1) NOT NULL,
    [GeneratedOn] DATETIME NOT NULL,
    [Updation_Type] VARCHAR(1) NOT NULL,
    [Updation_flag] VARCHAR(1) NOT NULL,
    [Updation_status] VARCHAR(25) NULL,
    [Updation_Time] DATETIME NOT NULL,
    [ResponseCode] VARCHAR(25) NULL,
    [Segment] VARCHAR(10) NULL,
    [CliAccountNo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempagree
-- --------------------------------------------------
CREATE TABLE [dbo].[tempagree]
(
    [RequestId] VARCHAR(50) NULL,
    [RequestString] VARCHAR(5000) NULL,
    [RequestTime] DATETIME NULL,
    [ResponseString] VARCHAR(5000) NULL,
    [verificationStatus] VARCHAR(50) NULL,
    [VerficationType] VARCHAR(50) NULL,
    [TransactionReferenceNo] VARCHAR(50) NULL,
    [BankName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.testtaskproc
-- --------------------------------------------------
CREATE TABLE [dbo].[testtaskproc]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [insertedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UPDATE_CLIENT_CHECK_DETAIL
-- --------------------------------------------------
CREATE TABLE [dbo].[UPDATE_CLIENT_CHECK_DETAIL]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [clientid] INT NOT NULL,
    [Status] VARCHAR(10) NULL,
    [Remark] VARCHAR(200) NULL,
    [image] VARBINARY(MAX) NULL,
    [updated_by] VARCHAR(12) NULL,
    [update_on] DATETIME NULL,
    [phycopy_status] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.GBL_ERROR_ErrTrig
-- --------------------------------------------------
CREATE trigger GBL_ERROR_ErrTrig on dbo.GBL_ERROR  for insert       
as        
begin        
select ''    
  
 declare @str varchar(max)        
 declare @i int        
 declare @sub varchar(max), @rec varchar(max)        
 set @i = 0        
 set @str = 'ERROR!! Aggregator process:'        
 set @sub = ''        
 set @rec = 'manesh@angelbroking.com;renil.pillai@angelbroking.com;neha.naiwar@angelbroking.com;rohit.patil@angelbroking.com'        
         
 if exists(select * from deleted)--update/delete        
 begin        
  select @str = @str + 'ErrID:'+convert(varchar(10),ErrID) +         
   ', ErrTime:'+ convert(varchar(20),ErrTime)+        
   ', ErrObject:' + isnull(ErrObject,'')+        
   ', ErrLine:'+ convert(varchar(10),ErrLine)+        
   ', ErrMessage:' + ErrMessage +        
   ', Del/UpdTime:' + convert(varchar(20),GETDATE())        
  from deleted        
        
  set @i = 1        
  set @sub = 'Deletion/Updation occured in Error log'        
 end        
 else if exists(select * from inserted) and not exists(select * from deleted) --insert        
 begin        
  select @str = @str + 'ErrID:'+convert(varchar(10),ErrID) +         
   ', ErrTime:'+ convert(varchar(20),ErrTime)+        
   ', ErrObject:' + isnull(ErrObject,'')+        
   ', ErrLine:'+ convert(varchar(10),ErrLine)+        
   ', ErrMessage:' + ErrMessage +        
   ', Insert:' + convert(varchar(20),GETDATE())        
  from inserted        
          
  set @rec = @rec +';bi.dba@angelbroking.com'  
  set @i = 2        
  set @sub = 'URGENT : Error Occured in Aggregator Process'        
 end        
        
 create table #MobNo          
 (          
  mobno numeric(10,0)          
 )          
 insert into #MobNo         
 select 9892953949  --Manesh        
 union all      
 select 9820556259  --Renil      
 union all      
 select 8976552188  --Neha
 union all      
 select 7709733841  --rOHIT
  
        
 insert into intranet.sms.dbo.sms        
 select a.mobno,@str,convert(varchar(10), getdate(), 103),          
  ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +           
  ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),                                            
  'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12           
 then 'PM' else 'AM' end,'RMS UPDATION'          
 from #MobNo a         
         
 EXEC MSDB.DBO.SP_SEND_DBMAIL          
 @RECIPIENTS = @rec,        
 @PROFILE_NAME = 'SOFTWARE',          
 @BODY_FORMAT ='HTML',          
 @SUBJECT = @sub,        
 @BODY = @str        
         
 drop table #MobNo        
   
end

GO

-- --------------------------------------------------
-- TRIGGER dbo.T_Chqreturnlog
-- --------------------------------------------------
CREATE TRIGGER T_Chqreturnlog   
   ON  tbl_ChqRtn_BO_Entries   
   for DELETE,UPDATE  
AS   
BEGIN  
 SET NOCOUNT ON  
 begin try
 declare @srno int ,@actiontype varchar(8),@host varchar(20),@ipAddress varchar(20)      
       
 set @host = (select host_name())            
 set @ipAddress = (SELECT top 1 client_net_address FROM sys.dm_exec_connections         
 WHERE session_id = @@SPID)      

 
 if (select count(*) from inserted)>=1
 begin 
	set @actiontype='updated'
 end
 else
 begin 		
   set @actiontype='deleted'
 end  
	 insert into tbl_ChqRtn_BO_Entries_log  
	 select id,Branch,sub_broker,Segment,vdt,cltcode,Name,vamt,vno,ChequeNo,narration,CMS_cheque,Process_Date,
	 @actiontype,getdate(),@host,@ipAddress 
	 from deleted with (nolock)     
 end try
 begin catch
  DECLARE @ErrorMessage NVARCHAR(4000);
	SELECT @ErrorMessage = ERROR_MESSAGE();
	RAISERROR (@ErrorMessage, 16, 1);

  rollback transaction
  end catch
 
END

GO

-- --------------------------------------------------
-- VIEW dbo.AGG_AtomTechUploadedData
-- --------------------------------------------------
CREATE View AGG_AtomTechUploadedData  
as  
 select SRNO,BANK_ID,BANK_NAME,TRAN_ID,substring(src_prn,3,(LEN(src_prn)-3)) as SRC_PRN,SRC_AMT,TOTCOMM,SERVICE_TAX,        
 AMT_GIVE_TO_SUBMER,TXN_DATE,TXN_TIME,PAYMENT_DATE,SRC_ITC,STATUS_DESC,'TECHPROCESS' as SRVPRO         
 from tbl_TechFile with (nolock)       
 UNION ALL        
 select  SRNO,BANKID,BANKNAME,TRANSID,SMTXNID,ACTUALTOTAMT,TOTCOMM,SERVICETAX,        
 NETAMOUNT,TXNDATE,TXNTIME,PAYMENTDATE,ITC,STATUS_DESC,'PAYNETZ' as SRVPRO from tbl_AtomFile with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.AGG_BO_BankReceipt_test
-- --------------------------------------------------

Create View AGG_BO_BankReceipt_test
as 
select * from AGG_BO_BankReceipt where Vdate='08/10/2014' and Cltcode not in ('A60593','S133733')

GO

-- --------------------------------------------------
-- VIEW dbo.Agg_Reco_FormatedData
-- --------------------------------------------------

Create View Agg_Reco_FormatedData
as
select 
Newid() as RequestID,
'' as AppName,
left(SRC_ITC,charindex('_',SRC_ITC,1)-1) as Party_Code,
substring(SRC_ITC,charindex('_',SRC_ITC,1)+1,(charindex('_',SRC_ITC,charindex('_',SRC_ITC,1)+1))-(charindex('_',SRC_ITC,1)+1) ) as Segment,
null as BankName,
Cli_AccountNo as BankAccountNo,
SRC_Amt as Amount,
convert(Datetime,SUBSTRING(TXN_date,4,3)+SUBSTRING(TXN_date,1,3)+SUBSTRING(TXN_date,7,4)+' '+TXN_Time) as LogDate,
Narration as Vendor,
(Case when Narration ='TECHPROCESS' then 'L1668' when Narration ='PAYNETZ' then '167' else 'New' End) as VendorMerchantID,
SRC_PRN as TransactionMerchantID,
TRAN_ID as TransactionReferenceNo,
null as TransactionStatus,
null as TransactionRemark,
convert(Datetime,SUBSTRING(TXN_date,4,3)+SUBSTRING(TXN_date,1,3)+SUBSTRING(TXN_date,7,4)+' '+TXN_Time) as TransactionDate,
'Y' as TransactionVerified,
'SUCCESS' as  VerificationRemark,
getdate() as VerificationDate,
null as LimitUpdateStatus,
null as LimitUpdateRequestInitiatedAt,
null as LimitUpdateResponseRecvdAt,
null as LimitUpdateResponse,
null as LimitUpdationDoneBy,
null as LimitUpdationAPIStatus,
null as LimitUpdationAPIMessage,
null as TransactionReVerified,
null as ReVerificationRemark,
null as ReVerificationDate,
null as ExtraField1,
TRAN_ID as ExtraField2,
null as ExtraField3,
'Reco Update' as ExtraField4,
null as ExtraField5 
from AGG_Reco_View

GO

-- --------------------------------------------------
-- VIEW dbo.AGG_Reco_View
-- --------------------------------------------------
 
CREATE View AGG_Reco_View  
as  
select tf.BANK_ID,tf.BANK_NAME,tf.TRAN_ID,tf.SRC_PRN,tf.SRC_AMT,tf.TOTCOMM,tf.SERVICE_TAX,        
 tf.AMT_GIVE_TO_SUBMER,tf.TXN_DATE,tf.TXN_TIME,tf.PAYMENT_DATE,tf.SRC_ITC,tf.STATUS_DESC,  
 tf.SRVPRO as NARRATION,  
 TXN_date+' '+Txn_time as GENERATED_ON,  
 AB.CLIACCOUNTNO CLI_ACCOUNTNO   
 from   
 (  
 select SRNO,BANK_ID,BANK_NAME,TRAN_ID,SRC_PRN,SRC_AMT,TOTCOMM,SERVICE_TAX,AMT_GIVE_TO_SUBMER,TXN_DATE,TXN_TIME,PAYMENT_DATE,SRC_ITC,STATUS_DESC,SRVPRO  
 from AGG_AtomTechUploadedData where status_desc like  '%success%' and SRC_ITC not like '%NBFC%'  
 )   tf        
 left join        
 (  
 select   
 [Sr No],Edate,Vdate,Cltcode,Amount,DRCR,Narration,BankCode,BankName,DDno,Branchcode,Chqmode,chqdate,chqname,Clmode,GeneratedOn,Updation_Type,Updation_flag,Updation_status,Updation_Time,ResponseCode,Segment,CliAccountNo  
 from AGG_BO_BankReceipt where Segment <> 'NBFC'  
 )ab   
 on (tf.TRAN_ID=ab.ddno or tf.SRC_PRN=ab.ddno)     
 /*where  ab.ResponseCode is null   */
 where  ab.cltcode is null

GO

-- --------------------------------------------------
-- VIEW dbo.VW_Agg_H2H_Transactions
-- --------------------------------------------------
CREATE view VW_Agg_H2H_Transactions  
as  
  
 select txn_msg,clnt_txn_ref,tpsl_bank_cd,tpsl_txn_id,txn_amt,clnt_rqst_meta, 
 case when clnt_rqst_meta like '{email%' then SUBSTRING(right(clnt_rqst_meta,len(clnt_rqst_meta)-7),0,CHARINDEX('}',right(clnt_rqst_meta,len(clnt_rqst_meta)-7),0))
 else SUBSTRING(clnt_rqst_meta,0,CHARINDEX('_',clnt_rqst_meta,0)) end  as PanNo,
 tpsl_txn_time as ActualDateTime,BankTransactionID,LastUpDateTime  
 from Agg_TechTrnasctionSplitData where  convert(datetime,tpsl_txn_time,103)>=DATEADD(dd, DATEDIFF(dd, 0, GETDATE()) - 10, 0)

GO

