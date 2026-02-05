-- DDL Export
-- Server: 10.253.78.163
-- Database: Legal
-- Exported: 2026-02-05T12:30:01.072731

USE Legal;
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
-- PROCEDURE dbo.usp_legal_feesdeposted
-- --------------------------------------------------
CREATE proc  usp_legal_feesdeposted  
(  
@Fld_PartyCode as varchar(25),  
@Fld_Segment as varchar(25),  
@Fld_CaseType as varchar(25),  
@Fld_chq1 as varchar(25),  
@Fld_amt1 as  numeric,  
@Fld_chq2 as varchar(25),  
@Fld_amt2 as  numeric,  
@Fld_chq3 as varchar(25),  
@Fld_amt3 as  numeric,  
@Fld_chq4 as varchar(25),  
@Fld_amt4 as  numeric,  
@Fld_chq5 as varchar(25),  
@Fld_amt5 as  numeric,
@Fld_total as numeric  
)  
as  
insert into tbl_legal_feesdeposited values  
(  
@Fld_PartyCode ,  
@Fld_Segment ,  
@Fld_CaseType ,  
@Fld_chq1 ,  
@Fld_amt1 ,  
@Fld_chq2 ,  
@Fld_amt2 ,  
@Fld_chq3 ,  
@Fld_amt3 ,  
@Fld_chq4 ,  
@Fld_amt4 ,  
@Fld_chq5 ,  
@Fld_amt5 ,
@Fld_total
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_LegalArbitration_Entry
-- --------------------------------------------------
CREATE proc usp_LegalArbitration_Entry                    
(                    
@Fld_partycode as varchar(15),                    
@Fld_partyname as varchar(100),                    
@Fld_Branch as varchar(15),                    
@Fld_subbroker as varchar(15),                    
@Fld_LDN_dt as varchar(11),                    
@Fld_Req_dt as varchar(11),                    
@Fld_casefiling_dt as varchar(11),                    
@Fld_segment as varchar(15),                    
@Fld_claimamount as numeric,                    
@Fld_decreeamount as numeric,                    
@Fld_satt_amount as numeric,                    
@Fld_Amount_recovered as numeric,                    
@Fld_counter_claim as varchar(10),                    
@Fld_counter_amountas numeric,                    
@Fld_Nxt_hdt as varchar(11),  
@Fld_Htime as varchar(30),                    
@Fld_FileNo as varchar(30),                    
@Fld_Status as varchar(100),                    
@Fld_Remark as varchar(250),                    
@Fld_Fees_Deposited as numeric,                    
@Fld_EnteredBy as varchar(25),              
@Fld_case_By as varchar(25) ,          
@Fld_awardfor as varchar(25),      
@Fld_forum as varchar(50),  
@Fld_case_no as varchar(50),  
@Fld_Incharge_Person as varchar(50)            
)                    
as                    
                    
set @Fld_LDN_dt = convert(datetime,@Fld_LDN_dt,103)                                            
set @Fld_Req_dt = convert(datetime,@Fld_Req_dt,103)                                            
set @Fld_casefiling_dt = convert(datetime,@Fld_casefiling_dt,103)                                            
set @Fld_Nxt_hdt = convert(datetime,@Fld_Nxt_hdt,103)                     
                    
if(select count(Fld_partycode) from tbl_legalarbitration where fld_partycode = @Fld_partycode and Fld_segment = @Fld_segment ) = 0                     
begin                      
insert into tbl_legalarbitration                     
values                     
(                    
upper(@Fld_partycode),@Fld_partyname ,@Fld_Branch ,@Fld_subbroker ,                    
@Fld_LDN_dt ,@Fld_Req_dt ,@Fld_casefiling_dt ,@Fld_segment ,                    
@Fld_claimamount,@Fld_decreeamount ,@Fld_satt_amount ,                    
@Fld_Amount_recovered ,@Fld_counter_claim ,@Fld_counter_amountas ,                    
@Fld_Nxt_hdt ,@Fld_Htime,@Fld_FileNo,@Fld_Status,@Fld_Remark ,@Fld_Fees_Deposited,getdate(),                    
@Fld_EnteredBy ,@Fld_case_By,'A',@Fld_awardfor,@Fld_forum,@Fld_case_no,@Fld_Incharge_Person                    
)                    
insert into tbl_legalstatus_log                     
values                     
(                    
@Fld_partycode,@Fld_segment,@Fld_Status,@Fld_Remark,getdate(),@Fld_EnteredBy,'Arbitration'                    
)                    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_LegalArbitration_Update
-- --------------------------------------------------
CREATE proc usp_LegalArbitration_Update                 
(          
@Fld_partycode as varchar(15),                
@Fld_partyname as varchar(50),                
@Fld_Branch as varchar(15),                
@Fld_subbroker as varchar(15),                
@Fld_LDN_dt as varchar(11),                
@Fld_Req_dt as varchar(11),                
@Fld_casefiling_dt as varchar(11),                
@Fld_segment as varchar(15),                
@Fld_claimamount as numeric,                
@Fld_decreeamount as numeric,                
@Fld_satt_amount as numeric,                
@Fld_Amount_recovered as numeric,                
@Fld_counter_claim as varchar(10),                
@Fld_counter_amount as numeric,                
@Fld_Nxt_hdt as varchar(11),                
@Fld_FileNo as varchar(30),                
@Fld_Status as varchar(100),                
@Fld_Remark as varchar(250),                
@Fld_Fees_Deposited as numeric,                
@Fld_EnteredBy as varchar(25),          
@Fld_srno as varchar(25),        
@Fld_case_By as varchar(25),        
@Fld_Case_status as varchar(25),      
@Fld_forum as varchar(50),    
@Fld_Htime as varchar(30),  
@case_no as varchar(30),  
@incharge_person as varchar(50)    
)          
as           
          
set @Fld_LDN_dt = convert(datetime,@Fld_LDN_dt,103)                                        
set @Fld_Req_dt = convert(datetime,@Fld_Req_dt,103)                                        
set @Fld_casefiling_dt = convert(datetime,@Fld_casefiling_dt,103)                                        
set @Fld_Nxt_hdt = convert(datetime,@Fld_Nxt_hdt,103)           
          
update tbl_legalarbitration set           
Fld_partycode = @Fld_partycode,          
Fld_partyname = @Fld_partyname ,                
Fld_Branch = @Fld_Branch ,                
Fld_subbroker = @Fld_subbroker,                
Fld_LDN_dt = @Fld_LDN_dt ,                
Fld_Req_dt = @Fld_Req_dt ,                
Fld_casefiling_dt = @Fld_casefiling_dt ,                
Fld_segment = @Fld_segment,                
Fld_claimamount = @Fld_claimamount,                
Fld_decreeamount = @Fld_decreeamount,                
Fld_satt_amount = @Fld_satt_amount,                
Fld_Amount_recovered = @Fld_Amount_recovered,                
Fld_counter_claim = @Fld_counter_claim,                
Fld_counter_amount = @Fld_counter_amount,                
Fld_Nxt_hdt = @Fld_Nxt_hdt,                
Fld_FileNo = @Fld_FileNo,                
Fld_Status = @Fld_Status,                
Fld_Remark = @Fld_Remark,                
Fld_Fees_Deposited = @Fld_Fees_Deposited,                
Fld_EnteredBy = @Fld_EnteredBy,        
Fld_case_By = @Fld_case_By,        
Fld_Case_status = @Fld_Case_status,      
Fld_forum  = @Fld_forum,      
Fld_Htime=@Fld_Htime,    
Fld_case_No=@case_no,  
Fld_Incharge_Person=@incharge_person  
where Fld_partycode = @Fld_partycode and Fld_srno = @Fld_srno          
          
insert into tbl_legalstatus_log                 
values                 
(                
@Fld_partycode,@Fld_segment,@Fld_Status,@Fld_Remark,getdate(),@Fld_EnteredBy,'Arbitration'                
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_legalstatus_entry
-- --------------------------------------------------
create proc usp_legalstatus_entry
(
@Fld_StatusName as varchar(50),
@Fld_CaseType as varchar(50),
@Fld_CreatedBy as varchar(50)
)
as 
insert into tbl_legalstatus_master values (@Fld_StatusName,@Fld_CaseType,getdate(),@Fld_CreatedBy)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MIS_Legal
-- --------------------------------------------------
        
create PROCEDURE usp_MIS_Legal
(              
@access_to as varchar(25),@access_code as varchar(25)               
)              
 as            
set nocount on               
set transaction isolation level read uncommitted                        
              
        
        
if @access_to='branch'         
begin        

select x.*,y.person_name from
(select Fld_partycode as[Party Code],Fld_partyname as [Party Name],
Fld_Branch as [Branch],
Fld_subbroker as [Subbroker],
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],
convert(varchar(11),Fld_Req_dt,103) as [Request date],
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],
Fld_decreeamount as [Decree Amount],Fld_satt_amount as [Settlement],
Fld_Amount_recovered as [Amount Recovered],
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],
Fld_Fees_Deposited as [Fees Deposited],
convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By],
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]  
from Tbl_LegalArbitration  )x
left outer join
(select person_name,username from intranet.risk.dbo.user_login )y
on x.[Entred By]=y.username where x.branch=@access_to order by x.[File_No]            
        
