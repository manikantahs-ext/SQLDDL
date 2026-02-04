-- DDL Export
-- Server: 10.253.33.89
-- Database: Angelvms
-- Exported: 2026-02-05T02:38:28.835996

USE Angelvms;
GO

-- --------------------------------------------------
-- INDEX dbo.bill_status_log
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_V_NO] ON [dbo].[bill_status_log] ([v_no])

GO

-- --------------------------------------------------
-- INDEX dbo.billmaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_branch] ON [dbo].[billmaster] ([branch], [entry_date]) INCLUDE ([eid_branch])

GO

-- --------------------------------------------------
-- INDEX dbo.billmaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_branch1] ON [dbo].[billmaster] ([branch], [eid_branch], [entry_date]) INCLUDE ([v_no], [vcode], [segment], [bill_date], [acname], [longname], [inv_no], [amount], [pan_no], [st_no], [br_tag], [exp_empid], [dest_branch], [remark], [exp_fdt], [exp_tdt], [LOB], [Adv_Amt], [Adv_Cheque_No], [Order_Maker])

GO

-- --------------------------------------------------
-- INDEX dbo.PaymentMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_cheque_no] ON [dbo].[PaymentMaster] ([cheque_no])

GO

-- --------------------------------------------------
-- INDEX dbo.PaymentMaster_deleted
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_PV_NO] ON [dbo].[PaymentMaster_deleted] ([pv_no])

GO

-- --------------------------------------------------
-- INDEX dbo.vendormaster_RENAMEDAS_PII
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_segment] ON [dbo].[vendormaster_RENAMEDAS_PII] ([segment], [acname])

GO

-- --------------------------------------------------
-- INDEX dbo.VoucherEntry
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_VNO] ON [dbo].[VoucherEntry] ([v_code])

GO

-- --------------------------------------------------
-- INDEX dbo.VoucherEntry_deteled
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_V_NO] ON [dbo].[VoucherEntry_deteled] ([v_no])

GO

-- --------------------------------------------------
-- INDEX dbo.VoucherMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_v_date] ON [dbo].[VoucherMaster] ([v_date])

GO

-- --------------------------------------------------
-- INDEX dbo.VoucherMaster_deleted
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_V_NO] ON [dbo].[VoucherMaster_deleted] ([v_no])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.billmaster
-- --------------------------------------------------
ALTER TABLE [dbo].[billmaster] ADD CONSTRAINT [PK_billmaster] PRIMARY KEY ([v_no])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.couriersmaster
-- --------------------------------------------------
ALTER TABLE [dbo].[couriersmaster] ADD CONSTRAINT [PK_couriersmaster] PRIMARY KEY ([cid])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Expense_MIS
-- --------------------------------------------------
ALTER TABLE [dbo].[Expense_MIS] ADD CONSTRAINT [PK_Expense_MIS] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.PaymentMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[PaymentMaster] ADD CONSTRAINT [PK_PaymentMaster] PRIMARY KEY ([pv_no])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TPD_CE
-- --------------------------------------------------
ALTER TABLE [dbo].[TPD_CE] ADD CONSTRAINT [PK_TPD_CE] PRIMARY KEY ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TPD_HC
-- --------------------------------------------------
ALTER TABLE [dbo].[TPD_HC] ADD CONSTRAINT [PK_TPD_HC] PRIMARY KEY ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TPD_WS
-- --------------------------------------------------
ALTER TABLE [dbo].[TPD_WS] ADD CONSTRAINT [PK_TPD_WS] PRIMARY KEY ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.update_log
-- --------------------------------------------------
ALTER TABLE [dbo].[update_log] ADD CONSTRAINT [PK_update_log] PRIMARY KEY ([srn])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.VoucherMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[VoucherMaster] ADD CONSTRAINT [PK_VoucherMaster] PRIMARY KEY ([v_no])

GO

-- --------------------------------------------------
-- PROCEDURE dbo. usp_fill_user1
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[ usp_fill_user1]                             
(                                        
@uname as varchar(40),@str1 as varchar(25),@str2 as varchar(25),@fdate as varchar(11),@tdate as varchar(11)                                         
)                                        
 as                                      
set nocount on                                         
set transaction isolation level read uncommitted                                                  
                
set @fdate=convert(datetime,@fdate,103)              
set @tdate=convert(datetime,@tdate,103)              
              
if  @uname='ALL'                    
begin                    
set @uname='%%'                    
end                     
                    
                                
if @str1='branch'                                   
begin                      
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end ,a.remark,convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,                  
a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]   
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                               
a.eid_branch=b.username where  a.eid_branch like @uname and a.branch=@str2 and                     
a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                   
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                                 
                                  
end                                  
 if @str1='region'                                   
begin                   
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end,a.remark,convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]            
  
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                           
a.eid_branch=b.username where  a.eid_branch like @uname and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch like @str2)                     
and a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                     
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                                  
end                                  
if @str1='broker'                                   
begin                                  
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end,a.remark,convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]    
  
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                  
a.eid_branch=b.username where  a.eid_branch like @uname and a.branch=@str2                     
and a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                    
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                                
end                                  
if @str1='BRMAST'                                  
begin                   
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end,a.remark,                  
convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]    
  
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                         
a.eid_branch=b.username where  a.eid_branch like @uname and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch like @str2)                     
and a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                  
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                  
                  
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
-- PROCEDURE dbo.SHOW_DG_PENDING
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SHOW_DG_PENDING]    
(    
@str1 as varchar(25)     
)    
 as  
set nocount on     
set transaction isolation level read uncommitted              
    
    
if @str1 ='ALL'    
begin     
Select a.v_no,a.branch,a.br_tag,b.person_name,a.segment,a.acname,a.vcode,a.longname,a.inv_no,    
a.amount,a.bill_date,a.courier_name,    
a.doc_no,a.r_date,a.pay_amount,a.cheque_no,a.cso_date,a.courier_name1,convert (varchar(11),a.dis_date,103) as dis_date,convert (varchar(11),a.d_date,103) as d_date,    
a.doc_no1,c.person_name  as pname from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username     
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username    
where a.comp_flag='1' and a.r_flag1 ='0' order by a.v_no    
end     
if @str1 <>'ALL'    
begin  
Select a.v_no,a.branch,a.br_tag,b.person_name,a.segment,a.acname,a.vcode,a.longname,a.inv_no,    
a.amount,a.bill_date,a.courier_name,convert (varchar(11),a.dis_date,103) as dis_date,convert (varchar(11),a.d_date,103) as d_date,    
a.doc_no,a.r_date,a.pay_amount,a.cheque_no,a.cso_date,a.courier_name1,     
a.doc_no1,c.person_name from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username     
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username    
where  a.branch=@str1 and a.comp_flag='1' and a.r_flag1 ='0' order by a.v_no    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sp_Inverse_JV
-- --------------------------------------------------
CREATE Proc Sp_Inverse_JV  
(  
@fdate as varchar(11),  
@tdate as varchar(11)  
)  
as  
  
/*  
create nonclustered index ix_vno on vouchermaster(entry_date,ven_code)  
create nonclustered index ix_vno on voucherentry(v_code)  
*/  
  
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))  
set @tdate = convert(varchar(11),convert(datetime,@tdate,103)) + ' 23:59:59'  
  
select * into #x from  
(  
select x.v_no,inv_no,narration,v_date,emp_no,segment,ven_name,ven_code,entry_date,status,y.amount from  
(select * from vouchermaster (nolock) where entry_date >= @fdate and entry_date <= @tdate and ven_code <> '444444')x  
inner join  
(select * from voucherentry (nolock) where v_code = '444444')y  
on x.v_no = y.v_no  
union   
select * from vouchermaster (nolock) where inv_no in  
(  
select inv_no from  
(select * from vouchermaster (nolock) where entry_date >= @fdate and entry_date <= @tdate and ven_code <> '444444')x  
inner join  
(select * from voucherentry (nolock) where v_code = '444444')y  
on x.v_no = y.v_no  
) and ven_code = '444444'  
) x  
  
select * from #x where inv_no in  
(  
select inv_no from #x group by inv_no having count(*) = 2  
) order by inv_no,ven_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MisNew
-- --------------------------------------------------
CREATE Proc sp_MisNew           
(                        
@filter_type as varchar(10),
@access_to as varchar(25),                      
@access_code as varchar(25),          
@param1 as varchar(60),      
@param2 as varchar(60),           
@param3 as varchar(60),        
@param4 as varchar(60),           
@param5 as varchar(60)                       
)                        
as                         
declare @str as varchar(2000)          
declare @filter as varchar(600)          
declare @access_query as varchar(600)          
declare @final as varchar(5000)          
declare @post as varchar(500)         
declare @fdt as varchar(30)
declare @tdt as varchar(30)  
       
---print @param1
--print @param2  
if @access_to='BRANCH'            
      
begin                      
set @access_query=''            
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by a.V_NO '          
end          
--print @access_query          
else if @access_to='REGION'                        
begin          
set @access_query=''            
set @access_query=@access_query+' and a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''')'            
end          
          
                     
else if @access_to='BRMAST'                      
begin          
set  @access_query=''            
set  @access_query=@access_query+' and  a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') order by a.V_NO '          
end     
     
else if @access_to='BROKER'                      
begin          
set  @access_query=''            
set  @access_query=@access_query+' and  a.branch like ''%'' order by a.V_NO '          
end          
          

if @filter_type='1'          
begin  

set @fdt= convert(datetime,@param1,103)
set @tdt= convert(datetime,@param2,103)
--Print @param1
--Print @param2
--Print @fdt
--Print @tdt
set @filter=''          
set @filter=@filter+' where a.dis_date>='''+@fdt+''' and a.dis_date<='''+@tdt+''''          
end          
else if @filter_type='2'          
begin          
set @filter=''          
set @filter=@filter+' where a.inv_no='''+@param1+''''          
end        
else if @filter_type='3'      
begin       
set @filter=''      
set @filter=@filter+' where a.segment='''+@param1+''' and a.acname='''+@param2+''' and a.vcode='''+@param3+''''      
end      

else if @filter_type='4'      
begin 
set @fdt=convert(datetime,@param1,103)
set @tdt=convert(datetime,@param2,103)    
set @filter=''      
set @filter=@filter+' where a.d_date>='''+@fdt+''' and a.d_date<='''+@tdt+''''

end   

else if @filter_type='5'          
begin          
set @filter=''          
set @filter=@filter+' where a.cheque_no like ''%'+@param1+'%'''          
end     

