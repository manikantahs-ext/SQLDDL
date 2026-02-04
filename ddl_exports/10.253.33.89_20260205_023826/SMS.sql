-- DDL Export
-- Server: 10.253.33.89
-- Database: SMS
-- Exported: 2026-02-05T02:39:29.164525

USE SMS;
GO

-- --------------------------------------------------
-- FUNCTION dbo.FN_GET_TIME
-- --------------------------------------------------
CREATE FUNCTION DBO.FN_GET_TIME(@TIME VARCHAR(8),@AMPM VARCHAR(8))
RETURNS TIME
AS
BEGIN
	DECLARE @T TIME
	
	SELECT @T = 
		CONVERT(TIME,
					CASE WHEN @TIME = '' 
							THEN '12:01' 
							ELSE CASE WHEN CONVERT(INT,LEFT(@TIME,CHARINDEX(':',@TIME)-1)) > 12 
									THEN CONVERT(VARCHAR,CONVERT(INT,LEFT(@TIME,CHARINDEX(':',@TIME)-1))-12)+ RIGHT(@TIME,LEN(@TIME)-CHARINDEX(':',@TIME)+1)
									ELSE @TIME 
								END 
					END + 
					CASE WHEN @AMPM = '' AND @TIME = ''
							THEN 'AM' 
							ELSE CASE WHEN CONVERT(INT,LEFT(@TIME,CHARINDEX(':',@TIME)-1)) > 12 
									THEN 'PM'
									ELSE @AMPM
								END 
					END
				)
	RETURN @T
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.split
-- --------------------------------------------------
CREATE FUNCTION split(
    @delimited NVARCHAR(MAX),
    @delimiter NVARCHAR(100)
) RETURNS @t TABLE (id INT IDENTITY(1,1), val NVARCHAR(MAX))
AS
BEGIN
    DECLARE @xml XML
    SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'
    INSERT INTO @t(val)
    SELECT  r.value('.','varchar(MAX)') as item
    FROM  @xml.nodes('/t') as records(r)
    RETURN
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.SplitString
-- --------------------------------------------------
create function SplitString
(   
    @str varchar(max),
    @length int
)
returns @Results table( Result varchar(50) ) 
AS
begin
    declare @s varchar(50)
    while len(@str) > 0
    begin
        set @s = left(@str, @length)
        set @str = right(@str, len(@str) - @length)
        insert @Results values (@s)
    end
    return 
end

GO

-- --------------------------------------------------
-- INDEX dbo.sms
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_purpose] ON [dbo].[sms] ([to_no], [purpose])

GO

-- --------------------------------------------------
-- INDEX dbo.sms
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_purpose] ON [dbo].[sms] ([purpose], [date])

GO

-- --------------------------------------------------
-- INDEX dbo.sms
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sms] ON [dbo].[sms] ([flag], [to_no], [date])

GO

-- --------------------------------------------------
-- INDEX dbo.SMS_CNS_Response
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_srno] ON [dbo].[SMS_CNS_Response] ([srno])

GO

-- --------------------------------------------------
-- INDEX dbo.sms_new
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_purpose_1] ON [dbo].[sms_new] ([to_no], [purpose])

GO

-- --------------------------------------------------
-- INDEX dbo.sms_new
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_purpose_1] ON [dbo].[sms_new] ([purpose], [date])

GO

-- --------------------------------------------------
-- INDEX dbo.sms_new
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_purpose1] ON [dbo].[sms_new] ([purpose], [message]) INCLUDE ([to_no], [date], [time], [flag], [ampm])

GO

-- --------------------------------------------------
-- INDEX dbo.sms_new
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sms_1] ON [dbo].[sms_new] ([flag], [to_no], [date])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_SMS_NRMS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SMS_NRMS_FastJoin] ON [dbo].[Tbl_SMS_NRMS] ([Party_code], [purpose], [Requestdate])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BI_SMS_Send
-- --------------------------------------------------
CREATE procedure BI_SMS_Send(@num as varchar(10),@msg as varchar(480),@purpose as varchar(100))            
          
as            
          
set nocount on          
          
if isnumeric(@num) =1 and len(@num)=10           
begin          
--declare @msg1 varchar(160)  
-- if (LEN(@msg)>160)  
--  begin   
--   set @msg1=SUBSTRING(@msg,161,160)     
--   insert into sms.dbo.sms values             
--  (@num,@msg1,convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P',right(convert(varchar(25),getdate()),2),@purpose)            
--  select 'SMS Sent' as mess   
     
--   --print '1'  
--   if (LEN(@msg)>320)  
--    begin   
--     set @msg1=SUBSTRING(@msg,321,160)   
       
--     insert into sms.dbo.sms values             
--  (@num,@msg1,convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P',right(convert(varchar(25),getdate()),2),@purpose)            
--  select 'SMS Sent' as mess     
--     --print '2'  
--    end  
--  end   
-- else   
-- begin  
--  insert into sms.dbo.sms values             
--  (@num,@msg,convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P',right(convert(varchar(25),getdate()),2),@purpose)            
--  select 'SMS Sent' as mess          
-- end  
--end 
  insert into sms.dbo.sms values             
  (@num,@msg,convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P',right(convert(varchar(25),getdate()),2),@purpose)            
  select 'SMS Sent' as mess           
end
else          
begin          
 select 'Invalid Mobile No.' as mess          
end          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CNS_S2S_token
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CNS_S2S_token](@accesstoken varchar(max) =null)
As 
Begin
	    truncate table CNS_Token
		insert into CNS_Token  (ServiceName,AccesstokenValue,UpdatedOn)
		select 'CNS',@accesstoken,GETDATE()

  		select * FROM CNS_Token WITH(NOLOCK)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CNS_S2S_token_UAT
-- --------------------------------------------------
create PROCEDURE [dbo].[CNS_S2S_token_UAT](@accesstoken varchar(max) =null)
As 
Begin
	    truncate table CNS_Token_uat
		insert into CNS_Token_uat  (ServiceName,AccesstokenValue,UpdatedOn)
		select 'CNS',@accesstoken,GETDATE()

  		select * FROM CNS_Token_uat WITH(NOLOCK)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FAILURE_CLIENTSMS
-- --------------------------------------------------



/*-------------
CREATED BY NAVIN
PURPOSE:	ALERTING ON MOBILE NUMBER FAILURE
DATE: 27/03/2012
-----------------------------
-----------------------------*/



CREATE PROC  FAILURE_CLIENTSMS
AS 
DECLARE
@check INT

SELECT C.PARTY_CODE as 'Client Code',C.SHORT_NAME 'Client Name',S.TO_NO AS 'Mobile Number',S.PURPOSE as 'Purpose',Date,Time + S.AMPM as 'Time'
,CASE 
WHEN LEFT(TO_NO,1) = '0' THEN 'Mobile number starts with zero' 
WHEN LEN(TO_NO)<10 THEN 'Mobile no length doesn’t match to 10 digits'
WHEN ISNUMERIC(TO_NO) = 0 THEN 'Mobile Number has alphabets or character'
ELSE 'Invalid Mobile Numbers' END Reasons
INTO #SMS1
FROM SMS S
INNER JOIN 
RISK.DBO.CLIENT_DETAILS C
ON S.TO_NO = C.MOBILE_PAGER
WHERE DATE = CONVERT(VARCHAR(11),GETDATE()-1,103) AND FLAG = 'P'
AND TO_NO <> '0' AND (TO_NO <> '' AND TO_NO IS NOT NULL) AND  (len(TO_NO) <> 10 or
(len(TO_NO) = 10 and LEFT(TO_NO,1) = '0' ))

SELECT @check = count('Mobile Number') from #SMS1 
SELECT  ROW_NUMBER() OVER(ORDER BY Date) AS  'ROWNUM',* INTO #SMS                      
FROM #SMS1

if (@check > 0)
BEGIN
 DECLARE 
 @TABLEXML AS NVARCHAR(MAX);
SET 
@TABLEXML =
 N'Dear Team,<BR><BR>' +                                                                                       
 N'Kindly find the below list for the Failed Client SMS. Kindly do The needful.
<BR><BR>'+
 N'<TABLE  BORDER="1" ALIGN="CENTER" CELLPADDING="0" CELLSPACING="0" BORDERCOLOR="#FFFFFF" BGCOLOR="#D5C9F1"                   
 STYLE="BORDER:#000000 SOLID 1PX;FONT-SIZE:15PX;FONT-FAMILY:ARIAL">'                                                                                                 
                    
 +N'<TR>'                                     
 +N'<TD HEIGHT="15" COLSPAN="8" BGCOLOR="#2C204B" ALIGN=CENTER><FONT COLOR=WHITE SIZE="3"><B>SMS Failure</B></FONT> </TD>'                                                  
 +N'</TR>' +                                                                                                                                                              
 +N'<TR>'                                                     
 +N'<TD WIDTH: 100%; HEIGHT: 21PX; BGCOLOR="#AA98D3">SR. NO</TD> '                                                  
 +N'<TD "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">CLIENT CODE</TD> '                                                                                                                                                            
 +N'<TD  "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">CLIENT NAME</TD> '                        
 +N'<TD  "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">MOBILE NUMBER</TD> '     
 +N'<TD  "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">PURPOSE</TD> '                        
 +N'<TD  "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">DATE</TD> '                        
 +N'<TD  "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">TIME</TD> '                        
 +N'<TD  "WIDTH: 100%; HEIGHT: 21PX;" BGCOLOR="#AA98D3">REASONS</TD> '                        
 +N'</TR>'+                    
                     
                   
 CAST((SELECT                  
 TD =  [ROWNUM],'',                                 
 TD = [Client Code],'',                                   
 TD = [Client Name], '',
 TD = [Mobile Number], '',                                   
 TD = [Purpose], '',
 TD = [Date], '',
 TD = [Time], '',
 TD = [Reasons], ''
      FROM #sms  
      FOR XML PATH('TR'),TYPE) AS NVARCHAR(MAX)) +                     
                          
 '</TR>' +                     
 +N' </TABLE><BR><BR><BR><BR>'                     
                                  
 +N' <TABLE> '+                                    
 +N'THIS IS AN AUTOMATED SYSTEM GENERATED INFORMATION FOR YOUR REFERENCE.PLEASE DO NOT REPLY.<BR>ANGEL BROKING '                     
declare
@cur_date varchar(max)
 set @cur_date = (select 'Failure SMS-CLI dated : '+ convert(varchar(11),(getdate()-1),103))
 
EXEC MSDB.DBO.SP_SEND_DBMAIL                                                                                                               
@RECIPIENTS  = 'KYC.CSO@ANGELBROKING.COM;',              
@COPY_RECIPIENTS = '',                                                                                                                   
@BLIND_COPY_RECIPIENTS= '',          
@PROFILE_NAME = 'Intranet',                                                                                                              
@BODY_FORMAT ='HTML',                                   
@SUBJECT = @cur_date ,
@BODY = @TABLEXML

PRINT @TABLEXML  
                    
drop table #sms1
drop table #sms		

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_CNS_Autentication
-- --------------------------------------------------
-- =============================================  
-- Author:  Neha Naiwar  
-- Create date: 27 Jun 2023  
-- =============================================  
Create PROCEDURE [dbo].[Get_CNS_Autentication]  
As   
Begin  
select ServiceName,AccesstokenValue,UpdatedOn from CNS_Token with(nolock) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_CNS_Autentication_NRMS
-- --------------------------------------------------
-- =============================================  
-- Author:  Abha JAiswal
-- Create date: Dec 12 2023  
-- =============================================  
CREATE PROCEDURE [dbo].[Get_CNS_Autentication_NRMS]  
As   
Begin  
select ServiceName,AccesstokenValue,UpdatedOn from CNS_Token with(nolock) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_CNS_Autentication_NRMS_16Aug2023
-- --------------------------------------------------
-- =============================================  
-- Author:  Abha JAiswal
-- Create date: Dec 12 2023  
-- =============================================  
create PROCEDURE [dbo].[Get_CNS_Autentication_NRMS_16Aug2023]  
As   
Begin  
select ServiceName,AccesstokenValue,UpdatedOn from CNS_Token_NRMS with(nolock) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_CNS_Autentication_S2S
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Get_CNS_Autentication_S2S]  
As   
Begin  
 if (select COUNT(1) from CNS_Token with(nolock) where convert(date,updatedOn, 103)=convert(date, getdate(), 103))>0  
 begin  
  select ServiceName,AccesstokenValue,UpdatedOn from CNS_Token with(nolock) 

 end  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_CNS_Autentication_S2S_UAT
-- --------------------------------------------------
create PROCEDURE [dbo].[Get_CNS_Autentication_S2S_UAT]  
As   
Begin  
 if (select COUNT(1) from CNS_Token_uat with(nolock) where convert(date,updatedOn, 103)=convert(date, getdate(), 103))>0  
 begin  
  select ServiceName,AccesstokenValue,UpdatedOn from CNS_Token_uat with(nolock) 

 end  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS
-- --------------------------------------------------
-- =============================================                      
-- Author:  Neha Naiwar                      
-- Create date: 27 Jun 2023                      
-- =============================================                      
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS]                      
As                       
Begin                      
                  
select *  into #sms                       
from dbo.tbl_SMS with (nolock)                       
where date= CONVERT(varchar,GETDATE(),103) and flag='P'    
and purpose in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion','Payout Exception','Payout Rejection',  
'Aggregator Verification Stop','Payout Cancellation','Brokerage Tariff For 15',  
'Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Broker_Payout','ECN Activation','Modify_Mobile no','Trade File Missing','Service Implicit','DPAMC') /*'DormantToReactive'*/

update #sms set message=message+' Regards - Angel One'  where purpose in ('Service Implicit','ECN Activation')   
                  
insert into tbl_sms_withouturl_processlog_CNS                      
select getdate(),ss=(select count(1) from #sms),''                     
                  
insert into tbl_SMS_CNS(party_code,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
select party_code,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                     
          
update I set flag='A' from tbl_SMS I, tbl_SMS_CNS S                           
where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
                 
/*select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<=3     
  
update SMS_Sent_CNS set  NoOfAttempt=NoOfAttempt +1 where   flag='P' and NoOfAttempt<=3    
 */  
   
select top 10000 a.*,b.TemplateID,notification_type into #tmpsms   
from tbl_SMS_CNS a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose   
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3     
order by a.srno   
               
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
from tbl_SMS_CNS a  
inner join #tmpsms b on a.srno=b.Srno   
where   a.flag='P'          
  
select * from #tmpsms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_13May2025
-- --------------------------------------------------
-- =============================================                      
-- Author:  Neha Naiwar                      
-- Create date: 27 Jun 2023                      
-- =============================================                      
create PROCEDURE [dbo].[Get_Inhouse_SMS_13May2025]                      
As                       
Begin                      
                  
select *  into #sms                       
from dbo.sms with (nolock)                       
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''   
and purpose in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion','Payout Exception','Payout Rejection',  
'Aggregator Verification Stop','Payout Cancellation','Brokerage Tariff For 15',  
'Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Broker_Payout','ECN Activation','Modify_Mobile no','Trade File Missing','Service Implicit','DPAMC') /*'DormantToReactive'*/

update #sms set message=message+' Regards - Angel One'  where purpose in ('Service Implicit','ECN Activation')   
                  
insert into tbl_sms_withouturl_processlog_CNS                      
select getdate(),ss=(select count(1) from #sms),''                     
                  
insert into SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
          
update sms set flag='A' from sms I, SMS_Sent_CNS S                           
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
                 
/*select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<=3     
  
update SMS_Sent_CNS set  NoOfAttempt=NoOfAttempt +1 where   flag='P' and NoOfAttempt<=3    
 */  
   
select top 10000 a.*,b.TemplateID,notification_type into #tmpsms   
from SMS_Sent_CNS a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose   
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3     
order by a.srno   
               
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
from SMS_Sent_CNS a  
inner join #tmpsms b on a.srno=b.Srno   
where   a.flag='P'          
  
select * from #tmpsms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_ForCheck
-- --------------------------------------------------
-- =============================================                      
-- Author:  Neha Naiwar                      
-- Create date: 27 Jun 2023                      
-- =============================================                      
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_ForCheck]                      
As                       
Begin                      
                  
--select *  into #sms                       
--from dbo.sms with (nolock)                       
--where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''   
--and purpose in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion','Payout Exception','Payout Rejection',  
--'Aggregator Verification Stop','Payout Cancellation','Ageing Day7','NBFC Day 7','MTF Day7','Tday','Brokerage Tariff For 15',  
--'Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Sebi PreSMS','SEBI Circular Funds Payout')                   
      
--insert into #sms       
--select to_no,message,[DATE],[TIME],flag,ampm,purpose    
--from [196.1.115.182].general.dbo.nrms_sms_cns with (nolock)                       
--where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
--and purpose in ('Ageing Day5','Ageing Day6','T day Eve','Tday')         
                  
