-- DDL Export
-- Server: 10.253.33.89
-- Database: FEF_JDemail
-- Exported: 2026-02-05T02:38:45.201086

USE FEF_JDemail;
GO

-- --------------------------------------------------
-- FUNCTION dbo.Split
-- --------------------------------------------------
create FUNCTION [dbo].[Split](@String varchar(MAX), @Delimiter char(1))       
returns @temptable TABLE (items varchar(MAX))       
as       
begin      
    declare @idx int       
    declare @slice varchar(8000)       

    select @idx = 1       
        if len(@String)<1 or @String is null  return       

    while @idx!= 0       
    begin       
        set @idx = charindex(@Delimiter,@String)       
        if @idx!=0       
            set @slice = left(@String,@idx - 1)       
        else       
            set @slice = @String       

        if(len(@slice)>0)  
            insert into @temptable(Items) values(@slice)       

        set @String = right(@String,len(@String) - @idx)       
        if len(@String) = 0 break       
    end   
return 
end;

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Calendar
-- --------------------------------------------------
ALTER TABLE [dbo].[Calendar] ADD CONSTRAINT [PK_Calendar] PRIMARY KEY ([gc_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CONTACTS
-- --------------------------------------------------
ALTER TABLE [dbo].[CONTACTS] ADD CONSTRAINT [PK_CONTACTS] PRIMARY KEY ([OCS_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Journal
-- --------------------------------------------------
ALTER TABLE [dbo].[Journal] ADD CONSTRAINT [PK_Journal] PRIMARY KEY ([gc_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Notes
-- --------------------------------------------------
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [PK_Notes] PRIMARY KEY ([gc_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tasks
-- --------------------------------------------------
ALTER TABLE [dbo].[Tasks] ADD CONSTRAINT [PK_SampleTasks] PRIMARY KEY ([gc_guid])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_Item
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_Item] ADD CONSTRAINT [PK_VIS_Item] PRIMARY KEY ([ItemId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_ItemSale
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_ItemSale] ADD CONSTRAINT [PK_VIS_ItemSale] PRIMARY KEY ([OrderNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_Reedumption
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_Reedumption] ADD CONSTRAINT [PK_VIS_Reedumption] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_Servicing
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_Servicing] ADD CONSTRAINT [PK_VIS_Servicing] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_StockEntry
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_StockEntry] ADD CONSTRAINT [PK_VIS_StockEntry] PRIMARY KEY ([StockId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_StockReminderMast
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_StockReminderMast] ADD CONSTRAINT [PK_VIS_StockReminderMast] PRIMARY KEY ([ReId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_SubItemMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_SubItemMaster] ADD CONSTRAINT [PK_VIS_SubItemMaster] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_SubVoucherMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_SubVoucherMaster] ADD CONSTRAINT [PK_VIS_SubVoucherMaster] PRIMARY KEY ([SubVouchId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_VouchCategory
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_VouchCategory] ADD CONSTRAINT [PK_VIS_Category] PRIMARY KEY ([V_CatId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_Voucher
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_Voucher] ADD CONSTRAINT [PK_VIS_Voucher] PRIMARY KEY ([VID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_VoucherMember
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_VoucherMember] ADD CONSTRAINT [PK_VIS_VoucherMember] PRIMARY KEY ([Vouch_No])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VIS_VouReasonMast
-- --------------------------------------------------
ALTER TABLE [dbo].[VIS_VouReasonMast] ADD CONSTRAINT [PK_VIS_VouReasonMast] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fef_getVoucherItems_details
-- --------------------------------------------------
create proc fef_getVoucherItems_details(@member as varchar(20))
as
begin
select MemberName,VoucherName,ItemName,MaxQty  as Quantity,Consumed,Pending,receiptNo,Startdate,EnddateVouch
 from VIS_Reedumption  where  memberNo=@member 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_JDemailContent
-- --------------------------------------------------
Create proc FEF_JDemailContent(@mphone as varchar(10))
as
select gc_htmlbody from mail with (nolock)
where gc_guid in (select guid from FEF_JDemail where phone=@mphone)
order by gc_senton

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LeadJD_entry
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LeadJD_entry]
(
@leadid as varchar(50),
@leadtype as varchar(50),
@prefix as varchar(50),
@name as varchar(50),
@mobile as varchar(50),
@phone as varchar(50),
@email as varchar(50),
@date as varchar(50),
@category as varchar(50),
@city as varchar(50),
@Area as varchar(50),
@brancharea as varchar(50),
@dncmobile as int,
@dncphone as int,
@company as varchar(50),
@pincode as varchar(50),
@time as varchar(50),
@branchpin as varchar(50),
@parentid as varchar(50),
@FollowUpFromDate as datetime
  )  
    
as    
    
    
insert into FEF_JDLead    
select @leadid,@leadtype,@prefix,@name,@mobile,@phone,@email,@date,@category,@city,@Area,@brancharea,@dncmobile,@dncphone,@company,@pincode,
@time,@branchpin,@parentid,@FollowUpFromDate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Appointment
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_Appointment]  
(@tblAppointment FEF_AppointmentType READONLY)  
  
as  
  
truncate table TestAppointment  
insert into [dbo].TestAppointment  
select * from @tblAppointment  
  
insert into LMS_Appointment_log  
 select getdate(),count(1) as NOR from TestAppointment with (nolock)   
  
/*insert into FEF_AppointmentRpt*/  
/*truncate table FEF_AppointmentRpt_15oct15*/
truncate table FEF_AppointmentRpt  
  
  
insert into FEF_AppointmentRpt(EnquiryNo,EnquiryName,MobileNo,ReminderDate,Remark,Appointment,Counseller,ReminderTime,LastUpdatedon,flag)   
SELECT a.EnquiryNo,a.EnquiryName,a.MobileNo,           
 convert(datetime,substring(a.ReminderDate,6,2)+'/'+substring(a.ReminderDate,9,2)+'/'+substring(a.ReminderDate,1,4)),a.Remark,a.Appointment,  
 a.Counseller,            
 convert(datetime,substring(a.ReminderTime,6,2)+'/'+substring(a.ReminderTime,9,2)+'/'+substring(a.ReminderTime,1,4)),            
 getdate() as LastUpdatedon,1 as flag   
 FROM TestAppointment a            
  
/*SELECT a.EnquiryNo,a.EnquiryName,a.MobileNo,           
 convert(datetime,substring(a.ReminderDate,6,2)+'/'+substring(a.ReminderDate,9,2)+'/'+substring(a.ReminderDate,1,4)),a.Remark,a.Appointment,  
 a.Counseller,            
 convert(datetime,substring(a.ReminderTime,6,2)+'/'+substring(a.ReminderTime,9,2)+'/'+substring(a.ReminderTime,1,4)),            
 getdate() as LastUpdatedon,1 as flag   
 FROM TestAppointment a   
/*WHERE not exists (SELECT 1 FROM FEF_AppointmentRpt b WHERE a.EnquiryNo=b.EnquiryNo and a.EnquiryName=b.EnquiryName */  
WHERE not exists (SELECT 1 FROM FEF_AppointmentRpt_15oct15 b WHERE a.EnquiryNo=b.EnquiryNo and a.EnquiryName=b.EnquiryName   
and b.ReminderDate=convert(datetime,substring(a.ReminderDate,6,2)+'/'+substring(a.ReminderDate,9,2)+'/'+substring(a.ReminderDate,1,4))  
and b.ReminderTime=convert(datetime,substring(a.ReminderTime,6,2)+'/'+substring(a.ReminderTime,9,2)+'/'+substring(a.ReminderTime,1,4)) )           
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Appointment_Entry
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_Appointment_Entry]  
  
  
as  
  
  
insert into LMS_Appointment_log  
select getdate(),count(1) as NOR from TestAppointment with (nolock)   
  
/*insert into FEF_AppointmentRpt*/  
truncate table FEF_AppointmentRpt_15oct15
  
insert into FEF_AppointmentRpt_15oct15(EnquiryNo,EnquiryName,MobileNo,ReminderDate,Remark,Appointment,Counseller,ReminderTime,LastUpdatedon,flag)   
select EnquiryNo,EnquiryName,MobileNo,ReminderDate,Remark,Appointment,Counseller,ReminderTime,getdate() as LastUpdatedon,1 as flag 
 from TestAppointment

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Conversion
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_Conversion]
(@tblConversion FEF_ConversionType READONLY)

as

truncate table testconversion
insert into [dbo].testconversion
select * from @tblConversion

insert into LMS_Conversion_log
 select getdate(),count(1) as NOR from testconversion with (nolock) 

/*insert into FEF_AppointmentRpt*/
truncate table FEF_ConversionRpt

insert into FEF_ConversionRpt(EmpName,TotalEnquiry,CurrConv,PrevConv,PlanSaleUnits,TotalAmount,PaidAmount,LastUpdatedon,flag)   
select EmpName,TotalEnquiry,CurrConv,PrevConv,PlanSaleUnits,TotalAmount,PaidAmount,getdate() as LastUpdatedon,1 as flag 
 from testconversion

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Conversion_Entry
-- --------------------------------------------------
create Proc [dbo].[FEF_LMS_Conversion_Entry]  

as  
insert into LMS_Conversion_log  
select getdate(),count(1) as NOR from testconversion with (nolock)   
  
/*insert into FEF_AppointmentRpt*/  
truncate table FEF_ConversionRpt
  
insert into FEF_ConversionRpt(EmpName,TotalEnquiry,CurrConv,PrevConv,PlanSaleUnits,TotalAmount,PaidAmount,LastUpdatedon,flag)   
select EmpName,TotalEnquiry,CurrConv,PrevConv,PlanSaleUnits,TotalAmount,PaidAmount,getdate() as LastUpdatedon,1 as flag 
 from testconversion

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Enqiry
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_Enqiry]      
(@tblEnquiry FEF_EnquiryType READONLY)      
      
as      
      
truncate table TestEntryList      
insert into [dbo].TestEntryList      
select * from @tblEnquiry      
      
insert into LMS_Enquiry_log      
 select getdate(),count(1) as NOR from TestEntryList with (nolock)       
      
/*insert into FEF_EnquiryList*/      
/*truncate table FEF_EnquiryList_20Oct2015*/    
truncate table FEF_EnquiryList     
     
insert into FEF_EnquiryList(EnquiryNo,EnquiryName,EnquiryDt,Source,EmpNo,EmpCode,EmpName,MobileNo,Location,MemberNo,Remark,Gender,LastUpdatedon,flag)         
select EnquiryNo,EnquiryName,      
/*convert(datetime,substring(EnquiryDt,6,2)+'/'+substring(EnquiryDt,9,2)+'/'+substring(EnquiryDt,1,4))      */
replace(substring(EnquiryDt,1,19),'T',' ')
,Source,EmpNo,EmpCode,EmpName,MobileNo,Location,MemberNo,Remark,Gender,getdate() as LastUpdatedon,1 as flag  
 from TestEntryList

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Enqiry_09Jun2017
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_Enqiry_09Jun2017]        
(@tblEnquiry FEF_EnquiryType READONLY)        
        
as        
        
truncate table TestEntryList        
insert into [dbo].TestEntryList        
select * from @tblEnquiry        
        
insert into LMS_Enquiry_log        
 select getdate(),count(1) as NOR from TestEntryList with (nolock)         
        
/*insert into FEF_EnquiryList*/        
/*truncate table FEF_EnquiryList_20Oct2015*/      
truncate table FEF_EnquiryList       
       
insert into FEF_EnquiryList(EnquiryNo,EnquiryName,EnquiryDt,Source,EmpNo,EmpCode,EmpName,MobileNo,Location,MemberNo,Remark,Gender,LastUpdatedon,flag)           
select EnquiryNo,EnquiryName,        
/*convert(datetime,substring(EnquiryDt,6,2)+'/'+substring(EnquiryDt,9,2)+'/'+substring(EnquiryDt,1,4))      */  
replace(substring(EnquiryDt,1,19),'T',' ')  
,Source,EmpNo,EmpCode,EmpName,MobileNo,Location,MemberNo,Remark,Gender,getdate() as LastUpdatedon,1 as flag    
 from TestEntryList

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_Enquiry_Entry
-- --------------------------------------------------
create Proc [dbo].[FEF_LMS_Enquiry_Entry]  

as  
insert into LMS_Enquiry_log  
select getdate(),count(1) as NOR from testconversion with (nolock)   
  
/*insert into FEF_AppointmentRpt*/  
truncate table FEF_EnquiryList_20Oct2015
  
insert into FEF_EnquiryList_20Oct2015(EnquiryNo,EnquiryName,EnquiryDt,Source,EmpNo,EmpCode,EmpName,MobileNo,Location,MemberNo,Remark,Gender,LastUpdatedon,flag)   
select EnquiryNo,EnquiryName,
convert(datetime,substring(EnquiryDt,6,2)+'/'+substring(EnquiryDt,9,2)+'/'+substring(EnquiryDt,1,4))
,Source,EmpNo,EmpCode,EmpName,MobileNo,Location,MemberNo,Remark,Gender,getdate() as LastUpdatedon,1 as flag 
 from TestEntryList

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_GapEmail
-- --------------------------------------------------
        
CREATE procedure [dbo].[FEF_LMS_GapEmail]        
AS        
SET nocount ON          
        
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)                    
DECLARE @emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                              
                           
SELECT @emailto='fauzeeya.shaikh@48fitness.in;yogini.chavan@48fitness.in'   --rajdeep.chakroborty@angelbroking.com              
SELECT @emailcc=''--'radisson@48fitness.in'                    
SELECT @emailbcc='nikhil.walanj@angelbroking.com'  

--SELECT @emailto='nikhil.walanj@angelbroking.com;prashant.patade@angelbroking.com'   --rajdeep.chakroborty@angelbroking.com              
--SELECT @emailcc='nikhil.walanj@angelbroking.com'--'radisson@48fitness.in'                    
--SELECT @emailbcc='nikhil.walanj@angelbroking.com'       
                          
        
--Declare @fromdate as varchar(11),@todate as varchar(11)            
--set @fromdate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))            
--set @fromdate = left(@fromdate,4)+'21'+right(@fromdate,5)            
--print @fromdate         
        
--set @todate = DATEADD(ss, 0, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))            
--set @todate = left(@todate,4)+'20'+right(@todate,5)            
--If CONVERT(datetime,@fromdate) > convert(datetime,@todate)        
--set @todate = CONVERT(varchar(11),getdate())         
--print @todate        

Declare @fromdate as varchar(11),@todate as varchar(11)            
set @fromdate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate())-1, 0))            
set @fromdate = left(@fromdate,4)+'21'+right(@fromdate,5)            
--print @fromdate         
        
set @todate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))            
set @todate = left(@todate,4)+'20'+right(@todate,5)            
If CONVERT(datetime,@fromdate) > convert(datetime,@todate)        
set @todate = CONVERT(varchar(11),getdate())         
--print @todate          
declare @totalLeadJD as int='',@totalLeadWeb as int='',@NotCalledJD as int ='',@NotCalledWeb as int ='',@CalledJD as int ='',@CalledWeb as int =''        
        
select @NotCalledWeb=count(Enquiry_No) from FEF_LeadCall where Enquiry_No='Not Called' and  source='web' and             
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'              
        
select @CalledWeb=count(Enquiry_No) from FEF_LeadCall where Enquiry_No<>'Not Called' and  source='Web' and             
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'              
        
select @totalLeadWeb=count(Enquiry_No) from FEF_LeadCall where source='Web' and             
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'              
        
select @NotCalledJD=count(Enquiry_No) from FEF_LeadCall where Enquiry_No='Not Called' and  source='JD' and             
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'              
        
select @CalledJD=count(Enquiry_No) from FEF_LeadCall where Enquiry_No<>'Not Called' and  source='JD' and             
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'              
        
select @totalLeadJD=count(Enquiry_No) from FEF_LeadCall where source='JD' and             
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'              
truncate table FEF_LeadGap        
insert into FEF_LeadGap        
select 'Web' as Source,@totalLeadWeb as TotalLead,@NotCalledWeb as NotCalled,@CalledWeb as Called        
        
insert into FEF_LeadGap        
select 'JD' as Source,@totalLeadJD as TotalLead,@NotCalledJD  as NotCalled,@CalledJD as Called        
  --8898889454
 /*Sending SMS */             
 /* select '8898889454' as mobno, sum(TotalLead) as TotalLead,sum(NotCalled) as NotCalled,sum(Called) as Called into #MobNo1 from FEF_LeadGap  
  
   insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                     
   select a.mobno,'Dear Sales Consultant,Your total lead target was '+ltrim(rtrim(CONVERT(VARCHAR(10),a.TotalLead)))+'.Out of '+ltrim(rtrim(CONVERT(VARCHAR(10),a.TotalLead)))+' you have successfully attended '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Called)))+'
 leads and rest '+ltrim(rtrim(CONVERT(VARCHAR(10),a.NotCalled)))+' are your Unattended leads.',  
   convert(varchar(10), getdate(), 103),              
   ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +              
   ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),              
   'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12              
   then 'PM' else 'AM' end,'WellnessPromo'              
   from  #MobNo1 a  
 /*Sending SMS */               
  */        
BEGIN try           
  declare @Count int,@CountEnd int,@Source as varchar(20)='',@TotalLead as int,@notCalled as int, @called as int              
  DECLARE @MessBody NVARCHAR(MAX) ,@MESS NVARCHAR(MAX) ,@MessBody1 as varchar(4000)=''         
  DECLARE @xml NVARCHAR(MAX)            
   DECLARE @Data NVARCHAR(MAX) ,  @totctrOT as int=0        
         
    set @Data=''              
    set @MessBody=''                        
    set @MESS=''        
    set @Count=1                                  
            
            
    select  row_number()over (order by Source) As Srno,Source,TotalLead,NotCalled,Called into #aa from FEF_LeadGap        
     SELECT @totctrOT=count(1) from #aa         
   SET @MESS=                          
   '<table border="1">                          
   <tr>                     
    <th> Source </th>                          
       <th> Total Leads </th>                          
       <th> NotCalled Leads  </th>                          
       <th> Called Leads </th>                          
   </tr>'        
--print @MESS        
   WHILE @Count <= @totctrOT                            
     BEGIN                      
      SELECT @Source=Source, @TotalLead=TotalLead,@notCalled=NotCalled,@called=Called FROM #aa WHERE Srno=@count                                 
      set @Data=@Data+                         
     '<tr>                        
     <td> '+ CONVERT(VARCHAR,@Source) +' </td>                        
     <td> '+ CONVERT(VARCHAR,@TotalLead) +' </td>                        
     <td> '+ CONVERT(VARCHAR,@notCalled) +' </td>                        
     <td> '+ CONVERT(VARCHAR,@called) +' </td>                        
       </tr>'         
       --print @Data                       
      SET   @Count=@Count+1                                  
     END           
 -- set @MessBody=        
 -- '<tr>         
 --<td> '+  CONVERT(VARCHAR,Source) +' </td>                           
 --    <td> '+ CONVERT(VARCHAR,@totalLeadWeb) +' </td>                          
 --    <td> '+ CONVERT(VARCHAR,@NotCalledWeb) +' </td>                          
 --    <td> '+ CONVERT(VARCHAR,@CalledWeb) +' </td>                                         
 --      </tr>'            
               
 --set @MessBody1=        
 -- '<tr>         
 --<td> '+  CONVERT(VARCHAR,'JD') +' </td>                           
 --    <td> '+ CONVERT(VARCHAR,@totalLeadJD) +' </td>                          
 --    <td> '+ CONVERT(VARCHAR,@NotCalledJD) +' </td>                          
 --    <td> '+ CONVERT(VARCHAR,@CalledJD) +' </td>                                         
 --      </tr>'                 
        
SET @MessBody =  'Dear Team,<br/><br/>'+' LMS Gap Report for '+@fromdate+' to '+@todate+' has been generated: <br/><br/>'+ @MESS + @Data + '</Table>'     
SET @MessBody=@MessBody+'<BR><BR>Regards,<br><Br>Team 48 Fitness <BR><hr width=100%> <BR>This is a System generated Message. Please do not Reply.'                                  
           
         --print @MessBody                     
                        
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                  
 @RECIPIENTS =@emailto,--'neha.naiwar@angelbroking.com' ,                                  
 @COPY_RECIPIENTS = @emailcc,                                  
 @blind_copy_recipients =@emailbcc,--'neha.naiwar@angelbroking.com' ,              
 @PROFILE_NAME = '48fitness',                                  
 @BODY_FORMAT ='HTML',                                  
 @SUBJECT = '48 Fitness : LMS Gap Analysis Report',                                  
 @FILE_ATTACHMENTS ='',                                  
 @BODY =@MessBody                                  
                        
END try              
        
  BEGIN catch                        
      SET @MessBody=                        
'<BR><BR> ERROR in triggering email: 48 Fitness [Inhouse]:Gap Analysis Report.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                        
                        
    EXEC intranet.msdb.dbo.Sp_send_dbmail                        
      @RECIPIENTS =@emailto,                        
      @COPY_RECIPIENTS = @emailcc,                        
      @PROFILE_NAME = '48fitness',                        
      @BODY_FORMAT ='HTML',                        
      @SUBJECT = 'ERROR: 48 Fitness : LMS Gap Analysis Report',                        
      @FILE_ATTACHMENTS ='',                        
      @BODY =@MESS                        
END catch                        
                        
SET nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_GapEmail_16082017
-- --------------------------------------------------
          
CREATE procedure [dbo].[FEF_LMS_GapEmail_16082017]          
AS          
SET nocount ON            
          
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)                      
DECLARE @emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                                
                             
SELECT @emailto='nazir.sheikh@48fitness.in'   --rajdeep.chakroborty@angelbroking.com                
SELECT @emailcc='Vijay.Thakkar@48fitness.in'--'radisson@48fitness.in'                      
SELECT @emailbcc='neha.naiwar@angelbroking.com;rajdeep.chakroborty@angelbroking.com'           
                            
          
--Declare @fromdate as varchar(11),@todate as varchar(11)              
--set @fromdate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))              
--set @fromdate = left(@fromdate,4)+'21'+right(@fromdate,5)              
--print @fromdate           
          
--set @todate = DATEADD(ss, 0, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))              
--set @todate = left(@todate,4)+'20'+right(@todate,5)              
--If CONVERT(datetime,@fromdate) > convert(datetime,@todate)          
--set @todate = CONVERT(varchar(11),getdate())           
--print @todate          
  
Declare @fromdate as varchar(11),@todate as varchar(11)              
set @fromdate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate())-1, 0))              
set @fromdate = left(@fromdate,4)+'21'+right(@fromdate,5)              
--print @fromdate           
          
set @todate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))              
set @todate = left(@todate,4)+'20'+right(@todate,5)              
If CONVERT(datetime,@fromdate) > convert(datetime,@todate)          
set @todate = CONVERT(varchar(11),getdate())           
--print @todate            
declare @totalLeadJD as int='',@totalLeadWeb as int='',@NotCalledJD as int ='',@NotCalledWeb as int ='',@CalledJD as int ='',@CalledWeb as int =''          
          
select @NotCalledWeb=count(Enquiry_No) from FEF_LeadCall where Enquiry_No='Not Called' and  source='web' and               
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'                
          
select @CalledWeb=count(Enquiry_No) from FEF_LeadCall where Enquiry_No<>'Not Called' and  source='Web' and               
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'                
          
select @totalLeadWeb=count(Enquiry_No) from FEF_LeadCall where source='Web' and               
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'                
          
select @NotCalledJD=count(Enquiry_No) from FEF_LeadCall where Enquiry_No='Not Called' and  source='JD' and               
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'                
          
select @CalledJD=count(Enquiry_No) from FEF_LeadCall where Enquiry_No<>'Not Called' and  source='JD' and               
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'                
          
select @totalLeadJD=count(Enquiry_No) from FEF_LeadCall where source='JD' and               
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'                
truncate table FEF_LeadGap          
insert into FEF_LeadGap          
select 'Web' as Source,@totalLeadWeb as TotalLead,@NotCalledWeb as NotCalled,@CalledWeb as Called          
          
insert into FEF_LeadGap          
select 'JD' as Source,@totalLeadJD as TotalLead,@NotCalledJD  as NotCalled,@CalledJD as Called          
  --8898889454  
 /*Sending SMS */               
 /* select '8898889454' as mobno, sum(TotalLead) as TotalLead,sum(NotCalled) as NotCalled,sum(Called) as Called into #MobNo1 from FEF_LeadGap    
    
   insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                       
   select a.mobno,'Dear Sales Consultant,Your total lead target was '+ltrim(rtrim(CONVERT(VARCHAR(10),a.TotalLead)))+'.Out of '+ltrim(rtrim(CONVERT(VARCHAR(10),a.TotalLead)))+' you have successfully attended '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Called)))+'
  
 leads and rest '+ltrim(rtrim(CONVERT(VARCHAR(10),a.NotCalled)))+' are your Unattended leads.',    
   convert(varchar(10), getdate(), 103),                
   ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +                
   ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),                
   'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12                
   then 'PM' else 'AM' end,'WellnessPromo'                
   from  #MobNo1 a    
 /*Sending SMS */                 
  */          
BEGIN try             
  declare @Count int,@CountEnd int,@Source as varchar(20)='',@TotalLead as int,@notCalled as int, @called as int                
  DECLARE @MessBody NVARCHAR(MAX) ,@MESS NVARCHAR(MAX) ,@MessBody1 as varchar(4000)=''           
  DECLARE @xml NVARCHAR(MAX)              
   DECLARE @Data NVARCHAR(MAX) ,  @totctrOT as int=0          
           
    set @Data=''                
    set @MessBody=''                          
    set @MESS=''          
    set @Count=1                                    
              
              
    select  row_number()over (order by Source) As Srno,Source,TotalLead,NotCalled,Called into #aa from FEF_LeadGap          
     SELECT @totctrOT=count(1) from #aa           
   SET @MESS=                            
   '<table border="1">                            
   <tr>                       
    <th> Source </th>                            
       <th> Total Leads </th>                            
       <th> NotCalled Leads  </th>                            
       <th> Called Leads </th>                            
   </tr>'          
--print @MESS          
   WHILE @Count <= @totctrOT                              
     BEGIN                        
      SELECT @Source=Source, @TotalLead=TotalLead,@notCalled=NotCalled,@called=Called FROM #aa WHERE Srno=@count                                   
      set @Data=@Data+                           
     '<tr>                          
     <td> '+ CONVERT(VARCHAR,@Source) +' </td>                          
     <td> '+ CONVERT(VARCHAR,@TotalLead) +' </td>                          
     <td> '+ CONVERT(VARCHAR,@notCalled) +' </td>                          
     <td> '+ CONVERT(VARCHAR,@called) +' </td>                          
       </tr>'           
       --print @Data                         
      SET   @Count=@Count+1                                    
     END             
 -- set @MessBody=          
 -- '<tr>           
 --<td> '+  CONVERT(VARCHAR,Source) +' </td>                             
 --    <td> '+ CONVERT(VARCHAR,@totalLeadWeb) +' </td>                            
 --    <td> '+ CONVERT(VARCHAR,@NotCalledWeb) +' </td>                            
 --    <td> '+ CONVERT(VARCHAR,@CalledWeb) +' </td>                                           
 --      </tr>'              
                 
 --set @MessBody1=          
 -- '<tr>           
 --<td> '+  CONVERT(VARCHAR,'JD') +' </td>                             
 --    <td> '+ CONVERT(VARCHAR,@totalLeadJD) +' </td>                            
 --    <td> '+ CONVERT(VARCHAR,@NotCalledJD) +' </td>                            
 --    <td> '+ CONVERT(VARCHAR,@CalledJD) +' </td>                                           
 --      </tr>'                   
          
SET @MessBody =  'Dear Team,<br/><br/>'+' LMS Gap Report for '+@fromdate+' to '+@todate+' has been generated: <br/><br/>'+ @MESS + @Data + '</Table>'       
SET @MessBody=@MessBody+'<BR><BR>Regards,<br><Br>Team 48 Fitness <BR><hr width=100%> <BR>This is a System generated Message. Please do not Reply.'                                    
             
         --print @MessBody                       
                          
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                    
 @RECIPIENTS =@emailto,--'neha.naiwar@angelbroking.com' ,                                    
 @COPY_RECIPIENTS = @emailcc,                                    
 @blind_copy_recipients =@emailbcc,--'neha.naiwar@angelbroking.com' ,                
 @PROFILE_NAME = '48fitness',                                    
 @BODY_FORMAT ='HTML',                                    
 @SUBJECT = '48 Fitness : LMS Gap Analysis Report',                                    
 @FILE_ATTACHMENTS ='',                                    
 @BODY =@MessBody                                    
                          
END try                
          
  BEGIN catch                          
      SET @MessBody=                          
'<BR><BR> ERROR in triggering email: 48 Fitness [Inhouse]:Gap Analysis Report.<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>'                          
                          
    EXEC intranet.msdb.dbo.Sp_send_dbmail                          
      @RECIPIENTS =@emailto,                          
      @COPY_RECIPIENTS = @emailcc,                          
      @PROFILE_NAME = '48fitness',                          
      @BODY_FORMAT ='HTML',                          
      @SUBJECT = 'ERROR: 48 Fitness : LMS Gap Analysis Report',                          
      @FILE_ATTACHMENTS ='',                          
      @BODY =@MESS                          
END catch                          
                          
SET nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_MemberAttandance
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_MemberAttandance]        
(@tblMemAttendance FEF_MemberAttanType READONLY)        
        
as        
        
truncate table TestMemberAttandance        
insert into [dbo].TestMemberAttandance        
select * from @tblMemAttendance        
        
insert into LMS_Attandance_Log        
select getdate(),count(1) as NOR from TestMemberAttandance with (nolock)         
             
truncate table FEF_AttandanceList       
       
insert into FEF_AttandanceList(MemberNo,Membername,AttandanceDate,LastUpdatedon,flag)           
select MemberNo,Membername,AttandanceDate,getdate() as LastUpdatedon,1 as flag    
 from TestMemberAttandance

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_MemberStatus
-- --------------------------------------------------
CREATE Proc [dbo].[FEF_LMS_MemberStatus]        
(@tblMemStatus FEF_MemberStatusType READONLY)        
        
as        
        
truncate table TestMemberStatus        
insert into [dbo].TestMemberStatus        
select * from @tblMemStatus        
        
insert into LMS_Status_Log        
select getdate(),count(1) as NOR from TestMemberStatus with (nolock)         
             
truncate table FEF_MembeStatusList       
       
insert into FEF_MembeStatusList(MemberNo,Membername,Active,LastUpdatedon,flag)           
select MemberNo,Membername,Active,getdate() as LastUpdatedon,1 as flag    
 from TestMemberStatus

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_NotCalledEmail
-- --------------------------------------------------
       
CREATE procedure [dbo].[FEF_LMS_NotCalledEmail]      
AS      
       
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100)                  
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
                         
