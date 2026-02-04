-- DDL Export
-- Server: 10.253.33.89
-- Database: kyc
-- Exported: 2026-02-05T02:38:48.725989

USE kyc;
GO

-- --------------------------------------------------
-- INDEX dbo.Clt_Password_SMS_Log
-- --------------------------------------------------
CREATE CLUSTERED INDEX [active_date] ON [dbo].[Clt_Password_SMS_Log] ([active_date])

GO

-- --------------------------------------------------
-- INDEX dbo.Clt_Password_SMS_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_active_date] ON [dbo].[Clt_Password_SMS_Log] ([active_date], [SMS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.Clt_Password_SMS_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [nc_Clt_Password_SMS_Log] ON [dbo].[Clt_Password_SMS_Log] ([SMS_Date], [active_date]) INCLUDE ([party_code], [mobile_pager], [Inactive_Date], [inserted_on], [updated_on])

GO

-- --------------------------------------------------
-- INDEX dbo.Clt_Password_SMS_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ncl_party_code] ON [dbo].[Clt_Password_SMS_Log] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.kycregister_renamed_For_PII
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ind_pan_gir_no] ON [dbo].[kycregister_renamed_For_PII] ([pan_gir_no])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_USPKYCJV
-- --------------------------------------------------
CREATE procedure [dbo].[Angel_USPKYCJV]  
as   
set nocount on  
set transaction isolation level read uncommitted  
declare @str as varchar(500),@stdt as varchar(500)  
set @stdt = convert(varchar,getdate()-1,112)  
set @str= 'AngelNseCM.msajag.dbo.V2_OFFLINE_CLIENTMASTER '''+@stdt+''',''I'','''','''',''All'',''All'''  
--print @str   
  
truncate table temp_track  
-- exec(@str)  
insert into temp_track exec(@str) 

insert into tbl_track select * from temp_track
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.find_table
-- --------------------------------------------------
CREATE proc find_table @content varchar(20)  
as   
print @content  
select * from information_schema.tables where table_name like '%'+@content+'%'

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
-- PROCEDURE dbo.USP_KycLetter_SMS
-- --------------------------------------------------
CREATE proc [dbo].[USP_KycLetter_SMS]                
as              
               
insert into Clt_Password_SMS_Log                
select party_code=ltrim(rtrim(cl_code)),mobile_pager,active_date=convert(varchar(11),''),SMS_Date=convert(varchar(11),''),Inactive_Date=convert(varchar(11),'')            
,getdate(),''              
from AngelNseCM.msajag.dbo.client_details with (nolock) where isnumeric(cl_code) = 0 and cl_code not in (select party_code from Clt_Password_SMS_Log)                
              
insert into tbl_sms_log               
select 'Update Client',count(*),getdate()              
from Clt_Password_SMS_Log with (nolock) where active_date = '' and sms_date = ''              
              
select cl_code=ltrim(rtrim(cl_code)), active_date=isnull(min(active_date),''),Inactive_Date=isnull(max(inactive_from),'')              
into #B                
from AngelNseCM.msajag.dbo.client_brok_details with (nolock) where cl_code in (select party_code from Clt_Password_SMS_Log where active_date = '')                
and convert(datetime,inactive_from,103) > convert(datetime,convert(varchar(11),getdate(),103),103)              
and active_date <= getdate()              
and convert(varchar(11),active_date,103) <> convert(varchar(11),inactive_from,103)              
group by cl_code              
                