else if @filter_type='6'          
begin          
set @filter=''          
set @filter=@filter+' where a.v_no='''+@param1+''''          
end     


--else if @filter_type='7'          
--begin     
--set @fdt=convert(datetime,@param1,103)
--set @tdt=convert(datetime,@param2,103)     
--set @filter=''          
--set @filter=@filter+' where Convert(datetime,a.Bill_date,103)> as Bill_date ='''+@fdt+''' and Convert(datetime,a.Bill_date,103)as Bill_date<='''+@tdt+''''          
--end    
         
set @str=''          
set @str=@str+'select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,'     
set @str=@str+'a.vcode,a.segment,a.inv_no,a.LOB,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,'     
set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'     
set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'     
set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'           
set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'           
set @str=@str+'a.cheque_no,a.eid_cso,c.person_name as pname,convert(varchar(11),a.d_date,103)'           
set @str=@str+'as d_date,a.br_date from billmaster a (nolock)'           
set @str=@str+'inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username '
set @str=@str+'inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username'

set @final=''
set @final=@final+@str+@filter+@access_query
--print(@final)
exec(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPcountPVJV
-- --------------------------------------------------
CREATE proc SPcountPVJV  
@Fdate varchar(11), @Tdate varchar(22)    
as   
  
set @Fdate = convert(varchar(11),convert(datetime,@Fdate,103))      
set @Tdate = convert(varchar(11),convert(datetime,@Tdate,103))+' 23:59:59'    
  
Exec SPGetJVCount @Fdate, @Tdate  
  
Exec SPGetPVCount @Fdate, @Tdate  
  
Exec SPGetCMSCount @Fdate, @Tdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPCreateBranch
-- --------------------------------------------------
create proc SPCreateBranch
@Branch varchar(50),
@SubBranch varchar(50),
@Ratio Decimal,
@Status bit,
@ShortBranch varchar(50)
as
insert into Branch_details values(@Branch,@SubBranch,@Ratio,@Status,@ShortBranch)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGet444444
-- --------------------------------------------------

create proc SPGet444444  
as  
select  b.*  into #t  
from voucherentry a (nolock), vouchermaster b (nolock)  
where a.v_code = '444444' and a.v_no = b.v_no and   
entry_date >= '2009-04-01 00:00:00.000' and entry_date <= '2009-04-01 23:59:59.000'   
select * from #t where inv_no in (select inv_no from #t group by inv_no having count(*) > 1) 
order by inv_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetBillCount
-- --------------------------------------------------
CREATE proc SPGetBillCount  
@Fdate varchar(11),  
@Tdate varchar(11)  
as  
select count(*) as [No.Of Bills Received By CSO] from billmaster 
where r_flag = 1 and r_date >=@Fdate  and r_date <= @Tdate 
--select   
--count(case when branch_flag=1 then 1 end ) as [No.Of Bills Sent By Branch],  
--count(case when r_flag=1 then 1 end) as [No.Of Bills Received By CSO],  
--count(case when cso_flag=1 then 1 end ) as [No.Of Cheques Created By CSO],  
--count(case when Comp_flag=1 then 1 end) as [No.Of Cheques Dispatched By CSO],  
--count(case when r_flag1=1 then 1 end) as [No.Of Cheques Received By Branch]   
--from billmaster (nolock)   
--where entry_date between convert(datetime,@Fdate,103)  
--and convert(datetime,@Tdate,103)  
--exec SPGetBillCount '18/03/2009','19/03/2009'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetBillCount_Test
-- --------------------------------------------------
CREATE proc SPGetBillCount_Test   
@Status varchar(50),
@Fdate varchar(11),    
@Tdate varchar(11)
as    
If @Status = 'BEntry'
Begin
	select count(*) as [No.Of Bills Entered By Branch] from billmaster   
	where entry_date >=convert(datetime,@Fdate,103)  and entry_date <= convert(datetime,@Tdate,103)+' 23:59:59' 
End
Else If @Status = 'BSent'
Begin 
	select count(*) as [No.Of Bills Sent By Branch] from billmaster   
	where dis_date >=convert(datetime,@Fdate,103)  and dis_date <= convert(datetime,@Tdate,103)+' 23:59:59'
	and branch_flag = 1 
End
Else If @Status = 'BReceived'
Begin 
	select count(*) as [No.Of Bills Received By Branch] from billmaster   
	where r_date >=@Fdate  and r_date <= @Tdate
	and r_flag = 1 
End
Else If @Status = 'CCreated'
Begin 
	select count(*) as [No.Of Cheques Created By CSO] from billmaster   
	where cso_date >=@Fdate  and cso_date <= @Tdate
	and cso_flag = 1 
End
Else If @Status = 'CDispatched'
Begin 
	select count(*) as [No.Of Cheques Dispatched By CSO] from billmaster   
	where d_date >=convert(datetime,@Fdate,103)  and d_date <= convert(datetime,@Tdate,103)+' 23:59:59'
	and comp_flag = 1 
End
Else If @Status = 'CReceived'
Begin 
	select count(*) as [No.Of Cheques Received By Branch] from billmaster   
	where br_date >=@Fdate  and br_date <= @Tdate
	and r_flag1 = 1 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetBillStatus
-- --------------------------------------------------
CREATE proc [dbo].[SPGetBillStatus]    
@EntryNo as varchar(25)    
as    
 select L.v_no,L.Status ,convert(varchar,L.action_date,109)action_date,L.action_by, I.person_name, Couriered_by,Doc_no
 from bill_status_log L left outer join intranet.risk.dbo.user_login I       
 on L.action_by = I.username      
 where L.v_no= @EntryNo
 order by L.action_date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetBillStatusLog
-- --------------------------------------------------
CREATE proc SPGetBillStatusLog    
@Status varchar(100),    
@Fdate varchar(11),    
@Tdate varchar(11),  
@seg varchar(15)    
as    
if @Seg = 'All'  
begin  
 select a.v_no as [Entry No.], c.acname as [Vendor Name],c.inv_no as [Invoice No],c.Amount as [Amount], a.status as [Status], a.action_date as [Action Date], b.person_name as [Action By], a.couriered_by as [Couriered By], a.doc_no as [Docket No],c.segment  as [Segment],
[Bill Sent To CSO] = case when c.branch_flag =1 then 'Yes' else 'No' end,
[Bill Received By CSO] = case when c.r_flag =1 then 'Yes' else 'No' end,
[Cheque Created By CSO] = case when c.cso_flag =1 then 'Yes' else 'No' end,
[Cheque Dispatched By CSO] = case when c.comp_flag =1 then 'Yes' else 'No' end,
[Bill Received By Branch] = case when c.r_flag1 =1 then 'Yes' else 'No' end   
 from     
 bill_status_log A (nolock), intranet.risk.dbo.user_login b, billmaster c (nolock)    
 where     
 a.v_no = c.v_no     
 and b.username=a.action_by    
 and    
 a.status = @Status     
 and a.action_date >= convert(datetime,@Fdate +' 00:00:00.000',103)    
 and    
 a.action_date <= convert(datetime,@Tdate +' 23:59:59.999',103)    
end  
else  
begin  
 select a.v_no as [Entry No.], c.acname as [Vendor Name],c.inv_no as [Invoice No],c.Amount as [Amount], a.status as [Status], a.action_date as [Action Date], b.person_name as [Action By], a.couriered_by as [Couriered By], a.doc_no as [Docket No],c.segment as [Segment],
[Bill Sent To CSO] = case when c.branch_flag =1 then 'Yes' else 'No' end,
[Bill Received By CSO] = case when c.r_flag =1 then 'Yes' else 'No' end,
[Cheque Created By CSO] = case when c.cso_flag =1 then 'Yes' else 'No' end,
[Cheque Dispatched By CSO] = case when c.comp_flag =1 then 'Yes' else 'No' end,
[Bill Received By Branch] = case when c.r_flag1 =1 then 'Yes' else 'No' end
 from     
 bill_status_log A (nolock), intranet.risk.dbo.user_login b, billmaster c (nolock)    
 where     
 a.v_no = c.v_no     
 and b.username=a.action_by    
 and    
 a.status = @Status     
 and a.action_date >= convert(datetime,@Fdate +' 00:00:00.000',103)    
 and    
 a.action_date <= convert(datetime,@Tdate +' 23:59:59.999',103)   
 and  
 c.segment = @seg   
end  
--exec SPGetBillStatusLog 'Cheque Created','13/03/2009','13/03/2009','all'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetBillStatusLog_Demo
-- --------------------------------------------------
CREATE proc SPGetBillStatusLog_Demo     
@Status varchar(100),      
@Fdate varchar(11),      
@Tdate varchar(11),    
@seg varchar(15),
@User varchar(20)      
as      
if @Seg = 'All' 
begin
	set @seg = '%'
end   

if @User = 'All' 
begin
	set @User = '%'
end  
    
 select a.v_no as [Entry No.], c.acname as [Vendor Name],c.inv_no as [Invoice No],c.Amount as [Amount], a.status as [Status], a.action_date as [Action Date], b.person_name as [Action By], a.couriered_by as [Couriered By], a.doc_no as[Docket No],c.segment
as [Segment],  
[Bill Sent To CSO] = case when c.branch_flag =1 then 'Yes' else 'No' end,  
[Bill Received By CSO] = case when c.r_flag =1 then 'Yes' else 'No' end,  
[Cheque Created By CSO] = case when c.cso_flag =1 then 'Yes' else 'No' end,  
[Cheque Dispatched By CSO] = case when c.comp_flag =1 then 'Yes' else 'No' end,  
[Bill Received By Branch] = case when c.r_flag1 =1 then 'Yes' else 'No' end     
 from       
 bill_status_log A (nolock), intranet.risk.dbo.user_login b, billmaster c (nolock)      
 where       
 a.v_no = c.v_no       
 and b.username=a.action_by      
 and      
 a.status = @Status       
 and a.action_date >= convert(datetime,@Fdate +' 00:00:00.000',103)      
 and      
 a.action_date <= convert(datetime,@Tdate +' 23:59:59.999',103)      
 and    
 c.segment like @seg 
 and         
 a.action_by like @user
--exec SPGetBillStatusLog 'Cheque Created','12/05/2009','13/05/2009','All',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetBranches
-- --------------------------------------------------

CREATE proc SPGetBranches
@Branch varchar(50)
as
If @Branch = ''
Begin
Select Distinct Branch from branch_details (nolock)
End
Else
Begin
Select Distinct Sub_Branch from branch_details (nolock) where Branch = @Branch
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetCMSCount
-- --------------------------------------------------
CREATE proc SPGetCMSCount --Exec SPGetCMSCount '01/03/2008','27/04/2008'         
@Fdate varchar(11), @Tdate varchar(22)        
as        
        
         
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))          
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))+' 23:59:59'          
        
--select distinct segment into #t        
--from paymentmaster         
--order by segment        
select distinct v.segment into #t        
from paymentmaster   p  
full outer join
vouchermaster v  
on  p.segment=v.segment
order by segment
     
select Segment, count(pv_no) as [No. Of CMS]  into #CMS0  
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and cms_status = '0'        
group by segment       
  
select Segment, count(pv_no) as [No. Of CMS]  into #CMS1  
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and cms_status = '1'        
group by segment       
  
select Segment, count(pv_no) as [No. Of PV]  into #PV0 
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and status = '0'        
group by segment       
  
select Segment, count(pv_no) as [No. Of PV]  into #PV1 
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and status = '1'        
group by segment  
  
select Segment, count(*) as [No. Of JV]   into #JV0 
from vouchermaster           
where entry_date >= @fdate and entry_date<= @tdate and status = '0'
group by segment 

select Segment, count(*) as [No. Of JV]   into #JV1  
from vouchermaster           
where entry_date >= @fdate and entry_date<= @tdate and status = '1'
group by segment 

select #t.*, isnull(#CMS0.[No. Of CMS],0) as [Non Generated], isnull(#CMS1.[No. Of CMS],0) as [Generated], convert(int,isnull(#CMS0.[No. Of CMS],0))+convert(int,isnull(#CMS1.[No. Of CMS],0)) as [TOTAL],
isnull(#PV0.[No. Of PV],0) as [Non Generated PV], isnull(#PV1.[No. Of PV],0) as [Generated PV], convert(int,isnull(#PV0.[No. Of PV],0))+convert(int,isnull(#PV1.[No. Of PV],0)) as [PV TOTAL],
isnull(#JV0.[No. Of JV],0) as [Non Generated JV], isnull(#JV1.[No. Of JV],0) as [Generated JV], convert(int,isnull(#JV0.[No. Of JV],0))+convert(int,isnull(#JV1.[No. Of JV],0)) as [JV TOTAL]
from #t  
left outer join  
 #CMS0  
on #t.segment = #CMS0.segment  
left outer join  
 #CMS1  
on #t.segment = #CMS1.segment    
left outer join  
#PV0  
on #t.segment = #PV0.segment  
left outer join  
#PV1  
on #t.segment = #PV1.segment 
left outer join  
#JV0
on #t.segment = #JV0.segment 
left outer join  
#JV1
on #t.segment = #JV1.segment 
/*  
select #t.*,isnull(b.[No. Of CMS],0) as [No. Of CMS] from #t        
left outer join        
(select Segment, count(pv_no) as [No. Of CMS]            
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and cms_status = '0'        
group by segment)b         
on #t.segment = b.segment  
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetEditEntry
-- --------------------------------------------------
CREATE proc [dbo].[SPGetEditEntry]        
@VNo numeric(18, 0),@Vcode varchar(50)        
as        
      
set nocount on                     
set transaction isolation level read uncommitted                              
      
set @vcode = (select vcode from billmaster where v_no = @VNo)        
If @vcode <> 'NEW'        
Begin        
 select b.v_no, b.segment, v.acname, b.longname, b.inv_no, b.st_no, b.pan_no, b.amount, b.adv_amt, b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker, b.remark,b.vcode, b.EID_BRANCH,b.branch, u.person_name, b.due_date, b.chequeDispatchedAt   
 from billmaster B (nolock), Vendormaster V (nolock), intranet.risk.dbo.user_login U        
 where b.v_no=@VNo and b.segment = v.segment and b.vcode = v.cltcode  and b.eid_branch = u.username      
End        
Else        
Begin        
 select b.v_no, b.segment, b.acname, b.longname, b.inv_no, b.st_no, b.pan_no,b.amount, b.adv_amt, b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker, b.remark, b.vcode, b.EID_BRANCH,b.branch ,u.person_name, b.due_date, b.chequeDispatchedAt         
 from billmaster b (nolock), intranet.risk.dbo.user_login U    
 where v_no=@VNo and b.eid_branch = u.username     
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetEditEntry_NoData
-- --------------------------------------------------
CREATE proc [dbo].[SPGetEditEntry_NoData]      
@VNo numeric(18, 0)
as          
        
set nocount on                       
set transaction isolation level read uncommitted                                

declare @Vcode varchar(50) 
set @vcode = (select vcode from billmaster where v_no = @VNo)          
If @vcode <> 'NEW'          
Begin          
 select b.v_no, b.segment,'' as acname,  b.longname, b.inv_no, b.st_no, b.pan_no, b.amount, b.adv_amt, 
b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker, 
b.remark,b.vcode, b.EID_BRANCH,b.branch, u.person_name, b.due_date, b.chequeDispatchedAt     
 from billmaster B (nolock), intranet.risk.dbo.user_login U          
 where b.v_no=@VNo and b.eid_branch = u.username        
End          
Else          
Begin          
 select b.v_no, b.segment, b.acname, b.longname, b.inv_no, b.st_no, b.pan_no,b.amount, 
b.adv_amt, b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, 
b.order_maker, b.remark, b.vcode, b.EID_BRANCH,b.branch ,u.person_name, b.due_date, 
b.chequeDispatchedAt           
 from billmaster b (nolock), intranet.risk.dbo.user_login U      
 where v_no=@VNo and b.eid_branch = u.username       
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetFundEmp
-- --------------------------------------------------
CREATE proc SPGetFundEmp    
@EmpNo varchar(20),    
@JVNo  varchar(20),    
@IONo varchar(20)    
as    
select emp_no + '-' + emp_name from intranet.risk.dbo.emp_info     
where emp_no = @EmpNo    
    
select emp_no + '-' + emp_name from intranet.risk.dbo.emp_info    
where emp_no =    
(    
select exp_empid     
from billmaster     
where v_no = (select io_no from voucher_details where v_no = @JVNo and io_no = @IONo)    
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetFundEmp1
-- --------------------------------------------------
CREATE proc SPGetFundEmp1     
@EmpNo varchar(20),          
@JVNo  varchar(20),          
@IONo varchar(20),
@FY varchar(20)          
as         
  
   
select [emp_no] + '-' + emp_name from intranet.risk.dbo.emp_info         
where [emp_no] = @EmpNo  AND [acntno] is not Null and len(replace([acntno],' ','')) = 14   
  
IF @FY='20102011'
BEGIN  
	Select  [emp_no] + '-' + emp_name from intranet.risk.dbo.emp_info  
	where [emp_no] =(select exp_empid from billmaster where v_no =  
	(select io_no from voucher_details where v_no = @JVNo and io_no = @IONo) ) 
END        
ELSE
BEGIN
	Select  [emp_no] + '-' + emp_name from intranet.risk.dbo.emp_info  
	where [emp_no] =(select exp_empid from Account123.dbo.billmaster where v_no =  
	(select io_no from voucher_details where v_no = @JVNo and io_no = @IONo))          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetFundTranser
-- --------------------------------------------------
CREATE proc SPGetFundTranser                  
@FDate as varchar(11),                  
@TDate as varchar(22),                
@segment as varchar(20)                 
as                  
 /*                 
declare @FDate as varchar(11)                  
declare @TDate as varchar(25)                 
declare @segment as varchar(20)                 
set @Fdate = '01/06/2009'                
set @tdate = '30/06/2009'                
set @segment = 'NSECM'                
*/           
          
select p.io_srno as [IO No.],p.jv_no as [JV No],p.pv_no as [PV No.],p.segment as [Segment],   
e.[emp_no] as [Employee Code], e.emp_name as [Employee Name], e.department as [Department],         
e. designation as [Designation], e.[Joindate] as [Joining Date],                
e.[email] as [Email], e.[acntno] as [Account No.], e.[sr_name] as [HOD],         
e.costcode as [Branch], e.[company] as [Company],  e.LOB as [LOB], --e.Panno as [Pan No],                
p.cheque_no as [Cheque No.], p.Amount as [Amount] into #T                  
From paymentmaster p (nolock),       
(select distinct [emp_no],emp_name,department,designation,[Joindate],[email],[acntno],  
[sr_name],costcode,[company],LOB,      
panno from intranet.risk.dbo.emp_info) e      
where p.paytype = 'T' and p.cms_status = '0' and                  
p.transferto = e.[emp_no]  and p.entry_date > = convert(datetime,@FDate,103)         
and p.entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999' and p.Segment = @segment          
AND e.[acntno] is not Null and len(replace(e.[acntno],' ','')) = 14        
order by  e.[emp_no]    
                  
update paymentmaster set cms_status = '1'                   
where pv_no in (select [PV No.] from #T)                  
                  
select  [Account No.] as [Account], 'C' as [Credit], convert(int,Amount) as [Amount],                 
'Reimbursed To '+[Employee Code] as [Narration] from #T                
                
select count(*) as [Fund Transfer Count] from #T

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetIo_Srno
-- --------------------------------------------------
CREATE proc [dbo].[SPGetIo_Srno]  
@pvno varchar(20),@io_no varchar(20)  
as  

set nocount on               
set transaction isolation level read uncommitted                        

set @io_no = (select io_srno from paymentmaster (nolock) where pv_no=@pvno)  
select @io_no  
update billmaster set cso_date='', eid_cso='',pay_amount=0,cheque_no=''  
where v_no=@io_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetJVCount
-- --------------------------------------------------
CREATE proc SPGetJVCount --Exec SPGetjVCount '01/03/2008','27/04/2008'      
@Fdate varchar(11), @Tdate varchar(22)      
as      
      
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))      
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))+' 23:59:59'      
      
    
select distinct segment into #t    
from vouchermaster     
order by segment    
    
select #t.*,isnull(b.[No. Of JVs],0) as [No. Of JVs] from #t    
left outer join    
(select Segment, count(v_no) as [No. Of JVs]        
from vouchermaster       
where entry_date >= @fdate and entry_date<= @tdate      
group by segment)b    
on #t.segment = b.segment

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetJVDetails
-- --------------------------------------------------
CREATE proc [dbo].[SPGetJVDetails]  
@VNO as numeric(18,0),@Segment varchar(25),@Vcode varchar(25)  
as  
if @segment = (select segment from vouchermaster where v_no=@VNO)   
and @Vcode = (select ven_code from vouchermaster where v_no=@VNO)  
begin  
 select b.amount as [IOAmt],b.longname as [IO LongName],a.* from (select VM.segment,VM.inv_no,VM.ven_name,VM.ven_code,VM.narration,VM.total ,V.longname, VE.br_tag, vd.io_no  
 from  vouchermaster (nolock) VM, vendormaster V , VoucherEntry VE, voucher_details vd  
 where VM.ven_code =V.cltcode and VM.segment=V.segment and vm.ven_code = ve.v_code and vm.v_no = ve.v_no and  
 vd.v_no = vm.v_no and  VM.v_no =@VNO)a left outer join billmaster b on a.io_no = b.v_no  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetMultiPayIO
-- --------------------------------------------------

--exec [SPGetMultiPayIO] 37997,''
--select * from Multipayment where io_srno=37997
--33778	36841	37997	1045978970	461	MAHIM        

CREATE proc [dbo].[SPGetMultiPayIO]      
@IONo as varchar(15),@PVNo as varchar(15)      
as      
set @PVNo =(select io_srno from multipayment where io_srno=@IONo)      
if @PVNo <>''      
begin      
 select M.pvno  as [PV], M.jvno as [JV], p.narration as [Narration],p.v_name_f as [VName], p.v_code as [Vcode]      
 From Multipayment M, PaymentMaster P      
 Where M.pvno = p.pv_no and m.io_srno = @IONo      
end      
else      
begin      
 select pv_no as [PV],jv_no as [JV],narration as [Narration],v_name_f as [VName],v_code as [Vcode]      
 from paymentmaster(nolock)       
 where io_srno=@IONo      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetPayTypeReport
-- --------------------------------------------------

CREATE proc SPGetPayTypeReport    
@Fdate as datetime, @Tdate as Datetime, @Type as varchar(10)    
as    
select p.pv_no as [PV NO.], p.Entry_date as [Entry Date], p.v_name_f as [Vendor Name], p.v_code as [Vendor Code], p.br_tag as [Branch], p.Narration, cheque_no as [Cheque No.], p.amount as [Amount], p.inv_no as [Invoice No.], p.jv_no as [JV NO.], p.Segment
  
, i.emp_name    
from paymentmaster p, intranet.risk.dbo.emp_info i     
where entry_date >= convert(datetime,@Fdate) and entry_date <= convert(datetime,@Tdate)+' 23:59:59' and paytype = @Type and p.emp_id = i.emp_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetPVCount
-- --------------------------------------------------
CREATE proc SPGetPVCount  --Exec SPGetPVCount '01/03/2008','27/04/2009'            
@Fdate varchar(11), @Tdate varchar(22)            
as            
            
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))            
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))+' 23:59:59'            
            
select distinct v.segment into #t        
from paymentmaster   p  
full outer join
vouchermaster v  
on  p.segment=v.segment
order by segment         
          
select segment, count(pv_no) as [n] into #n            
from paymentmaster            
where paytype = 'n' and  entry_date >= @Fdate and entry_date<= @Tdate            
group by segment            
            
select segment, count(pv_no) as Adv into #a            
from paymentmaster            
where paytype = 'a' and  entry_date >= @Fdate and entry_date<= @Tdate            
group by segment            
            
select segment, count(pv_no) as m into #m            
from paymentmaster            
where paytype = 'm' and  entry_date >=@Fdate and entry_date<= @Tdate            
group by segment            
            
--select isnull(#n.segment,isnull(#a.segment,#m.segment)) as [Segment],isnull(#n.n,0) as [Normal Payment],isnull(#a.adv,0) as [Advance Payment],isnull(#m.m,0) as [Multi Payment] from #n full outer join #a             
--on #n.segment = #a.segment            
--full outer join #m            
--on #n.segment = #m.segment          
          
select #t.*,isnull(#n.n,0) as [Normal],isnull(#a.adv,0) as [Advance], isnull(#m.m,0) as [Multi], convert(int,isnull(#n.n,0))+convert(int,isnull(#a.adv,0))+convert(int,isnull(#m.m,0)) as [TOTAL]     
from #t       
left outer join          
#n on #t.segment= #n.segment          
left outer join          
#a on #t.segment= #a.segment          
left outer join          
#m on #t.segment= #m.segment

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetServiceTaxRegister
-- --------------------------------------------------
CREATE proc [dbo].[SPGetServiceTaxRegister]    
@Fdate as varchar(20),@Tdate as varchar(20)    
as   
  
set nocount on                 
set transaction isolation level read uncommitted                          
   
select vm.v_date as [V Date],     
vm.v_no as [JV No],     
vm.inv_no as [Invoice No],     
vm.ven_name as [Vendor Name],     
v.add1+','+v.add2+','+v.add3 as [Address],     
v.st_no as [ST No],     
v.Pan_no as [PAN NO.],  
v.services as [Nature],     
vd.bill_amount as [Value],     
vd.st as [ST 12%],     
vd.ct as [CT 2%],     
vd.she as [SHE 1%],     
--vd.st_cr as [ST Cr],      
(vd.st+ vd.ct+vd.she) as [Total],     
vm.narration as [Narration],    
vd.io_no as [I/O No],    
vm.segment as [Segment]    
from voucher_details vd, vouchermaster vm, vendormaster v    
where vd.v_no=vm.v_no and vm.segment = v.segment     
and v.cltcode = vm.ven_code and     
vm.v_date >= convert(varchar(11),convert(datetime,@Fdate),103) and vm.v_date <=convert(varchar(11),convert(datetime,@Tdate),103)    
order by vm.v_no desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPGetStatusReport
-- --------------------------------------------------
CREATE proc [dbo].[SPGetStatusReport]  
@Status varchar(100)  
as  

set nocount on               
set transaction isolation level read uncommitted                        

select bm.v_no as [Entry No.], bm.branch as [Branch], bm.vcode as [Vendor Code], bm.inv_no as [Invoice No.], bm.amount as [Amount]   
from billmaster bm (nolock), bill_status_log sl (nolock) 
where bm.v_no = sl.v_no and sl.status = @status

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPInsertMultiPay
-- --------------------------------------------------
CREATE proc [dbo].[SPInsertMultiPay]    
@pvno as varchar(60),    
@Date as varchar(50),    
@VName as varchar(100),    
@Cheque as varchar(100),    
@VCode as varchar(100),    
@Branch as varchar(100),    
@Narration as varchar(100),    
@BankName as varchar(100),    
@BankCode as varchar(100),    
@ChequeNo as varchar(100),    
@Payment numeric(18,0),    
@Seg as varchar(100),    
@Uid as varchar(30)    
as    
--Insert in Paymentmaster(1 Value) Io = 0,Multipay    
insert into PaymentMaster values(getdate(),@Date,@VName,@Cheque,@VCode,@Branch,@Narration,@BankName,@BankCode,@ChequeNo,@Payment,'MultiPay',0,@Seg,@Uid,'0','0',0,'M','0')    
--Get PVNo    
set @pvno = (Select top 1 PV_no from paymentmaster order by entry_date desc)    
select @pvno    
--Insert into Multipayment (All Values)    
-- update in billmaster  (All Values)    
--insert in bill_status_log  (All Values)    
    
    
--SPInsertMultiPay '','3/1/2009','KESHAV INFOTECH','KESHAV INFOTECH','27000180','XS','KESHAV INFOTECH FOR KEYBOARD EXP. INV. NO. KE-11/02 BRANCH : XS','HDFC BK','02095','0123456','400','BSECM','E06135'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPRevokeFund
-- --------------------------------------------------
CREATE proc SPRevokeFund    
@FDate as varchar(11),        
@TDate as varchar(22),      
@segment as varchar(20)     
as    
    
update paymentmaster set cms_status = '0'    
where pv_no in     
(    
select distinct PV_no from paymentmaster (nolock)    
where paytype = 'T' and cms_status = '1' and        
entry_date > = convert(datetime,@FDate,103) and entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999' and Segment = @segment        
)    
    
select count(distinct PV_no) from paymentmaster (nolock) 
where paytype = 'T' and cms_status = '1' and        
entry_date > = convert(datetime,@FDate,103) and entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999' and Segment = @segment

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPShowDeletePayment
-- --------------------------------------------------
CREATE proc [dbo].[SPShowDeletePayment]  
@ChequeNo varchar(15)--,@PVNo varchar(15)  
as  
  
Select P.pv_no as [PV No.], p.inv_no as [Invoice No.], p.br_tag as [Branch Tag], p.Segment as [Segment], p.v_name_s as [Vendor Name], p.v_code as [Vendor Code], p.v_name_f as [Cheque Name], p.Cheque_no as [Cheque No.], p.Narration as [Narration], p.amount
 as [Paid Amount], p.bank_name as [Bank Name], p.jv_no as [JV No.], p.entry_date as [Entry Date], p.date as [Effective Date], L.uname as [Login ID], p.status as [CSV Status], p.cms_status as [CMS Status], p.io_srno as [IO SrNo.],v.action_time as [Deleted 
Date/Time], L1.uname as [Deleted By]  
From paymentmaster_deleted P (nolock), login_vms L (nolock), login_vms L1 (nolock), voucher_delete_log V (nolock)  
where P.emp_id = L. Uid and v.uid = L1.uid and p.pv_no = v.pv_no and cheque_no = @ChequeNo  
order by  P.pv_no desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPTotalCount
-- --------------------------------------------------
CREATE proc SPTotalCount  
@fdate varchar(11),  
@tdate varchar(22)  
as  
--declare @fdate varchar(11)  
--declare @tdate varchar(22)  
  
truncate table t  
  
--set @fdate = '01/07/2009'  
--set @tdate = '31/07/2009' 
  
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))              
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))+' 23:59:59'              
  
declare @Segment int  
declare @Segment1 int  
  
    
set @segment = (select count(distinct segment) as [Pay] from paymentmaster)  
set @segment1 = (select count(distinct segment) as [Vou] from vouchermaster)  
  
if @segment > @segment1   
begin  
 insert into t select distinct segment  
 from paymentmaster  
end  
else  
begin  
 insert into t select distinct segment  
 from vouchermaster  
end  
  
---------------------------JV-----------------------------------------  
select t.*,isnull(b.[No. Of JVs],0) as [No. Of JVs] into #MainJV  
from t        
left outer join        
(select Segment, count(v_no) as [No. Of JVs]            
from vouchermaster           
where entry_date >= @fdate and entry_date<= @tdate          
group by segment)b        
on t.segment = b.segment   
  
---------------------------PV---------------------------------------  
select segment, count(pv_no) as [n] into #n              
from paymentmaster              
where paytype = 'n' and  entry_date >= @Fdate and entry_date<= @Tdate              
group by segment              
              
select segment, count(pv_no) as Adv into #a              
from paymentmaster              
where paytype = 'a' and  entry_date >= @Fdate and entry_date<= @Tdate              
group by segment              
              
select segment, count(pv_no) as m into #m              
from paymentmaster              
where paytype = 'm' and  entry_date >=@Fdate and entry_date<= @Tdate              
group by segment                       
            
select t.*,isnull(#n.n,0) as [Normal],isnull(#a.adv,0) as [Advance], isnull(#m.m,0) as [Multi], convert(int,isnull(#n.n,0))+convert(int,isnull(#a.adv,0))+convert(int,isnull(#m.m,0)) as [TOTAL]  into #MainPV  
from t         
left outer join            
#n on t.segment= #n.segment            
left outer join            
#a on t.segment= #a.segment            
left outer join            
#m on t.segment= #m.segment   
  
  
---------------------------CMS---------------------------------------  
         
select Segment, count(pv_no) as [No. Of CMS]  into #CMS0      
from paymentmaster               
where entry_date >= @fdate and entry_date<= @tdate and cms_status = '0'            
group by segment           
      
select Segment, count(pv_no) as [No. Of CMS]  into #CMS1      
from paymentmaster               
where entry_date >= @fdate and entry_date<= @tdate and cms_status = '1'            
group by segment           
      
select Segment, count(pv_no) as [No. Of PV]  into #PV0     
from paymentmaster               
where entry_date >= @fdate and entry_date<= @tdate and status = '0'            
group by segment           
      
select Segment, count(pv_no) as [No. Of PV]  into #PV1     
from paymentmaster               
where entry_date >= @fdate and entry_date<= @tdate and status = '1'            
group by segment      
      
select Segment, count(*) as [No. Of JV]   into #JV0     
from vouchermaster               
where entry_date >= @fdate and entry_date<= @tdate and status = '0'    
group by segment     
    
select Segment, count(*) as [No. Of JV]   into #JV1      
from vouchermaster               
where entry_date >= @fdate and entry_date<= @tdate and status = '1'    
group by segment   

---------------------------Fund Transfer-----------------------------------------  
select t.*,isnull(b.[No. Of FTs],0) as [No. Of FTs] into #FT  
from t        
left outer join        
(select Segment, count(pv_no) as [No. Of FTs]            
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and paytype='T' and cms_status = '1'    
group by segment)b        
on t.segment = b.segment  

select t.*,isnull(b.[No. Of FTs],0) as [No. Of FTs] into #FT1  
from t        
left outer join        
(select Segment, count(pv_no) as [No. Of FTs]            
from paymentmaster           
where entry_date >= @fdate and entry_date<= @tdate and paytype='T' and cms_status = '0'    
group by segment)b        
on t.segment = b.segment  
 
--------------------------------Main Select----------------------------------   
select t.*,  
isnull(#MainJV.[No. Of JVs],0) as [No Of JVs],  
isnull(#MainPV.[Normal],0) as [Normal],   
isnull(#MainPV.[Advance],0) as [Advance],   
isnull(#MainPV.[Multi],0) as [Multi],   
convert(int,isnull(#MainPV.[Normal],0))+convert(int,isnull(#MainPV.[Advance],0))+convert(int,isnull(#MainPV.[Multi],0)) as [TOTAL] ,  
isnull(#CMS0.[No. Of CMS],0) as [NG-CMS],   
isnull(#CMS1.[No. Of CMS],0) as [G-CMS],   
convert(int,isnull(#CMS0.[No. Of CMS],0))+convert(int,isnull(#CMS1.[No. Of CMS],0)) as [CMS-TOTAL],    
isnull(#PV0.[No. Of PV],0) as [NG-PV],   
isnull(#PV1.[No. Of PV],0) as [G-PV],   
convert(int,isnull(#PV0.[No. Of PV],0))+convert(int,isnull(#PV1.[No. Of PV],0)) as [PV-TOTAL],    
isnull(#JV0.[No. Of JV],0) as [NG-JV],   
isnull(#JV1.[No. Of JV],0) as [G-JV],   
convert(int,isnull(#JV0.[No. Of JV],0))+convert(int,isnull(#JV1.[No. Of JV],0)) as [JV-TOTAL],
isnull(#FT1.[No. Of FTs],0) as  [NG-FT],
isnull(#FT.[No. Of FTs],0) as  [G-FT],  
convert(int,isnull(#FT.[No. Of FTs],0))+convert(int,isnull(#FT1.[No. Of FTs],0)) as [FT-TOTAL]
from t      
left outer join      
 #CMS0      
on t.segment = #CMS0.segment      
left outer join      
 #CMS1      
on t.segment = #CMS1.segment        
left outer join      
#PV0      
on t.segment = #PV0.segment      
left outer join      
#PV1      
on t.segment = #PV1.segment     
left outer join      
#JV0    
on t.segment = #JV0.segment     
left outer join      
#JV1    
on t.segment = #JV1.segment     
left outer join  
#MainJV  
on t.segment = #MainJV.segment    
left outer join  
#MainPV  
on t.segment = #MainPV.segment
left outer join  
#FT1 
on t.segment = #FT1.segment
left outer join  
#FT 
on t.segment = #FT.segment    
order by t.segment

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPUpdateBillEntry
-- --------------------------------------------------
CREATE proc [dbo].[SPUpdateBillEntry]        
@Vno numeric(18, 0),@Seg varchar(15),@OldVendor varchar(100),@NewVendor varchar(100),
@Cheque varchar(100),@InvNo varchar(60),@STno varchar(50),@PAN varchar(50),
@Amt numeric(18, 0),@AdvAmt numeric(18, 0),@AdvCheque varchar(50),@ExpToBr varchar(50),
@ExpFdt varchar(100),@ExpTdt varchar(100),@DispatchTo varchar(50),@Emp varchar(50),
@OrderMake varchar(100),@Remark varchar(60),@Vcode varchar(60), @duedate varchar(50), 
@ChequeDispatchedAt varchar(50)
as        
--if @OldVendor <> 'SELECT'    
--Begin    
 update billmaster set segment=@Seg, acname=@NewVendor, vcode=@Vcode, --oldvendor,vendor        
 longname = @Cheque, inv_no = @InvNo, st_no = @STno, pan_no = @PAN, 
amount = @Amt,--clarify the amount field       
 adv_amt = @AdvAmt, adv_cheque_no = @AdvCheque, br_tag = @ExpToBr, 
exp_fdt = convert(datetime,@ExpFdt,103), exp_tdt = convert(datetime,@ExpTdt,103), 
dest_branch = @DispatchTo, exp_empid = @Emp, order_maker = @OrderMake, remark = @remark,
due_date = convert(datetime,@duedate,103), chequedispatchedAt = @ChequeDispatchedAt
 where v_no = @Vno        
--End    
--Else    
--Begin    
-- update billmaster set segment=@Seg, acname=@NewVendor, --oldvendor,vendor        
-- longname = @Cheque, inv_no = @InvNo, st_no = @STno, pan_no = @PAN, pay_amount = @Amt,--clarify the amount field       
-- adv_amt = @AdvAmt, adv_cheque_no = @AdvCheque, br_tag = @ExpToBr, exp_fdt = convert(datetime,@ExpFdt,103), exp_tdt = convert(datetime,@ExpTdt,103), dest_branch = @DispatchTo, exp_empid = @Emp, order_maker = @OrderMake, remark = @remark        
-- where v_no = @Vno        
--End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_CMS_LOCATION
-- --------------------------------------------------
CREATE Procedure Upd_CMS_LOCATION
as
set nocount on

select Branch_Code,Branch into #Nbr from RISK.dbo.Branches where Branch_Code not in 
(
select Branch_Tag from Angelvms.dbo.CMS_LOCATION
)

select a.*,isnull(b.Reg_Code,'') as Reg_Code,isnull(B.Region,'') as Region Into #Tbl1 from #NBR a left outer Join Risk.dbo.Region b 
on  a.Branch_Code=b.Code

select a.*,isnull(b.BrMast_Cd,'') as BrMast_Cd ,Print_Loc=Space(20),Drawee_CD=Space(20),
Print_Cd=Space(20),UpadedOn=getdate(),UpadateBy='SYSTEM',CSO_BranchTag=Space(20) into #CMS_LOC from #Tbl1 a 
left outer join  RISK.DBO.Branch_Master b on a.Branch_Code=b.Branch_CD

update #CMS_LOC set #CMS_LOC.Print_LOC=b.Print_LOCa,#CMS_LOC.Drawee_CD=b.DRAWEE_CD,#CMS_LOC.Print_Cd=b.Print_Cd,
#CMS_LOC.CSO_BRANCHTAG=''
from RISK.DBO.CMSBR b where #CMS_LOC.Branch_Code=b.sbtag


declare @tname as varchar(50)
declare @str as varchar(1000)
set @tname='CMS_LOCATION_'+convert(varchar(11),getdate(),112)
--Print @tname
set @str= ''
set @str= @str+ 'select * into '+@tname+' from CMS_LOCATION'
exec (@str)

insert into CMS_LOCATION
select * from #CMS_LOC


set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis
-- --------------------------------------------------
CREATE PROCEDURE usp_brmis                
(                                           
@filter_type as varchar(10),                    
@access_to as varchar(25),                                          
@access_code as varchar(25),                              
@param1 as varchar(60),                          
@param2 as varchar(60),                               
@param3 as varchar(60)                            
                
)                                            
as                                             
declare @str as varchar(2000)                              
declare @filter as varchar(600)                              
declare @access_query as varchar(600)                              
declare @final as varchar(5000)                              
declare @post as varchar(500)                             
declare @fdt as varchar(30)                    
declare @tdt as varchar(30)                     
                
set @str=''                 
set @str=@str+'select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,'                
set @str=@str+'a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,a.br_tag,'                
set @str=@str+'a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,'                
set @str=@str+'a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,'                
set @str=@str+'c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,'                
set @str=@str+'a.courier_name1,a.doc_no1,a.br_date,a.dest_branch,convert (varchar(11),a.due_date,103) as due_date,a.chequedispatchedat from billmaster a (nolock) inner join '               
set @str=@str+'intranet.risk.dbo.user_login b on a.eid_branch=b.username inner join '                
set @str=@str+' intranet.risk.dbo.user_login c on a.eid_cso=c.username'                
                
if @filter_type='1'                              
begin                      
                
set @filter=''                              
set @filter=@filter+' where a.dis_date>=convert(datetime,'''+@param1+''',103) and a.dis_date<=convert(datetime,'''+@param2+''',103) and eid_branch  like '''+@param3+''''                             
end                              
else if @filter_type='2'                
begin                
set @filter=''                              
set @filter=@filter+' where a.inv_no ='''+@param1+''''                
end                
else if @filter_type='3'                
begin                   
set @filter=''                              
set @filter=@filter+' where a.segment ='''+@param1+''' and a.acname='''+@param2+''' and a.vcode='''+@param3+''''                
end                
                   
else if @filter_type='4'                
begin                
set @filter=''                       
set @filter=@filter+' where a.d_date>=convert(datetime,'''+@param1+''',103) and a.d_date<=convert(datetime,'''+@param2+''',103) and eid_branch  like '''+@param3+''''                
                
end                
                
else if @filter_type='5'                
begin                   
set @filter=''                  
set @filter=@filter+' where courier_name1 ='''+@param1+''' and doc_no1='''+@param2+''''                
end                
else if @filter_type='6'                
begin                   
set @filter=''                
set @filter=@filter+' where a.cheque_no='''+@param1+''''                
end                
else if @filter_type='7'                
begin                   
set @filter=''                
set @filter=@filter+' where a.longname like ''%'+@param1+'%'''                  
end                
else if @filter_type='8'                
begin                   
set @filter=''                  
set @filter=@filter+' where a.segment ='''+@param1+''' and a.vcode='''+@param2+''''                
end                
                
else if @filter_type='9'                
begin                   
set @filter=''                  
set @filter=@filter+' where Courier_name1 = ''CHEQUE PRINTED AT BRANCH LOCATION'' and cso_flag=''1''          
and d_date=convert(datetime,'''+@param1+''',103) '      
              
end             
          
          
if @access_to='BRANCH'                                
                 
begin                                          
set @access_query=''                                
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by a.v_no '                              
end                 
                
else if @access_to='REGION'                                            
begin                              
set @access_query=''                               
set @access_query=@access_query+' and (a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''') or a.branch='''+@access_code+''') order by a.v_no'                                
end                  
                
