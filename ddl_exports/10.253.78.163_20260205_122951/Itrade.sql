-- DDL Export
-- Server: 10.253.78.163
-- Database: Itrade
-- Exported: 2026-02-05T12:30:00.534595

USE Itrade;
GO

-- --------------------------------------------------
-- FUNCTION dbo.funcGenRanTag
-- --------------------------------------------------
CREATE function funcGenRanTag
(@ogsb varchar(20))
returns varchar(20)
BEGIN
	declare @lenogsb as int = len(@ogsb)
	declare @i as int =65
	declare @nwsb as varchar(20)
	declare @cnt as int=0
	declare @chr as varchar(5)
	declare @intchr as int
	declare @newchr as varchar(5)
	set @nwsb =@ogsb + 'A'

	while(@i  >64 and @i <91)
	 Begin
		 --chk if exist in system continue (sb),else break
		 if not exists (select SBtag from SB_COMP.dbo.sb_broker where SBtag=@nwsb)
		   Begin
		   if not exists (select SBtag from ItradeSB_Broker where SBtag=@nwsb)
		    Begin
				if(len(@nwsb)>4)
				 Begin
				 -- print(len(@nwsb))
				   Break
				 End
			 End
		   End

		  set @cnt= len(@nwsb)-len(@ogsb) 
		  while(@cnt >0)
		   Begin
				set @chr= substring(@nwsb,len(@ogsb)+(@cnt),1)
				 if(@chr ='Z')
				  begin
					--set char to A  -- STUFF(sb, len(ogsb)+(cnt-1), 1, 'A')
					  set @nwsb = @nwsb +'A'
					  set @nwsb= STUFF(@nwsb, len(@ogsb)+(@cnt), 1, 'A')
					--if cnt =1 then add char to right side and i =65 -- STUFF(sb, len(ogsb)+(cnt+1), 1, 'A')
					 If(@cnt=1)
					  Begin
					  set @nwsb= STUFF(@nwsb, len(@ogsb)+(@cnt), 1, 'A')
					  set @i=65
					  End
			
					 set @cnt= @cnt-1
				  end
				  else
				  begin
				  set @intchr= ascii(@chr)
				  set @newchr=char(@intchr+1)   
					set @nwsb=STUFF(@nwsb, len(@ogsb)+(@cnt), 1, @newchr)
					break
				  end
			End		
			--print(@i)
			--print (@nwsb)
	   set @i= @i +1
	 End
	 return @nwsb
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.funcGenRanTag_12Aug2021
-- --------------------------------------------------
CREATE function funcGenRanTag_12Aug2021
(@ogsb varchar(20))
returns varchar(20)
BEGIN
	declare @lenogsb as int = len(@ogsb)
	declare @i as int =65
	declare @nwsb as varchar(20)
	declare @cnt as int=0
	declare @chr as varchar(5)
	declare @intchr as int
	declare @newchr as varchar(5)
	set @nwsb =@ogsb + 'A'

	while(@i  >64 and @i <91)
	 Begin
		 --chk if exist in system continue (sb),else break
		 if not exists (select SBtag from SB_COMP.dbo.sb_broker where SBtag=@nwsb)
		   Begin
			if(len(@nwsb)>4)
			 Begin
			 -- print(len(@nwsb))
			   Break
			 End
		   End

		  set @cnt= len(@nwsb)-len(@ogsb) 
		  while(@cnt >0)
		   Begin
				set @chr= substring(@nwsb,len(@ogsb)+(@cnt),1)
				 if(@chr ='Z')
				  begin
					--set char to A  -- STUFF(sb, len(ogsb)+(cnt-1), 1, 'A')
					  set @nwsb = @nwsb +'A'
					  set @nwsb= STUFF(@nwsb, len(@ogsb)+(@cnt), 1, 'A')
					--if cnt =1 then add char to right side and i =65 -- STUFF(sb, len(ogsb)+(cnt+1), 1, 'A')
					 If(@cnt=1)
					  Begin
					  set @nwsb= STUFF(@nwsb, len(@ogsb)+(@cnt), 1, 'A')
					  set @i=65
					  End
			
					 set @cnt= @cnt-1
				  end
				  else
				  begin
				  set @intchr= ascii(@chr)
				  set @newchr=char(@intchr+1)   
					set @nwsb=STUFF(@nwsb, len(@ogsb)+(@cnt), 1, @newchr)
					break
				  end
			End		
			--print(@i)
			--print (@nwsb)
	   set @i= @i +1
	 End
	 return @nwsb
END

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ItradeBPApplication
-- --------------------------------------------------
ALTER TABLE [dbo].[ItradeBPApplication] ADD CONSTRAINT [PK_BPApplication] PRIMARY KEY ([AppRefNo], [EST])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ItradeBPREGMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[ItradeBPREGMaster] ADD CONSTRAINT [PK_bpregMaster] PRIMARY KEY ([RegAprRefNo], [RegTAG], [RegExchangeSegment])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ItradeSB_Broker
-- --------------------------------------------------
ALTER TABLE [dbo].[ItradeSB_Broker] ADD CONSTRAINT [PK_RefNo] PRIMARY KEY ([RefNo])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_itradeUnmatchingTAG_06Nov2025
-- --------------------------------------------------
-- =============================================    
-- Author:  <Author,,SATYAJEET MALL>    
-- Create date: <Create Date,22-07-2022,>    
-- Description: <Description,,>    
---EXEC USP_itradeUnmatchingTAG    
-- =============================================    
CREATE PROCEDURE USP_itradeUnmatchingTAG_06Nov2025    
    
AS    
BEGIN    
    
    -- Insert statements for procedure here    
truncate table tbl_ItradeTAG  
  
 Insert into tbl_ItradeTAG     
  Select B.RegAprRefNo,B.RegTAG, GETDATE() from sb_comp.dbo.sb_broker as    
 A left outer join sb_comp.dbo.BPREGMASTER as B on RefNo = B.RegAprRefNo     
 where  A.branch='Itrade' and A.TAGGeneratedDate > getdate()-3      
 and A.SBTAG<>B.RegTAG     
    
  SELECT * FROM tbl_ItradeTAG    
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_itradeUnmatchingTAG_27jul2022
-- --------------------------------------------------
-- =============================================  
-- Author:  <Author,,SATYAJEET MALL>  
-- Create date: <Create Date,22-07-2022,>  
-- Description: <Description,,>  
---EXEC USP_itradeUnmatchingTAG  
-- =============================================  
CREATE PROCEDURE USP_itradeUnmatchingTAG_27jul2022  
  
AS  
BEGIN  
   
  
    -- Insert statements for procedure here  
 Insert into tbl_ItradeTAG   
  Select B.RegAprRefNo,B.RegTAG, GETDATE() from sb_comp.dbo.sb_broker as  
 A inner join sb_comp.dbo.BPREGMASTER as B on RefNo = B.RegAprRefNo   
 where  A.branch='Itrade' and A.TAGGeneratedDate > getdate()-3    
 and A.SBTAG<>B.RegTAG   
  
  SELECT * FROM tbl_ItradeTAG  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_itradeUnmatchingTAG_tobedeleted09jan2026
-- --------------------------------------------------
-- =============================================    
-- Author:  <Author,,SATYAJEET MALL>    
-- Create date: <Create Date,22-07-2022,>    
-- Description: <Description,,>    
---EXEC USP_itradeUnmatchingTAG    
-- =============================================    
CREATE PROCEDURE USP_itradeUnmatchingTAG    
    
AS    
BEGIN   

insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())
    
    -- Insert statements for procedure here    
truncate table tbl_ItradeTAG  
  
 Insert into tbl_ItradeTAG     
  Select B.RegAprRefNo,B.RegTAG, GETDATE() from sb_comp.dbo.sb_broker as    
 A left outer join sb_comp.dbo.BPREGMASTER as B on RefNo = B.RegAprRefNo     
 where  A.branch='Itrade' and A.TAGGeneratedDate > getdate()-3      
 and A.SBTAG<>B.RegTAG     
    
  SELECT * FROM tbl_ItradeTAG    
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_itradeWelcomeMailer
-- --------------------------------------------------
CREATE proc usp_itradeWelcomeMailer  
(  
@ItradeTag as varchar(20),  
@ItradeName as varchar(20),  
@ItradeEmail as varchar(200),
@ItradeMob as varchar(20)
)  
As  
BEGIN  
   
  
declare @body as varchar(max)  
  
set @body='<html><bod>  
  
Dear '+@ItradeName+',<br><br>  
  
Congratulations!<br><br>  
  
We are pleased to inform you that We have successfully activated your I Trade tag. Mentioned below are your credentials which will be used in any communication with the AngelOne Team:<br><br>  
  
I Trade TAG : '+@ItradeTag+'<br>  
Intermediary Name : '+@ItradeName+'<br>  
Trade Name : '+@ItradeName+'<br>  
Registered Email : '+@ItradeEmail+'<br>  
Registered Mobile :'+@ItradeMob+'<br><br>  

For any queries/information, kindly get in touch with your respective Branch Manager at +91- 9155491554 Or Email at  partners@angelbroking.com</b><br><br>  
   
  
<b>*This is a system generated email,please do not reply to this email<br><br></b>  
</body></html>  
'  
--print (@body)  
  
exec msdb.dbo.sp_send_dbmail                                                                                    
@recipients  = @ItradeEmail,                                                                               
@blind_copy_recipients =  'Leon.vaz@angelbroking.com;hemantp.patel@angelbroking.com',                                                                              
@profile_name = 'Angel Broking',                      
--@from ='Prepaid@angeltrade.com',                                                                                        
@body_format ='html',                                                                                          
@subject = 'Registration of I Trade Tag',                                                                    
@file_attachments ='',                                                                                                                               
@body =@body     
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_itradeWelcomeMailer_07oct2021
-- --------------------------------------------------
CREATE proc usp_itradeWelcomeMailer_07oct2021
(
@ItradeTag as varchar(20),
@ItradeName as varchar(20),
@ItradeEmail as varchar(200)
)
As
BEGIN
 

declare @body as varchar(max)

set @body='<html><bod>

Dear '+@ItradeName+',<br><br>

Congratulations!<br><br>

We are pleased to inform you that your I Trade tag is successfully generated and mentioned below are your details which will be used in any communication with the AngelOne Team:<br><br>

I Trade TAG : '+@ItradeTag+'<br>
Intermediary Name : '+@ItradeName+'<br>
Trade Name : '+@ItradeName+'<br>
Branch Name:ITRADE<br><br>
 

Kindly use branch tag and I trade Tag in combination as a User name while login in NXT for eg. Branch is ABC and Tag is XYZ the it should be ABCXYZ as User name. For password kindly use reset password process at initial phase.
<br><br> 

Further, you can do direct login in I Trade through parent  tag at NXT by following below path<br><br>

Login in Parent Tag > Click on drop down option at Name > Click on change sub-broker>Click on I Trade tag tab<br><br>

For any queries & concern, you can reach out to your respective BM at <b>9155491554 for faster response</b><br><br>
 

<b>*This is a system generated email,please do not reply to this email<br><br></b>
</body></html>
'
--print (@body)

exec msdb.dbo.sp_send_dbmail                                                                                  
@recipients  ='Leon.vaz@angelbroking.com',                                                                             
@blind_copy_recipients =  'Leon.vaz@angelbroking.com;hemantp.patel@angelbroking.com',                                                                            
@profile_name = 'Angel Broking',                    
--@from ='Prepaid@angeltrade.com',                                                                                      
@body_format ='html',                                                                                        
@subject = 'Testing - Registration of I Trade Tag',                                                                  
@file_attachments ='',                                                                                                                             
@body =@body   



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_itradeWelcomeMailer_08jul2022
-- --------------------------------------------------
CREATE proc usp_itradeWelcomeMailer_08jul2022  
(  
@ItradeTag as varchar(20),  
@ItradeName as varchar(20),  
@ItradeEmail as varchar(200)  
)  
As  
BEGIN  
   
  
declare @body as varchar(max)  
  
set @body='<html><bod>  
  
Dear '+@ItradeName+',<br><br>  
  
Congratulations!<br><br>  
  
We are pleased to inform you that your I Trade tag is successfully generated and mentioned below are your details which will be used in any communication with the AngelOne Team:<br><br>  
  
