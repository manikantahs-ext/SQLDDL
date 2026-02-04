-- DDL Export
-- Server: 10.253.33.89
-- Database: IOVMS
-- Exported: 2026-02-05T02:38:47.473502

USE IOVMS;
GO

-- --------------------------------------------------
-- FUNCTION dbo.getEmpName
-- --------------------------------------------------
create function getEmpName
(@empcode varchar(10))
returns varchar(200)
AS
begin
declare @empName varchar(200)
select @empName=Emp_name from risk.dbo.emp_info where emp_no=@empcode
return @empName

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ActionUpdate
-- --------------------------------------------------
CREATE proc usp_ActionUpdate
(
    @PrNo as varchar(20),
	@Username as varchar(20),	
	@vendorSite varchar(100) =null,
	@Statusflag varchar(50) = null,
	@Statuslevel varchar(20) = null,
	@CGST varchar(5) = null,
	@SGST varchar(5) = null,
	@IGST varchar(5) = null,
	@CGSTAmount money = null,
	@SGSTAmount money = null,
	@IGSTAmount money = null,
	@roundOffAmt varchar(15)=null,
	@Total money=null,
	@PaymentTerms varchar(300)=null,
	@GstState varchar(100)=null,
	@GstNo varchar(100)=null,
	@Comment varchar(100) = null,
	@PIpath varchar(300)=null,	
	@ExpenseType varchar(100)=null,
	@Items [ItemList] readonly
)
As
BEGIN 
        Update tbl_IOP2P_ItemRequest		
		set VendorSite=@vendorSite,Total=@Total,[CGST%]=@CGST,[SGST%]=@SGST,[IGST%]=@IGST,
		CGST_Amount=@CGSTAmount,SGST_Amount=@SGSTAmount,IGST_Amount=@IGSTAmount,PaymentTerms=@PaymentTerms,GstState=@GstState,GstNo=@GstNo,
		ItemName=b.ItemName,SubItemName=b.SubItemName,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs,Units=b.Units,DeliveryDate=b.Deliverydate,[A/C Code]=b.Expense, RoundOffAmt=@roundOffAmt,
	    ItOption =@ExpenseType		
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.SrNo=b.SrNo		
		where a.PrNo=@PrNo

		Select 'The Request has been updated sucessfully'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_advInvoice
-- --------------------------------------------------
CREATE proc [dbo].[usp_advInvoice]
(
@flag varchar(100),
@PrNo varchar(50)=null,
@Inv_num varchar(20)=null,
@user varchar(50)=null,
@AdvAmount money=null
)
As
BEGIN			

 if(@flag='AddAdvance')
  Begin
	 --declare @AdvAmount as money='30000'
	 declare @totalAmt as money
	 declare @Amount as money

	  select @Amount=isnull(Sum(Amount),0) from tbl_IOP2P_Advance where PrNo=@PrNo and left(PANO,2)='PA'
	  select @totalAmt=Total from tbl_IOP2P_ItemRequest where Prno=@PrNo
  
	  if((@Amount +@AdvAmount )>@totalAmt)
	   Begin
		select 'Advance Amount cannot exceed the total Invoice Bill Amount'
		 return
	   End

	 declare @PA as varchar(50)
	 Select @PA=isnull((select  'PA' + right('00000'+ cast(max(replace(isnull(PANo,0),'PA','')) +1 as varchar),6)),'PA000001') from tbl_IOP2P_Advance where left(PANO,2)!='PI'

	 insert into tbl_IOP2P_Advance (PANo,PrNo,Amount,UpdatedBy,Updateddate)
	 values(@PA,@PrNo,@AdvAmount,@user,getdate())

	 select 'Advance Invoice with No '+@PA+' for PR: '+@PrNo+' has been generated successfully'
	 return
   End
  if(@flag='GetAdvHist')
   Begin
     select PrNo,Amount,Convert(varchar,Updateddate,103)Updateddate from tbl_IOP2P_Advance where PrNo=@PrNo and left(PANO,2)='PA'
	 return
   End
   if(@flag='GetAdvanceList')
	    Begin
		  select a.PrNo,A.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate, 
		  vm.Vendor_Name VendorName from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  left outer join (select distinct Vendor_ID,Vendor_Name from [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] )vm on a.VendorID=vm.Vendor_ID 
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@user
		  group by  a.PrNo,A.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate,vm.Vendor_Name
		  order by a.RequestedDate desc
		  return
		End
    if(@flag='GetAdvdetails')
   Begin
     select PrNo,PANo,Cast(Amount as numeric(10,2))Amount,Convert(varchar,Updateddate,103)Updateddate from tbl_IOP2P_Advance where PANo=@Inv_num
	 return
   End
   if(@flag='getINVBalance')  /*Partial Invoice*/
   Begin
         select  ItmId,PrNo, Amount,rank() OVER(PARTITION BY Amount ORDER BY ItmID) ID into #tmpInvBal from tbl_IOP2P_Advance where PrNo=@PrNo and left(PANO,2)='PI' and (Status !='Rejected' or status is null)
		  
		 select cast(sum(amount) as numeric(18,2)) AMTAvailed,cast(b.Total as numeric(18,2)) PO_Amount,cast((b.Total - sum(amount)) as numeric(18,2)) Balance from #tmpInvBal a 
		 right outer join tbl_IOP2P_ItemRequest b on a.ItmID=b.SrNo
		 where b.PrNo=@PrNo and 1= case when (a.id is null) then 1 else a.ID end
		 group by b.Total
      
	  --select a.PrNo,sum(Amount) AMTAvailed,Total PO_Amount,(Total - sum(Amount)) Balance from tbl_IOP2P_ItemRequest a
	  --left outer join tbl_IOP2P_Advance b on a.PrNo =b.PrNo
	  --where a.PrNo=@PrNo group by a.PrNo,Total
      return
   End
   if(@flag='POBals') /*Partial Invoice*/
   Begin    
	select cast((b.EstCosts - sum(isnull(a.costs,0))) as numeric(18,2))BalAmount,b.SrNo,b.ItemName,b.SubItemName,b.ItmQty,cast(B.Rate as numeric(18,2)) rate,b.units,b.DeliveryDate,b.[A/C Code] Expense from tbl_IOP2P_Advance a 
	right outer join tbl_IOP2P_ItemRequest b on a.ItmID=b.SrNo and left(a.PANO,2)='PI' and (a.Status !='Rejected' or a.status is null)
	where b.PrNo=@PrNo 
	group by b.SrNo,b.ItemName,b.SubItemName,b.ItmQty,b.units,b.DeliveryDate,b.[A/C Code],b.EstCosts,b.rate
   End
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_advInvoice_23May2019
-- --------------------------------------------------
CREATE proc [dbo].[usp_advInvoice_23May2019]
(
@flag varchar(100),
@PrNo varchar(50)=null,
@Inv_num varchar(20)=null,
@user varchar(50)=null,
@AdvAmount money=null
)
As
BEGIN			

 if(@flag='AddAdvance')
  Begin
	 --declare @AdvAmount as money='30000'
	 declare @totalAmt as money
	 declare @Amount as money

	  select @Amount=isnull(Sum(Amount),0) from tbl_IOP2P_Advance where PrNo=@PrNo
	  select @totalAmt=Total from tbl_IOP2P_ItemRequest where Prno=@PrNo
  
	  if((@Amount +@AdvAmount )>@totalAmt)
	   Begin
		select 'Advance Amount cannot exceed the total Invoice Bill Amount'
		 return
	   End

	 declare @PA as varchar(50)
	 Select @PA=isnull((select  'PA' + right('00000'+ cast(max(replace(isnull(PANo,0),'PA','')) +1 as varchar),6)),'PA000001') from tbl_IOP2P_Advance where left(PANO,2)!='PI'

	 insert into tbl_IOP2P_Advance (PANo,PrNo,Amount,UpdatedBy,Updateddate)
	 values(@PA,@PrNo,@AdvAmount,@user,getdate())

	 select 'Advance Invoice with No '+@PA+' for PR: '+@PrNo+' has been generated successfully'
	 return
   End
  if(@flag='GetAdvHist')
   Begin
     select PrNo,Amount,Convert(varchar,Updateddate,103)Updateddate from tbl_IOP2P_Advance where PrNo=@PrNo
	 return
   End
   if(@flag='GetAdvanceList')
	    Begin
		  select a.PrNo,A.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@user
		  group by  a.PrNo,A.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
   if(@flag='GetAdvdetails')
   Begin
     select PrNo,PANo,Cast(Amount as numeric(10,2))Amount,Convert(varchar,Updateddate,103)Updateddate from tbl_IOP2P_Advance where PANo=@Inv_num
	 return
   End
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Approvalist
-- --------------------------------------------------
--exec Usp_Approvalist 'E77084','PO'
CREATE proc [dbo].[Usp_Approvalist] 
(
	@empno varchar(20),
	@flag varchar(20)=null
)
as
BEGIN        


--drop table #tmp
--declare @empno as varchar(10)
--set @empno=''
--E00335  E79086
if(@flag='PO')
begin        
	select a.PrNo,a.PONO,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	--where (d.Senior=@empno or d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	where @empno in(select emp_no from [Vw_UserRoles] where access in('FC','Admin')) and 
	a.PrNo is not null  and a.status=6 --and ApprovedBY is null  and a.status=6
	group by PrNo,PONO,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,a.PONO,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate, 
	Vm.Vendor_Name VendorName 	from #tmp a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	left outer join (select distinct Vendor_ID,Vendor_Name from[196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] ) vm on itmReq.VendorID=vm.Vendor_ID
	--where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and a.status=2) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	--or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	--or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) and
	where
	a.PrNo is not null  order by itmReq.RequestedDate desc
END
else
begin 
		select a.PrNo,a.PONO,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp1
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	where (d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	a.PrNo is not null and a.status<6  --and ApprovedBY is null  and a.status=6
	group by PrNo,PONO,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,a.PONO,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate, 
	vm.Vendor_Name VendorName from #tmp1 a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	left outer join (select distinct Vendor_ID,Vendor_Name from [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] )vm on itmReq.VendorID=vm.Vendor_ID
	where (d.hoe= @empno and a.status=1) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	--or (d.cfo= @empno and TotalCosts > 500000 and a.status in(4,5))
	or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.ceo=@empno and TotalCosts>500000 and a.status in(4,5)) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 
	and
	a.PrNo is not null  order by itmReq.RequestedDate desc
END 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Approvalist_04Jun2019
-- --------------------------------------------------
--exec Usp_Approvalist 'E77084','PO'
create proc [dbo].[Usp_Approvalist_04Jun2019] 
(
	@empno varchar(20),
	@flag varchar(20)=null
)
as
BEGIN        


--drop table #tmp
--declare @empno as varchar(10)
--set @empno=''
--E00335  E79086
if(@flag='PO')
begin        
	select a.PrNo,a.PONO,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	--where (d.Senior=@empno or d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	where @empno in(select emp_no from [Vw_UserRoles] where access in('FC','Admin')) and 
	a.PrNo is not null  and a.status=6 --and ApprovedBY is null  and a.status=6
	group by PrNo,PONO,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,a.PONO,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate, 
	Vm.Vendor_Name VendorName 	from #tmp a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	left outer join (select distinct Vendor_ID,Vendor_Name from[196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] ) vm on itmReq.VendorID=vm.Vendor_ID
	--where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and a.status=2) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	--or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	--or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) and
	where
	a.PrNo is not null  order by itmReq.RequestedDate desc
