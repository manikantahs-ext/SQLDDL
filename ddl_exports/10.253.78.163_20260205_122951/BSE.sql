-- DDL Export
-- Server: 10.253.78.163
-- Database: BSE
-- Exported: 2026-02-05T12:29:52.730523

USE BSE;
GO

-- --------------------------------------------------
-- INDEX dbo.bse_error_report
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party_code1] ON [dbo].[bse_error_report] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.bse_error_report
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [sauda_date1] ON [dbo].[bse_error_report] ([sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.BSE_SCRIP2
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [scrip_cd] ON [dbo].[BSE_SCRIP2] ([scrip_cd], [BseCode])

GO

-- --------------------------------------------------
-- INDEX dbo.bsecashtrd
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_bsecashtrd] ON [dbo].[bsecashtrd] ([Sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.bsecashtrd_MIS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Sell_Buy] ON [dbo].[bsecashtrd_MIS] ([Sell_Buy], [Party_Code], [Scrip_cd], [TradeQty], [Sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.Sebi_bannedFromintranet
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_party_code_pan] ON [dbo].[Sebi_bannedFromintranet] ([Party_code], [Pan_no])

GO

-- --------------------------------------------------
-- INDEX dbo.selftrade_fin
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_sauda_date] ON [dbo].[selftrade_fin] ([Sauda_date], [branch_id], [Scrip_Cd])

GO

-- --------------------------------------------------
-- INDEX dbo.tbsetable
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_party_code] ON [dbo].[tbsetable] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.tbsetable
-- --------------------------------------------------
CREATE CLUSTERED INDEX [tbsetableindex] ON [dbo].[tbsetable] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.terminal_chng
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_upd_date] ON [dbo].[terminal_chng] ([Upd_Date], [ORDER ID], [NEW CLIENT])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.bse_termid
-- --------------------------------------------------
ALTER TABLE [dbo].[bse_termid] ADD CONSTRAINT [pk_bse_termid] PRIMARY KEY ([termid])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a1
-- --------------------------------------------------
create proc a1 
as
set nocount on  
select distinct party_code,termid from bsecashtrd as a1
select  distinct party_code from a1 trd 
where trd.party_code not in   
(select distinct party_code from intranet.risk.dbo.bse_client2) 
and trd.termid not in (select distinct userid from termparty)   
order by party_code  
  set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a2
-- --------------------------------------------------
create proc a2 
as
set nocount on  
select distinct party_code,termid from bsecashtrd as a1
select  distinct party_code from a1 trd 
where trd.party_code not in   
(select distinct party_code from intranet.risk.dbo.bse_client2) 
and trd.termid not in (select distinct userid from termparty)   
order by party_code  
  set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.branch_bsecls
-- --------------------------------------------------
CREATE procedure branch_bsecls(@dt1 as varchar(20),@dt2 as varchar(20),@reg as varchar(20))              
as              
set nocount on 

select  [order id],upd_date,[NEW CLIENT] 
into #file1
from terminal_chng 
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59' 

select DISTINCT x.branch_cd,Order_id=count(distinct [order id]),
Trade_Id=count([ORDER ID]) from #file1 a ,(select b.reg_code,a.branch_cd,a.party_code 
from intranet.risk.dbo.client_details a
JOIN intranet.risk.dbo.region b ON a.branch_cd=b.code) x 
where a.[NEW CLIENT]=x.party_code collate  SQL_Latin1_General_CP1_CI_AS 
and x.reg_code like @reg 
group by x.branch_cd order by x.branch_cd

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.branch_bsecls2
-- --------------------------------------------------
CREATE procedure branch_bsecls2(@Fdate as varchar(11),@Tdate as varchar(11),@Region as Varchar(20),@Accessto as varchar(50),@AccessCode as varchar(30))                        
as                        
set nocount on           
    
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))    
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))    
          
select  [order id],upd_date,[NEW CLIENT]           
into #file1          
from terminal_chng           
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'           
          
          
if @Accessto='REGION' or @Accessto='BROKER'             
begin         
select DISTINCT x.branch_cd,Order_id=count(distinct [order id]),          
Trade_Id=count([ORDER ID]) from #file1 a ,(select b.reg_code,a.branch_cd,a.party_code           
from intranet.risk.dbo.client_details a          
JOIN intranet.risk.dbo.region b ON a.branch_cd=b.code) x           
where a.[NEW CLIENT]=x.party_code collate  SQL_Latin1_General_CP1_CI_AS           
and x.reg_code like @Region         
group by x.branch_cd order by Trade_Id desc         
END         
if @Accessto='BRANCH'              
begin         
select DISTINCT x.branch_cd,Order_id=count(distinct [order id]),          
Trade_Id=count([ORDER ID]) from #file1 a ,(select b.reg_code,a.branch_cd,a.party_code           
from intranet.risk.dbo.client_details a          
JOIN intranet.risk.dbo.region b ON a.branch_cd=b.code) x           
where a.[NEW CLIENT]=x.party_code collate  SQL_Latin1_General_CP1_CI_AS           
and x.reg_code like @Region         
AND x.branch_cd=@AccessCode          
group by x.branch_cd order by Trade_Id desc      
 END         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BRANCH_BSECLS2_15122010
-- --------------------------------------------------
CREATE PROCEDURE BRANCH_BSECLS2_15122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11),
	@REGION AS VARCHAR(20),
	@ACCESSTO AS VARCHAR(50),
	@ACCESSCODE AS VARCHAR(30)
)
                        
AS                        
SET NOCOUNT ON           
    
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))    
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))    
	          
	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT]           
	INTO #FILE1          
	FROM TERMINAL_CHNG           
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'          
	
	/************************************************************************
		ADDED TO REMOVE X FROM ORDER BY AS GIVING ERROR IN SQL SERVER 2008
	*************************************************************************/
	SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE           
	INTO #TEMP
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A          
	JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE 
	
	/******************************* END ************************************/
	
	IF @ACCESSTO='REGION' OR @ACCESSTO='BROKER'             
	BEGIN         
		SELECT DISTINCT X.BRANCH_CD,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) 
		FROM #FILE1 A ,#TEMP X           
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND X.REG_CODE LIKE @REGION         
		GROUP BY X.BRANCH_CD 
		ORDER BY #TEMP.TRADE_ID DESC         
	END 
	        
	IF @ACCESSTO='BRANCH'              
	BEGIN         
		SELECT DISTINCT X.BRANCH_CD,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A , #TEMP X           
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS				
			AND X.REG_CODE LIKE @REGION         
			AND X.BRANCH_CD=@ACCESSCODE          
		GROUP BY X.BRANCH_CD 
		ORDER BY #TEMP.TRADE_ID DESC      
	
	          
	/**************************************************************************************	          
	IF @ACCESSTO='REGION' OR @ACCESSTO='BROKER'             
	BEGIN         
		SELECT DISTINCT X.BRANCH_CD,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) 
		FROM #FILE1 A ,(
							SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE           
							FROM INTRANET.RISK.DBO.CLIENT_DETAILS A          
							JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE
						) X           
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND X.REG_CODE LIKE @REGION         
		GROUP BY X.BRANCH_CD 
		ORDER BY X.TRADE_ID DESC         
	END 
	        
	IF @ACCESSTO='BRANCH'              
	BEGIN         
		SELECT DISTINCT X.BRANCH_CD,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A ,
			(
				SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE           
				FROM INTRANET.RISK.DBO.CLIENT_DETAILS A          
				JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE
			) X           
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS				
			AND X.REG_CODE LIKE @REGION         
			AND X.BRANCH_CD=@ACCESSCODE          
		GROUP BY X.BRANCH_CD 
		ORDER BY X.TRADE_ID DESC      
	*********************************************************************************/
	
	END         
 
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BRANCH_BSECLS2_31122010
-- --------------------------------------------------
CREATE PROCEDURE BRANCH_BSECLS2_31122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11),
	@REGION AS VARCHAR(20),
	@ACCESSTO AS VARCHAR(50),
	@ACCESSCODE AS VARCHAR(30)
)                        

	AS                        
	SET NOCOUNT ON           
	    
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))    
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))    
	          
	SELECT  [ORDER ID],UPD_DATE,[NEW CLIENT]           
	INTO #FILE1          
	FROM TERMINAL_CHNG           
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'           
	          
	          
	IF @ACCESSTO='REGION' OR @ACCESSTO='BROKER'             
	BEGIN         
	
		SELECT DISTINCT X.BRANCH_CD,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A ,(SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE           
		FROM INTRANET.RISK.DBO.CLIENT_DETAILS A          
			JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X           
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND X.REG_CODE LIKE @REGION         
		GROUP BY X.BRANCH_CD 
		ORDER BY TRADE_ID DESC         
	
	END         
	
	IF @ACCESSTO='BRANCH'              
	BEGIN         
		SELECT DISTINCT X.BRANCH_CD,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A ,(SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE           
		FROM INTRANET.RISK.DBO.CLIENT_DETAILS A          
			JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X           
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND X.REG_CODE LIKE @REGION         
			AND X.BRANCH_CD=@ACCESSCODE          
		GROUP BY X.BRANCH_CD 
		ORDER BY TRADE_ID DESC      
	END         
	
	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.branch_bsecls2_Email
-- --------------------------------------------------
CREATE procedure branch_bsecls2_Email(@Fdate as varchar(11),@Tdate as varchar(11))                          
as                          
set nocount on             
      
DECLARE @rc INT                   
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                   
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                  
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp

Declare @Msg as varchar(2000)       
Set @Msg = 'Dear All,<br><br>  
We have observed the attached incidence of client code changes through the window provided by the exchange in the post closing session as well as the requests for modification of client codes through the back office. At this stage it is imperative to note
 that the facility of client code modification has been provided by the Exchange solely for the purpose of rectification of legitimate errors in punching client codes at the time of order entry. <br><br>   
In view of the above it becomes mandatory for all Branches and Sub-brokers to review the existing process & controls over the use/misuse of the facility and stringently follow the below checks: <br><br>  
<b>1.    Adequate care and prudence has to be exercised while placing the orders.</b> <br><br>  
<b>2.    The facility of modification of client codes should be sparingly used to rectify bonafide mistakes for genuine errors and to the minimum extent possible.</b> <br><br>  
<b>3.    The practice of client code modification through back office software should not consider as an alternative.</b><br><br><br>  
Regards,<br><br>CSO - Settlement Team'   
  
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))      
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))      
            
select [order id],upd_date,[NEW CLIENT] into #file1 from terminal_chng             
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'            
            
select DISTINCT x.branch_cd as reg_code,Order_id=count(distinct [order id]),            
Trade_Id=count([ORDER ID]) into #t from #file1 a ,(select b.reg_code,a.branch_cd,a.party_code             
from intranet.risk.dbo.client_details a            
JOIN intranet.risk.dbo.region b ON a.branch_cd=b.code) x             
where a.[NEW CLIENT]=x.party_code collate  SQL_Latin1_General_CP1_CI_AS                   
group by x.branch_cd order by x.Trade_Id desc        
    
Declare @Trade as int,@RegCode as Varchar(15)      
DECLARE Mail_cursor CURSOR FOR Select reg_code,Trade_Id from #t      
OPEN Mail_cursor      
      
FETCH NEXT FROM Mail_cursor       
INTO @RegCode, @Trade      
      
WHILE @@FETCH_STATUS = 0      
BEGIN      
IF @Trade >= 25      
Begin       
 Declare @CCMail as varchar(30)  
    Set @CCMail = 'KamleshN.Gaikwad@angeltrade.com; Prabodh@angeltrade.com;Selvin.turai@angeltrade.com;'  
 Declare @EmailId as Varchar(50)  
 If Exists(Select Email from intranet.risk.dbo.branches where Branch_code = @RegCode and Email <> '' and Email is not null)   
 Begin   
   Select @EmailId = Email from intranet.risk.dbo.branches where Branch_code = @RegCode  
  
  If @Trade > 100  
  Begin  
   Set @CCMail = @CCMail+'Krishnamoorthy@angeltrade.com;Santanu.Syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com'    
  End  
  
  Declare @Sub as Varchar(70)  
  Set @Sub = @RegCode + ' - Branch Trade Changes ('+ Convert(Varchar,@Trade)+' Changes)'   
  
   EXEC intranet.msdb.dbo.sp_send_dbmail                                                                                                                          
   @recipients  = @EmailId,  
   @profile_name = 'intranet',                                                                                                     
   --@from = 'Soft@angeltrade.com',      
   @copy_recipients  = @CCMail,                                
   @body  = @Msg,                                                                 
   @subject = @Sub,                                                                                                                                                
   @body_format  = 'html'                                                          
   --@server = 'angelmail.angelbroking.com'           
 End    
 End  
FETCH NEXT FROM Mail_cursor INTO @RegCode, @Trade    
End      
CLOSE Mail_cursor      
DEALLOCATE Mail_cursor        
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BRANCH_BSECLS2_EMAIL_15122010
-- --------------------------------------------------
CREATE PROCEDURE BRANCH_BSECLS2_EMAIL_15122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11)
)                            
AS                            

SET NOCOUNT ON               
        
	DECLARE @RC INT                     
	
	IF NOT EXISTS (
					SELECT * 
					FROM INTRANET.MSDB.SYS.SERVICE_QUEUES                     
					WHERE NAME = N'EXTERNALMAILQUEUE' AND IS_RECEIVE_ENABLED = 1
				  )
				  
	EXEC @RC = INTRANET.MSDB.DBO.SYSMAIL_START_SP  

	DECLARE @MSG AS VARCHAR(2000)         
	SET @MSG = 'DEAR ALL,<BR><BR>    
	WE HAVE OBSERVED THE ATTACHED INCIDENCE OF CLIENT CODE CHANGES THROUGH THE WINDOW PROVIDED BY THE EXCHANGE IN THE POST CLOSING SESSION AS WELL AS THE REQUESTS FOR MODIFICATION OF CLIENT CODES THROUGH THE BACK OFFICE. AT THIS STAGE IT IS IMPERATIVE TO NOTE

	THAT THE FACILITY OF CLIENT CODE MODIFICATION HAS BEEN PROVIDED BY THE EXCHANGE SOLELY FOR THE PURPOSE OF RECTIFICATION OF LEGITIMATE ERRORS IN PUNCHING CLIENT CODES AT THE TIME OF ORDER ENTRY. <BR><BR>     
	IN VIEW OF THE ABOVE IT BECOMES MANDATORY FOR ALL BRANCHES AND SUB-BROKERS TO REVIEW THE EXISTING PROCESS & CONTROLS OVER THE USE/MISUSE OF THE FACILITY AND STRINGENTLY FOLLOW THE BELOW CHECKS: <BR><BR>    
	<B>1.    ADEQUATE CARE AND PRUDENCE HAS TO BE EXERCISED WHILE PLACING THE ORDERS.</B> <BR><BR>    
	<B>2.    THE FACILITY OF MODIFICATION OF CLIENT CODES SHOULD BE SPARINGLY USED TO RECTIFY BONAFIDE MISTAKES FOR GENUINE ERRORS AND TO THE MINIMUM EXTENT POSSIBLE.</B> <BR><BR>    
	<B>3.    THE PRACTICE OF CLIENT CODE MODIFICATION THROUGH BACK OFFICE SOFTWARE SHOULD NOT CONSIDER AS AN ALTERNATIVE.</B><BR><BR><BR>    
	REGARDS,<BR><BR>CSO - SETTLEMENT TEAM'     

	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))        
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))        
	  
	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT] 
	INTO #FILE1 FROM TERMINAL_CHNG               
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'  
	
	SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE
	INTO #TEMP               
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A              
		JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE            
	  
	SELECT DISTINCT X.BRANCH_CD AS REG_CODE,
		ORDER_ID=COUNT(DISTINCT [ORDER ID]),              
		TRADE_ID=COUNT([ORDER ID]) 
	INTO #T 
	FROM #FILE1 A ,#TEMP X               
	WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS                     
	GROUP BY X.BRANCH_CD 
	ORDER BY #TEMP.TRADE_ID DESC          

	DECLARE @TRADE AS INT,@REGCODE AS VARCHAR(15)        
	
	DECLARE MAIL_CURSOR CURSOR FOR SELECT REG_CODE,TRADE_ID FROM #T        
	OPEN MAIL_CURSOR        

	FETCH NEXT FROM MAIL_CURSOR         
	INTO @REGCODE, @TRADE        

	WHILE @@FETCH_STATUS = 0        
	BEGIN        
		IF @TRADE >= 25        
		BEGIN         
			DECLARE @CCMAIL AS VARCHAR(30) 
			   
			SET @CCMAIL = 'KAMLESHN.GAIKWAD@ANGELTRADE.COM; PRABODH@ANGELTRADE.COM;SELVIN.TURAI@ANGELTRADE.COM;'    
			DECLARE @EMAILID AS VARCHAR(50)    
		
			IF EXISTS(SELECT EMAIL FROM INTRANET.RISK.DBO.BRANCHES WHERE BRANCH_CODE = @REGCODE AND EMAIL <> '' AND EMAIL IS NOT NULL)     
			BEGIN     
				SELECT @EMAILID = EMAIL FROM INTRANET.RISK.DBO.BRANCHES WHERE BRANCH_CODE = @REGCODE    

				IF @TRADE > 100    
				BEGIN    
					SET @CCMAIL = @CCMAIL+'KRISHNAMOORTHY@ANGELTRADE.COM;SANTANU.SYAM@ANGELTRADE.COM;MANISHA.KAPOOR@ANGELTRADE.COM;MUTHUSWAMY.IYER@ANGELTRADE.COM'      
				END    

				DECLARE @SUB AS VARCHAR(70)    
				SET @SUB = @REGCODE + ' - BRANCH TRADE CHANGES ('+ CONVERT(VARCHAR,@TRADE)+' CHANGES)'     

				EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                                                                                            
				@RECIPIENTS  = @EMAILID,    
				@PROFILE_NAME = 'INTRANET',                                                                                                       
				--@FROM = 'SOFT@ANGELTRADE.COM',        
				@COPY_RECIPIENTS  = @CCMAIL,                                  
				@BODY  = @MSG,        
				@SUBJECT = @SUB,                                                                                                                                                  
				@BODY_FORMAT  = 'HTML'                                                            
				--@SERVER = 'ANGELMAIL.ANGELBROKING.COM'             
			END      
		END    
	
	FETCH NEXT FROM MAIL_CURSOR INTO @REGCODE, @TRADE 
	     
	END  
	      
	CLOSE MAIL_CURSOR        
	DEALLOCATE MAIL_CURSOR          

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BRANCH_BSECLS2_EMAIL_31122010
-- --------------------------------------------------
CREATE PROCEDURE BRANCH_BSECLS2_EMAIL_31122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11)
)                            

	AS                            
	SET NOCOUNT ON               
	        
	DECLARE @RC INT                     
	IF NOT EXISTS (SELECT * FROM INTRANET.MSDB.SYS.SERVICE_QUEUES                     
	WHERE NAME = N'EXTERNALMAILQUEUE' AND IS_RECEIVE_ENABLED = 1)                    
	EXEC @RC = INTRANET.MSDB.DBO.SYSMAIL_START_SP  
	  
	DECLARE @MSG AS VARCHAR(2000)         
	SET @MSG = 'DEAR ALL,<BR><BR>    
	WE HAVE OBSERVED THE ATTACHED INCIDENCE OF CLIENT CODE CHANGES THROUGH THE WINDOW PROVIDED BY THE EXCHANGE IN THE POST CLOSING SESSION AS WELL AS THE REQUESTS FOR MODIFICATION OF CLIENT CODES THROUGH THE BACK OFFICE. AT THIS STAGE IT IS IMPERATIVE TO NOTE
	  
	 THAT THE FACILITY OF CLIENT CODE MODIFICATION HAS BEEN PROVIDED BY THE EXCHANGE SOLELY FOR THE PURPOSE OF RECTIFICATION OF LEGITIMATE ERRORS IN PUNCHING CLIENT CODES AT THE TIME OF ORDER ENTRY. <BR><BR>     
	IN VIEW OF THE ABOVE IT BECOMES MANDATORY FOR ALL BRANCHES AND SUB-BROKERS TO REVIEW THE EXISTING PROCESS & CONTROLS OVER THE USE/MISUSE OF THE FACILITY AND STRINGENTLY FOLLOW THE BELOW CHECKS: <BR><BR>    
	<B>1.    ADEQUATE CARE AND PRUDENCE HAS TO BE EXERCISED WHILE PLACING THE ORDERS.</B> <BR><BR>    
	<B>2.    THE FACILITY OF MODIFICATION OF CLIENT CODES SHOULD BE SPARINGLY USED TO RECTIFY BONAFIDE MISTAKES FOR GENUINE ERRORS AND TO THE MINIMUM EXTENT POSSIBLE.</B> <BR><BR>    
	<B>3.    THE PRACTICE OF CLIENT CODE MODIFICATION THROUGH BACK OFFICE SOFTWARE SHOULD NOT CONSIDER AS AN ALTERNATIVE.</B><BR><BR><BR>    
	REGARDS,<BR><BR>CSO - SETTLEMENT TEAM'     
	    
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))        
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))        
	              
	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT] INTO #FILE1 FROM TERMINAL_CHNG               
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'              
	              
	SELECT DISTINCT X.BRANCH_CD AS REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]),              
		TRADE_ID=COUNT([ORDER ID]) 
	INTO #T 
	FROM #FILE1 A ,
	(
		SELECT B.REG_CODE,A.BRANCH_CD,A.PARTY_CODE               
		FROM INTRANET.RISK.DBO.CLIENT_DETAILS A              
		JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE
	) X               
	WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS                     
	GROUP BY X.BRANCH_CD ORDER BY TRADE_ID DESC          
	      
	DECLARE @TRADE AS INT,@REGCODE AS VARCHAR(15)        
	DECLARE MAIL_CURSOR CURSOR FOR SELECT REG_CODE,TRADE_ID FROM #T        
	OPEN MAIL_CURSOR        
	        
	FETCH NEXT FROM MAIL_CURSOR         
	INTO @REGCODE, @TRADE        
	        
	WHILE @@FETCH_STATUS = 0        
	BEGIN        
	IF @TRADE >= 25        
	BEGIN         
	 DECLARE @CCMAIL AS VARCHAR(30)    
		SET @CCMAIL = 'KAMLESHN.GAIKWAD@ANGELTRADE.COM; PRABODH@ANGELTRADE.COM;SELVIN.TURAI@ANGELTRADE.COM;'    
	 DECLARE @EMAILID AS VARCHAR(50)    
	 IF EXISTS(SELECT EMAIL FROM INTRANET.RISK.DBO.BRANCHES WHERE BRANCH_CODE = @REGCODE AND EMAIL <> '' AND EMAIL IS NOT NULL)     
	 BEGIN     
	   SELECT @EMAILID = EMAIL FROM INTRANET.RISK.DBO.BRANCHES WHERE BRANCH_CODE = @REGCODE    
	    
	  IF @TRADE > 100    
	  BEGIN    
	   SET @CCMAIL = @CCMAIL+'KRISHNAMOORTHY@ANGELTRADE.COM;SANTANU.SYAM@ANGELTRADE.COM;MANISHA.KAPOOR@ANGELTRADE.COM;MUTHUSWAMY.IYER@ANGELTRADE.COM'      
	  END    
	    
	  DECLARE @SUB AS VARCHAR(70)    
	  SET @SUB = @REGCODE + ' - BRANCH TRADE CHANGES ('+ CONVERT(VARCHAR,@TRADE)+' CHANGES)'     
	    
	   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                                                                                            
	   @RECIPIENTS  = @EMAILID,    
	   @PROFILE_NAME = 'INTRANET',                                                                                                       
	   --@FROM = 'SOFT@ANGELTRADE.COM',        
	   @COPY_RECIPIENTS  = @CCMAIL,                                  
	   @BODY  = @MSG,        
	   @SUBJECT = @SUB,                                                                                                                                                  
	   @BODY_FORMAT  = 'HTML'                                                            
	   --@SERVER = 'ANGELMAIL.ANGELBROKING.COM'             
	 END      
	 END    
	FETCH NEXT FROM MAIL_CURSOR INTO @REGCODE, @TRADE      
	END        
	CLOSE MAIL_CURSOR        
	DEALLOCATE MAIL_CURSOR          
	      
	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_cl
-- --------------------------------------------------

CREATE procedure [dbo].[bse_cl]
as
set nocount on

select distinct party_code into #bse from bsecashtrd 

select party_code,long_name,activefrom,inactivefrom  from 
AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()
and party_code in (select party_code from #bse )

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_cl_advance
-- --------------------------------------------------
CREATE procedure bse_cl_advance                
as                
Set nocount on                        
   
Set transaction isolation level read uncommitted                
Select distinct bsecashtrd.party_code,bse_termid.termid ,bse_termid.branch_name,    
bse_termid.branch_cd,bse_termid.sub_broker status into #test from bsecashtrd (nolock) left join bse_termid (nolock)     
on bsecashtrd.termid = bse_termid.termid where bsecashtrd.party_code in (Select party_code from tbsetable)    
order by bsecashtrd.party_code    
  
Set transaction isolation level read uncommitted    
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from     
(select * from #test (nolock))a    
left outer join    
(select * from tbl_vanda_mismatch (nolock))b    
on party_code = partycode   
               
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_cl_advance_bse
-- --------------------------------------------------
CREATE procedure bse_cl_advance_bse                  
as                  
Set nocount on                          
     
Set transaction isolation level read uncommitted                  
Select distinct bsecashtrd.party_code
into #test 
from bsecashtrd (nolock) left join bse_termid (nolock)       
on bsecashtrd.termid = bse_termid.termid where bsecashtrd.party_code in (Select party_code from tbsetable)      
order by bsecashtrd.party_code      
    
Set transaction isolation level read uncommitted      
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from       
(select * from #test (nolock))a      
left outer join      
(select * from tbl_vanda_mismatch (nolock))b      
on party_code = partycode     
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_cl_advance_OFS
-- --------------------------------------------------
CREATE procedure [dbo].[bse_cl_advance_OFS]                  
as                  
Set nocount on                          
     
Set transaction isolation level read uncommitted                  
Select distinct bsecashOFS.party_code,bse_termid.termid ,bse_termid.branch_name,      
bse_termid.branch_cd,bse_termid.sub_broker status into #test from bsecashOFS (nolock) left join bse_termid (nolock)       
on bsecashOFS.party_code = bse_termid.party_code where bsecashOFS.party_code in (Select party_code from tbsetable)      
order by bsecashOFS.party_code      
    
Set transaction isolation level read uncommitted      
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from       
(select * from #test (nolock))a      
left outer join      
(select * from tbl_vanda_mismatch (nolock))b      
on party_code = partycode     
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch]
as
set nocount on

select distinct party_code into #bse from bsecashtrd 

select branch_cd,sub_Broker, party_Code into #cl 
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )


select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt 
from bsecashtrd trd , bse_termid term , #cl cl
 where trd.party_code=cl.party_code  and trd.party_code not in
 (select distinct party_code from pcode_exception) 
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty) 
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or 
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') ) 
order by trd.termid,trd.party_code
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak
-- --------------------------------------------------

CREATE procedure [dbo].[bse_mismatch_deepak]  
as  
set nocount on  


select distinct party_code into #bse from bsecashtrd   
  
select branch_cd,sub_Broker, party_Code 
into #cl   
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1  
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )  


select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt   
from bsecashtrd trd , bse_termid term , #cl cl  
where trd.party_code=cl.party_code  and trd.party_code not in  
(select distinct party_code from pcode_exception)   
and trd.termid not in 
(select userid from AngelBSECM.bsedb_ab.dbo.termparty)   

and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' 
and not 
( 
(cl.branch_cd = term.branch_cd and term.sub_broker='') or   
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or 
-- (cl.branch_cd = term.branch_cd_alt and  term.sub_broker_alt = '') or 
(cl.branch_cd in (Select alt_BranchSBCode  from AlternateBranchSB where alt_BranchSB = 'B' and alt_termid =trd.termid) and  term.sub_broker_alt = '') or 
-- (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') 
(cl.branch_cd  in (Select alt_BranchSBCode  from AlternateBranchSB where alt_BranchSB = 'B' and alt_termid =trd.termid) and cl.sub_broker  in (Select alt_BranchSBCode  from AlternateBranchSB where alt_BranchSB = 'S' and alt_termid =trd.termid) and term.sub_broker_alt<>'') 
)   
order by trd.termid,trd.party_code 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak_mukesh
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch_deepak_mukesh]
as  
set nocount on  
  
select distinct party_code into #bseaa from  dbo.bsecashtrd   
  
select branch_cd,sub_Broker, party_Code into #claa   
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1  
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bseaa  )  OPTION (KEEPFIXED PLAN)
  
  
--select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt   
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt       
into #MisMatchaa    
from  dbo.bsecashtrd trd ,  dbo.bse_termid term , #claa cl  
 where trd.party_code=cl.party_code  and trd.party_code not in  
 (select distinct party_code from  dbo.pcode_exception)   
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)   
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or   
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and  
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )   
order by trd.termid,trd.party_code  OPTION (KEEPFIXED PLAN)
  
  
  
Select * from #MisMatchaa   
where Branch_Cd+Sub_Broker not in   
(Select alt_BranchSB+alt_BranchSBCode from  dbo.AlternateBranchSB where alt_termid = termid)  
and Branch_cd not in   
(Select alt_BranchSB from  dbo.AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid)  OPTION (KEEPFIXED PLAN)
  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak_mukeshbb
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch_deepak_mukeshbb]
as  
set nocount on  
declare @bsebb table(party_code varchar(50))
insert into @bsebb
select  distinct party_code from dbo.bsecashtrd    
--select distinct party_code into #bseaa from  dbo.bsecashtrd   
 

declare @clbb table(branch_cd varchar(50),sub_broker varchar(40),party_code varchar(40))
insert into @clbb 
select branch_cd,sub_Broker, party_Code    
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1  
where c1.cl_code=c2.cl_code and party_code in (select party_code from @bsebb ) 
--select branch_cd,sub_Broker, party_Code into #claa   
--from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1  
--where c1.cl_code=c2.cl_code and party_code in (select party_code from #bseaa  )  
  
  
--select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt   
declare @mismatchbb table(party_code varchar(40),branch_cd varchar (40),sub_broker varchar(40),termid varchar(40),termbranch varchar(40),term_sb varchar(40),TermBranch1 varchar (40),TermSB1 varchar(40))
insert into @mismatchbb
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt       

from  dbo.bsecashtrd trd ,  dbo.bse_termid term , @clbb cl  
 where trd.party_code=cl.party_code  and trd.party_code not in  
 (select distinct party_code from  dbo.pcode_exception)   
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)   
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or   
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and  
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )   
order by trd.termid,trd.party_code  
  

--select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt       
--into #MisMatchaa    
--from  dbo.bsecashtrd trd ,  dbo.bse_termid term , #claa cl  
-- where trd.party_code=cl.party_code  and trd.party_code not in  
-- (select distinct party_code from  dbo.pcode_exception)   
--and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)   
--and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or   
--cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and  
 --term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )   
--order by trd.termid,trd.party_code  
  
  
Select * from @MisMatchbb  
where Branch_Cd+Sub_Broker not in   
(Select alt_BranchSB+alt_BranchSBCode from  dbo.AlternateBranchSB where alt_termid = termid)  
and Branch_cd not in   
(Select alt_BranchSB from  dbo.AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid)  
  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak1
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch_deepak1]
as
set nocount on

select distinct party_code into #bse from bsecashtrd 

select branch_cd,sub_Broker, party_Code into #cl 
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )


--select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,term.branch_cd,term.sub_broker,term.branch_cd_alt,term.sub_broker_alt 
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt     
into #MisMatch  
from bsecashtrd trd , bse_termid term , #cl cl
 where trd.party_code=cl.party_code  and trd.party_code not in
 (select distinct party_code from pcode_exception) 
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty) 
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or 
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') ) 
order by trd.termid,trd.party_code



Select * from #MisMatch 
where Branch_Cd+Sub_Broker not in 
(Select alt_BranchSB+alt_BranchSBCode from AlternateBranchSB where alt_termid = termid)
and Branch_cd not in 
(Select alt_BranchSB from AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid)


set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak1_advance
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch_deepak1_advance]         
as          
set nocount on          
           
select distinct party_code into #bse from bsecashtrd           
create index party_code5 on #bse(party_code)        
select branch_cd,sub_Broker, party_Code into #cl           
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1          
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )        
--create index party_code6 on #cl(party_code)        
       
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt               
into #MisMatch            
from bsecashtrd trd , bse_termid term , #cl cl          
 where trd.party_code=cl.party_code  and trd.party_code not in          
 (select distinct party_code from pcode_exception)           
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)           
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or           
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and          
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )           
order by trd.termid,trd.party_code          
        
create index mismatch1 on #mismatch(Sub_Broker)        
create index mismatch2 on #mismatch(branch_cd)        
   
     
Select * into #test1 from #MisMatch           
where Branch_Cd+Sub_Broker not in           
(Select alt_BranchSB+alt_BranchSBCode from AlternateBranchSB where alt_termid = termid)          
and Branch_cd not in           
(Select alt_BranchSB from AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid)

 
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from   
(select * from #test1 (nolock))a  
left outer join  
(select * from tbl_vanda_mismatch (nolock))b  
on party_code = partycode          
      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak1_advance_New
-- --------------------------------------------------

CREATE procedure [dbo].[bse_mismatch_deepak1_advance_New]
as            
set nocount on            
             
select distinct party_code into #bse from bsecashtrd             
create index party_code5 on #bse(party_code)          

select branch_cd,sub_Broker,d.party_Code into #cl from
(
select  branch_cd,sub_Broker,a.party_Code from 
(select party_code = cl_code  from intranet.risk.dbo.client_brok_details where exchange = 'BSE' and segment = 'CAPITAl' and inactive_from >= getdate())a
inner join
(select branch_cd,sub_broker,party_code from intranet.risk.dbo.client_details)b
on a.party_code = b.party_code
) d
inner join
(select party_code from #bse)c
on d.party_code = c.party_code         

--create index party_code6 on #cl(party_code)          
         
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt                 
into #MisMatch              
from bsecashtrd trd , bse_termid term , #cl cl            
 where trd.party_code=cl.party_code  and trd.party_code not in            
 (select distinct party_code from pcode_exception)             
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)             
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or             
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and            
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )             
order by trd.termid,trd.party_code            
          
create index mismatch1 on #mismatch(Sub_Broker)          
create index mismatch2 on #mismatch(branch_cd)          
     
       
Select * into #test1 from #MisMatch             
where Branch_Cd+Sub_Broker not in             
(Select alt_BranchSB+alt_BranchSBCode from AlternateBranchSB where alt_termid = termid)            
and Branch_cd not in             
(Select alt_BranchSB from AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid)  
  
   
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from     
(select * from #test1 (nolock))a    
left outer join    
(select * from tbl_vanda_mismatch (nolock))b    
on party_code = partycode            
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_deepak1_advance_NEWBSE
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch_deepak1_advance_NEWBSE]          
as            
set nocount on            
             
select distinct party_code into #bse from bsecashtrd             
create index party_code5 on #bse(party_code)          
/*select branch_cd,sub_Broker, party_Code into #cl             
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1            
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )          */
--create index party_code6 on #cl(party_code)          

select  branch_cd,sub_broker,party_code into #cl from AngelNseCM.msajag.dbo.client_details  where 
party_code in (select * from #bse)
         
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt                 
into #MisMatch              
from bsecashtrd trd , bse_termid term , #cl cl            
 where trd.party_code=cl.party_code  and trd.party_code not in            
 (select distinct party_code from pcode_exception)             
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)             
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or             
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and            
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )             
order by trd.termid,trd.party_code            
          
create index mismatch1 on #mismatch(Sub_Broker)          
create index mismatch2 on #mismatch(branch_cd)          
     
       
Select * into #test1 from #MisMatch             
where Branch_Cd+Sub_Broker not in             
(Select alt_BranchSB+alt_BranchSBCode from AlternateBranchSB where alt_termid = termid)            
and Branch_cd not in             
(Select alt_BranchSB from AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid)  
  
   
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from     
(select * from #test1 (nolock))a    
left outer join    
(select * from tbl_vanda_mismatch (nolock))b    
on party_code = partycode            
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.bse_mismatch_OFS_advance
-- --------------------------------------------------
CREATE procedure [dbo].[bse_mismatch_OFS_advance]           
as            
set nocount on            
             
select distinct party_code into #bse from bsecashOFS             
create index party_code11 on #bse(party_code)          
select branch_cd,sub_Broker, party_Code into #cl             
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1            
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )          
--create index party_code6 on #cl(party_code)          
         
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt                 
into #MisMatch              
from bsecashOFS trd , bse_termid term , #cl cl            
 where trd.party_code=cl.party_code  and trd.party_code not in            
 (select distinct party_code from pcode_exception)             
--and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)             
--and trd.termid = term.termid 
and ltrim(rtrim(term.branch_cd)) <> 'ALL' 
and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') 
or (cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and            
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )             
order by trd.party_code            
          