I Trade TAG : '+@ItradeTag+'<br>  
Intermediary Name : '+@ItradeName+'<br>  
Trade Name : '+@ItradeName+'<br>  
Branch Name:ITRADE<br><br>  
   
  
Kindly use branch tag and I trade Tag in combination as a User name while login in NXT for eg. Branch is ABC and Tag is XYZ the it should be ABCXYZ as User name. For password kindly use reset password process at initial phase.  
<br><br>   
  
Further, you can do direct login in I Trade through parent  tag at NXT by following below path<br><br>  
  
Login in Parent Tag > Click on drop down option at Name > Click on change sub-broker>Click on I Trade tag tab<br><br>  
  
For any queries & concern, you can reach out to your respective BM at <b>9155491554 for faster response</b><br><br>  
   
  
<b>*This is a system generated email,please do not reply to this email<br><br></b>  
</body></html>  
'  
--print (@body)  
  
exec msdb.dbo.sp_send_dbmail                                                                                    
@recipients  = @ItradeEmail,                                                                               
@blind_copy_recipients =  'Leon.vaz@angelbroking.com;hemantp.patel@angelbroking.com',                                                                              
@profile_name = 'Angel Broking',                      
--@from ='Prepaid@angeltrade.com',                                                                                        
@body_format ='html',                                                                                          
@subject = 'Testing - Registration of I Trade Tag',                                                                    
@file_attachments ='',                                                                                                                               
@body =@body     
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_itradeWelcomeMailer_uat
-- --------------------------------------------------
CREATE proc usp_itradeWelcomeMailer_uat    
(    
@ItradeTag as varchar(20),    
@ItradeName as varchar(20),    
@ItradeEmail as varchar(200),  
@ItradeMob as varchar(20)  
)    
As    
BEGIN    
     
    
declare @body as varchar(max)    
    
set @body='<html><bod>    
    
Dear '+@ItradeName+',<br><br>    
    
Congratulations!<br><br>    
    
We are pleased to inform you that We have successfully activated your I Trade tag. Mentioned below are your credentials which will be used in any communication with the AngelOne Team:<br><br>    
    
I Trade TAG : '+@ItradeTag+'<br>    
Intermediary Name : '+@ItradeName+'<br>    
Trade Name : '+@ItradeName+'<br>    
Registered Email : '+@ItradeEmail+'<br>    
Registered Mobile :'+@ItradeMob+'<br><br>    
  
For any queries/information, kindly get in touch with your respective Branch Manager at +91- 9155491554 Or Email at  partners@angelbroking.com</b><br><br>    
     
    
<b>*This is a system generated email,please do not reply to this email<br><br></b>    
</body></html>    
'    
--print (@body)    
    
exec msdb.dbo.sp_send_dbmail                                                                                      
@recipients  = 'Leon.vaz@angelbroking.com',                                                                                 
--@blind_copy_recipients =  'Leon.vaz@angelbroking.com;hemantp.patel@angelbroking.com',                                                                                
@profile_name = 'Angel Broking',                        
--@from ='Prepaid@angeltrade.com',                                                                                          
@body_format ='html',                                                                                            
@subject = 'Registration of I Trade Tag',                                                                      
@file_attachments ='',                                                                                                                                 
@body =@body       
    
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_pushMissingItradeTagsinBO_04Aug2022
-- --------------------------------------------------
CREATE proc [dbo].[usp_pushMissingItradeTagsinBO_04Aug2022]  
AS  
Begin  
  
exec USP_itradeUnmatchingTAG  
  
select ParentTag sbtag,Sbtag ItradeSBtag, Refno ItradeRefNO   
into #parenttag   
from   
SB_COMP.DBO.sb_broker where sbtag  in  
(  
select RegTag from tbl_ItradeTAG  
)   
  
alter table #parenttag  
add Refno  varchar(20)  
  
update #parenttag  
set refno = b.Refno  
from #parenttag a  
inner join SB_COMP.DBO.sb_broker b on a.sbtag=b.sbtag  
  
  declare @sub as varchar(100)='Itrade Missing Tags'  
  declare  @MESS as varchar(max)  
if exists (select top 1 * from #parenttag)  
   Begin  
    set @MESS= '<html><body><table><tr><td>Itrade SBtag</td></tr>'   
     select @MESS=@MESS+'<tr><td>'+ItradeSBtag+'</td></tr>' from #parenttag   
     set @MESS=@MESS+'</table></body><html>'  
  
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL       
    @RECIPIENTS ='Leon.vaz@angelbroking.com;Yogen.Gandhi@angelbroking.com;saurabh.saran@angelbroking.com;hemantp.patel@angelbroking.com',                                
   -- @COPY_RECIPIENTS ='',                            
    @PROFILE_NAME = 'AngelBroking',                                
    @BODY_FORMAT ='HTML',                                
    @SUBJECT = @sub ,                        
    --@FILE_ATTACHMENTS =@s,                                
    @BODY =@MESS      
  End  
  
-- insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,    
-- RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,    
-- RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment)    
   
-- select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,    
-- RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,  
--    AliasName,RegPortalNo,RegIntimateDate,    
-- BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment    
-- from #parenttag a left outer join    
-- SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo    
-- --where RegAprRefNo='20220316010'  
  
-- insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,    
-- RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,  
  
-- RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],    
-- Reason,Filename,Attachment)    
   
-- select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,    
-- RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,    
-- RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,    
-- Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER   
-- where RegAprRefno in(select ItradeRefno from #parenttag)  
  
-- --delete from ItradeBPAPPLICATION where Apprefno in (select ItradeRefno from #parenttag)  
  
  
-- insert into ItradeBPAPPLICATION(Apprefno,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments  
    
-- ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
-- select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,  
-- CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno    
-- from #parenttag a left outer join    
-- SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo    
-- --where AppRefNo = '20220316010'  
  
-- insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,  
-- CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
-- select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,  
--IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION  where AppRefno in(select ItradeRefno from #parenttag)  
  
----Identification for BO proces  
--  INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)    
--    select ItradeSBtag,'N',getdate() from  #parenttag       
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_pushMissingItradeTagsinBO_06Nov2025
-- --------------------------------------------------
create proc [dbo].[usp_pushMissingItradeTagsinBO_06Nov2025]  
AS  
Begin  
  
--exec USP_itradeUnmatchingTAG  
  
--select ParentTag sbtag,Sbtag ItradeSBtag, Refno ItradeRefNO   
--into #parenttag   
--from   
--SB_COMP.DBO.sb_broker where sbtag  in  
--(  
--select RegTag from tbl_ItradeTAG  
--)   
  
select ParentTag sbtag,Sbtag ItradeSBtag, Refno ItradeRefNO   
into #parenttag   
from   
SB_COMP.DBO.sb_broker where sbtag not in  
(  
 select RegTAG from SB_COMP.DBO.BPREGMASTER  
) and branch='Itrade' and TAGGeneratedDate > getdate()-3  
  
  
alter table #parenttag  
add Refno  varchar(20)  
  
update #parenttag  
set refno = b.Refno  
from #parenttag a  
inner join SB_COMP.DBO.sb_broker b on a.sbtag=b.sbtag  
  
  declare @sub as varchar(100)='Itrade Missing Tags'  
  declare  @MESS as varchar(max)  
if exists (select top 1 * from #parenttag)  
   Begin  
    set @MESS= '<html><body><table><tr><td>Itrade SBtag</td></tr>'   
     select @MESS=@MESS+'<tr><td>'+ItradeSBtag+'</td></tr>' from #parenttag   
     set @MESS=@MESS+'</table></body><html>'  
  
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL       
    @RECIPIENTS ='Leon.vaz@angelbroking.com;Yogen.Gandhi@angelbroking.com;saurabh.saran@angelbroking.com;hemantp.patel@angelbroking.com',                                
   -- @COPY_RECIPIENTS ='',                            
    @PROFILE_NAME = 'AngelBroking',                                
    @BODY_FORMAT ='HTML',                                
    @SUBJECT = @sub ,                        
    --@FILE_ATTACHMENTS =@s,                                
    @BODY =@MESS      
  End  
else
  Begin
   set  @MESS  ='There are 0 Itrade Missing tags'

    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL       
    @RECIPIENTS ='Leon.vaz@angelbroking.com;Yogen.Gandhi@angelbroking.com;saurabh.saran@angelbroking.com;hemantp.patel@angelbroking.com',                                
   -- @COPY_RECIPIENTS ='',                            
    @PROFILE_NAME = 'AngelBroking',                                
    @BODY_FORMAT ='HTML',                                
    @SUBJECT = @sub ,                        
    --@FILE_ATTACHMENTS =@s,                                
    @BODY =@MESS      

  End
  
-- insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,    
-- RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,    
-- RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment)    
   
-- select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,    
-- RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,  
--    AliasName,RegPortalNo,RegIntimateDate,    
-- BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment    
-- from #parenttag a left outer join    
-- SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo    
-- --where RegAprRefNo='20220316010'  
  
-- insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,    
-- RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,  
  
-- RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],    
-- Reason,Filename,Attachment)    
   
-- select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,    
-- RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,    
-- RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,    
-- Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER   
-- where RegAprRefno in(select ItradeRefno from #parenttag)  
  
-- --delete from ItradeBPAPPLICATION where Apprefno in (select ItradeRefno from #parenttag)  
  
  
-- insert into ItradeBPAPPLICATION(Apprefno,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments  
    
-- ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
-- select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,  
-- CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno    
-- from #parenttag a left outer join    
-- SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo    
-- --where AppRefNo = '20220316010'  
  
-- insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,  
-- CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
-- select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,  
--IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION  where AppRefno in(select ItradeRefno from #parenttag)  
  
----Identification for BO proces  
--  INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)    
--    select ItradeSBtag,'N',getdate() from  #parenttag       
  
End

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_pushMissingItradeTagsinBO_28jul2022
-- --------------------------------------------------
create proc usp_pushMissingItradeTagsinBO_28jul2022  
AS  
Begin  
  
exec USP_itradeUnmatchingTAG  
  
select ParentTag sbtag,Sbtag ItradeSBtag, Refno ItradeRefNO   
into #parenttag   
from   
SB_COMP.DBO.sb_broker where sbtag  in  
(  
select RegTag from tbl_ItradeTAG  
)   
  
alter table #parenttag  
add Refno  varchar(20)  
  
update #parenttag  
set refno = b.Refno  
from #parenttag a  
inner join SB_COMP.DBO.sb_broker b on a.sbtag=b.sbtag  
  
  
 insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,    
 RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,    
 RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Da
te],Reason,Filename,Attachment)    
   
 select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOff
Pin,RegOffPhone,RegMobile,RegMobile2,    
 RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
  
    AliasName,RegPortalNo,RegIntimateDate,    
 BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment    
 from #parenttag a left outer join    
 SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo    
 --where RegAprRefNo='20220316010'  
  
 insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,    
 RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,    
 RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],    
 Reason,Filename,Attachment)    
   
 select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,    
 RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,    
 RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,    
 Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER   
 where RegAprRefno in(select ItradeRefno from #parenttag)  
  
 --delete from ItradeBPAPPLICATION where Apprefno in (select ItradeRefno from #parenttag)  
  
  
 insert into ItradeBPAPPLICATION(Apprefno,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
  
    
 ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
 select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId, 
 
 CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno    
 from #parenttag a left outer join    
 SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo    
 --where AppRefNo = '20220316010'  
  
 insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,  
 CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
 select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,
  
IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION  where AppRefno in(select ItradeRefno from #parenttag)  
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_pushMissingItradeTagsinBO_tobedeleted09jan2026
-- --------------------------------------------------
CREATE proc [dbo].[usp_pushMissingItradeTagsinBO]  
AS  
Begin  
 
 insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

--exec USP_itradeUnmatchingTAG  
  
--select ParentTag sbtag,Sbtag ItradeSBtag, Refno ItradeRefNO   
--into #parenttag   
--from   
--SB_COMP.DBO.sb_broker where sbtag  in  
--(  
--select RegTag from tbl_ItradeTAG  
--)   
  
select ParentTag sbtag,Sbtag ItradeSBtag, Refno ItradeRefNO   
into #parenttag   
from   
SB_COMP.DBO.sb_broker where sbtag not in  
(  
 select RegTAG from SB_COMP.DBO.BPREGMASTER  
) and branch='Itrade' and TAGGeneratedDate > getdate()-3  
  
  
alter table #parenttag  
add Refno  varchar(20)  
  
update #parenttag  
set refno = b.Refno  
from #parenttag a  
inner join SB_COMP.DBO.sb_broker b on a.sbtag=b.sbtag  
  
  declare @sub as varchar(100)='Itrade Missing Tags'  
  declare  @MESS as varchar(max)  
if exists (select top 1 * from #parenttag)  
   Begin  
    set @MESS= '<html><body><table><tr><td>Itrade SBtag</td></tr>'   
     select @MESS=@MESS+'<tr><td>'+ItradeSBtag+'</td></tr>' from #parenttag   
     set @MESS=@MESS+'</table></body><html>'  
  
    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL       
    @RECIPIENTS ='Leon.vaz@angelbroking.com;Yogen.Gandhi@angelbroking.com;saurabh.saran@angelbroking.com;hemantp.patel@angelbroking.com',                                
   -- @COPY_RECIPIENTS ='',                            
    @PROFILE_NAME = 'AngelBroking',                                
    @BODY_FORMAT ='HTML',                                
    @SUBJECT = @sub ,                        
    --@FILE_ATTACHMENTS =@s,                                
    @BODY =@MESS      
  End  
else
  Begin
   set  @MESS  ='There are 0 Itrade Missing tags'

    EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL       
    @RECIPIENTS ='Leon.vaz@angelbroking.com;Yogen.Gandhi@angelbroking.com;saurabh.saran@angelbroking.com;hemantp.patel@angelbroking.com',                                
   -- @COPY_RECIPIENTS ='',                            
    @PROFILE_NAME = 'AngelBroking',                                
    @BODY_FORMAT ='HTML',                                
    @SUBJECT = @sub ,                        
    --@FILE_ATTACHMENTS =@s,                                
    @BODY =@MESS      

  End
  
-- insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,    
-- RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,    
-- RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment)    
   
-- select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,    
-- RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,  
--    AliasName,RegPortalNo,RegIntimateDate,    
-- BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment    
-- from #parenttag a left outer join    
-- SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo    
-- --where RegAprRefNo='20220316010'  
  
-- insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,    
-- RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,  
  
-- RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],    
-- Reason,Filename,Attachment)    
   
-- select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,    
-- RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,    
-- RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,    
-- Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER   
-- where RegAprRefno in(select ItradeRefno from #parenttag)  
  
-- --delete from ItradeBPAPPLICATION where Apprefno in (select ItradeRefno from #parenttag)  
  
  
-- insert into ItradeBPAPPLICATION(Apprefno,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments  
    
-- ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
-- select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,  
-- CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno    
-- from #parenttag a left outer join    
-- SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo    
-- --where AppRefNo = '20220316010'  
  
-- insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,  
-- CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
   
-- select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,  
--IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION  where AppRefno in(select ItradeRefno from #parenttag)  
  
----Identification for BO proces  
--  INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)    
--    select ItradeSBtag,'N',getdate() from  #parenttag       
  
End

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBRoyalTagcreation
-- --------------------------------------------------
CREATE proc [dbo].[usp_SBRoyalTagcreation]    
AS    
BEGIN    
 declare @refnoCnter as numeric    
 truncate table ItradeSBtemp     
 --if((select max(left(ItradeRefNo,8)) from ItradeSBtemp) !=replace(Convert(varchar,getdate(),103),'/',''))    
 -- Begin    
 --  truncate table ItradeSBtemp    
 -- End    
     
 if exists (select 1 from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/','')))    
   Begin    
      select @refnoCnter=replace(Convert(varchar,getdate(),103),'/','') + max(right(Refno,3)) from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/',''))    
   End    
 else    
  Begin    
     set @refnoCnter=replace(Convert(varchar,getdate(),103),'/','')+'900'    
  End    
     
  insert into ItradeSBtemp    
  select a.SBTAG,dbo.funcGenRanTag(a.SBTAG),a.RefNo,(@refnoCnter+Row_number() over (order by a.RefNo)) from SB_COMP.DBO.SB_BROKER a with(nolock)     
  left outer join ItradeSB_Broker b on a.sbtag =b.ParentTag    
  inner join [ABVSTSS].SmallOffice.dbo.RefIntermediary c on a.sbtag collate SQL_Latin1_General_CP1_CI_AS =c.Intermediarycode    
  where a.taggenerateddate between Convert(varchar,getdate()-6,101) and Convert(varchar,getdate(),101) + ' 23:59:59'    
  and a.Branch not in ('RFRL','ITRADE','MFSB','SMART') and b.ParentTag is null and a.OrgType in ('CO','I','P','PF')    
  and a.SBTAG  not in(select ParentTag from SB_COMP.DBO.SB_BROKER a with(nolock) where Branch='Itrade' and ParentTag is not null)    
      
      
  insert into ItradeSB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,    
  FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,    
  TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,    
  FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)    
 select a.ItradeRefNo,a.ItradeSBTAG,'ITRADE',b.SBTAG,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,FileNo,    
 PANVerified,getdate(),SBstatus,RegStatus,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,    
 TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,    
 FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date     
 from ItradeSBtemp a left outer join    
 SB_COMP.DBO.SB_BROKER b with(nolock) on a.sbtag=b.sbtag    
    
     
 insert into ItradeSB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)    
 select A.ItradeRefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3    
 from ItradeSBtemp a left outer join    
 SB_COMP.DBO.SB_CONTACT b on a.RefNo=b.RefNo    
    
     
 insert into ItradeSB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,    
 SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,    
 Company,MakerID,CheckerId,TimeStamp,IpAddress)    
 select A.ItradeRefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,    
 TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress    
 from ItradeSBtemp a left outer join    
 SB_COMP.DBO.SB_BANKOTHERS b on a.RefNo=b.RefNo    
    
     
 insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,    
 RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,    
 RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],  
 [Address Intimate Date],Reason,Filename,Attachment)    
 select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,  
 RegOffPin,RegOffPhone,RegMobile,RegMobile2,    
 RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
  
    
    AliasName,RegPortalNo,RegIntimateDate,    
 BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment    
 from ItradeSBtemp a left outer join    
 SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo    
    
     
 insert into ItradeBPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
  
    
    ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
 select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId, 
 
 CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno    
 from ItradeSBtemp a left outer join    
 SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo    
    
     
 insert into ItradeSB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,
  
    
 SpouseOcc,TimeStamp,IPADDRESS)    
 select A.ItradeRefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,OccupationDetails,SpouseOcc, 
 
 TimeStamp,IPADDRESS    
 from ItradeSBtemp a left outer join    
 SB_COMP.DBO.SB_PERSONAL b on a.RefNo=b.RefNo    
    
     
 insert into ItradeSB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,    
 TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc) select A.ItradeRefNo,PartnerSeq,PartnerSalutation
  
