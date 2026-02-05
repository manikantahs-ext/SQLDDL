-- DDL Export
-- Server: 10.253.78.163
-- Database: Remissor
-- Exported: 2026-02-05T12:32:28.776864

USE Remissor;
GO

-- --------------------------------------------------
-- FUNCTION dbo.getlastdate
-- --------------------------------------------------
Create function getlastdate(@mmonth int, @myear int)  
RETURNs Datetime  
As  
Begin  
--set @mmonth =  2  
--set @myear  = 2007  
declare @tdate as datetime  
select @tdate=convert(datetime,convert(varchar(2),case when @mmonth < 12 then @mmonth+1 else 1 end)+'/01/'+convert(varchar(4),  
case when @mmonth < 12 then @myear else @myear+1 end))-1  
Return @tdate  
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.multi_sbtag_List
-- --------------------------------------------------

CREATE Function [dbo].[multi_sbtag_List] (@sb_code Varchar(200)) 
RETURNS Varchar(2000) -- Multi Tag’s list
As
Begin
	Declare @sb_List Varchar(2000)
	Select  @sb_List = Coalesce(@sb_List+',','') + sub_broker
	From risk.dbo.sb_list
	Where
	sbname = @sb_code

	RETURN @sb_List
	
End

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Category
-- --------------------------------------------------
ALTER TABLE [dbo].[Category] ADD CONSTRAINT [PK_Category] PRIMARY KEY ([CatID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InventoryData
-- --------------------------------------------------
ALTER TABLE [dbo].[InventoryData] ADD CONSTRAINT [PK_InventoryData] PRIMARY KEY ([ItemID], [CatID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InventoryItem
-- --------------------------------------------------
ALTER TABLE [dbo].[InventoryItem] ADD CONSTRAINT [PK_InventoryItem] PRIMARY KEY ([ItemID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ModifiedRequest
-- --------------------------------------------------
ALTER TABLE [dbo].[ModifiedRequest] ADD CONSTRAINT [PK_ModifiedRequest] PRIMARY KEY ([ModID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Notifications
-- --------------------------------------------------
ALTER TABLE [dbo].[Notifications] ADD CONSTRAINT [PK_Notifications] PRIMARY KEY ([NoteID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Order_Queue
-- --------------------------------------------------
ALTER TABLE [dbo].[Order_Queue] ADD CONSTRAINT [PK_Order_Queue] PRIMARY KEY ([orderID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Order_VQueue
-- --------------------------------------------------
ALTER TABLE [dbo].[Order_VQueue] ADD CONSTRAINT [PK_Order_VQueue] PRIMARY KEY ([ReqID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.OrderTmpQueue
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderTmpQueue] ADD CONSTRAINT [PK_OrderTmpQueue] PRIMARY KEY ([OrderID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ProcessIncharge
-- --------------------------------------------------
ALTER TABLE [dbo].[ProcessIncharge] ADD CONSTRAINT [PK_ProcessIncharge] PRIMARY KEY ([Emp_No], [ReqID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ReqModified
-- --------------------------------------------------
ALTER TABLE [dbo].[ReqModified] ADD CONSTRAINT [PK_ReqModified] PRIMARY KEY ([ReqID], [ModID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ReqStatus
-- --------------------------------------------------
ALTER TABLE [dbo].[ReqStatus] ADD CONSTRAINT [PK_ReqStatus] PRIMARY KEY ([ReqStatusCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UserRequest
-- --------------------------------------------------
ALTER TABLE [dbo].[UserRequest] ADD CONSTRAINT [PK_UserRequest] PRIMARY KEY ([ReqID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UserVIRequest
-- --------------------------------------------------
ALTER TABLE [dbo].[UserVIRequest] ADD CONSTRAINT [PK_UserVIRequest] PRIMARY KEY ([ReqID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.add_notice
-- --------------------------------------------------
create procedure add_notice
(
@nid varchar(50),
@reqID varchar(20),
@hodNo varchar(20),
@empno varchar(20),
@pino varchar(20),
@note varchar(80),
@noteDate varchar(20),
@message varchar(80),
@subject varchar(40),
@ischecked int,
@catname varchar(30),
@itemName varchar(30),
@status varchar(4)
)
as 
insert into Notifications values(@nid, @reqID, @hodNo, @empno,@pino, @note, @noteDate,@message,@subject,@ischecked,@catname,@itemname,@status)
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.addToOrderQueue
-- --------------------------------------------------
create procedure addToOrderQueue
(
@ordid varchar(50),
@hodid varchar(25),
@itemid varchar(50),
@qty float--,@reqid varchar(20)
--,@stat integer--,@initQty float,@newQty float
)
as
--@initQty = select qty from Order_Queue where hod_no = @hodid and itemid = @itemid
--@newQty = @qty - @initQty
Declare @rate float

select @rate=rate from InventoryItem where Itemid = @itemId

insert into Order_Queue values(@ordid,@hodid,@itemid,@qty,0,0,@rate)
--update UserRequest set orderID=@ordID where ReqID = @ReqID

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.calc_sb_ledger
-- --------------------------------------------------

 

CREATE proc [dbo].[calc_sb_ledger]
as

declare @acyearfrom as datetime,@acyearto as datetime  
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)   
where sdtcur <=getdate() and ldtcur >=getdate() 

---------------- BSE

select acname,
amount = isnull(sum(case when drcr='D' then -vamt else vamt end),0)
into #sb_ledger_bse
 from AngelBSECM.account_ab.dbo.ledger
where vdt >=@acyearfrom and 
vdt <=@acyearto and acname  in (select distinct(name) from remissor.dbo.sb_list)
group by acname

-------------------- NSE
select acname,
amount = isnull(sum(case when drcr='D' then -vamt else vamt end),0)
into #sb_ledger_nse
 from AngelNseCM.inhouse.dbo.ledger
where vdt >=@acyearfrom and 
vdt <=@acyearto and acname  in (select distinct(name) from remissor.dbo.sb_list)
group by acname

--------------- BSE FO
select acname,
amount = isnull(sum(case when drcr='D' then -vamt else vamt end),0)
into #sb_ledger_bsefo
 from AngelBSECM.accountbfo.dbo.ledger
where vdt >=@acyearfrom and 
vdt <=@acyearto and acname  in (select distinct(name) from remissor.dbo.sb_list)
group by acname

----------------- NSEFO
select acname,
amount = isnull(sum(case when drcr='D' then -vamt else vamt end),0)
into #sb_ledger_nsefo
 from angelfo.inhouse.dbo.ledger
where vdt >=@acyearfrom and 
vdt <=@acyearto and acname  in (select distinct(name) from remissor.dbo.sb_list)
group by acname

------------------- MCX
select acname,
amount = isnull(sum(case when drcr='D' then -vamt else vamt end),0)
into #sb_ledger_mcx
 from angelcommodity.accountmcdx.dbo.ledger
where vdt >=@acyearfrom and 
vdt <=@acyearto and acname  in (select distinct(name) from remissor.dbo.sb_list)
group by acname

--------------- NCDEX

select acname,
amount = isnull(sum(case when drcr='D' then -vamt else vamt end),0)
into #sb_ledger_ncdx
 from angelcommodity.accountncdx.dbo.ledger
where vdt >=@acyearfrom and 
vdt <=@acyearto and acname  in (select distinct(name) from remissor.dbo.sb_list)
group by acname

/*
drop table #sb_ledger_bse
drop table #sb_ledger_nse
drop table #sb_ledger_bsefo
drop table #sb_ledger_nsefo
drop table #sb_ledger_mcx
drop table #sb_ledger_ncdx

select * from #sb_ledger_bse
select * from #sb_ledger_nse
select * from #sb_ledger_bsefo
select * from #sb_ledger_nsefo
select * from #sb_ledger_mcx
select * from #sb_ledger_ncdx
*/



select * 
into sb_ledger
from #sb_ledger_bse

update sb_ledger 
set sb_ledger.amount = sb_ledger.amount + b.amount 
from #sb_ledger_nse b
where sb_ledger.acname = b.acname


update sb_ledger 
set sb_ledger.amount = sb_ledger.amount + b.amount 
from #sb_ledger_bsefo b
where sb_ledger.acname = b.acname

update sb_ledger 
set sb_ledger.amount = sb_ledger.amount + b.amount 
from #sb_ledger_nsefo b
where sb_ledger.acname = b.acname

update sb_ledger 
set sb_ledger.amount = sb_ledger.amount + b.amount 
from #sb_ledger_mcx b
where sb_ledger.acname = b.acname

update sb_ledger 
set sb_ledger.amount = sb_ledger.amount + b.amount 
from #sb_ledger_ncdx b
where sb_ledger.acname = b.acname

--select * from sb_ledger where acname='B N V SATYANARAYANA'
--B N V SATYANARAYANA

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.commModifyVIRequest
-- --------------------------------------------------
create procedure commModifyVIRequest
(
@ModID nvarchar(15),
@Pi_No nvarchar(15),
@ReqID nvarchar(15),
@ItemID varchar(20),
@ItemName varchar(50),
@UserNote varchar(80),
@HodNote varchar(80),
@ModBy varchar(10),
@ModDate datetime,
@Note varchar(80),
@CompleteByDate varchar(25),
@qty int,
@stat varchar(4),
@modtype int
)
as

update UserVIRequest set ItemID = @ItemID, ItemName = @ItemName, UserNote = @UserNote, HodNote=@HodNote,commnote = @note, Qty=@qty,CompleteByDate = @CompleteByDate, Pi_No = @Pi_No, ReqStatusCode = @stat where ReqID = @ReqID
insert into ModifiedVIRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@Note,@ModBy,@ModDate,@CompleteByDate,@stat,@modtype)
update ProcessIncharge set Emp_no = @Pi_no where reqid = @reqid 
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
@ItemName varchar(50),
@CategoryName varchar(50),
@UserNote varchar(80),
@ReqDate datetime,--varchar(50),
@CompleteByDate varchar(25),
@Emp_no varchar(10),
@Hod_no varchar(10),
--@Pi_no varchar(10),
@Qty int,
@ModID varchar(25),
@stat varchar(4)
)
as
Declare @Pi as Varchar(10)
set @Pi = (select Emp_No from ProcessIncharge where hod_no=@hod_no)

insert into UserRequest values (@ReqID,@ItemID,@CatID,@ItemName,@CategoryName,@UserNote,'',@stat,@ReqDate,@CompleteByDate,'','no',@Emp_no,@Hod_no,@Pi,@qty,'')
insert into ModifiedRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@UserNote,@Emp_no,@ReqDate,@CompleteByDate,@stat,0)
--insert into ProcessIncharge values (@Pi_no, @hod_no , @reqID)
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.createVIRequest
-- --------------------------------------------------
create procedure createVIRequest
(
@ReqID nvarchar(15),
@ItemID varchar(20),
@CatID varchar(20),
@ItemName varchar(50),
@CategoryName varchar(50),
@UserNote varchar(80),
@ReqDate datetime,
@CompleteByDate varchar(25),
@Emp_no varchar(10),
@Hod_no varchar(10),
@Pi_no varchar(10),
@qty int,
@ModID nvarchar(25),
@stat varchar(4)
)
as
insert into UserVIRequest values (@ReqID,@ItemID,@CatID,@ItemName,@CategoryName,@UserNote,'',@stat,@ReqDate,@CompleteByDate,'','no',@Emp_no,@Hod_no,@Pi_no,'',@qty)
insert into ModifiedVIRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@UserNote,@Emp_no,@ReqDate,@CompleteByDate,@stat,0)
insert into ProcessIncharge values (@Pi_no, @hod_no , @reqID)
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.disp_req
-- --------------------------------------------------
create procedure disp_req
(
@uno as varchar(25),
@reqCode as varchar(5)
)
as

select a.ReqID, a.ItemName, a.CategoryName, b.ReqStatusName,a.Emp_No,a.CompleteByDate, a.reqStatusCode from UserRequest a,
ReqStatus b where a.Hod_no =@uno AND a.ReqStatusCode = b.ReqStatusCode AND a.ReqStatusCode=@reqCode order by a.ReqStatusCode 

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.gen_report
-- --------------------------------------------------
create proc gen_report

@emp_no  varchar(15)

as
select itemid,sum(qty) as sum  into #tempabc from userrequest  where emp_no=@emp_no group by itemid


select b.itemid,a.sum,b.itemname from #tempabc a,inventoryitem b where b.itemid in(select itemid from #tempabc)
and a.itemid=b.itemid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.gen_report1
-- --------------------------------------------------
CREATE proc gen_report1      
(    
@emp_no  varchar(15),    
--@option varchar(10),  
@frmdate varchar(20),  
@todate varchar(20)     
)      
as    
    
  
--if @option = 'EMP'    
--BEGIN      
select itemid,sum(qty) as sum  into #tempabc from userrequest where emp_no=@emp_no 
and (reqdate>=@frmdate+' 00:00:00' and reqdate<=@todate+' 23:59:59')  
and (reqstatuscode=0 or reqstatuscode=1 or reqstatuscode=2)
group by itemid  

select b.itemid,a.sum,b.itemname from #tempabc a,inventoryitem b     
where b.itemid in(select itemid from #tempabc) and a.itemid=b.itemid 


RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.generate_po
-- --------------------------------------------------
create proc generate_po
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
CREATE procedure get_hodReqList(@hod_no as varchar(25),@code as varchar(10), @code1 as varchar(10))        
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
  
--drop table #allreq  
--drop table #DistWOQty  
--drop table #DistWQty  
--select * from #allReq  
  
set nocount off    
  return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.get_ReqsDetail
-- --------------------------------------------------
create procedure get_ReqsDetail(@hod_no as varchar(25),@code as varchar(10),@itmID as varchar(25))      
as
set transaction isolation level read uncommitted      
set nocount on      

select a.itemID,a.ItemNAme,a.CategoryName,a.Qty,b.ReqStatusName,a.pi_no,a.CatID into #allReq 
from UserRequest a,ReqStatus b where hod_no = @hod_no and a.ReqStatusCOde =@code 
and a.ReqStatusCode = b.ReqStatusCode and a.ItemID=@ItmID
order by ItemName

select distinct ItemID, Itemname,CategoryName,ReqStatusName,Pi_no,Catid into #DistWOQty from #allReq order by itemname

--select * from #DistWOQty 
select itemName,sum(Qty) as 'Qty' into #DistWQty from #allReq group by itemName order by itemname 
--select * from #DistWQty

select a.ItemID,a.Itemname,a.CategoryName,a.ReqStatusName,b.Qty,a.Pi_no,a.Catid from #DistWOQty a left outer join  #DistWQty  b 
on a.Itemname = b.ItemName

--drop table #allreq
--drop table #DistWOQty
--drop table #DistWQty
--select * from #allReq

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.HodmodifyNVIRequest
-- --------------------------------------------------
CREATE procedure HodmodifyNVIRequest
(
@ModID nvarchar(15),
@Pi_No nvarchar(15),
@ReqID nvarchar(15),
@ItemID varchar(20),
@ItemName varchar(50),
@UserNote varchar(80),
@HodNote varchar(80),
@ModBy varchar(10),
@ModDate datetime,--varchar(50),
@Note varchar(80),
@CompleteByDate varchar(25),
@qty int,
@stat varchar(4),
@modtype int,
@ordID varchar(50)
)
as

update UserRequest set ItemID = @ItemID, ItemName = @ItemName, UserNote = @UserNote, HodNote=@HodNote,Qty=@qty,CompleteByDate = @CompleteByDate, Pi_No = @Pi_No,ReqStatusCode = @stat,orderID=@ordID where ReqID = @ReqID

insert into ModifiedRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@Note,@ModBy,@ModDate,@CompleteByDate,@stat,@modtype)

update ProcessIncharge set Emp_no = @Pi_no where reqid = @reqid 

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.HodmodifyVIRequest
-- --------------------------------------------------
create procedure HodmodifyVIRequest
(
@ModID nvarchar(15),
@Pi_No nvarchar(15),
@ReqID nvarchar(15),
@ItemID varchar(20),
@ItemName varchar(50),
@UserNote varchar(80),
@HodNote varchar(80),
@ModBy varchar(10),
@ModDate datetime,
@Note varchar(80),
@CompleteByDate varchar(25),
@qty int,
@stat varchar(4),
@modtype int
)
as

update UserVIRequest set ItemID = @ItemID, ItemName = @ItemName, UserNote = @UserNote, HodNote=@HodNote,Qty=@qty,CompleteByDate = @CompleteByDate, Pi_No = @Pi_No, ReqStatusCode = @stat where ReqID = @ReqID
insert into ModifiedVIRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@Note,@ModBy,@ModDate,@CompleteByDate,@stat,@modtype)
update ProcessIncharge set Emp_no = @Pi_no where reqid = @reqid 
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insertReq2
-- --------------------------------------------------
create procedure insertReq2
as 
declare 
@ireq nvarchar(50),
@name char(10),
@no int

set @no = (select count(name) from temp)
set @no = @no + 1
set @ireq = @no

insert into temp(ireq,name) values(@ireq,'sl')

return(0)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.modify_OrderQueue
-- --------------------------------------------------
create procedure modify_OrderQueue
(
@ordid varchar(50),
@stat int,
@newQty float
)
as

Declare @totalQty float, @stock float, @initQty float

select @totalQty = TotalQty from Order_queue where orderID = @ordid
select @stock = StockQty from Order_Queue where orderID = @ordid

set @initQty = @totalQty
set @totalQty = @newQty --(@totalQty - @initQty) + @newQty 
set @stock = @stock + (@initQty - @totalQty)

update Order_Queue set TotalQty = @totalQty, StockQty = @stock, status = @stat where orderID = @ordid

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.modifyNVIRequest
-- --------------------------------------------------
CREATE procedure modifyNVIRequest
(
@ModID nvarchar(15),
@ReqID nvarchar(15),
@ItemID varchar(20),
@ItemName varchar(50),
@UserNote varchar(80),
@HodNote varchar(80),
@ModBy varchar(10),
@ModDate datetime,--varchar(50),
@Note varchar(80),
@CompleteByDate varchar(25),
@qty int,
@stat varchar(4),
@modtype int
)
as

update UserRequest set ItemID = @ItemID, ItemName = @ItemName, UserNote = @UserNote, Qty=@qty, HodNote=@HodNote ,CompleteByDate = @CompleteByDate, ReqStatusCode = @stat where ReqID = @ReqID
insert into ModifiedRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@Note,@ModBy,@ModDate,@CompleteByDate,@stat,@modtype)
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.modifyOrderQueue
-- --------------------------------------------------
create procedure modifyOrderQueue
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
-- PROCEDURE dbo.modifyVIRequest
-- --------------------------------------------------
create procedure modifyVIRequest
(
@ModID nvarchar(15),
@ReqID nvarchar(15),
@ItemID varchar(20),
@ItemName varchar(50),
@UserNote varchar(80),
@HodNote varchar(80),
@ModBy varchar(10),
@ModDate datetime,
@Note varchar(80),
@CompleteByDate varchar(25),
@qty int,
@stat varchar(4),
@modtype int
)
as

update UserVIRequest set ItemID = @ItemID, ItemName = @ItemName, UserNote = @UserNote, Qty=@qty, HodNote=@HodNote ,CompleteByDate = @CompleteByDate where ReqID = @ReqID
insert into ModifiedVIRequest values (@ModID,@ReqID,@ItemID,@ItemName,@qty,@Note,@ModBy,@ModDate,@CompleteByDate,@stat,@modtype)
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.po_status_update
-- --------------------------------------------------
CREATE proc po_status_update  
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
create procedure proc_notice
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
-- PROCEDURE dbo.process1
-- --------------------------------------------------

CREATE procedure [dbo].[process1](@sname as varchar(10),@df as datetime, @dt as datetime)                              
as                              
                  
set nocount on                  
set transaction isolation level read uncommitted                  
                
select party_code into #cli from intranet.risk.dbo.client_details where sub_broker=@sname      
and branch_cd='PTN'             
                
select * into #sb1 from --temp_jkh_nse--temp_pdr_nse--            
AngelNseCM.msajag.dbo.cmbillvalan a                 
--where sauda_Date >= @df and sauda_Date <= @dt and party_code in (select party_code from #cli)         
where sauda_Date >= @df and sauda_Date <= @dt and exists (select party_code from #cli where #cli.party_Code=a.party_Code)         
and tradetype not like '__F'                            
                  
truncate table temp_brok                            
insert into temp_brok                                   
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,                            
sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,                            
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),                              
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),                              
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),                              
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),                              
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00)                        
--from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, risk.dbo.bse_client1 b, risk.dbo.bse_client2 c                              
from #sb1  a, intranet.risk.dbo.client_details b             
where b.party_Code=a.party_code --and c.cl_code=b.cl_code                     
--and b.sub_broker=@sname                   
--and a.sauda_Date >= @df and a.sauda_Date <= @dt                              
--and tradetype not like '__F'                            
order by a.party_code                   
                  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process1a
-- --------------------------------------------------

CREATE procedure [dbo].[process1a](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))    
as    
drop table temp_broka    
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,    
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),    
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),    
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),    
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),    
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_broka    
from AngelNseCM.msajag.dbo.cmbillvalan a, intranet.risk.dbo.nse_client1 b, intranet.risk.dbo.nse_client2 c    
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.sub_broker=@sname and a.sauda_Date between @df and @dt and b.branch_cd='PTN'   
and tradetype not like '__F'     
and a.party_code=@mcode    
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process1af
-- --------------------------------------------------
CREATE procedure [dbo].[process1af](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))  
as  
drop table temp_broka  
select b.sub_broker, a.party_code,b.short_name,scrip_cd=(ltrim(rtrim(symbol))+'-'+left(ltrim(rtrim(expirydate)),11)),series=(ltrim(rtrim(inst_type))+' '+ltrim(rtrim(option_type))),  
sauda_date,pqty as pqtytrd,sqty as sqtytrd,0 as pqtydel,0 as sqtydel,pbrokamt as Pbroktrd,sbrokamt as Sbroktrd,0 as pbrokdel,0 as sbrokdel,  
Strike_Price+prate as ptrate, Strike_Price+srate as strate, 0 as sdrate,0 as pdrate,ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),  
ndbrok=convert(money,0.00) into temp_broka  
from angelfo.nsefo.dbo.fobillvalan a, angelfo.nsefo.dbo.client1 b, angelfo.nsefo.dbo.client2 c  
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.sub_broker=@sname and a.sauda_Date between @df and @dt and branch_cd='PTN' 
and a.party_code=@mcode and pbrokamt+sbrokamt > 0  
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process1f
-- --------------------------------------------------
CREATE procedure [dbo].[process1f](@sname as varchar(10),@df as datetime, @dt as datetime)  
as  
drop table temp_brok  
select b.sub_broker, a.party_code,b.short_name,scrip_cd=(ltrim(rtrim(symbol))+' '+left(ltrim(rtrim(expirydate)),10)),series=(ltrim(rtrim(inst_type))+' '+ltrim(rtrim(option_type))),  
sauda_date,pqty as pqtytrd,sqty as sqtytrd,0 as pqtydel,0 as sqtydel,pbrokamt as Pbroktrd,sbrokamt as Sbroktrd,0 as pbrokdel,0 as sbrokdel,  
Strike_Price+prate as ptrate, Strike_Price+srate as strate, 0 as sdrate,0 as pdrate,ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),  
ndbrok=convert(money,0.00) into temp_brok  
from angelfo.nsefo.dbo.fobillvalan a, angelfo.nsefo.dbo.client1 b, angelfo.nsefo.dbo.client2 c , foclient focl  
where c.party_Code=a.party_code and c.cl_code=b.cl_code   and b.branch_cd='PTN'
and focl.party_code = c.party_code  
and focl.mark = 'Y'  
and b.sub_broker=@sname and a.sauda_Date between @df and @dt  
and pbrokamt+sbrokamt > 0  
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process1fa
-- --------------------------------------------------

CREATE procedure [dbo].[process1fa](@sname as varchar(10),@df as datetime, @dt as datetime)      
as      
drop table temp_brok      
  
select party_code into #cli from risk.dbo.client_details (nolock) where sub_broker=@sname   
  
select b.sub_broker, a.party_code,b.short_name,scrip_cd=(ltrim(rtrim(symbol))+' '+left(ltrim(rtrim(expirydate)),10)),series=(ltrim(rtrim(inst_type))+' '+ltrim(rtrim(option_type))),      
sauda_date,pqty as pqtytrd,sqty as sqtytrd,0 as pqtydel,0 as sqtydel,pbrokamt as Pbroktrd,sbrokamt as Sbroktrd,0 as pbrokdel,0 as sbrokdel,      
Strike_Price+prate as ptrate, Strike_Price+srate as strate, 0 as sdrate,0 as pdrate,ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),      
ndbrok=convert(money,0.00) into temp_brok      
from angelfo.nsefo.dbo.fobillvalan a, angelfo.nsefo.dbo.client1 b, angelfo.nsefo.dbo.client2 c --, foclient focl     

where c.party_Code=a.party_code and c.cl_code=b.cl_code       
and b.branch_cd='PTN' 
--and focl.party_code = c.party_code      
--and focl.mark = 'Y'      
 and a.party_code in (select party_code from #cli) and a.sauda_Date between @df and @dt      
and pbrokamt+sbrokamt > 0      
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process2
-- --------------------------------------------------
CREATE procedure [dbo].[process2](@sname as varchar(10),@df as datetime, @dt as datetime)                            
as                            
                
set nocount on                
set transaction isolation level read uncommitted                
select party_code,sub_broker,short_name into #cli from intranet.risk.dbo.client_details  where sub_Broker=@sname      and branch_cd='PTN'          
              
select * into #sb1 from --temp_jkh_bse--temp_pdr      
AngelBSECM.bsedb_ab.dbo.cmbillvalan a                
where sauda_Date >= @df and sauda_Date <= @dt and exists (select party_code from #cli where #cli.party_Code=a.party_Code)     
and tradetype not like '__F'    
                
truncate table temp_brok                          
insert into temp_brok                                 
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,                          
sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,                          
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),                            
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),                            
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),                            
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),                            
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00)                      
--from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, risk.dbo.bse_client1 b, risk.dbo.bse_client2 c                            
from #sb1  a, #cli b (nolock)                 
where b.party_Code=a.party_code --and c.cl_code=b.cl_code                   
--and b.sub_broker=@sname                 
--and a.sauda_Date >= @df and a.sauda_Date <= @dt                            
--and tradetype not like '__F'                          
order by a.party_code                 
                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process2a
-- --------------------------------------------------
CREATE procedure [dbo].[process2a](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10) )    
as    
drop table temp_broka    
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,    
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),    
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),    
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),    
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),    
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_broka    
from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, intranet.risk.dbo.bse_client1 b, intranet.risk.dbo.bse_client2 c    
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.sub_broker=@sname and a.sauda_Date between @df and @dt    
and tradetype not like '__F'     
and a.party_code=@mcode    
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process3
-- --------------------------------------------------