end        
 if @access_to='region'         
begin         
select x.*,y.person_name from
(select Fld_partycode as[Party Code],Fld_partyname as [Party Name],
Fld_Branch as [Branch],
Fld_subbroker as [Subbroker],
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],
convert(varchar(11),Fld_Req_dt,103) as [Request date],
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],
Fld_decreeamount as [Decree Amount],Fld_satt_amount as [Settlement],
Fld_Amount_recovered as [Amount Recovered],
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],
Fld_Fees_Deposited as [Fees Deposited],
convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By],
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]  
from Tbl_LegalArbitration  )x
left outer join
(select person_name,username from intranet.risk.dbo.user_login )y
on x.[Entred By]=y.username 
where x.branch in (select code from intranet.risk.dbo.region where reg_code=@access_to) or x.branch=@access_to  order by x.[File_No]               
end        
if @access_to='broker'         
begin        
 
select x.*,y.person_name from
(select Fld_partycode as[Party Code],Fld_partyname as [Party Name],
Fld_Branch as [Branch],
Fld_subbroker as [Subbroker],
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],
convert(varchar(11),Fld_Req_dt,103) as [Request date],
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],
Fld_decreeamount as [Decree Amount],Fld_satt_amount as [Settlement],
Fld_Amount_recovered as [Amount Recovered],
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],
Fld_Fees_Deposited as [Fees Deposited],
convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By],
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]  
from Tbl_LegalArbitration  )x
left outer join
(select person_name,username from intranet.risk.dbo.user_login )y
on x.[Entred By]=y.username order by x.[File_No]       
       
end 
if @access_to='BRMAST'        
begin        

select x.*,y.person_name from
(select Fld_partycode as[Party Code],Fld_partyname as [Party Name],
Fld_Branch as [Branch],
Fld_subbroker as [Subbroker],
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],
convert(varchar(11),Fld_Req_dt,103) as [Request date],
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],
Fld_decreeamount as [Decree Amount],Fld_satt_amount as [Settlement],
Fld_Amount_recovered as [Amount Recovered],
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],
Fld_Fees_Deposited as [Fees Deposited],
convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By],
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]  
from Tbl_LegalArbitration  )x
left outer join
(select person_name,username from intranet.risk.dbo.user_login )y
on x.[Entred By]=y.username 
where x.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@access_to)or x.branch=@access_to order by x.[File_No]    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_legal_all
-- --------------------------------------------------
CREATE Proc [dbo].[usp_mis_legal_all]                               
(                                    
@segment as varchar(25),                                    
@partycode as varchar(25),                                  
@access_to as varchar(25),                                  
@access_code as varchar(25),                      
@file_no as varchar(25),                  
@next_hdt as varchar(25),                       
@filter_type as varchar(10)                                  
)                                    
as                                     
declare @str as varchar(2000)                      
declare @filter as varchar(200)                      
declare @access_query as varchar(200)                      
declare @final as varchar(5000)                      
declare @post as varchar(500)                      
                     
                  
--declare @segment as varchar(25)                                    
--declare @partycode as varchar(25)                    
--declare @access_to as varchar(30)                      
--declare @access_Code as varchar(25)                            
--declare @file_no as varchar(25)                    
--declare @next_hdt as varchar(20)                            
--declare @filter_type as varchar(10)                                  
--set @segment='%'                    
--set @partycode=''                  
--set @access_Code='CSO'                      
--set @access_to='BROKER'                                 
--set @filter_type='3'                   
--set @file_no=''                  
--set @next_hdt='2009-04-27'                      
if @access_to='BRANCH'                        
                  
begin                                  
set @access_query=''                        
set @access_query=@access_query+' and Fld_branch = '''+@access_code+''''                      
end                      
--print @access_query                      
else if @access_to='REGION'                                    
begin                      
set @access_query=''                        
set @access_query=@access_query+' and Fld_Branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''')'                        
end                      

/* Added By Rohit Patil for SB 03 Jan 2017*/
else if @access_to='SB'
begin
set @access_query=''                          
set @access_query=@access_query+' and Fld_Subbroker = '''+@access_code+''''
end                      

/* **** End ***** */
                                 
else if @access_to='BRMAST'                                  
begin                      
set  @access_query=''                        
set  @access_query=@access_query+' and  Fld_Branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''')'                      
end                      
                      