--insert into tbl_sms_withouturl_processlog_CNS                      
--select getdate(),ss=(select count(1) from #sms),''                     
                  
--insert into SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
--select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
          
--update sms set flag='A' from sms I, SMS_Sent_CNS S                           
--where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
    
    
--update [196.1.115.182].general.dbo.nrms_sms_cns set flag='A' from [196.1.115.182].general.dbo.nrms_sms_cns I, SMS_Sent_CNS S                           
--where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
                      
                      
/*select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<=3     
  
update SMS_Sent_CNS set  NoOfAttempt=NoOfAttempt +1 where   flag='P' and NoOfAttempt<=3    
 */  
   
select top 4000 a.*,b.TemplateID into #tmpsms   
from SMS_Sent_CNS a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose   
where flag='P' and  a.entrydate<'2023-07-12 09:30:55.743' and NoOfAttempt<3     
order by a.srno   
               
--update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
--from SMS_Sent_CNS a  
--inner join #tmpsms b on a.srno=b.Srno   
--where   a.flag='P'          
  
select * from #tmpsms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_NRMS_NEW
-- --------------------------------------------------
    
-- =============================================                          
-- Author:  Abha Jaiswal                          
-- Create date: Nov 28 2025                       
-- =============================================                          
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_NRMS_NEW]                          
As                           
Begin       
       
 select * into #commodity
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS with (nolock)                           
 where cast(upd_date as date)= cast(getdate() as date) 
 and status='P' 
 and Party_code is not null and Party_code<>'' 
 and purpose in ('Expiry','ITM','Tender')

 select  C.*,scrip_name
 into #final 
 from #commodity C 
 inner join [CSOKYC-6].general.dbo.CommoditySMSToClient C1 with (nolock)
 on C.purpose=C1.sms_type
 and C.party_code=C1.cl_code

 select top 4000 *  into #sms                
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS with (nolock)                           
 where cast(upd_date as date)= cast(getdate() as date) and status='P' 
 and Party_code is not null and Party_code<>'' 
 
 insert into tbl_sms_withouturl_processlog_CNS                          
 select getdate(),ss=(select count(1) from #sms),''  
 
 ----delete from Tbl_SMS_NRMS where Party_code='S215178'
 ----and Party_code='S215178
                      
 insert into Tbl_SMS_NRMS                      
 select  Party_code,to_no=Mobile_no,Amount1,Amount2,Amount3,Date1,Date2,message=sms_content,url,flag='P',  
 SMS_Type,Upd_date,Request='',Response='',Requestdate=GETDATE(),purpose,NoOfAttempt=0   
 from #sms            

 update I set Status='A'   
 from 
 (
 select * from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS 
 where cast(upd_date as date)=cast(getdate() as date)
 )I , 
 (
 select * from Tbl_SMS_NRMS  where cast(upd_date as date)=cast(getdate() as date)
 ) S                                 
 where cast(I.[requestdate] as date)=Cast(S.[Requestdate] as date)
 and I.[status]='P'   and  I.party_code=S.party_code 
 and I.SMS_Content=S.message
 and I.purpose=S.purpose --and I.party_code='V70293'  

        
 select distinct top 4000 a.*,b.Template_Name,notification_type,
 b.No_Of_parameter
 into #tmpsms         
 from Tbl_SMS_NRMS a with(nolock) inner join SMS_NRMS_TemplateMaster b with(nolock)       
 on a.purpose=b.purpose         
 where cast(a.Upd_date as date)= cast(getdate() as date) 
 and flag='P' and NoOfAttempt<3   
 order by a.srno   
                   
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
 from Tbl_SMS_NRMS a      
 inner join #tmpsms b on a.srno=b.Srno       
 where   a.flag='P' 
 
 select t.*,scrip1 = isnull(f.scrip_name, '')
 from #tmpsms t
 left join #final f
 on t.purpose = f.purpose;

 
 --if exists(select count(1) from #final)
 --begin
	-- select t.*,scrip1=f.scrip_name 
	-- from #tmpsms t left outer join #final f
	-- on t.purpose=f.purpose
	 
 --end
 --else
 --begin
 -- select * from #tmpsms
 --end 
 --select * from SMS_Template_Master order by srno  
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_NRMS_NEW_14012026
-- --------------------------------------------------
    
-- =============================================                          
-- Author:  Abha Jaiswal                          
-- Create date: Nov 28 2025                       
-- =============================================                          
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_NRMS_NEW_14012026]                          
As                           
Begin       
       
 select * into #commodity
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS with (nolock)                           
 where cast(upd_date as date)= cast(getdate() as date) 
 and status='P' 
 and Party_code is not null and Party_code<>'' 
 and purpose in ('Expiry','ITM','Tender')

 select  C.*,scrip_name
 into #final 
 from #commodity C 
 inner join [CSOKYC-6].general.dbo.CommoditySMSToClient C1 with (nolock)
 on C.purpose=C1.sms_type
 and C.party_code=C1.cl_code

 select *  into #sms                
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS with (nolock)                           
 where cast(upd_date as date)= cast(getdate() as date) and status='P' 
 and Party_code is not null and Party_code<>'' 
 
 insert into tbl_sms_withouturl_processlog_CNS                          
 select getdate(),ss=(select count(1) from #sms),''  
 
 --delete from Tbl_SMS_NRMS where Party_code='S215178'
 --and Party_code='S215178
                      
 insert into Tbl_SMS_NRMS                      
 select  Party_code,to_no=Mobile_no,Amount1,Amount2,Amount3,Date1,Date2,message=sms_content,url,flag='P',  
 SMS_Type,Upd_date,Request='',Response='',Requestdate=GETDATE(),purpose,NoOfAttempt=0   
 from #sms           

 update I set Status='A'   
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS I , Tbl_SMS_NRMS S                                 
 where cast(I.[requestdate] as date)=Cast(S.[Requestdate] as date) and I.[status]='P'       
 and I.SMS_Content=S.message and   
 I.purpose=S.purpose --and I.party_code='V70293'  
        
 select distinct top 4000 a.*,b.Template_Name,notification_type,
 b.No_Of_parameter
 into #tmpsms         
 from Tbl_SMS_NRMS a with(nolock) inner join SMS_NRMS_TemplateMaster b with(nolock)       
 on a.purpose=b.purpose         
 where cast(a.Upd_date as date)= cast(getdate() as date) 
 and flag='P' and NoOfAttempt<3   
 order by a.srno  
                   
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
 from Tbl_SMS_NRMS a      
 inner join #tmpsms b on a.srno=b.Srno       
 where   a.flag='P'              
 
 if exists(select count(1) from #final)
 begin
	 select t.*,scrip1=f.scrip_name 
	 from #tmpsms t left outer join #final f
	 on t.purpose=f.purpose
	 
 end
 else
 begin
  select * from #tmpsms
 end 
 --select * from SMS_Template_Master order by srno  
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_NRMS_NEW_bkup_09012026
-- --------------------------------------------------

    
-- =============================================                          
-- Author:  Abha Jaiswal                          
-- Create date: Nov 28 2025                       
-- =============================================                          
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_NRMS_NEW_bkup_09012026]                          
As                           
Begin       
        
 select *  into #sms                
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS with (nolock)                           
 where cast(upd_date as date)= cast(getdate() as date) and status='P' 
 and Party_code is not null and Party_code<>''         
 --and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',    
 --'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender',
 --'MTF_90Days_Day3','DeviationSqoff','Ageing Day5',
 --'MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS',
 --'Debit Intimation','Debit Intimation New','Debit & Manual SMS',  
 --'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')             
 
 insert into tbl_sms_withouturl_processlog_CNS                          
 select getdate(),ss=(select count(1) from #sms),''  
 
                      
 insert into Tbl_SMS_NRMS                      
 select  Party_code,to_no=Mobile_no,Amount1,Amount2,Amount3,Date1,Date2,message=sms_content,url,flag='P',  
 SMS_Type,Upd_date,Request='',Response='',Requestdate=GETDATE(),purpose,NoOfAttempt=0   
 from #sms           

 update I set Status='A'   
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_SMS I , Tbl_SMS_NRMS S                                 
 where cast(I.[requestdate] as date)=Cast(S.[Requestdate] as date) and I.[status]='P'       
 and I.SMS_Content=S.message and   
 I.purpose=S.purpose --and I.party_code='V70293'  
                       

 select distinct top 4000 a.*,b.Template_Name,notification_type,
 b.No_Of_parameter
 into #tmpsms         
 from Tbl_SMS_NRMS a with(nolock) inner join SMS_NRMS_TemplateMaster b with(nolock)       
 on a.purpose=b.purpose         
 where cast(a.Upd_date as date)= cast(getdate() as date) 
 and flag='P' and NoOfAttempt<3   
 order by a.srno  
                   
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
 from tbl_SMS_CNS_NRMS a      
 inner join #tmpsms b on a.srno=b.Srno       
 where   a.flag='P'              
      
 select * from #tmpsms    
  
 --select * from SMS_Template_Master order by srno  
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS
-- --------------------------------------------------
    
-- =============================================                          
-- Author:  Abha Jaiswal                          
-- Create date: Jul 13 2023                          
-- =============================================                          
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_RMS]                          
As                           
Begin       
/*    
select     
a.*,    
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)      
into #Priority    
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''       
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                       
      
    
select id = row_number() over(order by [priority]), *  into #final       
from #Priority order by [priority]    
 */    
   
 select *  into #sms                           
 from dbo.tbl_SMS with (nolock)                           
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and Party_code is not null and Party_code<>''       
 and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',    
 'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender','MTF_90Days_Day3','DeviationSqoff')    
 and  message is not null    
    
 insert into #sms           
 select party_code,message,[DATE],[TIME],flag,ampm,purpose        
 from [CSOKYC-6].general.dbo.nrms_sms_cns with (nolock)                           
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and Party_code is not null and Party_code<>''         
 and purpose in ('Ageing Day5','MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New','Debit & Manual SMS',  
 'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')             
 and message is not null  
   
  
 insert into tbl_sms_withouturl_processlog_CNS                          
 select getdate(),ss=(select count(1) from #sms),''                         
                      
 insert into tbl_SMS_CNS_NRMS(party_code,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                      
 select party_code,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                   
           
 update I set flag='A' from tbl_SMS I, tbl_SMS_CNS_NRMS S                               
 where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P'     
 and I.message=S.message and I.purpose=S.purpose     
     
 update [CSOKYC-6].general.dbo.nrms_sms_cns set flag='A'     
 from [CSOKYC-6].general.dbo.nrms_sms_cns I, tbl_SMS_CNS_NRMS S                               
 where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P'     
 and I.message=S.message and I.purpose=S.purpose                  
                          
 select top 4000 a.*,b.TemplateID,notification_type into #tmpsms       
 from tbl_SMS_CNS_NRMS a  with(nolock) join SMS_Template_Master  b with(nolock)     
 on a.purpose=b.purpose       
 where flag='P' and NoOfAttempt<3         
 order by a.srno       
                   
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
 from tbl_SMS_CNS_NRMS a      
 inner join #tmpsms b on a.srno=b.Srno       
 where   a.flag='P'              
      
 select * from #tmpsms    
  
 --select * from SMS_Template_Master order by srno  
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS_bkup_08062025
-- --------------------------------------------------
  
-- =============================================                        
-- Author:  Abha Jaiswal                        
-- Create date: Jul 13 2023                        
-- =============================================                        
create PROCEDURE [dbo].[Get_Inhouse_SMS_RMS_bkup_08062025]                        
As                         
Begin     
/*  
select   
a.*,  
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)    
into #Priority  
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                     
    
  
select id = row_number() over(order by [priority]), *  into #final     
from #Priority order by [priority]  
 */  
 
 select *  into #sms                         
 from dbo.sms with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
 and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',  
 'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender','MTF_90Days_Day3','DeviationSqoff')  
 and  message is not null  
  
 insert into #sms         
 select to_no,message,[DATE],[TIME],flag,ampm,purpose      
 from [CSOKYC-6].general.dbo.nrms_sms_cns with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''       
 and purpose in ('Ageing Day5','MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New','Debit & Manual SMS',
 'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')           
 and message is not null
 

 insert into tbl_sms_withouturl_processlog_CNS                        
 select getdate(),ss=(select count(1) from #sms),''                       
                    
 insert into NRMS_SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                    
 select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
         
 update sms set flag='A' from sms I, NRMS_SMS_Sent_CNS S                             
 where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 and I.message=S.message and I.purpose=S.purpose   
   
 update [CSOKYC-6].general.dbo.nrms_sms_cns set flag='A'   
 from [CSOKYC-6].general.dbo.nrms_sms_cns I, NRMS_SMS_Sent_CNS S                             
 where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 and I.message=S.message and I.purpose=S.purpose                
                        
 select top 4000 a.*,b.TemplateID,notification_type into #tmpsms     
 from NRMS_SMS_Sent_CNS a  with(nolock) join SMS_Template_Master  b with(nolock)   
 on a.purpose=b.purpose     
 where flag='P' and NoOfAttempt<3       
 order by a.srno     
                 
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1     
 from NRMS_SMS_Sent_CNS a    
 inner join #tmpsms b on a.srno=b.Srno     
 where   a.flag='P'            
    
 select * from #tmpsms  

 --select * from SMS_Template_Master order by srno
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS_bkup_17062025
-- --------------------------------------------------

  
-- =============================================                        
-- Author:  Abha Jaiswal                        
-- Create date: Jul 13 2023                        
-- =============================================                        
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_RMS_bkup_17062025]                        
As                         
Begin     
/*  
select   
a.*,  
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)    
into #Priority  
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                     
    
  
select id = row_number() over(order by [priority]), *  into #final     
from #Priority order by [priority]  
 */  
 
 select *  into #sms                         
 from dbo.sms with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
 and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',  
 'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender','MTF_90Days_Day3','DeviationSqoff')  
 and  message is not null  
  
 insert into #sms         
 select to_no,message,[DATE],[TIME],flag,ampm,purpose      
 from [CSOKYC-6].general.dbo.nrms_sms_cns with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''       
 and purpose in ('Ageing Day5','MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New','Debit & Manual SMS',
 'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')           
 and message is not null
 

 insert into tbl_sms_withouturl_processlog_CNS                        
 select getdate(),ss=(select count(1) from #sms),''                       
                    
 insert into NRMS_SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                    
 select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
         
 update sms set flag='A' from sms I, NRMS_SMS_Sent_CNS S                             
 where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 and I.message=S.message and I.purpose=S.purpose   
   
 update [CSOKYC-6].general.dbo.nrms_sms_cns set flag='A'   
 from [CSOKYC-6].general.dbo.nrms_sms_cns I, NRMS_SMS_Sent_CNS S                             
 where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 and I.message=S.message and I.purpose=S.purpose                
                        
 select top 4000 a.*,b.TemplateID,notification_type into #tmpsms     
 from NRMS_SMS_Sent_CNS a  with(nolock) join SMS_Template_Master  b with(nolock)   
 on a.purpose=b.purpose     
 where flag='P' and NoOfAttempt<3       
 order by a.srno     
                 
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1     
 from NRMS_SMS_Sent_CNS a    
 inner join #tmpsms b on a.srno=b.Srno     
 where   a.flag='P'            
    
 select * from #tmpsms  

 --select * from SMS_Template_Master order by srno
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS_bkup_17062025_morn
-- --------------------------------------------------


  
-- =============================================                        
-- Author:  Abha Jaiswal                        
-- Create date: Jul 13 2023                        
-- =============================================                        
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_RMS_bkup_17062025_morn]                        
As                         
Begin     
/*  
select   
a.*,  
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)    
into #Priority  
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                     
    
  
select id = row_number() over(order by [priority]), *  into #final     
from #Priority order by [priority]  
 */  
 
 select *  into #sms                         
 from dbo.sms with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
 and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',  
 'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender','MTF_90Days_Day3','DeviationSqoff')  
 and  message is not null  
  
 insert into #sms         
 select to_no,message,[DATE],[TIME],flag,ampm,purpose      
 from [CSOKYC-6].general.dbo.nrms_sms_cns with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''       
 and purpose in ('Ageing Day5','MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New','Debit & Manual SMS',
 'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')           
 and message is not null
 

 insert into tbl_sms_withouturl_processlog_CNS                        
 select getdate(),ss=(select count(1) from #sms),''                       
                    
 insert into NRMS_SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                    
 select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
         
 update sms set flag='A' from sms I, NRMS_SMS_Sent_CNS S                             
 where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 and I.message=S.message and I.purpose=S.purpose   
   
 update [CSOKYC-6].general.dbo.nrms_sms_cns set flag='A'   
 from [CSOKYC-6].general.dbo.nrms_sms_cns I, NRMS_SMS_Sent_CNS S                             
 where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 and I.message=S.message and I.purpose=S.purpose                
                        
 select top 4000 a.*,b.TemplateID,notification_type into #tmpsms     
 from NRMS_SMS_Sent_CNS a  with(nolock) join SMS_Template_Master  b with(nolock)   
 on a.purpose=b.purpose     
 where flag='P' and NoOfAttempt<3       
 order by a.srno     
                 
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1     
 from NRMS_SMS_Sent_CNS a    
 inner join #tmpsms b on a.srno=b.Srno     
 where   a.flag='P'            
    
 select * from #tmpsms  

 --select * from SMS_Template_Master order by srno
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS_bkup_22122023
-- --------------------------------------------------

-- =============================================                      
-- Author:  Abha Jaiswal                      
-- Create date: Jul 13 2023                      
-- =============================================                      
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_RMS_bkup_22122023]                      
As                       
Begin   
/*
select 
a.*,
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)  
into #Priority
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''   
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                   
  

select id = row_number() over(order by [priority]), *  into #final   
from #Priority order by [priority]
 */                
	select *  into #sms                       
	from dbo.sms with (nolock)                       
	where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''   
	and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',
	'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender')
	and  message is not null

	insert into #sms       
	select to_no,message,[DATE],[TIME],flag,ampm,purpose    
	from [196.1.115.182].general.dbo.nrms_sms_cns with (nolock)                       
	where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
	and purpose in ('Ageing Day5','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New')         
    and message is not null  
	
	insert into tbl_sms_withouturl_processlog_CNS                      
	select getdate(),ss=(select count(1) from #sms),''                     
                  
	insert into NRMS_SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
	select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms               
       
	update sms set flag='A' from sms I, NRMS_SMS_Sent_CNS S                           
	where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' 
	and I.message=S.message and I.purpose=S.purpose 
	
	update [196.1.115.182].general.dbo.nrms_sms_cns set flag='A' 
	from [196.1.115.182].general.dbo.nrms_sms_cns I, NRMS_SMS_Sent_CNS S                           
	where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' 
	and I.message=S.message and I.purpose=S.purpose              
                      
	select top 4000 a.*,b.TemplateID into #tmpsms   
	from NRMS_SMS_Sent_CNS a  with(nolock) join SMS_Template_Master  b with(nolock) 
	on a.purpose=b.purpose   
	where flag='P' and NoOfAttempt<3     
	order by a.srno   
               
	update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
	from NRMS_SMS_Sent_CNS a  
	inner join #tmpsms b on a.srno=b.Srno   
	where   a.flag='P'          
  
	select * from #tmpsms  

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS_testing
-- --------------------------------------------------
  
-- =============================================                        
-- Author:  Abha Jaiswal                        
-- Create date: Jul 13 2023                        
-- =============================================                        
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_RMS_testing]                        
As                         
Begin   
/*  
select   
a.*,  
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)    
into #Priority  
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                     
    
  
select id = row_number() over(order by [priority]), *  into #final     
from #Priority order by [priority]  
 */  
 /*
 select *  into #sms                         
 from dbo.sms with (nolock)                         
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''     
 and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',  
 'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender','MTF_90Days_Day3','DeviationSqoff')  
 and  message is not null  
  
 insert into #sms         
 select to_no,message,[DATE],[TIME],flag,ampm,purpose      
 from [CSOKYC-6].general.dbo.nrms_sms_cns with (nolock)                         
 where date= CONVERT(varchar,GETDATE()-1,103) and flag='P' and to_no is not null and to_no<>''       
 and purpose in ('Ageing Day5','MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New','Debit & Manual SMS',
 'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')           
 and message is not null
 */
 select clientid='P94285',message=' Dear Client P94285, Please pay Rs.5000 by 5.30 pm tomorrow to avoid your shares being sold on 18/07/2023. Click here to pay trade.angelone.in .Please ignore, if paid Regards - Angel One',
 [DATE]='17/06/2025',[TIME]='10:15',flag='P',ampm='PM',purpose='Ageing Day5'  
 into #sms  
    
 --insert into tbl_sms_withouturl_processlog_CNS                        
 --select getdate(),ss=(select count(1) from #sms),''                       
                    
 insert into tbl_SMS_CNS_NRMS(party_code,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                    
 select clientid,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
         
 --update sms set flag='A' from sms I, NRMS_SMS_Sent_CNS S                             
 --where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 --and I.message=S.message and I.purpose=S.purpose   
   

 --update [CSOKYC-6].general.dbo.nrms_sms_cns set flag='A'   
 --from [CSOKYC-6].general.dbo.nrms_sms_cns I, NRMS_SMS_Sent_CNS S                             
 --where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P'   
 --and I.message=S.message and I.purpose=S.purpose                
                        
 select top 4000 a.*,b.TemplateID,notification_type into #tmpsms     
 from tbl_SMS_CNS_NRMS a  with(nolock) join SMS_Template_Master  b with(nolock)   
 on a.purpose=b.purpose     
 where flag='P' and NoOfAttempt<3       
 order by a.srno     

                 
 --update  a  set  a.NoOfAttempt=a.NoOfAttempt +1     
 --from tbl_SMS_CNS_NRMS a    
 --inner join #tmpsms b on a.srno=b.Srno     
 --where   a.flag='P'    
 
 select * from #tmpsms  

 --select * from SMS_Template_Master order by srno
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_RMS_with ClientID
-- --------------------------------------------------
    
-- =============================================                          
-- Author:  Abha Jaiswal                          
-- Create date: Jul 13 2023                          
-- =============================================                          
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_RMS_with ClientID]                          
As                           
Begin       
/*    
select     
a.*,    
[PRiority]=(Case when purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Info','Risk') then '1' else '2' end)      
into #Priority    
from dbo.sms a where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''       
and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday')                       
      
    
select id = row_number() over(order by [priority]), *  into #final       
from #Priority order by [priority]    
 */    
   
 select *  into #sms                           
 from dbo.tbl_SMS with (nolock)                           
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and Party_code is not null and Party_code<>''       
 and purpose in ('Ageing Day7','NBFC Day 7','MTF Day7','Tday','Square Off',    
 'Info','Risk','ITM','ITM1','Expiry','MCX Expiry','NCDEX Expiry','DeviationSMS','CUSAMANUAL','Tender','MTF_90Days_Day3','DeviationSqoff')    
 and  message is not null    
    
 insert into #sms           
 select party_code,message,[DATE],[TIME],flag,ampm,purpose        
 from [CSOKYC-6].general.dbo.nrms_sms_cns with (nolock)                           
 where date= CONVERT(varchar,GETDATE(),103) and flag='P' and Party_code is not null and Party_code<>''         
 and purpose in ('Ageing Day5','MTF_90Days','MTF 90 Day2','MTF 90 Day1','Ageing Day6','T day Eve','Tday','Debit SMS','Combine SMS','Debit Intimation','Debit Intimation New','Debit & Manual SMS',  
 'MTF 90 Combine SMS','MTF 90 Combine SMS1','MTF 90 Combine SMS2','DeviationReminder','Intimation')             
 and message is not null  
   
  
 insert into tbl_sms_withouturl_processlog_CNS                          
 select getdate(),ss=(select count(1) from #sms),''                         
                      
 insert into tbl_SMS_CNS_NRMS(party_code,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                      
 select party_code,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                   
           
 update sms set flag='A' from tbl_SMS I, tbl_SMS_CNS_NRMS S                               
 where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P'     
 and I.message=S.message and I.purpose=S.purpose     
     
 update [CSOKYC-6].general.dbo.nrms_sms_cns set flag='A'     
 from [CSOKYC-6].general.dbo.nrms_sms_cns I, tbl_SMS_CNS_NRMS S                               
 where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P'     
 and I.message=S.message and I.purpose=S.purpose                  
                          
 select top 4000 a.*,b.TemplateID,notification_type into #tmpsms       
 from tbl_SMS_CNS_NRMS a  with(nolock) join SMS_Template_Master  b with(nolock)     
 on a.purpose=b.purpose       
 where flag='P' and NoOfAttempt<3         
 order by a.srno       
                   
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
 from tbl_SMS_CNS_NRMS a      
 inner join #tmpsms b on a.srno=b.Srno       
 where   a.flag='P'              
      
 select * from #tmpsms    
  
 --select * from SMS_Template_Master order by srno  
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_SebiPO
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_SebiPO]                                              
As                                               
Begin                                              
                                          
select *  into #sms                                               
from tbl_SMSMessages with (nolock)                                               
where date= CONVERT(varchar,GETDATE(),103) and flag='P'                         
and purpose in ('Sebi PreSMS','SEBI Circular Funds Payout','SEBI Payout failed SMS','Request Payout Failed')                        
                        
update #sms set message=message+' Regards - Angel One'  where purpose in ('Sebi PreSMS')                           
                                          
insert into tbl_sms_withouturl_processlog_CNS_SebiPO -- order by starttime desc                                            
select getdate(),ss=(select count(1) from #sms),''                                             
                                          
insert into tbl_SMSCNSSent_SebiPO(party_code,Amount_R,Amount_A,accountNo,UTR,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                                          
select party_code,Amount_R,Amount_A,accountNo,UTR,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                                         
                                  
update I set flag='A' from tbl_SMSMessages I, tbl_SMSCNSSent_SebiPO S                                                   
where I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose           
and Convert(datetime,I.[date],103) >getdate()-10      
                                         
                           
select top 10000 a.*,b.Template_Name,b.notification_type into #tmpsms                           
from tbl_SMSCNSSent_SebiPO a  with(nolock) join SMS_TemplateMaster_new  b with(nolock) on a.purpose=b.purpose                           
where flag='P' and  a.entrydate>=getdate()-5 and NoOfAttempt<3                             
order by a.srno                           
                                       
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1                           
from tbl_SMSCNSSent_SebiPO a                          
inner join #tmpsms b on a.srno=b.Srno                           
where   a.flag='P'                                  
                          
select Srno,Party_code,Amount_R,Amount_A,accountNo,UTR,[message],Convert(varchar,convert(datetime,[date],103),5)[date],[time],flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate,
Template_Name,notification_type
 from #tmpsms                            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_SebiPO_07dec2023
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_SebiPO_07dec2023]                              
As                               
Begin                              
                          
select *  into #sms                               
from dbo.sms with (nolock)                               
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''           
and purpose in ('Sebi PreSMS','SEBI Circular Funds Payout')        
        
update #sms set message=message+' Regards - Angel One'  where purpose in ('Sebi PreSMS')           
                          
insert into tbl_sms_withouturl_processlog_CNS_SebiPO -- order by starttime desc                            
select getdate(),ss=(select count(1) from #sms),''                             
                          
insert into SMS_Sent_CNS_SebiPO(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                          
select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                         
                  
update sms set flag='A' from sms I, SMS_Sent_CNS_SebiPO S                                   
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.purpose=S.purpose                      
                         
           
select top 10000 a.*,b.TemplateID into #tmpsms           
from SMS_Sent_CNS_SebiPO a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose           
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3             
order by a.srno           
                       
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1           
from SMS_Sent_CNS_SebiPO a          
inner join #tmpsms b on a.srno=b.Srno           
where   a.flag='P'                  
          
select * from #tmpsms          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_SebiPO_07oct2023
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_SebiPO_07oct2023]                          
As                           
Begin                          
                      
select *  into #sms                           
from dbo.sms with (nolock)                           
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''       
and purpose in ('Sebi PreSMS','SEBI Circular Funds Payout')    
    
update #sms set message=message+' Regards - Angel One'  where purpose in ('Sebi PreSMS')       
                      
insert into tbl_sms_withouturl_processlog_CNS_SebiPO -- order by starttime desc                        
select getdate(),ss=(select count(1) from #sms),''                         
                      
insert into SMS_Sent_CNS_SebiPO(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                      
select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                     
              
update sms set flag='A' from sms I, SMS_Sent_CNS_SebiPO S                               
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.purpose=S.purpose                  
                     
       
select top 4000 a.*,b.TemplateID into #tmpsms       
from SMS_Sent_CNS_SebiPO a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose       
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3         
order by a.srno       
                   
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
from SMS_Sent_CNS_SebiPO a      
inner join #tmpsms b on a.srno=b.Srno       
where   a.flag='P'              
      
select * from #tmpsms      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_SebiPO_28nov2025
-- --------------------------------------------------
    
    
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_SebiPO_28nov2025]                                        
As                                         
Begin                                        
                                    
select *  into #sms                                         
from dbo.sms with (nolock)                                         
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''                     
and purpose in ('Sebi PreSMS','SEBI Circular Funds Payout','SEBI Payout failed SMS','Request Payout Failed')                  
                  
update #sms set message=message+' Regards - Angel One'  where purpose in ('Sebi PreSMS')                     
                                    
insert into tbl_sms_withouturl_processlog_CNS_SebiPO -- order by starttime desc                                      
select getdate(),ss=(select count(1) from #sms),''                                       
                                    
insert into SMS_Sent_CNS_SebiPO(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                                    
select to_no,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                                   
                            
update sms set flag='A' from sms I, SMS_Sent_CNS_SebiPO S                                             
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.purpose=S.purpose                                
                                   
                     
select top 10000 a.*,b.TemplateID,b.notification_type into #tmpsms                     
from SMS_Sent_CNS_SebiPO a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose                     
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3                       
order by a.srno                     
                                 
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1                     
from SMS_Sent_CNS_SebiPO a                    
inner join #tmpsms b on a.srno=b.Srno                     
where   a.flag='P'                            
                    
select * from #tmpsms                    
end   
  
/*-https://angelbrokingpl.atlassian.net/browse/SRE-29862*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_test
-- --------------------------------------------------
-- =============================================                      
-- Author:  Neha Naiwar                      
-- Create date: 27 Jun 2023                      
-- =============================================                      
CREATE PROCEDURE [dbo].[Get_Inhouse_SMS_test]                      
As                       
Begin                      
                 
select *  into #sms                       
from dbo.tbl_SMSMessages with (nolock)                       
where date= CONVERT(varchar,GETDATE(),103) and flag='P'    
and purpose in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion','Payout Exception','Payout Rejection',  
'Aggregator Verification Stop','Payout Cancellation','Brokerage Tariff For 15',  
'Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Broker_Payout','ECN Activation','Modify_Mobile no','Trade File Missing','Service Implicit','DPAMC') /*'DormantToReactive'*/

update #sms set message=message+' Regards - Angel One'  where purpose in ('Service Implicit','ECN Activation')   
                  
insert into tbl_sms_withouturl_processlog_CNS                      
select getdate(),ss=(select count(1) from #sms),''                     
                  
insert into tbl_SMSCNS_send(party_code,Amount_R,Amount_A,accountNo,UTR,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
select party_code,Amount_R,Amount_A,accountNo,UTR,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                     
          
update I set flag='A' from tbl_SMSMessages I, tbl_SMSCNS_send S                           
where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
                 
/*select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<=3     
  
update SMS_Sent_CNS set  NoOfAttempt=NoOfAttempt +1 where   flag='P' and NoOfAttempt<=3    
 */  
   
select top 10000 a.*,b.Template_Name,notification_type into #tmpsms   
from tbl_SMSCNS_send a  with(nolock) join SMS_TemplateMaster_new  b with(nolock) on a.purpose=b.purpose   
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3     
order by a.srno   
               
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
from tbl_SMSCNS_send a  
inner join #tmpsms b on a.srno=b.Srno   
where   a.flag='P'          
  
select * from #tmpsms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMS_withoutNo_testing
-- --------------------------------------------------
-- =============================================                      
-- Author:  Neha Naiwar                      
-- Create date: 27 Jun 2023                      
-- =============================================                      
create PROCEDURE [dbo].[Get_Inhouse_SMS_withoutNo_testing]                      
As                       
Begin                      
                  
select *  into #sms                       
from dbo.tbl_SMS with (nolock)                       
where date= CONVERT(varchar,GETDATE(),103) and flag='P'  
and purpose in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion','Payout Exception','Payout Rejection',  
'Aggregator Verification Stop','Payout Cancellation','Brokerage Tariff For 15',  
'Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Broker_Payout','ECN Activation','Modify_Mobile no','Trade File Missing','Service Implicit','DPAMC') /*'DormantToReactive'*/

update #sms set message=message+' Regards - Angel One'  where purpose in ('Service Implicit','ECN Activation')   
                  
insert into tbl_sms_withouturl_processlog_CNS                      
select getdate(),ss=(select count(1) from #sms),''                     
                  
insert into tbl_SMS_CNS(party_code,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
select party_code,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                 
          
update I set flag='A' from tbl_SMS I, tbl_SMS_CNS S                           
where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
                 
/*select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<=3     
  
update SMS_Sent_CNS set  NoOfAttempt=NoOfAttempt +1 where   flag='P' and NoOfAttempt<=3    
 */  
   
select top 10000 a.*,b.TemplateID,notification_type into #tmpsms   
from tbl_SMS_CNS a  with(nolock) join SMS_Template_Master  b with(nolock) on a.purpose=b.purpose   
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3     
order by a.srno   
               
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
from SMS_Sent_CNS a  
inner join #tmpsms b on a.srno=b.Srno   
where   a.flag='P'          
  
select * from #tmpsms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Inhouse_SMSMessage
-- --------------------------------------------------
-- =============================================                      
-- Author:  Neha Naiwar                      
-- Create date: 27 Jun 2023                      
-- =============================================                      
CREATE PROCEDURE [dbo].[Get_Inhouse_SMSMessage]                      
As                       
Begin                      
                  
select *  into #sms                       
from dbo.tbl_SMSMessages with (nolock)                       
where date= CONVERT(varchar,GETDATE(),103) and flag='P'    
and purpose in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion','Payout Exception','Payout Rejection',  
'Aggregator Verification Stop','Payout Cancellation','Brokerage Tariff For 15',  
'Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Broker_Payout','ECN Activation','Modify_Mobile no','Trade File Missing','Service Implicit','DPAMC') /*'DormantToReactive'*/

update #sms set message=message+' Regards - Angel One'  where purpose in ('Service Implicit','ECN Activation')   
                  
insert into tbl_sms_withouturl_processlog_CNS                      
select getdate(),ss=(select count(1) from #sms),''                     
               
insert into tbl_SMSCNS_send(party_code,Amount_R,Amount_A,accountNo,UTR,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt,EntryDate)                  
select party_code,Amount_R,Amount_A,accountNo,UTR,message,date,time,'P',ampm,purpose,'','','',0,GETDATE() from #sms                     
             
update I set flag='A' from tbl_SMSMessages I, tbl_SMSCNS_send S                           
where  I.party_code=S.party_code and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose              
                   
/*select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<=3     
  
update SMS_Sent_CNS set  NoOfAttempt=NoOfAttempt +1 where   flag='P' and NoOfAttempt<=3    
 */  
select top 10000 a.*,b.Template_Name,notification_type into #tmpsms   
from tbl_SMSCNS_send a  with(nolock) join SMS_TemplateMaster_new  b with(nolock) on a.purpose=b.purpose   
where flag='P' and  a.entrydate>='2023-07-12 09:30:55.743' and NoOfAttempt<3     
order by a.srno   
               
update  a  set  a.NoOfAttempt=a.NoOfAttempt +1   
from tbl_SMSCNS_send a  
inner join #tmpsms b on a.srno=b.Srno   
where   a.flag='P'           
  
select * from #tmpsms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_NRMS_SMS
-- --------------------------------------------------

-- =============================================                    
-- Author:  Neha Naiwar                    
-- Create date: 27 Jun 2023                    
-- =============================================                    
CREATE PROCEDURE [dbo].[Get_NRMS_SMS]                    
As                     
Begin                    
                
select *  into #sms                     
from dbo.sms with (nolock)                     
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''   
and purpose in ('Full Payout Processed','Partial Payout Processed')    
  
insert into #sms     
select to_no,message,[DATE],[TIME],flag,ampm,purpose  
from [CSOKYC-6].general.dbo.tbl_sms_withurl with (nolock)                     
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>''   
and purpose in ('Ageing Day5')       
                
insert into tbl_sms_withouturl_processlog_CNS                    
select getdate(),ss=(select count(1) from #sms),''                   
                
insert into SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date,NoOfAttempt)                
select to_no,message,date,time,'P',ampm,purpose,'','','',0 from #sms               
        
update sms set flag='A' from sms I, SMS_Sent_CNS S                         
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message and I.purpose=S.purpose            
                    
select a.*,b.TemplateID from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose where flag='P' and NoOfAttempt<3            
            
                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_NRMS_WatsApp_Noti_Data
-- --------------------------------------------------
-- =============================================  
-- Author:  Abha Jaiswal  
-- Create date: 07/08/2024  
-- Description: Watsapp Notification to square off clients  
-- =============================================  
CREATE PROCEDURE [dbo].[Get_NRMS_WatsApp_Noti_Data]  
AS  
BEGIN  
           
 select  * into #sms                             
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_WatsAppNotification with (nolock)                             
 where cast(upd_date as date)= cast(getdate() as date)   
 --where upd_date>'2025-09-08 10:04:53.603'  
 and Status='P'-- and Mobile_no is not null and Mobile_no<>''-- and party_code='V70293'  
   
 --truncate table NRMS_WATSAPP_SENT_CNS  
 insert into NRMS_WatsApp_Sent_CNS                     
 select  Party_code,to_no=Mobile_no,Amount1,Amount2,Amount3,Date1,Date2,message=sms_content,url,flag='P',  
 SMS_Type,Upd_date,Request='',Response='',Requestdate=GETDATE(),purpose,NoOfAttempt=0   
 from #sms    
             
 update I set Status='A'   
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_WatsAppNotification I , NRMS_WatsApp_Sent_CNS S                                 
 where cast(I.[requestdate] as date)=Cast(S.[Requestdate] as date) and I.[status]='P'       
 and I.SMS_Content=S.message and   
 I.purpose=S.purpose --and I.party_code='V70293'  
           
 select distinct top 4000 a.*,b.Template_Name,notification_type,b.No_Of_parameter into #tmpsms         
 from NRMS_WatsApp_Sent_CNS a with(nolock) inner join [tbl_WatsApp_Template_Master] b with(nolock)       
 on a.purpose=b.purpose         
 where cast(a.Upd_date as date)= cast(getdate() as date) and flag='P' and NoOfAttempt<3   
 order by a.srno  
  
 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1         
 from NRMS_WatsApp_Sent_CNS a        
 inner join #tmpsms b on a.srno=b.Srno         
 where  cast(a.Upd_date as date)= cast(getdate() as date) and  a.flag='P'   
       
 select * from  
 (  
 select distinct  srno,party_code,to_no,Amount1,Amount2,Amount3,Date1,Date2,  
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms   
 union all  
 select distinct top 1   srno,party_code,to_no='9051959274',Amount1,Amount2,Amount3,Date1,Date2,  
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms  
-- where Template_Name ='dr_mtf_t4'   
 union all  
 select distinct top 1   srno,party_code,to_no='9820701602',Amount1,Amount2,Amount3,Date1,Date2,  
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms  
 --where Template_Name ='dr_mtf_t4'   
 union all  
 select distinct top 1   srno,party_code,to_no='8108987990',Amount1,Amount2,Amount3,Date1,Date2,  
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms  
 --where Template_Name ='dr_mtf_t4'   
 union all  
 select distinct top 1   srno,party_code,to_no='9768685152',Amount1,Amount2,Amount3,Date1,Date2,  
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms  
-- where Template_Name ='dr_mtf_t4'   
 )A  
  
   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_NRMS_WatsApp_Noti_Data_bkup_25062025
-- --------------------------------------------------

-- =============================================
-- Author:		Abha Jaiswal
-- Create date: 07/08/2024
-- Description:	Watsapp Notification to square off clients
-- =============================================
CREATE PROCEDURE [dbo].[Get_NRMS_WatsApp_Noti_Data_bkup_25062025]
AS
BEGIN
         
 select  *-- into #sms                           
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_WatsAppNotification with (nolock)                           
 where cast(upd_date as date)= cast(getdate() as date) 
 and Status='P'-- and Mobile_no is not null and Mobile_no<>''-- and party_code='V70293'
 
 --truncate table NRMS_WATSAPP_SENT_CNS
 insert into NRMS_WatsApp_Sent_CNS                   
 select  Party_code,to_no=Mobile_no,Amount1,Amount2,Amount3,Date1,Date2,message=sms_content,url,flag='P',
 SMS_Type,Upd_date,Request='',Response='',Requestdate=GETDATE(),purpose,NoOfAttempt=0 
 from #sms  
           
 update I set Status='A' 
 from [CSOKYC-6].general.dbo.Tbl_Squareoff_WatsAppNotification I , NRMS_WatsApp_Sent_CNS S                               
 where  I.Mobile_no=S.to_no and cast(I.[requestdate] as date)=Cast(S.[Requestdate] as date) and I.[status]='P'     
 and I.SMS_Content=S.message and 
 I.purpose=S.purpose --and I.party_code='V70293'

                             
 select distinct top 4000 a.*,b.Template_Name,notification_type,b.No_Of_parameter into #tmpsms       
 from NRMS_WatsApp_Sent_CNS a with(nolock) inner join [tbl_WatsApp_Template_Master] b with(nolock)     
 on a.purpose=b.purpose       
 where cast(a.Upd_date as date)= cast(getdate() as date)   and flag='P' and NoOfAttempt<3 
 order by a.srno

 update  a  set  a.NoOfAttempt=a.NoOfAttempt +1       
 from NRMS_WatsApp_Sent_CNS a      
 inner join #tmpsms b on a.srno=b.Srno       
 where  cast(a.Upd_date as date)= cast(getdate() as date) and  a.flag='P' 

           
 select * from
 (
 select distinct  srno,party_code,to_no,Amount1,Amount2,Amount3,Date1,Date2,
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms 
 union all
 select distinct top 1   srno,party_code,to_no='9051959274',Amount1,Amount2,Amount3,Date1,Date2,
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms
-- where Template_Name ='dr_mtf_t4' 
 union all
 select distinct top 1   srno,party_code,to_no='9820701602',Amount1,Amount2,Amount3,Date1,Date2,
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms
 --where Template_Name ='dr_mtf_t4' 
 union all
 select distinct top 1   srno,party_code,to_no='8108987990',Amount1,Amount2,Amount3,Date1,Date2,
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms
 --where Template_Name ='dr_mtf_t4' 
 union all
 select distinct top 1   srno,party_code,to_no='9768685152',Amount1,Amount2,Amount3,Date1,Date2,
 url,Template_Name,notification_type,No_Of_parameter from #tmpsms
-- where Template_Name ='dr_mtf_t4' 
 )A

 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Payout_SMS_27Jun2023
-- --------------------------------------------------
-- =============================================                  
-- Author:  Neha Naiwar                  
-- Create date: 27 Jun 2023                  
-- =============================================                  
CREATE PROCEDURE [dbo].[Get_Payout_SMS_27Jun2023]                  
As                   
Begin     
select * from sms_test_19sep2025
--delete from SMS_Sent_CNS   where flag='P'            
--truncate table SMS_checking_27Jun2023             
--insert into SMS_checking_27Jun2023            
--select top 5 *,'1307167998866696529' as TemplateID  from sms.dbo.sms with(nolock) where            
--date like '%28/06/2022' and message like '%Funds withdrawal of Rs.%has been processed successfully with UTR Number%' and            
--purpose='Payout Marking'   and to_no like '7777%'            
--select * into #aa from SMS_checking_27Jun2023                
                
--update #aa set to_no='8976552188'              
            
            
--insert into SMS_Sent_CNS(to_no,message,date,time,flag,ampm,purpose,Request,Response,Response_date)            
--select to_no,message,date,time,'P',ampm,purpose,'','','' from #aa            
            
--select *,'1307167998866696529' as TemplateID  from SMS_Sent_CNS  where flag='P'           
--select top 2 a.*,b.TemplateID into #tmp from SMS_Sent_CNS a join SMS_Template_Master  b on a.purpose=b.purpose --where flag='P' and NoOfAttempt<4      
      
--       update   #tmp    
--    set to_no='8788706544'    
--    where to_no='9311875943'    
    
--    update #tmp    
--    set Srno=Srno+1    
--    where to_no='8788706544'    
    
--     update   #tmp    
--    set to_no='8976552188'    
--    where to_no='9131353868'    
    
--     update #tmp    
--    set Srno=Srno+1    
--    where to_no='8976552188'    
    
--    select * into tmpsms from #tmp    
    --select * from tmpsms_15Apr2025    
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
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';      
        IF @frag >= 30.0      
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD WITH (SORT_IN_TEMPDB = ON)';      
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
-- PROCEDURE dbo.SMS_SendCNS_exe
-- --------------------------------------------------


   

          

CREATE Proc [dbo].[SMS_SendCNS_exe]          

As          

Begin          

      

  declare @cmd1 varchar(7000)          

  set @cmd1 = 'start \\INHOUSELIVEAPP1-FS.angelone.in\d\UploadAdvChart\Inhouse_SMS\SMS_Application\SMS_Application\bin\Debug\SMS_Application.exe'        

  exec master..xp_cmdshell @cmd1 , no_output 

      

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_Error_log
-- --------------------------------------------------
      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE Update_CNS_Error_log       
 @Message varchar(500),      
 @status varchar(100)      
as      
BEGIN      
       
insert into   SMS_Error_log(Msg,Status,Error_date)  
select @Message,@status,GETDATE()  
  
declare @profile_name varchar(100)    
  declare @recipients varchar(100)    
  declare @copy_recipients varchar(100)    
  declare @subject varchar(100)    
  declare @body varchar(100)    
  declare  @body_format varchar(100)    
  declare @MSg varchar(1000)    
   
 set @MSg='Dear Team,<br><Br>Please check the below error message while executing CNS service.<br><br>Error : '+@Message+''         
    
     
         EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                     
              @profile_name='AngelBroking',        
              @recipients='neha.naiwar@angelbroking.com;yogen.gandhi@angelbroking.com;prashant.patade@angelbroking.com;abha.1jaiswal@angelbroking.com;leon.vaz@angelbroking.com;sanand.adivarekar@angelbroking.com;in-house-sms-cns-service-email.gk6d5f5v@angelbroking.pagerduty.com',    
             -- @copy_recipients ='rahulc.shah@angelbroking.com;siva.kopparapu@angelbroking.com',      
              @subject = 'ALERT: Error in CNS Service',                      
              @body=@MSg ,                      
              @body_format = 'HTML'     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_Error_log_SebiPO
-- --------------------------------------------------
CREATE PROCEDURE Update_CNS_Error_log_SebiPO         
 @Message varchar(500),        
 @status varchar(100)        
as        
BEGIN        
         
insert into   SMS_Error_log_SebiPO(Msg,Status,Error_date)    
select @Message,@status,GETDATE()    
    
declare @profile_name varchar(100)      
  declare @recipients varchar(100)      
  declare @copy_recipients varchar(100)      
  declare @subject varchar(100)      
  declare @body varchar(100)      
  declare  @body_format varchar(100)      
  declare @MSg varchar(1000)      
     
 set @MSg='Dear Team,<br><Br>Please check the below error message while executing CNS SMS Sebi PO service.<br><br>Error : '+@Message+''           
      
       
--         EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                       
--              @profile_name='AngelBroking',          
--              @recipients='neha.naiwar@angelbroking.com;yogen.gandhi@angelbroking.com;prashant.patade@angelbroking.com;abha.1jaiswal@angelbroking.com;leon.vaz@angelbroking.com;sanand.adivarekar@angelbroking.com;in-house-sms-cns-service-email.gk6d5f5v@ange
--lbroking.pagerduty.com',      
--             -- @copy_recipients ='rahulc.shah@angelbroking.com;siva.kopparapu@angelbroking.com',        
--              @subject = 'ALERT: Error in CNS SMS SEBI PO Service',                        
--              @body=@MSg ,                        
--              @body_format = 'HTML'       
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_Notification_Response
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Update_CNS_Notification_Response]                             
as                    
BEGIN                    
        
   Declare @filePath1 varchar(500)=''                
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_WhatsApp_Notification\W_Notification_log.txt'        
        
   truncate table Notification_CNS_Response        
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT Notification_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                        
   EXEC(@sql1)         
        
  update a set a.Response=b.response,a.flag='A',a.Requestdate=getdate()         
  from NRMS_WatsApp_Sent_CNS a inner join Notification_CNS_Response b on a.srno=b.srno where flag='P'               
  and b.Response like '%"success":true%'     
  
        
  update a set a.Response=b.response,a.Requestdate=getdate()         
  from NRMS_WatsApp_Sent_CNS a inner join Notification_CNS_Response b on a.srno=b.srno where flag='P'               
  and b.Response like '%"success":false%'         
        
  --update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where          
  --starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                      
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response
-- --------------------------------------------------


            

-- Author:  Neha Naiwar           
-- Create date: 27 Jun 2023            
-- =============================================            
CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response]                     
as            
BEGIN            

   Declare @filePath1 varchar(500)=''        
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog.txt'

   truncate table SMS_CNS_Response
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                
   EXEC(@sql1) 

  update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from tbl_SMS_CNS a join SMS_CNS_Response b on a.srno=b.srno where flag='P'       
  and b.Response like '%"success":true%' 

  update a set a.Response=b.response,a.response_date=getdate() from tbl_SMS_CNS a join SMS_CNS_Response b on a.srno=b.srno where flag='P'       
  and b.Response like '%"success":false%' 

  update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where  
  starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)              

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_04July2023
-- --------------------------------------------------
      
-- Author:  Neha Naiwar     
-- Create date: 27 Jun 2023      
-- =============================================      
CREATE PROCEDURE Update_CNS_SMS_Response_04July2023     
 @id int,      
 @Response varchar(1000),      
 @Request varchar(max)      
as      
BEGIN      
       
 update SMS_Sent_CNS set Response=@Response ,Flag='A',request=@Request,Response_date=GETDATE() where srno=@id  and flag='P'  
    
 select * into #smsResonse from SMS_Sent_CNS  where srno=@id     
       
update sms set flag='A' from sms I, #smsResonse S               
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message --and I.purpose=S.purpose        
--and purpose in ('T 1','T 7','VMSS_7')        
        
update tbl_sms_withouturl_processlog set EndTime=getdate() where starttime =(select max(starttime) from tbl_sms_withouturl_processlog)        
        
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_06July2023
-- --------------------------------------------------
            
-- Author:  Neha Naiwar           
-- Create date: 27 Jun 2023            
-- =============================================            
CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response_06July2023]           
 @id int,            
 @Response varchar(1000),            
 @Request varchar(max)            
as            
BEGIN            
             
 update SMS_Sent_CNS set Response=case when @Response like '%"success":false%'  then '' else @Response end,      
 Flag=case when @Response like '%"success":false%'  then 'P' else 'A' end,request=@Request,Response_date=GETDATE() where srno=@id  and flag='P'       
 and NoOfAttempt<=4      
       
update SMS_Sent_CNS set NoOfAttempt=NoOfAttempt+1 where srno=@id  and flag='P' and @Response like '%"success":false%'        
and NoOfAttempt<=4      
      
          
-- select * into #smsResonse from SMS_Sent_CNS  where srno=@id           
             
--update sms set flag='A' from sms I, #smsResonse S                     
--where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message --and I.purpose=S.purpose              
--and purpose in ('T 1','T 7','VMSS_7')              
              
--update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where  
--starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)              
              
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_13May2025
-- --------------------------------------------------


            

-- Author:  Neha Naiwar           
-- Create date: 27 Jun 2023            
-- =============================================            
create PROCEDURE [dbo].[Update_CNS_SMS_Response_13May2025]                     
as            
BEGIN            

   Declare @filePath1 varchar(500)=''        
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog.txt'

   truncate table SMS_CNS_Response
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                
   EXEC(@sql1) 

  update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from SMS_Sent_CNS a join SMS_CNS_Response b on a.srno=b.srno where flag='P'       
  and b.Response like '%"success":true%' 

  update a set a.Response=b.response,a.response_date=getdate() from SMS_Sent_CNS a join SMS_CNS_Response b on a.srno=b.srno where flag='P'       
  and b.Response like '%"success":false%' 

  update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where  
  starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)              

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_27Jun2023
-- --------------------------------------------------
    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE Update_CNS_SMS_Response_27Jun2023   
 @id int,    
 @Response varchar(1000),    
 @Request varchar(max)    
as    
BEGIN    
     
 update SMS_Sent_CNS set Response=case when @Response like '%"success":false%'  then '' else @Response end,
 Flag=case when @Response like '%"success":false%'  then 'P' else 'A' end,request=@Request,Response_date=GETDATE() where srno=@id  and flag='P' 
 and NoOfAttempt<=4
 
update SMS_Sent_CNS set NoOfAttempt=NoOfAttempt+1 where srno=@id  and flag='P' and @Response like '%"success":false%'  
and NoOfAttempt<=4  
  
-- select * into #smsResonse from SMS_Sent_CNS  where srno=@id   
     
--update sms set flag='A' from sms I, #smsResonse S             
--where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message --and I.purpose=S.purpose      
----and purpose in ('T 1','T 7','VMSS_7')      
      
--update tbl_sms_withouturl_processlog set EndTime=getdate() where starttime =(select max(starttime) from tbl_sms_withouturl_processlog)      
      
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_NRMS
-- --------------------------------------------------

              

-- Author:  Neha Naiwar             

-- Create date: 27 Jun 2023              

-- =============================================              

CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response_NRMS]                       

as              

BEGIN              

   Declare @filePath1 varchar(500)=''          

   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog_nrms.txt'   

   truncate table NRMS_SMS_CNS_Response       

   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT NRMS_SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                  

   EXEC(@sql1)   


    update a set a.Response=b.response,a.flag='A',a.response_date=getdate()
	from tbl_SMS_CNS_NRMS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

    and b.Response like '%"success":true%'   

	update a set a.Response=b.response,a.response_date=getdate() 
	from tbl_SMS_CNS_NRMS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         
    and b.Response like '%"success":false%'   

	update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where    
	starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_NRMS_bkup_08062025
-- --------------------------------------------------

              

-- Author:  Neha Naiwar             

-- Create date: 27 Jun 2023              

-- =============================================              

Create PROCEDURE [dbo].[Update_CNS_SMS_Response_NRMS_bkup_08062025]                       

as              

BEGIN              

   

   Declare @filePath1 varchar(500)=''          

   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog_nrms.txt'  

   

   truncate table NRMS_SMS_CNS_Response  

        

   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT NRMS_SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                  

   EXEC(@sql1)   

  

    update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from NRMS_SMS_Sent_CNS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

    and b.Response like '%"success":true%'   

  

	update a set a.Response=b.response,a.response_date=getdate() from NRMS_SMS_Sent_CNS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

    and b.Response like '%"success":false%'   

  

	update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where    

	starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                

                

            

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_NRMS_bkup_17062025
-- --------------------------------------------------


              

-- Author:  Neha Naiwar             

-- Create date: 27 Jun 2023              

-- =============================================              

CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response_NRMS_bkup_17062025]                       

as              

BEGIN              

   

   Declare @filePath1 varchar(500)=''          

   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog_nrms.txt'  

   

   truncate table NRMS_SMS_CNS_Response  

        

   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT NRMS_SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                  

   EXEC(@sql1)   

  

    update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from NRMS_SMS_Sent_CNS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

    and b.Response like '%"success":true%'   

  

	update a set a.Response=b.response,a.response_date=getdate() from NRMS_SMS_Sent_CNS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

    and b.Response like '%"success":false%'   

  

	update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where    

	starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                

                

            

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_NRMS_clientid
-- --------------------------------------------------


              

-- Author:  Neha Naiwar             

-- Create date: 27 Jun 2023              

-- =============================================              

CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response_NRMS_clientid]                       
@payload varchar(500)
as              

BEGIN              

   insert into NRMS_SMS_CNS_Response_test(payload)
   select @payload

 --  Declare @filePath1 varchar(500)=''          

 --  set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog_nrms.txt'  

   

 --  truncate table NRMS_SMS_CNS_Response  

        

 --  DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT NRMS_SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                  

 --  EXEC(@sql1)   

  

 --   update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from tbl_SMS_CNS_NRMS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

 --   and b.Response like '%"success":true%'   

  

	--update a set a.Response=b.response,a.response_date=getdate() from tbl_SMS_CNS_NRMS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'         

 --   and b.Response like '%"success":false%'   

  

	--update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where    

	--starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                

                

            

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_NRMS_NEW
-- --------------------------------------------------
  
                
  
-- Author:  Abha Jaiswal            
  
-- Create date: 29 Nov 2026  
-- =============================================                
  
CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response_NRMS_NEW]                         
  