select @Emp_name=Emp_name,@emp_email=email from risk.dbo.emp_info with (nolock) where Department='Fitness' and emp_no<>'W00003' and Sub_Department='Sales' and SeparationDate is null      
Declare @date1 as varchar(11),@today1 as varchar(20)            
set @date1 = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))            
set @date1 = left(@date1,4)+'24'+right(@date1,5)            
select @today1=convert(varchar(11),getdate(),100)  
print @today1
print @date1 
 if (@date1=@today1)  
 begin
	SELECT @emailto='MohammedAli.Sayyed@48fitness.in' --'neha.naiwar@angelbrokin.com'sharmagaurav@angelbroking.com; 
	SELECT @emailcc='nazir.sheikh@48fitness.in'                  
	SELECT @emailbcc='neha.naiwar@angelbroking.com;rajdeep.chakroborty@angelbroking.com'  
end
else
begin
	SELECT @emailto='Fauzeeya.Shaikh@48fitness.in;ali.sayyed@48fitness.in'--@emp_email
	SELECT @emailcc='rajdeep.chakroborty@angelbroking.com'
	SELECT @emailbcc='neha.naiwar@angelbroking.com' 
end             
      
                        
begin Try      
Declare @fromdate as varchar(11),@todate as varchar(11)          
set @fromdate = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))          
set @fromdate = left(@fromdate,4)+'21'+right(@fromdate,5)          
--print @fromdate       
      
set @todate = DATEADD(ss, 0, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))          
set @todate = left(@todate,4)+'20'+right(@todate,5)          
If CONVERT(datetime,@fromdate) > convert(datetime,@todate)      
set @todate = CONVERT(varchar(11),getdate())       
--print @todate      
      
truncate table FEF_LMS_data                 
insert into FEF_LMS_data        
 SELECT       
 ROW_NUMBER() OVER ( ORDER BY Name) AS [SrNo],Lead_Date         
 ,Name,Contact_No      
 FROM FEF_LeadCall where Enquiry_No='Not Called'       
 and           
Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'            
order by lEAD_DATE       
       
 DECLARE @filename1 as varchar(100)                                      
              
/* select @filename1='d:\upload1\FEF\FEF_LMS_NotCalled_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                              */
 select @filename1='I:\upload1\FEF\FEF_LMS_NotCalled_'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.xls'                              

      
truncate table FEF_LMS_Head                       
insert into FEF_LMS_Head(SrNo,[Lead Date],Name,[Mobile No.])      
select 'SrNo','Lead Date','Name','Mobile No.'      
      
insert into FEF_LMS_Head(SrNo,[Lead Date],Name,[Mobile No.])      
select SrNo,[Lead Date],Name,[Mobile No.] from FEF_LMS_data                   
                
/* Generate Details XLS File */          
declare @s1 as varchar(max)             
set @s1 = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT SrNo,[Lead Date],Name,[Mobile No.] FROM INTRANET.FEF_JDemail.dbo.FEF_LMS_Head " queryout '+@filename1+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                       
  
    
          
set @s1= @s1+''''                                  
Exec (@s1)                               
      
if(select count(1) from FEF_LMS_data)>0                
Begin                                 
 SET @MESS='Dear Team,<br><Br>Good Morning!!!<br><Br>Please refer the attached file of NotCalled Leads for the period '+@fromdate+' to '+@todate+'.<Br><Br>'                      
 SET @MESS=@MESS+'<BR><BR>Regards,<br><Br>Team 48 Fitness <BR><hr width=100%> <BR>This is a System generated Message. Please do not Reply.'                                
 set @sub ='48 Fitness: Unattended Leads '+@fromdate+' to '+@todate+'.'                   
End      
Else       
Begin      
 SET @MESS='Dear Team,<br><Br>Good Morning!!!<br><Br>You called or attended all the leads for the period '+@fromdate+' to '+@todate+'.<Br><Br>'                      
 SET @MESS=@MESS+'<BR><BR>Regards,<br><Br>Team 48 Fitness <BR><hr width=100%> <BR>This is a System generated Message. Please do not Reply.'                                
 set @sub ='48 Fitness: Unattended Leads '+@fromdate+' to '+@todate+'.'          
End                  
                      
 DECLARE @s varchar(500)                      
 SET @s = @filename1           
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = '48fitness',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                                

 /*Sending SMS */  
Declare @date as varchar(11),@today as varchar(20)            
set @date = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))            
set @date = left(@date,4)+'24'+right(@date,5)            
select @today=convert(varchar(11),getdate(),100)  
print @today
print @date 
 if (@date=@today)  
 begin         
 select '8898889454' as mobno, sum(TotalLead) as TotalLead,sum(NotCalled) as NotCalled,sum(Called) as Called into #MobNo1 from FEF_LeadGap  
  
   insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                     
   select a.mobno,'Dear Sales Consultant,Your total lead target was '+ltrim(rtrim(CONVERT(VARCHAR(10),a.TotalLead)))+'.Out of '+ltrim(rtrim(CONVERT(VARCHAR(10),a.TotalLead)))+' you have successfully attended '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Called)))+'
 leads and rest '+ltrim(rtrim(CONVERT(VARCHAR(10),a.NotCalled)))+' are your Unattended leads.',  
   convert(varchar(10), getdate(), 103),              
   ltrim(rtrim(str(datepart(hh, dateadd(minute, 1, getdate()))))) +':' +              
   ltrim(rtrim(str(datepart(minute, dateadd(minute, 2, getdate()))))),              
   'P', case when (datepart(hh, dateadd(minute, 1, getdate()))) >= 12              
   then 'PM' else 'AM' end,'WellnessPromo'              
   from  #MobNo1 a  
   
   drop table #MobNo1
  end 
 /*Sending SMS */ 	
	                                
END TRY      
                                
BEGIN CATCH                                
                                
                                
 SET @MESS='<BR><BR> ERROR in triggering email for 48 Fitness:  Unattended Leads                              
 <BR>                                
 <BR>                                
 This is a System generated Message. Please do not Reply.<BR>                                
 <BR>                                
 '                                
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailbcc,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @PROFILE_NAME = '48fitness',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = 'ERROR in 48 Fitness: 48 Fitness:  Unattended Leads ',                                
 @FILE_ATTACHMENTS ='',                                
 @BODY =@MESS                                
                                
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_RPT
-- --------------------------------------------------

  
--FEF_LMS_RPT '22/12/2015','01/01/2016','All','All','CSO','Broker'  
CREATE Procedure [dbo].[FEF_LMS_RPT]                 
(      
@FromDate as varchar(11),              
@toDate as varchar(11),    
@Source varchar(10),    
@Type varchar(20),              
@access_to varchar(30),                  
@access_code varchar(30)                  
)                 
as                  
              
set nocount on              
    
if @Source='All'    
Begin    
 set @Source='%'    
End    
if @Type='All'    
Begin    
 set @Type='%'    
End    
  
if @Type='NotCalled'    
Begin    
 set @Type='Not Called'    
End    
  
if @Type='Closed'    
Begin    
 set @Type='yes'    
End    
  
if @Type='Open'    
Begin    
	--SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]            
	SELECT Lead_Date as [Date]  
	,Name,Contact_No,Source,Phone,sendorEmailAddress,EnquiryFor,Area,Enquiry_No,
	/*convert(varchar(25),First_Contact_Date,103) as First_Contact_Date*/
	First_Contact_Date
	,NoofCalls,            
	Counseller,membership_no as MembershipStatus,
	(Case when Source='JD' then
	'<a href="#" onClick="openmodalpopup(''JustDial email content'',''/FEF/FEF_JDemail.asp?mph='+phone+''',800,500); return false">email</a>' 
	else '' end) as email              
	FROM FEF_LeadCall where Source like @Source    
	and membership_no <> 'YES'    and Name <>''
	and Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'    
	order by lEAD_DATE desc      

	select ''  
	select 'LMS Report: Date from '+replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' To '+replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' Source:'+replace(@Source,'%','All')+' Type:'+replace(replace(@type,'yes','Closed'),'%','All')   
   
 Return    
End    
  
  
if @Type='Not Called'   
Begin    
 --SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]  
 SELECT Lead_Date as [Date]           
 ,Name,Contact_No,Source,sendorEmailAddress,EnquiryFor,Area,Enquiry_No,
 /*convert(varchar(25),First_Contact_Date,103) as First_Contact_Date*/
 First_Contact_Date
 ,NoofCalls,            
 Counseller,membership_no  as MembershipStatus,            
 (Case when Source='JD' then
	'<a href="#" onClick="openmodalpopup(''JustDial email content'',''/FEF/FEF_JDemail.asp?mph='+phone+''',800,500); return false">email</a>' 
	else '' end) as email
 FROM FEF_LeadCall where Source like @Source    
 and Enquiry_No=@Type   and Name<>''
 and Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'    
 order by lEAD_DATE desc               
  
 select ''  
 select 'LMS Report: Date from '+replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' To '+replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' Source:'+replace(@Source,'%','All')+' Type:'
 +replace(replace(@type,'yes','Closed'),'%','All')   
  
 return  
End  
  
  
  
if @Type='%'   
Begin    
 --SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]  
 SELECT Lead_Date as [Date]           
 ,Name,Contact_No,Source,sendorEmailAddress,EnquiryFor,Area,Enquiry_No,
 	/*convert(varchar(25),First_Contact_Date,103) as First_Contact_Date*/
	First_Contact_Date
 ,NoofCalls,            
 Counseller,membership_no  as MembershipStatus,
 (Case when Source='JD' then
	'<a href="#" onClick="openmodalpopup(''JustDial email content'',''/FEF/FEF_JDemail.asp?mph='+phone+''',800,500); return false">email</a>' 
	else '' end) as email            
 FROM FEF_LeadCall where Source like @Source  and Name <>''
 and Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'    
 order by lEAD_DATE desc               
  
 select ''  
 select 'LMS Report: Date from '+replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' To '+replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' Source:'+replace(@Source,'%','All')+' Type:'
 +replace(replace(@type,'yes','Closed'),'%','All')   
  
 return  
End  
  
  
if @Type='yes'    
Begin    
 --SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date] 
 SELECT Lead_Date as [Date]            
 ,Name,Contact_No,Source,sendorEmailAddress,EnquiryFor,Area,Enquiry_No,
	/*convert(varchar(25),First_Contact_Date,103) as First_Contact_Date*/
	First_Contact_Date
 ,NoofCalls,            
 Counseller,membership_no  as MembershipStatus,
 (Case when Source='JD' then
	'<a href="#" onClick="openmodalpopup(''JustDial email content'',''/FEF/FEF_JDemail.asp?mph='+phone+''',800,500); return false">email</a>' 
	else '' end) as email            
 FROM FEF_LeadCall where Source like @Source   and Name <>''
 and membership_no like @Type    
 and Lead_Date>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Lead_Date <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'    
 order by lEAD_DATE desc               
  
 select ''  
 select 'LMS Report: Date from '+replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' To '+replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' Source:'+replace(@Source,'%','All')+' Type:'
 +replace(replace(@type,'yes','Closed'),'%','All')   
 return  
End  
  
              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_LMS_RPT_03112015
-- --------------------------------------------------

CREATE Procedure [dbo].[FEF_LMS_RPT_03112015]               
(    
@FromDate as varchar(11),            
@toDate as varchar(11),  
@Source varchar(10),  
@Type varchar(20),            
@access_to varchar(30),                
@access_code varchar(30)                
)               
as                
            
set nocount on            
  
if @Source='All'  
Begin  
 set @Source='%'  
End  
if @Type='All'  
Begin  
 set @Type='%'  
End  

if @Type='NotCalled'  
Begin  
 set @Type='Not Called'  
End  

if @Type='Closed'  
Begin  
 set @Type='yes'  
End  

if @Type='Open'  
Begin  
	SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]          
	,Name,Contact_No,Source,Enquiry_No,convert(varchar(25),First_Contact_Date,103) as First_Contact_Date,NoofCalls,          
	Counseller,membership_no          
	FROM FEF_LeadCall where Source like @Source  
	and membership_no <> 'YES'  
	and Lead_Date>=convert(varchar(25),@FromDate,106)+' 00:00:00' and Lead_Date <= convert(varchar(11),@todate,106)+' 23:59:59'  
	order by lEAD_DATE desc    


	select ''
	select 'LMS Report: Date from '+convert(varchar(25),@FromDate,106)+' To '+convert(varchar(11),@todate,106)+' Source:'+replace(@Source,'%','All')+' Type:'+replace(replace(@type,'yes','Closed'),'%','All') 
	
	Return  
End  


if @Type='Not Called' 
Begin  
	SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]          
	,Name,Contact_No,Source,Enquiry_No,convert(varchar(25),First_Contact_Date,103) as First_Contact_Date,NoofCalls,          
	Counseller,membership_no          
	FROM FEF_LeadCall where Source like @Source  
	and Enquiry_No=@Type 
	and Lead_Date>=convert(varchar(25),@FromDate,106)+' 00:00:00' and Lead_Date <=  convert(varchar(11),@todate,106)+' 23:59:59'  
	order by lEAD_DATE desc             

	select ''
	select 'LMS Report: Date from '+convert(varchar(25),@FromDate,106)+' To '+ convert(varchar(11),@todate,106)+' Source:'+replace(@Source,'%','All')+' Type:'+replace(replace(@type,'yes','Closed'),'%','All') 

	return
End



if @Type='%' 
Begin  
	SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]          
	,Name,Contact_No,Source,Enquiry_No,convert(varchar(25),First_Contact_Date,103) as First_Contact_Date,NoofCalls,          
	Counseller,membership_no          
	FROM FEF_LeadCall where Source like @Source  
	and Lead_Date>=convert(varchar(25),@FromDate,106)+' 00:00:00' and Lead_Date <= convert(varchar(11),@todate,106)+' 23:59:59'  
	order by lEAD_DATE desc             

	select ''
	select 'LMS Report: Date from '+convert(varchar(25),@FromDate,106)+' To '+convert(varchar(11),@todate,106)+' Source:'+replace(@Source,'%','All')+' Type:'+replace(replace(@type,'yes','Closed'),'%','All') 

	return
End


if @Type='yes'  
Begin  
	SELECT convert(varchar(25),Lead_Date,103)+' '+convert(varchar(25),Lead_Date,108) as [Date]          
	,Name,Contact_No,Source,Enquiry_No,convert(varchar(25),First_Contact_Date,103) as First_Contact_Date,NoofCalls,          
	Counseller,membership_no          
	FROM FEF_LeadCall where Source like @Source  
	and membership_no like @Type  
	and Lead_Date>=convert(varchar(25),@FromDate,106)+' 00:00:00' and Lead_Date <= convert(varchar(11),@todate,106)+' 23:59:59'  
	order by lEAD_DATE desc             

	select ''
	select 'LMS Report: Date from '+convert(varchar(25),@FromDate,106)+' To '+convert(varchar(11),@todate,106)+' Source:'+replace(@Source,'%','All')+' Type:'+replace(replace(@type,'yes','Closed'),'%','All') 
	return
End

            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_PTRegularityRpt
-- --------------------------------------------------
 
--FEF_PTRegularityRpt 'jun-2017','20003','CSO','Broker'
 
 CREATE PROCEDURE [dbo].[FEF_PTRegularityRpt] 
(
@mon  as char(8),
@Membercode Varchar(50),
@ACCESS_TO varchar(25),
@ACCESS_CODE VARCHAR(25),
@username varchar(25)
)
As
BEGIN

if(@Membercode='0')      
Begin      
 set @Membercode='%%'      
End 

select memberno,Membername,
convert(datetime,substring(AttandanceDate,6,2)+'/'+substring(AttandanceDate,9,2)+'/'+substring(AttandanceDate,1,4)) as AttandanceDate
into #attendance from FEF_AttandanceList where  memberno like @Membercode   

select  memberno,Membername,count(AttandanceDate) as AttandanceDate into #TotalAtten from  #attendance 
where upper(left(datename(mm,AttandanceDate),3))+'-'+convert(char(4),datepart(yy,AttandanceDate))=@mon
group by memberno,Membername
order by AttandanceDate

/*
select call_type,workdate as PTDate into #PT2
from misc.dbo.fef_data  
where upper(left(datename(mm,workdate),3))+'-'+convert(char(4),datepart(yy,workdate))=@mon and call_type like @Membercode
group by call_type,workdate

select call_type,count(PTDate) as PTDate into #PT
from #PT2 
where upper(left(datename(mm,PTDate),3))+'-'+convert(char(4),datepart(yy,PTDate))=@mon and call_type like @Membercode
group by call_type
*/

select memberno,saleid,DATEADD(dd, DATEDIFF(dd, 0,updatedon),0) as PTDate,noofsessions into #PT2
from misc.dbo.FEF_Srno_saleid 
where upper(left(datename(mm,updatedon),3))+'-'+convert(char(4),datepart(yy,updatedon))=@mon and memberno like @Membercode


select memberno,sum(noofsessions) as noofsessions,saleid into #PT
from #PT2
group by memberno,saleid
 

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession   
--into #aa   
,c.AttandanceDate as GYMAttendedDay,
d.noofsessions as PTSessionconsumed
into #ww from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
join #TotalAtten c  on a.memberNo=c.memberno
join #PT d on  a.memberNo=d.memberNo and a.saleid=d.saleid
where b.balancesession>=0  and a.MemberNo like @Membercode 
group by  a.MemberNo,a.MemberName,c.AttandanceDate,d.noofsessions,a.PlanName,a.StartDt,a.EndDt,a.Trainer,a.saleid,b.balancesession 

select MemberNo as [Member No.],MemberName as [Member Name],max(PlanName) as [Plan Name], 
/*CONVERT(VARCHAR(10), cast(max(StartDt) as date), 103)  as [Plan Start Datet],
CONVERT(VARCHAR(10), cast(max(EndDt) as date), 103)  as [Plan End Date],*/
max(StartDt)  as [Plan Start Datet],
max(EndDt)   as [Plan End Date],
max(Trainer) as Trainer,Saleid,/*max(saleid) as Saleid,*/
max(balancesession) as [Balance Session],
[GYM Attended Days]='<A HREF =''/global3/report.aspx?reportno=839&mon='+convert(char(8),@mon)+'&access_to='+@access_to+'&access_code='+@access_code+'&username='+@username+'&Member='+Convert(varchar(50),MemberNo)+'&saleid='+Convert(varchar(50),saleid)
+  
    
'''>'+convert(varchar(50),[GYMAttendedDay])+'</A>' ,PTSessionconsumed as [PT Session Consumed]
from #ww group by MemberNo,MemberName,GYMAttendedDay,PTSessionconsumed,Saleid
order by MemberNo
/*
#TotalAtten where memberno=20716
#PT  where memberno=20716
misc.dbo.fef_pt_sales_v16 where memberno=20716 order by saleid
misc.dbo.fef_data where call_type=20716 order by Workdate desc






select memberno,saleid,max(updatedon) as LastPTDate into #PT from misc.dbo.FEF_Srno_saleid  group by memberno,saleid

select memberno,Membername,max(AttandanceDate) as AttandanceDate into #attan from FEF_AttandanceList group by memberno,Membername

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession    
--into #aa   
,convert(datetime,substring(c.AttandanceDate,6,2)+'/'+substring(c.AttandanceDate,9,2)+'/'+substring(c.AttandanceDate,1,4)) as LastattendeddateOnGym,
DATEADD(dd, DATEDIFF(dd, 0, d.LastPTDate),0) as LastPTDate into #main
from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
join #attan c  on a.memberNo=c.memberno
join #PT d on  a.memberNo=d.memberno and a.saleid=d.saleid
where b.balancesession>=0  and a.MemberNo like @Membercode  
--and convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))<=getdate()   
order by convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))  desc  


select memberno as [Member No],MemberName as[Member Name],[PlanName],[StartDt],[EndDt],[Trainer],[saleid],[balancesession],LastattendeddateOnGym as
[Last attended date On Gym],LastPTDate as [Last PT Date]
,abs(DATEDIFF(day,LastattendeddateOnGym,LastPTDate)) AS [Day Diffrence For PT],DATEDIFF(day,LastattendeddateOnGym,getdate()) 
AS [Day Difference for GYM]  from #main where 
upper(left(datename(mm,LastattendeddateOnGym),3))+'-'+convert(char(4),datepart(yy,LastattendeddateOnGym))=@mon  
/*where memberno='20144'*/
*/

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_PTRegularityRpt_16Jun2017
-- --------------------------------------------------
 
--FEF_PTRegularityRpt 'May-2017','0','CSO','Broker'
 
 create PROCEDURE [dbo].[FEF_PTRegularityRpt_16Jun2017] 
(
@mon  as char(8),
@Membercode Varchar(50),
@ACCESS_TO varchar(25),
@ACCESS_CODE VARCHAR(25),
@username varchar(25)=null  
)
As
BEGIN

if(@Membercode='0')      
Begin      
 set @Membercode='%%'      
End 

select memberno,saleid,max(updatedon) as LastPTDate into #PT from misc.dbo.FEF_Srno_saleid  group by memberno,saleid

select memberno,Membername,max(AttandanceDate) as AttandanceDate into #attan from FEF_AttandanceList group by memberno,Membername

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession    
--into #aa   
,convert(datetime,substring(c.AttandanceDate,6,2)+'/'+substring(c.AttandanceDate,9,2)+'/'+substring(c.AttandanceDate,1,4)) as LastattendeddateOnGym,
DATEADD(dd, DATEDIFF(dd, 0, d.LastPTDate),0) as LastPTDate into #main
from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
join #attan c  on a.memberNo=c.memberno
join #PT d on  a.memberNo=d.memberno and a.saleid=d.saleid
where b.balancesession>=0  and a.MemberNo like @Membercode  
--and convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))<=getdate()   
order by convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))  desc  


select memberno as [Member No],MemberName as[Member Name],[PlanName],[StartDt],[EndDt],[Trainer],[saleid],[balancesession],LastattendeddateOnGym as
[Last attended date On Gym],LastPTDate as [Last PT Date]
,abs(DATEDIFF(day,LastattendeddateOnGym,LastPTDate)) AS [Day Diffrence For PT],DATEDIFF(day,LastattendeddateOnGym,getdate()) 
AS [Day Difference for GYM]  from #main where 
upper(left(datename(mm,LastattendeddateOnGym),3))+'-'+convert(char(4),datepart(yy,LastattendeddateOnGym))=@mon  
/*where memberno='20144'*/

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_PTRegularityRpt_30Jun2017
-- --------------------------------------------------
 
--FEF_PTRegularityRpt 'apr-2017','20328','CSO','Broker'
 
 create PROCEDURE [dbo].[FEF_PTRegularityRpt_30Jun2017] 
(
@mon  as char(8),
@Membercode Varchar(50),
@ACCESS_TO varchar(25),
@ACCESS_CODE VARCHAR(25),
@username varchar(25)=null  
)
As
BEGIN

if(@Membercode='0')      
Begin      
 set @Membercode='%%'      
End 

select memberno,Membername,
convert(datetime,substring(AttandanceDate,6,2)+'/'+substring(AttandanceDate,9,2)+'/'+substring(AttandanceDate,1,4)) as AttandanceDate
into #attendance from FEF_AttandanceList where  memberno like @Membercode   

select  memberno,Membername,count(AttandanceDate) as AttandanceDate into #TotalAtten from  #attendance 
where upper(left(datename(mm,AttandanceDate),3))+'-'+convert(char(4),datepart(yy,AttandanceDate))=@mon
group by memberno,Membername
order by AttandanceDate

/*
select call_type,workdate as PTDate into #PT2
from misc.dbo.fef_data  
where upper(left(datename(mm,workdate),3))+'-'+convert(char(4),datepart(yy,workdate))=@mon and call_type like @Membercode
group by call_type,workdate

select call_type,count(PTDate) as PTDate into #PT
from #PT2 
where upper(left(datename(mm,PTDate),3))+'-'+convert(char(4),datepart(yy,PTDate))=@mon and call_type like @Membercode
group by call_type
*/

select memberno,saleid,DATEADD(dd, DATEDIFF(dd, 0,updatedon),0) as PTDate,noofsessions into #PT2
from misc.dbo.FEF_Srno_saleid 
where upper(left(datename(mm,updatedon),3))+'-'+convert(char(4),datepart(yy,updatedon))=@mon and memberno like @Membercode


select memberno,sum(noofsessions) as noofsessions into #PT
from #PT2
group by memberno
 

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession   
--into #aa   
,c.AttandanceDate as GYMAttendedDay,
d.noofsessions as PTSessionconsumed
into #ww from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
join #TotalAtten c  on a.memberNo=c.memberno
join #PT d on  a.memberNo=d.memberNo --and a.saleid=d.saleid
where b.balancesession>=0  and a.MemberNo like @Membercode 
group by  a.MemberNo,a.MemberName,c.AttandanceDate,d.noofsessions,a.PlanName,a.StartDt,a.EndDt,a.Trainer,a.saleid,b.balancesession 

select MemberNo as [Member No.],MemberName as [Member Name],max(PlanName) as [Plan Name], CONVERT(VARCHAR(10), cast(max(StartDt) as date), 103)  as [Plan Start Datet],
CONVERT(VARCHAR(10), cast(max(EndDt) as date), 103)  as [Plan End Date],max(Trainer) as Trainer,max(saleid) as Saleid,
max(balancesession) as [Balance Session],
[GYM Attended Days]='<A HREF =''http://196.1.115.183/global3/report.aspx?reportno=839&mon='+convert(char(8),@mon)+'&access_to='+@access_to+'&access_code='+@access_code+'&username='+isnull(@username,'')+'&Member='+Convert(varchar(50),MemberNo)
+  
    
