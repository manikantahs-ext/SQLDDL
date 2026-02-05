-- DDL Export
-- Server: 10.253.78.163
-- Database: Ebroking
-- Exported: 2026-02-05T12:29:56.229243

USE Ebroking;
GO

-- --------------------------------------------------
-- FUNCTION dbo.get_trade_num
-- --------------------------------------------------
CREATE function get_trade_num(@tradenum varchar(30))    
RETURNs varchar(30)  
As    
Begin    
--set @mmonth =  2    
--set @myear  = 2007    
Return   
replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(@tradenum  
,'a',''),'b',''),'c',''),'d',''),'e',''),'f',''),'g',''),'h',''),'i',''),'j',''),'k',''),'l',''),'m',''),'n',''),'o',''),'p',''),'q',''),'r',''),'s',''),'t',''),'u',''),'v',''),'w',''),'x',''),'y',''),'z','')  
    
End

GO

-- --------------------------------------------------
-- INDEX dbo.BSETrade
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sauda_date] ON [dbo].[BSETrade] ([Sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.MCXTrade
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sauda_date] ON [dbo].[MCXTrade] ([sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.mis_to
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Pcode] ON [dbo].[mis_to] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.mis_to
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [SdDate] ON [dbo].[mis_to] ([sauda_date]) INCLUDE ([party_code], [Turnover], [brokerage])

GO

-- --------------------------------------------------
-- INDEX dbo.NSDEXTrade
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sauda_date] ON [dbo].[NSDEXTrade] ([sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.NSEFOTrade
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sauda_date] ON [dbo].[NSEFOTrade] ([sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.NSETrade
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_sauda_date] ON [dbo].[NSETrade] ([sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.TradeFileLog
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_TradeFileLog] ON [dbo].[TradeFileLog] ([uploadDt])

GO

-- --------------------------------------------------
-- INDEX dbo.TradeFileLog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_TradeFileLog_1] ON [dbo].[TradeFileLog] ([segment])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tblFilePath
-- --------------------------------------------------
ALTER TABLE [dbo].[tblFilePath] ADD CONSTRAINT [pk_segment] PRIMARY KEY ([segment], [manager])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.add_notice
-- --------------------------------------------------
CREATE procedure [dbo].[add_notice]
(
@nid varchar(50),
@reqID varchar(20),
@hodNo varchar(20),
@empno varchar(20),
@pino varchar(20),
@note varchar(100),
@noteDate varchar(20),
@message varchar(100),
@subject varchar(100),
@ischecked int,
@catname varchar(100),
@itemName varchar(100),
@status varchar(4)
)
as 
insert into Notifications values(@nid, @reqID, @hodNo, @empno,@pino, @note, @noteDate,@message,@subject,@ischecked,@catname,@itemname,@status)
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.addToOrderQueue
-- --------------------------------------------------
CREATE procedure [dbo].[addToOrderQueue]
(
@ordid varchar(50),
@hodid varchar(25),
@itemid varchar(50),
@qty float,
@reqid varchar(25)
--,@stat integer--,@initQty float,@newQty float
)
as
--@initQty = select qty from Order_Queue where hod_no = @hodid and itemid = @itemid
--@newQty = @qty - @initQty
Declare @rate float

select @rate=rate from InventoryItem where Itemid = @itemId

insert into Order_Queue values(@ordid,@hodid,@itemid,@qty,0,0,@rate)
update UserRequest set orderID=@ordiD where ReqID = @ReqID

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.createNVIRequest
-- --------------------------------------------------
CREATE procedure [dbo].[createNVIRequest]  
(  
@ReqID nvarchar(15),  
@ItemID varchar(20),  
@CatID varchar(20),  
@ItemName varchar(100),  
@CategoryName varchar(100),  
@UserNote varchar(100),  
@ReqDate datetime,--varchar(50),  
@CompleteByDate varchar(25),  
@Emp_no varchar(10),  
@Hod_no varchar(10), 
@Pi_no varchar(10), 
@Qty int,  
@ModID varchar(25),  
@stat varchar(4),
@rqgid varchar(20),
@orderid varchar(50)  
)  
as  
Declare @Pi as Varchar(10)  
set @Pi = (select Pi_No from hod_mapping where hod_no=@hod_no)  
  
insert into UserRequest values (@ReqID,@ItemID,@CatID,@ItemName,@CategoryName,@UserNote,'',@stat,@ReqDate,@CompleteByDate,'','no',@Emp_no,@Hod_no,@Pi,@qty,@orderid,@rqgid)  
insert into ModifiedRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@UserNote,@Emp_no,@ReqDate,@CompleteByDate,@stat,0)  
insert into userreqgroup values(@reqid,@rqgid)  
return

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
-- PROCEDURE dbo.disp_req
-- --------------------------------------------------

CREATE procedure [dbo].[disp_req]    
(    
@uno as varchar(25),    
@reqCode as varchar(5),  
@opt as varchar(50)    
)    
as    
  if @opt = 'HOD'    
begin  
select a.ReqID, a.ItemName, a.CategoryName, b.ReqStatusName,c.Emp_Name,c.Emp_no,a.CompleteByDate, a.reqStatusCode from UserRequest a,    
ReqStatus b,risk.dbo.emp_info c where a.Hod_no =@uno and a.hod_no=c.senior AND a.ReqStatusCode = b.ReqStatusCode AND a.ReqStatusCode=@reqCode order by a.ReqStatusCode     
  end  
else  
select a.ReqID, a.ItemName, a.CategoryName, b.ReqStatusName,c.Emp_Name,c.Emp_no,a.CompleteByDate, a.reqStatusCode from UserRequest a,    
ReqStatus b,risk.dbo.emp_info c where a.hod_no=(select hod_no from hod_mapping where pi_no =@uno)and a.emp_no=c.emp_no AND a.ReqStatusCode = b.ReqStatusCode AND a.ReqStatusCode=@reqCode order by a.ReqStatusCode     
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.gen_report
-- --------------------------------------------------

create proc [dbo].[gen_report]

@emp_no  varchar(15)

as
select itemid,sum(qty) as sum  into #tempabc from userrequest  where emp_no=@emp_no group by itemid


select b.itemid,a.sum,b.itemname from #tempabc a,inventoryitem b where b.itemid in(select itemid from #tempabc)
and a.itemid=b.itemid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.gen_report1
-- --------------------------------------------------
CREATE proc [dbo].[gen_report1]                
(              
@emp_no  varchar(50),              
@option varchar(50),            
@frmdate varchar(20),            
@todate varchar(20)               
)                
as              
            
--Declare @option as varchar(50),@emp_no as varchar(50) ,@frmdate as varchar(50) ,@todate as varchar(50)      
      
--set @option = 'department'      
--set @emp_no='Software Development'      
--set @frmdate='2007-09-01'      
--set @todate='2007-09-30'      
            
if @option = 'EMP'              
BEGIN                
             
select itemid,sum(qty) as sum  into #tempabc from userrequest where emp_no=@emp_no          
and (reqstatuscode='0' or reqstatuscode='1' or reqstatuscode='2')              
and (reqdate>=@frmdate+' 00:00:00' and reqdate<=@todate+' 23:59:59')             
group by itemid              
          
--drop table #tempabc            
--select * from userrequest where emp_no='e05204' and (reqstatuscode='0' or reqstatuscode='1' or reqstatuscode='2')          
            
select b.itemid,a.sum,b.itemname from #tempabc a,inventoryitem b               
where b.itemid in(select itemid from #tempabc) and a.itemid=b.itemid order by a.itemid             
END              
      
        
if @option = 'department'   
  
if @emp_no='ALL'  
   
begin  
select itemid,sum(qty) as sum into #tempabc5 from userrequest       
where        
 (reqstatuscode='0' or reqstatuscode='1' or reqstatuscode='2')              
and (reqdate>=@frmdate+' 00:00:00' and reqdate<=@todate+' 23:59:59')         
 group by itemid        
        
select b.itemid,a.sum,b.itemname from #tempabc5 a,inventoryitem b               
where b.itemid in(select itemid from #tempabc5) and a.itemid=b.itemid order by a.itemid           
       
end  
  
else  
begin        
select a.itemid,sum(a.qty) as sum into #tempabc1 from userrequest a,hod_mapping b         
where a.hod_no=b.hod_no and b.department =@emp_no         
and (reqstatuscode='0' or reqstatuscode='1' or reqstatuscode='2')              
and (reqdate>=@frmdate+' 00:00:00' and reqdate<=@todate+' 23:59:59')         
 group by itemid        
        
select b.itemid,a.sum,b.itemname from #tempabc1 a,inventoryitem b               
where b.itemid in(select itemid from #tempabc1) and a.itemid=b.itemid order by a.itemid           
end        
    
if @option='item'    
if @emp_no='ALL'    
    
begin    
select itemid,sum(qty) as sum into #tempabc3 from userrequest     
where     
 (reqstatuscode='0' or reqstatuscode='1' or reqstatuscode='2')          
and (reqdate>=@frmdate+' 00:00:00' and reqdate<=@todate+' 23:59:59')     
 group by itemid    
--drop table #tempabc3    
--select * from #tempabc3    
--select * from userrequest    
select b.itemid,a.sum,b.itemname from #tempabc3 a,inventoryitem b               
where b.itemid in(select itemid from #tempabc3) and a.itemid=b.itemid order by a.itemid        
end    
ELSE    
    
BEGIN    
select itemid,sum(qty) as sum into #tempabc2 from userrequest     
where itemname=@emp_no    
and (reqstatuscode='0' or reqstatuscode='1' or reqstatuscode='2')          
and (reqdate>=@frmdate+' 00:00:00' and reqdate<=@todate+' 23:59:59')     
 group by itemid    
    
select b.itemid,a.sum,b.itemname from #tempabc2 a,inventoryitem b               
where b.itemid in(select itemid from #tempabc2) and a.itemid=b.itemid         
end    
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.generate_po
-- --------------------------------------------------

create proc [dbo].[generate_po]
@poID as varchar(50)
as
truncate table temptbl1
insert into temptbl1 
select sum(TotalQty), itemid from order_queue where orderid in (select orderid from purchase_order_queue where purchase_id=@poID) group by itemid
---select * from temptbl1

select * from  temptbl1 a
left outer join 
(select itemname,rate,vat,itemid from inventoryItem where itemid in (select itemid from temptbl1)) b
on a.itemid = b.itemid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.get_hodReqList
-- --------------------------------------------------

CREATE procedure [dbo].[get_hodReqList](@hod_no as varchar(25),@code as varchar(10), @code1 as varchar(10), @opt as varchar(10))          
as    
set transaction isolation level read uncommitted          
set nocount on          
  
--Declare   
--@hod_no as varchar(25),  
--@code as varchar(10),  
--@code1 as varchar(10)  
--set @hod_no ='E01089'  
--set @code = '2'  
--set @code1=''  
  
if @opt = 'HOD'  
begin  
select a.itemID,a.ItemNAme,a.CategoryName,a.Qty,b.ReqStatusName into #allReq     
from UserRequest a,ReqStatus b where hod_no = @hod_no and (a.ReqStatusCOde =@code or a.ReqStatusCOde =@code1)    
and a.ReqStatusCode = b.ReqStatusCode    
order by a.Itemname    
select distinct ItemID, Itemname,CategoryName,ReqStatusName into #DistWOQty from #allReq order by itemname    
    
--select * from #DistWOQty     
select itemName,sum(Qty) as 'Qty' into #DistWQty from #allReq group by itemName order by itemname   
--select * from #DistWQty    
    
select a.ItemID,a.Itemname,a.CategoryName,a.ReqStatusName,b.Qty from #DistWOQty a left outer join  #DistWQty  b     
on a.Itemname = b.ItemName    
    
end  
else  
begin  
select a.itemID,a.ItemNAme,a.CategoryName,a.Qty,b.ReqStatusName into #allReq1     
from UserRequest a,ReqStatus b where a.hod_no=(select hod_no from hod_mapping where pi_no =@hod_no) and (a.ReqStatusCOde =@code or a.ReqStatusCOde =@code1)    
and a.ReqStatusCode = b.ReqStatusCode    
order by a.Itemname    
select distinct ItemID, Itemname,CategoryName,ReqStatusName into #DistWOQty1 from #allReq1 order by itemname    
    
--select * from #DistWOQty     
select itemName,sum(Qty) as 'Qty' into #DistWQty1 from #allReq1 group by itemName order by itemname   
--select * from #DistWQty    
    
select a.ItemID,a.Itemname,a.CategoryName,a.ReqStatusName,b.Qty from #DistWOQty1 a left outer join  #DistWQty1  b     
on a.Itemname = b.ItemName    
    
end  
    
    
  
--drop table #allreq    
--drop table #DistWOQty    
--drop table #DistWQty    
--select * from #allReq    
    
set nocount off      
  return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.HodmodifyNVIRequest
-- --------------------------------------------------

CREATE procedure [dbo].[HodmodifyNVIRequest]  
(  
@ModID nvarchar(15),  
@Pi_No nvarchar(15),  
@ReqID nvarchar(15),  
@ItemID varchar(20),  
@ItemName varchar(100),  
@UserNote varchar(100),  
@HodNote varchar(100),  
@ModBy varchar(10),  
@ModDate datetime,--varchar(50),  
@Note varchar(100),  
@CompleteByDate varchar(25),  
@qty int,  
@stat varchar(4),  
@modtype int,  
@ordID varchar(50)  
)  
as  
  
update UserRequest set ItemID = @ItemID, ItemName = @ItemName, UserNote = @UserNote, HodNote=@HodNote,Qty=@qty,CompleteByDate = @CompleteByDate, Pi_No = @Pi_No,ReqStatusCode = @stat,orderID=@ordID where ReqID = @ReqID  
  
insert into ModifiedRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@Note,@ModBy,@ModDate,@CompleteByDate,@stat,@modtype)  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.modifyOrderQueue
-- --------------------------------------------------

create procedure [dbo].[modifyOrderQueue]
(
@ordid varchar(50),
@hodid varchar(25),
@itemid varchar(50),
@initQty float,
@newQty float
)
as

Declare @totalQty float, @stock float

select @totalQty = TotalQty from Order_queue where hod_no = @hodid and itemid = @itemid

--set @totalQty = select TotalQty from Order_queue where hod_no = @hodid and itemid = @itemid
select @stock = StockQty from Order_Queue where hod_no = @hodid and itemid = @itemid

set @totalQty = (@totalQty - @initQty) + @newQty 

if(@totalQty<0)
begin
 set @stock = @stock + @totalQty
 set @totalqty = 0
end 

update Order_Queue set TotalQty = @totalQty, StockQty = @stock where hod_no = @hodid and itemid = @itemid
--update Order_Queue set TotalQty = (TotalQty - @initQty) + @newQty where hod_no = @hodid and itemid = @itemid
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.po_status_update
-- --------------------------------------------------

create proc [dbo].[po_status_update]  
(  
@poID varchar(10),  
@status varchar(10),
@REQID VARCHAR(20),
@option varchar(20)
)  
as 
if @option  ='POGEN'
BEGIN
update purchase_order_queue set status=@status where purchase_id=@poID  

update order_queue set status=@status where orderID   
in (select orderID from purchase_order_queue where purchase_id =@poID)  
  
update userrequest set reqstatuscode=@status where orderID   
in (select orderID from purchase_order_queue where purchase_id =@poID)  
END

IF @OPTION ='USRDELI'
BEGIN
update userrequest set reqstatuscode=@STATUS where ReqID=@REQID

update purchase_order_queue  set status=@STATUS where orderID in 
(select orderID from userrequest where reqid=@REQID)

update order_queue set status=@STATUS where orderID in
(select orderID from userrequest where reqid=@REQID)

END
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_notice
-- --------------------------------------------------
create procedure [dbo].[proc_notice]
(
@nID varchar(50)
)
as

select distinct a.Emp_name, a.Sr_name, b.ReqID, b.ItemName, b.NoteDate, c.ReqStatusName, b.note 
from Emp_info a, Notifications b, ReqStatus c, InventoryItem d, Category e  

where a.Emp_no = b.Emp_No AND b.NoteID =@nID 
AND ( b.CatName = e.CatName AND e.CatID = d.CatID) 
and b.ReqStatusCode=c.ReqStatusCode	

return

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
-- PROCEDURE dbo.sp_rpt_ebrok_detail_cli
-- --------------------------------------------------

CREATE procedure sp_rpt_ebrok_detail_cli (@fromdate as varchar(11))                                                          
as                                                          
                                                      
                                          
if(@fromdate='%')                          
begin                      
                         
                      
select @fromdate =max(sauda_date) from remisior.dbo.comb_co where brok_earned is not null                       
--select @todate  =max(sauda_date)+' 23:59:59' from remisior.dbo.comb_co where brok_earned is not null                       
--  print   @fromdate                  
--    print   @todate                    
end                          
/*                          
SET @fromdate ='Feb 01 2008'                                                          
set @todate  ='Feb 01 2008'                                                          
*/     
--DECLARE @fromdate as datetime                                        
   Set @fromdate=Convert(datetime,@fromdate)      
--   Set @todate=Convert(datetime,@todate)      
--DECLARE @fromdate as datetime,@todate as datetime       
--set @fromdate= 'Apr 01 2010'      
--set @todate='Jul 31 2010'          
                                                   
set transaction isolation level read uncommitted                                                          
select * into #remi_cli from remisior.dbo.comb_cli where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'                                                       
                                                      
set transaction isolation level read uncommitted                                                          
select *     
into #tmp_bsecm     
from remisior.dbo.BseCM_terminal (nolock) where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'                                                      
                                                      
update #tmp_bsecm set subbrokcode=b.subbrokcode from #remi_cli  b where                                                       
#tmp_bsecm.party_Code=b.party_code and #tmp_bsecm.sauda_DAte=b.sauda_DAte                                                       
and #tmp_bsecm.segment=b.segment                                                      
                                                      
                                                      
------------------ Get BSECM Terminalwise Data                                                          
set transaction isolation level read uncommitted                                                          
select a.segment,branch,sub_broker=subbrokcode,party_code,sauda_DAte,                                                          
Overall_Turnover=convert(money,0),ebrok_Turnover=convert(money,0),                                               
Overall_brok_earned=convert(money,0),Overall_Angel_share=convert(money,0),                                                         
ebrok_brok_earned=sum(brok_earned),ebrok_Angel_share=sum(angel_share)                                                          
                           
into #BSECM                                                          
from                                                       
(                                                          
--select y.aprtag,x.* from BseCM_terminal x (nolock) left outer join                                                          
select y.aprtag,x.*         
from #tmp_bsecm x (nolock)         
left outer join                                                          
(                                              
select APRTAG=b2c_sb from remisior.dbo.b2c_sb               
)y                                                           
on x.subbrokcode=y.aprtag                                     
) a ,         
(select * from remisior.dbo.ebrok_terminal_master (nolock) where to_date>@fromdate AND FROM_DATE<=@fromdate) b    where a.terminal_id=b.terminal_id and b.segment=a.segment                                                          
group by a.segment,branch,subbrokcode,sauda_DAte,party_code                                             
                                                      
                                      
------------------ Get NSECM Terminalwise Data                                                          
set transaction isolation level read uncommitted                                          
select * into #tmp_nsecm from remisior.dbo.nseCM_terminal (nolock) where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'                                                       
                                                      
update #tmp_nsecm set subbrokcode=b.subbrokcode from #remi_cli  b                                                       
where #tmp_nsecm.party_Code=b.party_code                                     
and #tmp_nsecm.sauda_DAte=b.sauda_DAte                                                       
and #tmp_nsecm.segment=b.segment                                              
                                                        
set transaction isolation level read uncommitted                                                          
select a.segment,branch,sub_broker=subbrokcode,party_code,sauda_DAte,                                                            
Overall_Turnover=convert(money,0),ebrok_Turnover=convert(money,0),                                                  
Overall_brok_earned=convert(money,0),Overall_Angel_share=convert(money,0),                                                          
ebrok_brok_earned=sum(brok_earned),ebrok_Angel_share=sum(angel_share)                                                  
                        
into #NSECM                                                          
from                                                           
(                                                          
select y.aprtag,x.* from #tmp_nsecm x left outer join                                                          
(                                              
select APRTAG=b2c_sb from remisior.dbo.b2c_sb                                            
)y                                                      
on x.subbrokcode=y.aprtag                                                          
where x.sauda_DAte >=@fromdate and x.sauda_date <=@fromdate +' 23:59:59'                                                          
)                                                          
a ,         
(select * from remisior.dbo.ebrok_terminal_master (nolock) where to_date>@fromdate AND FROM_DATE<=@fromdate) b   where a.terminal_id=b.terminal_id and b.segment=a.segment                                                          
and a.sauda_DAte >=@fromdate and sauda_date <=@fromdate +' 23:59:59'                                                   
group by a.segment,branch,subbrokcode,sauda_DAte,party_code                                                        
                                  
------------------ Get NSEFO Terminalwise Data                                                          
set transaction isolation level read uncommitted                                                 
select * into #tmp_nsefo from remisior.dbo.nseFO_terminal (nolock) where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'                                                       
                                         
update #tmp_nsefo set subbrokcode=b.subbrokcode from #remi_cli  b                                                       
where #tmp_nsefo.party_Code=b.party_code                                                       
and #tmp_nsefo.sauda_DAte=b.sauda_DAte                                                       
and #tmp_nsefo.segment=b.segment                                                      
                                                  
                                                      
set transaction isolation level read uncommitted                                              
select a.segment,branch,sub_broker=subbrokcode,party_Code,sauda_DAte,                                             Overall_Turnover=convert(money,0),ebrok_Turnover=convert(money,0),Overall_brok_earned=convert(money,0),Overall_Angel_share=convert(money,0), 
  
    
      
      ebrok_brok_earned=sum(brok_earned),ebrok_Angel_share=sum(angel_share)                                                                
into #NSEFO                                                          
from                                                           
(                                                          
select y.aprtag,x.* from  #tmp_nsefo x (nolock) left outer join                                                          
(                                                          
select APRTAG=b2c_sb from remisior.dbo.b2c_sb                                             
)y on x.subbrokcode=y.aprtag                                                          
where x.sauda_DAte >=@fromdate and x.sauda_date <=@fromdate +' 23:59:59'                                                          
)                                                          
a ,         
(select * from remisior.dbo.ebrok_terminal_master (nolock) where to_date>@fromdate AND FROM_DATE<=@fromdate) b   where a.terminal_id=b.terminal_id and b.segment=a.segment                                                          
group by a.segment,branch,subbrokcode,sauda_DAte,party_code                                                          
                                                          
------------------ Get MCX Terminalwise Data                                                          
set transaction isolation level read uncommitted                                                          
select * into #tmp_mcx from remisior.dbo.mcx_terminal (nolock) where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'             
                                                      
update #tmp_mcx set subbrokcode=b.subbrokcode from #remi_cli  b                                                       
where #tmp_mcx.party_Code=b.party_code                   
and #tmp_mcx.sauda_DAte=b.sauda_DAte                                                      
and #tmp_mcx.segment=b.segment                                                      
                                                      
set transaction isolation level read uncommitted                                                      
select a.segment,branch,sub_broker=subbrokcode,party_code,sauda_DAte,                                                              
Overall_Turnover=convert(money,0),ebrok_Turnover=convert(money,0),                                      
Overall_brok_earned=convert(money,0),Overall_Angel_share=convert(money,0),                                                         
ebrok_brok_earned=sum(brok_earned),ebrok_Angel_share=sum(angel_share)              into #mcdx                                                          
from                                                           
(                                          
select y.aprtag,x.* from #tmp_mcx x (nolock) left outer join                                                          
(                                              
select APRTAG=b2c_sb from remisior.dbo.b2c_sb                                             
)y                                                           
                                              
on x.subbrokcode=y.aprtag                                                          
)                                                          
a ,         
(select * from remisior.dbo.ebrok_terminal_master (nolock) where to_date>@fromdate AND FROM_DATE<=@fromdate) b   where a.terminal_id=b.terminal_id and b.segment=a.segment                                                          
group by a.segment,branch,subbrokcode,sauda_DAte,party_Code    
                               
                                                          
------------------ Get NCDEX Terminalwise Data                                                          
                                                      
set transaction isolation level read uncommitted                                                          
select * into #tmp_ncdex from remisior.dbo.ncdex_terminal (nolock) where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'                                                       
        
                                                  
update #tmp_ncdex set subbrokcode=b.subbrokcode from #remi_cli  b                         
where #tmp_ncdex.party_Code=b.party_code                                                       
and #tmp_ncdex.sauda_DAte=b.sauda_DAte                                                       
and #tmp_ncdex.segment=b.segment                                                      
                                                      
                                                      
set transaction isolation level read uncommitted                                                  
select a.segment,branch,sub_broker=subbrokcode,party_code,sauda_DAte,                                                              
Overall_Turnover=convert(money,0),ebrok_Turnover=convert(money,0),                                                     
Overall_brok_earned=convert(money,0),Overall_Angel_share=convert(money,0),                                                         
ebrok_brok_earned=sum(brok_earned),ebrok_Angel_share=sum(angel_share)          into #ncdx                                                          
from                                                           
(                                                          
select y.aprtag,x.* from #tmp_ncdex x (nolock) left outer join                                                          
(                                              
select APRTAG=b2c_sb from remisior.dbo.b2c_sb                                            
)y                                                           
on x.subbrokcode=y.aprtag                                                          
)                                                          
a, (select * from remisior.dbo.ebrok_terminal_master (nolock) where to_date>@fromdate AND FROM_DATE<=@fromdate) b where a.terminal_id=b.terminal_id and b.segment=a.segment                                                          
group by a.segment,branch,subbrokcode,sauda_DAte,party_code                                                          
                                                    
                                                        
insert into #nsefo select * from #bsecm                                                          
insert into #nsefo select * from #nsecm                                                          
insert into #nsefo select * from #mcdx                                                          
insert into #nsefo select * from #ncdx                                                          
                                                      
                                              
------------------- Get MIS Terminalwise Turnover Data                                                          
                                                      
/* updating MIS Sub-broker code with Remisier SB Code to match both the report with remisior Other reports*/                                                      
select * into #temp_MIS from intranet.bsedb_Ab.dbo.Mis_TO where sauda_DAte >=@fromdate and sauda_DAte <= @fromdate +' 23:59:59'          
        
----- update sub-broker code from remi.database                                                      
update #temp_MIS set sub_Broker=b.subbrokcode from #remi_cli  b where                                             #temp_MIS.party_Code=b.party_code collate Latin1_General_CI_AS                             
and #temp_MIS.sauda_DAte =b.sauda_DAte                                                       
and replace(#temp_MIS.company,'ACPLNCDEX','ACPLNCDX')=b.segment                                                     
                                                     
----- generate terminalwise summary for     
select                                                       
company=(case when company='ACPLNCDEX' then 'ACPLNCDX' else company end),                                         sauda_date,branch_Cd,Sub_Broker,party_code,terminal_id,                                        
turnover=sum(turnover),brokerage=sum(brokerage)                                                      
into #temp_mis_terminal                                                      
from #temp_MIS                                        
group by company,sauda_date,branch_Cd,sub_broker,party_code,terminal_id                                                                                                
set transaction isolation level read uncommitted                                                          
select company,sauda_date,branch_Cd,Sub_Broker,party_code,terminal_id,                                            turnover=sum(turnover),brokerage=sum(brokerage)                                                          
into #to_file                                                          
from #temp_mis_terminal a left outer join                                                           
(                                              
select APRTAG=b2c_sb from remisior.dbo.b2c_sb                                            
) b                                                           
on a.sub_Broker=b.aprtag                                                          
group by company,sauda_date,branch_Cd,Sub_Broker,terminal_id,party_code                                                                                                 
------------------- Update data from MIS -----------------------------------                     
select company,sauda_DAte,sub_Broker,party_Code,turnover=sum(turnover),brokerage=sum(brokerage),                  eturnover=sum(case when b.terminal_id is null then 0 else turnover end),                                          ebrokerage=sum(case when b
  
    
      
.terminal_id is null then 0 else brokerage end)                                        into #temp1                                                      
from #to_file a         
left outer join          
(select * from remisior.dbo.ebrok_terminal_master (nolock) where to_date>@fromdate AND FROM_DATE<=@fromdate) b   on a.company=b.segment and a.terminal_id=b.terminal_id                                                          
group by company,sauda_DAte,sub_BRoker,party_code                                                        
                                              
                                                      
select segment=isnull(a.company,b.segment),branch=isnull(b.branch,space(10)),sub_Broker=isnull(a.sub_Broker,b.sub_Broker),                                                      
party_code=isnull(a.party_code,b.party_code),party_name=space(100),sauda_date=isnull(a.sauda_date,b.sauda_date),  Overall_turnover=isnull(Overall_turnover,0),ebrok_Turnover=isnull(ebrok_Turnover,0)                              ,Overall_brok_earned=isnull(
  
    
      
Overall_brok_earned,0),                
Overall_Angel_share=isnull(Overall_Angel_share,0),                              
ebrok_brok_earned=isnull(ebrok_brok_earned,0),                                                      
ebrok_Angel_share=isnull(ebrok_Angel_share,0)                                                    
into #file                                                      
from #temp1 a left outer join #nsefo b                                                      
on a.sauda_date=b.sauda_Date                                               
and a.party_code=b.party_Code collate Latin1_General_CI_AS                                            
and b.segment=a.company                                                           
                                                      
update #file set overall_turnover = b.turnover,                                                           
Overall_brok_earned=b.brokerage, ebrok_Turnover=b.eturnover, ebrok_brok_earned=b.ebrokerage                       from #temp1 b                                                         
where #file.sauda_date=b.sauda_Date                                               
--and #file.Sub_Broker=b.sub_Broker                                               
and #file.party_code=b.party_code                                              
and #file.segment=b.company                                                           
                                                      
------------------- Update Overall Net Sharing data                                                           
                                        
update #file set Overall_Angel_share=b.angel_share                                                          
from (                                                          
select segment,sauda_Date,subbrokcode,party_code,                                              
brok_earned=sum(isnull(Brok_Earned,0)),angel_share=sum(isnull(angel_share,0))                                     from remisior.dbo.comb_cli a left outer join                  
(                                              
select APRTAG=b2c_sb from remisior.dbo.b2c_sb                                             
) b                                                      
on a.subbrokcode=b.aprtag                                                          
where sauda_DAte >=@fromdate and sauda_date <=@fromdate +' 23:59:59'                                                          
group by segment,sauda_Date,subBrokcode,party_code                                ) b                                                          
where #file.sauda_date=b.sauda_Date                                               
and #file.party_code collate SQL_Latin1_General_CP1_CI_AS=b.party_code                                               
and #file.segment=b.segment                                                        
                                
--------------------- Calcalate Percent                                                          
                                                
UPDATE #FILE SET BRANCH=B.BRANCH_CD FROM                                                 
(SELECT DISTINCT  SUB_bROKER,BRANCH_CD FROM INTRANET.RISK.DBO.CLIENT_DETAILS) B                                                 
WHERE #FILE.SUB_bROKER=B.SUB_bROKER                                                 
                                                
                
--Feb 22 2010-Shweta                
select * into #final from terminalmaster.dbo.ebrokingOfflineTrades                
where sauda_DAte >=@fromdate and sauda_date <=@fromdate +' 23:59:59'                
                
alter table #final alter column segment varchar(7)                
                         
update #final set segment='ABLCM' where segment='BSECM'                
update #final set segment='ACDLCM' where segment='NSECM'                
update #final set segment='ACPLMCX' where segment='MCX'                
update #final set segment='ACDLFO' where segment='FO'                
                
                
select a.*,turnover=isnull(turnover,0),total_brok=isnull(total_brok,0)                 
into #temp              
from                
(select * from #file                
) a                
left outer join                
#final b                
on a.sauda_date=b.sauda_date                 
and a.segment=b.segment                 
and a.party_code=b.party_code  collate Latin1_General_CI_AS                
                
select Net_perc=total_brok*100.00/case when ebrok_brok_earned =0 then 1 else ebrok_brok_earned end ,*                
into #temp3                
from #temp                
                
select segment,branch,sub_Broker,party_code,party_name,sauda_date,Overall_turnover,ebrok_Turnover,             
Overall_brok_earned,Overall_Angel_share,ebrok_brok_earned,ebrok_Angel_share               
from #file                
                
select segment ,branch ,sub_Broker ,party_code ,party_name ,sauda_date ,Overall_turnover ,ebrok_Turnover ,Overall_brok_earned ,Overall_Angel_share ,ebrok_brok_earned ,ebrok_Angel_share   
,B2C=space(20),Online=space(30),No_of_login=space(20),terminal_id=space(20),turnover, total_brok  ,Net_ebrok_offline=ebrok_Angel_share*Net_perc/100                                  
into #fin                
from #temp3               
         
update #fin set #fin.B2C='B2C' from mis.remisior.dbo.b2c_sb b where #fin.sub_broker=b.b2c_sb        
update #fin set #fin.B2C='B2B'  where #fin.B2C <> 'B2C'        
update #fin set #fin.Online='Online' from intranet.CTCL.dbo.ebrok_client b where #fin.party_code=b.party_code collate SQL_Latin1_General_CP1_CI_AS        
update #fin set #fin.Online='Offline'  where #fin.Online <> 'Online'        
        
select clientcode,coun=count(*)         
into #fin_login          
from [196.1.115.211].bidb.dbo.ebrokingfds_oct_09        
group by clientcode        
        
update #fin set #fin.No_of_login=coun from #fin_login b        
where #fin.party_code=b.clientcode collate SQL_Latin1_General_CP1_CI_AS        
        
        
select distinct party_code,sauda_date=max(sauda_date),terminal_id into #fin_id from intranet.bsedb_ab.dbo.mis_to where sauda_date>=@fromdate and sauda_date<=@fromdate +' 23:59:59'        
group by party_code,terminal_id        
        
        
update #fin set terminal_id=b.terminal_id from  #fin_id b        
where #fin.party_code=b.party_code        
        
update #fin                 
set ebrok_turnover=ebrok_turnover-turnover,Ebrok_brok_earned=Ebrok_brok_earned-total_brok,                
ebrok_angel_share=ebrok_angel_share-Net_ebrok_offline                
                
----                       
update #file set ebrok_Turnover=0,ebrok_brok_earned=0,ebrok_Angel_share=0        
                
where party_code not in             
(select distinct party_code collate Latin1_General_CI_AS from intranet.ctcl.dbo.ebrok_client)                                
                
delete from tbl_ebrok_detail_cli  where sauda_Date in (select distinct sauda_DAte from #file)                                                           
                                                         
insert into tbl_ebrok_detail_cli    
(segment ,branch ,sub_Broker ,party_code ,party_name ,sauda_date ,Overall_turnover ,ebrok_Turnover ,Overall_brok_earned ,Overall_Angel_share ,ebrok_brok_earned ,ebrok_Angel_share ,B2C ,Online ,No_of_login ,Terminal_id  
)                
select segment,branch,  
sub_Broker,  
party_code,  
party_name,  
sauda_date,  
convert(money,Overall_turnover),  
convert(money,ebrok_Turnover),                
convert(money,Overall_brok_earned),  
convert(money,Overall_Angel_share),  
convert(money,ebrok_brok_earned),  
convert(money,ebrok_Angel_share),  
B2C,  
Online,  
convert(money,No_of_login),  
convert(money,terminal_id)        
from #fin                                           
                                        
                                        
--delete from tbl_ebrok_detail where sauda_Date in (select distinct sauda_DAte from #file)                                        
--                                        
--insert into tbl_ebrok_detail                                        
--select segment, branch, sub_Broker, sauda_date,                                         
--Overall_turnover=sum(Overall_turnover), ebrok_Turnover=sum(ebrok_Turnover),                                         
--Overall_brok_earned=sum(Overall_brok_earned), Overall_Angel_share=sum(Overall_Angel_share),                       ebrok_brok_earned=sum(ebrok_brok_earned), ebrok_Angel_share=sum(ebrok_Angel_share)                                                        
  
     
     
           
--from #fin    
--group by sauda_Date,segment,branch,sub_Broker

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uploadBSETrade
-- --------------------------------------------------
CREATE procedure uploadbsetrade            
(            
 @foldername varchar(50),          
 @filename as varchar(50),            
 @mgr as varchar(10)             
)            
as            
begin            
 set nocount on            
 declare @path as varchar(500)            
 declare @sql as varchar(max)            
             
 truncate table tblbsetradetemp            
             
 --set @path='\\172.29.2.158\d$\upload1\tradefile\'+ @foldername +'\'+ @mgr +'\' + @filename             
  set @path='\\172.29.19.10\d$\upload1\tradefile\'+ @foldername +'\' + @filename      
 set @sql=''            
 set @sql=@sql+' bulk insert tblbsetradetemp from '            
 set @sql=@sql+''''+ @path +''''--'\\172.29.2.158\d$\upload1\tradefile\tr07122010_bse.txt'-- + @filename             
 set @sql=@sql+' with '            
 set @sql=@sql+' ( '            
 set @sql=@sql+' fieldterminator = ''|'','            
 set @sql=@sql+' rowterminator = ''\n'''            
 set @sql=@sql+' ) '            
 print (@sql)            
 exec(@sql)            
             
 delete from tblbsetrade where fname=@filename and mgr=@mgr            
             
 insert into tblbsetrade            
 select scripcd,scripname,tradeno,rate,qty,dummy1,dummy2,tradetime,            
   date,clinetcode_dealerid,buy_sell,dummy3,order_number,            
   pro_client,segement,clinet_code1,clinet_code2,            
   dummy4,isinno,series,settno,producttype,            
   tradetime1,ordertime,dummy5,@mgr,            
   @filename,convert(varchar,getdate(),106) from tblbsetradetemp            
 set nocount off            
             
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPLOADMCXSXTRADE
-- --------------------------------------------------
CREATE PROCEDURE UPLOADMCXSXTRADE      
(   
 @FolderName VARCHAR(50),     
 @FILENAME AS VARCHAR(50),      
 @Mgr AS VARCHAR(10)       
)      
AS      
BEGIN      
 SET NOCOUNT ON      
 DECLARE @PATH AS VARCHAR(100)      
 DECLARE @SQL AS VARCHAR(MAX)      
       
 TRUNCATE TABLE tblMCXSXTradeTemp      
       
 --SET @PATH='\\172.29.2.158\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\'+ @Mgr +'\' + @FILENAME      
  SET @PATH='\\172.29.19.10\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\' + @FILENAME  
 SET @SQL=''      
 SET @SQL=@SQL+' BULK INSERT tblMCXSXTradeTemp FROM '      
 SET @SQL=@SQL+''''+ @PATH +''''      
 SET @SQL=@SQL+' WITH '      
 SET @SQL=@SQL+' ( '      
 SET @SQL=@SQL+' FIELDTERMINATOR = '','','      
 SET @SQL=@SQL+' ROWTERMINATOR = ''\n'''      
 SET @SQL=@SQL+' ) '      
 --PRINT (@SQL)      
 EXEC(@SQL)      
       
 DELETE FROM tblMCXSXTrade WHERE FNAME=@FILENAME AND MGR=@MGR      
       
 INSERT INTO tblMCXSXTrade      
 SELECT TradeNo,Dummy1,Dummy2,InstType,Symbol1,Expiry,Dummy3,Dummy4,Dummy5,Symbol2,      
   Dummy6,OrderType1,Dummy7,ClinetCode_DealerID,Dummy8,Buy_Sell,Qty,Rate,      
   Dummy9,ClinetCode,MemberID1,Dummy10,MemberID2,Dummy11,TradeDateTime1,OrderDateTime,      
   OrderNo,Dummy12,Dummy13,TradeDateTime2,Dummy14,Dummy15,Dummy16,OrderType2,Dummy17,      
   Dummy18,Dummy19,Dummy20,@Mgr,      
   @FILENAME,CONVERT(VARCHAR,GETDATE(),106) FROM tblMCXSXTradeTemp      
 SET NOCOUNT OFF      
       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPLOADMCXTRADE
-- --------------------------------------------------
CREATE PROCEDURE UPLOADMCXTRADE    
(   
 @FolderName VARCHAR(50),   
 @FILENAME AS VARCHAR(50),    
 @Mgr AS VARCHAR(10)     
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @PATH AS VARCHAR(100)    
 DECLARE @SQL AS VARCHAR(MAX)    
     
 TRUNCATE TABLE tblMCXTradeTemp    
     
 --SET @PATH='\\172.29.2.158\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\'+ @Mgr +'\' + @FILENAME      
   SET @PATH='\\172.29.19.10\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\' + @FILENAME 
     
 SET @SQL=''    
 SET @SQL=@SQL+' BULK INSERT tblMCXTradeTemp FROM '    
 SET @SQL=@SQL+''''+ @PATH +''''    
 SET @SQL=@SQL+' WITH '    
 SET @SQL=@SQL+' ( '    
 SET @SQL=@SQL+' FIELDTERMINATOR = '','','    
 SET @SQL=@SQL+' ROWTERMINATOR = ''\n'''    
 SET @SQL=@SQL+' ) '    
 --PRINT (@SQL)    
 EXEC(@SQL)    
     
 DELETE FROM tblMCXTrade WHERE FNAME=@FILENAME AND MGR=@MGR    
     
 INSERT INTO tblMCXTrade    
 SELECT TradeNo,Dummy1,Dummy2,InstType,Symbol,Expiry,Dummy3,Dummy4,Dummy5,    
   ContractDescription,Dummy6,OrderType1,Dummy7,ClinetCode_DealerID,    
   Dummy8,Buy_Sell,Qty,Rate,Dummy9,ClinetCode,Member_ID1,Dummy10,MemberID2,    
   Dummy11,TradeDateTime,OrderDateTime,OrderNo,Dummy12,Dummy13,[DateTime],    
   Dummy14,Segement,Dummy15,Dummy16,Dummy17,Dummy18,OrderType2,Dummy19,@Mgr,    
   @FILENAME,CONVERT(VARCHAR,GETDATE(),106) FROM tblMCXTradeTemp    
 SET NOCOUNT OFF     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPLOADNSDEXTRADE
-- --------------------------------------------------
CREATE PROCEDURE UPLOADNSDEXTRADE      
(   
 @FolderName VARCHAR(50),  
 @FILENAME AS VARCHAR(50),      
 @Mgr AS VARCHAR(10)       
)      
AS      
BEGIN      
 SET NOCOUNT ON      
 DECLARE @PATH AS VARCHAR(100)      
 DECLARE @SQL AS VARCHAR(MAX)      
       
 TRUNCATE TABLE tblNSDEXTradeTemp      
       
 --SET @PATH='\\172.29.2.158\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\'+ @Mgr +'\' + @FILENAME     
     SET @PATH='\\172.29.19.10\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\' + @FILENAME       
 SET @SQL=''      
 SET @SQL=@SQL+' BULK INSERT tblNSDEXTradeTemp FROM '      
 SET @SQL=@SQL+''''+ @PATH +''''      
 SET @SQL=@SQL+' WITH '      
 SET @SQL=@SQL+' ( '      
 SET @SQL=@SQL+' FIELDTERMINATOR = '','','      
 SET @SQL=@SQL+' ROWTERMINATOR = ''\n'''      
 SET @SQL=@SQL+' ) '      
 --PRINT (@SQL)      
 EXEC(@SQL)      
       
 DELETE FROM tblNSDEXTrade WHERE FNAME=@FILENAME AND MGR=@MGR      
       
 INSERT INTO TBLNSDEXTrade      
 SELECT TradeNo,Dummy1,InstType,Symbol,Expiry,Dummy2,Dummy3,ContractDescription,      
   Dummy4,OrderType1,Dummy5,ClinetCode_DealerID,Dummy6,Buy_Sell,Qty,Rate,      
   Dummy7,ClinetCode,MemberID,Dummy8,Dummy9,TradeDateTime,OrderDateTime,OrderNo,      
   Dummy10,Segement,Dummy11,Dummy12,Dummy13,OrderType2,Dummy14,@Mgr,      
   @FILENAME,CONVERT(VARCHAR,GETDATE(),106) FROM TBLNSDEXTradeTemp      
 SET NOCOUNT OFF      
       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPLOADNSEFOTRADE
-- --------------------------------------------------
CREATE PROCEDURE UPLOADNSEFOTRADE    
(    
 @FolderName VARCHAR(50),  
 @FILENAME AS VARCHAR(50),    
 @Mgr AS VARCHAR(10)     
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @PATH AS VARCHAR(100)    
 DECLARE @SQL AS VARCHAR(MAX)    
     
 TRUNCATE TABLE tblNSEFOTradeTemp    
     
 --SET @PATH='\\172.29.2.158\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\'+ @Mgr +'\' + @FILENAME     
    SET @PATH='\\172.29.19.10\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\' + @FILENAME    
 SET @SQL=''    
 SET @SQL=@SQL+' BULK INSERT tblNSEFOTradeTemp FROM '    
 SET @SQL=@SQL+''''+ @PATH +''''    
 SET @SQL=@SQL+' WITH '    
 SET @SQL=@SQL+' ( '    
 SET @SQL=@SQL+' FIELDTERMINATOR = '','','    
 SET @SQL=@SQL+' ROWTERMINATOR = ''\n'''    
 SET @SQL=@SQL+' ) '    
 --PRINT (@SQL)    
 EXEC(@SQL)    
     
 DELETE FROM tblNSEFOTrade WHERE FNAME=@FILENAME AND MGR=@MGR    
     
 INSERT INTO tblNSEFOTrade    
 SELECT TradeNo,Dummy1,InstType,Symbol,ExpiryDate,StrikePrice,OptionType,ContractDescription,    
   Dummy2,OrderType,Dummy3,ClinetCode_DealerID,Dummy4,Buy_Sell,Qty,Rate,Dummy5,    
   Clinet_Code1,MemberID,Dummy6,Dummy7,TradeDateTime,OrderDateTime,OrderNo,Dummy8,    
   InstrumentType,ClinetCode2,ClinetCode3,Dummy9,TradeDateTime1,OrderDateTime1,OrderType1,    
   @Mgr,@FILENAME,CONVERT(VARCHAR,GETDATE(),106) FROM tblNSEFOTradeTemp    
 SET NOCOUNT OFF    
     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPLOADNSETRADE
-- --------------------------------------------------
CREATE PROCEDURE UPLOADNSETRADE      
(     
 @FolderName VARCHAR(50),   
 @FILENAME AS VARCHAR(50),      
 @Mgr AS VARCHAR(10)       
)      
AS      
BEGIN      
 SET NOCOUNT ON      
 DECLARE @PATH AS VARCHAR(100)      
 DECLARE @SQL AS VARCHAR(MAX)      
       
 TRUNCATE TABLE tblNSETradeTemp      
       
 --SET @PATH='\\172.29.2.158\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\'+ @Mgr +'\' + @FILENAME 
   SET @PATH='\\172.29.19.10\D$\UPLOAD1\TRADEFILE\'+ @FolderName +'\' + @FILENAME    
          
 SET @SQL=''      
 SET @SQL=@SQL+' BULK INSERT tblNSETradeTemp FROM '      
 SET @SQL=@SQL+''''+ @PATH +''''      
 SET @SQL=@SQL+' WITH '      
 SET @SQL=@SQL+' ( '      
 SET @SQL=@SQL+' FIELDTERMINATOR = '','','      
 SET @SQL=@SQL+' ROWTERMINATOR = ''\n'''      
 SET @SQL=@SQL+' ) '      
 --PRINT (@SQL)      
 EXEC(@SQL)      
       
 DELETE FROM tblNSETrade WHERE FNAME=@FILENAME AND MGR=@MGR      
       
 INSERT INTO tblNSETrade      
 SELECT TradeNo,Dummy1,Symbol,Series,ScripName,Dummy2,Dummy3,Dummy5,      
   ClinetCode_DealerID,Dummy6,Buy_Sell,Qty,Rate,Dummy7,ClinetCode1,      
   MemberID,MarketType,Dummy8,Dummy9,TradeDateTime,OrderDateTime,      
   OrderNumber,Dummy10,Segement,ClinetCode2,ClinetCode3,Dummy11,ProductType,      
   TradeTime,OrderTime,@Mgr,      
   @FILENAME,CONVERT(VARCHAR,GETDATE(),106) FROM tblNSETradeTemp      
 SET NOCOUNT OFF      
       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CalOfflineTurnOver
-- --------------------------------------------------
CREATE procedure [dbo].[usp_CalOfflineTurnOver]                  
(                  
 @FDate datetime ,                  
 @TDate datetime                   
)                  
as                  
begin                  
 set nocount on;                  
--declare @FDate datetime ,@TDate datetime                   
--set @TDate =Convert(datetime,Convert(varchar,GETDATE(),106)+' 00:00:00')                  
--set @FDate =Convert(datetime,Convert(varchar,GETDATE(),106)+' 23:59:59')                  
set @FDate =Convert(datetime,Convert(varchar,@FDate,106)+' 00:00:00')                  
set @TDate =Convert(datetime,Convert(varchar,@TDate,106)+' 23:59:59')                  
print @FDate                  
print @TDate                  
delete from EbrokOfflineTrade where sauda_date>=@FDate and sauda_date<=@TDate and segment  in('BSECM')       
        
  -----BSE                  
insert into EbrokOfflineTrade                  
select  segment='BSECM', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),                                                
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                   
Turnover=sum(MarketRate*tradeqty)                     
from                                                
(                     
Select  scripcd,TradeNo,orderno,ltrim(rtrim(party_code)) as party_code,dealerid,sauda_date,qty,rate from BSETrade                  
where sauda_date>=@FDate and sauda_date<=@TDate                  
and ltrim(rtrim(party_code))<>dealerid                                            
) a,                                                
(                                                
select                                                 
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate ,Trade_no,User_id as terminalid                                               
from AngelBSECM.bsedb_Ab.dbo.history where sauda_date >=@FDate and sauda_DAte <=@TDate                             
) b                                                 
where dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo) and b.scrip_Cd=a.scripcd and a.party_code=b.party_code                           
and b.Order_no=a.orderno                                              
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code    
print 'BSECM'                
  -----                  
                    
  -----NSE                  
   /*insert into EbrokOfflineTrade                  
select segment='NSECM', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),                                                
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),                    
Turnover=sum(MarketRate*tradeqty)                              
from                                                
(                  
select distinct symbol,TradeNo,OrderNumber,ltrim(rtrim(party_code)) as party_code,dealerid,sauda_date,qty,rate from NSETrade_r                  
where sauda_date>=@FDate and sauda_date<=@TDate                  
and ltrim(rtrim(party_code))<>dealerid                   
) a,                                                
(                                                
select                                       
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate,Trade_no,User_id as terminalid                                                 
from AngelNseCM.msajag.dbo.history where sauda_date >=@FDate and sauda_DAte <=@TDate                                                
) b                                                 
where dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo) and b.scrip_Cd=a.symbol and a.party_code=b.party_code                          
and b.Order_no=a.OrderNumber                                                                   
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code  
print 'NSECM'                   
  -----              
                     
  ---NSEFO                  
	select b.*,BseCode=A.Symbol,OrderNo,TradeNo,                              
	Turnover=(strike_price+ price)* tradeqty,                                         
	Brokerage=case when left(inst_type,3)='FUT' then tradeqty*brokapplied else 0 end                                
	into #fofile from                                                
	(                  
	select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,OrderNo,TradeNo                     
	from dbo.NSEFOTrade_R                      
	where sauda_date >=@FDate and sauda_date <=@TDate                     
	and ltrim(rtrim(party_Code))<>DealerID                   
	) a,                                                
	(                                                
	select   Trade_no,                                             
	sauda_date,Party_code,symbol,inst_type,Sec_name,expirydate,option_type,nBrokApp,Order_no,Tradeqty,brokapplied ,                    
	price,strike_price ,User_id as terminalid                     
	from angelfo.nsefo.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate                                               
	) b                                                 
	where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.TradeNo                          
	and b.Order_no=a.OrderNo                                                               

	select trade_no,order_no,party_code,                                      
	brokerage=sum(cd_tot_brok)                                                      
	into #nsefo_opt                                                                  
	from                                                                   
	#fofile a INNER JOIN angelfo.nsefo.dbo.charges_detail b                                                                  
	ON a.trade_no=b.cd_auctionPart+b.CD_trade_no                        
	and a.order_no=b.cd_order_no                                                                  
	and a.party_Code=b.cd_party_code                                                                  
	where b.cd_sauda_DATE >=@FDate and b.cd_sauda_Date <= @TDate                         
	group by trade_no,order_no,party_code                                 

	update #fofile set Brokerage=b.brokerage from #nsefo_opt b where (#fofile.trade_no)=b.trade_no                                      
	and #fofile.order_no=b.order_no and #fofile.party_code=b.party_code                   

	insert into EbrokOfflineTrade                  
	select segment='FO', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                                                
	Party_code,Total_Brok=sum(Brokerage),Turnover=sum(Turnover)                            
	from #fofile                                                
	group by convert(Datetime,convert(varchar(11),sauda_date)),Party_code                
	print 'FO'*/            
  ----MCX              
    /*insert into EbrokOfflineTrade              
	select segment='MCX', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),                                            
	b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                                      
	Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                                       
	from                                            
	(select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,orderno,TradeNo                
	from MCXTrade  where                                    
	sauda_date >=@FDate and sauda_date <=@TDate and ltrim(rtrim(party_Code))<>ltrim(rtrim(DealerID)) ) a,                                            
	(                                            
	select Trade_no,                                         
	sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,                
	Order_no,Tradeqty,brokapplied  ,price   ,User_id as terminalid                                                  
	from angelcommodity.mcdx.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate                                            
	) b                                             
	where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo)                         
	and b.Order_no=a.orderno                            
	group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code  
	print 'MCX'                 
 -----              
          -----NCDEX              
	insert into EbrokOfflineTrade              
	select segment='NCDEX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),                                                      
	b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                                      
	Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                        
	from                                            
	(select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,OrderNo,TradeNo                 
	from dbo.NSDEXTrade  where                 
	sauda_date >=@FDate and sauda_date <=@TDate                 
	and ltrim(rtrim(party_Code))<>ltrim(rtrim(DealerID)) ) a,                                            
	(                                            
	select Trade_no,                                         
	sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,                
	expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied  ,price,User_id as terminalid                                                     
	from angelcommodity.ncdx.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate                                            
	) b                                             
	where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo)                         
	and b.Order_no=a.OrderNo                                                              
	group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code               
	print 'NCDEX'              
	-----MCXSX              
	insert into EbrokOfflineTrade              
	select segment='MCXSX', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),                                            
	b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument)  ),                                      
	Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument))                                   
	from                                            
	(select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,OrderNo,TradeNo                
	from MCXSXTrade where                 
	sauda_date >=@FDate and sauda_date <=@TDate and ltrim(rtrim(party_Code))<>ltrim(rtrim(DealerID)) ) a,                                            
	(                                            
	select Trade_no,                                         
	sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,                
	Order_no,Tradeqty,brokapplied  ,price,User_id as terminalid                                                   
	from angelcommodity.mcdxcds.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate                                            
	) b                                             
	where a.party_code=b.party_code  and dbo.get_trade_num(b.Trade_no)=a.TradeNo                            
	and b.Order_no=a.OrderNo                                                           
	group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code         
	print 'MCXSX'  */         
         
 set nocount off;                  
                   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CalOfflineTurnOver_TerminalWise
-- --------------------------------------------------
CREATE procedure [dbo].[usp_CalOfflineTurnOver_TerminalWise]  
(  
 @FDate datetime ,  
 @TDate datetime  
)  
as  
begin  
set nocount on;  
--declare @FDate datetime ,@TDate datetime  
--set @TDate =Convert(datetime,Convert(varchar,GETDATE(),106)+' 00:00:00')  
--set @FDate =Convert(datetime,Convert(varchar,GETDATE(),106)+' 23:59:59')  
set @FDate =Convert(datetime,Convert(varchar,@FDate,106)+' 00:00:00')  
set @TDate =Convert(datetime,Convert(varchar,@TDate,106)+' 23:59:59')  
print @FDate  
print @TDate  
delete from EbrokOfflineTOTerminal where sauda_date>=@FDate and sauda_date<=@TDate  
  
-----BSE  
insert into EbrokOfflineTOTerminal  
select segment='BSECM', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),  
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),  
Turnover=sum(MarketRate*tradeqty),terminalid,0,0  
from  
(  
Select scripcd,TradeNo,orderno,ltrim(rtrim(party_code)) as party_code,dealerid,sauda_date,qty,rate from BSETrade  
where sauda_date>=@FDate and sauda_date<=@TDate  
and ltrim(rtrim(party_code))<>dealerid  
) a,  
(  
select  
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate ,Trade_no,User_id as terminalid  
from AngelBSECM.bsedb_Ab.dbo.history where sauda_date >=@FDate and sauda_DAte <=@TDate  
) b  
where dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo) and b.scrip_Cd=a.scripcd and a.party_code=b.party_code  
and b.Order_no=a.orderno  
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code,terminalid  
print 'BSECM'  
-----  
  
-----NSE  
insert into EbrokOfflineTOTerminal  
select segment='NSECM', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),  
b.Party_code,Total_Brok=sum(nBrokApp*Tradeqty),  
Turnover=sum(MarketRate*tradeqty),terminalid,0,0  
from  
(  
select distinct symbol,TradeNo,OrderNumber,ltrim(rtrim(party_code)) as party_code,dealerid,sauda_date,qty,rate from NSETrade_r  
where sauda_date>=@FDate and sauda_date<=@TDate  
and ltrim(rtrim(party_code))<>dealerid  
) a,  
(  
select  
sauda_date,Party_code,Scrip_cd,nBrokApp,Order_no,Tradeqty,MarketRate,n_netrate,Trade_no,User_id as terminalid  
from AngelNseCM.msajag.dbo.history where sauda_date >=@FDate and sauda_DAte <=@TDate  
) b  
where dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo) and b.scrip_Cd=a.symbol and a.party_code=b.party_code  
and b.Order_no=a.OrderNumber  
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code,terminalid  
print 'NSECM'  
-----  
  
---NSEFO  
select b.*,BseCode=A.Symbol,OrderNo,TradeNo,  
Turnover=(strike_price+ price)* tradeqty,  
Brokerage=case when left(inst_type,3)='FUT' then tradeqty*brokapplied else 0 end  
into #fofile from  
(  
select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,OrderNo,TradeNo  
from dbo.NSEFOTrade_R  
where sauda_date >=@FDate and sauda_date <=@TDate  
and ltrim(rtrim(party_Code))<>DealerID  
) a,  
(  
select Trade_no,  
sauda_date,Party_code,symbol,inst_type,Sec_name,expirydate,option_type,nBrokApp,Order_no,Tradeqty,brokapplied ,  
price,strike_price ,User_id as terminalid  
from angelfo.nsefo.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate  
) b  
where a.party_code=b.party_code and dbo.get_trade_num(b.Trade_no)=a.TradeNo  
and b.Order_no=a.OrderNo  
  
select trade_no,order_no,party_code,  
brokerage=sum(cd_tot_brok)  
into #nsefo_opt  
from  
#fofile a INNER JOIN angelfo.nsefo.dbo.charges_detail b  
ON a.trade_no=b.cd_auctionPart+b.CD_trade_no  
and a.order_no=b.cd_order_no  
and a.party_Code=b.cd_party_code  
where b.cd_sauda_DATE >=@FDate and b.cd_sauda_Date <= @TDate  
group by trade_no,order_no,party_code  
  
update #fofile set Brokerage=b.brokerage from #nsefo_opt b where (#fofile.trade_no)=b.trade_no  
and #fofile.order_no=b.order_no and #fofile.party_code=b.party_code  
  
insert into EbrokOfflineTOTerminal  
select segment='FO', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),  
Party_code,Total_Brok=sum(Brokerage),Turnover=sum(Turnover),terminalid,0,0  
from #fofile  
group by convert(Datetime,convert(varchar(11),sauda_date)),Party_code,terminalid  
print 'FO'  

----MCX  
insert into EbrokOfflineTOTerminal  
select segment='MCX', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),  
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument) ),  
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument)),terminalid,0,0  
from  
(select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,orderno,TradeNo  
from MCXTrade where  
sauda_date >=@FDate and sauda_date <=@TDate and ltrim(rtrim(party_Code))<>ltrim(rtrim(DealerID)) ) a,  
(  
select Trade_no,  
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,  
Order_no,Tradeqty,brokapplied ,price ,User_id as terminalid  
from angelcommodity.mcdx.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate  
) b  
where a.party_code=b.party_code and dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo)  
and b.Order_no=a.orderno  
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code ,terminalid 
print 'MCX'  
-----  

