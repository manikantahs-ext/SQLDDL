-- DDL Export
-- Server: 10.253.33.89
-- Database: SBAudit
-- Exported: 2026-02-05T02:39:27.268979

USE SBAudit;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SearchSubBrokerDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[stp_SearchSubBrokerDetails]    
 @sb_tag varchar(100)    
AS    
BEGIN    
 SET NOCOUNT ON;     
             
   --declare @sb_tag varchar(100)    
   create table #sbSegments    
   (       
   Segments varchar(100)    
   )    
    
   insert into #sbSegments (Segments)    
   exec usp_SubBrokerView_GetSBRegisteredSegments @sb_tag    
    
   declare @segments as varchar(100)    
   select @segments=Segments from #sbSegments    
    
   select A.SBTAG,A.TradeName SBName,b.MobNo TerMobNo,a.Sbcat Category,    
   (b.AddLine1+ ' ' + b.AddLine2 + ' ' + b.Landmark + ' ' + b.City+ ' ' + b.[State]+ ' ' + b.PinCode) strAddress,isnull(@segments,'') Segments,    
   '' CTCL_Details    
   from [MIS].sb_comp.dbo.sb_broker a     
   left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'    
   where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))    
    
    
  --SELECT SBTAG, SBName, TerMobNo, Category,    
  --(TerAddline1 + ' ' +  TerAddline2  + ' ' +  TerLandmark + ' ' + TerCity + ' ' + TerState + ' ' + TerPincode) as strAddress    
  --FROM [172.31.16.95].NXT.dbo.SBDetailsWithLedgerBal_syn WITH (NOLOCK)    
  --WHERE UPPER(SBTAG)= UPPER('AAA')    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SearchSubBrokerDetails_03Sep2021
-- --------------------------------------------------
CREATE PROCEDURE [stp_SearchSubBrokerDetails_03Sep2021]
	@sb_tag varchar(100)
AS
BEGIN
	SET NOCOUNT ON;	
	        
			--declare @sb_tag varchar(100)
			create table #sbSegments
			(			
			Segments varchar(100)
			)

			insert into #sbSegments (Segments)
			exec [172.31.16.95].NXT.dbo.usp_IPartner_SubBrokerView_GetSBRegisteredSegments @sb_tag

			declare @segments as varchar(100)
			select @segments=Segments from #sbSegments

			select A.SBTAG,A.ContactPerson SBName,b.MobNo TerMobNo,a.Sbcat Category,
			(b.AddLine1+ ' ' + b.AddLine2 + ' ' + b.Landmark + ' ' + b.City+ ' ' + b.[State]+ ' ' + b.PinCode) strAddress,@segments Segments,
			'' CTCL_Details
			from [196.1.115.167].sb_comp.dbo.sb_broker a 
			left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno and b.Addtype='RES'
			where a.sbtag=@sb_tag


		--SELECT SBTAG, SBName, TerMobNo, Category,
		--(TerAddline1 + ' ' +  TerAddline2  + ' ' +  TerLandmark + ' ' + TerCity + ' ' + TerState + ' ' + TerPincode) as strAddress
		--FROM [172.31.16.95].NXT.dbo.SBDetailsWithLedgerBal_syn WITH (NOLOCK)
		--WHERE UPPER(SBTAG)= UPPER('AAA')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SearchSubBrokerDetails_05Nov2020
-- --------------------------------------------------
CREATE PROCEDURE [stp_SearchSubBrokerDetails_05Nov2020]
	@sb_tag varchar(100)
AS
BEGIN
	SET NOCOUNT ON;	
	
			select A.SBTAG,A.ContactPerson SBName,b.MobNo TerMobNo,a.Sbcat Category,
			(b.AddLine1+ ' ' + b.AddLine2 + ' ' + b.Landmark + ' ' + b.City+ ' ' + b.[State]+ ' ' + b.PinCode) strAddress
			from [196.1.115.167].sb_comp.dbo.sb_broker a 
			left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno and b.Addtype='OFF'
			where a.sbtag=@sb_tag


		--SELECT SBTAG, SBName, TerMobNo, Category,
		--(TerAddline1 + ' ' +  TerAddline2  + ' ' +  TerLandmark + ' ' + TerCity + ' ' + TerState + ' ' + TerPincode) as strAddress
		--FROM [172.31.16.95].NXT.dbo.SBDetailsWithLedgerBal_syn WITH (NOLOCK)
		--WHERE UPPER(SBTAG)= UPPER('AAA')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SearchSubBrokerDetails_23sep2022
-- --------------------------------------------------
create PROCEDURE [dbo].[stp_SearchSubBrokerDetails_23sep2022]
	@sb_tag varchar(100)
AS
BEGIN
	SET NOCOUNT ON;	
	        
			--declare @sb_tag varchar(100)
			create table #sbSegments
			(			
			Segments varchar(100)
			)

			insert into #sbSegments (Segments)
			exec [172.31.16.95].NXT.dbo.usp_IPartner_SubBrokerView_GetSBRegisteredSegments @sb_tag

			declare @segments as varchar(100)
			select @segments=Segments from #sbSegments

			select A.SBTAG,A.ContactPerson SBName,b.MobNo TerMobNo,a.Sbcat Category,
			(b.AddLine1+ ' ' + b.AddLine2 + ' ' + b.Landmark + ' ' + b.City+ ' ' + b.[State]+ ' ' + b.PinCode) strAddress,@segments Segments,
			'' CTCL_Details
			from [196.1.115.167].sb_comp.dbo.sb_broker a 
			left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'
			where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))


		--SELECT SBTAG, SBName, TerMobNo, Category,
		--(TerAddline1 + ' ' +  TerAddline2  + ' ' +  TerLandmark + ' ' + TerCity + ' ' + TerState + ' ' + TerPincode) as strAddress
		--FROM [172.31.16.95].NXT.dbo.SBDetailsWithLedgerBal_syn WITH (NOLOCK)
		--WHERE UPPER(SBTAG)= UPPER('AAA')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SearchSubBrokerDetails_30nov2023
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[stp_SearchSubBrokerDetails_30nov2023]  
 @sb_tag varchar(100)  
AS  
BEGIN  
 SET NOCOUNT ON;   
           
   --declare @sb_tag varchar(100)  
   create table #sbSegments  
   (     
   Segments varchar(100)  
   )  
  
   insert into #sbSegments (Segments)  
   exec [172.31.16.95].NXT.dbo.usp_IPartner_SubBrokerView_GetSBRegisteredSegments @sb_tag  
  
   declare @segments as varchar(100)  
   select @segments=Segments from #sbSegments  
  
   select A.SBTAG,A.TradeName SBName,b.MobNo TerMobNo,a.Sbcat Category,  
   (b.AddLine1+ ' ' + b.AddLine2 + ' ' + b.Landmark + ' ' + b.City+ ' ' + b.[State]+ ' ' + b.PinCode) strAddress,@segments Segments,  
   '' CTCL_Details  
   from [196.1.115.167].sb_comp.dbo.sb_broker a   
   left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'  
   where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))  
  
  
  --SELECT SBTAG, SBName, TerMobNo, Category,  
  --(TerAddline1 + ' ' +  TerAddline2  + ' ' +  TerLandmark + ' ' + TerCity + ' ' + TerState + ' ' + TerPincode) as strAddress  
  --FROM [172.31.16.95].NXT.dbo.SBDetailsWithLedgerBal_syn WITH (NOLOCK)  
  --WHERE UPPER(SBTAG)= UPPER('AAA')  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SubBrokerQuestionsMaster
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[stp_SubBrokerQuestionsMaster]      
(      
@SbType varchar(5),      
@Version varchar(5)=null,      
@SbTag varchar(20)=null,      
@AuditType varchar(20)=null,       
@Auditor varchar(50) =null,      
@mode int      
)      
AS        
BEGIN        
 SET NOCOUNT ON;         
 if @mode=1      
 begin      
  SELECT * FROM tbl_SubBrokerAuditQustionMaster WITH (NOLOCK)        
  WHERE sStatus='A' and SBType=@SbType and version=@version and AuditType=@AuditType      
 end       
       
 if @mode=2      
  begin      
        
 select top 1 @version=Version from tbl_SubBrokerAuditQustionMaster where sStatus='A' and IsActive='A' and SBType=@SbType and AuditType=@AuditType      
   if not exists (select * from tbl_AuditStatus where SbTag=@Sbtag and AuditStatus!='3' )        
    begin   
      
     insert into tbl_AuditStatus(sbtag,apname,auditstatus,logdate,version,AuditType)            
     select @Sbtag,@Auditor,'1',getdate(),@version,@AuditType        
    End     
 Else    
  Begin    
    
      update tbl_AuditStatus set apname=@Auditor,auditstatus='1',logdate=getdate(),[version]=@version,AuditType=@AuditType where Sbtag=@Sbtag and AuditStatus!='3'    
    
  End    
      
   select a.nid,b.Qid,a.version,a.sbtype,a.sQuestion,b.option_Yes,b.option_No,b.option_NA,b.option_Others,b.Option_Remarks,b.Option_UploadDocument      
   from tbl_SubBrokerAuditQustionMaster a with (nolock)       
   inner join tbl_Question_Options b on a.nId=b.Qid      
   where sStatus='A' and IsActive='A' and a.SBType=@SbType and a.AuditType=@AuditType      
   order by a.nId      
         
        
 end       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SubBrokerQuestionsMaster_11jun2022
-- --------------------------------------------------
CREATE PROCEDURE [stp_SubBrokerQuestionsMaster_11jun2022]  
   
AS  
BEGIN  
 SET NOCOUNT ON;    
  SELECT * FROM tbl_SubBrokerAuditQustionMaster WITH (NOLOCK)  
  WHERE sStatus='A'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SubBrokerQuestionsMaster_21feb2024
-- --------------------------------------------------
CREATE PROCEDURE [stp_SubBrokerQuestionsMaster_21feb2024]    
(  
@SbType varchar(5)  
)     
AS    
BEGIN    
 SET NOCOUNT ON;      
  SELECT * FROM tbl_SubBrokerAuditQustionMaster WITH (NOLOCK)    
  WHERE sStatus='A'   and SBType=@SbType  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_APAudit_getstatus
-- --------------------------------------------------
create proc [dbo].[usp_APAudit_getstatus]          
(          
@SbTag varchar(10),          
@fromdate varchar(20),          
@todate varchar(20)          
)          
As          
BEGIN          
    
set @todate=@todate +' 23:55:50'    
    
select b.Nid AS Qid ,A.SBtag,A.Updateddate AuditDate,b.Squestion Checklist,A.Answer ,a.SrNO         
from [tbl_SubBrokerAuditAnswers] a          
left outer join [tbl_SubBrokerAuditQustionMaster] b on A.Qno=b.nId           
where A.Answer in   (select * from string_split((select NonCompliant from [tbl_SubBrokerAuditQustionMaster] where Nid= A.qno),',') )            
and A.sbtag=@SbTag and A.updateddate between @fromdate and @todate          
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ApAudit_SummaryRPT
-- --------------------------------------------------
/*-https://angelbrokingpl.atlassian.net/browse/SRE-24957*/
Create proc usp_ApAudit_SummaryRPT  
(  
@SbTag varchar(10),    
@fromdate varchar(20),    
@todate varchar(20)    
)  
AS  
BEGIN  
  select SbTag,AuditStatus,LogDate, AuditType from [tbl_AuditStatus] where SbTag=@SbTag  
   and Logdate between @fromdate and @todate    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_APAudit_updateDocInfo