if @filter_type='1'                      
begin                      
set @filter=''                      
set @filter=@filter+' where fld_segment like '''+@segment+''' and Fld_partycode like '''+@partycode+''''                      
end                      
else if @filter_type='2'                      
begin                      
set @filter=''                      
set @filter=@filter+' where Fld_fileNo='''+@file_no+''''                      
end                    
else if @filter_type='3'                  
begin                   
set @filter=''                  
set @filter=@filter+' where Fld_Nxt_hdt='''+@next_hdt+''''                  
end                  
                    
--print @access_query                      
--print @filter                      
                      
--declare @str as varchar(2000)                      
if  @access_to<>'BROKER'                       
begin                      
set @str=''                      
set @str=@str+' select Fld_FileNo as [File_No],case when Fld_case_By=''ANG'' then ''ANGEL'' else ''CLIENT'' end as [Case By], '                                      
set @str=@str+' case when Fld_Case_status = ''A'' then ''Active'' else ''Deactive'' end as [ACTIVE/DEACTIVE],'                                        
set @str=@str+' Fld_partycode as[Party Code],Fld_partyname as [Party Name],Fld_Branch as [Branch],'                     
set @str=@str+' Fld_subbroker as [Subbroker],'                         
set @str=@str+' case when Fld_LDN_dt =''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_LDN_dt,103) end as [LDN Date],'                      
set @str=@str+' case when Fld_Req_dt=''1900-01-01'' then  ''Not Available'' else convert(varchar(11),Fld_Req_dt,103) end as [Request date],'                      
set @str=@str+' case when Fld_casefiling_dt=''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_casefiling_dt,103) end as [Filing Date],'       
set @str=@str+' Fld_segment as [Segment],Fld_claimamount as[Claim Amount], Fld_counter_amount as [Counter Claim Amount],'                      
set @str=@str+' Fld_Fees_Deposited as [Fees Deposited],Fld_Case_No as [Case No.],Fld_Status as [Status], '                      
set @str=@str+' convert(varchar(100),Fld_decreeamount) + ''  AwardFor  '' + Fld_awardfor  as [Decree Amount],'                      
set @str=@str+' Fld_satt_amount as [Settlement], Fld_Amount_recovered as [Amount Recovered],'                      
--set @str=@str+'case when Fld_Nxt_hdt=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),Fld_Nxt_hdt,103) end as [Next Hearing Date],'                      
set @str=@str+' Fld_Remark as [Remark], Fld_Incharge_Person as [Incharge Person] '                      
set @str=@str+' from Tbl_LegalArbitration'                      
--print @str                      
set @final=''                      
set @final=@str+@filter+@access_query                      
--print @final                      
--exec @final                    
end       
else if @access_to='BROKER'                                             
begin                                            
--declare @str as varchar(2000)    
set @str=''                      
set @str=@str+' select x.*,y.[Person Name] from'                      
set @str=@str+'( select Fld_FileNo as [File_No],case when Fld_case_By=''ANG'' then ''ANGEL'' else ''CLIENT'' end as [Case By],'                      
set @str=@str+' case when Fld_Case_status = ''A'' then ''Active'' else ''Deactive'' end as [ACTIVE/DEACTIVE],'                      
set @str=@str+' Fld_partycode as[Party Code],Fld_partyname as [Party Name],Fld_Branch as [Branch],'                      
set @str=@str+' Fld_subbroker as [Subbroker],'                      
set @str=@str+' case when Fld_LDN_dt =''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_LDN_dt,103) end as [LDN Date],'                      
set @str=@str+' case when Fld_Req_dt=''1900-01-01'' then  ''Not Available'' else convert(varchar(11),Fld_Req_dt,103) end as [Request date],'                      
set @str=@str+' case when Fld_casefiling_dt=''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_casefiling_dt,103) end as [Filing Date], '                      
set @str=@str+' Fld_segment as [Segment],Fld_forum as [Court/Forum],Fld_claimamount as[Claim Amount], Fld_counter_amount as [Counter Claim Amount],'                                  
set @str=@str+' Fld_Fees_Deposited as [Fees Deposited],Fld_Case_No as [Case No.],Fld_Status as [Status],'                      
set @str=@str+' case when Fld_Nxt_hdt=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),Fld_Nxt_hdt,103) end as [Next Hearing Date],'                      
set @str=@str+' Fld_Htime [Hearing Time],'    
set @str=@str+' convert(varchar(100),Fld_decreeamount) + ''  AwardFor  '' + Fld_awardfor  as [Decree Amount],'    
set @str=@str+' Fld_satt_amount as [Settlement], Fld_Amount_recovered as [Amount Recovered],'                      
set @str=@str+' Fld_Remark as [Remark], Fld_Incharge_Person as [Incharge Person], '                      
  set @str=@str+' convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By]'                      
set @str=@str+' from Tbl_LegalArbitration '     
--print @str       
        
set @post=')x  left outer join'                      
set @post=@post+'(select person_name,username,username + ''-'' + person_name as [Person Name]  from intranet.risk.dbo.user_login)y'                      
set @post=@post+' on  x.[Entred By]=y.username'                      
set @final=''                      
set @final=@str+@filter+@post            
    
end                    
                    
--print @final                      
exec (@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_NI138_all
-- --------------------------------------------------
create Proc [dbo].[usp_mis_NI138_all]                               
(                                    
@segment as varchar(25),                                    
@partycode as varchar(25),                                  
@access_to as varchar(25),                                  
@access_code as varchar(25),                      
@file_no as varchar(25),                  
@next_hdt as varchar(25),                       
@filter_type as varchar(10)                                  
)                                    
as                                     
declare @str as varchar(2000)                      
declare @filter as varchar(200)                      
declare @access_query as varchar(200)                      
declare @final as varchar(5000)                      
declare @post as varchar(500)                      
                     
                  
--declare @segment as varchar(25)                                    
--declare @partycode as varchar(25)                    
--declare @access_to as varchar(30)                      
--declare @access_Code as varchar(25)                            
--declare @file_no as varchar(25)                    
--declare @next_hdt as varchar(20)                            
--declare @filter_type as varchar(10)                                  
--set @segment='%'                    
--set @partycode=''                  
--set @access_Code='CSO'                      
--set @access_to='BROKER'                                 
--set @filter_type='3'                   
--set @file_no=''                  
--set @next_hdt='2009-04-27'                      
if @access_to='BRANCH'                        
                  
begin                                  
set @access_query=''                        
set @access_query=@access_query+' and Fld_branch = '''+@access_code+''''                      
end                      
--print @access_query                      
else if @access_to='REGION'                                    
begin                      
set @access_query=''                        
set @access_query=@access_query+' and Fld_Branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''')'                        
end                      

/* Added By Rohit Patil for SB 03 Jan 2017*/
else if @access_to='SB'
begin
set @access_query=''                          
set @access_query=@access_query+' and Fld_Subbroker = '''+@access_code+''''
end                      

/* **** End ***** */
                                 
else if @access_to='BRMAST'                                  
begin                      
set  @access_query=''                        
set  @access_query=@access_query+' and  Fld_Branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''')'                      
end                      
                      