else if @access_to='BRMAST'                                          
begin                              
set  @access_query=''                                
set  @access_query=@access_query+' and  (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or a.branch='''+@access_code+''') order by a.V_NO '                              
end                    
                         
else if @access_to='BROKER'                                          
begin                              
set  @access_query=''                                
set  @access_query=@access_query+' and  a.branch like '''+@access_code+''' order by a.V_NO '                              
end                     
                
                
set @final=''                    
set @final=@final+@str+@filter+@access_query                    
--print(@final)                    
exec(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_acname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_acname]  
(              
@seg as varchar(10),@acname as varchar(85),@vcode as varchar(12), @str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode and a.branch=@str2 order by a.v_no  
  
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode and a.branch=@str2 order by a.v_no    
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_bdt
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_bdt]     
(              
@fdt as datetime,@tdt as datetime,@str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.eid_branch,a.branch,b.person_name,a.acname,a.longname,  
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,  
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)  
as d_date,a.courier_name1,a.doc_no1,a.br_date from   
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on   
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on   
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt and a.branch=@str2 order by a.v_no  
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.eid_branch,a.branch,b.person_name,a.acname,a.longname,  
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,  
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)  
as d_date,a.courier_name1,a.doc_no1,a.br_date from   
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on   
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on   
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.eid_branch,a.branch,b.person_name,a.acname,a.longname,  
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,  
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)  
as d_date,a.courier_name1,a.doc_no1,a.br_date from   
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on   
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on   
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt and a.branch=@str2 order by a.v_no    
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.eid_branch,a.branch,b.person_name,a.acname,a.longname,  
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,  
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)  
as d_date,a.courier_name1,a.doc_no1,a.br_date from   
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on   
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on   
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_cno
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_cno]  
(              
@cno as varchar(15),@str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join 
intranet.risk.dbo.user_login b on a.eid_branch=b.username inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where a.cheque_no=@cno and a.branch=@str2
order by a.v_no
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join 
intranet.risk.dbo.user_login b on a.eid_branch=b.username inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where a.cheque_no=@cno and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.v_no        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join 
intranet.risk.dbo.user_login b on a.eid_branch=b.username inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where a.cheque_no=@cno and a.branch=@str2 order by a.v_no
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join 
intranet.risk.dbo.user_login b on a.eid_branch=b.username inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where a.cheque_no=@cno 
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_crname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_crname]     
(              
@crname as varchar(60) ,@dcno as varchar(20),@str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,a.eid_cso,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) 
inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username  
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username where 
courier_name1 =@crname and doc_no1=@dcno and a.branch=@str2
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,a.eid_cso,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) 
inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username  
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username where 
courier_name1 =@crname and doc_no1=@dcno and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,a.eid_cso,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) 
inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username  
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username where 
courier_name1 =@crname and doc_no1=@dcno and a.branch=@str2 order by a.v_no    
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,a.eid_cso,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) 
inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username  
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username where 
courier_name1 =@crname and doc_no1=@dcno 
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_csodt
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_csodt]     
(              
@fdt as datetime,@tdt as datetime,@str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103)
 as dis_date,a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,
a.pay_amount,a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from 
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b 
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on 
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt and a.branch=@str2 order by a.v_no  

end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103)
 as dis_date,a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,
a.pay_amount,a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from 
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b 
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on 
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103)
 as dis_date,a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,
a.pay_amount,a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from 
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b 
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on 
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt and a.branch=@str2 order by a.v_no    
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103)
 as dis_date,a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,
a.pay_amount,a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from 
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b 
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on 
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt  
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_inv
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_inv]  
(              
@inv as varchar(50),@str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,  
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,  
convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,  
convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock)   
inner join  intranet.risk.dbo.user_login b   
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c   
on a.eid_cso=c.username where a.inv_no =@inv and a.branch=@str2 order by a.v_no  
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,  
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,  
convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,  
convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock)   
inner join  intranet.risk.dbo.user_login b   
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c   
on a.eid_cso=c.username where a.inv_no =@inv  and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,  
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,  
convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,  
convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock)   
inner join  intranet.risk.dbo.user_login b   
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c   
on a.eid_cso=c.username where a.inv_no =@inv  and a.branch=@str2 order by a.v_no    
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,  
a.inv_no,a.bill_date,a.amount,a.pan_no,a.st_no,  
convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,  
a.cheque_no,a.eid_cso,c.person_name as pname,  
convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock)   
inner join  intranet.risk.dbo.user_login b   
on a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c   
on a.eid_cso=c.username where a.inv_no =@inv  
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_lname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_brmis_lname]  
(              
@lname as varchar(50),@str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join  
intranet.risk.dbo.user_login b on a.eid_branch=b.username  inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where 
a.longname like @lname and a.branch=@str2
order by a.v_no
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join  
intranet.risk.dbo.user_login b on a.eid_branch=b.username  inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where a.longname like @lname and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.v_no        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join  
intranet.risk.dbo.user_login b on a.eid_branch=b.username  inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where 
a.longname like @lname and a.branch=@str2 order by a.v_no
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,
a.bill_date,a.amount,a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,
a.courier_name,a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join  
intranet.risk.dbo.user_login b on a.eid_branch=b.username  inner join 
intranet.risk.dbo.user_login c on a.eid_cso=c.username where a.longname like @lname
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_brmis_vcode
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_brmis_vcode]  
(              
@seg as varchar(10),@vcode as varchar(12), @str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.vcode=@vcode and a.branch=@str2 order by a.v_no  
  
end              
        
 if @str1='region'               
begin          
         
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.vcode=@vcode and   
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)   
 order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.vcode=@vcode and a.branch=@str2 order by a.v_no    
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,a.branch,a.eid_branch,b.person_name,a.acname,a.longname,a.vcode,  
a.segment,a.inv_no,a.bill_date,a.amount,a.pan_no,  
a.st_no,convert (varchar(11),a.dis_date,103) as dis_date,a.courier_name,  
a.doc_no,a.r_date,a.in_status,a.cso_date,a.pay_amount,a.cheque_no,a.eid_cso,  
c.person_name as pname,convert (varchar(11),a.d_date,103) as d_date,  
a.courier_name1,a.doc_no1,a.br_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username   
where a.segment =@seg and a.vcode=@vcode
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)   
order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_byusername
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_byusername]     
(                
@str1 as varchar(25),@str2 as varchar(25)                 
)                
 as                 
set nocount on                 
set transaction isolation level read uncommitted                          
                      
if @str1='branch'                 
begin              
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.branch_flag='0' and a.branch=@str2
end                
          
 if @str1='region'                 
begin            
           
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.branch_flag='0' and(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)     

end                
          
if @str1='broker'                 
begin          
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.branch_flag='0' and a.branch=@str2       
end          
if @str1='BRMAST'                
begin             
          
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.branch_flag='0'
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)     

            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_byusername1
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_byusername1]     
(                
@str1 as varchar(25),@str2 as varchar(25)                 
)                
 as                 
set nocount on                 
set transaction isolation level read uncommitted                          
                      
if @str1='branch'                 
begin              
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where  a.r_flag='1'and a.comp_flag='0' and a.branch=@str2
end                
          
 if @str1='region'                 
begin            
           
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.r_flag='1'and a.comp_flag='0' and(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)     

end                
          
if @str1='broker'                 
begin          
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.r_flag='1'and a.comp_flag='0' and a.branch=@str2       
end          
if @str1='BRMAST'                
begin             
          
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
where a.r_flag='1'and a.comp_flag='0'
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)     

            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_byusername2
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_byusername2]       
(                  
@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username   
where  a.r_flag1='0' and a.comp_flag='1'  and a.branch=@str2  
end                  
            
 if @str1='region'                   
begin              
             
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username   
where a.r_flag1='0' and a.comp_flag='1'  and(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)       
  
end                  
            
if @str1='broker'                   
begin            
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username   
where a.r_flag1='0' and a.comp_flag='1'  and a.branch=@str2         
end            
if @str1='BRMAST'                  
begin               
            
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username   
where a.r_flag1='0' and a.comp_flag='1'   
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
  
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Delete_V_No
-- --------------------------------------------------
CREATE proc [dbo].[usp_Delete_V_No]    
@V_No numeric(18,0)    
as  

set nocount on               
set transaction isolation level read uncommitted                        

delete from Billmaster    
where v_no=@V_No

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_dg_dg2_branch
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_dg_dg2_branch]            
(            
@str1 as varchar(25),@str2 as varchar(25)               
)            
 as             
set nocount on             
set transaction isolation level read uncommitted                      
    
if @str1='branch'           
begin      
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,        
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where a.branch=@str2 and a.r_flag='1'and a.comp_flag='0' ORDER BY a.V_NO    
    
          
end          
 if @str1='region'           
begin     
    
    
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,        
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where  a.r_flag='1'and a.comp_flag='0' and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2 ) ORDER BY a.V_NO    
end    
if @str1='broker'           
begin    
    
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,        
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where a.branch=@str2 and a.r_flag='1'and a.comp_flag='0' ORDER BY a.V_NO    
    
end          
if @str1='BRMAST'          
begin          
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,        
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where  a.r_flag='1'and a.comp_flag='0' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2) order by a.V_NO         
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_dg_pay
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_dg_pay]      
(      
@str1 as varchar(25)       
)      
 as       
set nocount on       
set transaction isolation level read uncommitted                
      
      
if @str1 ='ALL'      
begin       
select a.v_no,b.person_name,a.branch,a.br_tag,a.acname,a.vcode,a.longname,  
a.segment,a.inv_no,a.amount,a.in_status,a.pay_amount,a.cheque_no,  
a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as   
dis_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
where a.branch_flag='1' and  a.cso_flag='0' and a.r_flag='1' order by a.v_no  
end       
if @str1 <>'ALL'      
begin    
select a.v_no,b.person_name,a.branch,a.br_tag,a.acname,a.vcode,a.longname,  
a.segment,a.inv_no,a.amount,a.in_status,a.pay_amount,a.cheque_no,  
a.pan_no,a.st_no,convert (varchar(11),a.dis_date,103) as   
dis_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
where a.branch=@str1 and a.branch_flag='1' and  a.cso_flag='0' and a.r_flag='1' order by a.v_no  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_dg2_byname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_dg2_byname]               
(                
@uname as varchar(25),@str1 as varchar(25),@str2 as varchar(25)                   
)                
 as                 
set nocount on                 
set transaction isolation level read uncommitted                          
        
if @str1='branch'               
begin          
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,            
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.eid_branch=@uname and a.branch=@str2 and a.r_flag='1'and a.comp_flag='0' ORDER BY a.V_NO        
        
              
end              
 if @str1='region'               
begin         
        
        
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,            
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.eid_branch=@uname and a.r_flag='1'and a.comp_flag='0' and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2 ) ORDER BY a.V_NO        
end        
if @str1='broker'               
begin        
        
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,            
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.eid_branch=@uname and a.branch=@str2 and a.r_flag='1'and a.comp_flag='0' ORDER BY a.V_NO        
        
end              
if @str1='BRMAST'              
begin              
 select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.amount,a.inv_no,            
a.pan_no,a.st_no,a.in_status,a.pay_amount,a.cheque_no,a.r_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.eid_branch=@uname and a.r_flag='1'and a.comp_flag='0' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2) order by a.V_NO             
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_dgrc_ByUname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_dgrc_ByUname]             
(              
@uname as varchar(25), @str1 as varchar(25),@str2 as varchar(25)               
)              
 as               
set nocount on               
set transaction isolation level read uncommitted                        
                    
if @str1='branch'               
begin            
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,          
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username               
where a.r_flag1='0' and a.comp_flag='1' and a.eid_branch=@uname and a.branch= @str2 ORDER BY a.V_NO         
end              
        
 if @str1='region'               
begin          
         
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,          
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username               
where a.r_flag1='0' and a.comp_flag='1' and a.eid_branch=@uname and(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)  order by a.V_NO        
end              
        
if @str1='broker'               
begin        
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,          
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username               
where a.r_flag1='0' and a.comp_flag='1' and a.eid_branch=@uname and a.branch= @str2 ORDER BY a.V_NO        
end        
if @str1='BRMAST'              
begin           
        
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,          
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join             
intranet.risk.dbo.user_login b on a.eid_branch=b.username               
where a.r_flag1='0' and a.comp_flag='1' and a.eid_branch=@uname and(a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2) order by a.V_NO             
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Disp2cso
-- --------------------------------------------------
 --fdfdfd
CREATE PROCEDURE [dbo].[usp_Disp2cso]      
(                
@str1 as varchar(25),@str2 as varchar(25)                 
)                
 as              
set nocount on                 
set transaction isolation level read uncommitted                          
                
          
          
if @str1='branch'           
begin          
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,      
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on       
a.eid_branch=b.username where a.branch_flag='0' and a.branch=@str2   order by a.V_NO           
          
end          
 if @str1='region'           
begin           
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,      
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on       
a.eid_branch=b.username where a.branch_flag='0' and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2)  order by a.V_NO             
end          
if @str1='broker'           
begin          
          
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,      
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on       
a.eid_branch=b.username where a.branch_flag='0' and a.branch=@str2 order by a.V_NO             
end          
if @str1='BRMAST'          
begin          
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,      
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on       
a.eid_branch=b.username where a.branch_flag='0' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)or a.branch=@str2) order by a.V_NO         
end  
--CREATE PROCEDURE [dbo].[usp_Disp2cso]            
--(                      
--@uname as varchar(40),@str1 as varchar(25),@str2 as varchar(25),@querytype as varchar(1)  
                       
--)                      
-- as     
-- begin                 
--set nocount on                       
--set transaction isolation level read uncommitted                                
--declare @strQry varchar(2000)                      
--set @strQry='select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,            
--a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
--a.eid_branch=b.username where a.branch_flag=''0'''  
----print @strQry                
                
--declare @strClause varchar(500)  
--if @str1='branch'                 
--begin                
-- if @querytype='1'  
-- begin  
-- set @strClause=' and a.eid_branch='''+@uname+''' and a.branch='''+@str2+''' order by a.V_NO'                 
-- end  
-- else  
-- begin  
-- set @strClause=' and a.branch='''+@str2+''' order by a.V_NO  '  
-- end                
--end                
--else if @str1='region'                 
-- begin       
-- if @querytype='1'  
-- begin            
-- set @strClause=' and a.eid_branch='''+@uname+''' and (a.branch in (select code from intranet.risk.dbo.region where reg_code='''+@str2+''') or a.branch='''+@str2+''') order by a.V_NO'                   
-- end    
-- else  
-- begin  
-- set @strClause= ' and (a.branch in (select code from intranet.risk.dbo.region where reg_code='''+@str2+''') or a.branch='''+@str2+''') order by a.V_NO '   
-- end  
--end              
--else if @str1='broker'                 
-- begin                
-- if @querytype='1'  
-- begin                  
-- set @strClause=' and a.eid_branch='''+@uname+''' and a.branch='''+@str2+''' order by a.V_NO'                   
-- end  
-- else  
-- begin  
-- set @strClause=' and a.branch='''+@str2+''' order by a.V_NO'  
-- end  
--end                
--else if @str1='BRMAST'                
-- begin                
-- if @querytype='1'  
-- begin                  
-- set @strClause=' and a.eid_branch='''+@uname+''' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master   
-- where brmast_cd='''+@str2+''')or a.branch='''+@str2+''') order by a.V_NO'               
-- end  
-- else  
-- begin  
--  set @strClause=' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master   
--  where brmast_cd='''+@str2+''')or a.branch='''+@str2+''') order by a.V_NO'           
-- end  
--end  
--set @strQry=@strQry+@strClause  
--exec (@strQry)  
--end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Disp2cso_new
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_Disp2cso_new]            
(                      
@uname as varchar(40),@str1 as varchar(25),@str2 as varchar(25),@querytype as varchar(1)  
                       
)                      
 as     
 begin                 
set nocount on                       
set transaction isolation level read uncommitted                                
declare @strQry varchar(2000)                      
set @strQry='select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,            
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag=''0'''  
--print @strQry                
                