--create index mismatch1 on #mismatch(Sub_Broker)          
--create index mismatch2 on #mismatch(branch_cd)          
     
       
Select * into #test1 from #MisMatch             
where Branch_Cd+Sub_Broker not in             
(Select alt_BranchSB+alt_BranchSBCode from AlternateBranchSB)-- where alt_termid = termid)            
and Branch_cd not in             
(Select alt_BranchSB from AlternateBranchSB where alt_BranchSBCode = '')-- and alt_termid = termid)  
  
   
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from     
(select * from #test1 (nolock))a    
left outer join    
(select * from tbl_vanda_mismatch (nolock))b    
on party_code = partycode            
        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.check_termid
-- --------------------------------------------------
CREATE procedure check_termid
as

set transaction isolation level read uncommitted
set nocount on

select distinct party_code,termid into #file1 from bsecashtrd (nolock)

select distinct party_code from #file1 trd
where trd.party_code not in 
(select distinct party_code from intranet.risk.dbo.bse_client2) 
and trd.termid not in (select distinct userid from termparty) 
order by party_code

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.check_termid1
-- --------------------------------------------------
CREATE procedure check_termid1 
as  
  
set transaction isolation level read uncommitted  
set nocount on  
  
select distinct party_code,termid into #file1 from bsecashtrd (nolock)  
  
select distinct party_code from (select distinct party_code,termid from bsecashtrd (nolock) ) trd  
where trd.party_code not in   
(select distinct party_code from intranet.risk.dbo.bse_client2)   
order by party_code  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Chk_Missing_cli
-- --------------------------------------------------
CREATE procedure Chk_Missing_cli                
as                
                
set nocount on                
/*set transaction isolation level read uncommitted*/      
        
select party_code,cl_code into #client2 from anand.bsedb_ab.dbo.client2 (nolock)       
select cl_code,inactivefrom into #client5 from anand.bsedb_ab.dbo.client5  (nolock)         
              
Select party_code,tdate=convert(datetime ,getdate(),103) into #cli1  from #client2 c2, #client5 c5                 
where c2.cl_code = c5.cl_code and convert(datetime ,c5.inactivefrom ,103) >= convert(datetime ,getdate(),103)                 
                      
/*Select party_code,Termid into #aa from bsecashtrd (nolock) where party_code not in (select party_code from #cli1(nolock)) */
Select party_code,Termid into #aa from bsecashtrd x(nolock) where not exists (select party_code from #cli1 y(nolock) where x.party_code=y.party_code)        

Select distinct a.*,b.branch_name,b.Branch_Cd,status into #temp from #aa a left outer join bse_termid b (nolock) on a.termid=b.termid                
order by a.party_Code               
            
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from             
(select * from #temp (nolock))a            
left outer join            
(select * from tbl_vanda_mismatch (nolock))b            
on party_code = partycode            
               
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Chk_Missing_cli_new
-- --------------------------------------------------
CREATE procedure [dbo].[Chk_Missing_cli_new]                   
as                    
                    
set nocount on      
    
select party_code = cl_code,tdate=convert(datetime ,getdate(),103)        
into #cli1 from AngelNseCM.msajag.dbo.client_brok_details where exchange = 'BSE' and segment = 'CAPITAL' and      
inactive_from >= getdate()     
    
Select party_code,Termid into #aa from bsecashtrd x(nolock) where not exists (select party_code from #cli1 y(nolock) where x.party_code=y.party_code)            
    
Select distinct a.*,b.branch_name,b.Branch_Cd,status into #temp from #aa a left outer join bse_termid b (nolock) on a.termid=b.termid                    
order by a.party_Code      
    
    
select a.*,partycode=isnull(b.partycode,'unknown'),case when a.party_code=b.partycode then '1' else '0' end Flag into #missingdata from                 
(select * from #temp (nolock))a                
left outer join                
(select * from tbl_vanda_mismatch (nolock))b                
on party_code = partycode                

select * from #missingdata

--select Termid,
--'Missing Party_Code : '+ Convert(varchar,party_code)+' Terminal Id : '+Convert(varchar,Termid)+' 
--Alloted to '+ Convert(varchar,branch_Cd), from 
--#missingdata x 
                   
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Chk_Missing_cli_new_opt
-- --------------------------------------------------
CREATE procedure [dbo].[Chk_Missing_cli_new_opt]
(
@sauda_date datetime
)                   
as                    
                    
set nocount on      
    
select party_code = cl_code,tdate=convert(datetime ,getdate(),103)        
into #cli1 from AngelNseCM.msajag.dbo.client_brok_details where exchange = 'BSE' and segment = 'CAPITAL' and      
inactive_from >= getdate()     
    
Select party_code,Termid into #aa from bsecashtrd x(nolock) where not exists (select party_code from #cli1 y(nolock) where x.party_code=y.party_code)            
    
Select distinct a.*,b.branch_name,b.Branch_Cd,status into #temp from #aa a left outer join bse_termid b (nolock) on a.termid=b.termid                    
order by a.party_Code      
    
    
select a.*,partycode=isnull(b.partycode,'unknown'),case when a.party_code=b.partycode then '1' else '0' end Flag into #missingdata from                 
(select * from #temp (nolock))a                
left outer join                
(select * from tbl_vanda_mismatch (nolock))b                
on party_code = partycode                

insert into bse_error_report(termid,remark,sauda_date)
select termid,
remark= 'Missing Party_Code '+Convert(varchar,party_Code)+' Terminal Id : '+Convert(varchar,termid)+' Alloted to '+Convert(varchar,branch_name),
@sauda_date
from #missingdata


--select Termid,
--'Missing Party_Code : '+ Convert(varchar,party_code)+' Terminal Id : '+Convert(varchar,Termid)+' 
--Alloted to '+ Convert(varchar,branch_Cd), from 
--#missingdata x 
                   
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Chk_Missing_cli_OFS
-- --------------------------------------------------
CREATE procedure [dbo].[Chk_Missing_cli_OFS]                    
as                      
                      
set nocount on        
      
select party_code = cl_code,tdate=convert(datetime ,getdate(),103)          
into #cli1 from AngelNseCM.msajag.dbo.client_brok_details where exchange = 'BSE' and segment = 'CAPITAL' and        
inactive_from >= getdate()       
      
Select party_code into #aa from bsecashOFS x(nolock) where not exists (select party_code from #cli1 y(nolock) where x.party_code=y.party_code)              
      
Select distinct a.* into #temp from #aa a left outer join bse_termid b (nolock) on a.party_code=b.party_code                      
order by a.party_Code        
      
      
select a.*,partycode=isnull(b.partycode,'unknown'),case when a.party_code=b.partycode then '1' else '0' end Flag from                   
(select * from #temp (nolock))a                  
left outer join                  
(select * from tbl_vanda_mismatch (nolock))b                  
on party_code = partycode                  
                     
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_TABLE_ACTIVITY
-- --------------------------------------------------
CREATE PROCEDURE DBA_TABLE_ACTIVITY
AS
BEGIN

	WITH LastActivity (ObjectID, LastAction) 
	AS 
	( 
	SELECT object_id AS TableName, Last_User_Seek as LastAction
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_scan as LastAction 
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_lookup as LastAction 
	FROM sys.dm_db_index_usage_stats u  
	WHERE database_id = db_id(db_name()) 
	) 

	SELECT OBJECT_NAME(so.object_id)AS TableName, so.Create_Date "Creation Date",so.Modify_date "Last Modified",
	MAX(la.LastAction)as "Last Accessed" 
	FROM 
	sys.objects so 
	LEFT JOIN LastActivity la 
	ON so.object_id = la.ObjectID 
	WHERE so.type = 'U' 
	AND so.object_id > 100   --returns only the user tables.Tables with objectid < 100 are systables. 
	GROUP BY OBJECT_NAME(so.object_id),so.Create_Date,so.Modify_date
	ORDER BY OBJECT_NAME(so.object_id)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.distinctParty_code
-- --------------------------------------------------
CREATE proc distinctParty_code             
as            
Set nocount on              
      
Select Distinct party_code into #t from bsecashOFS(nolock)      
where party_code not in (Select distinct userid from termparty(nolock))      
          
--Select distinct party_code from #t a       
--where party_code not in  
--(Select distinct party_code from intranet.risk.dbo.client_details with (nolock))               
--order by party_code      
  
select distinct a.party_code from #t a left outer join intranet.risk.dbo.client_details b with (nolock)  
on a.party_code = b.party_code  
where b.party_code is null          
          
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.find_table
-- --------------------------------------------------
CREATE proc find_table @content varchar(20)    
as     
--print @content  
--declare   @content as varchar(20)
--set @content=''
--print 'a'+@content+'a'
select * from information_schema.tables where table_name like '%'+@content+'%'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.indata
-- --------------------------------------------------
CREATE proc [dbo].[indata] 
as
set nocount on
delete from tbsetable
insert into tbsetable
select party_code,long_name,activefrom,inactivefrom,convert(varchar (15) ,getdate(),103)from  
	AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5  
 where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate() order by party_code
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.m4
-- --------------------------------------------------
CREATE proc [dbo].[m4] 
as
select distinct party_code into #bse from bsecashtrd   
create index party_code4 on #bse(party_code)
--DBCC SHOW_STATISTICS (#bse, party_code4)  
select branch_cd,sub_Broker, party_Code into #cl   
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1  
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.m5
-- --------------------------------------------------
CREATE proc [dbo].[m5]
as
select distinct party_code into #bse from bsecashtrd   
select branch_cd,sub_Broker, party_Code into #cl   
from AngelBSECM.bsedb_ab.dbo.client2 c2 , AngelBSECM.bsedb_ab.dbo.client1 c1  
where c1.cl_code=c2.cl_code and party_code in (select party_code from #bse )
select distinct trd.party_code,cl.branch_cd,cl.sub_broker, trd.termid,TermBranch=term.branch_cd,TermSB=term.sub_broker,TermBranch1=term.branch_cd_alt,TermSB1=term.sub_broker_alt       
into #MisMatch    
from bsecashtrd trd , bse_termid term , #cl cl  
 where trd.party_code=cl.party_code  and trd.party_code not in  
 (select distinct party_code from pcode_exception)   
and trd.termid not in (select userid from AngelBSECM.bsedb_ab.dbo.termparty)   
and trd.termid = term.termid and ltrim(rtrim(term.branch_cd)) <> 'ALL' and not ( (cl.branch_cd = term.branch_cd and term.sub_broker='') or   
(cl.branch_cd = term.branch_cd and cl.sub_broker = term.sub_broker and term.sub_broker<>'') or (cl.branch_cd = term.branch_cd_alt and  
 term.sub_broker_alt = '') or (cl.branch_cd = term.branch_cd_alt and cl.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') )   
order by trd.termid,trd.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mukesh1
-- --------------------------------------------------


CREATE proc [dbo].[mukesh1]             
as            
Set nocount on              
      
Select Distinct party_code into #t from bsecashtrd(nolock)      
where termid not in (Select distinct userid from termparty(nolock))      
          
--Select distinct party_code from #t a       
--where party_code not in  
--(Select distinct party_code from intranet.risk.dbo.client_details with (nolock))               
--order by party_code      
  
--select distinct a.party_code,b.* from #t a left outer join intranet.risk.dbo.client_details b with (nolock)  
--on a.party_code = b.party_code  
--where b.party_code is null          


select distinct a.party_code from #t a left outer join AngelNseCM.MSAJAG.dbo.client_brok_details b with (nolock)  
on a.party_code = b.cl_code  
where b.cl_code is null

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
-- PROCEDURE dbo.region_bsecls
-- --------------------------------------------------
CREATE procedure region_bsecls(@dt1 as varchar(20),@dt2 as varchar(20))              
as              
set nocount on     

select  [order id],upd_date,[NEW CLIENT] 
into #file1
from terminal_chng 
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59' 

select x.reg_code,Order_id=count(distinct [order id]), Trade_Id=count([ORDER ID]) from #file1 a,
(select b.reg_code,b.code,a.party_code 
from intranet.risk.dbo.client_details a join intranet.risk.dbo.region b on a.branch_cd=b.code) x 
where a.[NEW CLIENT]=x.party_code collate SQL_Latin1_General_CP1_CI_AS 
group by x.reg_code order by x.reg_code 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.region_bsecls2
-- --------------------------------------------------
CREATE procedure region_bsecls2(@Fdate as varchar(11),@Tdate as varchar(11),@Accessto as varchar(50),@AccessCode as varchar(30))                      
as                      
SET NOCOUNT ON   
  
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))  
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))  
  
Select  [order id],upd_date,[NEW CLIENT] into #file1        
from terminal_chng         
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'         
          
if @Accessto='BROKER'            
begin          
 select x.reg_code,Order_id=count(distinct [order id]), Trade_Id = Count([ORDER ID]) from #file1 a,        
 (select b.reg_code,b.code,a.party_code         
 from intranet.risk.dbo.client_details a join intranet.risk.dbo.region b on a.branch_cd=b.code) x         
 where a.[NEW CLIENT]=x.party_code collate SQL_Latin1_General_CP1_CI_AS         
 group by x.reg_code 
 --order by x.Trade_Id desc         
 order by Trade_Id desc         
 end      
 if @Accessto='REGION'            
begin       
       
 Select DISTINCT REG_CODE into #br1 from intranet.risk.dbo.REGION WHERE REG_CODE=@AccessCode      
       
 select x.reg_code,Order_id=count(distinct [order id]), Trade_Id=count([ORDER ID]) from #file1 a,        
 (select b.reg_code,b.code,a.party_code        
 from intranet.risk.dbo.client_details a join intranet.risk.dbo.region b on a.branch_cd=b.code) x         
 where a.[NEW CLIENT]=x.party_code collate SQL_Latin1_General_CP1_CI_AS and x.reg_code in (select REG_CODE from #br1)               
 group by x.reg_code 
 --order by x.Trade_Id desc  
 order by Trade_Id desc                  
  
End      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.REGION_BSECLS2_15122010
-- --------------------------------------------------
CREATE PROCEDURE REGION_BSECLS2_15122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11),
	@ACCESSTO AS VARCHAR(50),
	@ACCESSCODE AS VARCHAR(30)

)                      
AS                      

	SET NOCOUNT ON   

	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))  
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))  

	SELECT  [ORDER ID],UPD_DATE,[NEW CLIENT] INTO #FILE1        
	FROM TERMINAL_CHNG         
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'         
	
	SELECT B.REG_CODE,B.CODE,A.PARTY_CODE         
	INTO #TEMP
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE
	
	IF @ACCESSTO='BROKER'            
	BEGIN          
		SELECT X.REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]), TRADE_ID = COUNT([ORDER ID]) 
		FROM #FILE1 A, #TEMP X         
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS         
		GROUP BY X.REG_CODE 
		ORDER BY #TEMP.TRADE_ID DESC         
	END      
	
	IF @ACCESSTO='REGION'            
	BEGIN       
	
		SELECT DISTINCT REG_CODE INTO #BR1 FROM INTRANET.RISK.DBO.REGION WHERE REG_CODE=@ACCESSCODE      
		SELECT X.REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]), TRADE_ID=COUNT([ORDER ID]) 
		FROM #FILE1 A, #TEMP X         
		WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS 
			AND X.REG_CODE IN (SELECT REG_CODE FROM #BR1)               
		GROUP BY X.REG_CODE 
		ORDER BY #TEMP.TRADE_ID DESC 
	END      
         
	
	/*******************************************************************************************************************      
	IF @ACCESSTO='BROKER'            
	BEGIN          
	SELECT X.REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]), TRADE_ID = COUNT([ORDER ID]) FROM #FILE1 A,        
	(SELECT B.REG_CODE,B.CODE,A.PARTY_CODE         
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X         
	WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS         
	GROUP BY X.REG_CODE ORDER BY X.TRADE_ID DESC         
	END      
	IF @ACCESSTO='REGION'            
	BEGIN       
	   
	SELECT DISTINCT REG_CODE INTO #BR1 FROM INTRANET.RISK.DBO.REGION WHERE REG_CODE=@ACCESSCODE      
	   
	SELECT X.REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]), TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A,        
	(SELECT B.REG_CODE,B.CODE,A.PARTY_CODE        
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X         
	WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS AND X.REG_CODE IN (SELECT REG_CODE FROM #BR1)               
	GROUP BY X.REG_CODE ORDER BY X.TRADE_ID DESC          
	
	***********************************************************************************************************************/
	
	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.REGION_BSECLS2_31122010
-- --------------------------------------------------
CREATE PROCEDURE REGION_BSECLS2_31122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11),
	@ACCESSTO AS VARCHAR(50),
	@ACCESSCODE AS VARCHAR(30)
)

AS                      

	SET NOCOUNT ON   
	  
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))  
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))  
	  
	SELECT  [ORDER ID],UPD_DATE,[NEW CLIENT] INTO #FILE1        
	FROM TERMINAL_CHNG         
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'         
	          
	IF @ACCESSTO='BROKER'            
	BEGIN          
	 SELECT X.REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]), TRADE_ID = COUNT([ORDER ID]) FROM #FILE1 A,        
	 (SELECT B.REG_CODE,B.CODE,A.PARTY_CODE         
	 FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X         
	 WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS         
	 GROUP BY X.REG_CODE 
	 ORDER BY TRADE_ID DESC         
	 END      
	 IF @ACCESSTO='REGION'            
	BEGIN       
	       
	 SELECT DISTINCT REG_CODE INTO #BR1 FROM INTRANET.RISK.DBO.REGION WHERE REG_CODE=@ACCESSCODE      
	       
	 SELECT X.REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]), TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A,        
	 (SELECT B.REG_CODE,B.CODE,A.PARTY_CODE        
	 FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X         
	 WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS AND X.REG_CODE IN (SELECT REG_CODE FROM #BR1)               
	 GROUP BY X.REG_CODE 
	 ORDER BY TRADE_ID DESC          
	  
	END      
	
	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.region_bsecls2_Email
-- --------------------------------------------------
CREATE procedure region_bsecls2_Email(@Fdate as varchar(11),@Tdate as varchar(11))                            
as                            
SET NOCOUNT ON    
  
DECLARE @rc INT                   
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                   
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                  
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp

Declare @Msg as varchar(2000)       
Set @Msg = 'Dear All,<br><br>  
We have observed the attached incidence of client code changes through the window provided by the exchange in the post closing session as well as the requests for modification of client codes through the back office. At this stage it is imperative to note
 that the facility of client code modification has been provided by the Exchange solely for the purpose of rectification of legitimate errors in punching client codes at the time of order entry. <br><br>   
In view of the above it becomes mandatory for all Branches and Sub-brokers to review the existing process & controls over the use/misuse of the facility and stringently follow the below checks: <br><br>  
<b>1.    Adequate care and prudence has to be exercised while placing the orders.</b> <br><br>  
<b>2.    The facility of modification of client codes should be sparingly used to rectify bonafide mistakes for genuine errors and to the minimum extent possible.</b> <br><br>  
<b>3.    The practice of client code modification through back office software should not consider as an alternative.</b><br><br><br>  
Regards,<br><br>CSO - Settlement Team'        
  
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))        
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))        
        
Select [order id],upd_date,[NEW CLIENT] into #file1 from terminal_chng               
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'               
                
Select x.reg_code,Order_id = Count(distinct [order id]), Trade_Id = Count([ORDER ID]) into #t from #file1 a,              
(select b.reg_code,b.code,a.party_code               
from intranet.risk.dbo.client_details a join intranet.risk.dbo.region b on a.branch_cd=b.code) x               
where a.[NEW CLIENT]=x.party_code collate SQL_Latin1_General_CP1_CI_AS               
Group by x.reg_code order by x.Trade_Id desc               
     
Declare @Trade as int,@RegCode as Varchar(15)      
DECLARE Mail_cursor CURSOR FOR Select reg_code,Trade_Id from #t      
OPEN Mail_cursor      
      
FETCH NEXT FROM Mail_cursor       
INTO @RegCode, @Trade      
      
WHILE @@FETCH_STATUS = 0      
BEGIN      
 IF @Trade >= 25      
 Begin     
 Declare @CCMail as varchar(30)  
    Set @CCMail = 'KamleshN.Gaikwad@angeltrade.com; Prabodh@angeltrade.com;Selvin.turai@angeltrade.com;'   
  Declare @EmailId as Varchar(50)  
  If Exists(Select Email_id from tbl_Region where Reg_Code = @RegCode and Email_id <> '' and Email_id is not null)   
  Begin   
  Select @EmailId = Email_id from tbl_Region where Reg_Code = @RegCode  
       
  If @Trade > 100  
  Begin  
   Set @CCMail = @CCMail+'Krishnamoorthy@angeltrade.com;Santanu.Syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com'    
  End  
  
  Declare @Sub as Varchar(70)  
  Set @Sub = @RegCode + ' - Region Trade Changes ('+ Convert(Varchar,@Trade)+' Changes)'   
  
   EXEC intranet.msdb.dbo.sp_send_dbmail                                                                                                                           
   @recipients  = @EmailId,
   @profile_name = 'intranet',                                                                                                       
   --@from = 'Soft@angeltrade.com',      
   @copy_recipients  = @CCMail,                                
   @body  = @Msg,                                                                 
   @subject = @Sub,                                                                                                                                                
   @body_format  = 'html'                                                          
   --@server = 'angelmail.angelbroking.com'           
  End  
 End      
 FETCH NEXT FROM Mail_cursor INTO @RegCode, @Trade       
End      
CLOSE Mail_cursor      
DEALLOCATE Mail_cursor      
      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.REGION_BSECLS2_EMAIL_15122010
-- --------------------------------------------------
CREATE PROCEDURE REGION_BSECLS2_EMAIL_15122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11)
)

AS                              

SET NOCOUNT ON      
    
	DECLARE @RC INT                     

	IF NOT EXISTS (SELECT * FROM INTRANET.MSDB.SYS.SERVICE_QUEUES WHERE NAME = N'EXTERNALMAILQUEUE' AND IS_RECEIVE_ENABLED = 1)
	
	EXEC @RC = INTRANET.MSDB.DBO.SYSMAIL_START_SP  

	DECLARE @MSG AS VARCHAR(2000)         
	
	SET @MSG = 'DEAR ALL,<BR><BR>    
	WE HAVE OBSERVED THE ATTACHED INCIDENCE OF CLIENT CODE CHANGES THROUGH THE WINDOW PROVIDED BY THE EXCHANGE IN THE POST CLOSING SESSION AS WELL AS THE REQUESTS FOR MODIFICATION OF CLIENT CODES THROUGH THE BACK OFFICE. AT THIS STAGE IT IS IMPERATIVE TO NOTE

	THAT THE FACILITY OF CLIENT CODE MODIFICATION HAS BEEN PROVIDED BY THE EXCHANGE SOLELY FOR THE PURPOSE OF RECTIFICATION OF LEGITIMATE ERRORS IN PUNCHING CLIENT CODES AT THE TIME OF ORDER ENTRY. <BR><BR>     
	IN VIEW OF THE ABOVE IT BECOMES MANDATORY FOR ALL BRANCHES AND SUB-BROKERS TO REVIEW THE EXISTING PROCESS & CONTROLS OVER THE USE/MISUSE OF THE FACILITY AND STRINGENTLY FOLLOW THE BELOW CHECKS: <BR><BR>    
	<B>1.    ADEQUATE CARE AND PRUDENCE HAS TO BE EXERCISED WHILE PLACING THE ORDERS.</B> <BR><BR>    
	<B>2.    THE FACILITY OF MODIFICATION OF CLIENT CODES SHOULD BE SPARINGLY USED TO RECTIFY BONAFIDE MISTAKES FOR GENUINE ERRORS AND TO THE MINIMUM EXTENT POSSIBLE.</B> <BR><BR>    
	<B>3.    THE PRACTICE OF CLIENT CODE MODIFICATION THROUGH BACK OFFICE SOFTWARE SHOULD NOT CONSIDER AS AN ALTERNATIVE.</B><BR><BR><BR>    
	REGARDS,<BR><BR>CSO - SETTLEMENT TEAM'          

	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))          
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))          

	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT] 
	INTO #FILE1 
	FROM TERMINAL_CHNG                 
	WHERE UPD_DATE >= @FDATE+' 00:00:00' AND UPD_DATE <= @TDATE+' 23:59:59'                 

	SELECT B.REG_CODE,B.CODE,A.PARTY_CODE                 
	INTO #TEMP
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE

	SELECT X.REG_CODE,ORDER_ID = COUNT(DISTINCT [ORDER ID]), TRADE_ID = COUNT([ORDER ID])
	INTO #T 
	FROM #FILE1 A, #TEMP X                 
	WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS                 
	GROUP BY X.REG_CODE 
	ORDER BY #TEMP.TRADE_ID DESC                 

	DECLARE @TRADE AS INT,@REGCODE AS VARCHAR(15)        
	DECLARE MAIL_CURSOR CURSOR FOR SELECT REG_CODE,TRADE_ID FROM #T        
	OPEN MAIL_CURSOR        

	FETCH NEXT FROM MAIL_CURSOR         
	INTO @REGCODE, @TRADE        

	WHILE @@FETCH_STATUS = 0        
	BEGIN        
		IF @TRADE >= 25        
		BEGIN       
			DECLARE @CCMAIL AS VARCHAR(30)    
			
			SET @CCMAIL = 'KAMLESHN.GAIKWAD@ANGELTRADE.COM; PRABODH@ANGELTRADE.COM;SELVIN.TURAI@ANGELTRADE.COM;'     
			DECLARE @EMAILID AS VARCHAR(50)    
			
			IF EXISTS(SELECT EMAIL_ID FROM TBL_REGION WHERE REG_CODE = @REGCODE AND EMAIL_ID <> '' AND EMAIL_ID IS NOT NULL)     
			BEGIN     
			
				SELECT @EMAILID = EMAIL_ID FROM TBL_REGION WHERE REG_CODE = @REGCODE    

				IF @TRADE > 100    
				BEGIN    
					SET @CCMAIL = @CCMAIL+'KRISHNAMOORTHY@ANGELTRADE.COM;SANTANU.SYAM@ANGELTRADE.COM;MANISHA.KAPOOR@ANGELTRADE.COM;MUTHUSWAMY.IYER@ANGELTRADE.COM'      
				END    

				DECLARE @SUB AS VARCHAR(70)    
				SET @SUB = @REGCODE + ' - REGION TRADE CHANGES ('+ CONVERT(VARCHAR,@TRADE)+' CHANGES)'     

				EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                                                                                             
				@RECIPIENTS  = @EMAILID,  
				@PROFILE_NAME = 'INTRANET',                                                                                                         
				--@FROM = 'SOFT@ANGELTRADE.COM',        
				@COPY_RECIPIENTS  = @CCMAIL,                                  
				@BODY  = @MSG,                                                                   
				@SUBJECT = @SUB,                                                                                                                                     
				@BODY_FORMAT  = 'HTML'                                                            
				--@SERVER = 'ANGELMAIL.ANGELBROKING.COM'             
				
			END    
		END     
		   
		FETCH NEXT FROM MAIL_CURSOR INTO @REGCODE, @TRADE         
		
	END 
	       
	CLOSE MAIL_CURSOR        
	DEALLOCATE MAIL_CURSOR        
        
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.REGION_BSECLS2_EMAIL_31122010
-- --------------------------------------------------
CREATE PROCEDURE REGION_BSECLS2_EMAIL_31122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11)
)

AS                              

SET NOCOUNT ON      
    
	DECLARE @RC INT                     
	IF NOT EXISTS (SELECT * FROM INTRANET.MSDB.SYS.SERVICE_QUEUES                     
	WHERE NAME = N'EXTERNALMAILQUEUE' AND IS_RECEIVE_ENABLED = 1)                    
	EXEC @RC = INTRANET.MSDB.DBO.SYSMAIL_START_SP  
	  
	DECLARE @MSG AS VARCHAR(2000)         
	SET @MSG = 'DEAR ALL,<BR><BR>    
	WE HAVE OBSERVED THE ATTACHED INCIDENCE OF CLIENT CODE CHANGES THROUGH THE WINDOW PROVIDED BY THE EXCHANGE IN THE POST CLOSING SESSION AS WELL AS THE REQUESTS FOR MODIFICATION OF CLIENT CODES THROUGH THE BACK OFFICE. AT THIS STAGE IT IS IMPERATIVE TO NOTE
	  
	 THAT THE FACILITY OF CLIENT CODE MODIFICATION HAS BEEN PROVIDED BY THE EXCHANGE SOLELY FOR THE PURPOSE OF RECTIFICATION OF LEGITIMATE ERRORS IN PUNCHING CLIENT CODES AT THE TIME OF ORDER ENTRY. <BR><BR>     
	IN VIEW OF THE ABOVE IT BECOMES MANDATORY FOR ALL BRANCHES AND SUB-BROKERS TO REVIEW THE EXISTING PROCESS & CONTROLS OVER THE USE/MISUSE OF THE FACILITY AND STRINGENTLY FOLLOW THE BELOW CHECKS: <BR><BR>    
	<B>1.    ADEQUATE CARE AND PRUDENCE HAS TO BE EXERCISED WHILE PLACING THE ORDERS.</B> <BR><BR>    
	<B>2.    THE FACILITY OF MODIFICATION OF CLIENT CODES SHOULD BE SPARINGLY USED TO RECTIFY BONAFIDE MISTAKES FOR GENUINE ERRORS AND TO THE MINIMUM EXTENT POSSIBLE.</B> <BR><BR>    
	<B>3.    THE PRACTICE OF CLIENT CODE MODIFICATION THROUGH BACK OFFICE SOFTWARE SHOULD NOT CONSIDER AS AN ALTERNATIVE.</B><BR><BR><BR>    
	REGARDS,<BR><BR>CSO - SETTLEMENT TEAM'          
	    
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))          
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))          
	          
	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT] INTO #FILE1 FROM TERMINAL_CHNG                 
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'                 
	                  
	SELECT X.REG_CODE,ORDER_ID = COUNT(DISTINCT [ORDER ID]), TRADE_ID = COUNT([ORDER ID]) INTO #T FROM #FILE1 A,                
	(SELECT B.REG_CODE,B.CODE,A.PARTY_CODE                 
	FROM INTRANET.RISK.DBO.CLIENT_DETAILS A JOIN INTRANET.RISK.DBO.REGION B ON A.BRANCH_CD=B.CODE) X                 
	WHERE A.[NEW CLIENT]=X.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS                 
	GROUP BY X.REG_CODE ORDER BY TRADE_ID DESC                 
	       
	DECLARE @TRADE AS INT,@REGCODE AS VARCHAR(15)        
	DECLARE MAIL_CURSOR CURSOR FOR SELECT REG_CODE,TRADE_ID FROM #T        
	OPEN MAIL_CURSOR        
	        
	FETCH NEXT FROM MAIL_CURSOR         
	INTO @REGCODE, @TRADE        
	        
	WHILE @@FETCH_STATUS = 0        
	BEGIN        
	 IF @TRADE >= 25        
	 BEGIN       
	 DECLARE @CCMAIL AS VARCHAR(30)    
		SET @CCMAIL = 'KAMLESHN.GAIKWAD@ANGELTRADE.COM; PRABODH@ANGELTRADE.COM;SELVIN.TURAI@ANGELTRADE.COM;'     
	  DECLARE @EMAILID AS VARCHAR(50)    
	  IF EXISTS(SELECT EMAIL_ID FROM TBL_REGION WHERE REG_CODE = @REGCODE AND EMAIL_ID <> '' AND EMAIL_ID IS NOT NULL)     
	  BEGIN     
	  SELECT @EMAILID = EMAIL_ID FROM TBL_REGION WHERE REG_CODE = @REGCODE    
	         
	  IF @TRADE > 100    
	  BEGIN    
	   SET @CCMAIL = @CCMAIL+'KRISHNAMOORTHY@ANGELTRADE.COM;SANTANU.SYAM@ANGELTRADE.COM;MANISHA.KAPOOR@ANGELTRADE.COM;MUTHUSWAMY.IYER@ANGELTRADE.COM'      
	  END    
	    
	  DECLARE @SUB AS VARCHAR(70)    
	  SET @SUB = @REGCODE + ' - REGION TRADE CHANGES ('+ CONVERT(VARCHAR,@TRADE)+' CHANGES)'     
	    
	   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                                                                                             
	   @RECIPIENTS  = @EMAILID,  
	   @PROFILE_NAME = 'INTRANET',                                                                                                         
	   --@FROM = 'SOFT@ANGELTRADE.COM',        
	   @COPY_RECIPIENTS  = @CCMAIL,                                  
	   @BODY  = @MSG,                                                                   
	   @SUBJECT = @SUB,                                                                                                                                     
	   @BODY_FORMAT  = 'HTML'                                                            
	   --@SERVER = 'ANGELMAIL.ANGELBROKING.COM'             
	  END    
	 END        
	 FETCH NEXT FROM MAIL_CURSOR INTO @REGCODE, @TRADE         
	END        
	CLOSE MAIL_CURSOR        
	DEALLOCATE MAIL_CURSOR        
	        
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.region_bsecls2_Email_New
-- --------------------------------------------------

CREATE procedure [dbo].[region_bsecls2_Email_New](@Fdate as varchar(11),@Tdate as varchar(11))                                      
as             
        
DECLARE @rc INT                       
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                       
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                      
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp    
      
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))                  
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))           
          