'''>'+convert(varchar(50),[GYMAttendedDay])+'</A>' ,PTSessionconsumed as [PT Session Consumed]
from #ww group by MemberNo,MemberName,GYMAttendedDay,PTSessionconsumed
order by MemberNo
/*
#TotalAtten where memberno=20716
#PT  where memberno=20716
misc.dbo.fef_pt_sales_v16 where memberno=20716 order by saleid
misc.dbo.fef_data where call_type=20716 order by Workdate desc






select memberno,saleid,max(updatedon) as LastPTDate into #PT from misc.dbo.FEF_Srno_saleid  group by memberno,saleid

select memberno,Membername,max(AttandanceDate) as AttandanceDate into #attan from FEF_AttandanceList group by memberno,Membername

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession    
--into #aa   
,convert(datetime,substring(c.AttandanceDate,6,2)+'/'+substring(c.AttandanceDate,9,2)+'/'+substring(c.AttandanceDate,1,4)) as LastattendeddateOnGym,
DATEADD(dd, DATEDIFF(dd, 0, d.LastPTDate),0) as LastPTDate into #main
from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
join #attan c  on a.memberNo=c.memberno
join #PT d on  a.memberNo=d.memberno and a.saleid=d.saleid
where b.balancesession>=0  and a.MemberNo like @Membercode  
--and convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))<=getdate()   
order by convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))  desc  


select memberno as [Member No],MemberName as[Member Name],[PlanName],[StartDt],[EndDt],[Trainer],[saleid],[balancesession],LastattendeddateOnGym as
[Last attended date On Gym],LastPTDate as [Last PT Date]
,abs(DATEDIFF(day,LastattendeddateOnGym,LastPTDate)) AS [Day Diffrence For PT],DATEDIFF(day,LastattendeddateOnGym,getdate()) 
AS [Day Difference for GYM]  from #main where 
upper(left(datename(mm,LastattendeddateOnGym),3))+'-'+convert(char(4),datepart(yy,LastattendeddateOnGym))=@mon  
/*where memberno='20144'*/
*/

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_PTRegularityRpt_MemberWise
-- --------------------------------------------------
 
--FEF_PTRegularityRpt_MemberWise 'May-2017','20716','CSO','Broker'
 
 CREATE PROCEDURE [dbo].[FEF_PTRegularityRpt_MemberWise] 
(
@mon  as char(8),
@Member Varchar(50),
@saleid varchar(50),
@ACCESS_TO varchar(25),
@ACCESS_CODE VARCHAR(25),
@username varchar(25)
)
As
BEGIN

if(@Member='0')      
Begin      
 set @Member='%%'      
End 

select memberno,saleid,DATEADD(dd, DATEDIFF(dd, 0,updatedon),0) as LastPTDate,noofsessions,SPACE(50)  as membername  into #PT11
from misc.dbo.FEF_Srno_saleid 
where upper(left(datename(mm,updatedon),3))+'-'+convert(char(4),datepart(yy,updatedon))=@mon and memberno=@Member and saleid=@saleid


select memberno,max(saleid) as saleid,LastPTDate,sum(noofsessions) as noofsessions,membername into #PT1
from #PT11
group by memberno,LastPTDate,membername

select memberno,Membername,
convert(datetime,substring(AttandanceDate,6,2)+'/'+substring(AttandanceDate,9,2)+'/'+substring(AttandanceDate,1,4)) as AttandanceDate 
into #attendance1 from FEF_AttandanceList where memberno=@Member   

select memberno,Membername,AttandanceDate into #attan1 
from #attendance1
where memberno=@Member and upper(left(datename(mm,AttandanceDate),3))+'-'+convert(char(4),datepart(yy,AttandanceDate))=@mon

/*
select c.*,isnull(a.LastPTDate,0) as LastPTDate,isnull(Convert(varchar(50),noofsessions)+'PT','') as PTAttendent,isnull(a.saleid,0) as saleid 
into #qq from #attan1 c 
left join #PT1 a on c.memberNo=a.memberNo  
/*and c.AttandanceDate= DATEADD(dd, DATEDIFF(dd, 0,a.LastPTDate),0) */  /*Commented on 20 Jun 2017 as suggested by Nikhil*/
and c.AttandanceDate= DATEADD(dd, DATEDIFF(dd, 0,a.LastPTDate),0)
order by c.AttandanceDate
*/ 
update #PT1 set MemberName=A.MemberName FRom 
(
select MemberName,memberno from #attan1
)A where #PT1.memberno=A.memberno

select memberno,MemberName,'' as saleid,Convert(varchar(11),AttandanceDate) as AttandanceDate,'Not Attend PT' as LastPTDate,'' as noofsessions into #qq from #attan1
union
select memberno,MemberName,saleid,'Absent' as AttandanceDate, convert(varchar(11),LastPTDate) as LastPTDate,noofsessions from #PT1

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession    
into #session from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
where b.balancesession>=0  and a.MemberNo=@Member  
order by convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))  desc  

select a.memberno,a.MemberName,isnull(a.saleid,0) as saleid,a.AttandanceDate,a.LastPTDate,
case when a.noofsessions=0 then ''
else isnull(Convert(varchar(50),a.noofsessions)+'PT','') end as PTAttendent,isnull(b.PlanName,'') as PlanName,isnull(b.StartDt,'') as StartDt,isnull(b.EndDt,'') as EndDt,isnull(b.Trainer,'') as Trainer,
isnull(b.balancesession,'') as balancesession into #main
 from #qq a left join #session b on a.MemberNo=b.MemberNo and  a.saleid=b.saleid
 
select memberno as [Member No],MemberName as[Member Name],AttandanceDate as [Attandance Date],
PTAttendent as [PT Sessions Attended],LastPTDate as [PT Date],isnull([PlanName],'') as [Plan Name],
/*CONVERT(VARCHAR(10), cast(isnull([StartDt],0) as date), 103) as [Plan Start Date],
CONVERT(VARCHAR(10), cast(isnull([EndDt],0) as date), 103) as [Plan End Date],*/
isnull([StartDt],0)  as [Plan Start Date],
isnull([EndDt],0) as [Plan End Date],
isnull([Trainer],'') as [Trainer],isnull([saleid],'') as [saleid],isnull([balancesession],'') as [Balance Session]  from #main

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_PTRegularityRpt_MemberWise_30Jun2017
-- --------------------------------------------------
 
--FEF_PTRegularityRpt_MemberWise 'May-2017','20716','CSO','Broker'
 
create PROCEDURE [dbo].[FEF_PTRegularityRpt_MemberWise_30Jun2017] 
(
@mon  as char(8),
@Member Varchar(50),
@ACCESS_TO varchar(25),
@ACCESS_CODE VARCHAR(25),
@username varchar(25)=null  
)
As
BEGIN

if(@Member='0')      
Begin      
 set @Member='%%'      
End 

select memberno,saleid,DATEADD(dd, DATEDIFF(dd, 0,updatedon),0) as LastPTDate,noofsessions,SPACE(50)  as membername  into #PT11
from misc.dbo.FEF_Srno_saleid 
where upper(left(datename(mm,updatedon),3))+'-'+convert(char(4),datepart(yy,updatedon))=@mon and memberno=@Member


select memberno,max(saleid) as saleid,LastPTDate,sum(noofsessions) as noofsessions,membername into #PT1
from #PT11
group by memberno,LastPTDate,membername

select memberno,Membername,
convert(datetime,substring(AttandanceDate,6,2)+'/'+substring(AttandanceDate,9,2)+'/'+substring(AttandanceDate,1,4)) as AttandanceDate 
into #attendance1 from FEF_AttandanceList where memberno=@Member   

select memberno,Membername,AttandanceDate into #attan1 
from #attendance1
where memberno=@Member and upper(left(datename(mm,AttandanceDate),3))+'-'+convert(char(4),datepart(yy,AttandanceDate))=@mon

/*
select c.*,isnull(a.LastPTDate,0) as LastPTDate,isnull(Convert(varchar(50),noofsessions)+'PT','') as PTAttendent,isnull(a.saleid,0) as saleid 
into #qq from #attan1 c 
left join #PT1 a on c.memberNo=a.memberNo  
/*and c.AttandanceDate= DATEADD(dd, DATEDIFF(dd, 0,a.LastPTDate),0) */  /*Commented on 20 Jun 2017 as suggested by Nikhil*/
and c.AttandanceDate= DATEADD(dd, DATEDIFF(dd, 0,a.LastPTDate),0)
order by c.AttandanceDate
*/ 
update #PT1 set MemberName=A.MemberName FRom 
(
select MemberName,memberno from #attan1
)A where #PT1.memberno=A.memberno

select memberno,MemberName,'' as saleid,Convert(varchar(11),AttandanceDate) as AttandanceDate,'Not Attend PT' as LastPTDate,'' as noofsessions into #qq from #attan1
union
select memberno,MemberName,saleid,'Absent' as AttandanceDate, convert(varchar(11),LastPTDate) as LastPTDate,noofsessions from #PT1

select a.MemberNo,a.MemberName,a.PlanName,  
convert(datetime,substring(a.StartDt,6,2)+'/'+substring(a.StartDt,9,2)+'/'+substring(a.StartDt,1,4)) as StartDt,  
convert(datetime,substring(a.EndDt,6,2)+'/'+substring(a.EndDt,9,2)+'/'+substring(a.EndDt,1,4)) as EndDt,a.Trainer,a.saleid,b.balancesession    
into #session from misc.dbo.fef_pt_sales_v16 a join misc.dbo.fef_Vw_balsession_v20 b on a.memberNo=b.membership_no and a.saleid=b.saleid 
where b.balancesession>=0  and a.MemberNo=@Member  
order by convert(datetime,substring(enddt,6,2)+'/'+substring(enddt,9,2)+'/'+substring(enddt,1,4))  desc  

select a.memberno,a.MemberName,isnull(a.saleid,0) as saleid,a.AttandanceDate,a.LastPTDate,
case when a.noofsessions=0 then ''
else isnull(Convert(varchar(50),a.noofsessions)+'PT','') end as PTAttendent,isnull(b.PlanName,'') as PlanName,isnull(b.StartDt,'') as StartDt,isnull(b.EndDt,'') as EndDt,isnull(b.Trainer,'') as Trainer,
isnull(b.balancesession,'') as balancesession into #main
 from #qq a left join #session b on a.MemberNo=b.MemberNo and  a.saleid=b.saleid
 
select memberno as [Member No],MemberName as[Member Name],AttandanceDate as [Attandance Date],
PTAttendent as [PT Sessions Attended],LastPTDate as [PT Date],isnull([PlanName],'') as [Plan Name],
CONVERT(VARCHAR(10), cast(isnull([StartDt],0) as date), 103) as [Plan Start Date],
CONVERT(VARCHAR(10), cast(isnull([EndDt],0) as date), 103) as [Plan End Date],
isnull([Trainer],'') as [Trainer],isnull([saleid],'') as [saleid],isnull([balancesession],'') as [Balance Session]  from #main

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_updJustDail
-- --------------------------------------------------
CREATE proc [dbo].[FEF_updJustDail]          
as          
          
set nocount on          
BEGIN TRY            
  
  
select   
ROW_NUMBER() OVER ( ORDER BY Id ) AS [SrNo],   
*  
into #mail2  
from FEF_JDLead /*a join  
FEF_JDemailid b on a.gc_SenderEmailAddress=b.jdemail  
WHERE gc_subject LIKE '%enquiry%'  */
  
select   
ROW_NUMBER() OVER ( ORDER BY gc_SentOn ) AS [SrNo],   
a.*  
into #mail1  
from Mail a join  
FEF_JDemailid b on a.gc_SenderEmailAddress=b.jdemail  
WHERE gc_subject LIKE '%enquiry%'  
  
 select gc_SenderEmailAddress,gc_senton,gc_guid,          
 substring(          
 gc_htmlbody,          
 charindex('Caller Name',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('Caller Name',gc_htmlbody))-charindex('Caller Name',gc_htmlbody)          
 ) as Name,          
 substring(          
 gc_htmlbody,          
 charindex('City',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('City',gc_htmlbody))-charindex('City',gc_htmlbody)          
 ) as City,  
 substring(          
 gc_htmlbody,          
 charindex('Phone',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('Phone',gc_htmlbody))-charindex('Phone',gc_htmlbody)          
 ) as Phone,        
 DNC=SPACE(10),        
 Phone1=SPACE(15)          
 into #mail       
 from #mail1  
  
drop table #mail1       
   
 update #mail set name=replace(name,'Caller Name:</b></td><td valign="top">',''),          
 City=replace(city,'City:</b></td><td valign="top">',''),          
 Phone=replace(phone,'Phone:</b></td><td valign="top">','')          
  
 update #mail set name=replace(name,'</td>',''),          
 City=replace(city,'</td>',''),          
 Phone=replace(phone,'</td>','')          
  
 update #mail set name=replace(name,'</td>',''),          
 City=replace(city,'</td>',''),          
 Phone=replace(phone,'</td>','')          
  
update #mail set name=replace(name,'''','')  
update #mail set city=replace(city,'''','')  
update #mail set phone=replace(phone,'''','')  
  
update #mail set name=replace(name,'Caller Name : </B>     <td valign="top">','')  
update #mail set name=replace(name,'<td valign="top">','')  
update #mail set name=replace(name,'Caller Name : </B>','')  
update #mail set name=replace(name,'<td valign=top style=font-size:10px;>','')  
update #mail set name='' where name like '<div style%'  
update #mail set name='' where name like '<table style%'  
update #mail set name=LTRIM(rtrim(name))  
  
update #mail set city=replace(city,'<td valign="top">','')  
update #mail set city=replace(city,'City : </B>','')  
update #mail set city=replace(city,'City Name : </B><td valign=top style=font-size:10px;>','')  
update #mail set city=replace(city,'<td valign=top style=font-size:10px;>','')  
update #mail set city=replace(city,'</B>','')  
update #mail set city=replace(city,'City Name','')  
update #mail set city=substring(city,CHARINDEX(':',city)+1,100) where city like '%:%'  
update #mail set city='' where city like '%<%'  
update #mail set city=LTRIM(rtrim(city))  
  
update #mail set phone=replace(phone,'<td valign="top">','')  
update #mail set phone=replace(phone,'</B>','')  
update #mail set phone=replace(phone,'<td valign=top style=font-size:10px;>','')  
update #mail set phone=replace(phone,'</a>','')  
update #mail set phone=substring(phone,CHARINDEX('>',phone)+1,100) where phone like '%<a href%'  
update #mail set phone=substring(phone,CHARINDEX(':',phone)+1,100) where phone like '%:%'  
update #mail set phone=LTRIM(rtrim(phone))  
update #mail set phone=substring(phone,CHARINDEX('+',phone),100) where phone like '%+%'  
  
update #mail set DNC=(Case when Phone like '%DNC%' then 'DNC' else '' end)        
update #mail set phone=REPLACE(phone,'(DNC)','')        
update #mail set phone=REPLACE(phone,'+91','')        
update #mail set phone=REPLACE(phone,' ','')        
update #mail set phone1=substring(phone,CHARINDEX(',',phone)+1,15) where phone like '%,%'        
update #mail set phone=substring(phone,1,CHARINDEX(',',phone)-1) where phone like '%,%'        
         
update #mail set city=replace(city,char(13),''),name=replace(name,char(13),''),phone=replace(phone,char(13),'')  
update #mail set city=replace(city,char(10),''),name=replace(name,char(10),''),phone=replace(phone,char(10),'')  
update #mail set city=replace(city,char(9),''),name=replace(name,char(9),''),phone=replace(phone,char(9),'')  
  
delete from #mail where phone=''    
/* Added on 08/07/2016*/
/*Insert into FEF_JDemail_hist(SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1,FEF_EnquiryNo,FEF_MemberNo,NoOfCalls,UpdatedOn)
select SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1,FEF_EnquiryNo,FEF_MemberNo,NoOfCalls,getdate() from FEF_JDemail
*/
truncate table FEF_JDemail
/*Old*/
insert into FEF_JDemail (SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1)          
select a.gc_SenderEmailAddress,a.gc_senton,a.gc_guid,a.Name,a.City,a.Phone,'JD',a.DNC,a.phone1        
from #mail a left outer join           
(select * from FEF_JDemail where src='JD' and  guid is null ) b on a.gc_guid=b.guid

/*New*/
insert into FEF_JDemail (SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1,EnquiryFor,Area)          
select email,(date+' '+time),leadid,Name,City,mobile,'JD',dncmobile,Phone,category,(Area+' '+ brancharea)      
from #mail2    
  
drop table #mail2  
  
insert into FEF_JDemail(SenderEmailAddress,senton,Name,City,Phone,Src,DNC,phone1)           
select           
email,          
reg_date,          
--Srno,          
first_name,          
isnull(Location,'') as Location,          
mobile,          
Src='Web','',''           
/*from [196.1.115.215].WebSite2.dbo.View_48FitnessLeads a left outer join           */   /*Commented on 05/07/2016 for changing source*/
from FEF_FitnessLeads a left outer join           
(select * from FEF_JDemail where src='Web') b on           
a.mobile=b.Phone          
where b.phone is null      
       
/*      
insert into FEF_JDemail(SenderEmailAddress,senton,Name,City,Phone,Src,DNC,phone1)       
select '',EnquiryDt,Enquiryname,'',MobileNo,Src='Gym','','' from FEF_EnquiryList a      
left outer join           
(select * from FEF_JDemail where src='Gym') b on           
a.MobileNo=b.Phone          
where b.phone is null          
*/      


update FEF_JDemail set FEF_MemberNo='',NoOfCalls=0,FEF_EnquiryNo=''   
/* For Update ph number */       
 update FEF_JDemail  set phone= replace(phone,'+91','')  
 update FEF_JDemail  set phone= replace(phone,'+910','')  
    
/*-----------------------*/
update FEF_JDemail set FEF_EnquiryNo=b.EnquiryNo,FEF_MemberNo=b.MemberNo,FEF_JDemail.NoOfCalls=b.NoofCalls        
from FEF_EnquiryList_vw b        
where b.mobileno=FEF_JDemail.phone  --and FEF_JDemail.FEF_EnquiryNo is null        
        
update FEF_JDemail set FEF_EnquiryNo=b.EnquiryNo,FEF_MemberNo=b.MemberNo,FEF_JDemail.NoOfCalls=FEF_JDemail.NoOfCalls+b.NoofCalls            
from FEF_EnquiryList_vw b        
where b.mobileno=FEF_JDemail.phone1 --and FEF_JDemail.FEF_EnquiryNo is null        
and isnull(FEF_JDemail.FEF_MemberNo,'')=''  
and isnull(FEF_JDemail.phone1,'')<>''   
  
update FEF_JDemail set FEF_MemberNo=b.MemeberNo        
from misc.dbo.FEF_Member_Details b        
where b.mobileno=FEF_JDemail.phone  and isnull(FEF_JDemail.phone,'') <> '' and  b.mobileno <> ''      
and isnull(FEF_JDemail.FEF_MemberNo,'')=''      
  
update FEF_JDemail set FEF_MemberNo=b.MemeberNo        
from misc.dbo.FEF_Member_Details b        
where b.mobileno=FEF_JDemail.phone1  and isnull(FEF_JDemail.phone1,'') <> '' and  b.mobileno <> ''      
and isnull(FEF_JDemail.FEF_MemberNo,'') = ''

          
END TRY                      
BEGIN CATCH                      
                      
 insert into risk.dbo.Appln_ERROR (ErrTime,ErrObject,ErrLine,ErrMessage,ApplnName,DBname)                                              
 select GETDATE(),'FEF_updJustDail',ERROR_LINE(),ERROR_MESSAGE(),'FEF JustDail Email Fetch',DB_NAME(db_id())                                              
            
 DECLARE @ErrorMessage NVARCHAR(4000);                                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                            
 RAISERROR (@ErrorMessage , 16, 1);                 
                      
END CATCH                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_updJustDail_05July2016
-- --------------------------------------------------
Create proc [dbo].[FEF_updJustDail_05July2016]          
as          
          
set nocount on          
BEGIN TRY            
  
  
select   
ROW_NUMBER() OVER ( ORDER BY gc_SentOn ) AS [SrNo],   
a.*  
into #mail1  
from Mail a join  
FEF_JDemailid b on a.gc_SenderEmailAddress=b.jdemail  
WHERE gc_subject LIKE '%enquiry%'  
  
 select gc_SenderEmailAddress,gc_senton,gc_guid,          
 substring(          
 gc_htmlbody,          
 charindex('Caller Name',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('Caller Name',gc_htmlbody))-charindex('Caller Name',gc_htmlbody)          
 ) as Name,          
 substring(          
 gc_htmlbody,          
 charindex('City',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('City',gc_htmlbody))-charindex('City',gc_htmlbody)          
 ) as City,  
 substring(          
 gc_htmlbody,          
 charindex('Phone',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('Phone',gc_htmlbody))-charindex('Phone',gc_htmlbody)          
 ) as Phone,        
 DNC=SPACE(10),        
 Phone1=SPACE(15)          
 into #mail       
 from #mail1  
  
drop table #mail1       
   
 update #mail set name=replace(name,'Caller Name:</b></td><td valign="top">',''),          
 City=replace(city,'City:</b></td><td valign="top">',''),          
 Phone=replace(phone,'Phone:</b></td><td valign="top">','')          
  
 update #mail set name=replace(name,'</td>',''),          
 City=replace(city,'</td>',''),          
 Phone=replace(phone,'</td>','')          
  
 update #mail set name=replace(name,'</td>',''),          
 City=replace(city,'</td>',''),          
 Phone=replace(phone,'</td>','')          
  
update #mail set name=replace(name,'''','')  
update #mail set city=replace(city,'''','')  
update #mail set phone=replace(phone,'''','')  
  
update #mail set name=replace(name,'Caller Name : </B>     <td valign="top">','')  
update #mail set name=replace(name,'<td valign="top">','')  
update #mail set name=replace(name,'Caller Name : </B>','')  
update #mail set name=replace(name,'<td valign=top style=font-size:10px;>','')  
update #mail set name='' where name like '<div style%'  
update #mail set name='' where name like '<table style%'  
update #mail set name=LTRIM(rtrim(name))  
  
update #mail set city=replace(city,'<td valign="top">','')  
update #mail set city=replace(city,'City : </B>','')  
update #mail set city=replace(city,'City Name : </B><td valign=top style=font-size:10px;>','')  
update #mail set city=replace(city,'<td valign=top style=font-size:10px;>','')  
update #mail set city=replace(city,'</B>','')  
update #mail set city=replace(city,'City Name','')  
update #mail set city=substring(city,CHARINDEX(':',city)+1,100) where city like '%:%'  
update #mail set city='' where city like '%<%'  
update #mail set city=LTRIM(rtrim(city))  
  
update #mail set phone=replace(phone,'<td valign="top">','')  
update #mail set phone=replace(phone,'</B>','')  
update #mail set phone=replace(phone,'<td valign=top style=font-size:10px;>','')  
update #mail set phone=replace(phone,'</a>','')  
update #mail set phone=substring(phone,CHARINDEX('>',phone)+1,100) where phone like '%<a href%'  
update #mail set phone=substring(phone,CHARINDEX(':',phone)+1,100) where phone like '%:%'  
update #mail set phone=LTRIM(rtrim(phone))  
update #mail set phone=substring(phone,CHARINDEX('+',phone),100) where phone like '%+%'  
  
update #mail set DNC=(Case when Phone like '%DNC%' then 'DNC' else '' end)        
update #mail set phone=REPLACE(phone,'(DNC)','')        
update #mail set phone=REPLACE(phone,'+91','')        
update #mail set phone=REPLACE(phone,' ','')        
update #mail set phone1=substring(phone,CHARINDEX(',',phone)+1,15) where phone like '%,%'        
update #mail set phone=substring(phone,1,CHARINDEX(',',phone)-1) where phone like '%,%'        
         
update #mail set city=replace(city,char(13),''),name=replace(name,char(13),''),phone=replace(phone,char(13),'')  
update #mail set city=replace(city,char(10),''),name=replace(name,char(10),''),phone=replace(phone,char(10),'')  
update #mail set city=replace(city,char(9),''),name=replace(name,char(9),''),phone=replace(phone,char(9),'')  
  
delete from #mail where phone=''  
  
insert into FEF_JDemail (SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1)          
select a.gc_SenderEmailAddress,a.gc_senton,a.gc_guid,a.Name,a.City,a.Phone,'JD',a.DNC,a.phone1        
from #mail a left outer join           
(select * from FEF_JDemail where src='JD') b on a.gc_guid=b.guid where b.guid is null          
  
drop table #mail  
  
insert into FEF_JDemail(SenderEmailAddress,senton,Name,City,Phone,Src,DNC,phone1)           
select           
email,          
reg_date,          
--Srno,          
first_name,          
isnull(Location,'') as Location,          
mobile,          
Src='Web','',''           
from [196.1.115.215].WebSite2.dbo.View_48FitnessLeads a left outer join           
(select * from FEF_JDemail where src='Web') b on           
a.mobile=b.Phone          
where b.phone is null          
       
/*      
insert into FEF_JDemail(SenderEmailAddress,senton,Name,City,Phone,Src,DNC,phone1)       
select '',EnquiryDt,Enquiryname,'',MobileNo,Src='Gym','','' from FEF_EnquiryList a      
left outer join           
(select * from FEF_JDemail where src='Gym') b on           
a.MobileNo=b.Phone          
where b.phone is null          
*/      


update FEF_JDemail set FEF_MemberNo='',NoOfCalls=0,FEF_EnquiryNo=''   
        
update FEF_JDemail set FEF_EnquiryNo=b.EnquiryNo,FEF_MemberNo=b.MemberNo,FEF_JDemail.NoOfCalls=b.NoofCalls        
from FEF_EnquiryList_vw b        
where b.mobileno=FEF_JDemail.phone  --and FEF_JDemail.FEF_EnquiryNo is null        
        
update FEF_JDemail set FEF_EnquiryNo=b.EnquiryNo,FEF_MemberNo=b.MemberNo,FEF_JDemail.NoOfCalls=FEF_JDemail.NoOfCalls+b.NoofCalls            
from FEF_EnquiryList_vw b        
where b.mobileno=FEF_JDemail.phone1 --and FEF_JDemail.FEF_EnquiryNo is null        
and isnull(FEF_JDemail.FEF_MemberNo,'')=''  
and isnull(FEF_JDemail.phone1,'')<>''   
  
update FEF_JDemail set FEF_MemberNo=b.MemeberNo        
from misc.dbo.FEF_Member_Details b        
where b.mobileno=FEF_JDemail.phone  and isnull(FEF_JDemail.phone,'') <> '' and  b.mobileno <> ''      
and isnull(FEF_JDemail.FEF_MemberNo,'')=''      
  
update FEF_JDemail set FEF_MemberNo=b.MemeberNo        
from misc.dbo.FEF_Member_Details b        
where b.mobileno=FEF_JDemail.phone1  and isnull(FEF_JDemail.phone1,'') <> '' and  b.mobileno <> ''      
and isnull(FEF_JDemail.FEF_MemberNo,'') = ''

          
END TRY                      
BEGIN CATCH                      
                      
 insert into risk.dbo.Appln_ERROR (ErrTime,ErrObject,ErrLine,ErrMessage,ApplnName,DBname)                                              
 select GETDATE(),'FEF_updJustDail',ERROR_LINE(),ERROR_MESSAGE(),'FEF JustDail Email Fetch',DB_NAME(db_id())                                              
            
 DECLARE @ErrorMessage NVARCHAR(4000);                                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                            
 RAISERROR (@ErrorMessage , 16, 1);                 
                      
END CATCH                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FEF_updJustDail_15Feb2017
-- --------------------------------------------------
Create proc [dbo].[FEF_updJustDail_15Feb2017]          
as          
          
set nocount on          
BEGIN TRY            
  
  
select   
ROW_NUMBER() OVER ( ORDER BY gc_SentOn ) AS [SrNo],   
a.*  
into #mail1  
from Mail a join  
FEF_JDemailid b on a.gc_SenderEmailAddress=b.jdemail  
WHERE gc_subject LIKE '%enquiry%'  
  
 select gc_SenderEmailAddress,gc_senton,gc_guid,          
 substring(          
 gc_htmlbody,          
 charindex('Caller Name',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('Caller Name',gc_htmlbody))-charindex('Caller Name',gc_htmlbody)          
 ) as Name,          
 substring(          
 gc_htmlbody,          
 charindex('City',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('City',gc_htmlbody))-charindex('City',gc_htmlbody)          
 ) as City,  
 substring(          
 gc_htmlbody,          
 charindex('Phone',gc_htmlbody),          
 charindex('</tr>',gc_htmlbody,charindex('Phone',gc_htmlbody))-charindex('Phone',gc_htmlbody)          
 ) as Phone,        
 DNC=SPACE(10),        
 Phone1=SPACE(15)          
 into #mail       
 from #mail1  
  
drop table #mail1       
   
 update #mail set name=replace(name,'Caller Name:</b></td><td valign="top">',''),          
 City=replace(city,'City:</b></td><td valign="top">',''),          
 Phone=replace(phone,'Phone:</b></td><td valign="top">','')          
  
 update #mail set name=replace(name,'</td>',''),          
 City=replace(city,'</td>',''),          
 Phone=replace(phone,'</td>','')          
  
 update #mail set name=replace(name,'</td>',''),          
 City=replace(city,'</td>',''),          
 Phone=replace(phone,'</td>','')          
  
update #mail set name=replace(name,'''','')  
update #mail set city=replace(city,'''','')  
update #mail set phone=replace(phone,'''','')  
  
update #mail set name=replace(name,'Caller Name : </B>     <td valign="top">','')  
update #mail set name=replace(name,'<td valign="top">','')  
update #mail set name=replace(name,'Caller Name : </B>','')  
update #mail set name=replace(name,'<td valign=top style=font-size:10px;>','')  
update #mail set name='' where name like '<div style%'  
update #mail set name='' where name like '<table style%'  
update #mail set name=LTRIM(rtrim(name))  
  
update #mail set city=replace(city,'<td valign="top">','')  
update #mail set city=replace(city,'City : </B>','')  
update #mail set city=replace(city,'City Name : </B><td valign=top style=font-size:10px;>','')  
update #mail set city=replace(city,'<td valign=top style=font-size:10px;>','')  
update #mail set city=replace(city,'</B>','')  
update #mail set city=replace(city,'City Name','')  
update #mail set city=substring(city,CHARINDEX(':',city)+1,100) where city like '%:%'  
update #mail set city='' where city like '%<%'  
update #mail set city=LTRIM(rtrim(city))  
  
update #mail set phone=replace(phone,'<td valign="top">','')  
update #mail set phone=replace(phone,'</B>','')  
update #mail set phone=replace(phone,'<td valign=top style=font-size:10px;>','')  
update #mail set phone=replace(phone,'</a>','')  
update #mail set phone=substring(phone,CHARINDEX('>',phone)+1,100) where phone like '%<a href%'  
update #mail set phone=substring(phone,CHARINDEX(':',phone)+1,100) where phone like '%:%'  
update #mail set phone=LTRIM(rtrim(phone))  
update #mail set phone=substring(phone,CHARINDEX('+',phone),100) where phone like '%+%'  
  
update #mail set DNC=(Case when Phone like '%DNC%' then 'DNC' else '' end)        
update #mail set phone=REPLACE(phone,'(DNC)','')        
update #mail set phone=REPLACE(phone,'+91','')        
update #mail set phone=REPLACE(phone,' ','')        
update #mail set phone1=substring(phone,CHARINDEX(',',phone)+1,15) where phone like '%,%'        
update #mail set phone=substring(phone,1,CHARINDEX(',',phone)-1) where phone like '%,%'        
         
update #mail set city=replace(city,char(13),''),name=replace(name,char(13),''),phone=replace(phone,char(13),'')  
update #mail set city=replace(city,char(10),''),name=replace(name,char(10),''),phone=replace(phone,char(10),'')  
update #mail set city=replace(city,char(9),''),name=replace(name,char(9),''),phone=replace(phone,char(9),'')  
  
delete from #mail where phone=''  
/* Added on 08/07/2016*/
/*Insert into FEF_JDemail_hist(SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1,FEF_EnquiryNo,FEF_MemberNo,NoOfCalls,UpdatedOn)
select SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1,FEF_EnquiryNo,FEF_MemberNo,NoOfCalls,getdate() from FEF_JDemail
*/
truncate table FEF_JDemail
  
insert into FEF_JDemail (SenderEmailAddress,senton,guid,Name,City,Phone,Src,DNC,phone1)          
select a.gc_SenderEmailAddress,a.gc_senton,a.gc_guid,a.Name,a.City,a.Phone,'JD',a.DNC,a.phone1        
from #mail a left outer join           
(select * from FEF_JDemail where src='JD') b on a.gc_guid=b.guid where b.guid is null          
  
drop table #mail  
  
insert into FEF_JDemail(SenderEmailAddress,senton,Name,City,Phone,Src,DNC,phone1)           
select           
email,          
reg_date,          
--Srno,          
first_name,          
isnull(Location,'') as Location,          
mobile,          
Src='Web','',''           
/*from [196.1.115.215].WebSite2.dbo.View_48FitnessLeads a left outer join           */   /*Commented on 05/07/2016 for changing source*/
from FEF_FitnessLeads a left outer join           
(select * from FEF_JDemail where src='Web') b on           
a.mobile=b.Phone          
where b.phone is null      
       
/*      
insert into FEF_JDemail(SenderEmailAddress,senton,Name,City,Phone,Src,DNC,phone1)       
select '',EnquiryDt,Enquiryname,'',MobileNo,Src='Gym','','' from FEF_EnquiryList a      
left outer join           
(select * from FEF_JDemail where src='Gym') b on           
a.MobileNo=b.Phone          
where b.phone is null          
*/      


update FEF_JDemail set FEF_MemberNo='',NoOfCalls=0,FEF_EnquiryNo=''   
/* For Update ph number */       
 update FEF_JDemail  set phone= replace(phone,'+91','')  
 update FEF_JDemail  set phone= replace(phone,'+910','')  
    
/*-----------------------*/
update FEF_JDemail set FEF_EnquiryNo=b.EnquiryNo,FEF_MemberNo=b.MemberNo,FEF_JDemail.NoOfCalls=b.NoofCalls        
from FEF_EnquiryList_vw b        
where b.mobileno=FEF_JDemail.phone  --and FEF_JDemail.FEF_EnquiryNo is null        
        
update FEF_JDemail set FEF_EnquiryNo=b.EnquiryNo,FEF_MemberNo=b.MemberNo,FEF_JDemail.NoOfCalls=FEF_JDemail.NoOfCalls+b.NoofCalls            
from FEF_EnquiryList_vw b        
where b.mobileno=FEF_JDemail.phone1 --and FEF_JDemail.FEF_EnquiryNo is null        
and isnull(FEF_JDemail.FEF_MemberNo,'')=''  
and isnull(FEF_JDemail.phone1,'')<>''   
  
update FEF_JDemail set FEF_MemberNo=b.MemeberNo        
from misc.dbo.FEF_Member_Details b        
where b.mobileno=FEF_JDemail.phone  and isnull(FEF_JDemail.phone,'') <> '' and  b.mobileno <> ''      
and isnull(FEF_JDemail.FEF_MemberNo,'')=''      
  
update FEF_JDemail set FEF_MemberNo=b.MemeberNo        
from misc.dbo.FEF_Member_Details b        
where b.mobileno=FEF_JDemail.phone1  and isnull(FEF_JDemail.phone1,'') <> '' and  b.mobileno <> ''      
and isnull(FEF_JDemail.FEF_MemberNo,'') = ''

          
END TRY                      
BEGIN CATCH                      
                      
 insert into risk.dbo.Appln_ERROR (ErrTime,ErrObject,ErrLine,ErrMessage,ApplnName,DBname)                                              
 select GETDATE(),'FEF_updJustDail',ERROR_LINE(),ERROR_MESSAGE(),'FEF JustDail Email Fetch',DB_NAME(db_id())                                              
            
 DECLARE @ErrorMessage NVARCHAR(4000);                                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                            
 RAISERROR (@ErrorMessage , 16, 1);                 
                      
END CATCH                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Update_Appointment
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Update_Appointment]
      @tblAppointment FEF_AppointmentType READONLY
AS
BEGIN
      SET NOCOUNT ON;
 
      MERGE INTO TestAppointment c1
      USING @tblAppointment c2
      ON c1.EnquiryNo=c2.EnquiryNo
      WHEN MATCHED THEN
      UPDATE SET c1.EnquiryName = c2.EnquiryName
            ,c1.MobileNo = c2.MobileNo
            ,c1.ReminderDate = c2.ReminderDate
            ,c1.Remark = c2.Remark
            ,c1.Appointment = c2.Appointment
            ,c1.Counseller = c2.Counseller
            ,c1.ReminderTime = c2.ReminderTime
      WHEN NOT MATCHED THEN
      INSERT VALUES(c2.EnquiryNo,c2.EnquiryName,c2.MobileNo,c2.ReminderDate,c2.Remark,c2.Appointment,c2.Counseller,c2.ReminderTime);