,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,    
 PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,SpouseOcc from ItradeSBtemp a left outer join    
 SB_COMP.DBO.SB_Partner b on a.RefNo=b.RefNo    
 where partnerseq is not null    
     
 truncate table tbl_itradeDupRefno    
     
 insert into tbl_itradeDupRefno    
 select A.RefNo from ItradeSB_Broker a    
 inner join SB_COMP.DBO.SB_BROKER b with(nolock) on a.RefNo=b.RefNo    
    
 if exists(select refno from tbl_itradeDupRefno)    
  Begin    
    delete from ItradeSB_Broker where RefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeSB_CONTACT where RefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeSB_BANKOTHERS where RefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeBPREGMASTER where RegAprRefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeBPAPPLICATION where AppRefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeSB_PERSONAL where RefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeSB_Partner where RefNo in (select refno from tbl_itradeDupRefno)    
    delete from ItradeSBtemp where ItradeRefNO in  (select refno from tbl_itradeDupRefno)    
  End    
    
    
 -- Push the data to SB details    
 insert into Sb_comp.dbo.SB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,    
 LeadSource,EmpId,FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,    
 Cso_PanCardName,SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,    
 OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)    
 select RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,    
 FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,    
 SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,    
 IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date    
 from ItradeSB_Broker where UpdFlg='N'        
 update ItradeSB_Broker set UpdFlg='Y' where UpdFlg='N'    
    
 insert into Sb_comp.dbo.SB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)    
 select RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3 from ItradeSB_CONTACT where UpdFlg='N'    
 update ItradeSB_CONTACT set UpdFlg='Y' where UpdFlg='N'    
    
 insert into Sb_comp.dbo.SB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,    
 DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress)    
 select  RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,    
 RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress from ItradeSB_BANKOTHERS  where UpdFlg='N'    
 update ItradeSB_BANKOTHERS set UpdFlg='Y' where UpdFlg='N'    
    
 insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,    
 RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,    
 RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],    
 Reason,Filename,Attachment)    
 select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,    
 RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,    
 RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,    
 Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER  where UpdFlg='N'    
 update ItradeBPREGMASTER set UpdFlg='Y' where UpdFlg='N'    
    
 insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,  
 CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)    
 select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,
  
IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION where UpdFlg='N'    
 update ItradeBPAPPLICATION set UpdFlg='Y' where UpdFlg='N'    
    
 insert into Sb_comp.dbo.SB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,  
 OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)    
 select RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,  
 IPADDRESS from ItradeSB_PERSONAL where UpdFlg='N'    
 update ItradeSB_PERSONAL set UpdFlg='Y' where UpdFlg='N'    
    
 insert into Sb_comp.dbo.SB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified  
 ,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,    
 TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)    
 select RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,  
 OccDetails,ExpDetails,BrokingCompany,TradMember,    
 BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc from ItradeSB_Partner where UpdFlg='N'    
 update ItradeSB_Partner set UpdFlg='Y' where UpdFlg='N'    
     
    INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)    
    select ItradeSBtag,'N',getdate() from  ItradeSBtemp         
         
    
    declare @max as int,@cnt as int=1    
    declare @itradeTag as varchar(20)    
  declare @sbTag as varchar(20),@ItradeName as varchar(200),@Itradeemail as varchar(200),@ItradeMob as varchar(20)    
     
  if exists (select 1 from ItradeSBtemp)    
   Begin    
    select @max =count(srno) from ItradeSBtemp    
       
  while(@cnt<=@max)    
   Begin    
       
    select @itradeTag=ItradeSbTag,@sbTag=SbTag from ItradeSBtemp where SrNo=@cnt    
    select @ItradeName=a.TradeName,@Itradeemail=isnull(b.EmailId,''),@ItradeMob=isnull(MobNo,'') from Sb_comp.dbo.SB_Broker a    
    inner join Sb_comp.dbo.SB_Contact b on a.refno=b.RefNo    
    where a.sbtag=@sbTag and b.AddType='RES'    
    exec usp_itradeWelcomeMailer @itradeTag,@ItradeName,@Itradeemail,@ItradeMob    
    
    set @cnt = @cnt +1    
   End    
    
   End 
   
    truncate table ItradeSB_Broker   
    truncate table ItradeSB_CONTACT 
    truncate table ItradeSB_BANKOTHERS 
    truncate table ItradeBPREGMASTER   
    truncate table ItradeBPAPPLICATION    
    truncate table ItradeSB_PERSONAL   
    truncate table ItradeSB_Partner
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBRoyalTagcreation_08jul2022
-- --------------------------------------------------
CREATE proc [dbo].[usp_SBRoyalTagcreation_08jul2022]  
AS  
BEGIN  
 declare @refnoCnter as numeric  
 truncate table ItradeSBtemp   
 --if((select max(left(ItradeRefNo,8)) from ItradeSBtemp) !=replace(Convert(varchar,getdate(),103),'/',''))  
 -- Begin  
 --  truncate table ItradeSBtemp  
 -- End  
   
 if exists (select 1 from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/','')))  
   Begin  
      select @refnoCnter=replace(Convert(varchar,getdate(),103),'/','') + max(right(Refno,3)) from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/',''))  
   End  
 else  
  Begin  
     set @refnoCnter=replace(Convert(varchar,getdate(),103),'/','')+'900'  
  End  
   
  insert into ItradeSBtemp  
  select a.SBTAG,dbo.funcGenRanTag(a.SBTAG),a.RefNo,(@refnoCnter+Row_number() over (order by a.RefNo)) from SB_COMP.DBO.SB_BROKER a with(nolock)   
  left outer join ItradeSB_Broker b on a.sbtag =b.ParentTag  
  inner join [172.31.16.28].SmallOffice.dbo.RefIntermediary c on a.sbtag collate SQL_Latin1_General_CP1_CI_AS =c.Intermediarycode  
  where a.taggenerateddate between Convert(varchar,getdate()-6,101) and Convert(varchar,getdate(),101) + ' 23:59:59'  
  and a.Branch not in ('RFRL','ITRADE','MFSB','SMART') and b.ParentTag is null and a.OrgType in ('CO','I','P','PF')  
  and a.SBTAG  not in(select ParentTag from SB_COMP.DBO.SB_BROKER a with(nolock) where Branch='Itrade' and ParentTag is not null)  
    
    
  insert into ItradeSB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,  
  FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,  
  TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,  
  FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)  
 select a.ItradeRefNo,a.ItradeSBTAG,'ITRADE',b.SBTAG,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,FileNo,  
 PANVerified,getdate(),SBstatus,RegStatus,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,  
 TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,  
 FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date   
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_BROKER b with(nolock) on a.sbtag=b.sbtag  
  
   
 insert into ItradeSB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)  
 select A.ItradeRefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_CONTACT b on a.RefNo=b.RefNo  
  
   
 insert into ItradeSB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,  
 SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,  
 Company,MakerID,CheckerId,TimeStamp,IpAddress)  
 select A.ItradeRefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,  
 TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_BANKOTHERS b on a.RefNo=b.RefNo  
  
   
 insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,  
 RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,  
 RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],
 [Address Intimate Date],Reason,Filename,Attachment)  
 select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,
 RegOffPin,RegOffPhone,RegMobile,RegMobile2,  
 RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
  
    AliasName,RegPortalNo,RegIntimateDate,  
 BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo  
  
   
 insert into ItradeBPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
  
    ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)  
 select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,
 CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo  
  
   
 insert into ItradeSB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,
  
 SpouseOcc,TimeStamp,IPADDRESS)  
 select A.ItradeRefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,OccupationDetails,SpouseOcc,
 TimeStamp,IPADDRESS  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_PERSONAL b on a.RefNo=b.RefNo  
  
   
 insert into ItradeSB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,  
 TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc) select A.ItradeRefNo,PartnerSeq,PartnerSalutation