declare @strClause varchar(500)  
if @str1='branch'                 
begin                
 if @querytype='1'  
 begin  
 set @strClause=' and a.eid_branch='''+@uname+''' and a.branch='''+@str2+''' order by a.V_NO'                 
 end  
 else  
 begin  
 set @strClause=' and a.branch='''+@str2+''' order by a.V_NO  '  
 end                
end                
else if @str1='region'                 
 begin       
 if @querytype='1'  
 begin            
 set @strClause=' and a.eid_branch='''+@uname+''' and (a.branch in (select code from intranet.risk.dbo.region where reg_code='''+@str2+''') or a.branch='''+@str2+''') order by a.V_NO'                   
 end    
 else  
 begin  
 set @strClause= ' and (a.branch in (select code from intranet.risk.dbo.region where reg_code='''+@str2+''') or a.branch='''+@str2+''') order by a.V_NO '   
 end  
end              
else if @str1='broker'                 
 begin                
 if @querytype='1'  
 begin                  
 set @strClause=' and a.eid_branch='''+@uname+''' and a.branch='''+@str2+''' order by a.V_NO'                   
 end  
 else  
 begin  
 set @strClause=' and a.branch='''+@str2+''' order by a.V_NO'  
 end  
end                
else if @str1='BRMAST'                
 begin                
 if @querytype='1' 
 begin                  
 set @strClause=' and a.eid_branch='''+@uname+''' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master   
 where brmast_cd='''+@str2+''')or a.branch='''+@str2+''') order by a.V_NO'               
 end  
 else  
 begin  
  set @strClause=' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master   
  where brmast_cd='''+@str2+''')or a.branch='''+@str2+''') order by a.V_NO'           
 end  
end  
set @strQry=@strQry+@strClause  
exec (@strQry)  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Disp2csoByname
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_Disp2csoByname]        
(                  
@uname as varchar(40),@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                
set nocount on                   
set transaction isolation level read uncommitted                            
                  
            
            
if @str1='branch'             
begin            
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,        
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on         
a.eid_branch=b.username where a.branch_flag='0' and a.eid_branch=@uname and a.branch=@str2   order by a.V_NO             
            
end            
 if @str1='region'             
begin             
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,        
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on         
a.eid_branch=b.username where a.branch_flag='0'  and a.eid_branch=@uname and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2)  order by a.V_NO               
end            
if @str1='broker'             
begin            
            
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,        
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on         
a.eid_branch=b.username where a.branch_flag='0' and a.eid_branch=@uname and a.branch=@str2 order by a.V_NO               
end            
if @str1='BRMAST'            
begin            
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,        
a.amount from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on         
a.eid_branch=b.username where a.branch_flag='0' and a.eid_branch=@uname and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)or a.branch=@str2) order by a.V_NO           
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_dispatch_Bill
-- --------------------------------------------------
      
CREATE PROCEDURE usp_dispatch_Bill   
(                                      
@dis_date as datetime,@doc as varchar(50),@crname as varchar(50),@vno as numeric                                       
)                                      
 as                                       
set nocount on                                       
set transaction isolation level read uncommitted               
  
update billmaster set branch_flag ='1',dis_date=@dis_date,  
doc_no=@doc,courier_name=@crname,  
in_status='Bill Dispatched To CSO' where   
v_no=@vno

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_EntryDetailIO
-- --------------------------------------------------
CREATE PROCEDURE usp_EntryDetailIO       
(                      
@vno as varchar(25), @str1 as varchar(25),@str2 as varchar(25)                       
)                      
 as                    
set nocount on                       
set transaction isolation level read uncommitted                                
                      
                
                
if @str1='branch'                 
begin                
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,      
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,      
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,      
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,      
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat    
from billmaster     
where v_no =@vno               
and branch=@str1              
                
end                
 if @str1='region'                 
begin                 
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,      
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,      
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,      
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,      
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat    
from billmaster     
where v_no =@vno               
and branch in (select code from intranet.risk.dbo.region where reg_code=@str2)                
end                
if @str1='broker'                 
begin                
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,      
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,      
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,      
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,      
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat     
from billmaster     
where v_no =@vno                   
               
end                
if @str1='BRMAST'                
begin                
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,      
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,      
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,      
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,      
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat    
from billmaster     
where v_no =@vno AND       
branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)      
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_EntryDetailIO_Deleted
-- --------------------------------------------------
CREATE PROCEDURE usp_EntryDetailIO_Deleted        
(                        
@vno as varchar(25), @str1 as varchar(25),@str2 as varchar(25)                         
)                        
 as                      
set nocount on                         
set transaction isolation level read uncommitted                                  
                        
                  
                  
if @str1='branch'                   
begin                  
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,        
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,        
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,        
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,        
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat      
from billmaster_deleted       
where v_no =@vno                 
and branch=@str1                
                  
end                  
 if @str1='region'                   
begin                   
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,        
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,        
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,        
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,        
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat      
from billmaster_deleted       
where v_no =@vno                 
and branch in (select code from intranet.risk.dbo.region where reg_code=@str2)                  
end                  
if @str1='broker'                   
begin                  
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,        
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,        
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,        
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,        
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat       
from billmaster_deleted       
where v_no =@vno                     
                 
end                  
if @str1='BRMAST'                  
begin                  
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,        
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,        
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,        
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,        
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch,convert(varchar(11),exp_fdt,103),convert(varchar(11),exp_tdt,103),lob,adv_amt,adv_cheque_no,order_maker,convert(varchar(11),due_date,103),chequedispatchedat      
from billmaster_deleted       
where v_no =@vno AND         
branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)        
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_EntryDetailIO_old
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_EntryDetailIO_old] 
(                
@vno as varchar(25), @str1 as varchar(25),@str2 as varchar(25)                 
)                
 as              
set nocount on                 
set transaction isolation level read uncommitted                          
                
          
          
if @str1='branch'           
begin          
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch from billmaster where v_no =@vno         
and branch=@str1        
          
end          
 if @str1='region'           
begin           
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch from billmaster where v_no =@vno         
and branch in (select code from intranet.risk.dbo.region where reg_code=@str2)          
end          
if @str1='broker'           
begin          
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch from billmaster where v_no =@vno             
         
end          
if @str1='BRMAST'          
begin          
select acname,longname,vcode,amount,branch_flag,r_flag,cso_flag,comp_flag,
r_flag1,inv_no,branch,convert(varchar(11),dis_date,103)as dis_date,pay_amount,
cheque_no,cso_date,segment,br_tag,remark,pan_no,st_no,r_date,br_date,
eid_branch,eid_cso,convert(varchar(11),d_date,103) as d_date,doc_no,courier_name,
doc_no1,courier_name1,in_status,exp_empid,dest_branch,to_branch from billmaster where v_no =@vno AND 
branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_exp_details
-- --------------------------------------------------
CREATE PROCEDURE usp_exp_details         
(       
@access_to as varchar(25),
@access_code as varchar(25),                                       
@fdt as varchar(11),
@tdt as varchar(11),
@exp_code as varchar(10)                                            
)                                              
 as                                               
set nocount on                                               
set transaction isolation level read uncommitted                       
      
  
select v_no,inv_no,narration,convert(datetime,v_date,103) as v_date,emp_no,segment,ven_name,                    
ven_code,entry_date,status,total into #file1 from vouchermaster (nolock) where len(v_date)>=10                    
                
                   
                
--declare @exp_code as varchar(25)                      
--set @exp_code='5800013'        
--set @exp_code='520021'        
select  v_no into #data from #file1 where v_date>=convert(datetime,@fdt,103)and v_date<=convert(datetime,@tdt,103)                       
         
        
--select * from vouchermaster        
select * into #file2 from voucherentry (nolock) where  v_code =@exp_code and v_no in (select v_no from #data) order by v_no         
     
select a.v_no[JV No.],a.inv_no [Inv. No.],a.Segment,a.ven_name [Vendor Name],a.ven_code [Vendor Code],        
b.v_code as [ExpenseCode],b.ac_name as [ExpenseName],b.Amount,        
b.Br_Tag as[BranchTag] into #file3 from vouchermaster (nolock) a inner join #file2 (nolock) b on a.v_no=b.v_no         
  
      
select a.*,b.IO_NO into #file4 from #file3 a left outer join voucher_details (nolock) b on a.[JV No.]=b.v_no        
        
        
select a.*,case when b.exp_fdt='01/01/1900' then 'Not Available' else convert(varchar(11),b.exp_fdt,103) end  as [Expense from date],        
case when b.exp_tdt='01/01/1900' then 'Not Available' else convert(varchar(11),exp_tdt,103) end  as [Expense to date],        
b.LOB,b.Order_Maker,b.eid_Branch         
into #file5 from #file4 a left outer join billmaster (nolock) b on a.IO_NO= b.v_no        
        
select a.*,b.person_name into #file6 from #file5 a left outer join intranet.risk.dbo.user_login b on a.eid_branch=b.username        
        
    
select [JV No.],IO_NO as [IO. SrNO],[Inv. No.],Segment,[Vendor Name],[Vendor Code],      
Amount,BranchTag,[Expense from date],[Expense to date],LOB,Order_Maker,eid_Branch as [Branch UserID],person_name as [Branch User Name]         
from #file6        
        
        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_fill_user
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_fill_user]             
(                        
@str1 as varchar(25),@str2 as varchar(25)                         
)                        
 as                         
set nocount on                         
set transaction isolation level read uncommitted                                  
                              
if @str1='branch'                         
begin                      
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where   a.branch=@str2  and  a.entry_date>=getdate()-40 and  a.entry_date<=getdate()      
end                        
                  
 if @str1='region'                         
begin                    
                   
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where  a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2          
 and  a.entry_date>=getdate()-40 and  a.entry_date<=getdate()         
        
end                        
                  
if @str1='broker'                         
begin                  
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where  a.branch='CSO'  and  a.entry_date>=getdate()-40 and  a.entry_date<=getdate()    
end                  
if @str1='BRMAST'                        
begin                     
                  
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username         
where  a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2      
 and  a.entry_date>=getdate()-40 and  a.entry_date<=getdate()            
               
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_fill_user1
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[usp_fill_user1]                             
(                                        
@uname as varchar(40),@str1 as varchar(25),@str2 as varchar(25),@fdate as varchar(11),@tdate as varchar(11)                                         
)                                        
 as                                      
set nocount on                                         
set transaction isolation level read uncommitted                                                  
                
set @fdate=convert(datetime,@fdate,103)              
set @tdate=convert(datetime,@tdate,103)              
              
if  @uname='ALL'                    
begin                    
set @uname='%%'                    
end                     
                    
                                
if @str1='branch'                                   
begin                      
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end ,a.remark,convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,                  
a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]   
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                               
a.eid_branch=b.username where  a.eid_branch like @uname and a.branch=@str2 and                     
a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                   
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                                 
                                  
end                                  
 if @str1='region'                                   
begin                   
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end,a.remark,convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]            
  
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                           
a.eid_branch=b.username where  a.eid_branch like @uname and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch like @str2)                     
and a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                     
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                                  
end                                  
if @str1='broker'                                   
begin                                  
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end,a.remark,convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]    
  
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                  
a.eid_branch=b.username where  a.eid_branch like @uname and a.branch=@str2                     
and a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                    
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                                
end                                  
if @str1='BRMAST'                                  
begin                   
                  
select a.*,isnull(b.person_name,'') as empname from                  
(select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,                              
a.amount,a.segment,a.pan_no,a.st_no,exp_empid=case when a.exp_empid='' then '-' else a.exp_empid end,a.remark,                  
convert(varchar(11),a.exp_fdt,103) as exp_fdt,convert(varchar(11),a.exp_tdt,103) as exp_tdt,isnull(a.LOB,'') as LOB,a.Adv_Amt,                  
isnull(a.Adv_Cheque_No,'') as Adv_Cheque_No,isnull(a.Order_Maker,'') as Order_Maker,a.branch,eid_branch=case when a.eid_branch='' then '-' else a.eid_branch end,a.br_tag,convert(varchar(11),a.entry_date,103) as entry_date, a.dest_branch as [Dispatch To]    
  
from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on                         
a.eid_branch=b.username where  a.eid_branch like @uname and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch like @str2)                     
and a.entry_date>=@fdate and  a.entry_date<=@tdate +' 23:59:59.999')a                  
left outer join                  
(select username,person_name from intranet.risk.dbo.user_login )b                  
on a.exp_empid=b.username                  
order by a.V_NO                  
                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_fillBrtg_TPD
-- --------------------------------------------------
CREATE PROC [dbo].[usp_fillBrtg_TPD]          
(          
 @strParam AS NVARCHAR(10),          
 @strBCode AS NVARCHAR(50),    
 @strDate AS VARCHAR(11)       
)          
-----------------------------------------------------------------------------------------------------------          
-- Examples          
-- EXEC usp_fillBrtg_TPD 'WS','SAPHYDHN1','01/06/2009'            
-- EXEC usp_fillBrtg_TPD 'HC','WGJAHMNG1'          
-- EXEC usp_fillBrtg_TPD 'CE','E11913','24/07/2009'            
-- EXEC usp_fillBrtg_TPD 'WS',''          
-- EXEC usp_fillBrtg_TPD 'HC','',''          
-- EXEC usp_fillBrtg_TPD 'CE',''          
-- exec usp_fillBrtg_TPD 'HC','WMHMUMKD1','24/07/2009'      
-----------------------------------------------------------------------------------------------------------          
AS          
BEGIN          
-----------------------------------------------------------------------------------------------------------          
 IF @strParam='WS' AND (@strBCode <> NULL OR @strBCode <> '')          
 BEGIN          
  SELECT BranchTag,Count,Ratio,suffix FROM tpd_ws a (NOLOCK)   
  LEFT OUTER JOIN TPD_LOB ON a.LOB=TPD_LOB.LOB   
  WHERE BranchCode LIKE ''+@strBCode+'%' AND MONTH(Date) = MONTH(CONVERT(DATETIME,@strDate,103))   
  AND YEAR(Date)=YEAR(CONVERT(DATETIME,@strDate,103)) AND Ratio<>0 ORDER BY 1   
 END          
-----------------------------------------------------------------------------------------------------------          
 IF @strParam='HC' AND (@strBCode <> NULL OR @strBCode <> '')          
 BEGIN          
  SELECT BranchTag,Count,Ratio,suffix FROM tpd_hc a (NOLOCK)   
  LEFT OUTER JOIN TPD_LOB ON a.LOB=TPD_LOB.LOB  
  WHERE BranchCode LIKE ''+@strBCode+'%' AND MONTH(Date) =MONTH(CONVERT(DATETIME,@strDate,103))   
  AND YEAR(Date)=YEAR(CONVERT(DATETIME,@strDate,103)) AND Ratio<>0 ORDER BY 1          
 END          
-----------------------------------------------------------------------------------------------------------          
 IF @strParam='CE' AND (@strBCode <> NULL OR @strBCode <> '')          
 BEGIN          
  SELECT BranchTag,Count,Ratio,suffix FROM tpd_ce a (NOLOCK)   
  LEFT OUTER JOIN TPD_LOB ON a.LOB=TPD_LOB.LOB   
  WHERE BranchCode LIKE ''+@strBCode+'%' AND MONTH(Date) = MONTH(CONVERT(DATETIME,@strDate,103))   
  AND YEAR(Date)=YEAR(CONVERT(DATETIME,@strDate,103)) AND Ratio<>0 ORDER BY 1          
 END          
-----------------------------------------------------------------------------------------------------------          
 IF @strParam='WS' AND @strBCode=''          
 BEGIN          
  SELECT DISTINCT BranchCode,BranchName FROM tpd_ws NOLOCK where BranchCode<>'' ORDER BY 1          
 END          
-----------------------------------------------------------------------------------------------------------          
 IF @strParam='HC' AND @strBCode=''          
 BEGIN          
  SELECT DISTINCT BranchCode,BranchName FROM  tpd_hc NOLOCK ORDER BY 1          
 END          
-----------------------------------------------------------------------------------------------------------          
 IF @strParam='CE' AND @strBCode=''          
 BEGIN          
  SELECT DISTINCT BranchCode,BranchName FROM tpd_ce NOLOCK ORDER BY 1          
 END          
-----------------------------------------------------------------------------------------------------------          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_findInUSP]                  
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
-- PROCEDURE dbo.usp_Fund_Verify
-- --------------------------------------------------
CREATE proc usp_Fund_Verify--_old   --usp_Fund_Verify '01/05/2009','17/06/2009','afapl'              
@FDate as varchar(11),                            
@TDate as varchar(22),                          
@segment as varchar(20)                           
as                      
If @segment = 'All'              
Begin              
 set @segment =  '%'              
End                
              
select ''''+e.[acntno] as [Account No.], 'C' as [Credit], p.Amount as [Amount],                      
'Reimbursed To '+e.[emp_no] as [Narration],            
b.comp_flag, ''''+e.[acntno] as [Account], p.cheque_no as [Cheque No.],                    
e.[emp_no] as [Emp Code],e.emp_name as [Employee Name], convert(varchar,p.entry_date,103) as [Entry Date],
p.segment as [Segment],p.pv_no as [PV No.],p.io_srno as [IO No.],r_flag1 into #Temp                      
From paymentmaster p (nolock), billmaster b (nolock),                  
(select distinct [emp_no],emp_name,department,designation,[Joindate],[email],[acntno],[sr_name],        
costcode,[company],LOB,panno         
from intranet.risk.dbo.emp_info) e                       
where b.v_no = p.io_srno and            
p.paytype = 'T' and p.cms_status = '1' and                            
p.transferto = e.[emp_no]  and p.entry_date > = convert(datetime,@FDate,103) and p.entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999' and p.Segment like @segment                       
AND e.[acntno] is not Null and len(replace(e.[acntno],' ','')) = 14                
order by e.[emp_no], p.io_srno                        
                      
select * from #Temp                      
                      
select count(*) from #Temp                  
                  
select count(*) from paymentmaster where paytype = 'T' and segment like @segment                  
 and entry_date > = convert(datetime,@FDate,103) and                   
entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Fund_Verify_old
-- --------------------------------------------------
CREATE proc usp_Fund_Verify_old   --usp_Fund_Verify '01/06/2009','10/06/2009','all'      
@FDate as varchar(11),                    
@TDate as varchar(22),                  
@segment as varchar(20)                   
as              
If @segment = 'All'      
Begin      
 set @segment =  '%'      
End        
      
select e.[acntno] as [Account No.], 'C' as [Credit], p.Amount as [Amount],              
'Reimbursed To '+e.[emp_no] as [Narration],    
b.comp_flag, e.[acntno] as [Account], p.cheque_no as [Cheque No.],            
e.[acntno] as [Emp Code],              
e.emp_name as [Employee Name], convert(varchar,p.entry_date,103) as [Entry Date], p.segment as [Segment],           
p.pv_no as [PV No.],p.io_srno as [IO No.],r_flag1 into #Temp              
From paymentmaster p (nolock), billmaster b (nolock),          
(select distinct [emp_no],emp_name,department,designation,[Joindate],[email],[acntno],[sr_name],
costcode,[company],LOB,panno 
from intranet.risk.dbo.emp_info) e               
where b.v_no = p.io_srno and    
p.paytype = 'T' and p.cms_status = '1' and                    
p.transferto = e.[emp_no]  and p.entry_date > = convert(datetime,@FDate,103) and p.entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999' and p.Segment like @segment               
AND e.[acntno] is not Null and len(replace(e.[acntno],' ','')) = 14        
order by e.[emp_no], p.io_srno                
              
select * from #Temp              
              
select count(*) from #Temp          
          
select count(*) from paymentmaster where paytype = 'T' and segment like @segment          
 and entry_date > = convert(datetime,@FDate,103) and           
entry_date < = convert(datetime,@TDate,103)+ ' 23:59:59.999'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_gen_cms
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_gen_cms]                            
(                                
@dtr1 as datetime, @ptr1 as datetime,@segment as varchar(15),@FY varchar(15)                                
)                                
 as                              
set nocount on                                 
set transaction isolation level read uncommitted                       
                    
/*set @dtr1 = convert(datetime,@dtr1,103)                    
set @ptr1 = convert(datetime,@ptr1,103)*/                    
                    
/*declare  @Fdate as varchar(11)                                        
declare  @tdate as varchar(11)                                       
                    
set @dtr1 = convert(varchar(11),@dtr1)                    
set @dtr1 = 'Jan 29 2009' + ' 23:59:59'   
                        
*/                        
select                     
p.v_code as Client_Code,                    
p.v_name_f as Client_Full_name,                    
p.amount as Amount,                    
'MUMBAI' as Pay_Location,                    
b.dest_branch as Branch_code,                    
b.dest_branch as Sub_broker_code,                    
case                    
when p.io_srno = '0' then b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')--+' '+p.br_tag                    
else b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')+' '+b.ChequeDispatchedAt --+' '+p.br_tag     
end as Narration,         
p.cheque_no as Cheque_Number,                    
Enet_Code =                      
(                    
case when p.segment = 'BSECM' then 'ABLD'                     
when p.segment = 'NSECM' then 'ACDL'                             
when p.segment = 'NCDEX' then 'ACBL'                     
when p.segment = 'BSE FO' then 'BSE FO'                     
when p.segment = 'NSEFO' then 'NSEFO'                     
when p.segment = 'MCX' then 'MCX'                     
when p.segment='NBFC' then 'MBNL'                     
when p.segment='AFAPL' then 'WOWT' end),'C' as File_Type                     
from                    
(                    
select  * from paymentmaster (nolock) where left(convert(varchar,entry_date,121),11) >= @dtr1 and left(convert(varchar,entry_date,121),11) <= @ptr1 and segment = @segment and cms_status = '0' and paytype <> 'T'            
 )p                    
left outer join                    
(select * from billmaster (nolock))b                    
on p.io_Srno = b.V_no order by p.cheque_no     

/*IF @FY='20102011'  
BEGIN                    
select                     
p.v_code as Client_Code,                    
p.v_name_f as Client_Full_name,                    
p.amount as Amount,                    
'MUMBAI' as Pay_Location,                    
b.dest_branch as Branch_code,                    
b.dest_branch as Sub_broker_code,                    
case                    
when p.io_srno = '0' then b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')--+' '+p.br_tag                    
else b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')+' '+b.ChequeDispatchedAt --+' '+p.br_tag     
end as Narration,         
p.cheque_no as Cheque_Number,                    
Enet_Code =                      
(                    
case when p.segment = 'BSECM' then 'ABLD'                     
when p.segment = 'NSECM' then 'ACDL'                             
when p.segment = 'NCDEX' then 'ACBL'                     
when p.segment = 'BSE FO' then 'BSE FO'                     
when p.segment = 'NSEFO' then 'NSEFO'                     
when p.segment = 'MCX' then 'MCX'                     
when p.segment='NBFC' then 'MBNL'                     
when p.segment='AFAPL' then 'WOWT' end),'C' as File_Type                     
from                    
(                    
select  * from paymentmaster (nolock) where left(convert(varchar,entry_date,121),11) >= @dtr1 and left(convert(varchar,entry_date,121),11) <= @ptr1 and segment = @segment and cms_status = '0' and paytype <> 'T'            
 )p                    
left outer join                    
(select * from billmaster (nolock))b                    
on p.io_Srno = b.V_no order by p.cheque_no                        
END  
ELSE  
BEGIN  
select                     
p.v_code as Client_Code,                    
p.v_name_f as Client_Full_name,                    
p.amount as Amount,                    
'MUMBAI' as Pay_Location,                    
b.dest_branch as Branch_code,                    
b.dest_branch as Sub_broker_code,                    
case                    
when p.io_srno = '0' then b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')--+' '+p.br_tag                    
else b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')+' '+b.ChequeDispatchedAt --+' '+p.br_tag     
end as Narration,         
p.cheque_no as Cheque_Number,                    
Enet_Code =                      
(                    
case when p.segment = 'BSECM' then 'ABLD'                     
when p.segment = 'NSECM' then 'ACDL'                             
when p.segment = 'NCDEX' then 'ACBL'                     
when p.segment = 'BSE FO' then 'BSE FO'                     
when p.segment = 'NSEFO' then 'NSEFO'                     
when p.segment = 'MCX' then 'MCX'                     
when p.segment='NBFC' then 'MBNL'                     
when p.segment='AFAPL' then 'WOWT' end),'C' as File_Type                     
from                    
(                    
select  * from paymentmaster (nolock) where left(convert(varchar,entry_date,121),11) >= @dtr1 and left(convert(varchar,entry_date,121),11) <= @ptr1 and segment = @segment and cms_status = '0' and paytype <> 'T'            
 )p                    
left outer join                    
(select * from account123.dbo.billmaster (nolock))b                    
on p.io_Srno = b.V_no order by p.cheque_no                        
END                    
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_gen_cms_bkup
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_gen_cms_bkup]    
(        
@dtr1 as datetime,@ptr1 as datetime,@segment as varchar(15)        
)        
 as      
set nocount on         
set transaction isolation level read uncommitted                  
    
    
select v_code as Client_Code,v_name_f as Client_Full_name,amount as Amount,'MUMBAI'     
as Pay_Location,'HO' as Branch_code,'HO' as Sub_broker_code,br_tag+'-'+'J-'+    
convert (varchar(11),jv_no)+'-P-'+convert (varchar(11),pv_no)+'-S-'+isnull(convert (varchar(11),io_srno),'')as    
Narration,cheque_no as Cheque_Number,Enet_Code =     
(case when segment = 'BSECM' then 'ABLD' when segment = 'NSECM' then 'ACDL'     
when segment = 'NCDEX' then 'ACBL' when segment = 'BSE FO' then 'BSE FO' when     
segment = 'NSEFO' then 'NSEFO' when segment = 'MCX' then 'MCX' when segment='NBFC' then 'MBNL' when segment='AFAPL' then 'WOWT' end) ,'C' as File_Type     
from paymentmaster where entry_date >=@dtr1 and entry_date <= @ptr1 and     
segment =@segment and cms_status = '0' order by cheque_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_gen_cms20092010
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_gen_cms20092010]                            
(                                
@dtr1 as datetime, @ptr1 as datetime,@segment as varchar(15),@FY varchar(15)                                
)                                
 as                              
set nocount on                                 
set transaction isolation level read uncommitted                       
                    
/*set @dtr1 = convert(datetime,@dtr1,103)                    
set @ptr1 = convert(datetime,@ptr1,103)*/                    
                    
/*declare  @Fdate as varchar(11)                                        
declare  @tdate as varchar(11)                                       
                    
set @dtr1 = convert(varchar(11),@dtr1)                    
set @dtr1 = 'Jan 29 2009' + ' 23:59:59'                           
*/                        

select                     
p.v_code as Client_Code,                    
p.v_name_f as Client_Full_name,                    
p.amount as Amount,                    
'MUMBAI' as Pay_Location,                    
b.dest_branch as Branch_code,                    
b.dest_branch as Sub_broker_code,                    
case                    
when p.io_srno = '0' then b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')--+' '+p.br_tag                    
else b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')+' '+b.ChequeDispatchedAt --+' '+p.br_tag     
end as Narration,         
p.cheque_no as Cheque_Number,                    
Enet_Code =                      
(                    
case when p.segment = 'BSECM' then 'ABLD'                     
when p.segment = 'NSECM' then 'ACDL'                             
when p.segment = 'NCDEX' then 'ACBL'                     
when p.segment = 'BSE FO' then 'BSE FO'                     
when p.segment = 'NSEFO' then 'NSEFO'                     
when p.segment = 'MCX' then 'MCX'                     
when p.segment='NBFC' then 'MBNL'                     
when p.segment='AFAPL' then 'WOWT' end),'C' as File_Type                     
from                    
(                    
select  * from paymentmaster (nolock) where left(convert(varchar,entry_date,121),11) >= @dtr1 and left(convert(varchar,entry_date,121),11) <= @ptr1 and segment = @segment and cms_status = '0' and paytype <> 'T'            
 )p                    
left outer join                    
(select * from account123.dbo.billmaster (nolock))b                    
on p.io_Srno = b.V_no order by p.cheque_no                        
                  












select                     
p.v_code as Client_Code,                    
p.v_name_f as Client_Full_name,                    
p.amount as Amount,                    
'MUMBAI' as Pay_Location,                    
b.dest_branch as Branch_code,                    
b.dest_branch as Sub_broker_code,                    
case                    
when p.io_srno = '0' then b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')               
else b.dest_branch+' '+isnull(convert (varchar(11),p.io_srno),'')+' '+b.ChequeDispatchedAt 
end as Narration,         
p.cheque_no as Cheque_Number,                    
Enet_Code =                      
(                    
case when p.segment = 'BSECM' then 'ABLD'                     
when p.segment = 'NSECM' then 'ACDL'                             
when p.segment = 'NCDEX' then 'ACBL'                     
when p.segment = 'BSE FO' then 'BSE FO'                     
when p.segment = 'NSEFO' then 'NSEFO'                     
when p.segment = 'MCX' then 'MCX'                     
when p.segment='NBFC' then 'MBNL'                     
when p.segment='AFAPL' then 'WOWT' end),'C' as File_Type                     
from                    
(                    
select  * from paymentmaster (nolock) where left(convert(varchar,entry_date,121),11) >= '2010-04-04' and left(convert(varchar,entry_date,121),11) <= '2010-04-04 23:59:59' and segment = 'BSECM' and cms_status = '0' and paytype <> 'T'            
 )p                    
left outer join                    
(select * from Account123.dbo.billmaster (nolock))b                    
on p.io_Srno = b.V_no order by p.cheque_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_gen_jv_csv
-- --------------------------------------------------
CREATE PROCEDURE usp_gen_jv_csv              
(                
@dtr1 as datetime,@ptr1 as datetime,@seg as varchar(15)                
)                
 as                 
set nocount on                 
set transaction isolation level read uncommitted                          
                
select a.v_no as srno,b.v_date as Vdate,b.v_date  as Edate,a.v_code as cltcode,a.Drcr,          
a.amount as Amount,b.narration as Narration,a.br_tag as branchcode into #t 
from voucherentry a (nolock) inner join          
 vouchermaster b on a.v_no=b.v_no 
where left(convert(varchar,b.entry_date,121),11) >=@dtr1
and  left(convert(varchar,b.entry_date,121),11) <= @ptr1 
and b.segment =@seg  and b.status = '0' order by b.v_date, a.v_no          
        
select distinct srno,vdate into #t1 from #t order by vdate 

truncate table tbl_srno        
        
insert into tbl_srno(Srno)        
 (select Srno from #t1)        
        
select b.cnt as Srno,Vdate,Edate,cltcode,Drcr,Amount,Narration,branchcode        
 from         
(select * from #t) a        
left outer join        
 (select * from tbl_srno) b        
on a.srno = b.srno

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_gen_pv_csv
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_gen_pv_csv]               
(                
@dtr1 as datetime,@ptr1 as datetime,@seg as varchar(15)                
)                
 as                 
set nocount on                 
set transaction isolation level read uncommitted          
        
        
select pv_no as SrNo,date as Edate,date as Vdate,v_code as Cltcode,amount as 
Amount, 'D' as DrCr,        
narration as Narration,bank_code as BANKCODE,bank_name as BankName,cheque_no as 
DDNo,br_tag as BranchCode,        
'FORT' as BrnName,'C' as chq_mode,date as chq_date,v_name_f as chq_name,'O' as 
cl_mode into #t_pay from paymentmaster         
where left(convert(varchar,entry_date,121),11) >=@dtr1 and left(convert(varchar,entry_date,121),11) <=@ptr1 and segment =@seg and status = '0'  
      
 order by pv_no        
truncate table tbl_srno_pay        
insert into tbl_srno_pay(Srno)        
 (select distinct Srno from #t_pay)        
        
select b.cnt as 
Srno,Edate,Vdate,cltcode,Amount,Drcr,Narration,BANKCODE,BankName,DDNo,BranchCode,BrnName,chq_mode,chq_date,        
chq_name,cl_mode        
        
        
from         
(select * from #t_pay) a        
left outer join        
 (select * from tbl_Srno_pay) b        
on a.srno = b.srno

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Get_Cheque_Printed_Loc
-- --------------------------------------------------
CREATE proc usp_Get_Cheque_Printed_Loc    
@access_to varchar(50),    
@access_code varchar(50)    
    
as    
    
declare @access_query varchar(2000)    
declare @str varchar(2000)    
    
/*    
declare @access_to varchar(50)    
declare @access_code varchar(50)    
set @access_to = 'branch'    
set @access_code = 'acm'    
*/    
    
set @str = 'select distinct print_loc,ltrim(rtrim(cso_branchtag)) as [CSO_BranchTag] from CMS_Location where '    
    
if @access_to='BRANCH'                              
                        
begin                                        
set @access_query=''                              
set @access_query=@access_query+' branch_tag='''+@access_code+''''                            
end               
              
else if @access_to='REGION'                                          
begin                            
set @access_query=''                             
set @access_query=@access_query+' (branch_tag in (select code from intranet.risk.dbo.region    
where reg_code = '''+@access_code+''') or branch_tag='''+@access_code+''')'                              
end                
              
else if @access_to='BRMAST'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' (branch_tag in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or branch_tag='''+@access_code+''')'                            
end                  
                       
else if @access_to='BROKER'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+'  branch_tag like '''+@access_code+''''                            
end      
    
--print @str+@access_query    
exec(@str+@access_query)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_get_EmailNarr
-- --------------------------------------------------
create proc usp_get_EmailNarr
@PV as numeric(18,0),
@Emp as varchar(20)
as
select email from intranet.risk.dbo.emp_info where emp_no =  @Emp

SELECT Narration FROM paymentmaster where pv_no = @PV

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetBillLog_User
-- --------------------------------------------------
CREATE proc usp_GetBillLog_User
@Status varchar(100),      
@Fdate varchar(11),      
@Tdate varchar(11),    
@seg varchar(15)
as 

if @seg = 'All'
Begin 
	set @seg = '%'	
End

 select distinct b.person_name,b.username
 from       
 bill_status_log A (nolock), intranet.risk.dbo.user_login b , billmaster c (nolock)      
 where       
 a.v_no = c.v_no       
 and b.username=a.action_by      
 and      
 a.status = @Status       
 and a.action_date >= convert(datetime,@Fdate +' 00:00:00.000',103)      
 and      
 a.action_date <= convert(datetime,@Tdate +' 23:59:59.999',103)
 and 
 c.segment like @seg
 order by person_name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetChequePrintedByUser
-- --------------------------------------------------
CREATE proc usp_GetChequePrintedByUser --usp_GetChequePrintedByUser '27/06/2009','27/06/2009','E06135','broker','cso','all','2'  
@Fdate varchar(20),  
@TDate varchar(20),  
@username varchar(20),  
@access_to varchar(30), --Broker/Branch/subbroker/region/brmast  
@access_code varchar(30), --Region Code  
@EmpCode varchar(20),
@Srno int
as  
declare @str varchar(4000)  
   
if @Srno = 1
begin
	set @str = 'select distinct b.eid_branch, e.person_name  
	from billmaster b (nolock), risk.dbo.user_login e  
	where   
	b.eid_branch = e.username   
	and courier_name1 = ''CHEQUE PRINTED AT BRANCH LOCATION''  
	and d_date >= convert(datetime,'''+@Fdate+''',103)   
	and d_date <= convert(datetime,'''+@TDate+''',103)'  
end
else if @Srno = 2
begin 
	set @str = 'select b.v_no as [VNO], b.BRANCH, b.eid_branch as [EmployeeID], e.person_name, b.SEGMENT, 
	b.bill_date as [Bill Date],  
	b.acname as [Vendor Name], b.longname as [Cheque Name], b.vcode as [Vendor Code], b.inv_no as [Invoice No.],  
	b.amount as [Bill Amount], b.pan_no as [Pan No.], b.st_no as [ST No.], 
	convert (varchar(11),b.dis_date,103) as [Dispatche To CSO],   
	b.courier_name as [Courier Name(Branch)], b.doc_no as [Doc No.], b.r_date as [Received By CSO],   
	b.in_status as [Status By CSO], b.cso_date as [Cheque Date], b.pay_amount as [Cheque Amount],   
	b.cheque_no as [Cheque No.], b.eid_cso as [CSO UID], e1.person_name as [CSO Login],   
	convert (varchar(11),b.d_date,103) as [Dispatch To Branch], b.courier_name1 as [Courier Name(CSO)], 
	b.doc_no1 as [Doc No.(CSO)],   
	b.br_date as [Received By Branch], b.dest_branch as [Cheque Printed At], 
	convert (varchar(11),b.due_date,103) as [Due Date], 
	b.chequedispatchedat as [Cheque Dispatched At]  
	from billmaster b (nolock), risk.dbo.user_login e, risk.dbo.user_login e1  
	where b.eid_branch = e.username  
	and b.eid_cso=e1.username  
	and courier_name1 = ''CHEQUE PRINTED AT BRANCH LOCATION''  
	and d_date >= convert(datetime,'''+@Fdate+''',103)   
	and d_date <= convert(datetime,'''+@TDate+''',103)'

	If @EmpCode <> 'All'
	begin 
		set @str = @str + ' and b.eid_branch = '''+@EmpCode+''''
	End
	
End
  
if @access_to='BRANCH'                                                     
begin                                              
 set  @str = @str + ' and b.branch in (select distinct branch_tag from cms_location where cso_branchtag in(select distinct cso_branchtag from cms_location where branch_tag='''+@access_code+''')) order by e.person_name'  
end                     
                    
else if @access_to='REGION'                                                
begin                                  
 set  @str = @str + ' and b.branch in (select distinct branch_tag from cms_location where cso_branchtag in (select distinct cso_branchtag from cms_location where reg_code='''+@access_code+''')) order by e.person_name'                         
end                      
                    
else if @access_to='BRMAST'                                              
begin                                              
 set  @str = @str + ' and b.branch in (select distinct branch_tag from cms_location where cso_branchtag in(select distinct cso_branchtag from cms_location where branch_tag='''+@access_code+''')) order by e.person_name'  
end    
                             
else if @access_to='BROKER'                                              
begin                                  
 set  @str = @str + ' and b.branch in (select distinct branch_tag from cms_location where cso_branchtag in (select distinct cso_branchtag from cms_location)) order by e.person_name'  
end    
  
--print @str  
exec(@str)  
  
/*  
select b.v_no as [VNO], b.BRANCH, b.eid_branch as [EmployeeID], e.person_name, b.SEGMENT, 
b.bill_date as [Bill Date],  
b.acname as [Vendor Name], b.longname as [Cheque Name], b.vcode as [Vendor Code], b.inv_no as [Invoice No.],  
b.amount as [Bill Amount], b.pan_no as [Pan No.], b.st_no as [ST No.], b.dis_date as [Dispatche To CSO],   
b.courier_name as [Courier Name(Branch)], b.doc_no as [Doc No.], b.r_date as [Received By CSO],   
b.in_status as [Status By CSO], b.cso_date as [Cheque Date], b.pay_amount as [Cheque Amount],   
b.cheque_no as [Cheque No.], b.eid_cso as [CSO UID], e1.person_name as [CSO Login],   
b.d_date as [Dispatch To Branch], b.courier_name1 as [Courier Name(CSO)], b.doc_no1 as [Doc No.(CSO)],   
b.br_date as [Received By Branch], b.dest_branch as [Cheque Printed At], b.due_date as [Due Date], b.chequedispatchedat as [Cheque Dispatched At]  
from billmaster b (nolock), risk.dbo.user_login e, risk.dbo.user_login e1  
where b.eid_branch = e.username  
and b.eid_cso=e1.username  
and courier_name1 = ''CHEQUE PRINTED AT BRANCH LOCATION''  
and d_date >= convert(datetime,'''+@Fdate+''',103)   
and d_date <= convert(datetime,'''+@TDate+''',103)  
and b.eid_branch = @Code  
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetEditBranchEntry
-- --------------------------------------------------

CREATE proc usp_GetEditBranchEntry --'602',''      
@VNo varchar(20),@Vcode varchar(50),  
@Str varchar(2000),  
@Str1 as varchar(25), --access_to  
@Str2 as varchar(25) --access_code         
as      
      
set nocount on      
set @VNo =      
(      
select v_no from billmaster      
where cso_flag = '0' and comp_flag = '0' and r_flag = '0' and r_flag1 = '0'  --and branch_flag = '1'      
and v_no = @VNo      
)      
      
If @VNo <> ''      
Begin      
      
 set @vcode = (select vcode from billmaster where v_no = @VNo)            
 If @vcode <> 'NEW'            
  Begin            
   set @Str = 'select b.v_no, b.segment, v.acname, b.longname, b.inv_no, b.st_no, b.pan_no, b.amount, b.adv_amt,       b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker,       
   b.remark,b.vcode, b.EID_BRANCH,b.branch, u.person_name        
   from billmaster B, Vendormaster V, intranet.risk.dbo.user_login U           
   where b.v_no='''+@VNo+''' and b.segment = v.segment and b.vcode = v.cltcode  and b.eid_branch = u.username'  
  End            
       
 Else            
  Begin            
   set @Str = 'select b.v_no, b.segment, b.acname, b.longname, b.inv_no, b.st_no, b.pan_no,b.amount,   
   b.adv_amt, b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker,       
   b.remark, b.vcode, b.EID_BRANCH,b.branch ,u.person_name             
   from billmaster b, intranet.risk.dbo.user_login U        
   where v_no='''+@VNo+''' and b.eid_branch = u.username'         
  End       
--End      
--Else      
--Begin      
-- select 'No Data'      
--End   
--  
  print @str
if @str1='branch'  
Begin  
 set @str = @str + ' and b.branch='''+@str2+''''  
End  
Else If @str1='region'  
Begin   
 set @str = @str + ' and (b.branch in (select code from intranet.risk.dbo.region where reg_code='''+@str2+''') or b.branch='''+@str2+''')'  
End  
Else If @str1='broker'  
Begin   
 set @str = @str + ' and b.branch='''+@str2+''''  
End  
Else If @str1='BRMAST'  
Begin   
 set @str = @str + ' and (b.branch in (select branch_cd from intranet.risk.dbo.branch_master   
 where brmast_cd='''+@str2+''') or b.branch='''+@str2+''')'  
End  

End

Else  
Begin  
 select 'No Entry'    
End  
  

--exec(@str)  
print @str  
--usp_GetEditBranchEntry '10675','','','region','cso'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetEditBranchEntry1
-- --------------------------------------------------
CREATE proc usp_GetEditBranchEntry1 --'602',''        
@VNo varchar(20),@Vcode varchar(50),    
@Str varchar(2000),    
@Str1 as varchar(25), --access_to    
@Str2 as varchar(25) --access_code           
as        
        
set nocount on        
set @VNo =        
(        
select v_no from billmaster        
where cso_flag = '0' and comp_flag = '0' and r_flag = '0' and r_flag1 = '0'  --and branch_flag = '1'        
and v_no = @VNo        
)        
        
If @VNo <> ''        
Begin        
        
 set @vcode = (select vcode from billmaster where v_no = @VNo)              
 If @vcode <> 'NEW'              
  Begin              
   set @Str = 'select b.v_no, b.segment, v.acname, b.longname, b.inv_no, b.st_no, b.pan_no, b.amount, b.adv_amt,       b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker,         
   b.remark,b.vcode, b.EID_BRANCH,b.branch, u.person_name, b.due_date, b.chequedispatchedat          
   from billmaster B, Vendormaster V, intranet.risk.dbo.user_login U             
   where b.v_no='''+@VNo+''' and b.segment = v.segment and b.vcode = v.cltcode  and b.eid_branch = u.username'    
  End              
         
 Else              
  Begin              
   set @Str = 'select b.v_no, b.segment, b.acname, b.longname, b.inv_no, b.st_no, b.pan_no,b.amount,     
   b.adv_amt, b.adv_cheque_no, b.br_tag, b.exp_fdt, b.exp_tdt, b.dest_branch, b.exp_empid, b.order_maker,         
   b.remark, b.vcode, b.EID_BRANCH,b.branch ,u.person_name, b.due_date, b.chequedispatchedat               
   from billmaster b, intranet.risk.dbo.user_login U          
   where v_no='''+@VNo+''' and b.eid_branch = u.username'           
  End         
End        
Else        
Begin        
 select 'No Data'        
End     
    
    
if @str1='branch'    
Begin    
 set @str = @str + ' and b.branch='''+@str2+''''    
End    
Else If @str1='region'    
Begin     
 set @str = @str + ' and (b.branch in (select code from intranet.risk.dbo.region where reg_code='''+@str2+''') or b.branch='''+@str2+''')'    
End    
Else If @str1='broker'    
Begin     
 set @str = @str + ' and b.branch='''+@str2+''''    
End    
Else If @str1='BRMAST'    
Begin     
 set @str = @str + ' and (b.branch in (select branch_cd from intranet.risk.dbo.branch_master     
 where brmast_cd='''+@str2+''') or b.branch='''+@str2+''')'    
End    
Else    
Begin    
 select 'No Entry'      
End    
    
exec(@str)    
--print @str    
--usp_GetEditBranchEntry1 '13179','','','branch','jnd'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getpendingbills
-- --------------------------------------------------
CREATE proc usp_getpendingbills --'BROKER','CSO'
(
@access_to as varchar(25),
@access_code as varchar(25)
)

as
select a.v_no as [IO Sr.No.],a.Branch,b.Person_name as [Branch User],a.vcode as [Vendor Code],a.Segment,a.r_date as [Bill Received Date],
DATEDIFF(day,convert(datetime,a.r_date,103),getdate()) as [No.Of Days since pending],a.acname[Vendor Name],
a.longname[Cheque Name],a.Inv_no,a.Amount,a.br_tag[Expense to BrTag],a.LOB
from billmaster a
inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username 
 where a.r_flag='1' and a.cso_flag='0' and convert(datetime,a.r_date,103)<=getdate()-10
order by convert(datetime,a.r_date,103)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_GetTotalCount
-- --------------------------------------------------
CREATE Proc Usp_GetTotalCount
(@fdt as Varchar(11),
@tdt as Varchar(11)
)
as


select Emp_no,Count(v_no)V_Count into #JV from vouchermaster (Nolock) where Entry_Date>=Convert(Datetime,@fdt,103) and Entry_Date <=Convert(Datetime,@tdt,103)+' 23:59:59'
group by Emp_no


select Emp_no,Count(Distinct Convert(datetime,Convert(Varchar(11),Entry_Date,103),103)) as JvDays into #JVDays from vouchermaster (Nolock) where Entry_Date>=Convert(Datetime,@fdt,103) and Entry_Date <=Convert(Datetime,@tdt,103)+' 23:59:59'
group by Emp_no

--drop table #data
select Emp_id,Count(Pv_no)V_Count into #PV from PaymentMaster (Nolock) where Entry_Date>=Convert(Datetime,@fdt,103) and Entry_Date <=Convert(Datetime,@tdt,103)+' 23:59:59'
group by Emp_id

select Emp_id,Count(Distinct Convert(datetime,Convert(Varchar(11),Entry_Date,103),103)) as PvDays into #PVDays from PaymentMaster (Nolock) where Entry_Date>=Convert(Datetime,@fdt,103) and Entry_Date <=Convert(Datetime,@tdt,103)+' 23:59:59'
group by Emp_id

select * into #Emp from
(
select distinct Emp_no as Emp_Id  from #jv
Union all
select distinct Emp_Id from #Pv

) x

select distinct upper(EMP_Id) as EmployeeCode,EmployeeName=Space(100), JVCount = Space(10),PVCount =Space(10),TotalMarking=Space(10),JVDays=Space(10),PVDays=Space(10)
into #data from #Emp



Update #data set EmployeeName=b.uname from login_VMS b where #data.EmployeeCode=b.uid

Update #data set JVCount=b.V_Count from #JV b where #data.EmployeeCode=b.Emp_no
Update #data set PVCount=b.V_Count from #PV b where #data.EmployeeCode=b.Emp_id
Update #data set JVDays=b.JVDays from #JVDays b where #data.EmployeeCode=b.Emp_no
Update #data set PVDays=b.PVDays from #PVDays b where #data.EmployeeCode=b.Emp_id


Update #data set TotalMarking=Convert(int,JVCount)+Convert(int,PVCount)

Select * from #data order by Convert(int,TotalMarking) desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getuser_brmis
-- --------------------------------------------------
CREATE proc usp_getuser_brmis --usp_getuser_brmis '4','brmast','ya','22/06/2009','',''   
(              
@filter_type as varchar(10),              
@access_to as varchar(25),                                        
@access_code as varchar(25),               
@param1 as varchar(25),              
@param2 as varchar(25),              
@param3 as varchar(25)              
)              
as              
              
declare @str as varchar(2000)                            
declare @filter as varchar(600)                            
declare @access_query as varchar(600)                            
declare @final as varchar(5000)                            
--declare @post as varchar(500)                           
              
              
              
set @str=''              
set @str=@str+'select distinct(a.eid_branch),b.person_name from billmaster  a (nolock) '              
set @str=@str+' inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username '              
              
if @filter_type='1'                            
begin                    
              
set @filter=''                            
set @filter=@filter+' where a.dis_date>=convert(datetime,'''+@param1+''',103) and a.dis_date<=convert(datetime,'''+@param2+''',103) and  cso_flag=''1'' '              
              
end              
else if @filter_type='2'                            
begin                    
              
set @filter=''                            
set @filter=@filter+' where a.d_date>=convert(datetime,'''+@param1+''',103) and a.d_date<=convert(datetime,'''+@param2+''',103) and  cso_flag=''1'' '              
              
end              
else if @filter_type='3'                            
begin                    
              
set @filter=''                            
set @filter=@filter+' where left(convert(varchar,a.entry_date,121),11)>=convert(datetime,'''+@param1+''',103) and left(convert(varchar,a.entry_date,121),11) <=convert(datetime,'''+@param2+''',103)'         
              
set  @access_query=''                              
set  @access_query=@access_query+' and  a.branch like ''%'' order by b.person_name '             
          
end       
----------------    
else if @filter_type='4'                            
begin                    
              
set @filter=''                            
set @filter=@filter+' where a.d_date>=convert(datetime,'''+@param1+''',103) and  cso_flag=''1'' 
and Courier_name1 like ''CHEQUE PRINTED AT BRANCH LOCATION'''              
              
