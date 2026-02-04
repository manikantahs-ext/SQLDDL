-- DDL Export
-- Server: 10.253.33.89
-- Database: Adv_Chart_Activation
-- Exported: 2026-02-05T02:38:28.272264

USE Adv_Chart_Activation;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fun_GetFileExists
-- --------------------------------------------------
    
 Create function [dbo].[fun_GetFileExists](@filePath varchar(4000))        
returns int        
begin       
----@cnt 0 means file exists and 1 means file not exists       
---@filePath complete  path with file name        
declare @Cnt int;        
declare @exists nvarchar(4000)                
set @exists = 'dir ' + @filePath        
exec @Cnt = master..xp_cmdshell @exists,no_output        
return @Cnt;      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Adv_Chart_Email
-- --------------------------------------------------
CREATE Procedure [dbo].[Adv_Chart_Email]              
as              
              
Set nocount on              
           
BEGIN TRY               
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)              
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                        
      SET @emailto='abdulk.choudhary@angelbroking.com;productsupportl2@angelbroking.com;Productdevelopment@angelbroking.com;nikita@delstar.net.in;sales@delstar.net.in'
      --SET @emailto='prashant.patade@angelbroking.com;abdulk.choudhary@angelbroking.com'                      
                             
DECLARE @filename1 as varchar(100)                            
               
/*select @filename1='d:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv' */                                                      

select @filename1='I:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv' 

     
select ClientCode,UserName,Manager into #aa from (select * from TBL_ADVCHART_ACTIVATE where IsApproved=1 and ActivationApprovalDate
 between DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,-1, getdate()))) and DATEADD(hh,16,DATEDIFF(dd,0,getdate())) 
  )a
join 
(select replace(manager_code ,'Manager','Global') as Manager,client_code  from [172.31.12.85].sps_integrated.dbo.pda_fileinfo_details )b
on a.ClientCode=b.client_code    

--exec master..xp_cmdshell 'bcp "SELECT * FROM ##aa" queryout C:\CSV\ExcelTest1.csv -c -t'',''  -T -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '
--declare @sql varchar(8000)
--select @sql = 'bcp "SELECT * FROM #aa" queryout C:\ExcelTest.csv -t, -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc -d adv_chart_cativation -T' 

--exec master..xp_cmdshell @sql

truncate table TBL_ADVCHART_ACTIVATE_heading              

insert into TBL_ADVCHART_ACTIVATE_heading( [Client Id],[Template Id])

SELECT  'Client Id','Template Id'

insert into TBL_ADVCHART_ACTIVATE_heading([Client Id],[Template Id])
SELECT UPPER([ClientCode]),RTRIM([Manager]) --FROM TBL_ADVCHART_ACTIVATE
FROM #aa
     
  DECLARE @BCPCOMMAND VARCHAR(250)        
  DECLARE @FILENAME VARCHAR(250) 
  declare @s1 as varchar(max)        
       
  --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'        
  /*SET @FILENAME = 'd:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv' */                                                              
  SET @FILENAME = 'I:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'
  SET @BCPCOMMAND = 'BCP "SELECT * FROM Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading " QUERYOUT "'        
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'        
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND            
 --set @s1=' EXEC MASTER..XP_CMDSHELL @BCPCOMMAND'  
 --set @s1= @s1+''''                              
 --Exec (@s1)
--declare @s1 as varchar(max)                          
----set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT ClientCode,Manager FROM INTRANET.Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading" queryout '+@filename1+' -c  -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                                                       
--set @s1='exec master.dbo.xp_cmdshell'+ '''' +'bcp "SELECT ClientCode,Manager FROM Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading" QUERYOUT '+@filename1+'-c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '
--set @s1= @s1+''''                              
--Exec (@s1)
--print @s1  
                         
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached Adv Chart Activation .<Br><Br>'                                
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                            
set @sub ='Advance chart activation request'               
 --print @filename1              
                  
 DECLARE @s varchar(500)                
 SET @s = @filename1           
                  
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailto,                            
 @COPY_RECIPIENTS ='Prashant.patade@angelbroking.com;renil.pillai@angelbroking.com;sandeep.rai@angelbroking.com',                        
 @PROFILE_NAME = 'AngelBroking',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = @sub ,                            
 @FILE_ATTACHMENTS =@s,                            
 @BODY =@MESS                            

                         
END TRY                            
BEGIN CATCH                            
                            
                             
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS ='Prashant.patade@angelbroking.com',
 @COPY_RECIPIENTS ='renil.pillai@angelbroking.com;sandeep.rai@angelbroking.com;bi.dba@angelbroking.com',                     
 @PROFILE_NAME = 'AngelBroking',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = 'ERROR in ADV-Chart : Testing',                            
 @FILE_ATTACHMENTS ='',                            
 @BODY ='ERROR'                            
                            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Adv_Chart_Email_1782016_bak
-- --------------------------------------------------
CREATE Procedure [dbo].[Adv_Chart_Email_1782016_bak]              
as              
              
Set nocount on              
 --- date          
BEGIN TRY 

 IF (Not EXISTS (SELECT 1 FROM [196.1.115.239].HARMONY.DBO.HOLIMST WHERE HDATE =  CONVERT(DATETIME,CONVERT(VARCHAR(10), GETDATE(), 112)))) AND DATENAME(WEEKDAY,GETDATE()) <> 'SATURDAY' AND DATENAME(WEEKDAY,GETDATE()) <> 'SUNDAY'                                       
Begin


DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)  ,@job_maxdate as varchar(100)             
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                        
     -- SET @emailto='abdulk.choudhary@angelbroking.com;productsupportl2@angelbroking.com;Productdevelopment@angelbroking.com;nikita@delstar.net.in;sales@delstar.net.in'
     SET @emailto='prashant.patade@angelbroking.com'
      --SET @emailto='prashant.patade@angelbroking.com;abdulk.choudhary@angelbroking.com'                      
                             
DECLARE @filename1 as varchar(100)                            
               
select @filename1='d:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                       

select @job_maxdate=max(maxdate) from tbl_ChartActivationMaxDate   
     
select ClientCode,UserName,Manager into #aa from (select * from TBL_ADVCHART_ACTIVATE where IsApproved=1 and ActivationApprovalDate
 between @job_maxdate and DATEADD(hh,16,DATEDIFF(dd,0,getdate())) 
-- between DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,-1, getdate()))) and DATEADD(hh,16,DATEDIFF(dd,0,getdate())) 
  )a
join 
(select replace(manager_code ,'Manager','Global') as Manager,client_code  from [10.30.30.142].sps_integrated.dbo.pda_fileinfo_details )b
on a.ClientCode=b.client_code    

--exec master..xp_cmdshell 'bcp "SELECT * FROM ##aa" queryout C:\CSV\ExcelTest1.csv -c -t'',''  -T -Sintranet -Uinhouse -Pinh6014 '
--declare @sql varchar(8000)
--select @sql = 'bcp "SELECT * FROM #aa" queryout C:\ExcelTest.csv -t, -c -Sintranet -Uinhouse -Pinh6014 -d adv_chart_cativation -T' 

--exec master..xp_cmdshell @sql

truncate table TBL_ADVCHART_ACTIVATE_heading              

insert into TBL_ADVCHART_ACTIVATE_heading( [Client Id],[Template Id])

SELECT  'Client Id','Template Id'

insert into TBL_ADVCHART_ACTIVATE_heading([Client Id],[Template Id])
SELECT UPPER([ClientCode]),RTRIM([Manager]) --FROM TBL_ADVCHART_ACTIVATE
FROM #aa
     
  DECLARE @BCPCOMMAND VARCHAR(250)        
  DECLARE @FILENAME VARCHAR(250) 
  declare @s1 as varchar(max)        
       
  --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'        
  SET @FILENAME = 'd:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                               
  SET @BCPCOMMAND = 'BCP "SELECT * FROM Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading " QUERYOUT "'        
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'        
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND            
 --set @s1=' EXEC MASTER..XP_CMDSHELL @BCPCOMMAND'  
 --set @s1= @s1+''''                              
 --Exec (@s1)
--declare @s1 as varchar(max)                          
----set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT ClientCode,Manager FROM INTRANET.Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading" queryout '+@filename1+' -c  -Sintranet -Uinhouse -Pinh6014'                                                                                       
--set @s1='exec master.dbo.xp_cmdshell'+ '''' +'bcp "SELECT ClientCode,Manager FROM Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading" QUERYOUT '+@filename1+'-c -t, -Sintranet -Uinhouse -Pinh6014 '
--set @s1= @s1+''''                              
--Exec (@s1)
--print @s1  
                         
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached Adv Chart Activation .<Br><Br>'                                
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                            
set @sub ='Advance chart activation request'               
 --print @filename1              
                  
 DECLARE @s varchar(500)                
 SET @s = @filename1           
                  
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailto,                            
 --@COPY_RECIPIENTS ='Prashant.patade@angelbroking.com;renil.pillai@angelbroking.com;sandeep.rai@angelbroking.com',                        
 @PROFILE_NAME = 'AngelBroking',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = @sub ,                            
 @FILE_ATTACHMENTS =@s,                            
 @BODY =@MESS                            

insert into tbl_ChartActivationMaxDate  select DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,0, getdate())))

End
END TRY                            
BEGIN CATCH                            
                            
                             
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS ='Prashant.patade@angelbroking.com',
 --@COPY_RECIPIENTS ='renil.pillai@angelbroking.com;sandeep.rai@angelbroking.com;bi.dba@angelbroking.com',                     
 @PROFILE_NAME = 'AngelBroking',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = 'ERROR in ADV-Chart : Testing',                            
 @FILE_ATTACHMENTS ='',                            
 @BODY ='ERROR'                            
                            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Adv_Chart_Email_Sat_Sun
-- --------------------------------------------------
CREATE Procedure [dbo].[Adv_Chart_Email_Sat_Sun]              
as              
              
Set nocount on              
 --- date          
BEGIN TRY 

 IF (Not EXISTS (SELECT 1 FROM [MIDDLEWARE].HARMONY.DBO.HOLIMST WHERE HDATE =  CONVERT(DATETIME,CONVERT(VARCHAR(10), GETDATE(), 112)))) AND DATENAME(WEEKDAY,GETDATE()) <> 'SATURDAY' AND DATENAME(WEEKDAY,GETDATE()) <> 'SUNDAY'                                       
Begin


DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)  ,@job_maxdate as varchar(100)             
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                        
     SET @emailto='haji.shaikh@angelbroking.com;productsupportl2@angelbroking.com;Productdevelopment@angelbroking.com;nikita@delstar.net.in;sales@delstar.net.in;info@deltafinsoft.com'
     --SET @emailto='prashant.patade@angelbroking.com'
      --SET @emailto='prashant.patade@angelbroking.com;abdulk.choudhary@angelbroking.com'                      
                             
DECLARE @filename1 as varchar(100)                            
               
select @filename1='I:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                       

truncate table tbl_ChartActivation_EmailClient
select @job_maxdate=max(maxdate) from tbl_ChartActivationMaxDate   
 
     
select ClientCode,UserName,Manager 
into #aa
 from (select * from TBL_ADVCHART_ACTIVATE where IsApproved=1 and ActivationApprovalDate
 between @job_maxdate and DATEADD(hh,16,DATEDIFF(dd,0,getdate())) 
-- between DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,-1, getdate()))) and DATEADD(hh,16,DATEDIFF(dd,0,getdate())) 
  )a
join 
(select replace(manager_code ,'Manager','Global') as Manager,client_code  from [172.31.12.85].sps_integrated.dbo.pda_fileinfo_details )b
on a.ClientCode=b.client_code    


insert into tbl_ChartActivation_EmailClient
select ClientCode,'' from #aa


--exec master..xp_cmdshell 'bcp "SELECT * FROM ##aa" queryout C:\CSV\ExcelTest1.csv -c -t'',''  -T -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '
--declare @sql varchar(8000)
--select @sql = 'bcp "SELECT * FROM #aa" queryout C:\ExcelTest.csv -t, -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc -d adv_chart_cativation -T' 

--exec master..xp_cmdshell @sql

truncate table TBL_ADVCHART_ACTIVATE_heading              

insert into TBL_ADVCHART_ACTIVATE_heading( [Client Id],[Template Id])

SELECT  'Client Id','Template Id'