-----NCDEX  
insert into EbrokOfflineTOTerminal  
select segment='NCDEX', sauda_date=convert(Datetime,convert(varchar(11),sauda_date)),  
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument) ),  
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument)),terminalid,0,0  
from  
(select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,OrderNo,TradeNo  
from dbo.NSDEXTrade where  
sauda_date >=@FDate and sauda_date <=@TDate  
and ltrim(rtrim(party_Code))<>ltrim(rtrim(DealerID)) ) a,  
(  
select Trade_no,  
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,  
expirydate,option_type,booktype,instrument,Order_no,Tradeqty,brokapplied ,price,User_id as terminalid  
from angelcommodity.ncdx.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate  
) b  
where a.party_code=b.party_code and dbo.get_trade_num(b.Trade_no)=dbo.get_trade_num(a.TradeNo)  
and b.Order_no=a.OrderNo  
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code,terminalid  
print 'NCDEX' 
 
-----MCXSX  
insert into EbrokOfflineTOTerminal  
select segment='MCXSX', sauda_date=convert(Datetime,convert(varchar(11),b.sauda_date)),  
b.Party_code,Total_Brok=sum(brokapplied*tradeqty*(booktype/instrument) ),  
Turnover=sum((strike_price+price)* tradeqty*(booktype/instrument)),terminalid,0,0  
from  
(select distinct party_Code=ltrim(rtrim(party_Code)),Symbol,OrderNo,TradeNo  
from MCXSXTrade where  
sauda_date >=@FDate and sauda_date <=@TDate and ltrim(rtrim(party_Code))<>ltrim(rtrim(DealerID)) ) a,  
(  
select Trade_no,  
sauda_date,Party_code,symbol,strike_price,inst_type,Sec_name,expirydate,option_type,booktype,instrument,  
Order_no,Tradeqty,brokapplied ,price,User_id as terminalid  
from angelcommodity.mcdxcds.dbo.fosettlement where sauda_date >=@FDate and sauda_DAte <=@TDate  
) b  
where a.party_code=b.party_code and dbo.get_trade_num(b.Trade_no)=a.TradeNo  
and b.Order_no=a.OrderNo  
group by convert(Datetime,convert(varchar(11),b.sauda_date)),b.Party_code,terminalid  
print 'MCXSX'   
  