update Clt_Password_SMS_Log set active_date = convert(varchar(11),#B.active_date,103),Inactive_Date = convert(varchar(11),#B.Inactive_Date,103),updated_on=getdate()              
from Clt_Password_SMS_Log A, #B where ltrim(rtrim(#B.cl_code)) = ltrim(rtrim(A.party_code)) and A.active_date = ''                
                
insert into tbl_sms_log               
select 'Update ActiveDate',count(*),getdate()              
from Clt_Password_SMS_Log with (nolock) where sms_date = ''              
                
/*              
--update Clt_Password_SMS_Log set active_date = '01/01/1900' where active_date = ''              
--update Clt_Password_SMS_Log set SMS_date = '01/01/1900' where sms_date = '' and active_date <> convert(varchar(10),getdate(),103)              
--select * from Clt_Password_SMS_Log with (nolock) where Inactive_date = ''              
*/                
                
--------------BO PASSWORD----------------------              
DECLARE  @pcode varchar(10)              
              
declare @ss as table              
(Password varchar(25))                
                
select distinct party_code,password=space(10),GeneratedOn=getdate(),encruppswd=space(10) into #temp1               
from  Clt_Password_SMS_Log where sms_date='' and active_date <> '' and active_date <> '01/01/2000'              
and party_Code not in (select party_code from ctcl.dbo.BO_Client_Password)              
               
DECLARE error_cursor CURSOR FOR               
select party_code from #temp1               
                
OPEN error_cursor              
              
FETCH NEXT FROM error_cursor               
INTO @pcode              
              
WHILE @@FETCH_STATUS = 0              
BEGIN              
              
  insert into @ss (password) exec ctcl.dbo.random_password1 8,''                
  update @ss set password=replace(password,'O','x')                
  update @ss set password=replace(password,'0','q')                
  update @ss set password=replace(password,'B','e')                
  update @ss set password=replace(password,'8','n')                
  update @ss set password=replace(password,'5','k')                
  update @ss set password=replace(password,'S','d')                
  update @ss set password=replace(password,'1','w')                
  update @ss set password=replace(password,'I','z')                
  update @ss set password=replace(password,'L','v')                
  update @ss set password=lower(password)                
              
/*              
  update #temp1 set password=replace(b.password,'''','a') from @ss b where #temp1.party_code=@pcode              
  update #temp1 set password=replace(b.password,'"','a') from @ss b where #temp1.party_code=@pcode              
  update #temp1 set password=replace(b.password,'O','x') from @ss b where #temp1.party_code=@pcode          
  update #temp1 set password=replace(b.password,'0','x') from @ss b where #temp1.party_code=@pcode                
*/              
  update #temp1 set password=b.password from @ss b where #temp1.party_code=@pcode          
  delete from @ss              
              
  FETCH NEXT FROM error_cursor               
  INTO @pcode              
              
END                
              
CLOSE error_cursor              
DEALLOCATE error_cursor              
               
--update #temp1 set password=replace(password,'O','x')                
--update #temp1 set password=replace(password,'0','x')                
              
update #temp1 set password = 'x'+substring(password,2,7) where ascii(substring(password,1,1))=113              
update #temp1 set password = substring(password,1,1)+'x'+substring(password,3,6) where ascii(substring(password,2,1))=70              
update #temp1 set password = substring(password,1,2)+'x'+substring(password,4,5) where ascii(substring(password,3,1))=69              
update #temp1 set password = substring(password,1,3)+'x'+substring(password,5,4) where ascii(substring(password,4,1))=71              
update #temp1 set password = substring(password,1,4)+'x'+substring(password,6,3) where ascii(substring(password,5,1))=114              
update #temp1 set password = substring(password,1,5)+'x'+substring(password,7,2) where ascii(substring(password,6,1))=73              
update #temp1 set password = substring(password,1,6)+'x'+substring(password,8,1) where ascii(substring(password,7,1))=122              
update #temp1 set password = substring(password,1,7)+'x' where ascii(substring(password,8,1))=118              
              
update #temp1 set password = 'e'+substring(password,2,7) where ascii(substring(password,1,1))=ascii('i')              
update #temp1 set password = substring(password,1,1)+'e'+substring(password,3,6) where ascii(substring(password,2,1))=ascii('x')              
update #temp1 set password = substring(password,1,2)+'e'+substring(password,4,5) where ascii(substring(password,3,1))=ascii('w')              
update #temp1 set password = substring(password,1,3)+'e'+substring(password,5,4) where ascii(substring(password,4,1))=ascii('y') update #temp1 set password = substring(password,1,4)+'e'+substring(password,6,3)               
where ascii(substring(password,5,1))=ascii('j')                
update #temp1 set password = substring(password,1,5)+'e'+substring(password,7,2) where ascii(substring(password,6,1))=ascii('A')              
update #temp1 set password = substring(password,1,6)+'e'+substring(password,8,1) where ascii(substring(password,7,1))=ascii('r')              
update #temp1 set password = substring(password,1,7)+'e' where ascii(substring(password,8,1))=ascii('n')              
               
insert into ctcl.dbo.BO_Client_Password select *,'WelcomeKit','' from #temp1                
insert into tbl_sms_log               
select 'Generate Password',count(*),getdate() from #Temp1 with (nolock)              
------------------------------------------------              
--Insert into SMS Table              
select a.*,b.password into #tt           
from              
(select * from Clt_Password_SMS_Log where sms_date = '' and active_date <> ''               
and len(mobile_pager)=10 and (left(mobile_pager,1)='9' or left(mobile_pager,1)='8'))a              
inner join              
(select party_code,password from ctcl.dbo.BO_Client_Password where source='WelcomeKit')b              
on a.party_code=b.party_code              
            
              
/*          
Ebrok client exclude from sending sms          
Added By : Unnati Desai          
Added On : 22 Nov 2010          
Requested by: Vikram Gosar          
*/              
          
update ebrok_kyc_online set sms_date=a.sms_date from mis.genodinlimit.dbo.ebrok_kyc_smslog a where   
ebrok_kyc_online.party_code=a.party_code             
select distinct party_code into #ebrok from ABVSKYCMIS.kyc.dbo.client_inwardregister with (nolock)            
where (ebroking='y' or len(drpproduct)>5)      
        
insert into ebrok_kyc_online         
select distinct party_code,mobile_pager,active_date,SMS_Date,Inactive_Date,convert(varchar(11),getdate()),updated_on,[password]         
from #tt         
where party_code in         
/*(select distinct party_code from ctcl.dbo.ebrok_client)  */      
( select party_code from #ebrok )        
          
insert into tbl_sms_log               
select 'Ebroking Client',count(*),getdate() from ebrok_kyc_online with (nolock)            
where  inserted_on=convert(varchar(11),getdate())          
          
delete from #tt where party_code in (select party_code from ebrok_kyc_online with (nolock)             
where  inserted_on=convert(varchar(11),getdate()))          
/*end*/              
          
             
insert into sms.dbo.sms                
select mobile_pager,'Dear Customer, Please note your back office login ID is your client code, Password: '+password                
+'. Pl contact 022-3355 1111 for any assistance',              
convert(varchar(11),getdate(),103),left(convert(varchar(11),getdate(),108),5),'P','','KYC BO Password'               
from #tt              
              
insert into tbl_sms_log               
select 'Generate SMS',count(*),getdate() from #TT with (nolock)              
              
update Clt_Password_SMS_Log set SMS_date = convert(varchar(10),getdate(),103)              
where sms_date = ''  and party_code in (select party_code from #tt)                
              
insert into tbl_sms_log               
select 'SMS Not Sent',count(*),getdate() from Clt_Password_SMS_Log with (nolock) where sms_date = ''              
              
update Clt_Password_SMS_Log set SMS_date = 'Not Sent' where sms_date = '' and active_date <> ''

GO

-- --------------------------------------------------
-- TABLE dbo.ail
-- --------------------------------------------------
CREATE TABLE [dbo].[ail]
(
    [branch] NVARCHAR(255) NULL,
    [subbroker] NVARCHAR(255) NULL,
    [emailid] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Atul
-- --------------------------------------------------
CREATE TABLE [dbo].[Atul]
(
    [Name] VARCHAR(255) NULL,
    [Address] VARCHAR(255) NULL,
    [city] VARCHAR(255) NULL,
    [MobNumber] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bak_ctcl_old
-- --------------------------------------------------
CREATE TABLE [dbo].[bak_ctcl_old]
(
    [RecId] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [BranchId] NUMERIC(4, 0) NOT NULL,
    [Segment] CHAR(1) NOT NULL,
    [OdinID] VARCHAR(10) NULL,
    [OffNature] NVARCHAR(50) NULL,
    [PanNo] NVARCHAR(10) NULL,
    [SEBINO] NVARCHAR(12) NULL,
    [SubBrokerName] NVARCHAR(50) NULL,
    [AuthPerson] NVARCHAR(50) NULL,
    [MapinNo] NVARCHAR(9) NULL,
    [Address1] NVARCHAR(50) NOT NULL,
    [Address2] NVARCHAR(50) NULL,
    [Address3] NVARCHAR(50) NULL,
    [City] NVARCHAR(35) NULL,
    [Pincode] NVARCHAR(10) NULL,
    [State] NVARCHAR(35) NULL,
    [ContactPerson] NVARCHAR(50) NULL,
    [Designation] NVARCHAR(25) NULL,
    [Phoneno] NVARCHAR(25) NULL,
    [Fax] NVARCHAR(25) NULL,
    [Mailid] NVARCHAR(25) NULL,
    [LineMode] NVARCHAR(50) NOT NULL,
    [ApprovedPerson] NVARCHAR(50) NOT NULL,
    [FatherName] NVARCHAR(50) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [ResAddress1] NVARCHAR(50) NOT NULL,
    [ResAddress2] NVARCHAR(50) NULL,
    [ResAddress3] NVARCHAR(50) NULL,
    [ResAddress4] NVARCHAR(50) NOT NULL,
    [ResAddress5] NVARCHAR(50) NOT NULL,
    [PerAddress1] NVARCHAR(50) NOT NULL,
    [PerAddress2] NVARCHAR(50) NULL,
    [PerAddress3] NVARCHAR(50) NULL,
    [PerAddress4] NVARCHAR(50) NOT NULL,
    [PerAddress5] NVARCHAR(50) NOT NULL,
    [Relation] NUMERIC(2, 0) NOT NULL,
    [AllotDate] DATETIME NOT NULL,
    [DisablingDate] DATETIME NULL,
    [PayNature] NVARCHAR(25) NOT NULL,
    [Regno] NVARCHAR(30) NULL,
    [RegValidDate] DATETIME NULL,
    [Purpose] CHAR(3) NOT NULL,
    [Status] CHAR(1) NOT NULL,
    [Audit] CHAR(1) NOT NULL,
    [CTCLID] NVARCHAR(12) NULL,
    [CTCLDTL_ID] NUMERIC(18, 0) NULL,
    [Remark] NVARCHAR(100) NULL,
    [NCFMTag] CHAR(1) NULL,
    [Ncfm_Remarks] NVARCHAR(100) NULL,
    [Created_By] NUMERIC(4, 0) NOT NULL,
    [Created_Date] DATETIME NOT NULL,
    [Modified_By] NUMERIC(4, 0) NULL,
    [Modified_Date] DATETIME NULL,
    [IBranch_type] NVARCHAR(15) NULL,
    [IAdd1] NVARCHAR(50) NULL,
    [IAdd2] NVARCHAR(50) NULL,
    [IAdd3] NVARCHAR(50) NULL,
    [IPin] NVARCHAR(10) NULL,
    [ICity] NVARCHAR(20) NULL,
    [IState] NVARCHAR(35) NULL,
    [ISBType] NVARCHAR(30) NULL,
    [ISBName] NVARCHAR(50) NULL,
    [ISBRegno] NVARCHAR(12) NULL,
    [ISBRegdt] DATETIME NULL,
    [IAUType] NVARCHAR(20) NULL,
    [IAUName] NVARCHAR(50) NULL,
    [IAUdt] DATETIME NULL,
    [IRelation] NVARCHAR(50) NULL,
    [IVerified] CHAR(2) NULL,
    [ISBTag] NVARCHAR(25) NULL,
    [Approval_Status] NVARCHAR(1) NULL,
    [Approval_Reason] NVARCHAR(50) NULL,
    [Angel_premises] NVARCHAR(10) NULL,
    [IBranch_cd] NVARCHAR(7) NULL,
    [ConServer] NVARCHAR(50) NULL,
    [CTCL_AngEmpCode] NVARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Clt_Password_SMS_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[Clt_Password_SMS_Log]
(
    [party_code] VARCHAR(10) NULL,
    [mobile_pager] VARCHAR(30) NOT NULL DEFAULT '',
    [active_date] VARCHAR(11) NULL,
    [SMS_Date] VARCHAR(11) NULL,
    [Inactive_Date] VARCHAR(11) NOT NULL DEFAULT '',
    [inserted_on] DATETIME NULL,
    [updated_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rates
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rates]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ebrok_kyc_online
-- --------------------------------------------------
CREATE TABLE [dbo].[ebrok_kyc_online]
(
    [party_code] VARCHAR(10) NULL,
    [mobile_pager] VARCHAR(30) NOT NULL,
    [active_date] VARCHAR(11) NULL,
    [SMS_Date] DATETIME NULL,
    [Inactive_Date] VARCHAR(11) NOT NULL,
    [inserted_on] DATETIME NULL,
    [updated_on] DATETIME NULL,
    [password] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.formdetails
-- --------------------------------------------------
CREATE TABLE [dbo].[formdetails]
(
    [PCODE] VARCHAR(8) NULL,
    [ID] FLOAT NULL,
    [BREF] FLOAT NULL,
    [DEED] FLOAT NULL,
    [BOARD] FLOAT NULL,
    [SIGN] FLOAT NULL,
    [DP] FLOAT NULL,
    [INTRO] FLOAT NULL,
    [BANK] FLOAT NULL,
    [PAN] FLOAT NULL,
    [COCODE] VARCHAR(6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.formdetails1
-- --------------------------------------------------
CREATE TABLE [dbo].[formdetails1]
(
    [PCODE] VARCHAR(8) NULL,
    [ID] FLOAT NULL,
    [BREF] FLOAT NULL,
    [DEED] FLOAT NULL,
    [BOARD] FLOAT NULL,
    [SIGN] FLOAT NULL,
    [DP] FLOAT NULL,
    [INTRO] FLOAT NULL,
    [BANK] FLOAT NULL,
    [PAN] FLOAT NULL,
    [COCODE] VARCHAR(6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.formstatus
-- --------------------------------------------------
CREATE TABLE [dbo].[formstatus]
(
    [SR] VARCHAR(10) NULL,
    [CODE] VARCHAR(20) NULL,
    [ACOPDATE] VARCHAR(20) NULL,
    [NAME] VARCHAR(100) NULL,
    [BR] VARCHAR(20) NULL,
    [SB] VARCHAR(20) NULL,
    [TRADER] VARCHAR(20) NULL,
    [FORMVER] VARCHAR(20) NULL,
    [COMPDATE] VARCHAR(20) NULL,
    [BRANCH_CD] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(20) NULL,
    [FAX] VARCHAR(20) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_NATION] VARCHAR(30) NULL,
    [L_STATE] VARCHAR(30) NULL,
    [L_ZIP] VARCHAR(30) NULL,
    [L_CITY] VARCHAR(30) NULL,
    [MOBILE_PAG] VARCHAR(20) NULL,
    [OFF_PHONE1] VARCHAR(20) NULL,
    [RES_PHONE1] VARCHAR(20) NULL,
    [ACINDATE] VARCHAR(20) NULL,
    [PCODE] VARCHAR(20) NULL,
    [MINDATE] VARCHAR(20) NULL,
    [MAXDATE] VARCHAR(20) NULL,
    [COCODE] VARCHAR(20) NULL,
    [REMARKS] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.formstatus1
-- --------------------------------------------------
CREATE TABLE [dbo].[formstatus1]
(
    [SR] VARCHAR(10) NULL,
    [CODE] VARCHAR(20) NULL,
    [ACOPDATE] VARCHAR(20) NULL,
    [NAME] VARCHAR(100) NULL,
    [BR] VARCHAR(20) NULL,
    [SB] VARCHAR(20) NULL,
    [TRADER] VARCHAR(20) NULL,
    [FORMVER] VARCHAR(20) NULL,
    [COMPDATE] VARCHAR(20) NULL,
    [BRANCH_CD] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(20) NULL,
    [FAX] VARCHAR(20) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_NATION] VARCHAR(30) NULL,
    [L_STATE] VARCHAR(30) NULL,
    [L_ZIP] VARCHAR(30) NULL,
    [L_CITY] VARCHAR(30) NULL,
    [MOBILE_PAG] VARCHAR(20) NULL,
    [OFF_PHONE1] VARCHAR(20) NULL,
    [RES_PHONE1] VARCHAR(20) NULL,
    [ACINDATE] VARCHAR(20) NULL,
    [PCODE] VARCHAR(20) NULL,
    [MINDATE] VARCHAR(20) NULL,
    [MAXDATE] VARCHAR(20) NULL,
    [COCODE] VARCHAR(20) NULL,
    [REMARKS] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.frm_status_abl
-- --------------------------------------------------
CREATE TABLE [dbo].[frm_status_abl]
(
    [PCODE] VARCHAR(8) NULL,
    [ID] FLOAT NULL,
    [BREF] FLOAT NULL,
    [DEED] FLOAT NULL,
    [BOARD] FLOAT NULL,
    [SIGN] FLOAT NULL,
    [DP] FLOAT NULL,
    [INTRO] FLOAT NULL,
    [BANK] FLOAT NULL,
    [PAN] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.genesis
-- --------------------------------------------------
CREATE TABLE [dbo].[genesis]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GENESIS_1
-- --------------------------------------------------
CREATE TABLE [dbo].[GENESIS_1]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.genesis_a
-- --------------------------------------------------
CREATE TABLE [dbo].[genesis_a]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.genesis_b
-- --------------------------------------------------
CREATE TABLE [dbo].[genesis_b]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.genesis_b_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[genesis_b_fin]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.genesis_b1
-- --------------------------------------------------
CREATE TABLE [dbo].[genesis_b1]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.KYC_DISPATCH
-- --------------------------------------------------
CREATE TABLE [dbo].[KYC_DISPATCH]
(
    [receive_date] DATETIME NULL,
    [entry_type] VARCHAR(20) NULL,
    [challan_no] NUMERIC(10, 0) NULL,
    [BSEQTY_1] NUMERIC(5, 0) NULL,
    [NSEQTY_1] NUMERIC(5, 0) NULL,
    [NSEFOQTY_1] NUMERIC(5, 0) NULL,
    [MCXQTY_1] NUMERIC(5, 0) NULL,
    [NCDXQTY_1] NUMERIC(5, 0) NULL,
    [DIPINDQTY_1] NUMERIC(5, 0) NULL,
    [DPCOPRATEQTY_1] NUMERIC(5, 0) NULL,
    [DPCOMMOQTY_1] NUMERIC(5, 0) NULL,
    [DISPATCH_DATE] DATETIME NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [DELIVERY_MODE] VARCHAR(20) NULL,
    [BSEQTY_2] NUMERIC(5, 0) NULL,
    [NSEQTY_2] NUMERIC(5, 0) NULL,
    [NSEFOQTY_2] NUMERIC(5, 0) NULL,
    [MCXQTY_2] NUMERIC(5, 0) NULL,
    [NCDXQTY_2] NUMERIC(5, 0) NULL,
    [DIPINDQTY_2] NUMERIC(5, 0) NULL,
    [DPCOPRATEQTY_2] NUMERIC(5, 0) NULL,
    [DPCOMMOQTY_2] NUMERIC(5, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kycregister_renamed_For_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[kycregister_renamed_For_PII]
(
    [party_code] VARCHAR(20) NULL,
    [short_name] VARCHAR(200) NULL,
    [pan_gir_no] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [abl] VARCHAR(10) NULL,
    [acdl] VARCHAR(10) NULL,
    [fno] VARCHAR(10) NULL,
    [entry_date] DATETIME NULL,
    [remarks] VARCHAR(200) NULL,
    [option_remarks] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LuckyPartyCode
-- --------------------------------------------------
CREATE TABLE [dbo].[LuckyPartyCode]
(
    [Party_Code] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Pin_State_City
-- --------------------------------------------------
CREATE TABLE [dbo].[Pin_State_City]
(
    [ctclBranch_pincode] VARCHAR(255) NULL,
    [ctclBranch_state] VARCHAR(255) NULL,
    [ctclBranch_city] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Pin_State_City1
-- --------------------------------------------------
CREATE TABLE [dbo].[Pin_State_City1]
(
    [ctclBranch_pincode] VARCHAR(255) NULL,
    [ctclBranch_state] VARCHAR(255) NULL,
    [ctclBranch_city] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MfssClientFrmAngelFO_renamed_For_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MfssClientFrmAngelFO_renamed_For_PII]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sms_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sms_log]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [Process_Name] VARCHAR(50) NULL,
    [Records] INT NULL,
    [Process_Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_track
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_track]
(
    [cl_code] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [Long_name] VARCHAR(100) NULL,
    [Branch_cd] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(30) NULL,
    [Trader] VARCHAR(50) NULL,
    [imp_status] VARCHAR(20) NULL,
    [NSE] CHAR(10) NULL,
    [BSE] CHAR(10) NULL,
    [Fo] CHAR(10) NULL,
    [NCDX] CHAR(10) NULL,
    [MCX] CHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.utd_subbrokeremail
-- --------------------------------------------------
CREATE TABLE [dbo].[utd_subbrokeremail]
(
    [branch] NVARCHAR(255) NULL,
    [subbroker] NVARCHAR(255) NULL,
    [emailid] NVARCHAR(255) NULL
);

GO