as                
  
BEGIN                
  
   Declare @filePath1 varchar(500)=''            
  
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\NRMS_SMS_LOG\W_Notification_log.txt'     
  
   truncate table NRMS_SMS_CNS_Response         
  
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT NRMS_SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                    
  
   EXEC(@sql1)     
  
  
    update a set a.Response=b.response,a.flag='A',a.requestdate=getdate()  
 from Tbl_SMS_NRMS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'           
    and b.Response like '%"success":true%'     
  
 update a set a.Response=b.response,a.requestdate=getdate()   
 from Tbl_SMS_NRMS a join NRMS_SMS_CNS_Response b on a.srno=b.srno where flag='P'           
    and b.Response like '%"success":false%'     
  
 update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where      
 starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_SebiPO
-- --------------------------------------------------
  
  
CREATE PROCEDURE Update_CNS_SMS_Response_SebiPO 
as  
BEGIN 
   Declare @filePath1 varchar(500)='' 
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog_SebiPO.txt'   
  
   truncate table SMS_CNS_Response_SebiPO    
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT SMS_CNS_Response_SebiPO FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                    
   EXEC(@sql1) 
  
    update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from tbl_SMSCNSSent_SebiPO a join SMS_CNS_Response_SebiPO b on a.srno=b.srno where flag='P'           
    and b.Response like '%"success":true%'     
  
   update a set a.Response=b.response,a.response_date=getdate() from tbl_SMSCNSSent_SebiPO a join SMS_CNS_Response_SebiPO b on a.srno=b.srno where flag='P'           
   and b.Response like '%"success":false%'     
    
 update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS_SebiPO a where starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS_SebiPO)                  
        
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_SebiPO_01dec2025
-- --------------------------------------------------
CREATE PROCEDURE Update_CNS_SMS_Response_SebiPO_01dec2025  
as  
BEGIN 
   Declare @filePath1 varchar(500)='' 
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog_SebiPO.txt'   
  
   truncate table SMS_CNS_Response_SebiPO    
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT SMS_CNS_Response_SebiPO FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                    
   EXEC(@sql1) 
  
    update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from SMS_Sent_CNS_SebiPO a join SMS_CNS_Response_SebiPO b on a.srno=b.srno where flag='P'           
    and b.Response like '%"success":true%'     
  
   update a set a.Response=b.response,a.response_date=getdate() from SMS_Sent_CNS_SebiPO a join SMS_CNS_Response_SebiPO b on a.srno=b.srno where flag='P'           
   and b.Response like '%"success":false%'     
    
 update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS_SebiPO a where starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS_SebiPO)                  
        
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMS_Response_testing
-- --------------------------------------------------
  
  
              
  
-- Author:  Neha Naiwar             
-- Create date: 27 Jun 2023              
-- =============================================              
CREATE PROCEDURE [dbo].[Update_CNS_SMS_Response_testing]                       
as              
BEGIN              
  
   --Declare @filePath1 varchar(500)=''          
   --set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog.txt'  
  
   --truncate table SMS_CNS_Response  
   --DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                  
   --EXEC(@sql1)   
  
  --update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from SMS_Sent_CNS a join SMS_CNS_Response b on a.srno=b.srno where flag='P'         
  --and b.Response like '%"success":true%'   
  
  --update a set a.Response=b.response,a.response_date=getdate() from SMS_Sent_CNS a join SMS_CNS_Response b on a.srno=b.srno where flag='P'         
  --and b.Response like '%"success":false%'   
  
  update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where    
  starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)                
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_CNS_SMSMessage_Response
-- --------------------------------------------------


            