-- --------------------------------------------------
CREATE proc [dbo].[usp_APAudit_updateDocInfo]          
(          
@SbTag varchar(10),          
@UploadPath varchar(200),        
@Remarks varchar(100),        
@Qid varchar(10),    
@Srno Varchar(10)    
)          
As          
Begin          
 insert into tbl_APDocUpload(SbTag,UploadPath,UploadDatetime,Remarks,Qid,ChkListID)          
 values(@SbTag,@UploadPath,getdate(),@Remarks,@Qid,@Srno)          
        
    declare @V as varchar(5) ,@AT as varchar(5)        
    select @V=[Version],@AT=AuditType from [tbl_SubBrokerAuditQustionMaster] where NID=@Qid        
           
  -- update [tbl_SubBrokerAuditAnswers] set Answer='Yes' where Srno=@Srno    
    
      update tbl_AuditStatus         
    set auditstatus = 5        
    where SbTag=@Sbtag --and [Version]=@version --and AuditType=        
    and auditstatus  =4 and [Version]=@V and AuditType=@AT         
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_APAudit_updateStatus
-- --------------------------------------------------
CREATE proc usp_APAudit_updateStatus    
AS    
BEGIN    
  update tbl_SBPlannedAuditMIS      
  Set AuditStatus='Pending'    
  where AuditStartDate < getdate() and AuditStatus='New'    
    
update a    
  Set AuditStatus='Completed',AuditCompleteddate=b.Logdate ,  AuditFile=c.Filepath,  
  AuditObservation= case when  b.AuditStatus=3 then 'Compliant' else 'Non-Compliant' end  
  from  tbl_SBPlannedAuditMIS a    
  inner join  SbAudit.dbo.tbl_AuditStatus  b on A.APTag =b.Sbtag    
  inner join SbAudit.[dbo].[tbl_SBAuditpdfLogs] c on a.APTag = c.SbTag  
  where A.AuditStatus not in ('Completed','Cancelled') and b.AuditStatus in(3,6)  
  and b.Logdate = (select max(logdate) from SbAudit.dbo.tbl_AuditStatus where sbtag=A.APTag)    
  and c.pdfdownloaddate = (select max(pdfdownloaddate) from SbAudit.dbo.[tbl_SBAuditpdfLogs] where sbtag=A.APTag)     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ApListfileUpload
-- --------------------------------------------------
create proc USP_ApListfileUpload  
(@FileName varchar(200))  
AS  
BEGIN  
--select top 0 APTag,FY,AuditStartDate,AuditorID,AuditorName,AuditorEmail into tmp_SBPlannedAuditMIS from tbl_SBPlannedAuditMIS  
   -- declare @FileName as varchar(100)='DummyAplist.csv'                              
    truncate table tmp_SBPlannedAuditMIS                      
                   
    Declare @filePath varchar(500)=''                                                 
    set @filePath ='\\INHOUSELIVEAPP1-FS.angelone.in\upload1\SBAuditAPList\'+@FileName+''                                   
    DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tmp_SBPlannedAuditMIS FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=1 )';                                              
    EXEC(@sql)    
  
    truncate table tbl_SBPlannedAuditMIS  
    insert into tbl_SBPlannedAuditMIS  
 select * ,'New',null,'','',getdate() from tmp_SBPlannedAuditMIS  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Approve_Reject_AuditStatus
-- --------------------------------------------------
CREATE proc usp_Approve_Reject_AuditStatus            
@SrNo int,            
@value varchar(20)            
as            
begin          
          
declare @sbtag varchar(20)          
 update tbl_APDocUpload set IsApproved =@value where srno=@SrNo            
        
  update [tbl_SubBrokerAuditAnswers] set Answer=@value where Srno in(select chkListID from tbl_APDocUpload where srno=@SrNo)            
      
  select @sbtag=sbtag from tbl_APDocUpload where srno=@SrNo     
  -- if  exists(select count(1) from tbl_APDocUpload where sbtag=@sbtag and IsApproved='No')       
  if  exists(select 1 from [tbl_SubBrokerAuditAnswers] where sbtag=@sbtag and Answer='No' and updateddate = (select top 1 updateddate from [tbl_SubBrokerAuditAnswers] where sbtag=@sbtag and srno=@SrNo)  )        
    Begin          
    update tbl_AuditStatus set AuditStatus=4          
    where SbTag=@sbtag and AUditStatus=5          
 End          
  Else          
   Begin          
       update tbl_AuditStatus set AuditStatus=3          
    where SbTag=@sbtag and AUditStatus=5          
        
 /*Notify NXT*/        
 exec usp_NXTNotificationAuditComplete @sbtag        
        
   End          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Approve_Reject_AuditStatus_uat
-- --------------------------------------------------
CREATE proc usp_Approve_Reject_AuditStatus_uat  
@SrNo int,  
@value varchar(20)  
as  
begin  

  exec [10.253.42.53].sbaudit_uat.dbo.usp_Approve_Reject_AuditStatus @SrNo,@value
 --update [10.253.42.53].sbaudit_uat.dbo.tbl_APDocUpload set IsApproved =@value where srno=@SrNo  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditResponse
-- --------------------------------------------------
CREATE proc [dbo].[usp_AuditResponse]                
(                
@SBAnswers  [ty_TBLSbResponse] readonly,                
@AuditDate varchar(50)          
)                
AS                
Begin                
     
declare @Sbtag as varchar(10)                
declare @Auditor as varchar(50)             
declare @Qno as int            
declare @version varchar(20)         
declare @audittype varchar(10)        
declare @sbtype varchar(20)        
    
select top 1 @Sbtag=Sbtag,@Auditor=Auditor from @SBAnswers        
    
if exists(select top 1 * from   tbl_SubBrokerAuditAnswers where SBtag=@Sbtag and updateddate=@AuditDate)    
 Begin    
  update tbl_SubBrokerAuditAnswers    
  set SBtag = SBtag+'_Bkp'    
  where SBtag=@Sbtag and updateddate=@AuditDate    
 End    
    
    
insert into tbl_SubBrokerAuditAnswers               
select Sbtag,Qno,Ans,Remark ,@AuditDate,Auditor,Filepath from @SBAnswers                
                
insert into tbl_AuditDateLog                
select @@identity,Sbtag,max(@AuditDate),getdate(),Auditor from @SBAnswers                
group by sbtag,Auditor                
                
    
            
 select top 1 @Qno=Qno from @SBAnswers             
          
 select @audittype=audittype,@sbtype=SBType from tbl_SubBrokerAuditQustionMaster where nId=@Qno        
 select distinct @version= version from tbl_SubBrokerAuditQustionMaster WITH (NOLOCK) where isactive='A' and sbtype=@sbtype and audittype=@audittype           
         
 ------------if not exists (select * from tbl_AuditStatus where SbTag=@Sbtag and AuditStatus!='Closed' )        
 ------------ begin        
 ------------ insert into tbl_AuditStatus(sbtag,apname,auditstatus,logdate,version)            
 ------------ select @Sbtag,@Auditor,'1',getdate(),@version        
 ------------ End          
                
 select b.SQuestion Question,A.Answer,A.Remarks from tbl_SubBrokerAuditAnswers a                
 left outer join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nID                
 where a.Updatedby=@Auditor and a.sbtag=@Sbtag and a.Updateddate between @AuditDate and @AuditDate +' 23:50:50'                 
                
 declare @fy as varchar(10)                
 declare @yr as numeric                
 set @yr =datepart(year,getdate())                
                
 if((select datepart(month,getdate()))<4)                
 Begin                
  set @fy = cast((@yr-1) as varchar) +'-'+ right(cast(@yr as varchar),2)                
 End                
 else                
 Begin                
  set @fy = cast((@yr) as varchar) +'-'+ right(cast((@yr+1) as varchar),2)                
 end                
 --print @fy                
                
--set @fy ='2021-22'                 
 --select Emp_no,Emp_name,email,Phone from risk.dbo.emp_info where emp_no=@Auditor                
                 
 select A.SBTAG,isnull(A.TradeName,a.ContactPerson) SBName,b.EmailID Email,b.AddLine1 +AddLine2+Landmark+City+' '+State as SBAddress,        
 case when C.Emp_no=@Auditor then C.AuditorsName+'('+C.Emp_no+')' else @Auditor end Auditor,@fy FY                
 ,Convert(varchar,Convert(datetime,@AuditDate,101),103) as AuditDate            
 from [MIS].sb_comp.dbo.sb_broker a                 
   left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno and b.Addtype='OFF'                
   left outer join tbl_APDetails c on c.Emp_no=@Auditor                
   where a.sbtag=@Sbtag           
           
  if Exists( select b.Nid AS Qid ,A.SBtag,A.Updateddate AuditDate,b.Squestion Checklist,A.Answer            
 from [tbl_SubBrokerAuditAnswers] a            
 left outer join [tbl_SubBrokerAuditQustionMaster] b on A.Qno=b.nId             
 where A.Answer in  (select * from string_split((select NonCompliant from [tbl_SubBrokerAuditQustionMaster] where Nid= A.qno),',') )          
 and A.sbtag=@Sbtag and A.updateddate between @AuditDate and @AuditDate +' 23:50:50'  )        
 Begin        
    update tbl_AuditStatus       
    set auditstatus = 4  ,Logdate=@AuditDate    
    where SbTag=@Sbtag and [Version]=@version --and AuditType=@audittype     
    and auditstatus in (1,2)      
            
 End        
 else        
  Begin        
     update tbl_AuditStatus      
    set auditstatus = 3  ,Logdate=@AuditDate    
    where SbTag=@Sbtag and [Version]=@version --and AuditType= @audittype    
    and auditstatus in (1,2)       
  End        
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditResponse_03Aug2023
-- --------------------------------------------------
CREATE proc [dbo].[usp_AuditResponse_03Aug2023]  
(  
@SBAnswers  ty_SbResponse readonly  
)  
AS  
Begin  
  
insert into tbl_SubBrokerAuditAnswers  
select Sbtag,Qno,Ans,Remark ,getdate(),Auditor from @SBAnswers  
  
declare @Sbtag as varchar(10)  
declare @Auditor as varchar(20)  
  
 select top 1 @Sbtag=Sbtag,@Auditor=Auditor from @SBAnswers  
  
 select b.SQuestion Question,A.Answer,A.Remarks from tbl_SubBrokerAuditAnswers a  
 left outer join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nID  
 where a.Updatedby=@Auditor and a.sbtag=@Sbtag and a.Updateddate between cast(getdate() as date) and getdate()  
  
 declare @fy as varchar(10)  
 declare @yr as numeric  
 set @yr =datepart(year,getdate())  
  
 if((select datepart(month,getdate()))<4)  
 Begin  
  set @fy = cast((@yr-1) as varchar) +'-'+ right(cast(@yr as varchar),2)  
 End  
 else  
 Begin  
  set @fy = cast((@yr) as varchar) +'-'+ right(cast((@yr+1) as varchar),2)  
 end  
 --print @fy  
  