insert into TBL_ADVCHART_ACTIVATE_heading([Client Id],[Template Id])
SELECT UPPER([ClientCode]),RTRIM([Manager]) --FROM TBL_ADVCHART_ACTIVATE
FROM #aa
     
  DECLARE @BCPCOMMAND VARCHAR(250)        
  DECLARE @FILENAME VARCHAR(250) 
  declare @s1 as varchar(max)        
       
  --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'        
  SET @FILENAME = 'I:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                               
  SET @BCPCOMMAND = 'BCP "SELECT * FROM Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading " QUERYOUT "'        
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'        
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND            
 --set @s1=' EXEC MASTER..XP_CMDSHELL @BCPCOMMAND'  
 --set @s1= @s1+''''                              
 --Exec (@s1)
--declare @s1 as varchar(max)                          
----set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT ClientCode,Manager FROM INTRANET.Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading" queryout '+@filename1+' -c  -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                                                       
--set @s1='exec master.dbo.xp_cmdshell'+ '''' +'bcp "SELECT ClientCode,Manager FROM Adv_Chart_Activation.dbo.TBL_ADVCHART_ACTIVATE_heading" QUERYOUT '+@filename1+'-c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '
--set @s1= @s1+''''                              
--Exec (@s1)
--print @s1  
                         
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached Adv Chart Activation .<Br><Br>'                                
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                            
set @sub ='Advance chart activation request'               
 --print @filename1              
                  
 DECLARE @s varchar(500)                
 SET @s = @filename1           
                  
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailto,                            
 @COPY_RECIPIENTS ='Prashant.patade@angelbroking.com',                        
 @PROFILE_NAME = 'AngelBroking',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = @sub ,                            
 @FILE_ATTACHMENTS =@s,                            
 @BODY =@MESS                            

insert into tbl_ChartActivationMaxDate  select DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,0, getdate())))

End
END TRY                            
BEGIN CATCH                            
                         
                             
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS ='Prashant.patade@angelbroking.com',
 --@COPY_RECIPIENTS ='renil.pillai@angelbroking.com;sandeep.rai@angelbroking.com;bi.dba@angelbroking.com',                     
 @PROFILE_NAME = 'AngelBroking',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = 'ERROR in ADV-Chart : Testing',                            
 @FILE_ATTACHMENTS ='',                            
 @BODY ='ERROR'                            
                            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.del_ChartApproval
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[del_ChartApproval]   
 (  
 @srno as int,
 @StatusAddedBy as varchar(50),
 @Remarks as varchar(50)
 )  
AS  
BEGIN  
  
  
 --delete from AdvChart_Activate where srno=@srno  
 --Record insert --N  
 --Approval --A  
 --Rejected --R  
   
 update AdvChart_Activate set [Approval_Reject]='Deactived',StatusAddedBy=@StatusAddedBy,Remarks=@Remarks  where srno=@srno  
  
 --insert into AdvChart_Activate (ECode,EmployeeName)  
 --select ECode,EmployeeName from AdvChart_Activate  
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_AdvChart_Report
-- --------------------------------------------------
-- [Get_AdvChart_Report]  '13/07/2016','13/07/2016','','all','',''
CREATE PROCEDURE [dbo].[Get_AdvChart_Report] --rp61,'R',''
  (
		@FromDate as varchar(11),                
		@toDate as varchar(11), 
		@ClientCode nvarchar(50),
		@Approval_Reject nvarchar(50),
		@access_to varchar(30),                    
		@access_code varchar(30)   
		
   )
AS
BEGIN

Declare @CONDITION as varchar(max)='', @query as varchar(max)=''


If (isnull(@ClientCode,'')<>'' )

  SET  @CONDITION=@CONDITION + ' a.CLIENTCODE='''+@ClientCode+''' '

 --insert into Log_Report (Username,Access_date,IP_address,Report_no,ConnectionString,Report_Query) 
 --select 'E10398',getdate(),'172.29.22.91',793,'196.1.115.132/Adv_Chart_Activation','Command: Get_AdvChart_Report 
 --Parameter: FromDate=13/7/2016;toDate=13/7/2016;ClientCode=;Approval_Reject=;Access_to=BROKER; Access_Code=CSO'
 
If (isnull(@Approval_Reject,'')<>'')
Begin
	  If (isnull(@Approval_Reject,'')='ALL')
		 Begin
			 if(@CONDITION='')			 
			 SET @CONDITION=@CONDITION+ ' a.IsApproved like ''%'''	
			
			 else
			  SET @CONDITION=@CONDITION+ ' and a.IsApproved like ''%'''	
		 End
	 else 
		 Begin
			  if(@CONDITION='')				 
				  SET @CONDITION=@CONDITION+ ' a.IsApproved='''+@Approval_Reject+''' '					  
			  else		  
		  		  SET @CONDITION=@CONDITION+ ' and a.IsApproved='''+@Approval_Reject+''' '		  
		End 
End 

print @CONDITION
set @query='select c.party_code,c.short_name as Party_Code_Name,aa.person_name as Requester_Name,c.sub_broker,
--a.IsApproved,
CASE a.IsApproved
  WHEN 1 THEN ''active'' 
  WHEN 9 THEN ''deactive'' 
   WHEN 0 THEN ''processing'' 

  ELSE ''na'' 
END as Approval_reject ,
a.Remarks, CONVERT(VARCHAR(26), a.RequestDate, 9)  as Date_Of_Request 
from TBL_ADVCHART_ACTIVATE a with(nolock) inner join [CSOKYC-6].general.dbo.client_details c with(nolock) on a.clientcode=c.party_code  
 left join intranet.rolemgm.dbo.user_login aa on
a.UserName=aa.username where
RequestDate>=replace(CONVERT(VARCHAR(12),convert(datetime,'''+@FromDate+''',103),106), ''/'', '' '')+'' 00:00:00''
and RequestDate <=replace(CONVERT(VARCHAR(12),convert(datetime,'''+@todate+''',103),106), ''/'', '' '')+'' 23:59:59''      
and
 '+@CONDITION+''

print @query
Exec (@query)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_AdvChart_Rpt
-- --------------------------------------------------
--Get_AdvChart_Rpt 'rp61','A','CSO','Broker'
--Get_AdvChart_Rpt '13/07/2016','13/07/2016','','1','',''    
CREATE Procedure [dbo].[Get_AdvChart_Rpt]                   
(        
@FromDate as varchar(11),                
@toDate as varchar(11),      
@ClientCode nvarchar(50),
@Approval_Reject nvarchar(50),             
@access_to varchar(30),                    
@access_code varchar(30)                    
)                   
as                    
                
set nocount on                
      
--if @Approval_Reject='All'      
--Begin      
-- set @Approval_Reject='%'      
--End   
--If @ClientCode='' or @ClientCode!=null    
--Begin      
-- set @ClientCode='%'      
--End  
Declare @condition as varchar(max)='', @query as varchar(max)=''

If (isnull(@ClientCode,'')<>'' )
begin
  SET  @CONDITION=@CONDITION + 'and a.CLIENTCODE='''+@ClientCode+''' '
End 
--else
--begin
--  SET  @CONDITION= @CONDITION + 'and 1=1'
--End 
  print @condition
If (isnull(@Approval_Reject,'')<>'')
Begin
	  If (isnull(@Approval_Reject,'')='ALL')
	 Begin
	  SET @CONDITION=@CONDITION+ ' and a.IsApproved like ''%'''	
	 End
	 else 
	 Begin
	  SET @CONDITION=@CONDITION+ ' and a.IsApproved='''+@Approval_Reject+''' '	
	 End 
End 
    
--c.short_name as Requester,
select c.party_code,c.short_name as Party_Code_Name,aa.person_name as Requester_Name,c.sub_broker,a.IsApproved,a.Remarks, a.RequestDate as Date_Of_Request 
from TBL_ADVCHART_ACTIVATE a with(nolock) inner join [196.1.115.182].general.dbo.client_details c on a.clientcode=c.party_code  
 left join intranet.rolemgm.dbo.user_login aa on
a.UserName=aa.username where 
	 IsApproved like @Approval_Reject 
	 and  a.clientcode like @ClientCode and
     RequestDate>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and
     RequestDate <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'      

print @Approval_Reject
print @ClientCode
print @FromDate
print @todate
                
set nocount off     
  
  
--truncate table AdvChart_Activate a.StatusAddedBy as Requester
--select replace(CONVERT(VARCHAR(12),convert(datetime,'13/07/2016',103),106), '/', ' ')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_AdvChart_Rpt_2362016
-- --------------------------------------------------
CREATE Procedure [dbo].[Get_AdvChart_Rpt_2362016]                   
(        
@FromDate as varchar(11),                
@toDate as varchar(11),      
@ClientCode nvarchar(50),
@Approval_Reject nvarchar(50),             
@access_to varchar(30),                    
@access_code varchar(30)                    
)                   
as                    
                
set nocount on                
      
if @Approval_Reject='All'      
Begin      
 set @Approval_Reject='%'      
End      
--c.short_name as Requester,
select c.party_code,aa.person_name as RequesterName,c.sub_broker,a.StatusAddedBy as Requester,a.DateOfRequest, a.Approval_Reject from AdvChart_Activate a with(nolock) inner join 
intranet.risk.dbo.client_details c on a.clientcode=c.party_code join intranet.rolemgm.dbo.user_login aa on
a.StatusAddedBy=aa.username
 where Approval_Reject like @Approval_Reject  
 or  a.clientcode=@ClientCode         
 or DateOfRequest>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
  or DateOfRequest <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'      
 order by DateOfRequest desc   
                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_AdvChart_Rpt_23Jun2016
-- --------------------------------------------------
--Get_AdvChart_Rpt 'rp61','A','CSO','Broker'
--Get_AdvChart_Rpt_23Jun2016 '22/06/2016','23/06/2016','rp61','R','CSO','Broker'    
CREATE Procedure [dbo].[Get_AdvChart_Rpt_23Jun2016]                   
(        
@FromDate as varchar(11),                
@toDate as varchar(11),      
@ClientCode nvarchar(50),
@Approval_Reject nvarchar(50),             
@access_to varchar(30),                    
@access_code varchar(30)                    
)                   
as                    
                
set nocount on                
      
if @Approval_Reject='All'      
Begin      
 set @Approval_Reject='%'      
End      

select c.party_code,aa.person_name as RequesterName,c.sub_broker,a.DateOfRequest,a.Approval_Reject from AdvChart_Activate a with(nolock) inner join 
intranet.risk.dbo.client_details c with(nolock) on a.clientcode=c.party_code join intranet.rolemgm.dbo.user_login aa on
a.StatusAddedBy=aa.username
 where Approval_Reject like @Approval_Reject  
 and  a.clientcode=@ClientCode         
 and DateOfRequest>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
and DateOfRequest <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'      
 order by DateOfRequest desc   
                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_SendEmailAndMsg
-- --------------------------------------------------
 
-- [Get_SendEmailAndMsg]
CREATE PROCEDURE [dbo].[Get_SendEmailAndMsg] 
(
	@CLIENTCODE VARCHAR(50)=''
)

AS
BEGIN TRY    
 
declare @sqlMax varchar(MAX) 
set @sqlMax='<html xmlns="http://www.w3.org/1999/xhtml"><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title>Content for Advance Charts</title><link href="https://fonts.googleapis.com/css?family=Oswald" rel="stylesheet" type="text/css"></head><body><table width="620" border="0" cellspacing="0" cellpadding="0" align="center" style="min-width:620px;"></table><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" style="border:1px solid #d1d1d1;"><tbody><tr><td width="623" align="center" bgcolor="#0071bb" style="vertical-align:top; padding:0px 0px 0px 0px;background-color:#0071bb;"><table width="620" border="0" cellspacing="0" cellpadding="0" style="min-width:620px;"><tbody><tr><td width="325" align="left" valign="bottom" style="padding:10px 0px 10px 5px;"><a href="http://www.angelbroking.com" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/Angel-logo.gif" width="189" height="60" alt="Angel Broking" border="0" style="display:block;color:#fff;background-color:#0071bb;"></a></td><td width="325" align="right" valign="middle"><table width="140" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td><a href="https://www.facebook.com/AngelBrokingLtd" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/ficon.gif" width="29" height="29" alt="Facebook" title="Facebook" border="0"></a></td><td><a href="https://twitter.com/AngelBrokingLtd" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/ticon.gif" width="29" height="29" alt="Twitter" title="Twitter" border="0"></a></td><td><a href="https://www.youtube.com/user/AngelBrokingVideos" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/yutuicon.gif" width="29" height="29" alt="Youtube" title="Youtube" border="0"></a></td><td><a href="https://www.linkedin.com/company/angel-broking" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/inicon.gif" width="29" height="29" alt="linkedin" title="Linkedin" border="0"></a></td></tr></tbody></table></td></tr></tbody></table></td></tr> <tr><td colspan="3" align="left" valign="top" style="background-color:#283748;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_banner.jpg" width="620" height="225" style="display:block;" alt="Advanced Charts"></td></tr><tr><td valign="top" style="font-family:''Open Sans'', Tahoma , Trebuchet MS, sans-serif;font-size:15px;color:#231F20;text-align:left;padding:35px 40px 35px 40px;text-align:justify;"><p style="text-align:justify"><strong>Dear Customer,</strong><br><br>A new <strong>‘Advance charts’</strong> facility is now activated in your Speed Pro account!<br><br>Now identify customized technical patterns independently before executing your trades. </p></td></tr><tr><td align="center" valign="top" bgcolor="#589e48" style="padding:0;background-color:#589e48;"><table width="30%" border="0" cellspacing="0" cellpadding="0" style="min-width:620px;background-color:#589e48;"><tbody><tr><td align="right" style="background-color:#3b802e;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_leftline.jpg" width="72" height="23" style="display:block;" alt="Left Line"></td><td width="120px" align="left" valign="top" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffc03c;font-size:26px;line-height:40px;text-align:center;text-transform:uppercase;font-weight:700;background-color:#3b802e; padding:10px 0px 10px 0px;">Features</td><td align="left" style="background-color:#3b802e;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_leftline.jpg" width="72" height="23" style="display:block;" alt="Right Line"></td></tr></tbody></table></td></tr><tr><td align="center" valign="top" bgcolor="#e7e7e7" style="padding:0;background-color:#589e48;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_arrowimg.jpg" width="620" height="30" alt="Arrow Image"></td></tr><tr><td align="center" valign="top" bgcolor="#e7e7e7" style="padding:0;background-color:#589e48;"><table width="90%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0" style="background-color:#589e48;"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_advance.jpg" width="43" height="43" alt="Revenue and Turnover Report"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">100 + advance studiesand <br>indicators</td></tr><tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_tick.jpg" width="43" height="43" alt="Funds Payout"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">Advance tick watch with<br>condition generator</td></tr><tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td></tr><tr><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_days.jpg" width="43" height="43" alt="Shares Payout"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">60 days intraday data</td></tr><tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_years.jpg" width="43" height="43" alt="Click to Call &amp; Email"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">20 years days historical data</td></tr> <tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td align="center" valign="top" bgcolor="#e7e7e7" style="padding:0;background-color:#589e48;"><table align="center" width="50%" border="0" cellspacing="0" cellpadding="0" style="min-width:620px;"><tbody><tr><td width="15%" align="right" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_scanner.jpg" width="43" height="43" alt="Funds Payout"></td><td width="34%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">Portfolio scanner for default indices</td></tr></tbody></table></td></tr> <tr> <td align="center" valign="top" bgcolor="#589e48" style="padding:0;background-color:#589e48;"><table width="100%" border="0"><tbody><tr><td align="center"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_divline.jpg" width="585" height="45" style="display:block;" alt="Divided Line"></td></tr><tr><td style="font-family:''Open Sans'',sans-serif;color:#ffc03c;font-size:15px;line-height:18px;text-align:center;font-weight:normal;background-color:#589e48;font-weight:600;"><a href="http://pda.angelbolt.in/downloads/PDA%20Downloads/Advance%20chart/Advance%20chart.pdf" target="_blank" style="color:#ffc03c; text-decoration:none; ">Click here to download start up and user guide</a></td></tr> <tr><td>&nbsp;</td></tr></tbody></table></td></tr><tr><td bgcolor="#384c63" style="padding:10px 10px 10px 10px;background-color:#384c63;"><table width="28%" border="0" align="left" cellpadding="0" cellspacing="0"><tbody><tr><td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial, sans-serif; padding:5px 5px 5px 5px;"><a href="http://www.angelbroking.com/?utm_source=dripleads&amp;utm_medium=emailer&amp;utm_campaign=AO-equityinvestment2-13012016-JulAugC1&amp;utm_content=8th-wonder" target="_blank" style="color:#fff;">www.angelbroking.com</a></td></tr></tbody></table><table width="35%" border="0" align="left" cellpadding="0" cellspacing="0" style="border-right:1px solid #d1d1d1; border-left:1px solid #d1d1d1;"><tbody><tr><td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial, sans-serif; padding:5px 5px 5px 5px;"> 022-33551111/022-42185454</td></tr></tbody></table><table width="31%" border="0" align="left" cellpadding="0" cellspacing="0"><tbody><tr><td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial, sans-serif; padding:5px 5px 5px 5px;"><a href="mailto:feedback@angelbroking.com" target="_blank" style="color:#ffffff;">feedback@angelbroking.com</a></td></tr></tbody></table></td></tr><tr><td align="left" style="vertical-align:top;"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td bgcolor="#DBDBDB" style="font-size: 50%; color: #ffffff; font-family: Arial, sans-serif; padding:10px 5px 5px 10px;text-align:center;background-color:#384c63;">Angel Broking Private Limited, Registered Office: G-1, Ackruti Trade Centre, Road No. 7, MIDC, Andheri (E), Mumbai – 400 093. Tel: (022) 3083 7700. Fax: (022) 2835 8811, website: www.angelbroking.com, CIN: U67120MH1996PTC101709, BSE Cash/F&amp;O: INB010996539 /INF010996539, NSE Cash/F&amp;O/CD: INB231279838/INF231279838/ INE231279838, MSEI: INE261279838, CDSL Regn. No.: IN - DP - CDSL - 234 – 2004, PMS Regn. Code: PM/INP000001546, Compliance officer: Mr. Anoop Goyal, Tel: (022) 39413940, Email: compliance@angelbroking.com. Angel Commodities Broking Private Ltd.: CIN: U67120MH1996PTC100872, Compliance Officer: Mr. Nirav Shah, MCX Member ID: 12685 / FMC Regn. No.: MCX / TCM / CORP / 0037 NCDEX: Member ID 00220 / FMC Regn. No.: NCDEX / TCM / CORP / 0302.?</td></tr></tbody></table></td></tr></tbody></table></body></html>'

 
select  ROW_NUMBER() OVER ( ORDER BY b.email) AS [SrNo],  b.email as email,a.PartyCode
   into #ab
	from tbl_ChartActivation_EmailClient
	a inner join risk.dbo.client_Details b 
	on a.partyCode=b.party_code
	
	
	
DECLARE @totctr as int = 0,@ctr as int = 1 

SELECT @totctr=count(1) from #ab   
While @ctr <= @totctr    
BEGIN  
declare @emailto as varchar(1000)

 select @emailto =(Select email from #ab where Srno=@ctr)
 		--SELECT @emailto='prashant.patade@angelbroking.com';
		--select CONVERT(VARCHAR(max),@SqlMax)
		--PRINT CONVERT(VARCHAR(max),@SqlMax1)


  EXEC msdb.dbo.Sp_send_dbmail          
      @profile_name='productsupport',          
      @recipients=@emailto ,--'unnatib.desai@angeltrade.com',          
      --@blind_copy_recipients  ='prashant.patade@angelbroking.com', 
      @blind_copy_recipients ='prashant.patade@angelbroking.com',          
      --@blind_copy_recipients ='tushar.jorigal@angelbroking.com;',          
      @subject = 'Advance charts',          
      @body= @sqlMax,          
      @body_format = 'HTML' 
  set  @ctr=@ctr+1   
--  drop table #ab 
END 
    -------------------------- 
    
	  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                              
	 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from           
	(
	select b.mobile_pager  as No,'Dear Client, Advanced charts on Speed Pro for technical studies now activated in your account. Please refer to 
	the user guide shared on your email for details' as sms_msg  , convert(varchar(10), getdate(), 103) as sms_dt ,                 
	ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time ,                          
	'P' as flag    ,                           
	case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm  ,                           
	'speedpro_charts' as Purpose 
	from (select * from TBL_ADVCHART_ACTIVATE where IsApproved=1 
	and ActivationApprovalDate
	between DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,-1, getdate()))) and DATEADD(hh,16,DATEDIFF(dd,0,getdate()))
	) a inner join risk.dbo.client_Details b 
	on a.clientcode=b.party_code
	)x
	
	Select 1 as Msg
END TRY	
BEGIN CATCH                                        
                                    
 INSERT INTO tbl_Application_Error(ERRTIME,ERROBJECT,ERRLINE,ERRMESSAGE)             
 SELECT GETDATE(),'Email and Message ADV Chart',ERROR_LINE(),ERROR_MESSAGE()                                              
           
 DECLARE @ErrorMessage NVARCHAR(4000);                                          
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                          
 RAISERROR (@ErrorMessage , 16, 1);             
             
END CATCH   

--select * from TBL_ADVCHART_ACTIVATE where IsApproved=1 and ActivationApprovalDate
-- between DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,-1, getdate()))) and DATEADD(hh,16,DATEDIFF(dd,0,getdate()))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ISP_AdvChart_Activate
-- --------------------------------------------------
--[ISP_AdvChart_Activate] 'a34330','0.10','0.05','0.15','','P','E10398','broker','cso'
CREATE PROCEDURE [dbo].[ISP_AdvChart_Activate] 
  (
		@ClientCode nvarchar(50),
		--@ECode nvarchar(50),
		--@EmployeeName nvarchar(50),
        @OnlineRevenue nvarchar(50),
        @OfflineRevenue nvarchar(50),
        @TotalRevenue nvarchar(50),
        @ActivationDate datetime,
        @Approval_Reject nvarchar(50),
        @UserName nvarchar(50),
        @accessto nvarchar(50),
        @accesscode nvarchar(50)
       -- @DateOfRequest date
  )
AS
IF EXISTS(SELECT * FROM AdvChart_Activate WHERE ClientCode = @ClientCode) 
begin
select 'Invalid Client'  

end

else
BEGIN
Insert Into AdvChart_Activate
		(
		   ClientCode,
		 --  ECode,
		   --EmployeeName,
           OnlineRevenue,
           OfflineRevenue,
           TotalRevenue,
           ActivationDate,
           Approval_Reject,
           DateOfRequest,
           UserName,
          accessto,
          accesscode
		)
Values
		(
		@ClientCode,
		--@EmployeeName,
		--@EmployeeName,
        @OnlineRevenue,
        @OfflineRevenue,
        @TotalRevenue,
        @ActivationDate,
        @Approval_Reject,
        GETDATE(),
        @UserName,
        @accessto,
        @accesscode
		)
		
		
END

--select * from AdvChart_Activate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ISP_ADVCHART_PROCESS
-- --------------------------------------------------
--[ISP_ADVCHART_ACTIVATE] '','A34330','sss','0.10','0.05','0.15','','P','E10398','BROKER','CSO','0'
CREATE PROCEDURE [dbo].[ISP_ADVCHART_PROCESS] 
  (
  
        @PROCESS VARCHAR(50)='',
		@CLIENTCODE VARCHAR(50)='',
		@ClientName varchar(50)='',
        @ONLINEREVENUE VARCHAR(500)='',
        @OFFLINEREVENUE VARCHAR(50)='',
        @TOTALREVENUE VARCHAR(50)='',
        @ACTIVATIONDATE DATETIME=NULL,
        @APPROVAL_REJECT VARCHAR(50)='',
        @USERNAME VARCHAR(50)='',
        @ACCESSTO VARCHAR(50)='',
        @ACCESSCODE VARCHAR(50)='',
        @ISAPPROVED INT=0
       -- @DATEOFREQUEST DATE
  )
AS
BEGIN
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)        
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                        

IF @PROCESS='ADD REQUEST'
BEGIN
		IF EXISTS(SELECT * FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE = @CLIENTCODE AND ISAPPROVED IN(0,3,1)) 
		BEGIN
		
		    SELECT 'Client code is already activated for Advance chart' AS MSG

		END

		ELSE
		BEGIN
				INSERT INTO TBL_ADVCHART_ACTIVATE
				(
				CLIENTCODE,
				--  ECODE,
				--EMPLOYEENAME,
				ClientName,
				ONLINEREVENUE,
				OFFLINEREVENUE,
				TOTALREVENUE,
				ACTIVATIONDATE,
				REQUESTDATE,
				USERNAME,
				ACCESSTO,
				ACCESSCODE,
				ISAPPROVED
				)
				VALUES
				(
				@CLIENTCODE,
				@ClientName,
				@ONLINEREVENUE,
				@OFFLINEREVENUE,
				@TOTALREVENUE,
				@ACTIVATIONDATE,
				GETDATE(),
				@USERNAME,
				@ACCESSTO,
				@ACCESSCODE,
				0
				)
				
				SELECT 'REQUEST ACCEPTED' AS MSG


		END
END


IF @PROCESS='DEACTIVE REQUEST'
BEGIN


IF EXISTS(SELECT * FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE = @CLIENTCODE AND ISAPPROVED =1) 
		BEGIN
		
		     UPDATE TBL_ADVCHART_ACTIVATE
		     SET ISAPPROVED=3,DRequestDate=getdate()
		     WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED =1
		     
		    SELECT 'REQUEST ACCEPTED' AS MSG

		END

		ELSE
		BEGIN
				
          SELECT 'INVALID REQUEST'  AS MSG

		END
END
		
		
IF @PROCESS='APPROVE REQUEST'
BEGIN

DECLARE @STATUS AS INT

SELECT @STATUS = ISAPPROVED FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED IN (0,3)

		IF (@STATUS=0)
		BEGIN

		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=1,
		ActivationApprovalDate=GETDATE(),
		ActivationApprovalBy=@USERNAME
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=0
        
        EXEC [172.31.12.85].SPS_INTEGRATED.DBO.USP_CHARTACTIVATION @clientcode ,'ACTIVATE'
        --select * from sms.dbo.sms where to_no='9821535508'
  --      Insert into sms.dbo.sms  
		--select mobile_pager to_no,'Dear Client, Advanced charts on Speed Pro for technical studies now activated in your account. Please refer to the user guide shared on your email for details' as sms_msg  , convert(varchar(10), getdate(), 103) as sms_dt ,                 
		--ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time ,                          
		--'P' as flag    ,                           
		--case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm  ,                           
		--'speedpro_charts' as Purpose 
		--from TBL_ADVCHART_ACTIVATE a inner join risk.dbo.client_Details b 
		--on a.clientcode=b.party_code
		--where clientcode=@CLIENTCODE and IsApproved=1
        
  --      /* for email sending*/
  --       select @Emp_name=long_name,@emp_email=email from risk.dbo.client_Details with (nolock) where cl_code=@CLIENTCODE             
		--	SELECT @emailto=@emp_email 
		--	--select @emailcc='prashant.patade@angelbroking.com'
			
		--		declare @sqlMax varchar(MAX) 
		--		set @sqlMax='<html xmlns="http://www.w3.org/1999/xhtml"><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title>Content for Advance Charts</title><link href="https://fonts.googleapis.com/css?family=Oswald" rel="stylesheet" type="text/css"></head><body><table width="620" border="0" cellspacing="0" cellpadding="0" align="center" style="min-width:620px;"></table><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" style="border:1px solid #d1d1d1;"><tbody><tr><td width="623" align="center" bgcolor="#0071bb" style="vertical-align:top; padding:0px 0px 0px 0px;background-color:#0071bb;"><table width="620" border="0" cellspacing="0" cellpadding="0" style="min-width:620px;"><tbody><tr><td width="325" align="left" valign="bottom" style="padding:10px 0px 10px 5px;"><a href="http://www.angelbroking.com" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/Angel-logo.gif" width="189" height="60" alt="Angel Broking" border="0" style="display:block;color:#fff;background-color:#0071bb;"></a></td><td width="325" align="right" valign="middle"><table width="140" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td><a href="https://www.facebook.com/AngelBrokingLtd" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/ficon.gif" width="29" height="29" alt="Facebook" title="Facebook" border="0"></a></td><td><a href="https://twitter.com/AngelBrokingLtd" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/ticon.gif" width="29" height="29" alt="Twitter" title="Twitter" border="0"></a></td><td><a href="https://www.youtube.com/user/AngelBrokingVideos" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/yutuicon.gif" width="29" height="29" alt="Youtube" title="Youtube" border="0"></a></td><td><a href="https://www.linkedin.com/company/angel-broking" target="_blank"><img src="http://web.angelbackoffice.com/angelbroking/econnect/Budget-special-webinar-26022016/images/inicon.gif" width="29" height="29" alt="linkedin" title="Linkedin" border="0"></a></td></tr></tbody></table></td></tr></tbody></table></td></tr> <tr><td colspan="3" align="left" valign="top" style="background-color:#283748;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_banner.jpg" width="620" height="225" style="display:block;" alt="Advanced Charts"></td></tr><tr><td valign="top" style="font-family:''Open Sans'', Tahoma , Trebuchet MS, sans-serif;font-size:15px;color:#231F20;text-align:left;padding:35px 40px 35px 40px;text-align:justify;"><p style="text-align:justify"><strong>Dear Customer,</strong><br><br>A new <strong>‘Advance charts’</strong> facility is now activated in your Speed Pro account!<br><br>Now identify customized technical patterns independently before executing your trades. </p></td></tr><tr><td align="center" valign="top" bgcolor="#589e48" style="padding:0;background-color:#589e48;"><table width="30%" border="0" cellspacing="0" cellpadding="0" style="min-width:620px;background-color:#589e48;"><tbody><tr><td align="right" style="background-color:#3b802e;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_leftline.jpg" width="72" height="23" style="display:block;" alt="Left Line"></td><td width="120px" align="left" valign="top" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffc03c;font-size:26px;line-height:40px;text-align:center;text-transform:uppercase;font-weight:700;background-color:#3b802e; padding:10px 0px 10px 0px;">Features</td><td align="left" style="background-color:#3b802e;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_leftline.jpg" width="72" height="23" style="display:block;" alt="Right Line"></td></tr></tbody></table></td></tr><tr><td align="center" valign="top" bgcolor="#e7e7e7" style="padding:0;background-color:#589e48;"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_arrowimg.jpg" width="620" height="30" alt="Arrow Image"></td></tr><tr><td align="center" valign="top" bgcolor="#e7e7e7" style="padding:0;background-color:#589e48;"><table width="90%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0" style="background-color:#589e48;"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_advance.jpg" width="43" height="43" alt="Revenue and Turnover Report"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">100 + advance studiesand <br>indicators</td></tr><tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_tick.jpg" width="43" height="43" alt="Funds Payout"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">Advance tick watch with<br>condition generator</td></tr><tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td></tr><tr><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_days.jpg" width="43" height="43" alt="Shares Payout"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">60 days intraday data</td></tr><tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td><td width="50%" align="center" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td width="15%" align="left" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_years.jpg" width="43" height="43" alt="Click to Call &amp; Email"></td><td width="95%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">20 years days historical data</td></tr> <tr><td colspan="2" height="8" align="center" valign="middle" style="line-height:2px;height:20px;"></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td align="center" valign="top" bgcolor="#e7e7e7" style="padding:0;background-color:#589e48;"><table align="center" width="50%" border="0" cellspacing="0" cellpadding="0" style="min-width:620px;"><tbody><tr><td width="15%" align="right" valign="middle"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_scanner.jpg" width="43" height="43" alt="Funds Payout"></td><td width="34%" align="left" valign="middle" style="font-family:''Oswald'',''Open Sans'',sans-serif;color:#ffffff;font-size:17px;line-height:24px;text-align:left;text-transform:uppercase;font-weight:normal;background-color:#589e48;">Portfolio scanner for default indices</td></tr></tbody></table></td></tr> <tr> <td align="center" valign="top" bgcolor="#589e48" style="padding:0;background-color:#589e48;"><table width="100%" border="0"><tbody><tr><td align="center"><img src="http://web.angelbackoffice.com/angelbroking/mailer/images/ac_divline.jpg" width="585" height="45" style="display:block;" alt="Divided Line"></td></tr><tr><td style="font-family:''Open Sans'',sans-serif;color:#ffc03c;font-size:15px;line-height:18px;text-align:center;font-weight:normal;background-color:#589e48;font-weight:600;"><a href="http://pda.angelbolt.in/downloads/PDA%20Downloads/Advance%20chart/Advance%20chart.pdf" target="_blank" style="color:#ffc03c; text-decoration:none; ">Click here to download start up and user guide</a></td></tr> <tr><td>&nbsp;</td></tr></tbody></table></td></tr><tr><td bgcolor="#384c63" style="padding:10px 10px 10px 10px;background-color:#384c63;"><table width="28%" border="0" align="left" cellpadding="0" cellspacing="0"><tbody><tr><td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial, sans-serif; padding:5px 5px 5px 5px;"><a href="http://www.angelbroking.com/?utm_source=dripleads&amp;utm_medium=emailer&amp;utm_campaign=AO-equityinvestment2-13012016-JulAugC1&amp;utm_content=8th-wonder" target="_blank" style="color:#fff;">www.angelbroking.com</a></td></tr></tbody></table><table width="35%" border="0" align="left" cellpadding="0" cellspacing="0" style="border-right:1px solid #d1d1d1; border-left:1px solid #d1d1d1;"><tbody><tr><td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial, sans-serif; padding:5px 5px 5px 5px;"> 1860 500 5006 / 1860 200 2006</td></tr></tbody></table><table width="31%" border="0" align="left" cellpadding="0" cellspacing="0"><tbody><tr><td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial, sans-serif; padding:5px 5px 5px 5px;"><a href="mailto:feedback@angelbroking.com" target="_blank" style="color:#ffffff;">feedback@angelbroking.com</a></td></tr></tbody></table></td></tr><tr><td align="left" style="vertical-align:top;"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tbody><tr><td bgcolor="#DBDBDB" style="font-size: 50%; color: #ffffff; font-family: Arial, sans-serif; padding:10px 5px 5px 10px;text-align:center;background-color:#384c63;">Angel Broking Private Limited, Registered Office: G-1, Ackruti Trade Centre, Road No. 7, MIDC, Andheri (E), Mumbai – 400 093. Tel: (022) 3083 7700. Fax: (022) 2835 8811, website: www.angelbroking.com, CIN: U67120MH1996PTC101709, BSE Cash/F&amp;O: INB010996539 /INF010996539, NSE Cash/F&amp;O/CD: INB231279838/INF231279838/ INE231279838, MSEI: INE261279838, CDSL Regn. No.: IN - DP - CDSL - 234 – 2004, PMS Regn. Code: PM/INP000001546, Compliance officer: Mr. Anoop Goyal, Tel: (022) 39413940, Email: compliance@angelbroking.com. Angel Commodities Broking Private Ltd.: CIN: U67120MH1996PTC100872, Compliance Officer: Mr. Nirav Shah, MCX Member ID: 12685 / FMC Regn. No.: MCX / TCM / CORP / 0037 NCDEX: Member ID 00220 / FMC Regn. No.: NCDEX / TCM / CORP / 0302.?</td></tr></tbody></table></td></tr></tbody></table></body></html>'
		--		select CONVERT(VARCHAR(max),@SqlMax)
		--		--PRINT CONVERT(VARCHAR(max),@SqlMax1)

		--	  EXEC msdb.dbo.Sp_send_dbmail          
		--		  @profile_name='productsupport',          
		--		  @recipients=@emailto,--'unnatib.desai@angeltrade.com',          
		--		  --@blind_copy_recipients ='prashant.patade@angelbroking.com',          
		--		  --@blind_copy_recipients ='tushar.jorigal@angelbroking.com;',          
		--		  @subject = 'Advance charts',          
		--		  @body= @sqlMax,          
		--		  @body_format = 'HTML'  
        /********************/
        
		END 
		ELSE
		BEGIN
		
		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=9,
		DactivationApprovalDate=GETDATE(),
		DactivationApprovalBy=@USERNAME
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=3
		
		 EXEC [172.31.12.85].SPS_INTEGRATED.DBO.USP_CHARTACTIVATION @CLIENTCODE ,'DACTIVATE'
		
		
		
		END

        SELECT 'REQUEST HAS BEEN APPROVED!' AS MSG


END

IF @PROCESS='GET REQUESTDATA'
BEGIN
SELECT srno, ClientCode AS 'CLIENT',OnlineRevenue AS 'ONLINE REVENUE',OfflineRevenue AS 'OFFLINE REVENUE',TotalRevenue AS 'TOTAL REVENUE',
ActivationDate AS 'ACTIVATION DATE',B.PERSON_NAME AS 'USER NAME' ,RequestDate AS 'REQUEST DATE',[REQUEST TYPE] 
FROM (SELECT srno, ClientCode,OnlineRevenue,OfflineRevenue,TotalRevenue,ActivationDate,UserName,CASE WHEN IsApproved =0 THEN  RequestDate ELSE DRequestDate END AS 'RequestDate',CASE WHEN IsApproved =0 THEN 'ACTIVATION REQUEST' ELSE 'DEACTIVATION REQUEST' END 'REQUEST TYPE' 
 FROM TBL_ADVCHART_ACTIVATE WHERE IsApproved IN (0,3))A
 LEFT JOIN (SELECT PERSON_NAME,UserName FROM intranet.rolemgm.dbo.user_login WHERE UserName IS NOT NULL) B
 ON  B.UserName =A.UserName

END


IF @PROCESS='REJECT REQUEST'
BEGIN



SELECT @STATUS = ISAPPROVED FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED IN (0,3)

		IF (@STATUS=0)
		BEGIN

		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=9,
		ActivationApprovalDate=GETDATE(),
		ActivationApprovalBy=@USERNAME,Remarks=@ONLINEREVENUE 
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=0
        
        
        
		END 
		ELSE
		BEGIN
		
		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=1,
		DactivationApprovalDate=GETDATE(),
		DactivationApprovalBy=@USERNAME,Remarks=@ONLINEREVENUE
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=3
		
		END

        SELECT 'REQUEST HAS BEEN APPROVED!' AS MSG


END





--SELECT * FROM ADVCHART_ACTIVATE
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ISP_ADVCHART_PROCESS_pramod
-- --------------------------------------------------
--[ISP_ADVCHART_ACTIVATE] 'A34330','0.10','0.05','0.15','','P','E10398','BROKER','CSO'
create PROCEDURE [dbo].[ISP_ADVCHART_PROCESS_pramod] 
  (
  
        @PROCESS VARCHAR(50)='',
		@CLIENTCODE VARCHAR(50)='',
        @ONLINEREVENUE VARCHAR(500)='',
        @OFFLINEREVENUE VARCHAR(50)='',
        @TOTALREVENUE VARCHAR(50)='',
        @ACTIVATIONDATE DATETIME=NULL,
        @APPROVAL_REJECT VARCHAR(50)='',
        @USERNAME VARCHAR(50)='',
        @ACCESSTO VARCHAR(50)='',
        @ACCESSCODE VARCHAR(50)='',
        @ISAPPROVED INT=0
       -- @DATEOFREQUEST DATE
  )
AS
BEGIN

IF @PROCESS='ADD REQUEST'
BEGIN
		IF EXISTS(SELECT * FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE = @CLIENTCODE AND ISAPPROVED IN(0,3,1)) 
		BEGIN
		
		    SELECT 'INVALID REQUEST' AS MSG

		END

		ELSE
		BEGIN
				INSERT INTO TBL_ADVCHART_ACTIVATE
				(
				CLIENTCODE,
				--  ECODE,
				--EMPLOYEENAME,
				ONLINEREVENUE,
				OFFLINEREVENUE,
				TOTALREVENUE,
				ACTIVATIONDATE,
				REQUESTDATE,
				USERNAME,
				ACCESSTO,
				ACCESSCODE,
				ISAPPROVED
				)
				VALUES
				(
				@CLIENTCODE,
				@ONLINEREVENUE,
				@OFFLINEREVENUE,
				@TOTALREVENUE,
				@ACTIVATIONDATE,
				GETDATE(),
				@USERNAME,
				@ACCESSTO,
				@ACCESSCODE,
				0
				)
				
				SELECT 'REQUEST ACCEPTED' AS MSG


		END
END


IF @PROCESS='DEACTIVE REQUEST'
BEGIN


IF EXISTS(SELECT * FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE = @CLIENTCODE AND ISAPPROVED =1) 
		BEGIN
		
		     UPDATE TBL_ADVCHART_ACTIVATE
		     SET ISAPPROVED=3,DRequestDate=getdate()
		     WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED =1
		     
		    SELECT 'REQUEST ACCEPTED' AS MSG

		END

		ELSE
		BEGIN
				
          SELECT 'INVALID REQUEST'  AS MSG

		END
END
		
		
IF @PROCESS='APPROVE REQUEST'
BEGIN


DECLARE @STATUS AS INT

SELECT @STATUS = ISAPPROVED FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED IN (0,3)

		IF (@STATUS=0)
		BEGIN

		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=1,
		ActivationApprovalDate=GETDATE(),
		ActivationApprovalBy=@USERNAME
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=0
        
        
        
		END 
		ELSE
		BEGIN
		
		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=9,
		DactivationApprovalDate=GETDATE(),
		DactivationApprovalBy=@USERNAME
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=3
		
		END

        SELECT 'REQUEST HAS BEEN APPROVED!' AS MSG


END

IF @PROCESS='GET REQUESTDATA'
BEGIN
SELECT srno, ClientCode AS 'CLIENT',OnlineRevenue AS 'ONLINE REVENUE',OfflineRevenue AS 'OFFLINE REVENUE',TotalRevenue AS 'TOTAL REVENUE',
ActivationDate AS 'ACTIVATION DATE',B.PERSON_NAME AS 'USER NAME' ,RequestDate AS 'REQUEST DATE',[REQUEST TYPE] 
FROM (SELECT srno, ClientCode,OnlineRevenue,OfflineRevenue,TotalRevenue,ActivationDate,UserName,CASE WHEN IsApproved =0 THEN  RequestDate ELSE DRequestDate END AS 'RequestDate',CASE WHEN IsApproved =0 THEN 'ACTIVATION REQUEST' ELSE 'DEACTIVATION REQUEST' END 'REQUEST TYPE' 
 FROM TBL_ADVCHART_ACTIVATE WHERE IsApproved IN (0,3))A
 LEFT JOIN (SELECT PERSON_NAME,UserName FROM intranet.rolemgm.dbo.user_login WHERE UserName IS NOT NULL) B
 ON  B.UserName =A.UserName

END




IF @PROCESS='REJECT REQUEST'
BEGIN



SELECT @STATUS = ISAPPROVED FROM TBL_ADVCHART_ACTIVATE WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED IN (0,3)

		IF (@STATUS=0)
		BEGIN

		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=9,
		ActivationApprovalDate=GETDATE(),
		ActivationApprovalBy=@USERNAME,Remarks=@ONLINEREVENUE 
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=0
        
        
        
		END 
		ELSE
		BEGIN
		
		UPDATE TBL_ADVCHART_ACTIVATE
		SET ISAPPROVED=1,
		DactivationApprovalDate=GETDATE(),
		DactivationApprovalBy=@USERNAME,Remarks=@ONLINEREVENUE
		WHERE CLIENTCODE=@CLIENTCODE AND ISAPPROVED=3
		
		END

        SELECT 'REQUEST HAS BEEN APPROVED!' AS MSG


END





--SELECT * FROM ADVCHART_ACTIVATE
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ISP_FileUpload
-- --------------------------------------------------




--exec Prc_ISP_GL_Code_Report @FilePathName=N'Upload.csv'

CREATE PROCEDURE [dbo].[ISP_FileUpload] 
  (
  @FilePathName VARCHAR(500) = NULL 
  )
AS
BEGIN
truncate table tbl_FileUpload
declare @stServer  varchar(50),
		@path varchar(50),@SQL varchar(max)
		SET @stServer = '196.1.115.183'	 
declare @cnt as int=0
CREATE TABLE #tmp_FileUpload 
		(
			[ClientCode] [varchar](50) NULL,
			[FileName]	[varchar](50) null,
			[File_Size][varchar](50) null
			
		)
		
		SET @path = '\\' + @stServer + '\d$\ChartActivationFile\' + @FilePathName
			PRINT @path
		SET @SQL = 'BULK INSERT  #tmp_FileUpload FROM ''' + @Path + ''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','' , ROWTERMINATOR = ''\n'')'
		
		print @SQL
		EXEC (@SQL)
		declare @maxid int,@minId  int ,@strAttach varchar(100),@IsExist int
	 SET @IsExist = dbo.fun_GetFileExists(@strAttach)
	 IF (@IsExist = 0)
	 Begin
	    insert into tbl_FileUpload(ClientCode,FileName,File_Size,Executable_path,Physical_path,Virtual_path)
		select ClientCode,FileName,File_Size,FileName,FileName,FileName from #tmp_FileUpload --where rowid=@minID
		
		insert into tbl_FileUpload_log(ClientCode,FileName,File_Size,Executable_path,Physical_path,Virtual_path,UploadDate)
		select ClientCode,FileName,File_Size,FileName,FileName,FileName,GETDATE() from #tmp_FileUpload
		
		select @cnt=COUNT(1) from #tmp_FileUpload
		
		
		
		declare @max as int =0
		declare @start as int=1
		select @max=COUNT(1) from tbl_FileUpload
		
		
		while (@start <=@max )
		begin
		
		
		declare @clcode as varchar(50)
		select @clcode = ClientCode from tbl_FileUpload where ID=@start
		
		IF NOT EXISTS(SELECT * FROM [172.31.25.123].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE WHERE CLIENTCODE = @clcode)  
		BEGIN  

		insert into [172.31.25.123].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE
		select clientCode,FileName,'','\'+Executable_path,'\'+Physical_path,'https://pda.angelbolt.in/downloads/PDA%20DOWNLOADS/DeltaLicence/'+Virtual_path,'','','',1,File_Size,'',0,'E~S',4 
		from Adv_Chart_Activation.dbo. tbl_FileUpload where ID=@start

		END 
		
		
		IF NOT EXISTS(SELECT * FROM [172.31.12.85].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE WHERE CLIENTCODE = @clcode)  
		BEGIN  

		insert into [172.31.12.85].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE
		select clientCode,FileName,'','\'+Executable_path,'\'+Physical_path,'https://pda.angelbolt.in/downloads/PDA%20DOWNLOADS/DeltaLicence/'+Virtual_path,'','','',1,File_Size,'',0,'E~S',4 
		from Adv_Chart_Activation.dbo. tbl_FileUpload where ID=@start

		END 
		
		set @start=@start+1
		
		end
		
		 
		
		
		
		
		select 'File Upload Successfully.Total '+ cast (@cnt as varchar(50))+ ' rows uploaded.' as 'Msg'
	END	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ISP_FileUpload_pramod