-- Author:  Neha Naiwar           
-- Create date: 27 Jun 2023            
-- =============================================            
create PROCEDURE [dbo].[Update_CNS_SMSMessage_Response]                     
as            
BEGIN            

   Declare @filePath1 varchar(500)=''        
   set @filePath1 ='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\CNS_SMS_log\smslog.txt'

   truncate table SMS_CNS_Response
   DECLARE @sql1 NVARCHAR(4000) = 'BULK INSERT SMS_CNS_Response FROM ''' + @filePath1 + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';                
   EXEC(@sql1) 

  update a set a.Response=b.response,a.flag='A',a.response_date=getdate() from tbl_SMSCNS_send a join SMS_CNS_Response b on a.srno=b.srno where flag='P'       
  and b.Response like '%"success":true%' 

  update a set a.Response=b.response,a.response_date=getdate() from tbl_SMSCNS_send a join SMS_CNS_Response b on a.srno=b.srno where flag='P'       
  and b.Response like '%"success":false%' 

  update a set EndTime=getdate() from tbl_sms_withouturl_processlog_CNS a where  
  starttime =(select max(starttime) from tbl_sms_withouturl_processlog_CNS)              

END

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
-- PROCEDURE dbo.USP_KYC_Send_SMS
-- --------------------------------------------------
CREATE Proc USP_KYC_Send_SMS(@Fdate as varchar(11),@Tdate as varchar(11),@mode as varchar(5))                
as                
              