--set @fy ='2021-22'   
 --select Emp_no,Emp_name,email,Phone from risk.dbo.emp_info where emp_no=@Auditor  
   
 select A.SBTAG,A.ContactPerson SBName,b.EmailID Email,b.AddLine1 +AddLine2+Landmark+City+' '+State as SBAddress,C.AuditorsName+'('+C.Emp_no+')' Auditor,@fy FY  
 from [196.1.115.167].sb_comp.dbo.sb_broker a   
   left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno and b.Addtype='OFF'  
   left outer join tbl_APDetails c on c.Emp_no=@Auditor  
   where a.sbtag=@Sbtag  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditResponse_16sep2023
-- --------------------------------------------------
CREATE proc [dbo].[usp_AuditResponse_16sep2023]      
(      
@SBAnswers  ty_SbResponse readonly,      
@AuditDate varchar(50)      
)      
AS      
Begin      
      
insert into tbl_SubBrokerAuditAnswers      
select Sbtag,Qno,Ans,Remark ,@AuditDate,Auditor from @SBAnswers      
      
insert into tbl_AuditDateLog      
select @@identity,Sbtag,max(@AuditDate),getdate(),Auditor from @SBAnswers      
group by sbtag,Auditor      
      
declare @Sbtag as varchar(10)      
declare @Auditor as varchar(20)      
      
 select top 1 @Sbtag=Sbtag,@Auditor=Auditor from @SBAnswers      
      
 select b.SQuestion Question,A.Answer,A.Remarks from tbl_SubBrokerAuditAnswers a      
 left outer join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nID      
 where a.Updatedby=@Auditor and a.sbtag=@Sbtag and a.Updateddate between @AuditDate and @AuditDate +' 23:50:50'       
      
 declare @fy as varchar(10)      
 declare @yr as numeric      
 set @yr =datepart(year,getdate())      
      
 if((select datepart(month,getdate()))<4)      
 Begin      
  set @fy = cast((@yr-1) as varchar) +'-'+ right(cast(@yr as varchar),2)      
 End      
 else      
 Begin      
  set @fy = cast((@yr) as varchar) +'-'+ right(cast((@yr+1) as varchar),2)      
 end      
 --print @fy      
      
--set @fy ='2021-22'       
 --select Emp_no,Emp_name,email,Phone from risk.dbo.emp_info where emp_no=@Auditor      
       
 select A.SBTAG,A.ContactPerson SBName,b.EmailID Email,b.AddLine1 +AddLine2+Landmark+City+' '+State as SBAddress,C.AuditorsName+'('+C.Emp_no+')' Auditor,@fy FY      
 ,Convert(varchar,Convert(datetime,@AuditDate,101),103) as AuditDate  
 from [196.1.115.167].sb_comp.dbo.sb_broker a       
   left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno and b.Addtype='OFF'      
   left outer join tbl_APDetails c on c.Emp_no=@Auditor      
   where a.sbtag=@Sbtag      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditSB_sendOTP
-- --------------------------------------------------
CREATE proc [dbo].[usp_AuditSB_sendOTP]      
@otp varchar(20),      
@sb_tag varchar(20),    
@audittype varchar(10)=''    
AS      
BEGIN      
 declare @mailbody as varchar(1000)      
 declare @subj as varchar(500)      
 declare @EmailID as varchar(100)      
 declare @mobileno as varchar(20)      
 declare @smscontent as varchar(200)      
      
      
 select @mobileno=b.MobNo ,@EmailID=b.Emailid        
 from [MIS].sb_comp.dbo.sb_broker a       
 left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'      
 where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))      
      
      
 set @subj ='OTP for online submission of Audit observation: '+Convert(varchar,getdate(),103)      
 set @mailbody=@otp+' is OTP for online submission of audit observation report dated '+Convert(varchar,getdate(),103)+', please share with our auditors '+      
 '<br><br>Regards,<br>Angel One'      
      
 set @smscontent = @otp+' is OTP for online submission of audit observation report dt '+Convert(varchar,getdate(),103)+', please share with our auditors Regards - Angel One'      
      
 --exec Usp_SbAudit_SMSService '8788706544',@smscontent,''      
 exec Usp_SbAudit_SMSService @mobileno,@smscontent,''      
      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                    
 @RECIPIENTS = @EmailID,--'Prashant.patade@angelbroking.com',--                                    
 @blind_copy_recipients='Leon.vaz@angelbroking.com;int.sbaudit@angelbroking.com',        
 @PROFILE_NAME = 'AngelBroking',                                    
 @BODY_FORMAT ='HTML',              
 @SUBJECT = @subj,                                    
 --@FILE_ATTACHMENTS =@s,                                    
 @BODY =@mailbody      
    
    update tbl_AuditStatus         
    set auditstatus = 2        
    where SbTag=@sb_tag and AuditType= @audittype and auditstatus  =1      
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditSB_sendOTP_11jun2022
-- --------------------------------------------------
CREATE proc [dbo].[usp_AuditSB_sendOTP_11jun2022]  
@otp varchar(20),  
@sb_tag varchar(20)  
AS  
BEGIN  
 declare @mailbody as varchar(1000)  
 declare @subj as varchar(500)  
 declare @EmailID as varchar(100)  
 declare @mobileno as varchar(20)  
 declare @smscontent as varchar(200)  
  
  
 select @mobileno=b.MobNo ,@EmailID=b.Emailid     
 from [196.1.115.167].sb_comp.dbo.sb_broker a   
 left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'  
 where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))  
  
  
 set @subj ='OTP for online submission of Audit observation: '+Convert(varchar,getdate(),103)  
 set @mailbody=@otp+' is OTP for online submission of audit observation report dated '+Convert(varchar,getdate(),103)+', please share with our auditors '+  
 '<br><br>Regards,<br>Angel One'  
  
 set @smscontent = @otp+' is OTP for online submission of audit observation report dt '+Convert(varchar,getdate(),103)+', please share with our auditors Regards - Angel One'  
  
 --exec Usp_SbAudit_SMSService '8788706544',@smscontent,''  
 exec Usp_SbAudit_SMSService @mobileno,@smscontent,''  
  
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS = @EmailID,--'Prashant.patade@angelbroking.com',--                              
 @blind_copy_recipients='Leon.vaz@angelbroking.com;',  
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',        
 @SUBJECT = @subj,                              
 --@FILE_ATTACHMENTS =@s,                              
 @BODY =@mailbody   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditSB_sendOTP_21feb2021
-- --------------------------------------------------
  
CREATE proc [dbo].[usp_AuditSB_sendOTP_21feb2021]      
@otp varchar(20),      
@sb_tag varchar(20)      
AS      
BEGIN      
 declare @mailbody as varchar(1000)      
 declare @subj as varchar(500)      
 declare @EmailID as varchar(100)      
 declare @mobileno as varchar(20)      
 declare @smscontent as varchar(200)      
      
      
 select @mobileno=b.MobNo ,@EmailID=b.Emailid         
 from [MIS].sb_comp.dbo.sb_broker a       
 left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'      
 where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))      
      
      
 set @subj ='OTP for online submission of Audit observation: '+Convert(varchar,getdate(),103)      
 set @mailbody=@otp+' is OTP for online submission of audit observation report dated '+Convert(varchar,getdate(),103)+', please share with our auditors '+      
 '<br><br>Regards,<br>Angel One'      
      
 set @smscontent = @otp+' is OTP for online submission of audit observation report dt '+Convert(varchar,getdate(),103)+', please share with our auditors Regards - Angel One'      
      
 --exec Usp_SbAudit_SMSService '8788706544',@smscontent,''      
 exec Usp_SbAudit_SMSService @mobileno,@smscontent,''      
      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                  
 @RECIPIENTS = @EmailID,--'Prashant.patade@angelbroking.com',--                                  
 @blind_copy_recipients='Leon.vaz@angelbroking.com;int.sbaudit@angelbroking.com',      
 @PROFILE_NAME = 'AngelBroking',                                  
 @BODY_FORMAT ='HTML',            
 @SUBJECT = @subj,                                  
 --@FILE_ATTACHMENTS =@s,                                  
 @BODY =@mailbody       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AuditSB_sendOTP_27jun2022
-- --------------------------------------------------
create proc [dbo].[usp_AuditSB_sendOTP_27jun2022]  
@otp varchar(20),  
@sb_tag varchar(20)  
AS  
BEGIN  
 declare @mailbody as varchar(1000)  
 declare @subj as varchar(500)  
 declare @EmailID as varchar(100)  
 declare @mobileno as varchar(20)  
 declare @smscontent as varchar(200)  
  
  
 select @mobileno=b.MobNo ,@EmailID=b.Emailid     
 from [196.1.115.167].sb_comp.dbo.sb_broker a   
 left outer join [196.1.115.167].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'  
 where a.sbtag=@sb_tag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))  
  
  
 set @subj ='OTP for online submission of Audit observation: '+Convert(varchar,getdate(),103)  
 set @mailbody=@otp+' is OTP for online submission of audit observation report dated '+Convert(varchar,getdate(),103)+', please share with our auditors '+  
 '<br><br>Regards,<br>Angel One'  
  
 set @smscontent = @otp+' is OTP for online submission of audit observation report dt '+Convert(varchar,getdate(),103)+', please share with our auditors Regards - Angel One'  
  
 --exec Usp_SbAudit_SMSService '8788706544',@smscontent,''  
 exec Usp_SbAudit_SMSService @mobileno,@smscontent,''  
  
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS = @EmailID,--'Prashant.patade@angelbroking.com',--                              
 @blind_copy_recipients='Leon.vaz@angelbroking.com',  
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',        
 @SUBJECT = @subj,                              
 --@FILE_ATTACHMENTS =@s,                              
 @BODY =@mailbody   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_auditstatus
-- --------------------------------------------------
CREATE proc usp_auditstatus      
@FromDate varchar(20),          
@ToDate varchar(20),    
@sbtag varchar(20)=null    
as      
begin      
 select b.Srno Id,a.sbtag,apname,auditstatus,a.version,b.Remarks,b.UploadPath,b.IsApproved,A.AuditStatus ,C.sQuestion   
 from tbl_AuditStatus a    
 left outer join     
 tbl_APDocUpload b on a.sbtag=b.sbtag    
 left outer join [dbo].[tbl_SubBrokerAuditQustionMaster] c on b.QID=c.nId  
 where a.Logdate between Convert(datetime,@FromDate,103) and convert(datetime,@ToDate,103)+' 23:50:50'       
 and b.UploadDatetime  between Convert(datetime,@FromDate,103) and convert(datetime,@ToDate,103)+' 23:50:50'         
 and a.sbtag=isnull(@sbtag,a.sbtag)    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_auditstatus_uat