-- --------------------------------------------------




--exec Prc_ISP_GL_Code_Report @FilePathName=N'Upload.csv'

create PROCEDURE [dbo].[ISP_FileUpload_pramod] 
  (
  @FilePathName VARCHAR(500) = NULL 
  )
AS
BEGIN
truncate table tbl_FileUpload
declare @stServer  varchar(50),
		@path varchar(50),@SQL varchar(max)
		SET @stServer = '196.1.115.183'	 
declare @cnt as int=0
CREATE TABLE #tmp_FileUpload 
		(
			[ClientCode] [varchar](50) NULL,
			[FileName]	[varchar](50) null,
			[File_Size][varchar](50) null,
			[Executable_path][varchar](500)null,
			[Physical_path]	[varchar](500)null,
			[Virtual_path][varchar](500)null	
		)
		
		SET @path = '\\' + @stServer + '\d$\ChartActivationFile\' + @FilePathName
			PRINT @path
		SET @SQL = 'BULK INSERT  #tmp_FileUpload FROM ''' + @Path + ''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','' , ROWTERMINATOR = ''\n'')'
		
		print @SQL
		EXEC (@SQL)
		declare @maxid int,@minId  int ,@strAttach varchar(100),@IsExist int
	 SET @IsExist = dbo.fun_GetFileExists(@strAttach)
	 IF (@IsExist = 0)
	 Begin
	    insert into tbl_FileUpload(ClientCode,FileName,File_Size,Executable_path,Physical_path,Virtual_path)
		select ClientCode,FileName,File_Size,Executable_path,Physical_path,Virtual_path from #tmp_FileUpload --where rowid=@minID
		
		insert into tbl_FileUpload_log(ClientCode,FileName,File_Size,Executable_path,Physical_path,Virtual_path,UploadDate)
		select ClientCode,FileName,File_Size,Executable_path,Physical_path,Virtual_path,GETDATE() from #tmp_FileUpload
		
		select @cnt=COUNT(1) from #tmp_FileUpload
		
		
		
		declare @max as int =0
		declare @start as int=1
		select @max=COUNT(1) from tbl_FileUpload
		
		
		while (@start <=@max )
		begin
		
		declare @clcode as varchar(50)
		select @clcode = ClientCode from tbl_FileUpload where ID=@start
		
		IF NOT EXISTS(SELECT * FROM [10.40.40.29].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE WHERE CLIENTCODE = @clcode)  
		BEGIN  

		insert into [10.40.40.29].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE
		select clientCode,FileName,'',Executable_path,Physical_path,Virtual_path,'','','',1,File_Size,'',0,'E~S',4 
		from Adv_Chart_Activation.dbo. tbl_FileUpload where ID=@start

		END 
		
		
		IF NOT EXISTS(SELECT * FROM [10.30.30.142].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE WHERE CLIENTCODE = @clcode)  
		BEGIN  

		insert into [10.30.30.142].SPS_INTEGRATED.DBO.PDA_CHATACTIVATION_LICENCEFILE
		select clientCode,FileName,'',Executable_path,Physical_path,Virtual_path,'','','',1,File_Size,'',0,'E~S',4 
		from Adv_Chart_Activation.dbo. tbl_FileUpload where ID=@start

		END 
		
		set @start=@start+1
		
		end
		
		 
		
		
		
		
		select 'File Upload Successfully.Total '+ cast (@cnt as varchar(50))+ ' rows uploaded.' as 'Msg'
	END	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ISP_GetChartActivate
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ISP_GetChartActivate] 
 