END
else
begin 
		select a.PrNo,a.PONO,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp1
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	where (d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	a.PrNo is not null and a.status<6  --and ApprovedBY is null  and a.status=6
	group by PrNo,PONO,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,a.PONO,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate, 
	vm.Vendor_Name VendorName from #tmp1 a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	left outer join (select distinct Vendor_ID,Vendor_Name from [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] )vm on itmReq.VendorID=vm.Vendor_ID
	where (d.hoe= @empno and a.status=1) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 
	and
	a.PrNo is not null  order by itmReq.RequestedDate desc
END 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Approvalist_15Mar2019
-- --------------------------------------------------
--exec Usp_Approvalist 'E77084','PO'
CREATE proc [dbo].[Usp_Approvalist_15Mar2019] 
(
	@empno varchar(20),
	@flag varchar(20)=null
)
as
BEGIN        


--drop table #tmp
--declare @empno as varchar(10)
--set @empno=''

if(@flag='PO')
begin        
	select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	where (d.Senior=@empno or d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	a.PrNo is not null  and a.status=6 --and ApprovedBY is null  and a.status=6
	group by PrNo,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate from #tmp a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and a.status=2) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 
	and
	a.PrNo is not null  order by itmReq.RequestedDate desc
END
else
begin 
		select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp1
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	where (d.Senior=@empno or d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	a.PrNo is not null and a.status<6  --and ApprovedBY is null  and a.status=6
	group by PrNo,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate from #tmp1 a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and a.status=1) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 
	and
	a.PrNo is not null  order by itmReq.RequestedDate desc
END 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Approvalist_23May2019
-- --------------------------------------------------

--exec Usp_Approvalist 'E77084','PO'
CREATE  proc [dbo].[Usp_Approvalist_23May2019] 
(
	@empno varchar(20),
	@flag varchar(20)=null
)
as
BEGIN        


--drop table #tmp
--declare @empno as varchar(10)
--set @empno=''

if(@flag='PO')
begin        
	select a.PrNo,a.PONO,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	--where (d.Senior=@empno or d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	where @empno in(select emp_no from [Vw_UserRoles] where access in('FC','Admin')) and 
	a.PrNo is not null  and a.status=6 --and ApprovedBY is null  and a.status=6
	group by PrNo,PONo,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,A.PONO,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate from #tmp a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	--where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and a.status=2) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	--or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	--or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 	and
	 where a.PrNo is not null  order by itmReq.RequestedDate desc
END
else
begin 
		select a.PrNo,A.PoNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
	sum(EStcosts) TotalCosts,
	a.requestedBy,a.status into #tmp1
	from tbl_IOP2P_ItemRequest a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	where (d.Senior=@empno or d.hoe=@empno or d.cxo=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
	a.PrNo is not null and a.status<6  --and ApprovedBY is null  and a.status=6
	group by PrNo,PoNo,b.Parent_Name,a.RequestedBy,a.status
	--having sum(EStcosts) <=40000 --between 500000 and 2500000
	--order by a.requesteddate desc 


	select distinct a.PrNo,A.PONO,a.Parent_Name,cast(a.TotalCosts as numeric(18,2))TotalCosts,d.Emp_name RequestedBy,d.Branch_cd,Convert(varchar,itmReq.RequestedDate,103) RequestedDate,itmReq.RequestedDate reqDate from #tmp1 a
	inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
	left outer join tbl_IOP2P_ItemRequest itmReq on a.PrNo=itmReq.PrNo
	where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and a.status=1) or (d.cxo= @empno and TotalCosts > 100000 and a.status=3)
	or (d.cfo= @empno and TotalCosts > 500000 and a.status=4)
	or (d.ceo=@empno and TotalCosts>2500000 and a.status=5) or (d.fc=@empno and a.status =6) 
	--or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
	--or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 
	and
	a.PrNo is not null  order by itmReq.RequestedDate desc
END 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Approvalist04Jan2019
-- --------------------------------------------------

--exec Usp_Approvalist 'E00335'
CREATE proc [dbo].[Usp_Approvalist04Jan2019] 
(
	@empno varchar(20)
)
as
BEGIN        


--drop table #tmp
--declare @empno as varchar(10)
--set @empno=''

       
select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@empno or d.hoe=@empno or d.cfo=@empno or d.ceo=@empno or d.fc=@empno )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
--having sum(EStcosts) <=40000 --between 500000 and 2500000
--order by a.requesteddate desc 


select * from #tmp a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
where (d.Senior=@empno and a.status=1) or (d.hoe= @empno and TotalCosts > 50000 and a.status=2) or (d.cfo= @empno and TotalCosts > 500000 and a.status=3)
or (d.ceo=@empno and TotalCosts>2500000 and a.status=4) or (d.fc=@empno and TotalCosts < 50000 and a.status=2) or (d.fc= @empno and TotalCosts < 500000 and a.status=3)
or (d.fc= @empno and TotalCosts < 2500000 and a.status=4) or (d.fc= @empno and TotalCosts > 2500000 and a.status=5) 
and
a.PrNo is not null  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetPODetails
-- --------------------------------------------------
CREATE proc [dbo].[usp_GetPODetails]
(
@PONO varchar(20)
)
As
BEGIN        
	     select top 1 'genPO' , Comments FCRemark from tbl_IOP2P_comments a 
		 inner join tbl_IOP2P_ItemRequest b on a.PrNo=b.PrNo
		 where b.PONo=@PONO and a.level=6 order by a.UpdatedDate  desc

		 select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,Bilto.Branch_Address BillTo_Address,
		 A.ItemName,case when a.ITAssetno is null then A.SubItemName else ('<b>' + isnull(cpm.Product_Name,'') + ':</b><br>'+ A.SubItemName) end SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,case when a.ITAssetNo is not null then dbo.getEmpName(g.Approved_By) 
		 else c.HOE_Name end HOE_Name,a.Units ,a.Status ,isnull(d.Address_Line1,'')+','+isnull(d.Address_Line2,'')+','+isnull(d.Address_Line3,'')+','+
		 isnull(d.Address_Line4,'') +','+isnull(d.City,'') +','+isnull(d.State,'')+'-'+isnull(d.Postal_code,'')  VendorAdd
		 ,Convert(varchar,a.FC_Date,103) PODate,cast(isnull(CGST_Amount,0) as numeric(10,2))CGST_Amount,cast(isnull(SGST_Amount,0) as numeric(10,2))SGST_Amount,A.PaymentTerms,RoundOffAmt,
		 cast(isnull(IGST_Amount,0) as numeric(10,2))IGST_Amount,Cast(Total as numeric(10,2))Total,[CGST%],[SGST%],[IGST%],isnull(d.PAN_NO,'N/A') as VendorPan,isnull(d.GST_Registration_Number,'N/A') as VendorGST,GstState [STATE],GstNo [GSTNo],
		 a.Remark,I.Emp_name ITAssetReqBy,a.ITAssetNo,a.Warranty ,h.Model_Name ITAssetModelName,A.BillTo_Name,a.ShipTo_Name,a.POfile_path
		 from tbl_IOP2P_ItemRequest a
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
		left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no and c.Access in ('User','ITAssetUser','View')
		left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE Bilto on a.BillTO= Bilto.Branch_code
		left outer join ITAssests.dbo.tbl_RequestMaster g on a.ITAssetNo=g.Request_Id
		left join ITAssests.[dbo].[tbl_ProductModelMaster] h on g.Model_No=h.Model_Id
		left join ITAssests.[dbo].tbl_CapexProductMaster CPM on g.Item_Code=CPM.Product_Code
		left outer join risk.dbo.emp_info i on g.Requested_By=i.emp_no
		where PONo=@PONO

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog
-- --------------------------------------------------

--exec [usp_getPRLog] 'PR000137'
CREATE proc [dbo].[usp_getPRLog]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	
	--declare @prno as varchar(20)='PR000017'
	if(@PrNo='')
	 Begin
	  if(@PoNo!='')
	    Begin
	     select @prno=PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo		 
        End	     
	   select @prno=PrNo from tbl_IOP2P_Advance where PANo=@PINo 
	  --select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End


	 declare @VendorName as varchar(2000)
	 select top 1 @VendorName=b.Vendor_Name from tbl_IOP2P_ItemRequest a 
	 left outer join [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] b on a.VendorID=b.Vendor_ID where a.PrNo=@prno
	 
	 if exists(select 1 from tbl_IOP2P_ItemRequest where Status=-8 and PrNo=@prno)
	 Begin
	   select Distinct top 1 '1' [Order], PrNo,PONo, [INVOICE_NUM] [PI],RequestedBY Emp_Code,b.Emp_name,RequestedDate  [Date],@VendorName as VendorName, 
	   'Admin' [Level],'Rejected' [Status],Remark from tbl_IOP2P_ItemRequest a 
	   left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	   where a.Status=-8 and PrNo=@prno
	   return
	 End

	 --Considers level as One step down of status in tbl_IOP2P_ItemRequest
	select [Order], PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103)
	+' ' + case when(Convert(varchar,RequestedDate,108))='00:00:00' then '' else Convert(varchar,RequestedDate,108) end as [Date],@VendorName as VendorName, 
	a.[Level], a.Status,Remark from
	(select Distinct top 1 '1' [Order], Itm.PrNo,PONo,adv.PANo [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest Itm 
	 left outer join tbl_IOP2P_Advance adv on Itm.PrNo=adv.PrNo and left(adv.PANo,2)='PI' where Itm.prno=@prno 
	union all
	select '1','','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Advance',case when status is null then 'Advance Created'else Status end,'' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PA'
	union all
	select Distinct '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Invoice',case when status is null then 'Invoice Created' else Status end,'' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PI'
	union all
	select Distinct '2',''PR,''PO,INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Advance',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANO where b.PRNo=@prno and left(PANo,2)='PA'
	union all
	select distinct top 5 '3','','',a.INVOICE_NUM,'',CHECK_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(PANo,2)='PA' order by check_status desc 
	--union all
	--select Distinct '4','' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'' Status, ''Remark from tbl_IOP2P_ItemRequest 
	--where prno=@prno and status='8' 
	union all
	select distinct '4',''PR,''PO,a.INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Invoice',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANo where b.PRNo=@prno and left(a.INVOICE_NUM,2)='PI'
	union all
	select distinct top 5 '5','','',a.INVOICE_NUM,'',CHECK_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(b.PANo,2)='PI' order by check_status  --and a.check_status='RECONCILED'	
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by [Order],convert(datetime,RequestedDate) 

	select * from (
	select a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.invoice_num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PI'-- order by check_status
	union all
	select    a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PA'	--order by check_status
	) d
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_09Aug2019
-- --------------------------------------------------

--exec [usp_getPRLog] 'PR000137'
CREATE proc [dbo].[usp_getPRLog_09Aug2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	
	--declare @prno as varchar(20)='PR000017'
	if(@PrNo='')
	 Begin
	  if(@PoNo!='')
	    Begin
	     select @prno=PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo		 
        End	     
	   select @prno=PrNo from tbl_IOP2P_Advance where PANo=@PINo 
	  --select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End


	 declare @VendorName as varchar(2000)
	 select top 1 @VendorName=b.Vendor_Name from tbl_IOP2P_ItemRequest a 
	 left outer join [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] b on a.VendorID=b.Vendor_ID where a.PrNo=@prno
	 
	 if exists(select 1 from tbl_IOP2P_ItemRequest where Status=-8 and PrNo=@prno)
	 Begin
	   select Distinct top 1 '1' [Order], PrNo,PONo, [INVOICE_NUM] [PI],RequestedBY Emp_Code,b.Emp_name,RequestedDate  [Date],@VendorName as VendorName, 
	   'Admin' [Level],'Rejected' [Status],Remark from tbl_IOP2P_ItemRequest a 
	   left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	   where a.Status=-8 and PrNo=@prno
	   return
	 End

	 --Considers level as One step down of status in tbl_IOP2P_ItemRequest
	select [Order], PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103)
	+' ' + case when(Convert(varchar,RequestedDate,108))='00:00:00' then '' else Convert(varchar,RequestedDate,108) end as [Date],@VendorName as VendorName, 
	a.[Level], a.Status,Remark from
	(select Distinct top 1 '1' [Order], Itm.PrNo,PONo,adv.PANo [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest Itm 
	 left outer join tbl_IOP2P_Advance adv on Itm.PrNo=adv.PrNo and left(adv.PANo,2)='PI' where Itm.prno=@prno 
	union all
	select '1','','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Advance','Advance Created','' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PA'
	union all
	select Distinct '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Invoice','Invoice Created','' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PI'
	union all
	select Distinct '2',''PR,''PO,INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Advance',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANO where b.PRNo=@prno
	union all
	select distinct top 5 '3','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(PANo,2)='PA' order by check_status desc 
	--union all
	--select Distinct '4','' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'' Status, ''Remark from tbl_IOP2P_ItemRequest 
	--where prno=@prno and status='8' 
	union all
	select distinct '4',''PR,''PO,a.INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Invoice',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_IOP2P_ItemRequest b on a.Invoice_num=b.INVOICE_NUM where b.PRNo=@prno	
	union all
	select distinct top 5 '5','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(b.PANo,2)='PI' order by check_status  --and a.check_status='RECONCILED'	
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by [Order],convert(datetime,RequestedDate) 

	select * from (
	select a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.invoice_num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PI'-- order by check_status
	union all
	select    a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PA'	--order by check_status
	) d
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_10Apr2019
-- --------------------------------------------------

CREATE proc [dbo].[usp_getPRLog_10Apr2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	--declare @prno as varchar(20)='PR000091'
	if(@PrNo='')
	 Begin
	  select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End

	select PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103) +' ' + Convert(varchar,RequestedDate,108) as [Date], a.[Level], a.Status,Remark from
	(select Distinct PrNo,PONo,InVoice_Num [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest where prno=@prno
	union all
	select '','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select Distinct '' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'Sent for Payment at CSO' Status, ''Remark from tbl_IOP2P_ItemRequest 
	where prno=@prno and status='8' 
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by convert(datetime,RequestedDate)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_11OCt2019
-- --------------------------------------------------

--exec [usp_getPRLog] 'PR000137'
CREATE proc [dbo].[usp_getPRLog_11OCt2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	
	--declare @prno as varchar(20)='PR000017'
	if(@PrNo='')
	 Begin
	  if(@PoNo!='')
	    Begin
	     select @prno=PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo		 
        End	     
	   select @prno=PrNo from tbl_IOP2P_Advance where PANo=@PINo 
	  --select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End


	 declare @VendorName as varchar(2000)
	 select top 1 @VendorName=b.Vendor_Name from tbl_IOP2P_ItemRequest a 
	 left outer join [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] b on a.VendorID=b.Vendor_ID where a.PrNo=@prno
	 
	 if exists(select 1 from tbl_IOP2P_ItemRequest where Status=-8 and PrNo=@prno)
	 Begin
	   select Distinct top 1 '1' [Order], PrNo,PONo, [INVOICE_NUM] [PI],RequestedBY Emp_Code,b.Emp_name,RequestedDate  [Date],@VendorName as VendorName, 
	   'Admin' [Level],'Rejected' [Status],Remark from tbl_IOP2P_ItemRequest a 
	   left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	   where a.Status=-8 and PrNo=@prno
	   return
	 End

	 --Considers level as One step down of status in tbl_IOP2P_ItemRequest
	select [Order], PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103)
	+' ' + case when(Convert(varchar,RequestedDate,108))='00:00:00' then '' else Convert(varchar,RequestedDate,108) end as [Date],@VendorName as VendorName, 
	a.[Level], a.Status,Remark from
	(select Distinct top 1 '1' [Order], Itm.PrNo,PONo,adv.PANo [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest Itm 
	 left outer join tbl_IOP2P_Advance adv on Itm.PrNo=adv.PrNo and left(adv.PANo,2)='PI' where Itm.prno=@prno 
	union all
	select '1','','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Advance',case when status is null then 'Advance Created'else Status end,'' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PA'
	union all
	select Distinct '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Invoice',case when status is null then 'Invoice Created' else Status end,'' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PI'
	union all
	select Distinct '2',''PR,''PO,INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Advance',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANO where b.PRNo=@prno and left(PANo,2)='PA'
	union all
	select distinct top 5 '3','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(PANo,2)='PA' order by check_status desc 
	--union all
	--select Distinct '4','' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'' Status, ''Remark from tbl_IOP2P_ItemRequest 
	--where prno=@prno and status='8' 
	union all
	select distinct '4',''PR,''PO,a.INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Invoice',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANo where b.PRNo=@prno and left(a.INVOICE_NUM,2)='PI'
	union all
	select distinct top 5 '5','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(b.PANo,2)='PI' order by check_status  --and a.check_status='RECONCILED'	
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by [Order],convert(datetime,RequestedDate) 

	select * from (
	select a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.invoice_num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PI'-- order by check_status
	union all
	select    a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PA'	--order by check_status
	) d
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_13Aug2019
-- --------------------------------------------------

--exec [usp_getPRLog] 'PR000137'
CREATE proc [dbo].[usp_getPRLog_13Aug2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	
	--declare @prno as varchar(20)='PR000017'
	if(@PrNo='')
	 Begin
	  if(@PoNo!='')
	    Begin
	     select @prno=PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo		 
        End	     
	   select @prno=PrNo from tbl_IOP2P_Advance where PANo=@PINo 
	  --select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End


	 declare @VendorName as varchar(2000)
	 select top 1 @VendorName=b.Vendor_Name from tbl_IOP2P_ItemRequest a 
	 left outer join [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] b on a.VendorID=b.Vendor_ID where a.PrNo=@prno
	 
	 if exists(select 1 from tbl_IOP2P_ItemRequest where Status=-8 and PrNo=@prno)
	 Begin
	   select Distinct top 1 '1' [Order], PrNo,PONo, [INVOICE_NUM] [PI],RequestedBY Emp_Code,b.Emp_name,RequestedDate  [Date],@VendorName as VendorName, 
	   'Admin' [Level],'Rejected' [Status],Remark from tbl_IOP2P_ItemRequest a 
	   left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	   where a.Status=-8 and PrNo=@prno
	   return
	 End

	 --Considers level as One step down of status in tbl_IOP2P_ItemRequest
	select [Order], PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103)
	+' ' + case when(Convert(varchar,RequestedDate,108))='00:00:00' then '' else Convert(varchar,RequestedDate,108) end as [Date],@VendorName as VendorName, 
	a.[Level], a.Status,Remark from
	(select Distinct top 1 '1' [Order], Itm.PrNo,PONo,adv.PANo [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest Itm 
	 left outer join tbl_IOP2P_Advance adv on Itm.PrNo=adv.PrNo and left(adv.PANo,2)='PI' where Itm.prno=@prno 
	union all
	select '1','','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Advance',case when status is null then 'Advance Created'else Status end,'' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PA'
	union all
	select Distinct '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Invoice',case when status is null then 'Invoice Created' else Status end,'' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PI'
	union all
	select Distinct '2',''PR,''PO,INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Advance',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANO where b.PRNo=@prno
	union all
	select distinct top 5 '3','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(PANo,2)='PA' order by check_status desc 
	--union all
	--select Distinct '4','' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'' Status, ''Remark from tbl_IOP2P_ItemRequest 
	--where prno=@prno and status='8' 
	union all
	select distinct '4',''PR,''PO,a.INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Invoice',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_IOP2P_ItemRequest b on a.Invoice_num=b.INVOICE_NUM where b.PRNo=@prno	
	union all
	select distinct top 5 '5','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno and left(b.PANo,2)='PI' order by check_status  --and a.check_status='RECONCILED'	
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by [Order],convert(datetime,RequestedDate) 

	select * from (
	select a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.invoice_num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PI'-- order by check_status
	union all
	select    a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo
	where b.PrNo=@prno and left(b.PANo,2)='PA'	--order by check_status
	) d
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_20Apr2019
-- --------------------------------------------------

CREATE proc [dbo].[usp_getPRLog_20Apr2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	--declare @prno as varchar(20)='PR000091'
	if(@PrNo='')
	 Begin
	  select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End

	select PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103) +' ' + Convert(varchar,RequestedDate,108) as [Date], a.[Level], a.Status,Remark from
	(select Distinct PrNo,PONo,InVoice_Num [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest where prno=@prno
	union all
	select '','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select Distinct '' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'Sent for Payment at CSO' Status, ''Remark from tbl_IOP2P_ItemRequest 
	where prno=@prno and status='8' 
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by convert(datetime,RequestedDate)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_23May2019
-- --------------------------------------------------
CREATE proc [dbo].[usp_getPRLog_23May2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	--declare @prno as varchar(20)='PR000091'
	if(@PrNo='')
	 Begin
	  select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End

	select [Order], PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103)
	+' ' + case when(Convert(varchar,RequestedDate,108))='00:00:00' then '' else Convert(varchar,RequestedDate,108) end as [Date], 
	a.[Level], a.Status,Remark from
	(select Distinct '1' [Order], PrNo,PONo,InVoice_Num [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest where prno=@prno
	union all
	select '1','','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Advance','Advance Created','' from tbl_iop2p_Advance where prno=@prno
	union all
	select '2',''PR,''PO,INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Advance',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANO where b.PRNo=@prno
	union all
	select distinct top 5 '3','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno order by check_status desc 
	union all
	select Distinct '4','' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'' Status, ''Remark from tbl_IOP2P_ItemRequest 
	where prno=@prno and status='8' 
	union all
	select distinct '4',''PR,''PO,a.INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Invoice',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_IOP2P_ItemRequest b on a.Invoice_num=b.INVOICE_NUM where b.PRNo=@prno	
	union all
	select distinct top 5 '5','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_ItemRequest b on a.Invoice_Num=b.INVOICE_NUM where b.PrNo=@prno order by check_status desc  --and a.check_status='RECONCILED'	
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by [Order],convert(datetime,RequestedDate) 

	select * from (
	select top 1   a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo
	where b.PrNo=@prno	order by check_status
	union all
	select top 1 a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_ItemRequest b on a.invoice_num=b.INVOICE_NUM
	where b.PrNo=@prno order by check_status
	) d
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getPRLog_31May2019
-- --------------------------------------------------
--exec [usp_getPRLog] 'PR000137'
create proc [dbo].[usp_getPRLog_31May2019]
(
@PrNo varchar(20)='',
@PoNo varchar(20)='',
@PINo varchar(20)=''
)
As
BEGIN
	--declare @prno as varchar(20)='PR000017'
	if(@PrNo='')
	 Begin
	  select @prno= PrNo from tbl_IOP2P_ItemRequest where PONo=@PoNo or INVOICE_NUM=@PINo 
	 End
	 declare @VendorName as varchar(2000)
	 select top 1 @VendorName=b.Vendor_Name from tbl_IOP2P_ItemRequest a 
	 left outer join [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] b on a.VendorID=b.Vendor_ID where a.PrNo=@prno
	 
	 --Considers level as One step down of status in tbl_IOP2P_ItemRequest
	select [Order], PrNo,PONo, [PI],a.RequestedBy Emp_Code,b.Emp_name, Convert(varchar,RequestedDate,103)
	+' ' + case when(Convert(varchar,RequestedDate,108))='00:00:00' then '' else Convert(varchar,RequestedDate,108) end as [Date],@VendorName as VendorName, 
	a.[Level], a.Status,Remark from
	(select Distinct '1' [Order], PrNo,PONo,InVoice_Num [PI],RequestedBY,RequestedDate, 'PR Raised' [Level],'Sent for Approval to VH' Status,Remark from tbl_IOP2P_ItemRequest where prno=@prno
	union all
	select '1','','','',UpdatedBy,UpdatedDate,case when([Level]=1) then 'Checked by VH' when ([Level]=3) then 'Checked by HOD' 
											   when([Level]=4) then 'Checked by CFO' when ([Level]=5) then 'Checked by CEO'
											   when([Level]=6)  then 'Checked by FC'  end  ,
										  Case when([Level]=6 and [Status]='DirApprove') then 'PO Generated' 
											   when ([Status]='DirApprove') then 'Approved' else 'Rejected' end ,
	Comments  from tbl_IOP2P_Comments where prno=@prno and level !=7
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Advance','Advance Created','' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PA'
	union all
	select '2',''PR,''PO,PANo ,UpdatedBy,UpdatedDate,'Invoice','Invoice Created','' from tbl_iop2p_Advance where prno=@prno and left(PANo,2)='PI'
	union all
	select '2',''PR,''PO,INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Advance',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_iop2p_Advance b on a.Invoice_num=b.PANO where b.PRNo=@prno
	union all
	select distinct top 5 '3','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo where b.PrNo=@prno order by check_status desc 
	--union all
	--select Distinct '4','' PrNo,''PONo,'' [PI],Update_Invoice,Update_Invoice_date, 'Invoice Created' [Level],'' Status, ''Remark from tbl_IOP2P_ItemRequest 
	--where prno=@prno and status='8' 
	union all
	select distinct '4',''PR,''PO,a.INVOICE_NUM ,left(BATCH_NAME,6),ACCOUNTING_DATE,'Invoice',case when isnull(INVOICE_STATUS,'')='' then 'Added To Staging' else 'Sent for Payment at CSO' end,'' from tbl_Staging a 
	inner join tbl_IOP2P_ItemRequest b on a.Invoice_num=b.INVOICE_NUM where b.PRNo=@prno	
	union all
	select distinct top 5 '5','','',a.INVOICE_NUM,'',INVOICE_ACCOUNTING_DATE,'Vendor Payment',CHECK_STATUS,'' from tbl_IOP2P_Paymentdetails a 
	inner join tbl_IOP2P_ItemRequest b on a.Invoice_Num=b.INVOICE_NUM where b.PrNo=@prno order by check_status  --and a.check_status='RECONCILED'	
	) a
	left outer join Risk.dbo.Emp_info b on a.RequestedBy = b.Emp_no
	order by [Order],convert(datetime,RequestedDate) 

	select * from (
	select top 1 a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_ItemRequest b on a.invoice_num=b.INVOICE_NUM
	where b.PrNo=@prno order by check_status
	union all
	select top 1   a.Invoice_Num,Check_Number,Check_Amount,Invoice_Amount_Paid,check_Status from tbl_IOP2P_Paymentdetails a
	left outer join tbl_IOP2P_Advance b on a.Invoice_Num=b.PANo
	where b.PrNo=@prno	order by check_status
	) d
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_InsertStaging
-- --------------------------------------------------
CREATE PROC [dbo].[Usp_InsertStaging]    
AS             
Begin     
  
 
 insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE
 
 )
 SELECT 
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,Vendor_Bill_Date,VendorNumber,Vendor_Site_Code,INVOICE_AMOUNT,                
 INVOICE_CURRENCY_CODE,TERMS_NAME,                
 DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,                
 GL_DATE,ORG_ID,LINE_NUMBER,                
 LINE_TYPE_LOOKUP_CODE,[Line Amount]=EstCosts,[Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,ASSETS_TRACKING_FLAG AS ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,                
 ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,                
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,                
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY                
 ,DIST_ATTRIBUTE1,DIST_ATTRIBUTE2,                
 DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,                
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,BatchName,  Null as  GST_CATEGORY, Null as  HSN_CODE    
  
 FROM Vw_IOPTP where INVOICE_NUM <>''     
    
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_InsertStaging05Jan2019
-- --------------------------------------------------

CREATE PROC Usp_InsertStaging05Jan2019    
AS             
Begin     
  
 insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE
 
 )
 SELECT 
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,Vendor_Bill_Date,VendorNumber,Vendor_Site_Code,INVOICE_AMOUNT,                
 INVOICE_CURRENCY_CODE,TERMS_NAME,                
 DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,                
 GL_DATE,ORG_ID,LINE_NUMBER,                
 LINE_TYPE_LOOKUP_CODE,[Line Amount]=EstCosts,[Line Description]=Remark, '' AS DIST_LINE_NUMBER,                
 '' dist_Amount,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,ASSETS_TRACKING_FLAG AS ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,                
 ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,                
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,                
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY                
 ,DIST_ATTRIBUTE1,DIST_ATTRIBUTE2,                
 DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,                
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,                
 '' AS PREPAY_NUM,'' AS PREPAY_DIST_NUM,'' AS PREPAY_APPLY_AMOUNT,''  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,'' AS PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE,
 '' as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,BATCH_NAME,  '' as  GST_CATEGORY, '' as  HSN_CODE    
  
 FROM Vw_IOPTP where INVOICE_NUM <>''     
    
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,a.LOB as LOB,b.channel as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [172.31.12.73].DarwinBoxMiddleware.dbo.tbl_EmployeeMaster b with (nolock) on a.emp_no=b.emp_no collate SQL_Latin1_General_CP1_CI_AS
	 --left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 --left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 --left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   --select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	     select @param3=Access from vw_userroles where emp_no=@param2
	     select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType=@param and item != (case when @param3='user' then 'IT Equipments' else '' end)
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,isnull(PONo,'')PONO,isnull(INVOICE_NUM,'') PINO,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,
		  REPLACE(REPLACE(Remark, CHAR(13), ''), CHAR(10), '')Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate,PONo,POfile_path,Project from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo,a.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate
		  ,vm.Vendor_Name VendorName  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  left outer join (select distinct Vendor_ID,Vendor_Name from [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] )vm on a.VendorID=vm.Vendor_ID
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo,a.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate,vm.Vendor_Name
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		  if exists (select 1 from tbl_IOP2P_ItemRequest where PrNo=@param and ITAssetno is not null)		  
		 Begin
		  insert into tbl_IOP2P_Comments
		  select @param,'Approved through ITAssets','DirApprove','1',@HOE,DATEADD(MINUTE,2,getdate())
		 End 

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End
	   if(@flag='getApprovers') 		 		 
		 begin
			select isnull(dbo.getEmpName(HOE),'') VH,isnull(dbo.getEmpName(CXO),'')HOD,isnull(dbo.getEmpName(CFO),'')CFO,isnull(dbo.getEmpName(CEO),'')CEO,isnull(dbo.getEmpName(FC),'')FC
            from tbl_IOP2P_ItemRequest where PrNo=@param
		 End
	   if(@flag='getProjectCodes')
		 Begin
		  select [Description],Project_code from [196.1.115.199].[ORACLEFIN].[dbo].[XXANG_ANGEL_PROJECT_CODE] where Enabled_flag='y'
		 End		 		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails_01Apr2019
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails_01Apr2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,
		  REPLACE(REPLACE(Remark, CHAR(13), ''), CHAR(10), '')Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails_12Apr2019
-- --------------------------------------------------

--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails_12Apr2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,isnull(PONo,'')PONO,isnull(INVOICE_NUM,'') PINO,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,
		  REPLACE(REPLACE(Remark, CHAR(13), ''), CHAR(10), '')Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate,PONo,POfile_path from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo,a.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo,a.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End
	   if(@flag='getApprovers') 		 		 
		 begin
			select isnull(dbo.getEmpName(HOE),'') VH,isnull(dbo.getEmpName(CXO),'')HOD,isnull(dbo.getEmpName(CFO),'')CFO,isnull(dbo.getEmpName(CEO),'')CEO,isnull(dbo.getEmpName(FC),'')FC
            from tbl_IOP2P_ItemRequest where PrNo=@param
		 End		 		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails_18Apr2019
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

create proc [dbo].[usp_IOP2P_getDetails_18Apr2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,isnull(PONo,'')PONO,isnull(INVOICE_NUM,'') PINO,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,
		  REPLACE(REPLACE(Remark, CHAR(13), ''), CHAR(10), '')Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate,PONo,POfile_path,Project from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo,a.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo,a.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End
	   if(@flag='getApprovers') 		 		 
		 begin
			select isnull(dbo.getEmpName(HOE),'') VH,isnull(dbo.getEmpName(CXO),'')HOD,isnull(dbo.getEmpName(CFO),'')CFO,isnull(dbo.getEmpName(CEO),'')CEO,isnull(dbo.getEmpName(FC),'')FC
            from tbl_IOP2P_ItemRequest where PrNo=@param
		 End
	   if(@flag='getProjectCodes')
		 Begin
		  select [Description],Project_code from [196.1.115.199].[ORACLEFIN].[dbo].[XXANG_ANGEL_PROJECT_CODE] where Enabled_flag='y'
		 End		 		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails_23jan2020
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails_23jan2020]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   --select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	     select @param3=Access from vw_userroles where emp_no=@param2
	     select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType=@param and item != (case when @param3='user' then 'IT Equipments' else '' end)
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,isnull(PONo,'')PONO,isnull(INVOICE_NUM,'') PINO,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,
		  REPLACE(REPLACE(Remark, CHAR(13), ''), CHAR(10), '')Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate,PONo,POfile_path,Project from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo,a.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate
		  ,vm.Vendor_Name VendorName  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  left outer join (select distinct Vendor_ID,Vendor_Name from [196.1.115.199].Oraclefin.[dbo].[XXC_VENDOR_MASTER_DETAIL] )vm on a.VendorID=vm.Vendor_ID
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo,a.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate,vm.Vendor_Name
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		  if exists (select 1 from tbl_IOP2P_ItemRequest where PrNo=@param and ITAssetno is not null)		  
		 Begin
		  insert into tbl_IOP2P_Comments
		  select @param,'Approved through ITAssets','DirApprove','1',@HOE,DATEADD(MINUTE,2,getdate())
		 End 

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End
	   if(@flag='getApprovers') 		 		 
		 begin
			select isnull(dbo.getEmpName(HOE),'') VH,isnull(dbo.getEmpName(CXO),'')HOD,isnull(dbo.getEmpName(CFO),'')CFO,isnull(dbo.getEmpName(CEO),'')CEO,isnull(dbo.getEmpName(FC),'')FC
            from tbl_IOP2P_ItemRequest where PrNo=@param
		 End
	   if(@flag='getProjectCodes')
		 Begin
		  select [Description],Project_code from [196.1.115.199].[ORACLEFIN].[dbo].[XXANG_ANGEL_PROJECT_CODE] where Enabled_flag='y'
		 End		 		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails_23May2019
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

create proc [dbo].[usp_IOP2P_getDetails_23May2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   --select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	     select @param3=Access from vw_userroles where emp_no=@param2
	     select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType=@param and item != (case when @param3='user' then 'IT Equipments' else '' end)
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,isnull(PONo,'')PONO,isnull(INVOICE_NUM,'') PINO,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,
		  REPLACE(REPLACE(Remark, CHAR(13), ''), CHAR(10), '')Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate,PONo,POfile_path,Project from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo,a.PONo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo,a.PONo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		  if exists (select 1 from tbl_IOP2P_ItemRequest where PrNo=@param and ITAssetno is not null)		  
		 Begin
		  insert into tbl_IOP2P_Comments
		  select @param,'Approved through ITAssets','DirApprove','1',@HOE,DATEADD(MINUTE,2,getdate())
		 End 

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End
	   if(@flag='getApprovers') 		 		 
		 begin
			select isnull(dbo.getEmpName(HOE),'') VH,isnull(dbo.getEmpName(CXO),'')HOD,isnull(dbo.getEmpName(CFO),'')CFO,isnull(dbo.getEmpName(CEO),'')CEO,isnull(dbo.getEmpName(FC),'')FC
            from tbl_IOP2P_ItemRequest where PrNo=@param
		 End
	   if(@flag='getProjectCodes')
		 Begin
		  select [Description],Project_code from [196.1.115.199].[ORACLEFIN].[dbo].[XXANG_ANGEL_PROJECT_CODE] where Enabled_flag='y'
		 End		 		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails_27Mar2019
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails_27Mar2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,replace(a.Company,' (AFPL)','')Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc,
	 e.HOE_Name ApproverName,e.Access from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	 left outer join tbl_HODEmp_list e on a.emp_no=e.Emp_no
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code in('IO-VENDOR','IO-FOREIGN') and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  --select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null and Site_InActive_Date is null		  	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select Distinct PrNo,Case when [Status]=1 then 'Pending with HOE' when [Status]=-1 then 'Rejected By HOE' 
			 when [Status]=3 then 'Pending with HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=4 then 'Pending with CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=5 then 'Pending with CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=7 then 'Approved By FC' when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(-5) then Convert(varchar,CEO_Date,103)
			 when [status] =6 then 
			     case when CEO_Date is not null then Convert(varchar,Ceo_Date,103) when CFO_Date is not null then Convert(varchar,CFO_Date ,103)
			     when CXO_Date is not null then Convert(varchar,CXO_Date,103) when HOE_Date is not null then Convert(varchar,HOE_Date,103) End
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo,A.Warranty,isnull(A.[SGST%],'0.00')[SGST%],isnull(a.SGST_Amount,'0.00')SGST_Amount,
		  isnull(a.[CGST%],'0.00')[CGST%],isnull(a.CGST_Amount,'0.00')CGST_Amount,isnull(a.[IGST%],'0.00')[IGST%],isnull(a.IGST_Amount,'0.00')IGST_Amount,isnull(a.RoundoffAmt,'0.00')RoundoffAmt,
		  GstState,BillTo_Name,ShipTo_Name,[A/C Code] Expense,PI_Path,Vendor_Bill_Num,Convert(varchar,Vendor_Bill_Date,103) VendorBillDate from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no and c.access in('User','ITAssetUser')
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4, 
		  isnull(City,'')City,isnull([State],'')[State],isnull(Postal_Code,'') Postalcode  from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param and Entity_code=@param2
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End
	 if(@flag='UpdateItemAccCOde')
	   Begin
	    declare @HOE as varchar(20)
		declare @HOEDate as datetime
		select @HOE=a.Approved_BY,@HOEDate=a.Approved_Datetime from ITAssests.dbo.[tbl_RequestMaster] a
		inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNo
		where b.PrNo=@param
	    
	      update tbl_IOP2P_ItemRequest
		  set [A/C Code] = b.[A/C Code],
		  HOE= case when(a.ITAssetNo is not null ) then @HOE else HOE end,
		  HOE_Date = case when(a.ITAssetNo is not null ) then @HOEDate else HOE_Date end
		  from tbl_IOP2P_ItemRequest a
		  inner join tbl_IOP2P_ItemMaster b on a.ItemName=b.Item
		  Where a.PrNo=@param

		 exec usp_IOP2P_sendemailPRUpdate @param

	   End	   
	   if(@flag='UserAcess')
	    Begin
		  if not exists( select Emp_name from [dbo].[Vw_UserRoles] where emp_no=@param)
			 Begin
			    select 'False'Usrstatus,'you do not have acccess to IOP2P Portal' msg
				return
			 End
			 else
			  Begin
			    select 'True' Usrstatus
			  End
		End	
		if(@flag='getAcCodes')
		 Begin
		   select [A/C Description] AccDesc,[A/C Code]ACcode from tbl_IOP2P_ItemMaster
		 End		 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails07jan2019
-- --------------------------------------------------

--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'
CREATE proc [dbo].[usp_IOP2P_getDetails07jan2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,a.Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code='IO-VENDOR' and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param	     
		 select 'PR'+@param2+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest 
		End

	 if(@flag='SubmitReq')
	   	Begin    
			 declare @VendorNum as varchar(20)
			 declare @PrNo as varchar(50)

			 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
			 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

			 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
			 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
			 select 'Item Request Submitted Successfully.'
		End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select PrNo,Case when [Status]=0 then 'Pending' when [Status]=1 then 'Approved By HOD' when [Status]=-1 then 'Rejected By HOD'  
			 when [Status]=2 then 'Approved' when [Status]=-2 then 'Rejected' End as Status,
			 RequestedDate,ApprovedBY,ApprovedDate from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,103)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status] from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 if(@flag='DirApprove')
	   	 Begin
			if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
			 Begin
			   Update tbl_IOP2P_ItemRequest
			   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
			   where PrNo=@param
			 End
			Else
			 Begin
			  update  tbl_IOP2P_ItemRequest
			  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
			  where PrNo=@param
			 End				
		 End
	 if(@flag='DirReject')
	   	 Begin
		  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
			 Begin
			   Update tbl_IOP2P_ItemRequest
			   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
			   where PrNo=@param
			 End
			Else
			 Begin
				update  tbl_IOP2P_ItemRequest
				set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
				where PrNo=@param
			 End	
		 End
	 if(@flag='genInvoice')
		Begin
			declare @invNo as varchar(20)		
		    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
			select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		    Update tbl_IOP2P_ItemRequest
			set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
			where PrNo=@param

			select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails18jan2019
-- --------------------------------------------------

--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails18jan2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,a.Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code='IO-VENDOR' and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param	     
		 select 'PR'+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest 
		End

	 if(@flag='SubmitReq')
	   	Begin    
			 declare @VendorNum as varchar(20)
			 declare @PrNo as varchar(50)

			 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
			 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

			 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
			 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
			 select 'Item Request Submitted Successfully.'
		End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select PrNo,Case when [Status]=1 then 'Pending' when [Status]=3 then 'Approved By HOE' when [Status]=-1 then 'Rejected By HOE'  
			 when [Status]=4 then 'Approved By HOD' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=5 then 'Approved By CFO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=6 then 'Approved By CEO' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=7 then 'Approved By FC' when [Status]=-6 then 'Rejected By FC' End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,Convert(varchar,ApprovedDate,103)ApprovedDate from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Units,Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 if(@flag='genInvoice')
		Begin
			declare @invNo as varchar(20)		
		    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
			select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		    Update tbl_IOP2P_ItemRequest
			set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
			where PrNo=@param

			select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'') Pan_No, '' GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4 from 
		  [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_getDetails23jan2019
-- --------------------------------------------------
--usp_IOP2P_getDetails @flag='EstAmt', @param='Furniture And Fixtures' , @param2	='2-Drawer File Cabinet'

CREATE proc [dbo].[usp_IOP2P_getDetails23jan2019]
(
@flag varchar(100),
@param varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null,
@param12 varchar(100)=null,
@param13 varchar(100)=null,
@param14 varchar(20)=null,
@param15 varchar(20)=null,
@param16 varchar(20)=null,
@param17 varchar(20)=null,
@param18 varchar(20)=null,
@param19 varchar(10)=null,
@param20 varchar(200)=null,
@param21 varchar(200)=null,
@param22 varchar(200)=null
)
as
Begin
  if(@flag='empInfo')
    Begin
	 select a.Emp_No,a.Emp_Name,a.Branch_cd,a.Company,a.Department,a.Sub_Department,b.LOB_DESC as LOB,d.str_channel_desc as Channel,(a.Branch_cd+'_'+a.AttendanceLoc)BranchLoc from Risk.dbo.Emp_Info a
	 left outer join [196.1.115.237].Angelbroking.dbo.lobmaster b on a.LOB=b.LobCode
	 left outer join [196.1.115.237].Angelbroking.dbo.emplmst c on a.Emp_no=c.Emp_No
	 left outer join [196.1.115.237].Angelbroking.dbo.tbl_channel d on c.Channel_No=d.pid_tbl_channel
	  where a.EMP_No=@param
	 --select Isnull(max(PrNo),0)+1 from tbl_IOP2P_ItemRequest
    End
  if(@flag='Company')
    Begin
	  select Parent_Name,Entity_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE where entity_code in(131,171,201,221,231,301)
	End
	if(@flag='Branch')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' --and Branch_Type='STATE' --where [Description] like '%'+@param+'%'
		order by  [Description]
	 End
	 if(@flag='ShipTo')
     Begin	 
		select [Description],Branch_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE where Enabled_flag='Y' and Branch_Type!='STATE' --where [Description] like '%'+@param+'%' 	
		order by [Description]
	 End
	if(@flag='Department')
	 Begin
	   select Distinct Department,Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE 
	 End
	 if(@flag='subDept')
	 Begin
	   select Distinct SubDepartment,Sub_Department_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE where Department=@param or Department_code=@param
	 End
	 if(@flag='ItemMaster')
	 Begin
	   select Distinct Item,Item from tbl_IOP2P_ItemMaster where ItemType =case when (@param is null) then 'Capital-Non-IT' else @param end
	 End
	 if(@flag='SubItemMaster')
	 Begin
	   select Distinct SubItem,SubItem from tbl_IOP2P_ItemMaster where Item =case when (@param is null) then Item else @param end
	 End
	 if(@flag='ChannelCode')
	 Begin
		select [Description],channel_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_CHANNEL_CODE
	 End
	  if(@flag='LOB')
	   Begin
		select [Description],LOB_Code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_LOB_CODE
	   End
	 if(@flag='VendorName')
       Begin  
		select Distinct Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a		
		where Vendor_type_lookup_code='IO-VENDOR' and A.Entity_Code=@param and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Name
      End
     if(@flag='VendorSite')
       Begin  
        select Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param and Entity_Code=@param2 and Supplier_End_Date is null and Site_InActive_Date is null
		order by Vendor_Site_Code
       End
	 -- if(@flag='EstAmt')
	 -- Begin
	 --    /*@param=qty ,@param2=Item, @param3=SubItem*/		
		-- select cast(Itmcost * cast(@param  as int) as numeric(8,2)) EStCost from tbl_IOP2P_ItemMaster where Item=@param2 and SubItem=@param3
		--End	
      if(@flag='getUnits')
	   Begin
		 select Unit as Unit,Unit as Units from tbl_IOP2P_ItemMaster where Item = @param and SubItem=@param2		 
	   End
	  if(@flag='getPrNoVNum')
	    Begin
			/*@param2 -- Entity code*/
		  select Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param	     		 
		  select isnull((select  'PR' + right('00000'+ cast(max(replace(isnull(PRNO,0),'pr','')) +1 as varchar),6)),'PR000001')	from tbl_IOP2P_ItemRequest	 
		End

	 --if(@flag='SubmitReq')
	 --  	Begin    
		--	 declare @VendorNum as varchar(20)
		--	 declare @PrNo as varchar(50)

		--	 select @VendorNum=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18	     
		--	 select @PrNo='PR'+@param3+cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(SrNo)+1 as varchar)  from tbl_IOP2P_ItemRequest

		--	 insert into tbl_IOP2P_ItemRequest (PrNo,ItOption,Company,Branch,Department,SubDepartment,LOB,Channel,ItemName,SubItemName,ItmQty,EstCosts,Remark,RequestedBy,RequestedDate,ShipTO,BillTO,VendorID,VendorSite,VendorNumber,Rate)
		--	 values(@PrNo,@param2,@param3,@param4,@param5,@param6,@param7,@param8,@param9,@param10,@param11,@param12,@param13,@param14,getdate(),@param15,@param16,@param17,@param18,@VendorNum,@param19)  
		--	 select 'Item Request Submitted Successfully.'
		--End 
	 if(@flag='UpdateReq')
	   Begin
	         declare @VendorNo as varchar(10)
			 select @VendorNo=Vendor_Number from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_Site_ID=@param18

			update tbl_IOP2P_ItemRequest 
			set ItOption=@param2,Company=@param3,Branch=@param4,Department=@param5,SubDepartment=@param6,LOB=@param7,Channel=@param8,ItemName=@param9,SubItemName=@param10,ItmQty=@param11,
			EstCosts=@param12,Remark=@param13,RequestedBy=@param14,RequestedDate=getdate(),ShipTO=@param15,BillTO=@param16,VendorID=@param17,VendorSite=@param18,VendorNumber=@VendorNo,
			Quotation1_Path=@param20,Quotation2_Path=@param21,Quotation3_Path=@param22,Rate=@param19
			where PrNo=@param

			select 'Request with Pr No: '+@param+' has been updated'
	   End
	   if(@flag='getUserRequests')
	    Begin
			 select PrNo,Case when [Status]=1 then 'Pending with HOE' when [Status]=3 then 'Pending with HOD' when [Status]=-1 then 'Rejected By HOE'  
			 when [Status]=4 then 'Pending with CFO' when [Status]=-3 then 'Rejected By HOD'
			 when [Status]=5 then 'Pending with CEO' when [Status]=-4 then 'Rejected By CFO' 
			 when [Status]=6 then 'Pending with FC' when [Status]=-5 then 'Rejected By CEO' 
			 when [Status]=7 then 'Approved by FC' when [Status]=-6 then 'Rejected By FC' 
			 when [Status]=8 then 'Invoice Created'
			 End as Status,
			 Convert(varchar,RequestedDate,103)RequestedDate,ApprovedBY,
			 --Convert(varchar,ApprovedDate,103)ApprovedDate 
			 case when [Status] in(3,-1) then Convert(varchar,HOE_Date,103) when [Status] in(4,-3) then Convert(varchar,CXO_Date,103)
			 when [Status] in(5,-4) Then Convert(varchar,CFO_Date,103) when [Status] in(6,-5) then Convert(varchar,CEO_Date,103)
			 when [Status] in(7,-6) then Convert(varchar,FC_Date,103)  when [status] =8 then Convert(varchar,Update_Invoice_date,103) end ApprovedDate 
			 from tbl_IOP2P_ItemRequest 
			 where RequestedBy=@param and PrNo is not null order by requesteddate desc
			--select  from tbl_IOP2P_ItemRequest where PrNo is not null order by requesteddate desc
		End
	   if(@flag='UsrDetails_PrNo')
	   	 Begin
		  select b.emp_no,b.Emp_name,SrNo,PrNo,ItOption,a.Company,b.Branch_cd as branch,a.Department,SubDepartment,a.LOB,Channel,ItemName,SubItemName,ItmQty,cast(EstCosts as numeric(10,2))EstCosts,Units,Remark,VendorID,
		  (b.Branch_cd+'_'+b.AttendanceLoc)BranchLoc,VendorSite,ShipTO,BillTO,Quotation1_Path,Quotation2_Path,Quotation3_Path,Convert(varchar,DeliveryDate,101)DeliveryDate,Rate,
		  Convert(varchar,Fromdate,103)Fromdate, convert(varchar,Todate,103)Todate,A.[Status],A.PaymentTerms,A.ITAssetNo from tbl_IOP2P_ItemRequest a 
		  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
		  where a.PrNo=@param
		 End	
		  	 

	 --if(@flag='DirApprove')
	 --  	 Begin
		--	if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=case when status=0 then 1 when status=1 then 2 end ,POApprovedBY =@param14,POApprovedDate=getdate() 
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--	  update  tbl_IOP2P_ItemRequest
		--	  set Status=1,ApprovedBY=@param14,ApprovedDate=getdate()
		--	  where PrNo=@param
		--	 End				
		-- End
	 --if(@flag='DirReject')
	 --  	 Begin
		--  if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param14)
		--	 Begin
		--	   Update tbl_IOP2P_ItemRequest
		--	   set Status=-2,POApprovedBY =@param14,POApprovedDate=getdate()
		--	   where PrNo=@param
		--	 End
		--	Else
		--	 Begin
		--		update  tbl_IOP2P_ItemRequest
		--		set Status= case when status=0 then -1 when status=1 then -2 end,ApprovedBY=@param14,ApprovedDate=getdate()
		--		where PrNo=@param
		--	 End	
		-- End
	 --if(@flag='genInvoice')
		--Begin
		--	declare @invNo as varchar(20)		
		--    --select @invNo=cast(DatePart(MONTH,getdate()) as varchar)+ substring(cast(DatePart(YEAR,getdate()) as varchar),3,2)+cast(max(substring(Invoice_Num,6,(len(Invoice_Num)-6)))+1 as varchar)  from tbl_IOP2P_ItemRequest 
		--	select @invNo=max(isnull(Invoice_Num,0))+1 from tbl_IOP2P_ItemRequest
		--    Update tbl_IOP2P_ItemRequest
		--	set Vendor_Bill_Num=@param2,Vendor_Bill_Date =@param3,INVOICE_NUM=@invNo,Update_Invoice_date=getdate(),Status=8
		--	where PrNo=@param

		--	select 'Invoice No: '+@invNo+' has been generated for PrNo: '+@param
		--End	     
     if(@flag='GetInvoicelists')
		Begin
		  select a.PrNo, c.Emp_name RequestedBy,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103) RequestedDate, sum(a.EstCosts) [TotalCosts],a.RequestedDate reqdate  from tbl_IOP2P_ItemRequest a
		  left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
		  inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no
		  where a.Status=7 and RequestedBy=@param
		  group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,Convert(varchar,a.RequestedDate,103),a.RequestedDate
		  order by a.RequestedDate desc
		End
	 if(@flag='Vendordetails')
		Begin
		  select Distinct isnull(Pan_No,'N/A') Pan_No, isnull(GST_Registration_Number,'N/A') GST, isnull(Address_Line1,'')Address_Line1 ,isnull(Address_Line2,'')Address_Line2,isnull(Address_Line3,'')Address_Line3,isnull(Address_Line4,'')Address_Line4 from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where  Vendor_ID=@param and Entity_Code=@param2 and  Supplier_End_Date is null 
		  and Site_InActive_Date is null		  
		End
	 if(@flag='POFIleUpdate')
	   Begin
	     update tbl_IOP2P_ItemRequest set POfile_path=@param2 where PrNo=@param
	    End
	 if(@flag='getStateGSTNo')
	   Begin
	     select Distinct GSTNO StateGstNo from tbl_IOP2P_GSTNoMaster where [State]=@param
	   End
	 if(@flag='getGstStates')
	   Begin
	     select [State],[State] from  tbl_IOP2P_GSTNoMaster where [Entity_Code]=@param
	   End	 
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_ITAssetdetails
-- --------------------------------------------------
CREATE proc [dbo].[usp_IOP2P_ITAssetdetails]
(
 @flag varchar(100),
 @param varchar(20) =null
)
As
BEGIN
  if(@flag='getReqDetails')
   Begin
	  select b.emp_no,b.Emp_name,Model_Name  SubItemName, Model_Quantity ItmQty,Request_Date,Requested_By,User_Remark ,Status_Code from ITAssests.dbo.[tbl_RequestMaster] a
	  left outer join Risk.dbo.Emp_Info b on a.Requested_By=b.emp_no 
	  left outer join ITAssests.[dbo].[tbl_ProductModelMaster] c on a.Model_No=c.Model_Id
	  where request_id=@param --@param - request_id
	  --and status_code='A'
	  return
   End
    if(@flag='getReqs')
   Begin
	  select a.Request_Id,b.Emp_name RequestedBy,Request_Date,Status_Code from ITAssests.dbo.[tbl_RequestMaster] a
	  left outer join Risk.dbo.Emp_Info b on a.Requested_By=b.emp_no 
	  left outer join tbl_IOP2P_ItemRequest c on a.Request_Id=c.ITAssetNo
	  where status_code ='A' and ITAssetNo is null
	  order by request_date desc  
	  return
   End
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_POdetails
-- --------------------------------------------------

CREATE proc [dbo].[usp_IOP2P_POdetails]
(
@flag varchar(50),
@param1 varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null
)
As
Begin
if(@flag='POdetails')
 Begin
 /*@param1=emp_no , @param2=PRNO*/
     select Emp_No,Emp_Name,Branch_cd from Risk.dbo.Emp_Info where EMP_No=@param1
     select a.PRNO,a.SubItemName,b.Parent_Name,A.ItmQty,A.Rate UnitCost ,A.EstCosts TotalCosts,A.BillTO,A.ShipTO,A.VendorID,A.VendorSite from tbl_IOP2P_ItemRequest a
	 left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	 left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	 where Prno=@param2
 End 
 if(@flag='GetItemRequests')
  Begin 
        if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param1 )
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a			
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where a.PrNo is not null and ApprovedBY is not null and a.status=1 order by a.requesteddate desc 
		  End
		Else
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a
			inner join Risk.dbo.Emp_Info d on a.RequestedBy=d.emp_no
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where --d.Senior='E57731' and d.status='A' and 
			a.PrNo is not null and ApprovedBY is null order by a.requesteddate desc 
		 End    
  End
  
  if(@flag='staggingList')
   Begin
      select distinct PANo PINo,b.Emp_name RequestedBy,Convert(varchar,Updateddate,103) RequestedDate,Amount TotalCosts,a.PrNo from tbl_IOP2P_Advance a
	  left outer join Risk.dbo.Emp_Info b on a.UpdatedBy=b.emp_no
	  left outer join tbl_IOP2P_ItemRequest c on a.prno=c.prno
	  where a.Status is null and c.Status in(7,8)
		   --   select distinct a.INVOICE_NUM PINo,b.Emp_name RequestedBy,Convert(varchar,RequestedDate,103)RequestedDate,Total TotalCosts,a.PrNo from tbl_IOP2P_ItemRequest a
			  --left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
			  --where a.[status]=8 and BatchName is null
			  --union all
			  --select distinct PANo,b.Emp_name,Convert(varchar,Updateddate,103),Amount,a.PrNo from tbl_IOP2P_Advance a
			  --left outer join Risk.dbo.Emp_Info b on a.UpdatedBy=b.emp_no 
			  --where a.Status is null
   End
   if(@flag='chkPrStatus')
   Begin
      select a.PrNo, a.[status],a.BatchName from tbl_IOP2P_ItemRequest a	  
	  where PrNo=@param1
   End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_POdetails_01Apr2019
-- --------------------------------------------------

CREATE proc [dbo].[usp_IOP2P_POdetails_01Apr2019]
(
@flag varchar(50),
@param1 varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null
)
As
Begin
if(@flag='POdetails')
 Begin
 /*@param1=emp_no , @param2=PRNO*/
     select Emp_No,Emp_Name,Branch_cd from Risk.dbo.Emp_Info where EMP_No=@param1
     select a.PRNO,a.SubItemName,b.Parent_Name,A.ItmQty,A.Rate UnitCost ,A.EstCosts TotalCosts,A.BillTO,A.ShipTO,A.VendorID,A.VendorSite from tbl_IOP2P_ItemRequest a
	 left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	 left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	 where Prno=@param2
 End 
 if(@flag='GetItemRequests')
  Begin 
        if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param1 )
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a			
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where a.PrNo is not null and ApprovedBY is not null and a.status=1 order by a.requesteddate desc 
		  End
		Else
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a
			inner join Risk.dbo.Emp_Info d on a.RequestedBy=d.emp_no
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where --d.Senior='E57731' and d.status='A' and 
			a.PrNo is not null and ApprovedBY is null order by a.requesteddate desc 
		 End    
  End
  
  if(@flag='staggingList')
   Begin
      select distinct a.PrNo,b.Emp_name RequestedBy,Convert(varchar,RequestedDate,103)RequestedDate,Cast(Total as numeric(10,2)) TotalCosts,'' Parent_Name,'' Branch_cd from tbl_IOP2P_ItemRequest a
	  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
	  where a.[status]=8 and BatchName is null
   End
   if(@flag='chkPrStatus')
   Begin
      select a.PrNo, a.[status],a.BatchName from tbl_IOP2P_ItemRequest a	  
	  where PrNo=@param1
   End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_POdetails_25feb2019
-- --------------------------------------------------
create proc [dbo].[usp_IOP2P_POdetails_25feb2019]
(
@flag varchar(50),
@param1 varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null
)
As
Begin
if(@flag='POdetails')
 Begin
 /*@param1=emp_no , @param2=PRNO*/
     select Emp_No,Emp_Name,Branch_cd from Risk.dbo.Emp_Info where EMP_No=@param1
     select a.PRNO,a.SubItemName,b.Parent_Name,A.ItmQty,A.Rate UnitCost ,A.EstCosts TotalCosts,A.BillTO,A.ShipTO,A.VendorID,A.VendorSite from tbl_IOP2P_ItemRequest a
	 left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	 left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	 where Prno=@param2
 End
 if(@flag='VendorName')
  Begin  
    select Vendor_Name,Vendor_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail  a
	 inner join tbl_IOP2P_ItemRequest b on a.Entity_Code=b.Company
	where Vendor_type_lookup_code='IO-VENDOR' and b.PrNo=@param1 -- and InActive_Date >getdate() and Supplier_End_Date>getdate()
  End
 if(@flag='VendorSite')
  Begin  
    select  distinct top 10 Vendor_Site_Code,Vendor_Site_ID from [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail where Vendor_ID=@param1
  End
 if(@flag='GetItemRequests')
  Begin 
        if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param1 )
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a			
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where a.PrNo is not null and ApprovedBY is not null and a.status=1 order by a.requesteddate desc 
		  End
		Else
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a
			inner join Risk.dbo.Emp_Info d on a.RequestedBy=d.emp_no
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where --d.Senior='E57731' and d.status='A' and 
			a.PrNo is not null and ApprovedBY is null order by a.requesteddate desc 
		 End
    --  select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,c.ItmCost UnitCost ,a.EstCosts TotalCosts from tbl_IOP2P_ItemRequest a
	 --left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	 --left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
  End
  --if(@flag='UpdatePOdetails')
  -- Begin
  --    declare @POno as varchar(10)
	 -- select @POno=Max(isnull(PONo,0))+1 from tbl_IOP2P_ItemRequest
  --   update tbl_IOP2P_ItemRequest set [Status]=2,Approvedby=@param2,ApprovedDate=getdate(),BillTO=@param3,ShipTO=@param4,VendorID=@param5,
	 --VendorSite=@param6,ApprovedByRemark=@param7,GST=@param8,[Total]=@param9,PODate=convert(date,@param10,103), PONo=@POno
	 --where PrNo=@param11

	 --select 'Details Updated Successfully'
  -- End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_POdetails_25jun2019
-- --------------------------------------------------

create proc [dbo].[usp_IOP2P_POdetails_25jun2019]
(
@flag varchar(50),
@param1 varchar(100)=null,
@param2 varchar(100)=null,
@param3 varchar(100)=null,
@param4 varchar(100)=null,
@param5 varchar(100)=null,
@param6 varchar(100)=null,
@param7 varchar(100)=null,
@param8 varchar(100)=null,
@param9 varchar(100)=null,
@param10 varchar(100)=null,
@param11 varchar(100)=null
)
As
Begin
if(@flag='POdetails')
 Begin
 /*@param1=emp_no , @param2=PRNO*/
     select Emp_No,Emp_Name,Branch_cd from Risk.dbo.Emp_Info where EMP_No=@param1
     select a.PRNO,a.SubItemName,b.Parent_Name,A.ItmQty,A.Rate UnitCost ,A.EstCosts TotalCosts,A.BillTO,A.ShipTO,A.VendorID,A.VendorSite from tbl_IOP2P_ItemRequest a
	 left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	 left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
	 where Prno=@param2
 End 
 if(@flag='GetItemRequests')
  Begin 
        if exists(select '1' from Risk.dbo.emp_info where Sub_Department='Accounts' and designation='Chief Manager' and emp_no=@param1 )
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a			
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where a.PrNo is not null and ApprovedBY is not null and a.status=1 order by a.requesteddate desc 
		  End
		Else
		  Begin
			select a.PrNo,a.SubItemName,b.Parent_Name,a.ItmQty,A.Rate UnitCost ,(cast(a.Rate as money) * cast(A.ItmQty as numeric)) TotalCosts from tbl_IOP2P_ItemRequest a
			inner join Risk.dbo.Emp_Info d on a.RequestedBy=d.emp_no
			left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
			--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
			where --d.Senior='E57731' and d.status='A' and 
			a.PrNo is not null and ApprovedBY is null order by a.requesteddate desc 
		 End    
  End
  
  if(@flag='staggingList')
   Begin
      select distinct a.INVOICE_NUM PINo,b.Emp_name RequestedBy,Convert(varchar,RequestedDate,103)RequestedDate,Total TotalCosts,a.PrNo from tbl_IOP2P_ItemRequest a
	  left outer join Risk.dbo.Emp_Info b on a.RequestedBy=b.emp_no 
	  where a.[status]=8 and BatchName is null
	  union all
	  select distinct PANo,b.Emp_name,Convert(varchar,Updateddate,103),Amount,a.PrNo from tbl_IOP2P_Advance a
	  left outer join Risk.dbo.Emp_Info b on a.UpdatedBy=b.emp_no 
	  where a.Status is null
   End
   if(@flag='chkPrStatus')
   Begin
      select a.PrNo, a.[status],a.BatchName from tbl_IOP2P_ItemRequest a	  
	  where PrNo=@param1
   End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_sendemailPRUpdate
-- --------------------------------------------------

-- usp_IOP2P_sendemailPRUpdate 'PR000040'
CREATE proc [dbo].[usp_IOP2P_sendemailPRUpdate]
(
@PrNo varchar(50)
--@user varchar(20)
)
As
BEGIN
	--declare @PrNo varchar(50) ='PR000040'
	declare @html  varchar(max)=''
	declare @htmluser varchar(max)=''
	declare @RequestedBy varchar(100) =''
	Declare @htmlApprover varchar(max)=''
	declare @ApproverName varchar(500) =''
	declare @ApproverName2 varchar(500) =''
	declare @username varchar(200)=''
	declare @status varchar(5)=''
	declare @userEmail varchar(100)
	declare @email2 varchar(100)
	declare @PO varchar(20)
	declare @PI varchar(20)
	declare @ApproverId as varchar(20)
	declare @ApproverID2 as varchar(20)
	declare @subj varchar(200)
	declare @subj2 varchar(200)

	set @subj='Purchase Order'
	set @subj2='Purchase Order'


	select top 1 @status=a.Status,@username=b.emp_name,@userEmail=b.email,--@ApproverId=C.UpdatedBy,@ApproverName=dbo.getEmpName(updatedBY),
	 @ApproverId= case when (a.status =1) then b.HOE else C.UpdatedBy end,
     @ApproverName=case when (a.status =1) then b.HOE_Name else  dbo.getEmpName(updatedBY) end,
	--@ApproverName=case when(a.Status in(1,3,-1)) then b.HOE_Name when (a.Status in (4,-3)) then b.CXO_Name when (a.Status in (5,-4)) then b.CFO_Name when (a.Status in(6,-5)) then b.CEO_Name
	--				   when (a.Status in (7,-6)) then b.FC_Name end,
	-- @ApproverId=case when(a.Status in(1,3,-1)) then b.HOE when (a.Status in (4,-3)) then b.CXO when (a.Status in (5,-4)) then b.CFO when (a.Status in(6,-5)) then b.CEO
	--				   when (a.Status in (7,-6)) then b.FC end,
	 @ApproverName2 =case when(a.Status=3) then b.CXO_Name when (a.Status=4) then b.CFO_Name when (a.Status=5) then b.CEO_Name when (a.Status=6) then b.FC_Name
					   end,
	@ApproverID2 =  case when(a.Status=3) then b.CXO when (a.Status=4) then b.CFO when (a.Status=5) then b.CEO when (a.Status=6) then b.FC
					   end,
					   @PO=a.PONo,@PI=a.INVOICE_NUM
	from tbl_IOP2P_ItemRequest a
	left outer join Vw_UserRoles b on a.RequestedBy=b.emp_no
	left outer join tbl_IOP2P_Comments c on a.PrNo=c.PrNo
	 where a.Prno=@PrNo
	 order by c.Level desc
	 

	--set @userEmail='leon.vaz@angelbroking.com'	     

	set @html= @html + '<table border="1"><tr><th>PR No</th><th>Requested By</th><th>Company</th><th>Branch</th><th>Department</th><th>Expense Type</th><th>Date</th><th>Amount</th><th>Remark</th></tr>'
	select @html=@html+'<tr><td>'+a.PrNo+'</td><td>'+ c.Emp_name+'</td><td>'+b.Parent_Name+'</td><td>'+c.Branch_cd+'</td><td>'+ isnull(d.Department,'') +'</td><td>'+a.ItOption+'</td><td>'+Convert(varchar,a.RequestedDate,103)+'</td><td>'+ Cast(sum(a.EstCosts)

 as varchar(20))+'</td><td>'+a.Remark+'</td></tr>' 
	from tbl_IOP2P_ItemRequest a left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no 
	left outer join (select  distinct Department,department_code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE) d on a.Department=d.Department_code
	where a.PrNo=@PrNo 
    group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,d.Department,a.ItOption,Convert(varchar,a.RequestedDate,103),a.Remark
	set @html= @html + '</table>'
	--print @html
	
	if(cast(@status as numeric)<0)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Rejected' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been Rejected by '+@ApproverName+'.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print @htmluser

		--set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @RequestedBy+ '</b>.<br><br> Kindly login into P2P to update. <br>'
		--set @htmlApprover = @htmlApprover + @html
		--print @htmlApprover

		 --set @userEmail='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName
		 
	 End
	else if(@status=1)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Raised' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been raised and sent to '+@ApproverName+' for approval.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print (@htmluser)

		set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending'
		set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @username + '</b>.<br><br> Kindly login into P2P(Procure to Pay) for further action. <br>'
		set @htmlApprover = @htmlApprover + @html
		--print (@htmlApprover)

		 --set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverId

	 End
   else if(@status=7)
    Begin
	   set @subj =@subj +'--PO Generated: '+@PO
	   set @htmluser='Dear '+@username+',<br><br> Your PO has been generated with PO No: '+@PO + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		-- set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	else if(@status=8)
    Begin
	   set @subj =@subj +'--Invoice Generated: '+@PI
	   set @htmluser='Dear '+@username+',<br><br> Your Invoice has been generated with PI No: '+@PI + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 --set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	 else if(@status=6)
    Begin
	     set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending' 
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj =@subj +'-' +@PrNo +'--Approved by '+@ApproverName
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 --print @htmluser
		 --set @email2='leon.vaz@angelbroking.com'
		  select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	End
   else
     Begin
	     set @subj =@subj +'-' +@PrNo +'--Approval Pending'
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved by '+@ApproverName+' , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj2 =@subj2 +'-' +@PrNo +'--Approved by '+@ApproverName
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved by '+@ApproverName+' and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		-- set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	 End
	
	--Email to user
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='FCTeam', 
	@recipients = @userEmail,
	@blind_copy_recipients='sachindewoolkar@angelbroking.com;shailendra.bharati@angelbroking.com;Leon.vaz@angelBroking.com',
	--@copy_recipients= @COPY, 
	@subject = @subj, 
	@body_format = 'HTML', 
	@body =@htmluser 	


	if(@email2 is not null and @email2!='')
	  Begin
		--email to approvers
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='FCTeam', 
		@recipients = @email2,
		@blind_copy_recipients='sachindewoolkar@angelbroking.com;shailendra.bharati@angelbroking.com;Leon.vaz@angelBroking.com',
		--@copy_recipients= @COPY, 
		@subject = @subj2, 
		@body_format = 'HTML', 
		@body =@htmlApprover 	
       end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_sendemailPRUpdate_02Mar2019
-- --------------------------------------------------
-- usp_IOP2P_sendemailPRUpdate 'PR000040'
create proc [dbo].[usp_IOP2P_sendemailPRUpdate_02Mar2019]
(
@PrNo varchar(50)
--@user varchar(20)
)
As
BEGIN
	--declare @PrNo varchar(50) ='PR000040'
	declare @html  varchar(max)=''
	declare @htmluser varchar(max)=''
	declare @RequestedBy varchar(100) =''
	Declare @htmlApprover varchar(max)=''
	declare @ApproverName varchar(500) =''
	declare @ApproverName2 varchar(500) =''
	declare @username varchar(200)=''
	declare @status varchar(5)=''
	declare @userEmail varchar(100)
	declare @email2 varchar(100)
	declare @PO varchar(20)
	declare @PI varchar(20)
	declare @ApproverId as varchar(20)
	declare @ApproverID2 as varchar(20)

	select @status=a.Status,@username=b.emp_name,@userEmail=b.email,
	@ApproverName=case when(a.Status in(1,3,-1)) then b.HOE_Name when (a.Status in (4,-3)) then b.CXO_Name when (a.Status in (5,-4)) then b.CFO_Name when (a.Status in(6,-5)) then b.CEO_Name
					   when (a.Status in (7,-6)) then b.FC_Name end,
	 @ApproverId=case when(a.Status in(1,3,-1)) then b.HOE when (a.Status in (4,-3)) then b.CXO when (a.Status in (5,-4)) then b.CFO when (a.Status in(6,-5)) then b.CEO
					   when (a.Status in (7,-6)) then b.FC end,
	 @ApproverName2 =case when(a.Status=3) then b.CXO_Name when (a.Status=4) then b.CFO_Name when (a.Status=5) then b.CEO_Name when (a.Status=6) then b.FC_Name
					   end,
	@ApproverID2 =  case when(a.Status=3) then b.CXO when (a.Status=4) then b.CFO when (a.Status=5) then b.CEO when (a.Status=6) then b.FC
					   end,
					   @PO=a.PONo,@PI=a.INVOICE_NUM
	from tbl_IOP2P_ItemRequest a
	left outer join Vw_UserRoles b on a.RequestedBy=b.emp_no
	 where a.Prno=@PrNo
	 

	--set @userEmail='leon.vaz@angelbroking.com'	     

	set @html= @html + '<table border="1"><tr><th>PR No</th><th>Requested By</th><th>Company</th><th>Branch</th><th>Department</th><th>Expense Type</th><th>Date</th><th>Amount</th><th>Remark</th></tr>'
	select @html=@html+'<tr><td>'+a.PrNo+'</td><td>'+ c.Emp_name+'</td><td>'+b.Parent_Name+'</td><td>'+c.Branch_cd+'</td><td>'+ isnull(d.Department,'') +'</td><td>'+a.ItOption+'</td><td>'+Convert(varchar,a.RequestedDate,103)+'</td><td>'+ Cast(sum(a.EstCosts) as varchar(20))+'</td><td>'+a.Remark+'</td></tr>' 
	from tbl_IOP2P_ItemRequest a left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no 
	left outer join (select  distinct Department,department_code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE) d on a.Department=d.Department_code
	where a.PrNo=@PrNo 
    group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,d.Department,a.ItOption,Convert(varchar,a.RequestedDate,103),a.Remark
	set @html= @html + '</table>'
	--print @html
	
	if(cast(@status as numeric)<0)
	 Begin
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been Rejected by '+@ApproverName+'.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print @htmluser

		--set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @RequestedBy+ '</b>.<br><br> Kindly login into P2P to update. <br>'
		--set @htmlApprover = @htmlApprover + @html
		--print @htmlApprover

		 --set @userEmail='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName
		 
	 End
	else if(@status=1)
	 Begin
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been raised and sent to '+@ApproverName+' for approval.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print (@htmluser)

		set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @username + '</b>.<br><br> Kindly login into P2P(Procure to Pay) for further action. <br>'
		set @htmlApprover = @htmlApprover + @html
		--print (@htmlApprover)

		 --set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverId

	 End
   else if(@status=7)
    Begin
	   set @htmluser='Dear '+@username+',<br><br> Your PO has been generated with PO No: '+@PO + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		-- set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	else if(@status=8)
    Begin
	   set @htmluser='Dear '+@username+',<br><br> Your Invoice has been generated with PI No: '+@PI + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 --set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	 else if(@status=6)
    Begin
	    set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover


		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 --print @htmluser
		 --set @email2='leon.vaz@angelbroking.com'
		  select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	End
   else
     Begin
	   set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved by '+@ApproverName+' , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover


		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved by '+@ApproverName+' and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		-- set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	 End
	
	--Email to user
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='FCTeam', 
	@recipients = @userEmail,
	@blind_copy_recipients='sachindewoolkar@angelbroking.com;Leon.vaz@angelBroking.com',
	--@copy_recipients= @COPY, 
	@subject = 'IOP2P - Purchase Order', 
	@body_format = 'HTML', 
	@body =@htmluser 	


	if(@email2 is not null and @email2!='')
	  Begin
		--email to approvers
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='FCTeam', 
		@recipients = @email2,
		@blind_copy_recipients='sachindewoolkar@angelbroking.com;Leon.vaz@angelBroking.com',
		--@copy_recipients= @COPY, 
		@subject = 'IOP2P - Purchase Order', 
		@body_format = 'HTML', 
		@body =@htmlApprover 	
       end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_sendemailPRUpdate_18Apr2019
-- --------------------------------------------------

-- usp_IOP2P_sendemailPRUpdate 'PR000040'
CREATE proc [dbo].[usp_IOP2P_sendemailPRUpdate_18Apr2019]
(
@PrNo varchar(50)
--@user varchar(20)
)
As
BEGIN
	--declare @PrNo varchar(50) ='PR000040'
	declare @html  varchar(max)=''
	declare @htmluser varchar(max)=''
	declare @RequestedBy varchar(100) =''
	Declare @htmlApprover varchar(max)=''
	declare @ApproverName varchar(500) =''
	declare @ApproverName2 varchar(500) =''
	declare @username varchar(200)=''
	declare @status varchar(5)=''
	declare @userEmail varchar(100)
	declare @email2 varchar(100)
	declare @PO varchar(20)
	declare @PI varchar(20)
	declare @ApproverId as varchar(20)
	declare @ApproverID2 as varchar(20)
	declare @subj varchar(200)
	declare @subj2 varchar(200)

	set @subj='Purchase Order'
	set @subj2='Purchase Order'


	select @status=a.Status,@username=b.emp_name,@userEmail=b.email,
	@ApproverName=case when(a.Status in(1,3,-1)) then b.HOE_Name when (a.Status in (4,-3)) then b.CXO_Name when (a.Status in (5,-4)) then b.CFO_Name when (a.Status in(6,-5)) then b.CEO_Name
					   when (a.Status in (7,-6)) then b.FC_Name end,
	 @ApproverId=case when(a.Status in(1,3,-1)) then b.HOE when (a.Status in (4,-3)) then b.CXO when (a.Status in (5,-4)) then b.CFO when (a.Status in(6,-5)) then b.CEO
					   when (a.Status in (7,-6)) then b.FC end,
	 @ApproverName2 =case when(a.Status=3) then b.CXO_Name when (a.Status=4) then b.CFO_Name when (a.Status=5) then b.CEO_Name when (a.Status=6) then b.FC_Name
					   end,
	@ApproverID2 =  case when(a.Status=3) then b.CXO when (a.Status=4) then b.CFO when (a.Status=5) then b.CEO when (a.Status=6) then b.FC
					   end,
					   @PO=a.PONo,@PI=a.INVOICE_NUM
	from tbl_IOP2P_ItemRequest a
	left outer join Vw_UserRoles b on a.RequestedBy=b.emp_no
	 where a.Prno=@PrNo
	 

	--set @userEmail='leon.vaz@angelbroking.com'	     

	set @html= @html + '<table border="1"><tr><th>PR No</th><th>Requested By</th><th>Company</th><th>Branch</th><th>Department</th><th>Expense Type</th><th>Date</th><th>Amount</th><th>Remark</th></tr>'
	select @html=@html+'<tr><td>'+a.PrNo+'</td><td>'+ c.Emp_name+'</td><td>'+b.Parent_Name+'</td><td>'+c.Branch_cd+'</td><td>'+ isnull(d.Department,'') +'</td><td>'+a.ItOption+'</td><td>'+Convert(varchar,a.RequestedDate,103)+'</td><td>'+ Cast(sum(a.EstCosts)
 as varchar(20))+'</td><td>'+a.Remark+'</td></tr>' 
	from tbl_IOP2P_ItemRequest a left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no 
	left outer join (select  distinct Department,department_code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE) d on a.Department=d.Department_code
	where a.PrNo=@PrNo 
    group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,d.Department,a.ItOption,Convert(varchar,a.RequestedDate,103),a.Remark
	set @html= @html + '</table>'
	--print @html
	
	if(cast(@status as numeric)<0)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Rejected' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been Rejected by '+@ApproverName+'.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print @htmluser

		--set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @RequestedBy+ '</b>.<br><br> Kindly login into P2P to update. <br>'
		--set @htmlApprover = @htmlApprover + @html
		--print @htmlApprover

		 --set @userEmail='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName
		 
	 End
	else if(@status=1)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Raised' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been raised and sent to '+@ApproverName+' for approval.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print (@htmluser)

		set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending'
		set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @username + '</b>.<br><br> Kindly login into P2P(Procure to Pay) for further action. <br>'
		set @htmlApprover = @htmlApprover + @html
		--print (@htmlApprover)

		 --set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverId

	 End
   else if(@status=7)
    Begin
	   set @subj =@subj +'--PO Generated: '+@PO
	   set @htmluser='Dear '+@username+',<br><br> Your PO has been generated with PO No: '+@PO + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		-- set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	else if(@status=8)
    Begin
	   set @subj =@subj +'--Invoice Generated: '+@PI
	   set @htmluser='Dear '+@username+',<br><br> Your Invoice has been generated with PI No: '+@PI + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 --set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	 else if(@status=6)
    Begin
	     set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending' 
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj =@subj +'-' +@PrNo +'--Approved by '+@ApproverName
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 --print @htmluser
		 --set @email2='leon.vaz@angelbroking.com'
		  select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	End
   else
     Begin
	     set @subj =@subj +'-' +@PrNo +'--Approved by '+@ApproverName
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved by '+@ApproverName+' , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending'
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved by '+@ApproverName+' and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		-- set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	 End
	
	--Email to user
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='FCTeam', 
	@recipients = @userEmail,
	@blind_copy_recipients='sachindewoolkar@angelbroking.com;bhavik.shingala@angelbroking.com;Leon.vaz@angelBroking.com',
	--@copy_recipients= @COPY, 
	@subject = 'IOP2P - Purchase Order', 
	@body_format = 'HTML', 
	@body =@htmluser 	


	if(@email2 is not null and @email2!='')
	  Begin
		--email to approvers
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='FCTeam', 
		@recipients = @email2,
		@blind_copy_recipients='sachindewoolkar@angelbroking.com;bhavik.shingala@angelbroking.com;Leon.vaz@angelBroking.com',
		--@copy_recipients= @COPY, 
		@subject = 'IOP2P - Purchase Order', 
		@body_format = 'HTML', 
		@body =@htmlApprover 	
       end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_sendemailPRUpdate_23Apr2019
-- --------------------------------------------------
-- usp_IOP2P_sendemailPRUpdate 'PR000040'
CREATE proc [dbo].[usp_IOP2P_sendemailPRUpdate_23Apr2019]
(
@PrNo varchar(50)
--@user varchar(20)
)
As
BEGIN
	--declare @PrNo varchar(50) ='PR000040'
	declare @html  varchar(max)=''
	declare @htmluser varchar(max)=''
	declare @RequestedBy varchar(100) =''
	Declare @htmlApprover varchar(max)=''
	declare @ApproverName varchar(500) =''
	declare @ApproverName2 varchar(500) =''
	declare @username varchar(200)=''
	declare @status varchar(5)=''
	declare @userEmail varchar(100)
	declare @email2 varchar(100)
	declare @PO varchar(20)
	declare @PI varchar(20)
	declare @ApproverId as varchar(20)
	declare @ApproverID2 as varchar(20)
	declare @subj varchar(200)
	declare @subj2 varchar(200)

	set @subj='Purchase Order'
	set @subj2='Purchase Order'


	select @status=a.Status,@username=b.emp_name,@userEmail=b.email,
	@ApproverName=case when(a.Status in(1,3,-1)) then b.HOE_Name when (a.Status in (4,-3)) then b.CXO_Name when (a.Status in (5,-4)) then b.CFO_Name when (a.Status in(6,-5)) then b.CEO_Name
					   when (a.Status in (7,-6)) then b.FC_Name end,
	 @ApproverId=case when(a.Status in(1,3,-1)) then b.HOE when (a.Status in (4,-3)) then b.CXO when (a.Status in (5,-4)) then b.CFO when (a.Status in(6,-5)) then b.CEO
					   when (a.Status in (7,-6)) then b.FC end,
	 @ApproverName2 =case when(a.Status=3) then b.CXO_Name when (a.Status=4) then b.CFO_Name when (a.Status=5) then b.CEO_Name when (a.Status=6) then b.FC_Name
					   end,
	@ApproverID2 =  case when(a.Status=3) then b.CXO when (a.Status=4) then b.CFO when (a.Status=5) then b.CEO when (a.Status=6) then b.FC
					   end,
					   @PO=a.PONo,@PI=a.INVOICE_NUM
	from tbl_IOP2P_ItemRequest a
	left outer join Vw_UserRoles b on a.RequestedBy=b.emp_no
	 where a.Prno=@PrNo
	 

	--set @userEmail='leon.vaz@angelbroking.com'	     

	set @html= @html + '<table border="1"><tr><th>PR No</th><th>Requested By</th><th>Company</th><th>Branch</th><th>Department</th><th>Expense Type</th><th>Date</th><th>Amount</th><th>Remark</th></tr>'
	select @html=@html+'<tr><td>'+a.PrNo+'</td><td>'+ c.Emp_name+'</td><td>'+b.Parent_Name+'</td><td>'+c.Branch_cd+'</td><td>'+ isnull(d.Department,'') +'</td><td>'+a.ItOption+'</td><td>'+Convert(varchar,a.RequestedDate,103)+'</td><td>'+ Cast(sum(a.EstCosts)

 as varchar(20))+'</td><td>'+a.Remark+'</td></tr>' 
	from tbl_IOP2P_ItemRequest a left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no 
	left outer join (select  distinct Department,department_code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE) d on a.Department=d.Department_code
	where a.PrNo=@PrNo 
    group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,d.Department,a.ItOption,Convert(varchar,a.RequestedDate,103),a.Remark
	set @html= @html + '</table>'
	--print @html
	
	if(cast(@status as numeric)<0)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Rejected' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been Rejected by '+@ApproverName+'.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print @htmluser

		--set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @RequestedBy+ '</b>.<br><br> Kindly login into P2P to update. <br>'
		--set @htmlApprover = @htmlApprover + @html
		--print @htmlApprover

		 --set @userEmail='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName
		 
	 End
	else if(@status=1)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Raised' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been raised and sent to '+@ApproverName+' for approval.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print (@htmluser)

		set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending'
		set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @username + '</b>.<br><br> Kindly login into P2P(Procure to Pay) for further action. <br>'
		set @htmlApprover = @htmlApprover + @html
		--print (@htmlApprover)

		 --set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverId

	 End
   else if(@status=7)
    Begin
	   set @subj =@subj +'--PO Generated: '+@PO
	   set @htmluser='Dear '+@username+',<br><br> Your PO has been generated with PO No: '+@PO + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		-- set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	else if(@status=8)
    Begin
	   set @subj =@subj +'--Invoice Generated: '+@PI
	   set @htmluser='Dear '+@username+',<br><br> Your Invoice has been generated with PI No: '+@PI + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 --set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	 else if(@status=6)
    Begin
	     set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending' 
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj =@subj +'-' +@PrNo +'--Approved by '+@ApproverName
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 --print @htmluser
		 --set @email2='leon.vaz@angelbroking.com'
		  select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	End
   else
     Begin
	     set @subj =@subj +'-' +@PrNo +'--Approval Pending'
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved by '+@ApproverName+' , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj2 =@subj2 +'-' +@PrNo +'--Approved by '+@ApproverName
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved by '+@ApproverName+' and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		-- set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	 End
	
	--Email to user
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='FCTeam', 
	@recipients = @userEmail,
	@blind_copy_recipients='sachindewoolkar@angelbroking.com;bhavik.shingala@angelbroking.com;Leon.vaz@angelBroking.com',
	--@copy_recipients= @COPY, 
	@subject = @subj, 
	@body_format = 'HTML', 
	@body =@htmluser 	


	if(@email2 is not null and @email2!='')
	  Begin
		--email to approvers
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='FCTeam', 
		@recipients = @email2,
		@blind_copy_recipients='sachindewoolkar@angelbroking.com;bhavik.shingala@angelbroking.com;Leon.vaz@angelBroking.com',
		--@copy_recipients= @COPY, 
		@subject = @subj2, 
		@body_format = 'HTML', 
		@body =@htmlApprover 	
       end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_sendemailPRUpdate_26Mar2019
-- --------------------------------------------------
-- usp_IOP2P_sendemailPRUpdate 'PR000040'
CREATE proc [dbo].[usp_IOP2P_sendemailPRUpdate_26Mar2019]
(
@PrNo varchar(50)
--@user varchar(20)
)
As
BEGIN
	--declare @PrNo varchar(50) ='PR000040'
	declare @html  varchar(max)=''
	declare @htmluser varchar(max)=''
	declare @RequestedBy varchar(100) =''
	Declare @htmlApprover varchar(max)=''
	declare @ApproverName varchar(500) =''
	declare @ApproverName2 varchar(500) =''
	declare @username varchar(200)=''
	declare @status varchar(5)=''
	declare @userEmail varchar(100)
	declare @email2 varchar(100)
	declare @PO varchar(20)
	declare @PI varchar(20)
	declare @ApproverId as varchar(20)
	declare @ApproverID2 as varchar(20)
	declare @subj varchar(200)
	declare @subj2 varchar(200)

	set @subj='Purchase Order'
	set @subj2='Purchase Order'


	select @status=a.Status,@username=b.emp_name,@userEmail=b.email,
	@ApproverName=case when(a.Status in(1,3,-1)) then b.HOE_Name when (a.Status in (4,-3)) then b.CXO_Name when (a.Status in (5,-4)) then b.CFO_Name when (a.Status in(6,-5)) then b.CEO_Name
					   when (a.Status in (7,-6)) then b.FC_Name end,
	 @ApproverId=case when(a.Status in(1,3,-1)) then b.HOE when (a.Status in (4,-3)) then b.CXO when (a.Status in (5,-4)) then b.CFO when (a.Status in(6,-5)) then b.CEO
					   when (a.Status in (7,-6)) then b.FC end,
	 @ApproverName2 =case when(a.Status=3) then b.CXO_Name when (a.Status=4) then b.CFO_Name when (a.Status=5) then b.CEO_Name when (a.Status=6) then b.FC_Name
					   end,
	@ApproverID2 =  case when(a.Status=3) then b.CXO when (a.Status=4) then b.CFO when (a.Status=5) then b.CEO when (a.Status=6) then b.FC
					   end,
					   @PO=a.PONo,@PI=a.INVOICE_NUM
	from tbl_IOP2P_ItemRequest a
	left outer join Vw_UserRoles b on a.RequestedBy=b.emp_no
	 where a.Prno=@PrNo
	 

	--set @userEmail='leon.vaz@angelbroking.com'	     

	set @html= @html + '<table border="1"><tr><th>PR No</th><th>Requested By</th><th>Company</th><th>Branch</th><th>Department</th><th>Expense Type</th><th>Date</th><th>Amount</th><th>Remark</th></tr>'
	select @html=@html+'<tr><td>'+a.PrNo+'</td><td>'+ c.Emp_name+'</td><td>'+b.Parent_Name+'</td><td>'+c.Branch_cd+'</td><td>'+ isnull(d.Department,'') +'</td><td>'+a.ItOption+'</td><td>'+Convert(varchar,a.RequestedDate,103)+'</td><td>'+ Cast(sum(a.EstCosts)
 as varchar(20))+'</td><td>'+a.Remark+'</td></tr>' 
	from tbl_IOP2P_ItemRequest a left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no 
	left outer join (select  distinct Department,department_code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE) d on a.Department=d.Department_code
	where a.PrNo=@PrNo 
    group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,d.Department,a.ItOption,Convert(varchar,a.RequestedDate,103),a.Remark
	set @html= @html + '</table>'
	--print @html
	
	if(cast(@status as numeric)<0)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Rejected' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been Rejected by '+@ApproverName+'.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print @htmluser

		--set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @RequestedBy+ '</b>.<br><br> Kindly login into P2P to update. <br>'
		--set @htmlApprover = @htmlApprover + @html
		--print @htmlApprover

		 --set @userEmail='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName
		 
	 End
	else if(@status=1)
	 Begin
	     set @subj =@subj +'-' +@PrNo +'--Raised' 
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been raised and sent to '+@ApproverName+' for approval.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print (@htmluser)

		set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending'
		set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @username + '</b>.<br><br> Kindly login into P2P(Procure to Pay) for further action. <br>'
		set @htmlApprover = @htmlApprover + @html
		--print (@htmlApprover)

		 --set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverId

	 End
   else if(@status=7)
    Begin
	   set @subj =@subj +'--PO Generated: '+@PO
	   set @htmluser='Dear '+@username+',<br><br> Your PO has been generated with PO No: '+@PO + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		-- set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	else if(@status=8)
    Begin
	   set @subj =@subj +'--Invoice Generated: '+@PI
	   set @htmluser='Dear '+@username+',<br><br> Your Invoice has been generated with PI No: '+@PI + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 --set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	 else if(@status=6)
    Begin
	     set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending' 
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj =@subj +'-' +@PrNo +'--Approved by '+@ApproverName
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 --print @htmluser
		 --set @email2='leon.vaz@angelbroking.com'
		  select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	End
   else
     Begin
	     set @subj =@subj +'-' +@PrNo +'--Approved by '+@ApproverName
	     set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved by '+@ApproverName+' , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover

		 set @subj2 =@subj2 +'-' +@PrNo +'--Approval Pending'
		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved by '+@ApproverName+' and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		-- set @email2='leon.vaz@angelbroking.com'
		 select @email2=email from Vw_UserRoles where emp_no=@ApproverID2
	 End
	
	--Email to user
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='FCTeam', 
	@recipients = @userEmail,
	@blind_copy_recipients='sachindewoolkar@angelbroking.com;bhavik.shingala@angelbroking.com;Leon.vaz@angelBroking.com',
	--@copy_recipients= @COPY, 
	@subject = 'IOP2P - Purchase Order', 
	@body_format = 'HTML', 
	@body =@htmluser 	


	if(@email2 is not null and @email2!='')
	  Begin
		--email to approvers
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='FCTeam', 
		@recipients = @email2,
		@blind_copy_recipients='sachindewoolkar@angelbroking.com;bhavik.shingala@angelbroking.com;Leon.vaz@angelBroking.com',
		--@copy_recipients= @COPY, 
		@subject = 'IOP2P - Purchase Order', 
		@body_format = 'HTML', 
		@body =@htmlApprover 	
       end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_IOP2P_sendemailPRUpdate01Mar2019
-- --------------------------------------------------

-- usp_IOP2P_sendemailPRUpdate 'PR000040'
CREATE proc [dbo].[usp_IOP2P_sendemailPRUpdate01Mar2019]
(
@PrNo varchar(50)
--@user varchar(20)
)
As
BEGIN
	--declare @PrNo varchar(50) ='PR000040'
	declare @html  varchar(max)=''
	declare @htmluser varchar(max)=''
	declare @RequestedBy varchar(100) =''
	Declare @htmlApprover varchar(max)=''
	declare @ApproverName varchar(500) =''
	declare @ApproverName2 varchar(500) =''
	declare @username varchar(200)=''
	declare @status varchar(5)=''
	declare @userEmail varchar(100)
	declare @email2 varchar(100)
	declare @PO varchar(20)
	declare @PI varchar(20)

	select @status=a.Status,@username=b.emp_name,@userEmail=b.email,
	@ApproverName=case when(a.Status in(1,3,-1)) then b.HOE_Name when (a.Status in (4,-3)) then b.CXO_Name when (a.Status in (5,-4)) then b.CFO_Name when (a.Status in(6,-5)) then b.CEO_Name
					   when (a.Status in (7,-6)) then b.FC_Name end,
	 @ApproverName2 =case when(a.Status=3) then b.CXO_Name when (a.Status=4) then b.CFO_Name when (a.Status=5) then b.CEO_Name when (a.Status=6) then b.FC_Name
					   end,
					   @PO=a.PONo,@PI=a.INVOICE_NUM
	from tbl_IOP2P_ItemRequest a
	left outer join Vw_UserRoles b on a.RequestedBy=b.emp_no
	 where a.Prno=@PrNo
	 

	set @userEmail='leon.vaz@angelbroking.com'	     

	set @html= @html + '<table border="1"><tr><th>PR No</th><th>Requested By</th><th>Company</th><th>Branch</th><th>Department</th><th>Expense Type</th><th>Date</th><th>Amount</th><th>Remark</th></tr>'
	select @html=@html+'<tr><td>'+a.PrNo+'</td><td>'+ c.Emp_name+'</td><td>'+b.Parent_Name+'</td><td>'+c.Branch_cd+'</td><td>'+ isnull(d.Department,'') +'</td><td>'+a.ItOption+'</td><td>'+Convert(varchar,a.RequestedDate,103)+'</td><td>'+ Cast(sum(a.EstCosts)
 as varchar(20))+'</td><td>'+a.Remark+'</td></tr>' 
	from tbl_IOP2P_ItemRequest a left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
	inner join [Vw_UserRoles] c on a.RequestedBy=c.emp_no 
	left outer join (select  distinct Department,department_code from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_DEPARTMENT_CODE) d on a.Department=d.Department_code
	where a.PrNo=@PrNo 
    group by  a.PrNo, c.Emp_name,b.Parent_Name,c.Branch_cd,d.Department,a.ItOption,Convert(varchar,a.RequestedDate,103),a.Remark
	set @html= @html + '</table>'
	--print @html
	
	if(cast(@status as numeric)<0)
	 Begin
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been Rejected by '+@ApproverName+'.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print @htmluser

		--set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @RequestedBy+ '</b>.<br><br> Kindly login into P2P to update. <br>'
		--set @htmlApprover = @htmlApprover + @html
		--print @htmlApprover

		 set @userEmail='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName
		 
	 End
	else if(@status=1)
	 Begin
		 set @htmluser= 'Dear '+@username+',<br><br> PR with no: <b><u>'+@PrNo+'</b></u> has been raised and sent to '+@ApproverName+' for approval.<br><br> Kindly find the below details: <br>'	
		 set @htmluser = @htmluser + @html
		 --print (@htmluser)

		set @htmlApprover='Dear '+@ApproverName+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been raised by <b>'+ @username + '</b>.<br><br> Kindly login into P2P(Procure to Pay) for further action. <br>'
		set @htmlApprover = @htmlApprover + @html
		print (@htmlApprover)

		set @email2='leon.vaz@angelbroking.com'
		 --select @email2=email from Vw_UserRoles where emp_no=@ApproverName

	 End
   else if(@status=7)
    Begin
	   set @htmluser='Dear '+@username+',<br><br> Your PO has been generated with PO No: '+@PO + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	else if(@status=8)
    Begin
	   set @htmluser='Dear '+@username+',<br><br> Your Invoice has been generated with PI No: '+@PI + '<br><br>' 
	     --'Once you receive Goods/Service you are here by requested to raise the Tax Invoice for the Same.'
		 set @htmluser = @htmluser + @html
		 set @userEmail='leon.vaz@angelbroking.com'
		 --print @htmluser	 
	End
	 else if(@status=6)
    Begin
	    set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover


		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		 set @email2='leon.vaz@angelbroking.com'
	End
   else
     Begin
	   set @htmlApprover='Dear '+@ApproverName2+', <br> <br> PR with no: <b><u>'+@PrNo+'</u></b> has been approved by '+@ApproverName+' , now request you to kindly login into P2P(Procure to Pay) for further action'
		 set @htmlApprover=@htmlApprover + @html
		 --print @htmlApprover


		 set @htmluser='Dear '+@username+',<br><br> Your PR with no: <b><u>'+@PrNo+'</b></u> has been approved by '+@ApproverName+' and sent to '+@ApproverName2 +'.<br>'
		 set @htmluser = @htmluser + @html
		 print @htmluser
		 set @email2='leon.vaz@angelbroking.com'
		-- select @email2=email from Vw_UserRoles where emp_no=@ApproverName2
	 End
	
	--Email to user
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='FCTeam', 
	@recipients = @userEmail,
	@blind_copy_recipients='sachindewoolkar@angelbroking.com;Leon.vaz@angelBroking.com',
	--@copy_recipients= @COPY, 
	@subject = 'IOP2P - Purchase Order', 
	@body_format = 'HTML', 
	@body =@htmluser 	


	if(@email2 is not null and @email2!='')
	  Begin
		--email to approvers
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='FCTeam', 
		@recipients = @email2,
		@blind_copy_recipients='sachindewoolkar@angelbroking.com;Leon.vaz@angelBroking.com',
		--@copy_recipients= @COPY, 
		@subject = 'IOP2P - Purchase Order', 
		@body_format = 'HTML', 
		@body =@htmlApprover 	
       end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging
-- --------------------------------------------------
CREATE proc [dbo].[usp_movetoStagging]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--declare @emp_id as varchar(20)=@empID

declare @batchname as varchar(50)
select @batchname= @empID + isnull(right('00'+cast(max(right(BATCH_NAME,9))+1 as varchar),9) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

declare @Source as varchar(50)
select @Source=isnull(cast('ANG-IOPOI' + right('00'+cast(right(max([source]),2) +1 as varchar),2) as varchar(20)),'ANG-IOPOI01') from tbl_Staging 
where ACCOUNTING_DATE between Convert(date,getdate()) and getdate() --and left(BATCH_NAME,6) = @empID
--print @Source

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
  adv.PANo INVOICE_NUM,
 case when (left(adv.PANo,2)='PA') then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 adv.Updateddate as Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
  adv.Amount  INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 left(replace(a.Remark,char(10),''),240) DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (left(adv.PANo,2)='PA') then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 row_number() over (PARTITION BY adv.PANo order by adv.PANo )
  LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=  case  when (left(adv.PANo,2)='PA') then adv.Amount else adv.Costs end  ,
 [Line Description]=left(replace(Remark,char(10),''),240), null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (left(adv.PANo,2)='PA') then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (left(adv.PANo,2)='PA') then adv.PrNo else adv.Vendor_Bill_Num end ATTRIBUTE5,
 adv.FromDate ATTRIBUTE6, adv.ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
  adv.PANo as ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
   right outer join tbl_IOP2P_Advance adv  on a.PrNo=adv.PrNo and A.Srno=adv.ItmID  --case when  (left(adv.PANo,2)='PI') then adv.ItmID else null end
   inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
   inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID    
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where adv.PANo in (select PINo from @PINoList ) --or adv.PANO in(select PINo from @PINoList )
  union all
  SELECT Distinct 
  adv.PANo INVOICE_NUM,
 case when (left(adv.PANo,2)='PA') then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 adv.Updateddate as Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
  adv.Amount  INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 left(replace(a.Remark,char(10),''),240) DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (left(adv.PANo,2)='PA') then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 --row_number() over (PARTITION BY adv.PANo order by adv.PANo )
  '1' LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]= adv.Amount  ,
 [Line Description]=left(replace(Remark,char(10),''),240), null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (left(adv.PANo,2)='PA') then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (left(adv.PANo,2)='PA') then adv.PrNo else adv.Vendor_Bill_Num end ATTRIBUTE5,
 adv.FromDate ATTRIBUTE6, adv.ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
  adv.PANo as ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
    right outer join tbl_IOP2P_Advance adv  on a.PrNo=adv.PrNo 
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID 
 where adv.PANO in(select PINo from @PINoList ) and (left(adv.PANo,2)='PA')
   
 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_01Apr2019
-- --------------------------------------------------


CREATE proc [dbo].[usp_movetoStagging_01Apr2019]
(
@empID varchar(20),
@Prnolist  PrNoList readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(cast(max(right(BATCH_NAME,9))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE
 
 )
 SELECT 
 INVOICE_NUM,'STANDARD' as INVOICE_TYPE_LOOKUP_CODE,Vendor_Bill_Date,VendorNumber,Vendor_Site_Code,A.Total as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 a.remark DESCRIPTION,'Never Validated' [STATUS],'ANG-IOPOI01' [SOURCE],'IO STD INV' DOC_CATEGORY_CODE,'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=EstCosts,[Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+A.[A/C Code]+'-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (99999 as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1, b.BRANCHTAG as ATTRIBUTE2, b.BRANCHTAG as ATTRIBUTE3, b.BRANCHTAG as ATTRIBUTE4, Vendor_Bill_NUM ATTRIBUTE5,FromDate ATTRIBUTE6, 
  ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,INVOICE_NUM ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE    
  
  from tbl_IOP2P_ItemRequest a
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
where A.PrNO in (select Prno from @Prnolist )


update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where PrNO in (select Prno from @Prnolist )

 select 'The Items have been added to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_02May2019
-- --------------------------------------------------
CREATE proc [dbo].[usp_movetoStagging_02May2019]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(cast(max(right(BATCH_NAME,9))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

declare @Source as varchar(50)
select @Source=isnull(cast('ANG-IOPOI' + right('00'+cast(right(max([source]),2) +1 as varchar),2) as varchar(20)),'ANG-IOPOI01') from tbl_Staging 
where ACCOUNTING_DATE between Convert(date,getdate()) and getdate() --and left(BATCH_NAME,6) = @empID
--print @Source

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end INVOICE_NUM,
 case when (a.INVOICE_NUM is null) then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 case  when (a.INVOICE_NUM) is null then convert(date,GETDATE()) else a.Vendor_Bill_Date end Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
 case  when (a.INVOICE_NUM) is null then adv.Amount else A.Total end  as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 a.Remark DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (a.INVOICE_NUM) is null then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 case  when (a.INVOICE_NUM) is null then row_number() over (PARTITION BY adv.PANo order by adv.PANo ) 
 else row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) end LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=case  when (a.INVOICE_NUM) is null then adv.Amount else A.EstCosts end ,
 [Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (a.INVOICE_NUM) is null then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (a.INVOICE_NUM) is null then adv.PrNo else a.Vendor_Bill_NUM end ATTRIBUTE5,
 FromDate ATTRIBUTE6, ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
  left outer join tbl_IOP2P_Advance adv on a.PrNo=adv.PrNo
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where A.INVOICE_NUM in (select PINo from @PINoList ) or adv.PANO in(select PINo from @PINoList )

 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_04May2019
-- --------------------------------------------------
CREATE proc [dbo].[usp_movetoStagging_04May2019]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(right('00'+cast(max(right(BATCH_NAME,9))+1 as varchar),9) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

declare @Source as varchar(50)
select @Source=isnull(cast('ANG-IOPOI' + right('00'+cast(right(max([source]),2) +1 as varchar),2) as varchar(20)),'ANG-IOPOI01') from tbl_Staging 
where ACCOUNTING_DATE between Convert(date,getdate()) and getdate() --and left(BATCH_NAME,6) = @empID
--print @Source

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end INVOICE_NUM,
 case when (a.INVOICE_NUM is null) then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 case  when (a.INVOICE_NUM) is null then convert(date,GETDATE()) else a.Vendor_Bill_Date end Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
 case  when (a.INVOICE_NUM) is null then adv.Amount else A.Total end  as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 a.Remark DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (a.INVOICE_NUM) is null then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 case  when (a.INVOICE_NUM) is null then row_number() over (PARTITION BY adv.PANo order by adv.PANo ) 
 else row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) end LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=case  when (a.INVOICE_NUM) is null then adv.Amount else A.EstCosts end ,
 [Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (a.INVOICE_NUM) is null then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (a.INVOICE_NUM) is null then adv.PrNo else a.Vendor_Bill_NUM end ATTRIBUTE5,
 FromDate ATTRIBUTE6, ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
  left outer join tbl_IOP2P_Advance adv on a.PrNo=adv.PrNo
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where A.INVOICE_NUM in (select PINo from @PINoList ) or adv.PANO in(select PINo from @PINoList )

 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_08May2019
-- --------------------------------------------------
CREATE proc [dbo].[usp_movetoStagging_08May2019]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(right('00'+cast(max(right(BATCH_NAME,9))+1 as varchar),9) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

declare @Source as varchar(50)
select @Source=isnull(cast('ANG-IOPOI' + right('00'+cast(right(max([source]),2) +1 as varchar),2) as varchar(20)),'ANG-IOPOI01') from tbl_Staging 
where ACCOUNTING_DATE between Convert(date,getdate()) and getdate() --and left(BATCH_NAME,6) = @empID
--print @Source

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end INVOICE_NUM,
 case when (a.INVOICE_NUM is null) then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 case  when (a.INVOICE_NUM) is null then convert(date,GETDATE()) else a.Vendor_Bill_Date end Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
 case  when (a.INVOICE_NUM) is null then adv.Amount else A.Total end  as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 a.Remark DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (a.INVOICE_NUM) is null then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 case  when (a.INVOICE_NUM) is null then row_number() over (PARTITION BY adv.PANo order by adv.PANo ) 
 else row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) end LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=case  when (a.INVOICE_NUM) is null then adv.Amount else A.EstCosts end ,
 [Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (a.INVOICE_NUM) is null then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (a.INVOICE_NUM) is null then adv.PrNo else a.Vendor_Bill_NUM end ATTRIBUTE5,
 FromDate ATTRIBUTE6, ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
  left outer join tbl_IOP2P_Advance adv on a.PrNo=adv.PrNo
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where A.INVOICE_NUM in (select PINo from @PINoList ) or adv.PANO in(select PINo from @PINoList )

 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_12Apr2019
-- --------------------------------------------------

CREATE proc [dbo].[usp_movetoStagging_12Apr2019]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(cast(max(right(BATCH_NAME,9))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end INVOICE_NUM,
 case when (a.INVOICE_NUM is null) then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 case  when (a.INVOICE_NUM) is null then convert(date,GETDATE()) else a.Vendor_Bill_Date end Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
 case  when (a.INVOICE_NUM) is null then adv.Amount else A.Total end  as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 a.Remark DESCRIPTION,'Never Validated' [STATUS],'ANG-IOPOI01' [SOURCE],
 case  when (a.INVOICE_NUM) is null then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 case  when (a.INVOICE_NUM) is null then row_number() over (PARTITION BY adv.PANo order by adv.PANo ) 
 else row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) end LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=case  when (a.INVOICE_NUM) is null then adv.Amount else A.EstCosts end ,
 [Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (a.INVOICE_NUM) is null then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (99999 as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (a.INVOICE_NUM) is null then adv.PrNo else a.Vendor_Bill_NUM end ATTRIBUTE5,
 FromDate ATTRIBUTE6, ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
  left outer join tbl_IOP2P_Advance adv on a.PrNo=adv.PrNo
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where A.INVOICE_NUM in (select PINo from @PINoList ) or adv.PANO in(select PINo from @PINoList )

 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_26Apr2019
-- --------------------------------------------------
CREATE proc [dbo].[usp_movetoStagging_26Apr2019]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(cast(max(right(BATCH_NAME,9))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end INVOICE_NUM,
 case when (a.INVOICE_NUM is null) then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 case  when (a.INVOICE_NUM) is null then convert(date,GETDATE()) else a.Vendor_Bill_Date end Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
 case  when (a.INVOICE_NUM) is null then adv.Amount else A.Total end  as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 a.Remark DESCRIPTION,'Never Validated' [STATUS],'ANG-IOPOI01' [SOURCE],
 case  when (a.INVOICE_NUM) is null then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 case  when (a.INVOICE_NUM) is null then row_number() over (PARTITION BY adv.PANo order by adv.PANo ) 
 else row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) end LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=case  when (a.INVOICE_NUM) is null then adv.Amount else A.EstCosts end ,
 [Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (a.INVOICE_NUM) is null then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (a.INVOICE_NUM) is null then adv.PrNo else a.Vendor_Bill_NUM end ATTRIBUTE5,
 FromDate ATTRIBUTE6, ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
  left outer join tbl_IOP2P_Advance adv on a.PrNo=adv.PrNo
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where A.INVOICE_NUM in (select PINo from @PINoList ) or adv.PANO in(select PINo from @PINoList )

 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_26Mar2019
-- --------------------------------------------------

CREATE proc usp_movetoStagging_26Mar2019
(
@empID varchar(20),
@Prnolist  PrNoList readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(cast(max(right(BATCH_NAME,9))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE
 
 )
 SELECT 
 INVOICE_NUM,'STANDARD' as INVOICE_TYPE_LOOKUP_CODE,Vendor_Bill_Date,VendorNumber,Vendor_Site_Code,A.Total as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 DESCRIPTION,'Never Validated' [STATUS],'ANG-IOPOI01' [SOURCE],'IO STD INV' DOC_CATEGORY_CODE,'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=EstCosts,[Line Description]=Remark, null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+A.[A/C Code]+'-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (99999 as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1, b.BRANCHTAG as ATTRIBUTE2, b.BRANCHTAG as ATTRIBUTE3,                
 b.BRANCHTAG as ATTRIBUTE4, Vendor_Bill_NUM ATTRIBUTE5,FromDate ATTRIBUTE6, ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,INVOICE_NUM ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE    
  
  from tbl_IOP2P_ItemRequest a
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID   
where A.PrNO in (select Prno from @Prnolist )


update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where PrNO in (select Prno from @Prnolist )

 select 'The Items have been added to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_movetoStagging_29May2019
-- --------------------------------------------------
Create proc [dbo].[usp_movetoStagging_29May2019]
(
@empID varchar(20),
@PInolist [PINoList] readonly
)
As
BEGIN
--select 'E700335' + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)

--select @empID + isnull(cast(max(right(BATCH_NAME,8))+1 as varchar) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'01') from tbl_Staging
--where BATCH_NAME = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2))+'01' as varchar)


declare @batchname as varchar(50)
select @batchname= @empID + isnull(right('00'+cast(max(right(BATCH_NAME,9))+1 as varchar),9) ,replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)+'001') from tbl_Staging
where left(BATCH_NAME,12) = @empID + cast((replace(Convert(varchar(5),getdate(),103),'/','') + right(convert(varchar,year(getdate())),2)) as varchar)
--print @batchname

declare @Source as varchar(50)
select @Source=isnull(cast('ANG-IOPOI' + right('00'+cast(right(max([source]),2) +1 as varchar),2) as varchar(20)),'ANG-IOPOI01') from tbl_Staging 
where ACCOUNTING_DATE between Convert(date,getdate()) and getdate() --and left(BATCH_NAME,6) = @empID
--print @Source

insert into  dbo.tbl_Staging
 (
 INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE,INVOICE_DATE,VENDOR_NUM,VENDOR_SITE_CODE,INVOICE_AMOUNT,
 INVOICE_CURRENCY_CODE,TERMS_NAME,DESCRIPTION,STATUS,SOURCE,DOC_CATEGORY_CODE,PAYMENT_METHOD_LOOKUP_CODE,
 GL_DATE,ORG_ID,LINE_NUMBER,LINE_TYPE_LOOKUP_CODE,LINE_AMOUNT,LINE_DESCRIPTION,DIST_LINE_NUMBER,
 DIST_AMOUNT,DIST_CODE_CONCATENATED,ACCOUNTING_DATE,DIST_DESCRIPTION,PAY_GROUP_LOOKUP_CODE,
 SEGMENT_1,SEGMENT_2,SEGMENT_3,SEGMENT_4,SEGMENT_5,SEGMENT_6,SEGMENT_7,SEGMENT_8,SEGMENT_9,
 SEGMENT_10,SEGMENT_11,ASSETS_TRACKING_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,
 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,
 ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,DIST_ATTRIBUTE_CATEGORY,DIST_ATTRIBUTE1,
 DIST_ATTRIBUTE2,DIST_ATTRIBUTE3,DIST_ATTRIBUTE4,DIST_ATTRIBUTE5,DIST_GLOBAL_ATT_CATEGORY,
 GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,
 PREPAY_NUM,PREPAY_DIST_NUM,PREPAY_APPLY_AMOUNT,PREPAY_GL_DATE,INVOICE_INCLUDES_PREPAY_FLAG,
 PREPAY_LINE_NUM,CREATED_BY,CREATION_DATE ,PROCESSED_STATUS,ERROR_MESSAGE,INVOICE_STATUS,
 BATCH_NAME,GST_CATEGORY,HSN_CODE 
 )
 SELECT 
 case  when (a.INVOICE_NUM is null)  then adv.PANo else a.INVOICE_NUM end INVOICE_NUM,
 case when (a.INVOICE_NUM is null) then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 case  when (a.INVOICE_NUM) is null then convert(date,GETDATE()) else a.Vendor_Bill_Date end Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
 case  when (a.INVOICE_NUM) is null then adv.Amount else A.Total end  as INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 left(replace(a.Remark,char(10),''),240) DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (a.INVOICE_NUM) is null then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 case  when (a.INVOICE_NUM) is null then row_number() over (PARTITION BY adv.PANo order by adv.PANo ) 
 else row_number() over (PARTITION BY a.Invoice_Num order by a.Invoice_Num) end LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]=case  when (a.INVOICE_NUM) is null then adv.Amount else A.EstCosts end ,
 [Line Description]=left(replace(Remark,char(10),''),240), null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (a.INVOICE_NUM) is null then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (a.INVOICE_NUM) is null then adv.PrNo else a.Vendor_Bill_NUM end ATTRIBUTE5,
 adv.FromDate ATTRIBUTE6, adv.ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
 case  when (a.INVOICE_NUM) is null then adv.PANo else a.INVOICE_NUM end ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
    left outer join tbl_IOP2P_Advance adv  on a.PrNo=adv.PrNo and a.INVOICE_NUM=adv.PANo
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID    
 --where A.INVOICE_NUM in ('PA000002','PA000001','PI000004','PI000003') or adv.PANO in('PA000002','PA000001','PI000004','PI000003') 
  where A.INVOICE_NUM in (select PINo from @PINoList ) --or adv.PANO in(select PINo from @PINoList )
  union all
  SELECT 
  adv.PANo INVOICE_NUM,
 case when (left(adv.PANo,2)='PA') then 'PREPAYMENT' else  'STANDARD' end as INVOICE_TYPE_LOOKUP_CODE,
 adv.Updateddate as Vendor_Bill_Date,
 VendorNumber, Vendor_Site_Code, 
  adv.Amount  INVOICE_AMOUNT,                
 'INR' INVOICE_CURRENCY_CODE,'Immediate' TERMS_NAME,                
 left(replace(a.Remark,char(10),''),240) DESCRIPTION,'Never Validated' [STATUS],@Source [SOURCE],
 case  when (left(adv.PANo,2)='PA') then 'IO PREPAY INV' else 'IO STD INV' end DOC_CATEGORY_CODE,
 'IO-DEFAULT' PAYMENT_METHOD_LOOKUP_CODE,                
 GETDATE() GL_DATE, c.ORG_ID,
 row_number() over (PARTITION BY adv.PANo order by adv.PANo )
  LINE_NUMBER,                
 'ITEM' LINE_TYPE_LOOKUP_CODE,
 [Line Amount]= adv.Amount  ,
 [Line Description]=left(replace(Remark,char(10),''),240), null AS DIST_LINE_NUMBER,                
 null as dist_Amount, 
 +Company+'-'+ case  when (left(adv.PANo,2)='PA') then '351505' else A.[A/C Code] end +
 '-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (a.Project as varchar(10))+
 '-'+ cast (99999 as varchar(10))+'-' +cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)) as DIST_CODE_CONCATENATED,
 GETDATE() ACCOUNTING_DATE,                
 '' AS DIST_DESCRIPTION,'' AS PAY_GROUP_LOOKUP_CODE,                
 '' AS SEGMENT_1, '' AS SEGMENT_2,''AS SEGMENT_3,''AS SEGMENT_4, ''AS SEGMENT_5,                
 ''SEGMENT_6,'' AS SEGMENT_7,'' AS SEGMENT_8,'' AS SEGMENT_9,'' AS SEGMENT_10,                
 '' AS SEGMENT_11,(CAse when a.ItOption='CAPITAL' then 'Y'  else    'N'  end) AS ASSETS_TRACKING_FLAG,'Inward-Outward' ATTRIBUTE_CATEGORY,                
 '' as ATTRIBUTE1,
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE2, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE3, 
 case when b.Branch_Type='STATE' then b.branch_code else b.BRANCHTAG end as ATTRIBUTE4,  
 case  when (left(adv.PANo,2)='PA') then adv.PrNo else adv.Vendor_Bill_Num end ATTRIBUTE5,
 adv.FromDate ATTRIBUTE6, adv.ToDate ATTRIBUTE7,RequestedBy ATTRIBUTE8, HOE ATTRIBUTE9,
  adv.PANo as ATTRIBUTE10,'' ATTRIBUTE11,                
 ''ATTRIBUTE12, PONO as ATTRIBUTE13,'' ATTRIBUTE14, '' ATTRIBUTE15, ''DIST_ATTRIBUTE_CATEGORY                
 ,'' DIST_ATTRIBUTE1,''DIST_ATTRIBUTE2,         
 ''DIST_ATTRIBUTE3,''DIST_ATTRIBUTE4,'' DIST_ATTRIBUTE5,'' DIST_GLOBAL_ATT_CATEGORY,                
 '' GLOBAL_ATTRIBUTE1,'' GLOBAL_ATTRIBUTE2,'' GLOBAL_ATTRIBUTE3,'' GLOBAL_ATTRIBUTE4,'' GLOBAL_ATTRIBUTE5,                
 null AS PREPAY_NUM,null AS PREPAY_DIST_NUM,null AS PREPAY_APPLY_AMOUNT,null  AS PREPAY_GL_DATE,                
 '' AS INVOICE_INCLUDES_PREPAY_FLAG,null AS PREPAY_LINE_NUM,0 as CREATED_BY,'' CREATION_DATE,
 null as PROCESSED_STATUS, '' as ERROR_MESSAGE,               
 '' AS INVOICE_STATUS,@batchname,  Null as  GST_CATEGORY, Null as  HSN_CODE  
  from tbl_IOP2P_ItemRequest a
    right outer join tbl_IOP2P_Advance adv  on a.PrNo=adv.PrNo 
  inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b on a.ShipTO=b.BRANCH_CODE    
 inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on a.VendorSite=c.Vendor_Site_ID 
 where adv.PANO in(select PINo from @PINoList )
   
 update  tbl_IOP2P_ItemRequest set BATCHNAME = @batchname where INVOICE_NUM in (select PINo from @PINoList )
 update tbl_IOP2p_Advance set status='Processed', Batchname=@batchname where PANo  in (select PINo from @PINoList)

--insert into tbl_IOP2P_Comments 
--select Prno,'','Moved to Staging(IOP2P)','8',@empID,getdate() from @PINolist

select 'The Items have been moved to Stagging'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update
-- --------------------------------------------------
--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
--[Usp_PR_Update] 'PR119235','E00335','','','','DirApprove','6','FC Approved'
CREATE proc [dbo].[Usp_PR_Update] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null,
	@Statusflag varchar(50) = null,
	@Statuslevel varchar(20) = null,
	@CGST varchar(5) = null,
	@SGST varchar(5) = null,
	@IGST varchar(5) = null,
	@CGSTAmount money = null,
	@SGSTAmount money = null,
	@IGSTAmount money = null,
	@roundOffAmt varchar(15)=null,
	@Total money=null,
	@PaymentTerms varchar(300)=null,
	@GstState varchar(100)=null,
	@GstNo varchar(100)=null,
	@Comment varchar(100) = null,
	@PIpath varchar(300)=null,
	@ExpenseType varchar(100)=null,
	@closePO varchar(50) =null,
	@FromDate datetime = null,
	@ToDate datetime = null,	
	@Items [ItemList] readonly
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  

  /*Approval/Rejection Comments*/
  --if(@Comment is not null and @Comment!='')
  -- Begin
	  insert into tbl_IOP2P_Comments 
	  values(@PrNo,@Comment,@Statusflag,@status,@Username,getdate())
   --End
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if(@Statusflag='DirApprove')
	Begin
		if (@status=1)
		Begin 
			If (@Amt<=100000 and @status=1 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		End


		---HOE

	 if (@status=2)
		Begin 
			If (@Amt<=100000 and @status=2 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		END

		--CXO

	
  if (@status=3)
	Begin 
		If (@Amt<=1000000 and @status=3 )--CXO
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=4,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'HOE 333'
		END
	END

		--CFO
  if (@status=4)
	Begin 
		If (@Amt<=2500000 and @status=4 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=5,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'CFO'
		END
	END

		--CEO
  if (@status=5)
	Begin 
		If (@Amt>2500000 and @status=5 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CEO=@Username,CEO_Date=getdate()
			where PrNo=@PrNo
			--select @PrNo
		END
	
	END

		-- FC
  if (@status=6) 
	Begin	
	    declare @PONo as varchar(20)
		select  @PONo='PO' + right('00000'+ cast(max(replace(isnull(PONo,0),'PO','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest		
		set Status=7,FC=@Username,FC_Date=getdate(),PONo= @PONo,VendorSite=@vendorSite,Total=@Total,[CGST%]=@CGST,[SGST%]=@SGST,[IGST%]=@IGST,
		CGST_Amount=@CGSTAmount,SGST_Amount=@SGSTAmount,IGST_Amount=@IGSTAmount,PaymentTerms=@PaymentTerms,GstState=@GstState,GstNo=@GstNo,
		ItemName=b.ItemName,SubItemName=b.SubItemName,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs,Units=b.Units,DeliveryDate=b.Deliverydate,RoundOffAmt=@roundOffAmt,		
		ItOption =@ExpenseType
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.SrNo=b.SrNo		
		where a.PrNo=@PrNo
		
		update ITAssests.dbo.tbl_requestmaster
	    set Status_Code='PO'
	    from ITAssests.dbo.tbl_requestmaster a
	    inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNO
	    where b.PrNo=@PrNo and b.ITAssetNO is not null  and b.ITAssetNO !=''

		--update tbl_IOP2P_ItemRequest set VendorNumber=c.Vendor_number from tbl_IOP2P_ItemRequest a
		--inner join  [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on c.Vendor_Site_code=@vendorSite
		--where a.PrNo=@PrNo --and a.VendorSite=@vendorSite

		--update tbl_IOP2P_ItemRequest
		--set PONo= REPLACE(@PrNo,'PR','PO')
		--where PrNo=@PrNo

		select top 1 'genPO' , Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,Bilto.Branch_Address BillTo_Address,
		 A.ItemName,case when a.ITAssetno is null then A.SubItemName else ('<b>' + isnull(cpm.Product_Name,'') + ':</b><br>'+ A.SubItemName) end SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,case when a.ITAssetNo is not null then dbo.getEmpName(g.Approved_By) 
		 else c.HOE_Name end HOE_Name,a.Units ,a.Status ,isnull(d.Address_Line1,'')+','+isnull(d.Address_Line2,'')+','+isnull(d.Address_Line3,'')+','+
		 isnull(d.Address_Line4,'') +','+isnull(d.City,'') +','+isnull(d.State,'')+'-'+isnull(d.Postal_code,'')  VendorAdd
		 ,Convert(varchar,a.FC_Date,103) PODate,cast(isnull(CGST_Amount,0) as numeric(10,2))CGST_Amount,cast(isnull(SGST_Amount,0) as numeric(10,2))SGST_Amount,A.PaymentTerms,RoundOffAmt,
		 cast(isnull(IGST_Amount,0) as numeric(10,2))IGST_Amount,Cast(Total as numeric(10,2))Total,[CGST%],[SGST%],[IGST%],isnull(d.PAN_NO,'N/A') as VendorPan,isnull(d.GST_Registration_Number,'N/A') as VendorGST,GstState [STATE],GstNo [GSTNo],
		 a.Remark,I.Emp_name ITAssetReqBy,a.ITAssetNo,a.Warranty ,h.Model_Name ITAssetModelName,A.BillTo_Name,a.ShipTo_Name
		 from tbl_IOP2P_ItemRequest a
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
		left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no and c.Access in ('User','ITAssetUser')
		left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE Bilto on a.BillTO= Bilto.Branch_code
		left outer join ITAssests.dbo.tbl_RequestMaster g on a.ITAssetNo=g.Request_Id
		left join ITAssests.[dbo].[tbl_ProductModelMaster] h on g.Model_No=h.Model_Id
		left join ITAssests.[dbo].tbl_CapexProductMaster CPM on g.Item_Code=CPM.Product_Code
		left outer join risk.dbo.emp_info i on g.Requested_By=i.emp_no
		where PrNo=@PrNo

	   --select top 1 Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		--select @PrNo	
	END

		--Invoice 
   if (@status=7) 
	 Begin	
	    select ItmID, sum(costs) Costs 
		   into #Advdetails 
		  from  tbl_IOP2P_Advance   where PrNo=@PrNo and left(PANO,2)='PI' 
		  group by ItmID 

		  select a.SrNo, (a.costs + b.costs)Costs
		  into #Itmdetails
		  from  @Items a left outer join #Advdetails b on a.SrNo=b.ItmID
		  
		  if exists (select PrNo from tbl_IOP2P_Advance where Vendor_Bill_NUM=@vendorBillno)
		   Begin
		    select 'Vendor Bill NO already exists'
		    return
		   End

		  --drop table IOP2Ptmp1
		  --select * into IOP2Ptmp1 from @Items

		 --if exists(select a.EstCosts from tbl_IOP2P_ItemRequest a inner join #Itmdetails b on a.Srno=b.Srno where cast(b.Costs as money) > cast(a.EstCosts as money))
		 --Begin
		 -- select 'Invoice Amount for Items cannot be higher than the Purchase Order Amount'
		 -- return 
		 --End

		declare @PI as varchar(20)
		--select  @PI='PI' + right('00000'+ cast(max(replace(isnull(INVOICE_NUM,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest			
		select  @PI='PI' + right('00000'+ cast(max(replace(isnull(PANo,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_Advance where left(PANO,2)='PI'	


		Update tbl_IOP2P_ItemRequest
		set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,--INVOICE_NUM=@PI,
		Update_Invoice_date=getdate(),Update_Invoice=@Username,
		PI_Path=@PIpath --,ItmQty=b.Qty--,Rate=b.Rate,EstCosts=b.Costs
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.Srno=b.SrNo
		where a.PrNo=@PrNo
		--select @PrNo	

		insert into tbl_IOP2P_Advance (PANo,PrNo,Amount,UpdatedBy,Updateddate,[IGST%],[SGST%],[CGST%],IGST_Amount,SGST_Amount,CGST_Amount,PI_Path,Vendor_Bill_Num,Vendor_Bill_Date,
		ItmID,rate,RoundOffAmt,costs,units,ItmQty,SubItemName,ItemName,DeliveryDate,FromDate,ToDate)
		select  @PI,@PrNo,@Total,@Username,getdate(),@IGST,@SGST,@CGST,@IGSTAmount,@SGSTAmount,@CGSTAmount,@PIpath,@vendorBillno,@vendorBilldate,
		SrNo,Rate,@roundOffAmt,Costs,Units,Qty,SubItemName,ItemName,Deliverydate,@FromDate,@ToDate from @Items

		select @total=isnull(sum(Amount),0) from tbl_IOP2P_Advance where PRNo = @prno and left(PANO,2)='PI' 

		if(@closePO='True' or @total =(select top 1 Total from tbl_IOP2P_ItemRequest where PrNo=@PrNo))
		 Begin
		  update tbl_IOP2P_ItemRequest set [Status]='8' where PrNo=@PrNo
		 End

		select 'Invoice No: '+@PI+' has been generated for PrNo: '+@PrNo

	  END
	End
Else --Negative status are all Rejections
  Begin
    if (@status=1)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-1,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=3)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-3,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=4)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-4,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=5)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-5,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=6)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-6,FC=@Username,FC_Date=getdate()
		where PrNo=@PrNo
	 End
  End

  /*Send Mail Notification*/
 Exec usp_IOP2P_sendemailPRUpdate @PrNo
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update_01Apr2019
-- --------------------------------------------------

--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
--[Usp_PR_Update] 'PR119235','E00335','','','','DirApprove','6','FC Approved'
create proc [dbo].[Usp_PR_Update_01Apr2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null,
	@Statusflag varchar(50) = null,
	@Statuslevel varchar(20) = null,
	@CGST varchar(5) = null,
	@SGST varchar(5) = null,
	@IGST varchar(5) = null,
	@CGSTAmount money = null,
	@SGSTAmount money = null,
	@IGSTAmount money = null,
	@roundOffAmt varchar(15)=null,
	@Total money=null,
	@PaymentTerms varchar(300)=null,
	@GstState varchar(100)=null,
	@GstNo varchar(100)=null,
	@Comment varchar(100) = null,
	@PIpath varchar(300)=null,
	@ExpenseType varchar(100)=null,	
	@Items [ItemList] readonly
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  

  /*Approval/Rejection Comments*/
  --if(@Comment is not null and @Comment!='')
  -- Begin
	  insert into tbl_IOP2P_Comments 
	  values(@PrNo,@Comment,@Statusflag,@status,@Username,getdate())
   --End
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if(@Statusflag='DirApprove')
	Begin
		if (@status=1)
		Begin 
			If (@Amt<=100000 and @status=1 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		End


		---HOE

	 if (@status=2)
		Begin 
			If (@Amt<=100000 and @status=2 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		END

		--CXO

	
  if (@status=3)
	Begin 
		If (@Amt<=1000000 and @status=3 )--CXO
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=4,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'HOE 333'
		END
	END

		--CFO
  if (@status=4)
	Begin 
		If (@Amt<=2500000 and @status=4 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=5,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'CFO'
		END
	END

		--CEO
  if (@status=5)
	Begin 
		If (@Amt>2500000 and @status=5 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CEO=@Username,CEO_Date=getdate()
			where PrNo=@PrNo
			--select @PrNo
		END
	
	END

		-- FC
  if (@status=6) 
	Begin	
	    declare @PONo as varchar(20)
		select  @PONo='PO' + right('00000'+ cast(max(replace(isnull(PONo,0),'PO','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest		
		set Status=7,FC=@Username,FC_Date=getdate(),PONo= @PONo,VendorSite=@vendorSite,Total=@Total,[CGST%]=@CGST,[SGST%]=@SGST,[IGST%]=@IGST,
		CGST_Amount=@CGSTAmount,SGST_Amount=@SGSTAmount,IGST_Amount=@IGSTAmount,PaymentTerms=@PaymentTerms,GstState=@GstState,GstNo=@GstNo,
		ItemName=b.ItemName,SubItemName=b.SubItemName,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs,Units=b.Units,DeliveryDate=b.Deliverydate,RoundOffAmt=@roundOffAmt,		
		ItOption =@ExpenseType
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.SrNo=b.SrNo		
		where a.PrNo=@PrNo
		
		update ITAssests.dbo.tbl_requestmaster
	    set Status_Code='PO'
	    from ITAssests.dbo.tbl_requestmaster a
	    inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNO
	    where b.PrNo=@PrNo and b.ITAssetNO is not null  and b.ITAssetNO !=''

		--update tbl_IOP2P_ItemRequest set VendorNumber=c.Vendor_number from tbl_IOP2P_ItemRequest a
		--inner join  [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on c.Vendor_Site_code=@vendorSite
		--where a.PrNo=@PrNo --and a.VendorSite=@vendorSite

		--update tbl_IOP2P_ItemRequest
		--set PONo= REPLACE(@PrNo,'PR','PO')
		--where PrNo=@PrNo

		select top 1 'genPO' , Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,Bilto.Branch_Address BillTo_Address,
		 A.ItemName,case when a.ITAssetno is null then A.SubItemName else ('<b>' + isnull(cpm.Product_Name,'') + ':</b><br>'+ A.SubItemName) end SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,case when a.ITAssetNo is not null then dbo.getEmpName(g.Approved_By) 
		 else c.HOE_Name end HOE_Name,a.Units ,a.Status ,isnull(d.Address_Line1,'')+','+isnull(d.Address_Line2,'')+','+isnull(d.Address_Line3,'')+','+
		 isnull(d.Address_Line4,'') +','+isnull(d.City,'') +','+isnull(d.State,'')+'-'+isnull(d.Postal_code,'')  VendorAdd
		 ,Convert(varchar,a.FC_Date,103) PODate,cast(isnull(CGST_Amount,0) as numeric(10,2))CGST_Amount,cast(isnull(SGST_Amount,0) as numeric(10,2))SGST_Amount,A.PaymentTerms,RoundOffAmt,
		 cast(isnull(IGST_Amount,0) as numeric(10,2))IGST_Amount,Cast(Total as numeric(10,2))Total,[CGST%],[SGST%],[IGST%],isnull(d.PAN_NO,'N/A') as VendorPan,isnull(d.GST_Registration_Number,'N/A') as VendorGST,GstState [STATE],GstNo [GSTNo],
		 a.Remark,I.Emp_name ITAssetReqBy,a.ITAssetNo,a.Warranty ,h.Model_Name ITAssetModelName,A.BillTo_Name,a.ShipTo_Name
		 from tbl_IOP2P_ItemRequest a
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
		left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no and c.Access in ('User','ITAssetUser')
		left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE Bilto on a.BillTO= Bilto.Branch_code
		left outer join ITAssests.dbo.tbl_RequestMaster g on a.ITAssetNo=g.Request_Id
		left join ITAssests.[dbo].[tbl_ProductModelMaster] h on g.Model_No=h.Model_Id
		left join ITAssests.[dbo].tbl_CapexProductMaster CPM on g.Item_Code=CPM.Product_Code
		left outer join risk.dbo.emp_info i on g.Requested_By=i.emp_no
		where PrNo=@PrNo

	   select top 1 Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		--select @PrNo	
	END

		--Invoice 
   if (@status=7) 
	 Begin	
	    
		--if exists(select a.Rate from tbl_IOP2P_ItemRequest a inner join @Items b on a.Srno=b.Srno where cast(b.Rate as money) > cast(a.Rate as money))
		-- Begin
		--  select 'Revised Rate cannot be higher than the previous Rate'
		--  return 
		-- End

		 if exists(select a.EstCosts from tbl_IOP2P_ItemRequest a inner join @Items b on a.Srno=b.Srno where cast(b.Costs as money) > cast(a.EstCosts as money))
		 Begin
		  select 'Invoice Amount cannot be higher than the Purchase Order Amount'
		  return 
		 End

		declare @PI as varchar(20)
		select  @PI='PI' + right('00000'+ cast(max(replace(isnull(INVOICE_NUM,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest
		--set Status=8,Update_Invoice=@Username,Update_Invoice_date=getdate()
		set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,INVOICE_NUM=@PI,Update_Invoice_date=getdate(),Update_Invoice=@Username,
		PI_Path=@PIpath,[Status]=8,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.Srno=b.SrNo
		where a.PrNo=@PrNo
		--select @PrNo	

		select 'Invoice No: '+@PI+' has been generated for PrNo: '+@PrNo

	  END
	End
Else --Negative status are all Rejections
  Begin
    if (@status=1)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-1,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=3)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-3,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=4)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-4,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=5)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-5,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=6)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-6,FC=@Username,FC_Date=getdate()
		where PrNo=@PrNo
	 End
  End

  /*Send Mail Notification*/
 Exec usp_IOP2P_sendemailPRUpdate @PrNo
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update_10dec2019
-- --------------------------------------------------
--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
--[Usp_PR_Update] 'PR119235','E00335','','','','DirApprove','6','FC Approved'
Create proc [dbo].[Usp_PR_Update_10dec2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null,
	@Statusflag varchar(50) = null,
	@Statuslevel varchar(20) = null,
	@CGST varchar(5) = null,
	@SGST varchar(5) = null,
	@IGST varchar(5) = null,
	@CGSTAmount money = null,
	@SGSTAmount money = null,
	@IGSTAmount money = null,
	@roundOffAmt varchar(15)=null,
	@Total money=null,
	@PaymentTerms varchar(300)=null,
	@GstState varchar(100)=null,
	@GstNo varchar(100)=null,
	@Comment varchar(100) = null,
	@PIpath varchar(300)=null,
	@ExpenseType varchar(100)=null,
	@closePO varchar(50) =null,
	@FromDate datetime = null,
	@ToDate datetime = null,	
	@Items [ItemList] readonly
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  

  /*Approval/Rejection Comments*/
  --if(@Comment is not null and @Comment!='')
  -- Begin
	  insert into tbl_IOP2P_Comments 
	  values(@PrNo,@Comment,@Statusflag,@status,@Username,getdate())
   --End
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if(@Statusflag='DirApprove')
	Begin
		if (@status=1)
		Begin 
			If (@Amt<=100000 and @status=1 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		End


		---HOE

	 if (@status=2)
		Begin 
			If (@Amt<=100000 and @status=2 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		END

		--CXO

	
  if (@status=3)
	Begin 
		If (@Amt<=1000000 and @status=3 )--CXO
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=4,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'HOE 333'
		END
	END

		--CFO
  if (@status=4)
	Begin 
		If (@Amt<=2500000 and @status=4 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=5,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'CFO'
		END
	END

		--CEO
  if (@status=5)
	Begin 
		If (@Amt>2500000 and @status=5 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CEO=@Username,CEO_Date=getdate()
			where PrNo=@PrNo
			--select @PrNo
		END
	
	END

		-- FC
  if (@status=6) 
	Begin	
	    declare @PONo as varchar(20)
		select  @PONo='PO' + right('00000'+ cast(max(replace(isnull(PONo,0),'PO','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest		
		set Status=7,FC=@Username,FC_Date=getdate(),PONo= @PONo,VendorSite=@vendorSite,Total=@Total,[CGST%]=@CGST,[SGST%]=@SGST,[IGST%]=@IGST,
		CGST_Amount=@CGSTAmount,SGST_Amount=@SGSTAmount,IGST_Amount=@IGSTAmount,PaymentTerms=@PaymentTerms,GstState=@GstState,GstNo=@GstNo,
		ItemName=b.ItemName,SubItemName=b.SubItemName,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs,Units=b.Units,DeliveryDate=b.Deliverydate,RoundOffAmt=@roundOffAmt,		
		ItOption =@ExpenseType
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.SrNo=b.SrNo		
		where a.PrNo=@PrNo
		
		update ITAssests.dbo.tbl_requestmaster
	    set Status_Code='PO'
	    from ITAssests.dbo.tbl_requestmaster a
	    inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNO
	    where b.PrNo=@PrNo and b.ITAssetNO is not null  and b.ITAssetNO !=''

		--update tbl_IOP2P_ItemRequest set VendorNumber=c.Vendor_number from tbl_IOP2P_ItemRequest a
		--inner join  [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on c.Vendor_Site_code=@vendorSite
		--where a.PrNo=@PrNo --and a.VendorSite=@vendorSite

		--update tbl_IOP2P_ItemRequest
		--set PONo= REPLACE(@PrNo,'PR','PO')
		--where PrNo=@PrNo

		select top 1 'genPO' , Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,Bilto.Branch_Address BillTo_Address,
		 A.ItemName,case when a.ITAssetno is null then A.SubItemName else ('<b>' + isnull(cpm.Product_Name,'') + ':</b><br>'+ A.SubItemName) end SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,case when a.ITAssetNo is not null then dbo.getEmpName(g.Approved_By) 
		 else c.HOE_Name end HOE_Name,a.Units ,a.Status ,isnull(d.Address_Line1,'')+','+isnull(d.Address_Line2,'')+','+isnull(d.Address_Line3,'')+','+
		 isnull(d.Address_Line4,'') +','+isnull(d.City,'') +','+isnull(d.State,'')+'-'+isnull(d.Postal_code,'')  VendorAdd
		 ,Convert(varchar,a.FC_Date,103) PODate,cast(isnull(CGST_Amount,0) as numeric(10,2))CGST_Amount,cast(isnull(SGST_Amount,0) as numeric(10,2))SGST_Amount,A.PaymentTerms,RoundOffAmt,
		 cast(isnull(IGST_Amount,0) as numeric(10,2))IGST_Amount,Cast(Total as numeric(10,2))Total,[CGST%],[SGST%],[IGST%],isnull(d.PAN_NO,'N/A') as VendorPan,isnull(d.GST_Registration_Number,'N/A') as VendorGST,GstState [STATE],GstNo [GSTNo],
		 a.Remark,I.Emp_name ITAssetReqBy,a.ITAssetNo,a.Warranty ,h.Model_Name ITAssetModelName,A.BillTo_Name,a.ShipTo_Name
		 from tbl_IOP2P_ItemRequest a
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
		left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no and c.Access in ('User','ITAssetUser')
		left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE Bilto on a.BillTO= Bilto.Branch_code
		left outer join ITAssests.dbo.tbl_RequestMaster g on a.ITAssetNo=g.Request_Id
		left join ITAssests.[dbo].[tbl_ProductModelMaster] h on g.Model_No=h.Model_Id
		left join ITAssests.[dbo].tbl_CapexProductMaster CPM on g.Item_Code=CPM.Product_Code
		left outer join risk.dbo.emp_info i on g.Requested_By=i.emp_no
		where PrNo=@PrNo

	   --select top 1 Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		--select @PrNo	
	END

		--Invoice 
   if (@status=7) 
	 Begin	
	    select ItmID, sum(costs) Costs 
		   into #Advdetails 
		  from  tbl_IOP2P_Advance   where PrNo=@PrNo and left(PANO,2)='PI' 
		  group by ItmID 

		  select a.SrNo, (a.costs + b.costs)Costs
		  into #Itmdetails
		  from  @Items a left outer join #Advdetails b on a.SrNo=b.ItmID
		  

		  --drop table IOP2Ptmp1
		  --select * into IOP2Ptmp1 from @Items

		 --if exists(select a.EstCosts from tbl_IOP2P_ItemRequest a inner join #Itmdetails b on a.Srno=b.Srno where cast(b.Costs as money) > cast(a.EstCosts as money))
		 --Begin
		 -- select 'Invoice Amount for Items cannot be higher than the Purchase Order Amount'
		 -- return 
		 --End

		declare @PI as varchar(20)
		--select  @PI='PI' + right('00000'+ cast(max(replace(isnull(INVOICE_NUM,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest			
		select  @PI='PI' + right('00000'+ cast(max(replace(isnull(PANo,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_Advance where left(PANO,2)='PI'	


		Update tbl_IOP2P_ItemRequest
		set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,--INVOICE_NUM=@PI,
		Update_Invoice_date=getdate(),Update_Invoice=@Username,
		PI_Path=@PIpath --,ItmQty=b.Qty--,Rate=b.Rate,EstCosts=b.Costs
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.Srno=b.SrNo
		where a.PrNo=@PrNo
		--select @PrNo	

		insert into tbl_IOP2P_Advance (PANo,PrNo,Amount,UpdatedBy,Updateddate,[IGST%],[SGST%],[CGST%],IGST_Amount,SGST_Amount,CGST_Amount,PI_Path,Vendor_Bill_Num,Vendor_Bill_Date,
		ItmID,rate,RoundOffAmt,costs,units,ItmQty,SubItemName,ItemName,DeliveryDate,FromDate,ToDate)
		select  @PI,@PrNo,@Total,@Username,getdate(),@IGST,@SGST,@CGST,@IGSTAmount,@SGSTAmount,@CGSTAmount,@PIpath,@vendorBillno,@vendorBilldate,
		SrNo,Rate,@roundOffAmt,Costs,Units,Qty,SubItemName,ItemName,Deliverydate,@FromDate,@ToDate from @Items

		select @total=isnull(sum(Amount),0) from tbl_IOP2P_Advance where PRNo = @prno and left(PANO,2)='PI' 

		if(@closePO='True' or @total =(select top 1 Total from tbl_IOP2P_ItemRequest where PrNo=@PrNo))
		 Begin
		  update tbl_IOP2P_ItemRequest set [Status]='8' where PrNo=@PrNo
		 End

		select 'Invoice No: '+@PI+' has been generated for PrNo: '+@PrNo

	  END
	End
Else --Negative status are all Rejections
  Begin
    if (@status=1)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-1,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=3)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-3,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=4)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-4,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=5)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-5,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=6)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-6,FC=@Username,FC_Date=getdate()
		where PrNo=@PrNo
	 End
  End

  /*Send Mail Notification*/
 Exec usp_IOP2P_sendemailPRUpdate @PrNo
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update_23May2019
-- --------------------------------------------------
--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
--[Usp_PR_Update] 'PR119235','E00335','','','','DirApprove','6','FC Approved'
CREATE proc [dbo].[Usp_PR_Update_23May2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null,
	@Statusflag varchar(50) = null,
	@Statuslevel varchar(20) = null,
	@CGST varchar(5) = null,
	@SGST varchar(5) = null,
	@IGST varchar(5) = null,
	@CGSTAmount money = null,
	@SGSTAmount money = null,
	@IGSTAmount money = null,
	@roundOffAmt varchar(15)=null,
	@Total money=null,
	@PaymentTerms varchar(300)=null,
	@GstState varchar(100)=null,
	@GstNo varchar(100)=null,
	@Comment varchar(100) = null,
	@PIpath varchar(300)=null,
	@ExpenseType varchar(100)=null,	
	@Items [ItemList] readonly
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  

  /*Approval/Rejection Comments*/
  --if(@Comment is not null and @Comment!='')
  -- Begin
	  insert into tbl_IOP2P_Comments 
	  values(@PrNo,@Comment,@Statusflag,@status,@Username,getdate())
   --End
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if(@Statusflag='DirApprove')
	Begin
		if (@status=1)
		Begin 
			If (@Amt<=100000 and @status=1 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		End


		---HOE

	 if (@status=2)
		Begin 
			If (@Amt<=100000 and @status=2 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		END

		--CXO

	
  if (@status=3)
	Begin 
		If (@Amt<=1000000 and @status=3 )--CXO
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=4,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'HOE 333'
		END
	END

		--CFO
  if (@status=4)
	Begin 
		If (@Amt<=2500000 and @status=4 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=5,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'CFO'
		END
	END

		--CEO
  if (@status=5)
	Begin 
		If (@Amt>2500000 and @status=5 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CEO=@Username,CEO_Date=getdate()
			where PrNo=@PrNo
			--select @PrNo
		END
	
	END

		-- FC
  if (@status=6) 
	Begin	
	    declare @PONo as varchar(20)
		select  @PONo='PO' + right('00000'+ cast(max(replace(isnull(PONo,0),'PO','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest		
		set Status=7,FC=@Username,FC_Date=getdate(),PONo= @PONo,VendorSite=@vendorSite,Total=@Total,[CGST%]=@CGST,[SGST%]=@SGST,[IGST%]=@IGST,
		CGST_Amount=@CGSTAmount,SGST_Amount=@SGSTAmount,IGST_Amount=@IGSTAmount,PaymentTerms=@PaymentTerms,GstState=@GstState,GstNo=@GstNo,
		ItemName=b.ItemName,SubItemName=b.SubItemName,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs,Units=b.Units,DeliveryDate=b.Deliverydate,RoundOffAmt=@roundOffAmt,		
		ItOption =@ExpenseType
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.SrNo=b.SrNo		
		where a.PrNo=@PrNo
		
		update ITAssests.dbo.tbl_requestmaster
	    set Status_Code='PO'
	    from ITAssests.dbo.tbl_requestmaster a
	    inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNO
	    where b.PrNo=@PrNo and b.ITAssetNO is not null  and b.ITAssetNO !=''

		--update tbl_IOP2P_ItemRequest set VendorNumber=c.Vendor_number from tbl_IOP2P_ItemRequest a
		--inner join  [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on c.Vendor_Site_code=@vendorSite
		--where a.PrNo=@PrNo --and a.VendorSite=@vendorSite

		--update tbl_IOP2P_ItemRequest
		--set PONo= REPLACE(@PrNo,'PR','PO')
		--where PrNo=@PrNo

		select top 1 'genPO' , Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,Bilto.Branch_Address BillTo_Address,
		 A.ItemName,case when a.ITAssetno is null then A.SubItemName else ('<b>' + isnull(cpm.Product_Name,'') + ':</b><br>'+ A.SubItemName) end SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,
		 case when a.ITAssetNo is not null then dbo.getEmpName(g.Approved_By) 
		 else c.HOE_Name end HOE_Name,a.Units ,a.Status ,isnull(d.Address_Line1,'')+','+isnull(d.Address_Line2,'')+','+isnull(d.Address_Line3,'')+','+
		 isnull(d.Address_Line4,'') +','+isnull(d.City,'') +','+isnull(d.State,'')+'-'+isnull(d.Postal_code,'')  VendorAdd
		 ,Convert(varchar,a.FC_Date,103) PODate,cast(isnull(CGST_Amount,0) as numeric(10,2))CGST_Amount,cast(isnull(SGST_Amount,0) as numeric(10,2))SGST_Amount,A.PaymentTerms,RoundOffAmt,
		 cast(isnull(IGST_Amount,0) as numeric(10,2))IGST_Amount,Cast(Total as numeric(10,2))Total,[CGST%],[SGST%],[IGST%],isnull(d.PAN_NO,'N/A') as VendorPan,isnull(d.GST_Registration_Number,'N/A') as VendorGST,GstState [STATE],GstNo [GSTNo],
		 a.Remark,I.Emp_name ITAssetReqBy,a.ITAssetNo,a.Warranty ,h.Model_Name ITAssetModelName,A.BillTo_Name,a.ShipTo_Name
		 from tbl_IOP2P_ItemRequest a
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
		left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no and c.Access in ('User','ITAssetUser')
		left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE Bilto on a.BillTO= Bilto.Branch_code
		left outer join ITAssests.dbo.tbl_RequestMaster g on a.ITAssetNo=g.Request_Id
		left join ITAssests.[dbo].[tbl_ProductModelMaster] h on g.Model_No=h.Model_Id
		left join ITAssests.[dbo].tbl_CapexProductMaster CPM on g.Item_Code=CPM.Product_Code
		left outer join risk.dbo.emp_info i on g.Requested_By=i.emp_no
		where PrNo=@PrNo

	   --select top 1 Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		--select @PrNo	
	END

		--Invoice 
   if (@status=7) 
	 Begin	
	    
		--if exists(select a.Rate from tbl_IOP2P_ItemRequest a inner join @Items b on a.Srno=b.Srno where cast(b.Rate as money) > cast(a.Rate as money))
		-- Begin
		--  select 'Revised Rate cannot be higher than the previous Rate'
		--  return 
		-- End

		 if exists(select a.EstCosts from tbl_IOP2P_ItemRequest a inner join @Items b on a.Srno=b.Srno where cast(b.Costs as money) > cast(a.EstCosts as money))
		 Begin
		  select 'Invoice Amount cannot be higher than the Purchase Order Amount'
		  return 
		 End

		declare @PI as varchar(20)
		select  @PI='PI' + right('00000'+ cast(max(replace(isnull(INVOICE_NUM,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest
		--set Status=8,Update_Invoice=@Username,Update_Invoice_date=getdate()
		set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,INVOICE_NUM=@PI,Update_Invoice_date=getdate(),Update_Invoice=@Username,
		PI_Path=@PIpath,[Status]=8,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.Srno=b.SrNo
		where a.PrNo=@PrNo
		--select @PrNo	

		select 'Invoice No: '+@PI+' has been generated for PrNo: '+@PrNo

	  END
	End
Else --Negative status are all Rejections
  Begin
    if (@status=1)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-1,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=3)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-3,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=4)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-4,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=5)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-5,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=6)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-6,FC=@Username,FC_Date=getdate()
		where PrNo=@PrNo
	 End
  End

  /*Send Mail Notification*/
 Exec usp_IOP2P_sendemailPRUpdate @PrNo
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update_29May2019
-- --------------------------------------------------
--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
--[Usp_PR_Update] 'PR119235','E00335','','','','DirApprove','6','FC Approved'
create proc [dbo].[Usp_PR_Update_29May2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null,
	@Statusflag varchar(50) = null,
	@Statuslevel varchar(20) = null,
	@CGST varchar(5) = null,
	@SGST varchar(5) = null,
	@IGST varchar(5) = null,
	@CGSTAmount money = null,
	@SGSTAmount money = null,
	@IGSTAmount money = null,
	@roundOffAmt varchar(15)=null,
	@Total money=null,
	@PaymentTerms varchar(300)=null,
	@GstState varchar(100)=null,
	@GstNo varchar(100)=null,
	@Comment varchar(100) = null,
	@PIpath varchar(300)=null,
	@ExpenseType varchar(100)=null,
	@closePO varchar(50) =null,
	@FromDate datetime = null,
	@ToDate datetime = null,	
	@Items [ItemList] readonly
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  

  /*Approval/Rejection Comments*/
  --if(@Comment is not null and @Comment!='')
  -- Begin
	  insert into tbl_IOP2P_Comments 
	  values(@PrNo,@Comment,@Statusflag,@status,@Username,getdate())
   --End
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if(@Statusflag='DirApprove')
	Begin
		if (@status=1)
		Begin 
			If (@Amt<=100000 and @status=1 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		End


		---HOE

	 if (@status=2)
		Begin 
			If (@Amt<=100000 and @status=2 )--HOE
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=6,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'hi'
			END
			else
			BEGIN 
				Update tbl_IOP2P_ItemRequest
				set Status=3,HOE=@Username,HOE_Date=getdate()
				where PrNo=@PrNo
				--select 'HOE 333'
			END
		END

		--CXO

	
  if (@status=3)
	Begin 
		If (@Amt<=1000000 and @status=3 )--CXO
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=4,CXO=@Username,CXO_Date=getdate()
			where PrNo=@PrNo
			--select 'HOE 333'
		END
	END

		--CFO
  if (@status=4)
	Begin 
		If (@Amt<=2500000 and @status=4 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'hi'
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=5,CFO=@Username,CFO_Date=getdate()
			where PrNo=@PrNo
			--select 'CFO'
		END
	END

		--CEO
  if (@status=5)
	Begin 
		If (@Amt>2500000 and @status=5 )
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=6,CEO=@Username,CEO_Date=getdate()
			where PrNo=@PrNo
			--select @PrNo
		END
	
	END

		-- FC
  if (@status=6) 
	Begin	
	    declare @PONo as varchar(20)
		select  @PONo='PO' + right('00000'+ cast(max(replace(isnull(PONo,0),'PO','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest	
		
		Update tbl_IOP2P_ItemRequest		
		set Status=7,FC=@Username,FC_Date=getdate(),PONo= @PONo,VendorSite=@vendorSite,Total=@Total,[CGST%]=@CGST,[SGST%]=@SGST,[IGST%]=@IGST,
		CGST_Amount=@CGSTAmount,SGST_Amount=@SGSTAmount,IGST_Amount=@IGSTAmount,PaymentTerms=@PaymentTerms,GstState=@GstState,GstNo=@GstNo,
		ItemName=b.ItemName,SubItemName=b.SubItemName,ItmQty=b.Qty,Rate=b.Rate,EstCosts=b.Costs,Units=b.Units,DeliveryDate=b.Deliverydate,RoundOffAmt=@roundOffAmt,		
		ItOption =@ExpenseType
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.SrNo=b.SrNo		
		where a.PrNo=@PrNo
		
		update ITAssests.dbo.tbl_requestmaster
	    set Status_Code='PO'
	    from ITAssests.dbo.tbl_requestmaster a
	    inner join tbl_IOP2P_ItemRequest b on a.Request_id=b.ITAssetNO
	    where b.PrNo=@PrNo and b.ITAssetNO is not null  and b.ITAssetNO !=''

		--update tbl_IOP2P_ItemRequest set VendorNumber=c.Vendor_number from tbl_IOP2P_ItemRequest a
		--inner join  [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c on c.Vendor_Site_code=@vendorSite
		--where a.PrNo=@PrNo --and a.VendorSite=@vendorSite

		--update tbl_IOP2P_ItemRequest
		--set PONo= REPLACE(@PrNo,'PR','PO')
		--where PrNo=@PrNo

		select top 1 'genPO' , Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,Bilto.Branch_Address BillTo_Address,
		 A.ItemName,case when a.ITAssetno is null then A.SubItemName else ('<b>' + isnull(cpm.Product_Name,'') + ':</b><br>'+ A.SubItemName) end SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,case when a.ITAssetNo is not null then dbo.getEmpName(g.Approved_By) 
		 else c.HOE_Name end HOE_Name,a.Units ,a.Status ,isnull(d.Address_Line1,'')+','+isnull(d.Address_Line2,'')+','+isnull(d.Address_Line3,'')+','+
		 isnull(d.Address_Line4,'') +','+isnull(d.City,'') +','+isnull(d.State,'')+'-'+isnull(d.Postal_code,'')  VendorAdd
		 ,Convert(varchar,a.FC_Date,103) PODate,cast(isnull(CGST_Amount,0) as numeric(10,2))CGST_Amount,cast(isnull(SGST_Amount,0) as numeric(10,2))SGST_Amount,A.PaymentTerms,RoundOffAmt,
		 cast(isnull(IGST_Amount,0) as numeric(10,2))IGST_Amount,Cast(Total as numeric(10,2))Total,[CGST%],[SGST%],[IGST%],isnull(d.PAN_NO,'N/A') as VendorPan,isnull(d.GST_Registration_Number,'N/A') as VendorGST,GstState [STATE],GstNo [GSTNo],
		 a.Remark,I.Emp_name ITAssetReqBy,a.ITAssetNo,a.Warranty ,h.Model_Name ITAssetModelName,A.BillTo_Name,a.ShipTo_Name
		 from tbl_IOP2P_ItemRequest a
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
		left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no and c.Access in ('User','ITAssetUser')
		left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
		left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE Bilto on a.BillTO= Bilto.Branch_code
		left outer join ITAssests.dbo.tbl_RequestMaster g on a.ITAssetNo=g.Request_Id
		left join ITAssests.[dbo].[tbl_ProductModelMaster] h on g.Model_No=h.Model_Id
		left join ITAssests.[dbo].tbl_CapexProductMaster CPM on g.Item_Code=CPM.Product_Code
		left outer join risk.dbo.emp_info i on g.Requested_By=i.emp_no
		where PrNo=@PrNo

	   --select top 1 Comments FCRemark from tbl_IOP2P_comments where PrNo=@PrNo and level=6 order by UpdatedDate  desc
		--select @PrNo	
	END

		--Invoice 
   if (@status=7) 
	 Begin	
	    select ItmID, sum(costs) Costs 
		   into #Advdetails 
		  from  tbl_IOP2P_Advance   where PrNo=@PrNo and left(PANO,2)='PI' 
		  group by ItmID 

		  select a.SrNo, (a.costs + b.costs)Costs
		  into #Itmdetails
		  from  @Items a left outer join #Advdetails b on a.SrNo=b.ItmID
		  

		  --drop table IOP2Ptmp1
		  --select * into IOP2Ptmp1 from @Items

		 --if exists(select a.EstCosts from tbl_IOP2P_ItemRequest a inner join #Itmdetails b on a.Srno=b.Srno where cast(b.Costs as money) > cast(a.EstCosts as money))
		 --Begin
		 -- select 'Invoice Amount for Items cannot be higher than the Purchase Order Amount'
		 -- return 
		 --End

		declare @PI as varchar(20)
		--select  @PI='PI' + right('00000'+ cast(max(replace(isnull(INVOICE_NUM,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_ItemRequest			
		select  @PI='PI' + right('00000'+ cast(max(replace(isnull(PANo,0),'PI','')) +1 as varchar),6)	from tbl_IOP2P_Advance where left(PANO,2)='PI'	


		Update tbl_IOP2P_ItemRequest
		set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,--INVOICE_NUM=@PI,
		Update_Invoice_date=getdate(),Update_Invoice=@Username,
		PI_Path=@PIpath --,ItmQty=b.Qty--,Rate=b.Rate,EstCosts=b.Costs
		from tbl_IOP2P_ItemRequest a
		inner join @Items b on a.Srno=b.SrNo
		where a.PrNo=@PrNo
		--select @PrNo	

		insert into tbl_IOP2P_Advance (PANo,PrNo,Amount,UpdatedBy,Updateddate,[IGST%],[SGST%],[CGST%],IGST_Amount,SGST_Amount,CGST_Amount,PI_Path,Vendor_Bill_Num,Vendor_Bill_Date,
		ItmID,rate,RoundOffAmt,costs,units,ItmQty,SubItemName,ItemName,DeliveryDate,FromDate,ToDate)
		select  @PI,@PrNo,@Total,@Username,getdate(),@IGST,@SGST,@CGST,@IGSTAmount,@SGSTAmount,@CGSTAmount,@PIpath,@vendorBillno,@vendorBilldate,
		SrNo,Rate,@roundOffAmt,Costs,Units,Qty,SubItemName,ItemName,Deliverydate,@FromDate,@ToDate from @Items

		select @total=isnull(sum(Amount),0) +@total from tbl_IOP2P_Advance where PRNo = @prno and left(PANO,2)='PI' 

		if(@closePO='True' or @total =(select top 1 Total from tbl_IOP2P_ItemRequest where PrNo=@PrNo))
		 Begin
		  update tbl_IOP2P_ItemRequest set Status=8 where PrNo=@PrNo
		 End

		select 'Invoice No: '+@PI+' has been generated for PrNo: '+@PrNo

	  END
	End
Else --Negative status are all Rejections
  Begin
    if (@status=1)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-1,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=3)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-3,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=4)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-4,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=5)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-5,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
	 End
	 if (@status=6)
	 Begin
		Update tbl_IOP2P_ItemRequest
		set Status=-6,FC=@Username,FC_Date=getdate()
		where PrNo=@PrNo
	 End
  End

  /*Send Mail Notification*/
 Exec usp_IOP2P_sendemailPRUpdate @PrNo
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update04Jan2019
-- --------------------------------------------------

--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
CREATE proc [dbo].[Usp_PR_Update04Jan2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20)
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  
   
 --select * from Vw_UserRoles
 --where emp_no='E77084' 
if (@status=1 )
Begin  
		If (@Amt<=50000 and @status=1 )--'HOD'
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=5,ApprovedBY=@Username,ApprovedDate=getdate()
			where PrNo=@PrNo
			
		END
		else
		BEGIN 
			Update tbl_IOP2P_ItemRequest
			set Status=2,ApprovedBY=@Username,ApprovedDate=getdate()
			where PrNo=@PrNo
			
		END
END

if (@status=2)
Begin 
	If (@Amt<=500000 and @status=2 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=5,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=3,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END


if (@status=3)
Begin 
	If (@Amt<=2500000 and @status=3 )--CFO
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=5,ApprovedBY=@Username,ApprovedDate=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=4,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'CFO'
	END
END


if (@status=4)
Begin 
	If (@Amt>2500000 and @status=4 )--CFO
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=5,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
		--select @PrNo
	END
	
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update07Jan2019
-- --------------------------------------------------

--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
CREATE proc [dbo].[Usp_PR_Update07Jan2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20)
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  
   
 
 --HOD only for reviwer no limit
if (@status=1 )
Begin  
		
			Update tbl_IOP2P_ItemRequest
			set Status=2,ApprovedBY=@Username,ApprovedDate=getdate()
			where PrNo=@PrNo
END


---HOE

if (@status=2)
Begin 
	If (@Amt<=100000 and @status=2 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=3,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END

--CXO

if (@status=3)
Begin 
	If (@Amt<=500000 and @status=3 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=4,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END

--CFO
if (@status=4)
Begin 
	If (@Amt<=2500000 and @status=4 )
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=5,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'CFO'
	END
END

--CEO
if (@status=5)
Begin 
	If (@Amt>2500000 and @status=5 )
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
		--select @PrNo
	END
	
END

-- FC
if (@status=6) 
Begin	
	Update tbl_IOP2P_ItemRequest
	set Status=7,FC=@Username,FC_Date=getdate()
	where PrNo=@PrNo
	--select @PrNo	
END

--Invoice 
if (@status=7) 
Begin	
	Update tbl_IOP2P_ItemRequest
	set Status=8,Update_Invoice=@Username,Update_Invoice_date=getdate()
	where PrNo=@PrNo
	--select @PrNo	
END


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update15Jan2019
-- --------------------------------------------------
--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
CREATE proc [dbo].[Usp_PR_Update15Jan2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  
   
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if (@status=1 )
Begin 
	If (@Amt<=100000 and @status=1 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=3,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
End


---HOE

if (@status=2)
Begin 
	If (@Amt<=100000 and @status=2 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=3,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END

--CXO

if (@status=3)
Begin 
	If (@Amt<=1000000 and @status=3 )--CXO
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=4,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END

--CFO
if (@status=4)
Begin 
	If (@Amt<=2500000 and @status=4 )
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=5,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'CFO'
	END
END

--CEO
if (@status=5)
Begin 
	If (@Amt>2500000 and @status=5 )
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
		--select @PrNo
	END
	
END

-- FC
if (@status=6) 
Begin	
	Update tbl_IOP2P_ItemRequest
	set Status=7,FC=@Username,FC_Date=getdate(),PONo= REPLACE(@PrNo,'PR','PO'),VendorSite=@vendorSite
	where PrNo=@PrNo

	--update tbl_IOP2P_ItemRequest
	--set PONo= REPLACE(@PrNo,'PR','PO')
	--where PrNo=@PrNo

	select 'genPO'
	select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,
	 A.ItemName,A.SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,c.HOE_Name,a.Units ,a.Status ,(d.Address_Line1+','+d.Address_Line2+','+d.Address_Line3+','+d.Address_Line4)VendorAdd
	 ,Convert(varchar,a.FC_Date,103) PODate
	 from tbl_IOP2P_ItemRequest a
	left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
	left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no
	left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
	left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
	left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
	where PrNo=@PrNo
	--select @PrNo	
END

--Invoice 
if (@status=7) 
Begin	
	Update tbl_IOP2P_ItemRequest
	--set Status=8,Update_Invoice=@Username,Update_Invoice_date=getdate()
	set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,INVOICE_NUM=REPLACE(@PrNo,'PR','PI'),Update_Invoice_date=getdate(),Update_Invoice=@Username,Status=8
	where PrNo=@PrNo
	--select @PrNo	

	select 'Invoice No: '+REPLACE(@PrNo,'PR','PI')+' has been generated for PrNo: '+@PrNo

END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_PR_Update16Jan2019
-- --------------------------------------------------
--select status,EstCosts,HOE,HOE_date,CFO,CFO_date,CEO,CEO_date,* from tbl_IOP2P_ItemRequest where PrNo in ('PR131119177','PR1311218145','PR1311218150','PR1311218134')

--exec Usp_PR_Update 'PR131119177','E57731'
CREATE proc [dbo].[Usp_PR_Update16Jan2019] 
(
	@PrNo as varchar(20),
	@Username as varchar(20),
	@vendorBillno as varchar(50)=null,
	@vendorBilldate as datetime=null,
	@vendorSite varchar(100) =null
)
 as                     
 begin  
 
 --declare @Username as varchar(100)
 --set @Username='E57731'
 
 select a.PrNo,b.Parent_Name,--sum((cast(a.Rate as money) * cast(A.ItmQty as numeric))) TotalCosts ,
sum(EStcosts) TotalCosts,
a.requestedBy,a.status 
into #tmp
from tbl_IOP2P_ItemRequest a
inner join [Vw_UserRoles] d on a.RequestedBy=d.emp_no
left outer join (select distinct Entity_code,Parent_Name from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE) b on a.Company=b.Entity_Code
--left outer join tbl_IOP2P_ItemMaster c on a.SubItemName= c.SubItem
where (d.Senior=@Username or d.hoe=@Username or d.CXO =@Username or d.cfo=@Username or d.ceo=@Username or d.fc=@Username )  and
a.PrNo is not null  --and ApprovedBY is null  --and a.status=1 
group by PrNo,b.Parent_Name,a.RequestedBy,a.status
 

 declare @Amt money
 select @Amt = TotalCosts from #tmp where PrNo=@PrNo 
 print @Amt 
 
 declare @Empno as varchar(100)
 select @Empno = RequestedBy from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @Empno
 
 declare @status as varchar(100)
 select @status = status from tbl_IOP2P_ItemRequest where PrNo=@PrNo
 print @status  
  
   
 
 -- skipped HOD Approval to HOE Directly and so status 1 will be updated by HOE directly to 3
if (@status=1 )
Begin 
	If (@Amt<=100000 and @status=1 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=3,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
End


---HOE

if (@status=2)
Begin 
	If (@Amt<=100000 and @status=2 )--HOE
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=3,HOE=@Username,HOE_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END

--CXO

if (@status=3)
Begin 
	If (@Amt<=1000000 and @status=3 )--CXO
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=4,CXO=@Username,CXO_Date=getdate()
		where PrNo=@PrNo
		--select 'HOE 333'
	END
END

--CFO
if (@status=4)
Begin 
	If (@Amt<=2500000 and @status=4 )
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'hi'
	END
	else
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=5,CFO=@Username,CFO_Date=getdate()
		where PrNo=@PrNo
		--select 'CFO'
	END
END

--CEO
if (@status=5)
Begin 
	If (@Amt>2500000 and @status=5 )
	BEGIN 
		Update tbl_IOP2P_ItemRequest
		set Status=6,CEO=@Username,CEO_Date=getdate()
		where PrNo=@PrNo
		--select @PrNo
	END
	
END

-- FC
if (@status=6) 
Begin	
	Update tbl_IOP2P_ItemRequest
	set Status=7,FC=@Username,FC_Date=getdate(),PONo= REPLACE(@PrNo,'PR','PO'),VendorSite=@vendorSite
	where PrNo=@PrNo

	--update tbl_IOP2P_ItemRequest
	--set PONo= REPLACE(@PrNo,'PR','PO')
	--where PrNo=@PrNo

	select 'genPO'
	select A.PrNo,b.Parent_Name compName ,a.PONo,Convert(varchar,a.DeliveryDate,103)DeliveryDate,a.VendorID,d.Vendor_Name,e.Branch_Address ShipTo_Address, f.Branch_Address,
	 A.ItemName,A.SubItemName,A.ItmQty,cast(A.Rate as numeric(10,2))Rate,cast(A.EstCosts as numeric(10,2))EstCosts,c.Emp_name,c.HOE_Name,a.Units ,a.Status ,(d.Address_Line1+','+d.Address_Line2+','+d.Address_Line3+','+d.Address_Line4)VendorAdd
	 ,Convert(varchar,a.FC_Date,103) PODate
	 from tbl_IOP2P_ItemRequest a
	left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_ENTITY_CODE b  on a.company=b.Entity_Code
	left outer join [Vw_UserRoles] c on a.RequestedBy =c.emp_no
	left outer join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail d on a.VendorNumber=d.Vendor_Number and a.VendorSite=d.Vendor_Site_ID
	left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE e on a.ShipTO= e.Branch_code
	left outer join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE f on a.Branch= f.Branch_code
	where PrNo=@PrNo
	--select @PrNo	
END

--Invoice 
if (@status=7) 
Begin	
	Update tbl_IOP2P_ItemRequest
	--set Status=8,Update_Invoice=@Username,Update_Invoice_date=getdate()
	set Vendor_Bill_Num=@vendorBillno,Vendor_Bill_Date =@vendorBilldate,INVOICE_NUM=REPLACE(@PrNo,'PR','PI'),Update_Invoice_date=getdate(),Update_Invoice=@Username,Status=8
	where PrNo=@PrNo
	--select @PrNo	

	select 'Invoice No: '+REPLACE(@PrNo,'PR','PI')+' has been generated for PrNo: '+@PrNo

END

END

GO

-- --------------------------------------------------
-- TABLE dbo.Accounts
-- --------------------------------------------------
CREATE TABLE [dbo].[Accounts]
(
    [Emp_no] VARCHAR(50) NULL,
    [Branch_Type] VARCHAR(50) NULL,
    [HOE] VARCHAR(50) NULL,
    [HOE_Name] VARCHAR(50) NULL,
    [CXO] VARCHAR(50) NULL,
    [CXO_Name] VARCHAR(50) NULL,
    [CFO] VARCHAR(50) NULL,
    [CFO_Name] VARCHAR(50) NULL,
    [CEO] VARCHAR(50) NULL,
    [CEO_Name] VARCHAR(50) NULL,
    [FC] VARCHAR(50) NULL,
    [FC_Name] VARCHAR(50) NULL,
    [Access] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IOP2Ptmp1
-- --------------------------------------------------
CREATE TABLE [dbo].[IOP2Ptmp1]
(
    [SrNo] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [Qty] NUMERIC(10, 0) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(10) NULL,
    [Deliverydate] DATETIME NULL,
    [Expense] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ItemMaster_Rmv
-- --------------------------------------------------
CREATE TABLE [dbo].[ItemMaster_Rmv]
(
    [Srno] FLOAT NULL,
    [ItemType] NVARCHAR(255) NULL,
    [Item] NVARCHAR(255) NULL,
    [SubItem] NVARCHAR(255) NULL,
    [A/C Code] FLOAT NULL,
    [A/C Description] NVARCHAR(255) NULL,
    [ProductType] NVARCHAR(255) NULL,
    [Units] NVARCHAR(255) NULL,
    [Chapter / Section / Heading] NVARCHAR(255) NULL,
    [Description of Service] NVARCHAR(255) NULL,
    [CGST Rate(%)] FLOAT NULL,
    [SGST/UTGST Rate(%)] FLOAT NULL,
    [IGST Rate(%)] FLOAT NULL,
    [Compensation Cess / Condition] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_06dec2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_06dec2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_09Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_09Apr2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_10Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_10Apr2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_11Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_11Mar2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_13Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_13Aug2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_15122019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_15122019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_15Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_15Oct2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_17aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_17aug2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_18Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_18Sep2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_19Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_19Sep2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_26Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_26Mar2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list_28Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list_28Nov2019]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list01Feb2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list01Feb2019_Renamed_By_DBA]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [F13] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HODEmp_list07Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HODEmp_list07Mar2019_Renamed_By_DBA]
(
    [Emp_no] NVARCHAR(255) NULL,
    [Branch_Type] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL,
    [CXO] NVARCHAR(255) NULL,
    [CXO_Name] NVARCHAR(255) NULL,
    [CFO] NVARCHAR(255) NULL,
    [CFO_Name] NVARCHAR(255) NULL,
    [CEO] NVARCHAR(255) NULL,
    [CEO_Name] NVARCHAR(255) NULL,
    [FC] NVARCHAR(255) NULL,
    [FC_Name] NVARCHAR(255) NULL,
    [Access] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HOETree
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HOETree]
(
    [emp_no] NVARCHAR(255) NULL,
    [Emp_name] NVARCHAR(255) NULL,
    [HOE] NVARCHAR(255) NULL,
    [HOE_Name] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_03jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_03jun2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_iop2p_Advance_04Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_iop2p_Advance_04Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_05Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_05Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_08may2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_08may2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2p_Advance_08May2019_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2p_Advance_08May2019_2]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_10dec2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_10dec2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_12jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_12jun2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_21Jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_21Jun2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_21May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_21May2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_23Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_23Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_23May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_23May2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_24May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_24May2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_26Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_26Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_29May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_29May2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_29May2019_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_29May2019_2]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Advance_30may2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Advance_30may2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PANo] VARCHAR(50) NULL,
    [PrNo] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [BatchName] VARCHAR(50) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [Updateddate] DATETIME NULL,
    [Status] VARCHAR(20) NULL,
    [IGST%] VARCHAR(5) NULL,
    [SGST%] VARCHAR(5) NULL,
    [CGST%] VARCHAR(5) NULL,
    [IGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [CGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(500) NULL,
    [Vendor_Bill_Num] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [ItmID] NUMERIC(18, 0) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [Rate] MONEY NULL,
    [Costs] MONEY NULL,
    [Units] VARCHAR(20) NULL,
    [RoundOffAmt] MONEY NULL,
    [DeliveryDate] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_01Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_01Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_02mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_02mar2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_02May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_02May2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_03jul2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_03jul2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_05Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_05Nov2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_06Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_06Aug2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_11Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_11Oct2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_13dec2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_13dec2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_13Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_13Sep2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_14Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_14Aug2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_14Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_14Oct2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_18Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_18Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_18Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_18Oct2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_18sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_18sep2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2p_comments_19Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2p_comments_19Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_20Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_20Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_20Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_20Nov2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_20Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_20Sep2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_21nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_21nov2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_25Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_25Apr2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_25jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_25jun2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_26Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_26Sep2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_27Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_27Aug2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments_27nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments_27nov2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Comments05Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Comments05Mar2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [Comments] VARCHAR(100) NULL,
    [Status] VARCHAR(10) NULL,
    [Level] VARCHAR(10) NULL,
    [UpdatedBy] VARCHAR(20) NULL,
    [UpdatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_GSTNoMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_GSTNoMaster]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Entity_code] VARCHAR(20) NULL,
    [State] VARCHAR(200) NULL,
    [GSTNO] VARCHAR(100) NULL,
    [Address] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_GSTNoMaster07Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_GSTNoMaster07Mar2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Entity_code] VARCHAR(20) NULL,
    [State] VARCHAR(200) NULL,
    [GSTNO] VARCHAR(100) NULL,
    [Address] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemMaster]
(
    [Srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ItemType] VARCHAR(50) NULL,
    [Item] VARCHAR(100) NULL,
    [SubItem] VARCHAR(500) NULL,
    [A/C Code] VARCHAR(10) NULL,
    [A/C Description] VARCHAR(200) NULL,
    [ProductType] VARCHAR(20) NULL,
    [Unit] VARCHAR(10) NULL,
    [Chapter_Section_Heading] VARCHAR(50) NULL,
    [Description_Service] VARCHAR(1000) NULL,
    [CGST Rate] FLOAT NULL,
    [SGST_UTGST Rate] FLOAT NULL,
    [IGST Rate] FLOAT NULL,
    [Compensation_Cess_condition] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemMaster_19Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemMaster_19Mar2019]
(
    [Srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ItemType] VARCHAR(50) NULL,
    [Item] VARCHAR(100) NULL,
    [SubItem] VARCHAR(500) NULL,
    [A/C Code] VARCHAR(10) NULL,
    [A/C Description] VARCHAR(200) NULL,
    [ProductType] VARCHAR(20) NULL,
    [Unit] VARCHAR(10) NULL,
    [Chapter_Section_Heading] VARCHAR(50) NULL,
    [Description_Service] VARCHAR(1000) NULL,
    [CGST Rate] FLOAT NULL,
    [SGST_UTGST Rate] FLOAT NULL,
    [IGST Rate] FLOAT NULL,
    [Compensation_Cess_condition] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemMaster_22Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemMaster_22Mar2019]
(
    [Srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ItemType] VARCHAR(50) NULL,
    [Item] VARCHAR(100) NULL,
    [SubItem] VARCHAR(500) NULL,
    [A/C Code] VARCHAR(10) NULL,
    [A/C Description] VARCHAR(200) NULL,
    [ProductType] VARCHAR(20) NULL,
    [Unit] VARCHAR(10) NULL,
    [Chapter_Section_Heading] VARCHAR(50) NULL,
    [Description_Service] VARCHAR(1000) NULL,
    [CGST Rate] FLOAT NULL,
    [SGST_UTGST Rate] FLOAT NULL,
    [IGST Rate] FLOAT NULL,
    [Compensation_Cess_condition] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemMaster24Jan2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemMaster24Jan2019]
(
    [Srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ItemType] VARCHAR(50) NULL,
    [Item] VARCHAR(100) NULL,
    [SubItem] VARCHAR(500) NULL,
    [A/C Code] VARCHAR(10) NULL,
    [A/C Description] VARCHAR(200) NULL,
    [ProductType] VARCHAR(20) NULL,
    [Unit] VARCHAR(10) NULL,
    [Chapter_Section_Heading] VARCHAR(50) NULL,
    [Description_Service] VARCHAR(1000) NULL,
    [CGST Rate] FLOAT NULL,
    [SGST_UTGST Rate] FLOAT NULL,
    [IGST Rate] FLOAT NULL,
    [Compensation_Cess_condition] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemMaster31dec2018
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemMaster31dec2018]
(
    [Srno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ItemType] VARCHAR(50) NULL,
    [Item] VARCHAR(100) NULL,
    [SubItem] VARCHAR(100) NULL,
    [A/C Code] VARCHAR(10) NULL,
    [A/C Description] VARCHAR(100) NULL,
    [ProductType] VARCHAR(20) NULL,
    [ItmCost] MONEY NULL,
    [Unit] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL DEFAULT (getdate()),
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(15) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(500) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(15) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL,
    [Project] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_19Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_19Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_20Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_20Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_22Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_22Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_25Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_25Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_26Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_26Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_27Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_27Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_28Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_28Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_28Mar2019_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_28Mar2019_2]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest_29Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest_29Mar2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest01Feb2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest01Feb2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(100) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest01Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest01Mar2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest05Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest05Mar2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest06Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest06Mar2019_Renamed_By_DBA]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(1000) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(200) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL,
    [GstState] VARCHAR(100) NULL,
    [GstNo] VARCHAR(100) NULL,
    [ItmQty2] VARCHAR(10) NULL,
    [EstCosts2] MONEY NULL,
    [BatchName] VARCHAR(20) NULL,
    [CSOUser] VARCHAR(20) NULL,
    [Rate2] VARCHAR(10) NULL,
    [RoundoffAmt] VARCHAR(15) NULL,
    [Warranty] VARCHAR(100) NULL,
    [BillTo_Name] VARCHAR(200) NULL,
    [ShipTo_Name] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest17jan2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest17jan2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(100) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [GST] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(100) NULL,
    [ITAssetNo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_ItemRequest18jan2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_ItemRequest18jan2019]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [PrNo] VARCHAR(50) NULL,
    [ItOption] VARCHAR(20) NULL,
    [Company] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [Department] VARCHAR(20) NULL,
    [SubDepartment] VARCHAR(20) NULL,
    [LOB] VARCHAR(10) NULL,
    [Channel] VARCHAR(10) NULL,
    [ItemName] VARCHAR(100) NULL,
    [SubItemName] VARCHAR(100) NULL,
    [ItmQty] VARCHAR(10) NULL,
    [EstCosts] MONEY NULL,
    [Remark] VARCHAR(600) NULL,
    [RequestedBy] VARCHAR(10) NULL,
    [RequestedDate] DATETIME NULL,
    [Status] VARCHAR(10) NULL,
    [ApprovedBY] VARCHAR(20) NULL,
    [ApprovedDate] DATETIME NULL,
    [BillTO] VARCHAR(200) NULL,
    [ShipTO] VARCHAR(200) NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorSite] VARCHAR(50) NULL,
    [ApprovedByRemark] VARCHAR(100) NULL,
    [IGST%] VARCHAR(5) NULL,
    [Total] MONEY NULL,
    [PODate] DATETIME NULL,
    [PONo] VARCHAR(50) NULL,
    [GRNSDate] DATETIME NULL,
    [VendorNumber] VARCHAR(10) NULL,
    [DeliveryDate] DATETIME NULL,
    [Quotation1_Path] VARCHAR(300) NULL,
    [Quotation2_Path] VARCHAR(300) NULL,
    [Quotation3_Path] VARCHAR(300) NULL,
    [Rate] VARCHAR(10) NULL,
    [POApprovedBy] VARCHAR(10) NULL,
    [POApprovedDate] DATETIME NULL,
    [Vendor_Bill_NUM] VARCHAR(50) NULL,
    [Vendor_Bill_Date] DATETIME NULL,
    [A/C Code] VARCHAR(10) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [HOE] VARCHAR(10) NULL,
    [HOE_Date] DATETIME NULL,
    [CFO] VARCHAR(10) NULL,
    [CFO_Date] DATETIME NULL,
    [CEO] VARCHAR(10) NULL,
    [CEO_Date] DATETIME NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [CXO] VARCHAR(10) NULL,
    [CXO_Date] DATETIME NULL,
    [FC] VARCHAR(10) NULL,
    [FC_Date] DATETIME NULL,
    [Update_Invoice] VARCHAR(50) NULL,
    [Update_Invoice_date] DATETIME NULL,
    [Units] VARCHAR(20) NULL,
    [PaymentTerms] VARCHAR(100) NULL,
    [ITAssetNo] VARCHAR(50) NULL,
    [POfile_path] VARCHAR(500) NULL,
    [SGST%] NUMERIC(5, 2) NULL,
    [CGST%] NUMERIC(5, 2) NULL,
    [CGST_Amount] MONEY NULL,
    [SGST_Amount] MONEY NULL,
    [IGST_Amount] MONEY NULL,
    [PI_Path] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IOP2P_Paymentdetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IOP2P_Paymentdetails]
(
    [VENDOR_NAME] VARCHAR(300) NULL,
    [VENDOR_SITE_CODE] VARCHAR(20) NULL,
    [CHECK_NUMBER] VARCHAR(40) NULL,
    [CHECK_ACCOUNTING_DATE] DATETIME NULL,
    [CHECK_AMOUNT] VARCHAR(40) NULL,
    [INVOICE_NUM] VARCHAR(50) NULL,
    [ORG_INV_NUM] VARCHAR(50) NULL,
    [INVOICE_AMOUNT_PAID] VARCHAR(40) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [INVOICE_ACCOUNTING_DATE] DATETIME NULL,
    [CHECK_STATUS] VARCHAR(25) NULL,
    [CHECK_VOID_DATE] DATETIME NULL,
    [PREPAY_INV_NUM] VARCHAR(50) NULL,
    [PREPAY_ACCOUNTING_DATE] DATETIME NULL,
    [PREPAY_INV_AMT] VARCHAR(40) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_itemmaster_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_itemmaster_2019]
(
    [ItemType] VARCHAR(50) NULL,
    [Item] VARCHAR(50) NULL,
    [SubItem] VARCHAR(500) NULL,
    [A C Code] VARCHAR(50) NULL,
    [A C Description] VARCHAR(500) NULL,
    [ProductType] VARCHAR(50) NULL,
    [Units] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_01Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_01Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_01Apr2019_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_01Apr2019_2]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_01Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_01Nov2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_03jul2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_03jul2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_03May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_03May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_03May2019_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_03May2019_2]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_03Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_03Oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_04dec2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_04dec2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_04May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_04May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_04May2019_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_04May2019_2]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_04Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_04Nov2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_05Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_05Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_05oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_05oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_05sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_05sep2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_06Jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_06Jun2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_07jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_07jun2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_07Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_07Nov2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_08Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_08Aug2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_08May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_08May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_09Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_09Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_09May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_09May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_staging_09oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_staging_09oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_10Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_10Oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_11jul2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_11jul2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_12Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_12Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_13Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_13Aug2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_14Jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_14Jun2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_14Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_14Oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_18Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_18Oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_18sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_18sep2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_20Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_20Aug2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_20Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_20Mar2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_21Aug2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_21Aug2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_21Nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_21Nov2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_22Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_22Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_22jul2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_22jul2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_23May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_23May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_24May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_24May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_24Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_24Oct2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_24Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_24Sep2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_25Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_25Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_25jul2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_25jul2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_25nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_25nov2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_26Apr2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_26Apr2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_26Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_26Sep2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_28jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_28jun2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_28May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_28May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_29May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_29May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_29nov2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_29nov2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_30Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_30Mar2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_30may2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_30may2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_30Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_30Sep2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging_31May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging_31May2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging05jan2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging05jan2019]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NVARCHAR(384) NULL,
    [DIST_AMOUNT] NVARCHAR(384) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Staging26feb2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Staging26feb2019_Renamed_By_DBA]
(
    [INVOICE_NUM] VARCHAR(50) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [VENDOR_NUM] VARCHAR(30) NULL,
    [VENDOR_SITE_CODE] VARCHAR(15) NULL,
    [INVOICE_AMOUNT] NVARCHAR(384) NULL,
    [INVOICE_CURRENCY_CODE] VARCHAR(15) NULL,
    [TERMS_NAME] VARCHAR(50) NULL,
    [DESCRIPTION] VARCHAR(240) NULL,
    [STATUS] VARCHAR(25) NULL,
    [SOURCE] VARCHAR(80) NULL,
    [DOC_CATEGORY_CODE] VARCHAR(30) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] VARCHAR(25) NULL,
    [GL_DATE] DATETIME NULL,
    [ORG_ID] NUMERIC(15, 0) NULL,
    [LINE_NUMBER] NUMERIC(15, 0) NULL,
    [LINE_TYPE_LOOKUP_CODE] VARCHAR(25) NULL,
    [LINE_AMOUNT] NVARCHAR(384) NULL,
    [LINE_DESCRIPTION] VARCHAR(240) NULL,
    [DIST_LINE_NUMBER] NUMERIC(8, 0) NULL,
    [DIST_AMOUNT] NUMERIC(8, 0) NULL,
    [DIST_CODE_CONCATENATED] VARCHAR(500) NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [DIST_DESCRIPTION] VARCHAR(240) NULL,
    [PAY_GROUP_LOOKUP_CODE] VARCHAR(50) NULL,
    [SEGMENT_1] VARCHAR(25) NULL,
    [SEGMENT_2] VARCHAR(25) NULL,
    [SEGMENT_3] VARCHAR(25) NULL,
    [SEGMENT_4] VARCHAR(25) NULL,
    [SEGMENT_5] VARCHAR(25) NULL,
    [SEGMENT_6] VARCHAR(25) NULL,
    [SEGMENT_7] VARCHAR(25) NULL,
    [SEGMENT_8] VARCHAR(25) NULL,
    [SEGMENT_9] VARCHAR(25) NULL,
    [SEGMENT_10] VARCHAR(25) NULL,
    [SEGMENT_11] VARCHAR(25) NULL,
    [ASSETS_TRACKING_FLAG] VARCHAR(1) NULL,
    [ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [ATTRIBUTE1] VARCHAR(150) NULL,
    [ATTRIBUTE2] VARCHAR(150) NULL,
    [ATTRIBUTE3] VARCHAR(150) NULL,
    [ATTRIBUTE4] VARCHAR(150) NULL,
    [ATTRIBUTE5] VARCHAR(50) NULL,
    [ATTRIBUTE6] DATETIME NULL,
    [ATTRIBUTE7] DATETIME NULL,
    [ATTRIBUTE8] VARCHAR(50) NULL,
    [ATTRIBUTE9] VARCHAR(50) NULL,
    [ATTRIBUTE10] VARCHAR(50) NULL,
    [ATTRIBUTE11] VARCHAR(50) NULL,
    [ATTRIBUTE12] VARCHAR(50) NULL,
    [ATTRIBUTE13] VARCHAR(50) NULL,
    [ATTRIBUTE14] VARCHAR(50) NULL,
    [ATTRIBUTE15] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE_CATEGORY] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE1] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE2] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE3] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE4] VARCHAR(50) NULL,
    [DIST_ATTRIBUTE5] VARCHAR(50) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE1] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE2] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE3] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE4] VARCHAR(50) NULL,
    [GLOBAL_ATTRIBUTE5] VARCHAR(50) NULL,
    [PREPAY_NUM] NVARCHAR(384) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(384) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(384) NULL,
    [PREPAY_GL_DATE] DATETIME NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] VARCHAR(1) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(384) NULL,
    [CREATED_BY] NVARCHAR(384) NULL,
    [CREATION_DATE] DATETIME NULL,
    [PROCESSED_STATUS] VARCHAR(10) NULL,
    [ERROR_MESSAGE] VARCHAR(3000) NULL,
    [INVOICE_STATUS] VARCHAR(20) NULL,
    [BATCH_NAME] VARCHAR(50) NULL,
    [GST_CATEGORY] VARCHAR(150) NULL,
    [HSN_CODE] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_IOPTP
-- --------------------------------------------------

CREATE view [dbo].[Vw_IOPTP]                                            
as                   
      
select INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE='STANDARD',Vendor_Bill_Date,VendorNumber,c.Vendor_Site_Code,Total as INVOICE_AMOUNT,INVOICE_CURRENCY_CODE='INR',      
TERMS_NAME='Immediate',Remark as DESCRIPTION,STATUS='Never Validated',SOURCE='ANG-IOPOI01',DOC_CATEGORY_CODE='IO STD INV',PAYMENT_METHOD_LOOKUP_CODE='IO-DEFAULT',GL_DATE=GETDATE(),      
c.ORG_ID,LINE_NUMBER=1,LINE_TYPE_LOOKUP_CODE='ITEM',EstCosts,Remark,DIST_LINE_NUMBER='',DIST_AMOUNT='',      
      
DIST_CODE_CONCATENATED =+Company+'-'+A.[A/C Code]+'-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (99999 as varchar(10))+'-'+ cast (99999 as varchar(10))+'-'+cast (9999 as varchar(10))+'-'+cast (999 as varchar(10))
,   
    
    
     
      
ACCOUNTING_DATE=GETDATE(),DIST_DESCRIPTION='',PAY_GROUP_LOOKUP_CODE='',      
SEGMENT_1='',SEGMENT_2='',SEGMENT_3='',SEGMENT_4='',SEGMENT_5='',SEGMENT_6='',SEGMENT_7='',SEGMENT_8='',SEGMENT_9='',SEGMENT_10='',SEGMENT_11='',      
      
--(case when ASSETS_TRACKING_FLAG='Capital' then 'Y' else 'N' end) as ASSETS_TRACKING_FLAG,      
 ASSETS_TRACKING_FLAG = CAse when ItOption='CAPITAL' then 'Y'  else    'N'  end ,      
      
ATTRIBUTE_CATEGORY='Inward-Outward',      
ATTRIBUTE1='',ATTRIBUTE2=b.BRANCHTAG,ATTRIBUTE3=b.BRANCHTAG,ATTRIBUTE4=b.BRANCHTAG,ATTRIBUTE5=Vendor_Bill_NUM,ATTRIBUTE6=FromDate,ATTRIBUTE7=ToDate,      
ATTRIBUTE8=RequestedBy,ATTRIBUTE9=HOE,ATTRIBUTE10=INVOICE_NUM,ATTRIBUTE11='',ATTRIBUTE12='',ATTRIBUTE13=PONo,ATTRIBUTE14='',ATTRIBUTE15='',      
DIST_ATTRIBUTE_CATEGORY='', DIST_ATTRIBUTE1='', DIST_ATTRIBUTE2='',DIST_ATTRIBUTE3='', DIST_ATTRIBUTE4='',      
DIST_ATTRIBUTE5='', DIST_GLOBAL_ATT_CATEGORY='',GLOBAL_ATTRIBUTE1='',GLOBAL_ATTRIBUTE2='',GLOBAL_ATTRIBUTE3='', GLOBAL_ATTRIBUTE4='',      
GLOBAL_ATTRIBUTE5='',PREPAY_NUM='', PREPAY_DIST_NUM='', PREPAY_APPLY_AMOUNT='', PREPAY_GL_DATE='', INVOICE_INCLUDES_PREPAY_FLAG='',      
PREPAY_LINE_NUM='', CREATED_BY='', CREATION_DATE='',PROCESSED_STATUS='',ERROR_MESSAGE='',INVOICE_STATUS='', BatchName,GST_CATEGORY='',HSN_CODE=''      
from tbl_IOP2P_ItemRequest a inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b      
on a.ShipTO=b.BRANCH_CODE    
inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c    
on a.VendorSite=c.Vendor_Site_ID    
--inner join tbl_IOP2P_ItemMaster d  
--on a.SubItemName = d.SubItem  
where a.Status='8'  and BatchName='E003352019020201'

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_IOPTP05jan2019
-- --------------------------------------------------

CREATE view [dbo].Vw_IOPTP05jan2019                                        
as               
  
select INVOICE_NUM,INVOICE_TYPE_LOOKUP_CODE='STANDARD',Vendor_Bill_Date,VendorNumber,c.Vendor_Site_Code,EstCosts as INVOICE_AMOUNT,INVOICE_CURRENCY_CODE='INR',  
TERMS_NAME='Immediate',Remark as DESCRIPTION,STATUS='Never Validated',SOURCE='ANG-IOPOI01',DOC_CATEGORY_CODE='IO STD INV',PAYMENT_METHOD_LOOKUP_CODE='IO-DEFAULT',GL_DATE=GETDATE(),  
ORG_ID='83',LINE_NUMBER='1',LINE_TYPE_LOOKUP_CODE='ITEM',EstCosts,Remark,DIST_LINE_NUMBER='',DIST_AMOUNT='',  
  
DIST_CODE_CONCATENATED =+Company+'-'+[A/C Code]+'-'+ShipTO+'-'+SubDepartment+'-'+LOB+'-'+cast (999 as varchar(10))+'-'+Channel+'-'+ cast (99999 as varchar(10))+'-'+ cast (99999 as varchar(10))+'-'+cast (9999 as varchar(10))+'-'+cast (999 as varchar(10)), 

 
  
ACCOUNTING_DATE=GETDATE(),DIST_DESCRIPTION='',PAY_GROUP_LOOKUP_CODE='',  
SEGMENT_1='',SEGMENT_2='',SEGMENT_3='',SEGMENT_4='',SEGMENT_5='',SEGMENT_6='',SEGMENT_7='',SEGMENT_8='',SEGMENT_9='',SEGMENT_10='',SEGMENT_11='',  
  
--(case when ASSETS_TRACKING_FLAG='Capital' then 'Y' else 'N' end) as ASSETS_TRACKING_FLAG,  
 ASSETS_TRACKING_FLAG = CAse when ItOption='CAPITAL' then 'Y'  else    'N'  end ,  
  
ATTRIBUTE_CATEGORY='Inward-Outward',  
ATTRIBUTE1='',ATTRIBUTE2=b.BRANCHTAG,ATTRIBUTE3=b.BRANCHTAG,ATTRIBUTE4=b.BRANCHTAG,ATTRIBUTE5=Vendor_Bill_NUM,ATTRIBUTE6=FromDate,ATTRIBUTE7=ToDate,  
ATTRIBUTE8=RequestedBy,ATTRIBUTE9=HOE,ATTRIBUTE10=INVOICE_NUM,ATTRIBUTE11='',ATTRIBUTE12='',ATTRIBUTE13='',ATTRIBUTE14='',ATTRIBUTE15='',  
DIST_ATTRIBUTE_CATEGORY='', DIST_ATTRIBUTE1='', DIST_ATTRIBUTE2='',DIST_ATTRIBUTE3='', DIST_ATTRIBUTE4='',  
DIST_ATTRIBUTE5='', DIST_GLOBAL_ATT_CATEGORY='',GLOBAL_ATTRIBUTE1='',GLOBAL_ATTRIBUTE2='',GLOBAL_ATTRIBUTE3='', GLOBAL_ATTRIBUTE4='',  
GLOBAL_ATTRIBUTE5='',PREPAY_NUM='', PREPAY_DIST_NUM='', PREPAY_APPLY_AMOUNT='', PREPAY_GL_DATE='', INVOICE_INCLUDES_PREPAY_FLAG='',  
PREPAY_LINE_NUM='', CREATED_BY='', CREATION_DATE='',PROCESSED_STATUS='',ERROR_MESSAGE='',INVOICE_STATUS='', BATCH_NAME='',GST_CATEGORY='',HSN_CODE=''  
from tbl_IOP2P_ItemRequest a inner join [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE b  
on a.ShipTO=b.BRANCH_CODE
inner join [196.1.115.199].oraclefin.dbo.xxc_vendor_master_detail c
on a.VendorSite=c.Vendor_Site_ID
where a.Status='8'

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_UserRoles
-- --------------------------------------------------
CREATE View Vw_UserRoles  
As  
  
select a.emp_no,a.Emp_name,a.email,a.Senior,a.Sr_name,a.CategoryDesc,a.Department,a.Sub_Department,a.designation,a.CostCode,a.SeparationDate,a.Branch_cd,a.AttendanceLoc,a.SBU,a.company,
b.Branch_Type,b.HOE,b.HOE_Name,b.CXO,b.CXO_Name,b.CFO,b.CFO_Name,b.CEO,b.CEO_Name,b.FC,b.FC_Name,b.Access
from risk.dbo.emp_info a inner join tbl_HODEmp_list b
on a.emp_no=b.Emp_no
where SeparationDate is null --and Department='Administration'

GO