CREATE procedure [dbo].[process3](@sname as varchar(10),@df as datetime, @dt as datetime)    
as    
drop table temp_brok    
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,    
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),    
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),    
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),    
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),    
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_brok    
from AngelNseCM.msajag.dbo.cmbillvalan a, intranet.risk.dbo.nse_client1 b, intranet.risk.dbo.nse_client2 c    
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.branch_cd='PTN' and a.sauda_Date between @df and @dt   
and tradetype not like '__F'  
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process3a
-- --------------------------------------------------

CREATE procedure [dbo].[process3a](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))    
as    
drop table temp_broka    
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,    
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),    
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),    
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),    
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),    
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_broka    
from AngelNseCM.msajag.dbo.cmbillvalan a, intranet.risk.dbo.nse_client1 b, intranet.risk.dbo.nse_client2 c    
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.branch_cd=@sname and a.sauda_Date between @df and @dt    
and a.party_code=@mcode and tradetype not like '__F'     
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process4
-- --------------------------------------------------
CREATE procedure [dbo].[process4](@sname as varchar(10),@df as datetime, @dt as datetime)      
as      
drop table temp_brok      
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,      
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),      
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),      
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),      
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),      
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_brok      
from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, intranet.risk.dbo.bse_client1 b, intranet.risk.dbo.bse_client2 c      
--where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.branch_cd=@sname and a.sauda_Date between @df and @dt  
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.branch_cd='PTN' and a.sauda_Date between @df and @dt     
and tradetype not like '__F'    
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process4a
-- --------------------------------------------------
CREATE procedure [dbo].[process4a](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))    
as    
drop table temp_broka    
select b.sub_broker, a.party_code,b.short_name,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,    
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),    
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),    
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),    
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),    
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_broka    
from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, intranet.risk.dbo.bse_client1 b, intranet.risk.dbo.bse_client2 c    
where c.party_Code=a.party_code and c.cl_code=b.cl_code and b.branch_cd=@sname and a.sauda_Date between @df and @dt    
and a.party_code=@mcode and tradetype not like '__F'     
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process5
-- --------------------------------------------------