-- --------------------------------------------------

CREATE proc usp_auditstatus_uat    
@FromDate varchar(20),        
@ToDate varchar(20),  
@sbtag varchar(20)=null  
as    
begin    
	exec [10.253.42.53].sbaudit_uat.dbo.usp_auditstatus
	@FromDate =@FromDate,
	@ToDate =@ToDate,
	@sbtag =@sbtag
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ChkAuthAP
-- --------------------------------------------------
CREATE proc [dbo].[usp_ChkAuthAP]    
(    
@emp_no as varchar(20)    
)    
As    
BEGIN    
   declare @UserRole as varchar(20)=''  
 if exists(select AuditorsName from [tbl_APDetails] where Emp_no=@emp_no)    
  BEGIN    
   select @UserRole=UserRole from [tbl_APDetails] where Emp_no=@emp_no  
   select 'True' flag  ,@UserRole UserRole  
  End    
 Else    
   Begin    
     select 'False' flag  ,'' UserRole  
   End    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ChkAuthAP_21feb2024
-- --------------------------------------------------
CREATE proc [dbo].[usp_ChkAuthAP_21feb2024]  
(  
@emp_no as varchar(20)  
)  
As  
BEGIN  
   
 if exists(select AuditorsName from [tbl_APDetails] where Emp_no=@emp_no)  
  BEGIN  
   select 'True' flag  
  End  
 Else  
   Begin  
     select 'False' flag  
   End  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getAPList
-- --------------------------------------------------
CREATE proc [dbo].[usp_getAPList]        
(    
@Auditor as varchar(20)=null,    
@SBtag as varchar(20)=null,    
@AuditObservation as varchar(50)='ALL',    
@AuditStatus  as varchar(20)='ALL' ,    
@startdate  as varchar(25)=null,    
@todate  as varchar(25)=null,    
@CompletionStartdate  as varchar(25)=null,    
@CompletionEnddate  as varchar(25)=null,    
@flag  as varchar(25)=null    
)    
AS        
BEGIN        
    
if(@CompletionEnddate is not null and @CompletionEnddate !='')    
 Begin    
 set @CompletionEnddate = @CompletionEnddate +' 23:50:50'    
 End    
 if(@todate is not null and @todate !='')    
 Begin    
 set @todate = @todate +' 23:50:50'    
 End    
    
 if(@Auditor='')    
 set @Auditor=null    
    
 if(@SBtag='')    
 set @SBtag = null    
    
 if(@AuditStatus='All')    
 set @AuditStatus =null    
    
 if(@AuditObservation='All' or @AuditObservation='')    
 set @AuditObservation =null    
  
 declare  @CompletionStartdatetemp as varchar(25)=@CompletionStartdate  
    
 select  @startdate =case when @startdate is null  or @startdate='' then Convert(varchar,min(AuditStartDate),103) else @startdate end,     
     @todate= case when @todate is null  or @todate='' then convert(varchar,max(AuditStartDate),103) else @todate end,   
     @CompletionStartdate =case when @CompletionStartdate is null or @CompletionStartdate='' then Convert(varchar,min(AuditCompleteddate),103) else @CompletionStartdate end ,     
     @CompletionEnddate= case when @CompletionEnddate is null or @CompletionEnddate='' then convert(varchar,max(AuditCompleteddate),103) else @CompletionEnddate end     
 from tbl_SBPlannedAuditMIS    
    
  --print (@startdate)  
  --print(@todate)  
  --print (@CompletionStartdate)  
  --print(@CompletionEnddate)  
    
    