set nocount off;  
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_EbrokOfflineTurnOver
-- --------------------------------------------------
CREATE procedure usp_EbrokOfflineTurnOver                      
(                      
 @FDate datetime=null ,                      
 @TDate datetime=null                       
)                      
as                      
begin                      
 set nocount on;       
 ---196.1.115.167 MIS Server    
 ---use Ebroking    
 set @FDate =Convert(datetime,Convert(varchar,@FDate,106)+' 00:00:00')    
 set @TDate =Convert(datetime,Convert(varchar,@TDate,106)+' 23:59:59')    
 print @FDate                      
 print @TDate    
 Select sauda_date=convert(datetime,Convert(varchar,sauda_date,106)),segment,party_code,    
 ETOOffline=SUM(isnull(TurnOver,0)),    
 EBrokerageOffline=SUM(isnull(Total_Brok,0))    
 into #Offline    
 from MIS.Ebroking.dbo.EbrokOfflineTrade   
 --where sauda_date>=@Fdate and sauda_date<=@Tdate    
 group by sauda_date,segment,party_code    
 order by sauda_date,segment    
  
 update #Offline set Segment='ABLCM' where Segment='BSECM'    
 update #Offline set Segment='ACDLFO' where Segment='FO'    
 update #Offline set Segment='ACPLMCX' where Segment='MCX'    
 update #Offline set Segment='ACPLNCDEX' where Segment='NCDEX'    
 update #Offline set Segment='ACDLCM' where Segment='NSECM'    
 update #Offline set Segment='ACPLMCD' where Segment='MCXSX'    
  
  
 Select  sauda_date=convert(datetime,Convert(varchar,sauda_date,106)),company,party_code,    
 TurnOver=SUM(isnull(TurnOver,0)),    
 Brokerage=SUM(isnull(Brokerage,0)),    
 ETOOnline=SUM(isnull(ETurnover,0)),    
 EBrokerageOnline=SUM(isnull(EBrokerage,0))    
 into #Online    
 from mis.remisior.dbo.ebrok_terminal_calc    
 --where sauda_date>=@Fdate and sauda_date<=@Tdate    
 group by sauda_date,company,party_code    
 order by sauda_date,company    
  
 --delete from EBrokeOnlinTo where sauda_date>=@Fdate and sauda_date<=@Tdate    
 if EXISTS (select * from sysobjects where name ='EBrokeOnlineTo' and xtype='U')  
 begin  
 drop table EBrokeOnlineTo  
 end  
  
 select     
 b.sauda_date,Segment=b.Company,b.party_code,    
 OnlineTO=(isnull(ETOOnline,0)-isnull(ETOOffline,0)),    
 OnlineBrokerage=(isnull(EBrokerageOnline,0)-isnull(EBrokerageOffline,0))    
 --OnlineTO=(round(isnull(ETOOnline,0),4)-round(isnull(ETOOffline,0),4)),    
 --OnlineBrokerage=(round(isnull(EBrokerageOnline,0),4)-isnull(round(EBrokerageOffline,0),4))    
 into EBrokeOnlineTo    
 from  #online b left outer join  #Offline a    
 on a.sauda_date=b.sauda_date    
 and a.segment=b.Company    
 and a.party_code=b.party_code collate SQL_Latin1_General_CP1_CI_AS    