if @filter_type='1'                      
begin                      
set @filter=''                      
set @filter=@filter+' where fld_segment like '''+@segment+''' and Fld_partycode like '''+@partycode+''''                      
end                      
else if @filter_type='2'                      
begin                      
set @filter=''                      
set @filter=@filter+' where Fld_fileNo='''+@file_no+''''                      
end                    
else if @filter_type='3'                  
begin                   
set @filter=''                  
set @filter=@filter+' where Fld_Nxt_hdt='''+@next_hdt+''''                  
end                  
                    
--print @access_query                      
--print @filter                      
                      
--declare @str as varchar(2000)                      
if  @access_to<>'BROKER'                       
begin                      
set @str=''                      
set @str=@str+' select Fld_FileNo as [File_No],case when Fld_case_By=''ANG'' then ''ANGEL'' else ''CLIENT'' end as [Case By], '                                      
set @str=@str+' case when Fld_Case_status = ''A'' then ''Active'' else ''Deactive'' end as [ACTIVE/DEACTIVE],'                                        
set @str=@str+' Fld_partycode as[Party Code],Fld_partyname as [Party Name],Fld_Branch as [Branch],'                     
set @str=@str+' Fld_subbroker as [Subbroker],'                         
set @str=@str+' case when Fld_LDN_dt =''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_LDN_dt,103) end as [LDN Date],'                      
set @str=@str+' case when Fld_Req_dt=''1900-01-01'' then  ''Not Available'' else convert(varchar(11),Fld_Req_dt,103) end as [Request date],'                      
set @str=@str+' case when Fld_casefiling_dt=''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_casefiling_dt,103) end as [Filing Date],'       
set @str=@str+' Fld_segment as [Segment],Fld_claimamount as[Claim Amount], Fld_counter_amount as [Counter Claim Amount],'                      
set @str=@str+' Fld_Fees_Deposited as [Fees Deposited],Fld_Case_No as [Case No.],Fld_Status as [Status], '                      
set @str=@str+' convert(varchar(100),Fld_decreeamount) + ''  AwardFor  '' + Fld_awardfor  as [Decree Amount],'                      
set @str=@str+' Fld_satt_amount as [Settlement], Fld_Amount_recovered as [Amount Recovered],'                      
--set @str=@str+'case when Fld_Nxt_hdt=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),Fld_Nxt_hdt,103) end as [Next Hearing Date],'                      
set @str=@str+' Fld_Remark as [Remark], Fld_Incharge_Person as [Incharge Person] '                      
set @str=@str+' from tbl_NI138_Master'                      
--print @str                      
set @final=''                      
set @final=@str+@filter+@access_query                      
--print @final                      
--exec @final                    
end       
else if @access_to='BROKER'                                             
begin                                            
--declare @str as varchar(2000)    
set @str=''                      
set @str=@str+' select x.*,y.[Person Name] from'                      
set @str=@str+'( select Fld_FileNo as [File_No],case when Fld_case_By=''ANG'' then ''ANGEL'' else ''CLIENT'' end as [Case By],'                      
set @str=@str+' case when Fld_Case_status = ''A'' then ''Active'' else ''Deactive'' end as [ACTIVE/DEACTIVE],'                      
set @str=@str+' Fld_partycode as[Party Code],Fld_partyname as [Party Name],Fld_Branch as [Branch],'                      
set @str=@str+' Fld_subbroker as [Subbroker],'                      
set @str=@str+' case when Fld_LDN_dt =''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_LDN_dt,103) end as [LDN Date],'                      
set @str=@str+' case when Fld_Req_dt=''1900-01-01'' then  ''Not Available'' else convert(varchar(11),Fld_Req_dt,103) end as [Request date],'                      
set @str=@str+' case when Fld_casefiling_dt=''1900-01-01'' then ''Not Available'' else convert(varchar(11),Fld_casefiling_dt,103) end as [Filing Date], '                      
set @str=@str+' Fld_segment as [Segment],Fld_forum as [Court/Forum],Fld_claimamount as[Claim Amount], Fld_counter_amount as [Counter Claim Amount],'                                  
set @str=@str+' Fld_Fees_Deposited as [Fees Deposited],Fld_Case_No as [Case No.],Fld_Status as [Status],'                      
set @str=@str+' case when Fld_Nxt_hdt=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),Fld_Nxt_hdt,103) end as [Next Hearing Date],'                      
set @str=@str+' Fld_Htime [Hearing Time],'    
set @str=@str+' convert(varchar(100),Fld_decreeamount) + ''  AwardFor  '' + Fld_awardfor  as [Decree Amount],'    
set @str=@str+' Fld_satt_amount as [Settlement], Fld_Amount_recovered as [Amount Recovered],'                      
set @str=@str+' Fld_Remark as [Remark], Fld_Incharge_Person as [Incharge Person], '                      
  set @str=@str+' convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By]'                      
set @str=@str+' from tbl_NI138_Master '     
--print @str       
        
set @post=')x  left outer join'                      
set @post=@post+'(select person_name,username,username + ''-'' + person_name as [Person Name]  from intranet.risk.dbo.user_login)y'                      
set @post=@post+' on  x.[Entred By]=y.username'                      
set @final=''                      
set @final=@str+@filter+@post            
    
end                    
                    
--print @final                      
exec (@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_partycode_wise
-- --------------------------------------------------
CREATE Proc usp_mis_partycode_wise            
(            
@segment as varchar(25),            
@partycode as varchar(25),          
@access_to as varchar(25),          
@access_code as varchar(25)            
)            
as             
          
if @access_to='BRANCH'          
begin          
         
select Fld_partycode as[Party Code],Fld_partyname as [Party Name],              
Fld_Branch as [Branch],              
Fld_subbroker as [Subbroker],              
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],              
convert(varchar(11),Fld_Req_dt,103) as [Request date],              
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],              
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],              
convert(varchar(100),Fld_decreeamount) + '  AwardFor  ' + Fld_awardfor  as [Decree Amount],Fld_satt_amount as [Settlement],              
Fld_Amount_recovered as [Amount Recovered],              
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],              
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],              
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],              
Fld_Fees_Deposited as [Fees Deposited],                   
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],              
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]                
from Tbl_LegalArbitration where fld_segment like @segment and Fld_partycode = @partycode and Fld_branch = @access_code            
end          
          
if @access_to='REGION'            
begin          
select Fld_partycode as[Party Code],Fld_partyname as [Party Name],            
Fld_Branch as [Branch],            
Fld_subbroker as [Subbroker],            
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],            
convert(varchar(11),Fld_Req_dt,103) as [Request date],            
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],            
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],            
convert(varchar(100),Fld_decreeamount) + '  AwardFor  ' + Fld_awardfor  as [Decree Amount],Fld_satt_amount as [Settlement],            
Fld_Amount_recovered as [Amount Recovered],            
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],            
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],            
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],            
Fld_Fees_Deposited as [Fees Deposited],                
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],            
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]              
from Tbl_LegalArbitration            
where fld_segment like @segment and Fld_partycode = @partycode and  Fld_Branch in           
(select code from intranet.risk.dbo.region where reg_code = @access_code)          
end          
          
if @access_to='BRMAST'          
begin          
select Fld_partycode as[Party Code],Fld_partyname as [Party Name],            
Fld_Branch as [Branch],            
Fld_subbroker as [Subbroker],            
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],            
convert(varchar(11),Fld_Req_dt,103) as [Request date],            
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],            
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],            
convert(varchar(100),Fld_decreeamount) + '  AwardFor  ' + Fld_awardfor  as [Decree Amount],Fld_satt_amount as [Settlement],            
Fld_Amount_recovered as [Amount Recovered],            
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],            
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],            
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],            
Fld_Fees_Deposited as [Fees Deposited],                
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],            
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE] from Tbl_LegalArbitration             
where  fld_segment like @segment and Fld_partycode = @partycode and  Fld_Branch in           
(select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)             
end          
          
if @access_to='BROKER'                     
begin                    
select x.*,y.[Person Name] from               
(select Fld_partycode as[Party Code],Fld_partyname as [Party Name],            
Fld_Branch as [Branch],            
Fld_subbroker as [Subbroker],            
convert(varchar(11),Fld_LDN_dt,103)as [LDN Date],            
convert(varchar(11),Fld_Req_dt,103) as [Request date],            
convert(varchar(11),Fld_casefiling_dt,104) as [Filing Date],            
Fld_segment as [Segment],Fld_claimamount as[Claim Amount],            
convert(varchar(100),Fld_decreeamount) + '  AwardFor  ' + Fld_awardfor   as [Decree Amount],Fld_satt_amount as [Settlement],            
Fld_Amount_recovered as [Amount Recovered],            
Fld_counter_claim as [Counter Claim ],Fld_counter_amount as [Counter Claim Amount],            
convert(varchar(11),Fld_Nxt_hdt,103) as [Next Hearing Date],            
Fld_FileNo as [File_No],Fld_Status as [Status],Fld_Remark as [Remark],            
Fld_Fees_Deposited as [Fees Deposited],            
convert(varchar(11),Fld_EntryDate,103) as [Entry Date],Fld_EnteredBy as [Entred By],            
case when Fld_case_By='ANG' then 'ANGEL' else 'CLIENT' end as [Case By],            
case when Fld_Case_status = 'A' then 'Active' else 'Deactive' end as [ACTIVE/DEACTIVE]              
from Tbl_LegalArbitration where  fld_segment like @segment and Fld_partycode = @partycode)x         
left outer join        
(select person_name,username,username + '-' + person_name as [Person Name]  from intranet.risk.dbo.user_login)y        
 on  x.[Entred By]=y.username          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_Section_138
-- --------------------------------------------------
CREATE Proc [dbo].[usp_mis_Section_138]                                    
(                                          
@company as varchar(25),                                          
@partycode as varchar(25),                                        
@access_to as varchar(25),                                        
@access_code as varchar(25),                            
@case_no as varchar(25),                        
@next_hdt as varchar(25),                             
@filter_type as varchar(10)                                        
)                                          
as                                           
declare @str as varchar(2000)                            
declare @filter as varchar(200)                            
declare @access_query as varchar(200)                            
declare @final as varchar(5000)                            
declare @post as varchar(500)                            
--EXEC usp_mis_Section_138 'ABL','S2106','BRANCH','YZ','','','1'                          
--EXEC usp_mis_Section_138 'ABL','S2106','BRANCH','YZ','','','1'           
--EXEC usp_mis_Section_138 'ALL','S2106','BRANCH','YZ','','','1'         
--EXEC usp_mis_Section_138 '%','%','BROKER','YZ','','','1'          
--EXEC usp_mis_Section_138 '','','BROKER','%','','08/09/2009','3'       
--declare @segment as varchar(25)                                          
--declare @partycode as varchar(25)                          
--declare @access_to as varchar(30)                            
--declare @access_Code as varchar(25)                                  
--declare @file_no as varchar(25)                          
--declare @next_hdt as varchar(20)                                  
--declare @filter_type as varchar(10)                                        
--set @segment='%'                          
--set @partycode=''                        
--set @access_Code='CSO'                         
--set @access_to='BROKER'                                       
--set @filter_type='3'                         
--set @file_no=''                        
--set @next_hdt='2009-04-27' 
set @next_hdt=convert(datetime,@next_hdt,103)                           
if @access_to='BRANCH'                              
                        
begin    
set @access_query=''    
set @access_query=@access_query+' and branch = '''+@access_code+''''    
print @access_query    
end    
                         
else if @access_to='REGION'    
begin                            
set @access_query=''                              
set @access_query=@access_query+' and Branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''')'                              
end                            
                            
                                       
else if @access_to='BRMAST'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and  Branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''')'                            
end                            
                            
if @filter_type='1'                            
begin                            
set @filter=''            
 set @filter=@filter+' where company like '''+@company+''' and partycode like '''+@partycode+''''                            
end      
                           
else if @filter_type='2'                            
begin                            
set @filter=''                            
set @filter=@filter+' where company like '''+@company+''' and caseno  LIKE '''+@case_no+''''                            
end                          
else if @filter_type='3'                        
begin                         
set @filter=''                        
set @filter=@filter+' where nextdate ='''+@next_hdt+''''                        
end                        
                          
--print @access_query                            
print @filter                  
                            
--declare @str as varchar(2000)                            
if  @access_to<>'BROKER'    --select * from Tbl_Section138            
begin                            
set @str=''                            
set @str=@str+' select row_number() over(order by branch,partycode) [S.No.],Branch as [Branch Tag],SubBroker [SB Tag],'               
set @str=@str+' partycode as[Client Code],Company,name as [Party],'                           
set @str=@str+' CaseNo [Case No.],Court,Chequeno [Cheque No.],amount as [Amount],'                            
set @str=@str+' NextDate [Next Date],b.Fld_statusName Stage,AdvocateonRecord [Adv. on Record],'                            
set @str=@str+' courtfeesstumps[Court fee Stump],FilingDate [Filing Date],convert(varchar(100),settlementamount) [Sett. Amt.],'                            
--set @str=@str+'case when Fld_Nxt_hdt=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),Fld_Nxt_hdt,103) end as [Next Hearing Date],'                            
set @str=@str+' Remarks as [Remark],Convictted [Convictted/Acquitted],PersonIncharge as [Incharge Person] '                            
set @str=@str+' from Tbl_Section138 a left outer join Tbl_legalStatus_Master b on a.stage=b.fld_statuscode'                            
--print @str                            
set @final=''                            
set @final=@str+@filter+@access_query                            
print @final                            
--exec @final                          
end             
else if @access_to='BROKER'                                                   
begin                                                  
--declare @str as varchar(2000)          
set @str=''                            
set @str=@str+' select x.*,y.[Person Name] from'                            
--set @str=@str+'( select CaseNo ,'                            
--set @str=@str+' partycode as[Party Code],name as [Party Name],Branch as [Branch],'                            
--set @str=@str+' subbroker as [Subbroker],'                            
----set @str=@str+' case when NextDate =''1900-01-01'' then ''Not Available'' else convert(varchar(11),NextDate,103) end as [LDN Date],'                            
----set @str=@str+' case when Fld_Req_dt=''1900-01-01'' then  ''Not Available'' else convert(varchar(11),Fld_Req_dt,103) end as [Request date],'                            
--set @str=@str+' case when filingDate=''1900-01-01'' then ''Not Available'' else convert(varchar(11),filingDate,103) end as [Filing Date], '                            
--set @str=@str+' Company as Company,Court,amount as[Amount], '      
--set @str=@str+' CaseNo as [Case No.],Stage,'                            
--set @str=@str+' case when NextDate=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),NextDate,103) end as [Next Hearing Date],'                            
----set @str=@str+' Fld_Htime [Hearing Time],'          
----set @str=@str+' convert(varchar(100),Fld_decreeamount) + ''  AwardFor  '' + Fld_awardfor  as [Decree Amount],'          
----set @str=@str+' Fld_satt_amount as [Settlement], Fld_Amount_recovered as [Amount Recovered],'                            
--set @str=@str+' Remarks as [Remark], PersonIncharge as [Incharge Person], '                            
--  set @str=@str+' convert(varchar(11),EntryDate,103) as [Entry Date],EnteredBy as [Entred By]'                            
--set @str=@str+' from Tbl_Section138 '           
set @str=@str+'( select row_number() over(order by branch,partycode) [S.No.], Branch as [Branch Tag],SubBroker [SB Tag],'               
set @str=@str+' partycode as[Client Code],Company,name as [Party],'                           
set @str=@str+' CaseNo [Case No.],Court,Chequeno [Cheque No.],amount as [Amount],'                            
set @str=@str+' convert(varchar(11),NextDate,103) [Next Date],b.Fld_statusName Stage,AdvocateonRecord [Adv. on Record], '                            
set @str=@str+' courtfeesstumps[Court fee Stump],convert(varchar(11),FilingDate,103) [Filing Date],convert(varchar(100),settlementamount) [Sett. Amt.],'                            
--set @str=@str+'case when Fld_Nxt_hdt=''1900-01-01'' then ''Not Available'' else  convert(varchar(11),Fld_Nxt_hdt,103) end as [Next Hearing Date],'                            
set @str=@str+' Remarks as [Remark],Convictted [Con./Acq.],PersonIncharge as [Inc. Person], '                            
set @str=@str+' convert(varchar(11),EntryDate,103) as [Entry Date],EnteredBy as [Entred By]'     
set @str=@str+' from Tbl_Section138 a left outer join Tbl_legalStatus_Master b on a.stage=b.fld_statuscode'          
--print @str             
              
set @post=')x  left outer join'                            
set @post=@post+'(select person_name,username,username + ''-'' + person_name as [Person Name]  from intranet.risk.dbo.user_login)y'                            
set @post=@post+' on  x.[Entred By]=y.username'                            
set @final=''                            
set @final=@str+@filter+@post                  
          
end                          
                          
print @final                            
exec (@final)       
      
--select * from Tbl_Section138 where company like '%' and partycode='V1914'      
--EXEC usp_mis_Section_138 '%','V1914','BRANCH','YZ','','','1'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_NI138_Entry
-- --------------------------------------------------
CREATE proc [dbo].[usp_NI138_Entry]                    
(                    
@Fld_partycode as varchar(15),                    
@Fld_partyname as varchar(100),                    
@Fld_Branch as varchar(15),                    
@Fld_subbroker as varchar(15),                    
@Fld_LDN_dt as varchar(11),                    
@Fld_Req_dt as varchar(11),                    
@Fld_casefiling_dt as varchar(11),                    
@Fld_segment as varchar(15)='',                    
@Fld_claimamount as numeric,                    
@Fld_decreeamount as numeric,                    
@Fld_satt_amount as numeric,                    
@Fld_Amount_recovered as numeric,                    
@Fld_counter_claim as varchar(10),                    
@Fld_counter_amountas numeric,                    
@Fld_Nxt_hdt as varchar(11),  
@Fld_Htime as varchar(30),                    
@Fld_FileNo as varchar(30),                    
@Fld_Status as varchar(100),                    
@Fld_Remark as varchar(250),                    
@Fld_Fees_Deposited as numeric,                    
@Fld_EnteredBy as varchar(25),              
@Fld_case_By as varchar(25) ,          
@Fld_awardfor as varchar(25),      
@Fld_forum as varchar(50),  
@Fld_case_no as varchar(50),  
@Fld_Incharge_Person as varchar(50)            
)                    
as                    
                    
set @Fld_LDN_dt = convert(datetime,@Fld_LDN_dt,103)                                            
set @Fld_Req_dt = convert(datetime,@Fld_Req_dt,103)                                            
set @Fld_casefiling_dt = convert(datetime,@Fld_casefiling_dt,103)                                            
set @Fld_Nxt_hdt = convert(datetime,@Fld_Nxt_hdt,103)                     
                    
if(select count(Fld_partycode) from tbl_NI138_Master where fld_partycode = @Fld_partycode and Fld_segment = @Fld_segment ) = 0                     
begin                      
insert into tbl_NI138_Master                     
values                     
(                    
upper(@Fld_partycode),@Fld_partyname ,@Fld_Branch ,@Fld_subbroker ,                    
@Fld_LDN_dt ,@Fld_Req_dt ,@Fld_casefiling_dt ,@Fld_segment ,                    
@Fld_claimamount,@Fld_decreeamount ,@Fld_satt_amount ,                    
@Fld_Amount_recovered ,@Fld_counter_claim ,@Fld_counter_amountas ,                    
@Fld_Nxt_hdt ,@Fld_Htime,@Fld_FileNo,@Fld_Status,@Fld_Remark ,@Fld_Fees_Deposited,getdate(),                    
@Fld_EnteredBy ,@Fld_case_By,'A',@Fld_awardfor,@Fld_forum,@Fld_case_no,@Fld_Incharge_Person                    
)                    
insert into tbl_legalstatus_log                     
values                     
(                    
@Fld_partycode,@Fld_segment,@Fld_Status,@Fld_Remark,getdate(),@Fld_EnteredBy,'NI138'                    
)                    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_NI138_Update
-- --------------------------------------------------
create proc [dbo].[usp_NI138_Update]                 
(          
@Fld_partycode as varchar(15),                
@Fld_partyname as varchar(50),                
@Fld_Branch as varchar(15),                
@Fld_subbroker as varchar(15),                
@Fld_LDN_dt as varchar(11),                
@Fld_Req_dt as varchar(11),                
@Fld_casefiling_dt as varchar(11),                
@Fld_segment as varchar(15),                
@Fld_claimamount as numeric,                
@Fld_decreeamount as numeric,                
@Fld_satt_amount as numeric,                
@Fld_Amount_recovered as numeric,                
@Fld_counter_claim as varchar(10),                
@Fld_counter_amount as numeric,                
@Fld_Nxt_hdt as varchar(11),                
@Fld_FileNo as varchar(30),                
@Fld_Status as varchar(100),                
@Fld_Remark as varchar(250),                
@Fld_Fees_Deposited as numeric,                
@Fld_EnteredBy as varchar(25),          
@Fld_srno as varchar(25),        
@Fld_case_By as varchar(25),        
@Fld_Case_status as varchar(25),      
@Fld_forum as varchar(50),    
@Fld_Htime as varchar(30),  
@case_no as varchar(30),  
@incharge_person as varchar(50)    
)          
as           
          
set @Fld_LDN_dt = convert(datetime,@Fld_LDN_dt,103)                                        
set @Fld_Req_dt = convert(datetime,@Fld_Req_dt,103)                                        
set @Fld_casefiling_dt = convert(datetime,@Fld_casefiling_dt,103)                                        
set @Fld_Nxt_hdt = convert(datetime,@Fld_Nxt_hdt,103)           
          
update tbl_NI138_Master set           
Fld_partycode = @Fld_partycode,          
Fld_partyname = @Fld_partyname ,                
Fld_Branch = @Fld_Branch ,                
Fld_subbroker = @Fld_subbroker,                
Fld_LDN_dt = @Fld_LDN_dt ,                
Fld_Req_dt = @Fld_Req_dt ,                
Fld_casefiling_dt = @Fld_casefiling_dt ,                
Fld_segment = @Fld_segment,                
Fld_claimamount = @Fld_claimamount,                
Fld_decreeamount = @Fld_decreeamount,                
Fld_satt_amount = @Fld_satt_amount,                
Fld_Amount_recovered = @Fld_Amount_recovered,                
Fld_counter_claim = @Fld_counter_claim,                
Fld_counter_amount = @Fld_counter_amount,                
Fld_Nxt_hdt = @Fld_Nxt_hdt,                
Fld_FileNo = @Fld_FileNo,                
Fld_Status = @Fld_Status,                
Fld_Remark = @Fld_Remark,                
Fld_Fees_Deposited = @Fld_Fees_Deposited,                
Fld_EnteredBy = @Fld_EnteredBy,        
Fld_case_By = @Fld_case_By,        
Fld_Case_status = @Fld_Case_status,      
Fld_forum  = @Fld_forum,      
Fld_Htime=@Fld_Htime,    
Fld_case_No=@case_no,  
Fld_Incharge_Person=@incharge_person  
where Fld_partycode = @Fld_partycode and Fld_srno = @Fld_srno          
          
insert into tbl_legalstatus_log                 
values                 
(                
@Fld_partycode,@Fld_segment,@Fld_Status,@Fld_Remark,getdate(),@Fld_EnteredBy,'Section138'                
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Section138_Entry
-- --------------------------------------------------

          
CREATE PROC [dbo].[usp_Section138_Entry]                              
(              
@CaseBy AS VARCHAR(20),        
@PartyCode AS VARCHAR(20), 
@Legalforum AS Varchar(50),
@FileBy As Varchar(50),
@Name AS VARCHAR(50),                              
@Branch AS VARCHAR(20),                              
@SubBroker AS VARCHAR(50),                              
@Company AS VARCHAR(15),  
@ClaimAmt AS Bigint,
@AmountPaid As Bigint,
@Stage As Varchar(300),
@AdvocatesName AS Varchar(50),
@AmtRecovered AS bigint,
@CounterClaim As bigint,
@NextDate AS Varchar(11),
@Remarks AS varchar(1000),
@AdvocateEmailID AS nvarchar(80),
@TypeofCase AS varchar(50),
@AdvocatePhoneNo AS Nvarchar(50),                             
@EnteredBy  AS VARCHAR(50)          
)              
-- Exec usp_Section138_Entry 'TEST','JAIP4647','1','VIVEK  BOTHRA','JAIP','EBCJP','ACDL','1','1',1,'09/09/2009',106,'1','1',1,'16/09/2009',1,'1','1','1',''                      
AS                       
                              
IF(SELECT COUNT(partycode) FROM tbl_Section138 WHERE PartyCode = @PartyCode AND Company = @Company) = 0                               
BEGIN          
INSERT INTO tbl_Section138          
VALUES          
(               
@CaseBy,UPPER(@PartyCode),'-',@Name ,@Branch ,@SubBroker ,                              
@Company ,'-' ,'-' ,'',                              
CONVERT(DATETIME,@NextDate,103)--NextDateParameter
,@Stage,'-',                              
'-','',CONVERT(DATETIME,'1900-01-01',103),CONVERT(DATETIME,'1900-01-01',103),          
'',@Remarks,'-','-',@EnteredBy,GETDATE(),@Legalforum,
@TypeofCase,@AmountPaid,@AmtRecovered,@AdvocatePhoneNo,@AdvocateEmailID,@CounterClaim,
@ClaimAmt,@AdvocatesName,@FileBy  
          
                   
)                              
INSERT INTO tbl_legalstatus_log                               
VALUES                               
(                              
UPPER(@PartyCode),@Company,@Stage,@Remarks,GETDATE(),@EnteredBy,'Section138'                              
)                              
End           
          
--select * from tbl_legalstatus_log

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Section138_Update
-- --------------------------------------------------
CREATE PROC [dbo].[usp_Section138_Update]                            
(           
@SRNO  AS NUMERIC,        
@CaseBy AS VARCHAR(20),          
@PartyCode AS VARCHAR(20),   
@Legalforum AS Varchar(50),  
@FileBy As Varchar(50),  
@Name AS VARCHAR(50),                                
@Branch AS VARCHAR(20),                                
@SubBroker AS VARCHAR(50),                                
@Company AS VARCHAR(15),    
@ClaimAmt AS Bigint,  
@AmountPaid As Bigint,  
@Stage As Varchar(300),  
@AdvocatesName AS Varchar(50),  
@AmtRecovered AS bigint,  
@CounterClaim As bigint,  
@Remarks AS varchar(1000),  
@AdvocateEmailID AS nvarchar(80),  
@TypeofCase AS varchar(50),  
@AdvocatePhoneNo AS Nvarchar(50),   
@NextDate AS VARCHAR(50),                              
@EnteredBy  AS VARCHAR(50)       
)          
------------------------------------------------------------------------------------------------------------------                          
AS             
BEGIN               
------------------------------------------------------------------------------------------------------------------        
UPDATE tbl_Section138 SET        
 CaseBy=@CaseBy,Name=@Name ,Branch=@Branch ,SubBroker=@SubBroker ,                            
 Company=@Company ,LegalForum=@Legalforum,FileBy=@FileBy,  
 ClaimAmount=CONVERT(bigint,@ClaimAmt),AmountPaid=CONVERT(bigint,@AmountPaid),AdvocatesName=@AdvocatesName,  
 AmountRecovered=CONVERT(bigint,@AmtRecovered),CounterClaim=CONVERT(bigint,@CounterClaim),                            
 NextDate=CONVERT(DATETIME,@NextDate,103),Stage=@Stage,                       
 AdvocatesEmailID=@AdvocateEmailID,TypeOfCase=@TypeofCase,  
 AdvocatesPhoneNo=@AdvocatePhoneNo,        
 Remarks=@Remarks,       
 EnteredBy=@EnteredBy,EntryDate=GETDATE()        
 WHERE PartyCode=@PartyCode AND SRNO=@SRNO --AND Company=@Company   
------------------------------------------------------------------------------------------------------------------                         
 INSERT INTO tbl_legalstatus_log                             
 VALUES                             
 (                            
  UPPER(@PartyCode),@Company,@stage,@Remarks,GETDATE(),@EnteredBy,'Section138'                            
 )                            
------------------------------------------------------------------------------------------------------------------        
End         
        
--select * from tbl_Section138        
        
--Exec usp_Section138_Entry 'TEST','1','1','SHREEKALA','XF','BB','ACDL','1','1',1,'09/08/2009',102,'1','',1,'09/08/2009','','','','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Section138_Update_bak14082012
-- --------------------------------------------------
CREATE PROC [dbo].[usp_Section138_Update_bak14082012]                          
(         
 @SRNO  AS NUMERIC,      
 @CaseBy AS VARCHAR(20),      
 @CaseNo AS VARCHAR(25),                      
 @PartyCode AS VARCHAR(20),                          
 @Name AS VARCHAR(50),                          
 @Branch AS VARCHAR(20),                          
 @SubBroker AS VARCHAR(50),                          
 @Company AS VARCHAR(15),                          
 @Court AS VARCHAR(50),                         
 @ChequeNo AS VARCHAR(15),                     
 @Amount AS MONEY,                          
 @NextDate AS VARCHAR(11),        
 @stageCode AS NUMERIC,                          
 @AdvocateOnRecord AS VARCHAR(100),                          
 @ProfFeesPaid AS VARCHAR(50),                          
 @CourtFeesStumps AS MONEY,                          
 @FilingDate AS VARCHAR(11),                          
 @SettlementAmount AS MONEY,                    
 @Remarks AS VARCHAR(2000) ,                
 @Convictted AS VARCHAR(100),            
 @PersonInCharge AS VARCHAR(50),      
 @EnteredBy  AS VARCHAR(50)      
)        
------------------------------------------------------------------------------------------------------------------                        
AS           
BEGIN             
------------------------------------------------------------------------------------------------------------------      
 UPDATE tbl_Section138 SET      
 CaseBy=@CaseBy,CaseNo=@CaseNo,Name=@Name ,Branch=@Branch ,SubBroker=@SubBroker ,                          
 Company=@Company ,Court=@Court ,ChequeNo=@ChequeNo ,Amount=@Amount ,                          
 NextDate=CONVERT(DATETIME,@NextDate,103),Stage=@stageCode ,AdvocateOnRecord=@AdvocateOnRecord ,                          
 ProfFeesPaid=@ProfFeesPaid ,CourtFeesStumps=@CourtFeesStumps ,FilingDate=CONVERT(DATETIME,@FilingDate,103),      
 SettlementAmount=ISNULL(@SettlementAmount,0),Remarks=@Remarks,Convictted=@Convictted,PersonInCharge=@PersonInCharge,      
 EnteredBy=@EnteredBy,EntryDate=GETDATE()      
 WHERE PartyCode=@PartyCode AND SRNO=@SRNO --AND Company=@Company      
------------------------------------------------------------------------------------------------------------------                       
 INSERT INTO tbl_legalstatus_log                           
 VALUES                           
 (                          
  UPPER(@PartyCode),@Company,@stageCode,@Remarks,GETDATE(),@EnteredBy,'Section138'                          
 )                          
------------------------------------------------------------------------------------------------------------------      
End       
      
--select * from tbl_Section138      
      
--Exec usp_Section138_Entry 'TEST','1','1','SHREEKALA','XF','BB','ACDL','1','1',1,'09/08/2009',102,'1','',1,'09/08/2009','','','','',''

GO

-- --------------------------------------------------
-- TABLE dbo.branch
-- --------------------------------------------------
CREATE TABLE [dbo].[branch]
(
    [sbtag] VARCHAR(10) NULL,
    [tradername] VARCHAR(100) NULL,
    [email] VARCHAR(50) NULL,
    [add1] VARCHAR(50) NULL,
    [add2] VARCHAR(50) NULL,
    [add3] VARCHAR(50) NULL,
    [add4] VARCHAR(50) NULL,
    [add5] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Legal_format
-- --------------------------------------------------
CREATE TABLE [dbo].[Legal_format]
(
    [Fld_partycode] NVARCHAR(255) NULL,
    [Fld_partyname] NVARCHAR(255) NULL,
    [Fld_Branch] NVARCHAR(255) NULL,
    [Fld_subbroker] NVARCHAR(255) NULL,
    [Fld_LDN_dt] NVARCHAR(255) NULL,
    [Fld_Req_dt] NVARCHAR(255) NULL,
    [Fld_casefiling_dt] NVARCHAR(255) NULL,
    [Fld_segment] NVARCHAR(255) NULL,
    [Fld_claimamount] FLOAT NULL,
    [Fld_decreeamount] NVARCHAR(255) NULL,
    [Fld_satt_amount] NVARCHAR(255) NULL,
    [Fld_Amount_recovered] NVARCHAR(255) NULL,
    [Fld_counter_claim] NVARCHAR(255) NULL,
    [Fld_counter_amount] NVARCHAR(255) NULL,
    [Fld_Nxt_hdt] SMALLDATETIME NULL,
    [Fld_FileNo] NVARCHAR(255) NULL,
    [Fld_Status] NVARCHAR(255) NULL,
    [Fld_Remark] NVARCHAR(255) NULL,
    [Fld_Fees_Deposited] NVARCHAR(255) NULL,
    [Fld_EntryDate] NVARCHAR(255) NULL,
    [Fld_EnteredBy] NVARCHAR(255) NULL,
    [Fld_case_By] NVARCHAR(255) NULL,
    [Fld_Case_status] NVARCHAR(255) NULL,
    [Fld_awardfor] NVARCHAR(255) NULL,
    [Forum] NVARCHAR(255) NULL,
    [Fld_dummy3] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Legal_format1
-- --------------------------------------------------
CREATE TABLE [dbo].[Legal_format1]
(
    [Fld_partycode] VARCHAR(255) NULL,
    [Fld_partyname] VARCHAR(255) NULL,
    [Fld_Branch] VARCHAR(255) NULL,
    [Fld_subbroker] VARCHAR(255) NULL,
    [Fld_LDN_dt] NVARCHAR(255) NULL,
    [Fld_Req_dt] NVARCHAR(255) NULL,
    [Fld_casefiling_dt] NVARCHAR(255) NULL,
    [Fld_segment] NVARCHAR(255) NULL,
    [Fld_claimamount] NUMERIC(25, 2) NULL,
    [Fld_decreeamount] NUMERIC(25, 2) NULL,
    [Fld_satt_amount] NUMERIC(25, 2) NULL,
    [Fld_Amount_recovered] NUMERIC(25, 2) NULL,
    [Fld_counter_claim] NVARCHAR(255) NULL,
    [Fld_counter_amount] NUMERIC(25, 2) NULL,
    [Fld_Nxt_hdt] VARCHAR(255) NULL,
    [Fld_FileNo] NVARCHAR(255) NULL,
    [Fld_Status] NVARCHAR(255) NULL,
    [Fld_Remark] NVARCHAR(255) NULL,
    [Fld_Fees_Deposited] NUMERIC(25, 2) NULL,
    [Fld_EntryDate] NVARCHAR(255) NULL,
    [Fld_EnteredBy] VARCHAR(255) NULL,
    [Fld_case_By] NVARCHAR(255) NULL,
    [Fld_Case_status] NVARCHAR(255) NULL,
    [Fld_awardfor] NVARCHAR(255) NULL,
    [Forum] NVARCHAR(255) NULL,
    [Fld_dummy3] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_case_delete_log
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_case_delete_log]
(
    [Fld_PartyCode] VARCHAR(10) NULL,
    [Fld_Segment] VARCHAR(10) NULL,
    [Fld_action] VARCHAR(50) NULL,
    [Fld_CaseType] VARCHAR(20) NULL,
    [Fld_userid] VARCHAR(50) NULL,
    [Fld_actiontime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_legal_feesdeposited
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_legal_feesdeposited]
(
    [Fld_srno] INT IDENTITY(1,1) NOT NULL,
    [Fld_PartyCode] VARCHAR(50) NULL,
    [Fld_Segment] VARCHAR(50) NULL,
    [Fld_CaseType] VARCHAR(50) NULL,
    [Fld_chq1] VARCHAR(50) NULL,
    [Fld_amt1] NUMERIC(18, 2) NULL,
    [Fld_chq2] VARCHAR(50) NULL,
    [Fld_amt2] NUMERIC(18, 2) NULL,
    [Fld_chq3] VARCHAR(50) NULL,
    [Fld_amt3] NUMERIC(18, 2) NULL,
    [Fld_chq4] VARCHAR(50) NULL,
    [Fld_amt4] NUMERIC(18, 2) NULL,
    [Fld_chq5] VARCHAR(50) NULL,
    [Fld_amt5] NUMERIC(18, 2) NULL,
    [Fld_total] NUMERIC(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_LegalArbitration
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_LegalArbitration]
(
    [Fld_srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Fld_partycode] VARCHAR(50) NULL,
    [Fld_partyname] VARCHAR(150) NULL,
    [Fld_Branch] VARCHAR(15) NULL,
    [Fld_subbroker] VARCHAR(15) NULL,
    [Fld_LDN_dt] DATETIME NULL,
    [Fld_Req_dt] DATETIME NULL,
    [Fld_casefiling_dt] DATETIME NULL,
    [Fld_segment] VARCHAR(10) NULL,
    [Fld_claimamount] NUMERIC(18, 2) NULL,
    [Fld_decreeamount] NUMERIC(18, 2) NULL,
    [Fld_satt_amount] NUMERIC(18, 2) NULL,
    [Fld_Amount_recovered] NUMERIC(18, 2) NULL,
    [Fld_counter_claim] CHAR(5) NULL,
    [Fld_counter_amount] NUMERIC(18, 2) NULL,
    [Fld_Nxt_hdt] DATETIME NULL,
    [Fld_Htime] VARCHAR(50) NULL,
    [Fld_FileNo] VARCHAR(50) NULL,
    [Fld_Status] VARCHAR(100) NULL,
    [Fld_Remark] VARCHAR(150) NULL,
    [Fld_Fees_Deposited] NUMERIC(18, 2) NULL,
    [Fld_EntryDate] DATETIME NULL,
    [Fld_EnteredBy] VARCHAR(50) NULL,
    [Fld_case_By] VARCHAR(50) NULL,
    [Fld_Case_status] VARCHAR(50) NULL,
    [Fld_awardfor] VARCHAR(50) NULL,
    [Fld_forum] VARCHAR(50) NULL,
    [Fld_Case_No] VARCHAR(50) NULL,
    [Fld_Incharge_Person] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_LegalArbitration_deleted
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_LegalArbitration_deleted]
(
    [Fld_srno] NUMERIC(18, 0) NOT NULL,
    [Fld_partycode] NCHAR(10) NULL,
    [Fld_partyname] VARCHAR(150) NULL,
    [Fld_Branch] VARCHAR(15) NULL,
    [Fld_subbroker] VARCHAR(15) NULL,
    [Fld_LDN_dt] DATETIME NULL,
    [Fld_Req_dt] DATETIME NULL,
    [Fld_casefiling_dt] DATETIME NULL,
    [Fld_segment] VARCHAR(10) NULL,
    [Fld_claimamount] NUMERIC(18, 2) NULL,
    [Fld_decreeamount] NUMERIC(18, 2) NULL,
    [Fld_satt_amount] NUMERIC(18, 2) NULL,
    [Fld_Amount_recovered] NUMERIC(18, 2) NULL,
    [Fld_counter_claim] CHAR(5) NULL,
    [Fld_counter_amount] NUMERIC(18, 2) NULL,
    [Fld_Nxt_hdt] DATETIME NULL,
    [Fld_Htime] VARCHAR(50) NULL,
    [Fld_FileNo] VARCHAR(50) NULL,
    [Fld_Status] VARCHAR(100) NULL,
    [Fld_Remark] VARCHAR(150) NULL,
    [Fld_Fees_Deposited] NUMERIC(18, 2) NULL,
    [Fld_EntryDate] DATETIME NULL,
    [Fld_EnteredBy] VARCHAR(50) NULL,
    [Fld_caseby] VARCHAR(50) NULL,
    [Fld_casestatus] VARCHAR(50) NULL,
    [Fld_awardfor] VARCHAR(50) NULL,
    [Fld_forum] VARCHAR(50) NULL,
    [Fld_Case_No] VARCHAR(50) NULL,
    [Fld_Incharge_Person] VARCHAR(50) NULL,
    [Fld_Actiondate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_LegalStatus_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_LegalStatus_Log]
(
    [Fld_Refcode] VARCHAR(100) NULL,
    [Fld_segment] VARCHAR(50) NULL,
    [Fld_status] VARCHAR(70) NULL,
    [Fld_remark] VARCHAR(200) NULL,
    [Fld_ActionDate] DATETIME NULL,
    [Fld_EnteredBy] VARCHAR(20) NULL,
    [Fld_Module] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_legalStatus_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_legalStatus_Master]
(
    [Fld_statuscode] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Fld_StatusName] VARCHAR(150) NULL,
    [Fld_CaseType] VARCHAR(50) NULL,
    [Fld_CreationDate] DATETIME NULL,
    [Fld_CreatedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NI138_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NI138_Master]
(
    [Fld_srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Fld_partycode] VARCHAR(50) NULL,
    [Fld_partyname] VARCHAR(150) NULL,
    [Fld_Branch] VARCHAR(15) NULL,
    [Fld_subbroker] VARCHAR(15) NULL,
    [Fld_LDN_dt] DATETIME NULL,
    [Fld_Req_dt] DATETIME NULL,
    [Fld_casefiling_dt] DATETIME NULL,
    [Fld_segment] VARCHAR(10) NULL,
    [Fld_claimamount] NUMERIC(18, 2) NULL,
    [Fld_decreeamount] NUMERIC(18, 2) NULL,
    [Fld_satt_amount] NUMERIC(18, 2) NULL,
    [Fld_Amount_recovered] NUMERIC(18, 2) NULL,
    [Fld_counter_claim] CHAR(5) NULL,
    [Fld_counter_amount] NUMERIC(18, 2) NULL,
    [Fld_Nxt_hdt] DATETIME NULL,
    [Fld_Htime] VARCHAR(50) NULL,
    [Fld_FileNo] VARCHAR(50) NULL,
    [Fld_Status] VARCHAR(100) NULL,
    [Fld_Remark] VARCHAR(350) NULL,
    [Fld_Fees_Deposited] NUMERIC(18, 2) NULL,
    [Fld_EntryDate] DATETIME NULL,
    [Fld_EnteredBy] VARCHAR(50) NULL,
    [Fld_case_By] VARCHAR(50) NULL,
    [Fld_Case_status] VARCHAR(50) NULL,
    [Fld_awardfor] VARCHAR(50) NULL,
    [Fld_forum] VARCHAR(50) NULL,
    [Fld_Case_No] VARCHAR(50) NULL,
    [Fld_Incharge_Person] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NI38_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NI38_log]
(
    [Fld_Refcode] VARCHAR(100) NULL,
    [Fld_segment] VARCHAR(50) NULL,
    [Fld_status] VARCHAR(70) NULL,
    [Fld_remark] VARCHAR(200) NULL,
    [Fld_ActionDate] DATETIME NULL,
    [Fld_EnteredBy] VARCHAR(20) NULL,
    [Fld_Module] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Section138
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Section138]
(
    [srno] BIGINT IDENTITY(1,1) NOT NULL,
    [caseBy] VARCHAR(20) NULL,
    [PartyCode] VARCHAR(20) NULL,
    [CaseNo] VARCHAR(25) NOT NULL,
    [Name] VARCHAR(50) NOT NULL,
    [Branch] VARCHAR(20) NULL,
    [SubBroker] VARCHAR(50) NULL,
    [Company] VARCHAR(10) NOT NULL,
    [Court] VARCHAR(50) NULL,
    [ChequeNo] VARCHAR(60) NULL,
    [Amount] MONEY NOT NULL,
    [NextDate] DATETIME NULL,
    [stage] VARCHAR(300) NOT NULL,
    [AdvocateOnRecord] VARCHAR(100) NOT NULL,
    [ProfFeesPaid] VARCHAR(50) NULL,
    [CourtFeesStumps] MONEY NULL,
    [FilingDate] DATETIME NULL,
    [NoticeDate] DATETIME NOT NULL,
    [SettlementAmount] MONEY NULL,
    [Remarks] VARCHAR(2000) NULL,
    [Convictted] VARCHAR(100) NULL,
    [PersonInCharge] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(50) NULL,
    [EntryDate] DATETIME NULL,
    [LegalForum] VARCHAR(100) NULL,
    [TypeOfCase] VARCHAR(80) NULL,
    [AmountPaid] BIGINT NULL,
    [AmountRecovered] BIGINT NULL,
    [AdvocatesPhoneNo] NVARCHAR(50) NULL,
    [AdvocatesEmailID] NVARCHAR(50) NULL,
    [CounterClaim] BIGINT NULL,
    [ClaimAmount] BIGINT NULL,
    [AdvocatesName] VARCHAR(50) NULL,
    [FileBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.trg_delete_LegalArbitration
-- --------------------------------------------------
create trigger trg_delete_LegalArbitration
  
on dbo.Tbl_LegalArbitration     
  
for delete      
  
as       
  
insert into dbo.Tbl_LegalArbitration_deleted       
  
select *,getdate() from deleted

GO