AS
BEGIN
--select 
--srno,
--isnull(ECode,'') as ECode,
--ClientCode,
--OnlineRevenue,
--OfflineRevenue,
--TotalRevenue,
--ActivationDate,
--Approval_Reject,
--UserName,
--accessto,
--accesscode,
--DateOfRequest,
--isnull(Remarks,'') as Remarks,
--isnull(StatusAddedBy,'') as StatusAddedBy,
--isnull(StatusAddedDate,'') as StatusAddedDate from AdvChart_Activate
--  where ISNULL(Approval_Reject,'Pending')='Pending'
select c.party_code as Client_Code,c.short_name as ClientName, a.OnlineRevenue,a.OfflineRevenue,a.TotalRevenue,a.ActivationDate,aa.person_name as Requestor,a.srno
from AdvChart_Activate a with(nolock) inner join [CSOKYC-6].general.dbo.client_details c with(nolock) on a.clientcode=c.party_code  
 left join intranet.rolemgm.dbo.user_login aa on
a.UserName=aa.username where ISNULL(Approval_Reject,'Pending')='Pending'


--update AdvChart_Activate set [Approval_Reject]='R' where srno=@srno
--select * from AdvChart_Activate

END

--select c.party_code as Client_Code,aa.person_name as Requester_Name,a.OnlineRevenue,a.OfflineRevenue,a.TotalRevenue,a.DateOfRequest 
--from AdvChart_Activate a with(nolock) inner join [CSOKYC-6].general.dbo.client_details c on a.clientcode=c.party_code  
-- left join intranet.rolemgm.dbo.user_login aa on
--a.UserName=aa.username where ISNULL(Approval_Reject,'Pending')='Pending'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_Approval_ChartApproval
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Prc_Approval_ChartApproval] --'102','E66460'
 (
 @srno as int,
 @StatusAddedBy as varchar(50)
 --@ECode as varchar(50)
 )