end            
-----------------             
if @access_to='BRANCH'                              
                        
begin                                        
set @access_query=''                              
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by b.person_name '                            
end               
              
else if @access_to='REGION'                                          
begin                            
set @access_query=''                              
set @access_query=@access_query+' and (a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''') or a.branch = '''+@access_code+''') order by b.person_name'                              
end                
              
else if @access_to='BRMAST'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and  (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or a. branch='''+@access_code+''') order by b.person_name  '                            
end                       
          
         
else if @access_to='BROKER' and @filter_type <> '4'                                   
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and  a.branch like '''+@access_code+''' order by b.person_name '        
end  
else
begin if @access_to='BROKER' and @filter_type = '4' 
set  @access_query=''                              
set  @access_query=@access_query+' and  a.branch like ''%'' order by b.person_name '        

end                
              
set @final=''                  
set @final=@final+@str+@filter+@access_query                  
--print(@final)                  
exec(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_JVRemarksMIS
-- --------------------------------------------------
CREATE proc [dbo].[usp_JVRemarksMIS]  
  
(  
 @access_to Varchar(20),  
 @access_code varchar(20),  
 @f varchar(20)  ,
 @t varchar(20)  
)  
AS  
-- exec usp_JVRemarksMIS null,null,'01/01/2008','01/01/2010'  
begin  
--if @iono='All'  
--begin  
-- select io_no [IO No.],Segment,Inv_No [Invoice No.],round(jamt,2) [Inv. Amt.],pv_No [PV No],  
-- round(pamt,2) [PV Amt.],Emp_Name [Employee Name],entry_date [Entry Date],Remarks,Solutions,  
-- cremarks [Check Remarks] from jv_remarks where io_no LIKE '%'  
--end  
--else  
--begin  
 select io_no [IO No.],entry_date [Entry Date],Segment,Inv_No [Invoice No.],v_no [JV No.],round(jamt,2) [Inv. Amt.],pv_No [PV No],  
 round(pamt,2) [PV Amt.],Emp_Name [Employee Name],createdby [Checked By],Remarks,Solutions,  
 cremarks [Check Remarks] from jv_remarks where convert(datetime,convert(varchar(11),entry_date,103),103) 
 between convert(datetime,convert(varchar(11),@f,103),103) and convert(datetime,convert(varchar(11),@t,103),103)  
--end  
end  
-- select * from jv_remarks

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MIS_cross_check
-- --------------------------------------------------
CREATE proc usp_MIS_cross_check
( @fdt as datetime,@tdt as datetime)
 as                 
set nocount on                 
set transaction isolation level read uncommitted                          
select * into #data1 from vouchermaster (nolock) where entry_date>=@fdt and entry_date<=@tdt order by v_no


--drop table #data4
select a.v_no [Old_Jvno],b.v_no as [New_Jvno],space(6) as Old_pv_no,space(6) as New_pv_no,space(6) as Old_Io_Srno,space(6) as New_Io_Srno,a.Inv_no,a.emp_no as[Old Jv by user],b.emp_no as [New Jv by user],
a.segment,a.ven_name,a.ven_code,a.total as [Old Amount],b.total
as [New Amount] into #data2 from  
account123.dbo.vouchermaster a, #data1 b
where a.inv_no=b.Inv_no and a.segment=b.segment and a.ven_code=b.ven_code 

--select * from #data2

update #data2 set Old_pv_no=b.pv_no,Old_Io_Srno=b.io_srno from
(select jv_no,pv_no,io_srno from account123.dbo.paymentmaster where jv_no in (select [Old_Jvno] from #data2)
)b

update #data2 set New_pv_no=b.pv_no,New_Io_Srno=b.io_srno from
(select jv_no,pv_no,io_srno from paymentmaster where jv_no in (select [New_Jvno] from #data2)
)b

select a.Old_Jvno,a.New_Jvno,a.Old_pv_no,a.New_pv_no,a.Old_Io_Srno,a.New_Io_Srno,a.inv_no,a.segment,a.ven_name,a.ven_code,a.[Old Amount],a.[New Amount],b.uname as [Old Jv by user],a.[New Jv by user]into #data3 from #data2 a inner join login_vms b on a.[Old Jv by user]=b.uid

select a.Old_Jvno,a.New_Jvno,a.Old_pv_no,a.New_pv_no,a.Old_Io_Srno,a.New_Io_Srno,a.inv_no,a.segment,a.ven_name,a.ven_code,a.[Old Amount],a.[New Amount],[Old JV by user],b.uname as [New Jv by user]into #data4 from #data3 a inner join login_vms b on a.[New Jv by user]=b.uid

select * from #data4
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MIS_Global1
-- --------------------------------------------------
CREATE PROCEDURE usp_MIS_Global1             
(                                         
@filter_type as varchar(10),                  
@access_to as varchar(25),                                        
@access_code as varchar(25),                            
@param1 as varchar(25),                        
@param2 as varchar(25),                             
@param3 as varchar(60)                          
              
)                                          
as                                           
declare @str as varchar(2000)                            
declare @filter as varchar(600)                            
declare @access_query as varchar(600)                            
declare @final as varchar(5000)     
SET @param1=CONVERT(datetime,@param1,103)        
SET @param2=CONVERT(datetime,@param2,103)  
   
                   
set @str=''               
set @str=@str+'select a.v_no as [IO_Srno],a.Branch as [Branch],a.eid_branch as [Branch Userid],b.person_name as [Branch Username],'              
set @str=@str+'a.acname as [Vendor Name],a.longname as [Cheque Name],a.vcode as [Vendor Code],'          
set @str=@str+'a.Segment as [Segment],a.inv_no as [Invoice No.],a.bill_date as [Bill Date], convert(varchar(11),a.entry_date,103) as entry_date,a.amount as [Amount],a.Adv_Amt [Advance Amount],a.adv_cheque_No [Adv. Cheque no.],a.LOB as [LOB],'              
set @str=@str+'a.pan_no as [PAN No.],a.br_tag as [Expense To Br.Tag],a.st_no as [ST. No.], '          
set @str=@str+'case when convert(varchar(11),a.dis_date,103)=''01/01/1900'' then ''Not Dispatched'' else convert(varchar(11),a.dis_date,103) end as [Bill Dispatch Date],'          
set @str=@str+'a.courier_name as[Branch Courier],a.doc_no as [Br. Doc. No.],'              
set @str=@str+'convert(varchar(11),a.exp_fdt,103) as [Expense from date],convert(varchar(11),a.exp_tdt,103) as [Expense to date],'          
set @str=@str+'a.r_date [Bill Rec. Date],a.in_status as [Bill Status],a.cso_date [Cheque Date],a.pay_amount as [Cheque Amount],a.cheque_no as [Cheque No.],a.eid_cso as [CSO Username],'              
set @str=@str+'case when convert(varchar(11),a.d_date,103)=''01/01/1900'' then ''Not Dispatched'' else convert (varchar(11),a.d_date,103) end  as [Cheque Dispatch Date],'              
set @str=@str+'a.courier_name1 as [CSO Courier],a.doc_no1 as [CSO Doc No.],a.br_date as [Cheque Rec. date],Remark from billmaster a (nolock) inner join  '              
set @str=@str+'intranet.risk.dbo.user_login b on a.eid_branch =b.username '              
             
              
          
              
if @filter_type='1'              
begin              
set @filter=''                     
--set @filter=@filter+' where left(convert(varchar,a.entry_date,121),11)>=Convert(datetime,'''+@param1+''',103) and left(convert(varchar,a.entry_date,121),11) <=Convert(datetime,'''+@param2+''',103) and eid_branch  like '''+@param3+''''              
  
set @filter=@filter+' where  a.entry_date between  '''+@param1+ ''' and '''+@param2+''' and eid_branch  like '''+@param3+''''              
              
--print @filter          
end              
          
if @access_to='BRANCH'                              
                        
begin                                        
set @access_query=''                              
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by a.v_no '                            
end               
              
else if @access_to='REGION'                                          
begin                            
set @access_query=''                              
set @access_query=@access_query+' and ( a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''') or a.branch='''+@access_code+''' ) order by a.v_no'                              
end                
              
else if @access_to='BRMAST'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and ( a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or a.branch='''+@access_code+''' ) order by a.V_NO '                            
end                       
                       
else if @access_to='BROKER'                                        
begin                            
set  @access_query=''                              
set @access_query=@access_query+' and  a.branch like '''+@access_code+''' order by a.V_NO '                            
end                   
            
              
set @final=''                  
set @final=@final+@str+@filter+@access_query                  
--print(@final)                 
exec(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MIS_Global1Bynew
-- --------------------------------------------------
create PROCEDURE usp_MIS_Global1Bynew              
(                                         
@filter_type as varchar(10),                  
@access_to as varchar(25),                                        
@access_code as varchar(25),                            
@param1 as varchar(25),                        
@param2 as varchar(25),                             
@param3 as varchar(60)                          
              
)                                          
as                                           
declare @str as varchar(2000)                            
declare @filter as varchar(600)                            
declare @access_query as varchar(600)                            
declare @final as varchar(5000)     
SET @param1=CONVERT(datetime,@param1,103)        
SET @param2=CONVERT(datetime,@param2,103)  
   
                   
set @str=''               
set @str=@str+'select a.v_no as [IO_Srno],a.Branch as [Branch],a.eid_branch as [Branch Userid],b.person_name as [Branch Username],'              
set @str=@str+'a.acname as [Vendor Name],a.longname as [Cheque Name],a.vcode as [Vendor Code],'          
set @str=@str+'a.Segment as [Segment],a.inv_no as [Invoice No.],a.bill_date as [Bill Date], convert(varchar(11),a.entry_date,103) as entry_date,a.amount as [Amount],a.Adv_Amt [Advance Amount],a.adv_cheque_No [Adv. Cheque no.],a.LOB as [LOB],'              
set @str=@str+'a.pan_no as [PAN No.],a.br_tag as [Expense To Br.Tag],a.st_no as [ST. No.], '          
set @str=@str+'case when convert(varchar(11),a.dis_date,103)=''01/01/1900'' then ''Not Dispatched'' else convert(varchar(11),a.dis_date,103) end as [Bill Dispatch Date],'          
set @str=@str+'a.courier_name as[Branch Courier],a.doc_no as [Br. Doc. No.],'              
set @str=@str+'convert(varchar(11),a.exp_fdt,103) as [Expense from date],convert(varchar(11),a.exp_tdt,103) as [Expense to date],'          
set @str=@str+'a.r_date [Bill Rec. Date],a.in_status as [Bill Status],a.cso_date [Cheque Date],a.pay_amount as [Cheque Amount],a.cheque_no as [Cheque No.],a.eid_cso as [CSO Username],'              
set @str=@str+'case when convert(varchar(11),a.d_date,103)=''01/01/1900'' then ''Not Dispatched'' else convert (varchar(11),a.d_date,103) end  as [Cheque Dispatch Date],'              
set @str=@str+'a.courier_name1 as [CSO Courier],a.doc_no1 as [CSO Doc No.],a.br_date as [Cheque Rec. date],Remark from billmaster a (nolock) inner join  '              
set @str=@str+'intranet.risk.dbo.user_login b on a.eid_branch =b.username '              
             
              
          
              
if @filter_type='1'              
begin              
set @filter=''                     
--set @filter=@filter+' where left(convert(varchar,a.entry_date,121),11)>=Convert(datetime,'''+@param1+''',103) and left(convert(varchar,a.entry_date,121),11) <=Convert(datetime,'''+@param2+''',103) and eid_branch  like '''+@param3+''''              
  
set @filter=@filter+' where  a.entry_date between  '''+@param1+ ''' and '''+@param2+''' and eid_branch  like '''+@param3+''''              
              
--print @filter          
end              
          
if @access_to='BRANCH'                              
                        
begin                                        
set @access_query=''                              
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by a.v_no '                            
end               
              
else if @access_to='REGION'                                          
begin                            
set @access_query=''                              
set @access_query=@access_query+' and ( a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''') or a.branch='''+@access_code+''' ) order by a.v_no'                              
end                
              