,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,  
 PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,SpouseOcc from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_Partner b on a.RefNo=b.RefNo  
 where partnerseq is not null  
   
 truncate table tbl_itradeDupRefno  
   
 insert into tbl_itradeDupRefno  
 select A.RefNo from ItradeSB_Broker a  
 inner join SB_COMP.DBO.SB_BROKER b with(nolock) on a.RefNo=b.RefNo  
  
 if exists(select refno from tbl_itradeDupRefno)  
  Begin  
    delete from ItradeSB_Broker where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_CONTACT where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_BANKOTHERS where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeBPREGMASTER where RegAprRefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeBPAPPLICATION where AppRefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_PERSONAL where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_Partner where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSBtemp where ItradeRefNO in  (select refno from tbl_itradeDupRefno)  
  End  
  
  
 -- Push the data to SB details  
 insert into Sb_comp.dbo.SB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,  
 LeadSource,EmpId,FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,  
 Cso_PanCardName,SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,  
 OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)  
 select RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,  
 FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,  
 SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,  
 IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date  
 from ItradeSB_Broker where UpdFlg='N'      
 update ItradeSB_Broker set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)  
 select RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3 from ItradeSB_CONTACT where UpdFlg='N'  
 update ItradeSB_CONTACT set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,  
 DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress)  
 select  RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,  
 RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress from ItradeSB_BANKOTHERS  where UpdFlg='N'  
 update ItradeSB_BANKOTHERS set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,  
 RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,  
 RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],  
 Reason,Filename,Attachment)  
 select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,  
 RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,  
 RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,  
 Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER  where UpdFlg='N'  
 update ItradeBPREGMASTER set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,
 CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)  
 select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,
IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION where UpdFlg='N'  
 update ItradeBPAPPLICATION set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,
 OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)  
 select RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,
 IPADDRESS from ItradeSB_PERSONAL where UpdFlg='N'  
 update ItradeSB_PERSONAL set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified
 ,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,  
 TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)  
 select RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,
 OccDetails,ExpDetails,BrokingCompany,TradMember,  
 BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc from ItradeSB_Partner where UpdFlg='N'  
 update ItradeSB_Partner set UpdFlg='Y' where UpdFlg='N'  
   
    INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)  
    select ItradeSBtag,'N',getdate() from  ItradeSBtemp       
       
  
    declare @max as int,@cnt as int=1  
    declare @itradeTag as varchar(20)  
  declare @sbTag as varchar(20),@ItradeName as varchar(200),@Itradeemail as varchar(200)  
   
  if exists (select 1 from ItradeSBtemp)  
   Begin  
    select @max =count(srno) from ItradeSBtemp  
     
  while(@cnt<=@max)  
   Begin  
     
    select @itradeTag=ItradeSbTag,@sbTag=SbTag from ItradeSBtemp where SrNo=@cnt  
    select @ItradeName=a.TradeName,@Itradeemail=b.EmailId from Sb_comp.dbo.SB_Broker a  
    inner join Sb_comp.dbo.SB_Contact b on a.refno=b.RefNo  
    where a.sbtag=@sbTag and b.AddType='RES'  
    exec usp_itradeWelcomeMailer @itradeTag,@ItradeName,@Itradeemail  
  
    set @cnt = @cnt +1  
   End  
  
   End  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBRoyalTagcreation_14sep2021
-- --------------------------------------------------
create proc [dbo].[usp_SBRoyalTagcreation_14sep2021]
AS
BEGIN
	declare @refnoCnter as numeric
	truncate table ItradeSBtemp	
	--if((select max(left(ItradeRefNo,8)) from ItradeSBtemp) !=replace(Convert(varchar,getdate(),103),'/',''))
	-- Begin
	--  truncate table ItradeSBtemp
	-- End
	
	if exists (select 1 from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/','')))
	  Begin
	     select @refnoCnter=replace(Convert(varchar,getdate(),103),'/','') + max(right(Refno,3)) from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/',''))
	  End
	else
	 Begin
	    set @refnoCnter=replace(Convert(varchar,getdate(),103),'/','')+'900'
	 End
	
	 insert into ItradeSBtemp
	 select a.SBTAG,dbo.funcGenRanTag(a.SBTAG),a.RefNo,(@refnoCnter+Row_number() over (order by a.RefNo)) from SB_COMP.DBO.SB_BROKER a with(nolock) 
	 left outer join ItradeSB_Broker b on a.sbtag =b.ParentTag
	 inner join [172.31.16.28].SmallOffice.dbo.RefIntermediary c on a.sbtag collate SQL_Latin1_General_CP1_CI_AS =c.Intermediarycode
	 where a.taggenerateddate between Convert(varchar,getdate()-6,101) and Convert(varchar,getdate(),101) + ' 23:59:59'
	 and a.Branch not in ('RFRL','ITRADE','MFSB','SMART') and b.ParentTag is null and a.OrgType in ('CO','I','P','PF')
	 and a.SBTAG  not in(select ParentTag from SB_COMP.DBO.SB_BROKER a with(nolock) where Branch='Itrade' and ParentTag is not null)
	 
	 
	 insert into ItradeSB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,
	 FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,
	 TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,
	 FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)
	select a.ItradeRefNo,a.ItradeSBTAG,'ITRADE',b.SBTAG,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,FileNo,
	PANVerified,getdate(),SBstatus,RegStatus,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,
	TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,
	FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date 
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_BROKER b with(nolock) on a.sbtag=b.sbtag

	
	insert into ItradeSB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)
	select A.ItradeRefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_CONTACT b on a.RefNo=b.RefNo

	
	insert into ItradeSB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,
	SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,
	Company,MakerID,CheckerId,TimeStamp,IpAddress)
	select A.ItradeRefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,
	TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_BANKOTHERS b on a.RefNo=b.RefNo

	
	insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,
	RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,
	RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment)
	select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,
	RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
AliasName,RegPortalNo,RegIntimateDate,
	BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo

	
	insert into ItradeBPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)
	select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo

	
	insert into ItradeSB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,


SpouseOcc,TimeStamp,IPADDRESS)
	select A.ItradeRefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_PERSONAL b on a.RefNo=b.RefNo

	
	insert into ItradeSB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,
	TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)	select A.ItradeRefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,
	PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,SpouseOcc	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_Partner b on a.RefNo=b.RefNo
	where partnerseq is not null
	
	truncate table tbl_itradeDupRefno
	
	insert into tbl_itradeDupRefno
	select A.RefNo from ItradeSB_Broker a
	inner join SB_COMP.DBO.SB_BROKER b with(nolock) on a.RefNo=b.RefNo

	if exists(select refno from tbl_itradeDupRefno)
	 Begin
	   delete from ItradeSB_Broker where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_CONTACT where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_BANKOTHERS where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeBPREGMASTER where RegAprRefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeBPAPPLICATION where AppRefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_PERSONAL where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_Partner where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSBtemp where ItradeRefNO in  (select refno from tbl_itradeDupRefno)
	 End


	-- Push the data to SB details
	insert into Sb_comp.dbo.SB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,
	LeadSource,EmpId,FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,
	Cso_PanCardName,SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,
	OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)
	select RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,
	FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,
	SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,
	IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date
	from ItradeSB_Broker where UpdFlg='N'    
	update ItradeSB_Broker set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)
	select RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3 from ItradeSB_CONTACT where UpdFlg='N'
	update ItradeSB_CONTACT set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,
	DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress)
	select  RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,
	RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress from ItradeSB_BANKOTHERS  where UpdFlg='N'
	update ItradeSB_BANKOTHERS set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,
	RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,
	RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],
	Reason,Filename,Attachment)
	select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,
	RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,
	RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,
	Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER  where UpdFlg='N'
	update ItradeBPREGMASTER set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)
	select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,


IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION where UpdFlg='N'
	update ItradeBPAPPLICATION set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)
	select RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS from ItradeSB_PERSONAL where UpdFlg='N'
	update ItradeSB_PERSONAL set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,
	TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)
	select RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,
	BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc from ItradeSB_Partner where UpdFlg='N'
	update ItradeSB_Partner set UpdFlg='Y' where UpdFlg='N'
	
    INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)
    select ItradeSBtag,'N',getdate() from  ItradeSBtemp     
     


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBRoyalTagcreation_20sep2021
-- --------------------------------------------------
create proc [dbo].[usp_SBRoyalTagcreation_20sep2021]
AS
BEGIN
	declare @refnoCnter as numeric
	truncate table ItradeSBtemp	
	--if((select max(left(ItradeRefNo,8)) from ItradeSBtemp) !=replace(Convert(varchar,getdate(),103),'/',''))
	-- Begin
	--  truncate table ItradeSBtemp
	-- End
	
	if exists (select 1 from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/','')))
	  Begin
	     select @refnoCnter=replace(Convert(varchar,getdate(),103),'/','') + max(right(Refno,3)) from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/',''))
	  End
	else
	 Begin
	    set @refnoCnter=replace(Convert(varchar,getdate(),103),'/','')+'900'
	 End
	
	 insert into ItradeSBtemp
	 select a.SBTAG,dbo.funcGenRanTag(a.SBTAG),a.RefNo,(@refnoCnter+Row_number() over (order by a.RefNo)) from SB_COMP.DBO.SB_BROKER a with(nolock) 
	 left outer join ItradeSB_Broker b on a.sbtag =b.ParentTag
	 inner join [172.31.16.28].SmallOffice.dbo.RefIntermediary c on a.sbtag collate SQL_Latin1_General_CP1_CI_AS =c.Intermediarycode
	 where a.taggenerateddate between Convert(varchar,getdate()-6,101) and Convert(varchar,getdate(),101) + ' 23:59:59'
	 and a.Branch not in ('RFRL','ITRADE','MFSB','SMART') and b.ParentTag is null and a.OrgType in ('CO','I','P','PF')
	 and a.SBTAG  not in(select ParentTag from SB_COMP.DBO.SB_BROKER a with(nolock) where Branch='Itrade' and ParentTag is not null)
	 
	 
	 insert into ItradeSB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,
	 FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,
	 TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,
	 FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)
	select a.ItradeRefNo,a.ItradeSBTAG,'ITRADE',b.SBTAG,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,FileNo,
	PANVerified,getdate(),SBstatus,RegStatus,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,
	TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,
	FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date 
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_BROKER b with(nolock) on a.sbtag=b.sbtag

	
	insert into ItradeSB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)
	select A.ItradeRefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_CONTACT b on a.RefNo=b.RefNo

	
	insert into ItradeSB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,
	SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,
	Company,MakerID,CheckerId,TimeStamp,IpAddress)
	select A.ItradeRefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,
	TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_BANKOTHERS b on a.RefNo=b.RefNo

	
	insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,
	RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,
	RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment)
	select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,
	RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
    AliasName,RegPortalNo,RegIntimateDate,
	BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo

	
	insert into ItradeBPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
    ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)
	select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo

	
	insert into ItradeSB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,
	SpouseOcc,TimeStamp,IPADDRESS)
	select A.ItradeRefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS
	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_PERSONAL b on a.RefNo=b.RefNo

	
	insert into ItradeSB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,
	TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)	select A.ItradeRefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,
	PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,SpouseOcc	from ItradeSBtemp a left outer join
	SB_COMP.DBO.SB_Partner b on a.RefNo=b.RefNo
	where partnerseq is not null
	
	truncate table tbl_itradeDupRefno
	
	insert into tbl_itradeDupRefno
	select A.RefNo from ItradeSB_Broker a
	inner join SB_COMP.DBO.SB_BROKER b with(nolock) on a.RefNo=b.RefNo

	if exists(select refno from tbl_itradeDupRefno)
	 Begin
	   delete from ItradeSB_Broker where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_CONTACT where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_BANKOTHERS where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeBPREGMASTER where RegAprRefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeBPAPPLICATION where AppRefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_PERSONAL where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSB_Partner where RefNo in (select refno from tbl_itradeDupRefno)
	   delete from ItradeSBtemp where ItradeRefNO in  (select refno from tbl_itradeDupRefno)
	 End


	-- Push the data to SB details
	insert into Sb_comp.dbo.SB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,
	LeadSource,EmpId,FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,
	Cso_PanCardName,SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,
	OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)
	select RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,
	FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,
	SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,
	IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date
	from ItradeSB_Broker where UpdFlg='N'    
	update ItradeSB_Broker set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)
	select RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3 from ItradeSB_CONTACT where UpdFlg='N'
	update ItradeSB_CONTACT set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,
	DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress)
	select  RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,
	RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress from ItradeSB_BANKOTHERS  where UpdFlg='N'
	update ItradeSB_BANKOTHERS set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,
	RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,
	RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],
	Reason,Filename,Attachment)
	select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,
	RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,
	RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,
	Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER  where UpdFlg='N'
	update ItradeBPREGMASTER set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)
	select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION where UpdFlg='N'
	update ItradeBPAPPLICATION set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)
	select RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS from ItradeSB_PERSONAL where UpdFlg='N'
	update ItradeSB_PERSONAL set UpdFlg='Y' where UpdFlg='N'

	insert into Sb_comp.dbo.SB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,
	TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)
	select RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,
	BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc from ItradeSB_Partner where UpdFlg='N'
	update ItradeSB_Partner set UpdFlg='Y' where UpdFlg='N'
	
    INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)
    select ItradeSBtag,'N',getdate() from  ItradeSBtemp     
     



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBRoyalTagcreation_25sep2025
-- --------------------------------------------------
CREATE proc [dbo].[usp_SBRoyalTagcreation_25sep2025]      
AS      
BEGIN      
 declare @refnoCnter as numeric      
 truncate table ItradeSBtemp       
 --if((select max(left(ItradeRefNo,8)) from ItradeSBtemp) !=replace(Convert(varchar,getdate(),103),'/',''))      
 -- Begin      
 --  truncate table ItradeSBtemp      
 -- End      
       
 if exists (select 1 from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/','')))      
   Begin      
      select @refnoCnter=replace(Convert(varchar,getdate(),103),'/','') + max(right(Refno,3)) from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/',''))      
   End      
 else      
  Begin      
     set @refnoCnter=replace(Convert(varchar,getdate(),103),'/','')+'900'      
  End      
       
  insert into ItradeSBtemp      
  select a.SBTAG,dbo.funcGenRanTag(a.SBTAG),a.RefNo,(@refnoCnter+Row_number() over (order by a.RefNo)) from SB_COMP.DBO.SB_BROKER a with(nolock)       
  left outer join ItradeSB_Broker b on a.sbtag =b.ParentTag      
  inner join [ABVSTSS].SmallOffice.dbo.RefIntermediary c on a.sbtag collate SQL_Latin1_General_CP1_CI_AS =c.Intermediarycode      
  where a.taggenerateddate between Convert(varchar,getdate()-6,101) and Convert(varchar,getdate(),101) + ' 23:59:59'      
  and a.Branch not in ('RFRL','ITRADE','MFSB','SMART') and b.ParentTag is null and a.OrgType in ('CO','I','P','PF')      
  and a.SBTAG  not in(select ParentTag from SB_COMP.DBO.SB_BROKER a with(nolock) where Branch='Itrade' and ParentTag is not null)      
        
        
  insert into ItradeSB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,      
  FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,      
  TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,      
  FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)      
 select a.ItradeRefNo,a.ItradeSBTAG,'ITRADE',b.SBTAG,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,FileNo,      
 PANVerified,getdate(),SBstatus,RegStatus,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,      
 TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,      
 FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date       
 from ItradeSBtemp a left outer join      
 SB_COMP.DBO.SB_BROKER b with(nolock) on a.sbtag=b.sbtag      
      
       
 insert into ItradeSB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)      
 select A.ItradeRefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3      
 from ItradeSBtemp a left outer join      
 SB_COMP.DBO.SB_CONTACT b on a.RefNo=b.RefNo      
      
       
 insert into ItradeSB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,      
 SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,      
 Company,MakerID,CheckerId,TimeStamp,IpAddress)      
 select A.ItradeRefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,      
 TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress      
 from ItradeSBtemp a left outer join      
 SB_COMP.DBO.SB_BANKOTHERS b on a.RefNo=b.RefNo      
      
       
 insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,      
 RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,      
 RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],    
 [Address Intimate Date],Reason,Filename,Attachment)      
 select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,    
 RegOffPin,RegOffPhone,RegMobile,RegMobile2,      
 RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
  
    
      
    AliasName,RegPortalNo,RegIntimateDate,      
 BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment      
 from ItradeSBtemp a left outer join      
 SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo      
      
       
 insert into ItradeBPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
  
    
      
    ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)      
 select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId, 
  
   
 CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno      
 from ItradeSBtemp a left outer join      
 SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo      
      
       
 insert into ItradeSB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,
  
    
      
 SpouseOcc,TimeStamp,IPADDRESS)      
 select A.ItradeRefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,OccupationDetails,SpouseOcc, 
  
   
 TimeStamp,IPADDRESS      
 from ItradeSBtemp a left outer join      
 SB_COMP.DBO.SB_PERSONAL b on a.RefNo=b.RefNo      
      
       
 insert into ItradeSB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,      
 TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc) select A.ItradeRefNo,PartnerSeq,PartnerSalutation
  
    
,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,      
 PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,SpouseOcc from ItradeSBtemp a left outer join      
 SB_COMP.DBO.SB_Partner b on a.RefNo=b.RefNo      
 where partnerseq is not null      
       
 truncate table tbl_itradeDupRefno      
       
 insert into tbl_itradeDupRefno      
 select A.RefNo from ItradeSB_Broker a      
 inner join SB_COMP.DBO.SB_BROKER b with(nolock) on a.RefNo=b.RefNo      
      
 if exists(select refno from tbl_itradeDupRefno)      
  Begin      
    delete from ItradeSB_Broker where RefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeSB_CONTACT where RefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeSB_BANKOTHERS where RefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeBPREGMASTER where RegAprRefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeBPAPPLICATION where AppRefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeSB_PERSONAL where RefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeSB_Partner where RefNo in (select refno from tbl_itradeDupRefno)      
    delete from ItradeSBtemp where ItradeRefNO in  (select refno from tbl_itradeDupRefno)      
  End      
      
      
 -- Push the data to SB details      
 insert into Sb_comp.dbo.SB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,      
 LeadSource,EmpId,FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,      
 Cso_PanCardName,SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,      
 OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)      
 select RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,      
 FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,      
 SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,      
 IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date      
 from ItradeSB_Broker where UpdFlg='N'          
 update ItradeSB_Broker set UpdFlg='Y' where UpdFlg='N'      
      
 insert into Sb_comp.dbo.SB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)      
 select RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3 from ItradeSB_CONTACT where UpdFlg='N'      
 update ItradeSB_CONTACT set UpdFlg='Y' where UpdFlg='N'      
      
 insert into Sb_comp.dbo.SB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,      
 DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress)      
 select  RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,      
 RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress from ItradeSB_BANKOTHERS  where UpdFlg='N'      
 update ItradeSB_BANKOTHERS set UpdFlg='Y' where UpdFlg='N'      
      
 insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,      
 RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,    
  
 RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],      
 Reason,Filename,Attachment)      
 select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,      
 RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,      
 RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,      
 Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER  where UpdFlg='N'      
 update ItradeBPREGMASTER set UpdFlg='Y' where UpdFlg='N'      
      
 insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,    
 CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)      
 select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,
  
    
IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION where UpdFlg='N'      
 update ItradeBPAPPLICATION set UpdFlg='Y' where UpdFlg='N'      
      
 insert into Sb_comp.dbo.SB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,    
 OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)      
 select RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,   
 
 IPADDRESS from ItradeSB_PERSONAL where UpdFlg='N'      
 update ItradeSB_PERSONAL set UpdFlg='Y' where UpdFlg='N'      
      
 insert into Sb_comp.dbo.SB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified    
 ,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,      
 TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)      
 select RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,    
 OccDetails,ExpDetails,BrokingCompany,TradMember,      
 BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc from ItradeSB_Partner where UpdFlg='N'      
 update ItradeSB_Partner set UpdFlg='Y' where UpdFlg='N'      
       
    INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)      
    select ItradeSBtag,'N',getdate() from  ItradeSBtemp           
           
      
    declare @max as int,@cnt as int=1      
    declare @itradeTag as varchar(20)      
  declare @sbTag as varchar(20),@ItradeName as varchar(200),@Itradeemail as varchar(200),@ItradeMob as varchar(20)      
       
  if exists (select 1 from ItradeSBtemp)      
   Begin      
    select @max =count(srno) from ItradeSBtemp      
         
  while(@cnt<=@max)      
   Begin      
         
    select @itradeTag=ItradeSbTag,@sbTag=SbTag from ItradeSBtemp where SrNo=@cnt      
    select @ItradeName=a.TradeName,@Itradeemail=isnull(b.EmailId,''),@ItradeMob=isnull(MobNo,'') from Sb_comp.dbo.SB_Broker a      
    inner join Sb_comp.dbo.SB_Contact b on a.refno=b.RefNo      
    where a.sbtag=@sbTag and b.AddType='RES'      
    exec usp_itradeWelcomeMailer @itradeTag,@ItradeName,@Itradeemail,@ItradeMob      
      
    set @cnt = @cnt +1      
   End      
      
   End      
      
      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SBRoyalTagcreation_Uat