set nocount off    
end

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
-- PROCEDURE dbo.usp_uploadBSETrade
-- --------------------------------------------------
-- =============================================  
-- author: <amit gupta>  
-- create date: <20-jan-2011>  
-- description: <upload trade file auto process>  
-- =============================================  
CREATE procedure usp_uploadBSETrade  
as  
begin  
set nocount on;  
  
/*****************************  
START DECLARATION OF VARIABLE  
********************************/  
  
declare @path as varchar(500)  
declare @filepath as varchar(500)  
declare @sql as varchar(max)  
declare @filename as varchar(25)  
declare @mgr as varchar(25)  
declare @cnt as int  
declare @currdt datetime  
  
/***************************************************  
cheking file are exists for every manger and process  
*****************************************************/  
  
set @currdt=getdate()  
  
set @filename =replace(convert(varchar, getdate(), 103),'/','')+'.txt'  
select @cnt=count(*) from tblfilepath where segment='BSE'  
while @cnt>0 ---loop for all manger  
begin  
select @path=filepath,@mgr=manager from tblfilepath where segment='BSE' and cnt=@cnt  
set @filepath=@path+@filename  
  
truncate table tblfilestatus  
insert into tblfilestatus exec master..xp_fileexist @filepath  
  
if exists (select * from tblfilestatus where fileexists=0)  
begin  
/******************************************  
IF FILE ARE NOT EXISTS INSERT LOG DETAILS  
*******************************************/  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('BSE',@mgr,@filepath,@currdt,  
'In BSE segment '+@filename+' file are not exist on specific path for manager '  
+@mgr +', at time '+convert(varchar,@currdt,109)+'.','user')  
end  
else  
begin  
begin try  
truncate table bsetradetemp  
set @sql=''  
set @sql=@sql+' bulk insert bsetradetemp from '  
set @sql=@sql+''''+ @filepath +''''  
set @sql=@sql+' with '  
set @sql=@sql+' ( '  
set @sql=@sql+' fieldterminator = ''|'','  
set @sql=@sql+' rowterminator = ''\n'''  
set @sql=@sql+' ) '  
--print (@sql)  
exec(@sql)  
---CHECKING DATA INSIDE FILE FOR SAME SAUDA DATE  
/*if exists(select top 1 * from bsetradetemp  
where convert(datetime,convert(varchar,sauda_date,106))=convert(datetime,convert(varchar,@currdt,106)))  
begin  */
delete from bsetrade where fname=@filename and mgr=@mgr  
  