AS
BEGIN


 --delete from AdvChart_Activate where srno=@srno
 --Record insert --N
 --Approval --A
 --Rejected --R
 
 declare @clientcode as varchar(50)
 
 select @clientcode = ClientCode from AdvChart_Activate where srno=@srno 
 
 update AdvChart_Activate set [Approval_Reject]='Active',StatusAddedBy=@StatusAddedBy where srno=@srno 
 
 
 EXEC [172.31.12.85].SPS_INTEGRATED.DBO.USP_CHARTACTIVATION @clientcode 
-- update AdvChart_Activate set [Approval_Reject]='A',StatusAddedBy='E55539' where srno=104 
 --select * from AdvChart_Activate
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_SessionState
-- --------------------------------------------------
--[Prc_SessionState] 'E10398'
CREATE PROCEDURE [dbo].[Prc_SessionState]  --E10398 
 (  
 @ECode as varchar(50)=null
  )  
AS  
BEGIN

IF EXISTS(select * from AdminMaster where username=@ECode)
BEGIN
select person_name from intranet.rolemgm.dbo.user_login where username=@ECode
END
else
begin
select 'NOT Access'
End

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
-- PROCEDURE dbo.USP_BulkUploadAdvChart
-- --------------------------------------------------
CREATE PROC [dbo].[USP_BulkUploadAdvChart]  --'uploadAdvChart.csv'
(
 @FileName VARCHAR(50) = NULL,
 @Total int out 
)           
AS     
BEGIN
--select * from dbo.TBL_ADVCHART_ACTIVATE

			--BULK INSERT  uploadAdvChart
			----FROM '\\INHOUSELIVEAPP2-FS.angelone.in\D$\UploadAdvChart\uploadAdvChart.csv'  
			--FROM 'D:\UploadAdvChart\ '+@FileName +'
			--WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n',FirstRow=2)';
			
	        truncate table  uploadAdvChart
			Declare @filePath varchar(500)=''
			--Declare @FileName varchar(500)='uploadAdvChart.csv'
			set @filePath ='\\INHOUSELIVEAPP2-FS.angelone.in\D$\UploadAdvChart\'+@FileName+''
			DECLARE @sql NVARCHAR(4000) = 'BULK INSERT uploadAdvChart FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=2 )';
			EXEC(@sql)
			print (@sql)
			print @filePath
			
			insert into  BulkUploadAdvChart 
			select distinct ClientCode,GETDATE()from uploadAdvChart	
						
			
			insert into TBL_ADVCHART_ACTIVATE 
			select null,ClientCode,b.long_name,'0','0','0',GETDATE(),ClientCode,ClientCode,ClientCode,null,GETDATE(),GETDATE(),null,null,'1',null,null  
			from uploadAdvChart a  inner join risk.dbo.client_Details b
	        ON a.ClientCode=b.cl_code
	        
	        set @Total=(select COUNT(1) from uploadAdvChart)
	        --print @Total 
	        --delete TBL_ADVCHART_ACTIVATE where ClientCode='a81764'
	         		
END

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
 PRINT @STR                
  EXEC(@STR)                
        
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_IntradayCode_Email
-- --------------------------------------------------
CREATE  Procedure [dbo].[Usp_IntradayCode_Email]                
as                
                
Set nocount on                
 --- date            
BEGIN TRY   
  
 IF (Not EXISTS (SELECT 1 FROM [MIDDLEWARE].HARMONY.DBO.HOLIMST WHERE HDATE =  CONVERT(DATETIME,CONVERT(VARCHAR(10), GETDATE(), 112)))) AND DATENAME(WEEKDAY,GETDATE()) <> 'SATURDAY' AND DATENAME(WEEKDAY,GETDATE()) <> 'SUNDAY'                           
              
Begin  
  
  
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)  ,@job_maxdate as varchar(100)               
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                          
     SET @emailto='Prashant.patade@angelbroking.com;chandrakant.jadhav@angelbroking.com;tushar.jorigal@angelbroking.com'  
     --SET @emailto='prashant.patade@angelbroking.com'  
      --SET @emailto='prashant.patade@angelbroking.com;abdulk.choudhary@angelbroking.com'                        
                               
DECLARE @filename1 as varchar(100)                              
                 
select @filename1='I:\Adv_Chart_email\Intraday_Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                         
  
truncate table tbl_IntradayCode_EmailClient  
select @job_maxdate=max(maxdate) from tbl_IntradayCodeMaxDate     
  
  
select a.ClientCode,b.sub_broker,b.branch_cd,b.region into #bb from tbl_MTFActiveDeActive_test a join Client_details b   
on a.ClientCode=b.party_code where Segment='Intraday'   
and Update_Date between '2018-07-22 16:00:00.000' and DATEADD(hh,16,DATEDIFF(dd,0,getdate()))  
  
       
insert into TBL_Intraday_heading( ClientCode,sub_broker,branch_cd,region)  
  
SELECT  'Client Code','sub broker','branch code','Region'  
  
truncate table TBL_Intraday_heading  
insert into TBL_Intraday_heading (ClientCode,sub_broker,branch_cd,region)  
select * from #bb  
  
  
                                 
  
  DECLARE @BCPCOMMAND VARCHAR(250)          
  DECLARE @FILENAME VARCHAR(250)   
  declare @s1 as varchar(max)          
         
  --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'          
  SET @FILENAME = 'I:\Adv_Chart_email\Intraday_Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                 
  SET @BCPCOMMAND = 'BCP "SELECT * FROM risk.dbo.TBL_Intraday_heading" QUERYOUT "'          
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'          
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND              
  
                           
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached Adv Chart Activation .<Br><Br>'                                  
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                              
set @sub ='Advance chart activation request'                 
 --print @filename1                
                    
 DECLARE @s varchar(500)                  
 SET @s = @filename1             
                    
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS ='Prashant.patade@angelbroking.com;chandrakant.jadhav@angelbroking.com;tushar.jorigal@angelbroking.com',                              
 @COPY_RECIPIENTS ='Prashant.patade@angelbroking.com',                          
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',                              
 @SUBJECT = @sub ,                              
 @FILE_ATTACHMENTS =@s,                              
 @BODY =@MESS                              
  