CREATE procedure [dbo].[process5](@sname as varchar(10),@df as datetime, @dt as datetime)    
as    
drop table temp_brok    
select sub_broker=b.pmscode, a.party_code,short_name=b.clientname,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,    
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),    
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),    
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),    
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),    
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_brok    
from AngelNseCM.msajag.dbo.cmbillvalan a, clientmast b    
--where b.clientid=a.party_code and b.pmscode=@sname and a.sauda_Date between @df and @dt    
where b.clientid=a.party_code and b.pmscode='PTN' and a.sauda_Date between @df and @dt    
and tradetype not like '__F'  
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process5a
-- --------------------------------------------------



CREATE procedure [dbo].[process5a](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))
as
drop table temp_broka
select sub_broker=b.pmscode, a.party_code,short_name=b.clientname,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_broka
from AngelNseCM.msajag.dbo.cmbillvalan a, clientmast b
where b.clientid=a.party_code and b.pmscode=@sname and a.sauda_Date between @df and @dt
and a.party_code=@mcode and tradetype not like '__F'  
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process5af
-- --------------------------------------------------
CREATE procedure [dbo].[process5af](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))
as
drop table temp_broka
select a.sub_broker, a.party_code,party_name as short_name,scrip_cd=(ltrim(rtrim(symbol))+'-'+left(ltrim(rtrim(expirydate)),11)),series=(ltrim(rtrim(inst_type))+' '+ltrim(rtrim(option_type))),
sauda_date,pqty as pqtytrd,sqty as sqtytrd,0 as pqtydel,0 as sqtydel,pbrokamt as Pbroktrd,sbrokamt as Sbroktrd,0 as pbrokdel,0 as sbrokdel,
Strike_Price+prate as ptrate, Strike_Price+srate as strate, 0 as sdrate,0 as pdrate,ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),
ndbrok=convert(money,0.00) into temp_broka
from angelfo.nsefo.dbo.fobillvalan a, clientmast b
where b.clientid=a.party_code and b.pmscode=@sname and a.sauda_Date between @df and @dt
and a.party_code=@mcode and pbrokamt+sbrokamt > 0
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process5f
-- --------------------------------------------------
CREATE procedure [dbo].[process5f](@sname as varchar(10),@df as datetime, @dt as datetime)
as
drop table temp_brok
select a.sub_broker, a.party_code,party_name as short_name,scrip_cd=(ltrim(rtrim(symbol))+' '+left(ltrim(rtrim(expirydate)),10)),series=(ltrim(rtrim(inst_type))+' '+ltrim(rtrim(option_type))),
sauda_date,pqty as pqtytrd,sqty as sqtytrd,0 as pqtydel,0 as sqtydel,pbrokamt as Pbroktrd,sbrokamt as Sbroktrd,0 as pbrokdel,0 as sbrokdel,
Strike_Price+prate as ptrate, Strike_Price+srate as strate, 0 as sdrate,0 as pdrate,ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),
ndbrok=convert(money,0.00) into temp_brok
from angelfo.nsefo.dbo.fobillvalan a, clientmast b
where b.clientid=a.party_code and b.pmscode=@sname and a.sauda_Date between @df and @dt
and pbrokamt+sbrokamt > 0
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process6
-- --------------------------------------------------
CREATE procedure [dbo].[process6](@sname as varchar(10),@df as datetime, @dt as datetime)  
as  
drop table temp_brok  
select sub_broker=b.pmscode, a.party_code,short_name=b.clientname,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,  
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),  
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),  
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),  
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),  
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_brok  
from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, clientmast b  
where b.clientid=a.party_code and b.pmscode=@sname and a.sauda_Date between @df and @dt  
and tradetype not like '__F'
order by a.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.process6a
-- --------------------------------------------------