insert into bsetrade  
select scripcd,scripname,tradeno,rate,qty,dummy1,dummy2,tradetime,sauda_date,  
ltrim(rtrim(dealerid)) as dealerid,buy_sell,  
dummy3,orderno,pro_client,  
segement,  
ltrim(rtrim(party_code)) as party_code,  
ltrim(rtrim(party_code2)) as party_code2,  
dummy4,isinno,series,settno,producttype,tradetime1,ordertime,  
dummy5,'',@filename as fname,@currdt as uploaddate,@mgr as mgr from bsetradetemp  
  
update bsetrade set party_code=dealerid  
where ltrim(rtrim(party_code))='' and fname=@filename and mgr=@mgr  
  
------ CHECK FILE MOVE FOLDER  
set @path=@path+'BSESuccess\'  
declare @trailingslash varchar(750)  
set @trailingslash = reverse(@path)  
if '\' = left(@trailingslash, 1)  
set @trailingslash = substring(@trailingslash, 2, len(@path) + 1)  
set @path = reverse(@trailingslash)  
declare @cmd nvarchar(4000)  
set @cmd = 'dir ' + @path  
declare @exists tinyint  
set @exists = 0  
create table #dir (output nvarchar(4000))  
insert into #dir exec master..xp_cmdshell @cmd,no_output  
if not exists (select * from #dir where output like '%' + @path)  
begin  
declare @newpath varchar(550)  
set @newpath= 'md '+ @path+'\'  
exec xp_cmdshell @newpath,no_output  
end  
declare @movestr as varchar(750)  
set @movestr='move "'+ @filepath +'" "'+@path +'"'  
exec master..xp_cmdshell @movestr,no_output  
------END CHECK FILE MOVE FOLDER  
  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('BSE',@mgr,@filepath,@currdt,  
'In BSE segment for manager '+@mgr +' '+@filename+' data is successfully importade for sauda date '+  
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','success')  
/*end  
else  
begin  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('BSE',@mgr,@filepath,@currdt,  
'In BSE segment for manager '+@mgr +' '+@filename+' data is not available for sauda date '+  
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','user')  
end */  
end try  
begin catch  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('BSE',@mgr,@filepath,@currdt,  
'In BSE segment '+@filename+' file are not uploaded for manager '  
+@mgr +', at time '+convert(varchar,@currdt,109)+'. due to Errornumber: '+cast(error_number() as varchar)+  
' Errorseverity: '+cast (error_severity() as varchar)+  
' Errorstate: '+cast (error_state() as varchar)+  
' Errorline: '+cast (error_line() as varchar)+  
' Errormessage: '+error_message(),'system')  
end catch  
  
end  
set @cnt=@cnt-1  
  
end--end while loop  
set nocount off;  
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadMCXSXTrade
-- --------------------------------------------------
-- =============================================    
-- author: <Amit Gupta>    
-- create date: <20-Jan-2011>    
-- description: <Upload Trade File Auto Process>    
-- =============================================    
CREATE procedure usp_UploadMCXSXTrade    
as    
begin    
set nocount on;    
---Start declaration of variable    
declare @Path as varchar(500)    
declare @filePath as varchar(500)    
declare @sql as varchar(max)    
declare @filename as varchar(25)    
declare @mgr as varchar(25)    
declare @cnt as int    
declare @CurrDt datetime    
---End    
set @CurrDt=GETDATE()    
    
set @filename =replace(convert(varchar, @CurrDt, 103),'/','')+'.txt'    
select @cnt=COUNT(*) from tblFilePath where segment='MCXSX'    
while @cnt>0 ---Loop for all manger    
begin    
select @Path=filepath,@mgr=manager from tblFilePath where segment='MCXSX' and cnt=@cnt    
set @filePath=@Path+@filename    
--print @filePath    
truncate table tblFileStatus    
    
Insert into tblFileStatus exec master..xp_fileexist @filePath    
    
if Exists (select * from tblFileStatus where FileExists=0)    
begin    
    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('MCXSX',@mgr,@filePath,@CurrDt,    
'In MCXSX segment '+@filename+' file are not exist on specific path for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'.','User')    
    
end    
else    
begin    
    
begin try    
truncate table MCXSXTradeTemp    
set @sql=''    
set @sql=@sql+' bulk insert MCXSXTradeTemp from '    
set @sql=@sql+''''+ @filePath +''''    
set @sql=@sql+' with '    
set @sql=@sql+' ( '    
set @sql=@sql+' fieldterminator = '','','    
set @sql=@sql+' rowterminator = ''\n'''    
set @sql=@sql+' ) '    
--print (@sql)    
exec(@sql)    
    
---Checking Data inside file for same sauda date    
if exists(Select top 1 * from MCXSXTradeTemp where CONVERT(datetime,Convert(varchar,sauda_date,106))=    
CONVERT(datetime,Convert(varchar,@CurrDt,106)))    
begin
delete from MCXSXTrade where FName=@filename and Mgr=@Mgr    
insert into MCXSXTrade    
Select TradeNo,Dummy1,Dummy2,InstType,Symbol,Expiry,Dummy3,Dummy4,Dummy5,    
Symbol1,Dummy6,OrderType1,Dummy7,ltrim(rtrim(DealerID)) as DealerID,Dummy8,Buy_Sell,Qty,Rate,    
Dummy9,ltrim(rtrim(party_code))as party_code,MemberID1,Dummy10,MemberID2,Dummy11,sauda_date,    
OrderDateTime,OrderNo,Dummy12,Dummy13,sauda_date1,Dummy14,Dummy15,Dummy16,    
OrderType2,Dummy17,Dummy18,Dummy19,Dummy20,    
@mgr as Mgr ,@filename as FName,@CurrDt as UploadDatefrom     
from MCXSXTradeTemp   
  
------ CHECK FILE MOVE FOLDER  
set @path=@path+'MCXSXSuccess\'  
declare @trailingslash varchar(750)  
set @trailingslash = reverse(@path)  
if '\' = left(@trailingslash, 1)  
set @trailingslash = substring(@trailingslash, 2, len(@path) + 1)  
set @path = reverse(@trailingslash)  
declare @cmd nvarchar(4000)  
set @cmd = 'dir ' + @path  
declare @exists tinyint  
set @exists = 0  
create table #dir (output nvarchar(4000))  
insert into #dir exec master..xp_cmdshell @cmd,no_output  
if not exists (select * from #dir where output like '%' + @path)  
begin  
declare @newpath varchar(550)  
set @newpath= 'md '+ @path+'\'  
exec xp_cmdshell @newpath,no_output  
end  
declare @movestr as varchar(750)  
set @movestr='move "'+ @filepath +'" "'+@path +'"'  
exec master..xp_cmdshell @movestr,no_output  
------END CHECK FILE MOVE FOLDER  
  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('MCXSX',@mgr,@filepath,@currdt,  
'In MCXSX segment for manager '+@mgr +' '+@filename+' data is successfully importade for sauda date '+  
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','success')  
    
end    
else    
begin    
    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('MCXSX',@mgr,@filePath,@CurrDt,    
'In MCXSX segemane for manager '+@mgr +' '+@filename+' data is not available for sauda date '+    
cast(CONVERT(datetime,Convert(varchar,@CurrDt,106)) as varchar)+'at time '+convert(varchar,@CurrDt,109)+'.','User')    
--print 'y'    
end
end try    
    
begin catch    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('MCXSX',@mgr,@filePath,@CurrDt,    
'In MCXSX segment '+@filename+' file are not uploaded for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'. due to ErrorNumber: '+cast(ERROR_NUMBER() as varchar)+    
' ErrorSeverity: '+cast (ERROR_SEVERITY() as varchar)+    
' ErrorState: '+cast (ERROR_STATE() as varchar)+    
' ErrorLine: '+cast (ERROR_LINE() as varchar)+    
' ErrorMessage: '+ERROR_MESSAGE(),'System')    
end catch    
    
end---End Else bolck    
set @cnt=@cnt-1    
    
end--End while loop    
set nocount off;    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadMCXTrade
-- --------------------------------------------------
-- =============================================    
-- author: <Amit Gupta>    
-- create date: <20-Jan-2011>    
-- description: <Upload Trade File Auto Process>    
-- =============================================    
CREATE procedure usp_UploadMCXTrade    
as    
begin    
set nocount on;    
---Start declaration of variable   
declare @Path as varchar(500)   
declare @filePath as varchar(500)    
declare @sql as varchar(max)    
declare @filename as varchar(25)    
declare @mgr as varchar(25)    
declare @cnt as int    
declare @CurrDt datetime    
---End    
set @CurrDt=GETDATE()    
    
set @filename =replace(convert(varchar, @CurrDt, 103),'/','')+'.txt'    
select @cnt=COUNT(*) from tblFilePath where segment='MCX'    
while @cnt>0 ---Loop for all manger    
begin    
select @Path=filepath,@mgr=manager from tblFilePath where segment='MCX' and cnt=@cnt    
set @filePath=@Path+@filename    
--print @filePath    
truncate table tblFileStatus    
    
Insert into tblFileStatus exec master..xp_fileexist @filePath    
    
if Exists (select * from tblFileStatus where FileExists=0)    
begin    
    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('MCX',@mgr,@filePath,@CurrDt,    
'In MCX segment '+@filename+' file are not exist on specific path for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'.','User')    
    
end    
else    
begin    
    
begin try    
truncate table MCXTradeTemp    
set @sql=''    
set @sql=@sql+' bulk insert MCXTradeTemp from '    
set @sql=@sql+''''+ @filePath +''''    
set @sql=@sql+' with '    
set @sql=@sql+' ( '    
set @sql=@sql+' fieldterminator = '','','    
set @sql=@sql+' rowterminator = ''\n'''    
set @sql=@sql+' ) '    
--print (@sql)    
exec(@sql)    
    
---Checking Data inside file for same sauda date    
if exists(Select top 1 * from MCXTradeTemp where CONVERT(datetime,Convert(varchar,sauda_date,106))=    
CONVERT(datetime,Convert(varchar,@CurrDt,106)))    
begin    
delete from MCXTrade where FName=@FileName and Mgr=@Mgr    
insert into MCXTrade    
Select TradeNo,Dummy1,Dummy2,InstType,Symbol,Expiry,Dummy3,Dummy4,Dummy5,ContractDescription,    
Dummy6,OrderType1,Dummy7,ltrim(rtrim(DealerID)),Dummy8,Buy_Sell,Qty,Rate,Dummy9,ltrim(rtrim(party_code)),    
Member_ID1,Dummy10,MemberID2,Dummy11,sauda_date,OrderDateTime,OrderNo,Dummy12,    
Dummy13,DateTime,Dummy14,Segement,Dummy15,Dummy16,Dummy17,Dummy18,OrderType2,    
@mgr as Mgr ,@filename as FName,@CurrDt as UploadDatefrom     
from MCXTradeTemp   
  
------ CHECK FILE MOVE FOLDER  
set @path=@path+'MCXSuccess\'  
declare @trailingslash varchar(750)  
set @trailingslash = reverse(@path)  
if '\' = left(@trailingslash, 1)  
set @trailingslash = substring(@trailingslash, 2, len(@path) + 1)  
set @path = reverse(@trailingslash)  
declare @cmd nvarchar(4000)  
set @cmd = 'dir ' + @path  
declare @exists tinyint  
set @exists = 0  
create table #dir (output nvarchar(4000))  
insert into #dir exec master..xp_cmdshell @cmd,no_output  
if not exists (select * from #dir where output like '%' + @path)  
begin  
declare @newpath varchar(550)  
set @newpath= 'md '+ @path+'\'  
exec xp_cmdshell @newpath,no_output  
end  
declare @movestr as varchar(750)  
set @movestr='move "'+ @filepath +'" "'+@path +'"'  
exec master..xp_cmdshell @movestr,no_output  
------END CHECK FILE MOVE FOLDER  
  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('MCX',@mgr,@filepath,@currdt,  
'In MCX segment for manager '+@mgr +' '+@filename+' data is successfully importade for sauda date '+  
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','success')  
    
end    
else    
begin    
    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('MCX',@mgr,@filePath,@CurrDt,    
'In MCX segemane for manager '+@mgr +' '+@filename+' data is not available for sauda date '+    
cast(CONVERT(datetime,Convert(varchar,@CurrDt,106)) as varchar)+'at time '+convert(varchar,@CurrDt,109)+'.','User')    
--print 'y'    
end    
end try    
    
begin catch    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('MCX',@mgr,@filePath,@CurrDt,    
'In MCX segment '+@filename+' file are not uploaded for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'. due to ErrorNumber: '+cast(ERROR_NUMBER() as varchar)+    
' ErrorSeverity: '+cast (ERROR_SEVERITY() as varchar)+    
' ErrorState: '+cast (ERROR_STATE() as varchar)+    
' ErrorLine: '+cast (ERROR_LINE() as varchar)+    
' ErrorMessage: '+ERROR_MESSAGE(),'System')    
end catch    
    
end---End Else bolck    
set @cnt=@cnt-1    
    
end--End while loop    
set nocount off;    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadNSDEXTrade
-- --------------------------------------------------
-- =============================================    
-- author: <Amit Gupta>    
-- create date: <20-Jan-2011>    
-- description: <Upload Trade File Auto Process>    
-- ============================================= 
CREATE procedure usp_UploadNSDEXTrade    
as    
begin    
set nocount on;    
---Start declaration of variable    
declare @Path as varchar(500)    
declare @filePath as varchar(500)    
declare @sql as varchar(max)    
declare @filename as varchar(25)    
declare @mgr as varchar(25)    
declare @cnt as int    
declare @CurrDt datetime    
---End    
set @CurrDt=GETDATE()    
    
set @filename =replace(convert(varchar, @CurrDt, 103),'/','')+'.txt'    
select @cnt=COUNT(*) from tblFilePath where segment='NCDEX'    
while @cnt>0 ---Loop for all manger    
begin    
select @Path=filepath,@mgr=manager from tblFilePath where segment='NCDEX' and cnt=@cnt    
set @filePath=@Path+@filename    
--print @filePath    
truncate table tblFileStatus    
    
Insert into tblFileStatus exec master..xp_fileexist @filePath    
    
if Exists (select * from tblFileStatus where FileExists=0)    
begin    
    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('NCDEX',@mgr,@filePath,@CurrDt,    
'In NCDEX segment '+@filename+' file are not exist on specific path for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'.','User')    
    
end    
else    
begin    
    
begin try    
truncate table NSDEXTradeTemp    
set @sql=''    
set @sql=@sql+' bulk insert NSDEXTradeTemp from '    
set @sql=@sql+''''+ @filePath +''''    
set @sql=@sql+' with '    
set @sql=@sql+' ( '    
set @sql=@sql+' fieldterminator = '','','    
set @sql=@sql+' rowterminator = ''\n'''    
set @sql=@sql+' ) '    
--print (@sql)    
exec(@sql)    
    
---Checking Data inside file for same sauda date    
if exists(Select top 1 * from NSDEXTradeTemp where CONVERT(datetime,Convert(varchar,sauda_date,106))=    
CONVERT(datetime,Convert(varchar,@CurrDt,106)))    
begin    
delete from NSDEXTrade where FName=@FileName and Mgr=@Mgr    
insert into NSDEXTrade    
Select TradeNo,Dummy1,InstType,Symbol,Expiry,Dummy2,Dummy3,ContractDescription,
		Dummy4,OrderType1,Dummy5,ltrim(rtrim(dealerid)) as dealerid,Dummy6,Buy_Sell,Qty,Rate,Dummy7,
		ltrim(rtrim(party_code)) as party_code,MemberID,Dummy8,Dummy9,sauda_date,OrderDateTime,OrderNo,
		Dummy10,Segement,Dummy11,Dummy12,
		Dummy13,OrderType2,Dummy14,    
		@mgr as Mgr ,@filename as FName,@CurrDt as UploadDatefrom     
from NSDEXTradeTemp   
  
------ CHECK FILE MOVE FOLDER  
set @path=@path+'NCDEXSuccess\'  
declare @trailingslash varchar(750)  
set @trailingslash = reverse(@path)  
if '\' = left(@trailingslash, 1)  
set @trailingslash = substring(@trailingslash, 2, len(@path) + 1)  
set @path = reverse(@trailingslash)  
declare @cmd nvarchar(4000)  
set @cmd = 'dir ' + @path  
declare @exists tinyint  
set @exists = 0  
create table #dir (output nvarchar(4000))  
insert into #dir exec master..xp_cmdshell @cmd,no_output  
if not exists (select * from #dir where output like '%' + @path)  
begin  
declare @newpath varchar(550)  
set @newpath= 'md '+ @path+'\'  
exec xp_cmdshell @newpath,no_output  
end  
declare @movestr as varchar(750)  
set @movestr='move "'+ @filepath +'" "'+@path +'"'  
exec master..xp_cmdshell @movestr,no_output  
------END CHECK FILE MOVE FOLDER  
  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('NCDEX',@mgr,@filepath,@currdt,  
'In NCDEX segment for manager '+@mgr +' '+@filename+' data is successfully importade for sauda date '+  
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','success')  
    
end    
else    
begin    
    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('NCDEX',@mgr,@filePath,@CurrDt,    
'In NCDEX segemane for manager '+@mgr +' '+@filename+' data is not available for sauda date '+    
cast(CONVERT(datetime,Convert(varchar,@CurrDt,106)) as varchar)+'at time '+convert(varchar,@CurrDt,109)+'.','User')    
--print 'y'    
end   
end try    
    
begin catch    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('NCDEX',@mgr,@filePath,@CurrDt,    
'In NCDEX segment '+@filename+' file are not uploaded for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'. due to ErrorNumber: '+cast(ERROR_NUMBER() as varchar)+    
' ErrorSeverity: '+cast (ERROR_SEVERITY() as varchar)+    
' ErrorState: '+cast (ERROR_STATE() as varchar)+    
' ErrorLine: '+cast (ERROR_LINE() as varchar)+    
' ErrorMessage: '+ERROR_MESSAGE(),'System')    
end catch    
    
end---End Else bolck    
set @cnt=@cnt-1    
    
end--End while loop    
set nocount off;    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_uploadNSEFOTrade
-- --------------------------------------------------
-- =============================================  
-- author: <Amit Gupta>  
-- create date: <20-Jan-2011>  
-- description: <Upload Trade File Auto Process>  
-- =============================================  
CREATE procedure usp_uploadNSEFOTrade  
as  
begin  
set nocount on;  
---Start declaration of variable  
declare @Path as varchar(500)
declare @filePath as varchar(500)  
declare @sql as varchar(max)  
declare @filename as varchar(25)  
declare @mgr as varchar(25)  
declare @cnt as int  
declare @CurrDt datetime  
---End  
set @CurrDt=GETDATE()  
  
set @filename =replace(convert(varchar, getdate(), 103),'/','')+'.txt'  
select @cnt=COUNT(*) from tblFilePath where segment='NSEFO'  
while @cnt>0 ---Loop for all manger  
begin  
select @Path=filepath,@mgr=manager from tblFilePath where segment='NSEFO' and cnt=@cnt  
set @filePath=@Path+@filename  
  
truncate table tblFileStatus  
Insert into tblFileStatus exec master..xp_fileexist @filePath  
if Exists (select * from tblFileStatus where FileExists=0)  
begin  
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)  
values ('NSEFO',@mgr,@filePath,@CurrDt,  
'In NSEFO segment '+@filename+' file are not exist on specific path for manager '  
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'.','User')  
end  
else  
begin  
begin try  
truncate table NSEFOTradeTemp  
set @sql=''  
set @sql=@sql+' bulk insert NSEFOTradeTemp from '  
set @sql=@sql+''''+ @filePath +''''  
set @sql=@sql+' with '  
set @sql=@sql+' ( '  
set @sql=@sql+' fieldterminator = '','','  
set @sql=@sql+' rowterminator = ''\n'''  
set @sql=@sql+' ) '  
--print (@sql)  
exec(@sql)  
  
---Checking Data inside file for same sauda date  
if exists(Select top 1 * from NSEFOTradeTemp where CONVERT(datetime,Convert(varchar,sauda_date,106))=CONVERT(datetime,Convert(varchar,@CurrDt,106)))  
begin 
delete from NSEFOTrade where FName=@filename and Mgr=@mgr  
insert into NSEFOTrade  
Select TradeNo,Dummy1,InstType,Symbol,ExpiryDate,StrikePrice,OptionType,ContractDescription,  
Dummy2,OrderType,Dummy3,ltrim(rtrim(DealerID)) as DealerID,Dummy4,Buy_Sell,Qty,Rate,  
Dummy5,ltrim(rtrim(party_code)) as party_code,MemberID,  
Dummy6,Dummy7,sauda_date,OrderDateTime,OrderNo,Dummy8,InstrumentType,  
ltrim(rtrim(party_code2))as party_code2,  
ltrim(rtrim(party_code3)) as party_code3,Dummy9,sauda_date1,OrderDateTime1,OrderType1,  
@mgr as Mgr ,@filename as FName,@CurrDt as UploadDatefrom from NSEFOTradeTemp 

------ CHECK FILE MOVE FOLDER
set @path=@path+'NSEFOSuccess\'
declare @trailingslash varchar(750)
set @trailingslash = reverse(@path)
if '\' = left(@trailingslash, 1)
set @trailingslash = substring(@trailingslash, 2, len(@path) + 1)
set @path = reverse(@trailingslash)
declare @cmd nvarchar(4000)
set @cmd = 'dir ' + @path
declare @exists tinyint
set @exists = 0
create table #dir (output nvarchar(4000))
insert into #dir exec master..xp_cmdshell @cmd,no_output
if not exists (select * from #dir where output like '%' + @path)
begin
declare @newpath varchar(550)
set @newpath= 'md '+ @path+'\'
exec xp_cmdshell @newpath,no_output
end
declare @movestr as varchar(750)
set @movestr='move "'+ @filepath +'" "'+@path +'"'
exec master..xp_cmdshell @movestr,no_output
------END CHECK FILE MOVE FOLDER

insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)
values ('NSEFO',@mgr,@filepath,@currdt,
'In NSEFO segment for manager '+@mgr +' '+@filename+' data is successfully importade for sauda date '+
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','success')
 
end  
else  
begin  
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)  
values ('NSEFO',@mgr,@filePath,@CurrDt,  
'In NSEFO segment for manager '+@mgr +' '+@filename+' data is not available for sauda date '+  
cast(CONVERT(datetime,Convert(varchar,@CurrDt,106)) as varchar)+'at time '+convert(varchar,@CurrDt,109)+'.','User')  
end 
end try  
begin catch  
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)  
values ('NSEFO',@mgr,@filePath,@CurrDt,  
'In NSEFO segment '+@filename+' file are not uploaded for manager '  
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'. due to ErrorNumber: '+cast(ERROR_NUMBER() as varchar)+  
' ErrorSeverity: '+cast (ERROR_SEVERITY() as varchar)+  
' ErrorState: '+cast (ERROR_STATE() as varchar)+  
' ErrorLine: '+cast (ERROR_LINE() as varchar)+  
' ErrorMessage: '+ERROR_MESSAGE(),'System')  
end catch  
end---End Else bolck  
set @cnt=@cnt-1  
end--End while loop  
set nocount off;  
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_uploadNSETrade
-- --------------------------------------------------
-- =============================================    
-- author: <Amit Gupta>    
-- create date: <20-Jan-2011>    
-- description: <Upload Trade File Auto Process>    
-- =============================================    
CREATE procedure usp_uploadNSETrade    
as    
begin    
set nocount on;    
---Start declaration of variable    
declare @path as varchar(500)  
declare @filePath as varchar(500)   
declare @sql as varchar(max)    
declare @fileName as varchar(25)    
declare @mgr as varchar(25)    
declare @cnt as int    
declare @CurrDt datetime    
---End    
set @CurrDt=GETDATE()    
    
set @fileName =replace(convert(varchar, getdate(), 103),'/','')+'.txt'    
select @cnt=COUNT(*) from tblFilePath where segment='NSE'    
    
while @cnt>0 ---Loop for all manger    
begin    
select @path=filepath,@mgr=manager from tblFilePath where segment='NSE' and cnt=@cnt    
set @filePath=@path+@fileName    
    
truncate table tblFileStatus    
Insert into tblFileStatus exec master..xp_fileexist @filePath    
if Exists (select * from tblFileStatus where FileExists=0)    
begin    
 insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
 values ('NSE',@mgr,@filePath,@CurrDt,    
 'In NSE segment '+@fileName+' file are not exist on specific path for manager '    
 +@mgr +', at time '+convert(varchar,@CurrDt,109)+'.','User')    
end    
else    
begin    
begin try    
truncate table NSETradeTemp    
set @sql=''    
set @sql=@sql+' bulk insert NSETradeTemp from '    
set @sql=@sql+''''+ @filePath +''''    
set @sql=@sql+' with '    
set @sql=@sql+' ( '    
set @sql=@sql+' fieldterminator = '','','    
set @sql=@sql+' rowterminator = ''\n'''    
set @sql=@sql+' ) '    
--print (@sql)    
exec(@sql)    
if exists(Select top 1 * from NSETradeTemp where CONVERT(datetime,Convert(varchar,sauda_date,106))=CONVERT(datetime,Convert(varchar,@CurrDt,106)))    
begin    
delete from NSETRADE where FName=@fileName and Mgr=@mgr    
insert into NSETRADE    
Select TradeNo,Dummy1,Symbol,Series,ScripName,Dummy2,Dummy3,Dummy5,ltrim(rtrim(DealerID)) as DealerID,    
Dummy6,Buy_Sell,Qty,Rate,Dummy7,ltrim(rtrim(party_code)) as party_code,MemberID,MarketType,Dummy8,    
Dummy9,sauda_date,OrderDateTime,OrderNumber,Dummy10,Segement,    
ltrim(rtrim(party_code2)) as party_code2,ltrim(rtrim(party_code3)) as party_code3,Dummy11,    
ProductType,sauda_date1,    
OrderTime,@Mgr as Mgr ,@fileName as FName,@CurrDt as UploadDatefrom from NSETradeTemp   
  
------ CHECK FILE MOVE FOLDER  
set @path=@path+'NSESuccess\'  
declare @trailingslash varchar(750)  
set @trailingslash = reverse(@path)  
if '\' = left(@trailingslash, 1)  
set @trailingslash = substring(@trailingslash, 2, len(@path) + 1)  
set @path = reverse(@trailingslash)  
declare @cmd nvarchar(4000)  
set @cmd = 'dir ' + @path  
declare @exists tinyint  
set @exists = 0  
create table #dir (output nvarchar(4000))  
insert into #dir exec master..xp_cmdshell @cmd,no_output  
if not exists (select * from #dir where output like '%' + @path)  
begin  
declare @newpath varchar(550)  
set @newpath= 'md '+ @path+'\'  
exec xp_cmdshell @newpath,no_output  
end  
declare @movestr as varchar(750)  
set @movestr='move "'+ @filePath +'" "'+@path +'"'  
exec master..xp_cmdshell @movestr,no_output  
------END CHECK FILE MOVE FOLDER  
  
insert into tradefilelog (segment,manager,filepath,uploaddt,errordesc,errortype)  
values ('NSE',@mgr,@filePath,@currdt,  
'in NSE segment for manager '+@mgr +' '+@fileName+' data is successfully importade for sauda date '+  
cast(convert(datetime,convert(varchar,@currdt,106)) as varchar)+'at time '+convert(varchar,@currdt,109)+'.','Success')  
end  
else    
  
begin    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('NSE',@mgr,@filePath,@CurrDt,    
'In NSE segment for manager '+@mgr +' '+@fileName+' data is not available for sauda date '+    
cast(CONVERT(datetime,Convert(varchar,@CurrDt,106)) as varchar)+'at time '+convert(varchar,@CurrDt,109)+'.','User')    
--print 'y'    
end   
  
end try    
begin catch    
insert into TradeFileLog (segment,manager,filepath,uploadDt,ErrorDesc,ErrorType)    
values ('NSE',@mgr,@filePath,@CurrDt,    
'In NSE segment '+@fileName+' file are not uploaded for manager '    
+@mgr +', at time '+convert(varchar,@CurrDt,109)+'. due to ErrorNumber: '+cast(ERROR_NUMBER() as varchar)+    
' ErrorSeverity: '+cast (ERROR_SEVERITY() as varchar)+    
' ErrorState: '+cast (ERROR_STATE() as varchar)+    
' ErrorLine: '+cast (ERROR_LINE() as varchar)+    
' ErrorMessage: '+ERROR_MESSAGE(),'System')    
end catch   
  
end    
set @cnt=@cnt-1    
end--End while loop    
set nocount oFF;    
    
end

GO

-- --------------------------------------------------
-- TABLE dbo.BSETrade
-- --------------------------------------------------
CREATE TABLE [dbo].[BSETrade]
(
    [ScripCd] VARCHAR(50) NULL,
    [ScripName] VARCHAR(100) NULL,
    [TradeNo] VARCHAR(30) NULL,
    [Rate] MONEY NULL,
    [Qty] INT NULL,
    [Dummy1] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(50) NULL,
    [TradeTime] DATETIME NULL,
    [Sauda_Date] DATETIME NULL,
    [DealerID] VARCHAR(20) NULL,
    [Buy_Sell] VARCHAR(10) NULL,
    [Dummy3] VARCHAR(50) NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Pro_Client] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [party_code2] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(50) NULL,
    [ISINNO] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [SettNo] VARCHAR(50) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime1] DATETIME NULL,
    [OrderTime] VARCHAR(50) NULL,
    [Dummy5] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL,
    [Mgr] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSETrade_R
-- --------------------------------------------------
CREATE TABLE [dbo].[BSETrade_R]
(
    [ScripCd] VARCHAR(20) NULL,
    [ScripName] VARCHAR(20) NULL,
    [TradeNo] VARCHAR(20) NULL,
    [Rate] MONEY NULL,
    [Qty] INT NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [TradeTime] DATETIME NULL,
    [Sauda_Date] DATETIME NULL,
    [DealerID] VARCHAR(20) NULL,
    [Buy_Sell] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Pro_Client] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [party_code2] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [ISINNO] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [SettNo] VARCHAR(50) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime1] VARCHAR(20) NULL,
    [OrderTime] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSETRADESNew
-- --------------------------------------------------
CREATE TABLE [dbo].[BSETRADESNew]
(
    [Column 0] NVARCHAR(50) NULL,
    [Column 1] NVARCHAR(50) NULL,
    [Column 2] NVARCHAR(50) NULL,
    [Column 3] NVARCHAR(50) NULL,
    [Column 4] NVARCHAR(50) NULL,
    [Column 5] NVARCHAR(50) NULL,
    [Column 6] NVARCHAR(50) NULL,
    [Column 7] NVARCHAR(50) NULL,
    [Column 8] NVARCHAR(50) NULL,
    [Column 9] NVARCHAR(50) NULL,
    [Column 10] NVARCHAR(50) NULL,
    [Column 11] NVARCHAR(50) NULL,
    [Column 12] NVARCHAR(50) NULL,
    [Column 13] NVARCHAR(50) NULL,
    [Column 14] NVARCHAR(50) NULL,
    [Column 15] NVARCHAR(50) NULL,
    [Column 16] NVARCHAR(50) NULL,
    [Column 17] NVARCHAR(50) NULL,
    [Column 18] NVARCHAR(50) NULL,
    [Column 19] NVARCHAR(50) NULL,
    [Column 20] NVARCHAR(50) NULL,
    [Column 21] NVARCHAR(50) NULL,
    [Column 22] NVARCHAR(50) NULL,
    [Column 23] NVARCHAR(50) NULL,
    [Column 24] NVARCHAR(50) NULL,
    [Column 25] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSETRADESNEW1
-- --------------------------------------------------
CREATE TABLE [dbo].[BSETRADESNEW1]
(
    [Column 0] NVARCHAR(50) NULL,
    [Column 1] NVARCHAR(50) NULL,
    [Column 2] NVARCHAR(50) NULL,
    [Column 3] NVARCHAR(50) NULL,
    [Column 4] NVARCHAR(50) NULL,
    [Column 5] NVARCHAR(50) NULL,
    [Column 6] NVARCHAR(50) NULL,
    [Column 7] NVARCHAR(50) NULL,
    [Column 8] NVARCHAR(50) NULL,
    [Column 9] NVARCHAR(50) NULL,
    [Column 10] NVARCHAR(50) NULL,
    [Column 11] NVARCHAR(50) NULL,
    [Column 12] NVARCHAR(50) NULL,
    [Column 13] NVARCHAR(50) NULL,
    [Column 14] NVARCHAR(50) NULL,
    [Column 15] NVARCHAR(50) NULL,
    [Column 16] NVARCHAR(50) NULL,
    [Column 17] NVARCHAR(50) NULL,
    [Column 18] NVARCHAR(50) NULL,
    [Column 19] NVARCHAR(50) NULL,
    [Column 20] NVARCHAR(50) NULL,
    [Column 21] NVARCHAR(50) NULL,
    [Column 22] NVARCHAR(50) NULL,
    [Column 23] NVARCHAR(50) NULL,
    [Column 24] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSETradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[BSETradeTemp]
(
    [ScripCd] VARCHAR(75) NULL,
    [ScripName] VARCHAR(75) NULL,
    [TradeNo] VARCHAR(75) NULL,
    [Rate] MONEY NULL,
    [Qty] INT NULL,
    [Dummy1] VARCHAR(75) NULL,
    [Dummy2] VARCHAR(75) NULL,
    [TradeTime] DATETIME NULL,
    [Sauda_Date] DATETIME NULL,
    [DealerID] VARCHAR(75) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Dummy3] VARCHAR(75) NULL,
    [OrderNo] VARCHAR(75) NULL,
    [Pro_Client] VARCHAR(75) NULL,
    [Segement] VARCHAR(75) NULL,
    [party_code] VARCHAR(75) NULL,
    [party_code2] VARCHAR(75) NULL,
    [Dummy4] VARCHAR(75) NULL,
    [ISINNO] VARCHAR(75) NULL,
    [Series] VARCHAR(75) NULL,
    [SettNo] VARCHAR(50) NULL,
    [ProductType] VARCHAR(75) NULL,
    [TradeTime1] DATETIME NULL,
    [OrderTime] DATETIME NULL,
    [Dummy5] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EBrokeOnlineTo
-- --------------------------------------------------
CREATE TABLE [dbo].[EBrokeOnlineTo]
(
    [sauda_date] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [OnlineTO] MONEY NULL,
    [OnlineBrokerage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EbrokOfflineTOTerminal
-- --------------------------------------------------
CREATE TABLE [dbo].[EbrokOfflineTOTerminal]
(
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(20) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] MONEY NULL,
    [TerminalId] INT NOT NULL,
    [Net_Brok] MONEY NULL DEFAULT ((0)),
    [NetTurnOver] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.EbrokOfflineTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[EbrokOfflineTrade]
(
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(20) NULL,
    [Total_Brok] MONEY NULL,
    [Turnover] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Err_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[Err_Log]
(
    [Err_url] VARCHAR(100) NULL,
    [Err_stkTrace] VARCHAR(8000) NULL,
    [Err_line] VARCHAR(20) NULL,
    [Err_date] VARCHAR(50) NULL,
    [Err_App] VARCHAR(50) NULL,
    [Dev_name] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX_TradesNew
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX_TradesNew]
(
    [Column 0] VARCHAR(50) NULL,
    [Column 1] VARCHAR(50) NULL,
    [Column 2] VARCHAR(50) NULL,
    [Column 3] VARCHAR(50) NULL,
    [Column 4] VARCHAR(50) NULL,
    [Column 5] VARCHAR(50) NULL,
    [Column 6] VARCHAR(50) NULL,
    [Column 7] VARCHAR(50) NULL,
    [Column 8] VARCHAR(50) NULL,
    [Column 9] VARCHAR(50) NULL,
    [Column 10] VARCHAR(50) NULL,
    [Column 11] VARCHAR(50) NULL,
    [Column 12] VARCHAR(50) NULL,
    [Column 13] VARCHAR(50) NULL,
    [Column 14] VARCHAR(50) NULL,
    [Column 15] VARCHAR(50) NULL,
    [Column 16] VARCHAR(50) NULL,
    [Column 17] VARCHAR(50) NULL,
    [Column 18] VARCHAR(50) NULL,
    [Column 19] VARCHAR(50) NULL,
    [Column 20] VARCHAR(50) NULL,
    [Column 21] VARCHAR(50) NULL,
    [Column 22] VARCHAR(50) NULL,
    [Column 23] VARCHAR(50) NULL,
    [Column 24] VARCHAR(50) NULL,
    [Column 25] VARCHAR(50) NULL,
    [Column 26] VARCHAR(50) NULL,
    [Column 27] VARCHAR(50) NULL,
    [Column 28] VARCHAR(50) NULL,
    [Column 29] VARCHAR(50) NULL,
    [Column 30] VARCHAR(50) NULL,
    [Column 31] VARCHAR(50) NULL,
    [Column 32] VARCHAR(50) NULL,
    [Column 33] VARCHAR(50) NULL,
    [Column 34] VARCHAR(50) NULL,
    [Column 35] VARCHAR(50) NULL,
    [Column 36] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXSXTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXSXTrade]
(
    [TradeNo] VARCHAR(30) NULL,
    [Dummy1] VARCHAR(30) NULL,
    [Dummy2] VARCHAR(30) NULL,
    [InstType] VARCHAR(30) NULL,
    [Symbol] VARCHAR(30) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(30) NULL,
    [Dummy4] VARCHAR(30) NULL,
    [Dummy5] VARCHAR(30) NULL,
    [Symbol1] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(30) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(30) NULL,
    [DealerID] VARCHAR(30) NULL,
    [Dummy8] VARCHAR(30) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(30) NULL,
    [party_code] VARCHAR(30) NULL,
    [MemberID1] VARCHAR(30) NULL,
    [Dummy10] VARCHAR(30) NULL,
    [MemberID2] VARCHAR(30) NULL,
    [Dummy11] VARCHAR(30) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(30) NULL,
    [Dummy12] VARCHAR(30) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [sauda_date1] DATETIME NULL,
    [Dummy14] VARCHAR(30) NULL,
    [Dummy15] VARCHAR(30) NULL,
    [Dummy16] VARCHAR(30) NULL,
    [OrderType2] VARCHAR(30) NULL,
    [Dummy17] VARCHAR(30) NULL,
    [Dummy18] VARCHAR(30) NULL,
    [Dummy19] VARCHAR(30) NULL,
    [Dummy20] VARCHAR(30) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXSXTradesNew
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXSXTradesNew]
(
    [Column 0] VARCHAR(50) NULL,
    [Column 1] VARCHAR(50) NULL,
    [Column 2] VARCHAR(50) NULL,
    [Column 3] VARCHAR(50) NULL,
    [Column 4] VARCHAR(50) NULL,
    [Column 5] VARCHAR(50) NULL,
    [Column 6] VARCHAR(50) NULL,
    [Column 7] VARCHAR(50) NULL,
    [Column 8] VARCHAR(50) NULL,
    [Column 9] VARCHAR(50) NULL,
    [Column 10] VARCHAR(50) NULL,
    [Column 11] VARCHAR(50) NULL,
    [Column 12] VARCHAR(50) NULL,
    [Column 13] VARCHAR(50) NULL,
    [Column 14] VARCHAR(50) NULL,
    [Column 15] VARCHAR(50) NULL,
    [Column 16] VARCHAR(50) NULL,
    [Column 17] VARCHAR(50) NULL,
    [Column 18] VARCHAR(50) NULL,
    [Column 19] VARCHAR(50) NULL,
    [Column 20] VARCHAR(50) NULL,
    [Column 21] VARCHAR(50) NULL,
    [Column 22] VARCHAR(50) NULL,
    [Column 23] VARCHAR(50) NULL,
    [Column 24] VARCHAR(50) NULL,
    [Column 25] VARCHAR(50) NULL,
    [Column 26] VARCHAR(50) NULL,
    [Column 27] VARCHAR(50) NULL,
    [Column 28] VARCHAR(50) NULL,
    [Column 29] VARCHAR(50) NULL,
    [Column 30] VARCHAR(50) NULL,
    [Column 31] VARCHAR(50) NULL,
    [Column 32] VARCHAR(50) NULL,
    [Column 33] VARCHAR(50) NULL,
    [Column 34] VARCHAR(50) NULL,
    [Column 35] VARCHAR(50) NULL,
    [Column 36] VARCHAR(50) NULL,
    [Column 37] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXSXTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXSXTradeTemp]
(
    [TradeNo] VARCHAR(50) NULL,
    [Dummy1] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(50) NULL,
    [InstType] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(50) NULL,
    [Dummy4] VARCHAR(50) NULL,
    [Dummy5] VARCHAR(50) NULL,
    [Symbol1] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(50) NULL,
    [OrderType1] VARCHAR(50) NULL,
    [Dummy7] VARCHAR(50) NULL,
    [DealerID] VARCHAR(50) NULL,
    [Dummy8] VARCHAR(50) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [MemberID1] VARCHAR(50) NULL,
    [Dummy10] VARCHAR(50) NULL,
    [MemberID2] VARCHAR(50) NULL,
    [Dummy11] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(50) NULL,
    [Dummy12] VARCHAR(50) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [sauda_date1] DATETIME NULL,
    [Dummy14] VARCHAR(50) NULL,
    [Dummy15] VARCHAR(50) NULL,
    [Dummy16] VARCHAR(50) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy17] VARCHAR(50) NULL,
    [Dummy18] VARCHAR(50) NULL,
    [Dummy19] VARCHAR(50) NULL,
    [Dummy20] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXTrade]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [Member_ID1] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [MemberID2] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy12] VARCHAR(20) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [DateTime] DATETIME NULL,
    [Dummy14] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy15] VARCHAR(20) NULL,
    [Dummy16] VARCHAR(20) NULL,
    [Dummy17] VARCHAR(20) NULL,
    [Dummy18] VARCHAR(20) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCXTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[MCXTradeTemp]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [Member_ID1] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [MemberID2] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy12] VARCHAR(20) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [DateTime] DATETIME NULL,
    [Dummy14] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy15] VARCHAR(20) NULL,
    [Dummy16] VARCHAR(20) NULL,
    [Dummy17] VARCHAR(20) NULL,
    [Dummy18] VARCHAR(20) NULL,
    [OrderType2] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_to
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_to]
(
    [Company] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [Dealer] VARCHAR(10) NULL,
    [Region] VARCHAR(10) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [B2C] CHAR(1) NULL,
    [Ebrok_Cli] CHAR(1) NULL,
    [No_Of_trade] MONEY NULL,
    [Terminal_id] VARCHAR(10) NULL,
    [Product] VARCHAR(10) NULL,
    [Turnover] MONEY NULL,
    [brokerage] MONEY NULL,
    [TO_Trd_Fut] MONEY NULL,
    [TO_Del_Opt] MONEY NULL,
    [BK_Trd_Fut] MONEY NULL,
    [BK_Del_Opt] MONEY NULL,
    [Net] MONEY NULL,
    [Intra_net] MONEY NULL,
    [Del_net] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_to_bak
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_to_bak]
(
    [Company] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [Dealer] VARCHAR(10) NULL,
    [Region] VARCHAR(10) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [Terminal_id] VARCHAR(10) NULL,
    [Product] VARCHAR(10) NULL,
    [Turnover] MONEY NULL,
    [brokerage] MONEY NULL,
    [TO_Trd_Fut] MONEY NULL,
    [TO_Del_Opt] MONEY NULL,
    [BK_Trd_Fut] MONEY NULL,
    [BK_Del_Opt] MONEY NULL,
    [dummy1] VARCHAR(10) NULL,
    [dummy2] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDXTRADES_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDXTRADES_NEW]
(
    [Column 0] VARCHAR(50) NULL,
    [Column 1] VARCHAR(50) NULL,
    [Column 2] VARCHAR(50) NULL,
    [Column 3] VARCHAR(50) NULL,
    [Column 4] VARCHAR(50) NULL,
    [Column 5] VARCHAR(50) NULL,
    [Column 6] VARCHAR(50) NULL,
    [Column 7] VARCHAR(50) NULL,
    [Column 8] VARCHAR(50) NULL,
    [Column 9] VARCHAR(50) NULL,
    [Column 10] VARCHAR(50) NULL,
    [Column 11] VARCHAR(50) NULL,
    [Column 12] VARCHAR(50) NULL,
    [Column 13] VARCHAR(50) NULL,
    [Column 14] VARCHAR(50) NULL,
    [Column 15] VARCHAR(50) NULL,
    [Column 16] VARCHAR(50) NULL,
    [Column 17] VARCHAR(50) NULL,
    [Column 18] VARCHAR(50) NULL,
    [Column 19] VARCHAR(50) NULL,
    [Column 20] VARCHAR(50) NULL,
    [Column 21] VARCHAR(50) NULL,
    [Column 22] VARCHAR(50) NULL,
    [Column 23] VARCHAR(50) NULL,
    [Column 24] VARCHAR(50) NULL,
    [Column 25] VARCHAR(50) NULL,
    [Column 26] VARCHAR(50) NULL,
    [Column 27] VARCHAR(50) NULL,
    [Column 28] VARCHAR(50) NULL,
    [Column 29] VARCHAR(50) NULL,
    [Column 30] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSDEXTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[NSDEXTrade]
(
    [TradeNo] VARCHAR(30) NULL,
    [Dummy1] VARCHAR(30) NULL,
    [InstType] VARCHAR(30) NULL,
    [Symbol] VARCHAR(30) NULL,
    [Expiry] DATETIME NULL,
    [Dummy2] VARCHAR(30) NULL,
    [Dummy3] VARCHAR(30) NULL,
    [ContractDescription] VARCHAR(30) NULL,
    [Dummy4] VARCHAR(30) NULL,
    [OrderType1] VARCHAR(50) NULL,
    [Dummy5] VARCHAR(30) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(30) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(30) NULL,
    [party_code] VARCHAR(30) NULL,
    [MemberID] VARCHAR(30) NULL,
    [Dummy8] VARCHAR(30) NULL,
    [Dummy9] VARCHAR(30) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(30) NULL,
    [Dummy10] VARCHAR(30) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(30) NULL,
    [Dummy12] VARCHAR(30) NULL,
    [Dummy13] VARCHAR(30) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy14] VARCHAR(30) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSDEXTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[NSDEXTradeTemp]
(
    [TradeNo] VARCHAR(50) NULL,
    [Dummy1] VARCHAR(50) NULL,
    [InstType] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry] DATETIME NULL,
    [Dummy2] VARCHAR(50) NULL,
    [Dummy3] VARCHAR(50) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy4] VARCHAR(50) NULL,
    [OrderType1] VARCHAR(50) NULL,
    [Dummy5] VARCHAR(50) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(50) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [MemberID] VARCHAR(50) NULL,
    [Dummy8] VARCHAR(50) NULL,
    [Dummy9] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(50) NULL,
    [Dummy10] VARCHAR(50) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(50) NULL,
    [Dummy12] VARCHAR(50) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy14] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFOTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFOTrade]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [ExpiryDate] VARCHAR(20) NULL,
    [StrikePrice] VARCHAR(20) NULL,
    [OptionType] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [OrderType] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy5] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [InstrumentType] VARCHAR(20) NULL,
    [party_code2] VARCHAR(20) NULL,
    [party_code3] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [sauda_date1] DATETIME NULL,
    [OrderDateTime1] DATETIME NULL,
    [OrderType1] VARCHAR(20) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFOTrade_R
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFOTrade_R]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [ExpiryDate] VARCHAR(20) NULL,
    [StrikePrice] VARCHAR(20) NULL,
    [OptionType] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [OrderType] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy5] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [InstrumentType] VARCHAR(20) NULL,
    [party_code2] VARCHAR(20) NULL,
    [party_code3] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [sauda_date1] DATETIME NULL,
    [OrderDateTime1] DATETIME NULL,
    [OrderType1] VARCHAR(20) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFOTradesNEW
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFOTradesNEW]
(
    [Column 0] NVARCHAR(50) NULL,
    [Column 1] NVARCHAR(50) NULL,
    [Column 2] NVARCHAR(50) NULL,
    [Column 3] NVARCHAR(50) NULL,
    [Column 4] NVARCHAR(50) NULL,
    [Column 5] NVARCHAR(50) NULL,
    [Column 6] NVARCHAR(50) NULL,
    [Column 7] NVARCHAR(50) NULL,
    [Column 8] NVARCHAR(50) NULL,
    [Column 9] NVARCHAR(50) NULL,
    [Column 10] NVARCHAR(50) NULL,
    [Column 11] NVARCHAR(50) NULL,
    [Column 12] NVARCHAR(50) NULL,
    [Column 13] NVARCHAR(50) NULL,
    [Column 14] NVARCHAR(50) NULL,
    [Column 15] NVARCHAR(50) NULL,
    [Column 16] NVARCHAR(50) NULL,
    [Column 17] NVARCHAR(50) NULL,
    [Column 18] NVARCHAR(50) NULL,
    [Column 19] NVARCHAR(50) NULL,
    [Column 20] NVARCHAR(50) NULL,
    [Column 21] NVARCHAR(50) NULL,
    [Column 22] NVARCHAR(50) NULL,
    [Column 23] NVARCHAR(50) NULL,
    [Column 24] NVARCHAR(50) NULL,
    [Column 25] NVARCHAR(50) NULL,
    [Column 26] NVARCHAR(50) NULL,
    [Column 27] NVARCHAR(50) NULL,
    [Column 28] NVARCHAR(50) NULL,
    [Column 29] NVARCHAR(50) NULL,
    [Column 30] NVARCHAR(50) NULL,
    [Column 31] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFOTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFOTradeTemp]
(
    [TradeNo] VARCHAR(75) NULL,
    [Dummy1] VARCHAR(75) NULL,
    [InstType] VARCHAR(75) NULL,
    [Symbol] VARCHAR(75) NULL,
    [ExpiryDate] VARCHAR(75) NULL,
    [StrikePrice] VARCHAR(75) NULL,
    [OptionType] VARCHAR(75) NULL,
    [ContractDescription] VARCHAR(75) NULL,
    [Dummy2] VARCHAR(75) NULL,
    [OrderType] VARCHAR(75) NULL,
    [Dummy3] VARCHAR(75) NULL,
    [DealerID] VARCHAR(75) NULL,
    [Dummy4] VARCHAR(75) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy5] VARCHAR(75) NULL,
    [party_code] VARCHAR(75) NULL,
    [MemberID] VARCHAR(75) NULL,
    [Dummy6] VARCHAR(75) NULL,
    [Dummy7] VARCHAR(75) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(75) NULL,
    [Dummy8] VARCHAR(75) NULL,
    [InstrumentType] VARCHAR(75) NULL,
    [party_code2] VARCHAR(75) NULL,
    [party_code3] VARCHAR(75) NULL,
    [Dummy9] VARCHAR(75) NULL,
    [sauda_date1] DATETIME NULL,
    [OrderDateTime1] DATETIME NULL,
    [OrderType1] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSETrade
-- --------------------------------------------------
CREATE TABLE [dbo].[NSETrade]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [ScripName] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [MarketType] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNumber] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [party_code2] VARCHAR(20) NULL,
    [party_code3] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [ProductType] VARCHAR(20) NULL,
    [sauda_date1] DATETIME NULL,
    [OrderTime] DATETIME NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSETrade_R