END

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
-- PROCEDURE dbo.Usp_VIS_MemberIndution
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[Usp_VIS_MemberIndution] 
  (
	@MemberName [varchar](50) ='',
	@MemberCode [varchar](50) ='',
	@Status [varchar](50) ='',
	@UpdatedOn [varchar](50) ='',
	@updateBy [varchar](50) =''      
  )
AS

BEGIN
Insert Into tbl_VIS_MemberIndution
(
	  [MemberName]
      ,[MemberCode]
      ,[Status]
      ,[UpdatedOn]
      ,[updateBy]
      
)
Values
		(
		@MemberName, 
		@MemberCode ,
		@Status, 
		Getdate(),
		@updateBy 
		)
		
		
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_BindItem
-- --------------------------------------------------
create procedure VIS_BindItem
as  
set nocount on  
  
select ItemId,Itemname from VIS_Item  group by ItemId,Itemname
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_CheckBarcode
-- --------------------------------------------------
CREATE Proc VIS_CheckBarcode(@Barcode as varchar(500))  
as  
set nocount on  
  
If Exists (select Barcode from VIS_StockEntry where Barcode=@Barcode)  
Begin  
 Select 'Please Enter another Barcode.'  
End  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_CheckSubItemName
-- --------------------------------------------------
CREATE Proc VIS_CheckSubItemName(@SubItemName as varchar(50))  
as  
set nocount on  
  
If Exists (select ItemSubType from VIS_SubItemMaster where ItemSubType=@SubItemName)  
Begin  
 Select 'Please Enter another SubItem'  
End  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_CheckVName
-- --------------------------------------------------

CREATE Proc VIS_CheckVName(@VName as varchar(50))
as
set nocount on

If Exists (select VocherName from VIS_Voucher where VocherName=@VName)
Begin
	Select 'Please Enter another voucher name.'
End
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ConsumptionRpt
-- --------------------------------------------------
CREATE proc [dbo].[VIS_ConsumptionRpt]  
(  
@memberNo varchar(11),  
@ItemId varchar(50),  
@Fromdate varchar(12),  
@Todate varchar(12),  
@ACCESS_TO AS VARCHAR(20),                      
@ACCESS_CODE AS VARCHAR(20),  
@UserName as varchar(20)=null  
)  
as                                      
set nocount on                                      
Begin    
if(@memberNo='0')  
Begin  
 set @memberNo='%%'  
End   
if(@ItemId='0')  
Begin  
 set @ItemId='%%'  
End   

select '00'+Convert(varchar(50),VouchToMemID) as VoucherNumber,a.MemberNo,a.MemberName,a.VoucherName,a.ItemName,a.MaxQty,a.Consumed,a.Pending 
from VIS_Reedumption  a  
where a.MemberNo like @memberNo and a.ItemId like @ItemId and a.Updatedon>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and a.Updatedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'
group by VouchToMemID,a.MemberNo,a.MemberName,a.VoucherName,a.ItemId,a.ItemName,a.MaxQty,a.Consumed,a.Pending,a.DateOfEntry  
  
  --print @memberNo  
  --print @ItemId  
  --print @Fromdate  
  --print  @Todate                              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Detail_ConsumptionRpt
-- --------------------------------------------------
--VIS_Detail_ConsumptionRpt '0','All','1 Apr 2019','31 Oct 2019','Broker','CSO'
CREATE proc [dbo].[VIS_Detail_ConsumptionRpt]  
(  
@memberNo varchar(11),  
@Item varchar(50),  
@Fromdate varchar(12),  
@Todate varchar(12),  
@ACCESS_TO AS VARCHAR(20),                      
@ACCESS_CODE AS VARCHAR(20),  
@UserName as varchar(20)=null  
)  
as                                      
set nocount on                                      
Begin    
 if(@memberNo='0')  
Begin  
 set @memberNo='%%'  
End   
if(@Item='All')  
Begin  
 set @Item='%%'  
End   

select distinct MemberNo,MemberName into #aa from VIS_MemberData_Service

select MemberNo,Max(CAST(ReceiptNO AS INT)) AS ReceiptNO into #MemberReceipt  from VIS_MemberData_Service  
group by MemberNo

select  a.* into #MemberService from  VIS_MemberData_Service a inner join #MemberReceipt b 
on a.MemberNo = b.MemberNo and a.ReceiptNO = b.ReceiptNO

select a.MemberNo as [Member No.],b.MemberName as [Member Name],'00'+Convert(varchar(50),VoucherNo) as [Voucher No.],RTRIM(LTRIM(VoucherName)) as [Voucher Name],'00'+Convert(varchar(50),OrderNo) as [Order No.],
Date AS [Order Date],Items,SubItem as [Sub Items],
Quantity as [Qty. Given],Barcode,UpdatedBy as [Redeemed By],
c.Planname,c.Startdt,c.Enddt
from VIS_ItemSale a left join #aa b on a.MemberNo=b.MemberNo 
left join #MemberService c WITH(NOLOCK) 
on a.MemberNo = c.MemberNo  
where a.MemberNo like @memberNo and Items like @Item

and Updatedon>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Updatedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'
--and (convert(datetime,c.Enddt,103) >= convert(datetime,@Fromdate,103))
 
group by Date,VoucherNo,a.MemberNo,VoucherName,Items,SubItem,Quantity,UpdatedBy,OrderNo,Barcode,b.memberName  ,c.Planname,c.Startdt,c.Enddt


drop table #aa
drop table #MemberReceipt
drop table #MemberService                         
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Detail_ConsumptionRpt_1
-- --------------------------------------------------
--VIS_Detail_ConsumptionRpt_1 '0','All','1 Apr 2019','31 Oct 2019','Broker','CSO'
CREATE proc [dbo].[VIS_Detail_ConsumptionRpt_1]  
(  
@memberNo varchar(11),  
@Item varchar(50),  
@Fromdate varchar(12),  
@Todate varchar(12),  
@ACCESS_TO AS VARCHAR(20),                      
@ACCESS_CODE AS VARCHAR(20),  
@UserName as varchar(20)=null  
)  
as                                      
set nocount on                                      
Begin    
if(@memberNo='0')  
Begin  
 set @memberNo='%%'  
End   
if(@Item='All')  
Begin  
 set @Item='%%'  
End   

select distinct MemberNo,MemberName into #aa from VIS_MemberData_Service

select a.MemberNo as [Member No.],b.MemberName as [Member Name],'00'+Convert(varchar(50),VoucherNo) as [Voucher No.],VoucherName as [Voucher Name],'00'+Convert(varchar(50),OrderNo) as [Order No.],
Date AS [Order Date],Items,SubItem as [Sub Items],
Quantity as [Qty. Given],Barcode,UpdatedBy as [Redeemed By],
c.Planname,c.Startdt,c.Enddt
from VIS_ItemSale a left join #aa b on a.MemberNo=b.MemberNo 
left join VIS_MemberData_Service c WITH(NOLOCK) 
on a.MemberNo = c.MemberNo
where a.MemberNo like @memberNo and Items like @Item and Updatedon>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Updatedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'
and convert(datetime,c.Enddt,103) >= convert(datetime,@Todate,103)
 
group by Date,VoucherNo,a.MemberNo,VoucherName,Items,SubItem,Quantity,UpdatedBy,OrderNo,Barcode,b.memberName  ,c.Planname,c.Startdt,c.Enddt
  
  --print @memberNo  
  --print @ItemId  
  --print @Fromdate  
  --print  @Todate                              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Detail_ConsumptionRpt_bkp10122019
-- --------------------------------------------------
--VIS_Detail_ConsumptionRpt '0','All','13 Feb 2017','14 Feb 2017','Broker','CSO'
create proc [dbo].[VIS_Detail_ConsumptionRpt_bkp10122019]  
(  
@memberNo varchar(11),  
@Item varchar(50),  
@Fromdate varchar(12),  
@Todate varchar(12),  
@ACCESS_TO AS VARCHAR(20),                      
@ACCESS_CODE AS VARCHAR(20),  
@UserName as varchar(20)=null  
)  
as                                      
set nocount on                                      
Begin    
if(@memberNo='0')  
Begin  
 set @memberNo='%%'  
End   
if(@Item='All')  
Begin  
 set @Item='%%'  
End   

select distinct MemberNo,MemberName into #aa from VIS_MemberData_Service

select a.MemberNo as [Member No.],b.MemberName as [Member Name],'00'+Convert(varchar(50),VoucherNo) as [Voucher No.],VoucherName as [Voucher Name],'00'+Convert(varchar(50),OrderNo) as [Order No.],
Date AS [Order Date],Items,SubItem as [Sub Items],
Quantity as [Qty. Given],Barcode,UpdatedBy as [Redeemed By]
from VIS_ItemSale a left join #aa b on a.MemberNo=b.MemberNo 
where a.MemberNo like @memberNo and Items like @Item and Updatedon>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Updatedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'
group by Date,VoucherNo,a.MemberNo,VoucherName,Items,SubItem,Quantity,UpdatedBy,OrderNo,Barcode,b.memberName  
  
  --print @memberNo  
  --print @ItemId  
  --print @Fromdate  
  --print  @Todate                              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Detail_ConsumptionRpt_Test
-- --------------------------------------------------
--VIS_Detail_ConsumptionRpt_Test '0','All','1 Apr 2019','31 Oct 2019','Broker','CSO'
CREATE proc [dbo].[VIS_Detail_ConsumptionRpt_Test]  
(  
@memberNo varchar(11),  
@Item varchar(50),  
@Fromdate varchar(12),  
@Todate varchar(12),  
@ACCESS_TO AS VARCHAR(20),                      
@ACCESS_CODE AS VARCHAR(20),  
@UserName as varchar(20)=null  
)  
as                                      
set nocount on                                      
Begin    
if(@memberNo='0')  
Begin  
 set @memberNo='%%'  
End   
if(@Item='All')  
Begin  
 set @Item='%%'  
End   

select distinct MemberNo,MemberName into #aa from VIS_MemberData_Service

select a.MemberNo as [Member No.],b.MemberName as [Member Name],'00'+Convert(varchar(50),VoucherNo) as [Voucher No.],VoucherName as [Voucher Name],'00'+Convert(varchar(50),OrderNo) as [Order No.],
Date AS [Order Date],Items,SubItem as [Sub Items],
Quantity as [Qty. Given],Barcode,UpdatedBy as [Redeemed By]
from VIS_ItemSale a left join #aa b on a.MemberNo=b.MemberNo 
where a.MemberNo like @memberNo and Items like @Item and Updatedon>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Updatedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'
group by Date,VoucherNo,a.MemberNo,VoucherName,Items,SubItem,Quantity,UpdatedBy,OrderNo,Barcode,b.memberName  
  
  --print @memberNo  
  --print @ItemId  
  --print @Fromdate  
  --print  @Todate                              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Edit_Servicing
-- --------------------------------------------------
create procedure VIS_Edit_Servicing(@Id as int)     
as      
set nocount on      
      
select * from VIS_Servicing where Id=@ID  
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_FurnishServicing
-- --------------------------------------------------
CREATE procedure VIS_get_FurnishServicing       
as        
set nocount on        
        
select Id,convert(varchar(11),UpdatedOn,101) as UpdatedOn,MemberName,MemberNo,ItemName,Item,SubItem,ReceiptNo,SubItemName,Approve,Quantity,Reason,Cancel,Flag from VIS_Servicing where Flag='Furnish'    
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_Item
-- --------------------------------------------------
CREATE procedure VIS_get_Item(@Vtype int)  
as  
set nocount on  

select ItemId,ItemName,VoucherType
 from VIS_Item where VoucherType=@Vtype
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_ItemVoucher
-- --------------------------------------------------
create procedure VIS_get_ItemVoucher  
as  
set nocount on  
  
select a.ItemId,a.ItemName,b.VoucherType
 from VIS_Item a left join VIS_VouchCategory  b on b.V_CatId=a.VoucherType
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_Member
-- --------------------------------------------------
CREATE procedure VIS_get_Member     
as      
set nocount on      
      
/*select memberNo,MemberName from VIS_MemberData_Service  group by memberNo,MemberName  
order by  MemberName   
*/  
select distinct memberNo,MemberName from VIS_MemberData_Service order by  MemberName  
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_OnlyVoucherName
-- --------------------------------------------------
CREATE  procedure VIS_get_OnlyVoucherName    
as      
set nocount on     
select  Distinct vocherName from VIS_Voucher    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_ReasonName
-- --------------------------------------------------
create procedure VIS_get_ReasonName  
as  
set nocount on  
  
select ID,VIssueReason from VIS_VouReasonMast  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_Servicing
-- --------------------------------------------------

CREATE procedure VIS_get_Servicing       
as        
set nocount on        
        
select Id,convert(varchar(11),UpdatedOn,101) as UpdatedOn,MemberName,MemberNo,ItemName,Item,SubItem,SubItemName,Checked,Approve,Quantity,Reason,Cancel,Flag from VIS_Servicing where Flag='Replace'     
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_StockMaster
-- --------------------------------------------------
CREATE procedure VIS_get_StockMaster  
as        
set nocount on        
        
select ROW_NUMBER() OVER ( ORDER BY a.stockId) AS SrNo,a.stockId,a.VoucherType,a.Item,a.SubItem,  
a.Quantity,d.ItemSubType,c.ItemName,b.voucherType as VoucherName,convert(varchar(10),a.Updatedon,103) as Updatedon  
 from VIS_StockMaintbl a left join VIS_VouchCategory  b on b.V_CatId=a.voucherType   
 left join VIS_Item c on  c.ItemId=a.Item  
 left join  VIS_SubItemMaster d on d.Id=a.SubItem   
 order by a.stockId

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_SubItem
-- --------------------------------------------------
CREATE procedure VIS_get_SubItem(@ItemId int)    
as    
set nocount on
	select Id,VoucherType,ItemId,ItemName,ItemSubType from VIS_SubItemMaster where ItemId=@ItemId
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_SubItemMast
-- --------------------------------------------------

CREATE procedure VIS_get_SubItemMast    
as    
set nocount on    
    
select a.Id,b.voucherType,a.ItemName,a.ItemSubType  
 from VIS_SubItemMaster a left join VIS_VouchCategory  b on b.V_CatId=a.voucherType  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_SubItemStock
-- --------------------------------------------------
CREATE procedure VIS_get_SubItemStock     
as      
set nocount on  
 select Id,VoucherType,ItemId,ItemName,ItemSubType from VIS_SubItemMaster 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_SubVoucher
-- --------------------------------------------------
CREATE procedure VIS_get_SubVoucher(@Vreason as int) 
as  
set nocount on  
select sum(subvouissue) as SubVoucher,vissuereason from VIS_VouReasonMast 
where ID=@Vreason group by vissuereason
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_Voucher
-- --------------------------------------------------
CREATE  procedure VIS_get_Voucher    
as      
set nocount on     
select Vid,vocherName,  
(Case when ItemStatus=1 then 'Active'      
when  ItemStatus=0 then 'InActive'      
end) as ItemStatus,PlanType,V_Limit,VType,ItemName,iTEMQuantity  
from VIS_Voucher    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_VoucherMember
-- --------------------------------------------------
create procedure VIS_get_VoucherMember   
as    
set nocount on    
    
select memberNo,MemberName from VIS_VoucherMember  group by memberNo,MemberName  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_VoucherReasonWise
-- --------------------------------------------------
  
CREATE  procedure VIS_get_VoucherReasonWise      
as        
set nocount on       
select distinct vochername from  VIS_Voucher           
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_VoucherType
-- --------------------------------------------------
create procedure VIS_get_VoucherType
as
set nocount on

select * from VIS_VouchCategory

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_get_VoucherWithPlan
-- --------------------------------------------------
create  procedure VIS_get_VoucherWithPlan(@Planname as varchar(100),@ReceiptNo as int)    
as      
set nocount on  
declare @IssueReason as int
   
select @IssueReason=IssueReason from VIS_Voucher where PlanType=@Planname 

exec VIS_GetVoucher_SubVoucher @IssueReason,@ReceiptNo
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_getItemsForEdit
-- --------------------------------------------------
CREATE Procedure [dbo].[VIS_getItemsForEdit](@orderno as int)          
as           
set nocount on        
/*        
select '00'+Convert(varchar(50),OrderNo) as OrderNo,Date,MemberNo,VoucherNo,Items,Quantity,Consumed,Pending,Status,UpdatedOn,UpdatedBy,VoucherName      
from VIS_ItemSale where orderno=Replace(Convert(varchar(50),@orderno),'00','')        
*/      
select '00'+Convert(varchar(50),a.OrderNo) as OrderNo,a.Date,a.MemberNo,'00'+Convert(varchar(50),a.VoucherNo) as VoucherNo,a.Quantity,a.Items,    
b.ItemId,b.MaxQty,b.Consumed,b.Pending,a.SubItem from VIS_ItemSale a join  VIS_Reedumption b on      
 a.VoucherNo=b.VouchToMemID  and a.Items=b.Itemname and a. MemberNo=b.Memberno       
 /*where a.orderno=Replace(Convert(varchar(50),@orderno),'00','')      */  
  where a.orderno=replace(ltrim(replace(@orderno,'0',' ')),' ','0')    
  
       
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetItemsForSale
-- --------------------------------------------------
CREATE Procedure VIS_GetItemsForSale(@VoucherNo as int)                  
as                   
set nocount on                  
select a.memberno,a.VouchToMemID,a.VoucherName,a.ItemName,a.Itemid,c.ItemSubtype,a.MaxQty,isnull(a.Consumed,0) as Consumed,a.Pending as pending from         
VIS_Reedumption a             
--join VIS_Voucher b                
--on a.VoucherName=b.VocherName         
join VIS_SubItemMaster c        
on  c.ItemId=a.ItemId             
where a.VouchToMemID=Replace(Convert(varchar(50),@VoucherNo),'00','')                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetItemsForSale_02apr2016
-- --------------------------------------------------
CREATE Procedure VIS_GetItemsForSale_02Apr2016(@VoucherNo as int)                
as                 
set nocount on                
select a.memberno,a.VouchToMemID,a.VoucherName,a.ItemName,a.Itemid,a.MaxQty,isnull(a.Consumed,0) as Consumed,a.Pending as pending 
,count(c.ItemId) as d from       
VIS_Reedumption a           
--join VIS_Voucher b              
--on a.VoucherName=b.VocherName       
join VIS_SubItemMaster c      
on  c.ItemId=a.ItemId           
where a.VouchToMemID=Replace(Convert(varchar(50),@VoucherNo),'00','') group by a.memberno,a.VouchToMemID,a.VoucherName,a.ItemName,a.Itemid,a.MaxQty,a.Consumed,a.Pending              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetItemsForSale_28Mar2016
-- --------------------------------------------------
CREATE Procedure VIS_GetItemsForSale_28Mar2016(@VoucherNo as int)          
as           
set nocount on          
select a.memberno,a.vouch_no,a.VoucherName,b.ItemName,b.Itemid,b.ItemQuantity,isnull(ItemConsumed,0) as Consumed,b.ItemPending as pending from VIS_VoucherMember a     
join VIS_Voucher b        
on a.VoucherName=b.VocherName       
where a.vouch_no=Replace(Convert(varchar(50),@VoucherNo),'00','')        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetItemsForSale_testing
-- --------------------------------------------------
CREATE Procedure [dbo].[VIS_GetItemsForSale_testing](@VoucherNo as int)                
as                 
set nocount on                
select a.memberno,a.VouchToMemID,a.VoucherName,a.ItemName,a.Itemid,a.MaxQty,isnull(a.Consumed,0) as Consumed,a.Pending as pending 
,count(c.ItemId) as d 
from       
VIS_Reedumption a           
--join VIS_Voucher b              
--on a.VoucherName=b.VocherName       
join VIS_SubItemMaster c      
on  c.ItemId=a.ItemId where 
/*a.VouchToMemID=Replace(Convert(varchar(50),@VoucherNo),'00','') */ /*Commented on 19 Dec 2016*/
a.VouchToMemID=replace(ltrim(replace(@VoucherNo,'0',' ')),' ','0') 
group by a.memberno,a.VouchToMemID,a.VoucherName,a.ItemName,a.Itemid,a.MaxQty,a.Consumed,a.Pending
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetMemberName
-- --------------------------------------------------
CREATE Procedure VIS_GetMemberName(@MemberNo as int)  
as   
set nocount on  
select distinct memberno,Membername from VIS_MemberData_Service where memberno=@MemberNo  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetRasonWithVoucher
-- --------------------------------------------------
Create Proc VIS_GetRasonWithVoucher 
as
set nocount on
select a.*,b.VocherName,c.VissueReason from VIS_SubVoucherMaster a join VIS_Voucher b on a.voucherid=b.Vid join
VIS_VouReasonMast c on a.ReasonId=c.id
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetStock_OnlyAlert
-- --------------------------------------------------
CREATE Proc VIS_GetStock_OnlyAlert(@Item as int=null)      
as      
set nocount on      
if @Item is null      
Begin      
 select a.*,b.StockAlert from VIS_StockMaintbl a join VIS_StockReminderMast b on a.subitem=b.itemsubtype      
/*join VIS_Item c on a.item=c.itemid        
 join VIS_SubItemMaster d on a.item=d.ItemId  */    
 where a.quantity<=b.stockAlert      
End      
else      
begin      
 select a.*,b.StockAlert from VIS_StockMaintbl a join VIS_StockReminderMast b on a.subitem=b.itemsubtype      
 /*join VIS_Item c on a.item=c.itemid        
 join VIS_SubItemMaster d on a.item=d.ItemId*/      
 where   a.SubItem=@Item    /* and a.quantity<=b.stockAlert*/  
End       
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetStockalert
-- --------------------------------------------------
CREATE Proc VIS_GetStockalert(@Item as int=null)    
as    
set nocount on    
if @Item is null    
Begin    
 select a.*,b.StockAlert from VIS_StockMaintbl a join VIS_StockReminderMast b on a.subitem=b.itemsubtype    
/*join VIS_Item c on a.item=c.itemid      
 join VIS_SubItemMaster d on a.item=d.ItemId  */  
 /*where a.quantity<=b.stockAlert    */
End    
else    
begin    
 select a.*,b.StockAlert from VIS_StockMaintbl a join VIS_StockReminderMast b on a.subitem=b.itemsubtype    
 /*join VIS_Item c on a.item=c.itemid      
 join VIS_SubItemMaster d on a.item=d.ItemId*/    
 where   a.SubItem=@Item    /* and a.quantity<=b.stockAlert*/
End     
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetStockalert_05Apr2016
-- --------------------------------------------------
CREATE Proc VIS_GetStockalert_05Apr2016(@Item as int=null)  
as  
set nocount on  
if @Item is null  
Begin  
 select a.*,c.Itemname,b.StockAlert,d.ItemSubType from VIS_StockEntry a join VIS_StockReminderMast b on a.subitem=b.itemsubtype  
 join VIS_Item c on a.item=c.itemid    
 join VIS_SubItemMaster d on a.item=d.ItemId  
 where a.quantity<=b.stockAlert  
End  
else  
begin  
 select a.*,c.Itemname,b.StockAlert,d.ItemSubType from VIS_StockEntry a join VIS_StockReminderMast b on a.subitem=b.itemsubtype  
 join VIS_Item c on a.item=c.itemid    
 join VIS_SubItemMaster d on a.item=d.ItemId  
 where a.quantity<=b.stockAlert and d.Id=@Item  
End   
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_getStockITem
-- --------------------------------------------------
create Proc VIS_getStockITem  
as
 select b.ItemName,a.SubItemName,a.barcode,a.updatedon,a.updatedby from  VIS_StockEntry a join VIS_Item b on a.Item=b.ItemId
 order by a.updatedon desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucher_SubVoucher