if (@flag is null)    
Begin    
    
 select APTag,FY,Convert(varchar,AuditStartDate,103)AuditStartDate,AuditorID,AuditorName,AuditStatus,Convert(varchar,AuditCompleteddate,103)AuditCompleteddate,        
 AuditObservation,replace(replace(AuditFile,'\\INHOUSELIVEAPP1-FS.angelone.in\','//rm.angelbroking.com/'),'\','/') Auditfile,      
 case when Auditfile='' then '' else 'AuditPDF_'+APTag end ApAuditLink      
 from dbo.tbl_SBPlannedAuditMIS    
 where AuditorID= isnull(@Auditor,AuditorID)    
  and  APTag = isnull(@SBtag,APTag)    
  and AuditObservation  = isnull(@AuditObservation,AuditObservation)    
  and AuditStatus = isnull(@AuditStatus,AuditStatus)    
  and AuditStartDate between Convert(datetime,@startdate,103) and Convert(datetime,@todate,103)    
  and (isnull(AuditCompleteddate,'') = isnull(Convert(datetime,@CompletionStartdatetemp,103),'')   
   or AuditCompleteddate between Convert(datetime,@CompletionStartdate,103) and Convert(datetime,@CompletionEnddate,103)    
  )  
End    
Else    
 Begin    
    
 truncate table tbl_SBPlannedAuditMIS_dwnload    
    
 insert into tbl_SBPlannedAuditMIS_dwnload    
 select 'APTag','FY','AuditStartDate','AuditorID','AuditorName','AuditStatus','AuditCompleteddate','AuditObservation','Auditfile'    
    
 insert into tbl_SBPlannedAuditMIS_dwnload    
 select APTag,FY,Convert(varchar,AuditStartDate,103)AuditStartDate,AuditorID,AuditorName,AuditStatus,Convert(varchar,AuditCompleteddate,103)AuditCompleteddate,        
AuditObservation,replace(replace(AuditFile,'\\INHOUSELIVEAPP1-FS.angelone.in\','//rm.angelbroking.com/'),'\','/') Auditfile      
--case when Auditfile='' then '' else 'AuditPDF_'+APTag end ApAuditLink    
from dbo.tbl_SBPlannedAuditMIS    
where AuditorID= isnull(@Auditor,AuditorID)    
 and  APTag = isnull(@SBtag,APTag)    
 and AuditObservation  = isnull(@AuditObservation,AuditObservation)    
 and AuditStatus = isnull(@AuditStatus,AuditStatus)    
 and AuditStartDate between Convert(datetime,@startdate,103) and Convert(datetime,@todate,103)    
  and (isnull(AuditCompleteddate,'') = isnull(Convert(datetime,@CompletionStartdatetemp,103),'')   
  or AuditCompleteddate between Convert(datetime,@CompletionStartdate,103) and Convert(datetime,@CompletionEnddate,103)    
  )  
     
  DECLARE @BCPCOMMAND1 VARCHAR(500)                
  --declare @s2 as varchar(max)                                
  DECLARE @filename2 as varchar(100)                
                     
                                 
  SET @FILENAME2 = '\\INHOUSELIVEAPP1-FS.angelone.in\upload1\SBAuditAPList\ApAuditList_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'                                                                                               
  --SET @FILENAME = '\\196.1.115.182\upload1\OmnesysFileFormat\CodeCreationFileFormat'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                    
                                                              
                                  
  SET @BCPCOMMAND1 = 'BCP "select * from dustbin.dbo.tbl_SBPlannedAuditMIS_dwnload " QUERYOUT "'                                
     print(@BCPCOMMAND1)                          
  SET @BCPCOMMAND1 = @BCPCOMMAND1 + @FILENAME2 + '" -c -t, -SABVSNCMS.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                      
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1           
      
  select replace(@FILENAME2,'INHOUSELIVEAPP1-FS.angelone.in','rm.angelbroking.com')     
    
End    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPDFdata_SB
-- --------------------------------------------------
CREATE proc [dbo].[usp_getPDFdata_SB]          
(          
@SBtag  varchar(20) ,        
@Auditor varchar(20)        
)          
AS          
Begin          
          
        
--declare @Sbtag as varchar(10)          
--declare @Auditor as varchar(20)          
          
 --select top 1 @Sbtag=Sbtag,@Auditor=Auditor from @SBAnswers          
          
 --select b.SQuestion Question,A.Answer,A.Remarks from tbl_SubBrokerAuditAnswers a          
 --left outer join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nID          
 --where a.Updatedby=@Auditor and         
 --a.sbtag=@Sbtag and a.Updateddate >= '07/01/2022'        
        
 select b.SQuestion Question,A.Answer,A.Remarks,Convert(varchar,updateddate,103) Auditdate from [tbl_SubBrokerAuditAnswers] a         
  left outer join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nID          
 where updateddate =        
(select max(updateddate) from [tbl_SubBrokerAuditAnswers] where sbtag=a.sbtag and updateddate between  '07/15/2023' and'07/16/2023' )        
and a.Updatedby=@Auditor and         
 a.sbtag=@Sbtag and a.Updateddate between  '07/15/2023' and'07/16/2023'       
        
        
          
 declare @fy as varchar(10)          
 declare @yr as numeric          
 set @yr =datepart(year,getdate())          
          
 if((select datepart(month,getdate()))<4)          
 Begin          
  set @fy = cast((@yr-1) as varchar) +'-'+ right(cast(@yr as varchar),2)          
 End          
 else          
 Begin          
  set @fy = cast((@yr) as varchar) +'-'+ right(cast((@yr+1) as varchar),2)          
 end          
 --print @fy          
          
--set @fy ='2021-22'           
 --select Emp_no,Emp_name,email,Phone from risk.dbo.emp_info where emp_no=@Auditor          
           
 select A.SBTAG,A.TradeName SBName,b.EmailID Email,b.AddLine1 +AddLine2+Landmark+City+' '+State as SBAddress,C.AuditorsName+'('+C.Emp_no+')' Auditor,@fy FY          
 from [MIS].sb_comp.dbo.sb_broker a           
   left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno and b.Addtype='OFF'          
   left outer join tbl_APDetails c on c.Emp_no=@Auditor          
   where a.sbtag=@Sbtag          
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPDFLogs
-- --------------------------------------------------
/* -https://angelbrokingpl.atlassian.net/browse/SRE-24955*/
CREATE proc usp_getPDFLogs    
(    
@Fy varchar(20),    
@sb varchar(20)=''    
)    
As    
BEGIN    
    
 -- declare @Fy varchar(20)='2021'    
  --declare  @sb varchar(20)='AAAS'    
  declare @Fromdate as varchar(20)    
  declare @Todate as varchar(20)    
    
    
  set @Fromdate ='04/01/'+@Fy    
  set @Todate ='03/31/' +cast((cast(@Fy as numeric) +1 ) as varchar)    
  --set @Fromdate = Convert(datetime,@Fromdate,103)    
  --set @Todate = Convert(datetime,@Todate,103) + ' 23:50:50'    
 -- print (@Fromdate)    
  --print (@Todate)    
    
  select SrNo,SbTag,replace(replace(Filepath,'\\196.1.115.147','D:\'),'\\INHOUSELIVEAPP1-FS.angelone.in','D:\')Filepath, pdfdownloaddate,pdfMailsent from tbl_SBAuditpdfLogs where Sbtag = @sb and pdfdownloaddate between @Fromdate and @Todate    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getSBtags
-- --------------------------------------------------
CREATE proc usp_getSBtags      
 As      
 Begin      
   select distinct sbtag,updatedby  from [dbo].[tbl_SubBrokerAuditAnswers] a where updateddate  between  '07/15/2023' and'07/16/2023'     
  -- and sbtag not in('IRSH' ,'PSRB','VPO','RISG','AMVR','RJAY')     
   and updateddate in (select max(updateddate) from [tbl_SubBrokerAuditAnswers] where updateddate  between  '07/15/2023' and'07/16/2023' and sbtag= a.SBtag)     
 End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetSubBrokerMailList
-- --------------------------------------------------
CREATE proc usp_GetSubBrokerMailList  
@Mode int  
as  
begin  
   
 create table #temp(sbtag varchar(20),audit_date datetime,Question varchar(500),updatedby varchar(100),remarks varchar(max))  
  
 truncate table tbl_SbTag_Mail  
  
 --truncate table #temp  
  
 if @Mode=1 --for non-compliant  
 begin  
  insert into #temp   
  select distinct sbtag,max(updateddate),b.sQuestion,a.updatedby,c.NonCompliantRemarks from tbl_SubBrokerAuditAnswers a  
  inner join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nId  
  inner join tbl_AuditChecklistMaster c on c.srno=b.nId  
  where answer='No'  group by SBtag,b.sQuestion,a.updatedby,c.NonCompliantRemarks  
    
  insert into tbl_SbTag_Mail   
  select distinct b.SBTAG, c.EmailId,a.audit_date,b.TradeName,a.Question,a.updatedby,a.remarks from #temp a  
  inner join [MIS].sb_comp.dbo.sb_broker b on a.SBtag=b.SBTAG  
  inner  join [MIS].sb_comp.dbo.sb_contact c on b.refno=c.refno   
  where a.sbtag=b.SBTAG and (c.Addtype='TER' OR (c.Addtype!='TER' and  c.Addtype='RES'))  
  
  --select distinct sbtag,emailid,max(audit_date) 'Audit_Date' from tbl_SbTag_Mail group by SbTag,emailid  order by Audit_Date  
  select distinct a.sbtag,a.emailid,a.audit_date,max(b.logdate) 'EmailSentOn' from tbl_SbTag_Mail a  
  left  join tbl_SubBrokerMailSendLog b on a.SbTag=b.sbtag  
  group by a.sbtag,a.emailid,a.audit_date order by a.Audit_Date  
 end  
 if @Mode=2  
 begin  
  insert into #temp     
  select distinct sbtag,dateadd(day,3,max(updateddate)),b.sQuestion,a.updatedby,c.NonCompliantRemarks from tbl_SubBrokerAuditAnswers a  
  inner join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nId  
   inner join tbl_AuditChecklistMaster c on c.srno=b.nId  
  where a.answer='No'  group by SBtag,sQuestion,a.updatedby,c.NonCompliantRemarks  
    
  insert into tbl_SbTag_Mail   
  select distinct b.SBTAG, c.EmailId,dateadd(day,-3,a.audit_date),b.TradeName,a.Question,a.updatedby,a.remarks from #temp a  
  inner join [MIS].sb_comp.dbo.sb_broker b on a.SBtag=b.SBTAG  
  inner  join [MIS].sb_comp.dbo.sb_contact c on b.refno=c.refno   
  where a.sbtag=b.SBTAG and (c.Addtype='TER' OR (c.Addtype!='TER' and  c.Addtype='RES'))   
  and a.audit_date<getdate()   
  
  --select distinct sbtag,emailid,max(audit_date) 'Audit_Date' from tbl_SbTag_Mail group by SbTag,emailid  order by Audit_Date  
  select distinct a.sbtag,a.emailid,a.audit_date,max(b.logdate) 'EmailSentOn' from tbl_SbTag_Mail a  
  left  join tbl_SubBrokerMailSendLog b on a.SbTag=b.sbtag  
  group by a.sbtag,a.emailid,a.audit_date order by a.Audit_Date  
 end  
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetSubBrokerMailList_UAT
-- --------------------------------------------------
CREATE proc usp_GetSubBrokerMailList_UAT
@Mode int
as
begin
	exec [10.253.42.53].sbaudit_uat.dbo.usp_GetSubBrokerMailList
	@Mode=@Mode
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_GetVersionList
-- --------------------------------------------------
CREATE proc Usp_GetVersionList  
as  
begin  
 select distinct version From tbl_SubBrokerAuditQustionMaster  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_LogAuditor
-- --------------------------------------------------
create proc usp_LogAuditor
(
@InAuditor varchar(50),
@ExAuditor varchar(100)
)
As
BEGIN

insert into tbl_AuditorLog(InAuditor,ExAuditor,logdate)
values(@InAuditor,@ExAuditor,getdate())

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MISAuditChecklist
-- --------------------------------------------------
CREATE proc usp_MISAuditChecklist
@FromDate varchar(20),
@ToDate varchar(20)
as
begin
	select sbtag 'AP Tag',convert(varchar(20),pdfdownloaddate,103) 'Checklist Generation Date' 
	from tbl_SBAuditpdfLogs 
	where convert(varchar(20),pdfdownloaddate,101)>=Convert(datetime,@FromDate,103) and pdfdownloaddate<=Convert(datetime,@ToDate,103)
	order by convert(varchar(20),pdfdownloaddate,101)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_NXTNotificationAuditComplete
-- --------------------------------------------------
create proc usp_NXTNotificationAuditComplete
(
 @sbtag varchar(20)
)
AS
BEGIN

 --declare @sbtag as varchar(20)='AJYC'
    DECLARE @Object AS INT;    
    DECLARE @ResponseText AS VARCHAR(8000);    
    DECLARE @TBL_RESPONSE TABLE    
    (    
    DATA VARCHAR(100)    
    )    
    
	declare @url varchar(2000)='https://orchestrator-nxt-uat.angelbroking.com/nxt/v1/nxt-service/audit-notification/'+@sbtag+''
      
    declare @token as varchar(1000)='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE4MjI2NzMwNjksImlhdCI6MTY5NjUyOTA2OSwib3JpZ19pYXQiOjE2OTY1MjkwNjksInVzZXJEYXRhIjp7InVzZXIiOjAsInVzZXJJZCI6IiIsInVzZXJUeXBlIjoiIiwicGFydG5lcklkIjoiIiwic2NvcGUiOiJzZXJ2aWNlIn19.PZQL_7CXnNUE8shEs-gF9ZX13aafaI7o8zPleEDLuTU'
   --select len(@token)
    
	EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;    
    EXEC sp_OAMethod @Object, 'open', NULL, 'GET',@url, 'false'    
      
    EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'    
    EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'X-source', 'service'  
	EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Authorization', @token 
   
    EXEC sp_OAMethod @Object, 'send', null, null    
      
    EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT    
         
    INSERT INTO @TBL_RESPONSE    
    SELECT @ResponseText    
    
	select * from @TBL_RESPONSE
    EXEC sp_OADestroy @Object  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_PDFAutoMailer
-- --------------------------------------------------
CREATE proc [dbo].[usp_PDFAutoMailer]    
AS    
BEGIN    
Declare @MESS as varchar(1000),@sub as varchar(100),@filepath as varchar(200),@sbtag as varchar(20),@sbEmail as varchar(200)    
declare @max as int,@cnter as int=1    
    
select @max=count(1) from [dbo].[tbl_SBAuditpdfLogs] where pdfMailsent is null    
    
    
 while(@cnter<=@max)    
  Begin    
  select top 1 @sbtag=SbTag,@filepath=Filepath from  [dbo].[tbl_SBAuditpdfLogs] where pdfMailsent is null    
    
    
  select @sbEmail=Emailid from [MIS].sb_comp.dbo.sb_broker a     
   left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'    
   where a.sbtag=@sbtag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))    
    
    
    
  set @MESS='Dear Partner,<br><br>   Please find attached audit report for your reference. Request you to check and resolve audit observations (If any) within 3 working days.    
  <br><br><br>Regards,<br><br>AngelOne<br><br><br>    
  Disclaimer – This is a system generated mail, Please do not reply to this mail, Please contact int.sbaudit@angelbroking.com for further assistance.'    
  set @sub ='Audit Check List'    
    
  --set @filepath='\\196.1.115.147\upload1\SBAuditPdflogs\2022\Jul\VSVU0307220507.html'    
    
  EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL    
  @from_address='int.sbaudit@angelbroking.com',    
  @RECIPIENTS =@sbEmail, --'Leon.vaz@angelbroking.com',                             
  @COPY_RECIPIENTS ='int.sbaudit@angelbroking.com', --'Leon.vaz@angelbroking.com',--    
     @blind_copy_recipients='Leon.vaz@angelbroking.com;shilpa.karne@angelbroking.com ',      
  @PROFILE_NAME = 'AngelBroking',                                
  @BODY_FORMAT ='HTML',                                
  @SUBJECT = @sub ,                        
  @FILE_ATTACHMENTS =@filepath,                                
  @BODY =@MESS    
    
    
  update [tbl_SBAuditpdfLogs] set pdfMailsent='yes' where SbTag=@sbtag and pdfMailsent is null    
    
  insert into PDFEmailLog(FromEmailID,ToEmailID,Sbtag,Filepath,updateddate)    
  values ('int.sbaudit@angelbroking.com','-',@sbtag,@filepath,getdate())    
  set @cnter =@cnter+1    
 End    
    /*-https://angelbrokingpl.atlassian.net/browse/SRE-38887*/
 --select * FROM msdb.dbo.sysmail_allitems where send_request_Date between '07/03/2022' and getdate() and subject ='Test-- Audit check list'    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_PDFAutoMailer_20aug2025
-- --------------------------------------------------
CREATE proc [dbo].[usp_PDFAutoMailer_20aug2025]    
AS    
BEGIN    
Declare @MESS as varchar(1000),@sub as varchar(100),@filepath as varchar(200),@sbtag as varchar(20),@sbEmail as varchar(200)    
declare @max as int,@cnter as int=1    
    
select @max=count(1) from [dbo].[tbl_SBAuditpdfLogs] where pdfMailsent is null    
    
    
 while(@cnter<=@max)    
  Begin    
  select top 1 @sbtag=SbTag,@filepath=Filepath from  [dbo].[tbl_SBAuditpdfLogs] where pdfMailsent is null    
    
    
  select @sbEmail=Emailid from [MIS].sb_comp.dbo.sb_broker a     
   left outer join [MIS].sb_comp.dbo.sb_contact b on a.refno=b.refno --and b.Addtype='RES'    
   where a.sbtag=@sbtag and (b.Addtype='TER' OR (b.Addtype!='TER' and  b.Addtype='RES'))    
    
    
    
  set @MESS='Dear Partner,<br><br>   Please find attached audit report for your reference. Request you to check and resolve audit observations (If any) within 3 working days.    
  <br><br><br>Regards,<br><br>AngelOne<br><br><br>    
  Disclaimer – This is a system generated mail, Please do not reply to this mail, Please contact int.sbaudit@angelbroking.com for further assistance.'    
  set @sub ='Audit Check List'    
    
  --set @filepath='\\196.1.115.147\upload1\SBAuditPdflogs\2022\Jul\VSVU0307220507.html'    
    
  EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL    
  @from_address='int.sbaudit@angelbroking.com',    
  @RECIPIENTS =@sbEmail, --'Leon.vaz@angelbroking.com',                             
  @COPY_RECIPIENTS ='int.sbaudit@angelbroking.com', --'Leon.vaz@angelbroking.com',--    
     @blind_copy_recipients='Leon.vaz@angelbroking.com;shilpa.karne@angelbroking.com ',      
  @PROFILE_NAME = 'AngelBroking',                                
  @BODY_FORMAT ='HTML',                                
  @SUBJECT = @sub ,                        
  @FILE_ATTACHMENTS =@filepath,                                
  @BODY =@MESS    
    
    
  update [tbl_SBAuditpdfLogs] set pdfMailsent='yes' where SbTag=@sbtag and pdfMailsent is null    
    
  insert into PDFEmailLog(FromEmailID,ToEmailID,Sbtag,Filepath,updateddate)    
  values ('int.sbaudit@angelbroking.com',@sbEmail,@sbtag,@filepath,getdate())    
  set @cnter =@cnter+1    
 End    
     /*-https://angelbrokingpl.atlassian.net/browse/SRE-38887*/
 --select * FROM msdb.dbo.sysmail_allitems where send_request_Date between '07/03/2022' and getdate() and subject ='Test-- Audit check list'    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SbAudit_SMSService
-- --------------------------------------------------
CREATE Proc Usp_SbAudit_SMSService
(
@MobileNO varchar(30)='',  
@SMSContent varchar(5000)='',  
@SMSPurpose varchar(300)=''  
) 
AS
BEGIN 
		  DECLARE @Object AS INT;  
		  DECLARE @ResponseText AS VARCHAR(8000);  
		  DECLARE @TBL_RESPONSE TABLE  
		  (  
		  DATA VARCHAR(100)  
		  )  
		   DECLARE @Body AS VARCHAR(8000) =   
		  '{  "mobileNo":"'+@MobileNO+'",  
			 "smsContent": "'+@SMSContent+'",  
			 "smsPuspose":"'+@SMSPurpose+'",  
			 "smsSource":"Kyc",  
			 "smsTeam":"kyc",  
			 "smsUserId":"InhousePGUser",  
			 "smsPassword": "xfFPx65"  
		       
		  }'    
		  
		  EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;  
		  EXEC sp_OAMethod @Object, 'open', NULL, 'post','https://directsmsgateway.angelbroking.com/api/angelsms', 'false'  
		  
		  EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'  
		  EXEC sp_OAMethod @Object, 'send', null, @body  
		  
		  EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT  
		     
		  INSERT INTO @TBL_RESPONSE  
		  SELECT @ResponseText  
		  
		  EXEC sp_OADestroy @Object 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBAuditAddQuestion
-- --------------------------------------------------
CREATE proc usp_SBAuditAddQuestion  
(  
@Question varchar(500) ,
@SBType varchar(5)
)  
AS  
Begin  
  
 insert into tbl_SubBrokerAuditQustionMaster (sQuestion,sStatus,dtCreationDate,SBType)  
 values(@Question,'A',getdate(),@SBType)  
  
 select 'Question has been added successfully'  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBAuditAddQuestion_11jun2022
-- --------------------------------------------------
CREATE proc usp_SBAuditAddQuestion_11jun2022  
(  
@Question varchar(500)  
)  
AS  
Begin  
  
 insert into tbl_SubBrokerAuditQustionMaster (sQuestion,sStatus,dtCreationDate)  
 values(@Question,'A',getdate())  
  
 select 'Question has been added successfully'  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBAuditAddQuestionIntermediate
-- --------------------------------------------------
CREATE proc usp_SBAuditAddQuestionIntermediate(  
@Question varchar(500)=null ,  
@Option_Yes varchar(2)=null,  
@Option_No varchar(2)=null,  
@Option_NA varchar(2)=null,  
@Option_Others varchar(2)=null,  
@Option_Remarks varchar(2)=null,  
@Option_UploadDocument varchar(2)=null,  
@Compliant varchar(20)=null,  
@NonCompliant varchar(20)=null,  
@NotApplicable varchar(20)=null,  
@AuditType varchar(20),  
@SBType varchar(5),  
@version varchar(5)=null,  
@mode int  
)  
as  
begin  
 if @mode=1  
 begin  
  if not exists(select sbtype,audittype from tbl_SubBrokerAuditQustionMasterIntermediate where sbtype=@SbType and audittype=@AuditType)  
  begin  
   insert into tbl_SubBrokerAuditQustionMasterIntermediate  
   select squestion,sStatus,dtcreationdate,sbtype,version,isactive,compliant,noncompliant,notapplicable,audittype from tbl_SubBrokerAuditQustionMaster  
   where SBType=@SBType and AuditType=@AuditType  
  
     
   insert into tbl_Question_Options_Intermediate  
   select  distinct c.nid,b.option_yes,option_no,option_na,option_others,option_remarks,option_uploaddocument from tbl_SubBrokerAuditQustionMaster a  
   inner join tbl_question_options b on a.nid=b.qid  
   inner join tbl_SubBrokerAuditQustionMasterIntermediate c on a.sQuestion=c.sQuestion  
   where a.SBType=@SBType and a.AuditType=@AuditType and a.IsACtive='A'   
   and C.SBType=@SBType and C.AuditType=@AuditType and C.IsACtive='A'  
  end  
  else  
  begin  
   --select 'Already Exists'  
   SELECT * FROM tbl_SubBrokerAuditQustionMasterIntermediate WITH (NOLOCK)    
   WHERE sStatus='A' and SBType=@SbType and AuditType=@AuditType -- and version=@version   
  end  
 end  
   
 if @mode=2  
 begin  
  insert into tbl_SubBrokerAuditQustionMasterIntermediate(sQuestion,sStatus,dtCreationDate,SBType,Version,IsActive,Compliant,NonCompliant,NotApplicable,AuditType)    
  values(@Question,'A',getdate(),@SBType,@Version,'A',@Compliant,@NonCompliant,@NotApplicable,@AuditType)    
  
  insert into tbl_Question_Options_Intermediate(Qid,Option_Yes,Option_NO,Option_NA,Option_Others,Option_Remarks,Option_UploadDocument)  
  values(@@IDENTITY,@Option_Yes,@Option_No,@Option_NA,@Option_Others,@Option_Remarks,@Option_UploadDocument)  
   
  select 'Question has been added successfully'    
 end  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sbAuditAnswers
-- --------------------------------------------------
create proc usp_sbAuditAnswers
(
@Auditor varchar(20),
@Sbtag varchar(10)
)
AS
BEGIN

 select b.SQuestion Question,A.Answer,A.Remarks from tbl_SubBrokerAuditAnswers a
 left outer join tbl_SubBrokerAuditQustionMaster b on a.Qno=b.nID
 where a.Updatedby=@Auditor and a.sbtag=@Sbtag and a.Updateddate between cast(getdate() as date) and getdate()

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBAuditRemQuestion
-- --------------------------------------------------
create proc usp_SBAuditRemQuestion
(
@Qid varchar(10)
)
As
Begin
 if exists( select 1 from tbl_SubBrokerAuditQustionMaster where nid=@Qid)
  begin
	delete from tbl_SubBrokerAuditQustionMaster where nid=@Qid
	select 'Question was deleted sucessfully'
	return
  End
 Else
  begin
   select 'Question was not found!'
   return
  End 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SubBrokerMailSend
-- --------------------------------------------------
CREATE proc usp_SubBrokerMailSend        
@SbTag varchar(max)=null,      
@other_email varchar(max)=null,      
@To_Email varchar(max)=null,      
@mode int      
as        
begin         
 if @mode=1      
 begin      
  insert into MailListSbTag values(@SbTag,@other_email,@To_Email)      
 end      
 if @mode=2      
 begin      
   Declare @Other_Emails nvarchar(MAX) = '',@RECIPIENTS_Emails nvarchar(max)        
   Select @Other_Emails = coalesce(@Other_Emails + ';', '') + other_email from MailListSbTag        
   Select @RECIPIENTS_Emails = coalesce(@RECIPIENTS_Emails + ';', '') + to_email from MailListSbTag        
   select @Other_Emails       
   --select @Other_Emails+@RECIPIENTS_Emails      
           
  Declare @Init int= 1,@Rowcount int         
  Declare @Emails nvarchar(MAX),@APTag varchar(10),@APName varchar(200),@QuestionsList varchar(max),@AuditorName varchar(100),@AuditDate varchar(20)        
  Declare @subjectMessage varchar(max), @bodyMessage varchar(max)        
         
   truncate table tbl_Sbtaglist      
      
   insert into tbl_Sbtaglist      
   select distinct sbtag from tbl_SbTag_Mail      
      
  select @Rowcount=count(*) from MailListSbTag          
  while @Init<=@Rowcount      
  begin        
    select @APTag=sbtag from MailListSbTag where id=@Init      
    select distinct @Emails=Emailid,@APName=APName,@AuditorName=b.person_name,@AuditDate=Convert(varchar(20),Audit_Date,103) from tbl_SbTag_Mail a      
    inner join Rolemgm.dbo.user_login b on b.username=a.updatedby      
    where sbtag=@APTag          
          
    declare @html as varchar(max)        
    set @html='<table border=''1''><tr style="background-color:#F4DACD"><th style="width:800px;">Audit Observations</th><th>Corrective Action</th><th>Applicable Penalty</th></tr>'        
    select  @html= @html+ '<tr><td>'+NonCompliantRemarks +'</td><td>Refer Annexure A</td><td>Refer Annexure A</td></tr>' from tbl_SbTag_Mail where sbtag=@APTag        
    set @html= @html + '</table>'        
          
    Set @subjectMessage='Clarification for Non-compliance/Discrepancies observed during the internal audit/inspection at your office – (AP tag- '+@APTag+')'        
                
     Set @bodyMessage='Dear Sir,<br>       
       '+@APName+' ('+@APTag+')<br/>        
       This is further to the inspection of your books of accounts and other records carried out by our Inspecting team on dt. '+@AuditDate+'  below mentioned are the observations raised by the Auditors Mr. '+@AuditorName+' during inspection.         
    ' +@html +'<br/>You are requested to kindly go through the said observations and provide us necessary explanation or initiate corrective action, wherever required, within 7 days from the date of the email failing which you shall be liable for necessar
  
y action including penalties as per the policy of the Company. <br/>      
    Kindly treat this as utmost important and revert at the earliest. <br/>      
    Note :- Please submit your documents to int.sbaudit@angelbroking.com mail ID.<br/>      
    Regards,<br/>          
    Internal Audit Department'      
          
   select @APTag 'APTag',@Emails 'Email',@subjectMessage 'Subject',@bodyMessage 'Body',@html 'Questions'        
      
   DECLARE @FILENAME1 as varchar(100)       
   SET @FILENAME1 = '\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\IFSCUpdate\AP Audit Annexure.docx'      
           
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                
          @RECIPIENTS = @Other_Emails,          
          @blind_copy_recipients='Leon.vaz@angelbroking.com;int.sbaudit@angelbroking.com;Mehul.Desai@angelbroking.com',      
          @PROFILE_NAME = 'AngelBroking',                                                
          @BODY_FORMAT ='HTML',                                                
          @SUBJECT = @subjectMessage,          
       @FILE_ATTACHMENTS =@FILENAME1,         
          @BODY =@bodyMessage            
          
    insert into tbl_SubBrokerMailSendLog(sbtag,email,logdate,AuditDate)        
    select sbtag,'-',getdate(),max(Audit_Date) from tbl_SbTag_Mail  where sbtag=@APTag       
    group by Sbtag,emailid       
          
    SET @Init=@Init+1         
  end        
 end      
 if @mode=3      
 begin      
  truncate table MailListSbTag      
 end        
 if @mode=4      
 begin      
  SELECT Sbtag,NonCompliantRemarks FROM tbl_SbTag_Mail where sbtag=@SbTag      
 end      
end 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-38887 */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SubBrokerMailSend_20aug2025
-- --------------------------------------------------
CREATE proc usp_SubBrokerMailSend_20aug2025        
@SbTag varchar(max)=null,      
@other_email varchar(max)=null,      
@To_Email varchar(max)=null,      
@mode int      
as        
begin         
 if @mode=1      
 begin      
  insert into MailListSbTag values(@SbTag,@other_email,@To_Email)      
 end      
 if @mode=2      
 begin      
   Declare @Other_Emails nvarchar(MAX) = '',@RECIPIENTS_Emails nvarchar(max)        
   Select @Other_Emails = coalesce(@Other_Emails + ';', '') + other_email from MailListSbTag        
   Select @RECIPIENTS_Emails = coalesce(@RECIPIENTS_Emails + ';', '') + to_email from MailListSbTag        
   select @Other_Emails       
   --select @Other_Emails+@RECIPIENTS_Emails      
           
  Declare @Init int= 1,@Rowcount int         
  Declare @Emails nvarchar(MAX),@APTag varchar(10),@APName varchar(200),@QuestionsList varchar(max),@AuditorName varchar(100),@AuditDate varchar(20)        
  Declare @subjectMessage varchar(max), @bodyMessage varchar(max)        
         
   truncate table tbl_Sbtaglist      
      
   insert into tbl_Sbtaglist      
   select distinct sbtag from tbl_SbTag_Mail      
      
  select @Rowcount=count(*) from MailListSbTag          
  while @Init<=@Rowcount      
  begin        
    select @APTag=sbtag from MailListSbTag where id=@Init      
    select distinct @Emails=Emailid,@APName=APName,@AuditorName=b.person_name,@AuditDate=Convert(varchar(20),Audit_Date,103) from tbl_SbTag_Mail a      
    inner join Rolemgm.dbo.user_login b on b.username=a.updatedby      
    where sbtag=@APTag          
          
    declare @html as varchar(max)        
    set @html='<table border=''1''><tr style="background-color:#F4DACD"><th style="width:800px;">Audit Observations</th><th>Corrective Action</th><th>Applicable Penalty</th></tr>'        
    select  @html= @html+ '<tr><td>'+NonCompliantRemarks +'</td><td>Refer Annexure A</td><td>Refer Annexure A</td></tr>' from tbl_SbTag_Mail where sbtag=@APTag        
    set @html= @html + '</table>'        
          
    Set @subjectMessage='Clarification for Non-compliance/Discrepancies observed during the internal audit/inspection at your office – (AP tag- '+@APTag+')'        
                
     Set @bodyMessage='Dear Sir,<br>       
       '+@APName+' ('+@APTag+')<br/>        
       This is further to the inspection of your books of accounts and other records carried out by our Inspecting team on dt. '+@AuditDate+'  below mentioned are the observations raised by the Auditors Mr. '+@AuditorName+' during inspection.         
    ' +@html +'<br/>You are requested to kindly go through the said observations and provide us necessary explanation or initiate corrective action, wherever required, within 7 days from the date of the email failing which you shall be liable for necessar
  
y action including penalties as per the policy of the Company. <br/>      
    Kindly treat this as utmost important and revert at the earliest. <br/>      
    Note :- Please submit your documents to int.sbaudit@angelbroking.com mail ID.<br/>      
    Regards,<br/>          
    Internal Audit Department'      
          
   select @APTag 'APTag',@Emails 'Email',@subjectMessage 'Subject',@bodyMessage 'Body',@html 'Questions'        
      
   DECLARE @FILENAME1 as varchar(100)       
   SET @FILENAME1 = '\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\IFSCUpdate\AP Audit Annexure.docx'      
           
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                                
          @RECIPIENTS = @Other_Emails,          
          @blind_copy_recipients='Leon.vaz@angelbroking.com;int.sbaudit@angelbroking.com;Mehul.Desai@angelbroking.com',      
          @PROFILE_NAME = 'AngelBroking',                                                
          @BODY_FORMAT ='HTML',                                                
          @SUBJECT = @subjectMessage,          
       @FILE_ATTACHMENTS =@FILENAME1,         
          @BODY =@bodyMessage            
          
    insert into tbl_SubBrokerMailSendLog(sbtag,email,logdate,AuditDate)        
    select sbtag,emailid,getdate(),max(Audit_Date) from tbl_SbTag_Mail  where sbtag=@APTag       
    group by Sbtag,emailid       
          
    SET @Init=@Init+1         
  end        
 end      
 if @mode=3      
 begin      
  truncate table MailListSbTag      
 end        
 if @mode=4      
 begin      
  SELECT Sbtag,NonCompliantRemarks FROM tbl_SbTag_Mail where sbtag=@SbTag      
 end      
end 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-38887 */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SubBrokerMailSend_UAT
-- --------------------------------------------------
CREATE proc usp_SubBrokerMailSend_UAT  
@SbTag varchar(max)=null,
@other_email varchar(max)=null,
@To_Email varchar(max)=null,
@mode int
as  
begin
	exec [10.253.42.53].sbaudit_uat.dbo.usp_SubBrokerMailSend
	@SbTag =@SbTag,
	@other_email =@other_email,
	@To_Email =@To_Email,
	@mode =@mode
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SubBrokerView_GetSBRegisteredSegments
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_SubBrokerView_GetSBRegisteredSegments]
    @SubBroker VARCHAR(50)
AS
BEGIN
    ;WITH Segments AS
    (
    SELECT
        regtag
        ,CASE WHEN BSECM_remi = 'Registered' THEN 'BSECM_REMI' ELSE NULL END AS BSECM_REMI
        ,CASE WHEN BSECM_SB = 'Registered' Then 'BSE' ELSE NULL END AS BSECM_SB
        ,CASE WHEN NSECM = 'Registered' Then 'NSE' ELSE NULL END AS NSECM
        ,CASE WHEN NSEFO = 'Registered' Then 'NSEFO' ELSE NULL END AS NSEFO
        ,CASE WHEN MCX = 'Registered' Then 'MCX' ELSE NULL END AS MCX
        ,CASE WHEN NCDEX = 'Registered' Then 'NCDEX' ELSE NULL END AS NCDEX
        ,CASE WHEN MCD = 'Registered' Then 'MCD' ELSE NULL END AS MCD
        ,CASE WHEN NSX = 'Registered' Then 'NSX' ELSE NULL END AS NSX
    FROM
        GetSBRegStatus WITH(NOLOCK)
    WHERE
        regtag = @SubBroker
    )
    SELECT
        REPLACE(LTRIM(RTRIM(CONCAT(BSECM_REMI, ' ', BSECM_SB, ' ', NSECM, ' ', NSEFO, ' ', MCX, ' ', NCDEX, ' ', MCD, ' ', NSX))), '  ', ' ') AS Segment
    FROM
        Segments
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateAuditList
-- --------------------------------------------------
CREATE proc USP_UpdateAuditList    
(    
@ApTag as varchar(20),    
@AuditorID as varchar(200),    
@AuditorName as varchar(200),    
@startdate as varchar(50),  
@AuditStatus as varchar(50)  
)    
AS    
Begin    
    
update tbl_SBPlannedAuditMIS    
set AuditorID=@AuditorID,AuditorName=@AuditorName,AuditStartDate=convert(datetime,@startdate,103),  
AuditStatus=@AuditStatus  
where APTag=@ApTag    
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_updatePDFLog
-- --------------------------------------------------

create proc usp_updatePDFLog
(
@pdfpath varchar(200),
@sb varchar(20)
)
AS
BEGIN

 insert into tbl_SBAuditpdfLogs (SBtag,filepath)
 values(@sb,@pdfpath)

END

GO

-- --------------------------------------------------
-- TABLE dbo.auditchecklist
-- --------------------------------------------------
CREATE TABLE [dbo].[auditchecklist]
(
    [sbtag] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MailListSbTag
-- --------------------------------------------------
CREATE TABLE [dbo].[MailListSbTag]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [sbtag] VARCHAR(10) NULL,
    [other_email] VARCHAR(MAX) NULL,
    [to_email] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PDFEmailLog
-- --------------------------------------------------
CREATE TABLE [dbo].[PDFEmailLog]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [FromEmailID] VARCHAR(200) NULL,
    [ToEmailID] VARCHAR(200) NULL,
    [Sbtag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(300) NULL,
    [updateddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_APDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_APDetails]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Emp_No] VARCHAR(20) NULL,
    [AuditorsName] VARCHAR(100) NULL,
    [APEmail] VARCHAR(100) NULL,
    [UserRole] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_APDetails_UAT
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_APDetails_UAT]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Emp_No] VARCHAR(20) NULL,
    [AuditorsName] VARCHAR(100) NULL,
    [APEmail] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_APDocUpload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_APDocUpload]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(10) NULL,
    [UploadPath] VARCHAR(200) NULL,
    [UploadDatetime] DATETIME NULL,
    [Remarks] VARCHAR(100) NULL,
    [QID] VARCHAR(10) NULL,
    [IsApproved] VARCHAR(20) NULL,
    [ChkListID] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditChecklistMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditChecklistMaster]