insert into tbl_IntradayCodeMaxDate  select DATEADD(hh,16,DATEDIFF(dd,0,DATEADD( dd,0, getdate())))  
  
End  
END TRY                              
BEGIN CATCH                              
                       
                               
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS ='Prashant.patade@angelbroking.com',  
 --@COPY_RECIPIENTS ='renil.pillai@angelbroking.com;sandeep.rai@angelbroking.com;bi.dba@angelbroking.com',                       
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',                              
 @SUBJECT = 'ERROR in Intradey_Email : Testing',                              
 @FILE_ATTACHMENTS ='',                              
 @BODY ='ERROR'                              
                              
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Sent_Fail_WatchlistScript_Log
-- --------------------------------------------------
-- =============================================
-- Author:		<Narendra Prajapati>
-- Create date: <15 Sep 2018>
-- Description:	<Sent ,fail and watchlist script log>
-- =============================================
-- exec USP_Sent_Fail_WatchlistScript_Log
CREATE PROCEDURE [dbo].[USP_Sent_Fail_WatchlistScript_Log]
AS
BEGIN
	-----------Send notification LOg-----------------------
IF EXISTS(Select 1 from [196.1.115.219].mutualfund.dbo.tblLastSentNotification with(nolock) where CAST(InsertedDateON AS DATE)=CAST(GETDATE()-1 AS DATE))
BEGIN

IF  OBJECT_ID('TEMPDB..#temp' ) IS NOT NULL
DROP TABLE #temp

IF  OBJECT_ID('TEMPDB..#t2' ) IS NOT NULL
DROP TABLE #t2
			
IF  OBJECT_ID('TEMPDB..#t1' ) IS NOT NULL
DROP TABLE #t1

truncate table tblWatchlistsentLog
truncate table tblWatchlistFailLog  
truncate table tblWatchlistLog  
	
DECLARE @noOfHoliday int=0
SET @noOfHoliday=(Select NoOfHoliday from [196.1.115.219].mutualfund.dbo.tblLastSentNotification with(nolock) where CAST(InsertedDateON AS DATE)=CAST(GETDATE()-1 AS DATE))
DECLARE @Date varchar(100)=CAST(GETDATE()-1 AS DATE)

Select substring(request,CHARINDEX('Identity', request)+12,((CHARINDEX('objectId', request)-4)-(CHARINDEX('Identity', request)+12)) ) AS ClientID,
replace(substring(request,CHARINDEX('"ISIN', request)+7,((CHARINDEX('SelectedExchange', request)-3)-(CHARINDEX('"ISIN', request)+7)) ),'"','') AS ISIN,
Replace(substring(request,CHARINDEX('SelectedExchange', request)+19,((CHARINDEX('SelectedExchange', request))-2)),'"}','') AS ExchangeSelected
,RequestTime,Response,ResponseTime,request
 into #t2 from [196.1.115.219].mutualfund.dbo.tbl_SendNotificationRequestResponse with(nolock) where cast(RequestTime as date)=@Date

select ClientId,ISINNUMBER,ExchangeSelected,scriptName,max(InsertedOn) as InsertedOn into #temp 
from [196.1.115.219].mutualfund.dbo.tbl_WebhookData with(nolock) 
where ClientId<>'' and isinnumber<>'' 
AND InsertedOn between DATEADD(hh,15,DATEDIFF(dd,0,DATEADD( dd,-@noOfHoliday, @Date))) and DATEADD(hh,15,DATEDIFF(dd,0,@Date))         
group by ClientId,ISINNUMBER,ExchangeSelected,scriptName 

CREATE NONCLUSTERED INDEX #IX_webhook on #temp (ClientId,ISINNUMBER,ExchangeSelected)

insert into tblWatchlistsentLog( clientid,isin,exchangeSelected,Request,Response,RequestTime,WatchListDateOn)    
SELECT  'clientid','isin','exchangeSelected','Request','Response','RequestTime','WatchListDateOn'    
    