CREATE procedure [dbo].[process6a](@sname as varchar(10),@df as datetime, @dt as datetime, @mcode as varchar(10))
as
drop table temp_broka
select sub_broker=b.pmscode, a.party_code,short_name=b.clientname,scrip_cd,series,sauda_date,pqtytrd,sqtytrd,pqtydel,sqtydel,Pbroktrd,Sbroktrd,pbrokdel,sbrokdel,
ptrate=(case when pqtytrd > 0 then ((pamttrd-pbroktrd)/pqtytrd) else 0 end),
strate=(case when sqtytrd > 0 then ((samttrd+sbroktrd)/sqtytrd) else 0 end),
sdrate=(case when sqtydel > 0 then ((samtdel+sbrokdel)/sqtydel) else 0 end),
pdrate=(Case when pqtydel > 0 then ((pamtdel-pbrokdel)/pqtydel) else 0 end),
ntbrok=convert(money,0.00),nsbrok=convert(money,0.00),ndbrok=convert(money,0.00) into temp_broka
from AngelBSECM.bsedb_ab.dbo.cmbillvalan a, clientmast b
where b.clientid=a.party_code and b.pmscode=@sname and a.sauda_Date between @df and @dt
and a.party_code=@mcode and tradetype not like '__F'  
order by a.party_code

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
-- PROCEDURE dbo.roi_plat
-- --------------------------------------------------

CREATE proc [dbo].[roi_plat]
(
@sb_name as varchar(200),
@frm_date as datetime,--varchar(50),
@to_date as datetime,--varchar(50),
@frm_a_date as datetime,--varchar(50),
@to_a_date as datetime--varchar(50),
)
as

drop table sb_list
select distinct sub_broker, name 
into sb_list
from intranet.risk.dbo.subbrokers group by name,sub_broker order by sub_broker

--select * from sb_list

select b.name as SB_NAME,
sum(brok_earned) as ANNUAL_BROKERAGE,
AVG_BROKERAGE = (sum(brok_earned) / Datediff(Day,@frm_a_date,@to_a_date))
into #sum_abrk
from mis.remisior.dbo.bsecm_sb a
left outer join 
intranet.risk.dbo.subbrokers b
on a.subbrokcode = b.sub_broker
where a.subbrokcode in (select sub_broker from sb_list where name = @sb_name)
and a.sauda_date >=@frm_a_date
and a.sauda_date <=@to_a_date
group by 
b.name


--select top 5 * from mis.remisior.dbo.bsecm_sb

select b.name as SB_NAME,
LAST_QTR_BROKERAGE = sum(brok_earned) 
into #sum_lqbrk
from mis.remisior.dbo.bsecm_sb a
left outer join 
intranet.risk.dbo.subbrokers b
on a.subbrokcode = b.sub_broker
where a.subbrokcode in (select sub_broker from sb_list where name = @sb_name)
and a.sauda_date >=@frm_date
and a.sauda_date <=@to_date
group by b.name


select 
a.sub_broker as SUB_BROKER, c.SB_NAME,c.ANNUAL_BROKERAGE,c.AVG_BROKERAGE,c.LAST_QTR_BROKERAGE, c.TOTAL_NO
from 
(select distinct SUB_BROKER = remissor.dbo.multi_sbtag_List(name),name from sb_list) a

right outer Join

(select a.SB_NAME,a.ANNUAL_BROKERAGE,a.AVG_BROKERAGE,b.LAST_QTR_BROKERAGE, 
TOTAL_NO = (select count(*) from intranet.risk.dbo.client_details
 where sub_broker in (select sub_broker from sb_list where name = a.SB_name)
) from #sum_abrk a, #sum_lqbrk b where a.SB_NAME = b.SB_NAME) c

on a.name = c.SB_NAME

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.roi_plat_all
-- --------------------------------------------------


--exec roi_plat_all '2006-12-26','2007-03-24','2006-04-01','2007-03-31' 

CREATE proc [dbo].[roi_plat_all]
(
@qtr_strt as datetime,
@qtr_end as datetime,
@fin_yearstrt as datetime,
@fin_yearend as datetime
)
as
/*
declare @qtr_strt as datetime, @qtr_end as datetime
set @qtr_strt = '2006-12-26'
set @qtr_end = '2007-03-24'

declare @fin_yearstrt as datetime,@fin_yearend as datetime  
set @fin_yearstrt = '2006-04-01'
set @fin_yearend = '2007-03-31'
*/

/*
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)   
where sdtcur <=getdate() and ldtcur >=getdate() 
*/

/*
drop table sb_list
select distinct sub_broker, name 
into sb_list
from intranet.risk.dbo.subbrokers
where sub_broker not in (select sbtag from reject_list)
 group by name,sub_broker order by sub_broker
*/

declare @totaldays numeric(25,2), @totaldays2 numeric(25,2)
set @totaldays = Datediff(Day,@fin_yearstrt,@fin_yearend)
set @totaldays2 = Datediff(Day,@qtr_strt,@qtr_end)

/*
select b.sub_broker,
convert(numeric(25,2),sum(brokerage)) as ANNUAL_BROKERAGE,
AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays)),
AVG_TURNOVER = convert(numeric(25,2),(sum(turnover) / @totaldays))
into #sum_abrk
from bsedb_ab.dbo.mis_to_sb a
right outer join 
risk.dbo.sb_list b
--intranet.risk.dbo.subbrokers b
on a.sub_broker = b.sub_broker
where
a.sauda_date >=@fin_yearstrt--@frm_a_date
and a.sauda_date <=@fin_yearend--@to_a_date
and a.sub_broker not in (select sbtag from remissor.dbo.reject_list)
and a.sub_broker='AAK'
group by
b.sub_broker
*/

select 
--b.sbname as SB_NAME,
 b.sub_broker,
convert(numeric(25,2),sum(brokerage)) as ANNUAL_BROKERAGE,
AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays)),
AVG_TURNOVER = convert(numeric(25,2),(sum(turnover) / @totaldays))
into #sum_abrk
from bsedb_ab.dbo.mis_to_sb a
right outer join 
sb_list b
--intranet.risk.dbo.subbrokers b
on a.sub_broker = b.sub_broker
where
a.sauda_date >=@fin_yearstrt--@frm_a_date
and a.sauda_date <=@fin_yearend--@to_a_date
and a.sub_broker not in (select sbtag from remissor.dbo.reject_list)
group by
b.sub_broker
--,b.sbname

--select * from #sum_abrk order by sub_broker
--drop table  #sum_abrk

select --b.sbname as SB_NAME, 
b.sub_broker,
LAST_QTR_BROKERAGE = convert(numeric(25,2),sum(brokerage)) 
into #sum_lqbrk
from bsedb_ab.dbo.mis_to_sb a
right outer join 
sb_list b
--intranet.risk.dbo.subbrokers b
on a.sub_broker = b.sub_broker
where 
a.sauda_date >=@qtr_strt
and a.sauda_date <=@qtr_end
and a.sub_broker not in (select sbtag from remissor.dbo.reject_list)
group by b.sub_broker
--,b.sbname

--select * from #sum_lqbrk ORDER BY SUB_BROKER
--drop table #sum_lqbrk

--drop table #sb_cli_list

select sub_broker, 
total = count(long_name)
into
#sb_cli_list
from intranet.risk.dbo.client_details a
where sub_broker in (select distinct(sub_broker) from sb_list)
group by sub_broker

-- select * from #sb_cli_list