(
    [srno] INT NULL,
    [AuditClause] VARCHAR(MAX) NULL,
    [NonCompliantRemarks] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditDateLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditDateLog]
(
    [SrNo] INT NULL,
    [SbTag] VARCHAR(20) NULL,
    [AuditDate] VARCHAR(50) NULL,
    [UpdatedDate] VARCHAR(20) NULL,
    [Auditor] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditorLog]
(
    [Srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [InAuditor] VARCHAR(50) NULL,
    [ExAuditor] VARCHAR(100) NULL,
    [logdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditStatus]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [APName] VARCHAR(100) NULL,
    [AuditStatus] VARCHAR(20) NULL,
    [Logdate] DATETIME NULL,
    [Version] VARCHAR(20) NULL,
    [Remarks] VARCHAR(100) NULL,
    [AuditType] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditStatusMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditStatusMaster]
(
    [Status] VARCHAR(5) NULL,
    [StatusDesc] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Question_Options
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Question_Options]
(
    [Qid] INT NULL,
    [Option_Yes] INT NULL,
    [Option_NO] INT NULL,
    [Option_NA] INT NULL,
    [Option_Others] INT NULL,
    [Option_Remarks] INT NULL,
    [Option_UploadDocument] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Question_Options_Intermediate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Question_Options_Intermediate]
(
    [Qid] INT NULL,
    [Option_Yes] INT NULL,
    [Option_NO] INT NULL,
    [Option_NA] INT NULL,
    [Option_Others] INT NULL,
    [Option_Remarks] INT NULL,
    [Option_UploadDocument] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL DEFAULT (getdate()),
    [pdfMailsent] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_04jul2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_04jul2022]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_11aug2021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_11aug2021]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_11aug2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_11aug2022]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL,
    [pdfMailsent] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_20sep2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_20sep2022]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL,
    [pdfMailsent] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_27aug2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_27aug2022]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL,
    [pdfMailsent] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_27sep2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_27sep2022]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL,
    [pdfMailsent] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAuditpdfLogs_UAT
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAuditpdfLogs_UAT]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SbTag] VARCHAR(20) NULL,
    [Filepath] VARCHAR(200) NULL,
    [pdfdownloaddate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBPlannedAuditMIS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBPlannedAuditMIS]