set @Fdate = convert(varchar(11),convert(datetime,@Fdate,103))               
set @Tdate = convert(varchar(11),convert(datetime,@Tdate,103))               
              
if @mode = 'N'      
begin      
 select * from        
 (        
 select a.*,b.Mobile_Pager  from                
 (                
 select client_code,convert(varchar(11),dispatch_date) as dispatch_date ,pod,cour_compn_name                
 from NSECOURIER.DBO.delivered (nolock) where convert(varchar(11),dispatch_date) >= @Fdate and convert(varchar(11),dispatch_date) <= @Tdate+' 23:59:59'            
 and delivered='yes'                
 ) a inner join                
 (select * from intranet.risk.dbo.client_details (nolock)) b                  
 on a.client_code = b.cl_code              
 ) x inner join        
 (select * from tbl_Mobile_No (nolock) where flag = 'N') c        
 on x.client_code = c.client_code          
        
end      
else      
begin      
 select * from        
 (        
 select a.*,b.Mobile_Pager  from                
 (                
 select client_code,convert(varchar(11),dispatch_date) as dispatch_date ,pod,cour_compn_name                
 from NSECOURIER.DBO.delivered (nolock) where convert(varchar(11),dispatch_date) >= @Fdate and convert(varchar(11),dispatch_date) <= @Tdate+' 23:59:59'            
 and delivered='yes'                
 ) a inner join                
 (select * from intranet.risk.dbo.client_details (nolock)) b                  
 on a.client_code = b.cl_code              
 ) x inner join        
 (select * from tbl_Mobile_No (nolock) where flag = 'Y') c        
 on x.client_code = c.client_code          
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_KYC_Send_SMS_1
-- --------------------------------------------------
CREATE Proc USP_KYC_Send_SMS_1(@Fdate as varchar(11))                  
as                  
                
set @Fdate = convert(varchar(11),convert(datetime,@Fdate))                 
  
                
 select x.client_code,c.Mobile_Number,x.cour_compn_name,x.pod,x.dispatch_date from          
 (          
 select a.*,b.Mobile_Pager  from                  
 (                  
 select client_code,convert(varchar(11),dispatch_date) as dispatch_date ,pod,cour_compn_name                  
 from NSECOURIER.DBO.delivered (nolock) where convert(varchar(11),dispatch_date) >= @Fdate and convert(varchar(11),dispatch_date) <= @Fdate+' 23:59:59'              
 and delivered='yes'                  
 ) a inner join                  
 (select * from intranet.risk.dbo.client_details (nolock)) b                    
 on a.client_code = b.cl_code                
 ) x inner join          
 (select * from tbl_Mobile_No (nolock) where flag = 'N') c          
 on x.client_code = c.client_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Mobile_Mismatch
-- --------------------------------------------------
CREATE proc Usp_Mobile_Mismatch(@fdate as varchar(11),@tdate as varchar(11),@flag as varchar(2))            
as                 
                
set nocount on       
      
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))         
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))         
    
if @flag = 'M'    
    
Begin                
 select x.Client_Code,x.Mobile_Number from tbl_Mobile_No x where not exists            
 (select * from intranet.risk.dbo.client_details  y (nolock) where x.client_code = y.cl_code and x.Mobile_Number = y.Mobile_Pager)      
 and Entry_Date >= @fdate and Entry_Date <= @tdate + ' 23:59:59'           
end    
else     
begin    
 select Client_Code,Mobile_Number from tbl_Mobile_No where Entry_Date >= @fdate and Entry_Date <= @tdate + ' 23:59:59'    
end     
          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Mobile_Mismatch_1
-- --------------------------------------------------
CREATE proc Usp_Mobile_Mismatch_1(@fdate as varchar(11),@tdate as varchar(11))                
as                     
                    
set nocount on           
          
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))             
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))     
    
select x.Client_Code,right(x.Mobile_Number,10) as Mobile_Number from tbl_Mobile_No x where not exists                
 (select * from intranet.risk.dbo.client_details  y (nolock) where x.client_code = y.cl_code and right(x.Mobile_Number,10) = right(y.Mobile_Pager,10))          
 and Entry_Date >= @fdate and Entry_Date <= @tdate + ' 23:59:59' and Flag = 'N'        
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RTGS_SMS
-- --------------------------------------------------
CREATE Proc [dbo].[USP_RTGS_SMS](@cltCode varchar(15),@Flag varchar(2))            
as            
            
if @Flag = 'R'            
            
begin            
            
 insert into sms            
 select mobile_pager,'Dear '+upper(long_name)+'-'+upper(cl_code)+', Thank you for Registering for Payout through NEFT/RTGS. Your application will be approved post verification.',            
 convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P','','RTGS'           
 from AngelNseCM.msajag.dbo.client_details where cl_code = @cltCode         
             
select case when email = '' then 'NA' else email end as email from           
AngelNseCM.msajag.dbo.client_details           
where cl_code = @cltCode            
            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEBIFMC_PAYOUTDETAILS