select a.sub_broker as SUB_BROKER, 
--c.Sub_broker,
a.name as sbname,
c.ANNUAL_BROKERAGE,c.LAST_QTR_BROKERAGE, c.TOTAL_NO, c.AVG_TURNOVER,c.AVG_BROKERAGE
into 
#sb_final
from 
--(select distinct SUB_BROKER = remissor.dbo.multi_sbtag_List(sbname),sbname from risk.dbo.sb_list) a
(select * from sb_list) a
right outer Join
(select --a.SB_NAME,
a.sub_broker,a.ANNUAL_BROKERAGE,a.AVG_BROKERAGE,a.AVG_TURNOVER,b.LAST_QTR_BROKERAGE, 
TOTAL_NO = isnull(
(select sum(total) from #sb_cli_list where sub_broker in	
	(select sub_broker from risk.dbo.sb_list where sub_broker = a.sub_broker)),0--sbname = a.SB_name)),0
)
 from #sum_abrk a, #sum_lqbrk b where a.Sub_broker = b.Sub_broker) c--a.SB_NAME = b.SB_NAME) c
on a.sub_broker = c.sub_broker--a.sbname = c.SB_NAME
order by c.sub_broker--a.sub_broker

--select * from #sum_lqbrk where sb_name='A K FINANCIAL AND ADVISOR'

select * from #sb_final 
--where sub_broker='AKFS' or sub_broker='AKF' 
--order by sub_broker

-- calc sb_ledger
-- drop table #sb_final

/*
exec calc_sb_ledger

select a.*,isnull(convert(numeric(25,2),b.amount),0) as 'TOTAL LEDGER' from #sb_final a
left outer join
sb_ledger b
on a.sb_name = b.acname

drop table sb_ledger
*/
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.roi_plat_all_fin
-- --------------------------------------------------
  
--exec roi_plat_all_fin '2006-12-26','2007-04-24','2007-04-01','2008-03-31'   
  
  
CREATE proc [dbo].[roi_plat_all_fin]  
(  
@qtr_strt as datetime,  
@qtr_end as datetime,  
@fin_yearstrt as datetime,  
@fin_yearend as datetime  
)  
as  
 
/*  
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)     
where sdtcur <=getdate() and ldtcur >=getdate()   
*/  
  
/*  
drop table sb_list  
select distinct sub_broker, name   
into sb_list  
from intranet.risk.dbo.subbrokers  
where sub_broker not in (select sbtag from reject_list)  
 group by name,sub_broker order by sub_broker  


*/  
/*
declare @qtr_strt as datetime, @qtr_end as datetime  
set @qtr_strt = '2006-12-26'  
set @qtr_end = '2007-04-24'  
  
declare @fin_yearstrt as datetime,@fin_yearend as datetime    
set @fin_yearstrt = '2007-03-01'  
set @fin_yearend  ='2008-04-30'  

*/  
declare @totaldays numeric(25,2), @totaldays2 numeric(25,2)  
set @totaldays = Datediff(Day,@fin_yearstrt,@fin_yearend)  
set @totaldays2 = Datediff(Day,@qtr_strt,@qtr_end)  
  

select   
 b.sub_broker,  
convert(numeric(25,2),sum(brokerage)) as ANNUAL_BROKERAGE  
--AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays)),  
into #sum_abrk  
from bsedb_ab.dbo.mis_to_sb a  
right outer join   
--risk.dbo.sb_list b  
sb_list b
on a.sub_broker = b.sub_broker  
where  
a.sauda_date >=@fin_yearstrt  
and a.sauda_date <=@fin_yearend  
and a.sub_broker not in (select sbtag from remissor.dbo.reject_list)  
group by  
b.sub_broker  
  

--select * from #sum_abrk where sub_broker='NS' order by sub_broker  
--drop table  #sum_abrk  
  
select  
b.sub_broker,  
LAST_QTR_BROKERAGE = convert(numeric(25,2),sum(brokerage)),  
AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays2)),  
AVG_TURNOVER = convert(numeric(25,2),(sum(turnover) / @totaldays2))   
into #sum_lqbrk  
from bsedb_ab.dbo.mis_to_sb a  
right outer join   
--risk.dbo.sb_list b  
sb_list b
on a.sub_broker = b.sub_broker  
where   
a.sauda_date >=@qtr_strt  
and a.sauda_date <=@qtr_end  
and a.sub_broker not in (select sbtag from remissor.dbo.reject_list)  
group by b.sub_broker  
  
  
--select * from #sum_lqbrk where sub_broker='NS' ORDER BY SUB_BROKER  
--drop table #sum_lqbrk  
  
--drop table #sb_cli_list  
  
select sub_broker,   
total = count(long_name)  
into  
#sb_cli_list  
from intranet.risk.dbo.client_details a  
where sub_broker in (select distinct(sub_broker) from sb_list ) --risk.dbo.sb_list)  
group by sub_broker  
  
-- select * from #sb_cli_list  
  
select a.sub_broker as SUB_BROKER,a.NAME as SBNAME,   
c.ANNUAL_BROKERAGE,c.LAST_QTR_BROKERAGE, c.TOTAL_NO, c.AVG_TURNOVER,c.AVG_BROKERAGE  
into   
#sb_final  
from  
(select * from sb_list) a  
right outer join  
(  
select a.sub_broker,a.ANNUAL_BROKERAGE,isnull(b.AVG_TURNOVER,0) as AVG_TURNOVER,isnull(b.LAST_QTR_BROKERAGE,0) as LAST_QTR_BROKERAGE,isnull(b.AVG_BROKERAGE,0) as AVG_BROKERAGE,  
TOTAL_NO = isnull(  
(select total from #sb_cli_list where sub_broker =a.sub_broker  
--in (select sub_broker from risk.dbo.sb_list where sub_broker = a.sub_broker)  
),0 --sbname = a.SB_name)),0  
)   
from #sum_abrk a  
left outer join  
#sum_lqbrk b   
on a.Sub_broker = b.Sub_broker  
) c  
  
on a.sub_broker = c.sub_broker  
order by c.sub_broker  
  
select * from #sb_final   
--where sub_broker='NS'  
-- drop table #sb_final  
  
  
  
/*  
select a.sub_broker as SUB_BROKER,a.SBNAME,  
c.ANNUAL_BROKERAGE,c.LAST_QTR_BROKERAGE, c.TOTAL_NO, c.AVG_TURNOVER,c.AVG_BROKERAGE  
into   
#sb_final  
from   
--(select distinct SUB_BROKER = remissor.dbo.multi_sbtag_List(sbname),sbname from risk.dbo.sb_list) a  
(select * from risk.dbo.sb_list) a  
right outer Join  
(select a.sub_broker,a.ANNUAL_BROKERAGE,a.AVG_BROKERAGE,a.AVG_TURNOVER,b.LAST_QTR_BROKERAGE,   
TOTAL_NO = isnull(  
(select sum(total) from #sb_cli_list where sub_broker in   
 (select sub_broker from risk.dbo.sb_list where sub_broker = a.sub_broker)),0--sbname = a.SB_name)),0  
)  
 from #sum_abrk a, #sum_lqbrk b where a.Sub_broker = b.Sub_broker) c--a.SB_NAME = b.SB_NAME) c  
on a.sub_broker = c.sub_broker  
order by c.sub_broker  
  
  
select * from #sb_final   
*/  
  
  
  
  
/*  
exec calc_sb_ledger  
  
select a.*,isnull(convert(numeric(25,2),b.amount),0) as 'TOTAL LEDGER' from #sb_final a  
left outer join  
sb_ledger b  
on a.sb_name = b.acname  
  
drop table sb_ledger  
*/  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.roi_plat_all_report
-- --------------------------------------------------
CREATE proc [dbo].[roi_plat_all_report]  
(  
@frm_date as datetime,  
@to_date as datetime,  
@frm_a_date as datetime,  
@to_a_date as datetime  
)  
as  
  
/*  
exec roi_plat_all '2006-12-26','2007-03-24','2007-01-01','2007-12-31'  
declare @frm_date as datetime, @to_date as datetime  
set @frm_date = '2006-12-26'  
set @to_date = '2007-03-24'  
declare @totaldays numeric(25,2), @totaldays2 numeric(25,2)  
--set @totaldays = Datediff(Day,@acyearfrom,@acyearto)  
set @totaldays2 = Datediff(Day,@frm_date,@to_date)  
print @totaldays2  
*/  
  
declare @acyearfrom as datetime,@acyearto as datetime    
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)     
where sdtcur <=getdate() and ldtcur >=getdate()   
  
declare @totaldays numeric(25,2), @totaldays2 numeric(25,2)  
set @totaldays = Datediff(Day,@acyearfrom,@acyearto)  
set @totaldays2 = Datediff(Day,@frm_date,@to_date)  
  
drop table sb_list  
  
select distinct sub_broker, name   
into sb_list  
from intranet.risk.dbo.subbrokers  
where sub_broker not in (select sbtag from reject_list)  
 group by name,sub_broker order by sub_broker  
  
/*  
  
select b.name as SB_NAME,  
AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays2))  
into #sumbrk  
from bsedb_ab.dbo.mis_to_sb a  
left outer join   
sb_list b  
--intranet.risk.dbo.subbrokers b  
on a.sub_broker = b.sub_broker  
where  
a.sauda_date >=@frm_date  
and a.sauda_date <=@to_date  
group by   
b.name  
  
  
select * from #sumbrk order by sb_name */  
  
  
--select * from reject_list  
  
--select * from sb_list  
  
  
  
  
select b.name as SB_NAME,  
convert(numeric(25,2),sum(brokerage)) as ANNUAL_BROKERAGE,  
AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays)),  
AVG_TURNOVER = convert(numeric(25,2),(sum(turnover) / @totaldays))  
into #sum_abrk  
from bsedb_ab.dbo.mis_to_sb a  
left outer join   
sb_list b  
--intranet.risk.dbo.subbrokers b  
on a.sub_broker = b.sub_broker  
where  
a.sauda_date >=@acyearfrom--@frm_a_date  
and a.sauda_date <=@acyearto--@to_a_date  
--and a.sub_broker not in (select sbtag from reject_list)  
group by   
b.name  
  
--select * from #sum_abrk  
--drop table  #sum_abrk  
  