-- --------------------------------------------------
CREATE TABLE [dbo].[NSETrade_R]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [ScripName] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [MarketType] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNumber] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [party_code2] VARCHAR(20) NULL,
    [party_code3] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [ProductType] VARCHAR(20) NULL,
    [sauda_date1] DATETIME NULL,
    [OrderTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSETRADENEW
-- --------------------------------------------------
CREATE TABLE [dbo].[NSETRADENEW]
(
    [Column 0] NVARCHAR(50) NULL,
    [Column 1] NVARCHAR(50) NULL,
    [Column 2] NVARCHAR(50) NULL,
    [Column 3] NVARCHAR(50) NULL,
    [Column 4] NVARCHAR(50) NULL,
    [Column 5] NVARCHAR(50) NULL,
    [Column 6] NVARCHAR(50) NULL,
    [Column 7] NVARCHAR(50) NULL,
    [Column 8] NVARCHAR(50) NULL,
    [Column 9] NVARCHAR(50) NULL,
    [Column 10] NVARCHAR(50) NULL,
    [Column 11] NVARCHAR(50) NULL,
    [Column 12] NVARCHAR(50) NULL,
    [Column 13] NVARCHAR(50) NULL,
    [Column 14] NVARCHAR(50) NULL,
    [Column 15] NVARCHAR(50) NULL,
    [Column 16] NVARCHAR(50) NULL,
    [Column 17] NVARCHAR(50) NULL,
    [Column 18] NVARCHAR(50) NULL,
    [Column 19] NVARCHAR(50) NULL,
    [Column 20] NVARCHAR(50) NULL,
    [Column 21] NVARCHAR(50) NULL,
    [Column 22] NVARCHAR(50) NULL,
    [Column 23] NVARCHAR(50) NULL,
    [Column 24] NVARCHAR(50) NULL,
    [Column 25] NVARCHAR(50) NULL,
    [Column 26] NVARCHAR(50) NULL,
    [Column 27] NVARCHAR(50) NULL,
    [Column 28] NVARCHAR(50) NULL,
    [Column 29] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSETradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[NSETradeTemp]
(
    [TradeNo] VARCHAR(75) NULL,
    [Dummy1] VARCHAR(75) NULL,
    [Symbol] VARCHAR(75) NULL,
    [Series] VARCHAR(75) NULL,
    [ScripName] VARCHAR(75) NULL,
    [Dummy2] VARCHAR(75) NULL,
    [Dummy3] VARCHAR(75) NULL,
    [Dummy5] VARCHAR(75) NULL,
    [DealerID] VARCHAR(75) NULL,
    [Dummy6] VARCHAR(75) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(75) NULL,
    [party_code] VARCHAR(75) NULL,
    [MemberID] VARCHAR(75) NULL,
    [MarketType] VARCHAR(75) NULL,
    [Dummy8] VARCHAR(75) NULL,
    [Dummy9] VARCHAR(75) NULL,
    [sauda_date] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNumber] VARCHAR(75) NULL,
    [Dummy10] VARCHAR(75) NULL,
    [Segement] VARCHAR(75) NULL,
    [party_code2] VARCHAR(75) NULL,
    [party_code3] VARCHAR(75) NULL,
    [Dummy11] VARCHAR(75) NULL,
    [ProductType] VARCHAR(75) NULL,
    [sauda_date1] DATETIME NULL,
    [OrderTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ebrok_detail_cli
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ebrok_detail_cli]
(
    [segment] VARCHAR(10) NULL,
    [branch] VARCHAR(10) NULL,
    [sub_Broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [sauda_date] DATETIME NULL,
    [Overall_turnover] MONEY NOT NULL,
    [ebrok_Turnover] MONEY NOT NULL,
    [Overall_brok_earned] MONEY NOT NULL,
    [Overall_Angel_share] MONEY NOT NULL,
    [ebrok_brok_earned] MONEY NOT NULL,
    [ebrok_Angel_share] MONEY NOT NULL,
    [B2C] VARCHAR(10) NULL,
    [Online] VARCHAR(10) NULL,
    [No_of_login] MONEY NULL,
    [Terminal_id] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblBSETrade
-- --------------------------------------------------
CREATE TABLE [dbo].[tblBSETrade]
(
    [ScripCd] VARCHAR(20) NULL,
    [ScripName] VARCHAR(20) NULL,
    [TradeNo] VARCHAR(20) NULL,
    [Rate] MONEY NULL,
    [Qty] INT NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [TradeTime] DATETIME NULL,
    [Date] DATETIME NULL,
    [ClientCode_DealerID] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Order_Number] VARCHAR(20) NULL,
    [Pro_Client] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Clinet_Code1] VARCHAR(20) NULL,
    [Clinet_Code2] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [ISINNO] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [SettNo] VARCHAR(50) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime1] DATETIME NULL,
    [OrderTime] DATETIME NULL,
    [Dummy5] VARCHAR(20) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblBSETradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tblBSETradeTemp]
(
    [ScripCd] VARCHAR(20) NULL,
    [ScripName] VARCHAR(20) NULL,
    [TradeNo] VARCHAR(20) NULL,
    [Rate] MONEY NULL,
    [Qty] INT NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [TradeTime] DATETIME NULL,
    [Date] DATETIME NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Order_Number] VARCHAR(20) NULL,
    [Pro_Client] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Clinet_Code1] VARCHAR(20) NULL,
    [Clinet_Code2] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [ISINNO] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [SettNo] VARCHAR(50) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime1] DATETIME NULL,
    [OrderTime] DATETIME NULL,
    [Dummy5] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblbsetRadetest
-- --------------------------------------------------
CREATE TABLE [dbo].[tblbsetRadetest]
(
    [ScripCd] VARCHAR(20) NULL,
    [ScripName] VARCHAR(20) NULL,
    [TradeNo] VARCHAR(20) NULL,
    [Rate] MONEY NULL,
    [Qty] INT NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [TradeTime] DATETIME NULL,
    [Date] DATETIME NULL,
    [ClientCode_DealerID] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Order_Number] VARCHAR(20) NULL,
    [Pro_Client] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Clinet_Code1] VARCHAR(20) NULL,
    [Clinet_Code2] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [ISINNO] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [SettNo] VARCHAR(50) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime1] DATETIME NULL,
    [OrderTime] DATETIME NULL,
    [Dummy5] VARCHAR(20) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblFilePath
-- --------------------------------------------------
CREATE TABLE [dbo].[tblFilePath]
(
    [segment] VARCHAR(15) NOT NULL,
    [manager] VARCHAR(15) NOT NULL,
    [filepath] VARCHAR(150) NULL,
    [cnt] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblFileStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[tblFileStatus]
(
    [FileExists] BIT NULL,
    [FileisDirectory] BIT NULL,
    [ParentDirectoryExists] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblMCXSXTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[tblMCXSXTrade]
(
    [TradeNo] VARCHAR(30) NULL,
    [Dummy1] VARCHAR(30) NULL,
    [Dummy2] VARCHAR(30) NULL,
    [InstType] VARCHAR(30) NULL,
    [Symbol1] VARCHAR(30) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(30) NULL,
    [Dummy4] VARCHAR(30) NULL,
    [Dummy5] VARCHAR(30) NULL,
    [Symbol2] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(30) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(30) NULL,
    [ClinetCode_DealerID] VARCHAR(30) NULL,
    [Dummy8] VARCHAR(30) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(30) NULL,
    [ClinetCode] VARCHAR(30) NULL,
    [MemberID1] VARCHAR(30) NULL,
    [Dummy10] VARCHAR(30) NULL,
    [MemberID2] VARCHAR(30) NULL,
    [Dummy11] VARCHAR(30) NULL,
    [TradeDateTime1] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(30) NULL,
    [Dummy12] VARCHAR(30) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [TradeDateTime2] DATETIME NULL,
    [Dummy14] VARCHAR(30) NULL,
    [Dummy15] VARCHAR(30) NULL,
    [Dummy16] VARCHAR(30) NULL,
    [OrderType2] VARCHAR(30) NULL,
    [Dummy17] VARCHAR(30) NULL,
    [Dummy18] VARCHAR(30) NULL,
    [Dummy19] VARCHAR(30) NULL,
    [Dummy20] VARCHAR(30) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblMCXSXTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tblMCXSXTradeTemp]
(
    [TradeNo] VARCHAR(30) NULL,
    [Dummy1] VARCHAR(30) NULL,
    [Dummy2] VARCHAR(30) NULL,
    [InstType] VARCHAR(30) NULL,
    [Symbol1] VARCHAR(30) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(30) NULL,
    [Dummy4] VARCHAR(30) NULL,
    [Dummy5] VARCHAR(30) NULL,
    [Symbol2] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(30) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(30) NULL,
    [ClinetCode_DealerID] VARCHAR(30) NULL,
    [Dummy8] VARCHAR(30) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(30) NULL,
    [ClinetCode] VARCHAR(30) NULL,
    [MemberID1] VARCHAR(30) NULL,
    [Dummy10] VARCHAR(30) NULL,
    [MemberID2] VARCHAR(30) NULL,
    [Dummy11] VARCHAR(30) NULL,
    [TradeDateTime1] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(30) NULL,
    [Dummy12] VARCHAR(30) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [TradeDateTime2] DATETIME NULL,
    [Dummy14] VARCHAR(30) NULL,
    [Dummy15] VARCHAR(30) NULL,
    [Dummy16] VARCHAR(30) NULL,
    [OrderType2] VARCHAR(30) NULL,
    [Dummy17] VARCHAR(30) NULL,
    [Dummy18] VARCHAR(30) NULL,
    [Dummy19] VARCHAR(30) NULL,
    [Dummy20] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblMCXTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[tblMCXTrade]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(20) NULL,
    [ClinetCode] VARCHAR(20) NULL,
    [Member_ID1] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [MemberID2] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy12] VARCHAR(20) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [DateTime] DATETIME NULL,
    [Dummy14] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy15] VARCHAR(20) NULL,
    [Dummy16] VARCHAR(20) NULL,
    [Dummy17] VARCHAR(20) NULL,
    [Dummy18] VARCHAR(20) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy19] VARCHAR(20) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblMCXTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tblMCXTradeTemp]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry] DATETIME NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [OrderType1] VARCHAR(30) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy9] VARCHAR(20) NULL,
    [ClinetCode] VARCHAR(20) NULL,
    [Member_ID1] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [MemberID2] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy12] VARCHAR(20) NULL,
    [Dummy13] VARCHAR(50) NULL,
    [DateTime] DATETIME NULL,
    [Dummy14] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy15] VARCHAR(20) NULL,
    [Dummy16] VARCHAR(20) NULL,
    [Dummy17] VARCHAR(20) NULL,
    [Dummy18] VARCHAR(20) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy19] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNSDEXTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNSDEXTrade]