(
    [APTag] VARCHAR(20) NULL,
    [FY] VARCHAR(50) NULL,
    [AuditStartDate] DATETIME NULL,
    [AuditorID] VARCHAR(200) NULL,
    [AuditorName] VARCHAR(200) NULL,
    [AuditorEmail] VARCHAR(200) NULL,
    [AuditStatus] VARCHAR(100) NULL,
    [AuditCompleteddate] DATETIME NULL,
    [AuditObservation] VARCHAR(100) NULL,
    [AuditFile] VARCHAR(500) NULL,
    [LastUpdatedate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBPlannedAuditMIS_dwnload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBPlannedAuditMIS_dwnload]
(
    [APTag] VARCHAR(20) NULL,
    [FY] VARCHAR(50) NULL,
    [AuditStartDate] VARCHAR(30) NULL,
    [AuditorID] VARCHAR(200) NULL,
    [AuditorName] VARCHAR(200) NULL,
    [AuditStatus] VARCHAR(100) NULL,
    [AuditCompleteddate] VARCHAR(30) NULL,
    [AuditObservation] VARCHAR(100) NULL,
    [Auditfile] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SbTag_Mail
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SbTag_Mail]
(
    [SbTag] VARCHAR(20) NULL,
    [EmailId] VARCHAR(200) NULL,
    [Audit_Date] DATETIME NULL,
    [id] INT IDENTITY(1,1) NOT NULL,
    [APName] VARCHAR(200) NULL,
    [Question] VARCHAR(500) NULL,
    [updatedby] VARCHAR(100) NULL,
    [NonCompliantRemarks] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Sbtaglist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Sbtaglist]
(
    [ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sbtag] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditAnswers
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditAnswers]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [Qno] VARCHAR(5) NULL,
    [Answer] VARCHAR(50) NULL,
    [Remarks] VARCHAR(200) NULL,
    [updateddate] DATETIME NULL DEFAULT (getdate()),
    [updatedby] VARCHAR(100) NULL,
    [AuditProofDoc] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditAnswers_09sep2021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditAnswers_09sep2021]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [Qno] VARCHAR(5) NULL,
    [Answer] VARCHAR(50) NULL,
    [Remarks] VARCHAR(50) NULL,
    [updateddate] DATETIME NULL,
    [updatedby] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditAnswers_17Aug2021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditAnswers_17Aug2021]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [Qno] VARCHAR(5) NULL,
    [Answer] VARCHAR(50) NULL,
    [Remarks] VARCHAR(50) NULL,
    [updateddate] DATETIME NULL,
    [updatedby] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditAnswers_21feb2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditAnswers_21feb2024]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [Qno] VARCHAR(5) NULL,
    [Answer] VARCHAR(50) NULL,
    [Remarks] VARCHAR(200) NULL,
    [updateddate] DATETIME NULL,
    [updatedby] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditAnswers_26aug2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditAnswers_26aug2022]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [Qno] VARCHAR(5) NULL,
    [Answer] VARCHAR(50) NULL,
    [Remarks] VARCHAR(200) NULL,
    [updateddate] DATETIME NULL,
    [updatedby] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditAnswers_UAT
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditAnswers_UAT]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [Qno] VARCHAR(5) NULL,
    [Answer] VARCHAR(50) NULL,
    [Remarks] VARCHAR(200) NULL,
    [updateddate] DATETIME NULL DEFAULT (getdate()),
    [updatedby] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditQustionMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditQustionMaster]