-- --------------------------------------------------
--VIS_GetVoucher_SubVoucher 47,18051
CREATE Procedure [dbo].[VIS_GetVoucher_SubVoucher](@Vreason as int,@ReceiptNo as int)                
as                
set nocount on 
  
   If exists (select * from VIS_VoucherMember  where recepitNo=@ReceiptNo and Issuereason=@Vreason and VoucherName not like 'Valentine%'  and VoucherName not like 'Couple Up%')  
   begin  
    /*select * from VIS_VoucherMember  where recepitNo=@ReceiptNo  and Issuereason<>2 */
    print 'hi'
    select 2
    return;  
   end  

	Else
	begin
	               
		select a.ReasonId,a.VoucherId,c.VocherName,b.VIssueReason,c.Plantype,c.V_Limit into #Voucher from VIS_SubVoucherMaster a  join VIS_VouReasonMast b on a.reasonId=b.Id                 
		join VIS_Voucher c on a.VoucherId=c.VID                
		where reasonId=@Vreason           
		        
		if (select Count(*) from #Voucher where vissuereason not in ('Referral','Management Gesture','Managment','refferal'))>=1        
		begin            
		 /*select b.* into #Vouch from MemberDump_15_Jan_2016 a join #Voucher b on a.[Receipt no]=@ReceiptNo      */    
		/*Commented by neha on 29 Jan 2017 suggested by Nikhil*/
		/* if Exists(select b.* from VIS_MemberData_Service a join #Voucher b on a.planname=b.Plantype and a.ReceiptNo=@ReceiptNo )  */
		 if Exists(select b.* from VIS_MemberData_Service a join #Voucher b on case when a.planname='Renewal 1 year' then 'Renewal 12 months' 
		                                                                            when a.planname='NEW MEMBERSHIP 13 MONTHS' then 'New Membership 12+1 Months' else a.planname end=b.Plantype and a.ReceiptNo=@ReceiptNo )  
		 begin  
		 /* select b.* into #Vouch from VIS_MemberData_Service a join #Voucher b on a.planname=b.Plantype and a.ReceiptNo=@ReceiptNo          */
		  select b.* into #Vouch from VIS_MemberData_Service a join #Voucher b on case when a.planname='Renewal 1 year' then 'Renewal 12 months'
																				 when a.planname='NEW MEMBERSHIP 13 MONTHS' then 'New Membership 12+1 Months' else a.planname end=b.Plantype and a.ReceiptNo=@ReceiptNo          
		  select distinct vochername,V_Limit from #Vouch 
		  print 'rr'          
		 end  
		 else  
		 begin  
		 print 'qq'
		 select 1  
		 end  
		end        
		else        
		begin  
			print 'nn'      
		 select distinct vochername,V_Limit from #Voucher        
		End              
       
      End         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucher_SubVoucher_08Feb2019
-- --------------------------------------------------

create Procedure [dbo].[VIS_GetVoucher_SubVoucher_08Feb2019](@Vreason as int,@ReceiptNo as int)                
as                
set nocount on 
  
	  
   If exists (select * from VIS_VoucherMember  where recepitNo=@ReceiptNo and Issuereason=@Vreason)  
   begin  
		/*select * from VIS_VoucherMember  where recepitNo=@ReceiptNo  and Issuereason<>2 */
		print 'hi'
		select 2
		return;  
   end  

	Else
	begin
	               
			select a.ReasonId,a.VoucherId,c.VocherName,b.VIssueReason,c.Plantype,c.V_Limit into #Voucher from VIS_SubVoucherMaster a  join VIS_VouReasonMast b on a.reasonId=b.Id                 
			join VIS_Voucher c on a.VoucherId=c.VID                
			where reasonId=@Vreason           
			        
			if (select Count(*) from #Voucher where vissuereason not in ('Referral','Management Gesture','Managment','refferal'))>=1        
			begin            
				 /*select b.* into #Vouch from MemberDump_15_Jan_2016 a join #Voucher b on a.[Receipt no]=@ReceiptNo      */    
				/*Commented by neha on 29 Jan 2017 suggested by Nikhil*/
				/* if Exists(select b.* from VIS_MemberData_Service a join #Voucher b on a.planname=b.Plantype and a.ReceiptNo=@ReceiptNo )  */
				 if Exists(select b.* from VIS_MemberData_Service a join #Voucher b on case when a.planname='Renewal 1 year' then 'Renewal 12 months' 
																							when a.planname='NEW MEMBERSHIP 13 MONTHS' then 'New Membership 12+1 Months' else a.planname end=b.Plantype and a.ReceiptNo=@ReceiptNo )  
				 begin  
						 /* select b.* into #Vouch from VIS_MemberData_Service a join #Voucher b on a.planname=b.Plantype and a.ReceiptNo=@ReceiptNo          */
						  select b.* into #Vouch from VIS_MemberData_Service a join #Voucher b on case when a.planname='Renewal 1 year' then 'Renewal 12 months'
																								 when a.planname='NEW MEMBERSHIP 13 MONTHS' then 'New Membership 12+1 Months' else a.planname end=b.Plantype and a.ReceiptNo=@ReceiptNo          
						  select distinct vochername,V_Limit from #Vouch 
						  print 'rr'          
				 end  
				 else  
				 begin  
					 print 'qq'
					 select 1  
				 end  
			end        
			else        
			begin  
				 print 'nn'      
				 select distinct vochername,V_Limit from #Voucher        
			End              
       
      End         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucher_SubVoucher_29_Mar_2016
-- --------------------------------------------------
CREATE Procedure VIS_GetVoucher_SubVoucher_29_Mar_2016(@Vreason as int)    
as    
set nocount on    
select a.ReasonId,a.VoucherId,c.VocherName,b.VIssueReason into #Voucher from VIS_SubVoucherMaster a  join VIS_VouReasonMast b on a.reasonId=b.Id     
join VIS_Voucher c on a.VoucherId=c.VID    
where reasonId=@Vreason  
  
select distinct vochername from #Voucher    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucher_SubVoucher_29Sep2016
-- --------------------------------------------------
CREATE Procedure VIS_GetVoucher_SubVoucher_29Sep2016(@Vreason as int,@ReceiptNo as int)              
as              
set nocount on              
select a.ReasonId,a.VoucherId,c.VocherName,b.VIssueReason,c.Plantype into #Voucher from VIS_SubVoucherMaster a  join VIS_VouReasonMast b on a.reasonId=b.Id               
join VIS_Voucher c on a.VoucherId=c.VID              
where reasonId=@Vreason         
      
if (select Count(*) from #Voucher where vissuereason not in ('Referral','Management Gesture','Managment','refferal'))>=1      
begin          
 /*select b.* into #Vouch from MemberDump_15_Jan_2016 a join #Voucher b on a.[Receipt no]=@ReceiptNo      */  
 select b.* into #Vouch from VIS_MemberData_Service a join #Voucher b on a.ReceiptNo=@ReceiptNo        
 select distinct vochername from #Vouch         
end      
else      
begin      
 select distinct vochername from #Voucher      
End            
             
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucher_SubVoucher_WithPlan
-- --------------------------------------------------
CREATE Procedure VIS_GetVoucher_SubVoucher_WithPlan(@IssueReason as int,@ReceiptNo as int)              
as              
set nocount on 
             
select a.ReasonId,a.VoucherId,c.VocherName,b.VIssueReason,c.Plantype into #Voucher from VIS_SubVoucherMaster a  join VIS_VouReasonMast b on a.reasonId=b.Id               
join VIS_Voucher c on a.VoucherId=c.VID              
where reasonId=@IssueReason         
   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucherEntry
-- --------------------------------------------------
CREATE Procedure VIS_GetVoucherEntry(@MemberNo as int)                  
as                   
set nocount on                  
            
select distinct convert(varchar(11),a.startdate,106) as dateofIssuing,              
Right('00' + CONVERT(NVARCHAR,a.Vouch_No), 50) as VoucherNo,a.VoucherName,           
/*b.ItemName,b.ItemQuantity,      */            
(Case when a.VStatus=1 then 'Active'       
when  a.VStatus=2 then 'Consumed'                 
when  a.VStatus=0 then 'InActive'                  
end) as Status from VIS_VoucherMember a join VIS_Voucher b on a.VoucherName=b.VocherName where a.memberNo=@MemberNo     
and     
(GETDATE() BETWEEN DateOfIssue AND VoucherEndDate)
and a.vstatus=1                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucherEntry_08Mar2018
-- --------------------------------------------------
CREATE Procedure VIS_GetVoucherEntry_08Mar2018(@MemberNo as int)                    
as                     
set nocount on                    
              
select distinct convert(varchar(11),a.startdate,106) as dateofIssuing,                
Right('00' + CONVERT(NVARCHAR,a.Vouch_No), 50) as VoucherNo,a.VoucherName,             
/*b.ItemName,b.ItemQuantity,      */              
(Case when a.VStatus=1 then 'Active'         
when  a.VStatus=2 then 'Consumed'                   
when  a.VStatus=0 then 'InActive'                    
end) as Status from VIS_VoucherMember a join VIS_Voucher b on a.VoucherName=b.VocherName where a.memberNo=@MemberNo       
and       
(GETDATE() BETWEEN DateOfIssue AND VoucherEndDate)  
and a.vstatus=1                   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucherEntry_test
-- --------------------------------------------------
create Procedure VIS_GetVoucherEntry_test(@MemberNo as int)        
as         
set nocount on        
  
select distinct convert(varchar(11),a.startdate,106) as dateofIssuing,    
/*Right('00' + CONVERT(NVARCHAR,a.Vouch_No), 50) as VoucherNo,  */      
VoucherNo='<A HREF =''http://196.1.115.183/AngelWellness/ForIncentive/VIS_ItemSale.aspx?VoucherNo='+
Right('00' + CONVERT(varchar,a.Vouch_No), 50) 
+    
'''>'+Right('00' + CONVERT(varchar,a.Vouch_No), 50)+'</A>'   ,
/*b.ItemName,b.ItemQuantity,      */  
(Case when b.ItemStatus=1 then 'Active'        
when  b.ItemStatus=0 then 'InActive'        
end) as Status from VIS_VoucherMember a join VIS_Voucher b on a.VoucherName=b.VocherName where a.memberNo=@MemberNo        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVoucherReason
-- --------------------------------------------------
create Procedure VIS_GetVoucherReason
as
set nocount on
	select Id,VissueReason from VIS_VouReasonMast
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_GetVReason
-- --------------------------------------------------
create procedure VIS_GetVReason  
as  
set nocount on  
  
select * from VIS_VouReasonMast  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Issue_Voucher_ToMember
-- --------------------------------------------------

CREATE procedure [dbo].[VIS_Issue_Voucher_ToMember]                                  
(                                    
--@VoucherNumber as int,                                  
@ReceiptNo as int,                                  
@MemberNo as int,                             
@MemberName as Varchar(50),                            
@ReasonId as varchar(50),                     
@IssueDate as Datetime,
@VLimit as int,                            
@ReferralId as varchar(50)=null,                        
@BuddyFormNo as varchar(50)=null,                           
@VoucherName as varchar(100)=null,                    
--@VoucherId as int,                    
@startDate as Datetime=null,                    
@UpdatedBy as Varchar(50)                    
)                                    
as                                    
set nocount on                                    
Begin          
           
Declare @Receipt as int, @voucherN as varchar(50),@VID as int,@refmemName as varchar(50)=''---,@IssueDate as datetime 

	DECLARE @selYear1 int,@date1 varchar(11) 	
	set @selYear1=year(current_timestamp)
	select @date1=REPLACE(@startDate, DATEPART(year, @startDate), @selYear1) 

declare @Endate as datetime
--set @IssueDate=getdate()
set @Endate= dateadd(day,@VLimit,@date1)
print @Endate      
       
/*if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and a.IssueReason=@ReasonId /*and b.VissueReason in ('12 Month Member','Referral','6 Months','3 months','1 Month','Renewal 12 months','Renewal 6 Months','Renewal 3 Months','Renewal 1 Month','complimentary')*/)             */
--If(@ReasonId<>2)
--begin
	if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and a.IssueReason=@ReasonId and memberno=@MemberNo and a.IssueReason<>2 )             
	Begin                                
		select a.MemberNo,a.MemberName,a.recepitno,a.VoucherName,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and a.IssueReason=@ReasonId and a.IssueReason<>2  /*and b.VissueReason in ('12 Month Member','Referral','6 Months','3 months','1 Month','Renewal 12 months','Renewal 6 Months','Renewal 3 Months','Renewal 1 Month','complimentary')            */
		print 'neha'
	End
--end	          
	Else          
	Begin  
		 If(@ReasonId=2)
		 begin
			select @refmemName=MemberName from VIS_MemberData_Service  where MemberNo=@MemberNo
			    
			 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			 UpdatedOn,UpdatedBy,VStatus,VoucherEndDate)                                     
			 select @MemberNo,@refmemName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,            
			 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                    
			 getdate(),@updatedby,1,@Endate   ;      
			/*Change on 11 May6 2016*/    
			WITH CTE AS    
			(    
			   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			   UpdatedOn,UpdatedBy,    
				   RN = ROW_NUMBER()OVER(PARTITION BY VoucherName,MemberNo,recepitNo ORDER BY VoucherName,MemberNo,recepitNo)    
			   FROM VIS_VoucherMember     
			)    
			delete from CTE WHERE RN > 1
		 end
		 else
		 begin
			--If exists (select * from VIS_VoucherMember  where recepitNo=@ReceiptNo)
			--begin
			--	select * from VIS_VoucherMember  where recepitNo=@ReceiptNo
			--	return;
			--end
			--else
			--begin       
			 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			 UpdatedOn,UpdatedBy,VStatus,VoucherEndDate,vlimit)                                     
			 select @MemberNo,@MemberName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,            
			 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                    
			 getdate(),@updatedby,1,@Endate,@VLimit   ;      
			/*Change on 11 May6 2016*/    
		    
			WITH CTE AS    
			(    
			   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			   UpdatedOn,UpdatedBy,    
				   RN = ROW_NUMBER()OVER(PARTITION BY VoucherName,MemberNo,recepitNo ORDER BY VoucherName,MemberNo,recepitNo)    
			   FROM VIS_VoucherMember     
			)    
			delete from CTE WHERE RN > 1   
		 end
			--end
/*Change on 11 May6 2016*/        
     
 /* declare @srno as int           
  select @srno=scope_Identity()            
   */      
		 truncate table VIS_testing    
		 insert into VIS_testing(Vochername,ItemId,ItemName,ItemQuantity,ItemConsumed,ItemPending,Vouch_No,MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,VoucherId,StartDate,UpdatedOn,UpdatedBy,VEnddate)      
		 select a.Vochername,a.ItemId,a.ItemName,a.ItemQuantity,a.ItemConsumed,a.ItemPending,b.Vouch_No,b.MemberNo,b.MemberName,b.recepitNo,b.IssueReason,b.DateOfIssue,b.ReferralId,b.BuddyFormNo,b.VoucherName,b.VoucherId,b.StartDate,b.UpdatedOn,b.UpdatedBy,b.VoucherEndDate     
		 from VIS_Voucher a join VIS_VoucherMember b on a.vochername=b.vouchername
		 where b.recepitno=@ReceiptNo and b.memberno=@MemberNo             
		         
		 insert into VIS_Reedumption(VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,receiptNo,StartDate,EnddateVouch)        
		 select Vouch_No,MemberNo,MemberName,getdate(),UpdatedBy,VoucherName,ItemId,ItemName,ItemQuantity,isnull(ItemConsumed,0),ItemPending,UpdatedOn,UpdatedBy,recepitNo,StartDate,VEnddate          
		 from VIS_testing where recepitno=@ReceiptNo and memberno=@MemberNo;       
    
			 WITH CTE AS    
			(    
			   SELECT VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,receiptNo,StartDate,EnddateVouch,    
				   RN = ROW_NUMBER()OVER(PARTITION BY VouchToMemID,MemberNo,ItemName,receiptNo ORDER BY VouchToMemID,ItemName,MemberNo,receiptNo)    
			   FROM VIS_Reedumption     
			)    
			delete  from CTE WHERE RN > 1  

		/*for inserting data for pre session entry*/
		If Exists(select * from VIS_Reedumption where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo)
		Begin
			select * into #Birth from VIS_Reedumption where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			update VIS_Reedumption set Consumed=MaxQty where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			
			DECLARE @selYear int,@date varchar(11),@enddt date 
			select @date=CASE WHEN CAST(convert(varchar(10),DATEADD(YEAR,DATEDIFF(YEAR, Birthdate, GETDATE()), Birthdate), 111) AS DATETIME) 
			< CAST(convert(varchar(10),GETDATE(), 111) AS DATETIME) THEN
			DATEADD(YEAR,DATEDIFF(YEAR, Birthdate, GETDATE()) + 1, Birthdate) ELSE DATEADD(YEAR,DATEDIFF(YEAR, Birthdate, GETDATE()), Birthdate) END
			 from VIS_MemberData_Service where  receiptNo=@ReceiptNo and MemberNo=@MemberNo	
			/*commented on 02 Mar 2017*/
			/*select @selYear=year(startdt) from VIS_MemberData_Service where  receiptNo=@ReceiptNo  and MemberNo=@MemberNo
			select @date=REPLACE(StartDate, DATEPART(year, StartDate), @selYear) from #Birth
			*/
			
			/*Inserted on 01 Feb 2018*/
			set @enddt=dateadd(dd,15,@date)
			
			Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,EndDate)  
			select @date,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,@enddt from #Birth
			/*select @date,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,EnddateVouch from #Birth*/
		End
		If Exists(select * from VIS_Reedumption where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo)
		Begin
			select * into #Comp from VIS_Reedumption where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			update VIS_Reedumption set Consumed=MaxQty where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,EndDate)  
			select StartDate,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,EnddateVouch from #Comp
		End
		If Exists(select * from VIS_Reedumption where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo)
		Begin
			select * into #Induction from VIS_Reedumption where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			update VIS_Reedumption set Consumed=MaxQty where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,EndDate)  
			select StartDate,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,EnddateVouch from #Induction;
		End;

		WITH CTE AS    
		(    
		   SELECT Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,OrderNo,EndDate,    
			   RN = ROW_NUMBER()OVER(PARTITION BY MemberNo,VoucherNo,VoucherName,Items ORDER BY MemberNo,VoucherNo,VoucherName,Items)    
		   FROM  MISC.dbo.VIS_Timesheet     
		)    
		delete  from CTE WHERE RN > 1
/*End*/   

/*For Executing mail to member*/
/*Exec VIS_VoucherEmail @MemberNo,@ReceiptNo*/
         
End          
          
                               
End                                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Issue_Voucher_ToMember_08Sep2016
-- --------------------------------------------------

create procedure [dbo].[VIS_Issue_Voucher_ToMember_08Sep2016]                                  
(                                    
--@VoucherNumber as int,                                  
@ReceiptNo as int,                                  
@MemberNo as int,                             
@MemberName as Varchar(50),                            
@ReasonId as varchar(50),                     
@IssueDate as Datetime,                            
@ReferralId as varchar(50)=null,                        
@BuddyFormNo as varchar(50)=null,                           
@VoucherName as varchar(100)=null,                    
--@VoucherId as int,                    
@startDate as Datetime=null,                    
@UpdatedBy as Varchar(50)                    
)                                    
as                                    
set nocount on                                    
Begin          
           
Declare @Receipt as int, @voucherN as varchar(50),@VID as int          
          
if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and b.VissueReason in ('12 Month Member','Referral'))             
Begin                                
    select a.MemberNo,a.MemberName,a.recepitno,a.VoucherName,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and b.VissueReason in ('12 Month Member','Referral')            
End          
Else          
Begin          
 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
 UpdatedOn,UpdatedBy)                                     
 select @MemberNo,@MemberName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,            
 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                    
 getdate(),@updatedby   ;      
/*Change on 11 May6 2016*/    
    
WITH CTE AS    
(    
   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
   UpdatedOn,UpdatedBy,    
       RN = ROW_NUMBER()OVER(PARTITION BY VoucherName,MemberNo,recepitNo ORDER BY VoucherName,MemberNo,recepitNo)    
   FROM VIS_VoucherMember     
)    
delete from CTE WHERE RN > 1    
/*Change on 11 May6 2016*/        
     
 /* declare @srno as int           
  select @srno=scope_Identity()            
   */      
 truncate table VIS_testing    
 insert into VIS_testing(Vochername,ItemId,ItemName,ItemQuantity,ItemConsumed,ItemPending,Vouch_No,MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,VoucherId,StartDate,UpdatedOn,UpdatedBy)      
 select a.Vochername,a.ItemId,a.ItemName,a.ItemQuantity,a.ItemConsumed,a.ItemPending,b.Vouch_No,b.MemberNo,b.MemberName,b.recepitNo,b.IssueReason,b.DateOfIssue,b.ReferralId,b.BuddyFormNo,b.VoucherName,b.VoucherId,b.StartDate,b.UpdatedOn,b.UpdatedBy     
 from VIS_Voucher a join VIS_VoucherMember b on a.vochername=b.vouchername        
         
         
 insert into VIS_Reedumption(VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,receiptNo)        
 select Vouch_No,MemberNo,MemberName,getdate(),UpdatedBy,VoucherName,ItemId,ItemName,ItemQuantity,isnull(ItemConsumed,0),ItemPending,UpdatedOn,UpdatedBy,recepitNo          
 from VIS_testing ;       
    
 WITH CTE AS    
(    
   SELECT VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,receiptNo,    
       RN = ROW_NUMBER()OVER(PARTITION BY VouchToMemID,MemberNo,ItemName,receiptNo ORDER BY VouchToMemID,ItemName,MemberNo,receiptNo)    
   FROM VIS_Reedumption     
)    
delete  from CTE WHERE RN > 1     

/*For Executing mail to member*/
Exec VIS_VoucherEmail @MemberNo,@ReceiptNo
         
End          
          
                               
End                                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Issue_Voucher_ToMember_11052016_56PM
-- --------------------------------------------------
CREATE procedure [dbo].[VIS_Issue_Voucher_ToMember_11052016_56PM]                                
(                                  
--@VoucherNumber as int,                                
@ReceiptNo as int,                                
@MemberNo as int,                           
@MemberName as Varchar(50),                          
@ReasonId as varchar(50),                   
@IssueDate as Datetime,                          
@ReferralId as varchar(50)=null,                      
@BuddyFormNo as varchar(50)=null,                         
@VoucherName as varchar(100)=null,                  
--@VoucherId as int,                  
@startDate as Datetime=null,                  
@UpdatedBy as Varchar(50)                  
)                                  
as                                  
set nocount on                                  
Begin        
         
Declare @Receipt as int, @voucherN as varchar(50),@VID as int        
        
if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and b.VissueReason in ('12 Month Member','Referral'))           
Begin                              
    select a.MemberNo,a.MemberName,a.recepitno,a.VoucherName,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and b.VissueReason in ('12 Month Member','Referral')          
End        
Else        
Begin        
 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                  
 UpdatedOn,UpdatedBy)                                   
 select @MemberNo,@MemberName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,          
 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                  
 getdate(),@updatedby   ;    
/*Change on 11 May6 2016*/  
  
WITH CTE AS  
(  
   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                  
   UpdatedOn,UpdatedBy,  
       RN = ROW_NUMBER()OVER(PARTITION BY VoucherName ORDER BY VoucherName)  
   FROM VIS_VoucherMember   
)  
delete from CTE WHERE RN > 1  
/*Change on 11 May6 2016*/      
   
 /* declare @srno as int         
  select @srno=scope_Identity()          
   */    
 truncate table VIS_testing  
 insert into VIS_testing    
 select a.Vochername,a.ItemId,a.ItemName,a.ItemQuantity,a.ItemConsumed,a.ItemPending,b.*   
 from VIS_Voucher a join VIS_VoucherMember b on a.vochername=b.vouchername      
       
       
 insert into VIS_Reedumption(VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy)      
 select Vouch_No,MemberNo,MemberName,getdate(),UpdatedBy,VoucherName,ItemId,ItemName,ItemQuantity,isnull(ItemConsumed,0),ItemPending,UpdatedOn,UpdatedBy        
 from VIS_testing ;     
  
-- WITH CTE AS  
--(  
--   SELECT VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,  
--       RN = ROW_NUMBER()OVER(PARTITION BY MemberNo,ItemName ORDER BY ItemName,MemberNo)  
--   FROM VIS_Reedumption   
--)  
--delete  from CTE WHERE RN > 1   
       
End        
        
                             
End                                  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Issue_Voucher_ToMember_11Mar2016
-- --------------------------------------------------
CREATE procedure VIS_Issue_Voucher_ToMember_11Mar2016                        
(                          
--@VoucherNumber as int,                        
@ReceiptNo as int,                        
@MemberNo as int,                   
@MemberName as Varchar(50),                  
@ReasonId as varchar(50),           
@IssueDate as Datetime,                  
@ReferralId as varchar(50)=null,              
@BuddyFormNo as varchar(50)=null,                 
@VoucherName as varchar(20)=null,          
--@VoucherId as int,          
@startDate as Datetime,          
@UpdatedBy as Varchar(50)          
)                          
as                          
set nocount on                          
Begin
 
Declare @Receipt as int, @voucherN as varchar(50),@VID as int

if exists(select * from VIS_VoucherMember where recepitNo=@ReceiptNo and VoucherName=@VoucherName)   
Begin                      
     Select 1   
End
Else
Begin
	insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,          
	UpdatedOn,UpdatedBy)                           
	select @MemberNo,@MemberName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,  
	@VoucherName,cast(convert(datetime,@startDate, 103) as date),          
	getdate(),@updatedby 
End

                     
End                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Issue_Voucher_ToMember_11May2016
-- --------------------------------------------------
create procedure [dbo].[VIS_Issue_Voucher_ToMember_11May2016]                              
(                                
--@VoucherNumber as int,                              
@ReceiptNo as int,                              
@MemberNo as int,                         
@MemberName as Varchar(50),                        
@ReasonId as varchar(50),                 
@IssueDate as Datetime,                        
@ReferralId as varchar(50)=null,                    
@BuddyFormNo as varchar(50)=null,                       
@VoucherName as varchar(100)=null,                
--@VoucherId as int,                
@startDate as Datetime=null,                
@UpdatedBy as Varchar(50)                
)                                
as                                
set nocount on                                
Begin      
       
Declare @Receipt as int, @voucherN as varchar(50),@VID as int      
      
if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and b.VissueReason in ('12 Month Member','Referral'))         
Begin                            
    select a.MemberNo,a.MemberName,a.recepitno,a.VoucherName,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and b.VissueReason in ('12 Month Member','Referral')        
End      
Else      
Begin      
 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                
 UpdatedOn,UpdatedBy)                                 
 select @MemberNo,@MemberName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,        
 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                
 getdate(),@updatedby   ;  
/*Change on 11 May6 2016*/

WITH CTE AS
(
   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                
			UpdatedOn,UpdatedBy,
       RN = ROW_NUMBER()OVER(PARTITION BY VoucherName ORDER BY VoucherName)
   FROM VIS_VoucherMember 
)
delete from CTE WHERE RN > 1
/*Change on 11 May6 2016*/    
 
  declare @srno as int       
  select @srno=scope_Identity()        
     
 select a.Vochername,a.ItemId,a.ItemName,a.ItemQuantity,a.ItemConsumed,a.ItemPending,b.* into #aa    
 from VIS_Voucher a join VIS_VoucherMember b on a.vochername=b.vouchername    
     
     
 insert into VIS_Reedumption(VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy)    
 select @srno,MemberNo,MemberName,getdate(),UpdatedBy,VoucherName,ItemId,ItemName,ItemQuantity,isnull(ItemConsumed,0),ItemPending,UpdatedOn,UpdatedBy      
 from #aa    
    
End      
      
                           
End                                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Issue_Voucher_ToMember_testing
-- --------------------------------------------------

CREATE procedure [dbo].[VIS_Issue_Voucher_ToMember_testing]                                  
(                                    
--@VoucherNumber as int,                                  
@ReceiptNo as int,                                  
@MemberNo as int,                             
@MemberName as Varchar(50),                            
@ReasonId as varchar(50),                     
@IssueDate as Datetime,
@VLimit as int,                            
@ReferralId as varchar(50)=null,                        
@BuddyFormNo as varchar(50)=null,                           
@VoucherName as varchar(100)=null,                    
--@VoucherId as int,                    
@startDate as Datetime=null,                    
@UpdatedBy as Varchar(50)                    
)                                    
as                                    
set nocount on                                    
Begin          
           
Declare @Receipt as int, @voucherN as varchar(50),@VID as int,@refmemName as varchar(50)=''---,@IssueDate as datetime 

	DECLARE @selYear1 int,@date1 varchar(11) 	
	set @selYear1=year(current_timestamp)
	select @date1=REPLACE(@startDate, DATEPART(year, @startDate), @selYear1) 

declare @Endate as datetime
--set @IssueDate=getdate()
set @Endate= dateadd(day,@VLimit,@date1)
print @Endate      
       
/*if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and a.IssueReason=@ReasonId /*and b.VissueReason in ('12 Month Member','Referral','6 Months','3 months','1 Month','Renewal 12 months','Renewal 6 Months','Renewal 3 Months','Renewal 1 Month','complimentary')*/)             */
--If(@ReasonId<>2)
--begin
	if exists(select a.*,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and a.IssueReason=@ReasonId and a.IssueReason<>2 )             
	Begin                                
		select a.MemberNo,a.MemberName,a.recepitno,a.VoucherName,b.VissueReason from VIS_VoucherMember a join VIS_VouReasonMast b on a.IssueReason=b.Id where a.recepitNo=@ReceiptNo and a.VoucherName=@VoucherName and a.IssueReason=@ReasonId and a.IssueReason<>2  /*and b.VissueReason in ('12 Month Member','Referral','6 Months','3 months','1 Month','Renewal 12 months','Renewal 6 Months','Renewal 3 Months','Renewal 1 Month','complimentary')            */
	End
--end	          
	Else          
	Begin  
		 If(@ReasonId=2)
		 begin
			select @refmemName=MemberName from VIS_MemberData_Service  where MemberNo=@MemberNo
			    
			 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			 UpdatedOn,UpdatedBy,VStatus,VoucherEndDate)                                     
			 select @MemberNo,@refmemName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,            
			 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                    
			 getdate(),@updatedby,1,@Endate   ;      
			/*Change on 11 May6 2016*/    
			WITH CTE AS    
			(    
			   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			   UpdatedOn,UpdatedBy,    
				   RN = ROW_NUMBER()OVER(PARTITION BY VoucherName,MemberNo,recepitNo ORDER BY VoucherName,MemberNo,recepitNo)    
			   FROM VIS_VoucherMember     
			)    
			delete from CTE WHERE RN > 1
		 end
		 else
		 begin
			--If exists (select * from VIS_VoucherMember  where recepitNo=@ReceiptNo)
			--begin
			--	select * from VIS_VoucherMember  where recepitNo=@ReceiptNo
			--	return;
			--end
			--else
			--begin       
			 insert into VIS_VoucherMember(MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			 UpdatedOn,UpdatedBy,VStatus,VoucherEndDate,vlimit)                                     
			 select @MemberNo,@MemberName,@ReceiptNo,@ReasonId,cast(convert(datetime,@IssueDate, 103) as date),@ReferralId,@BuddyFormNo,            
			 @VoucherName,cast(convert(datetime,@startDate, 103) as date),                    
			 getdate(),@updatedby,1,@Endate,@VLimit   ;      
			/*Change on 11 May6 2016*/    
		    
			WITH CTE AS    
			(    
			   SELECT MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,StartDate,                    
			   UpdatedOn,UpdatedBy,    
				   RN = ROW_NUMBER()OVER(PARTITION BY VoucherName,MemberNo,recepitNo ORDER BY VoucherName,MemberNo,recepitNo)    
			   FROM VIS_VoucherMember     
			)    
			delete from CTE WHERE RN > 1   
		 end
			--end
/*Change on 11 May6 2016*/        
     
 /* declare @srno as int           
  select @srno=scope_Identity()            
   */      
		 truncate table VIS_testing    
		 insert into VIS_testing(Vochername,ItemId,ItemName,ItemQuantity,ItemConsumed,ItemPending,Vouch_No,MemberNo,MemberName,recepitNo,IssueReason,DateOfIssue,ReferralId,BuddyFormNo,VoucherName,VoucherId,StartDate,UpdatedOn,UpdatedBy,VEnddate)      
		 select a.Vochername,a.ItemId,a.ItemName,a.ItemQuantity,a.ItemConsumed,a.ItemPending,b.Vouch_No,b.MemberNo,b.MemberName,b.recepitNo,b.IssueReason,b.DateOfIssue,b.ReferralId,b.BuddyFormNo,b.VoucherName,b.VoucherId,b.StartDate,b.UpdatedOn,b.UpdatedBy,b.VoucherEndDate     
		 from VIS_Voucher a join VIS_VoucherMember b on a.vochername=b.vouchername
		 where b.recepitno=@ReceiptNo and b.memberno=@MemberNo             
		         
		 insert into VIS_Reedumption(VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,receiptNo,StartDate,EnddateVouch)        
		 select Vouch_No,MemberNo,MemberName,getdate(),UpdatedBy,VoucherName,ItemId,ItemName,ItemQuantity,isnull(ItemConsumed,0),ItemPending,UpdatedOn,UpdatedBy,recepitNo,StartDate,VEnddate          
		 from VIS_testing where recepitno=@ReceiptNo and memberno=@MemberNo;       
    
			 WITH CTE AS    
			(    
			   SELECT VouchToMemID,MemberNo,MemberName,DateOfentry,Employee,VoucherName,ItemId,ItemName,MaxQty,Consumed,Pending,UpdatedOn,UpdateBy,receiptNo,StartDate,EnddateVouch,    
				   RN = ROW_NUMBER()OVER(PARTITION BY VouchToMemID,MemberNo,ItemName,receiptNo ORDER BY VouchToMemID,ItemName,MemberNo,receiptNo)    
			   FROM VIS_Reedumption     
			)    
			delete  from CTE WHERE RN > 1  

		/*for inserting data for pre session entry*/
		If Exists(select * from VIS_Reedumption where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo)
		Begin
			select * into #Birth from VIS_Reedumption where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			update VIS_Reedumption set Consumed=MaxQty where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName='Birthday Session' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			
			DECLARE @selYear int,@date varchar(11),@enddt date 
			select @date=CASE WHEN CAST(convert(varchar(10),DATEADD(YEAR,DATEDIFF(YEAR, Birthdate, GETDATE()), Birthdate), 111) AS DATETIME) 
			< CAST(convert(varchar(10),GETDATE(), 111) AS DATETIME) THEN
			DATEADD(YEAR,DATEDIFF(YEAR, Birthdate, GETDATE()) + 1, Birthdate) ELSE DATEADD(YEAR,DATEDIFF(YEAR, Birthdate, GETDATE()), Birthdate) END
			 from VIS_MemberData_Service where  receiptNo=@ReceiptNo and MemberNo=@MemberNo	
			/*commented on 02 Mar 2017*/
			/*select @selYear=year(startdt) from VIS_MemberData_Service where  receiptNo=@ReceiptNo  and MemberNo=@MemberNo
			select @date=REPLACE(StartDate, DATEPART(year, StartDate), @selYear) from #Birth
			*/
			
			/*Inserted on 01 Feb 2018*/
			set @enddt=dateadd(dd,15,@date)
			
			Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,EndDate)  
			select @date,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,@enddt from #Birth
			/*select @date,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,EnddateVouch from #Birth*/
		End
		If Exists(select * from VIS_Reedumption where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo)
		Begin
			select * into #Comp from VIS_Reedumption where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			update VIS_Reedumption set Consumed=MaxQty where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName='Complimentary PT' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,EndDate)  
			select StartDate,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,EnddateVouch from #Comp
		End
		If Exists(select * from VIS_Reedumption where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo)
		Begin
			select * into #Induction from VIS_Reedumption where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			update VIS_Reedumption set Consumed=MaxQty where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName='Induction' and receiptNo=@ReceiptNo and MemberNo=@MemberNo
			
			Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,EndDate)  
			select StartDate,MemberNo,VouchToMemId,ItemName,MaxQty,UpdatedOn,UpdateBy,VoucherName,EnddateVouch from #Induction;
		End;

		WITH CTE AS    
		(    
		   SELECT Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,OrderNo,EndDate,    
			   RN = ROW_NUMBER()OVER(PARTITION BY MemberNo,VoucherNo,VoucherName,Items ORDER BY MemberNo,VoucherNo,VoucherName,Items)    
		   FROM  MISC.dbo.VIS_Timesheet     
		)    
		delete  from CTE WHERE RN > 1
/*End*/   

/*For Executing mail to member*/
/*Exec VIS_VoucherEmail @MemberNo,@ReceiptNo*/
         
End          
          
                               
End                                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Item_Delete
-- --------------------------------------------------

CREATE Procedure VIS_Item_Delete  
(    
  --variable  declareations     
 @Action Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select          
 @id int=null,    --id to perform specific task    
 @VType int=null,  
 @Item varchar(20)=null  
)    
as    
Begin     
  SET NOCOUNT ON;    
if @Action='Select'   --used to Select records    
Begin    
    select * from VIS_Item    
end    
Else If @Action='Delete'  --used to delete records    
 Begin    
   delete from VIS_Item where ItemId=@id    
 end    
Else If @Action='Update'  --used to update records    
 Begin    
   update VIS_Item set ItemName=@Item,VoucherType=@VType where ItemId=@id    
 end     
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemBindOnVoucher
-- --------------------------------------------------
CREATE procedure VIS_ItemBindOnVoucher(@VId as int,@memberno as varchar(20))    
as      
set nocount on      
      
select a.ItemId,a.Itemname from VIS_voucher a join VIS_VoucherMember b on a.vochername=b.Vouchername    
where a.vid=@VId and b.memberno=@memberno group by ItemId,Itemname   
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemMaster
-- --------------------------------------------------
CREATE procedure VIS_ItemMaster    
(    
@ItemName as varchar(20),  
@VType as varchar(20),
@UpdatedBy as varchar(50)     
)    
as    
set nocount on    
Begin    
insert into VIS_Item(ItemName,VoucherType,Updatedon,UpdatedBy)     
select  @ItemName,@VType,getdate(),@UpdatedBy    
End    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemSale_Entry
-- --------------------------------------------------
CREATE procedure [dbo].[VIS_ItemSale_Entry]                            
(                                                
@MemberNo as int,               
@date as varchar(11),               
@VoucherNo as int,               
@Items as varchar(50),        
@SubItems as varchar(50),     
@SubItemId as int,                    
@Quantity as int,
@Barcode as varchar(100),                        
@Consumed as int,                 
@Pending as int,                        
@UpdatedBy as Varchar(50),            
@VoucherName as varchar(50),            
@ItemId as int                
)                                
as                                
set nocount on                                
Begin                                
insert into VIS_ItemSale(MemberNo,Date,VoucherNo,Items,Quantity,Consumed,Pending,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,Barcode)                                 
select @MemberNo,@date,@VoucherNo,@Items,@Quantity,@Consumed,@Pending,getdate(),@updatedby,@VoucherName,@SubItems,@SubItemId,@Barcode 
            
update VIS_Reedumption set Consumed=Consumed+@Quantity where ItemName=@Items and vouchername=@VoucherName and ItemId=@ItemId and memberNo=@MemberNo and  VouchToMemID=@VoucherNo         
update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName=@Items and vouchername=@VoucherName  and ItemId=@ItemId and memberNo=@MemberNo and  VouchToMemID=@VoucherNo           
            
/*update VIS_StockEntry set Quantity=Quantity-@Quantity where Item=@ItemId    */        
update VIS_StockMaintbl set Quantity=Quantity-@Quantity where Item=@ItemId  and subItemName= @SubItems and subItem=@SubItemId  

DECLARE @Emp_name as varchar(100),@emp_email as varchar(100),@Expirydate as varchar(11)              
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)
/*declare @Membercode varchar(50)='23262'*/

select @emp_email=email1,@Emp_name=membername from VIS_MemberData_Service where Memberno=@MemberNo group by email1,membername
set @emp_email='info@48fitness.in;'+@emp_email

 SELECT @emailto=@emp_email              
 SELECT @emailcc='info@48fitness.in'             
 SELECT @emailbcc='48fitnessaccounts@angelbroking.com;jayashree.shetty@48fitness.in;Faheed.Hasware@48fitness.in;rajdeep.chakroborty@angelbroking.com' 
  --SELECT @emailbcc='rajdeep.chakroborty@angelbroking.com' 

  declare @OrderId as int                  
  set @OrderId=scope_Identity()
  --set @OrderId='00'+Convert(varchar(50),@OrderId)
  /*---For Inserting in Time sheet----*/                   
/*
If (@Items='Induction')
begin
	Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,OrderNo)
	select @date,@MemberNo,@VoucherNo,@Items,@Quantity,getdate(),@updatedby,@VoucherName,@SubItems,@SubItemId,@OrderId
end
*/
/*---For Inserting in Time sheet----*/
  --print @OrderId
 
 declare @Pen int ,@MaxQty int,@Consum int    
 select @Pen=Pending,@MaxQty=MaxQty,@Consum=Consumed from VIS_Reedumption  where ItemName=@Items and vouchername=@VoucherName  and ItemId=@ItemId and memberNo=@MemberNo       

SET @MESS='<b><font size="4" color="#FF4500">Dear '+@Emp_name+', </font></b><br><Br>'                
SET @MESS=@MESS+'<p align="justify">Your order for Item(s) - '+@SubItems+'(s) is confirmed. Therefore, kindly be informed that your updated account status is :</p>'            
if(@Items='Spa')
Begin
	SET @MESS=@MESs+'<Br><Table  width="100%"><tr bgcolor="#e60000"><td align="Center"><font color="#fff"><b>Item(s)</b></font></td><td align="Center"><font color="#fff"><b>Allotted</b></font></td></tr><tr align="Center" bgcolor=#D3D3D3><td >'+ @Items + '</td><td>' +Convert(varchar(50),@MaxQty)+'</td></tr></Table><BR>' 
End
Else
Begin
	SET @MESS=@MESs+'<Br><Table  width="100%"><tr bgcolor="#e60000"><td align="Center"><font color="#fff"><b>Item(s)</b></font></td><td align="Center"><font color="#fff"><b>Allotted</b></font></td><td align="Center"><font color="#fff"><b>Redeemed Today</b></font></td><td align="Center"><font color="#fff"><b>Total Redeemed</b></font></td><td align="Center"><font color="#fff"><b>Unredeemed</b></font></td></tr><tr align="Center" bgcolor=#D3D3D3><td >'+ @Items + '</td><td>' +Convert(varchar(50),@MaxQty)+'</td><td>' + Convert(varchar(50),@Quantity)+'</td><td>'+ Convert(varchar(50),@Consum)+'</td><td>'+Convert(varchar(50),@Pen)+'</td></tr></Table><BR>' 
End
SET @MESS=@MESS+'<p align="justify">In case of any query or feedback, please write to us at feedback@48fitness.in. Our quality assurance team would be glad to be at your service & resolve your query within 48 hours.<BR><BR> <img src="https://rm.angelbackoffice.com/48FitnessLogo1.png"/></p>'  
set @MESS=@MESS+'<br><p align="justify">This is a system generated mail, please do not respond. For any queries please mail us @ feedback@48fitness.in.</p>'
set @MESS=@MESS+'<p align="justify">This e-mail, and any attachment, is intended only for the person or entity to which it is addressed and may contain confidential and/or privileged material. Any review, re-transmission, copying, dissemination or other use of this information by persons or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender @ feedback@48fitness.in. and delete the material from any computer.</p>'                        
set @sub ='48 Fitness:Your order for '+@Items+'(s) is confirmed.'            

/*                            
SET @MESS='<b><font size="4" color="#FF4500">Dear '+@Emp_name+', </font></b><br><Br>'                
SET @MESS=@MESS+'<p align="justify">Your order for Item(s) - '+@Items+'(s) is confirmed. Therefore, kindly be informed that your updated account status is  '+Convert(varchar(50),@Quantity)+' '+ @SubItems+'(s) is redeemed and '+Convert(varchar(50),@Pen)+' '+@Items+'(s) is left to be redeem in your voucher No. 00'+Convert(varchar(50),@VoucherNo)+'</p>'            
SET @MESS=@MESS+'<p align="justify">In case of any query or feedback, please write to us at feedback@48fitness.in. Our quality assurance team would be glad to be at your service & resolve your query within 48 hours.<BR><BR> <img src="https://rm.angelbackoffice.com/unnamed.png"/></p>'  
set @MESS=@MESS+'<br><p align="justify">This is a system generated mail, please do not respond. For any queries please mail us @ feedback@48fitness.in.</p>'
set @MESS=@MESS+'<p align="justify">This e-mail, and any attachment, is intended only for the person or entity to which it is addressed and may contain confidential and/or privileged material. Any review, re-transmission, copying, dissemination or other use of this information by persons or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender @ feedback@48fitness.in. and delete the material from any computer.</p>'                        
set @sub ='48 Fitness:Your order for '+@Items+'(s) is confirmed.'            
*/
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailto,                            
 @COPY_RECIPIENTS = @emailcc,                            
 @blind_copy_recipients=@emailbcc,                  
 @PROFILE_NAME = '48Feedback',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = @sub ,                            
 @FILE_ATTACHMENTS ='',                            
 @BODY =@MESS  

                           
End                                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemSale_Entry_02Aug2016
-- --------------------------------------------------
create procedure [dbo].[VIS_ItemSale_Entry_02Aug2016]                            
(                                                
@MemberNo as int,               
@date as varchar(11),               
@VoucherNo as int,               
@Items as varchar(50),        
@SubItems as varchar(50),     
@SubItemId as int,                    
@Quantity as int,
@Barcode as varchar(100),                        
@Consumed as int,                 
@Pending as int,                        
@UpdatedBy as Varchar(50),            
@VoucherName as varchar(50),            
@ItemId as int                
)                                
as                                
set nocount on                                
Begin                                
insert into VIS_ItemSale(MemberNo,Date,VoucherNo,Items,Quantity,Consumed,Pending,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,Barcode)                                 
select @MemberNo,@date,@VoucherNo,@Items,@Quantity,@Consumed,@Pending,getdate(),@updatedby,@VoucherName,@SubItems,@SubItemId,@Barcode                    
            
update VIS_Reedumption set Consumed=Consumed+@Quantity where ItemName=@Items and vouchername=@VoucherName and ItemId=@ItemId and memberNo=@MemberNo           
update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName=@Items and vouchername=@VoucherName  and ItemId=@ItemId and memberNo=@MemberNo           
            
/*update VIS_StockEntry set Quantity=Quantity-@Quantity where Item=@ItemId    */        
update VIS_StockMaintbl set Quantity=Quantity-@Quantity where Item=@ItemId  and subItemName= @SubItems and subItem=@SubItemId         
                           
End                                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemSale_Entry_10Aug2018
-- --------------------------------------------------
create procedure [dbo].[VIS_ItemSale_Entry_10Aug2018]
(                                                
@MemberNo as int,               
@date as varchar(11),               
@VoucherNo as int,               
@Items as varchar(50),        
@SubItems as varchar(50),     
@SubItemId as int,                    
@Quantity as int,
@Barcode as varchar(100),                        
@Consumed as int,                 
@Pending as int,                        
@UpdatedBy as Varchar(50),            
@VoucherName as varchar(50),            
@ItemId as int                
)                                
as                                
set nocount on                                
Begin                                
insert into VIS_ItemSale(MemberNo,Date,VoucherNo,Items,Quantity,Consumed,Pending,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,Barcode)                                 
select @MemberNo,@date,@VoucherNo,@Items,@Quantity,@Consumed,@Pending,getdate(),@updatedby,@VoucherName,@SubItems,@SubItemId,@Barcode 
            
update VIS_Reedumption set Consumed=Consumed+@Quantity where ItemName=@Items and vouchername=@VoucherName and ItemId=@ItemId and memberNo=@MemberNo and  VouchToMemID=@VoucherNo         
update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName=@Items and vouchername=@VoucherName  and ItemId=@ItemId and memberNo=@MemberNo and  VouchToMemID=@VoucherNo           
            
/*update VIS_StockEntry set Quantity=Quantity-@Quantity where Item=@ItemId    */        
update VIS_StockMaintbl set Quantity=Quantity-@Quantity where Item=@ItemId  and subItemName= @SubItems and subItem=@SubItemId  

DECLARE @Emp_name as varchar(100),@emp_email as varchar(100),@Expirydate as varchar(11)              
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)
/*declare @Membercode varchar(50)='23262'*/

select @emp_email=email1,@Emp_name=membername from VIS_MemberData_Service where Memberno=@MemberNo group by email1,membername
set @emp_email='info@48fitness.in;'+@emp_email

 SELECT @emailto=@emp_email              
 SELECT @emailcc='info@48fitness.in'             
 SELECT @emailbcc='48fitnessaccounts@angelbroking.com;jayashree.shetty@48fitness.in;Faheed.Hasware@48fitness.in;rajdeep.chakroborty@angelbroking.com' 
  --SELECT @emailbcc='rajdeep.chakroborty@angelbroking.com' 

  declare @OrderId as int                  
  set @OrderId=scope_Identity()
  --set @OrderId='00'+Convert(varchar(50),@OrderId)
  /*---For Inserting in Time sheet----*/                   
/*
If (@Items='Induction')
begin
	Insert into MISC.dbo.VIS_Timesheet(Date,MemberNo,VoucherNo,Items,Quantity,UpdatedOn,UpdatedBy,VoucherName,SubItem,SubItemId,OrderNo)
	select @date,@MemberNo,@VoucherNo,@Items,@Quantity,getdate(),@updatedby,@VoucherName,@SubItems,@SubItemId,@OrderId
end
*/
/*---For Inserting in Time sheet----*/
  --print @OrderId
 
 declare @Pen int ,@MaxQty int,@Consum int    
 select @Pen=Pending,@MaxQty=MaxQty,@Consum=Consumed from VIS_Reedumption  where ItemName=@Items and vouchername=@VoucherName  and ItemId=@ItemId and memberNo=@MemberNo       

SET @MESS='<b><font size="4" color="#FF4500">Dear '+@Emp_name+', </font></b><br><Br>'                
SET @MESS=@MESS+'<p align="justify">Your order for Item(s) - '+@SubItems+'(s) is confirmed. Therefore, kindly be informed that your updated account status is :</p>'            
/*SET @MESS=@MESs+'<Br><Table  width="100%"><tr bgcolor="#e60000"><td align="Center"><font color="#fff"><b>Item(s)</b></font></td><td align="Center"><font color="#fff"><b>Allotted</b></font></td><td align="Center"><font color="#fff"><b>Redeemed Today</b></font></td><td align="Center"><font color="#fff"><b>Total Redeemed</b></font></td><td align="Center"><font color="#fff"><b>Unredeemed</b></font></td></tr><tr align="Center" bgcolor=#D3D3D3><td >'+ @Items + '</td><td>' +Convert(varchar(50),@MaxQty)+'</td><td>' + Convert(varchar(50),@Quantity)+'</td><td>'+ Convert(varchar(50),@Consum)+'</td><td>'+Convert(varchar(50),@Pen)+'</td></tr></Table><BR>' */
SET @MESS=@MESs+'<Br><Table  width="100%"><tr bgcolor="#e60000"><td align="Center"><font color="#fff"><b>Item(s)</b></font></td><td align="Center"><font color="#fff"><b>Allotted</b></font></td></tr><tr align="Center" bgcolor=#D3D3D3><td >'+ @Items + '</td><td>' +Convert(varchar(50),@MaxQty)+'</td></tr></Table><BR>' 
SET @MESS=@MESS+'<p align="justify">In case of any query or feedback, please write to us at feedback@48fitness.in. Our quality assurance team would be glad to be at your service & resolve your query within 48 hours.<BR><BR> <img src="https://rm.angelbackoffice.com/48FitnessLogo1.png"/></p>'  
set @MESS=@MESS+'<br><p align="justify">This is a system generated mail, please do not respond. For any queries please mail us @ feedback@48fitness.in.</p>'
set @MESS=@MESS+'<p align="justify">This e-mail, and any attachment, is intended only for the person or entity to which it is addressed and may contain confidential and/or privileged material. Any review, re-transmission, copying, dissemination or other use of this information by persons or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender @ feedback@48fitness.in. and delete the material from any computer.</p>'                        
set @sub ='48 Fitness:Your order for '+@Items+'(s) is confirmed.'            

/*                            
SET @MESS='<b><font size="4" color="#FF4500">Dear '+@Emp_name+', </font></b><br><Br>'                
SET @MESS=@MESS+'<p align="justify">Your order for Item(s) - '+@Items+'(s) is confirmed. Therefore, kindly be informed that your updated account status is  '+Convert(varchar(50),@Quantity)+' '+ @SubItems+'(s) is redeemed and '+Convert(varchar(50),@Pen)+' '+@Items+'(s) is left to be redeem in your voucher No. 00'+Convert(varchar(50),@VoucherNo)+'</p>'            
SET @MESS=@MESS+'<p align="justify">In case of any query or feedback, please write to us at feedback@48fitness.in. Our quality assurance team would be glad to be at your service & resolve your query within 48 hours.<BR><BR> <img src="https://rm.angelbackoffice.com/unnamed.png"/></p>'  
set @MESS=@MESS+'<br><p align="justify">This is a system generated mail, please do not respond. For any queries please mail us @ feedback@48fitness.in.</p>'
set @MESS=@MESS+'<p align="justify">This e-mail, and any attachment, is intended only for the person or entity to which it is addressed and may contain confidential and/or privileged material. Any review, re-transmission, copying, dissemination or other use of this information by persons or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender @ feedback@48fitness.in. and delete the material from any computer.</p>'                        
set @sub ='48 Fitness:Your order for '+@Items+'(s) is confirmed.'            
*/
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailto,                            
 @COPY_RECIPIENTS = @emailcc,                            
 @blind_copy_recipients=@emailbcc,                  
 @PROFILE_NAME = '48Feedback',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = @sub ,                            
 @FILE_ATTACHMENTS ='',                            
 @BODY =@MESS  

                           
End                                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemsSaleCancel
-- --------------------------------------------------
CREATE Procedure [dbo].[VIS_ItemsSaleCancel]         
(            
  --variable  declareations             
 @Action Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select                  
 @orderno int,        
 @Quantity int=null,      
 @Items varchar(50),   
 @SubItems Varchar(50)=null ,     
 @ItemsID int =null,      
 @Member varchar(50)        
)            
as            
Begin             
  SET NOCOUNT ON;            
if @Action='Select'   --used to Select records            
Begin            
    select * from VIS_ItemSale  where orderno=@orderno and Items=@Items and memberno=@Member             
end            
Else If @Action='Delete'  --used to delete records            
 Begin            
   update VIS_ItemSale set status='Cancelled' where orderno=@orderno
   declare @qty1 int
	select @qty1=Quantity from VIS_ItemSale where orderno=@orderno and Items=@Items and memberno=@Member 
	
   update VIS_Reedumption set Consumed=Consumed-@qty1 where ItemName=@Items and memberno=@Member --and ItemID= @ItemsID      
   update VIS_Reedumption set Pending=Pending+@qty1 where ItemName=@Items and memberno=@Member  --and ItemID= @ItemsID      
   update VIS_StockMaintbl set Quantity=Quantity-@qty1 where SubItemName=@SubItems
	
   update VIS_ItemSale set Consumed=Consumed-@qty1 where orderno=@orderno and Items=@Items and memberno=@Member
   update VIS_ItemSale set Pending=Pending+@qty1 where orderno=@orderno and Items=@Items and memberno=@Member  
   
 end            
Else If @Action='Update'  --used to update records            
 Begin            
	declare @qty int
	select @qty=Quantity from VIS_ItemSale where orderno=@orderno and Items=@Items and memberno=@Member
	If(@Quantity< @qty)
	Begin
		update VIS_ItemSale set Consumed=Consumed-@Quantity where orderno=@orderno and Items=@Items and memberno=@Member
		update VIS_ItemSale set Pending=Pending+@Quantity where orderno=@orderno and Items=@Items and memberno=@Member
	end
	if(@Quantity> @qty)
	Begin
	
		update VIS_ItemSale set Consumed=Consumed+@Quantity where orderno=@orderno and Items=@Items and memberno=@Member
		update VIS_ItemSale set Pending=Pending-@Quantity where orderno=@orderno and Items=@Items and memberno=@Member
	end
   update VIS_ItemSale set Quantity=@Quantity where orderno=@orderno 
        
   update VIS_Reedumption set Consumed=@Quantity where ItemName=@Items and memberno=@Member and ItemID= @ItemsID      
         
   update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName=@Items and memberno=@Member  and ItemID= @ItemsID      
        
 update VIS_StockMaintbl set Quantity=Quantity-@Quantity where SubItemName=@SubItems        
           
 end             
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ItemsSaleCancel_05Oct2016
-- --------------------------------------------------
CREATE Procedure VIS_ItemsSaleCancel_05Oct2016           
(              
  --variable  declareations               
 @Action Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select                    
 @orderno int,          
 @Quantity int=null,        
 @Items varchar(50)=null,     
 @SubItems Varchar(50) =null,       
 @ItemsID int =null,        
 @Member varchar(50) =null         
)              
as              
Begin               
  SET NOCOUNT ON;              
if @Action='Select'   --used to Select records              
Begin              
    select * from VIS_ItemSale              
end              
Else If @Action='Delete'  --used to delete records              
 Begin              
   update VIS_ItemSale set status='Canceled' where orderno=@orderno              
 end              
Else If @Action='Update'  --used to update records              
 Begin              
   update VIS_ItemSale set Quantity=@Quantity where orderno=@orderno   
          
   update VIS_Reedumption set Consumed=@Quantity where ItemName=@Items and memberno=@Member and ItemID= @ItemsID        
           
   update VIS_Reedumption set Pending=MaxQty-Consumed where ItemName=@Items and memberno=@Member  and ItemID= @ItemsID        
          
 update VIS_StockMaintbl set Quantity=Quantity-@Quantity where SubItemName=@SubItems          
             
 end               
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_MemberService
-- --------------------------------------------------
CREATE Proc [VIS_MemberService]  
(@tblMember VIS_Member_Data READONLY)  
as  
  
truncate table TestVISMaemberData  
insert into [dbo].TestVISMaemberData      
select * from @tblMember  
  
insert into VIS_Member_log   
 select getdate(),count(1) as NOR from TestVISMaemberData with (nolock)      
  
truncate table VIS_MemberData_Service  
  
Insert into VIS_MemberData_Service(MemberNo,MemberName,Planname,Startdt,Enddt,Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon,ReceiptDate)    
SELECT a.MemberNo,a.MemberName,a.Planname,               
 convert(datetime,substring(a.Startdt,6,2)+'/'+substring(a.Startdt,9,2)+'/'+substring(a.Startdt,1,4)),  
 convert(datetime,substring(a.Enddt,6,2)+'/'+substring(a.Enddt,9,2)+'/'+substring(a.Enddt,1,4)),  
  convert(datetime,substring(a.Birthdate,6,2)+'/'+substring(a.Birthdate,9,2)+'/'+substring(a.Birthdate,1,4)),a.MobileNo1,a.Email1,a.ReceiptNo,              
 getdate() as LastUpdatedon, convert(datetime,substring(a.ReceiptDate,6,2)+'/'+substring(a.ReceiptDate,9,2)+'/'+substring(a.ReceiptDate,1,4))    
 FROM TestVISMaemberData a

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_NotIntrested
-- --------------------------------------------------
CREATE proc VIS_NotIntrested(
@Memberno as varchar(20),
@VId as int,
@Item as int,
@UpdatedBy as varchar(20)
)
as
set nocount on

declare @vouchername as varchar(50)
select @vouchername=a.vochername from VIS_voucher a join VIS_VoucherMember b on a.vochername=b.Vouchername    
where a.vid=@VId and b.memberno=@memberno 

update VIS_Reedumption set VouchNotIntrested='Not Intrested',Pending=0,consumed=0,updateBy=@UpdatedBy  where memberno=@Memberno and 
vouchername=@vouchername and itemid=@Item 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Plan
-- --------------------------------------------------
CREATE Procedure [dbo].[VIS_Plan]    
as    
set nocount on    
select distinct planname  into #aa FROM misc.dbo.fef_pt_sales_v16    
union 
select distinct planname from misc.dbo.tempplanname
  
insert into #aa  
select distinct planname FROM /*misc.dbo.fef_member_details    */ VIS_MemberData_Service
  
select distinct planname from #aa order by planname  

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Plan_04Feb2019
-- --------------------------------------------------
create Procedure [dbo].[VIS_Plan_04Feb2019]    
as    
set nocount on    
select distinct planname  into #aa FROM misc.dbo.fef_pt_sales_v16    
union 
select distinct planname from misc.dbo.tempplanname
  
insert into #aa  
select distinct planname FROM misc.dbo.fef_member_details    
  
select distinct planname from #aa order by planname  

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ReasonMaster
-- --------------------------------------------------
    
CREATE procedure VIS_ReasonMaster       
(        
@VReason as varchar(500),      
@VIssueQty as int,     
@IssueSameU varchar(20),    
@SubVochIssue int,@UpdatedBy as varchar(50)        
)        
as        
set nocount on        
Begin        
insert into VIS_VouReasonMast(VIssueReason,VIssueQty,VSameUser,SubVouIssue,UpdatedOn,UpdatedBy)         
select  @VReason,@VIssueQty,@IssueSameU,@SubVochIssue,getdate(),@UpdatedBy          
End        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ReceiptNo_Details
-- --------------------------------------------------
--VIS_ReceiptNo_Details 17855,'Valentines 2 - Ren',42
CREATE procedure [dbo].[VIS_ReceiptNo_Details](@ReceiptNo as int,@reasonname as varchar(100)='',@reasonid as int=0)         
as          
set nocount on         
/*     
select [Registration date] as Registrationdate,[membership no] as membership_no,Name,[Plan Name] as Plan_Name,Duration,[Starting date] as Starting_date,        
[End date] as End_date,[paid amount] as Paid_amount, cast(convert(date,[Reciept date], 103) as date) as Receipt_date,        
[Receipt no] as Receipt_No,Sessions,RealizedAmount,RealizedDate,SaleNo        
 from MemberDump_15_Jan_2016         
where [Receipt no]=@ReceiptNo       
*/   

if(@reasonname='Valentines 2-new'  or @reasonname='Valentines 2 - New')
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where  MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
	print 'hi'
end
else if(@reasonname='Valentines 2 - Ren' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
	print 'Renew'
end
else if(@reasonname='Valentines 3-new' or @reasonname='Valentines 3 - New')
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where  MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else if(@reasonname='Valentines 3 - Ren' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else if(@reasonname='Couple UP PT-New' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else if(@reasonname='Couple UP PT -Ren' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else if(@reasonname='Couple Up-N' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else if(@reasonname='Couple Up - R' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service     
	where ReceiptNo=@ReceiptNo     
	print 'hello'
End
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ReceiptNo_Details_08Feb2019
-- --------------------------------------------------
--VIS_ReceiptNo_Details 17852
CREATE procedure [dbo].[VIS_ReceiptNo_Details_08Feb2019](@ReceiptNo as int)         
as          
set nocount on         
/*     
select [Registration date] as Registrationdate,[membership no] as membership_no,Name,[Plan Name] as Plan_Name,Duration,[Starting date] as Starting_date,        
[End date] as End_date,[paid amount] as Paid_amount, cast(convert(date,[Reciept date], 103) as date) as Receipt_date,        
[Receipt no] as Receipt_No,Sessions,RealizedAmount,RealizedDate,SaleNo        
 from MemberDump_15_Jan_2016         
where [Receipt no]=@ReceiptNo       
*/   

if( @ReceiptNo=0)
Begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service    
	where ReceiptNo=@ReceiptNo  and Planname  LIKE 'Valentine%'
end 
else
begin 
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service    
	where ReceiptNo=@ReceiptNo     
end
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ReceiptNo_Details_09Feb2019
-- --------------------------------------------------

create procedure [dbo].[VIS_ReceiptNo_Details_09Feb2019](@ReceiptNo as int)         
as          
set nocount on         
/*     
select [Registration date] as Registrationdate,[membership no] as membership_no,Name,[Plan Name] as Plan_Name,Duration,[Starting date] as Starting_date,        
[End date] as End_date,[paid amount] as Paid_amount, cast(convert(date,[Reciept date], 103) as date) as Receipt_date,        
[Receipt no] as Receipt_No,Sessions,RealizedAmount,RealizedDate,SaleNo        
 from MemberDump_15_Jan_2016         
where [Receipt no]=@ReceiptNo       
*/      
select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
from VIS_MemberData_Service    
where ReceiptNo=@ReceiptNo     
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ReceiptNo_Details_18Mar2019
-- --------------------------------------------------
--VIS_ReceiptNo_Details 17855,'Valentines 2 - Ren',42
create procedure [dbo].[VIS_ReceiptNo_Details_18Mar2019](@ReceiptNo as int,@reasonname as varchar(100)='',@reasonid as int=0)         
as          
set nocount on         
/*     
select [Registration date] as Registrationdate,[membership no] as membership_no,Name,[Plan Name] as Plan_Name,Duration,[Starting date] as Starting_date,        
[End date] as End_date,[paid amount] as Paid_amount, cast(convert(date,[Reciept date], 103) as date) as Receipt_date,        
[Receipt no] as Receipt_No,Sessions,RealizedAmount,RealizedDate,SaleNo        
 from MemberDump_15_Jan_2016         
where [Receipt no]=@ReceiptNo       
*/   

if(@reasonname='Valentines 2-new' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where  MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
	print 'hi'
end
else if(@reasonname='Valentines 2 - Ren' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
	print 'Renew'
end
else if(@reasonname='Valentines 3-new' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where  MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else if(@reasonname='Valentines 3 - Ren' )
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service where   MemberNo not in(select distinct memberno from VIS_VoucherMember where IssueReason =@reasonid 
	and recepitNo=@ReceiptNo)     
	and ReceiptNo=@ReceiptNo 
end
else
begin
	select MemberNo,MemberName,Planname, cast(convert(date,Startdt, 101) as date) as Startdt,Enddt,cast(convert(date,Birthdate, 101) as date) as Birthdate,MobileNo1,Email1,ReceiptNo,Lastupdatedon  
	, cast(convert(date,Receiptdate, 103) as date) as Receiptdate  
	from VIS_MemberData_Service     
	where ReceiptNo=@ReceiptNo     
	print 'hello'
End
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_ReplacementRpt
-- --------------------------------------------------
CREATE proc VIS_ReplacementRpt   
(    
@memberNo varchar(11),    
@ItemId varchar(50),    
@ReplaceType varchar(50),  
@Fromdate varchar(12),    
@Todate varchar(12),    
@ACCESS_TO AS VARCHAR(20),                        
@ACCESS_CODE AS VARCHAR(20),    
@UserName as varchar(20)=null    
)    
as                                        
set nocount on                                        
Begin      
if(@memberNo='0')    
Begin    
 set @memberNo='%%'    
End     
if(@ItemId='0')    
Begin    
 set @ItemId='%%'    
End   
if(@ReplaceType='All')    
Begin    
 set @ReplaceType='%%'    
End     
select convert(varchar(11),UpdatedOn,101) as Date,MemberName,MemberNo,ItemName,SubItemName,Quantity,Reason,OldBarcode,NewBarcode,ReceiptNo,ApproverName from VIS_Servicing where MemberNo 
like @memberNo and Item like @ItemId and flag like @ReplaceType 
and Updatedon>=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00' and Updatedon <=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'      
   
  
  --print @memberNo    
  --print @ItemId    
  --print @Fromdate    
  --print  @Todate                                
End                                        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Servicing_Module
-- --------------------------------------------------
CREATE procedure VIS_Servicing_Module      
( 
@MemberName as varchar(20) ,   
@MemberNo as varchar(20),    
@Item as int,  
@ItemName as varchar(20), 
@SubItem as int, 
@SubItemName as varchar(20),  
@Checked as varchar(20)=null,  
@ApproverName as varchar(50),
@Approve as varchar(20),  
@Quantity as int,  
@Reason as varchar(20),
@OldBarcode as varchar(20)=null,  
@NewBarcode as varchar(20),  
@ReceiptNo as int=null,  
@Flag as varchar(20),  
@UpdatedBy as varchar(50)       
)      
as      
set nocount on      
Begin      
insert into VIS_Servicing(MemberName,MemberNo,Item,ItemName,SubItem,SubItemName,Checked,ApproverName,Approve,Quantity,Reason,OldBarcode,NewBarcode,ReceiptNo,Cancel,Flag,UpdatedOn,UpdatedBy)       
select  @MemberName,@MemberNo,@Item,@ItemName,@SubItem,@SubItemName,@Checked,@ApproverName,@Approve,@Quantity,@Reason,@OldBarcode,@NewBarcode,isnull(@ReceiptNo,0),'No',@Flag,getdate(),@UpdatedBy      

update VIS_StockMaintbl set Quantity=Quantity-@Quantity where Item=@Item  and subItemName=@SubItemName and subItem=@SubItem         

End      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Servicing_Update_Delete
-- --------------------------------------------------
CREATE Procedure VIS_Servicing_Update_Delete      
(        
  --variable  declareations         
 @Action Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select              
 @id int , 
 @ItemId int,
 @SubItemId int, 
 @Quantity int   --id to perform specific task        
)        
as        
Begin         
  SET NOCOUNT ON;        
if @Action='Select'   --used to Select records        
Begin        
    select * from VIS_Item        
end        
Else If @Action='Delete'  --used to delete records        
 Begin        
   update VIS_Servicing set cancel='Yes' where Id=@id  
   update VIS_StockMaintbl set Quantity=Quantity+@Quantity where Item=@ItemId and subItem=@SubItemId       
 end        
Else If @Action='Update'  --used to update records        
 Begin  
   Declare @Qty as int=0,@TotalQty as int=0
   select @Qty=Quantity from VIS_Servicing where Item=@ItemId and subitem=@SubItemId       
   If(@Quantity>@Qty)
   Begin
		set @TotalQty=@Quantity-@Qty
		update VIS_StockMaintbl set Quantity=Quantity-@TotalQty where Item=@ItemId and subItem=@SubItemId 
		update VIS_Servicing set Quantity=@Quantity  where Id=@id       
   End 
   Else If  (@Quantity<@Qty)
   Begin
		set @TotalQty=@Qty-@Quantity
		update VIS_StockMaintbl set Quantity=Quantity+@TotalQty where Item=@ItemId and subItem=@SubItemId 
		update VIS_Servicing set Quantity=@Quantity  where Id=@id 
   End
 end         
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Stock_Master
-- --------------------------------------------------
CREATE procedure VIS_Stock_Master               
(                
@VocherType as int,              
@ItemId as int,             
@SubItemID as int,   
@SubItemName as varchar(50),           
@Quantity as int,          
@updatedby as varchar(20),
@Barcode as varchar(20)              
)                
as                
set nocount on                
Begin            
        
    SET IDENTITY_INSERT VIS_StockEntry_hist ON         
insert into VIS_StockEntry_hist(StockId,VoucherType,Item,SubItem,Quantity,UpdatedOn,updatedBy,Barcode)        
select StockId,VoucherType,Item,SubItem,Quantity,UpdatedOn,updatedBy,Barcode from VIS_StockEntry         
    SET IDENTITY_INSERT VIS_StockEntry_hist OFF          
          
insert into VIS_StockEntry(VoucherType,Item,SubItem,Quantity,UpdatedOn,updatedBy,SubItemName,Barcode)                 
select  @VocherType,@ItemId,@SubItemID,@Quantity,getdate(),@updatedby,@SubItemName,@Barcode      
    
update VIS_StockMaintbl set Quantity=isnull(Quantity,0)+@Quantity where item=@ItemId and  SubItem=@SubItemID        
            
End                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Stock_Reminder
-- --------------------------------------------------
CREATE procedure VIS_Stock_Reminder     
(   
@Act as varchar(50),       
@ItemSubType as int=null,      
@StockAlert as int,     
@updatedby as varchar(20)      
)        
as   
--VIS_Stock_Reminder 'DStockAlert',null,5,'e57090'     
set nocount on        
Begin  
If @Act='DStockAlert'  
Begin  
 -- print @Act 
 select Id,ItemSubType into #aa from VIS_SubItemMaster    
 truncate table VIS_StockReminderMast      
 insert into VIS_StockReminderMast(ItemSubType)         
 select  Id from #aa  
  
 update VIS_StockReminderMast set StockAlert =@StockAlert,updatedby=@updatedby,UpdatedOn=getdate()  
 drop table #aa 
End  
Else If @Act='IStockAlert'  
Begin  
 update VIS_StockReminderMast set StockAlert =@StockAlert,updatedby=@updatedby,UpdatedOn=getdate()  
 where ItemSubType=@ItemSubType  
End  
End        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Stock_Update
-- --------------------------------------------------

CREATE Procedure VIS_Stock_Update     
(        
  --variable  declareations         
 @Action as Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select              
 @id as int,    --id to perform specific task          
 @ItemQuantity as int   
)        
as        
Begin         
  SET NOCOUNT ON;        
if @Action='Select'   --used to Select records        
Begin        
    select * from VIS_StockEntry        
end        
Else If @Action='Delete'  --used to delete records        
 Begin        
   delete from VIS_StockEntry where stockid=@id        
 end        
Else If @Action='Update'  --used to update records        
 Begin        
   update VIS_StockEntry set Quantity=@ItemQuantity where stockid=@id        
 end         
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_StockEntry_Delete
-- --------------------------------------------------
CREATE Procedure VIS_StockEntry_Delete      
(        
  --variable  declareations         
 @Action as Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select              
 @id as int=null,    --id to perform specific task        
 @VocherType as int=null,    
 @ItemId as int =null,     
 @ItemSubType as int=null,  
 @SubTypeQuantity as int=null ,
 @updatedby as varchar(20)=null 
)        
as        
Begin         
  SET NOCOUNT ON;        
if @Action='Select'   --used to Select records        
Begin        
	select a.stockId,a.VoucherType,a.Item,a.SubItem,
	a.Quantity,d.ItemSubType,c.ItemName,b.voucherType as VoucherName,convert(varchar(10),a.Updatedon,103) as Updatedon
	 from VIS_StockEntry a left join VIS_VouchCategory  b on b.V_CatId=a.voucherType 
	 left join VIS_Item c on  c.ItemId=a.Item
	 left join  VIS_SubItemMaster d on d.Id=a.SubItem  where a.StockId=@id          
end        
Else If @Action='Delete'  --used to delete records        
 Begin        
   delete from VIS_StockEntry where StockId=@id        
 end        
Else If @Action='Update'  --used to update records        
 Begin        
   update VIS_StockEntry set voucherType=@VocherType,Item=@ItemId,   
   SubItem=@ItemSubType,Quantity=@SubTypeQuantity,updatedby= @updatedby,UpdatedOn=getdate() where StockId=@id        
 end         
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Sub_Master
-- --------------------------------------------------
CREATE procedure VIS_Sub_Master         
(          
@VocherType as int,        
@ItemId as int,       
@ItemName as varchar(50),      
@ItemSubType as varchar(50),    
@UpdatedBy as varchar(50)          
)          
as          
set nocount on          
Begin          
insert into VIS_SubItemMaster(voucherType,ItemId,ItemName,ItemSubType,UpdatedOn,UpdatedBy)           
select  @VocherType,@ItemId,@ItemName,@ItemSubType,getdate(),@UpdatedBy      
  
declare @srno as int                    
select @srno=scope_Identity()  
  
insert into VIS_StockMaintbl(VoucherType,Item,SubItem,UpdatedOn,updatedBy,SubItemName)  
select @VocherType,@ItemId,@srno,getdate(),@UpdatedBy,@ItemSubType  
       
End          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_SubItem_Delete
-- --------------------------------------------------
CREATE Procedure VIS_SubItem_Delete  
(    
  --variable  declareations     
 @Action as Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select          
 @id as int=null,    --id to perform specific task    
 @VocherType as int=null,
 @ItemId as int =null, 
 @ItemName varchar(20)=null,
 @ItemSubType varchar(50)=null
)    
as    
Begin     
  SET NOCOUNT ON;    
if @Action='Select'   --used to Select records    
Begin    
    select * from VIS_SubItemMaster    
end    
Else If @Action='Delete'  --used to delete records    
 Begin    
   delete from VIS_SubItemMaster where ID=@id    
 end    
Else If @Action='Update'  --used to update records    
 Begin    
   update VIS_SubItemMaster set voucherType=@VocherType,ItemId=@ItemId,ItemName=@ItemName,
   ItemSubType=@ItemSubType where ID=@id    
 end     
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_SubVocherInsertion
-- --------------------------------------------------
CREATE procedure [dbo].[VIS_SubVocherInsertion]                            
(                        
@ReasonId as int,                      
@VoucherId as varchar(50),                                 
@updatedby as varchar(20)                      
)                        
as                        
set nocount on                        
Begin                        
--insert into VIS_SubVoucherMaster(ReasonId,VoucherId,UpdatedOn,UpdatedBy)                         
--select  @ReasonId,@VoucherId,getdate(),@updatedby       
 declare @count int ,@suvVouch int       
 if exists(select * from VIS_SubVoucherMaster  where reasonId=@ReasonId)    
 Begin    
  /*select  @count=Count(*) from VIS_SubVoucherMaster  where reasonId=@ReasonId    
  select @suvVouch=subVouissue from VIS_VouReasonMast where Id=@ReasonId    
  if(@suvVouch=@count)    
  select 1  */  /*Commented on 06 May 2016*/
  SET IDENTITY_INSERT VIS_SubVoucherMaster_log ON
  insert into VIS_SubVoucherMaster_log(SubVouchId,ReasonId,VoucherId,VoucherName,UpdatedOn,UpdatedBy)
  select SubVouchId,ReasonId,VoucherId,VoucherName,UpdatedOn,UpdatedBy from VIS_SubVoucherMaster  where reasonId=@ReasonId
  SET IDENTITY_INSERT VIS_SubVoucherMaster_log OFF   
  
  delete from VIS_SubVoucherMaster where reasonId=@ReasonId
  
  INSERT INTO VIS_SubVoucherMaster (ReasonId,UpdatedOn,UpdatedBy,VoucherId)          
  SELECT @ReasonId,getdate(),@updatedby, items          
  FROM [dbo].[Split] (@VoucherId, ',') where items<>0 
 End    
 else    
 Begin          
  INSERT INTO VIS_SubVoucherMaster (ReasonId,UpdatedOn,UpdatedBy,VoucherId)          
  SELECT @ReasonId,getdate(),@updatedby, items          
  FROM [dbo].[Split] (@VoucherId, ',') where items<>0         
 End                      
End                        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_SubVocherInsertion_06May2016
-- --------------------------------------------------
CREATE procedure [dbo].[VIS_SubVocherInsertion_06May2016]                            
(                        
@ReasonId as int,                      
@VoucherId as varchar(50),                                 
@updatedby as varchar(20)                      
)                        
as                        
set nocount on                        
Begin                        
--insert into VIS_SubVoucherMaster(ReasonId,VoucherId,UpdatedOn,UpdatedBy)                         
--select  @ReasonId,@VoucherId,getdate(),@updatedby       
 declare @count int ,@suvVouch int       
 if exists(select * from VIS_SubVoucherMaster  where reasonId=@ReasonId)    
 Begin    
  select  @count=Count(*) from VIS_SubVoucherMaster  where reasonId=@ReasonId    
  select @suvVouch=subVouissue from VIS_VouReasonMast where Id=@ReasonId    
  if(@suvVouch=@count)    
  select 1    
 End    
 else    
 Begin          
  INSERT INTO VIS_SubVoucherMaster (ReasonId,UpdatedOn,UpdatedBy,VoucherId)          
  SELECT @ReasonId,getdate(),@updatedby, items          
  FROM [dbo].[Split] (@VoucherId, ',') where items<>0         
 End                      
End                        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_SubVocherInsertion_09Apr2016
-- --------------------------------------------------
CREATE procedure [dbo].[VIS_SubVocherInsertion_09Apr2016]                        
(                    
@ReasonId as int,                  
@VoucherId as varchar(50),                             
@updatedby as varchar(20)                  
)                    
as                    
set nocount on                    
Begin                    
--insert into VIS_SubVoucherMaster(ReasonId,VoucherId,UpdatedOn,UpdatedBy)                     
--select  @ReasonId,@VoucherId,getdate(),@updatedby        
      
    INSERT INTO VIS_SubVoucherMaster (ReasonId,UpdatedOn,UpdatedBy,VoucherId)      
    SELECT @ReasonId,getdate(),@updatedby, items      
    FROM [dbo].[Split] (@VoucherId, ',') where items<>0     
                  
End                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_Voucher_Update
-- --------------------------------------------------
CREATE Procedure VIS_Voucher_Update    
(      
  --variable  declareations       
 @Action as Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select            
 @id as int,    --id to perform specific task      
 @V_Limit as int,  
 @ItemQuantity as int 
)      
as      
Begin       
  SET NOCOUNT ON;      
if @Action='Select'   --used to Select records      
Begin      
    select * from VIS_Voucher      
end      
Else If @Action='Delete'  --used to delete records      
 Begin      
   delete from VIS_Voucher where VID=@id      
 end      
Else If @Action='Update'  --used to update records      
 Begin      
   update VIS_Voucher set V_Limit=@V_Limit,ItemQuantity=@ItemQuantity where VID=@id      
 end       
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VoucherCreation_Master
-- --------------------------------------------------

CREATE procedure VIS_VoucherCreation_Master                           
(                            
@VoucherName as varchar(50),                          
@PlanName as varchar(100),                          
@VLimit as int,                     
@VType as int,                    
@Status as bit,                       
@Quantity as varchar(50),                    
@Item as varchar(50),                
@ItemName as varchar(50),                   
@updatedby as varchar(20)  
/*@IssueReason as varchar(100)                         */
)                            
as                            
set nocount on                            
Begin           
    
insert into VIS_Voucher(VocherName,PlanType,V_Limit,VType,ItemStatus,ItemId,ItemName,UpdatedOn,updatedby,ItemPending,ItemQuantity)                             
select  distinct @VoucherName,@PlanName,@VLimit,@VType,@Status,@Item,@ItemName,getdate(),@updatedby,@Quantity,@Quantity            
    
/*                     
insert into VIS_Voucher(VocherName,PlanType,V_Limit,VType,ItemStatus,ItemId,ItemName,UpdatedOn,updatedby,ItemPending,ItemQuantity)                             
select  distinct @VoucherName,@PlanName,@VLimit,@VType,@Status,@Item,@ItemName,getdate(),@updatedby,items,items            
FROM [dbo].[Split] (@Quantity, ',')          
  */                     
End                            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VoucherCreation_Master_07Apr2016
-- --------------------------------------------------
CREATE procedure VIS_VoucherCreation_Master_07Apr2016                       
(                        
@VoucherName as varchar(50),                      
@PlanName as varchar(100),                      
@VLimit as int,                 
@VType as int,                
@Status as bit,                   
@Quantity as varchar(50),                
@Item as varchar(50),            
@ItemName as varchar(50),               
@updatedby as varchar(20)                      
)                        
as                        
set nocount on                        
Begin 
                      
insert into VIS_MainMaster_Voucher(VocherName,PlanType,V_Limit,VType,ItemStatus,ItemId,ItemName,UpdatedOn,updatedby,ItemPending,ItemQuantity)                         
select  distinct @VoucherName,@PlanName,@VLimit,@VType,@Status,@Item,@ItemName,getdate(),@updatedby,@Quantity,@Quantity        
--FROM [dbo].[Split] (@Quantity, ',') 


    
--declare @VID as int ,@qty as int                   
--select @VID=scope_Identity()        
--select @qty=ItemQuantity from VIS_Voucher where VID= @VID    
--update   VIS_Voucher set   ItemPending=ItemQuantity  where VID= 115    
                   
End                        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VoucherDeactive
-- --------------------------------------------------
CREATE proc VIS_VoucherDeactive(@memberno as varchar(50),@DeactivatedBy as varchar(50),@dateofIssue as varchar(50))
as
set nocount on

select * from VIS_VoucherMember where memberno=@memberno 
and dateofissue=convert(varchar(11),@dateofIssue,106)

update VIS_VoucherMember set vstatus=0,DeactivatedOn=getdate(),DeactivatedBy=@DeactivatedBy where memberno=@memberno 
and dateofissue=convert(varchar(11),@dateofIssue,106)

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VoucherEmail
-- --------------------------------------------------
CREATE Procedure [dbo].[VIS_VoucherEmail] (@Membercode as varchar(10),@ReceiptNo as int)              
as              
              
Set nocount on                        
              
DECLARE @Emp_name as varchar(100),@emp_email as varchar(100),@Expirydate as varchar(11)              
DECLARE @MESS AS VARCHAR(max),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)
/*declare @Membercode varchar(50)='23262'*/

select @emp_email=email1,@Emp_name=membername from VIS_MemberData_Service where Memberno=@Membercode group by email1,membername
set @emp_email='info@48fitness.in;'+@emp_email

 SELECT @emailto=@emp_email              
 SELECT @emailcc='info@48fitness.in'             
 SELECT @emailbcc='48fitnessaccounts@angelbroking.com;jayashree.shetty@48fitness.in;Faheed.Hasware@48fitness.in;rajdeep.chakroborty@angelbroking.com' 
 
 /*SELECT @emailto='info@48fitness.in'--@emp_email              
 SELECT @emailcc='rajdeep.chakroborty@angelbroking.com'             
 SELECT @emailbcc='neha.naiwar@angelbroking.com' */
 BEGIN TRY                            

SELECT  membership_no,membername,Min(start_date) AS start_date,Max(end_date) AS end_date,Max(lastupdatedon) AS lastupdatedon into #aa FROM   
MISC.dbo.fef_member_master with (nolock) where membership_no= @Membercode
GROUP  BY membership_no,membername

/*select (Itemname+'-'+Convert(varchar(10),ItemQuantity)) from VIS_testing where memberNo=@Membercode*/
select @Expirydate =start_date from #aa
--print @Expirydate
 
 declare @Count int,@CountEnd int,@Srno varchar(50) ='', @Item varchar(50) ='' ,@Description varchar(500) ='' ,@Quantity varchar(50) ='' ,@Issued varchar(500) =''            
  DECLARE @xml NVARCHAR(MAX)  
    DECLARE @MessBody NVARCHAR(MAX)          
   DECLARE @Data NVARCHAR(MAX) ,  @totctrOT as int=0  
   
   set @Data=''                   
    set @Count=1 
  /*Change on 16 Dec 2016 by Neha Naiwar as suggested by Rajdeep */   
/*select  row_number()over (order by Itemname) As SerialNumber,Itemname as Item,ItemQuantity as Quantity,'During Signing Up' as Issued into #Item from VIS_testing where memberNo=@Membercode and recepitNo=@ReceiptNo       */
select  row_number()over (order by a.Itemname) As SerialNumber,a.Itemname as Item,a.ItemQuantity as Quantity,'During Signing Up' as Issued,b.Description into #Item 
from VIS_testing a join VIS_Item b on a.Itemid=b.Itemid where memberNo=@Membercode and recepitNo=@ReceiptNo       

     SELECT @totctrOT=count(1) from #Item         
   SET @MessBody=                          
   '<table width="100%" cellpadding="5%">                           
   <tr bgcolor="#e60000"  width="20%">                     
    <th align="Center" ><font color="#fff"> SerialNumber </font></th>
    <th align="Center" ><font color="#fff"> Items </font></th>
    <th align="Center" ><font color="#fff"> Quantity </font></th>
    <th align="Center" ><font color="#fff"> Issued </font></th>                                                 
   </tr>'          
--print @MESS        
   WHILE @Count <= @totctrOT                            
     BEGIN                      
      SELECT @Srno=SerialNumber,@Item=Item,@Quantity=Quantity,@Issued=Issued,@Description=Description FROM #Item WHERE SerialNumber=@count                                 
      set @Data=@Data+                         
     '<tr> 
     <td align="Center" bgcolor=#D3D3D3> '+ CONVERT(VARCHAR,@Srno) +' </td>                       
     <td align="left" bgcolor=#D3D3D3> '+ CONVERT(VARCHAR(500),@Description) +' </td> 
     <td align="Center" bgcolor=#D3D3D3> '+ CONVERT(VARCHAR,@Quantity) +' </td> 
     <td align="Center" bgcolor=#D3D3D3> '+ CONVERT(VARCHAR,@Issued) +' </td>                                             
       </tr>'    
    -- print @Data                       
      SET   @Count=@Count+1                                  
     END    
--drop table #Item
 
SET @MESS='Dear '+@Emp_name+',<br><h3 style="color:#e60000">Welcome to 48 Fitness Family!</h3>' 
SET @MESS=@MESS+'<p align="justify">Congratulations on taking the first important step towards complete wellness. You are now a part of India'+'''s'+' award winning premium club - 48 Fitness.</p>'                  
SET @MESS=@MESS+'<p align="justify">To assist you in fulfilling your fitness goals, it is our sincere endeavour to make your journey not only smooth but also enjoyable! Your club membership comes with a host of exclusive privileges redeemable anytime during your membership period. You will receive your exclusive rewards voucher at the time of sign up with us.</p> ' 
SET @MESS=@MESS+'<u>48 Fitness Exclusive Membership Privileges at a glance:</u><Br>'  
--SET @MESS=@MESS+'You can redeem your voucher at 48Fitness. Validity of your voucher is till '+@Expirydate+'.<Br><Br>'  
SET @MESS=@MESs+'<Br><Br>'+ @MessBody + @Data + '</Table><BR>' 
SET @MESS=@MESs+'<u>IMPORTANT CLUB FEATURE:</u> <Br><Br>'  
SET @MESS=@MESs+'<u>World Class Security Club Entry & Exit - RFID Band:</u> <Br>'  
SET @MESS=@MESs+'<p align="justify">48 Fitness believes in the highest level of security when it comes to the safety and privacy of its elite members. The club entry is managed via hi-tech RFID turnstile operated by your RFID band. This RFID band is only issued post various individual verification & system authentication checks. Therefore, there is no entry to the club possible without the usage of the personalized RFID band. In an event of the personalized RFID band being misplaced or stolen, the same needs to be notified to the club authorities/front desk officers on priority for issuance of a new RFID Band. The same is issued at a nominal charge of Rs. 700/-.per band. In case if a member has forgotten to bring his/her band along with him/her on a particular day, the system has a provision of providing you with an additional service of 3 temporary card entries in a single calendar month. Beyond 3 temporary card entries, the system will deny creation of more temporary entries & a new payable RFID band needs to be re-issued to continue enjoying club facilities.</p>'
SET @MESS=@MESs+'<p align="justify">We understand the exclusiveness that is desired by you as our esteemed member & it is our endeavour to surpass your every expectation to make you feel nothing but absolutely special here at 48 Fitness Club. We as a brand are constantly striving to make your experience with us most premium at any given point in time.</p>'
SET @MESS=@MESs+'<p align="justify">We truly believe in listening to you and our quality assurance team will be happy to receive your valuable feedback at: <u>feedback@48fitness.in</u></p>'
SET @MESS=@MESs+'<p align="justify">We again thank you for choosing 48 Fitness as your trusted fitness partner.</p>'
SET @MESS=@MESs+'<Br><Br><img src="https://rm.angelbackoffice.com/48FitnessLogo1.png"/><br>'
--SET @MESS=@MESS+'<BR><BR>Thank you for being part of 48Fitness and hope you continue enjoying our services. We look forward to delivering Best of your health! .<BR><BR>Regards,<br><Br>Team 48Fitness '                            
--SET @MESS=@MESs+'<BR><BR>This voucher will not be refunded in cash and is non-transferable. The person(s) to whom this voucher is issued must appear in the checkout/ account	'
set @MESS=@MESs+'<br><p align="justify">This is a system generated mail, please do not respond. For any queries please mail us @ feedback@48fitness.in.</p>'
set @MESS=@MESs+'<p align="justify">This e-mail, and any attachment, is intended only for the person or entity to which it is addressed and may contain confidential and/or privileged material. Any review, re-transmission, copying, dissemination or other use of this information by persons or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender @ feedback@48fitness.in. and delete the material from any computer.</p>'                        

set @sub ='48 Fitness: Gift Voucher'                   


 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailto,                            
 @COPY_RECIPIENTS = @emailcc,                            
 @blind_copy_recipients=@emailbcc,                  
 @PROFILE_NAME = '48Feedback',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = @sub ,                            
 @FILE_ATTACHMENTS ='',                            
 @BODY =@MESS  
 
 drop table #aa
 drop table #item
END TRY                            
BEGIN CATCH                            
                            
                            
 SET @MESS='<BR><BR> ERROR in triggering email for 48 Fitness                          
 <BR>                            
 <BR>                            
 This is a System generated Message. Please do not Reply.<BR>                            
 <BR>                            
 '                            
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                            
 @RECIPIENTS =@emailbcc,                            
 @COPY_RECIPIENTS = @emailcc,                            
 @PROFILE_NAME = '48Feedback',                            
 @BODY_FORMAT ='HTML',                            
 @SUBJECT = 'ERROR in 48 Fitness: 48 Fitness: Gift Voucher',                            
 @FILE_ATTACHMENTS ='',                            
 @BODY =@MESS                            
                            
END CATCH               
              
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VoucherMaster
-- --------------------------------------------------
CREATE procedure VIS_VoucherMaster  
(  
@VType as varchar(20),
@UpdatedBy as varchar(50)  
)  
as  
set nocount on  
Begin  
insert into VIS_VouchCategory(VoucherType,UpdatedOn,UpdatedBy)   
select  @VType,getdate(),@UpdatedBy  
End  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VoucherReport
-- --------------------------------------------------
-- [VIS_VoucherReport] '4/10/2016','7/10/2016','broker','cso','e10398'
CREATE proc [dbo].[VIS_VoucherReport]    
(     
@Fromdate varchar(12),    
@Todate varchar(12),    
@ACCESS_TO AS VARCHAR(20),                        
@ACCESS_CODE AS VARCHAR(20),    
@UserName as varchar(20)=null    
)    
as                                        
set nocount on  

select distinct a.MemberNo,a.MemberName,a.recepitNo,b.VIssueReason,a.dateOfIssue,a.UpdatedBy from VIS_VoucherMember a join 
VIS_VouReasonMast b on a.IssueReason=b.ID
where a.UpdatedOn>=replace(CONVERT(VARCHAR(19),convert(datetime,@Fromdate,103),106), '/', ' ')+' 00:00:00'  --'2016-10-06 17:33:04.910' @FromDate
 and a.UpdatedOn <=replace(CONVERT(VARCHAR(19),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'   --@todate
    
                                   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VReason_Delete
-- --------------------------------------------------
CREATE Procedure VIS_VReason_Delete  
(    
  --variable  declareations     
 @Action Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select          
 @id int=null,    --id to perform specific task    
 @VReason varchar(50)=null,
 @VIssueQty as int =null, 
 @IssueSameU varchar(20)=null,
 @SubVochIssue int=null 
)    
as    
Begin     
  SET NOCOUNT ON;    
if @Action='Select'   --used to Select records    
Begin    
    select * from VIS_VouReasonMast    
end    
Else If @Action='Delete'  --used to delete records    
 Begin    
   delete from VIS_VouReasonMast where ID=@id    
 end    
Else If @Action='Update'  --used to update records    
 Begin    
   update VIS_VouReasonMast set VIssueReason=@VReason,VIssueQty=@VIssueQty,VSameUser=@IssueSameU,
   SubVouIssue=@SubVochIssue where ID=@id    
 end     
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VIS_VType_Delete
-- --------------------------------------------------
CREATE Procedure VIS_VType_Delete
(  
  --variable  declareations   
 @Action Varchar (10),    --to perform operation according to string ed to this varible such as Insert,update,delete,select        
 @id int=null,    --id to perform specific task  
 @VType varchar(20)=null
)  
as  
Begin   
  SET NOCOUNT ON;  
if @Action='Select'   --used to Select records  
Begin  
    select * from VIS_VouchCategory  
end  
Else If @Action='Delete'  --used to delete records  
 Begin  
   delete from VIS_VouchCategory where V_CatId=@id  
 end  
Else If @Action='Update'  --used to update records  
 Begin  
   update VIS_VouchCategory set voucherType=@VType where V_CatId=@id  
 end   
End

GO

-- --------------------------------------------------
-- TABLE dbo.Calendar
-- --------------------------------------------------
CREATE TABLE [dbo].[Calendar]
(
    [gc_AllDayEvent] CHAR(1) NULL,
    [gc_BillingInformation] VARCHAR(256) NULL,
    [gc_Body] TEXT NULL,
    [gc_BusyStatus] INT NULL,
    [gc_Categories] VARCHAR(256) NULL,
    [gc_Companies] VARCHAR(256) NULL,
    [gc_Duration] INT NULL,
    [gc_End] DATETIME NULL,
    [gc_Importance] INT NULL,
    [gc_InternetCodepage] INT NULL,
    [gc_IsOnlineMeeting] CHAR(1) NULL,
    [gc_Location] VARCHAR(256) NULL,
    [gc_MeetingStatus] INT NULL,
    [gc_MessageClassFormDescription] VARCHAR(256) NULL,
    [gc_Mileage] VARCHAR(256) NULL,
    [gc_NetmeetingServer] VARCHAR(256) NULL,
    [gc_NetMeetingAutoStart] CHAR(1) NULL,
    [gc_NetMeetingDocPathName] VARCHAR(256) NULL,
    [gc_NetMeetingOrganizerAlias] VARCHAR(256) NULL,
    [gc_NetMeetingType] INT NULL,
    [gc_NetShowURL] VARCHAR(256) NULL,
    [gc_NoAging] CHAR(1) NULL,
    [gc_OptionalAttendees] VARCHAR(256) NULL,
    [gc_Organizer] VARCHAR(256) NULL,
    [gc_ReminderMinutesBeforeStart] INT NULL,
    [gc_ReminderOverrideDefault] CHAR(1) NULL,
    [gc_ReminderPlaySound] CHAR(1) NULL,
    [gc_ReminderSet] CHAR(1) NULL,
    [gc_ReminderSoundFile] VARCHAR(256) NULL,
    [gc_ReplyTime] DATETIME NULL,
    [gc_RequiredAttendees] VARCHAR(256) NULL,
    [gc_Resources] VARCHAR(256) NULL,
    [gc_ResponseRequested] CHAR(1) NULL,
    [gc_Sensitivity] INT NULL,
    [gc_Start] DATETIME NULL,
    [gc_Subject] VARCHAR(256) NULL,
    [gc_Unread] CHAR(1) NULL,
    [gc_id] UNIQUEIDENTIFIER NOT NULL,
    [gc_RecurrencePattern] VARCHAR(100) NULL,
    [gc_LastModificationTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CONTACTS
-- --------------------------------------------------
CREATE TABLE [dbo].[CONTACTS]
(
    [OCS_ID] UNIQUEIDENTIFIER NOT NULL,
    [OCS_SENSITIVITY] INT NULL,
    [OCS_IMPORTANCE] CHAR(1) NULL,
    [OCS_BILLINGINFORMATION] VARCHAR(32) NULL,
    [OCS_MILEAGE] DECIMAL(16, 3) NULL,
    [OCS_NOAGING] CHAR(1) NULL,
    [OCS_INITIALS] VARCHAR(32) NULL,
    [OCS_FIRSTNAME] VARCHAR(128) NULL,
    [OCS_MIDDLENAME] VARCHAR(128) NULL,
    [OCS_LASTNAME] VARCHAR(128) NULL,
    [OCS_SUFFIX] VARCHAR(32) NULL,
    [OCS_FULLNAME] VARCHAR(256) NULL,
    [OCS_FILEAS] VARCHAR(256) NULL,
    [OCS_JOBTITLE] VARCHAR(64) NULL,
    [OCS_COMPANYNAME] VARCHAR(64) NULL,
    [OCS_DEPARTMENT] VARCHAR(64) NULL,
    [OCS_GENDER] CHAR(1) NULL,
    [OCS_SELECTEDMAILINGADDRESS] CHAR(1) NULL,
    [OCS_ACCOUNT] VARCHAR(32) NULL,
    [OCS_ANNIVERSARY] VARCHAR(32) NULL,
    [OCS_BIRTHDAY] DATETIME NULL,
    [OCS_ASSISTANTNAME] VARCHAR(256) NULL,
    [OCS_CHILDREN] VARCHAR(128) NULL,
    [OCS_COMPUTERNETWORKNAME] VARCHAR(20) NULL,
    [OCS_FTPSITE] VARCHAR(256) NULL,
    [OCS_CUSTOMERID] VARCHAR(32) NULL,
    [OCS_GOVERNMENTID] VARCHAR(32) NULL,
    [OCS_ORGANIZATIONID] VARCHAR(32) NULL,
    [OCS_HOBBY] VARCHAR(64) NULL,
    [OCS_INETFREEBUSSY] VARCHAR(256) NULL,
    [OCS_JOURNAL] CHAR(1) NULL,
    [OCS_LANGUAGE] VARCHAR(32) NULL,
    [OCS_MANAGERNAME] VARCHAR(256) NULL,
    [OCS_NETMEETINGALIAS] VARCHAR(128) NULL,
    [OCS_NETMEETINGSERVER] VARCHAR(256) NULL,
    [OCS_NICKNAME] VARCHAR(128) NULL,
    [OCS_OFFICELOCATION] VARCHAR(64) NULL,
    [OCS_PERSONALHOMEPAGE] VARCHAR(256) NULL,
    [OCS_PROFESSION] VARCHAR(64) NULL,
    [OCS_REFERREDBY] VARCHAR(256) NULL,
    [OCS_SPOUCE] VARCHAR(256) NULL,
    [OCS_WEBPAGE] VARCHAR(256) NULL,
    [OCS_CATEGORY] VARCHAR(64) NULL,
    [OCS_BUSINESS_CITY] VARCHAR(64) NULL,
    [OCS_BUSINESS_COUNTRY] VARCHAR(32) NULL,
    [OCS_BUSINESS_POSTALCODE] VARCHAR(8) NULL,
    [OCS_BUSINESS_POSTOFFICEBOX] VARCHAR(16) NULL,
    [OCS_BUSINESS_STATE] VARCHAR(32) NULL,
    [OCS_BUSINESS_STREET] VARCHAR(64) NULL,
    [OCS_BUSINESS_FAX] VARCHAR(32) NULL,
    [OCS_BUSINESS_HOMEPAGE] VARCHAR(256) NULL,
    [OCS_BUSINESS_TELEPHONE] VARCHAR(32) NULL,
    [OCS_BUSINESS_TELEPHONE2] VARCHAR(32) NULL,
    [OCS_EMAIL1ADDRESS] VARCHAR(128) NULL,
    [OCS_EMAIL1ADDRESSTYPE] VARCHAR(64) NULL,
    [OCS_EMAIL2ADDRESS] VARCHAR(128) NULL,
    [OCS_EMAIL2ADDRESS_TYPE] VARCHAR(64) NULL,
    [OCS_EMAIL3ADDRESS] VARCHAR(128) NULL,
    [OCS_EMAIL3ADDRESS_TYPE] VARCHAR(64) NULL,
    [OCS_HOME_CITY] VARCHAR(64) NULL,
    [OCS_HOME_COUNTRY] VARCHAR(32) NULL,
    [OCS_HOME_POSTALCODE] VARCHAR(8) NULL,
    [OCS_HOME_POSTOFFICEBOX] VARCHAR(16) NULL,
    [OCS_HOME_STATE] VARCHAR(32) NULL,
    [OCS_HOME_STREET] VARCHAR(64) NULL,
    [OCS_HOME_FAX] VARCHAR(32) NULL,
    [OCS_HOME_TELEPHONE] VARCHAR(32) NULL,
    [OCS_HOME_TELEPHONE2] VARCHAR(32) NULL,
    [OCS_OTHER_CITY] VARCHAR(64) NULL,
    [OCS_OTHER_COUNTRY] VARCHAR(32) NULL,
    [OCS_OTHER_POSTALCODE] VARCHAR(8) NULL,
    [OCS_OTHER_POSTOFFICEBOX] VARCHAR(16) NULL,
    [OCS_OTHER_STATE] VARCHAR(32) NULL,
    [OCS_OTHER_STREET] VARCHAR(64) NULL,
    [OCS_OTHER_FAX] VARCHAR(32) NULL,
    [OCS_OTHER_TELEPHONE] VARCHAR(32) NULL,
    [OCS_ASSISTANTTELEPHONE] VARCHAR(32) NULL,
    [OCS_BODY] TEXT NULL,
    [OCS_CALLBACKTELEPHONE] VARCHAR(32) NULL,
    [OCS_CARTELEPHONE] VARCHAR(32) NULL,
    [OCS_COMPANYMAINTELEPHONE] VARCHAR(32) NULL,
    [OCS_ISDNNUMBER] VARCHAR(32) NULL,
    [OCS_MOBILEPHONE] VARCHAR(32) NULL,
    [OCS_USERCERTIFICATE] VARCHAR(128) NULL,
    [OCS_UNREAD] CHAR(1) NULL,
    [OCS_TITLE] VARCHAR(50) NULL,
    [OCS_USER1] VARCHAR(50) NULL,
    [OCS_USER2] VARCHAR(50) NULL,
    [OCS_TTYTDD] VARCHAR(50) NULL,
    [OCS_RADIOTELEPHONE] VARCHAR(50) NULL,
    [OCS_TELEX] VARCHAR(50) NULL,
    [OCS_PAGER] VARCHAR(50) NULL,
    [OCS_PRIMARYTELEPHONE] VARCHAR(50) NULL,
    [gc_LastModificationTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_AttandanceList
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_AttandanceList]
(
    [MemberNo] VARCHAR(50) NULL,
    [Membername] VARCHAR(50) NULL,
    [AttandanceDate] VARCHAR(100) NULL,
    [LastUpdatedon] DATETIME NULL,
    [flag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_ConversionRpt
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_ConversionRpt]
(
    [EmpName] NVARCHAR(255) NULL,
    [TotalEnquiry] FLOAT NULL,
    [CurrConv] FLOAT NULL,
    [PrevConv] FLOAT NULL,
    [PlanSaleUnits] FLOAT NULL,
    [TotalAmount] FLOAT NULL,
    [PaidAmount] FLOAT NULL,
    [LastUpdatedon] DATETIME NULL,
    [flag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_JDemail_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_JDemail_hist]
(
    [SenderEmailAddress] VARCHAR(256) NULL,
    [senton] DATETIME NULL,
    [guid] UNIQUEIDENTIFIER NULL,
    [Name] VARCHAR(500) NULL,
    [City] VARCHAR(200) NULL,
    [Phone] VARCHAR(200) NULL,
    [Src] VARCHAR(10) NULL,
    [DNC] VARCHAR(10) NULL,
    [phone1] VARCHAR(15) NULL,
    [FEF_EnquiryNo] VARCHAR(10) NULL,
    [FEF_MemberNo] VARCHAR(10) NULL,
    [NoOfCalls] INT NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_LeadGap
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_LeadGap]
(
    [Source] VARCHAR(20) NULL,
    [TotalLead] INT NULL,
    [NotCalled] INT NULL,
    [Called] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_LMS_data
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_LMS_data]
(
    [SrNo] VARCHAR(10) NULL,
    [Lead Date] DATETIME NULL,
    [Name] VARCHAR(100) NULL,
    [Mobile No.] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_LMS_Head
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_LMS_Head]
(
    [SrNo] VARCHAR(10) NULL,
    [Lead Date] VARCHAR(100) NULL,
    [Name] VARCHAR(100) NULL,
    [Mobile No.] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_MembeStatusList
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_MembeStatusList]
(
    [MemberNo] VARCHAR(50) NULL,
    [Membername] VARCHAR(50) NULL,
    [Active] VARCHAR(50) NULL,
    [LastUpdatedon] DATETIME NULL,
    [flag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Journal
-- --------------------------------------------------
CREATE TABLE [dbo].[Journal]
(
    [gc_BillingInformation] VARCHAR(256) NULL,
    [gc_Body] TEXT NULL,
    [gc_Categories] VARCHAR(256) NULL,
    [gc_Companies] VARCHAR(256) NULL,
    [gc_ContactNames] VARCHAR(256) NULL,
    [gc_DocPosted] CHAR(1) NULL,
    [gc_DocPrinted] CHAR(1) NULL,
    [gc_DocRouted] CHAR(1) NULL,
    [gc_DocSaved] CHAR(1) NULL,
    [gc_Duration] INT NULL,
    [gc_End] DATETIME NULL,
    [gc_Importance] INT NULL,
    [gc_MessageClassFormDescription] VARCHAR(256) NULL,
    [gc_Mileage] VARCHAR(256) NULL,
    [gc_NoAging] CHAR(1) NULL,
    [gc_Recipients] VARCHAR(256) NULL,
    [gc_Sensitivity] INT NULL,
    [gc_Start] DATETIME NULL,
    [gc_Subject] VARCHAR(256) NULL,
    [gc_Type] VARCHAR(256) NULL,
    [gc_Unread] CHAR(1) NULL,
    [gc_id] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LMS_Appointment_log
-- --------------------------------------------------
CREATE TABLE [dbo].[LMS_Appointment_log]
(
    [LastUpdatedDate] DATETIME NULL,
    [NoOfRecords] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LMS_Attandance_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[LMS_Attandance_Log]
(
    [LastUpdatedDate] DATETIME NULL,
    [NoOfRecords] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LMS_Conversion_log
-- --------------------------------------------------
CREATE TABLE [dbo].[LMS_Conversion_log]
(
    [LastUpdatedDate] DATETIME NULL,
    [NoOfRecords] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LMS_Enquiry_log
-- --------------------------------------------------
CREATE TABLE [dbo].[LMS_Enquiry_log]
(
    [LastUpdatedDate] DATETIME NULL,
    [NoOfRecords] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LMS_Status_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[LMS_Status_Log]
(
    [LastUpdatedDate] DATETIME NULL,
    [NoOfRecords] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mail_nikhil
-- --------------------------------------------------
CREATE TABLE [dbo].[mail_nikhil]
(
    [gc_AlternateRecipientAllowed] CHAR(1) NULL,
    [gc_AutoForwarded] CHAR(1) NULL,
    [gc_BCC] VARCHAR(1700) NULL,
    [gc_BillingInformation] VARCHAR(256) NULL,
    [gc_Categories] VARCHAR(256) NULL,
    [gc_CC] VARCHAR(1700) NULL,
    [gc_Companies] VARCHAR(256) NULL,
    [gc_CreationTime] DATETIME NULL,
    [gc_DeferredDeliveryTime] DATETIME NULL,
    [gc_DeleteAfterSubmit] CHAR(1) NULL,
    [gc_ExpiryTime] DATETIME NULL,
    [gc_FlagDueBy] DATETIME NULL,
    [gc_FlagRequest] VARCHAR(100) NULL,
    [gc_FlagStatus] INT NULL,
    [gc_HTMLBody] TEXT NULL,
    [gc_Importance] INT NULL,
    [gc_InternetCodepage] INT NULL,
    [gc_Mileage] VARCHAR(100) NULL,
    [gc_NoAging] CHAR(1) NULL,
    [gc_OriginatorDeliveryReportRequested] CHAR(1) NULL,
    [gc_ReadReceiptRequested] CHAR(1) NULL,
    [gc_ReceivedByName] VARCHAR(150) NULL,
    [gc_ReceivedOnBehalfOfName] VARCHAR(150) NULL,
    [gc_RecipientReassignmentProhibited] CHAR(1) NULL,
    [gc_RemoteStatus] INT NULL,
    [gc_ReplyRecipientNames] VARCHAR(256) NULL,
    [gc_SenderEmailAddress] VARCHAR(256) NULL,
    [gc_SenderEmailType] VARCHAR(100) NULL,
    [gc_SenderName] VARCHAR(150) NULL,
    [gc_Sensitivity] INT NULL,
    [gc_SentOn] DATETIME NULL,
    [gc_SentOnBehalfOfName] VARCHAR(150) NULL,
    [gc_Subject] VARCHAR(256) NULL,
    [gc_To] VARCHAR(1700) NULL,
    [gc_Unread] CHAR(1) NULL,
    [gc_ReceivedTime] DATETIME NULL,
    [gc_guid] UNIQUEIDENTIFIER NOT NULL,
    [gc_LastModificationTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Notes
-- --------------------------------------------------
CREATE TABLE [dbo].[Notes]
(
    [gc_Body] VARCHAR(256) NULL,
    [gc_Categories] VARCHAR(256) NULL,
    [gc_Color] INT NULL,
    [gc_Height] INT NULL,
    [gc_Left] INT NULL,
    [gc_MessageClassFormDescription] VARCHAR(256) NULL,
    [gc_Top] INT NULL,
    [gc_Width] INT NULL,
    [gc_id] UNIQUEIDENTIFIER NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tasks
-- --------------------------------------------------
CREATE TABLE [dbo].[Tasks]
(
    [gc_ActualWork] INT NULL,
    [gc_BillingInformation] VARCHAR(256) NULL,
    [gc_Body] TEXT NULL,
    [gc_CardData] VARCHAR(256) NULL,
    [gc_Categories] VARCHAR(256) NULL,
    [gc_Companies] VARCHAR(256) NULL,
    [gc_Complete] CHAR(1) NULL,
    [gc_ContactNames] VARCHAR(256) NULL,
    [gc_CreationTime] DATETIME NULL,
    [gc_DateCompleted] DATETIME NULL,
    [gc_DueDate] DATETIME NULL,
    [gc_Importance] INT NULL,
    [gc_InternetCodepage] INT NULL,
    [gc_RecurrencePattern] VARCHAR(100) NULL,
    [gc_Mileage] VARCHAR(256) NULL,
    [gc_NoAging] CHAR(1) NULL,
    [gc_Ordinal] INT NULL,
    [gc_Owner] VARCHAR(256) NULL,
    [gc_PercentComplete] INT NULL,
    [gc_ReminderOverrideDefault] CHAR(1) NULL,
    [gc_ReminderPlaySound] CHAR(1) NULL,
    [gc_ReminderSet] CHAR(1) NULL,
    [gc_ReminderSoundFile] VARCHAR(256) NULL,
    [gc_ReminderTime] DATETIME NULL,
    [gc_Role] VARCHAR(256) NULL,
    [gc_SchedulePlusPriority] VARCHAR(256) NULL,
    [gc_Sensitivity] INT NULL,
    [gc_StartDate] DATETIME NULL,
    [gc_Status] INT NULL,
    [gc_StatusOnCompletionRecipients] VARCHAR(256) NULL,
    [gc_StatusUpdateRecipients] VARCHAR(256) NULL,
    [gc_Subject] VARCHAR(256) NULL,
    [gc_TeamTask] CHAR(1) NULL,
    [gc_TotalWork] INT NULL,
    [gc_Unread] CHAR(1) NULL,
    [gc_guid] UNIQUEIDENTIFIER NOT NULL,
    [gc_LastModificationTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VIS_MemberIndution
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VIS_MemberIndution]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [MemberName] VARCHAR(50) NULL,
    [MemberCode] VARCHAR(50) NULL,
    [Status] VARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL,
    [updateBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TestAppointment
-- --------------------------------------------------
CREATE TABLE [dbo].[TestAppointment]
(
    [EnquiryNo] VARCHAR(50) NULL,
    [EnquiryName] VARCHAR(50) NULL,
    [MobileNo] VARCHAR(50) NULL,
    [ReminderDate] VARCHAR(50) NULL,
    [Remark] VARCHAR(2000) NULL,
    [Appointment] VARCHAR(50) NULL,
    [Counseller] VARCHAR(50) NULL,
    [ReminderTime] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.testconversion
-- --------------------------------------------------
CREATE TABLE [dbo].[testconversion]
(
    [EmpName] NVARCHAR(255) NULL,
    [TotalEnquiry] FLOAT NULL,
    [CurrConv] FLOAT NULL,
    [PrevConv] FLOAT NULL,
    [PlanSaleUnits] FLOAT NULL,
    [TotalAmount] FLOAT NULL,
    [PaidAmount] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TestMemberAttandance
-- --------------------------------------------------
CREATE TABLE [dbo].[TestMemberAttandance]
(
    [MemberNo] VARCHAR(50) NULL,
    [Membername] VARCHAR(50) NULL,
    [AttandanceDate] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TestMemberStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[TestMemberStatus]
(
    [MemberNo] VARCHAR(50) NULL,
    [Membername] VARCHAR(50) NULL,
    [Active] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_Item
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_Item]
(
    [ItemId] INT IDENTITY(1,1) NOT NULL,
    [ItemName] VARCHAR(50) NULL,
    [Description] VARCHAR(100) NULL,
    [VoucherType] INT NULL,
    [Updatedon] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_ItemSale
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_ItemSale]
(
    [OrderNo] INT IDENTITY(1,1) NOT NULL,
    [Date] VARCHAR(50) NULL,
    [MemberNo] INT NULL,
    [VoucherNo] INT NULL,
    [Items] VARCHAR(50) NULL,
    [Quantity] INT NULL,
    [Consumed] INT NULL,
    [Pending] INT NULL,
    [Status] VARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [VoucherName] VARCHAR(100) NULL,
    [SubItem] VARCHAR(25) NULL,
    [SubItemId] INT NULL,
    [Barcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_MainMaster_Voucher
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_MainMaster_Voucher]
(
    [VID] INT IDENTITY(1,1) NOT NULL,
    [VocherName] VARCHAR(50) NULL,
    [PlanType] VARCHAR(100) NULL,
    [V_Limit] INT NULL,
    [VType] VARCHAR(50) NULL,
    [ItemId] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [ItemQuantity] INT NULL,
    [ItemConsumed] INT NULL,
    [ItemPending] INT NULL,
    [ItemStatus] BIT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_Member_log
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_Member_log]
(
    [LastUpdatedDate] DATETIME NULL,
    [NoOfRecords] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_Reedumption
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_Reedumption]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [VouchToMemID] INT NULL,
    [MemberNo] INT NULL,
    [MemberName] VARCHAR(50) NULL,
    [DateOfentry] DATETIME NULL,
    [Employee] VARCHAR(50) NULL,
    [VoucherName] VARCHAR(50) NULL,
    [ItemId] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [MaxQty] INT NULL,
    [Consumed] INT NULL,
    [Pending] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdateBy] VARCHAR(50) NULL,
    [receiptNo] VARCHAR(50) NULL,
    [VouchStatus] INT NULL,
    [Startdate] DATETIME NULL,
    [EnddateVouch] DATE NULL,
    [VouchNotIntrested] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_Reedumption_08Mar2018_Wrong_cafe
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_Reedumption_08Mar2018_Wrong_cafe]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [VouchToMemID] INT NULL,
    [MemberNo] INT NULL,
    [MemberName] VARCHAR(50) NULL,
    [DateOfentry] DATETIME NULL,
    [Employee] VARCHAR(50) NULL,
    [VoucherName] VARCHAR(50) NULL,
    [ItemId] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [MaxQty] INT NULL,
    [Consumed] INT NULL,
    [Pending] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdateBy] VARCHAR(50) NULL,
    [receiptNo] VARCHAR(50) NULL,
    [VouchStatus] INT NULL,
    [Startdate] DATETIME NULL,
    [EnddateVouch] DATE NULL,
    [VouchNotIntrested] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_Servicing
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_Servicing]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [MemberName] VARCHAR(50) NULL,
    [MemberNo] VARCHAR(50) NULL,
    [Item] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [SubItem] INT NULL,
    [SubItemName] VARCHAR(50) NULL,
    [Checked] VARCHAR(50) NULL,
    [Approve] VARCHAR(50) NULL,
    [Quantity] INT NULL,
    [Reason] VARCHAR(500) NULL,
    [OldBarcode] VARCHAR(50) NULL,
    [NewBarcode] VARCHAR(50) NULL,
    [ReceiptNo] INT NULL,
    [Flag] VARCHAR(50) NULL,
    [Cancel] VARCHAR(10) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [ApproverName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_StockEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_StockEntry]
(
    [StockId] INT IDENTITY(1,1) NOT NULL,
    [VoucherType] INT NULL,
    [Item] INT NULL,
    [SubItem] INT NULL,
    [Quantity] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [updatedBy] VARCHAR(50) NULL,
    [SubItemName] VARCHAR(50) NULL,
    [Barcode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_StockEntry_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_StockEntry_hist]
(
    [StockId] INT IDENTITY(1,1) NOT NULL,
    [VoucherType] INT NULL,
    [Item] INT NULL,
    [SubItem] INT NULL,
    [Quantity] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [updatedBy] VARCHAR(50) NULL,
    [Barcode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_StockMaintbl
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_StockMaintbl]
(
    [StockId] INT IDENTITY(1,1) NOT NULL,
    [VoucherType] INT NULL,
    [Item] INT NULL,
    [SubItem] INT NULL,
    [Quantity] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [updatedBy] VARCHAR(50) NULL,
    [SubItemName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_StockReminderMast
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_StockReminderMast]
(
    [ReId] INT IDENTITY(1,1) NOT NULL,
    [ItemSubType] INT NULL,
    [StockAlert] INT NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_SubItemMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_SubItemMaster]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [VoucherType] INT NULL,
    [ItemId] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [ItemSubType] VARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_SubVoucherMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_SubVoucherMaster]
(
    [SubVouchId] INT IDENTITY(1,1) NOT NULL,
    [ReasonId] INT NULL,
    [VoucherId] INT NULL,
    [VoucherName] VARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_SubVoucherMaster_log
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_SubVoucherMaster_log]
(
    [SubVouchId] INT IDENTITY(1,1) NOT NULL,
    [ReasonId] INT NULL,
    [VoucherId] INT NULL,
    [VoucherName] VARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_testing
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_testing]
(
    [Vochername] VARCHAR(50) NULL,
    [ItemId] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [ItemQuantity] INT NULL,
    [ItemConsumed] INT NULL,
    [ItemPending] INT NULL,
    [Vouch_No] INT NOT NULL,
    [MemberNo] VARCHAR(50) NULL,
    [MemberName] VARCHAR(50) NULL,
    [recepitNo] VARCHAR(50) NULL,
    [IssueReason] INT NULL,
    [DateOfIssue] DATE NULL,
    [ReferralId] VARCHAR(50) NULL,
    [BuddyFormNo] VARCHAR(50) NULL,
    [VoucherName] VARCHAR(50) NULL,
    [VoucherId] VARCHAR(50) NULL,
    [StartDate] DATE NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [VEnddate] DATE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_VouchCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_VouchCategory]
(
    [V_CatId] INT IDENTITY(1,1) NOT NULL,
    [VoucherType] VARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_Voucher
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_Voucher]
(
    [VID] INT IDENTITY(1,1) NOT NULL,
    [VocherName] VARCHAR(50) NULL,
    [PlanType] VARCHAR(100) NULL,
    [V_Limit] INT NULL,
    [VType] VARCHAR(50) NULL,
    [ItemId] INT NULL,
    [ItemName] VARCHAR(50) NULL,
    [ItemQuantity] INT NULL,
    [ItemConsumed] INT NULL,
    [ItemPending] INT NULL,
    [ItemStatus] BIT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [IssueReason] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_VoucherMember
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_VoucherMember]
(
    [Vouch_No] INT IDENTITY(1,1) NOT NULL,
    [MemberNo] VARCHAR(50) NULL,
    [MemberName] VARCHAR(50) NULL,
    [recepitNo] VARCHAR(50) NULL,
    [IssueReason] INT NULL,
    [DateOfIssue] DATE NULL,
    [ReferralId] VARCHAR(50) NULL,
    [BuddyFormNo] VARCHAR(50) NULL,
    [VoucherName] VARCHAR(50) NULL,
    [VoucherId] VARCHAR(50) NULL,
    [StartDate] DATE NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [VStatus] INT NULL,
    [VoucherEndDate] DATE NULL,
    [vlimit] INT NULL,
    [DeactivatedBy] VARCHAR(20) NULL,
    [DeactivatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_VoucherMember_08Mar2018_Wrong_cafe
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_VoucherMember_08Mar2018_Wrong_cafe]
(
    [Vouch_No] INT IDENTITY(1,1) NOT NULL,
    [MemberNo] VARCHAR(50) NULL,
    [MemberName] VARCHAR(50) NULL,
    [recepitNo] VARCHAR(50) NULL,
    [IssueReason] INT NULL,
    [DateOfIssue] DATE NULL,
    [ReferralId] VARCHAR(50) NULL,
    [BuddyFormNo] VARCHAR(50) NULL,
    [VoucherName] VARCHAR(50) NULL,
    [VoucherId] VARCHAR(50) NULL,
    [StartDate] DATE NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [VStatus] INT NULL,
    [VoucherEndDate] DATE NULL,
    [vlimit] INT NULL,
    [DeactivatedBy] VARCHAR(20) NULL,
    [DeactivatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_VouReasonMast
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_VouReasonMast]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [VIssueReason] VARCHAR(500) NULL,
    [VIssueQty] INT NULL,
    [VSameUser] VARCHAR(50) NULL,
    [SubVouIssue] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VIS_VouReasonMast_05Jul2019
-- --------------------------------------------------
CREATE TABLE [dbo].[VIS_VouReasonMast_05Jul2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [VIssueReason] VARCHAR(500) NULL,
    [VIssueQty] INT NULL,
    [VSameUser] VARCHAR(50) NULL,
    [SubVouIssue] INT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.tuAutoUpdateContacts
-- --------------------------------------------------


CREATE TRIGGER tuAutoUpdateContacts ON [dbo].[CONTACTS] 
FOR UPDATE not for replication
as 
begin
   if @@rowcount = 0
      return
      
 
   if not update(gc_LastModificationTime)
   begin
      update c
      	set gc_LastModificationTime = CURRENT_TIMESTAMP
	from CONTACTS c inner join inserted i on (c.OCS_ID=i.OCS_ID)
   end
end

GO

-- --------------------------------------------------
-- VIEW dbo.FEF_APPOINTMENT
-- --------------------------------------------------

cREATE vIEW FEF_APPOINTMENT
AS
SELECT EnquiryNo,EnquiryName,MobileNo,
CONVERT(DATETIME,SUBSTRING(REPLACE(ReminderDate,'  ','-'),1,10)) AS ReminderDate
,Remark,Appointment,Counseller,
CONVERT(DATETIME,SUBSTRING(REPLACE(ReminderTime,'  ','-'),1,10)) AS ReminderTime
FROM FEF_AppointmentRpt WITH (NOLOCK)

GO

-- --------------------------------------------------
-- VIEW dbo.FEF_APPOINTMENT_LAST
-- --------------------------------------------------
CREATE VIEW FEF_APPOINTMENT_LAST    
AS     
SELECT min(A.ENQUIRYNO) as ENQUIRYNO,A.MOBILENO,convert(datetime,enquiryDt) as REMINDERDATE,min(EmpName) as COUNSELLER FROM FEF_EnquiryList A JOIN    
(select MOBILENO,MIN(convert(datetime,enquiryDt)) AS REMINDERDATE  from FEF_EnquiryList GROUP BY MOBILENO) B    
ON convert(datetime,a.enquiryDt)=B.REMINDERDATE AND A.MOBILENO=B.MOBILENO    
GROUP BY A.MOBILENO,enquiryDt,EmpName

GO

-- --------------------------------------------------
-- VIEW dbo.FEF_EnquiryList_vw
-- --------------------------------------------------
CREATE View FEF_EnquiryList_vw  
as  
select min(convert(int,EnquiryNo)) as EnquiryNo,mobileno,COUNT(1) as NoofCalls,  
max(isnull(memberno,'')) as memberno   
from FEF_EnquiryList  
group by mobileno

GO

-- --------------------------------------------------
-- VIEW dbo.fEF_JDemail_VW_Distinct
-- --------------------------------------------------
CREATE vIEW fEF_JDemail_VW_Distinct  
as  
select   
max(sendEREmailAddress) as sendorEmailAddress,  
MIN(senton) as Senton,  
--MAX(ISNULL(guid,'')) as Guid,  
MAX(name) as Name,  
MAX(City) as City,  
Phone, 
EnquiryFor,
Area, 
Min(Src) as Src,  
max(ISNULL(DNC,'')) as DNC,  
max(ISNULL(phone1,'')) as Phone1,  
FEF_EnquiryNo,  
FEF_MemberNo,  
Min(NoOfCalls) as NoOfCalls  
from fEF_JDemail with (nolock)  
group by Phone,FEF_EnquiryNo,FEF_MemberNo,EnquiryFor,Area

GO

-- --------------------------------------------------
-- VIEW dbo.fEF_JDemail_VW_Distinct_15Feb2017
-- --------------------------------------------------

  
cREATE vIEW fEF_JDemail_VW_Distinct_15Feb2017  
as  
select   
max(sendEREmailAddress) as sendorEmailAddress,  
MIN(senton) as Senton,  
--MAX(ISNULL(guid,'')) as Guid,  
MAX(name) as Name,  
MAX(City) as City,  
Phone,  
Min(Src) as Src,  
max(ISNULL(DNC,'')) as DNC,  
max(ISNULL(phone1,'')) as Phone1,  
FEF_EnquiryNo,  
FEF_MemberNo,  
Min(NoOfCalls) as NoOfCalls  
from fEF_JDemail with (nolock)  
group by Phone,FEF_EnquiryNo,FEF_MemberNo

GO

-- --------------------------------------------------
-- VIEW dbo.FEF_LeadCall
-- --------------------------------------------------
CREATE View FEF_LeadCall              
as                  
select                    
a.senton as Lead_Date,                  
misc.dbo.propercase(a.Name) as Name,ISNULL(a.Phone,'') as Phone,                  
ISNULL(a.Phone,'')+'  '+ISNULL(a.Phone1,'') as Contact_No,                  
Src as Source,sendorEmailAddress,EnquiryFor,Area,                  
(Case when a.FEF_EnquiryNo='' then 'Not Called' else a.FEF_EnquiryNo end) as Enquiry_No,                  
ISNULL(ReminderDate,'jAN  1 1900') as First_Contact_Date,                  
NoofCalls,          
misc.dbo.propercase(isnull(Counseller,'')) as Counseller,                  
(Case when isnull(REplace(a.FEF_MemberNo,'NULL',''),'') <> '' then 'Yes' else '' end) as membership_no                   
from                   
fEF_JDemail_VW_Distinct a left outer join FEF_APPOINTMENT_LAST b                   
on a.FEF_EnquiryNo=b.EnquiryNo

GO

-- --------------------------------------------------
-- VIEW dbo.FEF_LeadCall_15Feb2017
-- --------------------------------------------------
CREATE View FEF_LeadCall_15Feb2017              
as                  
select                    
a.senton as Lead_Date,                  
misc.dbo.propercase(a.Name) as Name,ISNULL(a.Phone,'') as Phone,                  
ISNULL(a.Phone,'')+' '+ISNULL(DNC,'')+' '+ISNULL(a.Phone1,'') as Contact_No,                  
Src as Source,                  
(Case when a.FEF_EnquiryNo='' then 'Not Called' else a.FEF_EnquiryNo end) as Enquiry_No,                  
ISNULL(ReminderDate,'jAN  1 1900') as First_Contact_Date,                  
NoofCalls,          
misc.dbo.propercase(isnull(Counseller,'')) as Counseller,                  
(Case when isnull(REplace(a.FEF_MemberNo,'NULL',''),'') <> '' then 'Yes' else '' end) as membership_no                   
from                   
fEF_JDemail_VW_Distinct a left outer join FEF_APPOINTMENT_LAST b                   
on a.FEF_EnquiryNo=b.EnquiryNo

GO