-- --------------------------------------------------
--USP_SEBIFMC_PAYOUTDETAILS 'ZONE','ALL','03-10-2016','03-10-2016','sccs','post','BROKER','CSO'            
CREATE PROCEDURE [dbo].[USP_SEBIFMC_PAYOUTDETAILS]                
(              
@EntityType as varchar(10),                  
@EntityCode as varchar(10),                 
@FromDate as varchar(11),  --              
@ToDate as varchar(11),  --              
@Payout as varchar(10),  --              
@Purpose as varchar(80),  --              
@access_to as varchar(10),  --              
@access_code as varchar(10)  --              
)                
AS                
SET NOCOUNT ON                
BEGIN                

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

			if(@EntityCode='ALL')              
			begin              
			 set @EntityCode='%'              
			end      
              
                
			if @Payout ='Both' and @Purpose='Both' 

			begin 

			set @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
			set @Payout='%' 
			 

			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no
			/* and CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))               */
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			union 
			SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))*/
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 

			end

			else if @Payout ='SCCS' and @Purpose='Both' 

			begin 

			set @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
			set @Payout='%FMC'
			print 'pramod1'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and (CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))  or CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))             )               */
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message not LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 


			end

			else if @Payout ='FMC' and ( @Purpose='Both' or @Purpose='Post')

			begin 

			set @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
			set @Payout='%FMC'
			print 'pramod2'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and (CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) )))               */
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message  LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 


			end

			else if @Payout ='SCCS' and @Purpose='Pre' 

			begin 

			set @Purpose ='Sebi PreSMS'
			set @Payout='%FMC'
			print 'pramod3'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no
			/* and  CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))               */
			AND SM.purpose =@Purpose
			--IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message not LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 


			end

			else if @Payout ='SCCS' and @Purpose='Post' 

			begin 

			set @Purpose ='SEBI Circular Funds Payout'
			set @Payout='%FMC'
			print 'pramod4'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and (CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))  )               */
			AND SM.purpose =@Purpose
			--IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message not LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 


			end    
        
END                
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEBIFMC_PAYOUTDETAILS_12_Sept_2017
-- --------------------------------------------------
--USP_SEBIFMC_PAYOUTDETAILS_12_Sept_2017 'ZONE','ALL','09-09-2017','11-09-2017','Both','Both','BROKER','CSO'            
CREATE PROCEDURE [dbo].[USP_SEBIFMC_PAYOUTDETAILS_12_Sept_2017]                
(              
@EntityType as varchar(10),                  
@EntityCode as varchar(10),                 
@FromDate as varchar(11),  --              
@ToDate as varchar(11),  --              
@Payout as varchar(10),  --              
@Purpose as varchar(80),  --              
@access_to as varchar(10),  --              
@access_code as varchar(10)  --              
)                
AS                
SET NOCOUNT ON                
BEGIN                

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

			if(@EntityCode='ALL')              
			begin              
			 set @EntityCode='%'              
			end      
              
                
			if @Payout ='Both' and @Purpose='Both' 

			begin 

			set @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
			set @Payout='%' 
			 

			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no
			/* and CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))               */
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			union 
			SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))*/
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 
			
			print 'p1'

			end

			else if @Payout ='SCCS' and @Purpose='Both' 

			begin 

			set @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
			set @Payout='%FMC'
			print 'pramod1'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and (CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))  or CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))             )               */
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message not LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 
				
				print 'p2'

			end

			else if @Payout ='FMC' and ( @Purpose='Both' or @Purpose='Post')

			begin 

			set @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
			set @Payout='%FMC'
			print 'pramod2'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and (CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) )))               */
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message  LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 
            
            print 'p3'

			end

			else if @Payout ='SCCS' and @Purpose='Pre' 

			begin 

			set @Purpose ='Sebi PreSMS'
			set @Payout='%FMC'
			print 'pramod3'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no
			/* and  CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))               */
			AND SM.purpose =@Purpose
			--IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message not LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 
			print 'p4'
			
			end

			else if @Payout ='SCCS' and @Purpose='Post' 

			begin 

			set @Purpose ='SEBI Circular Funds Payout'
			set @Payout='%FMC'
			print 'pramod4'
			select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM WITH (NOLOCK) ON CI.MOBILE_PAGER=SM.to_no 
			/*and (CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))  )               */
			AND SM.purpose =@Purpose
			--IN ((select val from dbo.split(@Purpose,',')))                  
			and SM.message not LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 


			end    
        
END                
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEBIFMC_PAYOUTDETAILS_19Jan2015
-- --------------------------------------------------
--USP_SEBIFMC_PAYOUTDETAILS 'ZONE','ALL','03-01-2015','13-01-2015','sccs','Pre','BROKER','CSO'            
CREATE PROCEDURE USP_SEBIFMC_PAYOUTDETAILS_19Jan2015                
(              
@EntityType as varchar(10),                  
@EntityCode as varchar(10),                 
@FromDate as varchar(11),  --              
@ToDate as varchar(11),  --              
@Payout as varchar(10),  --              
@Purpose as varchar(80),  --              
@access_to as varchar(10),  --              
@access_code as varchar(10)  --              
)                
AS                
SET NOCOUNT ON                
BEGIN                
                
--DECLARE @Payout as varchar(10),@Purpose as varchar(30)                
--SET @Payout='%'                
--SET @Purpose='BOTH'                
              
if(@EntityCode='ALL')              
begin              
 set @EntityCode='%'              
end              
                
dECLARE @FILTER VARCHAR(5000),@filename VARCHAR(5000),@CLIENTDETAILS VARCHAR(5000)                
                
--set @CLIENTDETAILS=                
--DROP TABLE #CLIENTDETAILS                
--CREATE TABLE #CLIENTDETAILS                
--(                
--Update_date DATETIME,                
--PARTY_CODE VARCHAR(20),                
--PAYOUT VARCHAR(10)                
--);                
                
--IF @Payout='SCCS'                
-- BEGIN                
--  --SET @CLIENTDETAILS=@CLIENTDETAILS+                
--  INSERT INTO #CLIENTDETAILS                
--  SELECT Update_date,Party_code,PAYOUT='SCCS' FROM MIS.SCCS.DBO.SCCS_DATA_HIST WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'               
-- END                
--ELSE IF @Payout='FMC'                
-- BEGIN                
--  INSERT INTO #CLIENTDETAILS                
--  SELECT Update_date,Party_code,PAYOUT='FMC' FROM MIS.FCCS.DBO.sccs_data_commodities_HISTORY WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'                
-- END                
--ELSE                
-- BEGIN                
--  INSERT INTO #CLIENTDETAILS                
--  SELECT Update_date,Party_code,PAYOUT='SCCS' FROM MIS.SCCS.DBO.SCCS_DATA_HIST WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
--  UNION                
--  SELECT Update_date,Party_code,PAYOUT='FMC' FROM MIS.FCCS.DBO.sccs_data_commodities_HISTORY WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'               
-- END                
                
IF(@Purpose='Both')                
BEGIN                
 SET @Purpose='SEBI Circular Funds Payout,Sebi PreSMS'                
 SET @Payout='%'      
           
 if(@Payout='SCCS')            
  begin            
 set @Payout='%SEBI'            
 end            
 else            
 begin            
 set @Payout='%FMC'            
 end        
END                
ELSE                
BEGIN                
 IF(@Purpose='Post')                
 BEGIN                
  SET @Purpose='SEBI Circular Funds Payout'      
  -----------------------    
  if(@Payout='Both')    
  begin    
   set @Payout='%'    
  end    
  else-----------------------              
 if(@Payout='SCCS')            
  begin            
 set @Payout='%SEBI'            
 end            
 else            
 begin            
 set @Payout='%FMC'            
 end       
             
 END                  
 IF(@Purpose='Pre')                
 BEGIN                
  SET @Purpose='Sebi PreSMS'      
   -----------------------    
  if(@Payout='Both')    
  begin    
   set @Payout='%'    
  end    
  else-----------------------                       
  if(@Payout='SCCS')            
  begin            
 set @Payout='%'            
  end            
  else            
  begin            
 --set @Payout='%FMC'    
 set @Payout='%'              
  end                
 END                
END                
print @Purpose                
print @Payout                
                         
--SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,CD.*,SM.*                 
--FROM #CLIENTDETAILS CD INNER JOIN CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK) ON CD.PARTY_CODE=CI.Client                
--INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no                 
--AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
--AND SM.message LIKE @Payout                
--AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
--and @EntityType like @EntityCode              
--order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT              
      
/* Changes  on 24 Nov 2014*/      
    
  
SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no                 
AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
AND SM.message LIKE @Payout                
AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
and @EntityType like @EntityCode              
order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT                             
          
        
  /*      
SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,CI.mobile_pager,cd.*        
into #new             
FROM CLIENT_VERTICAL_DETAILS CI inner join [196.1.115.167].SCCS.dbo.Vw_sms_data_detailed cd WITH (NOLOCK) on cd.cltcode=CI.CLIENT    
      
SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
FROM #new CI WITH (NOLOCK)               
INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no                 
AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
AND SM.message LIKE @Payout                
AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
and @EntityType like @EntityCode              
order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT       
    */    
        
END                
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEBIFMC_PAYOUTDETAILS_23Jan2015
-- --------------------------------------------------
--USP_SEBIFMC_PAYOUTDETAILS 'ZONE','ALL','01-11-2014','13-01-2015','SCCS','Both','BROKER','CSO'            
create PROCEDURE USP_SEBIFMC_PAYOUTDETAILS_23Jan2015                
(              
@EntityType as varchar(10),                  
@EntityCode as varchar(10),                 
@FromDate as varchar(11),  --              
@ToDate as varchar(11),  --              
@Payout as varchar(10),  --              
@Purpose as varchar(80),  --              
@access_to as varchar(10),  --              
@access_code as varchar(10)  --              
)                
AS                
SET NOCOUNT ON                
BEGIN                
                
--DECLARE @Payout as varchar(10),@Purpose as varchar(30)                
--SET @Payout='%'                
--SET @Purpose='BOTH'                
              
if(@EntityCode='ALL')              
begin              
 set @EntityCode='%'              
end              
                
dECLARE @FILTER VARCHAR(5000),@filename VARCHAR(5000),@CLIENTDETAILS VARCHAR(5000)                
                
--set @CLIENTDETAILS=                
--DROP TABLE #CLIENTDETAILS                
--CREATE TABLE #CLIENTDETAILS                
--(                
--Update_date DATETIME,                
--PARTY_CODE VARCHAR(20),                
--PAYOUT VARCHAR(10)                
--);                
                
--IF @Payout='SCCS'                
-- BEGIN                
--  --SET @CLIENTDETAILS=@CLIENTDETAILS+                
--  INSERT INTO #CLIENTDETAILS                
--  SELECT Update_date,Party_code,PAYOUT='SCCS' FROM MIS.SCCS.DBO.SCCS_DATA_HIST WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'               
-- END                
--ELSE IF @Payout='FMC'                
-- BEGIN                
--  INSERT INTO #CLIENTDETAILS                
--  SELECT Update_date,Party_code,PAYOUT='FMC' FROM MIS.FCCS.DBO.sccs_data_commodities_HISTORY WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'                
-- END                
--ELSE                
-- BEGIN                
--  INSERT INTO #CLIENTDETAILS                
--  SELECT Update_date,Party_code,PAYOUT='SCCS' FROM MIS.SCCS.DBO.SCCS_DATA_HIST WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
--  UNION                
--  SELECT Update_date,Party_code,PAYOUT='FMC' FROM MIS.FCCS.DBO.sccs_data_commodities_HISTORY WITH (NOLOCK) WHERE Update_date BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'               
-- END                
                
IF(@Purpose='Both')                
BEGIN                
 SET @Purpose='SEBI Circular Funds Payout,Sebi PreSMS'                
 --SET @Payout='%'     
 if(@Payout='SCCS')            
  begin            
	set @Payout='%'            
  end            
 else if(@Payout='FMC')            
	begin            
		set @Payout='%FMC'            
	end
	else
	begin
		SET @Payout='%'
	end        
END                
ELSE                
BEGIN                
 IF(@Purpose='Post')                
 BEGIN                
  SET @Purpose='SEBI Circular Funds Payout'      
  -----------------------    
  if(@Payout='Both')    
  begin    
   set @Payout='%'    
  end    
  else-----------------------              
 if(@Payout='SCCS')            
  begin            
 set @Payout='%SEBI'            
 end            
 else            
 begin            
 set @Payout='%FMC'            
 end       
             
 END                  
 IF(@Purpose='Pre')                
 BEGIN                
  SET @Purpose='Sebi PreSMS'      
   -----------------------    
  if(@Payout='Both')    
  begin    
   set @Payout='%'    
  end    
  else-----------------------                       
  if(@Payout='SCCS')            
  begin            
	set @Payout='%'            
  end            
  else            
  begin            
	set @Payout='%FMC'    
 --set @Payout='%'              
  end                
 END                
END                
print @Purpose                
print @Payout                
                         
--SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,CD.*,SM.*                 
--FROM #CLIENTDETAILS CD INNER JOIN CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK) ON CD.PARTY_CODE=CI.Client                
--INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no                 
--AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
--AND SM.message LIKE @Payout                
--AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
--and @EntityType like @EntityCode              
--order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT              
      
/* Changes  on 24 Nov 2014*/      

if @Purpose ='SEBI Circular Funds Payout'
begin
			SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no and CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))               
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT  
end

else if  @Purpose ='SEBI Circular Funds Payout,Sebi PreSMS'
begin 
            select * from (SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no and CI.CLIENT = SUBSTRING (  SUBSTRING(SM.message ,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)),0,CHARINDEX (' ',SUBSTRING(SM.message,CHARINDEX ('Client Code',SM.message ) +12,LEN (SM.message)) ))               
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			union 
			SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no and CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                  
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode) a              
			order by a.ZONE,a.REGION,a.BRANCH,a.SB,a.CLIENT 
			
end
else if @Purpose='Sebi PreSMS'
begin 
			SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
			FROM CLIENT_VERTICAL_DETAILS CI WITH (NOLOCK)               
			INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no and CI.CLIENT = substring (SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message)),0, charindex (',', SUBSTRING(SM.message ,CHARINDEX ('Client',SM.message ) +7,LEN (SM.message))))                
			AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
			AND SM.message LIKE @Payout                
			AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
			and @EntityType like @EntityCode              
			order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT  
end
  
                           
          
        
  /*      
SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,CI.mobile_pager,cd.*        
into #new             
FROM CLIENT_VERTICAL_DETAILS CI inner join [196.1.115.167].SCCS.dbo.Vw_sms_data_detailed cd WITH (NOLOCK) on cd.cltcode=CI.CLIENT    
      
SELECT CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT,SM.*                 
FROM #new CI WITH (NOLOCK)               
INNER JOIN SMS SM ON CI.MOBILE_PAGER=SM.to_no                 
AND SM.purpose IN ((select val from dbo.split(@Purpose,',')))                 
AND SM.message LIKE @Payout                
AND convert(datetime,SM.date,103) BETWEEN convert(datetime,@FromDate,103) AND convert(datetime,@ToDate,103) + '23:59:59.000'              
and @EntityType like @EntityCode              
order by CI.ZONE,CI.REGION,CI.BRANCH,CI.SB,CI.CLIENT       
    */    
        
END                
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEBIPayout_SMS
-- --------------------------------------------------
Create Proc USP_SEBIPayout_SMS
(
@access_to varchar(20),
@access_code varchar(20)
)
as
set nocount on
select  * from sms with (nolock) where purpose ='SEBI Circular Funds Payout' and [date]=convert(varchar(11),GETDATE(),103)
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SendSMS_Response
-- --------------------------------------------------
--USP_SendSMS_Response '09/02/2019'
CREATE proc [dbo].[USP_SendSMS_Response]
@date varchar(20)
as
BEGIN
	select to_no,[message],[date],case when flag='A' then 'Sent' when flag='P' then 'Pending' else flag end as Flag from 
	DBO.SMS where [date]=Convert(varchar,@date,103) and purpose='WellnessPromo' 

	--declare @Status varchar(50)='',@mob1 varchar(10),@msg1 varchar(max),@date1 varchar(20)
	--select @mob1=to_no,@msg1=message,@date1=[date],@Status=flag from 
	-- [INTRANET].SMS.DBO.SMS where to_no=@mob and [message]=@msg and [date]=Convert(varchar,@date,103) and purpose='WellnessPromo' 
	--print @mob
	--print @msg
	--print @date
	--select @mob1 as MobileNo,@msg1 as message ,@Status as Status,@date1 as [Date]
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SifyPasswordReset
-- --------------------------------------------------
--USP_SifyPasswordReset  '1234567890','hi','3/22/2011 12:56:56 PM','P','sify'

--exec sms.dbo.USP_SifyPasswordReset '9665953812','As requested. Your Sify Login has been initialized and your new Password is a6te4n67','3/22/2011 3:02:10 PM','P','Sify Password Reset' 

CREATE proc USP_SifyPasswordReset  
(  
@telno as varchar(15),  
@message as varchar(max),  
@date as datetime,  
@flag as varchar(1),  
@purpose as varchar(max)  
)  
as  