insert into tblWatchlistsentLog( clientid,isin,exchangeSelected,Request,Response,RequestTime,WatchListDateOn)  
select A.clientid,isin,A.exchangeSelected,Request,Response,RequestTime,B.InsertedOn AS WatchListDateOn
from #t2 A 
join 
(select * from #temp)B 
on A.ClientId = B.ClientId AND
A.ISIN=B.ISINNUMBER AND
A.ExchangeSelected=B.ExchangeSelected

-----------failed notification LOg-----------------------
select *  into #t1 from [196.1.115.219].mutualfund.dbo.tbl_PushNotificationLog with(nolock) where cast(insertedon as date)=@Date

insert into tblWatchlistFailLog( ClientCode,ScripName,ISIN,ExchangeSelected,Remark,Status,InsertedOn,WatchListDateOn)    
SELECT  'ClientCode','ScripName','ISIN','ExchangeSelected','Remark','Status','InsertedOn','WatchListDateOn'   

insert into tblWatchlistFailLog( ClientCode,ScripName,ISIN,ExchangeSelected,Remark,Status,InsertedOn,WatchListDateOn) 
select ClientCode,ScripName,ISIN,A.ExchangeSelected,Remark,Status,A.InsertedOn,B.InsertedOn AS WatchListDateOn
from #t1 A 
join 
(select * from #temp)B 
on A.ClientCode = B.ClientId AND
A.ISIN=B.ISINNUMBER AND
A.ExchangeSelected=B.ExchangeSelected
and a.scripname=b.scriptName

--***************Check watchlist status *********************3969

insert into tblWatchlistLog( Clientid,EmailID,[identity],scriptname,isinnumber,exchangeselected,pushnotificationStatus,insertedon)    
SELECT  'Clientid','EmailID','identity','scriptname','isinnumber','exchangeselected','pushnotificationStatus','insertedon'  

insert into tblWatchlistLog( Clientid,EmailID,[identity],scriptname,isinnumber,exchangeselected,pushnotificationStatus,insertedon) 
Select Clientid,EmailID,[identity],scriptname,isinnumber,exchangeselected,pushnotificationStatus,insertedon from [196.1.115.219].mutualfund.dbo.tbl_WebhookData with(nolock) where
InsertedOn between DATEADD(hh,15,DATEDIFF(dd,0,DATEADD( dd,-@noOfHoliday, @Date))) and DATEADD(hh,15,DATEDIFF(dd,0,@Date))         
order by InsertedOn desc



 DECLARE @BCPCOMMAND VARCHAR(250)              
 DECLARE @FILENAME VARCHAR(250)       
 DECLARE @filename1 VARCHAR(250)		
 DECLARE @MESS VARCHAR(250)  
 
 DECLARE @BCPCOMMAND_Fail VARCHAR(250)              
 DECLARE @FILENAME_Fail VARCHAR(250)       
 DECLARE @filename1_Fail VARCHAR(250)		
 
 DECLARE @BCPCOMMAND_Watch VARCHAR(250)              
 DECLARE @FILENAME_Watch VARCHAR(250)       
 DECLARE @filename1_Watch VARCHAR(250)		
    
 DECLARE @emailto VARCHAR(250),@sub varchar(250)       
     
 declare @s1 as varchar(500),@s2 as varchar(500),@s3 as varchar(500)              
      
 select @filename1='I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
 SET @FILENAME = 'I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND = 'BCP "SELECT * FROM [196.1.115.132].Adv_Chart_Activation.dbo.tblWatchlistsentLog" QUERYOUT "'              
 SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND      
 
 
 
 
 
  select @filename1_Fail='I:\Adv_Chart_email\WatchlistfailLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
 SET @FILENAME_Fail = 'I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND_Fail = 'BCP "SELECT  * FROM [196.1.115.132].Adv_Chart_Activation.dbo.tblWatchlistfailLog" QUERYOUT "'              
 SET @BCPCOMMAND_Fail = @BCPCOMMAND_Fail + @filename1_Fail + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_Fail      
 
 select @filename1_Watch='I:\Adv_Chart_email\WatchlistLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
 SET @FILENAME_Watch = 'I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND_Watch = 'BCP "SELECT  * FROM [196.1.115.132].Adv_Chart_Activation.dbo.tblWatchlistLog" QUERYOUT "'              
 SET @BCPCOMMAND_Watch = @BCPCOMMAND_Watch + @filename1_Watch + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_Watch    
 
       
SET @MESS='Dear Nitesh,<br><Br>Good Morning!!!<br><Br>Please refer the attachments .<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='Push Notification Log details '+ convert(varchar(25),CAST(GETDATE() AS DATE))                  
--print @filename1                  
    
DECLARE @filenames varchar(MAX)                                    
SELECT @filenames = @filename1 +';'+ @filename1_Fail +';'+ @filename1_Watch           
 --1st                    
EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='narendra.prajapati@angelbroking.com',                                
@COPY_RECIPIENTS ='narendra.prajapati@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@filename1,                                
@BODY =@MESS         


 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='narendra.prajapati@angelbroking.com',                                
@COPY_RECIPIENTS ='narendra.prajapati@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@filename1_Fail,                                
@BODY =@MESS    


 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='narendra.prajapati@angelbroking.com',                                
@COPY_RECIPIENTS ='narendra.prajapati@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@filename1_Watch,                                
@BODY =@MESS    
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Sent_Fail_WatchlistScript_Log_20nov2021
-- --------------------------------------------------
-- =============================================
-- Author:		<Narendra Prajapati>
-- Create date: <15 Sep 2018>
-- Description:	<Sent ,fail and watchlist script log>
-- =============================================
-- exec USP_Sent_Fail_WatchlistScript_Log
CREATE PROCEDURE USP_Sent_Fail_WatchlistScript_Log_20nov2021
AS
BEGIN
	-----------Send notification LOg-----------------------
IF EXISTS(Select 1 from [196.1.115.219].mutualfund.dbo.tblLastSentNotification with(nolock) where CAST(InsertedDateON AS DATE)=CAST(GETDATE()-1 AS DATE))
BEGIN

IF  OBJECT_ID('TEMPDB..#temp' ) IS NOT NULL
DROP TABLE #temp

IF  OBJECT_ID('TEMPDB..#t2' ) IS NOT NULL
DROP TABLE #t2
			
IF  OBJECT_ID('TEMPDB..#t1' ) IS NOT NULL
DROP TABLE #t1

truncate table tblWatchlistsentLog
truncate table tblWatchlistFailLog  
truncate table tblWatchlistLog  
	
DECLARE @noOfHoliday int=0
SET @noOfHoliday=(Select NoOfHoliday from [196.1.115.219].mutualfund.dbo.tblLastSentNotification with(nolock) where CAST(InsertedDateON AS DATE)=CAST(GETDATE()-1 AS DATE))
DECLARE @Date varchar(100)=CAST(GETDATE()-1 AS DATE)

Select substring(request,CHARINDEX('Identity', request)+12,((CHARINDEX('objectId', request)-4)-(CHARINDEX('Identity', request)+12)) ) AS ClientID,
replace(substring(request,CHARINDEX('"ISIN', request)+7,((CHARINDEX('SelectedExchange', request)-3)-(CHARINDEX('"ISIN', request)+7)) ),'"','') AS ISIN,
Replace(substring(request,CHARINDEX('SelectedExchange', request)+19,((CHARINDEX('SelectedExchange', request))-2)),'"}','') AS ExchangeSelected
,RequestTime,Response,ResponseTime,request
 into #t2 from [196.1.115.219].mutualfund.dbo.tbl_SendNotificationRequestResponse with(nolock) where cast(RequestTime as date)=@Date

select ClientId,ISINNUMBER,ExchangeSelected,scriptName,max(InsertedOn) as InsertedOn into #temp 
from [196.1.115.219].mutualfund.dbo.tbl_WebhookData with(nolock) 
where ClientId<>'' and isinnumber<>'' 
AND InsertedOn between DATEADD(hh,15,DATEDIFF(dd,0,DATEADD( dd,-@noOfHoliday, @Date))) and DATEADD(hh,15,DATEDIFF(dd,0,@Date))         
group by ClientId,ISINNUMBER,ExchangeSelected,scriptName 

CREATE NONCLUSTERED INDEX #IX_webhook on #temp (ClientId,ISINNUMBER,ExchangeSelected)

insert into tblWatchlistsentLog( clientid,isin,exchangeSelected,Request,Response,RequestTime,WatchListDateOn)    
SELECT  'clientid','isin','exchangeSelected','Request','Response','RequestTime','WatchListDateOn'    
    
insert into tblWatchlistsentLog( clientid,isin,exchangeSelected,Request,Response,RequestTime,WatchListDateOn)  
select A.clientid,isin,A.exchangeSelected,Request,Response,RequestTime,B.InsertedOn AS WatchListDateOn
from #t2 A 
join 
(select * from #temp)B 
on A.ClientId = B.ClientId AND
A.ISIN=B.ISINNUMBER AND
A.ExchangeSelected=B.ExchangeSelected

-----------failed notification LOg-----------------------
select *  into #t1 from [196.1.115.219].mutualfund.dbo.tbl_PushNotificationLog with(nolock) where cast(insertedon as date)=@Date

insert into tblWatchlistFailLog( ClientCode,ScripName,ISIN,ExchangeSelected,Remark,Status,InsertedOn,WatchListDateOn)    
SELECT  'ClientCode','ScripName','ISIN','ExchangeSelected','Remark','Status','InsertedOn','WatchListDateOn'   

insert into tblWatchlistFailLog( ClientCode,ScripName,ISIN,ExchangeSelected,Remark,Status,InsertedOn,WatchListDateOn) 
select ClientCode,ScripName,ISIN,A.ExchangeSelected,Remark,Status,A.InsertedOn,B.InsertedOn AS WatchListDateOn
from #t1 A 
join 
(select * from #temp)B 
on A.ClientCode = B.ClientId AND
A.ISIN=B.ISINNUMBER AND
A.ExchangeSelected=B.ExchangeSelected
and a.scripname=b.scriptName

--***************Check watchlist status *********************3969

insert into tblWatchlistLog( Clientid,EmailID,[identity],scriptname,isinnumber,exchangeselected,pushnotificationStatus,insertedon)    
SELECT  'Clientid','EmailID','identity','scriptname','isinnumber','exchangeselected','pushnotificationStatus','insertedon'  

insert into tblWatchlistLog( Clientid,EmailID,[identity],scriptname,isinnumber,exchangeselected,pushnotificationStatus,insertedon) 
Select Clientid,EmailID,[identity],scriptname,isinnumber,exchangeselected,pushnotificationStatus,insertedon from [196.1.115.219].mutualfund.dbo.tbl_WebhookData with(nolock) where
InsertedOn between DATEADD(hh,15,DATEDIFF(dd,0,DATEADD( dd,-@noOfHoliday, @Date))) and DATEADD(hh,15,DATEDIFF(dd,0,@Date))         
order by InsertedOn desc



 DECLARE @BCPCOMMAND VARCHAR(250)              
 DECLARE @FILENAME VARCHAR(250)       
 DECLARE @filename1 VARCHAR(250)		
 DECLARE @MESS VARCHAR(250)  
 
 DECLARE @BCPCOMMAND_Fail VARCHAR(250)              
 DECLARE @FILENAME_Fail VARCHAR(250)       
 DECLARE @filename1_Fail VARCHAR(250)		
 
 DECLARE @BCPCOMMAND_Watch VARCHAR(250)              
 DECLARE @FILENAME_Watch VARCHAR(250)       
 DECLARE @filename1_Watch VARCHAR(250)		
    
 DECLARE @emailto VARCHAR(250),@sub varchar(250)       
     
 declare @s1 as varchar(500),@s2 as varchar(500),@s3 as varchar(500)              
      
 select @filename1='I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
 SET @FILENAME = 'I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND = 'BCP "SELECT * FROM [196.1.115.132].Adv_Chart_Activation.dbo.tblWatchlistsentLog" QUERYOUT "'              
 SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND      
 
 
 
 
 
  select @filename1_Fail='I:\Adv_Chart_email\WatchlistfailLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
 SET @FILENAME_Fail = 'I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND_Fail = 'BCP "SELECT  * FROM [196.1.115.132].Adv_Chart_Activation.dbo.tblWatchlistfailLog" QUERYOUT "'              
 SET @BCPCOMMAND_Fail = @BCPCOMMAND_Fail + @filename1_Fail + '" -c -t, -Sintranet -Uinhouse -Pinh6014'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_Fail      
 
 select @filename1_Watch='I:\Adv_Chart_email\WatchlistLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
 SET @FILENAME_Watch = 'I:\Adv_Chart_email\WatchlistsentLog'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND_Watch = 'BCP "SELECT  * FROM [196.1.115.132].Adv_Chart_Activation.dbo.tblWatchlistLog" QUERYOUT "'              
 SET @BCPCOMMAND_Watch = @BCPCOMMAND_Watch + @filename1_Watch + '" -c -t, -Sintranet -Uinhouse -Pinh6014'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_Watch    
 
       
SET @MESS='Dear Nitesh,<br><Br>Good Morning!!!<br><Br>Please refer the attachments .<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='Push Notification Log details '+ convert(varchar(25),CAST(GETDATE() AS DATE))                  
--print @filename1                  
    
DECLARE @filenames varchar(MAX)                                    
SELECT @filenames = @filename1 +';'+ @filename1_Fail +';'+ @filename1_Watch           
 --1st                    
EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='narendra.prajapati@angelbroking.com',                                
@COPY_RECIPIENTS ='narendra.prajapati@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@filename1,                                
@BODY =@MESS         


 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='narendra.prajapati@angelbroking.com',                                
@COPY_RECIPIENTS ='narendra.prajapati@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@filename1_Fail,                                
@BODY =@MESS    


 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='narendra.prajapati@angelbroking.com',                                
@COPY_RECIPIENTS ='narendra.prajapati@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@filename1_Watch,                                
@BODY =@MESS    
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_UPS_Report
-- --------------------------------------------------


--declare @Date Varchar(15)='03/09/2016'



CREATE PROCEDURE [dbo].[Usp_UPS_Report]                
AS
BEGIN
DECLARE @EMP_NAME AS VARCHAR(100),@EMP_EMAIL AS VARCHAR(100)                
DECLARE @EMAILTO AS VARCHAR(1000),@EMAILCC AS VARCHAR(1000),@EMAILBCC AS VARCHAR(1000),@SUB AS VARCHAR(MAX),@MESS NVARCHAR(MAX)  



SELECT @EMAILTO='PRASHANT.PATADE@ANGELBROKING.COM'

DECLARE @filename1 as varchar(100)                            
               
--select @filename1='d:\Ups_Report\UPS_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                       
    

declare @Date varchar(19)=convert(varchar(19),getdate()-6,103)
print @Date  
declare @BranchId int=0,@BrTag Varchar(15)='%%'  
                    
DECLARE @Fdate Varchar(15)                          
SET @Fdate = @Date                          
Set @Date = Convert(varchar(11),Convert(datetime,@Date,103),121)    
                                                                                                                              
Begin                                    
 print 'Hello'                               
SET NOCOUNT ON                            
                                   
CREATE TABLE #T(BRCODE INT,BRTAG VARCHAR(15),BRNAME VARCHAR(100))                                                
  INSERT INTO #T                                                
  EXEC MIS.helpdesk.dbo.USP_WAN_SEARCH_BRANCH @BRTAG          
              
   Select a.fld_srno as UpsId,a.ups_id,a.Ups_Name,fld_Model_Srno+' ('+Fld_Battery_Bank+')' UpsCapacity,            
   a.Fld_Branch_id,              
  g.CSONAME as CSOName, A.Remark_ups ,                  
 A.Agv_Daily_Load,              
 Case When A.Total_TestingTime =  '' Then '' Else A.Total_TestingTime END as Total_TestingTime,              
 A.Total_Load_InPer,              
 A.Remark,                                    
 Fld_Model_Capacity,Fld_Model_Name,a.Br_Name,            
 (a.Ups_Name + '-'+ CASE WHEN Fld_Model_Name is null THEN '-' ELSE Fld_Model_Name END + '-' + Fld_Model_Capacity) as UPS_Model,            
 e.Emp_Name
 into #aa                  
  FROM       
  (SELECT k.*,h.ChangedBy as changed_by,h.Agv_Daily_Load,h.Total_TestingTime,h.Total_Load_InPer,h.Remark as Remark_ups   FROM MIS.helpdesk.dbo.V_UPS_MASTER k        
  right outer join MIS.helpdesk.dbo.tbl_ups_data h  on k.Fld_srNo = h.Fld_Ups_id and  Fld_Entry_date = Convert(datetime,@FDATE,103)          
  WHERE FLD_BRANCH_ID IN (SELECT BRCODE FROM #T) AND DeactivatedOn >= Convert(datetime,@FDATE,103)        
  and Fld_Entry_date = Convert(datetime,@FDATE,103)                
  )A                              
  left outer join MIS.helpdesk.dbo.V_CSONAMES g on A.Fld_Branch_id = g.Sr_No                         
  left outer join intranet.risk.dbo.emp_info e  on A.changed_by = e.Emp_no                  
  ORDER BY CSOName 
   
           
End                                        
  truncate table tbl_UPS_Rpt_Temp

  
  insert into tbl_UPS_Rpt_Temp(UpsId,ups_id,Ups_Name,UpsCapacity,Fld_Branch_id,CSOName,Remark_ups,Agv_Daily_Load,Total_TestingTime,Total_Load_InPer,
  Remark,Fld_Model_Capacity,Fld_Model_Name,Br_Name,UPS_Model,Emp_Name)
 select UpsId,ups_id,Ups_Name,UpsCapacity,Fld_Branch_id,CSOName,Remark_ups,Agv_Daily_Load,Total_TestingTime,Total_Load_InPer,
 Remark,Fld_Model_Capacity,Fld_Model_Name,Br_Name,UPS_Model,Emp_Name
 from #aa  

  
  DECLARE @BCPCOMMAND VARCHAR(250)        
  DECLARE @FILENAME VARCHAR(250)--@filename1 varchar(max)
  --declare @s1 as varchar(max)  
  --select @filename1='d:\Ups_Report\UPS_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                       
  SET @FILENAME ='\\INTRANET\I:\Ups_Report\UPS_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'
              --  'd:\Adv_Chart_email\Email_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                               
  SET @BCPCOMMAND = 'BCP "SELECT CSOName,Br_Name,UPS_Model,UpsCapacity,Agv_Daily_Load,Total_TestingTime,Total_Load_InPer,Remark,Emp_Name FROM Adv_Chart_Activation.dbo.tbl_UPS_Rpt_Temp " QUERYOUT "'        
  SET @BCPCOMMAND = @BCPCOMMAND + @FILENAME + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'        
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND 
     print @FILENAME
  
  SET @MESS='DEAR ALL,<BR><BR>GOOD MORNING!!!<BR><BR>GREETINGS OF THE DAY!<BR>'
		SET @MESS=@MESS+'<BR><BR>THIS IS A SYSTEM GENERATED MESSAGE. PLEASE DO NOT REPLY.<BR><BR>REGARDS,<BR><BR>(IT HELPDESK)'                              
		SET @SUB ='UPS Report AS ON ' + CONVERT(VARCHAR(MAX),GETDATE())
		           
 DECLARE @s varchar(500)                
 SET @s = @FILENAME  

 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS =@EMAILTO,                              
 @COPY_RECIPIENTS = @EMAILCC,                              
 @BLIND_COPY_RECIPIENTS=@EMAILBCC,                    
 @PROFILE_NAME = 'ANGELBROKING',                              
 @BODY_FORMAT ='HTML',                              
 @SUBJECT = @SUB , 
 @FILE_ATTACHMENTS =@s,                             
 @BODY =@MESS 
  
  drop table #aa
   drop table #t  
  
-- drop table #T   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_WatchListMail
-- --------------------------------------------------
--EXEC USP_WatchListMail 

  
  
-- =============================================      
-- Author:  <Narendra Prajapati>      
-- Create date: <6th Jul 2018>      
-- Description: <Send watchlist data on daily basis through Email>      
-- EXEC USP_WatchListMail      
--abcsouatinhouse[219]  
--exec USP_WatchListMail  
-- =============================================      
CREATE PROCEDURE [dbo].[USP_WatchListMail]    
AS    
BEGIN    
truncate table watchlist  

Select * into #t from [196.1.115.219].Mutualfund.dbo.tbl_webhookdata where CAST(InsertedOn As Date)= CAST(getdate()-1 AS Date)    
    
Select ID,EMAILID,ClientId,ScriptName,case when ExchangeSelected='BSE' AND nMarketSegmentId='3' then b.ntoken else '' end AS scriptcode,    
ISINNumber,ExchangeSelected,insertedon into #final from #t a with (nolock)     
inner JOIN [172.31.16.75].[AE_MOBILE].dbo.vw_scrip_master  b with (nolock)    
ON a.isinnumber=b.sisinCode    
    
  
insert into watchlist( EMAILID,ClientId,ScriptName,scriptcode,ISINNumber,ExchangeSelected,insertedon)    
SELECT  'EMAILID','ClientId','ScriptName','scriptcode','ISINNumber','ExchangeSelected','insertedon'    
    
insert into watchlist( EMAILID,ClientId,ScriptName,scriptcode,ISINNumber,ExchangeSelected,insertedon)    
SELECT EMAILID,ClientId,ScriptName,scriptcode,ISINNumber,ExchangeSelected,insertedon FROM #final      
          
 DECLARE @BCPCOMMAND VARCHAR(250)              
 DECLARE @FILENAME VARCHAR(250)       
 DECLARE @filename1 VARCHAR(250)       
 DECLARE @MESS VARCHAR(250)       
 DECLARE @emailto VARCHAR(250),@sub varchar(250)       
     
 declare @s1 as varchar(max)              
      
select @filename1='I:\Adv_Chart_email\BulkUploadEmail_Watchlist_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
          
 --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'              
 SET @FILENAME = 'I:\Adv_Chart_email\BulkUploadEmail_Watchlist_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND = 'BCP "SELECT  * FROM [196.1.115.132].Adv_Chart_Activation.dbo.watchlist" QUERYOUT "'              
 SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND      
       
 SET @MESS='Dear Nitesh,<br><Br>Good Morning!!!<br><Br>Please refer the attached watchlist data .<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='Watch list Client Details '                   
--print @filename1                  
                     
DECLARE @s varchar(500)                    
SET @s = @filename1               
                     
EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='harjai.narendraprajapati@angelbroking.com;prashant.patade@angelbroking.com;nitesh.sawant@angelbroking.com',                                
@COPY_RECIPIENTS ='harjai.narendraprajapati@angelbroking.com;prashant.patade@angelbroking.com;nitesh.sawant@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@s,                                
@BODY =@MESS         
    
drop table #t    
drop table #final    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_WatchListMail_07082018
-- --------------------------------------------------
--EXEC USP_WatchListMail 

  
  
-- =============================================      
-- Author:  <Narendra Prajapati>      
-- Create date: <6th Jul 2018>      
-- Description: <Send watchlist data on daily basis through Email>      
-- EXEC USP_WatchListMail      
--abcsouatinhouse[219]  
--exec USP_WatchListMail  
-- =============================================      
Create PROCEDURE [dbo].[USP_WatchListMail_07082018]    
AS    
BEGIN    
truncate table watchlist  

Select * into #t from [196.1.115.219].Mutualfund.dbo.tbl_webhookdata where CAST(InsertedOn As Date)= CAST(getdate()-1 AS Date)    
    
Select ID,EMAILID,ClientId,ScriptName,case when ExchangeSelected='BSE' AND nMarketSegmentId='3' then b.ntoken else '' end AS scriptcode,    
ISINNumber,ExchangeSelected,insertedon into #final from #t a with (nolock)     
inner JOIN [172.31.16.75].[AE_MOBILE].dbo.vw_scrip_master  b with (nolock)    
ON a.isinnumber=b.sisinCode    
    
  
insert into watchlist( EMAILID,ClientId,ScriptName,scriptcode,ISINNumber,ExchangeSelected,insertedon)    
SELECT  'EMAILID','ClientId','ScriptName','scriptcode','ISINNumber','ExchangeSelected','insertedon'    
    
insert into watchlist( EMAILID,ClientId,ScriptName,scriptcode,ISINNumber,ExchangeSelected,insertedon)    
SELECT EMAILID,ClientId,ScriptName,scriptcode,ISINNumber,ExchangeSelected,insertedon FROM #final      
          
 DECLARE @BCPCOMMAND VARCHAR(250)              
 DECLARE @FILENAME VARCHAR(250)       
 DECLARE @filename1 VARCHAR(250)       
 DECLARE @MESS VARCHAR(250)       
 DECLARE @emailto VARCHAR(250),@sub varchar(250)       
     
 declare @s1 as varchar(max)              
      
select @filename1='I:\Adv_Chart_email\BulkUploadEmail_NOC_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'    
          
 --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'              
 SET @FILENAME = 'I:\Adv_Chart_email\BulkUploadEmail_NOC_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
 SET @BCPCOMMAND = 'BCP "SELECT * FROM [196.1.115.132].Adv_Chart_Activation.dbo.watchlist" QUERYOUT "'              
 SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'              
 EXEC MASTER..XP_CMDSHELL @BCPCOMMAND      
       
 SET @MESS='Dear Nitesh,<br><Br>Good Evening!!!<br><Br>Please refer the attached watchlist data .<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='Watch list Client Details '                   
--print @filename1                  
                     
DECLARE @s varchar(500)                    
SET @s = @filename1               
                     
EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
@RECIPIENTS ='harjai.narendraprajapati@angelbroking.com;prashant.patade@angelbroking.com;nitesh.sawant@angelbroking.com',                                
@COPY_RECIPIENTS ='harjai.narendraprajapati@angelbroking.com;prashant.patade@angelbroking.com;nitesh.sawant@angelbroking.com',                           
@PROFILE_NAME = 'AngelBroking',                                
@BODY_FORMAT ='HTML',                                
@SUBJECT = @sub ,                                
@FILE_ATTACHMENTS =@s,                                
@BODY =@MESS         
    
drop table #t    
drop table #final    
END

GO

-- --------------------------------------------------
-- TABLE dbo.AdminMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[AdminMaster]
(
    [Id] INT NOT NULL,
    [UserName] NCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AdvChart_Activate
-- --------------------------------------------------
CREATE TABLE [dbo].[AdvChart_Activate]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [ECode] NVARCHAR(50) NULL,
    [ClientCode] NVARCHAR(50) NULL,
    [ClientName] VARCHAR(50) NULL,
    [OnlineRevenue] NVARCHAR(50) NULL,
    [OfflineRevenue] NVARCHAR(50) NULL,
    [TotalRevenue] NVARCHAR(50) NULL,
    [ActivationDate] DATETIME NULL,
    [Approval_Reject] NVARCHAR(50) NULL,
    [UserName] NVARCHAR(50) NULL,
    [accessto] NVARCHAR(50) NULL,
    [accesscode] NVARCHAR(50) NULL,
    [DateOfRequest] DATETIME NULL,
    [Remarks] NVARCHAR(500) NULL,
    [StatusAddedBy] VARCHAR(50) NULL,
    [StatusAddedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AdvChart_Deactivate
-- --------------------------------------------------
CREATE TABLE [dbo].[AdvChart_Deactivate]
(
    [srno] INT NULL,
    [ClientCode] NVARCHAR(50) NULL,
    [OnlineRevenue] NVARCHAR(50) NULL,
    [OfflineRevenue] NVARCHAR(50) NULL,
    [TotalRevenue] NVARCHAR(50) NULL,
    [ActivationDate] DATE NULL,
    [Approval_Reject] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AdvChart_Report
-- --------------------------------------------------
CREATE TABLE [dbo].[AdvChart_Report]
(
    [srno] NVARCHAR(50) NULL,
    [ECode] NVARCHAR(50) NULL,
    [EmployeeName] NVARCHAR(50) NULL,
    [Requester] NVARCHAR(50) NULL,
    [Designation] NVARCHAR(50) NULL,
    [DateOfRequest] DATE NULL,
    [TagToBeActivates] NVARCHAR(100) NULL,
    [StatusOfRequest] NVARCHAR(500) NULL,
    [Remarks] NVARCHAR(500) NULL,
    [UpdateBy] NVARCHAR(50) NULL,
    [Date_Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BulkUploadAdvChart
-- --------------------------------------------------
CREATE TABLE [dbo].[BulkUploadAdvChart]
(
    [ClientCode] VARCHAR(10) NULL,
    [Date] VARCHAR(19) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ChartApproval
-- --------------------------------------------------
CREATE TABLE [dbo].[ChartApproval]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [ECode] NVARCHAR(50) NULL,
    [EmployeeName] NVARCHAR(50) NULL,
    [ClientCode] NVARCHAR(50) NULL,
    [OnlineRevenue] NVARCHAR(50) NULL,
    [OfflineRevenue] NVARCHAR(50) NULL,
    [TotalRevenue] NVARCHAR(50) NULL,
    [ActivationDate] DATE NULL,
    [isApproval] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ADVCHART_ACTIVATE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ADVCHART_ACTIVATE]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [ECode] NVARCHAR(50) NULL,
    [ClientCode] NVARCHAR(50) NULL,
    [ClientName] VARCHAR(50) NULL,
    [OnlineRevenue] NVARCHAR(50) NULL,
    [OfflineRevenue] NVARCHAR(50) NULL,
    [TotalRevenue] NVARCHAR(50) NULL,
    [ActivationDate] DATETIME NULL,
    [UserName] NVARCHAR(50) NULL,
    [accessto] NVARCHAR(50) NULL,
    [accesscode] NVARCHAR(50) NULL,
    [Remarks] NVARCHAR(500) NULL,
    [RequestDate] DATETIME NULL,
    [ActivationApprovalDate] DATETIME NULL,
    [DactivationApprovalDate] DATETIME NULL,
    [DRequestDate] DATETIME NULL,
    [IsApproved] INT NULL,
    [ActivationApprovalBy] VARCHAR(50) NULL,
    [DactivationApprovalBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ADVCHART_ACTIVATE_19122018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ADVCHART_ACTIVATE_19122018]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [ECode] NVARCHAR(50) NULL,
    [ClientCode] NVARCHAR(50) NULL,
    [ClientName] VARCHAR(50) NULL,
    [OnlineRevenue] NVARCHAR(50) NULL,
    [OfflineRevenue] NVARCHAR(50) NULL,
    [TotalRevenue] NVARCHAR(50) NULL,
    [ActivationDate] DATETIME NULL,
    [UserName] NVARCHAR(50) NULL,
    [accessto] NVARCHAR(50) NULL,
    [accesscode] NVARCHAR(50) NULL,
    [Remarks] NVARCHAR(500) NULL,
    [RequestDate] DATETIME NULL,
    [ActivationApprovalDate] DATETIME NULL,
    [DactivationApprovalDate] DATETIME NULL,
    [DRequestDate] DATETIME NULL,
    [IsApproved] INT NULL,
    [ActivationApprovalBy] VARCHAR(50) NULL,
    [DactivationApprovalBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ADVCHART_ACTIVATE_HEADING
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ADVCHART_ACTIVATE_HEADING]
(
    [Client Id] VARCHAR(50) NULL,
    [Template Id] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSETradeFile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSETradeFile]
(
    [TradeNo] VARCHAR(20) NULL,
    [Trade_Status] VARCHAR(10) NULL,
    [Sysbol] VARCHAR(10) NULL,
    [Security_Name] VARCHAR(25) NULL,
    [Instrument_Type] VARCHAR(10) NULL,
    [Book_Type] VARCHAR(10) NULL,
    [Market_Type] VARCHAR(10) NULL,
    [UserId] VARCHAR(10) NULL,
    [Branch_Id] VARCHAR(10) NULL,
    [Buy_Sell_Indicator] VARCHAR(10) NULL,
    [Trade_Qty] VARCHAR(10) NULL,
    [Trade_Price] MONEY NULL,
    [PRO_CLI] VARCHAR(10) NULL,
    [Client_AC] VARCHAR(10) NULL,
    [Participant_Code] VARCHAR(20) NULL,
    [Auction_Part_Type] VARCHAR(10) NULL,
    [Auction_No] VARCHAR(10) NULL,
    [Sett_Period] VARCHAR(10) NULL,
    [Trade_EntryDateTime] DATETIME NULL,
    [Trade_ModifiedDatetime] DATETIME NULL,
    [Order_Number] VARCHAR(20) NULL,
    [CP_ID] VARCHAR(10) NULL,
    [Order_Entered_Mod_DtTime] DATETIME NULL,
    [UpdateDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSETradeFile_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSETradeFile_Hist]
(
    [TradeNo] VARCHAR(20) NULL,
    [Trade_Status] VARCHAR(10) NULL,
    [Sysbol] VARCHAR(10) NULL,
    [Security_Name] VARCHAR(25) NULL,
    [Instrument_Type] VARCHAR(10) NULL,
    [Book_Type] VARCHAR(10) NULL,
    [Market_Type] VARCHAR(10) NULL,
    [UserId] VARCHAR(10) NULL,
    [Branch_Id] VARCHAR(10) NULL,
    [Buy_Sell_Indicator] VARCHAR(10) NULL,
    [Trade_Qty] VARCHAR(10) NULL,
    [Trade_Price] MONEY NULL,
    [PRO_CLI] VARCHAR(10) NULL,
    [Client_AC] VARCHAR(10) NULL,
    [Participant_Code] VARCHAR(20) NULL,
    [Auction_Part_Type] VARCHAR(10) NULL,
    [Auction_No] VARCHAR(10) NULL,
    [Sett_Period] VARCHAR(10) NULL,
    [Trade_EntryDateTime] DATETIME NULL,
    [Trade_ModifiedDatetime] DATETIME NULL,
    [Order_Number] VARCHAR(20) NULL,
    [CP_ID] VARCHAR(10) NULL,
    [Order_Entered_Mod_DtTime] DATETIME NULL,
    [UpdateDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ChartActivation_EmailClient
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ChartActivation_EmailClient]
(
    [PartyCode] VARCHAR(50) NULL,
    [Email] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ChartActivationMaxDate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ChartActivationMaxDate]
(
    [MaxDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FileUpload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FileUpload]
(
    [ClientCode] VARCHAR(50) NULL,
    [FileName] VARCHAR(50) NULL,
    [File_Size] VARCHAR(50) NULL,
    [Executable_path] VARCHAR(500) NULL,
    [Physical_path] VARCHAR(500) NULL,
    [Virtual_path] VARCHAR(500) NULL,
    [ID] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FileUpload_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FileUpload_log]
(
    [ClientCode] VARCHAR(50) NULL,
    [FileName] VARCHAR(50) NULL,
    [File_Size] VARCHAR(50) NULL,
    [Executable_path] VARCHAR(500) NULL,
    [Physical_path] VARCHAR(500) NULL,
    [Virtual_path] VARCHAR(500) NULL,
    [ID] INT IDENTITY(1,1) NOT NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntradayCode_EmailClient
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntradayCode_EmailClient]
(
    [PartyCode] VARCHAR(50) NULL,
    [Email] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntradayCodeMaxDate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntradayCodeMaxDate]
(
    [maxdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_UPS_Rpt_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_UPS_Rpt_Temp]
(
    [UpsId] INT NULL,
    [ups_id] INT NULL,
    [Ups_Name] VARCHAR(102) NULL,
    [UpsCapacity] VARCHAR(103) NULL,
    [Fld_Branch_id] INT NULL,
    [CSOName] VARCHAR(50) NULL,
    [Remark_ups] VARCHAR(150) NULL,
    [Agv_Daily_Load] VARCHAR(50) NULL,
    [Total_TestingTime] INT NULL,
    [Total_Load_InPer] VARCHAR(50) NULL,
    [Remark] VARCHAR(4000) NULL,
    [Fld_Model_Capacity] VARCHAR(50) NULL,
    [Fld_Model_Name] VARCHAR(50) NULL,
    [Br_Name] VARCHAR(100) NULL,
    [UPS_Model] VARCHAR(204) NULL,
    [Emp_Name] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblWatchlistFailLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tblWatchlistFailLog]
(
    [ClientCode] VARCHAR(100) NULL,
    [ScripName] VARCHAR(200) NULL,
    [ISIN] VARCHAR(500) NULL,
    [ExchangeSelected] VARCHAR(100) NULL,
    [Remark] VARCHAR(MAX) NULL,
    [Status] VARCHAR(100) NULL,
    [InsertedOn] VARCHAR(20) NULL,
    [WatchListDateOn] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblWatchlistLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tblWatchlistLog]
(
    [Clientid] VARCHAR(200) NULL,
    [EmailID] VARCHAR(200) NULL,
    [identity] VARCHAR(500) NULL,
    [scriptname] VARCHAR(500) NULL,
    [isinnumber] VARCHAR(500) NULL,
    [exchangeselected] VARCHAR(200) NULL,
    [insertedon] VARCHAR(20) NULL,
    [pushnotificationStatus] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblWatchlistsentLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tblWatchlistsentLog]
(
    [clientid] VARCHAR(MAX) NULL,
    [isin] VARCHAR(MAX) NULL,
    [exchangeSelected] VARCHAR(MAX) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [RequestTime] VARCHAR(20) NULL,
    [WatchListDateOn] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp2
-- --------------------------------------------------
CREATE TABLE [dbo].[temp2]
(
    [id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uploadAdvChart
-- --------------------------------------------------
CREATE TABLE [dbo].[uploadAdvChart]
(
    [ClientCode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.watchlist
-- --------------------------------------------------
CREATE TABLE [dbo].[watchlist]
(
    [EMAILID] VARCHAR(200) NULL,
    [ClientId] VARCHAR(200) NULL,
    [ScriptName] VARCHAR(500) NULL,
    [scriptcode] VARCHAR(50) NOT NULL,
    [ISINNumber] VARCHAR(500) NULL,
    [ExchangeSelected] VARCHAR(200) NULL,
    [insertedon] VARCHAR(20) NULL
);

GO