-- --------------------------------------------------
CREATE proc [dbo].[usp_SBRoyalTagcreation_Uat]  
AS  
BEGIN  
 declare @refnoCnter as numeric  
 truncate table ItradeSBtemp   
 --if((select max(left(ItradeRefNo,8)) from ItradeSBtemp) !=replace(Convert(varchar,getdate(),103),'/',''))  
 -- Begin  
 --  truncate table ItradeSBtemp  
 -- End  
   
 if exists (select 1 from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/','')))  
   Begin  
      select @refnoCnter=replace(Convert(varchar,getdate(),103),'/','') + max(right(Refno,3)) from ItradeSB_Broker where (left(Refno,8) = replace(Convert(varchar,getdate(),103),'/',''))  
   End  
 else  
  Begin  
     set @refnoCnter=replace(Convert(varchar,getdate(),103),'/','')+'900'  
  End  
   
  insert into ItradeSBtemp  
  select a.SBTAG,dbo.funcGenRanTag(a.SBTAG),a.RefNo,(@refnoCnter+Row_number() over (order by a.RefNo)) from SB_COMP.DBO.SB_BROKER a with(nolock)   
  left outer join ItradeSB_Broker b on a.sbtag =b.ParentTag  
  inner join [ABVSTSS].SmallOffice.dbo.RefIntermediary c on a.sbtag collate SQL_Latin1_General_CP1_CI_AS =c.Intermediarycode  
  where a.taggenerateddate between Convert(varchar,getdate()-6,101) and Convert(varchar,getdate(),101) + ' 23:59:59'  
  and a.Branch not in ('RFRL','ITRADE','MFSB','SMART') and b.ParentTag is null and a.OrgType in ('CO','I','P','PF')  
  and a.SBTAG  not in(select ParentTag from SB_COMP.DBO.SB_BROKER a with(nolock) where Branch='Itrade' and ParentTag is not null)  
    
    
  insert into ItradeSB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,  
  FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,  
  TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,  
  FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)  
 select a.ItradeRefNo,a.ItradeSBTAG,'ITRADE',b.SBTAG,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,FileNo,  
 PANVerified,getdate(),SBstatus,RegStatus,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,SalTradeName,CTS,PLS,  
 TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,  
 FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date   
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_BROKER b with(nolock) on a.sbtag=b.sbtag  
  
   
 insert into ItradeSB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)  
 select A.ItradeRefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_CONTACT b on a.RefNo=b.RefNo  
  
   
 insert into ItradeSB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,  
 SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,  
 Company,MakerID,CheckerId,TimeStamp,IpAddress)  
 select A.ItradeRefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,  
 TradingAcc,AccClientCode,DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_BANKOTHERS b on a.RefNo=b.RefNo  
  
   
 insert into ItradeBPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,  
 RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,  
 RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],
 [Address Intimate Date],Reason,Filename,Attachment)  
 select A.ItradeRefNo,a.ItradeSBTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,
 RegOffPin,RegOffPhone,RegMobile,RegMobile2,  
 RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,'ITRADE',GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,
  
    AliasName,RegPortalNo,RegIntimateDate,  
 BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.BPREGMASTER b on a.RefNo=b.RegAprRefNo  
  
   
 insert into ItradeBPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments
  
    ,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)  
 select A.ItradeRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,getdate(),ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,
 CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.BPAPPLICATION b on a.RefNo=b.AppRefNo  
  
   
 insert into ItradeSB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,
  
 SpouseOcc,TimeStamp,IPADDRESS)  
 select A.ItradeRefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,OccupationDetails,SpouseOcc,
 TimeStamp,IPADDRESS  
 from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_PERSONAL b on a.RefNo=b.RefNo  
  
   
 insert into ItradeSB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,  
 TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc) select A.ItradeRefNo,PartnerSeq,PartnerSalutation
,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,  
 PanNumber,PANVerified,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,getdate(),MdyBy,MdyDt,SpouseOcc from ItradeSBtemp a left outer join  
 SB_COMP.DBO.SB_Partner b on a.RefNo=b.RefNo  
 where partnerseq is not null  
   
 truncate table tbl_itradeDupRefno  
   
 insert into tbl_itradeDupRefno  
 select A.RefNo from ItradeSB_Broker a  
 inner join SB_COMP.DBO.SB_BROKER b with(nolock) on a.RefNo=b.RefNo  
  
 if exists(select refno from tbl_itradeDupRefno)  
  Begin  
    delete from ItradeSB_Broker where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_CONTACT where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_BANKOTHERS where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeBPREGMASTER where RegAprRefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeBPAPPLICATION where AppRefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_PERSONAL where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSB_Partner where RefNo in (select refno from tbl_itradeDupRefno)  
    delete from ItradeSBtemp where ItradeRefNO in  (select refno from tbl_itradeDupRefno)  
  End  
  
  
 -- Push the data to SB details  
 insert into Sb_comp.dbo.SB_Broker(RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,  
 LeadSource,EmpId,FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,  
 Cso_PanCardName,SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,  
 OldBranchShiftingTag,IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date)  
 select RefNo,SBTAG,Branch,ParentTag,TradeName,OrgType,DOI,NoofPartners,SalContactPerson,ContactPerson,RegCat,PanNo,Objective,ObjOthers,SEBIRegNo,LeadId,LeadSource,EmpId,  
 FileNo,PANVerified,TAGGeneratedDate,SBstatus,RegStatus,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,Printed,SbCat,Certno1,Certno2,Certno3,Certno4,Cso_PancardNum,Cso_PanCardName,  
 SalTradeName,CTS,PLS,TradeNameInCommodity,DOICOR,PanNoCorp,MakerPan,CheckerPan,MakerId,CheckerId,AppStatus,RejectReasons,TimeStamp,IpAddress,AuthSign,OldBranchShiftingTag,  
 IsActive,IsActiveDate,AadharNo,FamilyReason,LEAD_TYPE,LEAD_SOURCE,SB_Broker_Type,MF_REG_Date  
 from ItradeSB_Broker where UpdFlg='N'      
 update ItradeSB_Broker set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_CONTACT(RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3)  
 select RefNo,AddType,AddLine1,AddLine2,Landmark,City,State,Country,PinCode,Stdcode,TelNo,MobNo,FaxNo,EmailId,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,MakerId,CheckerID,TimeStamp,IpAddress,MobNo2,MobNo3 from ItradeSB_CONTACT where UpdFlg='N'  
 update ItradeSB_CONTACT set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_BANKOTHERS(RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,  
 DematAccNo,RegOther,RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress)  
 select  RefNo,NameInBank,AccType,AccNo,BankName,BranchAdd1,BranchAdd2,BranchAdd3,BranchPin,MICRCode,IFSRCode,IncomeRange,BusinessLoc,NomineeRel,NomineeName,Terminallocation,SocialNet,Language,TradingAcc,AccClientCode,DematAccNo,RegOther,  
 RegExgName,RegSeg,SEBIAction,SEBIActDet,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,NoofBranchOffices,Totareasqfeet,TotnoofDealers,TotnoofTerminals,Company,MakerID,CheckerId,TimeStamp,IpAddress from ItradeSB_BANKOTHERS  where UpdFlg='N'  
 update ItradeSB_BANKOTHERS set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.BPREGMASTER(RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,RegResCity,RegResPin,  
 RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,  
 RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],  
 Reason,Filename,Attachment)  
 select RegAprRefNo,RegTAG,RegExchangeSegment,NameSalutation,RegName,TradeNameSalutation,RegTradeName,RegFatherHusbandName,Type,RegDOB,RegSex,RegResAdd1,RegResAdd2,RegResAdd3,  
 RegResCity,RegResPin,RegOffAdd1,RegOffAdd2,RegOffAdd3,RegOffCity,RegOffPin,RegOffPhone,RegMobile,RegMobile2,RegResPhone,RegResFax,RegPAN,RegPAN_Applied,  
 RegCorrespondanceAdd,RegMAPIN,RegProprietorshipYN,RegExpinYrs,RegResidentialStatus,RegEmailId,RegReferenceTAG,RegMkrId,RegMkrDt,TAGBranch,GLUnregisteredcode,GLRegisteredCode,  
 Regstatus,Regdate,RegNo,upload,Alias,AliasName,RegPortalNo,RegIntimateDate,BO_UPDATE,CTS,PLS,[Address status],[Address Intimate Date],Reason,Filename,Attachment from ItradeBPREGMASTER  where UpdFlg='N'  
 update ItradeBPREGMASTER set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.BPAPPLICATION(AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,
 CSOComments,FileNo,MakerId,CheckId,IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno)  
 select  AppRefNo,EST,TerminalLocation,AppDate,AppStatus,StatusDate,CSORemarks,ExchRemarks,SEBIRegNo,CrUser,CrDate,ModUser,ModDate,APPAUTHORISED_PERSON,mode,Client_code,DDNO,Bank_Name,SEBIPortalNo,Intimatedate,SEBIQuery,CSOComments,FileNo,MakerId,CheckId,
IpAddress,TimeStamp,checkerstatus,CheckerSebiRegno from ItradeBPAPPLICATION where UpdFlg='N'  
 update ItradeBPAPPLICATION set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_PERSONAL(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,
 OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)  
 select RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,
 IPADDRESS from ItradeSB_PERSONAL where UpdFlg='N'  
 update ItradeSB_PERSONAL set UpdFlg='Y' where UpdFlg='N'  
  
 insert into Sb_comp.dbo.SB_Partner(RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified
 ,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,  
 TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc)  
 select RefNo,PartnerSeq,PartnerSalutation,PartnerFirstName,PartnerMiddleName,PartnerLastName,FatherName,AddLine1,AddLine2,Landmark,City,State,Country,Pincode,Stdcode,TelNo,MobNo,FaxNo,EmailId,DOB,Sex,PanNumber,PANVerified,Marital,EduQual,Occupation,
 OccDetails,ExpDetails,BrokingCompany,TradMember,  
 BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,SpouseOcc from ItradeSB_Partner where UpdFlg='N'  
 update ItradeSB_Partner set UpdFlg='Y' where UpdFlg='N'  
   
    INSERT INTO Sb_comp.dbo.TAG_BO_DETAILS(TAG,BO_TAG_UPDATE,TAG_DATE)  
    select ItradeSBtag,'N',getdate() from  ItradeSBtemp       
       
  
    declare @max as int,@cnt as int=1  
    declare @itradeTag as varchar(20)  
  declare @sbTag as varchar(20),@ItradeName as varchar(200),@Itradeemail as varchar(200),@ItradeMob as varchar(20)  
   
  if exists (select 1 from ItradeSBtemp)  
   Begin  
    select @max =count(srno) from ItradeSBtemp  
     
  while(@cnt<=@max)  
   Begin  
     
    select @itradeTag=ItradeSbTag,@sbTag=SbTag from ItradeSBtemp where SrNo=@cnt  
    select @ItradeName=a.TradeName,@Itradeemail=isnull(b.EmailId,''),@ItradeMob=isnull(MobNo,'') from Sb_comp.dbo.SB_Broker a  
    inner join Sb_comp.dbo.SB_Contact b on a.refno=b.RefNo  
    where a.sbtag=@sbTag and b.AddType='RES'  
    exec usp_itradeWelcomeMailer_uat @itradeTag,@ItradeName,@Itradeemail,@ItradeMob  
  
    set @cnt = @cnt +1  
   End  
  
   End  
  
  
  
END

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeBPApplication
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeBPApplication]
(
    [AppRefNo] VARCHAR(15) NOT NULL,
    [EST] CHAR(4) NOT NULL,
    [TerminalLocation] VARCHAR(50) NULL,
    [AppDate] DATETIME NULL,
    [AppStatus] VARCHAR(100) NULL,
    [StatusDate] DATETIME NULL,
    [CSORemarks] VARCHAR(4000) NULL,
    [ExchRemarks] VARCHAR(4000) NULL,
    [SEBIRegNo] VARCHAR(50) NULL,
    [CrUser] VARCHAR(500) NULL,
    [CrDate] DATETIME NULL,
    [ModUser] VARCHAR(500) NULL,
    [ModDate] DATETIME NULL,
    [APPAUTHORISED_PERSON] VARCHAR(100) NULL,
    [mode] VARCHAR(15) NULL,
    [Client_code] VARCHAR(20) NULL,
    [DDNO] VARCHAR(20) NULL,
    [Bank_Name] VARCHAR(50) NULL,
    [SEBIPortalNo] VARCHAR(12) NULL,
    [Intimatedate] DATETIME NULL,
    [SEBIQuery] VARCHAR(1000) NULL,
    [CSOComments] VARCHAR(500) NULL,
    [FileNo] VARCHAR(20) NULL,
    [MakerId] VARCHAR(20) NULL,
    [CheckId] VARCHAR(20) NULL,
    [IpAddress] VARCHAR(20) NULL,
    [TimeStamp] DATETIME NULL,
    [checkerstatus] VARCHAR(20) NULL,
    [CheckerSebiRegno] VARCHAR(40) NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeBPREGMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeBPREGMaster]