declare @dt as varchar(11),@tm as varchar(10),@ampm as varchar(2)
/*
declare @date as datetime,@telno as varchar(15)
declare @message as varchar(max),  @flag as varchar(1),  @purpose as varchar(max)  
set @telno ='123456789'
set @date = getdate()
*/
set @dt = convert(varchar,convert(datetime,@date),103)--date
set @tm = substring(right(convert(varchar,convert(datetime,dateadd(minute,30,@date),8)),7),0,6)--time
set @ampm =substring(right(convert(varchar,convert(datetime,dateadd(minute,30,@date),8)),7),6,8)--AMPM
--select top 0 * into #tempsms from sms  
--insert into sms
insert into sms
values (  
@telno,   
@message,   
@dt,  
@tm,  
@flag,  
@ampm,  
@purpose  
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sms_alert_cli_password
-- --------------------------------------------------

  
CREATE proc usp_sms_alert_cli_password                  
as                  
begin                  
declare @res int                  
 /*DATEADD (hh , 12 , getdate()-1),convert(varchar(11),getdate())+' '+min(time),*/                  
                  
select to_no,message,Purpose--@res=isnull(datediff(mi,convert(varchar(11),getdate())+' '+min(time),DATEADD (hh , 12 , getdate()-1)),0)   
into #data                 
from sms   
where purpose in ('Cli password reset','password reset') and   
time<>''  and flag='p'  
and  convert(datetime,date,103) >getdate()-1    
group by to_no,message,Purpose  
having isnull(datediff(mi,convert(varchar(11),getdate())+' '+min(time),DATEADD (hh , 12 , getdate()-1)),0)>5      
/*and to_no<>'9327521830'                    */      
  
select a.*,b.party_code into #final from #data a,risk.dbo.client_details b where a.to_no=b.mobile_pager order by a.to_no  
  
if (select count(1) from #data)>0                              
begin     
declare @tableHTML1 AS NVARCHAR(max);                                                                              
            SET @tableHTML1=''                                                   
  SET @tableHTML1 =                                                                              
  N'Dear Sir/Madam,<br><br>' +                                                      
  N'<table  border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF" style="border:#000000 solid 1px;font-size:13px;font-family:Arial">'                          
  +N'<tr>'                                                               
  +N'<th  bgcolor="#AA98D3"  >Sr. No.</th> '                                                                           
  +N'<th bgcolor="#AA98D3" >Client Code</th>'     
  +N'<th bgcolor="#AA98D3"  >Mobile Number</th>'                                                                            
  +N'<th  bgcolor="#AA98D3"  >Purpose</th>'                            
  +N'</tr>'+                                                                              
  CAST((select top 100 td = Row_number() over(order by party_code),'',  
  td = party_code, '',                                                                            
  td = to_no,'',  
  td = Purpose,''     
 from #final   order by to_no                                                                 
 FOR XML PATH('tr'),TYPE) AS NVARCHAR(MAX)) +                                                              
  '</tr>'  
  +N' </table><br><br>'+                                                                              
  +N'SMS delay more than 5 minutes set for PASSWORD RESET';                                                                              
--  print @tableHTML1  
  EXEC intranet.msdb.dbo.sp_send_dbmail                                   
  @profile_name = 'intranet',                                  
  --@recipients='inhouse.support@angeltrade.com;manesh@angeltrade.com',              --@stTo,                    
  @recipients='inhouse.support@angeltrade.com',              --@stTo,                    
  @subject ='SMS-Cli Password Reset', -- 'Request for deactivation / Surrender of NEAT /TWS / IML Direct Id',                                  
  @body = @tableHTML1 , /*'SMS delay more than 5 minutes for the purpose of CLI PASSWORD RESET'                */  
     @body_format = 'HTML'            
end    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sms_process_withouturl
-- --------------------------------------------------
    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_sms_process_withouturl]    
AS    
BEGIN    
    
select  SentFrom='AngelInHouse',purpose,to_no ,message,DeliveryAckRequired='N',TransmissionTime=GETDATE (),SMSSentStatus='N',TokenID=NEWID() ,time,[date]   
into #sms     
from dbo.sms with (nolock)     
where date= CONVERT(varchar,GETDATE(),103) and flag='P' and to_no is not null and to_no<>'' and   
purpose not in ('Full Payout Processed','Partial Payout Processed','Payout UTR','Payout BOD CLient Count','Payout Client Insertion',  
'Payout Exception','Payout Rejection','Aggregator Verification Stop','Payout Cancellation','Ageing Day7','NBFC Day 7','MTF Day7','Tday',  
'Brokerage Tariff For 15','Brokerage ITrade PrimePluse','Payout Marking Spark','Payout Marking Client','Brokerage ITrade Prime','Sebi PreSMS','SEBI Circular Funds Payout',
'Broker_Payout','DormantToReactive','ECN Activation','Modify_Mobile no','Trade File Missing','Service Implicit','DPAMC')    
    
insert into tbl_sms_withouturl_processlog    
select getdate(),ss=(select count(1) from #sms),''    
    
insert into [Mimansa].GENERAL.dbo.tbl_smsTransactions_deadqueue(SentFrom, ServiceName, MobileNo, Message, DeliveryAckRequired, TransmissionTime, SMSSentStatus,TokenID)        
select  'AngelInHouse',purpose,to_no ,message,'N',GETDATE (),'N',NEWID()  from #sms     
    
update sms set flag='A' from sms I, #sms S           
where  I.to_no=S.to_no and I.time=s.time and I.[date]=S.[date] and I.flag='P' and I.message=S.message --and I.purpose=S.purpose    
--and purpose in ('T 1','T 7','VMSS_7')    
    
update tbl_sms_withouturl_processlog set EndTime=getdate() where starttime =(select max(starttime) from tbl_sms_withouturl_processlog)    
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Test
-- --------------------------------------------------
Create Proc USP_Test
as

select  * from sms (nolock) where convert(datetime,[date],103) >= convert(varchar(11),getdate()) and flag = 'P'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_testGlobalReport
-- --------------------------------------------------
CREATE proc usp_testGlobalReport
(
 @access_to as varchar(20)=null,        
 @access_code as varchar(20)=null  
)
as
begin

select top 10 * from sms
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_testSSRS
-- --------------------------------------------------
create proc usp_testSSRS
(
@mobno varchar(10)
)
as
begin
	select * from sms where to_no=@mobno
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WatsAPP_NOtification
-- --------------------------------------------------
CREATE Proc [dbo].[WatsAPP_NOtification]      
As      
Begin      
    
declare @mdate as date,@today as date    
    
select top 1 @mdate=Start_date    
from  [CSOKYC-6].General.dbo.BO_Sett_Mst WITH(NOLOCK)    
where co_code='NSECM' and sett_type='M' and    
Start_date >= convert(varchar(11),getdate())    
order by Start_date    
    
select @today=CAST (getdate()  as date )  
print @mdate
    print @today

if(@mdate=@today)    
Begin        
 declare @cmd1 varchar(5000)        
 set @cmd1 = 'start \\INHOUSELIVEAPP1-FS.angelone.in\d\UploadAdvChart\WatsAppNotification\WatsAppNotification\bin\Debug\WatsAppNotification.exe'        
    
 exec master..xp_cmdshell @cmd1 , no_output     
  
   
End    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WD_SMS_Send
-- --------------------------------------------------
create procedure WD_SMS_Send(@num as varchar(10),@msg as varchar(160))  
as  
insert into sms.dbo.sms values   
(@num,@msg,convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P',right(convert(varchar(25),getdate()),2),'WebDevlopment')

GO

-- --------------------------------------------------
-- TABLE dbo.bankingSMS$
-- --------------------------------------------------
CREATE TABLE [dbo].[bankingSMS$]
(
    [SEG] NVARCHAR(255) NULL,
    [PARTY_CODE] NVARCHAR(255) NULL,
    [FD] FLOAT NULL,
    [LONG_NAME] NVARCHAR(255) NULL,
    [REGION] NVARCHAR(255) NULL,
    [BRANCH_CD] NVARCHAR(255) NULL,
    [SUB_BROKER] NVARCHAR(255) NULL,
    [ACTIVEFROM] DATETIME NULL,
    [Sauda Date] DATETIME NULL,
    [EMAIL] NVARCHAR(255) NULL,
    [MOBILE_PAGER] FLOAT NULL,
    [F12] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Check_SMSTest
-- --------------------------------------------------
CREATE TABLE [dbo].[Check_SMSTest]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CNS_Token
-- --------------------------------------------------
CREATE TABLE [dbo].[CNS_Token]
(
    [ServiceName] VARCHAR(50) NULL,
    [AccesstokenValue] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CNS_Token_07Dec2023
-- --------------------------------------------------
CREATE TABLE [dbo].[CNS_Token_07Dec2023]
(
    [ServiceName] VARCHAR(50) NULL,
    [AccesstokenValue] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CNS_Token_14Aug2024
-- --------------------------------------------------
CREATE TABLE [dbo].[CNS_Token_14Aug2024]
(
    [ServiceName] VARCHAR(50) NULL,
    [AccesstokenValue] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CNS_Token_NRMS
-- --------------------------------------------------
CREATE TABLE [dbo].[CNS_Token_NRMS]
(
    [ServiceName] VARCHAR(50) NULL,
    [AccesstokenValue] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CNS_Token_uat
-- --------------------------------------------------
CREATE TABLE [dbo].[CNS_Token_uat]
(
    [ServiceName] VARCHAR(50) NULL,
    [AccesstokenValue] VARCHAR(MAX) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foobar2
-- --------------------------------------------------
CREATE TABLE [dbo].[foobar2]
(
    [that] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hrs
-- --------------------------------------------------
CREATE TABLE [dbo].[hrs]
(
    [HR] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mins
-- --------------------------------------------------
CREATE TABLE [dbo].[mins]
(
    [HR] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Notification_CNS_Response
-- --------------------------------------------------
CREATE TABLE [dbo].[Notification_CNS_Response]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Notification_CNS_Response_aa
-- --------------------------------------------------
CREATE TABLE [dbo].[Notification_CNS_Response_aa]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRMS_SMS_CNS_Response
-- --------------------------------------------------
CREATE TABLE [dbo].[NRMS_SMS_CNS_Response]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRMS_SMS_CNS_Response_test
-- --------------------------------------------------
CREATE TABLE [dbo].[NRMS_SMS_CNS_Response_test]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL,
    [Payload] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRMS_SMS_Sent_CNS
-- --------------------------------------------------
CREATE TABLE [dbo].[NRMS_SMS_Sent_CNS]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRMS_WatsApp_Sent_CNS
-- --------------------------------------------------
CREATE TABLE [dbo].[NRMS_WatsApp_Sent_CNS]
(
    [Party_code] VARCHAR(20) NULL,
    [to_no] VARCHAR(50) NULL,
    [Amount1] MONEY NULL,
    [Amount2] MONEY NULL,
    [Amount3] MONEY NULL,
    [Date1] VARCHAR(10) NULL,
    [Date2] VARCHAR(10) NULL,
    [message] VARCHAR(MAX) NULL,
    [url] VARCHAR(200) NULL,
    [flag] VARCHAR(1) NOT NULL,
    [SMS_Type] VARCHAR(50) NULL,
    [Upd_date] DATETIME NULL,
    [Request] VARCHAR(1) NOT NULL,
    [Response] VARCHAR(200) NULL,
    [Requestdate] DATETIME NOT NULL,
    [purpose] VARCHAR(100) NULL,
    [NoOfAttempt] INT NOT NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms
-- --------------------------------------------------
CREATE TABLE [dbo].[sms]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL DEFAULT 'P',
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_05July2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_05July2023]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_31082015issue
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_31082015issue]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Block_Mobile
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Block_Mobile]
(
    [MobileNo] VARCHAR(10) NULL,
    [Updatedby] VARCHAR(25) NULL,
    [Updatedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Block_Mobile_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Block_Mobile_Log]
(
    [MobileNo] VARCHAR(10) NULL,
    [Updatedby] VARCHAR(25) NULL,
    [Updatedon] DATETIME NULL,
    [LogDate] DATETIME NOT NULL,
    [USER_IP] VARCHAR(15) NULL,
    [AppName] VARCHAR(100) NULL,
    [HostName] VARCHAR(100) NULL,
    [Action] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_check
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_check]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_checking_27Jun2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_checking_27Jun2023]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_CNS_Response
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_CNS_Response]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_CNS_Response_16aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_CNS_Response_16aug2023]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_CNS_Response_SebiPO
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_CNS_Response_SebiPO]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_CNS_Response12jul2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_CNS_Response12jul2023]
(
    [UpdatedOn] VARCHAR(50) NULL,
    [srno] INT NULL,
    [response] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_debitsms
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_debitsms]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_details
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_details]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(20) NULL,
    [Mobilenumber] BIGINT NULL,
    [Designation] VARCHAR(15) NULL,
    [Location] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Error_log
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Error_log]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Msg] VARCHAR(500) NULL,
    [Status] VARCHAR(100) NULL,
    [Error_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Error_log_SebiPO
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Error_log_SebiPO]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Msg] VARCHAR(500) NULL,
    [Status] VARCHAR(100) NULL,
    [Error_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_new
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_new]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] NVARCHAR(2000) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_notsend
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_notsend]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_NRMS_TemplateMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_NRMS_TemplateMaster]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL,
    [notification_type] VARCHAR(200) NULL,
    [Template_Name] VARCHAR(100) NULL,
    [No_Of_parameter] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_NRMS_TemplateMaster_bkup_09012026
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_NRMS_TemplateMaster_bkup_09012026]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL,
    [notification_type] VARCHAR(200) NULL,
    [Template_Name] VARCHAR(100) NULL,
    [No_Of_parameter] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_P
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_P]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Sent_CNS
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Sent_CNS]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Sent_CNS_SebiPO
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Sent_CNS_SebiPO]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Sent_CNS_SebiPO_07Aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Sent_CNS_SebiPO_07Aug2023]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Sent_CNS_SebiPO_07oct2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Sent_CNS_SebiPO_07oct2023]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_temp]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Template_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Template_Master]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL,
    [notification_type] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Template_Master_06Jan2025
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Template_Master_06Jan2025]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL,
    [notification_type] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Template_Master_08Sep2023
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Template_Master_08Sep2023]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_Template_Master_bkup_12022024
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_Template_Master_bkup_12022024]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL,
    [notification_type] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_TemplateMaster_new
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_TemplateMaster_new]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [TemplateID] VARCHAR(500) NULL,
    [SMSContent] VARCHAR(2000) NULL,
    [Purpose] VARCHAR(100) NULL,
    [UpdatedOn] DATETIME NULL,
    [notification_type] VARCHAR(200) NULL,
    [Template_Name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sms_test_19sep2025
-- --------------------------------------------------
CREATE TABLE [dbo].[sms_test_19sep2025]
(
    [Srno] INT NULL,
    [party_code] VARCHAR(50) NULL,
    [template_id] VARCHAR(100) NULL,
    [amountRequested] VARCHAR(200) NULL,
    [amountapproved] VARCHAR(200) NULL,
    [accountNo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tb_WatsApp_Template_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tb_WatsApp_Template_Master]
(
    [Square process] NVARCHAR(255) NULL,
    [SP] NVARCHAR(255) NULL,
    [Purpose] NVARCHAR(255) NULL,
    [Final wats app table] NVARCHAR(255) NULL,
    [Day] NVARCHAR(255) NULL,
    [SMS Content] NVARCHAR(255) NULL,
    [Template Name] NVARCHAR(255) NULL,
    [notification_type] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Mobile_No
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Mobile_No]
(
    [Client_Code] VARCHAR(25) NULL,
    [Mobile_Number] VARCHAR(15) NULL,
    [Entry_Date] DATETIME NULL,
    [Flag] VARCHAR(5) NULL,
    [Send_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SMS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SMS]
(
    [Party_code] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SMS_CNS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SMS_CNS]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Party_code] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SMS_CNS_NRMS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SMS_CNS_NRMS]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Party_code] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_SMS_NRMS
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_SMS_NRMS]
(
    [Party_code] VARCHAR(20) NULL,
    [to_no] VARCHAR(50) NULL,
    [Amount1] MONEY NULL,
    [Amount2] MONEY NULL,
    [Amount3] MONEY NULL,
    [Date1] VARCHAR(10) NULL,
    [Date2] VARCHAR(10) NULL,
    [message] VARCHAR(MAX) NULL,
    [url] VARCHAR(200) NULL,
    [flag] VARCHAR(1) NOT NULL,
    [SMS_Type] VARCHAR(50) NULL,
    [Upd_date] DATETIME NULL,
    [Request] VARCHAR(1) NOT NULL,
    [Response] VARCHAR(200) NULL,
    [Requestdate] DATETIME NOT NULL,
    [purpose] VARCHAR(100) NULL,
    [NoOfAttempt] INT NOT NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_SMS_NRMS_bkup_14
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_SMS_NRMS_bkup_14]
(
    [Party_code] VARCHAR(20) NULL,
    [to_no] VARCHAR(50) NULL,
    [Amount1] MONEY NULL,
    [Amount2] MONEY NULL,
    [Amount3] MONEY NULL,
    [Date1] VARCHAR(10) NULL,
    [Date2] VARCHAR(10) NULL,
    [message] VARCHAR(MAX) NULL,
    [url] VARCHAR(200) NULL,
    [flag] VARCHAR(1) NOT NULL,
    [SMS_Type] VARCHAR(50) NULL,
    [Upd_date] DATETIME NULL,
    [Request] VARCHAR(1) NOT NULL,
    [Response] VARCHAR(200) NULL,
    [Requestdate] DATETIME NOT NULL,
    [purpose] VARCHAR(100) NULL,
    [NoOfAttempt] INT NOT NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_SMS_NRMS_bkup23012026
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_SMS_NRMS_bkup23012026]
(
    [Party_code] VARCHAR(20) NULL,
    [to_no] VARCHAR(50) NULL,
    [Amount1] MONEY NULL,
    [Amount2] MONEY NULL,
    [Amount3] MONEY NULL,
    [Date1] VARCHAR(10) NULL,
    [Date2] VARCHAR(10) NULL,
    [message] VARCHAR(MAX) NULL,
    [url] VARCHAR(200) NULL,
    [flag] VARCHAR(1) NOT NULL,
    [SMS_Type] VARCHAR(50) NULL,
    [Upd_date] DATETIME NULL,
    [Request] VARCHAR(1) NOT NULL,
    [Response] VARCHAR(200) NULL,
    [Requestdate] DATETIME NOT NULL,
    [purpose] VARCHAR(100) NULL,
    [NoOfAttempt] INT NOT NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_SMS_NRMS_pending
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_SMS_NRMS_pending]
(
    [Party_code] VARCHAR(20) NULL,
    [to_no] VARCHAR(50) NULL,
    [Amount1] MONEY NULL,
    [Amount2] MONEY NULL,
    [Amount3] MONEY NULL,
    [Date1] VARCHAR(10) NULL,
    [Date2] VARCHAR(10) NULL,
    [message] VARCHAR(MAX) NULL,
    [url] VARCHAR(200) NULL,
    [flag] VARCHAR(1) NOT NULL,
    [SMS_Type] VARCHAR(50) NULL,
    [Upd_date] DATETIME NULL,
    [Request] VARCHAR(1) NOT NULL,
    [Response] VARCHAR(200) NULL,
    [Requestdate] DATETIME NOT NULL,
    [purpose] VARCHAR(100) NULL,
    [NoOfAttempt] INT NOT NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sms_withouturl_processlog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sms_withouturl_processlog]
