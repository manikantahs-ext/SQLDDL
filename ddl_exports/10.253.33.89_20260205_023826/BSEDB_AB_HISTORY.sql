-- DDL Export
-- Server: 10.253.33.89
-- Database: BSEDB_AB_HISTORY
-- Exported: 2026-02-05T02:38:32.249419

USE BSEDB_AB_HISTORY;
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
-- TABLE dbo.Category
-- --------------------------------------------------
CREATE TABLE [dbo].[Category]
(
    [CatID] VARCHAR(20) NOT NULL,
    [CatName] VARCHAR(60) NOT NULL,
    [CatDesc] VARCHAR(50) NULL,
    [CatCreationDate] DATETIME NOT NULL,
    [CatType] VARCHAR(15) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Committee
-- --------------------------------------------------
CREATE TABLE [dbo].[Committee]
(
    [ComID] VARCHAR(10) NULL,
    [EmpNo1] VARCHAR(20) NULL,
    [EmpNo2] VARCHAR(20) NULL,
    [EmpNo3] VARCHAR(20) NULL,
    [EmpNo4] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DuplicateAmt
-- --------------------------------------------------
CREATE TABLE [dbo].[DuplicateAmt]
(
    [bnkname] VARCHAR(35) NULL,
    [brnname] VARCHAR(20) NULL,
    [dd] CHAR(1) NULL,
    [ddno] VARCHAR(15) NULL,
    [vtyp] SMALLINT NOT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] INT NULL,
    [acname] VARCHAR(100) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NULL,
    [BookType] CHAR(2) NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [pdt] DATETIME NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [actnodays] INT NULL,
    [narration] VARCHAR(234) NULL,
    [Branch] CHAR(35) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Emp_info
-- --------------------------------------------------
CREATE TABLE [dbo].[Emp_info]
(
    [Emp_no] VARCHAR(10) NOT NULL,
    [Emp_name] VARCHAR(50) NOT NULL,
    [email] VARCHAR(50) NULL,
    [status] VARCHAR(10) NOT NULL,
    [Department] VARCHAR(50) NULL,
    [designation] VARCHAR(50) NULL,
    [Senior] VARCHAR(10) NULL,
    [Sr_name] VARCHAR(50) NULL,
    [password] VARCHAR(10) NULL
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
-- TABLE dbo.Hod_Mapping
-- --------------------------------------------------
CREATE TABLE [dbo].[Hod_Mapping]
(
    [Hod_no] VARCHAR(25) NULL,
    [Hod_name] VARCHAR(80) NULL,
    [Department] VARCHAR(100) NULL,
    [Pi_no] VARCHAR(50) NULL,
    [Pi_name] VARCHAR(50) NULL,
    [dc_no] VARCHAR(50) NULL,
    [dc_name] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InventoryData
-- --------------------------------------------------
CREATE TABLE [dbo].[InventoryData]
(
    [ItemID] VARCHAR(20) NOT NULL,
    [CatID] VARCHAR(20) NOT NULL,
    [Quantity] INT NULL,
    [LastUpdateDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InventoryItem
-- --------------------------------------------------
CREATE TABLE [dbo].[InventoryItem]
(
    [ItemID] VARCHAR(20) NOT NULL,
    [ItemName] VARCHAR(60) NOT NULL,
    [ItemDesc] VARCHAR(50) NULL,
    [ItemCreationDate] DATETIME NULL,
    [CatID] VARCHAR(20) NOT NULL,
    [ItemType] VARCHAR(15) NOT NULL,
    [Rate] FLOAT NULL,
    [VAT] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ModifiedRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[ModifiedRequest]
(
    [ModID] VARCHAR(10) NOT NULL,
    [ReqID] VARCHAR(10) NOT NULL,
    [ItemID] VARCHAR(50) NULL,
    [ItemName] VARCHAR(100) NULL,
    [Qty] INT NULL,
    [Note] VARCHAR(80) NULL,
    [ModBy] VARCHAR(25) NOT NULL,
    [ModDate] DATETIME NOT NULL,
    [CompleteByDate] VARCHAR(25) NULL,
    [ReqStatusCode] VARCHAR(4) NOT NULL,
    [ModType] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ModifiedVIRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[ModifiedVIRequest]
(
    [ModID] VARCHAR(10) NOT NULL,
    [ReqID] VARCHAR(10) NOT NULL,
    [ItemID] VARCHAR(50) NULL,
    [ItemName] VARCHAR(50) NULL,
    [Qty] INT NULL,
    [Note] VARCHAR(80) NULL,
    [ModBy] VARCHAR(25) NOT NULL,
    [ModDate] DATETIME NOT NULL,
    [CompleteByDate] VARCHAR(25) NULL,
    [ReqStatusCode] VARCHAR(4) NOT NULL,
    [ModType] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NewReqItems
-- --------------------------------------------------
CREATE TABLE [dbo].[NewReqItems]
(
    [ReqID] VARCHAR(15) NOT NULL,
    [ItemName] VARCHAR(50) NOT NULL,
    [CategoryName] VARCHAR(30) NULL,
    [newCatID] VARCHAR(20) NULL,
    [newItemID] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Notifications
-- --------------------------------------------------
CREATE TABLE [dbo].[Notifications]
(
    [NoteID] VARCHAR(50) NOT NULL,
    [ReqID] VARCHAR(20) NOT NULL,
    [Hod_No] VARCHAR(10) NOT NULL,
    [Emp_no] VARCHAR(10) NOT NULL,
    [Pi_No] VARCHAR(10) NULL,
    [Note] VARCHAR(200) NULL,
    [NoteDate] VARCHAR(20) NOT NULL,
    [Message] VARCHAR(100) NOT NULL,
    [Subject] VARCHAR(100) NOT NULL,
    [Is_Checked] INT NULL,
    [CatName] VARCHAR(100) NULL,
    [ItemName] VARCHAR(100) NULL,
    [ReqStatusCode] VARCHAR(4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Order_Queue
-- --------------------------------------------------
CREATE TABLE [dbo].[Order_Queue]
(
    [orderID] VARCHAR(50) NOT NULL,
    [Hod_no] VARCHAR(25) NULL,
    [ItemID] VARCHAR(50) NULL,
    [TotalQty] FLOAT NULL,
    [Status] INT NULL,
    [StockQty] FLOAT NULL,
    [Rate] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Order_VQueue
-- --------------------------------------------------
CREATE TABLE [dbo].[Order_VQueue]
(
    [ReqID] VARCHAR(25) NOT NULL,
    [Pi_no] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OrderTmpQueue
-- --------------------------------------------------
CREATE TABLE [dbo].[OrderTmpQueue]
(
    [OrderID] VARCHAR(50) NOT NULL,
    [ItemID] VARCHAR(50) NULL,
    [Qty] FLOAT NULL,
    [Rate] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.purchase_order_queue
-- --------------------------------------------------
CREATE TABLE [dbo].[purchase_order_queue]
(
    [purchase_id] VARCHAR(20) NULL,
    [orderID] VARCHAR(20) NULL,
    [order_date] VARCHAR(50) NULL,
    [status] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ReqModified
-- --------------------------------------------------
CREATE TABLE [dbo].[ReqModified]
(
    [ReqID] VARCHAR(20) NOT NULL,
    [ModID] VARCHAR(20) NOT NULL,
    [Hod_no] VARCHAR(15) NULL,
    [Comm_no] VARCHAR(15) NULL,
    [Hod_note] VARCHAR(60) NULL,
    [Comm_note] VARCHAR(60) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ReqReminder
-- --------------------------------------------------
CREATE TABLE [dbo].[ReqReminder]
(
    [ReqID] VARCHAR(20) NOT NULL,
    [Rem1] VARCHAR(4) NULL,
    [Rem1Date] DATETIME NULL,
    [Rem2] VARCHAR(4) NULL,
    [Rem2Date] DATETIME NULL,
    [Rem1Note] VARCHAR(50) NULL,
    [Rem2Note] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ReqStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[ReqStatus]
(
    [ReqStatusCode] VARCHAR(20) NOT NULL,
    [ReqStatusName] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.StockData
-- --------------------------------------------------
CREATE TABLE [dbo].[StockData]
(
    [ItemID] VARCHAR(50) NULL,
    [Qty] FLOAT NULL,
    [LastModified] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [ireq] CHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp1]
(
    [purchase1] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp12
-- --------------------------------------------------
CREATE TABLE [dbo].[temp12]
(
    [abcde] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempab
-- --------------------------------------------------
CREATE TABLE [dbo].[tempab]
(
    [abcd] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempabc
-- --------------------------------------------------
CREATE TABLE [dbo].[tempabc]
(
    [itemid] VARCHAR(20) NOT NULL,
    [sum] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temptbl
-- --------------------------------------------------
CREATE TABLE [dbo].[temptbl]
(
    [PO_ID] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temptbl1
-- --------------------------------------------------
CREATE TABLE [dbo].[temptbl1]
(
    [sum_totalqty] FLOAT NULL,
    [itemid] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserReqGroup
-- --------------------------------------------------
CREATE TABLE [dbo].[UserReqGroup]
(
    [ReqID] VARCHAR(50) NOT NULL,
    [ReqGroupID] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[UserRequest]
(
    [ReqID] NVARCHAR(15) NOT NULL,
    [ItemID] VARCHAR(20) NOT NULL,
    [CatID] VARCHAR(20) NOT NULL,
    [ItemName] VARCHAR(100) NULL,
    [CategoryName] VARCHAR(100) NULL,
    [UserNote] VARCHAR(100) NULL,
    [HodNote] VARCHAR(80) NULL,
    [ReqStatusCode] VARCHAR(20) NOT NULL,
    [ReqDate] DATETIME NOT NULL,
    [CompleteByDate] VARCHAR(50) NULL,
    [ReqCompletedDate] VARCHAR(50) NOT NULL,
    [ReqCancelled] NVARCHAR(5) NULL,
    [Emp_no] VARCHAR(10) NOT NULL,
    [Hod_no] VARCHAR(10) NOT NULL,
    [Pi_no] VARCHAR(10) NULL,
    [Qty] INT NULL,
    [orderID] VARCHAR(50) NULL,
    [ReqGroupID] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserVIRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[UserVIRequest]
(
    [ReqID] NVARCHAR(15) NOT NULL,
    [ItemID] VARCHAR(20) NOT NULL,
    [CatID] VARCHAR(20) NOT NULL,
    [ItemName] VARCHAR(50) NULL,
    [CategoryName] VARCHAR(50) NULL,
    [UserNote] VARCHAR(80) NULL,
    [HodNote] VARCHAR(80) NULL,
    [ReqStatusCode] VARCHAR(20) NOT NULL,
    [ReqDate] VARCHAR(50) NOT NULL,
    [CompleteByDate] DATETIME NULL,
    [ReqCompletedDate] DATETIME NULL,
    [ReqCancelled] NVARCHAR(5) NULL,
    [Emp_no] VARCHAR(10) NOT NULL,
    [Hod_no] VARCHAR(10) NOT NULL,
    [Pi_no] VARCHAR(10) NULL,
    [CommNote] VARCHAR(80) NULL,
    [Qty] INT NULL,
    [orderID] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VendorMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[VendorMaster]
(
    [clt_code] VARCHAR(53) NULL,
    [ac_name] NVARCHAR(255) NULL,
    [long_name] NVARCHAR(255) NULL,
    [branch_code] NVARCHAR(255) NULL,
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
-- TABLE dbo.VendorTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[VendorTemp]
(
    [clt_code] VARCHAR(53) NULL,
    [ac_name] NVARCHAR(255) NULL,
    [long_name] NVARCHAR(255) NULL,
    [branch_code] NVARCHAR(255) NULL,
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