else if @access_to='BRMAST'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and ( a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or a.branch='''+@access_code+''' ) order by a.V_NO '                            
end                       
                       
else if @access_to='BROKER'                                        
begin                            
set  @access_query=''                              
set @access_query=@access_query+' and  a.branch like '''+@access_code+''' order by a.V_NO '                            
end                   
            
              
set @final=''                  
set @final=@final+@str+@filter+@access_query                  
print(@final)                 
--exec(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MIS_Global1ByTest
-- --------------------------------------------------
CREATE PROCEDURE usp_MIS_Global1ByTest           
(                                       
@filter_type as varchar(10),                
@access_to as varchar(25),                                      
@access_code as varchar(25),                          
@param1 as varchar(60),                      
@param2 as varchar(60),                           
@param3 as varchar(60)                        
            
)                                        
as  
                                       
declare @str as varchar(2000)                          
declare @filter as varchar(600)                          
declare @access_query as varchar(600)                          
declare @final as varchar(5000)                          
set @str=''             
set @str=@str+'select a.v_no as [IO_Srno],a.Branch as [Branch],a.eid_branch as [Branch Userid],b.person_name as [Branch Username],'            
set @str=@str+'a.acname as [Vendor Name],a.longname as [Cheque Name],a.vcode as [Vendor Code],'        
set @str=@str+'a.Segment as [Segment],a.inv_no as [Invoice No.],a.bill_date as [Bill Date],a.amount as [Amount],a.Adv_Amt [Advance Amount],a.adv_cheque_No [Adv. Cheque no.],a.LOB as [LOB],'            
set @str=@str+'a.pan_no as [PAN No.],a.br_tag as [Expense To Br.Tag],a.st_no as [ST. No.], '        
set @str=@str+'case when convert(varchar(11),a.dis_date,103)=''01/01/1900'' then ''Not Dispatched'' else convert(varchar(11),a.dis_date,103) end as [Bill Dispatch Date],'        
set @str=@str+'a.courier_name as[Branch Courier],a.doc_no as [Br. Doc. No.],'            
set @str=@str+'convert(varchar(11),a.exp_fdt,103) as [Expense from date],convert(varchar(11),a.exp_tdt,103) as [Expense to date],'        
set @str=@str+'a.r_date [Bill Rec. Date],a.in_status as [Bill Status],a.cso_date [Cheque Date],a.pay_amount as [Cheque Amount],a.cheque_no as [Cheque No.],a.eid_cso as [CSO Username],'            
set @str=@str+'case when convert(varchar(11),a.d_date,103)=''01/01/1900'' then ''Not Dispatched'' else convert (varchar(11),a.d_date,103) end  as [Cheque Dispatch Date],'            
set @str=@str+'a.courier_name1 as [CSO Courier],a.doc_no1 as [CSO Doc No.],a.br_date as [Cheque Rec. date],Remark from billmaster a (nolock) inner join  '            
set @str=@str+'intranet.risk.dbo.user_login b on a.eid_branch =b.username '            
           
            
        
            
if @filter_type='1'            
begin            
set @filter=''                   
set @filter=@filter+' where left(convert(varchar,a.entry_date,121),11)>=Convert(datetime,'''+@param1+''',103) and left(convert(varchar,a.entry_date,121),11) <=Convert(datetime,'''+@param2+''',103) and eid_branch  like '''+@param3+''''            
            
--print @filter        
end            
        
if @access_to='BRANCH'                            
                      
begin                                      
set @access_query=''                            
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by a.v_no '                          
end             
            
else if @access_to='REGION'                                        
begin                          
set @access_query=''                            
set @access_query=@access_query+' and a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''') or a.branch='''+@access_code+''' order by a.v_no'                            
end              
            
else if @access_to='BRMAST'                                      
begin                          
set  @access_query=''                            
set  @access_query=@access_query+' and  a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or a.branch='''+@access_code+''' order by a.V_NO '                          
end                     
                     
else if @access_to='BROKER'                                      
begin                          
set  @access_query=''                            
set @access_query=@access_query+' and  a.branch like '''+@access_code+''' order by a.V_NO '                          
end                 
          
            
set @final=''                
set @final=@final+@str+@filter+@access_query                
print(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew
-- --------------------------------------------------
CREATE Proc usp_MisNew                             
(                                          
@filter_type as varchar(10),                  
@access_to as varchar(25),                                        
@access_code as varchar(25),                            
@param1 as varchar(60),                        
@param2 as varchar(60),                             
@param3 as varchar(60),                          
@param4 as varchar(60),                             
@param5 as varchar(60)                                         
)                                          
as                                           
declare @str as varchar(2000)                            
declare @filter as varchar(600)                            
declare @access_query as varchar(600)                            
declare @final as varchar(5000)                            
declare @post as varchar(500)                           
declare @fdt as varchar(30)                  
declare @tdt as varchar(30)                    
                         
---print @param1                  
--print @param2                    
if @access_to='BRANCH'                              
                        
begin                                        
set @access_query=''                              
set @access_query=@access_query+' and a.branch='''+@access_code+''' order by a.V_NO '                            
end                            
--print @access_query                            
else if @access_to='REGION'                                          
begin                            
set @access_query=''                              
set @access_query=@access_query+' and a.branch in (select code from intranet.risk.dbo.region where reg_code = '''+@access_code+''') or a.branch='''+@access_code+''''                              
end                            
                            
                                       
else if @access_to='BRMAST'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and  a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = '''+@access_code+''') or a.branch= '''+@access_code+''' order by a.V_NO '                            
end                       
                       
else if @access_to='BROKER'                                        
begin                            
set  @access_query=''                              
set  @access_query=@access_query+' and  a.branch like ''%'' order by a.V_NO '                            
end                            
                            
                  
if @filter_type='1'                            
begin                    
                  
set @fdt= convert(datetime,@param1,103)                  
set @tdt= convert(datetime,@param2,103)                  
--Print @param1                  
--Print @param2                  
--Print @fdt                  
--Print @tdt                  
set @filter=''                            
set @filter=@filter+' where a.dis_date>='''+@fdt+''' and a.dis_date<='''+@tdt+''''                            
end                            
else if @filter_type='2'                            
begin                            
set @filter=''                            
set @filter=@filter+' where a.inv_no='''+@param1+''''                            
end                          
else if @filter_type='3'                        
begin                         
set @filter=''                        
set @filter=@filter+' where a.segment='''+@param1+''' and a.acname='''+@param2+''' and a.vcode='''+@param3+''''                        
end                        
                  
else if @filter_type='4'                        
begin                   
set @fdt=convert(datetime,@param1,103)                  
set @tdt=convert(datetime,@param2,103)                      
set @filter=''                        
set @filter=@filter+' where a.d_date>='''+@fdt+''' and a.d_date<='''+@tdt+''''                  
                  
end                     
                  
                  
else if @filter_type='5'                            
begin                            
set @filter=''                            
set @filter=@filter+' where a.cheque_no='''+@param1+''''                            
end                       
                
else if @filter_type='6'                            
begin                            
set @filter=''                            
set @filter=@filter+' where a.v_no='''+@param1+''''                         
end                       
  else if @filter_type='7'                            
begin                            
set @filter=''                            
set @filter=@filter+' where a.longname like ''%'+@param1+'%'''                            
end                       
                  
 else if @filter_type='8'                            