(
    [StartTime] DATETIME NULL,
    [Noofrecords] INT NULL,
    [EndTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sms_withouturl_processlog_CNS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sms_withouturl_processlog_CNS]
(
    [StartTime] DATETIME NULL,
    [Noofrecords] INT NULL,
    [EndTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sms_withouturl_processlog_CNS_SebiPO
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sms_withouturl_processlog_CNS_SebiPO]
(
    [StartTime] DATETIME NULL,
    [Noofrecords] INT NULL,
    [EndTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SMSCNS_send
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SMSCNS_send]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Party_code] VARCHAR(50) NULL,
    [Amount_R] MONEY NULL,
    [Amount_A] MONEY NULL,
    [accountNo] VARCHAR(50) NULL,
    [UTR] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SMSCNSSent_SebiPO
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SMSCNSSent_SebiPO]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Party_code] VARCHAR(50) NULL,
    [Amount_R] MONEY NULL,
    [Amount_A] MONEY NULL,
    [accountNo] VARCHAR(50) NULL,
    [UTR] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SMSMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SMSMessages]
(
    [Party_code] VARCHAR(50) NOT NULL,
    [Amount_R] VARCHAR(100) NULL,
    [Amount_A] VARCHAR(100) NULL,
    [accountNo] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL,
    [UTR] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SmsPurpose_master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SmsPurpose_master]
(
    [Message] VARCHAR(500) NULL,
    [Purpose] VARCHAR(100) NULL,
    [Date] VARCHAR(20) NULL,
    [MappedInCommonSMSComponent] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_watsapp_data_notification
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_watsapp_data_notification]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [DATE] VARCHAR(20) NULL,
    [TIME] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL,
    [upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_WatsApp_Template_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_WatsApp_Template_Master]
(
    [SquareOffprocess] NVARCHAR(255) NULL,
    [SP] NVARCHAR(255) NULL,
    [Purpose] NVARCHAR(255) NULL,
    [WhatsApp_table] NVARCHAR(255) NULL,
    [Day] NVARCHAR(255) NULL,
    [SMS_Content] VARCHAR(MAX) NULL,
    [Template_Name] NVARCHAR(255) NULL,
    [notification_type] VARCHAR(20) NULL,
    [No_Of_parameter] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_WatsAppNot_withouturl_processlog_CNS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_WatsAppNot_withouturl_processlog_CNS]
(
    [StartTime] DATETIME NULL,
    [Noofrecords] INT NULL,
    [EndTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_call
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_call]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmpsms
-- --------------------------------------------------
CREATE TABLE [dbo].[tmpsms]
(
    [Srno] INT NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL,
    [TemplateID] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmpsms_15Apr2025
-- --------------------------------------------------
CREATE TABLE [dbo].[tmpsms_15Apr2025]
(
    [Srno] INT NOT NULL,
    [to_no] VARCHAR(50) NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(500) NULL,
    [time] VARCHAR(500) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(10) NULL,
    [purpose] VARCHAR(100) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [Response_date] DATETIME NULL,
    [NoOfAttempt] INT NULL,
    [EntryDate] DATETIME NULL,
    [TemplateID] VARCHAR(500) NULL,
    [party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.todeletefortest
-- --------------------------------------------------
CREATE TABLE [dbo].[todeletefortest]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.todeletefortest_1
-- --------------------------------------------------
CREATE TABLE [dbo].[todeletefortest_1]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.todeletefortest_2
-- --------------------------------------------------
CREATE TABLE [dbo].[todeletefortest_2]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_SMS_Block
-- --------------------------------------------------

CREATE TRIGGER TR_SMS_BLOCK  
ON SMS  
FOR INSERT  
AS
BEGIN 
	 SET NOCOUNT ON;   
    IF EXISTS (SELECT * FROM SMS_BLOCK_MOBILE B INNER JOIN INSERTED I  
                ON I.TO_NO=B.MOBILENO )  
    BEGIN  
        UPDATE SMS  SET FLAG='X'   
        FROM  INSERTED I  
        WHERE  SMS.TO_NO=I.TO_NO  
            AND SMS.[DATE]=I.[DATE]  
            AND SMS.[TIME]=I.[TIME]  
            AND SMS.AMPM=I.AMPM  
            AND SMS.PURPOSE=I.PURPOSE  
            AND SMS.FLAG='P'    
    END 
     SET NOCOUNT OFF; 
END

GO

-- --------------------------------------------------
-- TRIGGER dbo.TR_SMS_BLOCK_MOBILE_DELETE_LOG
-- --------------------------------------------------
CREATE TRIGGER TR_SMS_BLOCK_MOBILE_DELETE_LOG
ON SMS_BLOCK_MOBILE
FOR Delete
AS
BEGIN
		SET NOCOUNT ON;          
		DECLARE @IPADDRESS AS VARCHAR(20)          
		    
		SELECT @IPADDRESS = CLIENT_NET_ADDRESS          
		FROM SYS.DM_EXEC_CONNECTIONS          
		WHERE SESSION_ID = @@SPID 
		
		INSERT INTO SMS_BLOCK_MOBILE_LOG
		(
			MOBILENO,UPDATEDBY,UPDATEDON,LOGDATE,USER_IP,APPNAME,HOSTNAME,[ACTION]         
		)
		SELECT *,GETDATE(),@IPADDRESS,APP_NAME(),HOST_NAME(),'DELETE' FROM DELETED
		SET NOCOUNT OFF;
END

GO

-- --------------------------------------------------
-- TRIGGER dbo.TR_SMS_BLOCK_MOBILE_INSERT_LOG
-- --------------------------------------------------

CREATE TRIGGER TR_SMS_BLOCK_MOBILE_INSERT_LOG
ON SMS_BLOCK_MOBILE
FOR INSERT
AS
BEGIN
		SET NOCOUNT ON;          
		DECLARE @IPADDRESS AS VARCHAR(20)          
		    
		SELECT @IPADDRESS = CLIENT_NET_ADDRESS          
		FROM SYS.DM_EXEC_CONNECTIONS          
		WHERE SESSION_ID = @@SPID 
		
		INSERT INTO SMS_BLOCK_MOBILE_LOG
		(
			MOBILENO,UPDATEDBY,UPDATEDON,LOGDATE,USER_IP,APPNAME,HOSTNAME,[ACTION]         
		)
		SELECT *,GETDATE(),@IPADDRESS,APP_NAME(),HOST_NAME(),'INSERT' FROM INSERTED
		SET NOCOUNT OFF;
END

GO

-- --------------------------------------------------
-- TRIGGER dbo.TR_SMS_BLOCK_MOBILE_UPDATE_LOG
-- --------------------------------------------------

CREATE TRIGGER TR_SMS_BLOCK_MOBILE_UPDATE_LOG
ON SMS_BLOCK_MOBILE
FOR UPDATE
AS
BEGIN
		SET NOCOUNT ON;          
		DECLARE @IPADDRESS AS VARCHAR(20)          
		    
		SELECT @IPADDRESS = CLIENT_NET_ADDRESS          
		FROM SYS.DM_EXEC_CONNECTIONS          
		WHERE SESSION_ID = @@SPID 
		
		INSERT INTO SMS_BLOCK_MOBILE_LOG
		(
			MOBILENO,UPDATEDBY,UPDATEDON,LOGDATE,USER_IP,APPNAME,HOSTNAME,[ACTION]         
		)
		SELECT *,GETDATE(),@IPADDRESS,APP_NAME(),HOST_NAME(),'UPDATE' FROM DELETED
		SET NOCOUNT OFF;
END

GO

-- --------------------------------------------------
-- VIEW dbo.Checking_SMS_testing
-- --------------------------------------------------
CREATE view Checking_SMS_testing  
as  

select * from Check_SMSTest

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_VERTICAL_DETAILS
-- --------------------------------------------------
CREATE VIEW CLIENT_VERTICAL_DETAILS
AS
SELECT Zone,CV.Region,BRANCH,SB,CLIENT,mobile_pager FROM RISK.DBO.vw_RMS_Client_Vertical CV INNER JOIN RISK.DBO.Client_Details CD WITH (NOLOCK)
ON CV.Client=CD.party_code

GO

-- --------------------------------------------------
-- VIEW dbo.tmp_ViewSms
-- --------------------------------------------------
CREATE View tmp_ViewSms                                        
AS                                                                      
SELECT * FROM tmp_SMS (nolock)   
WHERE CONVERT(DATETIME,[date],103) >= CONVERT(VARCHAR(11),GETDATE())   
AND flag = 'P'                                        
AND CONVERT(DATETIME,[date],103) <= CONVERT(VARCHAR(11),GETDATE())+ ' 23:59:59'   
AND to_no <> ''                               
AND (LEFT(to_no,1) LIKE '%9%' OR LEFT(to_no,1) LIKE '%8%')   
AND (Purpose <> '' OR message <> '') AND LEN(to_no) = 10       
--------------------Add By Aaarvind-----------      
AND message NOT IN      
(      
 SELECT message FROM tmp_SMS (nolock)   
    WHERE message = ANY  
    (       
  SELECT message FROM tmp_SMS (nolock) WHERE purpose = 'harmony' AND message LIKE 'Dear_%'       
  GROUP BY message HAVING COUNT(*) > 1       
 ) AND purpose = 'harmony'  AND flag = 'P'       
)

GO

-- --------------------------------------------------
-- VIEW dbo.tmp_ViewSmsSending
-- --------------------------------------------------
CREATE View tmp_ViewSmsSending                                          
AS                                                                        
SELECT * FROM tmp_SMS (nolock)     
WHERE CONVERT(DATETIME,[date],103) >= CONVERT(VARCHAR(11),GETDATE())     
AND flag = 'P'                                          
AND CONVERT(DATETIME,[date],103) <= CONVERT(VARCHAR(11),GETDATE())+ ' 23:59:59'     
AND to_no <> ''                                 
AND (LEFT(to_no,3) LIKE '%9%' OR LEFT(to_no,3) LIKE '%8%')     
AND (Purpose <> '' OR message <> '') AND LEN(to_no) = 10         
--------------------Add By Aaarvind-----------        
AND message NOT IN        
(        
 SELECT message FROM tmp_SMS (nolock)     
    WHERE message = ANY    
    (         
  SELECT message FROM tmp_SMS (nolock) WHERE purpose = 'harmony' AND message LIKE 'Dear_%'         
  GROUP BY message HAVING COUNT(*) > 1         
 ) AND purpose = 'harmony'  AND flag = 'P'         
)

GO

-- --------------------------------------------------
-- VIEW dbo.V_Sms
-- --------------------------------------------------
CREATE View V_Sms      
as                                                                                
                                                                                
select to_no,message,date,time,flag,ampm,ltrim(rtrim(purpose)) purpose from sms (nolock)                               
where convert(datetime,[date],103) >= convert(varchar(11),getdate()-1) and flag = 'P'                                                                                
and convert(datetime,[date],103) <= convert(varchar(11),getdate())+ ' 23:59:59' and to_no <> ''                                                                       
and (left(to_no,1) like '%9%' or left(to_no,1) like '%8%' or left(to_no,1) like '%7%') and (Purpose <> '' or message <> '')                                     
and len(to_no) = 10 /* and  ( purpose<>'Cli password reset'  AND   purpose<>'password reset')            */
---purpose time <=current time .Added by Ravi Sharma                                    
/*(convert(varchar,time,108)<=                                    
convert(varchar,getdate(),108) or isnull(time,0)='0')   */                                  
----------------------------------------------                                    
--and purpose<>'Online Fund Transfer'                                           
--------------------Add By Aaarvind-----------                                              
and                                   
message not in                                              
(                                              
select message from sms (nolock) where message = any                                              
(                                               
select message from sms (nolock) where purpose = 'harmony' and message like 'Dear_%'                                               
group by message having count(*) > 1                                               
) and purpose = 'harmony'  and flag = 'P'                                                
)                                 
/*and to_no<>'9327521830'                    */        
-------- add by unnati -------------------------                        
--and                        
--message not in                                              
--(                         
--select message from  sms where to_no='9665953812' and purpose='Cli password reset'                        
------------------ add by rozina -----------------                            
----and (to_no<>'9665953812' or purpose='cli Password Reset')                          
--)         
/*Added By paras to block 'E-Broking Activation' sms from 9PM-8AM */      
and not (purpose = 'E-Broking Activation' and (CONVERT(time, getdate()) >= '21:00:00' or CONVERT(time, getdate()) <= '08:00:00'))      
and to_no not in  (select mobileno from SMS_Block_Mobile)  
  
--and purpose ='Square Off Intimation'

GO

-- --------------------------------------------------
-- VIEW dbo.V_Sms_Cli_Password_Reset
-- --------------------------------------------------
CREATE View V_Sms_Cli_Password_Reset                                                                        
as                                                                        
                                                                        
select to_no,message,date,time,flag,ampm,ltrim(rtrim(purpose)) purpose from sms (nolock)                       
where convert(datetime,[date],103) >= convert(varchar(11),getdate()-1) and flag = 'P'                                                                        
and convert(datetime,[date],103) <= convert(varchar(11),getdate())+ ' 23:59:59' and to_no <> ''                                                               
--and (left(to_no,1) like '%9%' or left(to_no,1) like '%8%' or left(to_no,1) like '%7%') 
and (Purpose <> '' or message <> '')                             
and len(to_no) = 10 and   (purpose='Cli password reset'    or   purpose='password reset')                                
---purpose time <=current time .Added by Ravi Sharma                            
/*(convert(varchar,time,108)<=                            
convert(varchar,getdate(),108) or isnull(time,0)='0')   */                          
----------------------------------------------                            
--and purpose<>'Online Fund Transfer'                                   
--------------------Add By Aaarvind-----------                                      
and                           
message not in                                      
(                                      
select message from sms (nolock) where message = any                                      
(                                       
select message from sms (nolock) where purpose = 'harmony' and message like 'Dear_%'                                       
group by message having count(*) > 1                                       
) and purpose = 'harmony'  and flag = 'P'                                        
)                         
/*and to_no<>'9327521830'                  */  
-------- add by unnati -------------------------                
--and                
--message not in                                      
--(                 
--select message from  sms where to_no='9665953812' and purpose='Cli password reset'                
------------------ add by rozina -----------------                    
----and (to_no<>'9665953812' or purpose='cli Password Reset')                  
--)

GO

-- --------------------------------------------------
-- VIEW dbo.vwsms
-- --------------------------------------------------
create view vwsms as select * from tmp_sms

GO