(
    [TradeNo] VARCHAR(30) NULL,
    [Dummy1] VARCHAR(30) NULL,
    [InstType] VARCHAR(30) NULL,
    [Symbol] VARCHAR(30) NULL,
    [Expiry] DATETIME NULL,
    [Dummy2] VARCHAR(30) NULL,
    [Dummy3] VARCHAR(30) NULL,
    [ContractDescription] VARCHAR(30) NULL,
    [Dummy4] VARCHAR(30) NULL,
    [OrderType1] VARCHAR(50) NULL,
    [Dummy5] VARCHAR(30) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(30) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(30) NULL,
    [ClinetCode] VARCHAR(30) NULL,
    [MemberID] VARCHAR(30) NULL,
    [Dummy8] VARCHAR(30) NULL,
    [Dummy9] VARCHAR(30) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(30) NULL,
    [Dummy10] VARCHAR(30) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(30) NULL,
    [Dummy12] VARCHAR(30) NULL,
    [Dummy13] VARCHAR(30) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy14] VARCHAR(30) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNSDEXTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNSDEXTradeTemp]
(
    [TradeNo] VARCHAR(30) NULL,
    [Dummy1] VARCHAR(30) NULL,
    [InstType] VARCHAR(30) NULL,
    [Symbol] VARCHAR(30) NULL,
    [Expiry] DATETIME NULL,
    [Dummy2] VARCHAR(30) NULL,
    [Dummy3] VARCHAR(30) NULL,
    [ContractDescription] VARCHAR(30) NULL,
    [Dummy4] VARCHAR(30) NULL,
    [OrderType1] VARCHAR(50) NULL,
    [Dummy5] VARCHAR(30) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(30) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(30) NULL,
    [ClinetCode] VARCHAR(30) NULL,
    [MemberID] VARCHAR(30) NULL,
    [Dummy8] VARCHAR(30) NULL,
    [Dummy9] VARCHAR(30) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(30) NULL,
    [Dummy10] VARCHAR(30) NULL,
    [Segement] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(30) NULL,
    [Dummy12] VARCHAR(30) NULL,
    [Dummy13] VARCHAR(30) NULL,
    [OrderType2] VARCHAR(50) NULL,
    [Dummy14] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNSEFOTrade
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNSEFOTrade]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [ExpiryDate] VARCHAR(20) NULL,
    [StrikePrice] VARCHAR(20) NULL,
    [OptionType] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [OrderType] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy5] VARCHAR(20) NULL,
    [Clinet_Code1] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [InstrumentType] VARCHAR(20) NULL,
    [ClinetCode2] VARCHAR(20) NULL,
    [ClinetCode3] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [TradeDateTime1] DATETIME NULL,
    [OrderDateTime1] DATETIME NULL,
    [OrderType1] VARCHAR(20) NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNSEFOTradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNSEFOTradeTemp]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [InstType] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [ExpiryDate] VARCHAR(20) NULL,
    [StrikePrice] VARCHAR(20) NULL,
    [OptionType] VARCHAR(20) NULL,
    [ContractDescription] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [OrderType] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy4] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy5] VARCHAR(20) NULL,
    [Clinet_Code1] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Dummy7] VARCHAR(20) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNo] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [InstrumentType] VARCHAR(20) NULL,
    [ClinetCode2] VARCHAR(20) NULL,
    [ClinetCode3] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [TradeDateTime1] DATETIME NULL,
    [OrderDateTime1] DATETIME NULL,
    [OrderType1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNSETrade
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNSETrade]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [ScripName] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(20) NULL,
    [ClinetCode1] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [MarketType] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNumber] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [ClinetCode2] VARCHAR(20) NULL,
    [ClinetCode3] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime] DATETIME NULL,
    [OrderTime] DATETIME NULL,
    [Mgr] VARCHAR(20) NULL,
    [FName] VARCHAR(50) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNSETradeTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNSETradeTemp]
(
    [TradeNo] VARCHAR(20) NULL,
    [Dummy1] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Series] VARCHAR(20) NULL,
    [ScripName] VARCHAR(50) NULL,
    [Dummy2] VARCHAR(20) NULL,
    [Dummy3] VARCHAR(20) NULL,
    [Dummy5] VARCHAR(20) NULL,
    [ClinetCode_DealerID] VARCHAR(20) NULL,
    [Dummy6] VARCHAR(20) NULL,
    [Buy_Sell] CHAR(1) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Dummy7] VARCHAR(20) NULL,
    [ClinetCode1] VARCHAR(20) NULL,
    [MemberID] VARCHAR(20) NULL,
    [MarketType] VARCHAR(20) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [TradeDateTime] DATETIME NULL,
    [OrderDateTime] DATETIME NULL,
    [OrderNumber] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL,
    [Segement] VARCHAR(20) NULL,
    [ClinetCode2] VARCHAR(20) NULL,
    [ClinetCode3] VARCHAR(20) NULL,
    [Dummy11] VARCHAR(20) NULL,
    [ProductType] VARCHAR(20) NULL,
    [TradeTime] DATETIME NULL,
    [OrderTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TradeFileLog
-- --------------------------------------------------
CREATE TABLE [dbo].[TradeFileLog]
(
    [segment] VARCHAR(15) NULL,
    [manager] VARCHAR(15) NULL,
    [filepath] VARCHAR(150) NULL,
    [uploadDt] DATETIME NULL,
    [ErrorDesc] VARCHAR(1000) NULL,
    [ErrorType] VARCHAR(50) NULL
);

GO