select  space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],                                      
space(100) as 'OldClname' ,space(20) as 'NewBranch',space(20) as 'NewSB',                                      
NewClcd=[new client],space(100) as 'NewClname',                                          
Terminal_no=[TWS NO],orderid = [order id],upd_date,Quantity,([RATE (Rs#)])Rate into #temp                     
from terminal_chng where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'           
          
          
Update #temp Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name                                       
from intranet.risk.dbo.client_details where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                                               
                        
                        
Update #temp Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name from                       
intranet.risk.dbo.client_details where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS           
          
select a.*,reg_code,c.* into #temp1 from #temp a join intranet.risk.dbo.region b on a.newbranch = b.code left outer join tbl_tradechanges_mailid c on a.newbranch = c.branch collate SQL_Latin1_General_CP1_CI_AS           
          
declare @branchcode varchar(50),@toemail varchar(4000),@ccemail varchar(4000),@mess as varchar(8000)             
          
DECLARE mail_conso_branch CURSOR FOR            
select distinct newbranch from #temp1          
OPEN mail_conso_branch                     
FETCH NEXT FROM mail_conso_branch                                         
INTO @branchcode                                                                       
WHILE @@FETCH_STATUS = 0                                                        
BEGIN           
          
select distinct @toemail =replace(branch_mail ,'/',','),@ccemail =replace(region_mail ,'/',',') from #temp1 where newbranch = @branchcode           
               
Set @mess = '<font face ="Century Gothic">Dear All,<br><br>            
We have observed the attached incidence of client code changes through the window provided by the exchange in           
the post closing session as well as the requests for modification of client codes through the back office.           
At this stage it is imperative to note that the facility of client code modification has been provided by           
the Exchange solely for the purpose of rectification of legitimate errors in punching client codes at the           
time of order entry.<br><br>             
In view of the above it becomes mandatory for all Branches and Sub-brokers to review the existing process & controls          
over the use/misuse of the facility and stringently follow the below checks:<br><br>            
<b>1. Adequate care and prudence has to be exercised while placing the orders.</b><br>          
<b>2. The facility of modification of client codes should be sparingly used to rectify bonafide mistakes for           
genuine errors and to the minimum extent possible.</b><br>            
<b>3. The practice of client code modification through back office software should not consider as an alternative.</b><br><br><br>            
Thanks & Regards<br>          
Prabodh  Salvi  - Operations<br>          
Contact No – 28358800 Ext – 214<br>          
CSO, Mumbai.</font>'          
          
          
truncate table  tbl_branchmail_tradechanges          
insert into tbl_branchmail_tradechanges values('DATE','OLD BRANCH','OLD SUBBROKER','OLD CLIENT CODE','OLD CLIENT NAME','NEW BRANCH','NEW SUBBROKER','NEW CLIENT CODE','NEW CLIENT NAME','TERMINAL NO','ORDER ID','QUANTITY','RATE')                      
insert into tbl_branchmail_tradechanges (fld_DATE,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,orderid,Quantity,Rate)select upd_date,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,convert
  
    
      
        
(numeric,orderid),Quantity,Rate from #temp1  where newbranch = @branchcode order by NewBranch          
          
/*insert into tbl_branchmail_tradechanges values(upd_date,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,convert(float,orderid),Quantity,Rate)          
select upd_date as [Date],OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,orderid,Quantity,Rate from #temp1  where newbranch = 'ACM' @branchcode order by NewBranch*/          
          
declare @s as varchar(4000),@s1 as varchar(4000),@attach as varchar(1000)           
          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  " select * from MIS.BSE.DBO.tbl_branchmail_tradechanges" queryout '+'\\196.1.115.136\d$\upload1\tradechanges_branch\'+@branchcode+'.xls -c -Sintranet -Usa -Pnirwan612'                                  
set @s1= @s+''''                                                                                                                   
exec(@s1)            
          
set @attach='\\196.1.115.136\d$\upload1\tradechanges_branch\'+@branchcode+'.xls'      
          
declare @date as varchar(50)          
SET  @date = 'Trade Changes Report As On Dated '+ convert(varchar(11),getdate())           
          
exec intranet.msdb.dbo.sp_send_dbmail            
/*@TO = 'KamleshN.Gaikwad@angeltrade.com;Deepak.Redekar@angeltrade.com',             
@CC = 'jagdish.kolhapure@angeltrade.com,Prabodh@angeltrade.com',*/      
@recipients  = @toemail,      
@copy_recipients  = @ccemail,      
@blind_copy_recipients  = 'KamleshN.Gaikwad@angeltrade.com;Prabodh@angeltrade.com;renil.pillai@angeltrade.com',    
@profile_name = 'intranet',               
--@from ='KamleshN.Gaikwad@angeltrade.com',                                                              
@body_format ='html',                                                                                        
@subject =  @date ,                 
@file_attachments =@attach,                                                                                                     
@body =@mess           
          
FETCH NEXT FROM mail_conso_branch                                          
INTO @branchcode                                                                              
END                             
CLOSE mail_conso_branch                                                                              
DEALLOCATE mail_conso_branch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Scrip_updatation
-- --------------------------------------------------
CREATE proc [dbo].[Scrip_updatation]    
as    
    
truncate table BSE_SCRIP2    
insert into BSE_SCRIP2 select * from AngelBSECM.bsedb_ab.dbo.scrip2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.selftrade_new
-- --------------------------------------------------
CREATE procedure selftrade_new (@sett_Date as varchar(11))
as

set nocount on

--drop table temp_selftrade
--declare @sett_date as varchar(11)
--set @sett_date = 'Dec 17 2004'

Select branch_name=isnull(br.branch,'Unknown'),Sauda_date=convert(varchar(11),Sauda_Date,109)+' '+sauda_time,
Series=' ',S.Trade_no,Order_no,[user_id]=S.termid,branchcode=isnull(branch_cd,''), branch_id=s.party_Code,
acname=isnull(c1.short_name,'Party Not found'),S.Scrip_Cd,scpname=s2.scrip_cd,
sb=(case when sell_buy='S' then 'Sell' else 'Buy' end), tradeqty,marketrate,net_trdqty=isnull(no_of_shrs,0),
our=isnull(((100*tradeqty)/no_of_shrs),0) into #
from 

(
select * from esignbse.bse.dbo.bsecashtrd where sauda_Date =@sett_Date and isnumeric(trade_no)=1 ) S 
left join ( select * from intranet.misc.dbo.qe where pddate=@sett_Date ) qe 
on qe.sc_code=s.scrip_cd, 
(select trade_no,Scrip_cd from esignbse.bse.dbo.bsecashtrd
where sauda_date =@sett_Date 
group by trade_no,Scrip_Cd Having count(Trade_no) > 1) D , anand.bsedb_ab.dbo.Scrip2 S2 , 
--( ( select User_id = UserId from anand.bsedb_ab.dbo.termparty) union (
--select User_id = Termid from esignbse.bse.dbo.bse_termid) ) T, 
anand.bsedb_ab.dbo.Client2 C2, 
anand.bsedb_ab.dbo.Client1 C1, anand.bsedb_ab.dbo.branch br where 
sauda_Date=@sett_Date  and S.Scrip_cd = D.Scrip_cd and S.Trade_no = D.Trade_no 
and s.sauda_Date=@sett_Date  and S.Scrip_cd = S2.Bsecode 
and s.Party_code = C2.Party_code and C2.Cl_code = C1.Cl_code and br.branch_code=branch_cd 
--and T.User_Id = S.termid 
order by s2.scrip_cd,S.trade_no,S.Tradeqty,S.Sell_buy 

delete from # where Scrip_Cd in (select scrip from intranet.misc.dbo.scriplockmast where lock = 'Y')

update # set marketrate = marketrate/100

delete from selftrade_fin where sauda_Date like @sett_date+'%'
insert into selftrade_fin select * from #

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sub_bsecls
-- --------------------------------------------------
CREATE procedure sub_bsecls(@dt1 as varchar(20),@dt2 as varchar(20),@branch as varchar(20))                
as                
set nocount on   
  
select  [order id],upd_date,[NEW CLIENT]   
into #file1  
from terminal_chng   
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59'   
  
select b.branch_cd,b.sub_broker,Order_id=count(distinct [order id]),  
Trade_Id=count([ORDER ID]) from #file1 a,intranet.risk.dbo.client_details b  
where a.[NEW CLIENT]=b.party_code collate  SQL_Latin1_General_CP1_CI_AS   
and b.branch_cd like @branch   
group by b.branch_cd,b.sub_broker order by b.branch_cd ,b.sub_broker 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sub_bsecls2
-- --------------------------------------------------
CREATE procedure sub_bsecls2(@Fdate as varchar(11),@Tdate as varchar(11),@Branch as Varchar(20),@Accessto as varchar(50),@AccessCode as varchar(30))                      
as                        
set nocount on           
  
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))  
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))  
          
select  [order id],upd_date,[NEW CLIENT]           
into #file1          
from terminal_chng           
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'         
      
if @Accessto='SB'      
begin          
select b.branch_cd,b.sub_broker,Order_id=count(distinct [order id]),          
Trade_Id=count([ORDER ID]) from #file1 a,intranet.risk.dbo.client_details b          
where a.[NEW CLIENT]=b.party_code collate  SQL_Latin1_General_CP1_CI_AS           
and b.branch_cd like @Branch and b.sub_broker=@AccessCode          
group by b.branch_cd,b.sub_broker order by Trade_Id desc    
end      
if @Accessto='BROKER' or @Accessto='BRANCH' or @Accessto='REGION'       
BEGIN      
select b.branch_cd,b.sub_broker,Order_id=count(distinct [order id]),          
Trade_Id=count([ORDER ID]) from #file1 a,intranet.risk.dbo.client_details b          
where a.[NEW CLIENT]=b.party_code collate  SQL_Latin1_General_CP1_CI_AS           
and b.branch_cd like @Branch       
group by b.branch_cd,b.sub_broker order by Trade_Id desc    
end      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SUB_BSECLS2_15122010
-- --------------------------------------------------
CREATE PROCEDURE SUB_BSECLS2_15122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11),
	@BRANCH AS VARCHAR(20),
	@ACCESSTO AS VARCHAR(50),
	@ACCESSCODE AS VARCHAR(30)
)                      

AS                        
SET NOCOUNT ON           
  
SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))  
SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))  
          
SELECT  [ORDER ID],UPD_DATE,[NEW CLIENT]           
INTO #FILE1          
FROM TERMINAL_CHNG           
WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'  

IF @ACCESSTO='SB'      
BEGIN          
	
	SELECT B.BRANCH_CD,B.SUB_BROKER,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
		TRADE_ID=COUNT([ORDER ID]) 
	INTO #FINAL1
	FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B          
	WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS           
		AND B.BRANCH_CD LIKE @BRANCH AND B.SUB_BROKER=@ACCESSCODE          
	GROUP BY B.BRANCH_CD,B.SUB_BROKER 
	
	SELECT * FROM #FINAL1 ORDER BY TRADE_ID DESC    
	
END
      
IF @ACCESSTO='BROKER' OR @ACCESSTO='BRANCH' OR @ACCESSTO='REGION'       
	BEGIN      
	
		SELECT B.BRANCH_CD,B.SUB_BROKER,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) 
		INTO #FINAL2
		FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B          
		WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND B.BRANCH_CD LIKE @BRANCH       
		GROUP BY B.BRANCH_CD,B.SUB_BROKER 
		
		SELECT * FROM #FINAL2 ORDER BY TRADE_ID DESC    
	
	END             
      
/**********************************************************************************
IF @ACCESSTO='SB'      

BEGIN          
SELECT B.BRANCH_CD,B.SUB_BROKER,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B          
WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
AND B.BRANCH_CD LIKE @BRANCH AND B.SUB_BROKER=@ACCESSCODE          
GROUP BY B.BRANCH_CD,B.SUB_BROKER ORDER BY X.TRADE_ID DESC    
END      

IF @ACCESSTO='BROKER' OR @ACCESSTO='BRANCH' OR @ACCESSTO='REGION'       
BEGIN      
SELECT B.BRANCH_CD,B.SUB_BROKER,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
TRADE_ID=COUNT([ORDER ID]) FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B          
WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
AND B.BRANCH_CD LIKE @BRANCH       
GROUP BY B.BRANCH_CD,B.SUB_BROKER ORDER BY X.TRADE_ID DESC    
END      

***********************************************************************************/

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SUB_BSECLS2_31122010
-- --------------------------------------------------
CREATE PROCEDURE SUB_BSECLS2_31122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11),
	@BRANCH AS VARCHAR(20),
	@ACCESSTO AS VARCHAR(50),
	@ACCESSCODE AS VARCHAR(30)
)                      

AS                        

	SET NOCOUNT ON           
	  
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))  
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))  
	          
	SELECT  [ORDER ID],UPD_DATE,[NEW CLIENT]           
	INTO #FILE1          
	FROM TERMINAL_CHNG           
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'         
	      
	IF @ACCESSTO='SB'      
	BEGIN          
		SELECT B.BRANCH_CD,B.SUB_BROKER,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) 
		FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B          
		WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND B.BRANCH_CD LIKE @BRANCH AND B.SUB_BROKER=@ACCESSCODE          
		GROUP BY B.BRANCH_CD,B.SUB_BROKER 
		ORDER BY TRADE_ID DESC    
	END      
	
	IF @ACCESSTO='BROKER' OR @ACCESSTO='BRANCH' OR @ACCESSTO='REGION'       
	BEGIN      
		SELECT B.BRANCH_CD,B.SUB_BROKER,ORDER_ID=COUNT(DISTINCT [ORDER ID]),          
			TRADE_ID=COUNT([ORDER ID]) 
		FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B          
		WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS           
			AND B.BRANCH_CD LIKE @BRANCH       
		GROUP BY B.BRANCH_CD,B.SUB_BROKER 
		ORDER BY TRADE_ID DESC    
	END      
	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sub_bsecls2_Email
-- --------------------------------------------------
CREATE procedure sub_bsecls2_Email(@Fdate as varchar(11),@Tdate as varchar(11))                          
as                            
set nocount on               
      
DECLARE @rc INT                   
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                   
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                  
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp

Declare @Msg as varchar(2000)       
Set @Msg = 'Dear All,<br><br>  
We have observed the attached incidence of client code changes through the window provided by the exchange in the post closing session as well as the requests for modification of client codes through the back office. At this stage it is imperative to note
 that the facility of client code modification has been provided by the Exchange solely for the purpose of rectification of legitimate errors in punching client codes at the time of order entry. <br><br>   
In view of the above it becomes mandatory for all Branches and Sub-brokers to review the existing process & controls over the use/misuse of the facility and stringently follow the below checks: <br><br>  
<b>1.    Adequate care and prudence has to be exercised while placing the orders.</b> <br><br>  
<b>2.    The facility of modification of client codes should be sparingly used to rectify bonafide mistakes for genuine errors and to the minimum extent possible.</b> <br><br>  
<b>3.    The practice of client code modification through back office software should not consider as an alternative.</b><br><br><br>  
Regards,<br><br>CSO - Settlement Team'   
  
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))      
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))      
              
select [order id],upd_date,[NEW CLIENT] into #file1 from terminal_chng               
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'             
          
select b.branch_cd ,b.sub_broker as Reg_code,Order_id=count(distinct [order id]),              
Trade_Id=count([ORDER ID]) into #t from #file1 a,intranet.risk.dbo.client_details b              
where a.[NEW CLIENT]=b.party_code collate  SQL_Latin1_General_CP1_CI_AS               
group by b.branch_cd,b.sub_broker order by x.Trade_Id desc        
    
Declare @Trade as int,@RegCode as Varchar(15)      
DECLARE Mail_cursor CURSOR FOR Select reg_code,Trade_Id from #t      
OPEN Mail_cursor      
      
FETCH NEXT FROM Mail_cursor       
INTO @RegCode, @Trade      
      
WHILE @@FETCH_STATUS = 0      
BEGIN      
IF @Trade >= 25      
Begin  
 Declare @CCMail as varchar(30)  
    Set @CCMail = 'KamleshN.Gaikwad@angeltrade.com; Prabodh@angeltrade.com;Selvin.turai@angeltrade.com;'       
 Declare @EmailId as Varchar(50)  
 If Exists(Select Distinct Email from Intranet.risk.dbo.Subbrokers where Sub_Broker = @RegCode and Email <> '' and Email is not null)   
 Begin   
   Select Distinct @EmailId = Email from Intranet.risk.dbo.Subbrokers where Sub_Broker = @RegCode     
  
  If @Trade > 100  
  Begin  
   Set @CCMail = @CCMail+'Krishnamoorthy@angeltrade.com;Santanu.Syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com'    
  End  
  
  Declare @Sub as Varchar(70)  
  Set @Sub = @RegCode + ' - Subbroker Trade Changes ('+ @Trade+' Changes)'   
  
   EXEC intranet.msdb.dbo.sp_send_dbmail                                                                                                                           
   @recipients  = @EmailId,                                                                                                       
   @profile_name = 'intranet',
   --@from = 'Soft@angeltrade.com',      
   @copy_recipients  = @CCMail,                                
   @body  = @Msg,                                                                 
   @subject = @Sub,                                                                                                                                                
   @body_format  = 'html'                                                         
   --@server = 'angelmail.angelbroking.com'           
 End    
  End    
FETCH NEXT FROM Mail_cursor INTO @RegCode, @Trade        
End      
CLOSE Mail_cursor      
DEALLOCATE Mail_cursor    
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SUB_BSECLS2_EMAIL_15122010
-- --------------------------------------------------

CREATE PROCEDURE SUB_BSECLS2_EMAIL_15122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11)
)

AS                              

SET NOCOUNT ON                 

	DECLARE @RC INT 
	        
	IF NOT EXISTS (SELECT * FROM INTRANET.MSDB.SYS.SERVICE_QUEUES WHERE NAME = N'EXTERNALMAILQUEUE' AND IS_RECEIVE_ENABLED = 1)                    
	EXEC @RC = INTRANET.MSDB.DBO.SYSMAIL_START_SP  

	DECLARE @MSG AS VARCHAR(2000)         
	SET @MSG = 'DEAR ALL,<BR><BR>    
	WE HAVE OBSERVED THE ATTACHED INCIDENCE OF CLIENT CODE CHANGES THROUGH THE WINDOW PROVIDED BY THE EXCHANGE IN THE POST CLOSING SESSION AS WELL AS THE REQUESTS FOR MODIFICATION OF CLIENT CODES THROUGH THE BACK OFFICE. AT THIS STAGE IT IS IMPERATIVE TO NOTE

	THAT THE FACILITY OF CLIENT CODE MODIFICATION HAS BEEN PROVIDED BY THE EXCHANGE SOLELY FOR THE PURPOSE OF RECTIFICATION OF LEGITIMATE ERRORS IN PUNCHING CLIENT CODES AT THE TIME OF ORDER ENTRY. <BR><BR>     
	IN VIEW OF THE ABOVE IT BECOMES MANDATORY FOR ALL BRANCHES AND SUB-BROKERS TO REVIEW THE EXISTING PROCESS & CONTROLS OVER THE USE/MISUSE OF THE FACILITY AND STRINGENTLY FOLLOW THE BELOW CHECKS: <BR><BR>    
	<B>1.    ADEQUATE CARE AND PRUDENCE HAS TO BE EXERCISED WHILE PLACING THE ORDERS.</B> <BR><BR>    
	<B>2.    THE FACILITY OF MODIFICATION OF CLIENT CODES SHOULD BE SPARINGLY USED TO RECTIFY BONAFIDE MISTAKES FOR GENUINE ERRORS AND TO THE MINIMUM EXTENT POSSIBLE.</B> <BR><BR>    
	<B>3.    THE PRACTICE OF CLIENT CODE MODIFICATION THROUGH BACK OFFICE SOFTWARE SHOULD NOT CONSIDER AS AN ALTERNATIVE.</B><BR><BR><BR>    
	REGARDS,<BR><BR>CSO - SETTLEMENT TEAM'     

	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))        
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))        
	    
	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT] 
	INTO #FILE1 
	FROM TERMINAL_CHNG                 
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'               

	SELECT B.BRANCH_CD ,B.SUB_BROKER AS REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]),                
		TRADE_ID=COUNT([ORDER ID]) 
	INTO #T 
	FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B                
	WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS                 
	GROUP BY B.BRANCH_CD,B.SUB_BROKER 

	SELECT * INTO #TEMP
	FROM #T
	ORDER BY TRADE_ID DESC

	DROP TABLE #T
	DROP TABLE #FILE1

	DECLARE @TRADE AS INT,@REGCODE AS VARCHAR(15)        
	DECLARE MAIL_CURSOR CURSOR FOR SELECT REG_CODE,TRADE_ID FROM #TEMP        
	OPEN MAIL_CURSOR        

	FETCH NEXT FROM MAIL_CURSOR         
	INTO @REGCODE, @TRADE        

	WHILE @@FETCH_STATUS = 0        
	BEGIN        
	IF @TRADE >= 25        
	BEGIN    
	DECLARE @CCMAIL AS VARCHAR(30)    
	SET @CCMAIL = 'KAMLESHN.GAIKWAD@ANGELTRADE.COM; PRABODH@ANGELTRADE.COM;SELVIN.TURAI@ANGELTRADE.COM;'         
	DECLARE @EMAILID AS VARCHAR(50)    
	IF EXISTS(SELECT DISTINCT EMAIL FROM INTRANET.RISK.DBO.SUBBROKERS WHERE SUB_BROKER = @REGCODE AND EMAIL <> '' AND EMAIL IS NOT NULL)     
	BEGIN     
	SELECT DISTINCT @EMAILID = EMAIL FROM INTRANET.RISK.DBO.SUBBROKERS WHERE SUB_BROKER = @REGCODE       

	IF @TRADE > 100    
	BEGIN    
	SET @CCMAIL = @CCMAIL+'KRISHNAMOORTHY@ANGELTRADE.COM;SANTANU.SYAM@ANGELTRADE.COM;MANISHA.KAPOOR@ANGELTRADE.COM;MUTHUSWAMY.IYER@ANGELTRADE.COM'      
	END    

	DECLARE @SUB AS VARCHAR(70)    
	SET @SUB = @REGCODE + ' - SUBBROKER TRADE CHANGES ('+ @TRADE+' CHANGES)'     

	EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                                                                                             
	@RECIPIENTS  = @EMAILID,                                                                                                         
	@PROFILE_NAME = 'INTRANET',  
	--@FROM = 'SOFT@ANGELTRADE.COM',        
	@COPY_RECIPIENTS  = @CCMAIL,                                  
	@BODY  = @MSG,                                                                   
	@SUBJECT = @SUB,                                                                      
	@BODY_FORMAT  = 'HTML'                                                           
	--@SERVER = 'ANGELMAIL.ANGELBROKING.COM'             
	END      
	END      
	FETCH NEXT FROM MAIL_CURSOR INTO @REGCODE, @TRADE          
	END        
	CLOSE MAIL_CURSOR        
	DEALLOCATE MAIL_CURSOR      
      
SET NOCOUNT OFF 



/******************************************************************************************
CREATE procedure sub_bsecls2_Email(@Fdate as varchar(11),@Tdate as varchar(11))                            
as                              
set nocount on                 
        
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp  
  
Declare @Msg as varchar(2000)         
Set @Msg = 'Dear All,<br><br>    
We have observed the attached incidence of client code changes through the window provided by the exchange in the post closing session as well as the requests for modification of client codes through the back office. At this stage it is imperative to note
  
 that the facility of client code modification has been provided by the Exchange solely for the purpose of rectification of legitimate errors in punching client codes at the time of order entry. <br><br>     
In view of the above it becomes mandatory for all Branches and Sub-brokers to review the existing process & controls over the use/misuse of the facility and stringently follow the below checks: <br><br>    
<b>1.    Adequate care and prudence has to be exercised while placing the orders.</b> <br><br>    
<b>2.    The facility of modification of client codes should be sparingly used to rectify bonafide mistakes for genuine errors and to the minimum extent possible.</b> <br><br>    
<b>3.    The practice of client code modification through back office software should not consider as an alternative.</b><br><br><br>    
Regards,<br><br>CSO - Settlement Team'     
    
Set @Fdate = Convert(Varchar(11),Convert(Datetime,@Fdate,103))        
Set @Tdate = Convert(Varchar(11),Convert(Datetime,@Tdate,103))        
                
select [order id],upd_date,[NEW CLIENT] into #file1 from terminal_chng                 
where upd_date>=@Fdate+' 00:00:00' and upd_date<=@Tdate+' 23:59:59'               
            
select b.branch_cd ,b.sub_broker as Reg_code,Order_id=count(distinct [order id]),                
Trade_Id=count([ORDER ID]) into #t from #file1 a,intranet.risk.dbo.client_details b                
where a.[NEW CLIENT]=b.party_code collate  SQL_Latin1_General_CP1_CI_AS                 
group by b.branch_cd,b.sub_broker order by x.Trade_Id desc          
      
Declare @Trade as int,@RegCode as Varchar(15)        
DECLARE Mail_cursor CURSOR FOR Select reg_code,Trade_Id from #t        
OPEN Mail_cursor        
        
FETCH NEXT FROM Mail_cursor         
INTO @RegCode, @Trade        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
IF @Trade >= 25        
Begin    
 Declare @CCMail as varchar(30)    
    Set @CCMail = 'KamleshN.Gaikwad@angeltrade.com; Prabodh@angeltrade.com;Selvin.turai@angeltrade.com;'         
 Declare @EmailId as Varchar(50)    
 If Exists(Select Distinct Email from Intranet.risk.dbo.Subbrokers where Sub_Broker = @RegCode and Email <> '' and Email is not null)     
 Begin     
   Select Distinct @EmailId = Email from Intranet.risk.dbo.Subbrokers where Sub_Broker = @RegCode       
    
  If @Trade > 100    
  Begin    
   Set @CCMail = @CCMail+'Krishnamoorthy@angeltrade.com;Santanu.Syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com'      
  End    
    
  Declare @Sub as Varchar(70)    
  Set @Sub = @RegCode + ' - Subbroker Trade Changes ('+ @Trade+' Changes)'     
    
   EXEC intranet.msdb.dbo.sp_send_dbmail                                                                                                                             
   @recipients  = @EmailId,                                                                                                         
   @profile_name = 'intranet',  
   --@from = 'Soft@angeltrade.com',        
   @copy_recipients  = @CCMail,                                  
   @body  = @Msg,                                                                   
   @subject = @Sub,                                                                      
   @body_format  = 'html'                                                           
   --@server = 'angelmail.angelbroking.com'             
 End      
  End      
FETCH NEXT FROM Mail_cursor INTO @RegCode, @Trade          
End        
CLOSE Mail_cursor        
DEALLOCATE Mail_cursor      
      
Set nocount off 

*****************************************************************************************************************/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SUB_BSECLS2_EMAIL_31122010
-- --------------------------------------------------
CREATE PROCEDURE SUB_BSECLS2_EMAIL_31122010
(
	@FDATE AS VARCHAR(11),
	@TDATE AS VARCHAR(11)
)                            

	AS                              
	SET NOCOUNT ON                 
	        
	DECLARE @RC INT                     
	IF NOT EXISTS (SELECT * FROM INTRANET.MSDB.SYS.SERVICE_QUEUES                     
	WHERE NAME = N'EXTERNALMAILQUEUE' AND IS_RECEIVE_ENABLED = 1)                    
	EXEC @RC = INTRANET.MSDB.DBO.SYSMAIL_START_SP  
	  
	DECLARE @MSG AS VARCHAR(2000)         
	SET @MSG = 'DEAR ALL,<BR><BR>    
	WE HAVE OBSERVED THE ATTACHED INCIDENCE OF CLIENT CODE CHANGES THROUGH THE WINDOW PROVIDED BY THE EXCHANGE IN THE POST CLOSING SESSION AS WELL AS THE REQUESTS FOR MODIFICATION OF CLIENT CODES THROUGH THE BACK OFFICE. AT THIS STAGE IT IS IMPERATIVE TO NOTE
	  
	 THAT THE FACILITY OF CLIENT CODE MODIFICATION HAS BEEN PROVIDED BY THE EXCHANGE SOLELY FOR THE PURPOSE OF RECTIFICATION OF LEGITIMATE ERRORS IN PUNCHING CLIENT CODES AT THE TIME OF ORDER ENTRY. <BR><BR>     
	IN VIEW OF THE ABOVE IT BECOMES MANDATORY FOR ALL BRANCHES AND SUB-BROKERS TO REVIEW THE EXISTING PROCESS & CONTROLS OVER THE USE/MISUSE OF THE FACILITY AND STRINGENTLY FOLLOW THE BELOW CHECKS: <BR><BR>    
	<B>1.    ADEQUATE CARE AND PRUDENCE HAS TO BE EXERCISED WHILE PLACING THE ORDERS.</B> <BR><BR>    
	<B>2.    THE FACILITY OF MODIFICATION OF CLIENT CODES SHOULD BE SPARINGLY USED TO RECTIFY BONAFIDE MISTAKES FOR GENUINE ERRORS AND TO THE MINIMUM EXTENT POSSIBLE.</B> <BR><BR>    
	<B>3.    THE PRACTICE OF CLIENT CODE MODIFICATION THROUGH BACK OFFICE SOFTWARE SHOULD NOT CONSIDER AS AN ALTERNATIVE.</B><BR><BR><BR>    
	REGARDS,<BR><BR>CSO - SETTLEMENT TEAM'     
	    
	SET @FDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@FDATE,103))        
	SET @TDATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TDATE,103))        
	                
	SELECT [ORDER ID],UPD_DATE,[NEW CLIENT] 
	INTO #FILE1 
	FROM TERMINAL_CHNG                 
	WHERE UPD_DATE>=@FDATE+' 00:00:00' AND UPD_DATE<=@TDATE+' 23:59:59'               
	            
	SELECT B.BRANCH_CD ,B.SUB_BROKER AS REG_CODE,ORDER_ID=COUNT(DISTINCT [ORDER ID]),                
		TRADE_ID=COUNT([ORDER ID]) 
	INTO #T 
	FROM #FILE1 A,INTRANET.RISK.DBO.CLIENT_DETAILS B                
	WHERE A.[NEW CLIENT]=B.PARTY_CODE COLLATE  SQL_LATIN1_GENERAL_CP1_CI_AS                 
	GROUP BY B.BRANCH_CD,B.SUB_BROKER 
	ORDER BY TRADE_ID DESC          
	      
	DECLARE @TRADE AS INT,@REGCODE AS VARCHAR(15)        
	DECLARE MAIL_CURSOR CURSOR FOR SELECT REG_CODE,TRADE_ID FROM #T        
	OPEN MAIL_CURSOR        
	        
	FETCH NEXT FROM MAIL_CURSOR         
	INTO @REGCODE, @TRADE        
	        
	WHILE @@FETCH_STATUS = 0        
	BEGIN        
	IF @TRADE >= 25        
	BEGIN    
	 DECLARE @CCMAIL AS VARCHAR(30)    
		SET @CCMAIL = 'KAMLESHN.GAIKWAD@ANGELTRADE.COM; PRABODH@ANGELTRADE.COM;SELVIN.TURAI@ANGELTRADE.COM;'         
	 DECLARE @EMAILID AS VARCHAR(50)    
	 IF EXISTS(SELECT DISTINCT EMAIL FROM INTRANET.RISK.DBO.SUBBROKERS WHERE SUB_BROKER = @REGCODE AND EMAIL <> '' AND EMAIL IS NOT NULL)     
	 BEGIN     
	   SELECT DISTINCT @EMAILID = EMAIL FROM INTRANET.RISK.DBO.SUBBROKERS WHERE SUB_BROKER = @REGCODE       
	    
	  IF @TRADE > 100    
	  BEGIN    
	   SET @CCMAIL = @CCMAIL+'KRISHNAMOORTHY@ANGELTRADE.COM;SANTANU.SYAM@ANGELTRADE.COM;MANISHA.KAPOOR@ANGELTRADE.COM;MUTHUSWAMY.IYER@ANGELTRADE.COM'      
	  END    
	    
	  DECLARE @SUB AS VARCHAR(70)    
	  SET @SUB = @REGCODE + ' - SUBBROKER TRADE CHANGES ('+ @TRADE+' CHANGES)'     
	    
	   EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                                                                                             
	   @RECIPIENTS  = @EMAILID,                                                                                                         
	   @PROFILE_NAME = 'INTRANET',  
	   --@FROM = 'SOFT@ANGELTRADE.COM',        
	   @COPY_RECIPIENTS  = @CCMAIL,                                  
	   @BODY  = @MSG,                                                                   
	   @SUBJECT = @SUB,                                                                      
	   @BODY_FORMAT  = 'HTML'                                                           
	   --@SERVER = 'ANGELMAIL.ANGELBROKING.COM'             
	 END      
	  END      
	FETCH NEXT FROM MAIL_CURSOR INTO @REGCODE, @TRADE          
	END        
	CLOSE MAIL_CURSOR        
	DEALLOCATE MAIL_CURSOR      
	      
	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sub_datebse
-- --------------------------------------------------
CREATE procedure sub_datebse(@dt1 as varchar(20),@dt2 as varchar(20),@sb as varchar(20))                  
as                  
set nocount on     
    
select  [order id],upd_date,[NEW CLIENT]     
into #file1    
from terminal_chng     
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59'     
    
select a.upd_date,Order_id=count(distinct [order id]),    
Trade_Id=count([ORDER ID]) from #file1 a,intranet.risk.dbo.client_details b    
where a.[NEW CLIENT]=b.party_code collate  SQL_Latin1_General_CP1_CI_AS     
and b.sub_broker like @sb     
group by a.upd_date order by a.upd_date desc  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.term_brsb_detail
-- --------------------------------------------------
CREATE procedure term_brsb_detail(@dt1 as varchar(20),@dt2 as varchar(20),@sb as varchar(20))                      
as                      
set nocount on          
/*declare @dt1 as varchar(20)
declare @dt2 as varchar(20)
declare @sb as varchar(20)

set @dt1 = 'Jul  1 2009'
set @dt2 = 'Jul  3 2009'
set @sb = 'HO'*/           
                      
select distinct space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],              
space(100) as 'OldClname' ,space(20) as 'NewBranch',space(20) as 'NewSB',              
NewClcd=[new client],space(100) as 'NewClname',                  
Terminal_no=[TWS NO],orderid=[order id],upd_date,sum(Quantity)Quantity,sum([RATE (Rs#)])Rate
into #AA1
from terminal_chng
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59'
group by  [old client],[new client],[TWS NO],[order id],upd_date


Update #AA1 Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name               
from intranet.risk.dbo.client_details where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                       


Update #AA1 Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name from               
intranet.risk.dbo.client_details where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                       
                      
Select distinct upd_date,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,orderid 
,Quantity,Rate
from #AA1                      
where Newsb like @SB                
--SELECT * FROM #AA where Newsb='BM'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.term_brsb_detail_conso
-- --------------------------------------------------


CREATE procedure term_brsb_detail_conso(@dt1 as varchar(11),@dt2 as varchar(20),@sb as varchar(20))                            
as                            
set nocount on      
    
select distinct space(20) as 'OldBranch',space(100) as 'Old_RegionName',space(20) as 'OldSB',OldClcd=[old client],                                              
space(100) as 'OldClname',space(500) as 'Old_Address',space(50) as 'Old_ActiveDate',    
space(50) as 'Old_Inactivedate',space(100) as 'NewRegion',      
space(20) as 'NewBranch',space(20) as 'NewSB',                                              
NewClcd=[new client],space(100) as 'NewClname',space(500) as 'NewAddress', space(50) as 'New_ActiveDate',    
space(50) as 'New_Inactivedate' ,                                               
Terminal_no=[TWS NO],orderid=[order id],Scriptcode = [scrip code],[BUY/SELL],upd_date,    
sum(Quantity)Quantity,sum([RATE (Rs#)])Rate,space(50) Amount                
into #AA1     
from terminal_chng (nolock)      
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59'      
group by  [old client],[new client],[TWS NO],[order id],upd_date,[scrip code],[BUY/SELL]    
    
Update #AA1 Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name,      
old_regionname = region,      
old_Address =  l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,      
old_activedate = First_active_date ,old_Inactivedate = last_inactive_date                                                 
from intranet.risk.dbo.client_details with (nolock) where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                                                       
                                
Update #AA1 Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name,      
NewRegion = region,      
NewAddress =  l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,      
New_ActiveDate = First_active_date ,New_Inactivedate = last_inactive_date       
from                               
intranet.risk.dbo.client_details with (nolock)where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS    
    
select distinct convert(varchar(11),upd_date,103) as [DATE],Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,Old_Address,      
convert(varchar(11),Old_ActiveDate,103) as Old_ActiveDate,convert(varchar(11),Old_Inactivedate,103) as Old_Inactivedate ,NewRegion,NewBranch,NewSB,      
NewClcd,NewClname,NewAddress,convert(varchar(11),New_ActiveDate,103) as New_ActiveDate,convert(varchar(11),New_Inactivedate,103) as New_Inactivedate ,      
Terminal_no,orderid,Scriptcode,[Buy/Sell],Quantity,Rate,Amount = quantity * rate  into #temp from #AA1 (nolock)    
    
SELECT  * FROM #temp where Newsb like @sb    

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.timeminimum
-- --------------------------------------------------
CREATE procedure timeminimum
as  
  
set transaction isolation level read uncommitted  
set nocount on  
  
select  party_code,termid into #file1 from bsecashtrd (nolock)  
  
select distinct party_code from #file1 trd  
where trd.party_code not in   
(select party_code from intranet.risk.dbo.bse_client2)   
and trd.termid not in (select userid from termparty)   
order by party_code  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ttest
-- --------------------------------------------------
create proc ttest
as 
select 'sumit'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccbse_clientopening
-- --------------------------------------------------

  
   CREATE    procedure [dbo].[uccbse_clientopening] (@fdate varchar(11),@tdate varchar(11))  
as      
  
/*  
exec  
 uccbse_clientopening 'Dec 18 2007', 'Dec 19 2007'  
*/  
  
SET NOCOUNT ON    
  
select /*distinct  */ucc.clientid,c1.branch_cd, c1.sub_broker,mapin=' ',c1.pan_gir_no ,      
  
long_name = ltrim(rtrim(  
 replace(  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       replace(  
        replace(  
         replace(  
          replace(  
           replace(  
            replace(long_name, '(C)', ''),  
            '( C )',  
            ''  
           ),  
           '( C)',  
           ''  
          ),  
          '(C )',  
          ''  
         ),  
         'CLOSED',  
         ''  
        ),  
        'CLOSE',  
        ''  
       ),  
       '(',  
       ''  
      ),  
      ')',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '-',  
    ''  
   ),  
   '\',  
   ''  
  ),  
  '*',  
  ''  
 )  
)),  
  
c1.l_address1, c1.l_address2, c1.l_address3, l_city, l_state, l_nation ,      
l_zip,   
  
--phone = coalesce(res_phone1,res_phone2,off_phone1,off_phone2),   
phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2),*/  
 replace(  
  replace(  
   replace(  
    replace(  
     replace(  
      case   
       when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
       when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
       when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
       when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
      else  
       ''  
      end,  
      space(1),  
      ''  
     ),  
     '-',  
     ''  
    ),  
    '/',  
    ''  
   ),  
   '(',  
   ''  
  ),  
  '(',  
  ''  
 )  
,  
  
fax, email, depository, c4.bankid, cltdpid , passportdtl,PassportDateOfIssue , PassportPlaceOfIssue ,      
passportdateofexpiry = dateadd(year , 20 , PassportDateOfIssue) , votersiddtl,VoterIdDateOfIssue ,      
VoterIdPlaceOfIssue , drivelicendtl,LicenceNoDateOfIssue , LicenceNoPlaceOfIssue,LicenceNoDateOfexpiry = dateadd(year , 20 , LicenceNoDateOfIssue)       
, rationcarddtl,RationCardDateOfIssue , RationCardPlaceOfIssue     
from       
(      
    select clientid=party_code from     
     middleware.mimansa.dbo.angelclient5     
     where BseCmActiveFrom >= @fdate + ' 18:00'    
     and BseCmActiveFrom < @tdate + ' 18:00'    
/*     and BseCmInactiveFrom >= getdate()    */  
)       
as ucc left outer join       
AngelBSECM.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid       
left outer join AngelBSECM.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code       
left join AngelBSECM.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid left join AngelBSECM.bsedb_ab.dbo.client5 c5       
on c5.cl_code = c2.cl_code where c2.party_code is not null       
--and ucc.clientid not in (select client_code from esignbse.bse.dbo.uccbsesuccess)       
order by ucc.clientid      
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccbse_upload
-- --------------------------------------------------






CREATE      procedure uccbse_upload
as  
set nocount on
set implicit_transactions off

declare @count as varchar(10)
select @count=count(*) from information_schema.tables where table_name='uccbsefile'  
if @count=1  
 begin  
  drop table uccbsefile
 end  

/*
select distinct ucc.clientid,c1.branch_cd, c1.sub_broker,mapin=' ',c1.pan_gir_no ,  
 long_name, c1.l_address1, c1.l_address2, c1.l_address3, l_city, l_state, l_nation ,  
 l_zip, phone = coalesce(res_phone1,res_phone2,off_phone1,off_phone2), fax, email ,  
 depository, c4.bankid, cltdpid , passportdtl,passportdateofissue , passportplaceofissue ,  
passportdateofexpiry = dateadd(year , 20 , passportdateofissue) , votersiddtl,voteriddateofissue ,  
voteridplaceofissue , drivelicendtl,licencenodateofissue , licencenoplaceofissue,licencenodateofexpiry = dateadd(year , 20 , licencenodateofissue)   
, rationcarddtl,rationcarddateofissue , rationcardplaceofissue */

select
	clientid = ltrim(rtrim(ucc.clientid)),
	branch_cd = ltrim(rtrim(c1.branch_cd)),
	sub_broker = ltrim(rtrim(c1.sub_broker)),
	mapin=' ',
	pan_gir_no = ltrim(rtrim(c1.pan_gir_no)),


	long_name = ltrim(rtrim(
		replace(
			replace(
				replace(
					replace(
						replace(
							replace(
								replace(
									replace(
										replace(
											replace(
												replace(
													replace(long_name, '(C)', ''),
													'( C )',
													''
												),
												'( C)',
												''
											),
											'(C )',
											''
										),
										'CLOSED',
										''
									),
									'CLOSE',
									''
								),
								'(',
								''
							),
							')',
							''
						),
						'/',
						''
					),
					'-',
					''
				),
				'\',
				''
			),
			'*',
			''
		)
	)),

	l_address1 = ltrim(rtrim(c1.l_address1)),
	l_address2 = ltrim(rtrim(c1.l_address2)),
	l_address3 = ltrim(rtrim(c1.l_address3)),
	l_city = ltrim(rtrim(l_city)),
	l_state = ltrim(rtrim(l_state)),
	l_nation = ltrim(rtrim(l_nation)),
--	l_zip = ltrim(rtrim(l_zip)),
	l_zip = case when len(ltrim(rtrim(l_zip))) = 6 then ltrim(rtrim(l_zip)) else '' end,

--	phone = coalesce(res_phone1, res_phone2, off_phone1, off_phone2),

	phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2),*/
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	,

	fax = ltrim(rtrim(fax)),
	email = ltrim(rtrim(email)),
	depository = ltrim(rtrim(depository)),
	bankid = ltrim(rtrim(c4.bankid)),
	cltdpid = ltrim(rtrim(cltdpid)),

/*
	passportdtl = ltrim(rtrim(passportdtl)),
	passportdateofissue,
	passportplaceofissue = ltrim(rtrim(passportplaceofissue)),
	passportdateofexpiry = dateadd(year, 20, passportdateofissue), 
	votersiddtl = ltrim(rtrim(votersiddtl)),
	voteriddateofissue,
	voteridplaceofissue = ltrim(rtrim(voteridplaceofissue)),
	drivelicendtl = ltrim(rtrim(drivelicendtl)),
	licencenodateofissue,
	licencenoplaceofissue = ltrim(rtrim(licencenoplaceofissue)),
	licencenodateofexpiry = dateadd(year, 20, licencenodateofissue),
	rationcarddtl = ltrim(rtrim(rationcarddtl)),
	rationcarddateofissue,
	rationcardplaceofissue = ltrim(rtrim(rationcardplaceofissue))
*/

	passportdtl = space(1),
	passportdateofissue = space(1),
	passportplaceofissue = space(1),
	passportdateofexpiry = space(1), 
	votersiddtl = space(1),
	voteriddateofissue = space(1),
	voteridplaceofissue = space(1),
	drivelicendtl = space(1),
	licencenodateofissue = space(1),
	licencenoplaceofissue = space(1),
	licencenodateofexpiry = space(1),
	rationcarddtl = space(1),
	rationcarddateofissue = space(1),
	rationcardplaceofissue = space(1)

into 
	uccbsefile
from   
	(select distinct clientid = ltrim(rtrim(clientid)) from intranet.ucc.dbo.ucc3009) as ucc 
	left outer join anand.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid 
	left outer join anand.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code 
	left join anand.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid 
	left join anand.bsedb_ab.dbo.client5 c5	on c5.cl_code = c2.cl_code 
--
--(  
--select distinct clientid from intranet.ucc.dbo.ucc3009   
  
--/*  
--    select distinct clientid,clientcode
--    from intranet.ucc.dbo.newcr newcr right outer join intranet.ucc.dbo.ucc3009 ucc3009   
--    on newcr.clientcode=ucc3009.clientid where clientcode is null   
--*/  
  
--)   
--as ucc left outer join   
--anand.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid   
--left outer join anand.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code   
--left join anand.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid left join anand.bsedb_ab.dbo.client5 c5   
--on c5.cl_code = c2.cl_code where c2.party_code is not null   

----and ucc.clientid not in (select client_code from esignbse.bse.dbo.uccbsesuccess)   

where
	len(ltrim(rtrim(long_name))) > 0

order by 
	ucc.clientid  

select 
	clientid,
	branch_cd,
	sub_broker,
	mapin,
	pan_gir_no = left(ltrim(rtrim(isnull(pan_gir_no, ''))), 10),
	long_name,
	l_address1,
	l_address2,
	l_address3,
	l_city,
	l_state,
	l_nation,
	l_zip,
	phone,
	fax,
	email,
	depository,
	bankid,
	cltdpid,
	passportdtl = ltrim(rtrim(passportdtl)),
	passportdateofissue = ltrim(rtrim(passportdateofissue)),
	passportplaceofissue = ltrim(rtrim(passportplaceofissue)),
	passportdateofexpiry = ltrim(rtrim(passportdateofexpiry)), 
	votersiddtl = ltrim(rtrim(votersiddtl)),
	voteriddateofissue = ltrim(rtrim(voteriddateofissue)),
	voteridplaceofissue = ltrim(rtrim(voteridplaceofissue)),
	drivelicendtl = ltrim(rtrim(drivelicendtl)),
	licencenodateofissue = ltrim(rtrim(licencenodateofissue)),
	licencenoplaceofissue = ltrim(rtrim(licencenoplaceofissue)),
	licencenodateofexpiry = ltrim(rtrim(licencenodateofexpiry)),
	rationcarddtl = ltrim(rtrim(rationcarddtl)),
	rationcarddateofissue = ltrim(rtrim(rationcarddateofissue)),
	rationcardplaceofissue = ltrim(rtrim(rationcardplaceofissue)),
	pan_gir_no_orig = pan_gir_no,
	pin=l_zip
from 
	uccbsefile

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UCCBSE_UPLOAD_15122010
-- --------------------------------------------------


CREATE PROCEDURE UCCBSE_UPLOAD_15122010

AS    

	SET NOCOUNT ON  
	SET IMPLICIT_TRANSACTIONS OFF  
	  
	DECLARE @COUNT AS VARCHAR(10)
	  
	SELECT @COUNT=COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='UCCBSEFILE'    

	IF @COUNT=1    
		
		BEGIN		
			DROP TABLE UCCBSEFILE  
		END    
	  
	/*  
	SELECT DISTINCT UCC.CLIENTID,C1.BRANCH_CD, C1.SUB_BROKER,MAPIN=' ',C1.PAN_GIR_NO ,    
	 LONG_NAME, C1.L_ADDRESS1, C1.L_ADDRESS2, C1.L_ADDRESS3, L_CITY, L_STATE, L_NATION ,    
	 L_ZIP, PHONE = COALESCE(RES_PHONE1,RES_PHONE2,OFF_PHONE1,OFF_PHONE2), FAX, EMAIL ,    
	 DEPOSITORY, C4.BANKID, CLTDPID , PASSPORTDTL,PASSPORTDATEOFISSUE , PASSPORTPLACEOFISSUE ,    
	PASSPORTDATEOFEXPIRY = DATEADD(YEAR , 20 , PASSPORTDATEOFISSUE) , VOTERSIDDTL,VOTERIDDATEOFISSUE ,    
	VOTERIDPLACEOFISSUE , DRIVELICENDTL,LICENCENODATEOFISSUE , LICENCENOPLACEOFISSUE,LICENCENODATEOFEXPIRY = DATEADD(YEAR , 20 , LICENCENODATEOFISSUE)     
	, RATIONCARDDTL,RATIONCARDDATEOFISSUE , RATIONCARDPLACEOFISSUE */  

	SELECT DISTINCT CLIENTID = LTRIM(RTRIM(CLIENTID)) 
	INTO #TEMP
	FROM INTRANET.UCC.DBO.UCC3009
	  
	SELECT  
	 CLIENTID = LTRIM(RTRIM(#TEMP.CLIENTID)),  
	 BRANCH_CD = LTRIM(RTRIM(C1.BRANCH_CD)),  
	 SUB_BROKER = LTRIM(RTRIM(C1.SUB_BROKER)),  
	 MAPIN=' ',  
	 PAN_GIR_NO = LTRIM(RTRIM(C1.PAN_GIR_NO)),  
	 LONG_NAME = LTRIM(RTRIM(  
	  REPLACE(  
	   REPLACE(  
		REPLACE(  
		 REPLACE(  
		  REPLACE(  
		   REPLACE(  
			REPLACE(  
			 REPLACE(  
			  REPLACE(  
			   REPLACE(  
				REPLACE(  
				 REPLACE(LONG_NAME, '(C)', ''),  
				 '( C )',  
				 ''  
				),  
				'( C)',  
				''  
			   ),  
			   '(C )',  
			   ''  
			  ),  
			  'CLOSED',  
			  ''  
			 ),  
			 'CLOSE',  
			 ''  
			),  
			'(',  
			''  
		   ),  
		   ')',  
		   ''  
		  ),  
		  '/',  
		  ''  
		 ),  
		 '-',  
		 ''  
		),  
		'\',  
		''  
	   ),  
	   '*',  
	   ''  
	  )  
	 )),  
	  
	 L_ADDRESS1 = LTRIM(RTRIM(C1.L_ADDRESS1)),  
	 L_ADDRESS2 = LTRIM(RTRIM(C1.L_ADDRESS2)),  
	 L_ADDRESS3 = LTRIM(RTRIM(C1.L_ADDRESS3)),  
	 L_CITY = LTRIM(RTRIM(L_CITY)),  
	 L_STATE = LTRIM(RTRIM(L_STATE)),  
	 L_NATION = LTRIM(RTRIM(L_NATION)),  
	-- L_ZIP = LTRIM(RTRIM(L_ZIP)),  
	 L_ZIP = CASE WHEN LEN(LTRIM(RTRIM(L_ZIP))) = 6 THEN LTRIM(RTRIM(L_ZIP)) ELSE '' END,  
	  
	-- PHONE = COALESCE(RES_PHONE1, RES_PHONE2, OFF_PHONE1, OFF_PHONE2),  
	  
	 PHONE = /*COALESCE(C1.RES_PHONE1,C1.RES_PHONE2,C1.OFF_PHONE1,C1.OFF_PHONE2),*/  
	  REPLACE(  
	   REPLACE(  
		REPLACE(  
		 REPLACE(  
		  REPLACE(  
		   CASE   
			WHEN LEN(LTRIM(RTRIM(C1.RES_PHONE1))) > 0 THEN C1.RES_PHONE1  
			WHEN LEN(LTRIM(RTRIM(C1.RES_PHONE2))) > 0 THEN C1.RES_PHONE2  
			WHEN LEN(LTRIM(RTRIM(C1.OFF_PHONE1))) > 0 THEN C1.OFF_PHONE1  
			WHEN LEN(LTRIM(RTRIM(C1.OFF_PHONE2))) > 0 THEN C1.OFF_PHONE2  
		   ELSE  
			''  
		   END,  
		   SPACE(1),  
		   ''  
		  ),  
		  '-',  
		  ''  
		 ),  
		 '/',  
		 ''  
		),  
		'(',  
		''  
	   ),  
	   '(',  
	   ''  
	  )  
	 ,  
	  
	 FAX = LTRIM(RTRIM(FAX)),  
	 EMAIL = LTRIM(RTRIM(EMAIL)),  
	 DEPOSITORY = LTRIM(RTRIM(DEPOSITORY)),  
	 BANKID = LTRIM(RTRIM(C4.BANKID)),  
	 CLTDPID = LTRIM(RTRIM(CLTDPID)),  
	  
	/*  
	 PASSPORTDTL = LTRIM(RTRIM(PASSPORTDTL)),  
	 PASSPORTDATEOFISSUE,  
	 PASSPORTPLACEOFISSUE = LTRIM(RTRIM(PASSPORTPLACEOFISSUE)),  
	 PASSPORTDATEOFEXPIRY = DATEADD(YEAR, 20, PASSPORTDATEOFISSUE),   
	 VOTERSIDDTL = LTRIM(RTRIM(VOTERSIDDTL)),  
	 VOTERIDDATEOFISSUE,  
	 VOTERIDPLACEOFISSUE = LTRIM(RTRIM(VOTERIDPLACEOFISSUE)),  
	 DRIVELICENDTL = LTRIM(RTRIM(DRIVELICENDTL)),  
	 LICENCENODATEOFISSUE,  
	 LICENCENOPLACEOFISSUE = LTRIM(RTRIM(LICENCENOPLACEOFISSUE)),  
	 LICENCENODATEOFEXPIRY = DATEADD(YEAR, 20, LICENCENODATEOFISSUE),  
	 RATIONCARDDTL = LTRIM(RTRIM(RATIONCARDDTL)),  
	 RATIONCARDDATEOFISSUE,  
	 RATIONCARDPLACEOFISSUE = LTRIM(RTRIM(RATIONCARDPLACEOFISSUE))  
	*/  
	  
	 PASSPORTDTL = SPACE(1),  
	 PASSPORTDATEOFISSUE = SPACE(1),  
	 PASSPORTPLACEOFISSUE = SPACE(1),  
	 PASSPORTDATEOFEXPIRY = SPACE(1),   
	 VOTERSIDDTL = SPACE(1),  
	 VOTERIDDATEOFISSUE = SPACE(1),  
	 VOTERIDPLACEOFISSUE = SPACE(1),  
	 DRIVELICENDTL = SPACE(1),  
	 LICENCENODATEOFISSUE = SPACE(1),  
	 LICENCENOPLACEOFISSUE = SPACE(1),  
	 LICENCENODATEOFEXPIRY = SPACE(1),  
	 RATIONCARDDTL = SPACE(1),  
	 RATIONCARDDATEOFISSUE = SPACE(1),  
	 RATIONCARDPLACEOFISSUE = SPACE(1)  
	  
	INTO   
	 UCCBSEFILE 
	  
	FROM     
	 #TEMP
	 LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT2 C2 ON C2.PARTY_CODE = #TEMP.CLIENTID   
	 LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT1 C1 ON C2.CL_CODE = C1.CL_CODE   
	 LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT4 C4 ON C4.PARTY_CODE = #TEMP.CLIENTID   
	 LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT5 C5 ON C5.CL_CODE = C2.CL_CODE   
	--  
	--(    
	--SELECT DISTINCT CLIENTID FROM INTRANET.UCC.DBO.UCC3009     
	--/*    
	--    SELECT DISTINCT CLIENTID,CLIENTCODE  
	--    FROM INTRANET.UCC.DBO.NEWCR NEWCR RIGHT OUTER JOIN INTRANET.UCC.DBO.UCC3009 UCC3009     
	--    ON NEWCR.CLIENTCODE=UCC3009.CLIENTID WHERE CLIENTCODE IS NULL     
	--*/    
	--)     
	--AS UCC LEFT OUTER JOIN     
	--ANAND.BSEDB_AB.DBO.CLIENT2 C2 ON C2.PARTY_CODE = UCC.CLIENTID     
	--LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT1 C1 ON C2.CL_CODE = C1.CL_CODE     
	--LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT4 C4 ON C4.PARTY_CODE = UCC.CLIENTID LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT5 C5     
	--ON C5.CL_CODE = C2.CL_CODE WHERE C2.PARTY_CODE IS NOT NULL     
	----AND UCC.CLIENTID NOT IN (SELECT CLIENT_CODE FROM ESIGNBSE.BSE.DBO.UCCBSESUCCESS)     
	  
	WHERE  
	 LEN(LTRIM(RTRIM(LONG_NAME))) > 0  
	  
	ORDER BY   
	 #TEMP.CLIENTID    
	  
	SELECT   
	 CLIENTID,  
	 BRANCH_CD,  
	 SUB_BROKER,  
	 MAPIN,  
	 PAN_GIR_NO = LEFT(LTRIM(RTRIM(ISNULL(PAN_GIR_NO, ''))), 10),  
	 LONG_NAME,  
	 L_ADDRESS1,  
	 L_ADDRESS2,  
	 L_ADDRESS3,  
	 L_CITY,  
	 L_STATE,  
	 L_NATION,  
	 L_ZIP,  
	 PHONE,  
	 FAX,  
	 EMAIL,  
	 DEPOSITORY,  
	 BANKID,  
	 CLTDPID,  
	 PASSPORTDTL = LTRIM(RTRIM(PASSPORTDTL)),  
	 PASSPORTDATEOFISSUE = LTRIM(RTRIM(PASSPORTDATEOFISSUE)),  
	 PASSPORTPLACEOFISSUE = LTRIM(RTRIM(PASSPORTPLACEOFISSUE)),  
	 PASSPORTDATEOFEXPIRY = LTRIM(RTRIM(PASSPORTDATEOFEXPIRY)),   
	 VOTERSIDDTL = LTRIM(RTRIM(VOTERSIDDTL)),  
	 VOTERIDDATEOFISSUE = LTRIM(RTRIM(VOTERIDDATEOFISSUE)),  
	 VOTERIDPLACEOFISSUE = LTRIM(RTRIM(VOTERIDPLACEOFISSUE)),  
	 DRIVELICENDTL = LTRIM(RTRIM(DRIVELICENDTL)),  
	 LICENCENODATEOFISSUE = LTRIM(RTRIM(LICENCENODATEOFISSUE)),  
	 LICENCENOPLACEOFISSUE = LTRIM(RTRIM(LICENCENOPLACEOFISSUE)),  
	 LICENCENODATEOFEXPIRY = LTRIM(RTRIM(LICENCENODATEOFEXPIRY)),  
	 RATIONCARDDTL = LTRIM(RTRIM(RATIONCARDDTL)),  
	 RATIONCARDDATEOFISSUE = LTRIM(RTRIM(RATIONCARDDATEOFISSUE)),  
	 RATIONCARDPLACEOFISSUE = LTRIM(RTRIM(RATIONCARDPLACEOFISSUE)),  
	 PAN_GIR_NO_ORIG = PAN_GIR_NO,  
	 PIN=L_ZIP  
	FROM   
	 UCCBSEFILE  
	  
	SET NOCOUNT OFF    
	  

/**********************************************************************************************************************

CREATE      procedure uccbse_upload  
as    
set nocount on  
set implicit_transactions off  
  
declare @count as varchar(10)  
select @count=count(*) from information_schema.tables where table_name='uccbsefile'    
if @count=1    
 begin    
  drop table uccbsefile  
 end    
  
/*  
select distinct ucc.clientid,c1.branch_cd, c1.sub_broker,mapin=' ',c1.pan_gir_no ,    
 long_name, c1.l_address1, c1.l_address2, c1.l_address3, l_city, l_state, l_nation ,    
 l_zip, phone = coalesce(res_phone1,res_phone2,off_phone1,off_phone2), fax, email ,    
 depository, c4.bankid, cltdpid , passportdtl,passportdateofissue , passportplaceofissue ,    
passportdateofexpiry = dateadd(year , 20 , passportdateofissue) , votersiddtl,voteriddateofissue ,    
voteridplaceofissue , drivelicendtl,licencenodateofissue , licencenoplaceofissue,licencenodateofexpiry = dateadd(year , 20 , licencenodateofissue)     
, rationcarddtl,rationcarddateofissue , rationcardplaceofissue */  
  
select  
 clientid = ltrim(rtrim(ucc.clientid)),  
 branch_cd = ltrim(rtrim(c1.branch_cd)),  
 sub_broker = ltrim(rtrim(c1.sub_broker)),  
 mapin=' ',  
 pan_gir_no = ltrim(rtrim(c1.pan_gir_no)),  
  
  
 long_name = ltrim(rtrim(  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       replace(  
        replace(  
         replace(  
          replace(  
           replace(  
            replace(  
             replace(long_name, '(C)', ''),  
             '( C )',  
             ''  
            ),  
            '( C)',  
            ''  
           ),  
           '(C )',  
           ''  
          ),  
          'CLOSED',  
          ''  
         ),  
         'CLOSE',  
         ''  
        ),  
        '(',  
        ''  
       ),  
       ')',  
       ''  
      ),  
      '/',  
      ''  
     ),  
     '-',  
     ''  
    ),  
    '\',  
    ''  
   ),  
   '*',  
   ''  
  )  
 )),  
  
 l_address1 = ltrim(rtrim(c1.l_address1)),  
 l_address2 = ltrim(rtrim(c1.l_address2)),  
 l_address3 = ltrim(rtrim(c1.l_address3)),  
 l_city = ltrim(rtrim(l_city)),  
 l_state = ltrim(rtrim(l_state)),  
 l_nation = ltrim(rtrim(l_nation)),  
-- l_zip = ltrim(rtrim(l_zip)),  
 l_zip = case when len(ltrim(rtrim(l_zip))) = 6 then ltrim(rtrim(l_zip)) else '' end,  
  
-- phone = coalesce(res_phone1, res_phone2, off_phone1, off_phone2),  
  
 phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2),*/  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 ,  
  
 fax = ltrim(rtrim(fax)),  
 email = ltrim(rtrim(email)),  
 depository = ltrim(rtrim(depository)),  
 bankid = ltrim(rtrim(c4.bankid)),  
 cltdpid = ltrim(rtrim(cltdpid)),  
  
/*  
 passportdtl = ltrim(rtrim(passportdtl)),  
 passportdateofissue,  
 passportplaceofissue = ltrim(rtrim(passportplaceofissue)),  
 passportdateofexpiry = dateadd(year, 20, passportdateofissue),   
 votersiddtl = ltrim(rtrim(votersiddtl)),  
 voteriddateofissue,  
 voteridplaceofissue = ltrim(rtrim(voteridplaceofissue)),  
 drivelicendtl = ltrim(rtrim(drivelicendtl)),  
 licencenodateofissue,  
 licencenoplaceofissue = ltrim(rtrim(licencenoplaceofissue)),  
 licencenodateofexpiry = dateadd(year, 20, licencenodateofissue),  
 rationcarddtl = ltrim(rtrim(rationcarddtl)),  
 rationcarddateofissue,  
 rationcardplaceofissue = ltrim(rtrim(rationcardplaceofissue))  
*/  
  
 passportdtl = space(1),  
 passportdateofissue = space(1),  
 passportplaceofissue = space(1),  
 passportdateofexpiry = space(1),   
 votersiddtl = space(1),  
 voteriddateofissue = space(1),  
 voteridplaceofissue = space(1),  
 drivelicendtl = space(1),  
 licencenodateofissue = space(1),  
 licencenoplaceofissue = space(1),  
 licencenodateofexpiry = space(1),  
 rationcarddtl = space(1),  
 rationcarddateofissue = space(1),  
 rationcardplaceofissue = space(1)  
  
into   
 uccbsefile  
from     
 (select distinct clientid = ltrim(rtrim(clientid)) from intranet.ucc.dbo.ucc3009) as ucc   
 left outer join anand.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid   
 left outer join anand.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code   
 left join anand.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid   
 left join anand.bsedb_ab.dbo.client5 c5 on c5.cl_code = c2.cl_code   
--  
--(    
--select distinct clientid from intranet.ucc.dbo.ucc3009     
    
--/*    
--    select distinct clientid,clientcode  
--    from intranet.ucc.dbo.newcr newcr right outer join intranet.ucc.dbo.ucc3009 ucc3009     
--    on newcr.clientcode=ucc3009.clientid where clientcode is null     
--*/    
    
--)     
--as ucc left outer join     
--anand.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid     
--left outer join anand.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code     
--left join anand.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid left join anand.bsedb_ab.dbo.client5 c5     
--on c5.cl_code = c2.cl_code where c2.party_code is not null     
  
----and ucc.clientid not in (select client_code from esignbse.bse.dbo.uccbsesuccess)     
  
where  
 len(ltrim(rtrim(long_name))) > 0  
  
order by   
 ucc.clientid    
  
select   
 clientid,  
 branch_cd,  
 sub_broker,  
 mapin,  
 pan_gir_no = left(ltrim(rtrim(isnull(pan_gir_no, ''))), 10),  
 long_name,  
 l_address1,  
 l_address2,  
 l_address3,  
 l_city,  
 l_state,  
 l_nation,  
 l_zip,  
 phone,  
 fax,  
 email,  
 depository,  
 bankid,  
 cltdpid,  
 passportdtl = ltrim(rtrim(passportdtl)),  
 passportdateofissue = ltrim(rtrim(passportdateofissue)),  
 passportplaceofissue = ltrim(rtrim(passportplaceofissue)),  
 passportdateofexpiry = ltrim(rtrim(passportdateofexpiry)),   
 votersiddtl = ltrim(rtrim(votersiddtl)),  
 voteriddateofissue = ltrim(rtrim(voteriddateofissue)),  
 voteridplaceofissue = ltrim(rtrim(voteridplaceofissue)),  
 drivelicendtl = ltrim(rtrim(drivelicendtl)),  
 licencenodateofissue = ltrim(rtrim(licencenodateofissue)),  
 licencenoplaceofissue = ltrim(rtrim(licencenoplaceofissue)),  
 licencenodateofexpiry = ltrim(rtrim(licencenodateofexpiry)),  
 rationcarddtl = ltrim(rtrim(rationcarddtl)),  
 rationcarddateofissue = ltrim(rtrim(rationcarddateofissue)),  
 rationcardplaceofissue = ltrim(rtrim(rationcardplaceofissue)),  
 pan_gir_no_orig = pan_gir_no,  
 pin=l_zip  
from   
 uccbsefile  
  
set nocount off    

**************************************************************************************************************************/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UCCBSE_UPLOAD_31122010
-- --------------------------------------------------
CREATE PROCEDURE UCCBSE_UPLOAD_31122010

AS    

	SET NOCOUNT ON  
	SET IMPLICIT_TRANSACTIONS OFF  

	DECLARE @COUNT AS VARCHAR(10)  
	SELECT @COUNT=COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='UCCBSEFILE'    
	
	IF @COUNT=1    
	BEGIN    
		DROP TABLE UCCBSEFILE  
	END    

	/*  
	SELECT DISTINCT UCC.CLIENTID,C1.BRANCH_CD, C1.SUB_BROKER,MAPIN=' ',C1.PAN_GIR_NO ,    
	LONG_NAME, C1.L_ADDRESS1, C1.L_ADDRESS2, C1.L_ADDRESS3, L_CITY, L_STATE, L_NATION ,    
	L_ZIP, PHONE = COALESCE(RES_PHONE1,RES_PHONE2,OFF_PHONE1,OFF_PHONE2), FAX, EMAIL ,    
	DEPOSITORY, C4.BANKID, CLTDPID , PASSPORTDTL,PASSPORTDATEOFISSUE , PASSPORTPLACEOFISSUE ,    
	PASSPORTDATEOFEXPIRY = DATEADD(YEAR , 20 , PASSPORTDATEOFISSUE) , VOTERSIDDTL,VOTERIDDATEOFISSUE ,    
	VOTERIDPLACEOFISSUE , DRIVELICENDTL,LICENCENODATEOFISSUE , LICENCENOPLACEOFISSUE,LICENCENODATEOFEXPIRY = DATEADD(YEAR , 20 , LICENCENODATEOFISSUE)     
	, RATIONCARDDTL,RATIONCARDDATEOFISSUE , RATIONCARDPLACEOFISSUE */  

	SELECT CLIENTID = LTRIM(RTRIM(UCC.CLIENTID)),  
		BRANCH_CD = LTRIM(RTRIM(C1.BRANCH_CD)),  
		SUB_BROKER = LTRIM(RTRIM(C1.SUB_BROKER)),  
		MAPIN=' ',  
		PAN_GIR_NO = LTRIM(RTRIM(C1.PAN_GIR_NO)),  
		LONG_NAME = LTRIM(RTRIM(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(LONG_NAME, '(C)', ''),  
		'( C )',  
		''  
		),  
		'( C)',  
		''  
		),  
		'(C )',  
		''  
		),  
		'CLOSED',  
		''  
		),  
		'CLOSE',  
		''  
		),  
		'(',  
		''  
		),  
		')',  
		''  
		),  
		'/',  
		''  
		),  
		'-',  
		''  
		),  
		'\',  
		''  
		),  
		'*',  
		''  
		)  
		)),  

		L_ADDRESS1 = LTRIM(RTRIM(C1.L_ADDRESS1)),  
		L_ADDRESS2 = LTRIM(RTRIM(C1.L_ADDRESS2)),  
		L_ADDRESS3 = LTRIM(RTRIM(C1.L_ADDRESS3)),  
		L_CITY = LTRIM(RTRIM(L_CITY)),  
		L_STATE = LTRIM(RTRIM(L_STATE)),  
		L_NATION = LTRIM(RTRIM(L_NATION)),  
		-- L_ZIP = LTRIM(RTRIM(L_ZIP)),  
		L_ZIP = CASE WHEN LEN(LTRIM(RTRIM(L_ZIP))) = 6 THEN LTRIM(RTRIM(L_ZIP)) ELSE '' END,  

		-- PHONE = COALESCE(RES_PHONE1, RES_PHONE2, OFF_PHONE1, OFF_PHONE2),  

		PHONE = /*COALESCE(C1.RES_PHONE1,C1.RES_PHONE2,C1.OFF_PHONE1,C1.OFF_PHONE2),*/  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		REPLACE(  
		CASE   
		WHEN LEN(LTRIM(RTRIM(C1.RES_PHONE1))) > 0 THEN C1.RES_PHONE1  
		WHEN LEN(LTRIM(RTRIM(C1.RES_PHONE2))) > 0 THEN C1.RES_PHONE2  
		WHEN LEN(LTRIM(RTRIM(C1.OFF_PHONE1))) > 0 THEN C1.OFF_PHONE1  
		WHEN LEN(LTRIM(RTRIM(C1.OFF_PHONE2))) > 0 THEN C1.OFF_PHONE2  
		ELSE  
		''  
		END,  
		SPACE(1),  
		''  
		),  
		'-',  
		''  
		),  
		'/',  
		''  
		),  
		'(',  
		''  
		),  
		'(',  
		''  
		)  
		,  

		FAX = LTRIM(RTRIM(FAX)),  
		EMAIL = LTRIM(RTRIM(EMAIL)),  
		DEPOSITORY = LTRIM(RTRIM(DEPOSITORY)),  
		BANKID = LTRIM(RTRIM(C4.BANKID)),  
		CLTDPID = LTRIM(RTRIM(CLTDPID)),  

		/*  
		PASSPORTDTL = LTRIM(RTRIM(PASSPORTDTL)),  
		PASSPORTDATEOFISSUE,  
		PASSPORTPLACEOFISSUE = LTRIM(RTRIM(PASSPORTPLACEOFISSUE)),  
		PASSPORTDATEOFEXPIRY = DATEADD(YEAR, 20, PASSPORTDATEOFISSUE),   
		VOTERSIDDTL = LTRIM(RTRIM(VOTERSIDDTL)),  
		VOTERIDDATEOFISSUE,  
		VOTERIDPLACEOFISSUE = LTRIM(RTRIM(VOTERIDPLACEOFISSUE)),  
		DRIVELICENDTL = LTRIM(RTRIM(DRIVELICENDTL)),  
		LICENCENODATEOFISSUE,  
		LICENCENOPLACEOFISSUE = LTRIM(RTRIM(LICENCENOPLACEOFISSUE)),  
		LICENCENODATEOFEXPIRY = DATEADD(YEAR, 20, LICENCENODATEOFISSUE),  
		RATIONCARDDTL = LTRIM(RTRIM(RATIONCARDDTL)),  
		RATIONCARDDATEOFISSUE,  
		RATIONCARDPLACEOFISSUE = LTRIM(RTRIM(RATIONCARDPLACEOFISSUE))  
		*/  

		PASSPORTDTL = SPACE(1),  
		PASSPORTDATEOFISSUE = SPACE(1),  
		PASSPORTPLACEOFISSUE = SPACE(1),  
		PASSPORTDATEOFEXPIRY = SPACE(1),   
		VOTERSIDDTL = SPACE(1),  
		VOTERIDDATEOFISSUE = SPACE(1),  
		VOTERIDPLACEOFISSUE = SPACE(1),  
		DRIVELICENDTL = SPACE(1),  
		LICENCENODATEOFISSUE = SPACE(1),  
		LICENCENOPLACEOFISSUE = SPACE(1),  
		LICENCENODATEOFEXPIRY = SPACE(1),  
		RATIONCARDDTL = SPACE(1),  
		RATIONCARDDATEOFISSUE = SPACE(1),  
		RATIONCARDPLACEOFISSUE = SPACE(1)  

	INTO UCCBSEFILE  
	FROM     
	(
		SELECT DISTINCT CLIENTID = LTRIM(RTRIM(CLIENTID)) FROM INTRANET.UCC.DBO.UCC3009
	) AS UCC   
	
	LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT2 C2 ON C2.PARTY_CODE = UCC.CLIENTID   
	LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT1 C1 ON C2.CL_CODE = C1.CL_CODE   
	LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT4 C4 ON C4.PARTY_CODE = UCC.CLIENTID   
	LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT5 C5 ON C5.CL_CODE = C2.CL_CODE   
	--  
	--(    
	--SELECT DISTINCT CLIENTID FROM INTRANET.UCC.DBO.UCC3009     

	--/*    
	--    SELECT DISTINCT CLIENTID,CLIENTCODE  
	--    FROM INTRANET.UCC.DBO.NEWCR NEWCR RIGHT OUTER JOIN INTRANET.UCC.DBO.UCC3009 UCC3009     
	--    ON NEWCR.CLIENTCODE=UCC3009.CLIENTID WHERE CLIENTCODE IS NULL     
	--*/    

	--)     
	--AS UCC LEFT OUTER JOIN     
	--ANAND.BSEDB_AB.DBO.CLIENT2 C2 ON C2.PARTY_CODE = UCC.CLIENTID     
	--LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT1 C1 ON C2.CL_CODE = C1.CL_CODE     
	--LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT4 C4 ON C4.PARTY_CODE = UCC.CLIENTID LEFT JOIN ANAND.BSEDB_AB.DBO.CLIENT5 C5     
	--ON C5.CL_CODE = C2.CL_CODE WHERE C2.PARTY_CODE IS NOT NULL     

	----AND UCC.CLIENTID NOT IN (SELECT CLIENT_CODE FROM ESIGNBSE.BSE.DBO.UCCBSESUCCESS)     

	WHERE  
	LEN(LTRIM(RTRIM(LONG_NAME))) > 0  

	ORDER BY   
	CLIENTID

	SELECT CLIENTID,  
		BRANCH_CD,  
		SUB_BROKER,  
		MAPIN,  
		PAN_GIR_NO = LEFT(LTRIM(RTRIM(ISNULL(PAN_GIR_NO, ''))), 10),  
		LONG_NAME,  
		L_ADDRESS1,  
		L_ADDRESS2,  
		L_ADDRESS3,  
		L_CITY,  
		L_STATE,  
		L_NATION,  
		L_ZIP,  
		PHONE,  
		FAX,  
		EMAIL,  
		DEPOSITORY,  
		BANKID,  
		CLTDPID,  
		PASSPORTDTL = LTRIM(RTRIM(PASSPORTDTL)),  
		PASSPORTDATEOFISSUE = LTRIM(RTRIM(PASSPORTDATEOFISSUE)),  
		PASSPORTPLACEOFISSUE = LTRIM(RTRIM(PASSPORTPLACEOFISSUE)),  
		PASSPORTDATEOFEXPIRY = LTRIM(RTRIM(PASSPORTDATEOFEXPIRY)),   
		VOTERSIDDTL = LTRIM(RTRIM(VOTERSIDDTL)),  
		VOTERIDDATEOFISSUE = LTRIM(RTRIM(VOTERIDDATEOFISSUE)),  
		VOTERIDPLACEOFISSUE = LTRIM(RTRIM(VOTERIDPLACEOFISSUE)),  
		DRIVELICENDTL = LTRIM(RTRIM(DRIVELICENDTL)),  
		LICENCENODATEOFISSUE = LTRIM(RTRIM(LICENCENODATEOFISSUE)),  
		LICENCENOPLACEOFISSUE = LTRIM(RTRIM(LICENCENOPLACEOFISSUE)),  
		LICENCENODATEOFEXPIRY = LTRIM(RTRIM(LICENCENODATEOFEXPIRY)),  
		RATIONCARDDTL = LTRIM(RTRIM(RATIONCARDDTL)),  
		RATIONCARDDATEOFISSUE = LTRIM(RTRIM(RATIONCARDDATEOFISSUE)),  
		RATIONCARDPLACEOFISSUE = LTRIM(RTRIM(RATIONCARDPLACEOFISSUE)),  
		PAN_GIR_NO_ORIG = PAN_GIR_NO,  
		PIN=L_ZIP  
	FROM UCCBSEFILE  

	SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccbse_upload_party_range
-- --------------------------------------------------






CREATE
	procedure [dbo].[uccbse_upload_party_range] (
		@range char(1)
	)

as  

/*
	exec uccbse_upload_party_range ''
	exec uccbse_upload_party_range 'Y'
*/

declare
	@strSelect varchar(8000),
	@strFrom varchar(2000),
	@strWhere varchar(2000),
	@strOrder varchar(1000)

set @strSelect = ''
set @strFrom = ''
set @strWhere = ''
set @strOrder = ''

declare @count as tinyint

select @count=count(*) from information_schema.tables where table_name='uccbsefile'
if convert(tinyint, @count) =1 begin
	drop table uccbsefile
end

set @strSelect = @strSelect + 'set nocount on ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + 'set implicit_transactions off ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + 'select ' + char(10) /* + char(13)*/

if upper(ltrim(rtrim(@range))) = 'Y' begin
	set @strSelect = @strSelect + 'distinct ' + char(10) /* + char(13)*/
end

set @strSelect = @strSelect + '	clientid = ltrim(rtrim(ucc.clientid)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	branch_cd = ltrim(rtrim(c1.branch_cd)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	sub_broker = ltrim(rtrim(c1.sub_broker)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	mapin = '' '', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	pan_gir_no = ltrim(rtrim(c1.pan_gir_no)), ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + '	long_name = ltrim(rtrim( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '		replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '									replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '										replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '											replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '												replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '													replace(long_name, ''(C)'', ''''), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '													''( C )'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '													'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '												), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '												''( C)'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '												'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '											), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '											''(C )'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '											'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '										), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '										''CLOSED'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '										'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '									), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '									''CLOSE'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '									'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								''('', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							'')'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						''/'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					''-'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				''\'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			''*'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '		) ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	)), ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + '	l_address1 = ltrim(rtrim(c1.l_address1)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	l_address2 = ltrim(rtrim(c1.l_address2)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	l_address3 = ltrim(rtrim(c1.l_address3)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	l_city = ltrim(rtrim(l_city)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	l_state = ltrim(rtrim(l_state)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	l_nation = ltrim(rtrim(l_nation)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	l_zip = case when len(ltrim(rtrim(l_zip))) = 6 then ltrim(rtrim(l_zip)) else '''' end, ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + '	phone =  ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '		replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						replace( ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							case ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1 ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2 ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1 ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2 ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							else ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '								'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							end, ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '							'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						''-'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '						'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					''/'', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '					'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				''('', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '				'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			''('', ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '			'''' ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '		) ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	, ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + '	fax = ltrim(rtrim(fax)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	email = ltrim(rtrim(email)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	depository = ltrim(rtrim(depository)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	bankid = ltrim(rtrim(c4.bankid)), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	cltdpid = ltrim(rtrim(cltdpid)), ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + '	passportdtl = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	passportdateofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	passportplaceofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	passportdateofexpiry = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	votersiddtl = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	voteriddateofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	voteridplaceofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	drivelicendtl = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	licencenodateofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	licencenoplaceofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	licencenodateofexpiry = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	rationcarddtl = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	rationcarddateofissue = space(1), ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	rationcardplaceofissue = space(1) ' + char(10) /* + char(13)*/

set @strSelect = @strSelect + 'into ' + char(10) /* + char(13)*/
set @strSelect = @strSelect + '	uccbsefile ' + char(10) /* + char(13)*/

set @strFrom = @strFrom + 'from ' + char(10) /* + char(13)*/

if upper(ltrim(rtrim(@range))) = 'Y' begin
	set @strFrom = @strFrom + '		(select distinct clientid = ltrim(rtrim(party_code)) from uccbse_upload_party_range_temp) ucc ' + char(10) /* + char(13)*/
end
else begin
	set @strFrom = @strFrom + '	(select distinct clientid = ltrim(rtrim(clientid)) from intranet.ucc.dbo.ucc3009) as ucc ' + char(10) /* + char(13)*/
end

set @strFrom = @strFrom + '	left outer join AngelBSECM.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid ' + char(10) /* + char(13)*/
set @strFrom = @strFrom + '	left outer join AngelBSECM.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code ' + char(10) /* + char(13)*/
set @strFrom = @strFrom + '	left join AngelBSECM.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid ' + char(10) /* + char(13)*/
set @strFrom = @strFrom + '	left join AngelBSECM.bsedb_ab.dbo.client5 c5	on c5.cl_code = c2.cl_code ' + char(10) /* + char(13)*/

set @strWhere = @strWhere + 'where ' + char(10) /* + char(13)*/
set @strWhere = @strWhere + '	len(ltrim(rtrim(long_name))) > 0 ' + char(10) /* + char(13)*/

if upper(ltrim(rtrim(@range))) = 'Y' begin
	set @strWhere = @strWhere + '		and ltrim(rtrim(ucc.clientid)) in (select distinct party_code = ltrim(rtrim(party_code)) from uccbse_upload_party_range_temp) ' + char(10) /* + char(13)*/
end

set @strOrder = @strOrder + 'order by ' + char(10) /* + char(13)*/
set @strOrder = @strOrder + '	ucc.clientid ' + char(10) /* + char(13)*/

--print (@strSelect + @strFrom + @strWhere + @strOrder)
--return
exec(@strSelect + @strFrom + @strWhere + @strOrder)

select
	clientid,
	branch_cd,
	sub_broker,
	mapin,
	pan_gir_no = case when len(ltrim(rtrim(isnull(pan_gir_no, '')))) = 0 then 'FORM60' else left(ltrim(rtrim(isnull(pan_gir_no, ''''))), 10) end,
	long_name,
	l_address1,
	l_address2,
	l_address3,
	l_city,
	l_state,
	l_nation,
	l_zip,
	phone,
	fax,
	email,
	depository,
	bankid,
	cltdpid,
	passportdtl = ltrim(rtrim(passportdtl)),
	passportdateofissue = ltrim(rtrim(passportdateofissue)),
	passportplaceofissue = ltrim(rtrim(passportplaceofissue)),
	passportdateofexpiry = ltrim(rtrim(passportdateofexpiry)), 
	votersiddtl = ltrim(rtrim(votersiddtl)),
	voteriddateofissue = ltrim(rtrim(voteriddateofissue)),
	voteridplaceofissue = ltrim(rtrim(voteridplaceofissue)),
	drivelicendtl = ltrim(rtrim(drivelicendtl)),
	licencenodateofissue = ltrim(rtrim(licencenodateofissue)),
	licencenoplaceofissue = ltrim(rtrim(licencenoplaceofissue)),
	licencenodateofexpiry = ltrim(rtrim(licencenodateofexpiry)),
	rationcarddtl = ltrim(rtrim(rationcarddtl)),
	rationcarddateofissue = ltrim(rtrim(rationcarddateofissue)),
	rationcardplaceofissue = ltrim(rtrim(rationcardplaceofissue)),
	pan_gir_no_orig = pan_gir_no,
	pin=l_zip

from 
	uccbsefile

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccbse_upload_report
-- --------------------------------------------------
create proc uccbse_upload_report

as

select distinct
	clientid,
	long_name,
	pan_gir_no_orig = pan_gir_no,
	pin=l_zip
from 
	uccbsefile

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccbse_uploadReport
-- --------------------------------------------------
Create procedure uccbse_uploadReport  
as  

select /*distinct  */ucc.clientid,c1.branch_cd, c1.sub_broker,c1.pan_gir_no ,  
 long_name, c1.l_address1, c1.l_address2, c1.l_address3, l_city, l_state, l_nation ,  
 l_zip, phone = coalesce(res_phone1,res_phone2,off_phone1,off_phone2),  
 depository, c4.bankid, cltdpid ,PassportDateOfIssue ,  
passportdateofexpiry = dateadd(year , 20 , PassportDateOfIssue) , votersiddtl,VoterIdDateOfIssue ,  
LicenceNoDateOfIssue ,LicenceNoDateOfexpiry = dateadd(year , 20 , LicenceNoDateOfIssue)   
,RationCardDateOfIssue  into #temp from   
(  
select distinct clientid from intranet.ucc.dbo.UCC3009   
  
/*  
    select distinct clientid,clientcode  
    from intranet.ucc.dbo.newcr newcr RIGHT outer join intranet.ucc.dbo.UCC3009 UCC3009   
    on newcr.clientcode=ucc3009.clientid where CLientCODE IS NULL   
*/  
  
)   
as ucc left outer join   
anand.bsedb_ab.dbo.client2 c2 on c2.party_code = ucc.clientid   
left outer join anand.bsedb_ab.dbo.client1 c1 on c2.cl_code = c1.cl_code   
left join anand.bsedb_ab.dbo.client4 c4 on c4.party_code = ucc.clientid left join anand.bsedb_ab.dbo.client5 c5   
on c5.cl_code = c2.cl_code where c2.party_code is not null   
--and ucc.clientid not in (select client_code from esignbse.bse.dbo.uccbsesuccess)   
order by ucc.clientid  
select * from #temp

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_termid_to
-- --------------------------------------------------
CREATE procedure upd_termid_to  
as  
  
set nocount on  
  
set transaction isolation level read uncommitted  
  
declare @sdate as datetime  
select @sdate=max(sauda_Date) from bsecashtrd   
  
select * into #file1 from bse_termid where segment='BSE CASH'  
union  
select termid =userid, c1.branch_cd, branch_name = c1.long_name, status='ACTIVE',   
party_code=c2.party_code, conn_type='', conn_id='',  
location=c1.L_city, segment = 'BSE CASH', user_name1 = '', ref_name = '',  
 c1.sub_broker, branch_cd_alt = '', sub_broker_alt = ''  
-- from anand.bsedb_ab.dbo.termparty termid ,   
from termparty termid ,   
 INTRANET.RISK.DBO.BSE_client2 c2,  INTRANET.RISK.DBO.BSE_client1 c1, INTRANET.RISK.DBO.branch br  
where termid.party_code = c2.party_code   
and c2.cl_code = c1.cl_code  
and br.SBTAG = c1.branch_cd  
  
select termid,sum( tradeqty * convert(float,Marketrate)/100 ) as turnover,max(sauda_date) as sauda_date   
into #file2  
from bsecashtrd where convert(datetime,convert(varchar(11),sauda_date),106)=@sdate  
group by termid   
  
  
insert into temp_bsecashtrd   
select a.termid,a.branch_Cd,a.branch_name,party_code,turnover=isnull(turnover,0),sauda_Date=@sdate   
from #file1 a left outer join #file2 b on a.termid=b.termid  
  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_termid_to1
-- --------------------------------------------------
CREATE procedure [dbo].[upd_termid_to1]      
as      
      
set nocount on      
      
set transaction isolation level read uncommitted      
      
declare @sdate as datetime      
select @sdate=max(sauda_Date) from bsecashtrd     
  
  
insert into temp_bsecashtrd    
select a.termid,a.branch_Cd,a.branch_name,party_code,turnover=isnull(turnover,0),sauda_Date=@sdate   
from   
(select * from bse_termid where segment='BSE CASH' union      
select termid =userid, c1.branch_cd, branch_name = c1.long_name, status='ACTIVE',       
party_code=c2.party_code, conn_type='', conn_id='',      
location=c1.L_city, segment = 'BSE CASH', user_name1 = '', ref_name = '',      
 c1.sub_broker, branch_cd_alt = '', sub_broker_alt = '',user_email = '',user_emailcc = ''            
-- from AngelBSECM.bsedb_ab.dbo.termparty termid ,       
from termparty termid ,       
 INTRANET.RISK.DBO.BSE_client2 c2,  INTRANET.RISK.DBO.BSE_client1 c1, INTRANET.RISK.DBO.branch br      
where termid.party_code = c2.party_code       
and c2.cl_code = c1.cl_code      
and br.SBTAG = c1.branch_cd)   
as a left outer join  
(select termid,sum( tradeqty * convert(float,Marketrate)/100 ) as turnover,max(sauda_date) as sauda_date       
from bsecashtrd where convert(datetime,convert(varchar(11),sauda_date),106)=@sdate       
group by termid) as b on a.termid=b.termid     
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_allbranch_bsecls2
-- --------------------------------------------------
CREATE procedure usp_allbranch_bsecls2(@dt1 as datetime,@dt2 as datetime)                        
as                        
set nocount on            
/*declare @dt1 as varchar(20)  
declare @dt2 as varchar(20)  
declare @sb as varchar(20)  
  
set @dt1 = 'Jul  1 2009'  
set @dt2 = 'Jul  3 2009'  
set @sb = 'HO'*/             
                    
select distinct space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],                
space(100) as 'OldClname' ,space(20) as 'NewBranch',space(20) as 'NewSB',                
NewClcd=[new client],space(100) as 'NewClname',                    
Terminal_no=[TWS NO],orderid=[order id],upd_date,sum(Quantity)Quantity,sum([RATE (Rs#)])Rate  
into #AA1  
from terminal_chng  
where upd_date>=@dt1+' 00:00:00' and upd_date<=@dt2+' 23:59:59'  
group by  [old client],[new client],[TWS NO],[order id],upd_date  
  
  
Update #AA1 Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name                 
from intranet.risk.dbo.client_details where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                         
  
  
Update #AA1 Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name from                 
intranet.risk.dbo.client_details where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                         
   

Select distinct upd_date as Date,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,orderid   
,Quantity,Rate  
from #AA1
order by NewBranch

/*
select b.reg_code,a.*   from                 
(Select distinct upd_date,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,orderid   
,Quantity,Rate  
from #AA1)a
 left outer join             
(select code,reg_code from intranet.risk.dbo.region)b
on a.NewBranch=b.code order by b.reg_code
*/
--SELECT * FROM #AA where Newsb='BM'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_allbranch_bsecls2_New
-- --------------------------------------------------
CREATE procedure usp_allbranch_bsecls2_New                
as                
                
/*select distinct space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],                                  
space(100) as 'OldClname' ,space(20) as 'NewBranch',space(20) as 'NewSB',                                  
NewClcd=[new client],space(100) as 'NewClname',                                      
Terminal_no=[TWS NO],orderid=[order id],upd_date,sum(Quantity)Quantity,sum([RATE (Rs#)])Rate                    
into #temp                    
from terminal_chng                    
where upd_date>=convert(datetime,convert(varchar(11),getdate()-1),103) and                
upd_date<=convert(datetime,convert(varchar(11),getdate()-1),103)+' 23:59:59.000'                    
group by  [old client],[new client],[TWS NO],[order id],upd_date           */      
     
declare @number int    
if datename(dw,getdate())='Monday'      
set @number=3    
else    
set @number=1               
      
select  space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],                                  
space(100) as 'OldClname' ,space(20) as 'NewBranch',space(20) as 'NewSB',                                  
NewClcd=[new client],space(100) as 'NewClname',                                      
Terminal_no=[TWS NO],orderid=[order id],upd_date,Quantity,([RATE (Rs#)])Rate       
into #temp                    
from terminal_chng                    
where upd_date>=convert(datetime,convert(varchar(11),getdate()-@number),103) and                
upd_date<=convert(datetime,convert(varchar(11),getdate()-@number),103)+' 23:59:59.000'           
      
Update #temp Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name                                   
from intranet.risk.dbo.client_details where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                                           
                    
                    
Update #temp Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name from                   
intranet.risk.dbo.client_details where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                
                
truncate table tbl_consolitated_report                
insert into tbl_consolitated_report values('Date','Old Branch','Old SubBroker','Old ClientCode','Old ClientName','New Branch','New SubBroker','New ClientCode','New ClientName','Terminal No','Order Id','Quantity','Rate')                
insert into tbl_consolitated_report               
select upd_date as Date,OldBranch,OldSB,OLDClcd,OldClname,NewBranch,NewSB,NewCLcd,NewClname,Terminal_no,orderid as orderid,Quantity,Rate                    
from #temp  order by NewBranch                
              
declare @s as varchar(1000),@s1 as varchar(1000),@file as varchar(50)                                
                                
set @file = (select 'Consolidated_Report_'+replace(convert(varchar(11),getdate()-1,3),'/','')+'.xls')                                             
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from MIS.bse.dbo.tbl_consolitated_report" queryout '+'\\196.1.115.136\d$\upload1\Consolidated\'+@file+'.xls -c -Sintranet -Usa -Pnirwan612'                                                     
  
    
      
        
set @s1= @s+''''                                                                          
exec(@s1)                
                
declare @attach as varchar(500)                                                                     
--set @attach='\\196.1.115.136\D$\upload1\Consolidated\'+@file+';'         
set @attach='\\196.1.115.136\D$\upload1\Consolidated\'+@file+'.xls;'                
                
                
declare @mess as varchar(8000)                                        
set @mess= 'Dear Sir,      
<br>      
<br>      
Please find attached consolidated trade changes report during the post closing time.      
<br>      
<br>      
<br>      
<br>      
      
Thanks & Regards,<br>      
Kamlesh Gaikwad<br>      
Operations Executive<br>      
Akruti (CSO)<br>      
kamleshn.gaikwad@angeltrade.com      
      
'           
                  
exec mis.master.dbo.xp_smtp_sendmail                 
@TO = 'Deepak.Redekar@angeltrade.com',         
@cc='santanu.syam@angeltrade.com;Krishnamoorthy@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com;Rahul Bhanushali@angeltrade.com;RamkrishnaP.Shukla@angeltrade.com ',                       
@bcc = 'KamleshN.Gaikwad@angeltrade.com',
@from ='KamleshN.Gaikwad@angeltrade.com',                                                        
@type='text/html',                                                                                  
@subject = 'Trade Changes Consolidated Report',                                                    
@attachments = @attach,                                                                                               
@server = 'angelmail.angelbroking.com',                                                                                          
@message = @mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_bse_error_report_insert
-- --------------------------------------------------
create proc Usp_bse_error_report_insert  
(  
@termid as varchar(25),  
@remark as varchar(500),  
@saudate as varchar(25)  
)  
as   
  
insert into bse_error_report (termid,remark,sauda_date)  
values(@termid,@remark,convert(datetime,@saudate,103))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_bse_error_report_temp_ViewedLast
-- --------------------------------------------------
CREATE proc usp_bse_error_report_temp_ViewedLast    
(    
@saudadate as varchar(25)    
)    
as    
declare @count int     
set @count = (select count(*) from bse_error_report where sauda_date = convert(datetime,@saudadate,103))    
    
if @count = 0    
insert into bse_error_report(party_code,remark,sauda_date)Values('Viewed Last:',getdate(),convert(datetime,@saudadate,103))    
else    
update bse_error_report set remark = getdate() where sauda_date = convert(datetime,@saudadate,103)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_OFS_Upload
-- --------------------------------------------------
CREATE proc USP_BSE_OFS_Upload    
as    
declare @file as varchar(100)    
declare @path as varchar(100)    
declare @sql as varchar(500)    
    
set @file = 'OFS'+left(replace(convert(varchar(11),getdate(),103),'/',''),4) + substring(right(replace(convert(varchar(11),getdate(),103),'/',''),4),3,2)+'.csv'                             
--set @path = '\\196.1.115.136\d$\bse\cashtrd\'+@file                            
set @path = '\\INHOUSELIVEAPP1-FS.angelone.in\d\bse\cashofs\'+@file      
                          
                            
truncate table bsecashOFS                            
                            
set @sql = 'BULK INSERT bsecashOFS FROM '''+@path+''' WITH (FIELDTERMINATOR=''|'',FIRSTROW=1,KEEPNULLS)'    
/*set @sql = 'BULK  
INSERT bsecashOFS  
FROM '''+@path+'''  
WITH  
(  
FIELDTERMINATOR = '','',  
ROWTERMINATOR = ''\n''  
)'  */                          
exec(@sql)  
--print @sql

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_OFS_Upload_08jan2021
-- --------------------------------------------------
CREATE proc USP_BSE_OFS_Upload_08jan2021  
as  
declare @file as varchar(100)  
declare @path as varchar(100)  
declare @sql as varchar(500)  
  
set @file = 'OFS'+left(replace(convert(varchar(11),getdate(),103),'/',''),4) + substring(right(replace(convert(varchar(11),getdate(),103),'/',''),4),3,2)+'.csv'                           
--set @path = '\\196.1.115.136\d$\bse\cashtrd\'+@file                          
set @path = '\\196.1.115.183\d$\bse\cashofs\'+@file    
                        
                          
truncate table bsecashOFS                          
                          
set @sql = 'BULK INSERT bsecashOFS FROM '''+@path+''' WITH (FIELDTERMINATOR=''|'',FIRSTROW=1,KEEPNULLS)'  
/*set @sql = 'BULK
INSERT bsecashOFS
FROM '''+@path+'''
WITH
(
FIELDTERMINATOR = '','',
ROWTERMINATOR = ''\n''
)'  */                        
exec(@sql)
--print @sql

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_bse_survelliance
-- --------------------------------------------------
CREATE proc usp_bse_survelliance
(
@fdate varchar(11),
@todate varchar(11)
)
as

--declare @fdate varchar(11),@todate varchar(11)
--set @fdate = '01/01/2010'
--set @todate = '05/01/2010'


select space(100) as 'Old_RegionName',space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],                                                                
space(100) as 'OldClname',space(500) as 'Old_Address',space(50) as 'Old_ActiveDate',space(50) as 'Old_Inactivedate',space(100) as 'NewRegion',                        
 space(20) as 'NewBranch',space(20) as 'NewSB',                                                                
NewClcd=[new client],space(100) as 'NewClname',space(500) as 'NewAddress', space(50) as 'New_ActiveDate',space(50) as 'New_Inactivedate' ,                                                                 
Terminal_no=[TWS NO],orderid=[order id],Scriptcode = [scrip code],[BUY/SELL],
upd_date,Quantity,([RATE (Rs#)])Rate,space(50) Amount                                    
into #temp                                                  
from terminal_chng                                                  
where upd_date>=convert(datetime,convert(varchar(11),@fdate),103) and                                              
upd_date<=convert(datetime,convert(varchar(11),@todate),103)+' 23:59:59.000'       


Update #temp Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name,                        
old_regionname = region,                        
old_Address =  l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,                        
old_activedate = First_active_date ,old_Inactivedate = last_inactive_date                                                                   
from intranet.risk.dbo.client_details where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                                                                         
                                                  
Update #temp Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name,                        
NewRegion = region,                        
NewAddress =  l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,                        
New_ActiveDate = First_active_date ,New_Inactivedate = last_inactive_date                         
from                                                 
intranet.risk.dbo.client_details where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                     
                    
select convert(varchar(11),upd_date,103) as [DATE],Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,Old_Address,                        
convert(varchar(11),Old_ActiveDate,103) as Old_ActiveDate,convert(varchar(11),Old_Inactivedate,103) as Old_Inactivedate ,NewRegion,NewBranch,NewSB,                        
NewClcd,NewClname,NewAddress,convert(varchar(11),New_ActiveDate,103) as New_ActiveDate,convert(varchar(11),New_Inactivedate,103) as New_Inactivedate ,                        
Terminal_no,orderid,Scriptcode,[Buy/Sell],Quantity,Rate,Amount = quantity * rate  into #temp1 from #temp 


truncate table tbl_BSE_Survelliance_report
truncate table tbl_BSE_Survelliance_profitreport

insert into tbl_BSE_Survelliance_report
select * from 
(
select *,
case when oldbranch = '' then 'Wrong code'
when oldclname = newclname then 'Same Name'
when oldclcd = newclcd then 'same client code' 
else 'diff client code'
end as status
 from #temp1 
) a 
where a.status <> 'diff client code' 
order by status




insert into tbl_BSE_Survelliance_profitreport
select * from 
(
select *,
case when oldbranch = '' then 'Wrong code'
when oldclname = newclname then 'Same Name'
when oldclcd = newclcd then 'same client code' 
else 'diff client code'
end as status
 from #temp1 
) a  
where a.status = 'diff client code' 
order by status

declare @c as varchar(1000),@c1 as varchar(1000),@file1 as varchar(100) 
set @file1 = (select 'Survelliance_WrongReport.xls')                                                                             
set @c = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from mis.bse.dbo.tbl_BSE_Survelliance_report" queryout '+'\\196.1.115.175\d$\upload1\Consolidated\'+@file1+' -c -Sintranet -Usa -Pnirwan612'                                      
set @c1= @c+''''                                                                                                        
exec(@c1)                                  


declare @s as varchar(1000),@s1 as varchar(1000),@file as varchar(100)                               
set @file = (select 'Survelliance_ProfitReport.xls')                                                                               
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from mis.bse.dbo.tbl_BSE_Survelliance_profitreport" queryout '+'\\196.1.115.175\d$\upload1\Consolidated\'+@file+' -c -Sintranet -Usa -Pnirwan612'                                      
set @s1= @s+''''                                                                                                          
exec(@s1)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_Trade_Upload
-- --------------------------------------------------
CREATE proc USP_BSE_Trade_Upload                              
      
as                              
                              
declare @file as varchar(100)                              
declare @path as varchar(100)                              
declare @sql as varchar(500)         
    
--Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'    
                              
set @file = 'BR'+left(replace(convert(varchar(11),getdate(),103),'/',''),4) + substring(right(replace(convert(varchar(11),getdate(),103),'/',''),4),3,2)+'.DAT'                               
--set @path = '\\196.1.115.136\d$\bse\cashtrd\'+@file                              
set @path = '\\INHOUSELIVEAPP1-FS.angelone.in\d\bse\cashtrd\'+@file                              
                              
truncate table bsecashtrd_MIS                              
                              
set @sql = 'BULK INSERT bsecashtrd_mis FROM '''+@path+''' WITH (FIELDTERMINATOR=''|'',FIRSTROW=1,KEEPNULLS)'                              
--print @sql       
exec(@sql)                                
                          
truncate table bsecashtrd                              
      
      
INSERT INTO bsecashtrd       
SELECT * FROM bsecashtrd_MIS (nolock)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_Trade_Upload_15Apr2020
-- --------------------------------------------------
CREATE proc USP_BSE_Trade_Upload_15Apr2020                        

as                        
                        
declare @file as varchar(100)                        
declare @path as varchar(100)                        
declare @sql as varchar(500)                        
                        
set @file = 'BR'+left(replace(convert(varchar(11),getdate(),103),'/',''),4) + substring(right(replace(convert(varchar(11),getdate(),103),'/',''),4),3,2)+'.DAT'                         
--set @path = '\\196.1.115.136\d$\bse\cashtrd\'+@file                        
set @path = '\\196.1.115.183\d$\bse\cashtrd\'+@file                        
                        
truncate table bsecashtrd_MIS                        
                        
set @sql = 'BULK INSERT bsecashtrd_mis FROM '''+@path+''' WITH (FIELDTERMINATOR=''|'',FIRSTROW=1,KEEPNULLS)'                        
--print @sql 
exec(@sql)                          
                    
truncate table bsecashtrd                        


INSERT INTO bsecashtrd 
SELECT * FROM bsecashtrd_MIS (nolock)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_Trade_Upload_26apr2023
-- --------------------------------------------------
CREATE proc USP_BSE_Trade_Upload_26apr2023                          
  
as                          
                          
declare @file as varchar(100)                          
declare @path as varchar(100)                          
declare @sql as varchar(500)                          
                          
set @file = 'BR'+left(replace(convert(varchar(11),getdate(),103),'/',''),4) + substring(right(replace(convert(varchar(11),getdate(),103),'/',''),4),3,2)+'.DAT'                           
--set @path = '\\196.1.115.136\d$\bse\cashtrd\'+@file                          
set @path = '\\196.1.115.147\d\bse\cashtrd\'+@file                          
                          
truncate table bsecashtrd_MIS                          
                          
set @sql = 'BULK INSERT bsecashtrd_mis FROM '''+@path+''' WITH (FIELDTERMINATOR=''|'',FIRSTROW=1,KEEPNULLS)'                          
--print @sql   
exec(@sql)                            
                      
truncate table bsecashtrd                          
  
  
INSERT INTO bsecashtrd   
SELECT * FROM bsecashtrd_MIS (nolock)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_bsecashOFS_bannedscript
-- --------------------------------------------------
CREATE proc usp_bsecashOFS_bannedscript  
  
as  
set nocount on  
  
select panno,pan_gir_no,party_code,branch_cd,sub_broker,long_name,region into #temp from Banned_script_pano a inner join  intranet.risk.dbo.client_details b  
on a.panno = b.pan_gir_no  
  
select a.*  from   
(select party_code as clientcode,branch_cd,sub_broker,long_name,region from #temp (nolock) )a  
inner join  
(select * from bsecashOFS (nolock))b  
on a.clientcode = b.party_code 
--and sauda_date =  convert(datetime,convert(varchar(11),getdate()))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_bsecashtrd_bannedscript
-- --------------------------------------------------
CREATE proc usp_bsecashtrd_bannedscript  
  
as  
set nocount on  
  
select panno,pan_gir_no,party_code,branch_cd,sub_broker,long_name,region into #temp from Banned_script_pano a inner join  intranet.risk.dbo.client_details b  
on a.panno = b.pan_gir_no  
  
select a.*,termid,tradeqty,sell_buy  from   
(select party_code as clientcode,branch_cd,sub_broker,long_name,region from #temp (nolock) )a  
inner join  
(select * from bsecashtrd (nolock))b  
on a.clientcode = b.party_code where b.scrip_cd = '532166'  
and sauda_date =  convert(datetime,convert(varchar(11),getdate()))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMisMatch_InactiveFrom
-- --------------------------------------------------
CREATE proc [dbo].[Usp_BseMisMatch_InactiveFrom]
as 
insert into tbsetable 
select party_code,long_name,activefrom,inactivefrom,convert(datetime ,getdate(),103)from 
AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5 where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code 
and convert(datetime ,c5.inactivefrom ,103) < convert(datetime ,getdate(),103)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMismatch_InTrans
-- --------------------------------------------------
create proc Usp_BseMismatch_InTrans
(
@party_code as varchar(25),
@termid as varchar
)
as 

select distinct a.*,b.tradeqty,b.symbol,b.party_code from
(select termid,branch_cd,branch_name,sub_broker  from bse_termid )a
left outer join
(select tradeqty,symbol,party_code,termid from bsecashtrd )b
on a.termid = b.termid where b.party_code = @party_code and a.termid = @termid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMismatch1
-- --------------------------------------------------
CREATE Proc Usp_BseMismatch1 @Date Varchar(20)
As

Set Nocount on

If Not Exists(Select Top 1 Sauda_date from bsecashtrd(nolock) where Sauda_date >= 'oct 13 2008') 
	Delete from bse_error_report where sauda_date >= 'oct 13 2008' 
Else
	Select party_code,pcode_branch_cd,pcode_sub_broker,termid,termid_branch_cd,termid_sub_broker,termid_branch_cd_alt,termid_sub_broker_alt from bse_error_report(nolock) where sauda_date >= 'oct 13 2008' 

Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMismatch2
-- --------------------------------------------------
CREATE Proc [dbo].[Usp_BseMismatch2]
As

Truncate Table tbsetable

Insert into tbsetable 
Select party_code,long_name,activefrom,inactivefrom,convert(datetime ,getdate(),103) from
AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5
Where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and convert(datetime ,c5.inactivefrom ,103) < convert(datetime ,getdate(),103)

Exec Chk_Missing_cli

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMismatch3
-- --------------------------------------------------
Create Proc Usp_BseMismatch3
As

Select termid,party_code,symbol,tradeqty from bsecashtrd(nolock) where pro_cli not in 
('CLIENT','NRI') and tradeqty in (select max(tradeqty) from bsecashtrd(nolock) where pro_cli not in 
('CLIENT','NRI') group by termid)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMismatch4
-- --------------------------------------------------
Create Proc Usp_BseMismatch4
As
Set Transaction Isolation Level Read Uncommitted

SELECT DISTINCT SCRIP_cD,SYMBOL FROM bsecashtrd(nolock)
WHERE SCRIP_CD NOT IN (SELECT BSECODE FROM bse_SCRIP2(nolock))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BseMismatch5
-- --------------------------------------------------
Create Proc Usp_BseMismatch5
As
Set Transaction Isolation level Read uncommitted

Select distinct convert(int,trd.termid) from bsecashtrd trd(nolock)
where trd.termid not in
(Select distinct termid from bse_termid(nolock) where status='ACTIVE' and segment='BSE CASH'
union  Select userid from termparty(nolock)) order by convert(int,trd.termid)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Client_Trd
-- --------------------------------------------------
CREATE Proc USP_Client_Trd(@cltcode varchar(50))  
as    

select 
case when isnull(x.termid,'') = '' then y.termid else x.termid end as termid,  
case when isnull(x.scrip_cd,'') = '' then y.scrip_cd else x.scrip_cd end as Scrip_cd,  
case when isnull(x.symbol,'') = '' then y.symbol else x.symbol end as symbol,  
isnull(x.buy,0) as BUY ,isnull(y.sell,0) as SELL from 
(
(select party_code,termid,Scrip_cd,Symbol,sum(tradeqty) as BUY from bsecashtrd (nolock)  
where party_code = @cltcode and Sell_buy = 'B'  group by Scrip_cd,Symbol,termid,party_code)x
full outer join
(select party_code,termid,Scrip_cd,Symbol,sum(tradeqty) as SELL from bsecashtrd (nolock)  
where party_code = @cltcode and Sell_buy = 'S'  group by Scrip_cd,Symbol,termid,party_code) y 
on x.party_code = y.party_code and x.termid = y.termid and x.scrip_cd = y.scrip_cd
) order by symbol,termid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_consolidate_Report
-- --------------------------------------------------
CREATE procedure [dbo].[usp_consolidate_Report]    
as    
    
DECLARE @rc INT    
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues    
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp    
    
declare @number int,@cnt int    
set @cnt=0    
if datename(dw,getdate())='Monday'    
set @number=3    
else    
set @number=1    
    
select @cnt=COUNT(hdate) from [MIDDLEWARE].harmony.dbo.HOLIMST with(nolock) where convert(varchar(11),hdate,103) =convert(varchar(11),GETDATE()-@number,103)    
if @cnt=1    
set @number=@number+1    
--select @number    
    
select space(100) as 'Old_RegionName',space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],    
space(100) as 'OldClname',space(500) as 'Old_Address',space(50) as 'Old_ActiveDate',space(50) as 'Old_Inactivedate',space(100) as 'NewRegion',    
space(20) as 'NewBranch',space(20) as 'NewSB',    
NewClcd=[new client],space(100) as 'NewClname',space(500) as 'NewAddress', space(50) as 'New_ActiveDate',space(50) as 'New_Inactivedate' ,    
Terminal_no=[TWS NO],orderid=[order id],Scriptcode = [scrip code],[BUY/SELL],upd_date,Quantity,([RATE (Rs#)])Rate,space(50) Amount    
into #temp    
from terminal_chng    
where upd_date>=convert(datetime,convert(varchar(11),getdate()-@number),103) and    
upd_date<=convert(datetime,convert(varchar(11),getdate()-@number),103)+' 23:59:59.000'    
    
Update #temp Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name,    
old_regionname = region,    
old_Address = l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,    
old_activedate = First_active_date ,old_Inactivedate = last_inactive_date    
from intranet.risk.dbo.client_details where oldclcd = party_code collate SQL_Latin1_General_CP1_CI_AS    
    
Update #temp Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name,    
NewRegion = region,    
NewAddress = l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,    
New_ActiveDate = First_active_date ,New_Inactivedate = last_inactive_date    
from    
intranet.risk.dbo.client_details where newclcd = party_code collate SQL_Latin1_General_CP1_CI_AS    
    
select convert(varchar(11),upd_date,103) as [DATE],Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,Old_Address,    
convert(varchar(11),Old_ActiveDate,103) as Old_ActiveDate,convert(varchar(11),Old_Inactivedate,103) as Old_Inactivedate ,NewRegion,NewBranch,NewSB,    
NewClcd,NewClname,NewAddress,convert(varchar(11),New_ActiveDate,103) as New_ActiveDate,convert(varchar(11),New_Inactivedate,103) as New_Inactivedate ,    
Terminal_no,orderid,Scriptcode,[Buy/Sell],Quantity,Rate,Amount = quantity * rate into #temp1 from #temp    
    
select newbranch as BranchName,Orderid=count([orderid]),Percentage=convert(varchar,convert(decimal(10,2),convert(decimal(10,2),(count([orderid]))*100)/convert(decimal(10,2),    
(Select count=count(newbranch) from #temp))))+'%'    
into #test from #temp    
group by newbranch order by Orderid desc    
    
    
truncate table tbl_consolitated_report    
insert into tbl_consolitated_report values('Date','Old Region','Old Branch','Old SubBroker','Old ClientCode','Old ClientName','Old Address','Old Active Date','Old Inactive Date','New Region','New Branch','New SubBroker','New ClientCode','New ClientName', 
  
   
'New Address','New Active Date','New Inactive Date','Terminal No',convert(varchar(50),'Order Id'),'Script Code','Buy/Sell','Quantity','Rate','Amount')    
insert into tbl_consolitated_report    
select [DATE],Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,Old_Address,    
Old_ActiveDate,Old_Inactivedate,NewRegion,NewBranch,NewSB,NewClcd,NewClname,    
NewAddress,New_ActiveDate,New_Inactivedate,Terminal_no,+''''+convert(varchar,convert(float,orderid)) orderid ,Scriptcode,[Buy/Sell],    
Quantity,Rate,Amount from #temp1    
    
truncate table tbl_consolidated_percentage    
insert into tbl_consolidated_percentage values('Branch','Count','Percentage')    
insert into tbl_consolidated_percentage    
select * from #test    
    
declare @s as varchar(1000),@s1 as varchar(1000),@file as varchar(100)    
set @file = (select 'Consolidated_Report_Per_'+replace(convert(varchar(11),getdate()-@number,3),'/','')+'.xls')    
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "select * from MIS.bse.dbo.tbl_consolidated_percentage" queryout '+'\\196.1.115.183\d$\upload1\Consolidated_per\'+@file+' -c -Sintranet -Usa -Pnirwan612'    
set @s1= @s+''''    
exec(@s1)    
    
declare @c as varchar(1000),@c1 as varchar(1000),@file1 as varchar(100)    
set @file1 = (select 'Consolidated_Report_'+replace(convert(varchar(11),getdate()-@number,3),'/','')+'.xls')    
set @c = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "select * from MIS.bse.dbo.tbl_consolitated_report" queryout '+'\\196.1.115.183\d$\upload1\Consolidated\'+@file1+' -c -Sintranet -Usa -Pnirwan612'    
set @c1= @c+''''    
exec(@c1)    
    
declare @attach as varchar(500) ,@attach1 as varchar(500), @attach2 as varchar(500)    
--set @attach='\\196.1.115.136\D$\upload1\Consolidated\'+@file+';'    
set @attach='\\196.1.115.183\D$\upload1\Consolidated_per\'+@file    
set @attach1='\\196.1.115.183\D$\upload1\Consolidated\'+@file1    
set @attach2 = @attach + ';' + @attach1    
    
declare @mess as varchar(8000)    
set @mess= 'Dear Sir,    
<br>    
<br>    
Please find attached consolidated trade changes report during the post closing time.    
<br>    
<br>    
<br>    
<br>    
    
Thanks & Regards,<br>    
Prabodh Salvi-Operations<br>    
Contact No - 28358800 Ext -214 <br>    
Akruti (CSO)<br>    
Mumbai.'    
    
declare @rec int    
set @rec = (select count(*) from tbl_consolidated_percentage (nolock))    
if( @rec > 1)    
begin    
exec intranet.msdb.dbo.sp_send_dbmail    
@recipients = 'Deepak.Redekar@angeltrade.com;dilipkumar.shukla@angelbroking.com',    
--@recipients = 'jagdish.kolhapure@angeltrade.com;Atulb.divekar@angeltrade.com',    
@copy_recipients ='santanu.syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com;Rahul Bhanushali@angeltrade.com;bhavin@angelbroking.com;Sanjay.Ghosh@angeltrade.com;Sabyasachi.Sikdar@angeltrade.com;InternalAuditor@angeltrade.com;anil.ranka@angelbroking.com',    
@blind_copy_recipients = 'KamleshN.Gaikwad@angeltrade.com;renil.pillai@angeltrade.com;Prabodh@angeltrade.com',    
@profile_name = 'intranet',    
--@from ='KamleshN.Gaikwad@angeltrade.com',    
@body_format ='html',    
@subject = 'Trade Changes Consolidated Report',    
--@file_attachments = '\\196.1.115.136\D$\upload1\Consolidated_per\Consolidated_Report_Per_010909.xls ;\\196.1.115.136\D$\upload1\Consolidated\Consolidated_Report_010909.xls', /*@attach2,*/    
@file_attachments = @attach2 ,    
--@attachments = @attach1,    
@body = @mess    
end    
else    
begin    
    
exec intranet.msdb.dbo.sp_send_dbmail    
@recipients = 'Deepak.Redekar@angeltrade.com;KamleshN.Gaikwad@angeltrade.com;Prabodh@angeltrade.com;dilipkumar.shukla@angelbroking.com',    
@blind_copy_recipients = 'renil.pillai@angeltrade.com',    
/*--@recipients = 'jagdish.kolhapure@angeltrade.com;Atulb.divekar@angeltrade.com',    
--@copy_recipients ='santanu.syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com;Rahul Bhanushali@angeltrade.com;bhavin@angelbroking.com;Sanjay.Ghosh@angeltrade.com;Sabyasachi.Sikdar@angeltrade.com;InternalAuditor@angeltrade.c
  
om',*/    
/*@blind_copy_recipients = 'KamleshN.Gaikwad@angeltrade.com', */    
@profile_name = 'intranet',    
--@from ='KamleshN.Gaikwad@angeltrade.com',    
@body_format ='html',    
@subject = 'Trade Changes Consolidated Report',    
--@file_attachments = '\\196.1.115.136\D$\upload1\Consolidated_per\Consolidated_Report_Per_010909.xls ;\\196.1.115.136\D$\upload1\Consolidated\Consolidated_Report_010909.xls', /*@attach2,*/    
--@file_attachments = @attach2 ,    
--@attachments = @attach1,    
@body = 'File Not Generated'    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_consolidate_Report_BackSandy
-- --------------------------------------------------
CREATE procedure usp_consolidate_Report_BackSandy      
as      
      
DECLARE @rc INT      
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues      
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)      
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp      
      
declare @number int,@cnt int      
set @cnt=0      
if datename(dw,getdate())='Monday'      
set @number=3      
else      
set @number=1      
      
select @cnt=COUNT(hdate) from [MIDDLEWARE].harmony.dbo.HOLIMST with(nolock) where convert(varchar(11),hdate,103) =convert(varchar(11),GETDATE()-@number,103)      
if @cnt=1      
set @number=@number+1      
--select @number      
      
select space(100) as 'Old_RegionName',space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],      
space(100) as 'OldClname',space(500) as 'Old_Address',space(50) as 'Old_ActiveDate',space(50) as 'Old_Inactivedate',space(100) as 'NewRegion',      
space(20) as 'NewBranch',space(20) as 'NewSB',      
NewClcd=[new client],space(100) as 'NewClname',space(500) as 'NewAddress', space(50) as 'New_ActiveDate',space(50) as 'New_Inactivedate' ,      
Terminal_no=[TWS NO],orderid=[order id],Scriptcode = [scrip code],[BUY/SELL],upd_date,Quantity,([RATE (Rs#)])Rate,space(50) Amount      
into #temp      
from terminal_chng      
where upd_date>=convert(datetime,convert(varchar(11),getdate()-@number),103) and      
upd_date<=convert(datetime,convert(varchar(11),getdate()-@number),103)+' 23:59:59.000'      
      
Update #temp Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name,      
old_regionname = region,      
old_Address = l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,      
old_activedate = First_active_date ,old_Inactivedate = last_inactive_date      
from intranet.risk.dbo.client_details where oldclcd = party_code collate SQL_Latin1_General_CP1_CI_AS      
      
Update #temp Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name,      
NewRegion = region,      
NewAddress = l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,      
New_ActiveDate = First_active_date ,New_Inactivedate = last_inactive_date      
from      
intranet.risk.dbo.client_details where newclcd = party_code collate SQL_Latin1_General_CP1_CI_AS      
      
select convert(varchar(11),upd_date,103) as [DATE],Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,Old_Address,      
convert(varchar(11),Old_ActiveDate,103) as Old_ActiveDate,convert(varchar(11),Old_Inactivedate,103) as Old_Inactivedate ,NewRegion,NewBranch,NewSB,      
NewClcd,NewClname,NewAddress,convert(varchar(11),New_ActiveDate,103) as New_ActiveDate,convert(varchar(11),New_Inactivedate,103) as New_Inactivedate ,      
Terminal_no,orderid,Scriptcode,[Buy/Sell],Quantity,Rate,Amount = quantity * rate into #temp1 from #temp      
      
select newbranch as BranchName,Orderid=count([orderid]),Percentage=convert(varchar,convert(decimal(10,2),convert(decimal(10,2),(count([orderid]))*100)/convert(decimal(10,2),      
(Select count=count(newbranch) from #temp))))+'%'      
into #test from #temp      
group by newbranch order by Orderid desc      
      
      
truncate table tbl_consolitated_report      
insert into tbl_consolitated_report values('Date','Old Region','Old Branch','Old SubBroker','Old ClientCode','Old ClientName','Old Address','Old Active Date','Old Inactive Date','New Region','New Branch','New SubBroker','New ClientCode','New ClientName', 
  
    
     
'New Address','New Active Date','New Inactive Date','Terminal No',convert(varchar(50),'Order Id'),'Script Code','Buy/Sell','Quantity','Rate','Amount')      
insert into tbl_consolitated_report      
select [DATE],Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,Old_Address,      
Old_ActiveDate,Old_Inactivedate,NewRegion,NewBranch,NewSB,NewClcd,NewClname,      
NewAddress,New_ActiveDate,New_Inactivedate,Terminal_no,+''''+convert(varchar,convert(numeric,orderid)) orderid ,Scriptcode,[Buy/Sell],      
Quantity,Rate,Amount from #temp1      
      
truncate table tbl_consolidated_percentage      
insert into tbl_consolidated_percentage values('Branch','Count','Percentage')      
insert into tbl_consolidated_percentage      
select * from #test      
      
declare @s as varchar(1000),@s1 as varchar(1000),@file as varchar(100)      
set @file = (select 'Consolidated_Report_Per_'+replace(convert(varchar(11),getdate()-@number,3),'/','')+'.xls')      
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "select * from MIS.bse.dbo.tbl_consolidated_percentage" queryout '+'\\196.1.115.183\d$\upload1\Consolidated_per\'+@file+' -c -Sintranet -Usa -Pnirwan612'      
set @s1= @s+''''      
exec(@s1)      
      
declare @c as varchar(1000),@c1 as varchar(1000),@file1 as varchar(100)      
set @file1 = (select 'Consolidated_Report_'+replace(convert(varchar(11),getdate()-@number,3),'/','')+'.xls')      
set @c = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "select * from MIS.bse.dbo.tbl_consolitated_report" queryout '+'\\196.1.115.183\d$\upload1\Consolidated\'+@file1+' -c -Sintranet -Usa -Pnirwan612'      
set @c1= @c+''''      
exec(@c1)      
      
declare @attach as varchar(500) ,@attach1 as varchar(500), @attach2 as varchar(500)      
--set @attach='\\196.1.115.136\D$\upload1\Consolidated\'+@file+';'      
set @attach='\\196.1.115.183\D$\upload1\Consolidated_per\'+@file      
set @attach1='\\196.1.115.183\D$\upload1\Consolidated\'+@file1      
set @attach2 = @attach + ';' + @attach1      
      
declare @mess as varchar(8000)      
set @mess= 'Dear Sir,      
<br>      
<br>      
Please find attached consolidated trade changes report during the post closing time.      
<br>      
<br>      
<br>      
<br>      
      
Thanks & Regards,<br>      
Prabodh Salvi-Operations<br>      
Contact No - 28358800 Ext -214 <br>      
Akruti (CSO)<br>      
Mumbai.'      
      
declare @rec int      
set @rec = (select count(*) from tbl_consolidated_percentage (nolock))      
if( @rec > 1)      
begin      
exec intranet.msdb.dbo.sp_send_dbmail      
@recipients = 'sandeep.rai@angelbroking.com',      
--@recipients = 'jagdish.kolhapure@angeltrade.com;Atulb.divekar@angeltrade.com',      
--@copy_recipients ='santanu.syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com;Rahul Bhanushali@angeltrade.com;bhavin@angelbroking.com;Sanjay.Ghosh@angeltrade.com;Sabyasachi.Sikdar@angeltrade.com;InternalAuditor@angeltrade.com
--;anil.ranka@angelbroking.com',      
@blind_copy_recipients = 'renil.pillai@angeltrade.com',      
@profile_name = 'intranet',      
--@from ='KamleshN.Gaikwad@angeltrade.com',      
@body_format ='html',      
@subject = 'Trade Changes Consolidated Report',      
--@file_attachments = '\\196.1.115.136\D$\upload1\Consolidated_per\Consolidated_Report_Per_010909.xls ;\\196.1.115.136\D$\upload1\Consolidated\Consolidated_Report_010909.xls', /*@attach2,*/      
@file_attachments = @attach2 ,      
--@attachments = @attach1,      
@body = @mess      


print 'Sucess'
end      
else      
begin      
      
exec intranet.msdb.dbo.sp_send_dbmail      
@recipients = 'sandeep.rai@angelbroking.com',      
@blind_copy_recipients = 'renil.pillai@angeltrade.com',      
/*--@recipients = 'jagdish.kolhapure@angeltrade.com;Atulb.divekar@angeltrade.com',      
--@copy_recipients ='santanu.syam@angeltrade.com;Manisha.Kapoor@angeltrade.com;Muthuswamy.Iyer@angeltrade.com;Rahul Bhanushali@angeltrade.com;bhavin@angelbroking.com;Sanjay.Ghosh@angeltrade.com;Sabyasachi.Sikdar@angeltrade.com;InternalAuditor@angeltrade.c
  
    
om',*/      
/*@blind_copy_recipients = 'KamleshN.Gaikwad@angeltrade.com', */      
@profile_name = 'intranet',      
--@from ='KamleshN.Gaikwad@angeltrade.com',      
@body_format ='html',      
@subject = 'Trade Changes Consolidated Report',      
--@file_attachments = '\\196.1.115.136\D$\upload1\Consolidated_per\Consolidated_Report_Per_010909.xls ;\\196.1.115.136\D$\upload1\Consolidated\Consolidated_Report_010909.xls', /*@attach2,*/      
--@file_attachments = @attach2 ,      
--@attachments = @attach1,      
@body = 'File Not Generated'      
print 'fail'      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DORMANTCLIENTS
-- --------------------------------------------------
  
--USP_DORMANTCLIENTS'NSEFO1'    
    
CREATE PROC USP_DORMANTCLIENTS (@FLAG VARCHAR(7))      
AS      
      
      
BEGIN      
      
SET NOCOUNT ON      
      
    IF @FLAG='BSE'      
    BEGIN      
          
        SELECT DISTINCT A.PARTY_CODE,A.TERMID,BRANCH_CD,BRANCH_NAME,SUB_BROKER,SYMBOL,TRADEQTY       
        FROM BSECASHTRD A      
        INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        LEFT OUTER JOIN BSE_TERMID C WITH(NOLOCK)      
        ON A.TERMID = C.TERMID       
        WHERE B.EXCHANGE='BSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE,A.TERMID      
              
    END       
          
    IF @FLAG='NSE'      
    BEGIN      
        SELECT DISTINCT A.PARTY_CODE,'','',''       
        FROM INTRANET.NSE.DBO.NSECASHTRD_ADMIN A      
        INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE      
    END       
          
    IF @FLAG='NSEFO'      
    BEGIN     
       
        SELECT DISTINCT A.PARTY_CODE AS [PARTY CODE],SCRIP_NAME AS [SCRIP NAME],QTY,    
        TERMID,BRANCH_CD AS [BRANCH CODE],BRANCH_NAME AS [BRANCH NAME]     
        FROM FOBKG.DBO.FOMISMATCH A WITH(NOLOCK)      
        INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='FUTURES'      
    END     
    
    IF @FLAG='NSEFO1'      
    BEGIN   
		
		SELECT CL_CODE,BRANCH_CD,SUB_BROKER INTO #C1 
		FROM ANGELFO.NSEFO.DBO.CLIENT1 C1    
		
		SELECT DISTINCT A.PARTY_CODE,C1.BRANCH_CD,C1.SUB_BROKER,A.TERMID,TERM.BRANCH_CD               
		AS 'BRANCH',isnull(TERM.SUB_BROKER,'') AS 'SUBBROKER',isnull(TERM.BRANCH_CD_ALT,'')AS 'ALTBRANCH',
		isnull(TERM.SUB_BROKER_ALT,'') AS 'ALTSUBBROKER'
		FROM PS03.DBO.FOTRD A WITH(NOLOCK)
		INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
		ON A.PARTY_CODE=B.PARTY_CODE 
		LEFT OUTER JOIN #C1 C1
		ON A.PARTY_CODE=C1.CL_CODE 
		LEFT OUTER JOIN PS03.DBO.FO_TERMID_LIST TERM WITH(NOLOCK)
		ON A.TERMID=TERM.TERMID
		WHERE B.EXCHANGE='NSE'AND B.SEGMENT='FUTURES'
		
    END
      
SET NOCOUNT OFF      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DORMANTCLIENTS_OFS
-- --------------------------------------------------
    
--USP_DORMANTCLIENTS'NSEFO1'      
      
CREATE PROC USP_DORMANTCLIENTS_OFS (@FLAG VARCHAR(7))        
AS        
        
        
BEGIN        
        
SET NOCOUNT ON        
        
    IF @FLAG='BSE'        
    BEGIN        
            
        SELECT DISTINCT A.PARTY_CODE         
        FROM bsecashOFS A        
        INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)        
        ON A.PARTY_CODE=B.PARTY_CODE        
        LEFT OUTER JOIN BSE_TERMID C WITH(NOLOCK)        
        ON A.PARTY_CODE = C.PARTY_CODE         
        WHERE B.EXCHANGE='BSE'AND B.SEGMENT='CAPITAL'        
        ORDER BY A.PARTY_CODE      
                
    END         
            
    IF @FLAG='NSE'        
    BEGIN        
        SELECT DISTINCT A.PARTY_CODE,'','',''         
        FROM INTRANET.NSE.DBO.NSECASHTRD_ADMIN A        
        INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)        
        ON A.PARTY_CODE=B.PARTY_CODE        
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'        
        ORDER BY A.PARTY_CODE        
    END         
            
    IF @FLAG='NSEFO'        
    BEGIN       
         
        SELECT DISTINCT A.PARTY_CODE AS [PARTY CODE],SCRIP_NAME AS [SCRIP NAME],QTY,      
        TERMID,BRANCH_CD AS [BRANCH CODE],BRANCH_NAME AS [BRANCH NAME]       
        FROM FOBKG.DBO.FOMISMATCH A WITH(NOLOCK)        
        INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)        
        ON A.PARTY_CODE=B.PARTY_CODE        
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='FUTURES'        
    END       
      
    IF @FLAG='NSEFO1'        
    BEGIN     
    
  SELECT CL_CODE,BRANCH_CD,SUB_BROKER INTO #C1   
  FROM ANGELFO.NSEFO.DBO.CLIENT1 C1      
    
  SELECT DISTINCT A.PARTY_CODE,C1.BRANCH_CD,C1.SUB_BROKER,A.TERMID,TERM.BRANCH_CD                 
  AS 'BRANCH',isnull(TERM.SUB_BROKER,'') AS 'SUBBROKER',isnull(TERM.BRANCH_CD_ALT,'')AS 'ALTBRANCH',  
  isnull(TERM.SUB_BROKER_ALT,'') AS 'ALTSUBBROKER'  
  FROM PS03.DBO.FOTRD A WITH(NOLOCK)  
  INNER JOIN INTRANET.RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)        
  ON A.PARTY_CODE=B.PARTY_CODE   
  LEFT OUTER JOIN #C1 C1  
  ON A.PARTY_CODE=C1.CL_CODE   
  LEFT OUTER JOIN PS03.DBO.FO_TERMID_LIST TERM WITH(NOLOCK)  
  ON A.TERMID=TERM.TERMID  
  WHERE B.EXCHANGE='NSE'AND B.SEGMENT='FUTURES'  
    
    END  
        
SET NOCOUNT OFF        
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Fetch_TotalTrade
-- --------------------------------------------------
CREATE Proc Usp_Fetch_TotalTrade(@Fdate varchar(11),@Tdate varchar(11))
As

Set @Fdate = Convert(Varchar(11),Convert(datetime,@Fdate,103))
Set @Tdate = Convert(Varchar(11),Convert(datetime,@Tdate,103))

Select * from tbl_TotalTrades 
where Fld_Date >= @Fdate and Fld_Date <= @Tdate+' 23:59:59' order by Fld_Date

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
-- PROCEDURE dbo.usp_fo_error_report_temp_ViewedLast
-- --------------------------------------------------
CREATE proc usp_fo_error_report_temp_ViewedLast      
(      
@saudadate as varchar(25)      
)      
as      
declare @count int       
set @count = (select count(*) from bse_error_report where sauda_date = convert(datetime,@saudadate,103))      
      
if @count = 0      
insert into bse_error_report(party_code,remark,sauda_date)Values('Viewed Last:',getdate(),convert(datetime,@saudadate,103))      
else      
update bse_error_report set remark = getdate() where sauda_date = convert(datetime,@saudadate,103)

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
-- PROCEDURE dbo.USP_illiquid_scripupload
-- --------------------------------------------------
CREATE proc USP_illiquid_scripupload                                                     
(                                                                      
@filename as varchar(100),                                                  
@server as varchar(50)        
)                                                                       
as 

declare @path as varchar(100)                                                                      
declare @sql as varchar(1000) 


set @path='\\'+@server+'\d$\Upload1\illiquidscrip\' + @filename  
--set @path='\\196.1.115.175\d$\Upload1\illiquidscrip\' + 'illscrip.xls'  


SET @sql = 'Insert into tbl_illiquidscrip_upload Select scripcode,scripname,fld_date = getdate() FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;DATABASE='+@path+''',''Select * from [sheet1$]'' )'                                                            
--print @sql
exec (@sql)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MismatchClient
-- --------------------------------------------------
--usp_MismatchClient '03/03/2016'

CREATE proc [dbo].[usp_MismatchClient]
@Sauda_Date1 varchar(12)
AS
 
/*Step 1*/ /*********** Report 1 *********/
/*Party Code & Terminal Details Mismatch*/ 
DECLARE @RSDateCnt INT
DECLARE @Sauda_Date as datetime 
--set @Sauda_Date= '2016-03-03 00:00:00.000'
set @Sauda_Date = convert(datetime,@Sauda_Date1)


--select * into #bse_error_report from bse_error_report
--select * into #tbsetable from tbsetable


SET @RSDateCnt=(SELECT TOP 5 count(1) FROM bsecashtrd(NOLOCK) WHERE CONVERT(DATETIME,LEFT(sauda_date,11)) =@Sauda_Date )

IF @RSDateCnt > 0
	BEGIN
		DELETE FROM bse_error_report WHERE sauda_date = @Sauda_Date
		
		SELECT TOP 0 PARTY_CODE,PCODE_BRANCH_CD,PCODE_SUB_BROKER,TERMID,TERMID_BRANCH_CD,TERMID_SUB_BROKER,TERMID_BRANCH_CD_ALT,
		REMARK,SAUDA_DATE FROM bse_error_report(NOLOCK) 
	END
ELSE
	BEGIN
		select PARTY_CODE,PCODE_BRANCH_CD,PCODE_SUB_BROKER,TERMID,TERMID_BRANCH_CD,TERMID_SUB_BROKER,TERMID_BRANCH_CD_ALT,REMARK,SAUDA_DATE 
		from bse_error_report(nolock) 
		where sauda_date = @Sauda_Date order by party_code	
	END

/*Step 1 END*/

/*Step 2*/ /*********** Report 2 *********/
/*WRONG CLIENT TYPE CODE*/
	SELECT [WRONG_CLIENT_TYPE_CODE]= CL_CODE FROM V_INS_Clients
/*Step 2 End*/

/*Step 3*/
/*Party Code & Terminal Details Mismatch heading is created but not  used! */
	 TRUNCATE TABLE tbsetable
	
	 INSERT INTO tbsetable  
	 SELECT party_code,long_name,activefrom,inactivefrom,CONVERT(DATETIME ,GETDATE(),103)
	 FROM   
	 AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5  
	 WHERE c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  
	 and CONVERT(DATETIME ,c5.inactivefrom ,103) < CONVERT(DATETIME ,GETDATE(),103) 
	 
/*Step 3 End*/

/*Step 4*/ /*********** Report 3 *********/
/* NO MISSING/INACTIVE LIST */
	CREATE TABLE #MISSING_CLI_NEW (PARTY_CODE VARCHAR(50),TERMID INT,BRANCH_NAME VARCHAR(200),BRANCH_CD VARCHAR(100),
	[STATUS] VARCHAR(100),PARTYCODE VARCHAR(50),FLAG VARCHAR(5))

	INSERT INTO #MISSING_CLI_NEW 
	exec Chk_Missing_cli_new

	INSERT INTO bse_error_report(termid,remark,sauda_date) 
	select TERMID ,'MISSING PARTY_CODE :' + PARTY_CODE +' TERMINAL ID : '+ CONVERT(VARCHAR(50), TERMID) +' ALLOTED TO '+ BRANCH_NAME, @Sauda_Date
	FROM #MISSING_CLI_NEW 
	
	SELECT [MISSING_PARTY_CODE] = PARTY_CODE ,[TERMINAL_ID]= TERMID,[ALLOTED_TO]= BRANCH_NAME, SAUDA_DATE= @Sauda_Date
	FROM #MISSING_CLI_NEW 

/*Step 4 END*/

/*Step 5 */ /*********** Report 4 *********/
/* PRO SAUDA REPORT */	

	SELECT
	TERMID ,
	[REMARK]='PARTY CODE: '+Party_Code+' TERMID: '+TERMID+ ' HAS DONE SAUDA IN PRO WITH TRANSACTION DETAILS AS TERMID: '+CONVERT(VARCHAR(50), TERMID) + 'SYMBOL: ' 
	+symbol + 'QTY: ' + CONVERT(VARCHAR(100),TRADEQTY),
	sauda_date
	INTO #bsecashtrd_TEMP
	FROM bsecashtrd 
	WHERE pro_cli 
	NOT IN ('CLIENT','NRI','SPLCLI') 
	AND 
	tradeqty 
	IN (SELECT MAX(tradeqty) FROM bsecashtrd WHERE pro_cli NOT IN ('CLIENT','NRI','SPLCLI') GROUP BY termid) 
	
	INSERT INTO bse_error_report(termid,remark,sauda_date) 
	SELECT TERMID,REMARK,SAUDA_DATE FROM #bsecashtrd_TEMP
	
	SELECT TERMID as [TERMINAL_ID],[REMARK],SAUDA_DATE FROM #bsecashtrd_TEMP

/*Step 5 END*/

/*Step 6 */ /*********** Report 5 *********/
/* WRONG SCRIP CODE FUND DETAIL REPORT */
	If ( Select count(*) from bsecashtrd(nolock) where Scrip_cd = '999999') > 0
	BEGIN
		Select [SCRIP_CODE_999999] = ('WRONG SCRIP CODE FOUND IN FILE')
	END
	
	ELSE
		BEGIN
			SELECT top 0 [SCRIP_CODE_999999] =null
		END
	
/*Step 6 END */

/*Step 7*/ /*********** Report 6 *********/
/* SCRIP CODE NOT IN DATA BASE */
	SELECT DISTINCT SCRIP_CD,SYMBOL 
	INTO #BSCCASHTRD 
	FROM bsecashtrd(nolock) 
	WHERE SCRIP_CD NOT IN (SELECT BSECODE FROM bse_SCRIP2)

	SELECT [SCRIP_CODE]= ('SCRIP: ' + SYMBOL + '--' + SCRIP_CD + 'NOT IN DATA BASE.') FROM #BSCCASHTRD

/*Step 7 END*/

/*Step 8*/ /*********** Report 7 *********/
/*TERM ID NOT FOUND IN DATA BASE*/

	SELECT DISTINCT CONVERT(INT,trd.termid)AS TERMID ,
	'TERM ID : '+ CONVERT(VARCHAR(50), TERMID) + ' IS NOT FOUND IN DATABASE' AS REMARK,sauda_date
	INTO #BSECASHTRD1
	FROM bsecashtrd trd  
	WHERE trd.termid NOT IN  
	(SELECT DISTINCT termid FROM bse_termid WHERE STATUS='ACTIVE' AND segment='BSE CASH' 
	UNION  SELECT userid FROM termparty) ORDER BY CONVERT(INT,trd.termid) 

	INSERT INTO bse_error_report(termid,remark,sauda_date)
	SELECT TERMID,REMARK,SAUDA_DATE FROM #BSECASHTRD1


	SELECT [TERM_ID]= ('TERM ID : '+ CONVERT(VARCHAR(50), TERMID) + ' IS NOT FOUND IN DATABASE') FROM #BSECASHTRD1

/*Step 8 END*/

/*Step 9*/ /*********** Report 8 *********/
/* NRI CLIENT TRADING DETAILS */

	CREATE TABLE #TEMP_NRI(PARTY_CODE VARCHAR(50),SYMBOL VARCHAR(50),BRANCH_CD VARCHAR(100),SUB_BROKER VARCHAR(100))
	INSERT INTO #TEMP_NRI
	EXEC Usp_Nri
	
	SELECT [NRI_CLIENT_DETAIL]= ('NRICLIENTCODE: '+ PARTY_CODE + 'OF BRANCH: ' + BRANCH_CD +' AND SUBBROKER: ' + 
	SUB_BROKER + ' HAS DONE TRADING ON :' + SYMBOL)
	FROM #TEMP_NRI 
	 
/*Step 9 END*/

/*Step 10*/ /*********** Report 9 *********/
/* SEBI BANNED CLIENT REPORT */
CREATE TABLE #PARTY_CODE (PARTY_CODE VARCHAR(50))

INSERT INTO #PARTY_CODE 
EXEC Usp_SebiBanned_Traded

SELECT [SEBI_BANNED_CLIENT_REPORT]= ('CLIENTCODE: '+ PARTY_CODE+ ' IS A SEBIBANNED CLIENT') FROM #PARTY_CODE

/*Step 10 END */

/*Step 11*/ /*********** Report 10 *********/
/* MISSING PARTY CODE IN DATABASE */
DECLARE @party_code varchar(50),@CNT INT

CREATE TABLE #PARTY_CODE1(PARTY_CODE VARCHAR(50))

INSERT INTO #PARTY_CODE1
EXEC mukesh1

SELECT ROW_NUMBER() OVER (ORDER BY PARTY_CODE DESC) AS SRNO,
PARTY_CODE INTO #PARTY_CODE2 FROM #PARTY_CODE1 GROUP BY PARTY_CODE

		SET @CNT=(SELECT COUNT(1) FROM #PARTY_CODE2)

		SELECT TOP 0 bsecashtrd.party_code, symbol , tradeqty, bse_termid.termid ,bse_termid.branch_cd , 
		bse_termid.branch_name, bse_termid.sub_broker ,@Sauda_Date AS Sauda_Date
		INTO #BSECASHTRD2 
		FROM bsecashtrd 
		LEFT JOIN bse_termid on bsecashtrd.termid = bse_termid.termid 

WHILE (@CNT > 0)
	BEGIN
		SET @party_code=(SELECT PARTY_CODE FROM #PARTY_CODE2 WHERE SRNO = @CNT)
		
		INSERT INTO #BSECASHTRD2
		SELECT DISTINCT bsecashtrd.party_code, symbol , tradeqty, bse_termid.termid ,bse_termid.branch_cd , 
		bse_termid.branch_name, bse_termid.sub_broker, @Sauda_Date AS Sauda_Date  
		FROM bsecashtrd 
		LEFT JOIN bse_termid on bsecashtrd.termid = bse_termid.termid 
		WHERE bsecashtrd.party_code = @party_code

		SET @CNT= @CNT - 1
	END
	
	INSERT INTO bse_error_report(party_code,remark,sauda_date)
	SELECT PARTY_CODE,
	'PARTY CODE: ' + PARTY_CODE + ' IS NOT FOUND IN DATABASE WITH TRANSACTION DETAILS AS TERMID: '+ CONVERT(VARCHAR(50), TERMID) + 
	'--'+	branch_cd+'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'SYMBOL: '+SYMBOL+'QTY: '+ CONVERT(VARCHAR(100),TRADEQTY)
	,@Sauda_Date 
	FROM #BSECASHTRD2	
	
	
	SELECT [PARTY_CODE_NOT_FOUND_IN_DATABASE] = 
	('PARTY CODE: ' + PARTY_CODE + ' IS NOT FOUND IN DATABASE WITH TRANSACTION DETAILS AS TERMID: '+ CONVERT(VARCHAR(50), TERMID) 
	+ '--'+	branch_cd+'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'SYMBOL: '+SYMBOL+'QTY: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *' )
	FROM #BSECASHTRD2

/* Step 11 END */

/*Step 12 */ /*********** Report 11 *********/
/*BSE INACTIVE CLIENT REPORT*/

CREATE TABLE #BSE_CL_ADVANCE(PARTY_CODE VARCHAR(50),TERMID INT,BRANCH_NAME VARCHAR(100),BRANCH_CODE VARCHAR(100),
[STATUS] VARCHAR(50),PARTYCODE VARCHAR(50),FLAG VARCHAR(10))

INSERT INTO #BSE_CL_ADVANCE 
exec bse_cl_advance 


TRUNCATE TABLE #PARTY_CODE2
TRUNCATE TABLE #BSECASHTRD2

		INSERT INTO #PARTY_CODE2
		SELECT ROW_NUMBER() OVER (ORDER BY PARTY_CODE DESC) AS SRNO, PARTY_CODE
		 FROM #BSE_CL_ADVANCE GROUP BY PARTY_CODE

		SET @CNT=(SELECT COUNT(1) FROM #PARTY_CODE2)

WHILE (@CNT > 0)
	BEGIN
		SET @party_code=(SELECT PARTY_CODE FROM #PARTY_CODE2 WHERE SRNO = @CNT)
		
		INSERT INTO #BSECASHTRD2
		SELECT DISTINCT bsecashtrd.party_code, symbol , tradeqty, bse_termid.termid ,bse_termid.branch_cd , 
		bse_termid.branch_name, bse_termid.sub_broker, @Sauda_Date AS Sauda_Date  
		FROM bsecashtrd 
		LEFT JOIN bse_termid on bsecashtrd.termid = bse_termid.termid 
		WHERE bsecashtrd.party_code = @party_code

		SET @CNT= @CNT - 1
	END
	
	INSERT INTO bse_error_report(party_code,remark,sauda_date)
	SELECT PARTY_CODE,
	'Party Code: ' + PARTY_CODE + ' is InActive with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	branch_cd +'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'symbol: '+SYMBOL+' qty: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *'
	,@Sauda_Date 
	FROM #BSECASHTRD2	
 
	
	SELECT [INACTIVE_PARTY_CODE]=
	('Party Code: ' + PARTY_CODE + ' is InActive with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	BRANCH_CD +'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'symbol: '+SYMBOL+'qty: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *')			
	FROM #BSECASHTRD2
	
/*Step 12 END*/

/*Step 13 */ /*********** Report 12 *********/
/* DORMANT CLIENTS REPORT*/

	create table #DORMANT_CLIENT (PARTY_CODE VARCHAR(50),TERMID INT,BRANCH_CD VARCHAR(100),
	BRANCH_NAME VARCHAR(100),SUB_BROKER VARCHAR(100),SYMBOL VARCHAR(100),TRADEQTY VARCHAR(100))

	INSERT INTO #DORMANT_CLIENT
	exec USP_DORMANTCLIENTS 'bse'

	INSERT INTO bse_error_report(party_code,remark,sauda_date)
	SELECT PARTY_CODE,
	'Party Code: ' + PARTY_CODE + ' is Dormant Client with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	BRANCH_CD+'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+' symbol: '+SYMBOL+' qty: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *'
	,@Sauda_Date 
	FROM #DORMANT_CLIENT
	
	
	SELECT [DORMANT_CLIENTS]= 
	('Party Code: ' + PARTY_CODE + ' is Dormant Client with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	BRANCH_CD +'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'symbol: '+SYMBOL+'qty: '+ CONVERT(VARCHAR(100), TRADEQTY)  + ' *')
	FROM #DORMANT_CLIENT	
	
/*Step 13  END */	

/* Step 14 */ /*********** Report 13 *********/
/*BSE MISMATCH REPORT*/

CREATE TABLE #bse_mismatch_deepak1_advance 
(PARTY_CODE VARCHAR(50),BRANCH_CD VARCHAR(100),
SUB_BROKER VARCHAR(100),TERMID INT,TERMBRAMCH VARCHAR(50),TERMSB VARCHAR(100),
TERMBRANCH1 VARCHAR(100),TERMSB1 VARCHAR(100),PARTYCODE VARCHAR(50),FLAG VARCHAR(10))

INSERT INTO #bse_mismatch_deepak1_advance 
exec  bse_mismatch_deepak1_advance 

SELECT * from #bse_mismatch_deepak1_advance 

/*Step 14 END*/

/* Step 15 */ /*********** Report 14 *********/
/* THE SEBI BANNED SCRIPT CODE */
CREATE TABLE #usp_bsecashtrd_bannedscript 
(CLIENT_CODE VARCHAR(50),BRANCH VARCHAR(100),
SUB_BROKER VARCHAR(100),LONG_NAME varchar(200),REGION VARCHAR(100),TERMID INT,QUANTITY INT,BUY_SELL VARCHAR(10))

INSERT INTO #usp_bsecashtrd_bannedscript
exec usp_bsecashtrd_bannedscript

SELECT CLIENT_CODE,BRANCH,SUB_BROKER,LONG_NAME,REGION,TERMID,QUANTITY,BUY_SELL FROM #usp_bsecashtrd_bannedscript

/*STEP 15 END */

/*DROPING ALL TEMP TABLE*/

DROP TABLE #MISSING_CLI_NEW
DROP TABLE #bsecashtrd_TEMP
DROP TABLE #BSCCASHTRD
DROP TABLE #BSECASHTRD1
DROP TABLE #TEMP_NRI
DROP TABLE #PARTY_CODE
DROP TABLE #PARTY_CODE1
DROP TABLE #PARTY_CODE2
DROP TABLE #BSECASHTRD2
DROP TABLE #BSE_CL_ADVANCE
DROP TABLE #DORMANT_CLIENT
DROP TABLE #bse_mismatch_deepak1_advance
DROP TABLE #usp_bsecashtrd_bannedscript

/*DROPING ALL TEMP TABLE END*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MismatchClient_bk04Mar2016
-- --------------------------------------------------
--usp_MismatchClient '03/03/2016'

CREATE proc [dbo].[usp_MismatchClient_bk04Mar2016]
@Sauda_Date1 varchar(12)
AS
 
/*Step 1*/ /*********** Report 1 *********/
/*Party Code & Terminal Details Mismatch*/ 
DECLARE @RSDateCnt INT
DECLARE @Sauda_Date as datetime 
--set @Sauda_Date= '2016-03-03 00:00:00.000'
set @Sauda_Date = convert(datetime,@Sauda_Date1)


select * into #bse_error_report from bse_error_report
select * into #tbsetable from tbsetable


SET @RSDateCnt=(SELECT TOP 5 count(1) FROM bsecashtrd(NOLOCK) WHERE CONVERT(DATETIME,LEFT(sauda_date,11)) =@Sauda_Date )

IF @RSDateCnt > 0
	BEGIN
		DELETE FROM #bse_error_report WHERE sauda_date = @Sauda_Date
		
		SELECT TOP 0 PARTY_CODE,PCODE_BRANCH_CD,PCODE_SUB_BROKER,TERMID,TERMID_BRANCH_CD,TERMID_SUB_BROKER,TERMID_BRANCH_CD_ALT,
		REMARK,SAUDA_DATE FROM #bse_error_report(NOLOCK) 
	END
ELSE
	BEGIN
		select PARTY_CODE,PCODE_BRANCH_CD,PCODE_SUB_BROKER,TERMID,TERMID_BRANCH_CD,TERMID_SUB_BROKER,TERMID_BRANCH_CD_ALT,REMARK,SAUDA_DATE 
		from #bse_error_report(nolock) 
		where sauda_date = @Sauda_Date order by party_code	
	END

/*Step 1 END*/

/*Step 2*/ /*********** Report 2 *********/
/*WRONG CLIENT TYPE CODE*/
	SELECT [WRONG_CLIENT_TYPE_CODE]= CL_CODE FROM V_INS_Clients
/*Step 2 End*/

/*Step 3*/
/*Party Code & Terminal Details Mismatch heading is created but not  used! */
	 TRUNCATE TABLE #tbsetable
	
	 INSERT INTO #tbsetable  
	 SELECT party_code,long_name,activefrom,inactivefrom,CONVERT(DATETIME ,GETDATE(),103)
	 FROM   
	 anand.bsedb_ab.dbo.client1 c1, anand.bsedb_ab.dbo.client2 c2, anand.bsedb_ab.dbo.client5 c5  
	 WHERE c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  
	 and CONVERT(DATETIME ,c5.inactivefrom ,103) < CONVERT(DATETIME ,GETDATE(),103) 
	 
/*Step 3 End*/

/*Step 4*/ /*********** Report 3 *********/
/* NO MISSING/INACTIVE LIST */
	CREATE TABLE #MISSING_CLI_NEW (PARTY_CODE VARCHAR(50),TERMID INT,BRANCH_NAME VARCHAR(200),BRANCH_CD VARCHAR(100),
	[STATUS] VARCHAR(100),PARTYCODE VARCHAR(50),FLAG VARCHAR(5))

	INSERT INTO #MISSING_CLI_NEW 
	exec Chk_Missing_cli_new

	INSERT INTO #bse_error_report(termid,remark,sauda_date) 
	select TERMID ,'MISSING PARTY_CODE :' + PARTY_CODE +' TERMINAL ID : '+ CONVERT(VARCHAR(50), TERMID) +' ALLOTED TO '+ BRANCH_NAME, @Sauda_Date
	FROM #MISSING_CLI_NEW 
	
	SELECT [MISSING_PARTY_CODE] = PARTY_CODE ,[TERMINAL_ID]= TERMID,[ALLOTED_TO]= BRANCH_NAME, SAUDA_DATE= @Sauda_Date
	FROM #MISSING_CLI_NEW 

/*Step 4 END*/

/*Step 5 */ /*********** Report 4 *********/
/* PRO SAUDA REPORT */	

	SELECT
	TERMID,
	[REMARK]='TERMID: '+TERMID+ ' HAS DONE SAUDA IN PRO WITH TRANSACTION DETAILS AS TERMID: '+CONVERT(VARCHAR(50), TERMID) + 'SYMBOL: ' 
	+symbol + 'QTY: ' + CONVERT(VARCHAR(100),TRADEQTY),
	sauda_date
	INTO #bsecashtrd_TEMP
	FROM bsecashtrd 
	WHERE pro_cli 
	NOT IN ('CLIENT','NRI','SPLCLI') 
	AND 
	tradeqty 
	IN (SELECT MAX(tradeqty) FROM bsecashtrd WHERE pro_cli NOT IN ('CLIENT','NRI','SPLCLI') GROUP BY termid) 
	
	INSERT INTO #bse_error_report(termid,remark,sauda_date) 
	SELECT TERMID,REMARK,SAUDA_DATE FROM #bsecashtrd_TEMP
	
	SELECT TERMID,[REMARK],SAUDA_DATE FROM #bsecashtrd_TEMP

/*Step 5 END*/

/*Step 6 */ /*********** Report 5 *********/
/* WRONG SCRIP CODE FUND DETAIL REPORT */
	If ( Select count(*) from bsecashtrd(nolock) where Scrip_cd = '999999') > 0
	BEGIN
		Select [SCRIP_CODE_999999] = ('WRONG SCRIP CODE FOUND IN FILE')
	END
	
	ELSE
		BEGIN
			SELECT top 0 [SCRIP_CODE_999999] =null
		END
	
/*Step 6 END */

/*Step 7*/ /*********** Report 6 *********/
/* SCRIP CODE NOT IN DATA BASE */
	SELECT DISTINCT SCRIP_CD,SYMBOL 
	INTO #BSCCASHTRD 
	FROM bsecashtrd(nolock) 
	WHERE SCRIP_CD NOT IN (SELECT BSECODE FROM bse_SCRIP2)

	SELECT [SCRIP_CODE]= ('SCRIP: ' + SYMBOL + '--' + SCRIP_CD + 'NOT IN DATA BASE.') FROM #BSCCASHTRD

/*Step 7 END*/

/*Step 8*/ /*********** Report 7 *********/
/*TERM ID NOT FOUND IN DATA BASE*/

	SELECT DISTINCT CONVERT(INT,trd.termid)AS TERMID ,
	'TERM ID : '+ CONVERT(VARCHAR(50), TERMID) + ' IS NOT FOUND IN DATABASE' AS REMARK,sauda_date
	INTO #BSECASHTRD1
	FROM bsecashtrd trd  
	WHERE trd.termid NOT IN  
	(SELECT DISTINCT termid FROM bse_termid WHERE STATUS='ACTIVE' AND segment='BSE CASH' 
	UNION  SELECT userid FROM termparty) ORDER BY CONVERT(INT,trd.termid) 

	INSERT INTO #bse_error_report(termid,remark,sauda_date)
	SELECT TERMID,REMARK,SAUDA_DATE FROM #BSECASHTRD1


	SELECT [TERM_ID]= ('TERM ID : '+ CONVERT(VARCHAR(50), TERMID) + ' IS NOT FOUND IN DATABASE') FROM #BSECASHTRD1

/*Step 8 END*/

/*Step 9*/ /*********** Report 8 *********/
/* NRI CLIENT TRADING DETAILS */

	CREATE TABLE #TEMP_NRI(PARTY_CODE VARCHAR(50),SYMBOL VARCHAR(50),BRANCH_CD VARCHAR(100),SUB_BROKER VARCHAR(100))
	INSERT INTO #TEMP_NRI
	EXEC Usp_Nri
	
	SELECT [NRI_CLIENT_DETAIL]= ('NRICLIENTCODE: '+ PARTY_CODE + 'OF BRANCH: ' + BRANCH_CD +' AND SUBBROKER: ' + 
	SUB_BROKER + ' HAS DONE TRADING ON :' + SYMBOL)
	FROM #TEMP_NRI 
	 
/*Step 9 END*/

/*Step 10*/ /*********** Report 9 *********/
/* SEBI BANNED CLIENT REPORT */
CREATE TABLE #PARTY_CODE (PARTY_CODE VARCHAR(50))

INSERT INTO #PARTY_CODE 
EXEC Usp_SebiBanned_Traded

SELECT [SEBI_BANNED_CLIENT_REPORT]= ('CLIENTCODE: '+ PARTY_CODE+ ' IS A SEBIBANNED CLIENT') FROM #PARTY_CODE

/*Step 10 END */

/*Step 11*/ /*********** Report 10 *********/
/* MISSING PARTY CODE IN DATABASE */
DECLARE @party_code varchar(50),@CNT INT

CREATE TABLE #PARTY_CODE1(PARTY_CODE VARCHAR(50))

INSERT INTO #PARTY_CODE1
EXEC mukesh1

SELECT ROW_NUMBER() OVER (ORDER BY PARTY_CODE DESC) AS SRNO,
PARTY_CODE INTO #PARTY_CODE2 FROM #PARTY_CODE1 GROUP BY PARTY_CODE

		SET @CNT=(SELECT COUNT(1) FROM #PARTY_CODE2)

		SELECT TOP 0 bsecashtrd.party_code, symbol , tradeqty, bse_termid.termid ,bse_termid.branch_cd , 
		bse_termid.branch_name, bse_termid.sub_broker ,@Sauda_Date AS Sauda_Date
		INTO #BSECASHTRD2 
		FROM bsecashtrd 
		LEFT JOIN bse_termid on bsecashtrd.termid = bse_termid.termid 

WHILE (@CNT > 0)
	BEGIN
		SET @party_code=(SELECT PARTY_CODE FROM #PARTY_CODE2 WHERE SRNO = @CNT)
		
		INSERT INTO #BSECASHTRD2
		SELECT bsecashtrd.party_code, symbol , tradeqty, bse_termid.termid ,bse_termid.branch_cd , 
		bse_termid.branch_name, bse_termid.sub_broker  
		FROM bsecashtrd 
		LEFT JOIN bse_termid on bsecashtrd.termid = bse_termid.termid 
		WHERE bsecashtrd.party_code = @party_code

		SET @CNT= @CNT + 1
	END
	
	INSERT INTO #bse_error_report(party_code,remark,sauda_date)
	SELECT PARTY_CODE,
	'PARTY CODE: ' + PARTY_CODE + ' IS NOT FOUND IN DATABASE WITH TRANSACTION DETAILS AS TERMID: '+ CONVERT(VARCHAR(50), TERMID) + 
	'--'+	branch_cd+'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'SYMBOL: '+SYMBOL+'QTY: '+ CONVERT(VARCHAR(100),TRADEQTY)
	,@Sauda_Date 
	FROM #BSECASHTRD2	
	
	
	SELECT [PARTY_CODE_NOT_FOUND_IN_DATABASE] = 
	('PARTY CODE: ' + PARTY_CODE + ' IS NOT FOUND IN DATABASE WITH TRANSACTION DETAILS AS TERMID: '+ CONVERT(VARCHAR(50), TERMID) 
	+ '--'+	branch_cd+'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'SYMBOL: '+SYMBOL+'QTY: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *' )
	FROM #BSECASHTRD2

/* Step 11 END */

/*Step 12 */ /*********** Report 11 *********/
/*BSE INACTIVE CLIENT REPORT*/

CREATE TABLE #BSE_CL_ADVANCE(PARTY_CODE VARCHAR(50),TERMID INT,BRANCH_NAME VARCHAR(100),BRANCH_CODE VARCHAR(100),
[STATUS] VARCHAR(50),PARTYCODE VARCHAR(50),FLAG VARCHAR(10))

INSERT INTO #BSE_CL_ADVANCE 
exec bse_cl_advance 


TRUNCATE TABLE #PARTY_CODE2
TRUNCATE TABLE #BSECASHTRD2

		INSERT INTO #PARTY_CODE2
		SELECT ROW_NUMBER() OVER (ORDER BY PARTY_CODE DESC) AS SRNO, PARTY_CODE
		 FROM #BSE_CL_ADVANCE GROUP BY PARTY_CODE

		SET @CNT=(SELECT COUNT(1) FROM #PARTY_CODE2)

WHILE (@CNT > 0)
	BEGIN
		SET @party_code=(SELECT PARTY_CODE FROM #PARTY_CODE2 WHERE SRNO = @CNT)
		
		INSERT INTO #BSECASHTRD2
		SELECT bsecashtrd.party_code, symbol , tradeqty, bse_termid.termid ,bse_termid.branch_cd , 
		bse_termid.branch_name, bse_termid.sub_broker  
		FROM bsecashtrd 
		LEFT JOIN bse_termid on bsecashtrd.termid = bse_termid.termid 
		WHERE bsecashtrd.party_code = @party_code

		SET @CNT= @CNT + 1
	END
	
	INSERT INTO #bse_error_report(party_code,remark,sauda_date)
	SELECT PARTY_CODE,
	'Party Code: ' + PARTY_CODE + ' is InActive with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	branch_cd +'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'symbol: '+SYMBOL+' qty: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *'
	,@Sauda_Date 
	FROM #BSECASHTRD2	
 
	
	SELECT [INACTIVE_PARTY_CODE]=
	('Party Code: ' + PARTY_CODE + ' is InActive with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	BRANCH_CD +'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'symbol: '+SYMBOL+'qty: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *')			
	FROM #BSECASHTRD2
	
/*Step 12 END*/

/*Step 13 */ /*********** Report 12 *********/
/* DORMANT CLIENTS REPORT*/

	create table #DORMANT_CLIENT (PARTY_CODE VARCHAR(50),TERMID INT,BRANCH_CD VARCHAR(100),
	BRANCH_NAME VARCHAR(100),SUB_BROKER VARCHAR(100),SYMBOL VARCHAR(100),TRADEQTY VARCHAR(100))

	INSERT INTO #DORMANT_CLIENT
	exec USP_DORMANTCLIENTS 'bse'

	INSERT INTO #bse_error_report(party_code,remark,sauda_date)
	SELECT PARTY_CODE,
	'Party Code: ' + PARTY_CODE + ' is Dormant Client with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	BRANCH_CD+'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+' symbol: '+SYMBOL+' qty: '+ CONVERT(VARCHAR(100),TRADEQTY) +' *'
	,@Sauda_Date 
	FROM #DORMANT_CLIENT
	
	
	SELECT [DORMANT_CLIENTS]= 
	('Party Code: ' + PARTY_CODE + ' is Dormant Client with Transaction Details as Termid: '+ CONVERT(VARCHAR(100),TERMID) + '--'+
	BRANCH_CD +'--'+BRANCH_NAME+'-SB:'+SUB_BROKER+'symbol: '+SYMBOL+'qty: '+ CONVERT(VARCHAR(100), TRADEQTY)  + ' *')
	FROM #DORMANT_CLIENT	
	
/*Step 13  END */	

/* Step 14 */ /*********** Report 13 *********/
/*BSE MISMATCH REPORT*/

CREATE TABLE #bse_mismatch_deepak1_advance 
(PARTY_CODE VARCHAR(50),BRANCH_CD VARCHAR(100),
SUB_BROKER VARCHAR(100),TERMID INT,TERMBRAMCH VARCHAR(50),TERMSB VARCHAR(100),
TERMBRANCH1 VARCHAR(100),TERMSB1 VARCHAR(100),PARTYCODE VARCHAR(50),FLAG VARCHAR(10))

INSERT INTO #bse_mismatch_deepak1_advance 
exec  bse_mismatch_deepak1_advance 

SELECT * from #bse_mismatch_deepak1_advance 

/*Step 14 END*/

/* Step 15 */ /*********** Report 14 *********/
/* THE SEBI BANNED SCRIPT CODE */
CREATE TABLE #usp_bsecashtrd_bannedscript 
(CLIENT_CODE VARCHAR(50),BRANCH VARCHAR(100),
SUB_BROKER VARCHAR(100),LONG_NAME varchar(200),REGION VARCHAR(100),TERMID INT,QUANTITY INT,BUY_SELL VARCHAR(10))

INSERT INTO #usp_bsecashtrd_bannedscript
exec usp_bsecashtrd_bannedscript

SELECT CLIENT_CODE,BRANCH,SUB_BROKER,LONG_NAME,REGION,TERMID,QUANTITY,BUY_SELL FROM #usp_bsecashtrd_bannedscript

/*STEP 15 END */

/*DROPING ALL TEMP TABLE*/

DROP TABLE #MISSING_CLI_NEW
DROP TABLE #bsecashtrd_TEMP
DROP TABLE #BSCCASHTRD
DROP TABLE #BSECASHTRD1
DROP TABLE #TEMP_NRI
DROP TABLE #PARTY_CODE
DROP TABLE #PARTY_CODE1
DROP TABLE #PARTY_CODE2
DROP TABLE #BSECASHTRD2
DROP TABLE #BSE_CL_ADVANCE
DROP TABLE #DORMANT_CLIENT
DROP TABLE #bse_mismatch_deepak1_advance
DROP TABLE #usp_bsecashtrd_bannedscript

/*DROPING ALL TEMP TABLE END*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Nri
-- --------------------------------------------------
CREATE proc [dbo].[Usp_Nri]  
as  
  
SET NOCOUNT ON  
Set Transaction isolation level read uncommitted  
  
Select party_code,branch_cd,sub_broker into #temp from AngelNseCM.msajag.dbo.client_details where cl_status = 'NRI'  
   
Select a.party_code into #temp1 from  
(select distinct party_code,symbol from bsecashtrd   
where party_code in (select party_code from #temp)  
and sell_buy = 'S'  
)a   
inner  join  
(  
Select distinct party_code,symbol from bsecashtrd   
where party_code in (select party_code from #temp)  
and sell_buy = 'B'  
)b  
on a.party_code=b.party_code and a.symbol=b.symbol  
  
Select x.party_code,x.symbol,y.branch_cd,y.sub_broker from  
(select distinct party_code,symbol from bsecashtrd where party_code in  
(select * from #temp1))x   
inner join  
(select party_code,branch_cd,sub_broker from #temp)y  
on x.party_code = y.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Nri_OFS
-- --------------------------------------------------
CREATE proc [dbo].[Usp_Nri_OFS]    
as    
    
SET NOCOUNT ON    
Set Transaction isolation level read uncommitted    
    
Select party_code,branch_cd,sub_broker into #temp from AngelNseCM.msajag.dbo.client_details where cl_status = 'NRI'    
     
Select a.party_code into #temp1 from    
(select distinct party_code from bsecashOFS     
where party_code in (select party_code from #temp)       
)a     
inner  join    
(    
Select distinct party_code from bsecashOFS     
where party_code in (select party_code from #temp)      
)b    
on a.party_code=b.party_code   
    
Select x.party_code,y.branch_cd,y.sub_broker from    
(select distinct party_code from bsecashOFS where party_code in    
(select * from #temp1))x     
inner join    
(select party_code,branch_cd,sub_broker from #temp)y    
on x.party_code = y.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Sebi_bannedFromintranet
-- --------------------------------------------------

CREATE proc usp_Sebi_bannedFromintranet  
AS  
begin  
  
 select Pan_no=isnull(a.Pan_no,''),Party_code=space(15)  
 into #file  
 from intranet.testdb.dbo.sebi_banned a(nolock)  
 left outer join  
 Sebi_bannedFromintranet b  
 on a.Pan_no=b.Pan_no  
 where b.Pan_no is null  
  
 update #file set party_code=b.party_code from intranet.risk.dbo.client_details b with (nolock)  
 where #file.Pan_no=b.pan_gir_no  
 and #file.Pan_no<>''  
  
 insert into Sebi_bannedFromintranet  
 select substring(isnull(pan_no,''),1,50),Party_code,getdate() from #file   
 where pan_no NOT IN (SELECT pan_no FROM Sebi_bannedFromintranet)
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Sebi_OFS
-- --------------------------------------------------

CREATE Proc Usp_Sebi_OFS           
as            
          
--Select Distinct Party_Code from bsecashtrd a(nolock)            
--Inner join tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode           
  
Select Distinct a.Party_Code from bsecashOFS a(nolock)            
Inner join Sebi_bannedFromintranet b(nolock) on a.party_Code = b.party_Code       
          
--SELECT a.Party_Code FROM          
-- (SELECT DISTINCT a.party_code,b.pan_gir_no from bsecashtrd a WITH(NOLOCK)          
--   INNER JOIN          
--   INTRANET.risk.dbo.client_details b WITH(NOLOCK)          
--   ON a.Party_Code=b.cl_code)a           
--             
-- INNER JOIN INTRANET.testdb.dbo.SEBI_banned b WITH(nolock)          
-- ON a.pan_gir_no=b.pan_no          
         
--SELECT DISTINCT party_code INTO #party from bsecashtrd  WITH(NOLOCK)          
--        
--SELECT a.party_code,b.pan_gir_no INTO #file FROM #party a        
--INNER JOIN          
--INTRANET.risk.dbo.client_details b WITH(NOLOCK)          
--ON a.Party_Code=b.cl_code        
--        
--SELECT DISTINCT a.party_code FROM #file a        
--INNER JOIN         
--INTRANET.testdb.dbo.SEBI_banned b WITH(nolock)         
--ON a.pan_gir_no=b.pan_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SebiBanned_Traded
-- --------------------------------------------------
CREATE Proc Usp_SebiBanned_Traded          
as          
        
--Select Distinct Party_Code from bsecashtrd a(nolock)          
--Inner join tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode         

Select Distinct a.Party_Code from bsecashtrd a(nolock)          
Inner join Sebi_bannedFromintranet b(nolock) on a.party_Code = b.party_Code     
        
--SELECT a.Party_Code FROM        
-- (SELECT DISTINCT a.party_code,b.pan_gir_no from bsecashtrd a WITH(NOLOCK)        
--   INNER JOIN        
--   INTRANET.risk.dbo.client_details b WITH(NOLOCK)        
--   ON a.Party_Code=b.cl_code)a         
--           
-- INNER JOIN INTRANET.testdb.dbo.SEBI_banned b WITH(nolock)        
-- ON a.pan_gir_no=b.pan_no        
       
--SELECT DISTINCT party_code INTO #party from bsecashtrd  WITH(NOLOCK)        
--      
--SELECT a.party_code,b.pan_gir_no INTO #file FROM #party a      
--INNER JOIN        
--INTRANET.risk.dbo.client_details b WITH(NOLOCK)        
--ON a.Party_Code=b.cl_code      
--      
--SELECT DISTINCT a.party_code FROM #file a      
--INNER JOIN       
--INTRANET.testdb.dbo.SEBI_banned b WITH(nolock)       
--ON a.pan_gir_no=b.pan_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_TradeCnt_BSEInsert
-- --------------------------------------------------
CREATE Proc [dbo].[Usp_TradeCnt_BSEInsert]
as 
select party_code,trdcount=count(scrip_cd) into #temp1 from AngelBSECM.bsedb_ab.dbo.settlement 
where sauda_date >= Convert(Varchar(11),convert(datetime,getdate()-1,103)) and
sauda_date <= Convert(Varchar(11),convert(datetime,getdate()-1,103))+ ' 23:59:59.000' 
and sett_type not in ('ac','ad') and tradeqty > 0 and isnumeric(trade_no) = '1'  
group by party_code

declare @cnt as int
set @cnt = (select count(*) from #temp1)

if @cnt > 0
begin
insert into tbl_tradecount_bse
select *,Convert(Varchar(11),convert(datetime,getdate()-1,103)) from #temp1
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_trdchg_rptdatewise
-- --------------------------------------------------
CREATE proc Usp_trdchg_rptdatewise        
(        
@fromdate as varchar(20),        
@todate as varchar(20),        
@accessto as varchar(20),        
@accesscode as varchar(20)        
)        
as         
        
select space(100) as 'Old_RegionName',space(20) as 'OldBranch',space(20) as 'OldSB',OldClcd=[old client],                                                                
space(100) as 'OldClname',space(500) as 'Old_Address',space(50) as 'Old_ActiveDate',space(50) as 'Old_Inactivedate',space(100) as 'NewRegion',                        
 space(20) as 'NewBranch',space(20) as 'NewSB',                                                                
NewClcd=[new client],space(100) as 'NewClname',space(500) as 'NewAddress', space(50) as 'New_ActiveDate',space(50) as 'New_Inactivedate' ,                                                                 
Terminal_no=[TWS NO],orderid=[order id],Scriptcode = [scrip code],[BUY/SELL],upd_date,Quantity,([RATE (Rs#)])Rate,space(50) Amount                                    
into #temp                                                  
 from terminal_chng                                                  
where upd_date>=convert(datetime,convert(varchar(11),@fromdate),103) and                                              
upd_date<=convert(datetime,convert(varchar(11),@todate),103)+' 23:59:59.000'        
    
    
Update #temp Set OldBranch = branch_cd,OldSB = sub_broker,OldClname=long_name,                        
old_regionname = region,                        
old_Address =  l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,                        
old_activedate = First_active_date ,old_Inactivedate = last_inactive_date                                                                   
from intranet.risk.dbo.client_details where oldclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS                                                                         
                                                  
Update #temp Set NewBranch = branch_cd,NewSB = sub_broker,NewClname=long_name,                        
NewRegion = region,                        
NewAddress =  l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_zip,                        
New_ActiveDate = First_active_date ,New_Inactivedate = last_inactive_date                         
from                                                 
intranet.risk.dbo.client_details where newclcd = party_code collate  SQL_Latin1_General_CP1_CI_AS           
    
/*
select a.*,b.reg_code into #temp1 from     
(select * from #temp (nolock))a    
left outer join    
(select code,reg_code from intranet.risk.dbo.region)b    
on newbranch = b.code 
*/
    
select Old_RegionName,OldBranch,OldSB,OldClcd,OldClname,NewRegion,NewBranch,NewSB,NewClcd,NewClname,Terminal_no,orderid,Scriptcode,[BUY/SELL] as buysell,Quantity,Rate from #temp (nolock) where NewBranch like @accesscode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Update_TotalTrades
-- --------------------------------------------------
CREATE Proc Usp_Update_TotalTrades(@Date varchar(11),@Bse numeric,@Nse numeric,@Nsefo numeric,  
@NseCds numeric,@Mcxsx numeric,@Mcx numeric,@Ncdex numeric)  
as  
  
Set @Date = Convert(Varchar(11),Convert(datetime,@Date,103))  

if Not Exists(Select * from tbl_TotalTrades where Fld_Date = @Date)
Begin  
	Insert into tbl_TotalTrades Values(@Date,@Bse,@Nse,@Nsefo,@NseCds,@Mcxsx,@Mcx,@Ncdex)   
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Update_Trades
-- --------------------------------------------------
Create Proc Usp_Update_Trades(@Date varchar(11),@Bse numeric,@Nse numeric,@Nsefo numeric,
@NseCds numeric,@Mcxsx numeric,@Mcx numeric,@Ncdex numeric)
as

Set @Date = Convert(Varchar(11),Convert(datetime,@Date,103))

Update tbl_TotalTrades Set Fld_Bse = @Bse,Fld_Nse = @Nse,Fld_Nsefo = @Nsefo,Fld_NseCds = @NseCds,
Fld_Mcxsx = @Mcxsx,Fld_Mcx = @Mcx,Fld_Ncdex = @Ncdex where Fld_Date = @Date

GO

-- --------------------------------------------------
-- TABLE dbo._temp_bse_clients
-- --------------------------------------------------
CREATE TABLE [dbo].[_temp_bse_clients]
(
    [party_code] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.abc
-- --------------------------------------------------
CREATE TABLE [dbo].[abc]
(
    [branch_name] CHAR(40) NULL,
    [Sauda_date] VARCHAR(62) NULL,
    [Series] VARCHAR(1) NULL,
    [Trade_no] VARCHAR(25) NULL,
    [Order_no] VARCHAR(25) NULL,
    [user_id] VARCHAR(20) NULL,
    [branchcode] VARCHAR(10) NULL,
    [branch_id] VARCHAR(50) NULL,
    [acname] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [scpname] VARCHAR(12) NULL,
    [sb] VARCHAR(4) NULL,
    [tradeqty] INT NULL,
    [marketrate] MONEY NULL,
    [net_trdqty] NUMERIC(10, 0) NULL,
    [our] NUMERIC(21, 11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.abc123
-- --------------------------------------------------
CREATE TABLE [dbo].[abc123]
(
    [branch_name] CHAR(40) NULL,
    [Sauda_date] VARCHAR(62) NULL,
    [Series] VARCHAR(1) NULL,
    [Trade_no] VARCHAR(25) NULL,
    [Order_no] VARCHAR(25) NULL,
    [user_id] VARCHAR(20) NULL,
    [branchcode] VARCHAR(10) NULL,
    [branch_id] VARCHAR(50) NULL,
    [acname] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [scpname] VARCHAR(12) NULL,
    [sb] VARCHAR(4) NULL,
    [tradeqty] INT NULL,
    [marketrate] MONEY NULL,
    [net_trdqty] NUMERIC(10, 0) NULL,
    [our] NUMERIC(21, 11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AlternateBranchSB
-- --------------------------------------------------
CREATE TABLE [dbo].[AlternateBranchSB]
(
    [alt_termid] VARCHAR(15) NULL,
    [alt_BranchSB] VARCHAR(25) NULL,
    [alt_BranchSBCode] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Angelclientstatus
-- --------------------------------------------------
CREATE TABLE [dbo].[Angelclientstatus]
(
    [Cl_Status] CHAR(3) NOT NULL,
    [Description] CHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.aprdetail
-- --------------------------------------------------
CREATE TABLE [dbo].[aprdetail]
(
    [MEMBERID] CHAR(9) NULL,
    [TWSNO] CHAR(8) NULL,
    [CLIENTID] CHAR(16) NULL,
    [CLTTYPE] CHAR(9) NULL,
    [SCRIPCODE] CHAR(11) NULL,
    [QTY] CHAR(12) NULL,
    [RATE] CHAR(13) NULL,
    [BS] CHAR(6) NULL,
    [DATETIME] CHAR(48) NULL,
    [flag] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.aprpending
-- --------------------------------------------------
CREATE TABLE [dbo].[aprpending]
(
    [clientid] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Banned_script_pano
-- --------------------------------------------------
CREATE TABLE [dbo].[Banned_script_pano]
(
    [PanNo] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[broktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] NUMERIC(19, 4) NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
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
-- TABLE dbo.bse_appr_list
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_appr_list]
(
    [srno] VARCHAR(20) NULL,
    [scode] VARCHAR(20) NULL,
    [sname] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bse_error_report
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_error_report]
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
-- TABLE dbo.bse_noreco
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_noreco]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(30) NULL,
    [edt] DATETIME NULL,
    [acname] VARCHAR(80) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [balamt] MONEY NULL,
    [cltcode] VARCHAR(30) NULL,
    [ddno] VARCHAR(30) NULL,
    [vdt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bse_reco1
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_reco1]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(50) NULL,
    [vdt] DATETIME NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [ddno] VARCHAR(20) NULL,
    [cltcode] VARCHAR(50) NULL,
    [ddno1] VARCHAR(20) NULL,
    [cramt] MONEY NULL,
    [reldt] DATETIME NULL,
    [edt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_SCRIP2
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_SCRIP2]
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
-- TABLE dbo.bse_termid
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_termid]
(
    [termid] VARCHAR(15) NOT NULL,
    [branch_cd] VARCHAR(20) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL,
    [user_email] VARCHAR(50) NULL,
    [user_emailcc] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsebroktable
-- --------------------------------------------------
CREATE TABLE [dbo].[bsebroktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] NUMERIC(10, 2) NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
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
-- TABLE dbo.bsecashOFS
-- --------------------------------------------------
CREATE TABLE [dbo].[bsecashOFS]
(
    [Party_Code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsecashtrade
-- --------------------------------------------------
CREATE TABLE [dbo].[bsecashtrade]
(
    [Clearing_Code] VARCHAR(20) NULL,
    [Termid] VARCHAR(20) NULL,
    [Scrip_cd] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [MarketRate] MONEY NULL,
    [TradeQty] INT NULL,
    [Svalue0] VARCHAR(5) NULL,
    [Svalue_0] VARCHAR(5) NULL,
    [Sauda_time] VARCHAR(50) NULL,
    [Sauda_date] DATETIME NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Order_no] VARCHAR(25) NULL,
    [SvalueL] VARCHAR(5) NULL,
    [Sell_Buy] VARCHAR(5) NULL,
    [trade_no] VARCHAR(25) NULL,
    [pro_cli] VARCHAR(20) NULL,
    [Isin_no] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[bsecashtrd]
(
    [Clearing_Code] VARCHAR(20) NULL,
    [Termid] VARCHAR(20) NULL,
    [Scrip_cd] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [MarketRate] MONEY NULL,
    [TradeQty] INT NULL,
    [Svalue0] VARCHAR(10) NULL,
    [Svalue_0] VARCHAR(10) NULL,
    [Sauda_time] VARCHAR(50) NULL,
    [Sauda_date] DATETIME NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Order_no] VARCHAR(25) NULL,
    [SvalueL] VARCHAR(5) NULL,
    [Sell_Buy] VARCHAR(5) NULL,
    [trade_no] VARCHAR(25) NULL,
    [pro_cli] VARCHAR(20) NULL,
    [Isin_no] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsecashtrd_MIS
-- --------------------------------------------------
CREATE TABLE [dbo].[bsecashtrd_MIS]
(
    [Clearing_Code] VARCHAR(20) NULL,
    [Termid] VARCHAR(20) NULL,
    [Scrip_cd] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [MarketRate] MONEY NULL,
    [TradeQty] INT NULL,
    [Svalue0] VARCHAR(10) NULL,
    [Svalue_0] VARCHAR(10) NULL,
    [Sauda_time] VARCHAR(50) NULL,
    [Sauda_date] DATETIME NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Order_no] VARCHAR(25) NULL,
    [SvalueL] VARCHAR(5) NULL,
    [Sell_Buy] VARCHAR(5) NULL,
    [trade_no] VARCHAR(25) NULL,
    [pro_cli] VARCHAR(20) NULL,
    [Isin_no] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsefotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[bsefotrd]
(
    [TradeNumber] INT NULL,
    [TradeDateTime] DATETIME NULL,
    [TradeStatus] INT NULL,
    [SegmentIndicator] VARCHAR(5) NULL,
    [SettlementType] VARCHAR(5) NULL,
    [ProductType] VARCHAR(5) NULL,
    [ProductCode] VARCHAR(15) NULL,
    [AssetCode] VARCHAR(15) NULL,
    [ExpiryDate] DATETIME NULL,
    [StrikePrice] FLOAT NULL,
    [optiontype] VARCHAR(5) NULL,
    [CALevel] FLOAT NULL,
    [BuyBroker] FLOAT NULL,
    [SellBroker] FLOAT NULL,
    [TradePrice] FLOAT NULL,
    [TradeQuantity] INT NULL,
    [seriesid] INT NULL,
    [TradeBuyerlocation] VARCHAR(30) NULL,
    [buyCMCode] INT NULL,
    [SellCMCode] INT NULL,
    [tradeSellerLocation] VARCHAR(30) NULL,
    [buyCustodianParticipant] VARCHAR(50) NULL,
    [BuySideConfirmation] VARCHAR(10) NULL,
    [SellCustodialParticipant] VARCHAR(50) NULL,
    [SellSideConfirmation] VARCHAR(10) NULL,
    [BuyCoveredUncoveredFlag] CHAR(1) NULL,
    [SellCoveredUncoveredFlag] CHAR(1) NULL,
    [BuyOldCustodialParticipant] VARCHAR(50) NULL,
    [BuyOldCM] VARCHAR(50) NULL,
    [SellOldCustodialParticipant] VARCHAR(50) NULL,
    [SellOldCM] VARCHAR(50) NULL,
    [TradeBuyerTerminalID] INT NULL,
    [TradeSellerTerminalID] INT NULL,
    [buyOrder] VARCHAR(30) NULL,
    [sellOrder] VARCHAR(30) NULL,
    [buyClientCode] VARCHAR(50) NULL,
    [sellClientCode] VARCHAR(50) NULL,
    [buyRemark] VARCHAR(50) NULL,
    [sellRemark] VARCHAR(50) NULL,
    [buyPosition] VARCHAR(10) NULL,
    [sellPosition] VARCHAR(10) NULL,
    [BuyProprietorClientFlag] VARCHAR(10) NULL,
    [SellProprietorClientFlag] VARCHAR(10) NULL,
    [BuyOrderTimeStamp] DATETIME NULL,
    [SellOrderTimeStamp] DATETIME NULL,
    [BuyOrderActiveFlag] VARCHAR(10) NULL,
    [SellOrderActiveFlag] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsefotrdhist_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[bsefotrdhist_RENAMEDAS_PII]
(
    [TradeNumber] INT NULL,
    [TradeDateTime] DATETIME NULL,
    [TradeStatus] INT NULL,
    [SegmentIndicator] VARCHAR(5) NULL,
    [SettlementType] VARCHAR(5) NULL,
    [ProductType] VARCHAR(5) NULL,
    [ProductCode] VARCHAR(15) NULL,
    [AssetCode] VARCHAR(15) NULL,
    [ExpiryDate] DATETIME NULL,
    [StrikePrice] FLOAT NULL,
    [optiontype] VARCHAR(5) NULL,
    [CALevel] FLOAT NULL,
    [BuyBroker] FLOAT NULL,
    [SellBroker] FLOAT NULL,
    [TradePrice] FLOAT NULL,
    [TradeQuantity] INT NULL,
    [seriesid] INT NULL,
    [TradeBuyerlocation] VARCHAR(30) NULL,
    [buyCMCode] INT NULL,
    [SellCMCode] INT NULL,
    [tradeSellerLocation] VARCHAR(30) NULL,
    [buyCustodianParticipant] VARCHAR(50) NULL,
    [BuySideConfirmation] VARCHAR(10) NULL,
    [SellCustodialParticipant] VARCHAR(50) NULL,
    [SellSideConfirmation] VARCHAR(10) NULL,
    [BuyCoveredUncoveredFlag] CHAR(1) NULL,
    [SellCoveredUncoveredFlag] CHAR(1) NULL,
    [BuyOldCustodialParticipant] VARCHAR(50) NULL,
    [BuyOldCM] VARCHAR(50) NULL,
    [SellOldCustodialParticipant] VARCHAR(50) NULL,
    [SellOldCM] VARCHAR(50) NULL,
    [TradeBuyerTerminalID] INT NULL,
    [TradeSellerTerminalID] INT NULL,
    [buyOrder] VARCHAR(30) NULL,
    [sellOrder] VARCHAR(30) NULL,
    [buyClientCode] VARCHAR(50) NULL,
    [sellClientCode] VARCHAR(50) NULL,
    [buyRemark] VARCHAR(50) NULL,
    [sellRemark] VARCHAR(50) NULL,
    [buyPosition] VARCHAR(10) NULL,
    [sellPosition] VARCHAR(10) NULL,
    [BuyProprietorClientFlag] VARCHAR(10) NULL,
    [SellProprietorClientFlag] VARCHAR(10) NULL,
    [BuyOrderTimeStamp] DATETIME NULL,
    [SellOrderTimeStamp] DATETIME NULL,
    [BuyOrderActiveFlag] VARCHAR(10) NULL,
    [SellOrderActiveFlag] VARCHAR(10) NULL,
    [update_date] DATETIME NOT NULL,
    [username] VARCHAR(8) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsetable
-- --------------------------------------------------
CREATE TABLE [dbo].[bsetable]
(
    [clientid] VARCHAR(10) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [mapin] VARCHAR(1) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(20) NULL,
    [l_state] VARCHAR(15) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [phone] VARCHAR(15) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [depository] VARCHAR(7) NULL,
    [bankid] VARCHAR(8) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [passportdtl] VARCHAR(30) NULL,
    [PassportDateOfIssue] DATETIME NULL,
    [PassportPlaceOfIssue] VARCHAR(30) NULL,
    [passportdateofexpiry] DATETIME NULL,
    [votersiddtl] VARCHAR(30) NULL,
    [VoterIdDateOfIssue] DATETIME NULL,
    [VoterIdPlaceOfIssue] VARCHAR(30) NULL,
    [drivelicendtl] VARCHAR(30) NULL,
    [LicenceNoDateOfIssue] DATETIME NULL,
    [LicenceNoPlaceOfIssue] VARCHAR(30) NULL,
    [LicenceNoDateOfexpiry] DATETIME NULL,
    [rationcarddtl] VARCHAR(30) NULL,
    [RationCardDateOfIssue] DATETIME NULL,
    [RationCardPlaceOfIssue] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.crv_log
-- --------------------------------------------------
CREATE TABLE [dbo].[crv_log]
(
    [data] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.down
-- --------------------------------------------------
CREATE TABLE [dbo].[down]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.downnew1
-- --------------------------------------------------
CREATE TABLE [dbo].[downnew1]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.illScrip_Month_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[illScrip_Month_Temp]
(
    [Scrip_cd] VARCHAR(255) NULL,
    [ScriptName] VARCHAR(255) NULL,
    [UpdDated] VARCHAR(255) NULL,
    [Month] VARCHAR(10) NULL,
    [Year] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LastUpdTermMismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[LastUpdTermMismatch]
(
    [Date] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_noreco
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_noreco]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(30) NULL,
    [edt] DATETIME NULL,
    [acname] VARCHAR(80) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [balamt] MONEY NULL,
    [cltcode] VARCHAR(30) NULL,
    [ddno] VARCHAR(30) NULL,
    [vdt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(10) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_reco1
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_reco1]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(15) NULL,
    [vdt] DATETIME NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [ddno] VARCHAR(20) NULL,
    [cltcode] VARCHAR(50) NULL,
    [ddno1] VARCHAR(20) NULL,
    [cramt] MONEY NULL,
    [reldt] DATETIME NULL,
    [edt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncdx_noreco
-- --------------------------------------------------
CREATE TABLE [dbo].[ncdx_noreco]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(30) NULL,
    [edt] DATETIME NULL,
    [acname] VARCHAR(80) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [balamt] MONEY NULL,
    [cltcode] VARCHAR(30) NULL,
    [ddno] VARCHAR(30) NULL,
    [vdt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncdx_reco1
-- --------------------------------------------------
CREATE TABLE [dbo].[ncdx_reco1]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(15) NULL,
    [vdt] DATETIME NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [ddno] VARCHAR(20) NULL,
    [cltcode] VARCHAR(50) NULL,
    [ddno1] VARCHAR(20) NULL,
    [cramt] MONEY NULL,
    [reldt] DATETIME NULL,
    [edt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] NVARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newcode_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[newcode_RENAMEDAS_PII]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newcode1_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[newcode1_RENAMEDAS_PII]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_noreco
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_noreco]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(30) NULL,
    [edt] DATETIME NULL,
    [acname] VARCHAR(80) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [balamt] MONEY NULL,
    [cltcode] VARCHAR(30) NULL,
    [ddno] VARCHAR(30) NULL,
    [vdt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_reco1
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_reco1]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(15) NULL,
    [vdt] DATETIME NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [ddno] VARCHAR(20) NULL,
    [cltcode] VARCHAR(50) NULL,
    [ddno1] VARCHAR(20) NULL,
    [cramt] MONEY NULL,
    [reldt] DATETIME NULL,
    [edt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsebroktable
-- --------------------------------------------------
CREATE TABLE [dbo].[nsebroktable]
(
    [Table_no] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
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
-- TABLE dbo.nsebroktable1
-- --------------------------------------------------
CREATE TABLE [dbo].[nsebroktable1]
(
    [Table_no] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
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
-- TABLE dbo.nsefo_noreco
-- --------------------------------------------------
CREATE TABLE [dbo].[nsefo_noreco]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(30) NULL,
    [edt] DATETIME NULL,
    [acname] VARCHAR(80) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [balamt] MONEY NULL,
    [cltcode] VARCHAR(30) NULL,
    [ddno] VARCHAR(30) NULL,
    [vdt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(50) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsefo_reco1
-- --------------------------------------------------
CREATE TABLE [dbo].[nsefo_reco1]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(15) NULL,
    [vdt] DATETIME NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [ddno] VARCHAR(20) NULL,
    [cltcode] VARCHAR(50) NULL,
    [ddno1] VARCHAR(20) NULL,
    [cramt] MONEY NULL,
    [reldt] DATETIME NULL,
    [edt] DATETIME NULL,
    [narration] VARCHAR(200) NULL,
    [bankcode] NVARCHAR(10) NULL,
    [bankname] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsependinglist
-- --------------------------------------------------
CREATE TABLE [dbo].[nsependinglist]
(
    [brokerid] VARCHAR(255) NULL,
    [clcode] VARCHAR(255) NULL,
    [amt] VARCHAR(255) NULL,
    [segment] VARCHAR(255) NULL,
    [info] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.oldcode
-- --------------------------------------------------
CREATE TABLE [dbo].[oldcode]
(
    [clcode] VARCHAR(255) NULL,
    [proof] VARCHAR(255) NULL,
    [det1] VARCHAR(255) NULL,
    [date1] VARCHAR(255) NULL,
    [date2] VARCHAR(255) NULL,
    [place] VARCHAR(255) NULL,
    [sbcode] VARCHAR(255) NULL,
    [name] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.oldcode1
-- --------------------------------------------------
CREATE TABLE [dbo].[oldcode1]
(
    [clcode] VARCHAR(255) NULL,
    [proof] VARCHAR(255) NULL,
    [det1] VARCHAR(255) NULL,
    [date1] VARCHAR(255) NULL,
    [date2] VARCHAR(255) NULL,
    [place] VARCHAR(255) NULL,
    [sbcode] VARCHAR(255) NULL,
    [name] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception]
(
    [party_code] VARCHAR(30) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pm010207_new
-- --------------------------------------------------
CREATE TABLE [dbo].[pm010207_new]
(
    [OldClient] VARCHAR(20) NULL,
    [NewClient] VARCHAR(20) NULL,
    [ScripCode] NUMERIC(18, 0) NULL,
    [CAClass] VARCHAR(75) NULL,
    [NewCAClass] VARCHAR(75) NULL,
    [Quantity] INT NULL,
    [Rate] MONEY NULL,
    [BuySell] CHAR(4) NULL,
    [OrderID] NUMERIC(18, 0) NULL,
    [TradeID] NUMERIC(18, 0) NULL,
    [TraderID] NUMERIC(18, 0) NULL,
    [TraderDate] VARCHAR(15) NULL,
    [upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.replace_id
-- --------------------------------------------------
CREATE TABLE [dbo].[replace_id]
(
    [termid] VARCHAR(5) NULL,
    [ctclid] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sauda_subbrokers_details
-- --------------------------------------------------
CREATE TABLE [dbo].[sauda_subbrokers_details]
(
    [party_code] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [symbol] VARCHAR(20) NULL,
    [marketrate] MONEY NULL,
    [tradeqty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_bdaymail_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_bdaymail_RENAMEDAS_PII]
(
    [sb_cname] VARCHAR(75) NULL,
    [sb_tag] VARCHAR(10) NULL,
    [sb_name] VARCHAR(60) NULL,
    [sb_mailid] VARCHAR(200) NULL,
    [sb_dob] DATETIME NOT NULL,
    [sb_filename] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sebi_bannedFromintranet
-- --------------------------------------------------
CREATE TABLE [dbo].[Sebi_bannedFromintranet]
(
    [Pan_no] VARCHAR(50) NULL,
    [Party_code] VARCHAR(15) NULL,
    [Upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sebi_bannedFromintranet_new
-- --------------------------------------------------
CREATE TABLE [dbo].[Sebi_bannedFromintranet_new]
(
    [Pan_no] VARCHAR(50) NULL,
    [Party_code] VARCHAR(15) NULL,
    [Upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sebipartycode
-- --------------------------------------------------
CREATE TABLE [dbo].[sebipartycode]
(
    [Party Code] VARCHAR(255) NULL,
    [Pan No.] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.selftrade_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[selftrade_fin]
(
    [branch_name] CHAR(40) NULL,
    [Sauda_date] VARCHAR(62) NULL,
    [Series] VARCHAR(1) NULL,
    [Trade_no] VARCHAR(25) NULL,
    [Order_no] VARCHAR(25) NULL,
    [user_id] VARCHAR(20) NULL,
    [branchcode] VARCHAR(10) NULL,
    [branch_id] VARCHAR(50) NULL,
    [acname] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [scpname] VARCHAR(12) NULL,
    [sb] VARCHAR(4) NULL,
    [tradeqty] INT NULL,
    [marketrate] MONEY NULL,
    [net_trdqty] NUMERIC(10, 0) NULL,
    [our] NUMERIC(21, 11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sub_broker_list
-- --------------------------------------------------
CREATE TABLE [dbo].[sub_broker_list]
(
    [party_code] VARCHAR(25) NULL,
    [short_name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t_selftrade_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[t_selftrade_fin]
(
    [branch_name] CHAR(40) NULL,
    [Sauda_date] VARCHAR(62) NULL,
    [Series] VARCHAR(1) NULL,
    [Trade_no] VARCHAR(25) NULL,
    [Order_no] VARCHAR(25) NULL,
    [user_id] VARCHAR(20) NULL,
    [branchcode] VARCHAR(3) NULL,
    [branch_id] VARCHAR(50) NULL,
    [acname] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [scpname] VARCHAR(12) NULL,
    [sb] VARCHAR(4) NULL,
    [tradeqty] INT NULL,
    [marketrate] MONEY NULL,
    [net_trdqty] NUMERIC(10, 0) NULL,
    [our] NUMERIC(21, 11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_branchmail_tradechanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_branchmail_tradechanges]
(
    [FLD_DATE] VARCHAR(50) NULL,
    [OldBranch] VARCHAR(50) NULL,
    [OldSB] VARCHAR(50) NULL,
    [OLDClcd] VARCHAR(50) NULL,
    [OldClname] VARCHAR(150) NULL,
    [NewBranch] VARCHAR(50) NULL,
    [NewSB] VARCHAR(50) NULL,
    [NewCLcd] VARCHAR(50) NULL,
    [NewClname] VARCHAR(150) NULL,
    [Terminal_no] VARCHAR(50) NULL,
    [orderid] VARCHAR(50) NULL,
    [Quantity] VARCHAR(50) NULL,
    [Rate] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSE_Survelliance_profitreport
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSE_Survelliance_profitreport]
(
    [Date] VARCHAR(25) NULL,
    [OldRegion] VARCHAR(150) NULL,
    [OldBranch] VARCHAR(20) NULL,
    [OldSB] VARCHAR(20) NULL,
    [OLDClcd] NVARCHAR(255) NULL,
    [OldClname] VARCHAR(100) NULL,
    [OldAddress] VARCHAR(500) NULL,
    [OldActiveDate] VARCHAR(50) NULL,
    [OldInactiveDate] VARCHAR(50) NULL,
    [Newregion] VARCHAR(100) NULL,
    [NewBranch] VARCHAR(20) NULL,
    [NewSB] VARCHAR(20) NULL,
    [NewCLcd] VARCHAR(50) NULL,
    [NewClname] VARCHAR(100) NULL,
    [NewAddress] VARCHAR(500) NULL,
    [NewActiveDate] VARCHAR(50) NULL,
    [NewInactiveDate] VARCHAR(50) NULL,
    [Terminal_no] VARCHAR(50) NULL,
    [orderid] VARCHAR(50) NULL,
    [scriptcode] VARCHAR(50) NULL,
    [Buy/Sell] VARCHAR(50) NULL,
    [Quantity] VARCHAR(50) NULL,
    [Rate] VARCHAR(50) NULL,
    [Amount] VARCHAR(50) NULL,
    [Status] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSE_Survelliance_report_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSE_Survelliance_report_RENAMEDAS_PII]
(
    [Date] VARCHAR(25) NULL,
    [OldRegion] VARCHAR(150) NULL,
    [OldBranch] VARCHAR(20) NULL,
    [OldSB] VARCHAR(20) NULL,
    [OLDClcd] NVARCHAR(255) NULL,
    [OldClname] VARCHAR(100) NULL,
    [OldAddress] VARCHAR(500) NULL,
    [OldActiveDate] VARCHAR(50) NULL,
    [OldInactiveDate] VARCHAR(50) NULL,
    [Newregion] VARCHAR(100) NULL,
    [NewBranch] VARCHAR(20) NULL,
    [NewSB] VARCHAR(20) NULL,
    [NewCLcd] VARCHAR(50) NULL,
    [NewClname] VARCHAR(100) NULL,
    [NewAddress] VARCHAR(500) NULL,
    [NewActiveDate] VARCHAR(50) NULL,
    [NewInactiveDate] VARCHAR(50) NULL,
    [Terminal_no] VARCHAR(50) NULL,
    [orderid] VARCHAR(50) NULL,
    [scriptcode] VARCHAR(50) NULL,
    [Buy/Sell] VARCHAR(50) NULL,
    [Quantity] VARCHAR(50) NULL,
    [Rate] VARCHAR(50) NULL,
    [Amount] VARCHAR(50) NULL,
    [Status] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_consolidated_percentage
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_consolidated_percentage]
(
    [Fldbranch] VARCHAR(50) NULL,
    [Fldcount] VARCHAR(50) NULL,
    [Fldpercentage] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_consolitated_report
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_consolitated_report]
(
    [Date] VARCHAR(25) NULL,
    [OldRegion] VARCHAR(150) NULL,
    [OldBranch] VARCHAR(20) NULL,
    [OldSB] VARCHAR(20) NULL,
    [OLDClcd] NVARCHAR(255) NULL,
    [OldClname] VARCHAR(100) NULL,
    [OldAddress] VARCHAR(500) NULL,
    [OldActiveDate] VARCHAR(50) NULL,
    [OldInactiveDate] VARCHAR(50) NULL,
    [Newregion] VARCHAR(100) NULL,
    [NewBranch] VARCHAR(20) NULL,
    [NewSB] VARCHAR(20) NULL,
    [NewCLcd] VARCHAR(50) NULL,
    [NewClname] VARCHAR(100) NULL,
    [NewAddress] VARCHAR(500) NULL,
    [NewActiveDate] VARCHAR(50) NULL,
    [NewInactiveDate] VARCHAR(50) NULL,
    [Terminal_no] VARCHAR(50) NULL,
    [orderid] VARCHAR(50) NULL,
    [scriptcode] VARCHAR(50) NULL,
    [Buy/Sell] VARCHAR(50) NULL,
    [Quantity] VARCHAR(50) NULL,
    [Rate] VARCHAR(50) NULL,
    [Amount] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_consolitated_report1
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_consolitated_report1]
(
    [DATE] VARCHAR(11) NULL,
    [Old_RegionName] VARCHAR(100) NULL,
    [OldBranch] VARCHAR(20) NULL,
    [OldSB] VARCHAR(20) NULL,
    [OldClcd] NVARCHAR(255) NULL,
    [OldClname] VARCHAR(100) NULL,
    [Old_Address] VARCHAR(500) NULL,
    [Old_ActiveDate] VARCHAR(11) NULL,
    [Old_Inactivedate] VARCHAR(11) NULL,
    [NewRegion] VARCHAR(100) NULL,
    [NewBranch] VARCHAR(20) NULL,
    [NewSB] VARCHAR(20) NULL,
    [NewClcd] NVARCHAR(255) NULL,
    [NewClname] VARCHAR(100) NULL,
    [NewAddress] VARCHAR(500) NULL,
    [New_ActiveDate] VARCHAR(11) NULL,
    [New_Inactivedate] VARCHAR(11) NULL,
    [Terminal_no] FLOAT NULL,
    [orderid] VARCHAR(50) NULL,
    [Scriptcode] FLOAT NULL,
    [Quantity] FLOAT NULL,
    [Rate] FLOAT NULL,
    [Amount] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_illiquidscrip_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_illiquidscrip_upload]
(
    [Fld_Srno] INT IDENTITY(1,1) NOT NULL,
    [Fld_scrip_cd] INT NULL,
    [Fld_scrip_name] VARCHAR(350) NULL,
    [Fld_entry_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Region
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Region]
(
    [Reg_Code] NVARCHAR(255) NULL,
    [Reg_Name] NVARCHAR(255) NULL,
    [Contact_Person] NVARCHAR(255) NULL,
    [Email_ID] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sebi_banned
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sebi_banned]
(
    [Fld_srno] INT IDENTITY(1,1) NOT NULL,
    [Fld_partycode] VARCHAR(50) NULL,
    [Fld_panno] VARCHAR(10) NULL,
    [Fld_remark] VARCHAR(500) NULL,
    [Fld_fdate] DATETIME NULL,
    [Fld_tdate] DATETIME NULL,
    [Fld_updatedon] DATETIME NULL,
    [Fld_updatedby] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TotalTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TotalTrades]
(
    [Fld_Srno] INT IDENTITY(1,1) NOT NULL,
    [Fld_Date] DATETIME NULL,
    [Fld_Bse] NUMERIC(18, 0) NULL,
    [Fld_Nse] NUMERIC(18, 0) NULL,
    [Fld_Nsefo] NUMERIC(18, 0) NULL,
    [Fld_NseCds] NUMERIC(18, 0) NULL,
    [Fld_McxSx] NUMERIC(18, 0) NULL,
    [Fld_Mcx] NUMERIC(18, 0) NULL,
    [Fld_Ncdex] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_tradechanges_mailid
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_tradechanges_mailid]
(
    [Zone] VARCHAR(255) NULL,
    [Region] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Region_Mail] VARCHAR(500) NULL,
    [Branch_mail] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_tradecount_bse
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_tradecount_bse]
(
    [Fld_party_code] VARCHAR(50) NULL,
    [Fld_Count] INT NULL,
    [Fld_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_vanda_mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_vanda_mismatch]
(
    [partycode] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [BranchName] VARCHAR(255) NULL,
    [SubBroker] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbsetable
-- --------------------------------------------------
CREATE TABLE [dbo].[tbsetable]
(
    [party_code] VARCHAR(10) NULL,
    [long_name] VARCHAR(100) NULL,
    [activefrom] SMALLDATETIME NULL,
    [inactivefrom] DATETIME NULL,
    [todaydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [clientid] CHAR(16) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [mapin] VARCHAR(1) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(20) NULL,
    [l_state] VARCHAR(15) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [phone] VARCHAR(15) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [depository] VARCHAR(7) NULL,
    [bankid] VARCHAR(8) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [passportdtl] VARCHAR(30) NULL,
    [PassportDateOfIssue] DATETIME NULL,
    [PassportPlaceOfIssue] VARCHAR(30) NULL,
    [passportdateofexpiry] DATETIME NULL,
    [votersiddtl] VARCHAR(30) NULL,
    [VoterIdDateOfIssue] DATETIME NULL,
    [VoterIdPlaceOfIssue] VARCHAR(30) NULL,
    [drivelicendtl] VARCHAR(30) NULL,
    [LicenceNoDateOfIssue] DATETIME NULL,
    [LicenceNoPlaceOfIssue] VARCHAR(30) NULL,
    [LicenceNoDateOfexpiry] DATETIME NULL,
    [rationcarddtl] VARCHAR(30) NULL,
    [RationCardDateOfIssue] DATETIME NULL,
    [RationCardPlaceOfIssue] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_bdaymail_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_bdaymail_RENAMEDAS_PII]
(
    [sb_cname] VARCHAR(75) NULL,
    [sb_tag] VARCHAR(10) NULL,
    [sb_name] VARCHAR(60) NULL,
    [sb_mailid] VARCHAR(200) NULL,
    [sb_dob] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_bsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_bsecashtrd]
(
    [termid] INT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [branch_name] VARCHAR(50) NULL,
    [party_code] VARCHAR(20) NULL,
    [turnover] FLOAT NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_selftrade
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_selftrade]
(
    [branch_name] CHAR(40) NULL,
    [Sauda_date] VARCHAR(62) NULL,
    [Series] VARCHAR(1) NULL,
    [Trade_no] VARCHAR(25) NULL,
    [Order_no] VARCHAR(25) NULL,
    [user_id] VARCHAR(20) NULL,
    [branchcode] VARCHAR(3) NULL,
    [branch_id] VARCHAR(50) NULL,
    [acname] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [scpname] VARCHAR(12) NULL,
    [sb] VARCHAR(4) NULL,
    [tradeqty] INT NULL,
    [marketrate] MONEY NULL,
    [net_trdqty] NUMERIC(10, 0) NULL,
    [our] NUMERIC(21, 11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp2
-- --------------------------------------------------
CREATE TABLE [dbo].[temp2]
(
    [cl_code] VARCHAR(10) NULL,
    [bse] VARCHAR(10) NOT NULL,
    [nse] VARCHAR(10) NOT NULL,
    [nsefo] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.terminal_chng
-- --------------------------------------------------
CREATE TABLE [dbo].[terminal_chng]
(
    [TWS NO] FLOAT NULL,
    [SCRIP CODE] FLOAT NULL,
    [ORDER ID] FLOAT NULL,
    [TRADE ID] FLOAT NULL,
    [BUY/SELL] NVARCHAR(255) NULL,
    [OLD CLIENT] NVARCHAR(255) NULL,
    [NEW CLIENT] NVARCHAR(255) NULL,
    [QUANTITY] FLOAT NULL,
    [RATE (Rs#)] FLOAT NULL,
    [CLASS] NVARCHAR(255) NULL,
    [Upd_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.terminal_chng_new
-- --------------------------------------------------
CREATE TABLE [dbo].[terminal_chng_new]
(
    [OldClient] VARCHAR(20) NULL,
    [NewClient] VARCHAR(20) NULL,
    [ScripCode] NUMERIC(18, 0) NULL,
    [CAClass] VARCHAR(75) NULL,
    [NewCAClass] VARCHAR(75) NULL,
    [Quantity] INT NULL,
    [Rate] MONEY NULL,
    [BuySell] CHAR(4) NULL,
    [OrderID] NUMERIC(18, 0) NULL,
    [TradeID] NUMERIC(18, 0) NULL,
    [TraderID] NUMERIC(18, 0) NULL,
    [TraderDate] VARCHAR(15) NULL,
    [upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.termparty
-- --------------------------------------------------
CREATE TABLE [dbo].[termparty]
(
    [UserId] CHAR(10) NOT NULL,
    [Party_code] CHAR(10) NOT NULL,
    [tmark] VARCHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL,
    [procli] CHAR(10) NULL,
    [ExceptParty] CHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test
-- --------------------------------------------------
CREATE TABLE [dbo].[test]
(
    [clientid] CHAR(16) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [mapin] VARCHAR(1) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(20) NULL,
    [l_state] VARCHAR(15) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [phone] VARCHAR(15) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [depository] VARCHAR(7) NULL,
    [bankid] VARCHAR(8) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [passportdtl] VARCHAR(30) NULL,
    [PassportDateOfIssue] DATETIME NULL,
    [PassportPlaceOfIssue] VARCHAR(30) NULL,
    [passportdateofexpiry] DATETIME NULL,
    [votersiddtl] VARCHAR(30) NULL,
    [VoterIdDateOfIssue] DATETIME NULL,
    [VoterIdPlaceOfIssue] VARCHAR(30) NULL,
    [drivelicendtl] VARCHAR(30) NULL,
    [LicenceNoDateOfIssue] DATETIME NULL,
    [LicenceNoPlaceOfIssue] VARCHAR(30) NULL,
    [LicenceNoDateOfexpiry] DATETIME NULL,
    [rationcarddtl] VARCHAR(30) NULL,
    [RationCardDateOfIssue] DATETIME NULL,
    [RationCardPlaceOfIssue] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccapr
-- --------------------------------------------------
CREATE TABLE [dbo].[uccapr]
(
    [MEMBE] VARCHAR(255) NULL,
    [RID TWS NO] VARCHAR(255) NULL,
    [CLIENTID] VARCHAR(255) NULL,
    [CLTTYPE] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [SCRIPCODE] VARCHAR(255) NULL,
    [QTY] VARCHAR(255) NULL,
    [RATE] VARCHAR(255) NULL,
    [B/S] VARCHAR(255) NULL,
    [DATETIME] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UCCAPRIL
-- --------------------------------------------------
CREATE TABLE [dbo].[UCCAPRIL]
(
    [Col001] CHAR(1) NULL,
    [clcode] CHAR(1) NULL,
    [Col003] CHAR(2) NULL,
    [Col004] CHAR(3) NULL,
    [Col005] CHAR(125) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbse_upload_party_range_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbse_upload_party_range_temp]
(
    [party_code] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbse1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbse1]
(
    [Col001] CHAR(9) NULL,
    [Col002] CHAR(8) NULL,
    [clientid] CHAR(16) NULL,
    [Col004] CHAR(15) NULL,
    [Col005] CHAR(11) NULL,
    [Col006] CHAR(12) NULL,
    [Col007] CHAR(13) NULL,
    [Col008] CHAR(6) NULL,
    [Col009] CHAR(42) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbsefile
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbsefile]
(
    [clientid] VARCHAR(10) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [mapin] VARCHAR(1) NOT NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [long_name] VARCHAR(8000) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(40) NULL,
    [l_state] VARCHAR(50) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [phone] VARCHAR(8000) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [depository] VARCHAR(7) NULL,
    [bankid] VARCHAR(8) NULL,
    [cltdpid] VARCHAR(20) NULL,
    [passportdtl] VARCHAR(1) NULL,
    [passportdateofissue] VARCHAR(1) NULL,
    [passportplaceofissue] VARCHAR(1) NULL,
    [passportdateofexpiry] VARCHAR(1) NULL,
    [votersiddtl] VARCHAR(1) NULL,
    [voteriddateofissue] VARCHAR(1) NULL,
    [voteridplaceofissue] VARCHAR(1) NULL,
    [drivelicendtl] VARCHAR(1) NULL,
    [licencenodateofissue] VARCHAR(1) NULL,
    [licencenoplaceofissue] VARCHAR(1) NULL,
    [licencenodateofexpiry] VARCHAR(1) NULL,
    [rationcarddtl] VARCHAR(1) NULL,
    [rationcarddateofissue] VARCHAR(1) NULL,
    [rationcardplaceofissue] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbselist
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbselist]
(
    [TWS NO] VARCHAR(255) NULL,
    [CLIENTID] VARCHAR(255) NULL,
    [CLTTYPE] VARCHAR(255) NULL,
    [SCRIPCODE] VARCHAR(255) NULL,
    [QTY] VARCHAR(255) NULL,
    [RATE] VARCHAR(255) NULL,
    [B_S] VARCHAR(255) NULL,
    [DATETIME] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbselist1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbselist1]
(
    [clientid] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbsesuccess
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbsesuccess]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL,
    [CREATED_BY_ID] VARCHAR(255) NULL,
    [CREATED_BY_NAME] VARCHAR(255) NULL,
    [CREATED_DATE] VARCHAR(255) NULL,
    [MODIFIED_BY_ID] VARCHAR(255) NULL,
    [MODIFIED_BY_NAME] VARCHAR(255) NULL,
    [MODIFIED_DATE] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbsesuccess1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbsesuccess1]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL,
    [CREATED_BY_ID] VARCHAR(255) NULL,
    [CREATED_BY_NAME] VARCHAR(255) NULL,
    [CREATED_DATE] VARCHAR(255) NULL,
    [MODIFIED_BY_ID] VARCHAR(255) NULL,
    [MODIFIED_BY_NAME] VARCHAR(255) NULL,
    [MODIFIED_DATE] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccdown
-- --------------------------------------------------
CREATE TABLE [dbo].[uccdown]
(
    [Col001] VARCHAR(255) NULL,
    [Col002] VARCHAR(255) NULL,
    [Col003] VARCHAR(255) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] VARCHAR(255) NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL,
    [Col010] VARCHAR(255) NULL,
    [Col011] VARCHAR(255) NULL,
    [Col012] VARCHAR(255) NULL,
    [Col013] VARCHAR(255) NULL,
    [Col014] VARCHAR(255) NULL,
    [Col015] VARCHAR(255) NULL,
    [Col016] VARCHAR(255) NULL,
    [Col017] VARCHAR(255) NULL,
    [Col018] VARCHAR(255) NULL,
    [Col019] VARCHAR(255) NULL,
    [Col020] VARCHAR(255) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL,
    [Col025] VARCHAR(255) NULL,
    [Col026] VARCHAR(255) NULL,
    [Col027] VARCHAR(255) NULL,
    [Col028] VARCHAR(255) NULL,
    [Col029] VARCHAR(255) NULL,
    [Col030] VARCHAR(255) NULL,
    [Col031] VARCHAR(255) NULL,
    [Col032] VARCHAR(255) NULL,
    [Col033] VARCHAR(255) NULL,
    [Col034] VARCHAR(255) NULL,
    [Col035] VARCHAR(255) NULL,
    [Col036] VARCHAR(255) NULL,
    [Col037] VARCHAR(255) NULL,
    [Col038] VARCHAR(255) NULL,
    [Col039] VARCHAR(255) NULL,
    [Col040] VARCHAR(255) NULL,
    [Col041] VARCHAR(255) NULL,
    [Col042] VARCHAR(255) NULL,
    [Col043] VARCHAR(255) NULL,
    [Col044] VARCHAR(255) NULL,
    [Col045] VARCHAR(255) NULL,
    [Col046] VARCHAR(255) NULL,
    [Col047] VARCHAR(255) NULL,
    [Col048] VARCHAR(255) NULL,
    [Col049] VARCHAR(255) NULL,
    [Col050] VARCHAR(255) NULL,
    [Col051] VARCHAR(255) NULL,
    [Col052] VARCHAR(255) NULL,
    [Col053] VARCHAR(255) NULL,
    [Col054] VARCHAR(255) NULL,
    [Col055] VARCHAR(255) NULL,
    [Col056] VARCHAR(255) NULL,
    [Col057] VARCHAR(255) NULL,
    [Col058] VARCHAR(255) NULL,
    [Col059] VARCHAR(255) NULL,
    [Col060] VARCHAR(255) NULL,
    [Col061] VARCHAR(255) NULL,
    [Col062] VARCHAR(255) NULL,
    [Col063] VARCHAR(255) NULL,
    [Col064] VARCHAR(255) NULL,
    [Col065] VARCHAR(255) NULL,
    [Col066] VARCHAR(255) NULL,
    [Col067] VARCHAR(255) NULL,
    [Col068] VARCHAR(255) NULL,
    [Col069] VARCHAR(255) NULL,
    [Col070] VARCHAR(255) NULL,
    [Col071] VARCHAR(255) NULL,
    [Col072] VARCHAR(255) NULL,
    [Col073] VARCHAR(255) NULL,
    [Col074] VARCHAR(255) NULL,
    [Col075] VARCHAR(255) NULL,
    [Col076] VARCHAR(255) NULL,
    [Col077] VARCHAR(255) NULL,
    [Col078] VARCHAR(255) NULL,
    [Col079] VARCHAR(255) NULL,
    [Col080] VARCHAR(255) NULL,
    [Col081] VARCHAR(255) NULL,
    [Col082] VARCHAR(255) NULL,
    [Col083] VARCHAR(255) NULL,
    [Col084] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccfile_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[uccfile_temp]
(
    [clientid] CHAR(16) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [mapin] VARCHAR(1) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(20) NULL,
    [l_state] VARCHAR(15) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [phone] VARCHAR(15) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [depository] VARCHAR(7) NULL,
    [bankid] VARCHAR(8) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [passportdtl] VARCHAR(30) NULL,
    [PassportDateOfIssue] DATETIME NULL,
    [PassportPlaceOfIssue] VARCHAR(30) NULL,
    [passportdateofexpiry] DATETIME NULL,
    [votersiddtl] VARCHAR(30) NULL,
    [VoterIdDateOfIssue] DATETIME NULL,
    [VoterIdPlaceOfIssue] VARCHAR(30) NULL,
    [drivelicendtl] VARCHAR(30) NULL,
    [LicenceNoDateOfIssue] DATETIME NULL,
    [LicenceNoPlaceOfIssue] VARCHAR(30) NULL,
    [LicenceNoDateOfexpiry] DATETIME NULL,
    [rationcarddtl] VARCHAR(30) NULL,
    [RationCardDateOfIssue] DATETIME NULL,
    [RationCardPlaceOfIssue] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccpending
-- --------------------------------------------------
CREATE TABLE [dbo].[uccpending]
(
    [MEMBERID] CHAR(9) NULL,
    [TWS NO] CHAR(8) NULL,
    [CLIENTID] CHAR(16) NULL,
    [CLTTYPE] CHAR(15) NULL,
    [SCRIPCODE] CHAR(11) NULL,
    [QTY] CHAR(12) NULL,
    [RATE] CHAR(13) NULL,
    [B/S] CHAR(6) NULL,
    [DATETIME] CHAR(42) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccpendinglist
-- --------------------------------------------------
CREATE TABLE [dbo].[uccpendinglist]
(
    [clientid] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccpendinglist1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccpendinglist1]
(
    [clcode] VARCHAR(25) NULL,
    [item] VARCHAR(50) NULL,
    [itemdetail] VARCHAR(50) NULL,
    [itemiss] VARCHAR(25) NULL,
    [itemexp] VARCHAR(25) NULL,
    [itemplace] VARCHAR(50) NULL,
    [introcode] VARCHAR(25) NULL,
    [introname] VARCHAR(50) NULL,
    [tradedate] VARCHAR(25) NULL,
    [Col010] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccsuccess_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[uccsuccess_RENAMEDAS_PII]
(
    [BROKER ID] VARCHAR(255) NULL,
    [BRANCH OFFICE ID] VARCHAR(255) NULL,
    [SUB BROKER ID] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT CODE] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME] VARCHAR(255) NULL,
    [FATHER HUSBAND NAME] VARCHAR(255) NULL,
    [NON INDIVIDUAL CLIENT NAME] VARCHAR(255) NULL,
    [ CONTACT PERSON NAME] VARCHAR(255) NULL,
    [ ADDR 1] VARCHAR(255) NULL,
    [ ADDR 2] VARCHAR(255) NULL,
    [ CITY] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [ COUNTRY] VARCHAR(255) NULL,
    [PINCODE] VARCHAR(255) NULL,
    [PHONE NO] VARCHAR(255) NULL,
    [FAX NO] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [ DATE OF BIRTH] VARCHAR(255) NULL,
    [EDUCATIONAL QUALIFICATION] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [ CLIENT AGGR DATE] VARCHAR(255) NULL,
    [INTRO SURNAME] VARCHAR(255) NULL,
    [INTRO FIRST NAME] VARCHAR(255) NULL,
    [ INTRO MIDDLE NAME] VARCHAR(255) NULL,
    [INTRO RELATION] VARCHAR(255) NULL,
    [INTRO CLIENT ID] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [ PAN DECL OBTAINED] VARCHAR(255) NULL,
    [PASSPORT NO] VARCHAR(255) NULL,
    [PASSPORT ISSUE PLACE] VARCHAR(255) NULL,
    [PASSPORT ISSUE DATE] VARCHAR(255) NULL,
    [PASSPORT EXPIRY DATE] VARCHAR(255) NULL,
    [DRIVING LICENSE NO] VARCHAR(255) NULL,
    [DRIVING LICENSE ISSUE PLACE] VARCHAR(255) NULL,
    [DRIVING LICENSE ISSUE DATE] VARCHAR(255) NULL,
    [DRIVING LICENSE EXPIRY DATE] VARCHAR(255) NULL,
    [VOTER ID NO] VARCHAR(255) NULL,
    [VOTER ID ISSUE PLACE] VARCHAR(255) NULL,
    [VOTER ID ISSUE DATE] VARCHAR(255) NULL,
    [RATION CARD NO] VARCHAR(255) NULL,
    [ RATION CARD ISSUE PLACE] VARCHAR(255) NULL,
    [RATION CARD ISSUE DATE] VARCHAR(255) NULL,
    [BANK CERT OBTAINED] VARCHAR(255) NULL,
    [BANK NAME] VARCHAR(255) NULL,
    [BANK BRANCH ADDR] VARCHAR(255) NULL,
    [BANK MICR NO] VARCHAR(255) NULL,
    [BANK ACC TYPE] VARCHAR(255) NULL,
    [BANK ACC NO] VARCHAR(255) NULL,
    [DEPOSITORY NAME] VARCHAR(255) NULL,
    [DEPOSITORY PARTICIPANT NAME] VARCHAR(255) NULL,
    [DEPOSITORY ID] VARCHAR(255) NULL,
    [REGISTRATION NO] VARCHAR(255) NULL,
    [REGISTRATION AUTH] VARCHAR(255) NULL,
    [REGISTRATION PLACE] VARCHAR(255) NULL,
    [REGISTRATION DATE] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB BROKER CLIENT] VARCHAR(255) NULL,
    [SUB BROKER NAME] VARCHAR(255) NULL,
    [SUB BROKER SEBI REGISTRATION NO] VARCHAR(255) NULL,
    [FAMILY MEMB ACC] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE1] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE2] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE3] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE4] VARCHAR(255) NULL,
    [FAMILY MEMB1] VARCHAR(255) NULL,
    [FAMILY MEMB2] VARCHAR(255) NULL,
    [FAMILY MEMB3] VARCHAR(255) NULL,
    [FAMILY MEMB4] VARCHAR(255) NULL,
    [ACC.WITH OTHER MEMB] VARCHAR(255) NULL,
    [OTHER MEMB CMID1] VARCHAR(255) NULL,
    [OTHER MEMB CMID2] VARCHAR(255) NULL,
    [OTHER MEMB CMID3] VARCHAR(255) NULL,
    [OTHER MEMB CMID4] VARCHAR(255) NULL,
    [CREATED BY ID] VARCHAR(255) NULL,
    [CREATED BY NAME] VARCHAR(255) NULL,
    [CREATED DATE] VARCHAR(255) NULL,
    [MODIFIED BY ID] VARCHAR(255) NULL,
    [MODIFIED BY NAME] VARCHAR(255) NULL,
    [MODIFIED DATE] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.bse_mismatch_deepak1view1
-- --------------------------------------------------
create view bse_mismatch_deepak1view1
as
select * from anand.bsedb_ab.dbo.bse_mismatch_deepak1view
where party_code in (select distinct party_code from bsecashtrd)

GO

-- --------------------------------------------------
-- VIEW dbo.bse1
-- --------------------------------------------------

CREATE view [dbo].[bse1]
as
select party_code,long_name,activefrom,inactivefrom  from   
AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5  
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()  
and party_code in (select party_code from (select distinct party_code from bsecashtrd  )as a1)

GO

-- --------------------------------------------------
-- VIEW dbo.bseproc1
-- --------------------------------------------------
create view bseproc1
as
select distinct party_code  from bsecashtrd

GO

-- --------------------------------------------------
-- VIEW dbo.bseproc2
-- --------------------------------------------------
create view bseproc2
as
select *  from bsecashtrd

GO

-- --------------------------------------------------
-- VIEW dbo.bseview1
-- --------------------------------------------------

CREATE view [dbo].[bseview1] 
as
select party_code,long_name,activefrom,inactivefrom  from   
AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5  
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()  
and party_code in (select distinct party_code from bsecashtrd)

GO

-- --------------------------------------------------
-- VIEW dbo.m1
-- --------------------------------------------------
create view m1
as
select termid,scrip_cd,symbol  from bse.dbo.bsecashtrd

GO

-- --------------------------------------------------
-- VIEW dbo.v_bse_cl_advance
-- --------------------------------------------------
CREATE view v_bse_cl_advance              
as             
Select distinct bsecashtrd.party_code,bse_termid.termid ,bse_termid.branch_name,  
bse_termid.branch_cd,bse_termid.sub_broker status  from bsecashtrd left join bse_termid   
on bsecashtrd.termid = bse_termid.termid where bsecashtrd.party_code in (Select party_code from tbsetable)

GO

-- --------------------------------------------------
-- VIEW dbo.V_INS_Clients
-- --------------------------------------------------

CREATE View [dbo].[V_INS_Clients]
as

select cl_code from 
(select * from AngelBSECM.msajag.dbo.client_details where Cl_type = 'INS')x
inner join
(select * from bsecashtrd (nolock))y
on x.cl_code = y.Party_Code

GO

-- --------------------------------------------------
-- VIEW dbo.v_Missing_cli
-- --------------------------------------------------

CREATE VIEW [dbo].[v_Missing_cli]    
as       

 
Select party_code,Termid from bsecashtrd (nolock) where party_code not in 
(select party_code from AngelBSECM.bsedb_ab.dbo.client2 c2, AngelBSECM.bsedb_ab.dbo.client5 c5 
where c2.cl_code = c5.cl_code and convert(datetime ,c5.inactivefrom ,103) >= convert(datetime ,getdate(),103))

GO

-- --------------------------------------------------
-- VIEW dbo.V_SebiBannedEntity
-- --------------------------------------------------
CREATE View V_SebiBannedEntity  
as  
  
select fld_partycode,termid,party_code,symbol,tradeqty from   
(select * from tbl_sebi_banned with(nolock))x  
inner join  
(select * from bsecashtrd (nolock))y  
on x.fld_partycode = y.Party_Code

GO