(
    [RegAprRefNo] VARCHAR(50) NOT NULL,
    [RegTAG] VARCHAR(25) NOT NULL,
    [RegExchangeSegment] VARCHAR(10) NOT NULL,
    [NameSalutation] VARCHAR(10) NULL,
    [RegName] VARCHAR(100) NULL,
    [TradeNameSalutation] VARCHAR(10) NULL,
    [RegTradeName] VARCHAR(300) NULL,
    [RegFatherHusbandName] VARCHAR(200) NULL,
    [Type] VARCHAR(50) NULL,
    [RegDOB] VARCHAR(20) NULL,
    [RegSex] VARCHAR(10) NULL,
    [RegResAdd1] VARCHAR(300) NULL,
    [RegResAdd2] VARCHAR(300) NULL,
    [RegResAdd3] VARCHAR(300) NULL,
    [RegResCity] VARCHAR(30) NULL,
    [RegResPin] VARCHAR(20) NULL,
    [RegOffAdd1] VARCHAR(100) NULL,
    [RegOffAdd2] VARCHAR(100) NULL,
    [RegOffAdd3] VARCHAR(100) NULL,
    [RegOffCity] VARCHAR(50) NULL,
    [RegOffPin] VARCHAR(20) NULL,
    [RegOffPhone] VARCHAR(25) NULL,
    [RegMobile] VARCHAR(100) NULL,
    [RegMobile2] VARCHAR(100) NULL,
    [RegResPhone] VARCHAR(100) NULL,
    [RegResFax] VARCHAR(25) NULL,
    [RegPAN] VARCHAR(15) NULL,
    [RegPAN_Applied] VARCHAR(10) NULL,
    [RegCorrespondanceAdd] VARCHAR(500) NULL,
    [RegMAPIN] VARCHAR(25) NULL,
    [RegProprietorshipYN] VARCHAR(10) NULL,
    [RegExpinYrs] VARCHAR(10) NULL,
    [RegResidentialStatus] VARCHAR(50) NULL,
    [RegEmailId] VARCHAR(100) NULL,
    [RegReferenceTAG] VARCHAR(25) NULL,
    [RegMkrId] VARCHAR(25) NULL,
    [RegMkrDt] VARCHAR(30) NULL,
    [TAGBranch] VARCHAR(50) NULL,
    [GLUnregisteredcode] VARCHAR(15) NULL,
    [GLRegisteredCode] VARCHAR(15) NULL,
    [Regstatus] VARCHAR(50) NULL,
    [Regdate] DATETIME NULL,
    [RegNo] VARCHAR(50) NULL,
    [upload] CHAR(10) NULL,
    [Alias] VARCHAR(50) NULL,
    [AliasName] VARCHAR(50) NULL,
    [RegPortalNo] VARCHAR(12) NULL,
    [RegIntimateDate] DATETIME NULL,
    [BO_UPDATE] CHAR(10) NULL,
    [CTS] VARCHAR(20) NULL,
    [PLS] VARCHAR(20) NULL,
    [Address status] VARCHAR(50) NULL,
    [Address Intimate Date] DATETIME NULL,
    [Reason] VARCHAR(2000) NULL,
    [Filename] VARCHAR(50) NULL,
    [Attachment] VARBINARY(MAX) NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeSB_BankOthers
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeSB_BankOthers]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [NameInBank] VARCHAR(200) NULL,
    [AccType] VARCHAR(10) NULL,
    [AccNo] VARCHAR(50) NULL,
    [BankName] VARCHAR(50) NULL,
    [BranchAdd1] VARCHAR(200) NULL,
    [BranchAdd2] VARCHAR(200) NULL,
    [BranchAdd3] VARCHAR(200) NULL,
    [BranchPin] VARCHAR(10) NULL,
    [MICRCode] VARCHAR(50) NULL,
    [IFSRCode] VARCHAR(50) NULL,
    [IncomeRange] VARCHAR(20) NULL,
    [BusinessLoc] VARCHAR(20) NULL,
    [NomineeRel] VARCHAR(20) NULL,
    [NomineeName] VARCHAR(50) NULL,
    [Terminallocation] VARCHAR(50) NULL,
    [SocialNet] VARCHAR(20) NULL,
    [Language] VARCHAR(50) NULL,
    [TradingAcc] VARCHAR(10) NULL,
    [AccClientCode] VARCHAR(50) NULL,
    [DematAccNo] VARCHAR(50) NULL,
    [RegOther] VARCHAR(10) NULL,
    [RegExgName] VARCHAR(100) NULL,
    [RegSeg] VARCHAR(50) NULL,
    [SEBIAction] VARCHAR(10) NULL,
    [SEBIActDet] VARCHAR(200) NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [NoofBranchOffices] VARCHAR(10) NULL,
    [Totareasqfeet] VARCHAR(10) NULL,
    [TotnoofDealers] VARCHAR(10) NULL,
    [TotnoofTerminals] VARCHAR(10) NULL,
    [Company] VARCHAR(20) NULL,
    [MakerID] VARCHAR(20) NULL,
    [CheckerId] VARCHAR(20) NULL,
    [TimeStamp] DATETIME NULL,
    [IpAddress] VARCHAR(20) NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeSB_Broker
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeSB_Broker]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [SBTAG] VARCHAR(50) NULL,
    [Branch] VARCHAR(50) NULL,
    [ParentTag] VARCHAR(50) NULL,
    [TradeName] VARCHAR(200) NULL,
    [OrgType] VARCHAR(20) NULL,
    [DOI] DATETIME NULL,
    [NoofPartners] INT NULL,
    [SalContactPerson] VARCHAR(20) NULL,
    [ContactPerson] VARCHAR(200) NULL,
    [RegCat] VARCHAR(10) NULL,
    [PanNo] VARCHAR(20) NULL,
    [Objective] VARCHAR(20) NULL,
    [ObjOthers] VARCHAR(100) NULL,
    [SEBIRegNo] VARCHAR(50) NULL,
    [LeadId] VARCHAR(20) NULL,
    [LeadSource] VARCHAR(50) NULL,
    [EmpId] VARCHAR(20) NULL,
    [FileNo] VARCHAR(20) NULL,
    [PANVerified] VARCHAR(5) NULL,
    [TAGGeneratedDate] DATETIME NULL,
    [SBstatus] VARCHAR(20) NULL,
    [RegStatus] INT NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [Printed] CHAR(1) NULL,
    [SbCat] VARCHAR(50) NULL,
    [Certno1] VARCHAR(20) NULL,
    [Certno2] VARCHAR(20) NULL,
    [Certno3] VARCHAR(20) NULL,
    [Certno4] VARCHAR(20) NULL,
    [Cso_PancardNum] VARCHAR(15) NULL,
    [Cso_PanCardName] VARCHAR(200) NULL,
    [SalTradeName] VARCHAR(20) NULL,
    [CTS] VARCHAR(20) NULL,
    [PLS] VARCHAR(20) NULL,
    [TradeNameInCommodity] VARCHAR(200) NULL,
    [DOICOR] DATETIME NULL,
    [PanNoCorp] VARCHAR(20) NULL,
    [MakerPan] VARCHAR(20) NULL,
    [CheckerPan] VARCHAR(20) NULL,
    [MakerId] VARCHAR(100) NULL,
    [CheckerId] VARCHAR(10) NULL,
    [AppStatus] VARCHAR(1) NULL,
    [RejectReasons] VARCHAR(4000) NULL,
    [TimeStamp] DATETIME NULL,
    [IpAddress] VARCHAR(20) NULL,
    [AuthSign] VARCHAR(100) NULL,
    [OldBranchShiftingTag] VARCHAR(30) NULL,
    [IsActive] VARCHAR(10) NULL,
    [IsActiveDate] DATETIME NULL,
    [AadharNo] VARCHAR(50) NULL,
    [FamilyReason] VARCHAR(200) NULL,
    [LEAD_TYPE] VARCHAR(20) NULL,
    [LEAD_SOURCE] VARCHAR(100) NULL,
    [SB_Broker_Type] VARCHAR(10) NULL,
    [MF_REG_Date] DATETIME NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeSB_Contact
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeSB_Contact]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [AddType] VARCHAR(10) NULL,
    [AddLine1] VARCHAR(1000) NULL,
    [AddLine2] VARCHAR(1000) NULL,
    [Landmark] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [State] VARCHAR(100) NULL,
    [Country] VARCHAR(50) NULL,
    [PinCode] VARCHAR(10) NULL,
    [Stdcode] VARCHAR(20) NULL,
    [TelNo] VARCHAR(100) NULL,
    [MobNo] VARCHAR(100) NULL,
    [FaxNo] VARCHAR(20) NULL,
    [EmailId] VARCHAR(200) NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [MakerId] VARCHAR(20) NULL,
    [CheckerID] VARCHAR(20) NULL,
    [TimeStamp] DATETIME NULL,
    [IpAddress] VARCHAR(20) NULL,
    [MobNo2] VARCHAR(20) NULL,
    [MobNo3] VARCHAR(20) NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeSB_Partner
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeSB_Partner]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [PartnerSeq] INT NOT NULL,
    [PartnerSalutation] VARCHAR(50) NULL,
    [PartnerFirstName] VARCHAR(100) NULL,
    [PartnerMiddleName] VARCHAR(100) NULL,
    [PartnerLastName] VARCHAR(100) NULL,
    [FatherName] VARCHAR(100) NULL,
    [AddLine1] VARCHAR(200) NULL,
    [AddLine2] VARCHAR(200) NULL,
    [Landmark] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [State] VARCHAR(100) NULL,
    [Country] VARCHAR(50) NULL,
    [Pincode] VARCHAR(10) NULL,
    [Stdcode] VARCHAR(20) NULL,
    [TelNo] VARCHAR(20) NULL,
    [MobNo] VARCHAR(20) NULL,
    [FaxNo] VARCHAR(20) NULL,
    [EmailId] VARCHAR(200) NULL,
    [DOB] DATETIME NULL,
    [Sex] CHAR(10) NULL,
    [PanNumber] VARCHAR(20) NULL,
    [PANVerified] VARCHAR(5) NULL,
    [Marital] VARCHAR(20) NULL,
    [EduQual] VARCHAR(20) NULL,
    [Occupation] VARCHAR(20) NULL,
    [OccDetails] VARCHAR(150) NULL,
    [ExpDetails] VARCHAR(150) NULL,
    [BrokingCompany] VARCHAR(250) NULL,
    [TradMember] VARCHAR(100) NULL,
    [BrokExp] VARCHAR(20) NULL,
    [Photograph] IMAGE NULL,
    [Signature] IMAGE NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(50) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(50) NULL,
    [MdyDt] DATETIME NULL,
    [SpouseOcc] VARCHAR(50) NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeSB_Personal
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeSB_Personal]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [Salutation] VARCHAR(50) NULL,
    [FirstName] VARCHAR(200) NULL,
    [MiddleName] VARCHAR(200) NULL,
    [LastName] VARCHAR(200) NULL,
    [FathHusbName] VARCHAR(200) NULL,
    [DOB] DATETIME NULL,
    [Sex] CHAR(1) NULL,
    [Marital] VARCHAR(20) NULL,
    [EduQual] VARCHAR(20) NULL,
    [Occupation] VARCHAR(20) NULL,
    [OccDetails] VARCHAR(150) NULL,
    [ExpDetails] VARCHAR(150) NULL,
    [BrokingCompany] VARCHAR(250) NULL,
    [TradMember] VARCHAR(100) NULL,
    [BrokExp] VARCHAR(20) NULL,
    [Photograph] IMAGE NULL,
    [Signature] IMAGE NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [OccupationDetails] VARCHAR(50) NULL,
    [SpouseOcc] VARCHAR(50) NULL,
    [TimeStamp] DATETIME NULL,
    [IPADDRESS] VARCHAR(20) NULL,
    [updFlg] VARCHAR(5) NULL DEFAULT 'N'
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItradeSBtemp
-- --------------------------------------------------
CREATE TABLE [dbo].[ItradeSBtemp]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [SBtag] VARCHAR(20) NULL,
    [ItradeSBtag] VARCHAR(20) NULL,
    [RefNO] NUMERIC(18, 0) NULL,
    [ItradeRefNO] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_itradeDupRefno
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_itradeDupRefno]
(
    [RefNo] NUMERIC(18, 0) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ItradeTAG
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ItradeTAG]
(
    [RefNo] BIGINT NOT NULL,
    [RegTAG] VARCHAR(50) NOT NULL,
    [TAGGeneratedDate] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test_LS
-- --------------------------------------------------
CREATE TABLE [dbo].[test_LS]
(
    [num] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uat_BPAPPLICATION
-- --------------------------------------------------
CREATE TABLE [dbo].[uat_BPAPPLICATION]
(
    [AppRefNo] VARCHAR(15) NOT NULL,
    [EST] CHAR(4) NOT NULL,
    [TerminalLocation] VARCHAR(50) NULL,
    [AppDate] DATETIME NULL,
    [AppStatus] VARCHAR(100) NULL,
    [StatusDate] DATETIME NULL,
    [CSORemarks] VARCHAR(4000) NULL,
    [ExchRemarks] VARCHAR(4000) NULL,
    [SEBIRegNo] VARCHAR(50) NULL,
    [CrUser] VARCHAR(500) NULL,
    [CrDate] DATETIME NULL,
    [ModUser] VARCHAR(500) NULL,
    [ModDate] DATETIME NULL,
    [APPAUTHORISED_PERSON] VARCHAR(100) NULL,
    [mode] VARCHAR(15) NULL,
    [Client_code] VARCHAR(20) NULL,
    [DDNO] VARCHAR(20) NULL,
    [Bank_Name] VARCHAR(50) NULL,
    [SEBIPortalNo] VARCHAR(12) NULL,
    [Intimatedate] DATETIME NULL,
    [SEBIQuery] VARCHAR(1000) NULL,
    [CSOComments] VARCHAR(500) NULL,
    [FileNo] VARCHAR(20) NULL,
    [MakerId] VARCHAR(20) NULL,
    [CheckId] VARCHAR(20) NULL,
    [IpAddress] VARCHAR(20) NULL,
    [TimeStamp] DATETIME NULL,
    [checkerstatus] VARCHAR(20) NULL,
    [CheckerSebiRegno] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uat_BPREGMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[uat_BPREGMASTER]
(
    [RegAprRefNo] VARCHAR(50) NOT NULL,
    [RegTAG] VARCHAR(25) NOT NULL,
    [RegExchangeSegment] VARCHAR(10) NOT NULL,
    [NameSalutation] VARCHAR(10) NULL,
    [RegName] VARCHAR(100) NULL,
    [TradeNameSalutation] VARCHAR(10) NULL,
    [RegTradeName] VARCHAR(300) NULL,
    [RegFatherHusbandName] VARCHAR(200) NULL,
    [Type] VARCHAR(50) NULL,
    [RegDOB] VARCHAR(20) NULL,
    [RegSex] VARCHAR(10) NULL,
    [RegResAdd1] VARCHAR(300) NULL,
    [RegResAdd2] VARCHAR(300) NULL,
    [RegResAdd3] VARCHAR(300) NULL,
    [RegResCity] VARCHAR(30) NULL,
    [RegResPin] VARCHAR(20) NULL,
    [RegOffAdd1] VARCHAR(100) NULL,
    [RegOffAdd2] VARCHAR(100) NULL,
    [RegOffAdd3] VARCHAR(100) NULL,
    [RegOffCity] VARCHAR(50) NULL,
    [RegOffPin] VARCHAR(20) NULL,
    [RegOffPhone] VARCHAR(25) NULL,
    [RegMobile] VARCHAR(100) NULL,
    [RegMobile2] VARCHAR(100) NULL,
    [RegResPhone] VARCHAR(100) NULL,
    [RegResFax] VARCHAR(25) NULL,
    [RegPAN] VARCHAR(15) NULL,
    [RegPAN_Applied] VARCHAR(10) NULL,
    [RegCorrespondanceAdd] VARCHAR(500) NULL,
    [RegMAPIN] VARCHAR(25) NULL,
    [RegProprietorshipYN] VARCHAR(10) NULL,
    [RegExpinYrs] VARCHAR(10) NULL,
    [RegResidentialStatus] VARCHAR(50) NULL,
    [RegEmailId] VARCHAR(100) NULL,
    [RegReferenceTAG] VARCHAR(25) NULL,
    [RegMkrId] VARCHAR(25) NULL,
    [RegMkrDt] VARCHAR(30) NULL,
    [TAGBranch] VARCHAR(50) NULL,
    [GLUnregisteredcode] VARCHAR(15) NULL,
    [GLRegisteredCode] VARCHAR(15) NULL,
    [Regstatus] VARCHAR(50) NULL,
    [Regdate] DATETIME NULL,
    [RegNo] VARCHAR(50) NULL,
    [upload] CHAR(10) NULL,
    [Alias] VARCHAR(50) NULL,
    [AliasName] VARCHAR(50) NULL,
    [RegPortalNo] VARCHAR(12) NULL,
    [RegIntimateDate] DATETIME NULL,
    [BO_UPDATE] CHAR(10) NULL,
    [CTS] VARCHAR(20) NULL,
    [PLS] VARCHAR(20) NULL,
    [Address status] VARCHAR(50) NULL,
    [Address Intimate Date] DATETIME NULL,
    [Reason] VARCHAR(2000) NULL,
    [Filename] VARCHAR(50) NULL,
    [Attachment] VARBINARY(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uat_SB_BANKOTHERS
-- --------------------------------------------------
CREATE TABLE [dbo].[uat_SB_BANKOTHERS]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [NameInBank] VARCHAR(200) NULL,
    [AccType] VARCHAR(10) NULL,
    [AccNo] VARCHAR(50) NULL,
    [BankName] VARCHAR(50) NULL,
    [BranchAdd1] VARCHAR(200) NULL,
    [BranchAdd2] VARCHAR(200) NULL,
    [BranchAdd3] VARCHAR(200) NULL,
    [BranchPin] VARCHAR(10) NULL,
    [MICRCode] VARCHAR(50) NULL,
    [IFSRCode] VARCHAR(50) NULL,
    [IncomeRange] VARCHAR(20) NULL,
    [BusinessLoc] VARCHAR(20) NULL,
    [NomineeRel] VARCHAR(20) NULL,
    [NomineeName] VARCHAR(50) NULL,
    [Terminallocation] VARCHAR(50) NULL,
    [SocialNet] VARCHAR(20) NULL,
    [Language] VARCHAR(50) NULL,
    [TradingAcc] VARCHAR(10) NULL,
    [AccClientCode] VARCHAR(50) NULL,
    [DematAccNo] VARCHAR(50) NULL,
    [RegOther] VARCHAR(10) NULL,
    [RegExgName] VARCHAR(100) NULL,
    [RegSeg] VARCHAR(50) NULL,
    [SEBIAction] VARCHAR(10) NULL,
    [SEBIActDet] VARCHAR(200) NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [NoofBranchOffices] VARCHAR(10) NULL,
    [Totareasqfeet] VARCHAR(10) NULL,
    [TotnoofDealers] VARCHAR(10) NULL,
    [TotnoofTerminals] VARCHAR(10) NULL,
    [Company] VARCHAR(20) NULL,
    [MakerID] VARCHAR(20) NULL,
    [CheckerId] VARCHAR(20) NULL,
    [TimeStamp] DATETIME NULL,
    [IpAddress] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uat_SB_Broker
-- --------------------------------------------------
CREATE TABLE [dbo].[uat_SB_Broker]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [SBTAG] VARCHAR(50) NULL,
    [Branch] VARCHAR(50) NULL,
    [ParentTag] VARCHAR(50) NULL,
    [TradeName] VARCHAR(200) NULL,
    [OrgType] VARCHAR(20) NULL,
    [DOI] DATETIME NULL,
    [NoofPartners] INT NULL,
    [SalContactPerson] VARCHAR(20) NULL,
    [ContactPerson] VARCHAR(200) NULL,
    [RegCat] VARCHAR(10) NULL,
    [PanNo] VARCHAR(20) NULL,
    [Objective] VARCHAR(20) NULL,
    [ObjOthers] VARCHAR(100) NULL,
    [SEBIRegNo] VARCHAR(50) NULL,
    [LeadId] VARCHAR(20) NULL,
    [LeadSource] VARCHAR(50) NULL,
    [EmpId] VARCHAR(20) NULL,
    [FileNo] VARCHAR(20) NULL,
    [PANVerified] VARCHAR(5) NULL,
    [TAGGeneratedDate] DATETIME NULL,
    [SBstatus] VARCHAR(20) NULL,
    [RegStatus] INT NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [Printed] CHAR(1) NULL,
    [SbCat] VARCHAR(50) NULL,
    [Certno1] VARCHAR(20) NULL,
    [Certno2] VARCHAR(20) NULL,
    [Certno3] VARCHAR(20) NULL,
    [Certno4] VARCHAR(20) NULL,
    [Cso_PancardNum] VARCHAR(15) NULL,
    [Cso_PanCardName] VARCHAR(200) NULL,
    [SalTradeName] VARCHAR(20) NULL,
    [CTS] VARCHAR(20) NULL,
    [PLS] VARCHAR(20) NULL,
    [TradeNameInCommodity] VARCHAR(200) NULL,
    [DOICOR] DATETIME NULL,
    [PanNoCorp] VARCHAR(20) NULL,
    [MakerPan] VARCHAR(20) NULL,
    [CheckerPan] VARCHAR(20) NULL,
    [MakerId] VARCHAR(100) NULL,
    [CheckerId] VARCHAR(10) NULL,
    [AppStatus] VARCHAR(1) NULL,
    [RejectReasons] VARCHAR(4000) NULL,
    [TimeStamp] DATETIME NULL,
    [IpAddress] VARCHAR(20) NULL,
    [AuthSign] VARCHAR(100) NULL,
    [OldBranchShiftingTag] VARCHAR(30) NULL,
    [IsActive] VARCHAR(10) NULL,
    [IsActiveDate] DATETIME NULL,
    [AadharNo] VARCHAR(50) NULL,
    [FamilyReason] VARCHAR(200) NULL,
    [LEAD_TYPE] VARCHAR(20) NULL,
    [LEAD_SOURCE] VARCHAR(100) NULL,
    [SB_Broker_Type] VARCHAR(10) NULL,
    [MF_REG_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uat_SB_CONTACT
-- --------------------------------------------------
CREATE TABLE [dbo].[uat_SB_CONTACT]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [AddType] VARCHAR(10) NULL,
    [AddLine1] VARCHAR(1000) NULL,
    [AddLine2] VARCHAR(1000) NULL,
    [Landmark] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [State] VARCHAR(100) NULL,
    [Country] VARCHAR(50) NULL,
    [PinCode] VARCHAR(10) NULL,
    [Stdcode] VARCHAR(20) NULL,
    [TelNo] VARCHAR(100) NULL,
    [MobNo] VARCHAR(100) NULL,
    [FaxNo] VARCHAR(20) NULL,
    [EmailId] VARCHAR(200) NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(500) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(500) NULL,
    [MdyDt] DATETIME NULL,
    [MakerId] VARCHAR(20) NULL,
    [CheckerID] VARCHAR(20) NULL,
    [TimeStamp] DATETIME NULL,
    [IpAddress] VARCHAR(20) NULL,
    [MobNo2] VARCHAR(20) NULL,
    [MobNo3] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uat_SB_Partner
-- --------------------------------------------------
CREATE TABLE [dbo].[uat_SB_Partner]
(
    [RefNo] NUMERIC(18, 0) NOT NULL,
    [PartnerSeq] INT NOT NULL,
    [PartnerSalutation] VARCHAR(50) NULL,
    [PartnerFirstName] VARCHAR(100) NULL,
    [PartnerMiddleName] VARCHAR(100) NULL,
    [PartnerLastName] VARCHAR(100) NULL,
    [FatherName] VARCHAR(100) NULL,
    [AddLine1] VARCHAR(200) NULL,
    [AddLine2] VARCHAR(200) NULL,
    [Landmark] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [State] VARCHAR(100) NULL,
    [Country] VARCHAR(50) NULL,
    [Pincode] VARCHAR(10) NULL,
    [Stdcode] VARCHAR(20) NULL,
    [TelNo] VARCHAR(20) NULL,
    [MobNo] VARCHAR(20) NULL,
    [FaxNo] VARCHAR(20) NULL,
    [EmailId] VARCHAR(200) NULL,
    [DOB] DATETIME NULL,
    [Sex] CHAR(10) NULL,
    [PanNumber] VARCHAR(20) NULL,
    [PANVerified] VARCHAR(5) NULL,
    [Marital] VARCHAR(20) NULL,
    [EduQual] VARCHAR(20) NULL,
    [Occupation] VARCHAR(20) NULL,
    [OccDetails] VARCHAR(150) NULL,
    [ExpDetails] VARCHAR(150) NULL,
    [BrokingCompany] VARCHAR(250) NULL,
    [TradMember] VARCHAR(100) NULL,
    [BrokExp] VARCHAR(20) NULL,
    [Photograph] IMAGE NULL,
    [Signature] IMAGE NULL,
    [RecStatus] INT NULL,
    [CrtBy] VARCHAR(50) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(50) NULL,
    [MdyDt] DATETIME NULL,
    [SpouseOcc] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UAT_TAG_BO_DETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[UAT_TAG_BO_DETAILS]
(
    [TAG] VARCHAR(20) NULL,
    [TAG_DATE] DATETIME NULL,
    [BO_TAG_UPDATE] CHAR(1) NULL,
    [BO_TAG_UPDATE_DATE] DATETIME NULL,
    [BO_GLCODE_UPDATE] CHAR(1) NULL,
    [BO_GLCODE_UPDATE_DATE] DATETIME NULL,
    [REMARKS] VARCHAR(100) NULL
);

GO