begin                            
set @filter=''                            
set @filter=@filter+' where a.segment like '''+@param1+''' and a.vcode='''+@param2+''''                            
end                   
            
else if @filter_type='9'                      
begin                         
set @filter=''                        
set @filter=@filter+' where Courier_name1 like ''CHEQUE PRINTED AT BRANCH LOCATION'' and cso_flag=''1''  and d_date=convert(datetime,'''+@param1+''',103) and a.eid_branch like '''+@param4+''''                
                    
end               
                  
--else if @filter_type='7'                            
--begin                       
--set @fdt=convert(datetime,@param1,103)                  
--set @tdt=convert(datetime,@param2,103)                       
--set @filter=''                            
--set @filter=@filter+' where Convert(datetime,a.Bill_date,103)> as Bill_date ='''+@fdt+''' and Convert(datetime,a.Bill_date,103)as Bill_date<='''+@tdt+''''                            
--end                      
                           
set @str=''                          
set @str=@str+'select a.v_no,a.eid_branch,a.LOB,a.branch,a.br_tag,b.person_name,a.acname,a.longname,'                       
set @str=@str+'a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,'        
      
set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'                       
--set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'                       
--set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'                             
--set @str=@str+'a.r_date,a.in_status,a.cso_date,a.pay_amount,'         
set @str=@str+'a.cheque_no,a.eid_cso,c.person_name as pname,convert(varchar(11),a.d_date,103)'                             
set @str=@str+'as d_date,a.br_date,a.dest_branch,convert (varchar(11),a.due_date,103) as due_date,a.chequedispatchedat from billmaster a (nolock)'                             
set @str=@str+'inner join  intranet.risk.dbo.user_login b on a.eid_branch=b.username '                  
set @str=@str+'inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username'                  
                  
set @final=''                  
set @final=@final+@str+@filter+@access_query                  
--print(@final)                  
exec(@final)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_acname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_acname]  
(                  
@seg as varchar(10),@acname as varchar(85),@vcode as varchar(12), @str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username      
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode and a.branch=@str2 order by a.v_no      
      
end                  
            
 if @str1='region'                   
begin              
             
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username      
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode  and       
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)       
 order by a.V_NO            
end                  
            
if @str1='broker'                   
begin            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username      
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode  order by a.v_no        
end            
if @str1='BRMAST'                  
begin               
            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on a.eid_cso=c.username      
where a.segment =@seg and a.acname=@acname and a.vcode=@vcode   
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
order by a.V_NO                 
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_bdt
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_bdt]         
(                  
@fdt as datetime,@tdt as datetime,@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark    
,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt and a.branch=@str2 order by a.v_no      
end                  
            
 if @str1='region'                   
begin              
             
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark    
,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt  and       
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)       
 order by a.V_NO            
end                  
            
if @str1='broker'                   
begin            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark    
,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt  order by a.v_no        
end            
if @str1='BRMAST'                  
begin               
            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark    
,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from       
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.d_date>=@fdt and a.d_date<=@tdt and  
(a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
order by a.V_NO                 
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_cno
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_cno]    
(                
@cno as varchar(15),@str1 as varchar(25),@str2 as varchar(25)                 
)                
 as                 
set nocount on                 
set transaction isolation level read uncommitted                          
                      
if @str1='branch'                 
begin              
select a.v_no,a.eid_branch,a.br_tag,a.branch,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.cheque_no=@cno and a.branch=@str2  
order by a.v_no  
end                
          
 if @str1='region'                 
begin            
           
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.cheque_no=@cno and     
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)     
 order by a.v_no          
end                
          
if @str1='broker'                 
begin          
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.cheque_no=@cno order by a.v_no  
end          
if @str1='BRMAST'                
begin             
          
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,      
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,      
a.r_date,a.in_status,a.cso_date,a.pay_amount,      
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)      
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on       
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on       
a.eid_cso=c.username where a.cheque_no=@cno   
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)     
order by a.V_NO               
            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_csodt
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_csodt]           
(                    
@fdt as datetime,@tdt as datetime,@str1 as varchar(25),@str2 as varchar(25)                     
)                    
 as                     
set nocount on                     
set transaction isolation level read uncommitted                              
                          
if @str1='branch'                     
begin                  
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt and a.branch=@str2 order by a.v_no        
end                    
              
 if @str1='region'                     
begin                
               
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt  and         
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)         
 order by a.V_NO              
end                    
              
if @str1='broker'                     
begin              
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt  order by a.v_no          
end              
if @str1='BRMAST'                    
begin                 
              
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.dis_date>=@fdt and a.dis_date<=@tdt and    
(a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)         
order by a.V_NO                   
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_inv
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_inv]      
(                  
@inv as varchar(50),@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.inv_no =@inv and a.branch=@str2 order by a.v_no      
end                  
            
 if @str1='region'                   
begin              
             
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.inv_no =@inv  and       
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)       
 order by a.V_NO            
end                  
            
if @str1='broker'                   
begin            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.inv_no =@inv order by a.v_no        
end            
if @str1='BRMAST'                  
begin               
            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.inv_no =@inv      
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
order by a.V_NO                 
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_lname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_lname]      
(                  
@lname as varchar(50),@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where     
a.longname like @lname and a.branch=@str2    
order by a.v_no    
end                  
            
 if @str1='region'                   
begin              
             
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.longname like @lname and       
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)       
 order by a.v_no            
end                  
            
if @str1='broker'                   
begin            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.longname like @lname order by a.v_no    
end            
if @str1='BRMAST'                  
begin               
            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.longname like @lname    
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
order by a.V_NO                 
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_vcode
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_vcode]  
(                  
@seg as varchar(10), @vcode as varchar(15),@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where     
a.segment=@seg and a.vcode=@vcode and a.branch=@str2    
order by a.v_no    
end                  
            
 if @str1='region'                   
begin              
             
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.segment=@seg and a.vcode=@vcode and       
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2)       
 order by a.v_no            
end                  
            
if @str1='broker'                   
begin            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.segment=@seg and a.vcode=@vcode order by a.v_no    
end            
if @str1='BRMAST'                  
begin               
            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.segment=@seg and a.vcode=@vcode    
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
order by a.V_NO                 
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MisNew_vno
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MisNew_vno]  
(                  
@vno as varchar(15),@str1 as varchar(25),@str2 as varchar(25)                   
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
                        
if @str1='branch'                   
begin                
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where     
a.v_no=@vno and a.branch=@str2    
order by a.v_no    
end                  
            
 if @str1='region'                   
begin              
             
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from         
billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.v_no=@vno and       
(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2)       
 order by a.v_no            
end                  
            
if @str1='broker'                   
begin            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.v_no=@vno order by a.v_no    
end            
if @str1='BRMAST'                  
begin               
            
select a.v_no,a.eid_branch,a.branch,a.br_tag,b.person_name,a.acname,a.longname,        
a.vcode,a.segment,a.inv_no,a.bill_date,a.amount,a.remark      
,convert (varchar(11),a.dis_date,103) as dis_date,        
a.r_date,a.in_status,a.cso_date,a.pay_amount,        
a.cheque_no,a.eid_cso,c.person_name as pname,convert (varchar(11),a.d_date,103)        
as d_date,a.br_date from billmaster a (nolock) inner join  intranet.risk.dbo.user_login b on         
a.eid_branch=b.username  inner join intranet.risk.dbo.user_login c on         
a.eid_cso=c.username where a.v_no=@vno    
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)       
order by a.V_NO                 
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_NotreceivedbyCSO
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_NotreceivedbyCSO]           
(                      
@str1 as varchar(25),@str2 as varchar(25),@action as varchar(10),@uname as varchar(40)                       
)                      
 as                    
set nocount on                       
set transaction isolation level read uncommitted                                
                          
if @action='ALL'         
begin             
if @str1='branch'                 
begin                
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,            
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and a.branch=@str2   order by a.V_NO                 
                
end                
 if @str1='region'                 
begin                 
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,             
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2)  order by a.V_NO                   
end                
if @str1='broker'                 
begin                
                
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,              
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1'and a.r_flag='0' and a.branch=@str2 order by a.V_NO                   
end                
if @str1='BRMAST'                
begin                
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,              
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)or a.branch=@str2) order by a.V_NO               
end         
end      
        
      
      
      
if @action='Userwise'         
begin             
if @str1='branch'                 
begin                
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,              
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and a.branch=@str2 and a.eid_branch=@uname order by a.V_NO                 
                
end                
 if @str1='region'                 
begin                 
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,             
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and a.eid_branch=@uname  and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or a.branch=@str2)  order by a.V_NO                   
end                
if @str1='broker'                 
begin                
                
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,              
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on             
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and a.branch=@str2 and a.eid_branch=@uname  order by a.V_NO                   
end                
if @str1='BRMAST'                
begin                
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.inv_no,a.bill_date,convert(varchar(11),a.dis_date,103) as dis_date,              
a.amount,a.Br_Tag from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on         
a.eid_branch=b.username where a.branch_flag='1' and a.r_flag='0' and a.eid_branch=@uname  and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2)or a.branch=@str2) order by a.V_NO               
end         
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_NotreceivedByCSO_uname
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_NotreceivedByCSO_uname]        
(                    
@str1 as varchar(25),@str2 as varchar(25)                     
)                    
 as                     
set nocount on                     
set transaction isolation level read uncommitted                              
                          
if @str1='branch'                     
begin                  
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username     
where a.branch_flag='1' and a.r_flag='0' and a.branch=@str2    
end                    
              
 if @str1='region'                     
begin                
               
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username     
where a.branch_flag='1' and a.r_flag='0' and(a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)         
    
end                    
              
if @str1='broker'                     
begin              
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username     
where a.branch_flag='1' and a.r_flag='0' and a.branch=@str2           
end              
if @str1='BRMAST'                    
begin                 
              
select distinct a.eid_branch as eid,b.person_name as pname from billmaster a (nolock) inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username     
where a.branch_flag='1' and a.r_flag='0'  
and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2)         
    
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_pendingcheque2dispatch
-- --------------------------------------------------
CREATE proc usp_pendingcheque2dispatch --'BROKER','CSO'  
(  
@access_to as varchar(25),  
@access_code as varchar(25)  
)  
  
as  
select a.v_no as [IO Sr.No.],a.Branch,b.Person_name as [Branch User],a.vcode as [Vendor Code],a.Segment,a.cso_date as [Cheque Creation Date],  
DATEDIFF(day,convert(datetime,a.cso_date,103),getdate()) as [No.Of Days since cheque ready],a.acname[Vendor Name],  
a.longname[Cheque Name],a.Inv_no,a.Amount as [Bill Amount],a.pay_amount as [Cheque Amount],a.br_tag[Expense to BrTag],a.LOB  
from billmaster a  
inner join intranet.risk.dbo.user_login b on a.eid_branch=b.username   
where a.cso_flag='1' and a.comp_flag='0' and eid_cso<>'' and convert(datetime,a.cso_date,103)<=getdate()-10  
order by convert(datetime,a.cso_date,103)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SetFY
-- --------------------------------------------------
CREATE proc Usp_SetFY
as

select FYNAME,FYCode from FY_Mast with (nolock) where FYVisible=1 order by FYseries desc
/* This Proc is created to fill dropdown of FY in VMS set Visible=1 to visible true and 0 to set visible false*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_show_dg_dis
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_show_dg_dis]     
(      
@str1 as varchar(25)       
)      
 as       
set nocount on       
set transaction isolation level read uncommitted                
      
      
if @str1 ='ALL'      
begin       
      
Select a.v_no,b.person_name,a.branch,a.dest_branch,a.segment,a.acname,a.vcode,a.longname,a.inv_no,    
a.amount,a.pay_amount,a.cheque_no,a.cso_date from billmaster a (nolock) inner join    
intranet.risk.dbo.user_login b on a.eid_branch=b.username    
where a.branch_flag='1' and a.cso_flag='1' and a.comp_flag='0' order by a.v_no    
    
end     
if @str1<>'ALL'    
begin    
      
Select a.v_no,b.person_name,a.branch,a.dest_branch,a.segment,a.acname,a.vcode,a.longname,a.inv_no,    
a.amount,a.pay_amount,a.cheque_no,a.cso_date from billmaster a (nolock) inner join    
 intranet.risk.dbo.user_login b on a.eid_branch=b.username    
where a.branch=@str1 and a.branch_flag='1' and a.cso_flag='1' and a.comp_flag='0' order by a.v_no    
    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_show_dg1
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_show_dg1]         
(          
@str1 as varchar(25),@uname as varchar(60)           
)          
 as           
set nocount on           
set transaction isolation level read uncommitted                    
          
          
if @str1 ='ALL'          
begin           
    
if @uname ='ALL'    
begin       
select a.v_no,b.person_name,a.branch,a.br_tag,a.acname,a.longname,a.vcode,        
a.segment,a.amount,a.inv_no,a.pan_no,a.st_no,a.doc_no,        
a.courier_name,convert (varchar(11),a.dis_date,103) as dis_date from billmaster a (nolock)inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username           
where a.branch_flag='1'  and a.r_flag='0' order by a.v_no        
end       
      
if @uname<>'ALL'  
begin    
select a.v_no,b.person_name,a.branch,a.br_tag,a.acname,a.longname,a.vcode,        
a.segment,a.amount,a.inv_no,a.pan_no,a.st_no,a.doc_no,        
a.courier_name,convert (varchar(11),a.dis_date,103) as dis_date from billmaster a (nolock)inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username           
where a.branch_flag='1'  and a.r_flag='0' and b.person_name=@uname    
end    
end    
    
if @str1<>'ALL'        
begin        
 if @uname='ALL'     
begin    
select a.v_no,b.person_name,a.branch,a.br_tag,a.acname,a.longname,a.vcode,        
a.segment,a.amount,a.inv_no,a.pan_no,a.st_no,a.doc_no,        
a.courier_name,convert (varchar(11),a.dis_date,103) as dis_date from billmaster a (nolock)inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username  where a.branch=@str1 and a.branch_flag='1'         
and a.r_flag='0' order by a.v_no        
end    
if @uname<>'ALL'   
begin    
select a.v_no,b.person_name,a.branch,a.br_tag,a.acname,a.longname,a.vcode,        
a.segment,a.amount,a.inv_no,a.pan_no,a.st_no,a.doc_no,        
a.courier_name,convert (varchar(11),a.dis_date,103) as dis_date from billmaster a (nolock)inner join         
intranet.risk.dbo.user_login b on a.eid_branch=b.username  where a.branch=@str1 and a.branch_flag='1'         
and a.r_flag='0' and b.person_name=@uname        
end        
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_show_dgrc
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_show_dgrc]           
(            
@str1 as varchar(25),@str2 as varchar(25)             
)            
 as             
set nocount on             
set transaction isolation level read uncommitted                      
                  
if @str1='branch'             
begin          
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,        
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join           
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.r_flag1='0' and a.comp_flag='1' and a.branch= @str2 ORDER BY a.V_NO       
end            
      
 if @str1='region'             
begin        
       
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,        
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join           
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.r_flag1='0' and a.comp_flag='1' and (a.branch in (select code from intranet.risk.dbo.region where reg_code=@str2) or  a.branch=@str2)  order by a.V_NO      
end            
      
if @str1='broker'             
begin      
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,        
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join           
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.r_flag1='0' and a.comp_flag='1' and a.branch= @str2 ORDER BY a.V_NO      
end      
if @str1='BRMAST'            
begin         
      
select a.v_no,b.person_name,a.acname,a.longname,a.vcode,a.segment,a.inv_no,a.amount,a.pay_amount,a.cheque_no,        
a.courier_name1,a.doc_no1,convert(varchar(11),a.d_date,103)as d_date from billmaster a (nolock) inner join           
intranet.risk.dbo.user_login b on a.eid_branch=b.username             
where a.r_flag1='0' and a.comp_flag='1' and (a.branch in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str2) or a.branch=@str2) order by a.V_NO           
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_updatebilldetails
-- --------------------------------------------------
CREATE PROCEDURE usp_UpdateBillDetails             
(          
@action_type as varchar(10),              
@username as varchar(20),
@param1 as varchar(80),
@param2 as varchar(80),
@param3 as varchar(80),
@param4 as varchar(80),
@param5 as varchar(80),
@filter1 as varchar(80)
--@filter2 as varchar(80)
)                        
 as                      
set nocount on                         
set transaction isolation level read uncommitted  

if @action_type='1' --To update recevied by CSO 
begin
update billmaster set r_flag ='1',r_date=@param1,in_status= @param2 where v_no=@filter1
end
if @action_type='2' --To update Dispatch to CSO 
begin

update billmaster set in_status='Bill Dispatched To CSO', branch_flag ='1',dis_date=convert(datetime,@param1,103),doc_no=@param2,courier_name=@param3,dest_branch=@param4 where v_no=@filter1
end
if @action_type='3' --To update Cheque Dispatch to CSO
begin

update billmaster set in_status='Cheque Dispatched', courier_name1=@param1, to_branch=@param2 ,doc_no1 =@param3,d_date =convert(datetime,@param4,103), comp_flag='1'  where v_no=@filter1
end

if @action_type='4' --To update Check no. amount ect(Bill process).
                      
begin

update billmaster set in_status ='Cheque Created',cheque_no=@param1,cso_date=@param2,eid_cso=@param3,pay_amount=@param4,cso_flag= '1' where v_no=@filter1        

end
if @action_type='5' --To update expense from date and expense to date information
begin

update billmaster set exp_fdt=convert(datetime,@param1,103),exp_tdt=convert(datetime,@param2,103) where v_no=@filter1

end
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_usernames_branch_All
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_usernames_branch_All]       
(          
  @branch as varchar(25))  
 as         
set nocount on         
set transaction isolation level read uncommitted                        

select distinct eid_branch,branch into #file1 from billmaster where branch_flag=1 and r_flag=0    
    


select a.*,b.person_name from #file1 a left outer join intranet.risk.dbo.user_login b on a.eid_branch =b.username

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_usernames_branchside
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_usernames_branchside]          
(            
  @branch as varchar(25))    
 as           
set nocount on           
set transaction isolation level read uncommitted                          
  
select distinct eid_branch,branch into #file1 from billmaster (nolock) where branch_flag=1 and r_flag=0      
      

  
select a.*,b.person_name from #file1 a left outer join intranet.risk.dbo.user_login b on a.eid_branch =b.username where a.branch=@branch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_venDetails_used
-- --------------------------------------------------
CREATE PROCEDURE usp_venDetails_used                        
(                                    
@fdt as datetime,@tdt as datetime,@type as varchar(10)                                     
)                                    
 as                                     
set nocount on                                     
set transaction isolation level read uncommitted             
select v_no,inv_no,narration,v_date,emp_no,segment,ven_name,          
ven_code,entry_date,status,total into #file1 from vouchermaster (nolock) where len(v_date)>=10          
      
select v_no,inv_no,narration,convert(datetime,v_date,103) as v_date, emp_no,segment,ven_name,          
ven_code,entry_date,status,total into #file2 from #file1          
      
if @type='TDS'              
begin              
--select * into #t1 from vouchermaster where narration like '%TDS%' and entry_date>=@fdt and entry_date<=@tdt              
--select distinct ven_code,segment into #file1 from #t1              
--select b.* from #file1 a  right outer join vendormaster b on a.ven_code=b.cltcode and a.segment=b.segment where a.ven_code is not null and a.segment is not null order by segment              
             
select * into #temp1 from #file2 where narration like '%TDS%' and v_date>=@fdt and v_date<=@tdt              
select distinct ven_code,segment into #temp2 from #temp1              
select b.* from #temp2 a  right outer join vendormaster b (nolock) on a.ven_code=b.cltcode and a.segment=b.segment where a.ven_code is not null and a.segment is not null order by segment              
end          
           
if @type='ALL'              
begin              
--select * into #t from vouchermaster where entry_date>=@fdt and entry_date<=@tdt              
--select distinct ven_code,segment into #file from #t              
--select b.* from #file a  right outer join vendormaster b on a.ven_code=b.cltcode and a.segment=b.segment where a.ven_code is not null and a.segment is not null               
          
select * into #temp3 from #file2 where v_date>=@fdt and v_date<=@tdt            
select distinct ven_code,segment into #temp4 from #temp3              
select b.* from #temp4 a  right outer join vendormaster b (nolock) on a.ven_code=b.cltcode and a.segment=b.segment where a.ven_code is not null and a.segment is not null               
          
end         
        
if @type='ST'        
begin        
        
select * into #file3 from #file2 where v_date>=@fdt and v_date<=@tdt          
        
select * into #file4 from voucherentry (nolock) where v_code = '400002' and v_no in (select v_no from #file3)        
        
select distinct v_no as v_no into #file5 from #file4        
        
select ven_code,segment into #file6 from vouchermaster (nolock) where v_no in (select v_no from #file5)        
        
select a.ven_code,a.segment as seg,b.* into #file7 from #file6 a  right outer join vendormaster b (nolock) on         
a.ven_code=b.cltcode and a.segment=b.segment where a.ven_code is not null and a.segment is not null         
       
select distinct cltcode,segment into #file8 from #file7        
      
select b.* from #file8 a  right outer join vendormaster b (nolock) on         
a.cltcode=b.cltcode and a.segment=b.segment where a.cltcode is not null and a.segment is not null order by a.segment       
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_VendorDetail
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_VendorDetail]        
(              
@str1 as varchar(25),@str2 as varchar(25),@str3 as varchar(25)               
)              
 as            
set nocount on               
set transaction isolation level read uncommitted                        
              
        
        
if @str1='branch'         
begin        
select acname,longname,cltcode,segment,branchCode,Pan_No,ST_No from vendormaster (nolock)         
where (branchcode=@str3 or branchcode='all') and segment=@str2 order by acname        
        
end        
 if @str1='region'         
begin         
select acname,longname,cltcode,segment,branchCode,Pan_No,ST_No from vendormaster (nolock)        
where (branchcode in (select code from intranet.risk.dbo.region where reg_code=@str3) or branchcode='all') and         
segment=@str2 order by acname        
end        
if @str1='broker'         
begin        
        
select acname,longname,cltcode,segment,branchCode,Pan_No,ST_No from vendormaster (nolock)         
where segment=@str2 order by acname        
end        
if @str1='BRMAST'        
begin        
select acname,longname,cltcode,segment,branchCode,Pan_No,ST_No from vendormaster (nolock)        
where SEGMENT=@STR2 AND (branchcode in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str3)      
or branchcode='All') order by acname     
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_VendorDetail_initial
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_VendorDetail_initial]         
(                
@str1 as varchar(25),@str2 as varchar(25),@str3 as varchar(25),@vname as varchar(25)                 
)                
 as              
set nocount on                 
set transaction isolation level read uncommitted                          
                
          
          
if @str1='branch'           
begin          
select acname from vendormaster (nolock)           
where (branchcode=@str3 or branchcode='all') and segment=@str2 and acname like @vname+'%' order by acname          
          
end          
 if @str1='region'           
begin           
select acname from vendormaster (nolock)          
where (branchcode in (select code from intranet.risk.dbo.region where reg_code=@str3) or branchcode='all') and           
segment=@str2 and acname like @vname+'%' order by acname          
end          
if @str1='broker'           
begin          
          
select acname from vendormaster (nolock)           
where segment=@str2 and acname like @vname+'%' order by acname          
end          
if @str1='BRMAST'          
begin          
select acname from vendormaster (nolock)          
where SEGMENT=@STR2 AND (branchcode in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@str3)        
or branchcode='All') and acname like @vname+'%' order by acname       
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_vmsdailycheck
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[usp_vmsdailycheck]                 
(                  
@fdt as datetime,@tdt as datetime      
)                  
 as                   
set nocount on                   
set transaction isolation level read uncommitted                            
          
          
--declare @fdt as datetime          
--declare @tdt as datetime          
--set @fdt ='2008-11-29'           
--set @tdt ='2008-11-29'          
  

                  
select * into #file1 from vouchermaster (nolock) where entry_date>=@fdt and entry_date<= @tdt    
          
          
          
select * into #file2 from voucherentry (nolock) where v_no in (select v_no from #file1)           
          
          
select * into #file3 from #file2 where v_code like '27%' or v_code like '31%' and drcr='c'          
          
          
          
select a.*,b.amount,b.br_tag into #jvdata from  #file1 a left outer join #file3 b on a.v_no=b.v_no where b.drcr='C'          
          
select pv_no,jv_no,date,v_name_f,br_tag as pay_brtag,cheque_no,amount as cheque_amount,emp_id,io_srno into #pvdata from paymentmaster where jv_no in (select v_no from #jvdata)          
  --select * from #Jvdata        
select a.*,b.pan_no,b.st_no into #jvdata1 from #jvdata a left outer join vendormaster b (nolock) on a.ven_code=b.cltcode and a.segment=b.segment        
select a.*,b.* into #finaldata from #jvdata1 a left outer join #pvdata b on a.v_no=b.jv_no           
        
select io_srno[IO No.],v_no[JV No.],pv_no[PV No.],inv_no[Inv. No.],v_date[Bill Date],          
Segment,ven_code [Vendor Code],ven_name[Vendor],pan_no [PAN No.],st_no [ST. No.] ,    
amount [Bill Amount],emp_no[JV Empcode],          
total [Payment],br_tag[Br Tag JV],Date[Payment Date],v_name_f[Cheque Name],          
cheque_amount[Paid Amount],cheque_no[Cheque No],pay_brtag[Br Tag PV],Narration,emp_id[PV Empcode]          
from #finaldata

GO

-- --------------------------------------------------
-- TABLE dbo.1STUPLOAD_ABL
-- --------------------------------------------------
CREATE TABLE [dbo].[1STUPLOAD_ABL]
(
    [cltcode] VARCHAR(255) NULL,
    [acname] VARCHAR(255) NULL,
    [longname] VARCHAR(255) NULL,
    [branchcode] VARCHAR(255) NULL,
    [segment] VARCHAR(255) NULL,
    [prop_name] VARCHAR(255) NULL,
    [Pan_No] VARCHAR(255) NULL,
    [ST_No] VARCHAR(255) NULL,
    [Add1] VARCHAR(255) NULL,
    [KOPAR KHAIRANE] VARCHAR(255) NULL,
    [Add3] VARCHAR(255) NULL,
    [city] VARCHAR(255) NULL,
    [pin] VARCHAR(255) NULL,
    [State] VARCHAR(255) NULL,
    [Phone_No] VARCHAR(255) NULL,
    [email] VARCHAR(255) NULL,
    [Fax] VARCHAR(255) NULL,
    [Status] VARCHAR(255) NULL,
    [Services] VARCHAR(255) NULL,
    [tdsCode] VARCHAR(255) NULL,
    [emp_id] VARCHAR(255) NULL,
    [creat_date] VARCHAR(255) NULL,
    [Trade_Name] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACDL
-- --------------------------------------------------
CREATE TABLE [dbo].[ACDL]
(
    [Cheque_Number] VARCHAR(8000) NULL,
    [io_no] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.aprws10
-- --------------------------------------------------
CREATE TABLE [dbo].[aprws10]
(
    [SNo] INT NOT NULL,
    [Date] DATETIME NULL,
    [BranchName] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(50) NULL,
    [LOB] VARCHAR(50) NULL,
    [TPD] NUMERIC(18, 0) NULL,
    [Count] INT NULL,
    [Ratio] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.backup1
-- --------------------------------------------------
CREATE TABLE [dbo].[backup1]
(
    [v_no] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [branch] VARCHAR(50) NULL,
    [eid_branch] VARCHAR(20) NULL,
    [vcode] VARCHAR(50) NULL,
    [segment] VARCHAR(15) NULL,
    [bill_date] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [acname] VARCHAR(100) NULL,
    [longname] VARCHAR(100) NULL,
    [inv_no] VARCHAR(60) NULL,
    [amount] NUMERIC(18, 0) NULL,
    [pan_no] VARCHAR(50) NULL,
    [st_no] VARCHAR(50) NULL,
    [dis_date] DATETIME NULL,
    [courier_name] VARCHAR(150) NULL,
    [doc_no] VARCHAR(50) NULL,
    [r_date] VARCHAR(50) NULL,
    [in_status] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [cso_date] VARCHAR(50) NULL,
    [eid_cso] VARCHAR(20) NULL,
    [pay_amount] NUMERIC(18, 0) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [d_date] DATETIME NULL,
    [courier_name1] VARCHAR(150) NULL,
    [doc_no1] VARCHAR(50) NULL,
    [br_date] VARCHAR(50) NULL,
    [to_branch] VARCHAR(50) NULL,
    [exp_empid] VARCHAR(50) NULL,
    [dest_branch] VARCHAR(50) NULL,
    [remark] VARCHAR(60) NULL,
    [exp_fdt] DATETIME NULL,
    [exp_tdt] DATETIME NULL,
    [branch_flag] BIT NULL,
    [cso_flag] BIT NULL,
    [comp_flag] BIT NULL,
    [r_flag] BIT NULL,
    [r_flag1] BIT NULL,
    [LOB] VARCHAR(100) NULL,
    [Adv_Amt] NUMERIC(18, 0) NULL,
    [Adv_Cheque_No] VARCHAR(50) NULL,
    [Order_Maker] VARCHAR(55) NULL,
    [Due_Date] DATETIME NULL,
    [ChequeDispatchedAt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.backup2
-- --------------------------------------------------
CREATE TABLE [dbo].[backup2]
(
    [v_no] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [branch] VARCHAR(50) NULL,
    [eid_branch] VARCHAR(20) NULL,
    [vcode] VARCHAR(50) NULL,
    [segment] VARCHAR(15) NULL,
    [bill_date] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [acname] VARCHAR(100) NULL,
    [longname] VARCHAR(100) NULL,
    [inv_no] VARCHAR(60) NULL,
    [amount] NUMERIC(18, 0) NULL,
    [pan_no] VARCHAR(50) NULL,
    [st_no] VARCHAR(50) NULL,
    [dis_date] DATETIME NULL,
    [courier_name] VARCHAR(150) NULL,
    [doc_no] VARCHAR(50) NULL,
    [r_date] VARCHAR(50) NULL,
    [in_status] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [cso_date] VARCHAR(50) NULL,
    [eid_cso] VARCHAR(20) NULL,
    [pay_amount] NUMERIC(18, 0) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [d_date] DATETIME NULL,
    [courier_name1] VARCHAR(150) NULL,
    [doc_no1] VARCHAR(50) NULL,
    [br_date] VARCHAR(50) NULL,
    [to_branch] VARCHAR(50) NULL,
    [exp_empid] VARCHAR(50) NULL,
    [dest_branch] VARCHAR(50) NULL,
    [remark] VARCHAR(60) NULL,
    [exp_fdt] DATETIME NULL,
    [exp_tdt] DATETIME NULL,
    [branch_flag] BIT NULL,
    [cso_flag] BIT NULL,
    [comp_flag] BIT NULL,
    [r_flag] BIT NULL,
    [r_flag1] BIT NULL,
    [LOB] VARCHAR(100) NULL,
    [Adv_Amt] NUMERIC(18, 0) NULL,
    [Adv_Cheque_No] VARCHAR(50) NULL,
    [Order_Maker] VARCHAR(55) NULL,
    [Due_Date] DATETIME NULL,
    [ChequeDispatchedAt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.banks
-- --------------------------------------------------
CREATE TABLE [dbo].[banks]
(
    [bank_code] VARCHAR(25) NOT NULL,
    [bank_name] VARCHAR(100) NULL,
    [branch] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bill_status_log
-- --------------------------------------------------
CREATE TABLE [dbo].[bill_status_log]
(
    [v_no] NUMERIC(18, 0) NULL,
    [status] VARCHAR(150) NULL,
    [action_date] DATETIME NULL,
    [Action_by] VARCHAR(50) NULL,
    [Couriered_by] VARCHAR(100) NULL,
    [Doc_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.billmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[billmaster]
(
    [v_no] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [branch] VARCHAR(50) NULL,
    [eid_branch] VARCHAR(20) NULL,
    [vcode] VARCHAR(50) NULL,
    [segment] VARCHAR(15) NULL,
    [bill_date] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [acname] VARCHAR(100) NULL,
    [longname] VARCHAR(100) NULL,
    [inv_no] VARCHAR(60) NULL,
    [amount] NUMERIC(18, 0) NULL,
    [pan_no] VARCHAR(50) NULL,
    [st_no] VARCHAR(50) NULL,
    [dis_date] DATETIME NULL,
    [courier_name] VARCHAR(150) NULL,
    [doc_no] VARCHAR(50) NULL,
    [r_date] VARCHAR(50) NULL,
    [in_status] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [cso_date] VARCHAR(50) NULL,
    [eid_cso] VARCHAR(20) NULL,
    [pay_amount] NUMERIC(18, 0) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [d_date] DATETIME NULL,
    [courier_name1] VARCHAR(150) NULL,
    [doc_no1] VARCHAR(50) NULL,
    [br_date] VARCHAR(50) NULL,
    [to_branch] VARCHAR(50) NULL,
    [exp_empid] VARCHAR(50) NULL,
    [dest_branch] VARCHAR(50) NULL,
    [remark] VARCHAR(60) NULL,
    [exp_fdt] DATETIME NULL,
    [exp_tdt] DATETIME NULL,
    [branch_flag] BIT NULL,
    [cso_flag] BIT NULL,
    [comp_flag] BIT NULL,
    [r_flag] BIT NULL,
    [r_flag1] BIT NULL,
    [LOB] VARCHAR(100) NULL,
    [Adv_Amt] NUMERIC(18, 0) NULL,
    [Adv_Cheque_No] VARCHAR(50) NULL,
    [Order_Maker] VARCHAR(55) NULL,
    [Due_Date] DATETIME NULL,
    [ChequeDispatchedAt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BillMaster_Amit
-- --------------------------------------------------
CREATE TABLE [dbo].[BillMaster_Amit]
(
    [v_no] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [branch] VARCHAR(50) NULL,
    [eid_branch] VARCHAR(20) NULL,
    [vcode] VARCHAR(50) NULL,
    [segment] VARCHAR(15) NULL,
    [bill_date] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [acname] VARCHAR(100) NULL,
    [longname] VARCHAR(100) NULL,
    [inv_no] VARCHAR(60) NULL,
    [amount] NUMERIC(18, 0) NULL,
    [pan_no] VARCHAR(50) NULL,
    [st_no] VARCHAR(50) NULL,
    [dis_date] DATETIME NULL,
    [courier_name] VARCHAR(150) NULL,
    [doc_no] VARCHAR(50) NULL,
    [r_date] VARCHAR(50) NULL,
    [in_status] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [cso_date] VARCHAR(50) NULL,
    [eid_cso] VARCHAR(20) NULL,
    [pay_amount] NUMERIC(18, 0) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [d_date] DATETIME NULL,
    [courier_name1] VARCHAR(150) NULL,
    [doc_no1] VARCHAR(50) NULL,
    [br_date] VARCHAR(50) NULL,
    [to_branch] VARCHAR(50) NULL,
    [exp_empid] VARCHAR(50) NULL,
    [dest_branch] VARCHAR(50) NULL,
    [remark] VARCHAR(60) NULL,
    [exp_fdt] DATETIME NULL,
    [exp_tdt] DATETIME NULL,
    [branch_flag] BIT NULL,
    [cso_flag] BIT NULL,
    [comp_flag] BIT NULL,
    [r_flag] BIT NULL,
    [r_flag1] BIT NULL,
    [LOB] VARCHAR(100) NULL,
    [Adv_Amt] NUMERIC(18, 0) NULL,
    [Adv_Cheque_No] VARCHAR(50) NULL,
    [Order_Maker] VARCHAR(55) NULL,
    [Due_Date] DATETIME NULL,
    [ChequeDispatchedAt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.billmaster_deleted
-- --------------------------------------------------
CREATE TABLE [dbo].[billmaster_deleted]
(
    [v_no] NUMERIC(18, 0) NOT NULL,
    [branch] VARCHAR(50) NULL,
    [eid_branch] VARCHAR(20) NULL,
    [vcode] VARCHAR(50) NULL,
    [segment] VARCHAR(15) NULL,
    [bill_date] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [acname] VARCHAR(100) NULL,
    [longname] VARCHAR(100) NULL,
    [inv_no] VARCHAR(60) NULL,
    [amount] NUMERIC(18, 0) NULL,
    [pan_no] VARCHAR(50) NULL,
    [st_no] VARCHAR(50) NULL,
    [dis_date] DATETIME NULL,
    [courier_name] VARCHAR(150) NULL,
    [doc_no] VARCHAR(50) NULL,
    [r_date] VARCHAR(50) NULL,
    [in_status] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [cso_date] VARCHAR(50) NULL,
    [eid_cso] VARCHAR(20) NULL,
    [pay_amount] NUMERIC(18, 0) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [d_date] DATETIME NULL,
    [courier_name1] VARCHAR(150) NULL,
    [doc_no1] VARCHAR(50) NULL,
    [br_date] VARCHAR(50) NULL,
    [to_branch] VARCHAR(50) NULL,
    [exp_empid] VARCHAR(50) NULL,
    [dest_branch] VARCHAR(50) NULL,
    [remark] VARCHAR(60) NULL,
    [exp_fdt] DATETIME NULL,
    [exp_tdt] DATETIME NULL,
    [branch_flag] BIT NULL,
    [cso_flag] BIT NULL,
    [comp_flag] BIT NULL,
    [r_flag] BIT NULL,
    [r_flag1] BIT NULL,
    [LOB] VARCHAR(100) NULL,
    [Adv_Amt] NUMERIC(18, 0) NULL,
    [Adv_Cheque_No] VARCHAR(50) NULL,
    [Order_Maker] VARCHAR(55) NULL,
    [Due_Date] DATETIME NULL,
    [ChequeDispatchedAt] VARCHAR(50) NULL,
    [deleted_time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branch
-- --------------------------------------------------
CREATE TABLE [dbo].[branch]
(
    [sbtag] VARCHAR(10) NULL,
    [tradername] VARCHAR(100) NULL,
    [abl_upd] DATETIME NULL,
    [acdl_upd] DATETIME NULL,
    [fo_upd] DATETIME NULL,
    [email] VARCHAR(50) NULL,
    [add1] VARCHAR(100) NULL,
    [add2] VARCHAR(50) NULL,
    [add3] VARCHAR(50) NULL,
    [add4] VARCHAR(50) NULL,
    [add5] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Branch_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[Branch_Details]
(
    [Sr_No] INT IDENTITY(1,1) NOT NULL,
    [Branch] VARCHAR(50) NULL,
    [Sub_Branch] VARCHAR(50) NULL,
    [Ratio] DECIMAL(18, 0) NULL,
    [Status] BIT NULL,
    [Short_Branch] VARCHAR(50) NULL,
    [Last_Updated] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branch_fas
-- --------------------------------------------------
CREATE TABLE [dbo].[branch_fas]
(
    [sbtag] VARCHAR(20) NULL,
    [tradername] VARCHAR(50) NULL,
    [abl_upd] VARCHAR(80) NULL,
    [acdl_upd] VARCHAR(80) NULL,
    [fo_upd] VARCHAR(80) NULL,
    [email] VARCHAR(80) NULL,
    [add1] VARCHAR(100) NULL,
    [add2] VARCHAR(20) NULL,
    [add3] VARCHAR(20) NULL,
    [add4] VARCHAR(20) NULL,
    [add5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CMS_Location
-- --------------------------------------------------
CREATE TABLE [dbo].[CMS_Location]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Branch_Tag] VARCHAR(30) NULL,
    [Branch] VARCHAR(100) NULL,
    [Reg_Code] VARCHAR(30) NULL,
    [Region] VARCHAR(100) NULL,
    [Brmast_Cd] VARCHAR(30) NULL,
    [Print_Loc] VARCHAR(30) NULL,
    [Drawee_Cd] VARCHAR(30) NULL,
    [Print_cd] VARCHAR(15) NULL,
    [updatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CMS_LOCATION_21102010_1
-- --------------------------------------------------
CREATE TABLE [dbo].[CMS_LOCATION_21102010_1]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Branch_Tag] VARCHAR(30) NULL,
    [Branch] VARCHAR(100) NULL,
    [Reg_Code] VARCHAR(30) NULL,
    [Region] VARCHAR(100) NULL,
    [Brmast_Cd] VARCHAR(30) NULL,
    [Print_Loc] VARCHAR(30) NULL,
    [Drawee_Cd] VARCHAR(30) NULL,
    [Print_cd] VARCHAR(15) NULL,
    [updatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.couriersmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[couriersmaster]
(
    [cid] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [cname] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Expense_MIS
-- --------------------------------------------------
CREATE TABLE [dbo].[Expense_MIS]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [acc_code] NVARCHAR(25) NULL,
    [acc_name] VARCHAR(60) NULL,
    [active_status] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ExpenseMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[ExpenseMaster]
(
    [ac_code] VARCHAR(20) NULL,
    [ac_name] VARCHAR(50) NULL,
    [perc] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINANCIAL TPD RATIO MAR10
-- --------------------------------------------------
CREATE TABLE [dbo].[FINANCIAL TPD RATIO MAR10]
(
    [srno] NVARCHAR(50) NULL,
    [Date] NVARCHAR(50) NULL,
    [Branch Name] NVARCHAR(50) NULL,
    [Angel Tag] NVARCHAR(50) NULL,
    [Branch Code] NVARCHAR(50) NULL,
    [Branch Tag] NVARCHAR(50) NULL,
    [LOB] NVARCHAR(50) NULL,
    [TDP] NVARCHAR(50) NULL,
    [COUNT] NVARCHAR(50) NULL,
    [Ratio] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FY_Mast
-- --------------------------------------------------
CREATE TABLE [dbo].[FY_Mast]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [FYName] VARCHAR(15) NULL,
    [FYCode] INT NULL,
    [FYseries] INT NULL,
    [FYVisible] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HCNOV09
-- --------------------------------------------------
CREATE TABLE [dbo].[HCNOV09]
(
    [Sno] NVARCHAR(50) NULL,
    [Date] NVARCHAR(50) NULL,
    [Branch Name] NVARCHAR(50) NULL,
    [Angel Tag] NVARCHAR(50) NULL,
    [Branch Code] NVARCHAR(50) NULL,
    [Branch Tag] NVARCHAR(50) NULL,
    [LOB] NVARCHAR(50) NULL,
    [TDP] NVARCHAR(50) NULL,
    [COUNT] NVARCHAR(50) NULL,
    [Ratio] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.JV_Remarks
-- --------------------------------------------------
CREATE TABLE [dbo].[JV_Remarks]
(
    [io_no] BIGINT NULL,
    [segment] VARCHAR(50) NULL,
    [inv_no] VARCHAR(50) NULL,
    [emp_name] VARCHAR(50) NULL,
    [entry_date] VARCHAR(11) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [solutions] VARCHAR(MAX) NULL,
    [pv_no] VARCHAR(50) NULL DEFAULT ((0)),
    [jamt] DECIMAL(10, 2) NULL DEFAULT ((0)),
    [pamt] DECIMAL(10, 2) NULL,
    [cremarks] VARCHAR(MAX) NULL,
    [createdby] VARCHAR(50) NULL,
    [createdon] VARCHAR(11) NULL,
    [modifiedby] VARCHAR(50) NULL,
    [modifiedon] VARCHAR(11) NULL,
    [v_no] VARCHAR(20) NULL,
    [checkedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.login_vms
-- --------------------------------------------------
CREATE TABLE [dbo].[login_vms]
(
    [uid] NVARCHAR(50) NOT NULL,
    [uname] VARCHAR(50) NULL,
    [password] NVARCHAR(50) NOT NULL,
    [role] VARCHAR(50) NOT NULL,
    [Status] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.manesh_xxx
-- --------------------------------------------------
CREATE TABLE [dbo].[manesh_xxx]
(
    [JV No.] INT NOT NULL,
    [IO. SrNO] NUMERIC(18, 0) NULL,
    [Inv. No.] VARCHAR(60) NULL,
    [Segment] VARCHAR(50) NULL,
    [Vendor Name] VARCHAR(200) NULL,
    [Vendor Code] VARCHAR(50) NULL,
    [ExpenseCode] VARCHAR(20) NULL,
    [ExpenseName] VARCHAR(200) NULL,
    [Amount] NUMERIC(18, 2) NULL,
    [BranchTag] VARCHAR(20) NULL,
    [Expense from date] VARCHAR(13) NULL,
    [Expense to date] VARCHAR(13) NULL,
    [LOB] VARCHAR(100) NULL,
    [Order_Maker] VARCHAR(55) NULL,
    [Branch UserID] VARCHAR(20) NULL,
    [Branch User Name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MultiPayment
-- --------------------------------------------------
CREATE TABLE [dbo].[MultiPayment]
(
    [PVNo] NUMERIC(18, 0) NULL,
    [JVNo] NUMERIC(18, 0) NULL,
    [IO_SrNo] NUMERIC(18, 0) NULL,
    [InvNo] VARCHAR(60) NULL,
    [Amount] NUMERIC(18, 0) NULL,
    [BrTag] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PaymentMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[PaymentMaster]
(
    [pv_no] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [entry_date] DATETIME NULL,
    [date] VARCHAR(50) NULL,
    [v_name_s] VARCHAR(100) NULL,
    [v_name_f] VARCHAR(200) NULL,
    [v_code] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [narration] VARCHAR(400) NULL,
    [bank_name] VARCHAR(80) NULL,
    [bank_code] VARCHAR(30) NULL,
    [cheque_no] VARCHAR(30) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [inv_no] VARCHAR(60) NULL,
    [jv_no] NUMERIC(18, 0) NULL,
    [segment] VARCHAR(25) NULL,
    [emp_id] VARCHAR(25) NULL,
    [status] BIT NULL,
    [cms_status] BIT NULL,
    [io_srno] NUMERIC(18, 0) NULL,
    [PayType] VARCHAR(5) NULL,
    [TransferTo] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.paymentMaster_Amit
-- --------------------------------------------------
CREATE TABLE [dbo].[paymentMaster_Amit]
(
    [pv_no] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [entry_date] DATETIME NULL,
    [date] VARCHAR(50) NULL,
    [v_name_s] VARCHAR(100) NULL,
    [v_name_f] VARCHAR(200) NULL,
    [v_code] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [narration] VARCHAR(400) NULL,
    [bank_name] VARCHAR(80) NULL,
    [bank_code] VARCHAR(30) NULL,
    [cheque_no] VARCHAR(30) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [inv_no] VARCHAR(60) NULL,
    [jv_no] NUMERIC(18, 0) NULL,
    [segment] VARCHAR(25) NULL,
    [emp_id] VARCHAR(25) NULL,
    [status] BIT NULL,
    [cms_status] BIT NULL,
    [io_srno] NUMERIC(18, 0) NULL,
    [PayType] VARCHAR(5) NULL,
    [TransferTo] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PaymentMaster_deleted
-- --------------------------------------------------
CREATE TABLE [dbo].[PaymentMaster_deleted]
(
    [pv_no] NUMERIC(18, 0) NOT NULL,
    [entry_date] DATETIME NULL,
    [date] VARCHAR(50) NULL,
    [v_name_s] VARCHAR(100) NULL,
    [v_name_f] VARCHAR(200) NULL,
    [v_code] VARCHAR(50) NULL,
    [br_tag] VARCHAR(50) NULL,
    [narration] VARCHAR(400) NULL,
    [bank_name] VARCHAR(80) NULL,
    [bank_code] VARCHAR(30) NULL,
    [cheque_no] VARCHAR(30) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [inv_no] VARCHAR(60) NULL,
    [jv_no] NUMERIC(18, 0) NULL,
    [segment] VARCHAR(25) NULL,
    [emp_id] VARCHAR(25) NULL,
    [status] BIT NULL,
    [cms_status] BIT NULL,
    [io_srno] NUMERIC(18, 0) NULL,
    [PayType] VARCHAR(5) NULL,
    [TransferTo] VARCHAR(30) NULL,
    [delete_time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REVISEDUPLOAD_ABL
-- --------------------------------------------------
CREATE TABLE [dbo].[REVISEDUPLOAD_ABL]
(
    [cltcode] VARCHAR(255) NULL,
    [acname] VARCHAR(255) NULL,
    [longname] VARCHAR(255) NULL,
    [branchcode] VARCHAR(255) NULL,
    [segment] VARCHAR(255) NULL,
    [prop_name] VARCHAR(255) NULL,
    [Pan_No] VARCHAR(255) NULL,
    [ST_No] VARCHAR(255) NULL,
    [Add1] VARCHAR(255) NULL,
    [KOPAR KHAIRANE] VARCHAR(255) NULL,
    [Add3] VARCHAR(255) NULL,
    [city] VARCHAR(255) NULL,
    [pin] VARCHAR(255) NULL,
    [State] VARCHAR(255) NULL,
    [Phone_No] VARCHAR(255) NULL,
    [email] VARCHAR(255) NULL,
    [Fax] VARCHAR(255) NULL,
    [Status] VARCHAR(255) NULL,
    [Services] VARCHAR(255) NULL,
    [tdsCode] VARCHAR(255) NULL,
    [emp_id] VARCHAR(255) NULL,
    [creat_date] VARCHAR(255) NULL,
    [Trade_Name] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.servicemaster
-- --------------------------------------------------
CREATE TABLE [dbo].[servicemaster]
(
    [SrNo] FLOAT NULL,
    [ServiceType] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.T
-- --------------------------------------------------
CREATE TABLE [dbo].[T]
(
    [segment] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Table_1
-- --------------------------------------------------
CREATE TABLE [dbo].[Table_1]
(
    [inds] DECIMAL(10, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Srno
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Srno]
(
    [cnt] INT IDENTITY(1,1) NOT NULL,
    [Srno] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Srno_pay
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Srno_pay]
(
    [cnt] INT IDENTITY(1,1) NOT NULL,
    [Srno] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEM_VEN
-- --------------------------------------------------
CREATE TABLE [dbo].[TEM_VEN]
(
    [SEGMENT] NVARCHAR(10) NULL,
    [CLTCODE] VARCHAR(30) NULL,
    [ACNAME] NVARCHAR(70) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ventry
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ventry]
(
    [v_no] NUMERIC(18, 0) NULL,
    [v_code] VARCHAR(20) NULL,
    [ac_name] VARCHAR(200) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [br_tag] VARCHAR(20) NULL,
    [Drcr] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_voucher_details
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_voucher_details]
(
    [io_no] NUMERIC(18, 0) NULL,
    [v_no] NUMERIC(18, 0) NULL,
    [pv_no] NUMERIC(18, 0) NULL,
    [bill_amount] NUMERIC(18, 2) NULL,
    [service_tax] NUMERIC(18, 2) NULL,
    [tds] NUMERIC(18, 2) NULL,
    [cheque_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_Voucher_details1
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_Voucher_details1]
(
    [io_no] NUMERIC(18, 0) NULL,
    [v_no] NUMERIC(18, 0) NULL,
    [pv_no] NUMERIC(18, 0) NULL,
    [bill_amount] NUMERIC(18, 2) NULL,
    [service_tax] NUMERIC(18, 2) NULL,
    [tds] NUMERIC(18, 2) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [ST] NUMERIC(18, 2) NULL,
    [CT] NUMERIC(18, 2) NULL,
    [SHE] NUMERIC(18, 2) NULL,
    [ST_CR] NUMERIC(18, 2) NULL,
    [FY] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TPD_CE
-- --------------------------------------------------
CREATE TABLE [dbo].[TPD_CE]
(
    [SNo] INT NOT NULL,
    [Date] DATETIME NULL,
    [BranchName] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(50) NULL,
    [LOB] VARCHAR(50) NULL,
    [TPD] NUMERIC(18, 0) NULL,
    [Count] INT NULL,
    [Ratio] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TPD_HC
-- --------------------------------------------------
CREATE TABLE [dbo].[TPD_HC]
(
    [SNo] INT NOT NULL,
    [Date] DATETIME NULL,
    [BranchName] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(50) NULL,
    [LOB] VARCHAR(50) NULL,
    [TPD] NUMERIC(18, 0) NULL,
    [Count] INT NULL,
    [Ratio] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tpd_hc_10
-- --------------------------------------------------
CREATE TABLE [dbo].[tpd_hc_10]
(
    [SNo] INT NOT NULL,
    [Date] DATETIME NULL,
    [BranchName] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(50) NULL,
    [LOB] VARCHAR(50) NULL,
    [TPD] NUMERIC(18, 0) NULL,
    [Count] INT NULL,
    [Ratio] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tpd_hc0605
-- --------------------------------------------------
CREATE TABLE [dbo].[tpd_hc0605]
(
    [Srno] NVARCHAR(50) NULL,
    [Date] NVARCHAR(50) NULL,
    [Branch Name] NVARCHAR(50) NULL,
    [Angel Tag] NVARCHAR(50) NULL,
    [Branch Code] NVARCHAR(50) NULL,
    [Branch Tag] NVARCHAR(50) NULL,
    [LOB] NVARCHAR(50) NULL,
    [TDP] NVARCHAR(50) NULL,
    [COUNT] NVARCHAR(50) NULL,
    [Ratio] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TPD_LOB
-- --------------------------------------------------
CREATE TABLE [dbo].[TPD_LOB]
(
    [ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [LOB] VARCHAR(10) NULL,
    [suffix] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TPD_WS
-- --------------------------------------------------
CREATE TABLE [dbo].[TPD_WS]
(
    [SNo] INT NOT NULL,
    [Date] DATETIME NULL,
    [BranchName] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(50) NULL,
    [LOB] VARCHAR(50) NULL,
    [TPD] NUMERIC(18, 0) NULL,
    [Count] INT NULL,
    [Ratio] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tpd_ws_10
-- --------------------------------------------------
CREATE TABLE [dbo].[tpd_ws_10]
(
    [SNo] INT NOT NULL,
    [Date] DATETIME NULL,
    [BranchName] VARCHAR(50) NULL,
    [CSO_BranchTag] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(50) NULL,
    [LOB] VARCHAR(50) NULL,
    [TPD] NUMERIC(18, 0) NULL,
    [Count] INT NULL,
    [Ratio] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.update_log
-- --------------------------------------------------
CREATE TABLE [dbo].[update_log]
(
    [srn] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [message] VARCHAR(100) NULL,
    [update_date] DATETIME NULL,
    [emp_id] VARCHAR(15) NULL,
    [update_name] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UPDATEOFTRADE NAME
-- --------------------------------------------------
CREATE TABLE [dbo].[UPDATEOFTRADE NAME]
(
    [SRNO] VARCHAR(255) NULL,
    [CLT CODE] VARCHAR(255) NULL,
    [TRADE NAME] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VendorMaster_old
-- --------------------------------------------------
CREATE TABLE [dbo].[VendorMaster_old]
(
    [cltcode] NUMERIC(18, 0) NULL,
    [acname] NVARCHAR(255) NULL,
    [longname] NVARCHAR(255) NULL,
    [branchcode] NVARCHAR(255) NULL,
    [segment] NVARCHAR(255) NULL,
    [Pan_No] NVARCHAR(255) NULL,
    [ST_No] NVARCHAR(255) NULL,
    [Address] NVARCHAR(255) NULL,
    [State] NVARCHAR(255) NULL,
    [Service] NVARCHAR(255) NULL,
    [Status] NVARCHAR(255) NULL,
    [Code] NVARCHAR(255) NULL,
    [To_Be_rectified] NVARCHAR(255) NULL,
    [Phone_No] NVARCHAR(255) NULL,
    [Fax] NVARCHAR(255) NULL,
    [email] NVARCHAR(255) NULL,
    [count] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vendormaster_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[vendormaster_RENAMEDAS_PII]
(
    [cltcode] VARCHAR(30) NULL,
    [acname] NVARCHAR(70) NULL,
    [longname] NVARCHAR(80) NULL,
    [branchcode] NVARCHAR(15) NULL,
    [segment] NVARCHAR(10) NULL,
    [prop_name] NVARCHAR(100) NULL,
    [Pan_No] NVARCHAR(20) NULL,
    [ST_No] NVARCHAR(60) NULL,
    [Add1] NVARCHAR(75) NULL,
    [Add2] NVARCHAR(60) NULL,
    [Add3] NVARCHAR(50) NULL,
    [city] NVARCHAR(40) NULL,
    [pin] NVARCHAR(10) NULL,
    [State] NVARCHAR(25) NULL,
    [Phone_No] NVARCHAR(50) NULL,
    [email] NVARCHAR(50) NULL,
    [Fax] NVARCHAR(30) NULL,
    [Status] NVARCHAR(30) NULL,
    [Services] NVARCHAR(50) NULL,
    [tdsCode] NVARCHAR(25) NULL,
    [emp_id] NVARCHAR(10) NULL,
    [creat_date] DATETIME NULL,
    [Trade_Name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VM170909
-- --------------------------------------------------
CREATE TABLE [dbo].[VM170909]
(
    [cltcode] VARCHAR(255) NULL,
    [acname] VARCHAR(255) NULL,
    [Trade Name] VARCHAR(255) NULL,
    [segment] VARCHAR(255) NULL,
    [Status] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.voucher_delete_log
-- --------------------------------------------------
CREATE TABLE [dbo].[voucher_delete_log]
(
    [jv_no] NUMERIC(18, 0) NULL,
    [pv_no] NUMERIC(18, 0) NULL,
    [action] VARCHAR(60) NULL,
    [action_time] DATETIME NULL,
    [uid] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.voucher_details
-- --------------------------------------------------
CREATE TABLE [dbo].[voucher_details]
(
    [io_no] NUMERIC(18, 0) NULL,
    [v_no] NUMERIC(18, 0) NULL,
    [pv_no] NUMERIC(18, 0) NULL,
    [bill_amount] NUMERIC(18, 2) NULL,
    [service_tax] NUMERIC(18, 2) NULL,
    [tds] NUMERIC(18, 2) NULL,
    [cheque_no] VARCHAR(50) NULL,
    [ST] NUMERIC(18, 2) NULL,
    [CT] NUMERIC(18, 2) NULL,
    [SHE] NUMERIC(18, 2) NULL,
    [ST_CR] NUMERIC(18, 2) NULL,
    [FY] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VoucherEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[VoucherEntry]
(
    [v_no] NUMERIC(18, 0) NULL,
    [v_code] VARCHAR(20) NULL,
    [ac_name] VARCHAR(200) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [br_tag] VARCHAR(20) NULL,
    [Drcr] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VoucherEntry_deteled
-- --------------------------------------------------
CREATE TABLE [dbo].[VoucherEntry_deteled]
(
    [v_no] NUMERIC(18, 0) NULL,
    [v_code] VARCHAR(20) NULL,
    [ac_name] VARCHAR(200) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [br_tag] VARCHAR(20) NULL,
    [Drcr] VARCHAR(10) NULL,
    [Delete_time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VoucherMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[VoucherMaster]
(
    [v_no] INT IDENTITY(1,1) NOT NULL,
    [inv_no] VARCHAR(60) NULL,
    [narration] VARCHAR(300) NULL,
    [v_date] VARCHAR(50) NULL,
    [emp_no] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [ven_name] VARCHAR(200) NULL,
    [ven_code] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [status] BIT NULL,
    [total] NUMERIC(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VoucherMaster_deleted
-- --------------------------------------------------
CREATE TABLE [dbo].[VoucherMaster_deleted]
(
    [v_no] INT NOT NULL,
    [inv_no] VARCHAR(60) NULL,
    [narration] VARCHAR(300) NULL,
    [v_date] VARCHAR(50) NULL,
    [emp_no] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [ven_name] VARCHAR(200) NULL,
    [ven_code] VARCHAR(50) NULL,
    [entry_date] DATETIME NULL,
    [status] BIT NULL,
    [total] NUMERIC(18, 2) NULL,
    [deleted_time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ws0605
-- --------------------------------------------------
CREATE TABLE [dbo].[ws0605]
(
    [Srno] NVARCHAR(50) NULL,
    [Date] NVARCHAR(50) NULL,
    [Branch Name] NVARCHAR(50) NULL,
    [Angel Tag] NVARCHAR(50) NULL,
    [Branch Code] NVARCHAR(50) NULL,
    [Branch Tag] NVARCHAR(50) NULL,
    [LOB] NVARCHAR(50) NULL,
    [TDP] NVARCHAR(50) NULL,
    [COUNT] NVARCHAR(50) NULL,
    [Ratio] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.Trg_delele_BillMaster
-- --------------------------------------------------
create trigger [dbo].[Trg_delele_BillMaster]
  
on dbo.billmaster     
  
for delete      
  
as       
  
insert into dbo.billmaster_deleted       
  
select *,getdate() from deleted

GO

-- --------------------------------------------------
-- TRIGGER dbo.Trg_delele_PaymentMaster
-- --------------------------------------------------
CREATE trigger [dbo].[Trg_delele_PaymentMaster]
  
on [dbo].[PaymentMaster]
  
for delete      
  
as       
  
insert into dbo.PaymentMaster_deleted      
  
select *,getdate() from deleted

GO

-- --------------------------------------------------
-- TRIGGER dbo.Trg_delele_VoucherEntry
-- --------------------------------------------------
CREATE trigger [dbo].[Trg_delele_VoucherEntry]
  
on [dbo].[VoucherEntry]     
  
for delete      
  
as       
  
insert into dbo.VoucherEntry_deteled       
  
select *,getdate() from deleted

GO

-- --------------------------------------------------
-- TRIGGER dbo.Trg_delele_VoucherMaster
-- --------------------------------------------------
CREATE trigger [dbo].[Trg_delele_VoucherMaster]
  
on [dbo].[VoucherMaster]      
  
for delete      
  
as       
  
insert into dbo.VoucherMaster_deleted       
  
select *,getdate() from deleted

GO

-- --------------------------------------------------
-- TRIGGER dbo.Trg_insert_billentry
-- --------------------------------------------------
CREATE trigger [dbo].[Trg_insert_billentry]  
  
on dbo.billmaster      
  
for insert      
  
as       
  
insert into dbo.bill_status_log       
  
select v_no,'Bill Entered By Branch',getdate(),eid_branch,'','' from inserted

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Billmaster
-- --------------------------------------------------
Create view Vw_Billmaster
as

select * from account123.dbo.billmaster with (nolock) where FY='20092010'
union all 
select * from account123.dbo.billmaster with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_VMS_Details
-- --------------------------------------------------

    
CREATE View Vw_VMS_Details    
as    
    
select a.v_no as IO_No,a.Eid_Branch,c.Person_Name,a.entry_date as RequestDate,a.exp_fdt,    
a.exp_tdt,a.inv_No as BillNo,isnull(b.entry_date,'') as Payment_date,    
a.amount,isnull(b.Segment,'') as Company,isnull(b.Br_Tag,'') as Branch,isnull(B.Cheque_No,'')Cheque_No,
isnull(b.Bank_Name,'')Bank_Name from Billmaster a (Nolock)    
left outer join     
Paymentmaster b (Nolock) on a.V_No=b.Io_Srno    
Left outer join     
Risk.dbo.User_Login c (nolock) on a.Eid_Branch=c.UserName

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_VMS_Details_hist
-- --------------------------------------------------
  
Create View Vw_VMS_Details_hist        
as        
        
select a.v_no as IO_No,a.Eid_Branch,c.Person_Name,a.entry_date as RequestDate,a.exp_fdt,        
a.exp_tdt,a.inv_No as BillNo,isnull(b.entry_date,'') as Payment_date,        
a.amount,isnull(b.Segment,'') as Company,isnull(b.Br_Tag,'') as Branch,isnull(B.Cheque_No,'')Cheque_No,    
isnull(b.Bank_Name,'')Bank_Name,a.FY as BILLMASTERFY, a.FY as PayMastFY from Account123.dbo.Billmaster a (Nolock)        
left outer join         
Account123.dbo.Paymentmaster b (Nolock) on a.V_No=b.Io_Srno        
Left outer join         
Risk.dbo.User_Login c (nolock) on a.Eid_Branch=c.UserName

GO

-- --------------------------------------------------
-- VIEW dbo.vw_vms_Payment
-- --------------------------------------------------

create view vw_vms_Payment
as
select * from paymentmaster (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_VMS_TexDetails
-- --------------------------------------------------
CREATE View Vw_VMS_TexDetails  
As  
select IO_No,Bill_Amount,Service_Tax,TDS,Cheque_No,FY from Voucher_Details (Nolock)

GO