select b.name as SB_NAME,  
LAST_QTR_BROKERAGE = convert(numeric(25,2),sum(brokerage))   
into #sum_lqbrk  
from bsedb_ab.dbo.mis_to_sb a  
left outer join   
sb_list b  
--intranet.risk.dbo.subbrokers b  
on a.sub_broker = b.sub_broker  
where   
a.sauda_date >=@frm_date  
and a.sauda_date <=@to_date  
--and a.sub_broker not in (select sbtag from reject_list)  
group by b.name  
  
  
  
select sub_broker,   
total = count(long_name)  
into  
#sb_cli_list  
from intranet.risk.dbo.client_details a  
where sub_broker in (select distinct(sub_broker) from sb_list)  
group by sub_broker  
  
  
  
select   
a.sub_broker as SUB_BROKER, c.SB_NAME,c.ANNUAL_BROKERAGE,c.LAST_QTR_BROKERAGE, c.TOTAL_NO, c.AVG_TURNOVER,c.AVG_BROKERAGE  
into   
#sb_final  
from   
(select distinct SUB_BROKER = remissor.dbo.multi_sbtag_List(name),name from sb_list) a  
right outer Join  
(select a.SB_NAME,a.ANNUAL_BROKERAGE,a.AVG_BROKERAGE,a.AVG_TURNOVER,b.LAST_QTR_BROKERAGE,   
TOTAL_NO = isnull((select sum(total) from #sb_cli_list where sub_broker in   
     (select sub_broker from sb_list where name = a.SB_name)),0)  
--TOTAL_NO = (select count(*) from intranet.risk.dbo.client_details  
-- where sub_broker in (select sub_broker from sb_list where name = a.SB_name)  
 from #sum_abrk a, #sum_lqbrk b where a.SB_NAME = b.SB_NAME) c  
on a.name = c.SB_NAME  
order by a.sub_broker  
  
  
select *,convert(numeric(25,2),((annual_brokerage-last_qtr_brokerage-avg_turnover)/90)) as AVERAGE_FUNDS_UTILIZATION 

from #sb_final  
  

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.roi_plat_all2
-- --------------------------------------------------

create proc [dbo].[roi_plat_all2]
(
@frm_date as datetime,
@to_date as datetime,
@frm_a_date as datetime,
@to_a_date as datetime
)
as

/*
exec roi_plat_all '2006-12-26','2007-03-24','2007-01-01','2007-12-31'
declare @frm_date as datetime, @to_date as datetime
set @frm_date = '2006-12-26'
set @to_date = '2007-03-24'
*/

declare @acyearfrom as datetime,@acyearto as datetime  
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)   
where sdtcur <=getdate() and ldtcur >=getdate() 

declare @totaldays numeric(25,2)
set @totaldays = Datediff(Day,@acyearfrom,@acyearto)

drop table sb_list

select distinct sub_broker, name 
into sb_list
from intranet.risk.dbo.subbrokers
--where sub_broker not in (select sbtag from reject_list)
 group by name,sub_broker order by sub_broker


--select * from reject_list

--select * from sb_list


select b.name as SB_NAME,
convert(numeric(25,2),sum(brokerage)) as ANNUAL_BROKERAGE,
AVG_BROKERAGE = convert(numeric(25,2),(sum(brokerage) / @totaldays)),
AVG_TURNOVER = convert(numeric(25,2),(sum(turnover) / @totaldays))
into #sum_abrk
from bsedb_ab.dbo.mis_to_sb a
left outer join 
--sb_list b
intranet.risk.dbo.subbrokers b
on a.sub_broker = b.sub_broker
where
a.sauda_date >=@acyearfrom--@frm_a_date
and a.sauda_date <=@acyearto--@to_a_date
--and a.sub_broker not in (select sbtag from reject_list)
group by 
b.name

--select * from #sum_abrk
--drop table  #sum_abrk

select b.name as SB_NAME,
LAST_QTR_BROKERAGE = convert(numeric(25,2),sum(brokerage)) 
into #sum_lqbrk
from bsedb_ab.dbo.mis_to_sb a
left outer join 
--sb_list b
intranet.risk.dbo.subbrokers b
on a.sub_broker = b.sub_broker
where 
a.sauda_date >=@frm_date
and a.sauda_date <=@to_date
--and a.sub_broker not in (select sbtag from reject_list)
group by b.name



select sub_broker, 
total = count(long_name)
into
#sb_cli_list
from intranet.risk.dbo.client_details a
where sub_broker in (select distinct(sub_broker) from sb_list)
group by sub_broker



select 
a.sub_broker as SUB_BROKER, c.SB_NAME,c.ANNUAL_BROKERAGE,c.LAST_QTR_BROKERAGE, c.TOTAL_NO, c.AVG_TURNOVER,c.AVG_BROKERAGE
into 
#sb_final
from 
(select distinct SUB_BROKER = remissor.dbo.multi_sbtag_List(name),name from sb_list) a

right outer Join

(select a.SB_NAME,a.ANNUAL_BROKERAGE,a.AVG_BROKERAGE,a.AVG_TURNOVER,b.LAST_QTR_BROKERAGE, 
TOTAL_NO = isnull((select sum(total) from #sb_cli_list where sub_broker in	
					(select sub_broker from sb_list where name = a.SB_name)),0)
--TOTAL_NO = (select count(*) from intranet.risk.dbo.client_details
-- where sub_broker in (select sub_broker from sb_list where name = a.SB_name)
 from #sum_abrk a, #sum_lqbrk b where a.SB_NAME = b.SB_NAME) c

on a.name = c.SB_NAME
order by a.sub_broker


select * from #sb_final

-- calc sb_ledger
/*exec calc_sb_ledger

select a.*,isnull(b.amount,0) as 'TOTAL LEDGER' from #sb_final a
left outer join
sb_ledger b
on a.sb_name = b.acname
*/

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_SMTPMail
-- --------------------------------------------------
Create Procedure sp_SMTPMail

	@SenderName varchar(100),
	@SenderAddress varchar(100),
	@RecipientName varchar(100),
	@RecipientAddress varchar(100),
	@Subject varchar(200),
	@Body varchar(8000),
	@MailServer varchar(100) = '196.1.115.136'

	AS	
	
	SET nocount on
	
	declare @oMail int --Object reference
	declare @resultcode int
	
	EXEC @resultcode = sp_OACreate 'SMTPsvg.Mailer', @oMail OUT
	
	if @resultcode = 0
	BEGIN
		EXEC @resultcode = sp_OASetProperty @oMail, 'RemoteHost', @mailserver
		EXEC @resultcode = sp_OASetProperty @oMail, 'FromName', @SenderName
		EXEC @resultcode = sp_OASetProperty @oMail, 'FromAddress', @SenderAddress
	
		EXEC @resultcode = sp_OAMethod @oMail, 'AddRecipient', NULL, @RecipientName, @RecipientAddress
	
		EXEC @resultcode = sp_OASetProperty @oMail, 'Subject', @Subject
		EXEC @resultcode = sp_OASetProperty @oMail, 'BodyText', @Body
	
	
		EXEC @resultcode = sp_OAMethod @oMail, 'SendMail', NULL
	
		EXEC sp_OADestroy @oMail
	END	
	

	SET nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sp_SysObj
-- --------------------------------------------------

/*  
Author :- Prashant  
Date :- 28/01/2011  
*/  
CREATE Procedure Sp_SysObj  
(  
 @objName as varchar(20),  
 @objType as varchar(3)=''  
)  
as  
Begin  
 select * from sysobjects where name like '%'+@objName+'%' and type like '%'+@objType+'%'--'%batch%'  
 order by name,type  
End

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
-- TABLE dbo.brokslab
-- --------------------------------------------------
CREATE TABLE [dbo].[brokslab]
(
    [code] VARCHAR(15) NULL,
    [company] VARCHAR(10) NULL,
    [Rem_type] VARCHAR(25) NULL,
    [Brok_type] VARCHAR(10) NULL,
    [fromRs] MONEY NULL,
    [toRs] MONEY NULL,
    [slab] FLOAT NULL,
    [pr] VARCHAR(10) NULL,
    [dummy1] VARCHAR(10) NULL,
    [dummy2] VARCHAR(10) NULL,
    [dummy3] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.brokslab_temp_May4
-- --------------------------------------------------
CREATE TABLE [dbo].[brokslab_temp_May4]
(
    [code] VARCHAR(15) NULL,
    [company] VARCHAR(10) NULL,
    [Rem_type] VARCHAR(25) NULL,
    [Brok_type] VARCHAR(10) NULL,
    [fromRs] MONEY NULL,
    [toRs] MONEY NULL,
    [slab] FLOAT NULL,
    [pr] VARCHAR(10) NULL,
    [dummy1] VARCHAR(10) NULL,
    [dummy2] VARCHAR(10) NULL,
    [dummy3] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bslab
-- --------------------------------------------------
CREATE TABLE [dbo].[bslab]
(
    [code] VARCHAR(15) NULL,
    [company] VARCHAR(10) NULL,
    [Rem_type] VARCHAR(25) NULL,
    [Brok_type] VARCHAR(10) NULL,
    [fromRs] MONEY NULL,
    [toRs] MONEY NULL,
    [slab] FLOAT NULL,
    [pr] VARCHAR(10) NULL,
    [dummy1] VARCHAR(10) NULL,
    [dummy2] VARCHAR(10) NULL,
    [dummy3] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bslabscdl
-- --------------------------------------------------
CREATE TABLE [dbo].[bslabscdl]
(
    [code] VARCHAR(15) NULL,
    [company] VARCHAR(10) NULL,
    [Rem_type] VARCHAR(25) NULL,
    [Brok_type] VARCHAR(10) NULL,
    [fromRs] MONEY NULL,
    [toRs] MONEY NULL,
    [slab] FLOAT NULL,
    [pr] VARCHAR(10) NULL,
    [dummy1] VARCHAR(10) NULL,
    [dummy2] VARCHAR(10) NULL,
    [dummy3] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C01NOV2010_6_09_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C01NOV2010_6_09_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03APR2004_12_22_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03APR2004_12_22_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03APR2004_12_23_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03APR2004_12_23_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03APR2004_12_24_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03APR2004_12_24_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03AUG2004_8_26_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03AUG2004_8_26_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03AUG2004_9_38_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03AUG2004_9_38_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03MAY2004_3_37_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03MAY2004_3_37_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03MAY2004_3_57_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03MAY2004_3_57_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03MAY2004_4_09_00_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03MAY2004_4_09_00_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03MAY2004_4_13_00_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03MAY2004_4_13_00_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C03NOV2004_10_25_45_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C03NOV2004_10_25_45_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04AUG2004_7_23_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04AUG2004_7_23_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04AUG2004_7_37_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04AUG2004_7_37_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04AUG2004_7_48_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04AUG2004_7_48_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04AUG2004_8_23_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04AUG2004_8_23_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04AUG2004_8_31_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04AUG2004_8_31_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04MAY2004_3_08_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04MAY2004_3_08_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C04MAY2004_3_08_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C04MAY2004_3_08_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C05SEP2004_5_53_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C05SEP2004_5_53_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_31_40_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_31_40_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_32_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_32_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_37_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_37_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_47_43_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_47_43_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_49_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_49_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_50_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_50_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_52_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_52_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_5_52_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_5_52_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_6_17_17_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_6_17_17_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAR2004_6_18_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAR2004_6_18_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_3_55_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_3_55_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_3_56_34_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_3_56_34_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_3_59_00_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_3_59_00_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_3_59_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_3_59_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_4_00_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_4_00_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_4_00_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_4_00_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_4_01_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_4_01_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_4_02_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_4_02_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_4_09_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_4_09_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C06MAY2004_4_11_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C06MAY2004_4_11_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2004_3_19_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2004_3_19_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_1_20_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_1_20_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_1_21_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_1_21_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_33_40_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_33_40_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_35_01_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_35_01_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_43_26_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_43_26_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_06_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_06_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_15_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_15_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_16_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_16_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_17_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_17_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_18_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_18_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_19_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_19_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_20_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_20_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_21_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_21_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_22_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_22_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_23_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_23_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_50_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_50_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_53_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_53_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_54_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_54_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_55_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_55_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_52_56_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_52_56_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_23_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_23_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_26_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_26_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_27_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_27_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_28_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_28_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_29_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_29_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_56_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_56_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_53_59_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_53_59_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_54_33_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_54_33_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_54_34_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_54_34_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_55_06_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_55_06_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_55_39_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_55_39_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_56_12_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_56_12_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_56_45_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_56_45_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_57_18_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_57_18_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_57_51_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_57_51_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_58_23_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_58_23_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_58_57_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_58_57_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_58_59_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_58_59_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_59_29_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_59_29_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_11_59_38_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_11_59_38_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_00_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_00_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_00_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_00_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_01_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_01_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_01_42_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_01_42_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_01_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_01_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_02_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_02_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_02_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_02_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_02_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_02_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_03_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_03_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_03_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_03_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_03_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_03_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_03_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_03_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_04_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_04_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_18_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_18_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_56_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_56_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_07_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_07_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_08_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_08_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_08_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_08_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_08_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_08_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_08_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_08_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_08_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_08_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_14_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_14_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_17_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_17_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_18_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_18_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_56_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_56_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_09_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_09_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_33_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_33_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_43_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_43_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_10_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_10_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_02_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_02_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_05_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_05_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_34_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_34_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_35_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_35_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_38_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_38_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_11_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_11_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_05_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_05_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_38_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_38_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_40_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_40_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_45_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_45_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_12_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_12_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_13_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_13_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_13_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_13_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_13_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_13_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_13_17_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_13_17_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_14_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_14_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_02_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_02_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_35_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_35_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_15_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_15_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_45_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_45_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_16_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_16_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_17_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_17_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_17_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_17_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_17_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_17_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_17_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_17_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_18_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_18_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_18_08_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_18_08_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_18_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_18_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_18_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_18_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_33_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_33_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_34_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_34_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_35_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_35_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_19_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_19_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_05_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_05_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_06_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_06_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_14_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_14_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_43_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_43_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_20_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_20_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_56_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_56_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_21_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_21_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_22_35_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_22_35_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_22_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_22_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_22_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_22_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_22_38_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_22_38_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_14_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_14_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_17_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_17_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_18_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_18_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_23_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_23_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_24_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_24_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_24_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_24_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_25_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_25_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_31_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_31_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_00_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_00_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_06_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_06_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_18_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_18_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_33_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_33_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_40_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_40_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_45_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_45_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_56_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_56_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_32_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_32_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_14_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_14_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_18_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_18_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_34_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_34_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_33_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_33_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_12_34_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_12_34_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_2_43_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_2_43_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_2_43_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_2_43_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_2_43_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_2_43_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_2_44_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_2_44_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_3_14_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_3_14_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07APR2011_3_29_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07APR2011_3_29_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07MAY2004_6_37_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07MAY2004_6_37_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07MAY2004_6_37_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07MAY2004_6_37_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07MAY2004_6_38_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07MAY2004_6_38_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07MAY2004_6_41_08_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07MAY2004_6_41_08_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07MAY2004_7_19_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07MAY2004_7_19_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C07MAY2005_3_46_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C07MAY2005_3_46_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_1_09_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_1_09_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_1_10_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_1_10_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_1_10_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_1_10_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_1_11_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_1_11_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_1_12_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_1_12_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_1_16_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_1_16_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_11_46_30_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_11_46_30_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_11_47_00_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_11_47_00_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_12_51_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_12_51_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_2_33_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_2_33_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_2_33_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_2_33_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_2_41_56_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_2_41_56_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_17_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_17_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_19_45_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_19_45_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_22_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_22_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_24_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_24_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_41_00_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_41_00_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_44_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_44_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_49_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_49_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_3_49_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_3_49_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_07_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_07_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_11_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_11_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_29_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_29_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_30_40_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_30_40_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_34_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_34_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_36_26_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_36_26_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_38_42_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_38_42_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_39_19_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_39_19_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_39_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_39_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_40_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_40_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_43_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_43_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_45_05_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_45_05_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_45_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_45_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_45_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_45_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_46_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_46_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_46_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_46_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_46_40_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_46_40_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_46_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_46_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_4_53_43_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_4_53_43_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_26_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_26_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_28_08_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_28_08_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_28_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_28_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_31_35_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_31_35_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_32_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_32_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_34_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_34_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_34_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_34_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_36_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_36_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_39_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_39_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_40_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_40_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_41_00_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_41_00_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_43_17_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_43_17_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_44_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_44_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_45_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_45_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_45_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_45_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_46_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_46_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_48_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_48_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_51_45_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_51_45_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_54_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_54_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_56_11_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_56_11_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_5_59_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_5_59_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_6_06_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_6_06_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_6_40_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_6_40_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_06_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_06_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_26_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_26_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_27_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_27_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_34_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_34_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_41_38_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_41_38_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_42_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_42_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C08MAY2004_7_50_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C08MAY2004_7_50_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C09MAY2004_2_53_01_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C09MAY2004_2_53_01_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAR2004_1_18_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAR2004_1_18_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAR2004_1_24_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAR2004_1_24_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_12_19_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_12_19_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_01_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_01_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_05_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_05_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_06_37_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_06_37_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_07_40_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_07_40_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_08_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_08_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_09_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_09_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_11_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_11_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_18_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_18_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_20_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_20_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_24_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_24_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_26_05_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_26_05_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_40_56_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_40_56_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_41_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_41_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_41_17_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_41_17_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_55_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_55_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_2_56_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_2_56_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_3_19_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_3_19_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_3_23_53_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_3_23_53_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_3_25_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_3_25_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_3_31_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_3_31_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_3_32_33_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_3_32_33_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_3_35_21_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_3_35_21_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10MAY2004_7_47_59_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10MAY2004_7_47_59_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_29_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_29_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_31_08_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_31_08_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_37_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_37_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_41_27_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_41_27_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_43_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_43_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_47_20_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_47_20_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_47_45_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_47_45_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_51_18_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_51_18_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_4_52_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_4_52_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_5_21_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_5_21_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_5_22_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_5_22_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C10NOV2004_5_42_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C10NOV2004_5_42_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C15FEB2005_3_36_55_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C15FEB2005_3_36_55_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C16MAR2004_6_30_58_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C16MAR2004_6_30_58_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C18MAY2004_1_20_43_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C18MAY2004_1_20_43_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C19AUG2004_12_44_01_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C19AUG2004_12_44_01_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C19MAR2004_11_05_43_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C19MAR2004_11_05_43_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C19MAR2004_11_06_34_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C19MAR2004_11_06_34_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20AUG2010_2_59_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20AUG2010_2_59_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20AUG2010_3_11_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20AUG2010_3_11_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20AUG2010_3_36_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20AUG2010_3_36_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20AUG2010_3_49_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20AUG2010_3_49_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20AUG2010_3_50_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20AUG2010_3_50_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20JUL2010_10_45_09_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20JUL2010_10_45_09_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20MAR2004_12_19_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20MAR2004_12_19_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20MAR2004_12_20_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20MAR2004_12_20_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C20MAR2004_5_20_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C20MAR2004_5_20_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_10_36_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_10_36_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_04_41_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_04_41_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_07_46_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_07_46_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_10_17_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_10_17_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_17_39_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_17_39_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_19_58_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_19_58_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_21_02_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_21_02_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_32_57_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_32_57_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_44_52_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_44_52_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_47_51_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_47_51_AM]
(
    [sub_broker] VARCHAR(15) NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_55_18_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_55_18_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_55_38_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_55_38_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C21SEP2004_9_56_22_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C21SEP2004_9_56_22_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C22MAR2004_10_59_59_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[C22MAR2004_10_59_59_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C22SEP2004_11_44_24_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C22SEP2004_11_44_24_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C23MAR2004_6_25_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C23MAR2004_6_25_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C23MAR2004_6_27_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C23MAR2004_6_27_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C23MAR2004_6_29_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C23MAR2004_6_29_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C26JUL2004_12_51_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C26JUL2004_12_51_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C26JUL2004_6_23_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C26JUL2004_6_23_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C26JUL2004_6_26_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C26JUL2004_6_26_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C27APR2004_5_14_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C27APR2004_5_14_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C27APR2004_6_48_33_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C27APR2004_6_48_33_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C27MAR2004_5_18_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C27MAR2004_5_18_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C28JUL2004_5_04_16_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C28JUL2004_5_04_16_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C29MAY2004_3_23_52_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C29MAY2004_3_23_52_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C29MAY2004_3_29_10_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C29MAY2004_3_29_10_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C29MAY2004_3_40_25_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C29MAY2004_3_40_25_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C29MAY2004_3_40_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C29MAY2004_3_40_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C29MAY2004_4_22_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C29MAY2004_4_22_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C29MAY2004_4_23_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[C29MAY2004_4_23_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

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
-- TABLE dbo.clientmast
-- --------------------------------------------------
CREATE TABLE [dbo].[clientmast]
(
    [pmscode] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(50) NULL
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
-- TABLE dbo.F03MAY2004_11_09_36_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_11_09_36_AM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_29_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_29_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_35_03_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_35_03_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_38_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_38_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_39_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_39_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_46_29_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_46_29_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_47_22_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_47_22_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_47_49_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_47_49_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_48_42_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_48_42_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_49_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_49_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_50_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_50_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_55_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_55_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_55_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_55_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_3_56_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_3_56_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_4_21_12_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_4_21_12_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_4_34_47_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_4_34_47_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_5_07_41_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_5_07_41_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_5_10_06_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_5_10_06_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_6_07_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_6_07_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F03MAY2004_6_56_39_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F03MAY2004_6_56_39_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F04MAY2004_3_07_46_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F04MAY2004_3_07_46_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAR2004_5_20_07_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAR2004_5_20_07_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAR2004_5_21_38_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAR2004_5_21_38_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAR2004_5_27_28_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAR2004_5_27_28_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAR2004_5_30_15_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAR2004_5_30_15_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAR2004_5_31_09_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAR2004_5_31_09_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAR2004_5_37_50_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAR2004_5_37_50_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAY2004_2_29_23_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAY2004_2_29_23_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAY2004_2_29_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAY2004_2_29_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAY2004_2_29_35_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAY2004_2_29_35_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F06MAY2004_2_29_44_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F06MAY2004_2_29_44_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F07APR2004_3_25_13_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F07APR2004_3_25_13_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F07APR2011_1_28_30_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F07APR2011_1_28_30_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F08MAY2004_7_54_48_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F08MAY2004_7_54_48_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F09MAY2004_12_58_08_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F09MAY2004_12_58_08_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F10MAY2004_7_50_32_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F10MAY2004_7_50_32_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F11MAY2004_12_36_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F11MAY2004_12_36_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F12MAY2004_1_18_36_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F12MAY2004_1_18_36_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F14MAY2004_12_27_43_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F14MAY2004_12_27_43_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F30APR2004_6_58_34_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F30APR2004_6_58_34_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F30APR2004_7_01_31_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F30APR2004_7_01_31_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F30APR2004_7_02_51_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F30APR2004_7_02_51_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F30APR2004_7_03_04_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F30APR2004_7_03_04_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F30APR2004_7_03_57_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F30APR2004_7_03_57_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F30APR2004_7_11_54_PM
-- --------------------------------------------------
CREATE TABLE [dbo].[F30APR2004_7_11_54_PM]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(23) NULL,
    [series] VARCHAR(9) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NOT NULL,
    [sqtydel] INT NOT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] INT NOT NULL,
    [sbrokdel] INT NOT NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] INT NOT NULL,
    [pdrate] INT NOT NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foclient
-- --------------------------------------------------
CREATE TABLE [dbo].[foclient]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] CHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [mark] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fosb
-- --------------------------------------------------
CREATE TABLE [dbo].[fosb]
(
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [NAME] VARCHAR(60) NULL,
    [mark] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Hod_Mapping
-- --------------------------------------------------
CREATE TABLE [dbo].[Hod_Mapping]
(
    [Hod_no] VARCHAR(25) NULL,
    [Hod_name] VARCHAR(80) NULL,
    [Department] VARCHAR(100) NULL
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
    [Subject] VARCHAR(50) NOT NULL,
    [Is_Checked] INT NULL,
    [CatName] VARCHAR(60) NULL,
    [ItemName] VARCHAR(40) NULL,
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
-- TABLE dbo.pms_manager
-- --------------------------------------------------
CREATE TABLE [dbo].[pms_manager]
(
    [pmscode] VARCHAR(15) NULL,
    [pmsname] VARCHAR(50) NULL,
    [abl] VARCHAR(10) NULL,
    [ACDLCM] VARCHAR(10) NULL,
    [ACDLFO] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ProcessIncharge
-- --------------------------------------------------
CREATE TABLE [dbo].[ProcessIncharge]
(
    [Emp_No] VARCHAR(30) NOT NULL,
    [Hod_No] VARCHAR(30) NULL,
    [ReqID] VARCHAR(25) NOT NULL,
    [pi_no] VARCHAR(50) NULL
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
-- TABLE dbo.reject_list
-- --------------------------------------------------
CREATE TABLE [dbo].[reject_list]
(
    [sbtag] VARCHAR(100) NULL,
    [sbname] VARCHAR(200) NULL
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
-- TABLE dbo.sb_ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_ledger]
(
    [acname] VARCHAR(100) NULL,
    [amount] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_list
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_list]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [name] VARCHAR(35) NULL
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
-- TABLE dbo.tb1
-- --------------------------------------------------
CREATE TABLE [dbo].[tb1]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
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
-- TABLE dbo.temp_brok
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_brok]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [sauda_date] DATETIME NOT NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_brok_temp_May4
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_brok_temp_May4]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_broka
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_broka]
(
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [sauda_date] DATETIME NOT NULL,
    [pqtytrd] INT NULL,
    [sqtytrd] INT NULL,
    [pqtydel] INT NULL,
    [sqtydel] INT NULL,
    [Pbroktrd] MONEY NULL,
    [Sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [ptrate] MONEY NULL,
    [strate] MONEY NULL,
    [sdrate] MONEY NULL,
    [pdrate] MONEY NULL,
    [ntbrok] MONEY NULL,
    [nsbrok] MONEY NULL,
    [ndbrok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_jkh_bse
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_jkh_bse]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Family] VARCHAR(10) NULL,
    [Family_Name] VARCHAR(100) NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [ClientType] VARCHAR(10) NULL,
    [TradeType] VARCHAR(3) NULL,
    [Trader] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Pamt] MONEY NOT NULL,
    [Samt] MONEY NOT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [TrdAmt] MONEY NULL,
    [DelAmt] MONEY NULL,
    [SerInEx] SMALLINT NULL,
    [Service_Tax] MONEY NULL,
    [ExService_Tax] MONEY NULL,
    [Turn_Tax] MONEY NULL,
    [Sebi_Tax] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Broker_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [Region] VARCHAR(50) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [Update_Date] VARCHAR(11) NULL,
    [Status_Name] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(3) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL,
    [Dummy3] VARCHAR(1) NULL,
    [Dummy4] MONEY NULL,
    [Dummy5] MONEY NULL,
    [Area] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_jkh_nse
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_jkh_nse]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(10) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Family] VARCHAR(10) NULL,
    [Family_Name] VARCHAR(50) NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [ClientType] VARCHAR(10) NULL,
    [TradeType] VARCHAR(3) NULL,
    [Trader] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Pamt] MONEY NOT NULL,
    [Samt] MONEY NOT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [TrdAmt] MONEY NULL,
    [DelAmt] MONEY NULL,
    [SerInEx] SMALLINT NULL,
    [Service_Tax] MONEY NULL,
    [ExService_Tax] MONEY NULL,
    [Turn_Tax] MONEY NULL,
    [Sebi_Tax] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Broker_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [Region] VARCHAR(50) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [Update_Date] VARCHAR(11) NULL,
    [Status_Name] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL,
    [Dummy3] VARCHAR(1) NULL,
    [Dummy4] MONEY NULL,
    [Dummy5] MONEY NULL,
    [Area] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_pdr
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_pdr]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Family] VARCHAR(10) NULL,
    [Family_Name] VARCHAR(100) NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [ClientType] VARCHAR(10) NULL,
    [TradeType] VARCHAR(3) NULL,
    [Trader] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Pamt] MONEY NOT NULL,
    [Samt] MONEY NOT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [TrdAmt] MONEY NULL,
    [DelAmt] MONEY NULL,
    [SerInEx] SMALLINT NULL,
    [Service_Tax] MONEY NULL,
    [ExService_Tax] MONEY NULL,
    [Turn_Tax] MONEY NULL,
    [Sebi_Tax] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Broker_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [Region] VARCHAR(50) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [Update_Date] VARCHAR(11) NULL,
    [Status_Name] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(3) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL,
    [Dummy3] VARCHAR(1) NULL,
    [Dummy4] MONEY NULL,
    [Dummy5] MONEY NULL,
    [Area] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_pdr_nse
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_pdr_nse]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(10) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(50) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Family] VARCHAR(10) NULL,
    [Family_Name] VARCHAR(50) NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [ClientType] VARCHAR(10) NULL,
    [TradeType] VARCHAR(3) NULL,
    [Trader] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Pamt] MONEY NOT NULL,
    [Samt] MONEY NOT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [TrdAmt] MONEY NULL,
    [DelAmt] MONEY NULL,
    [SerInEx] SMALLINT NULL,
    [Service_Tax] MONEY NULL,
    [ExService_Tax] MONEY NULL,
    [Turn_Tax] MONEY NULL,
    [Sebi_Tax] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Broker_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [Region] VARCHAR(50) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [Update_Date] VARCHAR(11) NULL,
    [Status_Name] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL,
    [Dummy3] VARCHAR(1) NULL,
    [Dummy4] MONEY NULL,
    [Dummy5] MONEY NULL,
    [Area] VARCHAR(10) NULL
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
-- TABLE dbo.UserRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[UserRequest]
(
    [ReqID] NVARCHAR(15) NOT NULL,
    [ItemID] VARCHAR(20) NOT NULL,
    [CatID] VARCHAR(20) NOT NULL,
    [ItemName] VARCHAR(50) NULL,
    [CategoryName] VARCHAR(60) NULL,
    [UserNote] VARCHAR(80) NULL,
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
    [orderID] VARCHAR(50) NULL
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

-- --------------------------------------------------
-- TABLE dbo.vikas
-- --------------------------------------------------
CREATE TABLE [dbo].[vikas]
(
    [name] VARCHAR(11) NULL
);

GO