(
    [nId] INT IDENTITY(1,1) NOT NULL,
    [sQuestion] VARCHAR(MAX) NULL,
    [sStatus] CHAR(1) NULL,
    [dtCreationDate] DATETIME NULL,
    [SBType] VARCHAR(5) NULL,
    [Version] VARCHAR(20) NULL,
    [IsActive] VARCHAR(20) NULL,
    [Compliant] VARCHAR(50) NULL,
    [NonCompliant] VARCHAR(50) NULL,
    [NotApplicable] VARCHAR(50) NULL,
    [AuditType] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditQustionMaster_11jun2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditQustionMaster_11jun2022]
(
    [nId] INT IDENTITY(1,1) NOT NULL,
    [sQuestion] VARCHAR(MAX) NULL,
    [sStatus] CHAR(1) NULL,
    [dtCreationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditQustionMaster_21feb2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditQustionMaster_21feb2024]
(
    [nId] INT IDENTITY(1,1) NOT NULL,
    [sQuestion] VARCHAR(MAX) NULL,
    [sStatus] CHAR(1) NULL,
    [dtCreationDate] DATETIME NULL,
    [SBType] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditQustionMaster_24aug2020
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditQustionMaster_24aug2020]
(
    [nId] INT IDENTITY(1,1) NOT NULL,
    [sQuestion] VARCHAR(MAX) NULL,
    [sStatus] CHAR(1) NULL,
    [dtCreationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerAuditQustionMasterIntermediate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerAuditQustionMasterIntermediate]
(
    [nId] INT IDENTITY(1,1) NOT NULL,
    [sQuestion] VARCHAR(MAX) NULL,
    [sStatus] CHAR(1) NULL,
    [dtCreationDate] DATETIME NULL,
    [SBType] VARCHAR(5) NULL,
    [Version] VARCHAR(20) NULL,
    [IsActive] VARCHAR(20) NULL,
    [Compliant] VARCHAR(50) NULL,
    [NonCompliant] VARCHAR(50) NULL,
    [NotApplicable] VARCHAR(50) NULL,
    [AuditType] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerMailSendLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerMailSendLog]
(
    [sbtag] VARCHAR(20) NULL,
    [email] VARCHAR(100) NULL,
    [logdate] DATETIME NULL,
    [AuditDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmp_SBPlannedAuditMIS
-- --------------------------------------------------
CREATE TABLE [dbo].[tmp_SBPlannedAuditMIS]
(
    [APTag] VARCHAR(20) NULL,
    [FY] VARCHAR(50) NULL,
    [AuditStartDate] DATETIME NULL,
    [AuditorID] VARCHAR(200) NULL,
    [AuditorName] VARCHAR(200) NULL,
    [AuditorEmail] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.GetSBRegStatus
-- --------------------------------------------------
CREATE View [dbo].[GetSBRegStatus]  
as  
select regtag,regtradeName,  k.TagGeneratedDate  ,  
BSECM_remi =(case when BSECM_remi='' then 'Unregistered' else BSECM_remi end),  
BSECM_SB =(case when BSECM_SB='' then 'Unregistered' else BSECM_SB end),  
NSECM  =(case when NSECM='' then 'Unregistered' else NSECM end),  
NSEFO  =(case when NSEFO='' then 'Unregistered' else NSEFO end),  
MCX  =(case when MCX='' then 'Unregistered' else MCX end),  
NCDEX  =(case when NCDEX='' then 'Unregistered' else NCDEX end) ,  
MCD  =(case when MCD='' then 'Unregistered' else MCD end),  
NSX  =(case when NSX='' then 'Unregistered' else NSX end) ,  
MF=  (case when MF='' then 'Unregistered' else MF end)  
from  
(  
select regtag,regtradeName=max(REGTRADENAME),  
BSECM_remi =max(case when regexchangesegment like '%B_CR%' then regstatus else '' end),  
BSECM_SB =max(case when regexchangesegment like '%B_CS%' then regstatus else '' end),  
NSECM  =max(case when regexchangesegment like '%N_CS%' then regstatus else '' end),  
NSEFO  =max(case when regexchangesegment like '%N_FA%' then regstatus else '' end),  
MCX  =max(case when regexchangesegment like '%M_CX%' then regstatus else '' end),  
NCDEX  =max(case when regexchangesegment like '%N_CX%' then regstatus else '' end),  
MCD= max(case when regexchangesegment like '%N_MF%' then regstatus else '' end),  
NSX= max(case when regexchangesegment like '%N_CF%' then regstatus else '' end),  
MF=    max(case when regexchangesegment like '%M_MF%' then regstatus else '' end)  
from  
(  
SELECT  
regaprrefno,  
REGTAG,REGTRADENAME,  
REGEXCHANGESEGMENT,  
SEGMENT=  
(CASE  
WHEN REGEXCHANGESEGMENT LIKE 'B_CS' THEN 'ABLCM'  
WHEN REGEXCHANGESEGMENT LIKE 'B_CR' THEN 'ABLCM'  
WHEN REGEXCHANGESEGMENT LIKE 'M_CX' THEN 'ACPLMCX'  
WHEN REGEXCHANGESEGMENT LIKE 'N_CX' THEN 'ACPLNCDX'  
WHEN REGEXCHANGESEGMENT LIKE 'N_FA' THEN 'ACDLFO'  
WHEN REGEXCHANGESEGMENT LIKE 'N_CS' THEN 'ACDLCM'  
WHEN REGEXCHANGESEGMENT LIKE 'N_CF' THEN 'ACDLNSX'  
WHEN REGEXCHANGESEGMENT LIKE 'N_MF' THEN 'ACPLMCD'  
WHEN REGEXCHANGESEGMENT LIKE 'M_MF' THEN 'Mutual Fund'  
END),  
REGSTATUS=replace(ISNULL(REGSTATUS,'Unregistered'),'UnRegistered','Unregistered'),REGDATE,REGNO  
FROM [MIS].SB_COMP.dbo.bpregmaster with (nolock) --where isnull(regstatus,'Unregistered') <> 'Cancelled'  
--AND  REGTAG = 'SPPL'  
) x  
group by regtag--,regtradeName  
) a  
left join  
[MIS].SB_COMP.dbo.sb_broker k on k.SBTAG=a.RegTAG

GO

