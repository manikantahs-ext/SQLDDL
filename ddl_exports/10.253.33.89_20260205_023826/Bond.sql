-- DDL Export
-- Server: 10.253.33.89
-- Database: Bond
-- Exported: 2026-02-05T02:38:29.995711

USE Bond;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.BondMaster_log
-- --------------------------------------------------
ALTER TABLE [dbo].[BondMaster_log] ADD CONSTRAINT [FK__BondMaster__Srno__25869641] FOREIGN KEY ([Srno]) REFERENCES [dbo].[BondMaster] ([Srno])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.OrderEntry
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderEntry] ADD CONSTRAINT [FK__OrderEntr__BondS__2B3F6F97] FOREIGN KEY ([BondSrno]) REFERENCES [dbo].[BondMaster] ([Srno])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.OrderEntry_log
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderEntry_log] ADD CONSTRAINT [FK__OrderEntr__BondS__2E1BDC42] FOREIGN KEY ([BondSrno]) REFERENCES [dbo].[BondMaster] ([Srno])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.OrderEntry_log
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderEntry_log] ADD CONSTRAINT [FK__OrderEntry__Srno__2D27B809] FOREIGN KEY ([Srno]) REFERENCES [dbo].[OrderEntry] ([Srno])

GO

-- --------------------------------------------------
-- FUNCTION dbo.AddZeroPrefox
-- --------------------------------------------------
CREATE function [dbo].[AddZeroPrefox](@ivalue int,@cnt int)          
RETURNs varchar(10)  
As          
Begin          
declare @value varchar(10)   
set @value = convert(varchar(10),@ivalue)  
  
While @cnt > len(@value)  
Begin   
 set @value='0'+@value  
End  
Return @value   
         
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.OnlineFundPayout
-- --------------------------------------------------
CREATE function [dbo].[OnlineFundPayout](@clientcode varchar(30))        
RETURNS money
AS
BEGIN

Declare @amounttransferred money,@date datetime
set @amounttransferred=0

/*
Declare @clientcode varchar(30)
set @clientcode='H32300'
*/

select @date=MAX(rms_date) from [196.1.115.182].general.dbo.RMS_DtclFi_summ_ABL with (nolock)          
  
/*Fund Payout Blocking*/  
select @amounttransferred=sum(bal) from 
(
 select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end)  from anand.ACCOUNT_AB.dbo.ledger with (nolock)                                           
 where vtyp =3 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                       
 --and Enteredby='TPR' 
 and cdt>=@date 
 and drcr='D'  
  group by cltcode                                           
  union              
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from anand1.ACCOUNT.dbo.ledger with (nolock)                                           
 where vtyp =3 and EDT = convert(datetime,convert(varchar,getdate(),103),103) and cltcode=@clientcode                                      
 --and Enteredby='TPR'  
 and cdt>=@date              
 and drcr='D'  
 group by cltcode                                           
  union                                  
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from ANGELFO.ACCOUNTFO.dbo.ledger with (nolock)                                           
 where vtyp =3 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                       
 --and Enteredby='TPR'   
 and cdt>=@date                                      
 and drcr='D'  
 group by cltcode                                           
 union                                          
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from ANGELCOMMODITY.accountmcdxcds.dbo.ledger with (nolock)                                           
 where vtyp =3 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                       
 --and Enteredby='TPR' 
 and cdt>= @date                                      
 and drcr='D'  
  group by cltcode                                           
  union                                          
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from Angelfo.accountcurfo.dbo.ledger with (nolock)                                           
 where vtyp =3 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                       
 --and Enteredby='TPR'     
 and cdt>= @date                                 
 and drcr='D'  
  group by cltcode  )x    
  
  return @amounttransferred
  
  END

GO

-- --------------------------------------------------
-- FUNCTION dbo.OnlineFundTransfer
-- --------------------------------------------------
  
  
CREATE function [dbo].[OnlineFundTransfer](@clientcode varchar(30))          
RETURNS money  
AS  
BEGIN  
  
Declare @amounttransferred money,@date datetime  
set @amounttransferred=0  
  
/*  
Declare @clientcode varchar(30)  
set @clientcode='H32300'  
*/  
  
select @date=MAX(rms_date) from [196.1.115.182].general.dbo.RMS_DtclFi_summ_ABL with (nolock)            
    
/*ONline Fund Transfer*/    
select @amounttransferred=sum(bal) from   
(  
 select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end)  from anand.ACCOUNT_AB.dbo.ledger with (nolock)                                             
 where vtyp =2 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                         
 --and Enteredby='TPR' 
 and cdt>=@date   
 and drcr='C'    
  group by cltcode                                             
  union                
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from anand1.ACCOUNT.dbo.ledger with (nolock)                                             
 where vtyp =2 and EDT = convert(datetime,convert(varchar,getdate(),103),103) and cltcode=@clientcode                                        
 --and Enteredby='TPR'  
 and cdt>=@date                
 and drcr='C'    
 group by cltcode                                             
  union                                    
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from ANGELFO.ACCOUNTFO.dbo.ledger with (nolock)                                             
 where vtyp =2 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                         
 --and Enteredby='TPR'  
 and cdt>=@date                                        
 and drcr='C'    
 group by cltcode                                             
 union                                            
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from ANGELCOMMODITY.accountmcdxcds.dbo.ledger with (nolock)                                             
 where vtyp =2 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                         
 --and Enteredby='TPR' 
 and cdt>= @date                                        
 and drcr='C'    
  group by cltcode                                             
  union                                            
  select cltcode,bal= sum(case when drcr='C' then vamt else -vamt end) from Angelfo.accountcurfo.dbo.ledger with (nolock)                                             
 where vtyp =2 and EDT = convert(datetime,convert(varchar,getdate(),103),103)  and cltcode=@clientcode                                         
 --and Enteredby='TPR'    
  and cdt>= @date                                   
 and drcr='C'    
  group by cltcode  )x      
    
  return @amounttransferred  
    
  END

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BondMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[BondMaster] ADD CONSTRAINT [PK__BondMast__C3A7DF8422AA2996] PRIMARY KEY ([Srno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.OrderEntry
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderEntry] ADD CONSTRAINT [PK__OrderEnt__C3A7DF8429572725] PRIMARY KEY ([Srno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_Bond_FILEUPLOADMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_Bond_FILEUPLOADMASTER] ADD CONSTRAINT [PK__TBL_Bond__3214EC2705D8E0BE] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_Bond_FILEUPLOADMASTER_NewFileFormate
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_Bond_FILEUPLOADMASTER_NewFileFormate] ADD CONSTRAINT [PK__TBL_Bond__3214EC276C618282] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BondMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BondMaster] ADD CONSTRAINT [PK__tbl_Bond__C3A7DF845441852A] PRIMARY KEY ([Srno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BondMaster_13072022
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BondMaster_13072022] ADD CONSTRAINT [PK__tbl_Bond__C3A7DF8482CCB2F9] PRIMARY KEY ([Srno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BondMaster_NewFileFormate
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BondMaster_NewFileFormate] ADD CONSTRAINT [PK__tbl_Bond__C3A7DF842F186FCC] PRIMARY KEY ([Srno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BONDOrderEntry_NewFileFormate_RENAMEDAS_PII
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BONDOrderEntry_NewFileFormate_RENAMEDAS_PII] ADD CONSTRAINT [PK__tbl_BOND__F57BD2F71C7A9416] PRIMARY KEY ([EntryId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BONDOrderEntry_RENAMEDAS_PII
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BONDOrderEntry_RENAMEDAS_PII] ADD CONSTRAINT [PK__tbl_BOND__F57BD2F75DCAEF64] PRIMARY KEY ([EntryId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IPO_Exceptionlog
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IPO_Exceptionlog] ADD CONSTRAINT [PK__tbl_IPO___3214EC072EDAF651] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Allotment
-- --------------------------------------------------

CREATE procedure [dbo].[Bond_Allotment]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    


select a.EntryId,a.Client_Code,a.Order_Status,a.Order_Qty,a.RATE,a.Total,b.netpayable,case when a.Total>b.netpayable then a.Total-b.netpayable
                                                                                 when b.netpayable>a.Total then b.netpayable-a.Total end
 as totalAmt into #qq from
( select * from #bondallotment) a
inner join 
 (select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock)   group by party_code)b 
  on a.client_code=b.party_code
  

--select * from #qq where totalAmt<=1.00 and total>0

update a  set netpayable=ceiling(a.netpayable) from  #bondallotment a,
(select * from #qq where totalAmt<1.00 and total>0) b 
where a.Client_Code=b.Client_Code and a.EntryId=b.EntryId  
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
 
 declare @enddate datetime
 SELECT @enddate=Enddate  FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121) and Rate<>0.00
 
 if(cONVERT(VARCHAR(11),@enddate,121)<=cONVERT(VARCHAR(11),GETDATE(),121))
 begin
	if(CONVERT(VARCHAR(5),GETDATE(),108)>='16:01') 
	begin
		 insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
		 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
		 (     
		select c.mobile_pager as No, a.Client_code                             
		 ,'Dear Client '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' We regret to inform you that your order for Sovereign Gold Bond Series '        
		 +ltrim(rtrim( RIGHT(BOND_Name, (CHARINDEX(' ',REVERSE(BOND_Name),0)))))+' has been rejected due to insufficient balance in your Angel Broking account. Regards - Angel One' as sms_msg ,         
		 convert(varchar(10), getdate(), 103) as sms_dt                  
		 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
		 ,'P' as flag                               
		 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
		 ,'Bond_Rejected'   as Purpose         
		 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c  with(nolock)                             
		 on a.Client_code=c.party_code 
		  ) x  
		  
		    update a      
			set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
			Verfiedon=GETDATE()      
			from tbl_bondorderentry a,      
			(select * from #bondallotment where netpayable<total) b      
			where a.client_code=b.client_code and a.entryid=b.entryid      
	end
 end
 else
 begin    
	 insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
	 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
	 (     
	select c.mobile_pager as No, a.Client_code                             
	 ,'Dear Client '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' your order for Sovereign Gold Bond Series '        
	 +ltrim(rtrim( RIGHT(BOND_Name, (CHARINDEX(' ',REVERSE(BOND_Name),0)))))+' is pending due to insufficient ledger balance.'   
	 +' Please add funds to your Angel Broking account immediately to avoid cancellation of your order. To add funds click here:
	https://trade.angelbroking.com/trade/trading/fundsview Kindly ignore if already done.' as sms_msg ,         
	 convert(varchar(10), getdate(), 103) as sms_dt                  
	 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
	 ,'P' as flag                               
	 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
	 ,'Bond_Rejected'   as Purpose         
	 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c  with(nolock)                             
	 on a.Client_code=c.party_code 
	  ) x  
 end  
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select distinct party_code,fromsegment=segment,y.total,y.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Bond_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    

--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
 
/**************Added on 28 May 2021*****************************************/
	select distinct party_code into #ee from #bondallotment_segmentwise 
  group by party_code having COUNT(distinct EntryId)>1
  
   select * into #as from #bondallotment_segmentwise where party_code in (select party_code from #ee) order by party_code
    
    insert into Bond_Notallow
   select *,GETDATE() from #as   where total>netpayable
   
   /****************************************/
    select Party_code,MAX(fromsegment) fromsegment,MAX(total) total,SUM(netpayable)netpayable,MAX(Order_Qty)Order_Qty,EntryId into #qw from #as   group  by EntryId,Party_code
   Select * into #q from #qw where total>netpayable 
   
     insert into Bond_NotAllowed
     select *,GETDATE() from #qw   where total>netpayable
   /*****************************************/
    --select * into #q from #as   where total>netpayable 
    
    update tbl_bondorderentry set order_status='PENDING',Verfiedon=NULL from #q b where  tbl_bondorderentry.client_code=b.Party_code 
    and tbl_bondorderentry.entryid=b.EntryId
    
    update #bondallotment_segmentwise set  Adjustamt=0   from #q b where  #bondallotment_segmentwise.Party_code=b.Party_code and #bondallotment_segmentwise.entryid=b.EntryId

/*******************************************************/     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table Bond_Jv    
    
insert into Bond_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/
  
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Allotment_10Sep2020
-- --------------------------------------------------

create procedure [dbo].[Bond_Allotment_10Sep2020]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select party_code,fromsegment=segment,y.total,x.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Bond_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    
     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table Bond_Jv    
    
insert into Bond_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/
  
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Allotment_12Sep2022
-- --------------------------------------------------


CREATE procedure [dbo].[Bond_Allotment_12Sep2022]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    


select a.EntryId,a.Client_Code,a.Order_Status,a.Order_Qty,a.RATE,a.Total,b.netpayable,case when a.Total>b.netpayable then a.Total-b.netpayable
                                                                                 when b.netpayable>a.Total then b.netpayable-a.Total end
 as totalAmt into #qq from
( select * from #bondallotment) a
inner join 
 (select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock)   group by party_code)b 
  on a.client_code=b.party_code
  

--select * from #qq where totalAmt<=1.00 and total>0

update a  set netpayable=ceiling(a.netpayable) from  #bondallotment a,
(select * from #qq where totalAmt<1.00 and total>0) b 
where a.Client_Code=b.Client_Code and a.EntryId=b.EntryId  
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
 
 declare @enddate datetime
 SELECT @enddate=Enddate  FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121) and Rate<>0.00
 
 if(cONVERT(VARCHAR(11),@enddate,121)<=cONVERT(VARCHAR(11),GETDATE(),121))
 begin
	if(CONVERT(VARCHAR(5),GETDATE(),108)>='16:01') 
	begin
		 insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
		 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
		 (     
		select c.mobile_pager as No, a.Client_code                             
		 ,'Dear Client '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' We regret to inform you that your order for Sovereign Gold Bond Series '        
		 +ltrim(rtrim( RIGHT(BOND_Name, (CHARINDEX(' ',REVERSE(BOND_Name),0)))))+' has been rejected due to insufficient balance in your Angel Broking account.' as sms_msg ,         
		 convert(varchar(10), getdate(), 103) as sms_dt                  
		 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
		 ,'P' as flag                               
		 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
		 ,'Bond_Rejected'   as Purpose         
		 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c  with(nolock)                             
		 on a.Client_code=c.party_code 
		  ) x  
		  
		    update a      
			set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
			Verfiedon=GETDATE()      
			from tbl_bondorderentry a,      
			(select * from #bondallotment where netpayable<total) b      
			where a.client_code=b.client_code and a.entryid=b.entryid      
	end
 end
 else
 begin    
	 insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
	 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
	 (     
	select c.mobile_pager as No, a.Client_code                             
	 ,'Dear Client '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' your order for Sovereign Gold Bond Series '        
	 +ltrim(rtrim( RIGHT(BOND_Name, (CHARINDEX(' ',REVERSE(BOND_Name),0)))))+' is pending due to insufficient ledger balance.'   
	 +' Please add funds to your Angel Broking account immediately to avoid cancellation of your order. To add funds click here:
	https://trade.angelbroking.com/trade/trading/fundsview Kindly ignore if already done.' as sms_msg ,         
	 convert(varchar(10), getdate(), 103) as sms_dt                  
	 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
	 ,'P' as flag                               
	 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
	 ,'Bond_Rejected'   as Purpose         
	 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c  with(nolock)                             
	 on a.Client_code=c.party_code 
	  ) x  
 end  
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select party_code,fromsegment=segment,y.total,x.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Bond_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    

--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
 
/**************Added on 28 May 2021*****************************************/
	select distinct party_code into #ee from #bondallotment_segmentwise 
  group by party_code having COUNT(distinct EntryId)>1
  
   select * into #as from #bondallotment_segmentwise where party_code in (select party_code from #ee) order by party_code
    
    insert into Bond_Notallow
   select *,GETDATE() from #as   where total>netpayable
   
   /****************************************/
    select Party_code,MAX(fromsegment) fromsegment,MAX(total) total,SUM(netpayable)netpayable,MAX(Order_Qty)Order_Qty,EntryId into #qw from #as   group  by EntryId,Party_code
   Select * into #q from #qw where total>netpayable 
   
     insert into Bond_NotAllowed
     select *,GETDATE() from #qw   where total>netpayable
   /*****************************************/
    --select * into #q from #as   where total>netpayable 
    
    update tbl_bondorderentry set order_status='PENDING',Verfiedon=NULL from #q b where  tbl_bondorderentry.client_code=b.Party_code 
    and tbl_bondorderentry.entryid=b.EntryId
    
    update #bondallotment_segmentwise set  Adjustamt=0   from #q b where  #bondallotment_segmentwise.Party_code=b.Party_code and #bondallotment_segmentwise.entryid=b.EntryId

/*******************************************************/     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table Bond_Jv    
    
insert into Bond_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/
  
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Allotment_16Jul2021
-- --------------------------------------------------


CREATE procedure [dbo].[Bond_Allotment_16Jul2021]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    


select a.EntryId,a.Client_Code,a.Order_Status,a.Order_Qty,a.RATE,a.Total,b.netpayable,case when a.Total>b.netpayable then a.Total-b.netpayable
                                                                                 when b.netpayable>a.Total then b.netpayable-a.Total end
 as totalAmt into #qq from
( select * from #bondallotment) a
inner join 
 (select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock)   group by party_code)b 
  on a.client_code=b.party_code
  

--select * from #qq where totalAmt<=1.00 and total>0

update a  set netpayable=ceiling(a.netpayable) from  #bondallotment a,
(select * from #qq where totalAmt<1.00 and total>0) b 
where a.Client_Code=b.Client_Code and a.EntryId=b.EntryId  
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
 insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (     
select c.mobile_pager as No, a.Client_code                             
 ,'Dear Client '+ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' your order for Sovereign Gold Bond Series '        
 +ltrim(rtrim( RIGHT(BOND_Name, (CHARINDEX(' ',REVERSE(BOND_Name),0)))))+' is pending due to insufficient ledger balance.'   
 +' Please add funds to your Angel Broking account immediately to avoid cancellation of your order. To add funds click here:
https://trade.angelbroking.com/trade/trading/fundsview Kindly ignore if already done.' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c  with(nolock)                             
 on a.Client_code=c.party_code 
  ) x  
     
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select party_code,fromsegment=segment,y.total,x.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Bond_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    

--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
 
/**************Added on 28 May 2021*****************************************/
	select distinct party_code into #ee from #bondallotment_segmentwise 
  group by party_code having COUNT(distinct EntryId)>1
  
   select * into #as from #bondallotment_segmentwise where party_code in (select party_code from #ee) order by party_code
    
    insert into Bond_Notallow
   select *,GETDATE() from #as   where total>netpayable
   
   /****************************************/
    select Party_code,MAX(fromsegment) fromsegment,MAX(total) total,SUM(netpayable)netpayable,MAX(Order_Qty)Order_Qty,EntryId into #qw from #as   group  by EntryId,Party_code
   Select * into #q from #qw where total>netpayable 
   
     insert into Bond_NotAllowed
     select *,GETDATE() from #qw   where total>netpayable
   /*****************************************/
    --select * into #q from #as   where total>netpayable 
    
    update tbl_bondorderentry set order_status='PENDING',Verfiedon=NULL from #q b where  tbl_bondorderentry.client_code=b.Party_code 
    and tbl_bondorderentry.entryid=b.EntryId
    
    update #bondallotment_segmentwise set  Adjustamt=0   from #q b where  #bondallotment_segmentwise.Party_code=b.Party_code and #bondallotment_segmentwise.entryid=b.EntryId

/*******************************************************/     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table Bond_Jv    
    
insert into Bond_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/
  
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Allotment_28Jun2021
-- --------------------------------------------------


CREATE procedure [dbo].[Bond_Allotment_28Jun2021]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    


select a.EntryId,a.Client_Code,a.Order_Status,a.Order_Qty,a.RATE,a.Total,b.netpayable,case when a.Total>b.netpayable then a.Total-b.netpayable
                                                                                 when b.netpayable>a.Total then b.netpayable-a.Total end
 as totalAmt into #qq from
( select * from #bondallotment) a
inner join 
 (select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock)   group by party_code)b 
  on a.client_code=b.party_code
  

--select * from #qq where totalAmt<=1.00 and total>0

update a  set netpayable=ceiling(a.netpayable) from  #bondallotment a,
(select * from #qq where totalAmt<1.00 and total>0) b 
where a.Client_Code=b.Client_Code and a.EntryId=b.EntryId  
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select party_code,fromsegment=segment,y.total,x.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Bond_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    

--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
 
/**************Added on 28 May 2021*****************************************/
	select distinct party_code into #ee from #bondallotment_segmentwise 
  group by party_code having COUNT(distinct EntryId)>1
  
   select * into #as from #bondallotment_segmentwise where party_code in (select party_code from #ee) order by party_code
    
    insert into Bond_Notallow
   select *,GETDATE() from #as   where total>netpayable
   
   /****************************************/
    select Party_code,MAX(fromsegment) fromsegment,MAX(total) total,SUM(netpayable)netpayable,MAX(Order_Qty)Order_Qty,EntryId into #qw from #as   group  by EntryId,Party_code
   Select * into #q from #qw where total>netpayable 
   
     insert into Bond_NotAllowed
     select *,GETDATE() from #qw   where total>netpayable
   /*****************************************/
    --select * into #q from #as   where total>netpayable 
    
    update tbl_bondorderentry set order_status='PENDING',Verfiedon=NULL from #q b where  tbl_bondorderentry.client_code=b.Party_code 
    and tbl_bondorderentry.entryid=b.EntryId
    
    update #bondallotment_segmentwise set  Adjustamt=0   from #q b where  #bondallotment_segmentwise.Party_code=b.Party_code and #bondallotment_segmentwise.entryid=b.EntryId

/*******************************************************/     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table Bond_Jv    
    
insert into Bond_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/
  
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Allotment_28May2021
-- --------------------------------------------------

create procedure [dbo].[Bond_Allotment_28May2021]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    


select a.EntryId,a.Client_Code,a.Order_Status,a.Order_Qty,a.RATE,a.Total,b.netpayable,case when a.Total>b.netpayable then a.Total-b.netpayable
                                                                                 when b.netpayable>a.Total then b.netpayable-a.Total end
 as totalAmt into #qq from
( select * from #bondallotment) a
inner join 
 (select party_code,netpayable=SUM(netpayable) from Bond_SegVeriData with (nolock)   group by party_code)b 
  on a.client_code=b.party_code
  

--select * from #qq where totalAmt<=1.00 and total>0

update a  set netpayable=ceiling(a.netpayable) from  #bondallotment a,
(select * from #qq where totalAmt<1.00 and total>0) b 
where a.Client_Code=b.Client_Code and a.EntryId=b.EntryId  
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select party_code,fromsegment=segment,y.total,x.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Bond_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    
     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table Bond_Jv    
    
insert into Bond_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/
  
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Batch_Exe
-- --------------------------------------------------
  
CREATE procedure [dbo].[Bond_Batch_Exe]                       
as                          
                          
set nocount on                          
                          
DECLARE @XACT_ABORT VARCHAR(3) = 'OFF',@XactChg varchar(3) ='No';                          
IF ( (16384 & @@OPTIONS) = 16384 ) SET @XACT_ABORT = 'ON';                          
if @XACT_ABORT='OFF'                          
Begin                          
 SET XACT_ABORT ON                          
 set @XactChg='Yes'                          
End                          
                          
select ROW_NUMBER() OVER ( ORDER BY srno ) AS [Ctr],              
Srno,ProcedureName,Active_Status,StartDate,EndDate,Flag,spdesc,Errflag,section              
into #File1 from Bond_Batch_process where active_Status=1 and flag=0                  
              
declare @totctr as int = 0,@ctr as int = 1, @str as varchar(2000),@srno as int,@spname as varchar(200)                          
              
select @totctr=MAX(Ctr) from #file1                          
While @ctr <= @totctr                          
Begin                          
 set @str = ''                          
 select @srno=srno,@str='exec '+procedurename,@spname=procedurename from #File1 where ctr=@ctr                          
 Begin Try                          
  update Bond_Batch_process set StartDate=GETDATE(),errflag='' where srno=@srno                          
   exec(@str)                 
                   
     /*        
     WAITFOR DELAY '00:00:02';          
     print @str                      
     */              
        
  if @srno < (select MAX(srno) from Bond_Batch_process)   
  update Bond_Batch_process set EndDate=GETDATE(),Flag=1 where srno=@srno      
  else    
  update Bond_Batch_process set EndDate=GETDATE() where srno=@srno          
        
 End Try                          
 Begin Catch                          
                
  insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)       
 select GETDATE(),'Bond_Batch_initialise',ERROR_LINE(),ERROR_MESSAGE()                       
                  
  update Bond_Batch_process set errflag='<font color="red">Error</font>' where Srno=@srno                    
                                        
  DECLARE @ErrorMessage NVARCHAR(4000);                                      
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                      
  RAISERROR (@ErrorMessage , 16, 1);                             
                          
  RETURN                          
                            
 End Catch                          
 set @ctr=@ctr+1                          
End                          
                          
if @XactChg='Yes'                          
Begin                          
 SET XACT_ABORT OFF                          
end                          
                          
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Batch_initialise
-- --------------------------------------------------
  
CREATE procedure [dbo].[Bond_Batch_initialise]        
as        
  
Set nocount on                          
SET XACT_ABORT ON                             
BEGIN TRY                                  
  
 insert into Bond_Batch_process_log(Srno,ProcedureName,Active_Status,StartDate,EndDate,Flag,UpdatedOn)         
 select Srno,ProcedureName,Active_Status,StartDate,EndDate,Flag,getdate() from Bond_Batch_process         
     
 update Bond_Batch_process set flag=0    
     
End try                               
BEGIN CATCH                                  
                              
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)       
 select GETDATE(),'Bond_Batch_initialise',ERROR_LINE(),ERROR_MESSAGE()                                        
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                    
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                    
 RAISERROR (@ErrorMessage , 16, 1);       
       
End catch                     
                          
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_BOapiPush
-- --------------------------------------------------
CREATE proc [dbo].[Bond_BOapiPush]                        
as                        
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY                           
                        
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)                       
                        
 ----insert into anand.MKTAPI.dbo.tbl_post_data                       
 --(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                        
 --CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                          
 select                                       
 8 as VOUCHERTYPE,                        
 ROW_NUMBER() OVER ( ORDER BY party_Code) AS [SNo],                        
 JVdate as VDATE,                        
 JVdate as EDATE,                        
 party_Code as CLTCODE,                        
 0 as CREDITAMT,                        
 JVAmount as DEBITAMT,                        
 /*'Amount Subscribed for Sovereign Gold Bond' as NARRATION,                        */
  'Appln amt debited twds '+Convert(varchar(20),OrderQty)+' Bonds @ Rs.'+Convert(varchar(20),d.Rate)+' - Per Gram - '+Symbol+' – Clt '+party_Code+'' as NARRATION,                        
 '' as BANKCODE,                        
 '' as MARGINCODE,                        
 '' as BANKNAME,                        
 '' as BRANCHNAME,                        
 'HO' as BRANCHCODE,                        
 '' as DDNO,            
 /*VerifierId as DDNO, */  
 /* convert(varchar(10),VerifierID)+convert(varchar(10),RequestID) as DDNO, */            
 '' as CHEQUEMODE,                        
 '' as CHEQUEDATE,                        
 '' as CHEQUENAME,                        
 '' as CLEAR_MODE,                        
 '' as TPACCOUNTNUMBER,                        
 EXCHANGE=case  
when tosegment='BSECM' then 'BSE'  
when tosegment='NSECM' then 'NSE'  
when tosegment='NSEFO' then 'NSE'  
when tosegment='MCD' then 'MCD'  
when tosegment='NSX' then 'NSX'  
when tosegment='BSX' then 'BSX'  
else tosegment end  
,     
 SEGMENT= case  
 when tosegment in ('BSECM','NSECM') then 'CAPITAL' else 'FUTURES' end ,                        
 1 as MKCK_FLAG,                        
 a.Entryid as Return_fld4,                        
 'Bond' as Return_fld5,                        
 0 as Rowstate,          
 'bonddebit' as Return_fld2    INTO #TEMP                 
 from                         
 (select * from Bond_Jv where BO_Posted='N' and JVAmount > 0) a                
 join risk.dbo.Vw_RMS_Client_Vertical c                        
 on a.Party_Code=c.client 
  join #tbl_BondMaster d on a.BOND_SrNo=d.srno
                        

SELECT * FROM (
  SELECT * FROM #TEMP
  UNION ALL
  SELECT VOUCHERTYPE,SNo,VDATE,EDATE,'99885' CLTCODE,
  DEBITAMT CREDTAMT,'0' DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,
  DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
  MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2
 FROM #TEMP )A
 ORDER BY SNO
 
  
 
   
  insert into AngelBSECM.MKTAPI.dbo.tbl_post_data                       
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                        
 CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                          
SELECT * FROM (
  SELECT * FROM #TEMP
  UNION ALL
  SELECT VOUCHERTYPE,SNo,VDATE,EDATE,'99885' CLTCODE,
  DEBITAMT CREDTAMT,'0' DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,
  DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
  MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2
 FROM #TEMP )A
 ORDER BY SNO   
   
   
  update Bond_Jv set BO_Posted='Y',BO_RowState=Rowstate from                        
 (                        
  select DDNO,Rowstate,RETURN_FLD4,cltcode,debitAmt,return_fld2   from AngelBSECM.MKTAPI.dbo.tbl_post_data with (nolock)  
  where Return_fld5='Bond' and Vdate>=GETDATE()-3                        
  and Return_fld2='bonddebit'  
 ) b where   
  Bond_Jv.party_code=b.cltcode        
 and Bond_Jv.JVAmount=b.debitAmt         
 and Bond_Jv.Entryid=b.Return_fld4                       
 and Bond_Jv.BO_Posted='N'  
   
   
insert into Bond_Jv_log       
select * from  Bond_Jv     
  
update a set Order_Status='Verified',Verfiedon=getdate() from tbl_bondorderentry a,  
(select party_code,entryid from Bond_Jv where BO_posted='Y' group by party_code,entryid)b  
 where   
 a.client_code=b.party_code and a.entryid=b.entryid and   
 a.Order_Status='Pending' and a.Verfiedon is null   
  
  
                        
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_BOapiPush',ERROR_LINE(),ERROR_MESSAGE()                                                             
                                  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                                                
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_BOapiPush_18Jul2016
-- --------------------------------------------------
CREATE proc [dbo].[Bond_BOapiPush_18Jul2016]                        
as                        
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY                           
                        
                         
 insert into anand.MKTAPI.dbo.tbl_post_data                       
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                        
 CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                          
 select                                       
 8 as VOUCHERTYPE,                        
 ROW_NUMBER() OVER ( ORDER BY party_Code) AS [SNo],                        
 convert(varchar(11),JVdate) as VDATE,                        
 convert(varchar(11),JVdate) as EDATE,                        
 party_Code as CLTCODE,                        
 0 as CREDITAMT,                        
 JVAmount as DEBITAMT,                        
 'Amount Adjusted for Bond' as NARRATION,                        
 '' as BANKCODE,                        
 '' as MARGINCODE,                        
 '' as BANKNAME,                        
 '' as BRANCHNAME,                        
 'HO' as BRANCHCODE,                        
 '' as DDNO,            
 /*VerifierId as DDNO, */  
 /* convert(varchar(10),VerifierID)+convert(varchar(10),RequestID) as DDNO, */            
 '' as CHEQUEMODE,                        
 convert(varchar(11),JVdate) as CHEQUEDATE,                        
 party_name as CHEQUENAME,                        
 '' as CLEAR_MODE,                        
 '' as TPACCOUNTNUMBER,                        
 EXCHANGE=case  
when tosegment='BSECM' then 'BSE'  
when tosegment='NSECM' then 'NSE'  
when tosegment='NSEFO' then 'NSE'  
when tosegment='MCD' then 'MCD'  
when tosegment='NSX' then 'NSX'  
when tosegment='BSX' then 'BSX'  
else tosegment end  
,     
 SEGMENT= case  
 when tosegment in ('BSECM','NSECM') then 'CAPITAL' else 'FUTURES' end ,                        
 1 as MKCK_FLAG,                        
 Entryid as Return_fld4,                        
 'Bond' as Return_fld5,                        
 0 as Rowstate,          
 'bonddebit' as Return_fld2                         
 from                         
 (select * from Bond_Jv where BO_Posted='N' and JVAmount > 0) a                
 join risk.dbo.Vw_RMS_Client_Vertical c                        
 on a.Party_Code=c.client                        
                         
  
   
  insert into anand.MKTAPI.dbo.tbl_post_data                       
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                        
 CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                          
 select                                       
 8 as VOUCHERTYPE,                        
 ROW_NUMBER() OVER ( ORDER BY party_Code) AS [SNo],                        
 convert(varchar(11),JVdate) as VDATE,                        
 convert(varchar(11),JVdate) as EDATE,                        
 '99793' as CLTCODE,                        
 JVAmount as CREDITAMT,                        
 0 as DEBITAMT,                        
 'Amount Adjusted for Bond' as NARRATION,                        
 '' as BANKCODE,                        
 '' as MARGINCODE,                        
 '' as BANKNAME,                        
 '' as BRANCHNAME,                        
 'HO' as BRANCHCODE,                        
 '' as DDNO,            
 /*VerifierId as DDNO, */  
 /* convert(varchar(10),VerifierID)+convert(varchar(10),RequestID) as DDNO, */            
 '' as CHEQUEMODE,                        
 convert(varchar(11),JVdate) as CHEQUEDATE,                        
 party_name as CHEQUENAME,                        
 '' as CLEAR_MODE,            
 '' as TPACCOUNTNUMBER,                        
 EXCHANGE=case  
when fromsegment='BSECM' then 'BSE'  
when fromsegment='NSECM' then 'NSE'  
when fromsegment='NSEFO' then 'NSE'  
when fromsegment='MCD' then 'MCD'  
when fromsegment='NSX' then 'NSX'  
when fromsegment='BSX' then 'BSX'  
else fromsegment end  
,     
 SEGMENT= case  
 when fromsegment in ('BSECM','NSECM') then 'CAPITAL' else 'FUTURES' end ,                        
 1 as MKCK_FLAG,                        
 Entryid as Return_fld4,                        
 'Bond' as Return_fld5,                        
 0 as Rowstate,          
 'bondcredit' as Return_fld2                         
 from                         
 (select * from Bond_Jv where BO_Posted='N' and JVAmount > 0) a                
 join risk.dbo.Vw_RMS_Client_Vertical c                        
 on a.Party_Code=c.client    
   
   
  update Bond_Jv set BO_Posted='Y',BO_RowState=Rowstate from                        
 (                        
  select DDNO,Rowstate,RETURN_FLD4,cltcode,debitAmt,return_fld2   from anand.MKTAPI.dbo.tbl_post_data with (nolock)  
  where Return_fld5='Bond' and Vdate>=GETDATE()-3                        
  and Return_fld2='bonddebit'  
 ) b where   
  Bond_Jv.party_code=b.cltcode        
 and Bond_Jv.JVAmount=b.debitAmt         
 and Bond_Jv.Entryid=b.Return_fld4                       
 and Bond_Jv.BO_Posted='N'  
   
   
insert into Bond_Jv_log       
select * from  Bond_Jv     
  
update a set Order_Status='Verified',Verfiedon=getdate() from tbl_bondorderentry a,  
(select party_code,entryid from Bond_Jv where BO_posted='Y' group by party_code,entryid)b  
 where   
 a.client_code=b.party_code and a.entryid=b.entryid and   
 a.Order_Status='Pending' and a.Verfiedon is null   
  
  
                        
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Bond_BOapiPush',ERROR_LINE(),ERROR_MESSAGE()                                                             
                                  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                                                
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_BSEFileGeneration
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_BSEFileGeneration]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
 SELECT @emailto='harshal.shesh@angelbroking.com;vikas.ranjan@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   select @emailcc='nimesh.sanghvi@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'          
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\BSE\BSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='BSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
  
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon  is not null  
 
  SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
                
TRUNCATE  TABLE Bond_OrderFile_BSE                
     
 /*select ScripId=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end  ,*/
 select ScripId=b.Symbol,
 a.ApplicationNo as ApplicationNumber,'CTZ' as Category,c.short_name as ApplicantName,  
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as Depository,
  DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '0' end,  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
 a.Order_Qty as Qty,1 as cutoffFlag,a.Rate,'N' as ChequeReceivedFlag,a.Total as ChequeAmount,'' as ChequeNumber,a.PAN as pannumber,  
 '' as Bankname,'' as location,  
 '' as AccountNumber,0 as BidId,  
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 join risk.dbo.client_details c on a.client_code=c.cl_code  
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='BSE'    
         
 INSERT INTO Bond_OrderFile_BSE            
 SELECT ScripId,ApplicationNumber,Category,ApplicantName,Depository,DPid,BeneficiaryId,Qty,cutoffFlag,Rate,ChequeReceivedFlag,ChequeAmount,ChequeNumber,pannumber,Bankname,location,AccountNumber,BidId,ActivityType  
 from #file    
          
            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_BSE " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
 declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon and a.ExportedOn is null and Segment='BSE'  
   
  insert into TBL_Bond_FILEUPLOADMASTER  
 select 'BSE Order Export',@BondSrno,'BSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''      
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached BSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: BSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',               
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile_BSE)b   
  where   
  /*a.dp=b.dpid and */
  a.applicationno=b.ApplicationNumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='BSE'  
        
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_OrderCsv',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_BSEFileGeneration_19072016
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_BSEFileGeneration_19072016]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
     SELECT @emailto='darshan.dalal@angelbroking.com;munira.memon@angelbroking.com'   
   select @emailcc='nimesh.sanghvi@angelbroking.com;renil.pillai@angelbroking.com;bhavin@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'     
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.183\d$\Bond\BSE\BSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='BSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
  
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon  is not null  
                
 TRUNCATE  TABLE Bond_OrderFile_BSE                
     
 select b.Symbol as ScripId,a.ApplicationNo as ApplicationNumber,'CTZ' as Category,c.short_name as ApplicantName,  
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as Depository,substring (a.DP,0,9) as DPid,  
BeneficiaryId=substring (a.DP,9,16),  
 a.Order_Qty as Qty,1 as cutoffFlag,a.Rate,'N' as ChequeReceivedFlag,a.Total as ChequeAmount,'' as ChequeNumber,a.PAN as pannumber,  
 '' as Bankname,'' as location,  
 '' as AccountNumber,0 as BidId,  
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a join tbl_BondMaster b on a.Bond_Srno=b.Srno    
 join risk.dbo.client_details c on a.client_code=c.cl_code  
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='BSE'    
         
 INSERT INTO Bond_OrderFile_BSE            
 SELECT ScripId,ApplicationNumber,Category,ApplicantName,Depository,DPid,BeneficiaryId,Qty,cutoffFlag,Rate,ChequeReceivedFlag,ChequeAmount,ChequeNumber,pannumber,Bankname,location,AccountNumber,BidId,ActivityType  
 from #file    
          
            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_BSE " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
 declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon and a.ExportedOn is null and Segment='BSE'  
   
  insert into TBL_Bond_FILEUPLOADMASTER  
 select 'BSE Order Export',@BondSrno,'BSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''      
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: BSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',               
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile)b   
  where   
  /*a.dp=b.dpid and */
  a.applicationno=b.refno and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='BSE'        
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_OrderCsv',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_CheckShortProcess
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_CheckShortProcess]  
as  
Set nocount on             
SET XACT_ABORT ON                       
BEGIN TRY                            
 
  exec ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_BondPRO_CLI     
  exec ANGELDEMAT.INHOUSE.DBO.Rpt_Delpayinmatch_BondPRO_CLI     
 
End try                         
                        
BEGIN CATCH                            
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                  
 select GETDATE(),'Bond_CheckShortProcess',ERROR_LINE(),ERROR_MESSAGE()                                  
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                  
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                  
 RAISERROR (@ErrorMessage , 16, 1);        
End catch                        
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration
-- --------------------------------------------------
/*
	CHANGE ID  :: 1                          
    MODIFIED BY  :: Satyajeet Mall                              
    MODIFIED DATE :: Jul 13 2022                              
    REASON   :: For New NSE File format in SGB

*/
---EXEC Bond_NSEFileGeneration_NewFileFormate
CREATE procedure [dbo].[Bond_NSEFileGeneration]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
   SELECT @emailto='harshal.shesh@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   select @emailcc='vikas.ranjan@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
      
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon is not null
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
             
 TRUNCATE  TABLE Bond_OrderFile_NewFileFormate               
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,
 --Changes Done By Satyajeet--
  a.ApplicationNo as ApplicationNumber,
 'CTZ' as Category,
 '' as ClientName,
 --Till Here--
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
 -- Series='GB',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as BidQuantity,
1 as cutoffIndicator,---Changes Done by Satyajeet--
a.Rate,
'N' as ChequeReceivedFlag,a.Total as ChequeAmount,'' as ChequeNumber,---Changes Done By Satyajeet--
a.Pan as PanNumber,
'' as BankName,'' as LocationCode,--Changes Done By Satyajeet--
'' as RefNo,    
0 as OrderNo,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    -- when live uncomment 
 into #file    
  from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='NSE' 
 

 INSERT INTO Bond_OrderFile_NewFileFormate           
 SELECT  Symbol,ApplicationNumber,Category,ClientName
 ,DepositoryName,DPid,BeneficiaryId,BidQuantity,cutoffIndicator,Rate,
 ChequeReceivedFlag,ChequeAmount,ChequeNumber,PanNumber,BankName,
 LocationCode,RefNo,OrderNo,ActivityType from #file  

            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_NewFileFormate " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'   
    
 insert into TBL_Bond_FILEUPLOADMASTER  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile_NewFileFormate)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='NSE'    
       
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration_13072022
-- --------------------------------------------------
---EXEC Bond_NSEFileGeneration_13072022
CREATE procedure [dbo].[Bond_NSEFileGeneration_13072022]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)
		Select @emailto='satyajeet.1mall@angelbroking.com'
		Select @emailcc='satyam.1dubey@angelbroking.com'
   --SELECT @emailto='harshal.shesh@angelbroking.com;vikas.ranjan@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   --select @emailcc='nimesh.sanghvi@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
   

 
 
  Declare @verifiedon date  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry_13072022 with (nolock) where Verfiedon is not null
 print @verifiedon
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster_13072022 WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
                
 TRUNCATE  TABLE Bond_OrderFile_13072022               
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,
 --Changes Done By Satyajeet--
  a.ApplicationNo as ApplicationNumber,
 'CTZ' as Category,
 '' as ClientName,
 --Till Here--
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
 -- Series='GB',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as BidQuantity,
1 as cutoffIndicator,---Changes Done by Satyajeet--
a.Rate,
'N' as ChequeReceivedFlag,a.Total as ChequeAmount,'' as ChequeNumber,---Changes Done By Satyajeet--
a.Pan as PanNumber,
'' as BankName,'' as LocationCode,--Changes Done By Satyajeet--
'' as RefNo,    
0 as OrderNo,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry_13072022 a inner  join #tbl_BondMaster b on a.Bond_Srno=b.Srno  
  --join risk.dbo.client_details c on a.client_code=c.cl_code  --changes Done By Satyajeet--
 where 
 --a.Order_status='Verified' 
  a.Verfiedon =@verifiedon  
-- and a.ExportedOn is null 
 and a.Segment='NSE' 
 

 INSERT INTO Bond_OrderFile_13072022           
 SELECT  Symbol,ApplicationNumber,Category,ClientName
 ,DepositoryName,DPid,BeneficiaryId,BidQuantity,cutoffIndicator,Rate,
 ChequeReceivedFlag,ChequeAmount,ChequeNumber,PanNumber,BankName,
 LocationCode,RefNo,OrderNo,ActivityType from #file  

            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_13072022 " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'   
    
 insert into TBL_Bond_FILEUPLOADMASTER  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile_13072022)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='NSE'    
      
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration_14Jul2022
-- --------------------------------------------------

CREATE procedure [dbo].[Bond_NSEFileGeneration_14Jul2022]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
   SELECT @emailto='harshal.shesh@angelbroking.com;vikas.ranjan@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   select @emailcc='nimesh.sanghvi@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
   
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon is not null
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
                
 TRUNCATE  TABLE Bond_OrderFile                
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,  
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
  Series='GB',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as BidQuantity,a.Rate,a.Pan as PanNumber,'' as RefNo,    
0 as OrderNo,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='NSE'     
         
            
 INSERT INTO Bond_OrderFile            
 SELECT  Symbol,Series,DepositoryName,DPid,BeneficiaryId,BidQuantity,Rate,Pannumber,RefNo,OrderNo,ActivityType from #file    
 
            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'   
    
 insert into TBL_Bond_FILEUPLOADMASTER  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='NSE'    
      
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration_19072016
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_NSEFileGeneration_19072016]           
as              
BEGIN              
 SET NOCOUNT ON   
BEGIN TRY  
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                          
   SELECT @emailto='darshan.dalal@angelbroking.com;munira.memon@angelbroking.com' 
   select @emailcc='nimesh.sanghvi@angelbroking.com;renil.pillai@angelbroking.com;bhavin@angelbroking.com'
   select @emailbcc='neha.naiwar@angelbroking.com'  
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                  
                       
 select @filename1='\\196.1.115.183\d$\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                      
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'
 
 Declare @verifiedon datetime
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon  is not null
              
 TRUNCATE  TABLE Bond_OrderFile              
   
 select b.Symbol,b.Series,
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,
substring (a.DP,0,9) as DPid,
BeneficiaryId=substring (a.DP,9,16),
a.Order_Qty as BidQuantity,a.Rate,a.Pan as PanNumber,a.ApplicationNo as RefNo,  
0 as OrderNo,  
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType  
 into #file  
 from tbl_BONDOrderEntry a join tbl_BondMaster b on a.Bond_Srno=b.Srno  
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon
 and a.ExportedOn is null and Segment='NSE'   
       
          
 INSERT INTO Bond_OrderFile          
 SELECT  Symbol,Series,DepositoryName,DPid,BeneficiaryId,BidQuantity,Rate,Pannumber,RefNo,OrderNo,ActivityType from #file  
            
          
  DECLARE @PATH VARCHAR(250)          
  DECLARE @BCPCOMMAND VARCHAR(250)          
  DECLARE @FILENAME VARCHAR(250)         
         
  --SET @PATH ='d:\upload1\Bond\'          
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'          
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile " QUERYOUT "'          
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'           
        
  --PRINT @BCPCOMMAND           
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND             
 -- SELECT @FILENAME AS FilePath    

declare @BondSrno as int

 select @BondSrno=a.Bond_Srno 
 from tbl_BONDOrderEntry a join tbl_BondMaster b on a.Bond_Srno=b.Srno  
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE' 
  
 insert into TBL_Bond_FILEUPLOADMASTER
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''   
                                 
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                  
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                              
set @sub ='BOND: NSE'                 
                  
                    
 DECLARE @s varchar(500)                  
 SET @s = @filename1           
                    
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS =@emailto,                              
 @COPY_RECIPIENTS = @emailcc,                              
 @blind_copy_recipients=@emailbcc,                    
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',                              
 @SUBJECT = @sub ,                              
 @FILE_ATTACHMENTS =@s,                              
 @BODY =@MESS                      
    
  update a set Order_Status='Exported',ExportedOn=getdate() from
  tbl_BONDOrderEntry a,
  (select * from Bond_OrderFile)b 
  where 
  /*a.dp=b.dpid and */
  a.applicationno=b.refno and
  VerfiedOn= @verifiedon 
  and a.ExportedOn is null and a.Segment='NSE'  
    
  drop table #file  
  END TRY                              
BEGIN CATCH                              
                                                                                         
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                          
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                          
                    
  DECLARE @ErrorMessage NVARCHAR(4000);                 
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                      
  RAISERROR (@ErrorMessage , 16, 1);                                                                                    
                              
END CATCH           
 SET NOCOUNT OFF;             
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration_20Dec2022
-- --------------------------------------------------


CREATE procedure [dbo].[Bond_NSEFileGeneration_20Dec2022]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
   SELECT @emailto='harshal.shesh@angelbroking.com;vikas.ranjan@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   select @emailcc='nimesh.sanghvi@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
   
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon is not null
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
                
 TRUNCATE  TABLE Bond_OrderFile                
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,  
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
  Series='GB',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as BidQuantity,a.Rate,a.Pan as PanNumber,'' as RefNo,    
0 as OrderNo,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='NSE'     
         
            
 INSERT INTO Bond_OrderFile            
 SELECT  Symbol,Series,DepositoryName,DPid,BeneficiaryId,BidQuantity,Rate,Pannumber,RefNo,OrderNo,ActivityType from #file    
 
            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'   
    
 insert into TBL_Bond_FILEUPLOADMASTER  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='NSE'    
      
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration_NewFileFormate
-- --------------------------------------------------
/*
	CHANGE ID  :: 1                          
    MODIFIED BY  :: Satyajeet Mall                              
    MODIFIED DATE :: Jul 13 2022                              
    REASON   :: For New NSE File format in SGB

*/
---EXEC Bond_NSEFileGeneration_NewFileFormate
CREATE procedure [dbo].[Bond_NSEFileGeneration_NewFileFormate]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)
		Select @emailto='satyajeet.1mall@angelbroking.com'
		Select @emailcc='satyam.1dubey@angelbroking.com'
   --SELECT @emailto='harshal.shesh@angelbroking.com;vikas.ranjan@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   --select @emailcc='nimesh.sanghvi@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
      
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon is not null
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
             
 TRUNCATE  TABLE Bond_OrderFile_NewFileFormate               
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,
 --Changes Done By Satyajeet--
  a.ApplicationNo as ApplicationNumber,
 'CTZ' as Category,
 '' as ClientName,
 --Till Here--
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
 -- Series='GB',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as BidQuantity,
1 as cutoffIndicator,---Changes Done by Satyajeet--
a.Rate,
'N' as ChequeReceivedFlag,a.Total as ChequeAmount,'' as ChequeNumber,---Changes Done By Satyajeet--
a.Pan as PanNumber,
'' as BankName,'' as LocationCode,--Changes Done By Satyajeet--
'' as RefNo,    
0 as OrderNo,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    -- when live uncomment 
 into #file    
  from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='NSE' 
 

 INSERT INTO Bond_OrderFile_NewFileFormate           
 SELECT  Symbol,ApplicationNumber,Category,ClientName
 ,DepositoryName,DPid,BeneficiaryId,BidQuantity,cutoffIndicator,Rate,
 ChequeReceivedFlag,ChequeAmount,ChequeNumber,PanNumber,BankName,
 LocationCode,RefNo,OrderNo,ActivityType from #file  

            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_NewFileFormate " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry_NewFileFormate a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'   
    
 insert into TBL_Bond_FILEUPLOADMASTER_NewFileFormate  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry_NewFileFormate a,  
  (select * from Bond_OrderFile_NewFileFormate)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='NSE'    
       
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_NSEFileGeneration_NewFileFormate_10Oct2022
-- --------------------------------------------------
/*
	CHANGE ID  :: 1                          
    MODIFIED BY  :: Satyajeet Mall                              
    MODIFIED DATE :: Jul 13 2022                              
    REASON   :: For New NSE File format in SGB

*/
---EXEC Bond_NSEFileGeneration_NewFileFormate
create procedure [dbo].[Bond_NSEFileGeneration_NewFileFormate_10Oct2022]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)
		Select @emailto='neha.naiwar@angelbroking.com;harshal.shesh@angelbroking.com'
		Select @emailcc='neha.naiwar@angelbroking.com'
   --SELECT @emailto='harshal.shesh@angelbroking.com;vikas.ranjan@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;ingrid.thanicatt@angelbroking.com;poonam.maurya@angelbroking.com;sunita.varun@angelbroking.com'   
   --select @emailcc='nimesh.sanghvi@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.147\d\Bond\NSE\NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
   

 
 
  Declare @verifiedon date  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon is not null
 print @verifiedon
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster_NewFileFormate WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
                
 TRUNCATE  TABLE Bond_OrderFile_NewFileFormate               
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,
 --Changes Done By Satyajeet--
  a.ApplicationNo as ApplicationNumber,
 'CTZ' as Category,
 '' as ClientName,
 --Till Here--
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
 -- Series='GB',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as BidQuantity,
1 as cutoffIndicator,---Changes Done by Satyajeet--
a.Rate,
'N' as ChequeReceivedFlag,a.Total as ChequeAmount,'' as ChequeNumber,---Changes Done By Satyajeet--
a.Pan as PanNumber,
'' as BankName,'' as LocationCode,--Changes Done By Satyajeet--
'' as RefNo,    
0 as OrderNo,    
--(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    -- when live uncomment 
'N'as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a inner  join #tbl_BondMaster b on a.Bond_Srno=b.Srno  
  --join risk.dbo.client_details c on a.client_code=c.cl_code  --changes Done By Satyajeet--
 where 
 a.Order_status='Verified' 
 -- a.Verfiedon =@verifiedon  
-- and a.ExportedOn is null 
 and a.Segment='NSE' 
 

 INSERT INTO Bond_OrderFile_NewFileFormate           
 SELECT  Symbol,ApplicationNumber,Category,ClientName
 ,DepositoryName,DPid,BeneficiaryId,BidQuantity,cutoffIndicator,Rate,
 ChequeReceivedFlag,ChequeAmount,ChequeNumber,PanNumber,BankName,
 LocationCode,RefNo,OrderNo,ActivityType from #file  

            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_NewFileFormate " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uinhouse -Pinh6014'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry  a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null   and Segment='NSE'   
    
 insert into TBL_Bond_FILEUPLOADMASTER_NewFileFormate  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='BOND: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from Bond_OrderFile_NewFileFormate)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
 -- VerfiedOn= @verifiedon   
 Order_status='Verified'
     and a.Segment='NSE'    
      --Select * from tbl_BONDOrderEntry_NewFileFormate where Bond_SrNo='58' and Order_Status='Verified'
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'Bond_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_OrderCsv_BSE
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_OrderCsv_BSE]           
as              
BEGIN              
 SET NOCOUNT ON   
BEGIN TRY  
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                          
   SELECT @emailto='neha.naiwar@angelbroking.com'   
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                  
                       
 /*select @filename1='d:\upload1\Bond\BSE\Order_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                      */
 select @filename1='I:\upload1\Bond\BSE\Order_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                      

              
 TRUNCATE  TABLE Bond_OrderFile              
   
 select b.Symbol as ScripId,'' as ApplicationNumber,c.Cl_type as Category,c.Long_name as ApplicantName,'' as Depository,a.DPid,a.BeneficiaryId
 ,a.Qty,0 as cutoffFlag,a.Rate,'N' as ChequeReceivedFlag,'N' as ChequeAmount,'' as ChequeNumber,a.pannumber,'' as Bankname,'' as location,
 '' as AccountNumber,'N' as BidId,(case when a.AppStatus='Pending' then 'N' else '' end) as ActivityType  
 into #file  
 from OrderEntry a join BondMaster b on a.BondSrno=b.Srno
 join risk.dbo.client_details c on a.ClientCode=c.cl_code 
 where a.AppStatus='Pending' and a.VerifiedOn is not null and a.ExportedOn is null and Segment='BSE'  
       
 INSERT INTO Bond_OrderFile_BSE          
 SELECT ScripId,ApplicationNumber,Category,ApplicantName,Depository,DPid,BeneficiaryId,Qty,cutoffFlag,Rate,ChequeReceivedFlag,ChequeAmount,ChequeNumber,pannumber,Bankname,location,AccountNumber,BidId,ActivityType
 from #file  
        
          
  DECLARE @PATH VARCHAR(250)          
  DECLARE @BCPCOMMAND VARCHAR(250)          
  DECLARE @FILENAME VARCHAR(250)         
         
  --SET @PATH ='d:\upload1\Bond\'          
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'          
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile_BSE " QUERYOUT "'          
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'           
        
  --PRINT @BCPCOMMAND           
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND             
 -- SELECT @FILENAME AS FilePath    
    
                                 
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                  
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                              
set @sub ='BOND: NSE'                 
                  
                    
 DECLARE @s varchar(500)                  
 SET @s = @filename1           
                    
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS =@emailto,                              
 @COPY_RECIPIENTS = @emailto,                              
 @blind_copy_recipients=@emailto,                    
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',                              
 @SUBJECT = @sub ,                              
 @FILE_ATTACHMENTS =@s,                              
 @BODY =@MESS                      
    
  update OrderEntry set AppStatus='Export',ExportedOn=getdate() where VerifiedOn is not null and ExportedOn is null and Segment='BSE'  
    
  drop table #file  
  END TRY                              
BEGIN CATCH                              
                                                                                         
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                          
  select GETDATE(),'Bond_OrderCsv',ERROR_LINE(),ERROR_MESSAGE()                                                          
                    
  DECLARE @ErrorMessage NVARCHAR(4000);                 
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                      
  RAISERROR (@ErrorMessage , 16, 1);                                                                                    
                              
END CATCH           
 SET NOCOUNT OFF;             
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_OrderCsv_NSE
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_OrderCsv_NSE]           
as              
BEGIN              
 SET NOCOUNT ON   
BEGIN TRY  
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                          
   SELECT @emailto='neha.naiwar@angelbroking.com'   
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                  
                       
/* select @filename1='d:\upload1\Bond\NSE\Order_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                      */
 select @filename1='I:\upload1\Bond\NSE\Order_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                      

              
 TRUNCATE  TABLE Bond_OrderFile              
   
 select b.Symbol,b.Series,a.DPName as DepositoryName,a.DP as DPid,a.BeneficiaryId,a.Order_Qty as BidQuantity,a.Rate,a.Pan as PanNumber,a.ApplicationNo as RefNo,  
0 as OrderNo,  
(case when a.Order_status='Pending' then 'N' else '' end) as ActivityType  
 into #file  
 from tbl_BONDOrderEntry a join tbl_BondMaster b on a.Bond_Srno=b.Srno  
 where a.Order_status='Pending' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'  
       
          
 INSERT INTO Bond_OrderFile          
 SELECT  Symbol,Series,DepositoryName,DPid,BeneficiaryId,BidQuantity,Rate,Pannumber,RefNo,OrderNo,ActivityType from #file  
        
          
          
  DECLARE @PATH VARCHAR(250)          
  DECLARE @BCPCOMMAND VARCHAR(250)          
  DECLARE @FILENAME VARCHAR(250)         
         
  --SET @PATH ='d:\upload1\Bond\'          
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'          
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.Bond_OrderFile " QUERYOUT "'          
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'           
        
  --PRINT @BCPCOMMAND           
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND             
 -- SELECT @FILENAME AS FilePath    
    
                                 
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                  
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                              
set @sub ='BOND: NSE'                 
                  
                    
 DECLARE @s varchar(500)                  
 SET @s = @filename1           
                    
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                              
 @RECIPIENTS =@emailto,                              
 @COPY_RECIPIENTS = @emailto,                              
 @blind_copy_recipients=@emailto,                    
 @PROFILE_NAME = 'AngelBroking',                              
 @BODY_FORMAT ='HTML',                              
 @SUBJECT = @sub ,                              
 @FILE_ATTACHMENTS =@s,                              
 @BODY =@MESS                      
    
  update OrderEntry set AppStatus='Export',ExportedOn=getdate() where VerifiedOn is not null and ExportedOn is null and Segment='NSE'  
    
  drop table #file  
  END TRY                              
BEGIN CATCH                              
                                                                                         
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                          
  select GETDATE(),'Bond_OrderCsv',ERROR_LINE(),ERROR_MESSAGE()                                                          
                    
  DECLARE @ErrorMessage NVARCHAR(4000);                 
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                      
  RAISERROR (@ErrorMessage , 16, 1);                                                                                    
                              
END CATCH           
 SET NOCOUNT OFF;             
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_Update_status
-- --------------------------------------------------
CREATE procedure [dbo].[Bond_Update_status](@flag as int)                  
as                  
set nocount on                  
BEGIN TRY             
          
 update Bond_Status  set status = @flag   
 
END TRY                                    
BEGIN CATCH                                    
                                    
 insert into risk.dbo.Appln_ERROR (ErrTime,ErrObject,ErrLine,ErrMessage,ApplnName,DBname)                                                            
 select GETDATE(),'Bond_Update_status',ERROR_LINE(),ERROR_MESSAGE(),'Bond',DB_NAME(db_id())                                                            
                          
 DECLARE @ErrorMessage NVARCHAR(4000);                                         
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                          
 RAISERROR (@ErrorMessage , 16, 1);                               
                                    
END CATCH           
                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_VeriData
-- --------------------------------------------------
CREATE procEDURE [dbo].[Bond_VeriData]                                
as                                                      
                                                      
Set nocount on                                         
SET XACT_ABORT ON                                                   
BEGIN TRY                                                        
                              
/*                                                        
  /* EQUITY */                                                      
  Exec anand.inhouse.dbo.NCMS_POdet                                
  Exec anand1.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse_curfo.dbo.NCMS_POdet                                 
  Exec angelcommodity.INHOUSE_MCDCS.dbo.NCMS_POdet                                  
  Exec angelfo.inhouse.dbo.NCMS_POdet_NSEMFSS                                                      
  Exec angelfo.inhouse.dbo.NCMS_POdet_BSEMFSS                                 
                                                        
  /* COMMODITY */                                                      
  Exec angelcommodity.inhouse_NCDX.dbo.NCMS_POdet                                 
  Exec angelcommodity.inhouse_MCDX.dbo.NCMS_POdet                                 
  /* SHORTAGE */                                                      
                                        
  if (Select blkstatus from NCMS_Get_BlockShrtTag with (nolock))='Unblock'                                      
  Begin                                      
 exec ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_CLI                                 
 exec ANGELDEMAT.INHOUSE.DBO.Rpt_Delpayinmatch_CMSPRO_CLI                                 
  End                                      
                              
  exec risk.dbo.Usp_Calc_ShrtVal_cli                                 
 */                              
                                  
  /* NBFC Process */                                                      
  /*                                              
  exec [172.31.16.57].inhouse.dbo.PROC_NBFC_PF_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.PR_NBFC_HOLD_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.NCMS_POdet                                                  
  */                                              
                                                        
  /* FETCH DATA */                                                      
   Create table #Bond_SegwiseCldata (                                                          
   id int,                                              
   ProcessDate datetime,                                              
   Entity varchar(10),                                              
   Segment varchar(10),                                              
   Party_code varchar(10),                                              
   Flag char(1),                                              
   Balance money,                                              
   UnsettledCrBill money,                                              
   UnrecoAmt money,                                              
   ShortSellValue money,                                              
   MarginAmt money,                                              
   Deposit money,                                              
   CashColl money,                                              
   NonCashColl money,                                              
   MarginAdjWithColl money,                                              
   MarginShortage money,                                              
   AccruedCharges money,                                              
   OtherDebit money,                                              
   NonCashConsideration money,                                              
ExpoUtilised money,                                              
   UnPosted_PO money,                   
   NetPayable money                                          
   )                                                                                                             
                                                
                          
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime,'Equity','BSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from AngelBSECM.inhouse.dbo.Bond_PO                                                     
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select ProcessDatetime,'Equity','NSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from AngelNseCM.inhouse.dbo.Bond_PO                                                       
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSEFO',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/ 
  
  /*****BSEFO************/
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','BSEFO',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelcommodity.BSEFO.dbo.Bond_marh with(nolock) 
  /*****************/
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse_curfo.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','MCD',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelcommodity.INHOUSE_MCDCS.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                                      
    
     
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                 
 select UpdDatetime,'Equity','BSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                   
 from angelcommodity.inhouse_bsx.dbo.Bond_marh     
 
                                                  
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                
 select UpdDatetime,'AllSegment','NCDEX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                 
 from angelcommodity.inhouse_NCDX.dbo.Bond_marh  with(nolock)                                               
 /* where PayoutValue <> 0 */        
                                                 
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                
 select UpdDatetime,'AllSegment','MCX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                 
 from angelcommodity.inhouse_MCDX.dbo.Bond_marh with(nolock)                                                
 /* where PayoutValue <> 0 */        
  
   
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                  
 select processDate,'NBFC','NBFC',party_Code,'I',ActualLedger,Unsettled,0,ShortValHC,0,0,0,VAHC,0,0,AccruedInt,ShortVal,0,0,NetAmount                                               
 from [172.31.16.57].inhouse.dbo.ncms_po  
      
    /************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
    /*Changed in order to consider MTM of cases where there is no ledger added by Neha Naiwar on suggestion from Bhavin Parikh dt: 23th June 2016*/         
        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSECM' ) and isnull(client_code,'')<>''    
      
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSECM' ) and isnull(client_code,'')<>''    
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSEFO',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSEFO > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSEFO' ) and isnull(client_code,'')<>''                           
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSX' ) and isnull(client_code,'')<>''                                                       
     
   insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','MCD',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where MCD > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCD' ) and isnull(client_code,'')<>''     
     
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSX' ) and isnull(client_code,'')<>''     
    
       
     insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'AllSegment','NCDEX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a with(nolock) where NCDEX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NCDEX' ) and isnull(client_code,'')<>''     
     
      insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'AllSegment','MCX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a with(nolock) where MCX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCX' ) and isnull(client_code,'')<>''    
     
/************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
   /* Unreco amount*/  
   --Changed in order to handle rejection on Nov 02 2016
   update #Bond_SegwiseCldata set UnrecoAmt=0.00  
   update #Bond_SegwiseCldata set UnsettledCrBill=0.00
     
                                                       
  /* Accrured Charges */                           
                                                
  UPDATE a                                                          
  set AccruedCharges=b.AccruedCharges,NetPayable=NetPayable+b.AccruedCharges                                                               
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                             
  (select party_code,segment,AccruedCharges from cms.dbo.NCMS_SegwiseCldata with (nolock) ) b                                              
  ON a.party_code=b.party_Code and a.segment=b.Segment                
  where a.Segment <> 'NBFC'                                               
                
                      
  /* BSECM & NSECM Zero for NBFC Clients */                                                      
                                  
  /*                                                             
  UPDATE a                                                          
  set NetPayable = 0,ShortSellValue=0,Balance=0                                              
  FROM #NCMS_SegwiseCldata a                           
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                               
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
  */                              
                                
  /*---- Only unreco cheque amount of BSECM and NSECM should get deducted from NBFC Net payable */                              
  UPDATE a                                                          
  set NetPayable =  UnrecoAmt+AccruedCharges                                 
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                        
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
                                                        
  /* Update Shortage Value */      
   update #Bond_SegwiseCldata set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval from                                                      
(select seg+'CM' as seg,party_code,shrtval=SUM(NetShortValue) from cms.dbo.ncms_shortsell                   
group by seg,party_Code having sum(NetShortValue) <> 0) b                        
 where #Bond_SegwiseCldata.segment=b.seg and #Bond_SegwiseCldata.party_code=b.party_Code     
         
/*                              
  UPDATE a          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
 FROM #NCMS_SegwiseCldata a                                               
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_BSECM_ShrtVal group by party_Code having sum(dedVal) <> 0) b                 
  ON a.segment='BSECM' and a.party_code=b.party_Code                                                      
                                         
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                       
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_NSECM_ShrtVal group by party_Code  having sum(dedVal) <> 0) b                                                      
  ON a.segment='NSECM' and a.party_code=b.party_Code                                                      
*/                              
                           
/* Only BOD shortage is considered in verification */                              
/*                  
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                                               
  JOIN                      
  (                              
 select segment,party_code,Shrtval=ShortSellValue from NCMS_SegwiseCldata with (nolock)                              
 where (SEGMENT='BSECM' OR SEGMENT='NSECM') AND ShortSellValue <> 0                              
  ) B                               
  ON a.segment=B.SEGMENT and a.party_code=b.party_Code                                                       
*/                  
                                                     
                    
/* Reduce LD Data */                    
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.BSECM,NetPayable=NetPayable-b.BSECM                    
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='BSECM'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSECM'              
             
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSECM,NetPayable=NetPayable-b.NSECM                    
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSECM'                    
 */            
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSECM'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSEFO,NetPayable=NetPayable-b.NSEFO                    
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSEFO'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSEFO'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.MCD,NetPayable=NetPayable-b.MCD                    
 from(                    
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='MCD'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                  
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCD'              
             
               
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSX,NetPayable=NetPayable-b.NSX                    
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSX'              
 */            
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSX'                     
    
    
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSX from cms.dbo.NCMS_LD_View where BSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSX'     
     
                   
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NCDEX,NetPayable=NetPayable-b.NCDEX                    
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NCDEX'                    
*/                
                
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NCDEX'                    
                    
                    
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,MCX from cms.dbo.NCMS_LD_View where MCX > 0                    
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCX'    
 
 /************************************/
 
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+debitamt,NetPayable=NetPayable+debitamt from                                                      
(select  cltcode,(debitamt*-1) as debitamt from AngelBSECM.account_ab.dbo.v2_offline_ledger_entries with(nolock) where vdate>=convert(varchar(11), GETDATE(),120) and
vouchertype=8 and rowstate=0 and debitamt<>0 ) b                        
 where  #Bond_SegwiseCldata.party_code=b.cltcode     
         
 /************************************/

  /* Insert into History table*/                  
 insert into Bond_SegVeriData_hist(POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,                      
 MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO)                      
 select POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,                      
 AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                      
 from Bond_SegVeriData with (nolock)   
                    
  truncate table Bond_SegVeriData                          
  insert into Bond_SegVeriData                                            
  (                                            
  POrequestID,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,                                            
  MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                          
  )                                              
  select   /*ROW_NUMBER() OVER ( ORDER BY party_code,segment) AS refno,*/                            
  convert(varchar(6),getdate(),112)+replace(convert(varchar(8),getdate(),108),':','') AS refno,                            
  ProcessDate,Entity,Segment,Party_code,flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,                                            
  NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                             
  from #Bond_SegwiseCldata                                               
                                   
                                            
End try                       
                                                
BEGIN CATCH                                                        
   
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)         
 select GETDATE(),'Bond_VeriData',ERROR_LINE(),ERROR_MESSAGE()                                                           
                                
 DECLARE @ErrorMessage NVARCHAR(4000);                                                              
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                              
 RAISERROR (@ErrorMessage , 16, 1);                                    
                                                     
End catch                                                    
                                                      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_VeriData_02Nov2016
-- --------------------------------------------------
create procEDURE [dbo].[Bond_VeriData_02Nov2016]                              
as                                                    
                                                    
Set nocount on                                       
SET XACT_ABORT ON                                                 
BEGIN TRY                                                      
                            
/*                                                      
  /* EQUITY */                                                    
  Exec anand.inhouse.dbo.NCMS_POdet                              
  Exec anand1.inhouse.dbo.NCMS_POdet                              
  Exec angelfo.inhouse.dbo.NCMS_POdet                              
  Exec angelfo.inhouse_curfo.dbo.NCMS_POdet                               
  Exec angelcommodity.INHOUSE_MCDCS.dbo.NCMS_POdet                                
  Exec angelfo.inhouse.dbo.NCMS_POdet_NSEMFSS                                                    
  Exec angelfo.inhouse.dbo.NCMS_POdet_BSEMFSS                               
                                                      
  /* COMMODITY */                                                    
  Exec angelcommodity.inhouse_NCDX.dbo.NCMS_POdet                               
  Exec angelcommodity.inhouse_MCDX.dbo.NCMS_POdet                               
  /* SHORTAGE */                                                    
                                      
  if (Select blkstatus from NCMS_Get_BlockShrtTag with (nolock))='Unblock'                                    
  Begin                                    
 exec ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_CLI                               
 exec ANGELDEMAT.INHOUSE.DBO.Rpt_Delpayinmatch_CMSPRO_CLI                               
  End                                    
                            
  exec risk.dbo.Usp_Calc_ShrtVal_cli                               
 */                            
                                
  /* NBFC Process */                                                    
  /*                                            
  exec [172.31.16.57].inhouse.dbo.PROC_NBFC_PF_DATA                                                    
  exec [172.31.16.57].inhouse.dbo.PR_NBFC_HOLD_DATA                                                    
  exec [172.31.16.57].inhouse.dbo.NCMS_POdet                                                
  */                                            
                                                      
  /* FETCH DATA */                                                    
   Create table #Bond_SegwiseCldata (                                                        
   id int,                                            
   ProcessDate datetime,                                            
   Entity varchar(10),                                            
   Segment varchar(10),                                            
   Party_code varchar(10),                                            
   Flag char(1),                                            
   Balance money,                                            
   UnsettledCrBill money,                                            
   UnrecoAmt money,                                            
   ShortSellValue money,                                            
   MarginAmt money,                                            
   Deposit money,                                            
   CashColl money,                                            
   NonCashColl money,                                            
   MarginAdjWithColl money,                                            
   MarginShortage money,                                            
   AccruedCharges money,                                            
   OtherDebit money,                                            
   NonCashConsideration money,                                            
   ExpoUtilised money,                                            
   UnPosted_PO money,                 
   NetPayable money                                        
   )                                                                                                           
                                              
                        
                                                      
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime,'Equity','BSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+UCV+UnRecoCr+OtherDr                                                     
  from anand.inhouse.dbo.Bond_PO                                                   
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                  
                                                      
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                    
  select ProcessDatetime,'Equity','NSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+UCV+UnRecoCr+OtherDr                                                     
  from anand1.inhouse.dbo.Bond_PO                                                     
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                  
                                                      
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                    
  select UpdDatetime,'Equity','NSEFO',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                     
  from angelfo.inhouse.dbo.Bond_marh                                                     
  /* and PayoutValue <> 0*/                                  
                                                      
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                    
  select UpdDatetime,'Equity','NSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                     
  from angelfo.inhouse_curfo.dbo.Bond_marh                                                     
  /* and PayoutValue <> 0*/                                                  
                                                      
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                    
  select UpdDatetime,'Equity','MCD',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                     
  from angelcommodity.INHOUSE_MCDCS.dbo.Bond_marh                                                     
  /* and PayoutValue <> 0*/                                                    
  
   
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                               
 select UpdDatetime,'Equity','BSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                 
 from angelcommodity.inhouse_bsx.dbo.Bond_marh   
 
 
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                
 select processDate,'NBFC','NBFC',party_Code,'I',ActualLedger,Unsettled,0,ShortValHC,0,0,0,VAHC,0,0,AccruedInt,ShortVal,0,0,NetAmount                                             
 from [172.31.16.57].inhouse.dbo.ncms_po
    
    /************************************************************************************************************************************************/   
/************************************************************************************************************************************************/   
    /*Changed in order to consider MTM of cases where there is no ledger added by Neha Naiwar on suggestion from Bhavin Parikh dt: 23th June 2016*/       
      
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                     
  from cms.dbo.NCMS_LD_View a where BSECM > 0   and not exists  
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSECM' ) and isnull(client_code,'')<>''  
    
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                     
  from cms.dbo.NCMS_LD_View a where NSECM > 0   and not exists  
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSECM' ) and isnull(client_code,'')<>''  
     
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSEFO',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                     
  from cms.dbo.NCMS_LD_View a where NSEFO > 0   and not exists  
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSEFO' ) and isnull(client_code,'')<>''                         
     
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                     
  from cms.dbo.NCMS_LD_View a where NSX > 0   and not exists  
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSX' ) and isnull(client_code,'')<>''                                                     
   
   insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','MCD',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                     
  from cms.dbo.NCMS_LD_View a where MCD > 0   and not exists  
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCD' ) and isnull(client_code,'')<>''   
   
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                    
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                     
  from cms.dbo.NCMS_LD_View a where BSX > 0   and not exists  
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSX' ) and isnull(client_code,'')<>''   
   
/************************************************************************************************************************************************/   
/************************************************************************************************************************************************/   
                                                     
  /* Accrured Charges */                         
                                              
  UPDATE a                                                        
  set AccruedCharges=b.AccruedCharges,NetPayable=NetPayable+b.AccruedCharges                                                             
  FROM #Bond_SegwiseCldata a                                             
  JOIN                                           
  (select party_code,segment,AccruedCharges from cms.dbo.NCMS_SegwiseCldata with (nolock) ) b                                            
  ON a.party_code=b.party_Code and a.segment=b.Segment              
  where a.Segment <> 'NBFC'                                                    
              
                    
  /* BSECM & NSECM Zero for NBFC Clients */                                                    
                                
  /*                                                           
  UPDATE a                                                        
  set NetPayable = 0,ShortSellValue=0,Balance=0                                            
  FROM #NCMS_SegwiseCldata a                         
  JOIN                                                        
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                             
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                     
  */                            
                              
  /*---- Only unreco cheque amount of BSECM and NSECM should get deducted from NBFC Net payable */                            
  UPDATE a                                                        
  set NetPayable =  UnrecoAmt+AccruedCharges                               
  FROM #Bond_SegwiseCldata a                                             
  JOIN                                                        
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                      
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                     
                                                      
  /* Update Shortage Value */    
   update #Bond_SegwiseCldata set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval from                                                    
(select seg+'CM' as seg,party_code,shrtval=SUM(NetShortValue) from cms.dbo.ncms_shortsell                 
group by seg,party_Code having sum(NetShortValue) <> 0) b                      
 where #Bond_SegwiseCldata.segment=b.seg and #Bond_SegwiseCldata.party_code=b.party_Code   
       
/*                            
  UPDATE a        
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                             
 FROM #NCMS_SegwiseCldata a                                             
  JOIN                                                        
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_BSECM_ShrtVal group by party_Code having sum(dedVal) <> 0) b               
  ON a.segment='BSECM' and a.party_code=b.party_Code                                                    
                                       
  UPDATE a                                                        
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                             
  FROM #NCMS_SegwiseCldata a                     
  JOIN                                                        
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_NSECM_ShrtVal group by party_Code  having sum(dedVal) <> 0) b                                                    
  ON a.segment='NSECM' and a.party_code=b.party_Code                                                    
*/                            
                         
/* Only BOD shortage is considered in verification */                            
/*                
  UPDATE a                                                        
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                             
  FROM #NCMS_SegwiseCldata a                                             
  JOIN                    
  (                            
 select segment,party_code,Shrtval=ShortSellValue from NCMS_SegwiseCldata with (nolock)                            
 where (SEGMENT='BSECM' OR SEGMENT='NSECM') AND ShortSellValue <> 0                            
  ) B                             
  ON a.segment=B.SEGMENT and a.party_code=b.party_Code                                                     
*/                
                                                   
                  
/* Reduce LD Data */                  
 /*          
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.BSECM,NetPayable=NetPayable-b.BSECM                  
 from(                  
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                  
 ) b                   
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='BSECM'                  
 */          
           
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSECM'            
           
 /*          
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSECM,NetPayable=NetPayable-b.NSECM                  
 from(                  
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                  
 ) b                   
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSECM'                  
 */          
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSECM'            
 /*                 
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSEFO,NetPayable=NetPayable-b.NSEFO                  
 from(                  
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                  
 ) b                   
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSEFO'                  
 */          
           
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSEFO'            
 /*                 
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.MCD,NetPayable=NetPayable-b.MCD                  
 from(                  
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                  
 ) b                   
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='MCD'                  
 */          
           
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCD'            
           
             
 /*                 
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSX,NetPayable=NetPayable-b.NSX                  
 from(                  
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                  
 ) b                   
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSX'            
 */          
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSX'                   
  
  
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,BSX from cms.dbo.NCMS_LD_View where BSX > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSX'   
   
                 
 /*                 
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NCDEX,NetPayable=NetPayable-b.NCDEX                  
 from(                  
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                  
 ) b                   
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NCDEX'                  
*/              
              
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                 
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NCDEX'                  
                  
                  
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+              
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)              
 from(                  
 select client_code,MCX from cms.dbo.NCMS_LD_View where MCX > 0                  
 ) b                   
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCX'                  
  /* Insert into History table*/                
 insert into Bond_SegVeriData_hist(POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,                    
 MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO)                    
 select POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,                    
 AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                    
 from Bond_SegVeriData with (nolock) 
                  
  truncate table Bond_SegVeriData                        
  insert into Bond_SegVeriData                                          
  (                                          
  POrequestID,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,                                          
  MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                        
  )                                            
  select   /*ROW_NUMBER() OVER ( ORDER BY party_code,segment) AS refno,*/                          
  convert(varchar(6),getdate(),112)+replace(convert(varchar(8),getdate(),108),':','') AS refno,                          
  ProcessDate,Entity,Segment,Party_code,flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,                                          
  NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                           
  from #Bond_SegwiseCldata                                             
                                 
                                          
End try                     
                                              
BEGIN CATCH                                                      
 
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)       
 select GETDATE(),'Bond_VeriData',ERROR_LINE(),ERROR_MESSAGE()                                                         
                              
 DECLARE @ErrorMessage NVARCHAR(4000);                                                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                            
 RAISERROR (@ErrorMessage , 16, 1);                                  
                                                   
End catch                                                  
                                                    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_VeriData_24Aug2022
-- --------------------------------------------------

CREATE procEDURE [dbo].[Bond_VeriData_24Aug2022]                                
as                                                      
                                                      
Set nocount on                                         
SET XACT_ABORT ON                                                   
BEGIN TRY                                                        
                              
/*                                                        
  /* EQUITY */                                                      
  Exec anand.inhouse.dbo.NCMS_POdet                                
  Exec anand1.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse_curfo.dbo.NCMS_POdet                                 
  Exec angelcommodity.INHOUSE_MCDCS.dbo.NCMS_POdet                                  
  Exec angelfo.inhouse.dbo.NCMS_POdet_NSEMFSS                                                      
  Exec angelfo.inhouse.dbo.NCMS_POdet_BSEMFSS                                 
                                                        
  /* COMMODITY */                                                      
  Exec angelcommodity.inhouse_NCDX.dbo.NCMS_POdet                                 
  Exec angelcommodity.inhouse_MCDX.dbo.NCMS_POdet                                 
  /* SHORTAGE */                                                      
                                        
  if (Select blkstatus from NCMS_Get_BlockShrtTag with (nolock))='Unblock'                                      
  Begin                                      
 exec ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_CLI                                 
 exec ANGELDEMAT.INHOUSE.DBO.Rpt_Delpayinmatch_CMSPRO_CLI                                 
  End                                      
                              
  exec risk.dbo.Usp_Calc_ShrtVal_cli                                 
 */                              
                                  
  /* NBFC Process */                                                      
  /*                                              
  exec [172.31.16.57].inhouse.dbo.PROC_NBFC_PF_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.PR_NBFC_HOLD_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.NCMS_POdet                                                  
  */                                              
                                                        
  /* FETCH DATA */                                                      
   Create table #Bond_SegwiseCldata (                                                          
   id int,                                              
   ProcessDate datetime,                                              
   Entity varchar(10),                                              
   Segment varchar(10),                                              
   Party_code varchar(10),                                              
   Flag char(1),                                              
   Balance money,                                              
   UnsettledCrBill money,                                              
   UnrecoAmt money,                                              
   ShortSellValue money,                                              
   MarginAmt money,                                              
   Deposit money,                                              
   CashColl money,                                              
   NonCashColl money,                                              
   MarginAdjWithColl money,                                              
   MarginShortage money,                                              
   AccruedCharges money,                                              
   OtherDebit money,                                              
   NonCashConsideration money,                                              
ExpoUtilised money,                                              
   UnPosted_PO money,                   
   NetPayable money                                          
   )                                                                                                             
                                                
                          
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime,'Equity','BSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from anand.inhouse.dbo.Bond_PO                                                     
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select ProcessDatetime,'Equity','NSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from anand1.inhouse.dbo.Bond_PO                                                       
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSEFO',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse_curfo.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','MCD',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelcommodity.INHOUSE_MCDCS.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                                      
    
     
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                 
 select UpdDatetime,'Equity','BSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                   
 from angelcommodity.inhouse_bsx.dbo.Bond_marh     
 
                                                  
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                
 select UpdDatetime,'AllSegment','NCDEX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                 
 from angelcommodity.inhouse_NCDX.dbo.Bond_marh  with(nolock)                                               
 /* where PayoutValue <> 0 */        
                                                 
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                
 select UpdDatetime,'AllSegment','MCX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                 
 from angelcommodity.inhouse_MCDX.dbo.Bond_marh with(nolock)                                                
 /* where PayoutValue <> 0 */        
  
   
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                  
 select processDate,'NBFC','NBFC',party_Code,'I',ActualLedger,Unsettled,0,ShortValHC,0,0,0,VAHC,0,0,AccruedInt,ShortVal,0,0,NetAmount                                               
 from [172.31.16.57].inhouse.dbo.ncms_po  
      
    /************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
    /*Changed in order to consider MTM of cases where there is no ledger added by Neha Naiwar on suggestion from Bhavin Parikh dt: 23th June 2016*/         
        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSECM' ) and isnull(client_code,'')<>''    
      
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSECM' ) and isnull(client_code,'')<>''    
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSEFO',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSEFO > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSEFO' ) and isnull(client_code,'')<>''                           
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSX' ) and isnull(client_code,'')<>''                                                       
     
   insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','MCD',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where MCD > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCD' ) and isnull(client_code,'')<>''     
     
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSX' ) and isnull(client_code,'')<>''     
    
       
     insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'AllSegment','NCDEX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a with(nolock) where NCDEX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NCDEX' ) and isnull(client_code,'')<>''     
     
      insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'AllSegment','MCX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a with(nolock) where MCX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCX' ) and isnull(client_code,'')<>''    
     
/************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
   /* Unreco amount*/  
   --Changed in order to handle rejection on Nov 02 2016
   update #Bond_SegwiseCldata set UnrecoAmt=0.00  
   update #Bond_SegwiseCldata set UnsettledCrBill=0.00
     
                                                       
  /* Accrured Charges */                           
                                                
  UPDATE a                                                          
  set AccruedCharges=b.AccruedCharges,NetPayable=NetPayable+b.AccruedCharges                                                               
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                             
  (select party_code,segment,AccruedCharges from cms.dbo.NCMS_SegwiseCldata with (nolock) ) b                                              
  ON a.party_code=b.party_Code and a.segment=b.Segment                
  where a.Segment <> 'NBFC'                                               
                
                      
  /* BSECM & NSECM Zero for NBFC Clients */                                                      
                                  
  /*                                                             
  UPDATE a                                                          
  set NetPayable = 0,ShortSellValue=0,Balance=0                                              
  FROM #NCMS_SegwiseCldata a                           
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                               
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
  */                              
                                
  /*---- Only unreco cheque amount of BSECM and NSECM should get deducted from NBFC Net payable */                              
  UPDATE a                                                          
  set NetPayable =  UnrecoAmt+AccruedCharges                                 
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                        
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
                                                        
  /* Update Shortage Value */      
   update #Bond_SegwiseCldata set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval from                                                      
(select seg+'CM' as seg,party_code,shrtval=SUM(NetShortValue) from cms.dbo.ncms_shortsell                   
group by seg,party_Code having sum(NetShortValue) <> 0) b                        
 where #Bond_SegwiseCldata.segment=b.seg and #Bond_SegwiseCldata.party_code=b.party_Code     
         
/*                              
  UPDATE a          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
 FROM #NCMS_SegwiseCldata a                                               
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_BSECM_ShrtVal group by party_Code having sum(dedVal) <> 0) b                 
  ON a.segment='BSECM' and a.party_code=b.party_Code                                                      
                                         
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                       
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_NSECM_ShrtVal group by party_Code  having sum(dedVal) <> 0) b                                                      
  ON a.segment='NSECM' and a.party_code=b.party_Code                                                      
*/                              
                           
/* Only BOD shortage is considered in verification */                              
/*                  
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                                               
  JOIN                      
  (                              
 select segment,party_code,Shrtval=ShortSellValue from NCMS_SegwiseCldata with (nolock)                              
 where (SEGMENT='BSECM' OR SEGMENT='NSECM') AND ShortSellValue <> 0                              
  ) B                               
  ON a.segment=B.SEGMENT and a.party_code=b.party_Code                                                       
*/                  
                                                     
                    
/* Reduce LD Data */                    
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.BSECM,NetPayable=NetPayable-b.BSECM                    
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='BSECM'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSECM'              
             
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSECM,NetPayable=NetPayable-b.NSECM                    
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSECM'                    
 */            
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSECM'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSEFO,NetPayable=NetPayable-b.NSEFO                    
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSEFO'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSEFO'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.MCD,NetPayable=NetPayable-b.MCD                    
 from(                    
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='MCD'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                  
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCD'              
             
               
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSX,NetPayable=NetPayable-b.NSX                    
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSX'              
 */            
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSX'                     
    
    
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSX from cms.dbo.NCMS_LD_View where BSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSX'     
     
                   
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NCDEX,NetPayable=NetPayable-b.NCDEX                    
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NCDEX'                    
*/                
                
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NCDEX'                    
                    
                    
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,MCX from cms.dbo.NCMS_LD_View where MCX > 0                    
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCX'                    
  /* Insert into History table*/                  
 insert into Bond_SegVeriData_hist(POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,                      
 MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO)                      
 select POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,                      
 AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                      
 from Bond_SegVeriData with (nolock)   
                    
  truncate table Bond_SegVeriData                          
  insert into Bond_SegVeriData                                            
  (                                            
  POrequestID,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,                                            
  MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                          
  )                                              
  select   /*ROW_NUMBER() OVER ( ORDER BY party_code,segment) AS refno,*/                            
  convert(varchar(6),getdate(),112)+replace(convert(varchar(8),getdate(),108),':','') AS refno,                            
  ProcessDate,Entity,Segment,Party_code,flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,                                            
  NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                             
  from #Bond_SegwiseCldata                                               
                                   
                                            
End try                       
                                                
BEGIN CATCH                                                        
   
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)         
 select GETDATE(),'Bond_VeriData',ERROR_LINE(),ERROR_MESSAGE()                                                           
                                
 DECLARE @ErrorMessage NVARCHAR(4000);                                                              
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                              
 RAISERROR (@ErrorMessage , 16, 1);                                    
                                                     
End catch                                                    
                                                      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_VeriData_28May2021
-- --------------------------------------------------

CREATE procEDURE [dbo].[Bond_VeriData_28May2021]                                
as                                                      
                                                      
Set nocount on                                         
SET XACT_ABORT ON                                                   
BEGIN TRY                                                        
                              
/*                                                        
  /* EQUITY */                                                      
  Exec anand.inhouse.dbo.NCMS_POdet                                
  Exec anand1.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse_curfo.dbo.NCMS_POdet                                 
  Exec angelcommodity.INHOUSE_MCDCS.dbo.NCMS_POdet                                  
  Exec angelfo.inhouse.dbo.NCMS_POdet_NSEMFSS                                                      
  Exec angelfo.inhouse.dbo.NCMS_POdet_BSEMFSS                                 
                                                        
  /* COMMODITY */                                                      
  Exec angelcommodity.inhouse_NCDX.dbo.NCMS_POdet                                 
  Exec angelcommodity.inhouse_MCDX.dbo.NCMS_POdet                                 
  /* SHORTAGE */                                                      
                                        
  if (Select blkstatus from NCMS_Get_BlockShrtTag with (nolock))='Unblock'                                      
  Begin                                      
 exec ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_CLI                                 
 exec ANGELDEMAT.INHOUSE.DBO.Rpt_Delpayinmatch_CMSPRO_CLI                                 
  End                                      
                              
  exec risk.dbo.Usp_Calc_ShrtVal_cli                                 
 */                              
                                  
  /* NBFC Process */                                                      
  /*                                              
  exec [172.31.16.57].inhouse.dbo.PROC_NBFC_PF_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.PR_NBFC_HOLD_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.NCMS_POdet                                                  
  */                                              
                                                        
  /* FETCH DATA */                                                      
   Create table #Bond_SegwiseCldata (                                                          
   id int,                                              
   ProcessDate datetime,                                              
   Entity varchar(10),                                              
   Segment varchar(10),                                              
   Party_code varchar(10),                                              
   Flag char(1),                                              
   Balance money,                                              
   UnsettledCrBill money,                                              
   UnrecoAmt money,                                              
   ShortSellValue money,                                              
   MarginAmt money,                                              
   Deposit money,                                              
   CashColl money,                                              
   NonCashColl money,                                              
   MarginAdjWithColl money,                                              
   MarginShortage money,                                              
   AccruedCharges money,                                              
   OtherDebit money,                                              
   NonCashConsideration money,                                              
ExpoUtilised money,                                              
   UnPosted_PO money,                   
   NetPayable money                                          
   )                                                                                                             
                                                
                          
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime,'Equity','BSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from anand.inhouse.dbo.Bond_PO                                                     
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select ProcessDatetime,'Equity','NSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from anand1.inhouse.dbo.Bond_PO                                                       
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSEFO',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse_curfo.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','MCD',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelcommodity.INHOUSE_MCDCS.dbo.Bond_marh                                                       
  /* and PayoutValue <> 0*/                                                      
    
     
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                 
 select UpdDatetime,'Equity','BSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                   
 from angelcommodity.inhouse_bsx.dbo.Bond_marh     
   
   
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                  
 select processDate,'NBFC','NBFC',party_Code,'I',ActualLedger,Unsettled,0,ShortValHC,0,0,0,VAHC,0,0,AccruedInt,ShortVal,0,0,NetAmount                                               
 from [172.31.16.57].inhouse.dbo.ncms_po  
      
    /************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
    /*Changed in order to consider MTM of cases where there is no ledger added by Neha Naiwar on suggestion from Bhavin Parikh dt: 23th June 2016*/         
        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSECM' ) and isnull(client_code,'')<>''    
      
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSECM' ) and isnull(client_code,'')<>''    
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSEFO',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSEFO > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSEFO' ) and isnull(client_code,'')<>''                           
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSX' ) and isnull(client_code,'')<>''                                                       
     
   insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','MCD',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where MCD > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCD' ) and isnull(client_code,'')<>''     
     
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSX' ) and isnull(client_code,'')<>''     
     
/************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
   /* Unreco amount*/  
   --Changed in order to handle rejection on Nov 02 2016
   update #Bond_SegwiseCldata set UnrecoAmt=0.00  
   update #Bond_SegwiseCldata set UnsettledCrBill=0.00
     
                                                       
  /* Accrured Charges */                           
                                                
  UPDATE a                                                          
  set AccruedCharges=b.AccruedCharges,NetPayable=NetPayable+b.AccruedCharges                                                               
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                             
  (select party_code,segment,AccruedCharges from cms.dbo.NCMS_SegwiseCldata with (nolock) ) b                                              
  ON a.party_code=b.party_Code and a.segment=b.Segment                
  where a.Segment <> 'NBFC'                                               
                
                      
  /* BSECM & NSECM Zero for NBFC Clients */                                                      
                                  
  /*                                                             
  UPDATE a                                                          
  set NetPayable = 0,ShortSellValue=0,Balance=0                                              
  FROM #NCMS_SegwiseCldata a                           
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                               
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
  */                              
                                
  /*---- Only unreco cheque amount of BSECM and NSECM should get deducted from NBFC Net payable */                              
  UPDATE a                                                          
  set NetPayable =  UnrecoAmt+AccruedCharges                                 
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                        
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
                                                        
  /* Update Shortage Value */      
   update #Bond_SegwiseCldata set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval from                                                      
(select seg+'CM' as seg,party_code,shrtval=SUM(NetShortValue) from cms.dbo.ncms_shortsell                   
group by seg,party_Code having sum(NetShortValue) <> 0) b                        
 where #Bond_SegwiseCldata.segment=b.seg and #Bond_SegwiseCldata.party_code=b.party_Code     
         
/*                              
  UPDATE a          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
 FROM #NCMS_SegwiseCldata a                                               
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_BSECM_ShrtVal group by party_Code having sum(dedVal) <> 0) b                 
  ON a.segment='BSECM' and a.party_code=b.party_Code                                                      
                                         
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                       
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_NSECM_ShrtVal group by party_Code  having sum(dedVal) <> 0) b                                                      
  ON a.segment='NSECM' and a.party_code=b.party_Code                                                      
*/                              
                           
/* Only BOD shortage is considered in verification */                              
/*                  
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                                               
  JOIN                      
  (                              
 select segment,party_code,Shrtval=ShortSellValue from NCMS_SegwiseCldata with (nolock)                              
 where (SEGMENT='BSECM' OR SEGMENT='NSECM') AND ShortSellValue <> 0                              
  ) B                               
  ON a.segment=B.SEGMENT and a.party_code=b.party_Code                                                       
*/                  
                                                     
                    
/* Reduce LD Data */                    
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.BSECM,NetPayable=NetPayable-b.BSECM                    
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='BSECM'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSECM'              
             
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSECM,NetPayable=NetPayable-b.NSECM                    
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSECM'                    
 */            
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSECM'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSEFO,NetPayable=NetPayable-b.NSEFO                    
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSEFO'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSEFO'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.MCD,NetPayable=NetPayable-b.MCD                    
 from(                    
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='MCD'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                  
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCD'              
             
               
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSX,NetPayable=NetPayable-b.NSX                    
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSX'              
 */            
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSX'                     
    
    
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSX from cms.dbo.NCMS_LD_View where BSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSX'     
     
                   
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NCDEX,NetPayable=NetPayable-b.NCDEX                    
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NCDEX'                    
*/                
                
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NCDEX'                    
                    
                    
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,MCX from cms.dbo.NCMS_LD_View where MCX > 0                    
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCX'                    
  /* Insert into History table*/                  
 insert into Bond_SegVeriData_hist(POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,                      
 MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO)                      
 select POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,                      
 AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                      
 from Bond_SegVeriData with (nolock)   
                    
  truncate table Bond_SegVeriData                          
  insert into Bond_SegVeriData                                            
  (                                            
  POrequestID,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,                                            
  MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                          
  )                                              
  select   /*ROW_NUMBER() OVER ( ORDER BY party_code,segment) AS refno,*/                            
  convert(varchar(6),getdate(),112)+replace(convert(varchar(8),getdate(),108),':','') AS refno,                            
  ProcessDate,Entity,Segment,Party_code,flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,                                            
  NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                             
  from #Bond_SegwiseCldata                                               
                                   
                                            
End try                       
                                                
BEGIN CATCH                                                        
   
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)         
 select GETDATE(),'Bond_VeriData',ERROR_LINE(),ERROR_MESSAGE()                                                           
                                
 DECLARE @ErrorMessage NVARCHAR(4000);                                                              
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                              
 RAISERROR (@ErrorMessage , 16, 1);                                    
                                                     
End catch                                                    
                                                      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BondLimit
-- --------------------------------------------------
--[BondLimit] 'GG263',0 return   
CREATE procedure [dbo].[BondLimit]      
(      
@clientcode varchar(30),      
@limitamt money output      
)      
as      
begin       
set nocount on      
      
set transaction isolation level read uncommitted      
      
      
Create table #clientlimit      
(      
clientcode varchar(30),      
Ledger money,      
unrecocredit money,      
accuralcharges money,      
Mforders money,      
Onlinetransfer money,    
Bondorders money,    
FundsPayout money,      
NetBalance money      
)      
      
/*      
declare @clientcode varchar(30)      
set @clientcode='Vl001'      
*/      
      
      
/*      
--Fetch Ledger Balance from Backoffice based on Effective date to consider online transaction as well.      
      
--BSECM      
--drop table #bsecm_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #bsecm_led      
from anand.ACCOUNT_AB.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode      
       
 --NSECM        
--drop table #nsecm_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #nsecm_led      
from anand1.ACCOUNT.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode                                         
      
--NSEFO      
--drop table #nsefo_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #nsefo_led      
from ANGELFO.ACCOUNTFO.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode      
      
      
 --NSX        
--drop table #nsx_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #nsx_led      
from Angelfo.accountcurfo.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode                                         
      
--MCD      
--drop table #mcd_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #mcd_led      
from ANGELCOMMODITY.accountmcdxcds.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode      
      
      
select cltcode,ledger=sum(ledger)*-1      
into #ledgerbal      
from      
(      
select * from #bsecm_led      
union      
select * from #nsecm_led      
union      
select * from #nsefo_led      
union      
select * from #nsx_led      
union      
select * from #mcd_led)x      
group by cltcode      
*/      
      
--NRMS source     
  
/*   
select cltcode=party_code,ledger=Abl_net+(case when Nbfc_net <0 then 0 else Nbfc_net end)    
--Net_debit     
into #ledgerbal      
from [196.1.115.182].general.dbo.tbl_rms_collection_cli_ABL with (nolock) where Party_Code=@clientcode      
  */  
    
   select cltcode=party_code,  
Ledger=CONVERT(decimal(15,2),  
Net_Ledger-(case when NBFC_ledger<0 then NBFC_ledger else 0 end )-  
Case when (Margin_Total-Coll_TotalHC)>=0 then(Margin_Total-Coll_TotalHC) else 0 end )  
into #ledgerbal      
/*from [196.1.115.182].general.dbo.tbl_rms_collection_cli_ABL with (nolock)   where Party_Code=@clientcode  */ /*commented by neha on 15 may 20202 due to consider of commodity*/
from [196.1.115.182].general.dbo.tbl_rms_collection_cli with (nolock)   where Party_Code=@clientcode  

      
insert into #clientlimit(clientcode,Ledger)      
select cltcode,ledger from #ledgerbal      
      
    
/*Fund Transfer*/    
select cltcode=@clientcode,bal=dbo.OnlineFundTransfer(@clientcode) into #fundtransfer_fundspayout    
        
      
 update a set  Onlinetransfer=bal  from #clientlimit a,      
 (select cltcode,bal from  #fundtransfer_fundspayout where cltcode=@clientcode)b      
 where  a.clientcode=b.cltcode      
     
     
 /*Funds Payout*/    
   
 select cltcode=@clientcode,bal=dbo.OnlineFundPayout(@clientcode) into #fundspayout    
        
      
 update a set  FundsPayout=bal  from #clientlimit a,      
 (select cltcode,bal from  #fundspayout where cltcode=@clientcode)b      
 where  a.clientcode=b.cltcode      
       
      
      
/*UnReco Credit to be adjusted*/      
      
--unreco credit fetching      
 exec AngelNseCM.inhouse.dbo.Fetch_CliUnreco_bond @clientcode                    
 exec AngelBSECM.inhouse.dbo.Fetch_CliUnreco_bond @clientcode       
 exec ANGELFO.inhouse.dbo.Fetch_CliUnreco_bond @clientcode       
 exec ANGELCOMMODITY.INHOUSE_MCDCS.dbo.Fetch_CliUnreco_bond @clientcode       
 exec ANGELFO.INHOUSE_Curfo.dbo.Fetch_CliUnreco_bond @clientcode       
      
      /*
update a set unrecocredit=b.UnRecoCr  from #clientlimit a,      
(select cltcode,SUM(UnRecoCr) as UnRecoCr from      
(        
 select cltcode,SUM(Cramt) as UnRecoCr from anand1.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from anand.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELFO.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELCOMMODITY.INHOUSE_MCDCS.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELFO.INHOUSE_Curfo.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 )x group by cltcode)b where a.clientcode=b.cltcode      
       
       */
/*Accural Chared to be adjusted*/      
      
update a set  accuralcharges=charges_amt*-1  from #clientlimit a,      
(select party_code,charges_amt from  [196.1.115.182].general.dbo.Vw_Accrual_Charges where PARTY_CODE=@clientcode)b      
where  a.clientcode=b.party_code      
      
      
/*mutual fund orders*/      
      
update a  set Mforders=b.limits from  #clientlimit a,      
(select * from intranet.risk.dbo.vW_Get_Bond_Limits with (nolock) )b      
where a.clientcode=b.party_code      
    
    
    
/*Bond orders*/      
update a set Bondorders=b.Total from #clientlimit a,     
(select Client_Code,Total=SUM(Total) from tbl_BONDOrderEntry with (nolock)     
where Order_Status='Pending' and Verfiedon is null group by Client_Code)b    
where a.clientcode=b.Client_Code    
    
      
 --update #clientlimit set unrecocredit=0 where clientcode='M86925'     
      
/*Calculating Net Balance*/      
      
update #clientlimit set       
NetBalance=    
(isnull(Ledger,0)+isnull(Onlinetransfer,0))-(isnull(unrecocredit,0)+isnull(accuralcharges,0)+isnull(Mforders,0)+isnull(Bondorders,0)+isnull(FundsPayout,0)),       
@limitamt=    
(isnull(Ledger,0)+isnull(Onlinetransfer,0))-(isnull(unrecocredit,0)+isnull(accuralcharges,0)+isnull(Mforders,0)+isnull(Bondorders,0)+isnull(FundsPayout,0))       
where clientcode=@clientcode      
    
  print @limitamt    
      


--select * from #clientlimit      
      
drop table #clientlimit      
      
set nocount off      
      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BondLimit_02112016
-- --------------------------------------------------
--[BondLimit] 'GG263',0 return   
create procedure [dbo].[BondLimit_02112016]      
(      
@clientcode varchar(30),      
@limitamt money output      
)      
as      
begin       
set nocount on      
      
set transaction isolation level read uncommitted      
      
      
Create table #clientlimit      
(      
clientcode varchar(30),      
Ledger money,      
unrecocredit money,      
accuralcharges money,      
Mforders money,      
Onlinetransfer money,    
Bondorders money,    
FundsPayout money,      
NetBalance money      
)      
      
/*      
declare @clientcode varchar(30)      
set @clientcode='Vl001'      
*/      
      
      
/*      
--Fetch Ledger Balance from Backoffice based on Effective date to consider online transaction as well.      
      
--BSECM      
--drop table #bsecm_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #bsecm_led      
from anand.ACCOUNT_AB.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode      
       
 --NSECM        
--drop table #nsecm_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #nsecm_led      
from anand1.ACCOUNT.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode                                         
      
--NSEFO      
--drop table #nsefo_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #nsefo_led      
from ANGELFO.ACCOUNTFO.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode      
      
      
 --NSX        
--drop table #nsx_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #nsx_led      
from Angelfo.accountcurfo.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode                                         
      
--MCD      
--drop table #mcd_led      
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)      
into #mcd_led      
from ANGELCOMMODITY.accountmcdxcds.dbo.ledger a with (nolock)      
where a.cltcode=@clientcode and vdt<=GETDATE()      
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)      
group by cltcode      
      
      
select cltcode,ledger=sum(ledger)*-1      
into #ledgerbal      
from      
(      
select * from #bsecm_led      
union      
select * from #nsecm_led      
union      
select * from #nsefo_led      
union      
select * from #nsx_led      
union      
select * from #mcd_led)x      
group by cltcode      
*/      
      
--NRMS source     
  
/*   
select cltcode=party_code,ledger=Abl_net+(case when Nbfc_net <0 then 0 else Nbfc_net end)    
--Net_debit     
into #ledgerbal      
from [196.1.115.182].general.dbo.tbl_rms_collection_cli_ABL with (nolock) where Party_Code=@clientcode      
  */  
    
   select cltcode=party_code,  
Ledger=CONVERT(decimal(15,2),  
Net_Ledger-(case when NBFC_ledger<0 then NBFC_ledger else 0 end )-  
Case when (Margin_Total-Coll_TotalHC)>=0 then(Margin_Total-Coll_TotalHC) else 0 end )  
into #ledgerbal      
from [196.1.115.182].general.dbo.tbl_rms_collection_cli_ABL with (nolock)   where Party_Code=@clientcode  
      
insert into #clientlimit(clientcode,Ledger)      
select cltcode,ledger from #ledgerbal      
      
    
/*Fund Transfer*/    
select cltcode=@clientcode,bal=dbo.OnlineFundTransfer(@clientcode) into #fundtransfer_fundspayout    
        
      
 update a set  Onlinetransfer=bal  from #clientlimit a,      
 (select cltcode,bal from  #fundtransfer_fundspayout where cltcode=@clientcode)b      
 where  a.clientcode=b.cltcode      
     
     
 /*Funds Payout*/    
   
 select cltcode=@clientcode,bal=dbo.OnlineFundPayout(@clientcode) into #fundspayout    
        
      
 update a set  FundsPayout=bal  from #clientlimit a,      
 (select cltcode,bal from  #fundspayout where cltcode=@clientcode)b      
 where  a.clientcode=b.cltcode      
       
      
      
/*UnReco Credit to be adjusted*/      
      
--unreco credit fetching      
 exec anand1.inhouse.dbo.Fetch_CliUnreco_bond @clientcode                    
 exec anand.inhouse.dbo.Fetch_CliUnreco_bond @clientcode       
 exec ANGELFO.inhouse.dbo.Fetch_CliUnreco_bond @clientcode       
 exec ANGELCOMMODITY.INHOUSE_MCDCS.dbo.Fetch_CliUnreco_bond @clientcode       
 exec ANGELFO.INHOUSE_Curfo.dbo.Fetch_CliUnreco_bond @clientcode       
      
      
update a set unrecocredit=b.UnRecoCr  from #clientlimit a,      
(select cltcode,SUM(UnRecoCr) as UnRecoCr from      
(        
 select cltcode,SUM(Cramt) as UnRecoCr from anand1.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from anand.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELFO.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELCOMMODITY.INHOUSE_MCDCS.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 union      
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELFO.INHOUSE_Curfo.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode      
 )x group by cltcode)b where a.clientcode=b.cltcode      
       
       
/*Accural Chared to be adjusted*/      
      
update a set  accuralcharges=charges_amt*-1  from #clientlimit a,      
(select party_code,charges_amt from  [196.1.115.182].general.dbo.Vw_Accrual_Charges where PARTY_CODE=@clientcode)b      
where  a.clientcode=b.party_code      
      
      
/*mutual fund orders*/      
      
update a  set Mforders=b.limits from  #clientlimit a,      
(select * from intranet.risk.dbo.vW_Get_Bond_Limits with (nolock) )b      
where a.clientcode=b.party_code      
    
    
    
/*Bond orders*/      
update a set Bondorders=b.Total from #clientlimit a,     
(select Client_Code,Total=SUM(Total) from tbl_BONDOrderEntry with (nolock)     
where Order_Status='Pending' and Verfiedon is null group by Client_Code)b    
where a.clientcode=b.Client_Code    
    
      
 --update #clientlimit set unrecocredit=0 where clientcode='M86925'     
      
/*Calculating Net Balance*/      
      
update #clientlimit set       
NetBalance=    
(isnull(Ledger,0)+isnull(Onlinetransfer,0))-(isnull(unrecocredit,0)+isnull(accuralcharges,0)+isnull(Mforders,0)+isnull(Bondorders,0)+isnull(FundsPayout,0)),       
@limitamt=    
(isnull(Ledger,0)+isnull(Onlinetransfer,0))-(isnull(unrecocredit,0)+isnull(accuralcharges,0)+isnull(Mforders,0)+isnull(Bondorders,0)+isnull(FundsPayout,0))       
where clientcode=@clientcode      
    
  print @limitamt    
      


--select * from #clientlimit      
      
drop table #clientlimit      
      
set nocount off      
      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BondLimit_Checking
-- --------------------------------------------------

/*    
  
declare @limitamt money     
  
exec [BondLimit_Checking] 'R80719',@limitamt out    
  
select @limitamt    
  
*/    
  
CREATE procedure [dbo].[BondLimit_Checking]    
  
(    
  
@clientcode varchar(30),    
  
@limitamt money output    
  
)    
  
as    
  
begin     
  
set nocount on    
  
    
  
set transaction isolation level read uncommitted    
  
    
  
    
  
Create table #clientlimit    
  
(    
  
clientcode varchar(30),    
  
Ledger money,    
  
unrecocredit money,    
  
accuralcharges money,    
  
Mforders money,    
  
Onlinetransfer money,  
  
Bondorders money,  
  
FundsPayout money,    
  
NetBalance money    
  
)    
  
    
  
/*    
  
declare @clientcode varchar(30)    
  
set @clientcode='Vl001'    
  
*/    
  
    
  
    
  
/*    
  
--Fetch Ledger Balance from Backoffice based on Effective date to consider online transaction as well.    
  
    
  
--BSECM    
  
--drop table #bsecm_led    
  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)    
  
into #bsecm_led    
  
from anand.ACCOUNT_AB.dbo.ledger a with (nolock)    
  
where a.cltcode=@clientcode and vdt<=GETDATE()    
  
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)    
  
group by cltcode    
  
     
  
 --NSECM      
  
--drop table #nsecm_led    
  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)    
  
into #nsecm_led    
  
from anand1.ACCOUNT.dbo.ledger a with (nolock)    
  
where a.cltcode=@clientcode and vdt<=GETDATE()    
  
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)    
  
group by cltcode                                       
  
    
  
--NSEFO    
  
--drop table #nsefo_led    
  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)    
  
into #nsefo_led    
  
from ANGELFO.ACCOUNTFO.dbo.ledger a with (nolock)    
  
where a.cltcode=@clientcode and vdt<=GETDATE()    
  
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)    
  
group by cltcode    
  
    
  
    
  
 --NSX      
  
--drop table #nsx_led    
  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)    
  
into #nsx_led    
  
from Angelfo.accountcurfo.dbo.ledger a with (nolock)    
  
where a.cltcode=@clientcode and vdt<=GETDATE()    
  
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)    
  
group by cltcode                                       
  
    
  
--MCD    
  
--drop table #mcd_led    
  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)    
  
into #mcd_led    
  
from ANGELCOMMODITY.accountmcdxcds.dbo.ledger a with (nolock)    
  
where a.cltcode=@clientcode and vdt<=GETDATE()    
  
and vdt>=(select sdtcur from risk.dbo.parameter with (nolock) where curyear=1)    
  
group by cltcode    
  
    
  
    
  
select cltcode,ledger=sum(ledger)*-1    
  
into #ledgerbal    
  
from    
  
(    
  
select * from #bsecm_led    
  
union    
  
select * from #nsecm_led    
  
union    
  
select * from #nsefo_led    
  
union    
  
select * from #nsx_led    
  
union    
  
select * from #mcd_led)x    
  
group by cltcode    
  
*/    
  
    
  
--NRMS source    
  
  /*
select cltcode=party_code,ledger=Abl_net+(case when Nbfc_net <0 then 0 else Nbfc_net end)  
  
--Net_debit   
  
into #ledgerbal    
  
from [196.1.115.182].general.dbo.tbl_rms_collection_cli_ABL with (nolock) where Party_Code=@clientcode    

*/

select cltcode=party_code,
Ledger=CONVERT(decimal(15,2),
Net_Ledger-(case when NBFC_ledger<0 then NBFC_ledger else 0 end )-
Case when (Margin_Total-Coll_TotalHC)>=0 then(Margin_Total-Coll_TotalHC) else 0 end )
into #ledgerbal    
from [196.1.115.182].general.dbo.tbl_rms_collection_cli_ABL with (nolock) where Party_Code=@clientcode  

    
  
    
  
insert into #clientlimit(clientcode,Ledger)    
  
select cltcode,ledger from #ledgerbal    
  
    
  
  
  
/*Fund Transfer*/  
  
select cltcode=@clientcode,bal=dbo.OnlineFundTransfer(@clientcode) into #fundtransfer_fundspayout  
  
      
  
    
  
 update a set  Onlinetransfer=bal  from #clientlimit a,    
  
 (select cltcode,bal from  #fundtransfer_fundspayout where cltcode=@clientcode)b    
  
 where  a.clientcode=b.cltcode    
  
   
  
   
  
 /*Funds Payout*/  
  
   
  
 select cltcode=@clientcode,bal=dbo.OnlineFundPayout(@clientcode) into #fundspayout  
  
      
  
    
  
 update a set  FundsPayout=bal  from #clientlimit a,    
  
 (select cltcode,bal from  #fundspayout where cltcode=@clientcode)b    
  
 where  a.clientcode=b.cltcode    
  
     
  
    
  
    
  
/*UnReco Credit to be adjusted*/    
  
    
  
--unreco credit fetching    
  
 exec anand1.inhouse.dbo.Fetch_CliUnreco_bond @clientcode                  
  
 exec anand.inhouse.dbo.Fetch_CliUnreco_bond @clientcode     
  
 exec ANGELFO.inhouse.dbo.Fetch_CliUnreco_bond @clientcode     
  
 exec ANGELCOMMODITY.INHOUSE_MCDCS.dbo.Fetch_CliUnreco_bond @clientcode     
  
 exec ANGELFO.INHOUSE_Curfo.dbo.Fetch_CliUnreco_bond @clientcode     
  
    
  
    
  
update a set unrecocredit=b.UnRecoCr  from #clientlimit a,    
  
(select cltcode,SUM(UnRecoCr) as UnRecoCr from    
  
(      
  
 select cltcode,SUM(Cramt) as UnRecoCr from anand1.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode group by cltcode    
  
 union    
  
 select cltcode,SUM(Cramt) as UnRecoCr from anand.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode    
  
 union    
  
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELFO.inhouse.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode    
  
 union    
  
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELCOMMODITY.INHOUSE_MCDCS.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode    
  
 union    
  
 select cltcode,SUM(Cramt) as UnRecoCr from ANGELFO.INHOUSE_Curfo.dbo.BO_client_deposit_recno_bond with (nolock) where cltcode=@clientcode  group by cltcode    
  
 )x group by cltcode)b where a.clientcode=b.cltcode    
  
     
  
     
  
/*Accural Chared to be adjusted*/    
  
    
  
update a set  accuralcharges=charges_amt*-1  from #clientlimit a,    
  
(select party_code,charges_amt from  [196.1.115.182].general.dbo.Vw_Accrual_Charges where PARTY_CODE=@clientcode)b    
  
where  a.clientcode=b.party_code    
  
    
  
    
  
/*mutual fund orders*/    
  
    
  
update a  set Mforders=b.limits from  #clientlimit a,    
  
(select * from intranet.risk.dbo.vW_Get_Bond_Limits with (nolock) )b    
  
where a.clientcode=b.party_code    
  
  
  
  
  
  
  
/*Bond orders*/    
  
update a set Bondorders=b.Total from #clientlimit a,   
  
(select Client_Code,Total=SUM(Total) from tbl_BONDOrderEntry with (nolock)   
  
where Order_Status='Pending' and Verfiedon is null group by Client_Code)b  
  
where a.clientcode=b.Client_Code  
  
  
  
    
  
    
  
    
  
/*Calculating Net Balance*/    
  
    
  
update #clientlimit set     
  
NetBalance=  
  
(isnull(Ledger,0)+isnull(Onlinetransfer,0))-(isnull(unrecocredit,0)+isnull(accuralcharges,0)+isnull(Mforders,0)+isnull(Bondorders,0)+isnull(FundsPayout,0)),     
  
@limitamt=  
  
(isnull(Ledger,0)+isnull(Onlinetransfer,0))-(isnull(unrecocredit,0)+isnull(accuralcharges,0)+isnull(Mforders,0)+isnull(Bondorders,0)+isnull(FundsPayout,0))     
  
where clientcode=@clientcode    
  
    
  
    
  
    
  
select * from #clientlimit    
  
    
  
drop table #clientlimit    
  
    
  
set nocount off    
  
    
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_ClientSubbroker_Details
-- --------------------------------------------------


   -- [Get_ClientSubbroker_Details] 'd37717','broker','e67515','e67515'        
   -- [Get_ClientSubbroker_Details] 'D2215','sb','smir','smir'        
CREATE proc [dbo].[Get_ClientSubbroker_Details]                                
   (                                
   @clientcode AS VARCHAR(15) ,                              
   @ACCESS_TO AS VARCHAR(20),                              
   @ACCESS_CODE AS VARCHAR(20),                      
   @SBCODE AS VARCHAR(50)                             
   )                                
   AS                                
   SET NOCOUNT ON                              
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                               
                          
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200),@STR1 AS VARCHAR(5000)                                                   
        
   IF OBJECT_ID('TempDB..#PARTY_MIMANSA_client') IS NOT NULL                    
      DROP TABLE #PARTY_MIMANSA_client                    
                          
   CREATE TABLE #PARTY_MIMANSA_client                 
   (                  
   PARTY_CODE VARCHAR(30)                  
   )               
                                                      
  IF @ACCESS_TO= 'BRANCH'                                                                                              
   BEGIN                                                                                   
    SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                                    
   END                    
  IF (@ACCESS_TO='BROKER' And (@ACCESS_CODE='CSO' OR @ACCESS_CODE='HO' )  )                                                                
   BEGIN                                 
    SET  @CONDITION='bran.BRANCH_CD LIKE ''%'''                     
   END                                                                        
  IF (@ACCESS_TO='BROKER' And @ACCESS_CODE='CSO')                  
   BEGIN                                                           
    SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                                                
   END                                                                                                           
  IF @ACCESS_TO='SB'                                                                    
   BEGIN                                                              
    SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                                                
   END                                                                 
  IF @ACCESS_TO='BRMAST'                                                                    
   BEGIN                                                              
    SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                                             
   END                                                                                    
  IF @ACCESS_TO='SBMAST'                                                                    
   BEGIN                                                                                       
    SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                                    
   END                                                                                     
  IF @ACCESS_TO='REGION'                                                                    
   BEGIN                                                              
    SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                                             
   END 
   
    IF EXISTS(SELECT * FROM [Mimansa].angelcs.DBO.angeluserbranch WHERE EMP_NO=@ACCESS_CODE)                 
  BEGIN  

    IF OBJECT_ID('TempDB..#PARTY_MIMANSA') IS NOT NULL                      
    DROP TABLE #PARTY_MIMANSA                      
                       
    CREATE TABLE #PARTY_MIMANSA            
    (                    
    PARTY_CODE VARCHAR(30)                    
    )                    
                      
    INSERT INTO #PARTY_MIMANSA                    
    EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode                    
                        
    SET @CONDITION=' PARTY_CODE IN (SELECT PARTY_CODE FROM #PARTY_MIMANSA)'                     
  END           
          
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                
   BEGIN 
            
   INSERT INTO #PARTY_MIMANSA_client                
   EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode               
   --EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO='cso',@STATUSID='broker',@PARTY_CODE=''               
 End          
           
IF Exists(Select * from #PARTY_MIMANSA_client)         
BEGIN           
          
 if Exists(Select party_Code from #PARTY_MIMANSA_client where party_Code=@clientcode)                      
 Begin                
  SET @STR='    SELECT cl_code as  Party_code,pan_gir_no as pan_no,long_name, case when  nsecm =''Y'' then ''NSE'' when bsecm =''Y'' then ''BSE''  else ''NSE'' end as ''Segment''  FROM INTRANET.RISK.DBO.CLIENT_DETAILS with(nolock)                      
        where party_code='''+@clientcode+'''  '                     
                       
  SET @STR1 = '  SELECT DISTINCT  sUB.BRANCH                      
  FROM [Mimansa].angelcs.dbo.angeluserbranch  SUB  with(nolock)                     
  INNER JOIN INTRANET.RISK.DBO.BRANCHES BRANC with(nolock) ON SUB.BRANCH_CD = BRANC.BRANCH_Code  AND SUB.Emp_no = '''+ @SBCODE + '''' 
  
  print @STR
      print @STR1             
 End              
END                      
Else                
Begin                
 SET @STR='SELECT cl_code as  Party_code,pan_gir_no as pan_no,long_name, case when  nsecm =''Y'' then ''NSE'' when bsecm =''Y'' then ''BSE''  else ''NSE'' end as ''Segment''  FROM INTRANET.RISK.DBO.CLIENT_DETAILS with(nolock)                      
        where party_code='''+@clientcode+''' and '+ @CONDITION+''                      
                    
 SET @STR1 = ' SELECT DISTINCT  BRANC.BRANCH                      
 FROM INTRANET.RISK.DBO.SUBBROKERS SUB with(nolock)                     
 INNER JOIN INTRANET.RISK.DBO.BRANCHES BRANC with(nolock) ON SUB.BRANCH_CODE = BRANC.BRANCH_CODE  AND SUB.SUB_BROKER = '''+ @SBCODE + ''''     
 print @STR
      print @STR1 
                  
End                     
  PRINT @STR                      
  PRINT @STR1 
                       
                          
   EXEC (@STR)                        
   EXEC (@STR1)                                

   DROP TABLE #PARTY_MIMANSA_client                                            
                          
   --PRINT @STR                                  
   SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_ClientSubbroker_Details_IPartner
-- --------------------------------------------------


   -- [Get_ClientSubbroker_Details] 'd37717','broker','e67515','e67515'        
   -- [Get_ClientSubbroker_Details] 'D2215','sb','smir','smir'        
CREATE proc [dbo].[Get_ClientSubbroker_Details_IPartner]                                
   (                                
   @clientcode AS VARCHAR(15) ,                              
   @ACCESS_TO AS VARCHAR(20),                              
   @ACCESS_CODE AS VARCHAR(20),                      
   @SBCODE AS VARCHAR(50)                             
   )                                
   AS                                
   SET NOCOUNT ON                              
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                               
                          
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200),@STR1 AS VARCHAR(5000)                                                   
        
   IF OBJECT_ID('TempDB..#PARTY_MIMANSA_client') IS NOT NULL                    
      DROP TABLE #PARTY_MIMANSA_client                    
                          
   CREATE TABLE #PARTY_MIMANSA_client                 
   (                  
   PARTY_CODE VARCHAR(30)                  
   )               
                                                      
  IF @ACCESS_TO= 'BRANCH'                                                                                              
   BEGIN                                                                                   
    SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                                    
   END                    
  IF (@ACCESS_TO='BROKER' And (@ACCESS_CODE='CSO' OR @ACCESS_CODE='HO' )  )                                                                
   BEGIN                                 
    SET  @CONDITION='bran.BRANCH_CD LIKE ''%'''                     
   END                                                                        
  IF (@ACCESS_TO='BROKER' And @ACCESS_CODE='CSO')                  
   BEGIN                                                           
    SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                                                
   END                                                                                                           
  IF @ACCESS_TO='SB'                                                                    
   BEGIN                                                              
    SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                                                
   END                                                                 
  IF @ACCESS_TO='BRMAST'                                                                    
   BEGIN                                                              
    SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                                             
   END                                                                                    
  IF @ACCESS_TO='SBMAST'                                                                    
   BEGIN                                                                                       
    SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                                    
   END                                                                                     
  IF @ACCESS_TO='REGION'                                                                    
   BEGIN                                                              
    SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                                             
   END 
   
    IF EXISTS(SELECT * FROM [Mimansa].angelcs.DBO.angeluserbranch WHERE EMP_NO=@ACCESS_CODE)                 
  BEGIN  

    IF OBJECT_ID('TempDB..#PARTY_MIMANSA') IS NOT NULL                      
    DROP TABLE #PARTY_MIMANSA                      
                       
    CREATE TABLE #PARTY_MIMANSA            
    (                    
    PARTY_CODE VARCHAR(30)                    
    )                    
                      
    INSERT INTO #PARTY_MIMANSA                    
    EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode                    
                        
    SET @CONDITION=' PARTY_CODE IN (SELECT PARTY_CODE FROM #PARTY_MIMANSA)'                     
  END           
          
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                
   BEGIN 
            
   INSERT INTO #PARTY_MIMANSA_client                
   EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode               
   --EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO='cso',@STATUSID='broker',@PARTY_CODE=''               
 End          
           
IF Exists(Select * from #PARTY_MIMANSA_client)         
BEGIN           
          
 if Exists(Select party_Code from #PARTY_MIMANSA_client where party_Code=@clientcode)                      
 Begin                
  SET @STR='    SELECT cl_code as  Party_code,pan_gir_no as pan_no,long_name, case when  nsecm =''Y'' then ''NSE'' when bsecm =''Y'' then ''BSE''  else ''NSE'' end as ''Segment''  FROM INTRANET.RISK.DBO.CLIENT_DETAILS with(nolock)                      
        where party_code='''+@clientcode+'''  '                     
                       
  SET @STR1 = '  SELECT DISTINCT  sUB.BRANCH                      
  FROM [Mimansa].angelcs.dbo.angeluserbranch  SUB  with(nolock)                     
  INNER JOIN INTRANET.RISK.DBO.BRANCHES BRANC with(nolock) ON SUB.BRANCH_CD = BRANC.BRANCH_Code  AND SUB.Emp_no = '''+ @SBCODE + '''' 
  
  print @STR
      print @STR1             
 End              
END                      
Else                
Begin                
 SET @STR='SELECT cl_code as  Party_code,pan_gir_no as pan_no,long_name, case when  nsecm =''Y'' then ''NSE'' when bsecm =''Y'' then ''BSE''  else ''NSE'' end as ''Segment''  FROM INTRANET.RISK.DBO.CLIENT_DETAILS with(nolock)                      
        where party_code='''+@clientcode+''' and '+ @CONDITION+''                      
                    
 SET @STR1 = ' SELECT DISTINCT  BRANC.BRANCH                      
 FROM INTRANET.RISK.DBO.SUBBROKERS SUB with(nolock)                     
 INNER JOIN INTRANET.RISK.DBO.BRANCHES BRANC with(nolock) ON SUB.BRANCH_CODE = BRANC.BRANCH_CODE  AND SUB.SUB_BROKER = '''+ @SBCODE + ''''     
 print @STR
      print @STR1 
                  
End                     
  PRINT @STR                      
  PRINT @STR1 
                       
                          
   EXEC (@STR)                        
   EXEC (@STR1)                                

   DROP TABLE #PARTY_MIMANSA_client                                            
                          
   --PRINT @STR                                  
   SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GETDROPDOWNLIST
-- --------------------------------------------------
CREATE proc [dbo].[GETDROPDOWNLIST]
AS
 SELECT SRNO,SCHEMENAME FROM [TBL_BONDMASTER]  
 WHERE CONVERT(DATE, GETDATE(),103) BETWEEN CONVERT(DATE, STARTDATE,103) AND CONVERT(DATE, ENDDATE,103)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_Allotment
-- --------------------------------------------------

CREATE procedure [dbo].[GSec_Allotment]    
as    
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY          
    
    
select x.*,y.netpayable into #bondallotment from     
(select * from tbl_bondorderentry with (nolock) where Order_Status='Pending' and Verfiedon is null)x    
inner join     
(select party_code,netpayable=SUM(netpayable) from GSec_SegVeriData with (nolock) group by party_code)y     
on x.client_code=y.party_Code    
    
--Rejection due to InSufficient balance     
update #bondallotment set Order_Status='Rejected',Comment='Insufficient Balance during allotment'    
where netpayable<total    
    /*
update a      
set Order_Status='Rejected',Comment='Insufficient Balance during allotment',      
Verfiedon=GETDATE()      
from tbl_bondorderentry a,      
 (select * from #bondallotment where netpayable<total) b      
 where a.client_code=b.client_code and a.entryid=b.entryid      
 
 
  insert into sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)                            
 select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from         
 (        
 select c.mobile_pager as No, a.Client_code                             
 ,'Order for subscription for'+convert(varchar,a.Order_Qty)+' Units / Rs. '+convert(varchar,Total)+' in Sovereign Gold Bond for code '        
 +ltrim(rtrim(CONVERT(VARCHAR(10),a.Client_Code)))+' is rejected.'   
 +' TRXN No. '+convert(varchar,a.ApplicationNo)+'' as sms_msg ,         
 convert(varchar(10), getdate(), 103) as sms_dt                  
 ,ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time                           
 ,'P' as flag                               
 , case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm                             
 ,'Bond_Rejected'   as Purpose         
 from (select * from #bondallotment where netpayable<total) a INNER JOIN risk.dbo.client_Details c                               
 on a.Client_code=c.party_code         
 ) x   
    
    */
    
select EntryId,BOND_SrNo,Client_code,total,netpayable,Order_qty,    
tosegment=case when segment='BSE' then 'BSECM' else 'NSECM' end into #eligiblecodes from  #bondallotment where netpayable>=total    
    
    
select party_code,fromsegment=segment,y.total,x.netpayable,y.Order_qty,      
srno=ROW_NUMBER() over (partition by Entryid order by x.Netpayable desc),    
clientsrno=DENSE_RANK() over (order by Entryid),    
Adjustamt=CONVERT(money,0),entryid    
into #bondallotment_segmentwise    
 from  Gsec_SegVeriData x    
inner join     
(select Entryid,Client_code,total,Order_qty,netpayable from  #eligiblecodes)y on x.party_code=y.Client_code    
where x.netpayable>0    
    
    
Declare @cnt int,@inc int,@bondamt money    
    
select @cnt=COUNT(client_code) from #eligiblecodes    
set @inc=1    
set @bondamt=0    
    
while (@cnt>=@inc)    
begin     
  declare @cntin int,@incin int,@Adjustamt money,@party_code varchar(30)    
  select @cntin=COUNT(srno),@party_code=max(party_code) from #bondallotment_segmentwise where clientsrno=@inc    
  set @incin=1    

    select party_code,fromsegment,previousadjustamt=sum(Adjustamt) into #previousadjustamt from 
    #bondallotment_segmentwise where party_code=@party_code group by party_code,fromsegment
    
    update a set netpayable=netpayable-previousadjustamt from #bondallotment_segmentwise a , #previousadjustamt b where a.party_code=b.party_code
    and a.fromsegment=b.fromsegment and clientsrno=@inc

	drop table #previousadjustamt    
          
	select @Adjustamt=MAX(total) from #bondallotment_segmentwise where clientsrno=@inc group by party_code    
      
  while (@cntin>=@incin)    
  begin    
          
   update #bondallotment_segmentwise     
    set Adjustamt=case when Netpayable>=@Adjustamt then @Adjustamt else    
     Netpayable end         
   where clientsrno=@inc and srno=@incin    
       
   select  @Adjustamt=@Adjustamt-Adjustamt from #bondallotment_segmentwise where clientsrno=@inc and srno=@incin    
          
   set @incin=@incin+1    
  end    
     
 set @inc=@inc+1    
end    
     
--Delete which are not getting adjusted    
delete from #bondallotment_segmentwise where Adjustamt=0    
    
    
truncate table GSec_Jv    
    
insert into GSec_Jv(party_code,fromsegment,tosegment,markedamount,availableamount,JVAmount,JVDate,ProcessDate,EntryId,BOND_SrNo,BO_Posted,BO_RowState,OrderQty)       
select x.party_code,fromsegment,tosegment,markedamount=x.total,    
availableamount=x.netpayable,JVAmount=Adjustamt,    
JVDate=Convert(datetime,CONVERT(varchar(11),GETDATE(),103),103),    
ProcessDate=GETDATE(),x.EntryId,BOND_SrNo,BO_Posted='N',BO_RowState=0,x.order_Qty
from #bondallotment_segmentwise x  inner join    
#eligiblecodes y on x.party_code=y.client_code and x.EntryId=y.EntryId
  

/*    
insert into Bond_Jv_log     
select * from  Bond_Jv

*/

End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'Gsec_Allotment',ERROR_LINE(),ERROR_MESSAGE()                                                             
       
  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_Batch_initialise
-- --------------------------------------------------
CREATE procedure [dbo].[GSec_Batch_initialise]          
as          
    
Set nocount on                            
SET XACT_ABORT ON                               
BEGIN TRY                                    
    
 insert into GSec_Batch_process_log(Srno,ProcedureName,Active_Status,StartDate,EndDate,Flag,UpdatedOn)           
 select Srno,ProcedureName,Active_Status,StartDate,EndDate,Flag,getdate() from GSec_Batch_process           
       
 update GSec_Batch_process set flag=0      
       
End try                                 
BEGIN CATCH                                    
                                
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)         
 select GETDATE(),'GSec_Batch_initialise',ERROR_LINE(),ERROR_MESSAGE()                                          
    
 DECLARE @ErrorMessage NVARCHAR(4000);                                      
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                      
 RAISERROR (@ErrorMessage , 16, 1);         
         
End catch                       
                            
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_BOapiPush
-- --------------------------------------------------
CREATE proc [dbo].[GSec_BOapiPush]                        
as                        
Set nocount on                                                
SET XACT_ABORT ON                                                   
BEGIN TRY                           
                        
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)                       
                        
 ----insert into anand.MKTAPI.dbo.tbl_post_data                       
 --(VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                        
 --CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                          
 select                                       
 8 as VOUCHERTYPE,                        
 ROW_NUMBER() OVER ( ORDER BY party_Code) AS [SNo],                        
 JVdate as VDATE,                        
 JVdate as EDATE,                        
 party_Code as CLTCODE,                        
 0 as CREDITAMT,                        
 JVAmount as DEBITAMT,                        
 /*'Amount Subscribed for Sovereign Gold Bond' as NARRATION,                        */
  'Appln amt debited twds '+Convert(varchar(20),OrderQty)+' '+case when d.Category='GSec' then 'G-Sec' when d.Category='TBill' then 'T-Bills' end +' @ Rs.'+Convert(varchar(20),d.Rate)+' - '+Symbol+' '+ case when d.Category='GSec' then 'Series'+Convert(varchar(20),Series)+' ' when d.Category='TBill' then 'GS' end +'– Clt '+party_Code+'' as NARRATION,                        
 '' as BANKCODE,                        
 '' as MARGINCODE,                        
 '' as BANKNAME,                        
 '' as BRANCHNAME,                        
 'HO' as BRANCHCODE,                        
 '' as DDNO,            
 /*VerifierId as DDNO, */  
 /* convert(varchar(10),VerifierID)+convert(varchar(10),RequestID) as DDNO, */            
 '' as CHEQUEMODE,                        
 '' as CHEQUEDATE,                        
 '' as CHEQUENAME,                        
 '' as CLEAR_MODE,                        
 '' as TPACCOUNTNUMBER,                        
 EXCHANGE=case  
when tosegment='BSECM' then 'BSE'  
when tosegment='NSECM' then 'NSE'  
when tosegment='NSEFO' then 'NSE'  
when tosegment='MCD' then 'MCD'  
when tosegment='NSX' then 'NSX'  
when tosegment='BSX' then 'BSX'  
else tosegment end  
,     
 SEGMENT= case  
 when tosegment in ('BSECM','NSECM') then 'CAPITAL' else 'FUTURES' end ,                        
 1 as MKCK_FLAG,                        
 a.Entryid as Return_fld4,                        
 case when d.Category='GSec' then 'GSec' else 'TBills' end as Return_fld5,                        
 0 as Rowstate,          
  case when d.Category='GSec' then 'GSecdebit' else 'TBillsDebits' end  as Return_fld2    INTO #TEMP                 
 from                         
 (select * from GSec_Jv where BO_Posted='N' and JVAmount > 0) a                
 join risk.dbo.Vw_RMS_Client_Vertical c                        
 on a.Party_Code=c.client 
  join #tbl_BondMaster d on a.BOND_SrNo=d.srno
                        

SELECT * FROM (
  SELECT * FROM #TEMP
  UNION ALL
  SELECT VOUCHERTYPE,SNo,VDATE,EDATE,'99885' CLTCODE,
  DEBITAMT CREDTAMT,'0' DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,
  DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
  MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2
 FROM #TEMP )A
 ORDER BY SNO
 
  
 
   
  insert into AngelBseCM.MKTAPI.dbo.tbl_post_data                       
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                        
 CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                          
SELECT * FROM (
  SELECT * FROM #TEMP
  UNION ALL
  SELECT VOUCHERTYPE,SNo,VDATE,EDATE,'99885' CLTCODE,
  DEBITAMT CREDTAMT,'0' DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,
  DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,
  MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2
 FROM #TEMP )A
 ORDER BY SNO   
  
  declare @Category as varchar(50)='' 
  select @Category=Category from #tbl_BondMaster 
  if(@Category='GSec')
  begin
	  update GSec_Jv set BO_Posted='Y',BO_RowState=Rowstate from                        
	 (                        
	  select DDNO,Rowstate,RETURN_FLD4,cltcode,debitAmt,return_fld2   from AngelBseCM.MKTAPI.dbo.tbl_post_data with (nolock)  
	  where Return_fld5='GSec' and Vdate>=GETDATE()-3                        
	  and Return_fld2='GSecdebit'  
	 ) b where   
	  GSec_Jv.party_code=b.cltcode        
	 and GSec_Jv.JVAmount=b.debitAmt         
	 and GSec_Jv.Entryid=b.Return_fld4                       
	 and GSec_Jv.BO_Posted='N'  
 End
 else
 begin
	 update GSec_Jv set BO_Posted='Y',BO_RowState=Rowstate from                        
	 (                        
	  select DDNO,Rowstate,RETURN_FLD4,cltcode,debitAmt,return_fld2   from AngelBseCM.MKTAPI.dbo.tbl_post_data with (nolock)  
	  where Return_fld5='TBills' and Vdate>=GETDATE()-3                        
	  and Return_fld2='TBillsdebit'  
	 ) b where   
	  GSec_Jv.party_code=b.cltcode        
	 and GSec_Jv.JVAmount=b.debitAmt         
	 and GSec_Jv.Entryid=b.Return_fld4                       
	 and GSec_Jv.BO_Posted='N' 
 end	 
   
   
insert into GSec_Jv_log       
select * from  GSec_Jv     
  
update a set Order_Status='Verified',Verfiedon=getdate() from tbl_bondorderentry a,  
(select party_code,entryid from GSec_Jv where BO_posted='Y' group by party_code,entryid)b  
 where   
 a.client_code=b.party_code and a.entryid=b.entryid and   
 a.Order_Status='Pending' and a.Verfiedon is null   
  

                        
End try                                                     
BEGIN CATCH                                                          
     
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)           
 select GETDATE(),'GSec_BOapiPush',ERROR_LINE(),ERROR_MESSAGE()                                                             
                                  
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                
 RAISERROR (@ErrorMessage , 16, 1);                                      
                                                       
End catch                                             
                                                
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_BSEFileGeneration
-- --------------------------------------------------
CREATE procedure [dbo].[GSec_BSEFileGeneration]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
   SELECT @emailto='falak.jagad@angelbroking.com;gopi.krishna@angelbroking.com;pravin.adkhale@angelbroking.com;kantish.salian@angelbroking.com'   
   select @emailcc='nimesh.sanghvi@angelbroking.com;bhavin@angelbroking.com;prakash.koradia@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.183\d$\Bond\BSE\GSec_BSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='GSec_BSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
   
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon  is not null  
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
              
 TRUNCATE  TABLE GSec_OrderFile                
     
 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,  
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
  a.ApplicationNo,Filler1='Y',
  a.ClientName, 
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as Depository,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Order_Qty as Units,Filler2='0',a.Rate,Filler3='Y',Filler4='0','0' as Pan_UCC_Flag,a.Pan as PanNumber,'0' as filler5,'0' as Filler6,
'' as Filler7,    
0 as BIDID,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='BSE'     
  
         
            
 INSERT INTO GSec_OrderFile            
 SELECT Symbol, ApplicationNo,Filler1,ApplicantName,Depository,DPid, BeneficiaryId,Units ,Filler2,Rate,Filler3,Filler4,Pan_UCC_Flag,
 Pannumber,Filler5,Filler6,Filler7,BIDID,ActivityType from #file    
 
            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.GSec_OrderFile " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='BSE'   
    
 insert into TBL_GSec_FILEUPLOADMASTER  
 select 'BSE Order Export',@BondSrno,'BSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached BSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='GSEC: BSE'                   
                    
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from GSec_OrderFile)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='BSE'    
      
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'GSec_BSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_NSEFileGeneration
-- --------------------------------------------------
CREATE procedure [dbo].[GSec_NSEFileGeneration]             
as                
BEGIN                
 SET NOCOUNT ON     
BEGIN TRY    
DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)                            
   SELECT @emailto='rohit.patil@angelbroking.com'   
   select @emailcc='rohit.patil@angelbroking.com'  
   select @emailbcc='neha.naiwar@angelbroking.com'    
DECLARE @filename1 as varchar(100),@filename2 as varchar(100)                                    
                         
 select @filename1='\\196.1.115.183\d$\Bond\NSE\GSec_NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                        
 select @filename2='GSec_NSEOrder_Report'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'  
   
 Declare @verifiedon datetime  
 select @verifiedon=max(verfiedon) from tbl_BONDOrderEntry with (nolock) where Verfiedon  is not null  
 
 SELECT * INTO #tbl_BondMaster FROM tbl_BondMaster WHERE Enddate>=cONVERT(VARCHAR(11),GETDATE(),121)
                
 TRUNCATE  TABLE GSec_NSE_OrderFile                

 /*select Symbol=case when b.Symbol='SGBT6' then 'SGB201606' else  b.Symbol end ,*/ /*commented on 27Feb2017*/
 select b.Symbol,  
  /*Series=case when b.Series='4' then 'GB' else  b.Series end,  */
  Series='GS',
 case when isnumeric(a.DP)=0 then 'NSDL' else 'CDSL' end as DepositoryName,  
 DPid=case when isnumeric(a.DP)=0 then substring (a.DP,0,9) else '' end,  
/*substring (a.DP,0,9) as DPid,*/  
BeneficiaryId=case when isnumeric(a.DP)=0 then substring (a.DP,9,16) else a.DP end,  
a.Total as BidQuantity/*InvestmentValue*/,a.Rate,a.Pan as PanNumber,'' as RefNo,    
0 as OrderNo,    
(case when a.Order_status='Verified' then 'N' else '' end) as ActivityType    
 into #file    
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon =@verifiedon  
 and a.ExportedOn is null and Segment='NSE'     
         
            
 INSERT INTO GSec_NSE_OrderFile            
 SELECT  Symbol,Series,DepositoryName,DPid,BeneficiaryId,BidQuantity,Rate,Pannumber,RefNo,OrderNo,ActivityType from #file    
 
            
  DECLARE @PATH VARCHAR(250)            
  DECLARE @BCPCOMMAND VARCHAR(250)            
  DECLARE @FILENAME VARCHAR(250)           
           
  --SET @PATH ='d:\upload1\Bond\'            
  --SET @FILENAME = @PATH + 'Order_Report'+CONVERT(VARCHAR,GETDATE(),112)+'.csv'            
  SET @BCPCOMMAND = 'BCP "SELECT * FROM INTRANET.Bond.dbo.GSec_NSE_OrderFile " QUERYOUT "'            
  SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'             
          
  --PRINT @BCPCOMMAND             
  EXEC MASTER..XP_CMDSHELL @BCPCOMMAND               
 -- SELECT @FILENAME AS FilePath      
  
declare @BondSrno as int  
  
 select @BondSrno=a.Bond_Srno   
 from tbl_BONDOrderEntry a join #tbl_BondMaster b on a.Bond_Srno=b.Srno    
 where a.Order_status='Verified' and a.Verfiedon is not null and a.ExportedOn is null and Segment='NSE'   
    
 insert into TBL_GSec_FILEUPLOADMASTER  
 select 'NSE Order Export',@BondSrno,'NSE',@filename2,'',@filename1,'In-house System','CSO',getdate(),''     
                                   
SET @MESS='Dear All,<br><Br>Good Evening!!!<br><Br>Please refer the attached NSE file.<Br><Br>'                                    
SET @MESS=@MESS+'<BR><BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'                                
set @sub ='GSec: NSE'                   
                    
                      
 DECLARE @s varchar(500)                    
 SET @s = @filename1             
                      
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                
 @RECIPIENTS =@emailto,                                
 @COPY_RECIPIENTS = @emailcc,                                
 @blind_copy_recipients=@emailbcc,                      
 @PROFILE_NAME = 'AngelBroking',                                
 @BODY_FORMAT ='HTML',                                
 @SUBJECT = @sub ,                                
 @FILE_ATTACHMENTS =@s,                                
 @BODY =@MESS                        
      
  update a set Order_Status='Exported',ExportedOn=getdate() from  
  tbl_BONDOrderEntry a,  
  (select * from GSec_NSE_OrderFile)b   
  where   
  /*a.dp=b.dpid and */  
  /*a.applicationno=b.refno and*/  
  a.PAN=b.Pannumber and  
  VerfiedOn= @verifiedon   
  and a.ExportedOn is null and a.Segment='NSE'    
      
  drop table #file    
  END TRY                                
BEGIN CATCH                                
                                                                                           
  insert into Risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                                            
  select GETDATE(),'GSec_NSEFileGeneration',ERROR_LINE(),ERROR_MESSAGE()                                                            
                      
  DECLARE @ErrorMessage NVARCHAR(4000);                   
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                        
  RAISERROR (@ErrorMessage , 16, 1);                                                                                      
                                
END CATCH             
 SET NOCOUNT OFF;               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_Update_status
-- --------------------------------------------------
CREATE procedure [dbo].[GSec_Update_status](@flag as int)                    
as                    
set nocount on                    
BEGIN TRY               
            
 update GSec_Status  set status = @flag     
   
END TRY                                      
BEGIN CATCH                                      
                                      
 insert into risk.dbo.Appln_ERROR (ErrTime,ErrObject,ErrLine,ErrMessage,ApplnName,DBname)                                                              
 select GETDATE(),'GSec_Update_status',ERROR_LINE(),ERROR_MESSAGE(),'Bond',DB_NAME(db_id())                                                              
                            
 DECLARE @ErrorMessage NVARCHAR(4000);                                           
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                            
 RAISERROR (@ErrorMessage , 16, 1);                                 
                                      
END CATCH             
                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_VeriData
-- --------------------------------------------------
CREATE procEDURE [dbo].[GSec_VeriData]                                
as                                                      
                                                      
Set nocount on                                         
SET XACT_ABORT ON                                                   
BEGIN TRY                                                        
                              
/*                                                        
  /* EQUITY */                                                      
  Exec anand.inhouse.dbo.NCMS_POdet                                
  Exec anand1.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse.dbo.NCMS_POdet                                
  Exec angelfo.inhouse_curfo.dbo.NCMS_POdet                                 
  Exec angelcommodity.INHOUSE_MCDCS.dbo.NCMS_POdet                                  
  Exec angelfo.inhouse.dbo.NCMS_POdet_NSEMFSS                                                      
  Exec angelfo.inhouse.dbo.NCMS_POdet_BSEMFSS                                 
                                                        
  /* COMMODITY */                                                      
  Exec angelcommodity.inhouse_NCDX.dbo.NCMS_POdet                                 
  Exec angelcommodity.inhouse_MCDX.dbo.NCMS_POdet                                 
  /* SHORTAGE */                                                      
                                        
  if (Select blkstatus from NCMS_Get_BlockShrtTag with (nolock))='Unblock'                                      
  Begin                                      
 exec ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_CLI                                 
 exec ANGELDEMAT.INHOUSE.DBO.Rpt_Delpayinmatch_CMSPRO_CLI                                 
  End                                      
                              
  exec risk.dbo.Usp_Calc_ShrtVal_cli                                 
 */                              
                                  
  /* NBFC Process */                                                      
  /*                                              
  exec [172.31.16.57].inhouse.dbo.PROC_NBFC_PF_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.PR_NBFC_HOLD_DATA                                                      
  exec [172.31.16.57].inhouse.dbo.NCMS_POdet                                                  
  */                                              
                                                        
  /* FETCH DATA */                                                      
   Create table #Bond_SegwiseCldata (                                                          
   id int,                                              
   ProcessDate datetime,                                              
   Entity varchar(10),                                              
   Segment varchar(10),                                              
   Party_code varchar(10),                                              
   Flag char(1),                                              
   Balance money,                                              
   UnsettledCrBill money,                                              
   UnrecoAmt money,                                              
   ShortSellValue money,                                              
   MarginAmt money,                                              
   Deposit money,                                              
   CashColl money,                                              
   NonCashColl money,                                              
   MarginAdjWithColl money,                                              
   MarginShortage money,                                              
   AccruedCharges money,                                              
   OtherDebit money,                                              
   NonCashConsideration money,                                              
   ExpoUtilised money,                                              
   UnPosted_PO money,                   
   NetPayable money                                          
   )                                                                                                             
                                                
                          
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime,'Equity','BSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from AngelNseCM.inhouse.dbo.GSec_PO                                                     
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select ProcessDatetime,'Equity','NSECM',cltcode,'I',Vbal,UCV,UnrecoCr,0,0,0,0,0,0,0,0,OtherDr,0,0,VBal+OtherDr                                                       
  from AngelNseCM.inhouse.dbo.GSec_PO                                                       
  /* and VBal+UCV+UnRecoCr+OtherDr <> 0 */                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSEFO',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse.dbo.GSec_marh                                                       
  /* and PayoutValue <> 0*/                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','NSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelfo.inhouse_curfo.dbo.GSec_marh                                                       
  /* and PayoutValue <> 0*/                                                    
                                                        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                      
  select UpdDatetime,'Equity','MCD',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                       
  from angelcommodity.INHOUSE_MCDCS.dbo.GSec_marh                                                       
  /* and PayoutValue <> 0*/                                                      
    
     
 insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                 
 select UpdDatetime,'Equity','BSX',Clcode,'I',ledgeramount,-received,UnrecoCr,0,imargin,deposit,cash_coll,non_cash,0,shortage,0,OtherDr,NonCashConsideration,0,PayoutValue-received                                                   
 from angelcommodity.inhouse_bsx.dbo.GSec_marh     
   
   
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                  
 Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                                  
 select processDate,'NBFC','NBFC',party_Code,'I',ActualLedger,Unsettled,0,ShortValHC,0,0,0,VAHC,0,0,AccruedInt,ShortVal,0,0,NetAmount                                               
 from [172.31.16.57].inhouse.dbo.ncms_po  
      
    /************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
    /*Changed in order to consider MTM of cases where there is no ledger added by Neha Naiwar on suggestion from Bhavin Parikh dt: 23th June 2016*/         
        
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSECM' ) and isnull(client_code,'')<>''    
      
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSECM',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSECM > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSECM' ) and isnull(client_code,'')<>''    
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSEFO',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSEFO > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSEFO' ) and isnull(client_code,'')<>''                           
       
  insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','NSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where NSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='NSX' ) and isnull(client_code,'')<>''                                                       
     
   insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','MCD',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where MCD > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='MCD' ) and isnull(client_code,'')<>''     
     
    insert into #Bond_SegwiseCldata(ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,                                                      
  Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable)                                  
  select ProcessDatetime=(select max(ProcessDate) from #Bond_SegwiseCldata),'Equity','BSX',cltcode=client_code,'I',Vbal=0,UCV=0,UnrecoCr=0,0,0,0,0,0,0,0,0,OtherDr=0,0,0,0                                                       
  from cms.dbo.NCMS_LD_View a where BSX > 0   and not exists    
 (select * from #Bond_SegwiseCldata b where a.client_code=b.party_code and segment='BSX' ) and isnull(client_code,'')<>''     
     
/************************************************************************************************************************************************/     
/************************************************************************************************************************************************/     
   /* Unreco amount*/  
   --Changed in order to handle rejection on Nov 02 2016
   update #Bond_SegwiseCldata set UnrecoAmt=0.00  
   update #Bond_SegwiseCldata set UnsettledCrBill=0.00
     
                                                       
  /* Accrured Charges */                           
                                                
  UPDATE a                                                          
  set AccruedCharges=b.AccruedCharges,NetPayable=NetPayable+b.AccruedCharges                                                               
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                             
  (select party_code,segment,AccruedCharges from cms.dbo.NCMS_SegwiseCldata with (nolock) ) b                                              
  ON a.party_code=b.party_Code and a.segment=b.Segment                
  where a.Segment <> 'NBFC'                                               
                
                      
  /* BSECM & NSECM Zero for NBFC Clients */                                                      
                                  
  /*                                                             
  UPDATE a                                                          
  set NetPayable = 0,ShortSellValue=0,Balance=0                                              
  FROM #NCMS_SegwiseCldata a                           
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                               
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
  */                              
                                
  /*---- Only unreco cheque amount of BSECM and NSECM should get deducted from NBFC Net payable */                              
  UPDATE a                                                          
  set NetPayable =  UnrecoAmt+AccruedCharges                                 
  FROM #Bond_SegwiseCldata a                                               
  JOIN                                                          
  (select Party_code from risk.dbo.client_Details where cl_type in ('NBF','TMF')) b                                        
  ON a.party_code=b.party_code and (a.segment = 'BSECM' or a.segment = 'NSECM')                                                       
                                                        
  /* Update Shortage Value */      
   update #Bond_SegwiseCldata set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval from                                                      
(select seg+'CM' as seg,party_code,shrtval=SUM(NetShortValue) from cms.dbo.ncms_shortsell                   
group by seg,party_Code having sum(NetShortValue) <> 0) b                        
 where #Bond_SegwiseCldata.segment=b.seg and #Bond_SegwiseCldata.party_code=b.party_Code     
         
/*                              
  UPDATE a          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
 FROM #NCMS_SegwiseCldata a                                               
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_BSECM_ShrtVal group by party_Code having sum(dedVal) <> 0) b                 
  ON a.segment='BSECM' and a.party_code=b.party_Code                                                      
                                         
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                       
  JOIN                                                          
  (select party_code,shrtval=sum(dedVal) from risk.dbo.Vw_CMSVerified_NSECM_ShrtVal group by party_Code  having sum(dedVal) <> 0) b                                                      
  ON a.segment='NSECM' and a.party_code=b.party_Code                                                      
*/                              
                           
/* Only BOD shortage is considered in verification */                              
/*                  
  UPDATE a                                                          
  set ShortSellValue=-b.shrtval,NetPayable=NetPayable-b.shrtval                                               
  FROM #NCMS_SegwiseCldata a                                               
  JOIN                      
  (                              
 select segment,party_code,Shrtval=ShortSellValue from NCMS_SegwiseCldata with (nolock)                              
 where (SEGMENT='BSECM' OR SEGMENT='NSECM') AND ShortSellValue <> 0                              
  ) B                               
  ON a.segment=B.SEGMENT and a.party_code=b.party_Code                                                       
*/                  
                                                     
                    
/* Reduce LD Data */                    
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.BSECM,NetPayable=NetPayable-b.BSECM                    
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='BSECM'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSECM then 0 else (b.BSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSECM from cms.dbo.NCMS_LD_View where BSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSECM'              
             
 /*            
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSECM,NetPayable=NetPayable-b.NSECM                    
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSECM'                    
 */            
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSECM then 0 else (b.NSECM+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSECM from cms.dbo.NCMS_LD_View where NSECM > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSECM'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSEFO,NetPayable=NetPayable-b.NSEFO                    
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSEFO'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSEFO then 0 else (b.NSEFO+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSEFO from cms.dbo.NCMS_LD_View where NSEFO > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSEFO'              
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.MCD,NetPayable=NetPayable-b.MCD                    
 from(                    
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='MCD'                    
 */            
             
   update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCD then 0 else (b.MCD+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                  
 select client_code,MCD from cms.dbo.NCMS_LD_View where MCD > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCD'              
             
               
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NSX,NetPayable=NetPayable-b.NSX                    
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NSX'              
 */            
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NSX then 0 else (b.NSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NSX from cms.dbo.NCMS_LD_View where NSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NSX'                     
    
    
  update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.BSX then 0 else (b.BSX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,BSX from cms.dbo.NCMS_LD_View where BSX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='BSX'     
     
                   
 /*                   
 update #NCMS_SegwiseCldata set OtherDebit=OtherDebit-b.NCDEX,NetPayable=NetPayable-b.NCDEX                    
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                    
 ) b                     
 where #NCMS_SegwiseCldata.Party_code=b.client_code and #NCMS_SegwiseCldata.Segment='NCDEX'                    
*/                
                
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.NCDEX then 0 else (b.NCDEX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,NCDEX from cms.dbo.NCMS_LD_View where NCDEX > 0                   
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='NCDEX'                    
                    
                    
 update #Bond_SegwiseCldata set OtherDebit=OtherDebit+                
 (Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 ,NetPayable=NetPayable+(Case when #Bond_SegwiseCldata.MArginAmt*-1 > b.MCX then 0 else (b.MCX+#Bond_SegwiseCldata.MArginAmt)*-1 end)                
 from(                    
 select client_code,MCX from cms.dbo.NCMS_LD_View where MCX > 0                    
 ) b                     
 where #Bond_SegwiseCldata.Party_code=b.client_code and #Bond_SegwiseCldata.Segment='MCX'                    
  /* Insert into History table*/                  
 insert into GSec_SegVeriData_hist(POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,                      
 MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO)                      
 select POrequestID,id,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,MarginAdjWithColl,MarginShortage,                      
 AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                      
 from GSec_SegVeriData with (nolock)   
                    
  truncate table GSec_SegVeriData                          
  insert into GSec_SegVeriData                                            
  (                                            
  POrequestID,ProcessDate,Entity,Segment,Party_code,Flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,NonCashColl,                                            
  MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                          
  )                                              
  select   /*ROW_NUMBER() OVER ( ORDER BY party_code,segment) AS refno,*/                            
  convert(varchar(6),getdate(),112)+replace(convert(varchar(8),getdate(),108),':','') AS refno,                            
  ProcessDate,Entity,Segment,Party_code,flag,Balance,UnsettledCrBill,UnrecoAmt,ShortSellValue,MarginAmt,Deposit,CashColl,                                            
  NonCashColl,MarginAdjWithColl,MarginShortage,AccruedCharges,OtherDebit,NonCashConsideration,ExpoUtilised,NetPayable,UnPosted_PO                                             
  from #Bond_SegwiseCldata                                               
                                   
                                            
End try                       
                                                
BEGIN CATCH                                                        
   
 insert into risk.dbo.Appln_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)         
 select GETDATE(),'GSec_VeriData',ERROR_LINE(),ERROR_MESSAGE()                                                           
                                
 DECLARE @ErrorMessage NVARCHAR(4000);                                                              
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                              
 RAISERROR (@ErrorMessage , 16, 1);                                    
                                                     
End catch                                                    
                                                      
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PGTxnSMS
-- --------------------------------------------------

CREATE proc [dbo].[PGTxnSMS]
 @clientName varchar(300)='', @LoginUser  varchar(300)='', @emailTxnAmount  varchar(500)='', 
 @emailBankRefNo  varchar(300)='', @clientMobileNo varchar(300)=''
As

BEGIN

	DECLARE @SMSText VARCHAR(500)=''
	
	SET @SMSText =''

	If isnull(@clientMobileNo ,'')<>''

	BEGIN
 		 
		INSERT INTO [Mimansa].[GENERAL].[dbo].[tbl_smsQueue] ([SentFrom], [ServiceName], [MobileNo], [Message], [DeliveryAckRequired], [TransmissionTime], [SMSSentStatus], [TokenID], [MessageType], [IsTransactionalSMS], [IsDNDNumber])

		VALUES ('AngelInHouse', 'Bond_OTP', @clientMobileNo, @SMSText , 'N', getdate(), 'N', NEWID(), 'NORMAL', 'Y', 'N')
		
		SELECT 1 AS Result
		 
	END

	ELSE

	BEGIN

		SELECT 0 AS Result

	END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Report_Rpt_Bond_orderbook_OCV
-- --------------------------------------------------
CREATE PROC Report_Rpt_Bond_orderbook_OCV
@Client_Code varchar (20)

As
begin

		SELECT EntryId, BOND_Name, Client_Code, ClientName, Order_Status, Order_Qty,cast((RATE) as decimal(16,2)) as Rate, 
		Segment ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason FROM
		(select * from tbl_BONDOrderEntry with(nolock) where Order_Date >= CONVERT(date , getdate()) ) a
		INNER JOIN (SELECT a.PARTY_CODE,a.LONG_NAME, 
		BRANCH_CD = (CASE WHEN a.BRANCH_CD IN ('NRIS','CALNT') THEN a.ORI_BRANCH_CD ELSE a.BRANCH_CD END), 
		SUB_BROKER = (CASE WHEN a.SUB_BROKER IN ('NRIS','CALNT') THEN a.ORI_SUB_BROKER ELSE a.SUB_BROKER END) 
		,a.[b2c] 
		FROM risk.DBO.CLIENT_DETAILS a with(nolock) 
		JOIN [196.1.115.200].BSEMFSS.DBO.MFSS_CLIENT b with(nolock) 
		on a.cl_code = b.party_code
		where (b.INACTIVE_FROM > getdate() OR b.INACTIVE_FROM Is NULL)) b on 
		Client_Code=@Client_Code and a.Client_Code = b.party_code where CONVERT(date,a.Order_Date) >= CONVERT(date , getdate())
		order by a.Order_Date desc

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Report_Rpt_BondUtility_OCV
-- --------------------------------------------------
CREATE PROC Report_Rpt_BondUtility_OCV
@viewtype varchar (20)

As
begin

			if  @viewtype='OpenBondList'
			begin
			SELECT Srno as 'srNo', SchemeName as 'bondName',Symbol as 'symbol', series as 'bondSeries',
			 cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'bondRate', MaxQty as 'maxQty', 
			 DATEADD(hh,9,DATEDIFF(dd,0,Startdate)) as 'openDate', DATEADD(hh,17,DATEDIFF(dd,0,Enddate)) as 'closeDate'
			 FROM tbl_BondMaster WHERE getdate() BETWEEN Startdate AND Enddate 
			end

			if  @viewtype='ForthComingBondList'
			begin
			SELECT Srno as 'srNo', SchemeName as 'bondName',Symbol as 'symbol', series as 'bondSeries',
			cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'bondRate', MaxQty as 'maxQty',  
			 DATEADD(hh,9,DATEDIFF(dd,0,Startdate)) as 'openDate', DATEADD(hh,17,DATEDIFF(dd,0,Enddate)) as 'closeDate' 
			FROM tbl_BondMaster WHERE getdate() < Startdate
			end

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_Bond_Master
-- --------------------------------------------------

-- Author:  Neha Naiwar    
-- Create date: 07/10/2021    
-- Description: Bond Master  
-- =============================================    
create Proc SP_Bond_Master(@bond_srno as varchar(100)=null,@Symbol as varchar(100) = null)
as
Begin
	select * from tbl_BondMaster with(nolock) order by Srno desc
	
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_findstring
-- --------------------------------------------------
CREATE procedure [dbo].[sp_findstring]    

@string varchar(max)    

as    

begin    

select distinct A.name  from sys.objects A    

inner join sys .syscomments B    

on A.object_id=B.id    

where CHARINDEX (@string,B.text)>0    

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_generate_inserts
-- --------------------------------------------------
    
    
CREATE proc [dbo].[sp_generate_inserts]    
(    
 @table_name varchar(776),    -- The table/view for which the INSERT statements will be generated using the existing data    
 @target_table varchar(776) = NULL,  -- Use this parameter to specify a different table name into which the data will be inserted    
 @include_column_list bit = 1,  -- Use this parameter to include/ommit column list in the generated INSERT statement    
 @from varchar(800) = NULL,   -- Use this parameter to filter the rows based on a filter condition (using WHERE)    
 @include_timestamp bit = 0,   -- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement    
 @debug_mode bit = 0,   -- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination    
 @owner varchar(64) = NULL,  -- Use this parameter if you are not the owner of the table    
 @ommit_images bit = 0,   -- Use this parameter to generate INSERT statements by omitting the 'image' columns    
 @ommit_identity bit = 0,  -- Use this parameter to ommit the identity columns    
 @top int = NULL,   -- Use this parameter to generate INSERT statements only for the TOP n rows    
 @cols_to_include varchar(8000) = NULL, -- List of columns to be included in the INSERT statement    
 @cols_to_exclude varchar(8000) = NULL, -- List of columns to be excluded from the INSERT statement    
 @disable_constraints bit = 0,  -- When 1, disables foreign key constraints and enables them after the INSERT statements    
 @ommit_computed_cols bit = 0  -- When 1, computed columns will not be included in the INSERT statement    
     
)    
AS    
BEGIN    
    
/***********************************************************************************************************    
Procedure: sp_generate_inserts  (Build 22)     
  (Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.)    
                                              
Purpose: To generate INSERT statements from existing data.     
  These INSERTS can be executed to regenerate the data at some other location.    
  This procedure is also useful to create a database setup, where in you can     
  script your data along with your table definitions.    
    
Written by: Narayana Vyas Kondreddi    
         http://vyaskn.tripod.com    
    
Acknowledgements:    
  Divya Kalra -- For beta testing    
  Mark Charsley -- For reporting a problem with scripting uniqueidentifier columns with NULL values    
  Artur Zeygman -- For helping me simplify a bit of code for handling non-dbo owned tables    
  Joris Laperre   -- For reporting a regression bug in handling text/ntext columns    
    
Tested on:  SQL Server 7.0 and SQL Server 2000    
    
Date created: January 17th 2001 21:52 GMT    
    
Date modified: May 1st 2002 19:50 GMT    
    
Email:   vyaskn@hotmail.com    
    
NOTE:  This procedure may not work with tables with too many columns.    
  Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types    
  Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results    
  IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed    
  you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts    
  like nchar and nvarchar    
      
    
Example 1: To generate INSERT statements for table 'titles':    
      
  EXEC sp_generate_inserts 'titles'    
    
Example 2:  To ommit the column list in the INSERT statement: (Column list is included by default)    
  IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,    
  to avoid erroneous results    
      
  EXEC sp_generate_inserts 'titles', @include_column_list = 0    
    
Example 3: To generate INSERT statements for 'titlesCopy' table from 'titles' table:    
    
  EXEC sp_generate_inserts 'titles', 'titlesCopy'    
    
Example 4: To generate INSERT statements for 'titles' table for only those titles     
  which contain the word 'Computer' in them:    
  NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter    
    
  EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"    
    
Example 5:  To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:    
  (By default TIMESTAMP column's data is not scripted)    
    
  EXEC sp_generate_inserts 'titles', @include_timestamp = 1    
    
Example 6: To print the debug information:    
      
  EXEC sp_generate_inserts 'titles', @debug_mode = 1    
    
Example 7:  If you are not the owner of the table, use @owner parameter to specify the owner name    
  To use this option, you must have SELECT permissions on that table    
    
  EXEC sp_generate_inserts Nickstable, @owner = 'Nick'    
    
Example 8:  To generate INSERT statements for the rest of the columns excluding images    
  When using this otion, DO NOT set @include_column_list parameter to 0.    
    
  EXEC sp_generate_inserts imgtable, @ommit_images = 1    
    
Example 9:  To generate INSERT statements excluding (ommiting) IDENTITY columns:    
  (By default IDENTITY columns are included in the INSERT statement)    
    
  EXEC sp_generate_inserts mytable, @ommit_identity = 1    
    
Example 10:  To generate INSERT statements for the TOP 10 rows in the table:    
      
  EXEC sp_generate_inserts mytable, @top = 10    
    
Example 11:  To generate INSERT statements with only those columns you want:    
      
  EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"    
    
Example 12:  To generate INSERT statements by omitting certain columns:    
      
  EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"    
    
Example 13: To avoid checking the foreign key constraints while loading data with INSERT statements:    
      
  EXEC sp_generate_inserts titles, @disable_constraints = 1    
    
Example 14:  To exclude computed columns from the INSERT statement:    
  EXEC sp_generate_inserts MyTable, @ommit_computed_cols = 1    
***********************************************************************************************************/    
    
SET NOCOUNT ON    
    
--Making sure user only uses either @cols_to_include or @cols_to_exclude    
IF ((@cols_to_include IS NOT NULL) AND (@cols_to_exclude IS NOT NULL))    
 BEGIN    
  RAISERROR('Use either @cols_to_include or @cols_to_exclude. Do not use both the parameters at once',16,1)    
  RETURN -1 --Failure. Reason: Both @cols_to_include and @cols_to_exclude parameters are specified    
 END    
    
--Making sure the @cols_to_include and @cols_to_exclude parameters are receiving values in proper format    
IF ((@cols_to_include IS NOT NULL) AND (PATINDEX('''%''',@cols_to_include) = 0))    
 BEGIN    
  RAISERROR('Invalid use of @cols_to_include property',16,1)    
  PRINT 'Specify column names surrounded by single quotes and separated by commas'    
  PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_include = "''title_id'',''title''"'    
  RETURN -1 --Failure. Reason: Invalid use of @cols_to_include property    
 END    
    
IF ((@cols_to_exclude IS NOT NULL) AND (PATINDEX('''%''',@cols_to_exclude) = 0))    
 BEGIN    
  RAISERROR('Invalid use of @cols_to_exclude property',16,1)    
  PRINT 'Specify column names surrounded by single quotes and separated by commas'    
  PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_exclude = "''title_id'',''title''"'    
  RETURN -1 --Failure. Reason: Invalid use of @cols_to_exclude property    
 END    
    
    
--Checking to see if the database name is specified along wih the table name    
--Your database context should be local to the table for which you want to generate INSERT statements    
--specifying the database name is not allowed    
IF (PARSENAME(@table_name,3)) IS NOT NULL    
 BEGIN    
  RAISERROR('Do not specify the database name. Be in the required database and just specify the table name.',16,1)    
  RETURN -1 --Failure. Reason: Database name is specified along with the table name, which is not allowed    
 END    
    
--Checking for the existence of 'user table' or 'view'    
--This procedure is not written to work on system tables    
--To script the data in system tables, just create a view on the system tables and script the view instead    
    
IF @owner IS NULL    
 BEGIN    
  IF ((OBJECT_ID(@table_name,'U') IS NULL) AND (OBJECT_ID(@table_name,'V') IS NULL))     
   BEGIN    
    RAISERROR('User table or view not found.',16,1)    
    PRINT 'You may see this error, if you are not the owner of this table or view. In that case use @owner parameter to specify the owner name.'    
    PRINT 'Make sure you have SELECT permission on that table or view.'    
    RETURN -1 --Failure. Reason: There is no user table or view with this name    
   END    
 END    
ELSE    
 BEGIN    
  IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND (TABLE_TYPE = 'BASE TABLE' OR TABLE_TYPE = 'VIEW') AND TABLE_SCHEMA = @owner)    
   BEGIN    
    RAISERROR('User table or view not found.',16,1)    
    PRINT 'You may see this error, if you are not the owner of this table. In that case use @owner parameter to specify the owner name.'    
    PRINT 'Make sure you have SELECT permission on that table or view.'    
    RETURN -1 --Failure. Reason: There is no user table or view with this name      
   END    
 END    
    
--Variable declarations    
DECLARE  @Column_ID int,       
  @Column_List varchar(8000),     
  @Column_Name varchar(128),     
  @Start_Insert varchar(786),     
  @Data_Type varchar(128),     
  @Actual_Values varchar(8000), --This is the string that will be finally executed to generate INSERT statements    
  @IDN varchar(128)  --Will contain the IDENTITY column's name in the table    
    
--Variable Initialization    
SET @IDN = ''    
SET @Column_ID = 0    
SET @Column_Name = ''    
SET @Column_List = ''    
SET @Actual_Values = ''    
    
IF @owner IS NULL     
 BEGIN    
  SET @Start_Insert = 'INSERT INTO ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']'     
 END    
ELSE    
 BEGIN    
  SET @Start_Insert = 'INSERT ' + '[' + LTRIM(RTRIM(@owner)) + '].' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']'       
 END    
    
    
--To get the first column's ID    
    
SELECT @Column_ID = MIN(ORDINAL_POSITION)      
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
WHERE  TABLE_NAME = @table_name AND    
(@owner IS NULL OR TABLE_SCHEMA = @owner)    
    
    
    
--Loop through all the columns of the table, to get the column names and their data types    
WHILE @Column_ID IS NOT NULL    
 BEGIN    
  SELECT  @Column_Name = QUOTENAME(COLUMN_NAME),     
  @Data_Type = DATA_TYPE     
  FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
  WHERE  ORDINAL_POSITION = @Column_ID AND     
  TABLE_NAME = @table_name AND    
  (@owner IS NULL OR TABLE_SCHEMA = @owner)    
    
    
    
  IF @cols_to_include IS NOT NULL --Selecting only user specified columns    
  BEGIN    
   IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_include) = 0     
   BEGIN    
    GOTO SKIP_LOOP    
   END    
  END    
    
  IF @cols_to_exclude IS NOT NULL --Selecting only user specified columns    
  BEGIN    
   IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_exclude) <> 0     
   BEGIN    
    GOTO SKIP_LOOP    
   END    
  END    
    
  --Making sure to output SET IDENTITY_INSERT ON/OFF in case the table has an IDENTITY column    
  IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsIdentity')) = 1     
  BEGIN    
   IF @ommit_identity = 0 --Determing whether to include or exclude the IDENTITY column    
    SET @IDN = @Column_Name    
   ELSE    
    GOTO SKIP_LOOP       
  END    
      
  --Making sure whether to output computed columns or not    
  IF @ommit_computed_cols = 1    
  BEGIN    
   IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsComputed')) = 1     
   BEGIN    
    GOTO SKIP_LOOP         
   END    
  END    
      
  --Tables with columns of IMAGE data type are not supported for obvious reasons    
  IF(@Data_Type in ('image'))    
   BEGIN    
    IF (@ommit_images = 0)    
     BEGIN    
      RAISERROR('Tables with image columns are not supported.',16,1)    
      PRINT 'Use @ommit_images = 1 parameter to generate INSERTs for the rest of the columns.'    
      PRINT 'DO NOT ommit Column List in the INSERT statements. If you ommit column list using @include_column_list=0, the generated INSERTs will fail.'    
      RETURN -1 --Failure. Reason: There is a column with image data type    
     END    
    ELSE    
     BEGIN    
     GOTO SKIP_LOOP    
     END    
   END    
    
  --Determining the data type of the column and depending on the data type, the VALUES part of    
  --the INSERT statement is generated. Care is taken to handle columns with NULL values. Also    
  --making sure, not to lose any data from flot, real, money, smallmomey, datetime columns    
  SET @Actual_Values = @Actual_Values  +    
  CASE     
   WHEN @Data_Type IN ('char','varchar','nchar','nvarchar')     
    THEN     
     'COALESCE('''''''' + REPLACE(RTRIM(' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'    
   WHEN @Data_Type IN ('datetime','smalldatetime')     
    THEN     
     'COALESCE('''''''' + RTRIM(CONVERT(char,' + @Column_Name + ',109))+'''''''',''NULL'')'    
   WHEN @Data_Type IN ('uniqueidentifier')     
    THEN      
     'COALESCE('''''''' + REPLACE(CONVERT(char(255),RTRIM(' + @Column_Name + ')),'''''''','''''''''''')+'''''''',''NULL'')'    
   WHEN @Data_Type IN ('text','ntext')     
    THEN      
     'COALESCE('''''''' + REPLACE(CONVERT(char(8000),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'         
   WHEN @Data_Type IN ('binary','varbinary')     
    THEN      
     'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'      
   WHEN @Data_Type IN ('timestamp','rowversion')     
    THEN      
     CASE     
      WHEN @include_timestamp = 0     
       THEN     
        '''DEFAULT'''     
       ELSE     
        'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'      
     END    
   WHEN @Data_Type IN ('float','real','money','smallmoney')    
    THEN    
     'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ',2)' + ')),''NULL'')'     
   ELSE     
    'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ')' + ')),''NULL'')'     
  END   + '+' +  ''',''' + ' + '    
      
  --Generating the column list for the INSERT statement    
  SET @Column_List = @Column_List +  @Column_Name + ','     
    
  SKIP_LOOP: --The label used in GOTO    
    
  SELECT  @Column_ID = MIN(ORDINAL_POSITION)     
  FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
  WHERE  TABLE_NAME = @table_name AND     
  ORDINAL_POSITION > @Column_ID AND    
  (@owner IS NULL OR TABLE_SCHEMA = @owner)    
    
    
 --Loop ends here!    
 END    
    
--To get rid of the extra characters that got concatenated during the last run through the loop    
SET @Column_List = LEFT(@Column_List,len(@Column_List) - 1)    
SET @Actual_Values = LEFT(@Actual_Values,len(@Actual_Values) - 6)    
    
IF LTRIM(@Column_List) = ''     
 BEGIN    
  RAISERROR('No columns to select. There should at least be one column to generate the output',16,1)    
  RETURN -1 --Failure. Reason: Looks like all the columns are ommitted using the @cols_to_exclude parameter    
 END    
    
--Forming the final string that will be executed, to output the INSERT statements    
IF (@include_column_list <> 0)    
 BEGIN    
  SET @Actual_Values =     
   'SELECT ' +      
   CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END +     
   '''' + RTRIM(@Start_Insert) +     
   ' ''+' + '''(' + RTRIM(@Column_List) +  '''+' + ''')''' +     
   ' +''VALUES(''+ ' +  @Actual_Values  + '+'')''' + ' ' +     
   COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')    
 END    
ELSE IF (@include_column_list = 0)    
 BEGIN    
  SET @Actual_Values =     
   'SELECT ' +     
   CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END +     
   '''' + RTRIM(@Start_Insert) +     
   ' '' +''VALUES(''+ ' +  @Actual_Values + '+'')''' + ' ' +     
   COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')    
 END     
    
--Determining whether to ouput any debug information    
IF @debug_mode =1    
 BEGIN    
  PRINT '/*****START OF DEBUG INFORMATION*****'    
  PRINT 'Beginning of the INSERT statement:'    
  PRINT @Start_Insert    
  PRINT ''    
  PRINT 'The column list:'    
  PRINT @Column_List    
  PRINT ''    
  PRINT 'The SELECT statement executed to generate the INSERTs'    
  PRINT @Actual_Values    
  PRINT ''    
  PRINT '*****END OF DEBUG INFORMATION*****/'    
  PRINT ''    
 END    
      
PRINT '--INSERTs generated by ''sp_generate_inserts'' stored procedure written by Vyas'    
PRINT '--Build number: 22'    
PRINT '--Problems/Suggestions? Contact Vyas @ vyaskn@hotmail.com'    
PRINT '--http://vyaskn.tripod.com'    
PRINT ''    
PRINT 'SET NOCOUNT ON'    
PRINT ''    
    
    
--Determining whether to print IDENTITY_INSERT or not    
IF (@IDN <> '')    
 BEGIN    
  PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' ON'    
  PRINT 'GO'    
  PRINT ''    
 END    
    
    
IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)    
 BEGIN    
  IF @owner IS NULL    
   BEGIN    
    SELECT  'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'    
   END    
  ELSE    
   BEGIN    
    SELECT  'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'    
   END    
    
  PRINT 'GO'    
 END    
    
PRINT ''    
PRINT 'PRINT ''Inserting values into ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ''''    
    
    
--All the hard work pays off here!!! You'll get your INSERT statements, when the next line executes!    
EXEC (@Actual_Values)    
    
PRINT 'PRINT ''Done'''    
PRINT ''    
    
    
IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)    
 BEGIN    
  IF @owner IS NULL    
   BEGIN    
    SELECT  'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL'  AS '--Code to enable the previously disabled constraints'    
   END    
  ELSE    
   BEGIN    
    SELECT  'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'    
   END    
    
  PRINT 'GO'    
 END    
    
PRINT ''    
IF (@IDN <> '')    
 BEGIN    
  PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' OFF'    
  PRINT 'GO'    
 END    
    
PRINT 'SET NOCOUNT OFF'    
    
    
SET NOCOUNT OFF    
RETURN 0 --Success. We are done!    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_FILEUPLOADMASTER
-- --------------------------------------------------
CREATE procEDURE [dbo].[USP_BOND_FILEUPLOADMASTER]  
(  
@FILETYPE AS VARCHAR(100),  
@VAR_FILENAME AS VARCHAR(200), 
@Bond_id AS VARCHAR(200),  
@Segment AS VARCHAR(200),   
@FILEGUIDNAME AS VARCHAR(200),  
@FILEPATH AS VARCHAR(400),  
@CONCATDIV AS VARCHAR(20),  
@UPLOADED_BY_USERNAME AS VARCHAR(50),  
@UPLOADED_BY_ACCESS_CODE AS VARCHAR(50)  
)  
AS  
BEGIN  
INSERT INTO TBL_Bond_FILEUPLOADMASTER(FILETYPE,VAR_FILENAME,FILEGUIDNAME,FILEPATH,UPLOADED_BY_USERNAME,UPLOADED_BY_ACCESS_CODE,UPLOADED_ON,REMARKS,bond_id,segment)  
SELECT @FILETYPE,@VAR_FILENAME,@FILEGUIDNAME, @FILEPATH,@UPLOADED_BY_USERNAME,@UPLOADED_BY_ACCESS_CODE,GETDATE(),@CONCATDIV,@Bond_id,@Segment   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Bond_GETALLUPLOADEDFILES
-- --------------------------------------------------
CREATE procEDURE [dbo].[USP_Bond_GETALLUPLOADEDFILES]      
AS      
BEGIN      
SELECT DISTINCT T.FILETYPE,VAR_FILENAME,FILEGUIDNAME,T.REMARKS,CONVERT(VARCHAR,T.UPLOADED_ON,100) AS 'UPLOADED_ON', ISNULL(E.EMP_NAME,'') AS 'EMP_NAME',Segment  
FROM     
(    
SELECT ROW_NUMBER()OVER(PARTITION BY FILETYPE ORDER BY (UPLOADED_ON) DESC) AS 'SRNO', *     
FROM TBL_Bond_FILEUPLOADMASTER    
)T      
LEFT JOIN      
risk.dbo.EMP_INFO E ON T.UPLOADED_BY_USERNAME = E.EMP_NO      
WHERE T.SRNO = 1    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT
-- --------------------------------------------------


CREATE proc [dbo].[USP_BOND_GETCLIENTLIMIT]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

   SELECT ISNULL(@CLIENTLIMIT,0)  AS ClientLimit

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT_07Jun2020
-- --------------------------------------------------


create proc [dbo].[USP_BOND_GETCLIENTLIMIT_07Jun2020]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

   SELECT ISNULL(@CLIENTLIMIT,0)  AS ClientLimit

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT_Bkp07Jun2020
-- --------------------------------------------------

CREATE proc [dbo].[USP_BOND_GETCLIENTLIMIT_Bkp07Jun2020]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

   SELECT ISNULL(@CLIENTLIMIT,0)  AS ClientLimit

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT_IPartner
-- --------------------------------------------------

--select sdtcur=sdtcur from risk.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()     


--EXEC [USP_BOND_GETCLIENTLIMIT_Ipartner] 'S145224'
--EXEC [USP_BOND_GETCLIENTLIMIT_Ipartner] 'P94439'


CREATE proc [dbo].[USP_BOND_GETCLIENTLIMIT_IPartner]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

--Declare @FromDate Date 
--Declare @Today Date =convert(date,Getdate())

--select @FromDate =sdtcur from risk.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()     

--Create table #Final
--(
--Exchangesegment	varchar(100)
--,CltCode		varchar(100)
--,Vdt	date
--,Particulars 	varchar(500)	
--,Debit	numeric(10,2)
--,Credit	numeric(10,2)
--,Balance numeric(10,2)
--)
--Insert into #Final
--EXEC [Mimansa].General.dbo.PartySingleLedgerBBGWithDate @CLIENTCODE,'',@FromDate,@Today

--select top 1 @CLIENTLIMIT=Balance from #Final order by Vdt desc


   SELECT ISNULL(@CLIENTLIMIT,0)  AS ClientLimit
   
--drop table #Final

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT_Ipartner_bkp10july2020
-- --------------------------------------------------

--select sdtcur=sdtcur from risk.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()     


--EXEC [USP_BOND_GETCLIENTLIMIT_Ipartner] 'S145224'
--EXEC [USP_BOND_GETCLIENTLIMIT_Ipartner] 'P94439'


CREATE proc [dbo].[USP_BOND_GETCLIENTLIMIT_Ipartner_bkp10july2020]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

--Declare @FromDate Date 
--Declare @Today Date =convert(date,Getdate())

--select @FromDate =sdtcur from risk.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()     

--Create table #Final
--(
--Exchangesegment	varchar(100)
--,CltCode		varchar(100)
--,Vdt	date
--,Particulars 	varchar(500)	
--,Debit	numeric(10,2)
--,Credit	numeric(10,2)
--,Balance numeric(10,2)
--)
--Insert into #Final
--EXEC [196.1.115.207].General.dbo.PartySingleLedgerBBGWithDate @CLIENTCODE,'',@FromDate,@Today

--select top 1 @CLIENTLIMIT=Balance from #Final order by Vdt desc


   SELECT ISNULL(@CLIENTLIMIT,0)  AS ClientLimit
   
--drop table #Final

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT_IPartner_Bkp2020June07
-- --------------------------------------------------

CREATE proc [dbo].[USP_BOND_GETCLIENTLIMIT_IPartner_Bkp2020June07]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

   SELECT ISNULL(@CLIENTLIMIT,0)  AS ClientLimit

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_GETCLIENTLIMIT_Ipartner_New
-- --------------------------------------------------

--select sdtcur=sdtcur from risk.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()     


--EXEC [USP_BOND_GETCLIENTLIMIT_Ipartner_New] 'S145224'
--EXEC [USP_BOND_GETCLIENTLIMIT_Ipartner] 'P94439'


CREATE proc [dbo].[USP_BOND_GETCLIENTLIMIT_Ipartner_New]
@CLIENTCODE AS VARCHAR(50)='',
@SRNO AS VARCHAR(50)=''
AS BEGIN

 DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
exec BondLimit @clientcode,@CLIENTLIMIT out

Declare @FromDate Date 
Declare @Today Date =convert(date,Getdate())

select @FromDate =sdtcur from risk.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()     

Create table #Final
(
Exchangesegment	varchar(100)
,CltCode		varchar(100)
,Vdt	date
,Particulars 	varchar(500)	
,Debit	numeric(10,2)
,Credit	numeric(10,2)
,Balance numeric(10,2)
)
Insert into #Final
EXEC [Mimansa].General.dbo.PartySingleLedgerBBGWithDate @CLIENTCODE,'',@FromDate,@Today

select top 1 @CLIENTLIMIT=Balance from #Final order by Vdt desc


   SELECT ISNULL(@CLIENTLIMIT,0)*-1  AS ClientLimit
   
--drop table #Final

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Bond_master
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj Patil
-- Create date: 15072016
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[USP_Bond_master]
	    @process as varchar(100),
	    @SchemeName as varchar(100)='',
        @Symbol as varchar(100)='',
        @Rate as varchar(100)='',
        @Startdate as varchar(100)='',
        @Enddate as varchar(100)='',
        @MinQty as varchar(100)='',
        @MaxQty as varchar(100)='',
        @MaxValue as varchar(100)='',
        @series as varchar(100)='',
        @CreatedBy as varchar(100)='',
        @CreatedOn as varchar(100)='',
        @UpdatedBy as varchar(100)='',
        @Updatedon as varchar(100)=''
AS
BEGIN
	if @process = 'insert'
	begin
    	
	    declare @cnt as int
	    set @cnt = 0
	    select @cnt=COUNT(1) from BondMaster where SchemeName = @SchemeName
	    if @cnt = 0
	    begin
	        insert into tbl_BondMaster([SchemeName],[Symbol],[series],[Rate],[Startdate] ,[Enddate],[MinQty],[MaxQty],[MaxValue],[CreatedBy],[CreatedOn],[UpdatedBy],[Updatedon])
	        values(@SchemeName,@Symbol,@series,@Rate,@Startdate,@Enddate,@MinQty,@MaxQty,@MaxValue,@CreatedBy,GETDATE(),@UpdatedBy,'')
	        select 1
	    end
	    else
	    begin
	        select 0
	    end
	end
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK
-- --------------------------------------------------

--[USP_BOND_ORDERBOOK]'','E67172','E67172','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E67515','E67515','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E59646','E59646','BROKER'     
--dbo.[USP_BOND_ORDERBOOK]'','e10398','CSO','BROKER'    
--[USP_BOND_ORDERBOOK]'','fb','fb','BROKER'    
CREATE procedure [dbo].[USP_BOND_ORDERBOOK]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
Declare @prefix varchar(max),@postfix varchar(max),@prepost varchar(max)                              
Declare @STR AS VARCHAR(max),@CONDITION AS VARCHAR(max),@Type AS VARCHAR(50)                                                                                                                                                    
                            
set @CONDITION = ISNULL(RISK.DBO.FN_MFSS_ACCESS_TO(@access_to,@access_code),'')  
print @CONDITION                          
                          
IF OBJECT_ID('TempDB..##PARTY_MIMANSA') IS NOT NULL                                            
DROP TABLE ##PARTY_MIMANSA                            
CREATE TABLE ##PARTY_MIMANSA                                          
(                                
   CLIENTCODE VARCHAR(30),                          
   CLIENTNAME VARCHAR(MAX)                          
)                                
                          
--INSERT INTO ##PARTY_MIMANSA                                        
--EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
                            
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                                     
BEGIN                                                      
 SET @CONDITION=''                              
 SET @TYPE='CRMS'                                    
END                                  
ELSE                              
BEGIN                              
 SET @TYPE='INHOUSE'                              
 SET @CONDITION=@CONDITION--+'and A.USERTYPE=''INHOUSE'' '                              
END                       
If(@Type='CRMS')            
BEGIN    
                                  
INSERT INTO ##PARTY_MIMANSA                                        
EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
  
            
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],a.ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate, cast((Total) as  decimal(16,2)) as [Total Amount],Segment 
  
            AS [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  , case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status]
            FROM ##PARTY_MIMANSA PARTY                            
            INNER join (select * from tbl_BONDOrderEntry with(nolock) where Order_Date > ''01-Oct-2017'' and bond_srno>=50) a on party.CLIENTCODE=a.Client_Code order by a.Order_Date desc'       
End               
ELSE    
BEGIN    
print 'hi'
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  ,case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status] 
            FROM (select * from tbl_BONDOrderEntry with(nolock) where Order_Date > ''01-Oct-2017'' and bond_srno>=60) a                            
            left outer join /*INNER JOIN  INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS*/ /*INTRANET.RISK.DBO.vw_Bond_MFSS_client_details*/
            RISK.DBO.client_details b WITH (NOLOCK)
             on a.Client_Code=b.party_code and '+ @CONDITION +' order by a.Order_Date desc'                                                                                           
    
END   
print (@str )  
Exec (@str ) 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK_07Aug2020
-- --------------------------------------------------
--[USP_BOND_ORDERBOOK]'','E67172','E67172','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E67515','E67515','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E59646','E59646','BROKER'     
--dbo.[USP_BOND_ORDERBOOK]'','e10398','CSO','BROKER'    
--[USP_BOND_ORDERBOOK]'','fb','fb','BROKER'    
create procedure [dbo].[USP_BOND_ORDERBOOK_07Aug2020]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
Declare @prefix varchar(max),@postfix varchar(max),@prepost varchar(max)                              
Declare @STR AS VARCHAR(max),@CONDITION AS VARCHAR(max),@Type AS VARCHAR(50)                                                                                                                                                    
                            
set @CONDITION = ISNULL(RISK.DBO.FN_MFSS_ACCESS_TO(@access_to,@access_code),'')  
print @CONDITION                          
                          
IF OBJECT_ID('TempDB..##PARTY_MIMANSA') IS NOT NULL                                            
DROP TABLE ##PARTY_MIMANSA                            
CREATE TABLE ##PARTY_MIMANSA                                          
(                                
   CLIENTCODE VARCHAR(30),                          
   CLIENTNAME VARCHAR(MAX)                          
)                                
                          
INSERT INTO ##PARTY_MIMANSA                                        
EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
                            
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                                     
BEGIN                                                      
 SET @CONDITION=''                              
 SET @TYPE='CRMS'                                    
END                                  
ELSE                              
BEGIN                              
 SET @TYPE='INHOUSE'                              
 SET @CONDITION=@CONDITION--+'and A.USERTYPE=''INHOUSE'' '                              
END                       
If(@Type='CRMS')            
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],a.ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate, cast((Total) as  decimal(16,2)) as [Total Amount],Segment 
  
            AS [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  , case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status]
            FROM ##PARTY_MIMANSA PARTY                            
            INNER join (select * from tbl_BONDOrderEntry with(nolock) where Order_Date > ''01-Oct-2017'') a on party.CLIENTCODE=a.Client_Code order by a.Order_Date desc'       
End               
ELSE    
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  ,case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status] 
            FROM (select * from tbl_BONDOrderEntry where Order_Date > ''01-Oct-2017'') a                            
            INNER JOIN  /*INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS*/ INTRANET.RISK.DBO.vw_Bond_MFSS_client_details b WITH (NOLOCK) on a.Client_Code=b.party_code and '+ @CONDITION +' order by a.Order_Date desc'                                                                                           
    
END   
print (@str )  
Exec (@str ) 
--bol ok bhari..test keli ahen ka?
--change ka keli kahi issue hota ka
--give me ur number 8108775272  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK_18072016
-- --------------------------------------------------

--[USP_BOND_ORDERBOOK]'','E67172','E67172','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E67515','E67515','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E59646','E59646','BROKER'     
--dbo.[USP_BOND_ORDERBOOK]'','e10398','CSO','BROKER'    
--[USP_BOND_ORDERBOOK]'','fb','fb','BROKER'    
CREATE procedure [dbo].[USP_BOND_ORDERBOOK_18072016]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS
BEGIN

        if @Process = 'BONDORDERBOOK'
        begin 
            SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')   
            FROM tbl_BONDOrderEntry where access_to = @access_to and  access_code = @access_code 

        end

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK_ABMA_APP
-- --------------------------------------------------


 

   
--[USP_BOND_ORDERBOOK_ABMA_APP]'18/07/2016','18/07/2016','H32795' 
CREATE procedure [dbo].[USP_BOND_ORDERBOOK_ABMA_APP]    
 @entryid int=0,@FromDate varchar(30)=null,@ToDate varchar(30)=null,@clientcode varchar(30)  
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
IF @FromDate=''  
BEGIN 
If @entryid>0
begin
select EntryId,BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,a.RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,
BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment as remark,
Srno,SchemeName,Symbol,series,Startdate,Enddate,MinQty,MaxQty,MaxValue,TransactionRefNo,InternalRefNo,IssuanceDate into #aa from tbl_BONDOrderEntry a left join tbl_BondMaster b on
 a.bond_srno=b.srno  where client_code=@clientcode  and EntryId=@entryid

   SELECT  BOND_SrNo,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,''),ApplicationNo,Order_Date,EntryId ,series,startdate,enddate,MINQTY,maxqty,remark,TransactionRefNo,InternalRefNo,IssuanceDate
            FROM (select * from #aa) a                            
            INNER JOIN  /*INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS INTRANET.RISK.DBO.vw_Bond_MFSS_client_details*/ INTRANET.RISK.DBO.client_details b WITH (NOLOCK)
             on a.Client_Code=b.party_code order by a.Order_Date desc
end             
END  
 ELSE   
  BEGIN
   
   
   select EntryId,BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,a.RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,
BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment as remark,
Srno,SchemeName,Symbol,series,Startdate,Enddate,MinQty,MaxQty,MaxValue,TransactionRefNo,InternalRefNo,IssuanceDate into #aa1 from tbl_BONDOrderEntry a left join tbl_BondMaster b on
 a.bond_srno=b.srno  where client_code=@clientcode and a.Order_Date >=replace(CONVERT(VARCHAR(12),convert(datetime,@FromDate,103),106), '/', ' ')+' 00:00:00'
  and a.Order_Date<=replace(CONVERT(VARCHAR(12),convert(datetime,@todate,103),106), '/', ' ')+' 23:59:59'    

   SELECT  BOND_SrNo,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,''),ApplicationNo,Order_Date,EntryId ,series,startdate,enddate,MINQTY,maxqty,remark,TransactionRefNo,InternalRefNo,IssuanceDate
            FROM (select * from #aa1) a                            
            INNER JOIN  /*INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS INTRANET.RISK.DBO.vw_Bond_MFSS_client_details*/ INTRANET.RISK.DBO.client_details b WITH (NOLOCK)
             on a.Client_Code=b.party_code order by a.Order_Date desc
             
end             
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK_IPartner
-- --------------------------------------------------
--[USP_BOND_ORDERBOOK]'','E67172','E67172','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E67515','E67515','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E59646','E59646','BROKER'     
--dbo.[USP_BOND_ORDERBOOK]'','e10398','CSO','BROKER'    
--[USP_BOND_ORDERBOOK]'','fb','fb','BROKER'    
CREATE procedure [dbo].[USP_BOND_ORDERBOOK_IPartner]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
Declare @prefix varchar(max),@postfix varchar(max),@prepost varchar(max)                              
Declare @STR AS VARCHAR(max),@CONDITION AS VARCHAR(max),@Type AS VARCHAR(50)                                                                                                                                                    
                            
set @CONDITION = ISNULL(RISK.DBO.FN_MFSS_ACCESS_TO(@access_to,@access_code),'')  
print @CONDITION                          
                          
IF OBJECT_ID('TempDB..##PARTY_MIMANSA') IS NOT NULL                                            
DROP TABLE ##PARTY_MIMANSA                            
CREATE TABLE ##PARTY_MIMANSA                                          
(                                
   CLIENTCODE VARCHAR(30),                          
   CLIENTNAME VARCHAR(MAX)                          
)                                
                          
INSERT INTO ##PARTY_MIMANSA                                        
EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
                            
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                                     
BEGIN                                                      
 SET @CONDITION=''                              
 SET @TYPE='CRMS'                                    
END                                  
ELSE                              
BEGIN                              
 SET @TYPE='INHOUSE'                              
 SET @CONDITION=@CONDITION--+'and A.USERTYPE=''INHOUSE'' '                              
END                       
If(@Type='CRMS')            
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],a.ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate, cast((Total) as  decimal(16,2)) as [Total Amount],Segment 
  
            AS [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  , case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status]
            FROM ##PARTY_MIMANSA PARTY                            
            INNER join (select * from tbl_BONDOrderEntry where Order_Date > ''01-Oct-2017'') a on party.CLIENTCODE=a.Client_Code order by a.Order_Date desc'       
End               
ELSE    
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  ,case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status] 
            FROM (select * from tbl_BONDOrderEntry where Order_Date > ''01-Oct-2017'') a                            
            INNER JOIN   /*INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS*/ INTRANET.RISK.DBO.vw_Bond_MFSS_client_details b WITH (NOLOCK) on a.Client_Code=b.party_code and '+ @CONDITION +' order by a.Order_Date desc'                                                                                           
    
END   
print (@str )  
Exec (@str ) 
--bol ok bhari..test keli ahen ka?
--change ka keli kahi issue hota ka
--give me ur number 8108775272  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK_new change_06aug2020
-- --------------------------------------------------
--[USP_BOND_ORDERBOOK]'','E67172','E67172','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E67515','E67515','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E59646','E59646','BROKER'     
--dbo.[USP_BOND_ORDERBOOK]'','e10398','CSO','BROKER'    
--[USP_BOND_ORDERBOOK]'','fb','fb','BROKER'    
create procedure [dbo].[USP_BOND_ORDERBOOK_new change_06aug2020]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
Declare @prefix varchar(max),@postfix varchar(max),@prepost varchar(max)                              
Declare @STR AS VARCHAR(max),@CONDITION AS VARCHAR(max),@Type AS VARCHAR(50)                                                                                                                                                    
                            
set @CONDITION = ISNULL(RISK.DBO.FN_MFSS_ACCESS_TO(@access_to,@access_code),'')  
print @CONDITION                          
                          
IF OBJECT_ID('TempDB..##PARTY_MIMANSA') IS NOT NULL                                            
DROP TABLE ##PARTY_MIMANSA                            
CREATE TABLE ##PARTY_MIMANSA                                          
(                                
   CLIENTCODE VARCHAR(30),                          
   CLIENTNAME VARCHAR(MAX)                          
)                                
                          
INSERT INTO ##PARTY_MIMANSA                                        
EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
                            
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                                     
BEGIN                                                      
 SET @CONDITION=''                              
 SET @TYPE='CRMS'                                    
END                                  
ELSE                              
BEGIN                              
 SET @TYPE='INHOUSE'                              
 SET @CONDITION=@CONDITION--+'and A.USERTYPE=''INHOUSE'' '                              
END                       
If(@Type='CRMS')            
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],a.ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate, cast((Total) as  decimal(16,2)) as [Total Amount],Segment 
  
            AS [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  , case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status]
            FROM ##PARTY_MIMANSA PARTY                            
            INNER join (select * from tbl_BONDOrderEntry with(nolock) where Order_Date > ''01-Oct-2017'') a on party.CLIENTCODE=a.Client_Code order by a.Order_Date desc'       
End               
ELSE    
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''') ,[B2C/B2B]= b.b2c ,case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status] 
            FROM (select * from tbl_BONDOrderEntry where Order_Date > ''01-Oct-2017'') a                            
            INNER JOIN  /*INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS*/ INTRANET.RISK.DBO.vw_Bond_MFSS_client_details b WITH (NOLOCK) on a.Client_Code=b.party_code and '+ @CONDITION +' order by a.Order_Date desc'                                                                                           
    
END   
print (@str )  
Exec (@str ) 
--bol ok bhari..test keli ahen ka?
--change ka keli kahi issue hota ka
--give me ur number 8108775272  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK_UAT
-- --------------------------------------------------
    
--dbo.[USP_BOND_ORDERBOOK_UAT]'','e10398','CSO','BROKER'    
create procedure [dbo].[USP_BOND_ORDERBOOK_UAT]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
Declare @prefix varchar(max),@postfix varchar(max),@prepost varchar(max)                              
Declare @STR AS VARCHAR(max),@CONDITION AS VARCHAR(max),@Type AS VARCHAR(50)                                                                                                                                                    
                            
set @CONDITION = ISNULL(RISK.DBO.FN_MFSS_ACCESS_TO(@access_to,@access_code),'')  
print @CONDITION                          
                          
IF OBJECT_ID('TempDB..##PARTY_MIMANSA') IS NOT NULL                                            
DROP TABLE ##PARTY_MIMANSA                            
CREATE TABLE ##PARTY_MIMANSA                                          
(                                
   CLIENTCODE VARCHAR(30),                          
   CLIENTNAME VARCHAR(MAX)                          
)                                
                          
INSERT INTO ##PARTY_MIMANSA                                        
EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
                            
IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)                                     
BEGIN                                                      
 SET @CONDITION=''                              
 SET @TYPE='CRMS'                                    
END                                  
ELSE                              
BEGIN                              
 SET @TYPE='INHOUSE'                              
 SET @CONDITION=@CONDITION--+'and A.USERTYPE=''INHOUSE'' '                              
END                       
If(@Type='CRMS')            
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],a.ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate, cast((Total) as  decimal(16,2)) as [Total Amount],Segment 
  
            AS [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  , case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status]
            FROM ##PARTY_MIMANSA PARTY                            
            INNER join (select * from tbl_BONDOrderEntry_Test with(nolock) where Order_Date > ''01-Oct-2017'') a on party.CLIENTCODE=a.Client_Code order by a.Order_Date desc'       
End               
ELSE    
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  ,case when  Order_Status=''PENDING'' then ''<input onclientclick="return false;" type="button" id=''+cast (EntryId as varchar(50))+'' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">''  else Order_Status   end as [Order Status] 
            FROM (select * from tbl_BONDOrderEntry_Test where Order_Date > ''01-Oct-2017'') a                            
            INNER JOIN  /*INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS*/ INTRANET.RISK.DBO.vw_Bond_MFSS_client_details b WITH (NOLOCK) on a.Client_Code=b.party_code and '+ @CONDITION +' order by a.Order_Date desc'                                                                                           
    
END   
--print (@str )  
Exec (@str )  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERBOOK17072016
-- --------------------------------------------------
--[USP_BOND_ORDERBOOK]'','E67172','E67172','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E67515','E67515','EXECUTIVE'  
--[USP_BOND_ORDERBOOK]'','E59646','E59646','BROKER'     
--dbo.[USP_BOND_ORDERBOOK]'','e10398','CSO','BROKER'    
--[USP_BOND_ORDERBOOK]'','fb','fb','BROKER'    
CREATE procedure [dbo].[USP_BOND_ORDERBOOK17072016]    
@Process VARCHAR(50)='',    
@username VARCHAR(50)='',    
@access_code VARCHAR(50)='',    
@access_to VARCHAR(50)=''    
AS       
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                                                                               
                             
Declare @prefix varchar(max),@postfix varchar(max),@prepost varchar(max)                              
Declare @STR AS VARCHAR(max),@CONDITION AS VARCHAR(max),@Type AS VARCHAR(50)                                                                                                                                                    
                            
set @CONDITION = ISNULL(RISK.DBO.FN_MFSS_ACCESS_TO(@access_to,@access_code),'')  
print @CONDITION                          
                          
IF OBJECT_ID('TempDB..##PARTY_MIMANSA') IS NOT NULL                                            
DROP TABLE ##PARTY_MIMANSA                            
CREATE TABLE ##PARTY_MIMANSA                                          
(                                
   CLIENTCODE VARCHAR(30),                          
   CLIENTNAME VARCHAR(MAX)                          
)                                
                          
INSERT INTO ##PARTY_MIMANSA                                        
EXEC USPGetDealerClients_bond @ACCESS_CODE,@ACCESS_TO                          
                            
IF EXISTS(SELECT 1 FROM [196.1.115.207].ANGELCS.DBO.ANGELUSERBRANCH with(nolock)  WHERE EMP_NO=@ACCESS_CODE)                                        
BEGIN                                                      
 SET @CONDITION=''                              
 SET @TYPE='CRMS'                                    
END                                  
ELSE                              
BEGIN                              
 SET @TYPE='INHOUSE'                              
 SET @CONDITION=@CONDITION--+'and A.USERTYPE=''INHOUSE'' '                              
END                       
If(@Type='CRMS')            
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],a.ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate, cast((Total) as  decimal(16,2)) as [Total Amount],Segment 
  
            AS [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')  
            FROM ##PARTY_MIMANSA PARTY                            
            INNER join tbl_BONDOrderEntry a on party.CLIENTCODE=a.Client_Code'       
End               
ELSE    
BEGIN    
            set @str='SELECT  BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
            [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'''')   
            FROM tbl_BONDOrderEntry a                            
            INNER JOIN  INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code and '+ @CONDITION                                                                                            
    
END    
    print @str
Exec (@str )   
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BOND_ORDERENTRY]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        --SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        --Client_Code =@Client_Code  and Order_Status<>'REJECTED'
		declare @max as int=0
		select @max = maxQty from TBL_BondMaster where SrNo=@BOND_SrNo

 if(@Segment='')
        begin
			set @Segment='NSE'
        end

		 SELECT @CNT=  case when ISNULL(SUM (order_qty),0) <= @max then  0 else 1  end FROM tbl_BONDOrderEntry WHERE BOND_SrNo=@BOND_SrNo AND
        pan =@pan  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@Order_Type ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM )

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID

			DECLARE @MSG AS VARCHAR(MAX)=''
			/*set @MSG='Order for subscription for  '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in '+@BOND_Name+' for client code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'--'Order for subscription for  '+@Order_Qty+' Units / Rs. '+@Total+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'*/
			set @MSG='Dear Client ('+@Client_Code+'), Order for subscription of '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in SGB '+@BOND_Name+' is accepted for processing.Application No:'+@ApplicationNo+'.'

			EXEC USP_BONDSMS @Client_Code,@MSG
			/**********************Email added on 05 aug 2020 by neha naiwar*****************/
			Exec USP_BondOrder_Confirmation_Email @BOND_Name,@Client_Code,@Order_Qty,@RATE,@Total,@ApplicationNo
			/********************************************/
			END
			ELSE
			BEGIN
       
			SELECT -1
       
			END
END


IF @Process ='REJECT'
BEGIN

UPDATE tbl_BONDOrderEntry
SET Order_Status='REJECTED',Comment='ORDER REJECTED/CANCELLED BY '+@access_code
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_05Aug2020
-- --------------------------------------------------

CREATE procedure [dbo].[USP_BOND_ORDERENTRY_05Aug2020]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        --SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        --Client_Code =@Client_Code  and Order_Status<>'REJECTED'
		declare @max as int=0
		select @max = maxQty from TBL_BondMaster where SrNo=@BOND_SrNo


		 SELECT @CNT=  case when ISNULL(SUM (order_qty),0) <= @max then  0 else 1  end FROM tbl_BONDOrderEntry WHERE BOND_SrNo=@BOND_SrNo AND
        pan =@pan  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@Order_Type ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM )

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID

			DECLARE @MSG AS VARCHAR(MAX)=''
			set @MSG='Order for subscription for  '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in '+@BOND_Name+' for client code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'--'Order for subscription for  '+@Order_Qty+' Units / Rs. '+@Total+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'

			EXEC USP_BONDSMS @Client_Code,@MSG


			END
			ELSE
			BEGIN
       
			SELECT -1
       
			END
END


IF @Process ='REJECT'
BEGIN

UPDATE tbl_BONDOrderEntry
SET Order_Status='REJECTED',Comment='ORDER REJECTED/CANCELLED BY '+@access_code
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_20072016
-- --------------------------------------------------
CREATE Procedure [dbo].[USP_BOND_ORDERENTRY_20072016]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        Client_Code =@Client_Code  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@Order_Type ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM )

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID
			END
			ELSE
			BEGIN
       
			SELECT -1
       
			END
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_ABMA_APP
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BOND_ORDERENTRY_ABMA_APP]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date varchar(100)='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate varchar(100)='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)='',
@TransactionRefNo varchar(20),
@InternalRefNo varchar(max)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        --SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        --Client_Code =@Client_Code  and Order_Status<>'REJECTED'
		declare @max as int=0
		select @max = maxQty from TBL_BondMaster where SrNo=@BOND_SrNo
		select @BONDCloseDate=Enddate from TBL_BondMaster where SrNo=@BOND_SrNo
	
         SELECT @Segment= case when  nsecm ='Y' then 'NSE' when bsecm ='Y' then 'BSE'  else 'NSE' end   FROM RISK.DBO.CLIENT_DETAILS with(nolock)                        
        where party_code=@Client_Code
        
       
        if(@Segment='')
        begin
			set @Segment='NSE'
        end
         
		 SELECT @CNT=  case when ISNULL(SUM (order_qty),0) <= @max then  0 else 1  end FROM tbl_BONDOrderEntry WHERE BOND_SrNo=@BOND_SrNo AND
        pan =@pan  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM ,TransactionRefNo,InternalRefNo )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,'NEW ORDER' ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM ,@TransactionRefNo,@InternalRefNo)

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID

			DECLARE @MSG AS VARCHAR(MAX)=''
			/*set @MSG='Order for subscription for  '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in '+@BOND_Name+' for client code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'--'Order for subscription for  '+@Order_Qty+' Units / Rs. '+@Total+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'*/
			set @MSG='Dear Client ('+@Client_Code+'), Order for subscription of '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in SGB '+@BOND_Name+' is accepted for processing.Application No:'+@ApplicationNo+'.'

			EXEC USP_BONDSMS @Client_Code,@MSG
			/**********************Email added on 05 aug 2020 by neha naiwar*****************/
			Exec USP_BondOrder_Confirmation_Email @BOND_Name,@Client_Code,@Order_Qty,@RATE,@Total,@ApplicationNo
			/********************************************/
			END
			ELSE
			BEGIN
       
			SELECT -1
       
			END
END


IF @Process ='REJECT'
BEGIN

Declare @BondNamecancel varchar(500)='',@party varchar(100)=''
UPDATE tbl_BONDOrderEntry
SET Order_Status='REJECTED',Comment='Order rejected/cancelled by user'/*+@access_code*/,TransactionRefNo=@TransactionRefNo,InternalRefNo=@InternalRefNo
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

select @party=client_code, @BondNamecancel=BOND_Name from tbl_BONDOrderEntry WHERE EntryId=@EntryId
declare @msgcancel VARCHAR(MAX)='' 
set @msgcancel='Dear Client ('+@Client_Code+'), As per your request order for '+@BOND_Name+'  has been cancelled. You can place another order for the same by clicking https://bit.ly/3lT7Ny5 '  

exec USP_BONDCancelSMS @party,@msgcancel

SELECT 1 AS ENTRYID

END


IF @Process ='EDIT'
BEGIN

UPDATE tbl_BONDOrderEntry
SET Order_Qty=@Order_Qty,Total=@Total,ClientLimit=@ClientLimit,TransactionRefNo=@TransactionRefNo,InternalRefNo=@InternalRefNo
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_Ipartner
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BOND_ORDERENTRY_Ipartner]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        --SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        --Client_Code =@Client_Code  and Order_Status<>'REJECTED'
		declare @max as int=0
		select @max = maxQty from TBL_BondMaster where SrNo=@BOND_SrNo

		 if(@Segment='')
        begin
			set @Segment='NSE'
        end

		 SELECT @CNT=  case when ISNULL(SUM (order_qty),0) <= @max then  0 else 1  end FROM tbl_BONDOrderEntry WHERE BOND_SrNo=@BOND_SrNo AND
        pan =@pan  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@Order_Type ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM )

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID

			DECLARE @MSG AS VARCHAR(MAX)=''
			/*set @MSG='Order for subscription for  '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'--'Order for subscription for  '+@Order_Qty+' Units / Rs. '+@Total+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'*/
		    set @MSG='Dear Client ('+@Client_Code+'), Order for subscription of '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in SGB '+@BOND_Name+' is accepted for processing.Application No:'+@ApplicationNo+'.'

			EXEC USP_BONDSMS @Client_Code,@MSG


			END
			ELSE
			BEGIN
       
			SELECT -1 as ID
       
			END
END


IF @Process ='REJECT'
BEGIN

UPDATE tbl_BONDOrderEntry
SET Order_Status='REJECTED',Comment='ORDER REJECTED/CANCELLED BY '+@access_code
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_Ipartner_UAT
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BOND_ORDERENTRY_Ipartner_UAT]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        --SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        --Client_Code =@Client_Code  and Order_Status<>'REJECTED'
		declare @max as int=0
		select @max = maxQty from TBL_BondMaster_UAT where SrNo=62

 if(@Segment='')
        begin
			set @Segment='NSE'
        end

		 SELECT @CNT=  case when ISNULL(SUM (order_qty),0) <= @max then  0 else 1  end FROM tbl_BONDOrderEntry_UAT WHERE BOND_SrNo=@BOND_SrNo AND
        pan =@pan  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry_UAT
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@Order_Type ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM )

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry_UAT 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID

			DECLARE @MSG AS VARCHAR(MAX)=''
			set @MSG='Order for subscription for  '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'--'Order for subscription for  '+@Order_Qty+' Units / Rs. '+@Total+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'

			/*EXEC USP_BONDSMS @Client_Code,@MSG*/


			END
			ELSE
			BEGIN
       
			SELECT -1 as ID
       
			END
END


IF @Process ='REJECT'
BEGIN

UPDATE tbl_BONDOrderEntry_UAT
SET Order_Status='REJECTED',Comment='ORDER REJECTED/CANCELLED BY '+@access_code
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_New
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BOND_ORDERENTRY_New]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@OrderType VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
  
   if(@Segment='')
        begin
			set @Segment='NSE'
        end
        
        SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        Client_Code =@Client_Code  
       
			IF @CNT=0
			BEGIN
			INSERT INTO tbl_BONDOrderEntry
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode)
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@OrderType ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode )
			END
			ELSE
			BEGIN
       
			SELECT -1
       
			END
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_ORDERENTRY_UAT
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BOND_ORDERENTRY_UAT]
@Process VARCHAR(50)='',
@EntryId INT =0,
@BOND_SrNo INT=0,
@BOND_Name VARCHAR(500)='',
@Client_Code VARCHAR(50)='',
@ClientName VARCHAR(200)='',
@Order_Date DATETIME='',
@Order_Status VARCHAR(300)='',
@Order_Qty INT='',
@RATE MONEY='',
@Total MONEY='',
@ClientLimit MONEY='',
@BOND_Code VARCHAR(50)='',
@BOND_Symbol VARCHAR(50)='',
@ISIN VARCHAR(50)='',
@PAN VARCHAR(50)='',
@DP VARCHAR(100)='',
@BONDCloseDate DATETIME='',
@ApplicationNo VARCHAR(100)='',
@BeneficiaryId VARCHAR(20)='',
@IPAddress VARCHAR(30)='',
@DPName VARCHAR(20)='',
@Order_Type VARCHAR(30)='',
@Segment VARCHAR(20)='',
@Channel VARCHAR(20)='',
@access_to VARCHAR(50)='',
@access_code VARCHAR(50)='',
@EnteredBy VARCHAR(30)='',
@EnteredOn DATETIME='',
@Verfiedon DATETIME='',
@Exportedon DATETIME='',
@ReverseConfirmation DATETIME='',
@Comment VARCHAR(2000)='',
@ACType VARCHAR(20)='',
@ACName VARCHAR(100)='',
@IFSCode VARCHAR(30)='',
@ACC_NUM  VARCHAR(100)=''

AS BEGIN

IF @Process ='ADD'
BEGIN
  DECLARE @CNT INT
        
        --SELECT @CNT =COUNT(1) FROM tbl_BONDOrderEntry WHERE BOND_Name=@BOND_Name AND
        --Client_Code =@Client_Code  and Order_Status<>'REJECTED'
		declare @max as int=0
		select @max = maxQty from TBL_BondMaster_UAT where SrNo=43
		
		 if(@Segment='')
        begin
			set @Segment='NSE'
        end

		 SELECT @CNT=  case when ISNULL(SUM (order_qty),0) <= @max then  0 else 1  end FROM tbl_BONDOrderEntry_UAT WHERE BOND_SrNo=@BOND_SrNo AND
        pan =@pan  and Order_Status<>'REJECTED'
       
			IF @CNT=0
			BEGIN

		  
			INSERT INTO tbl_BONDOrderEntry_UAT
			(BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Comment,ACType,ACName,IFSCode,ACC_NUM )
			VALUES
			( @BOND_SrNo ,@BOND_Name ,@Client_Code ,@ClientName ,GETDATE(),  'PENDING'  ,@Order_Qty  ,@RATE,@Total,@ClientLimit,@BOND_Code ,@BOND_Symbol ,@ISIN ,@PAN ,@DP ,@BONDCloseDate ,@ApplicationNo ,@BeneficiaryId  ,@IPAddress  ,@DPName ,@Order_Type ,@Segment ,@Channel ,@access_to ,@access_code ,@EnteredBy  ,getdate()    ,'NEW ORDER'  ,@ACType ,@ACName ,@IFSCode ,@ACC_NUM )

		    set @ApplicationNo =left(@BOND_Symbol,4)+ dbo.AddZeroPrefox(SCOPE_IDENTITY(),5) 

			update tbl_BONDOrderEntry_UAT 
			set ApplicationNo =@ApplicationNo
			where EntryId=SCOPE_IDENTITY()

			select @@IDENTITY as ID

			DECLARE @MSG AS VARCHAR(MAX)=''
			set @MSG='Order for subscription for  '+cast (@Order_Qty as varchar(500))+' Units / Rs. '+cast (@Total as varchar(500))+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'--'Order for subscription for  '+@Order_Qty+' Units / Rs. '+@Total+' in '+@BOND_Name+' for code '+@Client_Code+' is accepted for processing. TRXN No.'+@ApplicationNo+'.'

			/*EXEC USP_BONDSMS @Client_Code,@MSG*/


			END
			ELSE
			BEGIN
       
			SELECT -1 as ID
       
			END
END


IF @Process ='REJECT'
BEGIN

UPDATE tbl_BONDOrderEntry_UAT
SET Order_Status='REJECTED',Comment='ORDER REJECTED/CANCELLED BY '+@access_code
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END


IF @Process ='EDIT'
BEGIN

UPDATE tbl_BONDOrderEntry_UAT
SET Order_Qty=@Order_Qty,Total=@Total,ClientLimit=@ClientLimit
WHERE EntryId=@EntryId AND Order_Status='PENDING' 

SELECT 1 AS ENTRYID

END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOND_OTP
-- --------------------------------------------------

--exec [USP_BOND_OTP] '4564645','clientInfo','w','abc'
CREATE proc [dbo].[USP_BOND_OTP]
(@EmpCode varchar(15))
As

BEGIN

declare @isExist int

DECLARE @EmployeeId varchar(200)

DECLARE @mobileNumber varchar(25)

declare @otp varchar(6)

SET @mobileNumber=''

DECLARE @Str AS VARCHAR(11), @Dt AS VARCHAR(11), @Tm AS VARCHAR(5), @AP AS VARCHAR(2)

SET @Str = Convert(VARCHAR(11), getdate(), 113)

SET @Dt = Convert(VARCHAR(11), getdate(), 103)

SET @Tm = Replace(SubString(Convert(VARCHAR, dateadd(mi, 10, getdate()), 9), 13, 5), ' ', '')

SET @AP = Right(Convert(VARCHAR, getdate(), 100), 2)

SELECT @mobileNumber=mobile_pager,

@EmployeeId = party_code

FROM AngelNseCM.msajag.dbo.client_details with(nolock) WHERE party_code=@EmpCode --AND status='A'

if isnull(@mobileNumber,'')=''

BEGIN

SET @mobileNumber='9892767973'

END

--SET @mobileNumber='9664218244'
--SET @mobileNumber='9860700210'

print @employeeId
print @mobileNumber

	If isnull(@EmployeeId,'')<>''

	BEGIN

		SELECT @otp = left(ABs(Cast(cast(newid() AS VARBINARY) AS INT)), 6)

		UPDATE TBL_BOND_OTP
		SET FLG=0
		WHERE EMP_CODE = @EMPCODE

		INSERT INTO TBL_BOND_OTP (EMP_CODE,OTP,CREATION_DATE ,FLG) 
		VALUES(@EMPCODE,@OTP,GETDATE(),1)

		SELECT @OTP AS OTPMSG,@MOBILENUMBER AS MOBILENUMBER

		 
		INSERT INTO [Mimansa].[GENERAL].[dbo].[tbl_smsQueue] ([SentFrom], [ServiceName], [MobileNo], [Message], [DeliveryAckRequired], [TransmissionTime], [SMSSentStatus], [TokenID], [MessageType], [IsTransactionalSMS], [IsDNDNumber])

		VALUES ('AngelInHouse', 'Bond_OTP', @mobileNumber,

		'Your OTP verification code is '+@otp+' . Please enter the verification code and submit your details to proceed further .Regards - Angel Broking', 'N', getdate(), 'N', NEWID(), 'NORMAL', 'Y', 'N')
		 
	END

	ELSE

	BEGIN

	Select 'Please check the details' as OtpMsg,'' AS MobileNumber

	END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BONDCancelSMS
-- --------------------------------------------------
CREATE proc [dbo].[USP_BONDCancelSMS]  
@party VARCHAR(50)='',
@msgcancel VARCHAR(MAX)=''   
AS BEGIN  
  
DECLARE @MOB AS VARCHAR(50)=''  
  
SELECT @MOB =MOBILE_PAGER FROM RISK.DBO.CLIENT_DETAILS   
WHERE PARTY_CODE=@party  
  
 INSERT INTO SMS.DBO.SMS (TO_NO,MESSAGE,DATE,TIME,FLAG,AMPM,PURPOSE)   
 VALUES( @MOB,@msgcancel, CONVERT(VARCHAR(10), GETDATE(), 103), LTRIM(RTRIM(STR(DATEPART(HH, DATEADD(MINUTE, 15, GETDATE()))))) +':' + LTRIM(RTRIM(STR(DATEPART(MINUTE, DATEADD(MINUTE, 15, GETDATE()))))),'P',CASE WHEN (DATEPART(HH, DATEADD(MINUTE, 15, GETDATE()))) >= 12 THEN 'PM' ELSE 'AM' END,'Bond_Accepted')  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BondOrder_Confirmation_Email
-- --------------------------------------------------
CREATE proc [dbo].[USP_BondOrder_Confirmation_Email]( @BOND_Name VARCHAR(500),
@Client_Code VARCHAR(50),
@Order_Qty INT,
@RATE MONEY,
@Total MONEY,@ApplicationNo VARCHAR(100))

as
begin
			 DECLARE @HTMLBODY1   VARCHAR(8000),
			 @name as varchar(1000),              
            @MESS        As nVARCHAR(max),                  
            @emailto     AS VARCHAR(1000),                  
            @emailcc     AS VARCHAR(1000),                  
            @emailbcc    AS nVARCHAR(1000),                  
            @DATA AS nVARCHAR(MAX),
            @sub as varchar(100)
            
            set @DATA=''
              set @MESS=''
 --select @Order_Qty=order_qty,@RATE=rate, @Total=total ,@ApplicationNo=applicationno,@BOND_Name=bond_name ,@Client_Code=client_code from tbl_BONDOrderEntry where bond_srno=44 and client_code='V34086' and entryid=2427
            
            select @emailto=email,@name=long_name from risk.dbo.client_detailS WHere party_code=@Client_Code                
			--SET @emailCC='pankaj.chandila@48fitness.in'                  
			SET @emailbCC='neha.naiwar@angelbroking.com'
	SET @MESS=                              
    '<table border="1" cellpadding="2" cellspacing="2">                              
    <tr>                         
  <th align="center"> Quantity(Units)  </th>                              
     <th  align="center"> Price / Unit  </th>                              
     <th  align="center">Amount (Rs.) </th>                                                        
    </tr>'
	
	set @Data=@Data+                             
   '<tr>                            
   <td align="center"> '+ CONVERT(VARCHAR,@Order_Qty) +' </td>                            
   <td align="center"> '+ CONVERT(VARCHAR,@RATE) +' </td>                            
   <td align="center"> '+ CONVERT(VARCHAR,@Total) +' </td>                                                    
     </tr>'
	
	   SET @MESS='Dear '+@name+',<bR><br>

Your request for subscription of Sovereign Gold Bond Scheme has been accepted. Please find the details below.<br><br>

<b>Application No: '+@ApplicationNo+'<br>
Name of the Issue: ' +@BOND_Name+'<br>
Hold Amount (Rs) : '+CONVERT(VARCHAR,@Total)+'<br>
Client Code      : '+@Client_Code+'</b><br>
<Br>'+ @MESS + @Data +'</Table><BR>For any queries/information, please call our Centralized Helpdesk number 022-68071111 / 022-42185454 or email us at <a href="mailto:support@angelbroking.com">support@angelbroking.com</a><br />  '   
		
		set @sub='Sovereign Gold Bond Order Confirmation'   
                                    
                            
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                      
 @RECIPIENTS =@emailto,--'neha.naiwar@angelbroking.com' ,                                      
 @COPY_RECIPIENTS ='',-- @emailcc,                                      
 @blind_copy_recipients ='',--@emailbcc,--'neha.naiwar@angelbroking.com' ,                  
 @PROFILE_NAME = 'AngelBroking',                                      
 @BODY_FORMAT ='HTML',                                      
 @SUBJECT = @sub,                                      
 @FILE_ATTACHMENTS ='',                                      
 @BODY =@MESS 
 
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BONDSMS
-- --------------------------------------------------
CREATE proc [dbo].[USP_BONDSMS]
@CLIENTCODE VARCHAR(50)='',
@MSG VARCHAR(MAX)=''
AS BEGIN

DECLARE @MOB AS VARCHAR(50)=''

SELECT @MOB =MOBILE_PAGER FROM RISK.DBO.CLIENT_DETAILS 
WHERE PARTY_CODE=@CLIENTCODE

 INSERT INTO SMS.DBO.SMS (TO_NO,MESSAGE,DATE,TIME,FLAG,AMPM,PURPOSE) 
 VALUES(  @MOB,@MSG, CONVERT(VARCHAR(10), GETDATE(), 103), LTRIM(RTRIM(STR(DATEPART(HH, DATEADD(MINUTE, 15, GETDATE()))))) +':' + LTRIM(RTRIM(STR(DATEPART(MINUTE, DATEADD(MINUTE, 15, GETDATE()))))),'P',CASE WHEN (DATEPART(HH, DATEADD(MINUTE, 15, GETDATE()))) >= 12 THEN 'PM' ELSE 'AM' END,'Bond_Accepted')



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_BSE_Reverse_Upload
-- --------------------------------------------------
-- [Usp_BSE_Reverse_Upload] '259_bseorder_report.csv'  
CREATE procEDURE [dbo].[Usp_BSE_Reverse_Upload]   
(@filename as varchar(max))           
AS            
BEGIN    
  
Declare @file as varchar(max),@Delimiter as varchar(max)= ',',@newline as varchar(max)= '\n'  
   
truncate table Bond_OrderFile_BSE_Success  

--truncate table Bond_OrderFile_BSE_Success_history  
--truncate table Bond_OrderFile_BSE_Success    
                     
--Declare @path as varchar(max)= '\\196.1.115.183\d$\Inetpub\wwwroot\AngelInHouse_3.5\BondUpload\Bond_Upload_Files\'; 
Declare @path as varchar(max)= '\\196.1.115.147\Upload1\UploadAdvChart\';          
         
set @file = (@path+@filename);  
exec('BULK INSERT Bond_OrderFile_BSE_Success FROM ''' +@file+''' WITH (FIRSTROW = 1,FIELDTERMINATOR = '''+@Delimiter+''', ROWTERMINATOR = '''+@newline+''')')                    

declare @var as varchar(max)='DEL '+@file+''

 --exec master.dbo.xp_cmdshell @var -- 'DEL '+@path  
 --\\196.1.115.183\d$\Inetpub\wwwroot\AngelInHouse_3.5\BondUpload\Bond_Upload_Files\'+@file   
  
Insert into Bond_OrderFile_BSE_Success_history       
Select Scrip_Id,Application_No,Category,Applicant_Name,Depository,DpID,ClientId_Benf_Id,Quantity,Cut_off_flag,Rate,Cheque_Received_Flag,  
Cheque_Amount,Cheque_Number,Pan_No,Bank_Name,Location,Account_Number,Bid_Id,Action_Code,GETDATE() 
from Bond_OrderFile_BSE_Success      

update a  
set a.order_status='Executed',ReverseConfirmation=getdate()
from tbl_BONDOrderEntry a
inner join Bond_OrderFile_BSE_Success b 
on a.PAN=b.pan_no
where Order_Status='Exported' and a.Segment='BSE'
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Calc_ShrtVal_cli
-- --------------------------------------------------

CREATE proc [dbo].[Usp_Calc_ShrtVal_cli](@pcode as varchar(10) = null)      
as            
       
            
set nocount on       

            
delete from BondVerified_Cash_ShrtVal where party_Code=@pcode

insert into BondVerified_Cash_ShrtVal            
(sett_no, sett_type, party_code, scrip_cd, short_qty, poa_adj_qty, seg, total_holding, hld_ac_code, act_short_qty,ISIN)            
select             
A.sett_no, A.sett_type, A.party_code, A.scrip_cd, A.short_qty, A.poa_adj_qty, A.seg, 
0 as Tot_POA_Qty, '' as hld_ac_code, A.act_short_qty,A.certno             
from             
(
	select sett_no,sett_type,PARTY_cODE,SCRIP_CD, certno,              
	short_qty=SUM(delqty-recqty), poa_adj_qty=convert(numeric(17,4),0), seg='BSE', act_short_qty=SUM(delqty-recqty)            
	from              
	BSECM_shortage A (nolock)              
	where party_code=@pcode and sett_type in ('D','C')              
	group by              
	a.sett_no,a.sett_type,PARTY_CODE,SCRIP_CD,certno            

	UNION ALL

	select            
	sett_no,sett_type,PARTY_cODE,SCRIP_CD, certno,            
	short_qty=SUM(delqty-recqty), 0, 'NSE', short_qty=SUM(delqty-recqty)            
	from                   
	NSECM_shortage A (nolock)                       
	where party_code=@pcode and sett_type in ('N','W')                      
	group by                  
	a.sett_no,a.sett_type,PARTY_CODE,SCRIP_CD,certno            
) A
         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Check_IPO_SB_ARN_EUIN
-- --------------------------------------------------


/******************************************************************************                                
 CREATED BY: Pramod Jadhav                          
 DATE: 26/08/2015                         
 PURPOSE:             
                                 
 MODIFIED BY: PROGRAMMER NAME                                
 DATED: DD/MM/YYYY                                
 REASON: REASON TO CHANGE STORE PROCEDURE         
                            
 ******************************************************************************/                
 --    
   CREATE proc [dbo].[USP_Check_IPO_SB_ARN_EUIN]                    
   (                    
   @username AS VARCHAR(15) ,                  
   @ACCESS_TO AS VARCHAR(20),                  
   @ACCESS_CODE AS VARCHAR(20)                  
        
   )                    
   AS                    
   SET NOCOUNT ON                  
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                   
   DECLARE @ARN_EUIN_FLAG as int    
   SET @ARN_EUIN_FLAG=0           
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200)      
                                         
   IF @ACCESS_TO= 'BRANCH'                                                                                  
   BEGIN                                                                       
    SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                        
   END                                                                       
   IF @ACCESS_TO='BROKER'                                                        
   BEGIN                                               
    SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                                    
   END                                                                                               
   IF @ACCESS_TO='SB'                                                        
   BEGIN                                                  
    SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                                    
   END                                                     
   IF @ACCESS_TO='BRMAST'                                                        
   BEGIN                                                  
    SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                                 
   END                                                                        
   IF @ACCESS_TO='SBMAST'                                                        
   BEGIN                                                                           
    SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER  WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                        
   END                                                                         
   IF @ACCESS_TO='REGION'                                                        
   BEGIN                                                  
    SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                                   
   END              
   if(@ACCESS_TO='SB' OR @ACCESS_TO='SBMAST' )         
    Begin              
    if Exists(select 1 from tbl_mf_ls_arn_euins where [SB Equity Tag]=@ACCESS_CODE and  nullif(nullif([ARN NO],'-'),'')   
              is not null and nullif(nullif([EUIN No],'-'),'') is not null )                                      
     Begin          
     set @ARN_EUIN_FLAG=1         
     End                    
    Else        
     Begin                
     set @ARN_EUIN_FLAG=0             
     End             
    End          
   Else        
    Begin        
    set @ARN_EUIN_FLAG=1        
    End        
  select @ARN_EUIN_FLAG as ARN_EUIN_FLAG                     
   SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Check_IPO_SB_ARN_EUIN_IPartner
-- --------------------------------------------------
--exec USP_Check_IPO_SB_ARN_EUIN_IPartner 'alwr1937','SB','ajyc'
  
  
/******************************************************************************                                  
 CREATED BY: Pramod Jadhav                            
 DATE: 26/08/2015                           
 PURPOSE:               
                                   
 MODIFIED BY: PROGRAMMER NAME                                  
 DATED: DD/MM/YYYY                                  
 REASON: REASON TO CHANGE STORE PROCEDURE           
                              
 ******************************************************************************/                  
 --      
   CREATE proc [dbo].[USP_Check_IPO_SB_ARN_EUIN_IPartner]                      
   (                      
   @username AS VARCHAR(15) ,                    
   @ACCESS_TO AS VARCHAR(20),                    
   @ACCESS_CODE AS VARCHAR(20)                    
          
   )                      
   AS                      
   SET NOCOUNT ON                    
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                     
   DECLARE @ARN_EUIN_FLAG as int      
   SET @ARN_EUIN_FLAG=0             
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200)        
                                           
   IF @ACCESS_TO= 'BRANCH'                                                                                    
   BEGIN                                                                         
    SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                          
   END                                                                         
   IF @ACCESS_TO='BROKER'                                                          
   BEGIN                                                 
    SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                                      
   END                                                                                                 
   IF @ACCESS_TO='SB'                                                          
   BEGIN                                                    
    SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                                      
   END                                                       
   IF @ACCESS_TO='BRMAST'                                                          
   BEGIN                                                    
    SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                                   
   END                                                                          
   IF @ACCESS_TO='SBMAST'                                                          
   BEGIN                                                                             
    SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER  WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                          
   END                                                                           
   IF @ACCESS_TO='REGION'                                                          
   BEGIN                                                    
    SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                                     
   END                
   if(@ACCESS_TO='SB' OR @ACCESS_TO='SBMAST' )           
    Begin                
    if Exists(select 1 from risk.dbo.tbl_mf_ls_arn_euins where [SB Equity Tag]=@ACCESS_CODE and  nullif(nullif([ARN NO],'-'),'')     
              is not null and nullif(nullif([EUIN No],'-'),'') is not null )                                        
     Begin            
     set @ARN_EUIN_FLAG=1           
     End                      
    Else          
     Begin                  
     set @ARN_EUIN_FLAG=0               
     End               
   End            
   Else          
    Begin          
    set @ARN_EUIN_FLAG=1          
    End          
  select @ARN_EUIN_FLAG as ARN_EUIN_FLAG                       
   SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Get_NRMS_Details_Dealer_V1_FOR_Bond
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[Usp_Get_NRMS_Details_Dealer_V1_FOR_Bond]  
(  
   @clientcode  VARCHAR(50),  --='SKMI'
   @limitamt money output        

)  
  
 --EXEC [Usp_Get_NRMS_Details_Ipartner_Dealer_New]   'ET'  
 --EXEC [Usp_Get_NRMS_Details_Ipartner_Dealer]   'ET001'  
  /*
  EXEC [Usp_Get_NRMS_Details_Ipartner_Dealer] 'SUM'
  EXEC [Usp_Get_NRMS_Details_Ipartner_Dealer_V1] 'SUM'
  Usp_Get_NRMS_Details_Dealer_V1_FOR_Bond 'Rp61',0
  */

AS  
BEGIN  
  
 SET NOCOUNT ON  
 SET FMTONLY OFF  
 declare @Sub_broker  VARCHAR(50)
 Declare @Column varchar(100)
 Declare @EntityType varchar(100)
 select @Sub_broker=sub_broker from risk.dbo.client_Details with(nolock) where party_code=@clientcode
IF EXISTS(Select * from mimansa.dbo.Vw_B2B_CurrentClientDealerMapping with (nolock) WHERE Emp_No = @Sub_broker)
BEGIN
	SET @Column = 'Dealer'
	Set @EntityType='Dealer'
END
ELSE
BEGIN
	SET @Column = 'SubBroker'
	Set @EntityType='SB'
END 

IF OBJECT_ID('TEMPDB..#client_details') IS NOT NULL  
  DROP TABLE #client_details  
create table #client_details  
(
sub_broker varchar(100),
party_code varchar(100),
comb_last_date Datetime
)


 IF OBJECT_ID('TEMPDB..#TempNRMSDetails') IS NOT NULL  
  DROP TABLE #TempNRMSDetails  
 CREATE TABLE #TempNRMSDetails  
 (  
   Region VARCHAR(50)  
  ,Branch VARCHAR(50)  
  ,Sub_Broker VARCHAR(50)  
  ,Party_code VARCHAR(50)  
  ,Client_Name VARCHAR(200)  
  ,Client_Type VARCHAR(50)  
  ,Client_Category VARCHAR(50)  
  ,Ledger MONEY  
  ,Net_Shortfall MONEY  
  ,Holding MONEY  
  ,MOS MONEY  
  ,ROI MONEY  
  ,Total_Coll MONEY  
  ,Gross_Exposure MONEY  
  ,Margin_Total MONEY  
  ,Margin_Shortage MONEY  
  ,Net_Available MONEY  
  ,Unreco_Credit MONEY  
  ,Unbooked_Loss MONEY  
  ,NBFC_Logical_Ledger MONEY  
  ,[Violation %] MONEY  
  ,Pure_Risk MONEY  
  ,PureRisk_AfterDP Money
  ,Projected_Risk MONEY  
  ,ProjRisk_After_DP_Adj MONEY  
  ,SB_Cr_Adjusted MONEY  
  ,No_of_Dr_Days INT  
  ,Last_Bill_Date VARCHAR(20)  
  ,New_POA VARCHAR(50)  
  ,Intraday_Status VARCHAR(50)  
  ,MTF_Status VARCHAR(50)  
 )  


   
 --declare  @Sub_broker VARCHAR(50)='gds'  

 IF @Column = 'SubBroker'
 begin

 	insert into #client_details  
   select sub_broker,party_code,comb_last_date from risk.dbo.client_Details with(nolock) where sub_broker=@Sub_broker  

   INSERT INTO #TempNRMSDetails  
  EXEC [196.1.115.182].general.dbo.[Rpt_DrCr_client_Ipart_V1_Dealer_V1] @Sub_broker,@EntityType,@EntityType,'%','%','%','1','IN 20LACS','sanjay','BROKER','CSO'   
 
END
 ELSE 
 BEGIN
 		insert into #client_details  
		select sub_broker,SCD.party_code,comb_last_date 
		from risk.dbo.client_Details  SCD with(nolock) 
		  	INNER JOIN  Mimansa.dbo.tbl_Emp_Master em with(nolock) ON scd.Sub_Broker = em.sb_Tag
			LEFT JOIN   Mimansa.dbo.Vw_B2B_CurrentClientDealerMapping dm with(nolock) ON em.EMP_No = dm.Emp_no AND scd.party_code = dm.party_code
		where dm.Emp_no=@Sub_broker  

	  INSERT INTO #TempNRMSDetails  
	  EXEC [196.1.115.182].general.dbo.[Rpt_DrCr_client_Ipart_V1_Dealer_V1] @Sub_broker,@EntityType,@EntityType,'%','%','%','1','IN 20LACS','sanjay',@EntityType,@Sub_broker  
 
			

 END
    
  select c.* into #TBL_RMS_COLLECTION_CLI from risk.dbo.TBL_RMS_COLLECTION_CLI c with(nolock) inner join #client_details cd  
  on c.party_code=cd.party_code  

  select A.* into #CLI_ACCCHARGES from risk.dbo.CLI_ACCCHARGES_Ipartner A WITH (NOLOCK)  inner join #client_details cd  --96398032
  on a.party_code=cd.party_code  
    
  select m.* into #MTM_CLIENTS from risk.dbo.MTM_CLIENTS m with(nolock) inner join #client_details cd  
  on m.party_code=cd.party_code  
    
    
   
   
 CREATE NONCLUSTERED INDEX IX_PartyCode ON #client_details(party_code)  
   
 SELECT NRMS.Party_code,Sub_Broker,Client_Name,Client_Type,Client_Category,Ledger,Net_Shortfall,Accural_Amt,Holding,MOS,ROI,Total_Coll,Gross_Exposure,Margin_Total,
 Margin_Shortage,Net_Available,Unreco_Credit,Unbooked_Loss,NBFC_Logical_Ledger,[Violation %] 
AS Violation_Percentage,Pure_Risk,PureRisk_AfterDP,Projected_Risk,ProjRisk_After_DP_Adj,SB_Cr_Adjusted,No_of_Dr_Days,Last_Bill_Date,New_POA,Intraday_Status,
MTF_Status,debitEmail=case when isnull(debit.party_code,'')='' then 'N' else 'Y' end,squareoffEmail=case when isnull
(squareoff.party_code,'')='' then 'N' else 'Y' end  
into #Final
 FROM #TempNRMSDetails NRMS  
 LEFT JOIN  
 (  
	select * from #CLI_ACCCHARGES
 )Accural  
 ON NRMS.Party_code = Accural.PARTY_CODE  
 left join   
 (  
 SELECT a.PARTY_CODE FROM #client_details cd with(nolock)  
 inner join  
 #TBL_RMS_COLLECTION_CLI A WITH(NOLOCK)                  
 on cd.party_code=a.party_code                
 WHERE  cd.sub_broker=@Sub_broker AND NET_DEBIT < -500                                    
                 
  UNION                                
                 
  SELECT A.PARTY_CODE FROM #client_details cd with(nolock)  
   inner join   
   #MTM_CLIENTS A WITH(NOLOCK)                    
  on cd.party_code=a.party_code                 
  INNER JOIN #TBL_RMS_COLLECTION_CLI B WITH(NOLOCK) ON A.PARTY_CODE = B.Party_Code                                
                 
  WHERE   NET_DEBIT < -500 and cd.sub_broker=@Sub_broker  
 ) debit  
 on NRMS.Party_code=debit.party_code  
 left Join   
  (SELECT a.PARTY_CODE FROM #client_details cd with(nolock)  
 inner join  #TBL_RMS_COLLECTION_CLI A WITH(NOLOCK)                           
      on cd.party_code=a.party_code             
 WHERE  cd.sub_broker=@Sub_broker AND ISNULL(EXP_GROSS,0)<>0 AND NET_DEBIT <0                                
                
 UNION                                
                
 SELECT a.PARTY_CODE FROM #client_details cd with(nolock)  
   inner join  #MTM_CLIENTS a WITH(NOLOCK)                                
      on cd.party_code=a.party_code    
       INNER JOIN #TBL_RMS_COLLECTION_CLI B WITH(NOLOCK) ON A.PARTY_CODE = B.Party_Code                                
                 
  WHERE   NET_DEBIT < 0 AND ISNULL(EXP_GROSS,0)=0 and cd.sub_broker=@Sub_broker)  
  squareoff  
 on NRMS.Party_code=squareoff.party_code  
  
  Select distinct MS.*
  ,LEFT(DATENAME(MONTH, CD.comb_last_date), 3) + ' ' + RIGHT('0' + DATENAME(DAY, CD.comb_last_date), 2) + ' ' + DATENAME(YEAR, CD.comb_last_date)  AS Last_Traded_Date 
   into #clientwisedata from #Final MS
  	LEFT JOIN #client_details CD WITH (NOLOCK)
		ON CD.party_code = MS.Party_Code

   select @limitamt=Ledger from #clientwisedata where party_code=@clientcode
  print   @limitamt      

   --,LEFT(DATENAME(MONTH, CD.comb_last_date), 3) + ' ' + RIGHT('0' + DATENAME(DAY, CD.comb_last_date), 2) + ' ' + DATENAME(YEAR, CD.comb_last_date)  AS LastTradeDate
 drop table #client_details  
 drop table #TBL_RMS_COLLECTION_CLI  
 drop table #MTM_CLIENTS 
 --Drop table #Final  
Drop table #CLI_ACCCHARGES    
  
 SET NOCOUNT OFF  
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETBONDSEGMENTEDFILES
-- --------------------------------------------------
CREATE procEDURE [dbo].[USP_GETBONDSEGMENTEDFILES]      
AS      
BEGIN      
SELECT filetype,srno as 'bondid',schemename as 'bondname',segment,filepath,var_filename as 'filename',convert(varchar, uploaded_on,103) as uploaded_on  
FROM dbo.[TBL_Bond_FILEUPLOADMASTER] a       
JOIN dbo.[tbl_BondMaster] b on a.bond_id = b.srno 
where filetype like '%export%'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetBondStatus
-- --------------------------------------------------
CREATE proc [dbo].[USP_GetBondStatus]  
@SRNO varchar(2)='',  
@DATE VARCHAR(20)=''  
AS  
BEGIN

SET @DATE=@DATE +' '+CONVERT(varchar(10), DATEPART(HOUR, GETDATE()))+':'+CONVERT(varchar(10),DATEPART(MINUTE, GETDATE())) 
/* print @DATE */   
IF(SELECT count(1) FROM tbl_BondMaster   
WHERE   
SRNO =@SRNO   
AND  
(convert(DATETIME,@DATE) BETWEEN CONVERT(VARCHAR(12),CONVERT(DATETIME,STARTDATE),106)AND CONVERT(VARCHAR(12),CONVERT(DATETIME,ENDDATE),106))  
)>0  
 BEGIN  
 PRINT @DATE  
 SELECT 'Y' AS RESULT  
 END  
ELSE  
 BEGIN  
 SELECT 'N' AS RESULT  
 END   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getcleintDPId
-- --------------------------------------------------
CREATE proc [dbo].[usp_getcleintDPId]           
(          
 @Party_code varchar(10)          
)          
as           
begin          
 --select client_Code as cltdpid ,DIVIDEND_BRANCH_NO 'ifsc',LEFT( bank_name,30) AS bank_name,bank_accno ,CASE WHEN BANK_ACCOUNT_TYPE =10 THEN 'SAVING' ELSE 'CURRENT' END AS ACCOUNT_TYPE  
 --from [172.31.16.94].inhouse.dbo.tbl_client_master   
 --where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'         
 --order by client_Code desc     
   
 declare @cnt int=0  
select @cnt=count(1) from [AngelDP4].inhouse.dbo.tbl_client_master   
 where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'  
  
if (@cnt >0)  
 begin  
  
  
   select client_Code as cltdpid ,'NA' as ifsc,'NA' as bank_name,'NA' as bank_accno ,'NA' as ACCOUNT_TYPE  
   from [AngelDP4].inhouse.dbo.tbl_client_master   
   where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'         
   order by client_Code desc      
   
     
 end  
 else  
  begin  
  --SELECT A.cltdpid,isnull(B.ifsc,'-') as ifsc,isnull(c.bank_name,'-') as bank_name,isnull(B.bank_accno,'-') as bank_accno ,B.ACCOUNT_TYPE FROM  (select Party_code, case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.msajag.dbo.client4 where   
  --depository in ('cdsl','nsdl') and bankid <> '12033200'  
  --and defdp ='1' and Party_code  =@Party_code  
  --union   
  --select Party_code,case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.bsedb.dbo.client4 where   
  --depository in ('cdsl','nsdl') and bankid <> '12033200'  
  --and defdp ='1' and Party_code =@Party_code) A   
  --LEFT JOIN (SELECT DISTINCT cltcode AS Party_code ,bankname AS 'ifsc',acno AS bank_accno,'SAVING' AS ACCOUNT_TYPE from CMS.dbo.NCMS_ClientBankDetails_DISPLAY WHERE cltcode =@Party_code)B  
  --ON B.Party_code =A.Party_code  
  --LEFT JOIN (SELECT LEFT( bank_name,30) AS bank_name ,Ifsc_Code FROM  risk.dbo.rtgs_master)C  
  --ON C.Ifsc_Code=B.ifsc  
  --order by A.cltdpid desc     
  
  SELECT A.cltdpid,'NA' as ifsc,'NA' as bank_name,'NA' as bank_accno ,'NA' as ACCOUNT_TYPE FROM  (select Party_code, case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.msajag.dbo.client4 where   
  depository in ('cdsl','nsdl') and bankid <> '12033200'  
  and defdp ='1' and Party_code  =@Party_code  
  union   
  select Party_code,case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.bsedb.dbo.client4 where   
  depository in ('cdsl','nsdl') and bankid <> '12033200'  
  and defdp ='1' and Party_code =@Party_code) A  
  order by A.cltdpid desc   
 end    
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getcleintDPId_24jan2021
-- --------------------------------------------------
CREATE proc [dbo].[usp_getcleintDPId_24jan2021]           
(          
 @Party_code varchar(10)          
)          
as           
begin          
 --select client_Code as cltdpid ,DIVIDEND_BRANCH_NO 'ifsc',LEFT( bank_name,30) AS bank_name,bank_accno ,CASE WHEN BANK_ACCOUNT_TYPE =10 THEN 'SAVING' ELSE 'CURRENT' END AS ACCOUNT_TYPE  
 --from [172.31.16.94].inhouse.dbo.tbl_client_master   
 --where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'         
 --order by client_Code desc     
   
 declare @cnt int=0  
select @cnt=count(1) from [172.31.16.94].inhouse.dbo.tbl_client_master   
 where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'  
  
if (@cnt >0)  
 begin  
  
  
   select client_Code as cltdpid ,'NA' as ifsc,'NA' as bank_name,'NA' as bank_accno ,'NA' as ACCOUNT_TYPE  
   from [172.31.16.94].inhouse.dbo.tbl_client_master   
   where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'         
   order by client_Code desc      
   
     
 end  
 else  
  begin  
  --SELECT A.cltdpid,isnull(B.ifsc,'-') as ifsc,isnull(c.bank_name,'-') as bank_name,isnull(B.bank_accno,'-') as bank_accno ,B.ACCOUNT_TYPE FROM  (select Party_code, case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.msajag.dbo.client4 where   
  --depository in ('cdsl','nsdl') and bankid <> '12033200'  
  --and defdp ='1' and Party_code  =@Party_code  
  --union   
  --select Party_code,case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.bsedb.dbo.client4 where   
  --depository in ('cdsl','nsdl') and bankid <> '12033200'  
  --and defdp ='1' and Party_code =@Party_code) A   
  --LEFT JOIN (SELECT DISTINCT cltcode AS Party_code ,bankname AS 'ifsc',acno AS bank_accno,'SAVING' AS ACCOUNT_TYPE from CMS.dbo.NCMS_ClientBankDetails_DISPLAY WHERE cltcode =@Party_code)B  
  --ON B.Party_code =A.Party_code  
  --LEFT JOIN (SELECT LEFT( bank_name,30) AS bank_name ,Ifsc_Code FROM  risk.dbo.rtgs_master)C  
  --ON C.Ifsc_Code=B.ifsc  
  --order by A.cltdpid desc     
  
  SELECT A.cltdpid,'NA' as ifsc,'NA' as bank_name,'NA' as bank_accno ,'NA' as ACCOUNT_TYPE FROM  (select Party_code, case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.msajag.dbo.client4 where   
  depository in ('cdsl','nsdl') and bankid <> '12033200'  
  and defdp ='1' and Party_code  =@Party_code  
  union   
  select Party_code,case when depository='nsdl' then  BankId+''+CltDpId else CltDpId end as 'cltdpid'  from angeldemat.bsedb.dbo.client4 where   
  depository in ('cdsl','nsdl') and bankid <> '12033200'  
  and defdp ='1' and Party_code =@Party_code) A  
  order by A.cltdpid desc   
 end    
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getcleintDPId18072016
-- --------------------------------------------------
CREATE proc [dbo].[usp_getcleintDPId18072016]         
(        
 @Party_code varchar(10)        
)        
as         
begin        
 select client_Code as cltdpid ,DIVIDEND_BRANCH_NO 'ifsc',LEFT( bank_name,30) AS bank_name,bank_accno ,CASE WHEN BANK_ACCOUNT_TYPE =10 THEN 'SAVING' ELSE 'CURRENT' END AS ACCOUNT_TYPE
 from [172.31.16.94].inhouse.dbo.tbl_client_master 
 where nise_party_code=@Party_code and left(client_Code,8)='12033200'  and status ='ACTIVE'       
 order by client_Code desc      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETCLIENT_DETALS
-- --------------------------------------------------
CREATE proc [dbo].[USP_GETCLIENT_DETALS]  
 @PARTY_CODE VARCHAR(30)  
 AS  
BEGIN  
 SELECT LONG_NAME+ '  [' + PARTY_CODE +']' as ClNameCode,LONG_NAME as CLName 
 FROM RISK.DBO.CLIENT_DETAILS WITH(NOLOCK)   
 WHERE PARTY_CODE =@PARTY_CODE  
 AND LAST_INACTIVE_DATE >= GETDATE() AND  EMAIL <> ''   
    AND (BSECM='Y' OR NSECM='Y')   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetOfflineToOnlineStatus
-- --------------------------------------------------
Create proc [dbo].[USP_GetOfflineToOnlineStatus]
@ClientCode varchar(50)=''
AS
BEGIN

	select * from tbl_OfflinetoOnlineManualTest where Client_Code='RP61'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetOTP_FOR_BOND
-- --------------------------------------------------
CREATE proc [dbo].[USP_GetOTP_FOR_BOND]   
(
@OTPNO VARCHAR(15),    
@PARTY_CODE VARCHAR(30)    
)    
    
AS  
BEGIN    
	SELECT EMP_CODE FROM TBL_BOND_OTP WHERE OTP=@OTPNO AND EMP_CODE=@PARTY_CODE AND FLG=1     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IPO_ClientValidation
-- --------------------------------------------------



/******************************************************************************                        
 CREATED BY: PRAMOD               
 DATE: 24/08/2015                 
 PURPOSE:     
                         
 MODIFIED BY: PROGRAMMER NAME                        
 DATED: DD/MM/YYYY                        
 REASON: REASON TO CHANGE STORE PROCEDURE 
 USP_IPO_ClientValidation 'a89680','executive','e69427'                       
 ******************************************************************************/        
   CREATE proc [dbo].[USP_IPO_ClientValidation]            
   (            
   @CLIENTCODE AS VARCHAR(15)='' ,          
   @ACCESS_TO AS VARCHAR(20)='',          
   @ACCESS_CODE AS VARCHAR(20)='',
   @SRNO AS INT=0          
   )            
   AS            
   SET NOCOUNT ON          
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
   IF OBJECT_ID('TempDB..#CLIENTS') IS NOT NULL  
   DROP TABLE #CLIENTS 
   
   IF OBJECT_ID('TempDB..#CLIENT_LIMIT') IS NOT NULL  
   DROP TABLE #CLIENT_LIMIT 
    
            
   CREATE TABLE #CLIENTS
   (
   PARTY_CODE VARCHAR(15),
   LONG_NAME VARCHAR(100),
   SEGMENT VARCHAR(10)
   )
   
   
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200)                                
   --SET @ACCESS_TO='REGION'                                
   --SET @ACCESS_CODE='MAH'                                
   IF @ACCESS_TO= 'BRANCH'                                                                          
   BEGIN                                                               
    SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                
   END                                                               
   IF @ACCESS_TO='BROKER'                                                
   BEGIN                                       
    SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                            
   END                                                                                       
   IF @ACCESS_TO='SB'                                                
   BEGIN                                          
    SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                            
   END                                             
   IF @ACCESS_TO='BRMAST'                                                
   BEGIN                                          
    SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                         
   END                                                                
   IF @ACCESS_TO='SBMAST'                                                
   BEGIN                                                                   
    SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER  WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                
   END                                                                 
   IF @ACCESS_TO='REGION'                                                
   BEGIN                                          
    SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                           
   END   
   
       
   --commented by Yagnesh(11072017)
   IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)  
    --IF EXISTS(SELECT * FROM [Mimansa].angelcs.DBO.angeluserbranch WHERE EMP_NO=@ACCESS_CODE)                 
  BEGIN  
    IF OBJECT_ID('TempDB..#PARTY_MIMANSA') IS NOT NULL                      
    DROP TABLE #PARTY_MIMANSA                      
                       
    CREATE TABLE #PARTY_MIMANSA            
    (                    
    PARTY_CODE VARCHAR(30)                    
    )                    
                      
    INSERT INTO #PARTY_MIMANSA                    
    EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode                    
                        
    SET @CONDITION=' PARTY_CODE IN (SELECT PARTY_CODE FROM #PARTY_MIMANSA)'                     
  END                                     
      
    SET @STR='SELECT PARTY_CODE,LONG_NAME,case when  nsecm =''Y'' then ''NSE'' when bsecm =''Y'' then ''BSE''  else ''NULL'' end as ''SEGMENT'' FROM INTRANET.RISK.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE='''+ @CLIENTCODE +''' AND '+@CONDITION+''                       
      

      
         print (@STR) 

   INSERT INTO #CLIENTS   
   EXEC (@STR)  
   
   
   
   DECLARE @CLCNT AS INT=0
   DECLARE @PAGETYPE AS VARCHAR(50)=''                                
   DECLARE @MESSAGE AS VARCHAR(100)=''                      
   DECLARE @CONTENT AS VARCHAR(MAX) ='' 
   DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
   DECLARE @SEGMENT AS VARCHAR(10)=''
   DECLARE @DP AS int=0


--exec BondLimit @clientcode,@CLIENTLIMIT out
--print (@CLIENTLIMIT)
--print (@clientcode)

   
   SELECT @CLCNT =COUNT(1) FROM #CLIENTS  

      SELECT @SEGMENT =SEGMENT FROM #CLIENTS 


			IF @CLCNT >0
			BEGIN
   --         IF(@SEGMENT='NULL')
			--BEGIN
			--SET @MESSAGE = 'Client is not registered in NSE and BSE segment.'                                
			--	SET @PAGETYPE = 'RED'                                
			--	SET @CONTENT = 'Instructions~Ask the client to call on 18602002006'   
			--END
			--ELSE
			--BEGIN
			--SET @MESSAGE = 'Open BONDs'                                
			--SET @PAGETYPE = 'GREEN'                                
			--SET @CONTENT = 'Instructions~Ask the client to call on 18602002006' 
			--END
			--select @DP= COUNT(1)  from [172.31.16.108].inhouse.dbo.tbl_client_master 
   --         where nise_party_code=@CLIENTCODE and left(client_Code,8)='12033200'  and status ='ACTIVE'

			select @DP= sum(cnt) from (select COUNT(1) as cnt   from [AngelDP4].inhouse.dbo.tbl_client_master 
			where nise_party_code=@CLIENTCODE and left(client_Code,8)='12033200'  and status ='ACTIVE'

			union 
			select count(1) as cnt from angeldemat.msajag.dbo.client4 where 
			depository in ('cdsl','nsdl') and bankid <> '12033200'
			and defdp ='1' and Party_code  =@CLIENTCODE

			union 
			select count(1) as cnt from angeldemat.bsedb.dbo.client4 where 
			depository in ('cdsl','nsdl') and bankid <> '12033200'
			and defdp ='1' and Party_code =@CLIENTCODE)a


			IF @DP>0
			BEGIN
			SET @MESSAGE = 'Open BONDs'                                
			SET @PAGETYPE = 'GREEN'                                
			SET @CONTENT = 'Instructions~Ask the client to call on 022-33551111'
			END
			ELSE
			BEGIN
			SET @MESSAGE = 'Client does not have DP account.'                                
				SET @PAGETYPE = 'RED'                                
				SET @CONTENT = 'Instructions~Ask the client to call on 022-33551111' 
			END
			    			
			END
			ELSE
			BEGIN
						
				SET @MESSAGE = 'Client does not have DP account.'                                
				SET @PAGETYPE = 'RED'                                
				SET @CONTENT = 'Instructions~Ask the client to call on 022-33551111'   
			END     
   
   
    
	 
    
SELECT TOP 1 PARTY_CODE,LONG_NAME,@MESSAGE AS [MESSAGE],@PAGETYPE AS [PAGETYPE],@CONTENT AS CONTENT,@CLIENTLIMIT AS CLIENTLIMIT FROM  #CLIENTS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IPO_ClientValidation_IPartner
-- --------------------------------------------------



/******************************************************************************                        
 CREATED BY: PRAMOD               
 DATE: 24/08/2015                 
 PURPOSE:     
                         
 MODIFIED BY: PROGRAMMER NAME                        
 DATED: DD/MM/YYYY                        
 REASON: REASON TO CHANGE STORE PROCEDURE 
 USP_IPO_ClientValidation 'a89680','executive','e69427'                       
 ******************************************************************************/        
   CREATE proc [dbo].[USP_IPO_ClientValidation_IPartner]            
   (            
   @CLIENTCODE AS VARCHAR(15)='' ,          
   @ACCESS_TO AS VARCHAR(20)='',          
   @ACCESS_CODE AS VARCHAR(20)='',
   @SRNO AS INT=0          
   )            
   AS            
   SET NOCOUNT ON          
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
   IF OBJECT_ID('TempDB..#CLIENTS') IS NOT NULL  
   DROP TABLE #CLIENTS 
   
   IF OBJECT_ID('TempDB..#CLIENT_LIMIT') IS NOT NULL  
   DROP TABLE #CLIENT_LIMIT 
    
            
   CREATE TABLE #CLIENTS
   (
   PARTY_CODE VARCHAR(15),
   LONG_NAME VARCHAR(100),
   SEGMENT VARCHAR(10)
   )
   
   
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200)                                
   --SET @ACCESS_TO='REGION'                                
   --SET @ACCESS_CODE='MAH'                                
   IF @ACCESS_TO= 'BRANCH'                                                                          
   BEGIN                                                               
    SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                
   END                                                               
   IF @ACCESS_TO='BROKER'                                                
   BEGIN                                       
    SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                            
   END                                                                                       
   IF @ACCESS_TO='SB'                                                
   BEGIN                                          
    SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                            
   END                                             
   IF @ACCESS_TO='BRMAST'                                                
   BEGIN                                          
    SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                         
   END                                                                
   IF @ACCESS_TO='SBMAST'                                                
   BEGIN                                                                   
    SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER  WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                
   END                                                                 
   IF @ACCESS_TO='REGION'                                                
   BEGIN                                          
    SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                           
   END   
   
       
   --commented by Yagnesh(11072017)
   IF(isnumeric(right(@ACCESS_CODE,len(@ACCESS_CODE)-1))= 1)  
    --IF EXISTS(SELECT * FROM [Mimansa].angelcs.DBO.angeluserbranch WHERE EMP_NO=@ACCESS_CODE)                 
  BEGIN  
    IF OBJECT_ID('TempDB..#PARTY_MIMANSA') IS NOT NULL                      
    DROP TABLE #PARTY_MIMANSA                      
                       
    CREATE TABLE #PARTY_MIMANSA            
    (                    
    PARTY_CODE VARCHAR(30)                    
    )                    
                      
    INSERT INTO #PARTY_MIMANSA                    
    EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode                    
                        
    SET @CONDITION=' PARTY_CODE IN (SELECT PARTY_CODE FROM #PARTY_MIMANSA)'                     
  END                                     
      
    SET @STR='SELECT PARTY_CODE,LONG_NAME,case when  nsecm =''Y'' then ''NSE'' when bsecm =''Y'' then ''BSE''  else ''NULL'' end as ''SEGMENT'' FROM INTRANET.RISK.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE='''+ @CLIENTCODE +''' AND '+@CONDITION+''                       
      

      
         print (@STR) 

   INSERT INTO #CLIENTS   
   EXEC (@STR)  
   
   
   
   DECLARE @CLCNT AS INT=0
   DECLARE @PAGETYPE AS VARCHAR(50)=''                                
   DECLARE @MESSAGE AS VARCHAR(100)=''                      
   DECLARE @CONTENT AS VARCHAR(MAX) ='' 
   DECLARE @CLIENTLIMIT AS DECIMAL(18,2)=0 
   DECLARE @SEGMENT AS VARCHAR(10)=''
   DECLARE @DP AS int=0


--exec BondLimit @clientcode,@CLIENTLIMIT out
--print (@CLIENTLIMIT)
--print (@clientcode)

   
   SELECT @CLCNT =COUNT(1) FROM #CLIENTS  

      SELECT @SEGMENT =SEGMENT FROM #CLIENTS 


			IF @CLCNT >0
			BEGIN
   --         IF(@SEGMENT='NULL')
			--BEGIN
			--SET @MESSAGE = 'Client is not registered in NSE and BSE segment.'                                
			--	SET @PAGETYPE = 'RED'                                
			--	SET @CONTENT = 'Instructions~Ask the client to call on 18602002006'   
			--END
			--ELSE
			--BEGIN
			--SET @MESSAGE = 'Open BONDs'                                
			--SET @PAGETYPE = 'GREEN'                                
			--SET @CONTENT = 'Instructions~Ask the client to call on 18602002006' 
			--END
			--select @DP= COUNT(1)  from [172.31.16.108].inhouse.dbo.tbl_client_master 
   --         where nise_party_code=@CLIENTCODE and left(client_Code,8)='12033200'  and status ='ACTIVE'

			select @DP= sum(cnt) from (select COUNT(1) as cnt   from [AngelDP4].inhouse.dbo.tbl_client_master 
			where nise_party_code=@CLIENTCODE and left(client_Code,8)='12033200'  and status ='ACTIVE'

			union 
			select count(1) as cnt from angeldemat.msajag.dbo.client4 where 
			depository in ('cdsl','nsdl') and bankid <> '12033200'
			and defdp ='1' and Party_code  =@CLIENTCODE

			union 
			select count(1) as cnt from angeldemat.bsedb.dbo.client4 where 
			depository in ('cdsl','nsdl') and bankid <> '12033200'
			and defdp ='1' and Party_code =@CLIENTCODE)a


			IF @DP>0
			BEGIN
			SET @MESSAGE = 'Open BONDs'                                
			SET @PAGETYPE = 'GREEN'                                
			SET @CONTENT = 'Instructions~Ask the client to call on 022-33551111'
			END
			ELSE
			BEGIN
			SET @MESSAGE = 'Client does not have DP account.'                                
				SET @PAGETYPE = 'RED'                                
				SET @CONTENT = 'Instructions~Ask the client to call on 022-33551111' 
			END
			    			
			END
			ELSE
			BEGIN
						
				SET @MESSAGE = 'Client does not have DP account.'                                
				SET @PAGETYPE = 'RED'                                
				SET @CONTENT = 'Instructions~Ask the client to call on 022-33551111'   
			END     
   
   
    
	 
    
SELECT TOP 1 PARTY_CODE,LONG_NAME,@MESSAGE AS [MESSAGE],@PAGETYPE AS [PAGETYPE],@CONTENT AS CONTENT,@CLIENTLIMIT AS CLIENTLIMIT FROM  #CLIENTS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IPO_ClientValidation_NEW
-- --------------------------------------------------



/******************************************************************************                        
 CREATED BY: PRAMOD               
 DATE: 24/08/2015                 
 PURPOSE:     
                         
 MODIFIED BY: PROGRAMMER NAME                        
 DATED: DD/MM/YYYY                        
 REASON: REASON TO CHANGE STORE PROCEDURE 
 USP_IPO_ClientValidation 'VL002','BROKER','CSO'                       
 ******************************************************************************/        
   CREATE proc [dbo].[USP_IPO_ClientValidation_NEW]            
   (            
   @CLIENTCODE AS VARCHAR(15)='' ,          
   @ACCESS_TO AS VARCHAR(20)='',          
   @ACCESS_CODE AS VARCHAR(20)=''          
   )            
   AS            
   SET NOCOUNT ON          
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
   IF OBJECT_ID('TempDB..#CLIENTS') IS NOT NULL  
   DROP TABLE #CLIENTS 
   
   IF OBJECT_ID('TempDB..#CLIENT_LIMIT') IS NOT NULL  
   DROP TABLE #CLIENT_LIMIT 
    
            
   CREATE TABLE #CLIENTS
   (
   PARTY_CODE VARCHAR(15),
   LONG_NAME VARCHAR(100)
   )
   
   
   DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200)                                
  IF @ACCESS_TO= 'BRANCH'                                                                                                
    BEGIN                                                                                     
  SET @CONDITION='BRANCH_CD ='''+@ACCESS_CODE+''''                                                      
    END               
                 
    IF (@ACCESS_TO='BROKER' AND (@ACCESS_CODE='CSO' OR @ACCESS_CODE='HO')  )                                                                                                                                     
    BEGIN                                                      
   SET  @CONDITION='BRANCH_CD LIKE ''%'''                                                                       
    END                
  IF @ACCESS_TO='SB'                                                                      
    BEGIN                                                                
  SET   @CONDITION='SUB_BROKER='''+@ACCESS_CODE+''' '                                                                                                  
    END                                                                   
  IF @ACCESS_TO='BRMAST'                                                                      
    BEGIN                                                                
  SET  @CONDITION='BRANCH_CD IN (SELECT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER  WHERE BRMAST_CD='''+@ACCESS_CODE+''')'                                                                                               
    END                                                                                      
  IF @ACCESS_TO='SBMAST'                                                                      
    BEGIN                                                                                         
  SET   @CONDITION='SUB_BROKER IN (SELECT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER  WHERE SBMAST_CD ='''+@ACCESS_CODE+''')'                                                      
    END                                                                                       
 IF @ACCESS_TO='REGION'                                                                      
    BEGIN                                                                
   SET  @CONDITION='BRANCH_CD IN(SELECT CODE FROM INTRANET.RISK.DBO.REGION  WHERE REG_CODE='''+@ACCESS_CODE+''')'                                                                     
    END                    
       
  IF EXISTS(SELECT * FROM [Mimansa].angelcs.DBO.angeluserbranch WHERE EMP_NO=@ACCESS_CODE)                 
  BEGIN  
  print'hi'  
    IF OBJECT_ID('TempDB..#PARTY_MIMANSA') IS NOT NULL                      
    DROP TABLE #PARTY_MIMANSA                      
                       
    CREATE TABLE #PARTY_MIMANSA            
    (                    
    PARTY_CODE VARCHAR(30)                    
    )                    
                      
    INSERT INTO #PARTY_MIMANSA                    
    EXEC [Mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO=@ACCESS_CODE,@STATUSID=@ACCESS_TO,@PARTY_CODE=@clientcode                    
                        
    SET @CONDITION=' PARTY_CODE IN (SELECT PARTY_CODE FROM #PARTY_MIMANSA)'                     
  END             
                         
    SET @STR='SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE='''+ @clientcode +''' AND '+@CONDITION+''                                             
          print @STR                  
   EXEC (@STR)                                    
                 
      
             
   SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IPO_Excption
-- --------------------------------------------------
CREATE proc [dbo].[USP_IPO_Excption]
@Source varchar(30)='',
@Message varchar(max)='',
@UserId varchar(50)='',
@IP varchar(50)=''

AS BEGIN 

if @Message not like '%Thread was being%'
begin 
INSERT INTO tbl_IPO_Exceptionlog(Source,Message,UserId,IP,OccuredOn)
VALUES (@Source,@Message,@UserId,@IP,getdate())
end


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_NSE_Reverse_Upload
-- --------------------------------------------------
-- [Usp_NSE_Reverse_Upload] 'nse_reverse.csv'  
CREATE procEDURE [dbo].[Usp_NSE_Reverse_Upload]  
(@filename as varchar(max))           
          
AS          
BEGIN          
Declare @file as varchar(max)  ,@Delimiter as varchar(max)= ',',@newline as varchar(max) = '\n'     

truncate table Bond_OrderFile_NSE_Success

--truncate table Bond_OrderFile_NSE_Success_history  
--truncate table Bond_OrderFile_NSE_Success    
               
--Declare @path as varchar(max)= '\\196.1.115.183\d$\Inetpub\wwwroot\AngelInHouse_3.5\BondUpload\Bond_Upload_Files\';     
Declare @path as varchar(max)= '\\196.1.115.147\Upload1\UploadAdvChart\';          
     
set @file = (@path+@filename);  
  
exec('BULK INSERT Bond_OrderFile_NSE_Success FROM ''' +@file+''' WITH (FIRSTROW = 1,FIELDTERMINATOR = '''+@Delimiter+''', ROWTERMINATOR = '''+@newline+''')')                    

--declare @var as varchar(500)='DEL '+@path  

--exec master.dbo.xp_cmdshell @var  
 
Insert into Bond_OrderFile_NSE_Success_history     
Select Symbol,Series,depository_name,dp_id,benficiary_id,bid_quantity,rate_price,pan_number,reference_number,
order_number,activity_type,application_number,user_id,GETDATE() 
from Bond_OrderFile_NSE_Success

update a  
set a.order_status='Executed',ReverseConfirmation=getdate()
from tbl_BONDOrderEntry a
inner join Bond_OrderFile_NSE_Success b 
on a.PAN=b.pan_number
where Order_Status='Exported' and a.Segment='NSE' 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_NSE_Reverse_Upload_13072022
-- --------------------------------------------------
--EXEC [Usp_NSE_Reverse_Upload_13072022] 'sample upload file.csv'
CREATE procEDURE [dbo].[Usp_NSE_Reverse_Upload_13072022]  
(@filename as varchar(max))           
          
AS          
BEGIN          
Declare @file as varchar(max)  ,@Delimiter as varchar(max)= ',',@newline as varchar(max) = '\n'     

truncate table Bond_OrderFile_NSE_Success_13072022

--truncate table Bond_OrderFile_NSE_Success_history  
--truncate table Bond_OrderFile_NSE_Success    
               
--Declare @path as varchar(max)= '\\196.1.115.183\d$\Inetpub\wwwroot\AngelInHouse_3.5\BondUpload\Bond_Upload_Files\';     
--Declare @path as varchar(max)= '\\196.1.115.147\Upload1\UploadAdvChart\';   
Declare @path as varchar(max)= '\\196.1.115.136\icicih2h\Reportbackup\';   
--Declare @path as varchar(max)= 'E:\Satyajeet Personal\';
     
set @file = (@path+@filename);  
  
exec('BULK INSERT Bond_OrderFile_NSE_Success_13072022 FROM ''' +@file+''' WITH (FIRSTROW = 1,FIELDTERMINATOR = '''+@Delimiter+''', ROWTERMINATOR = '''+@newline+''')')                    

--declare @var as varchar(500)='DEL '+@path  

--exec master.dbo.xp_cmdshell @var  
 
Insert into Bond_OrderFile_NSE_Success_history_13072022     
Select 
[Symbol] ,
	[ApplicationNo] ,
	[Category] ,
	[ClientName] ,
	[DepositoryName] ,
	[DPid] ,
	[BeneficiaryId] ,
	[BidQuantity] ,
	[CutoffIndicator] ,
	[Rate] ,
	[ChequeReceivedFlag],
	[ChequeAmount] ,
	[ChequeNumber] ,
	[Pannumber] ,
	[BankName] ,
	[LocationCode] ,
	[RefNo] ,
	[OrderNo] ,
	[ActivityType] 
	--user_id,GETDATE() 
from Bond_OrderFile_NSE_Success_13072022

update a  
set a.order_status='Executed',ReverseConfirmation=getdate()
from tbl_BONDOrderEntry_13072022 a
inner join Bond_OrderFile_NSE_Success_13072022 b 
on a.PAN=b.Pannumber
where Order_Status='Exported' and a.Segment='NSE' 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_NSE_Reverse_Upload_20Dec2022
-- --------------------------------------------------
-- [Usp_NSE_Reverse_Upload] 'nse_reverse.csv'  
create procEDURE [dbo].[Usp_NSE_Reverse_Upload_20Dec2022]  
(@filename as varchar(max))           
          
AS          
BEGIN          
Declare @file as varchar(max)  ,@Delimiter as varchar(max)= ',',@newline as varchar(max) = '\n'     

truncate table Bond_OrderFile_NSE_Success

--truncate table Bond_OrderFile_NSE_Success_history  
--truncate table Bond_OrderFile_NSE_Success    
               
--Declare @path as varchar(max)= '\\196.1.115.183\d$\Inetpub\wwwroot\AngelInHouse_3.5\BondUpload\Bond_Upload_Files\';     
Declare @path as varchar(max)= '\\196.1.115.147\Upload1\UploadAdvChart\';          
     
set @file = (@path+@filename);  
  
exec('BULK INSERT Bond_OrderFile_NSE_Success FROM ''' +@file+''' WITH (FIRSTROW = 1,FIELDTERMINATOR = '''+@Delimiter+''', ROWTERMINATOR = '''+@newline+''')')                    

--declare @var as varchar(500)='DEL '+@path  

--exec master.dbo.xp_cmdshell @var  
 
Insert into Bond_OrderFile_NSE_Success_history     
Select Symbol,Series,depository_name,dp_id,benficiary_id,bid_quantity,rate_price,pan_number,reference_number,
order_number,activity_type,application_number,user_id,GETDATE() 
from Bond_OrderFile_NSE_Success

update a  
set a.order_status='Executed',ReverseConfirmation=getdate()
from tbl_BONDOrderEntry a
inner join Bond_OrderFile_NSE_Success b 
on a.PAN=b.pan_number
where Order_Status='Exported' and a.Segment='NSE' 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_NSE_Reverse_Upload_NewFileFormate
-- --------------------------------------------------
/*
	CHANGE ID  :: 1                          
    MODIFIED BY  :: Satyajeet Mall                              
    MODIFIED DATE :: Jul 13 2022                              
    REASON   :: For NSE Reverse Upload File Formate

*/
--EXEC [Usp_NSE_Reverse_Upload_NewFileFormate] 'NSEOrder_Report20221010130407_success.csv'
CREATE procEDURE [dbo].[Usp_NSE_Reverse_Upload_NewFileFormate]  
(@filename as varchar(max))           
          
AS          
BEGIN          
Declare @file as varchar(max)  ,@Delimiter as varchar(max)= ',',@newline as varchar(max) = '\n'     

truncate table Bond_OrderFile_NSE_Success_NewFileFormate

--truncate table Bond_OrderFile_NSE_Success_history  
--truncate table Bond_OrderFile_NSE_Success    
               
--Declare @path as varchar(max)= '\\196.1.115.183\d$\Inetpub\wwwroot\AngelInHouse_3.5\BondUpload\Bond_Upload_Files\';     
Declare @path as varchar(max)= '\\196.1.115.147\Upload1\UploadAdvChart\';   
--Declare @path as varchar(max)= '\\196.1.115.136\icicih2h\Reportbackup\';   
--Declare @path as varchar(max)= 'E:\Satyajeet Personal\';
     
set @file = (@path+@filename);  
  
exec('BULK INSERT Bond_OrderFile_NSE_Success_NewFileFormate FROM ''' +@file+''' WITH (FIRSTROW = 1,FIELDTERMINATOR = '''+@Delimiter+''', ROWTERMINATOR = '''+@newline+''')')                    

--declare @var as varchar(500)='DEL '+@path  

--exec master.dbo.xp_cmdshell @var  
 
Insert into Bond_OrderFile_NSE_Success_history_NewFileFormate    
Select 
[Symbol] ,
	[ApplicationNo] ,
	[Category] ,
	[ClientName] ,
	[DepositoryName] ,
	[DPid] ,
	[BeneficiaryId] ,
	[BidQuantity] ,
	[CutoffIndicator] ,
	[Rate] ,
	[ChequeReceivedFlag],
	[ChequeAmount] ,
	[ChequeNumber] ,
	[Pannumber] ,
	[BankName] ,
	[LocationCode] ,
	[RefNo] ,
	[OrderNo] ,
	[ActivityType] ,userid
	--user_id,GETDATE() 
from Bond_OrderFile_NSE_Success_NewFileFormate

update a  
set a.order_status='Executed',ReverseConfirmation=getdate()
from tbl_BONDOrderEntry a
inner join Bond_OrderFile_NSE_Success_NewFileFormate b 
on a.PAN=b.pannumber
where Order_Status='Exported' and a.Segment='NSE' 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NXT_IPartner_BOND_ORDERBOOK
-- --------------------------------------------------
-- =============================================
-- Author:		Vivek Sphere
-- Create date: 25/02/2019
-- Description:	USP_NXT_IPartner_BOND_ORDERBOOK
-- exec USP_NXT_IPartner_BOND_ORDERBOOK '01/02/2019','25/02/2019','CBHO'
-- exec USP_NXT_IPartner_BOND_ORDERBOOK '','','CBHO'
-- =============================================
CREATE PROCEDURE [dbo].[USP_NXT_IPartner_BOND_ORDERBOOK]
	-- Add the parameters for the stored procedure here
	@FromDate varchar(30)=null,@ToDate varchar(30)=null,@SUB_BROKER varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @FromDate=''
	BEGIN
	     SELECT  EntryId,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
	     Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
	     [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'')  ,
	     case when  Order_Status='PENDING' then '<input onclientclick="return false;" type="button" id='+cast (EntryId as varchar(50))+' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">'  else Order_Status   end as [Order Status] 
	     ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason
	     FROM (select * from tbl_BONDOrderEntry where Order_Date > '01-Oct-2017') a 
	     INNER JOIN  INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code and SUB_BROKER=@SUB_BROKER  
	     order by a.Order_Date desc
	END
	ELSE 
	 BEGIN
	     SELECT  EntryId,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
	     Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
	     [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'')  ,
	     case when  Order_Status='PENDING' then '<input onclientclick="return false;" type="button" id='+cast (EntryId as varchar(50))+' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">'  else Order_Status   end as [Order Status] 
	     ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason
	     FROM (select * from tbl_BONDOrderEntry where Order_Date > '01-Oct-2017') a 
	     INNER JOIN  INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code and SUB_BROKER=@SUB_BROKER  
	     where CONVERT(datetime,a.Order_Date,103) between CONVERT(datetime,@FromDate,103) and CONVERT(datetime,@ToDate,103)
	     order by a.Order_Date desc
	 END
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NXT_IPartner_BOND_ORDERBOOK_opti_18Apr2022
-- --------------------------------------------------
-- =============================================
-- Author:		Vivek Sphere
-- Create date: 25/02/2019
-- Description:	USP_NXT_IPartner_BOND_ORDERBOOK
-- exec USP_NXT_IPartner_BOND_ORDERBOOK '01/02/2019','25/02/2019','CBHO'
-- exec [USP_NXT_IPartner_BOND_ORDERBOOK_opti_18Apr2022] '','','bblm'
-- =============================================
CREATE PROCEDURE [dbo].[USP_NXT_IPartner_BOND_ORDERBOOK_opti_18Apr2022]
	-- Add the parameters for the stored procedure here
	@FromDate varchar(30)=null,@ToDate varchar(30)=null,@SUB_BROKER varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT PARTY_CODE,INACTIVE_FROM INTO #CLIENT_DETAILS200
	FROM [196.1.115.200].BSEMFSS.DBO.MFSS_CLIENT  B WITH(NOLOCK)  
	WHERE SUB_BROKER = @SUB_BROKER
	
	SELECT a.PARTY_CODE,a.LONG_NAME,          
	BRANCH_CD = (CASE WHEN a.BRANCH_CD IN ('NRIS','CALNT') THEN a.ORI_BRANCH_CD ELSE a.BRANCH_CD END),          
	SUB_BROKER = (CASE WHEN a.SUB_BROKER IN ('NRIS','CALNT') THEN a.ORI_SUB_BROKER ELSE a.SUB_BROKER END)          
	,a.[b2c]      
	INTO #VWMFSS_CLIENTDETAILS 
	FROM risk.DBO.CLIENT_DETAILS a with(nolock)  
	JOIN #CLIENT_DETAILS200  b with(nolock)   
	on a.cl_code = b.party_code  
	where (b.INACTIVE_FROM > getdate() OR b.INACTIVE_FROM  Is NULL)
	and a.SUB_BROKER=@SUB_BROKER 

	select * INTO #tbl_BONDOrderEntry from tbl_BONDOrderEntry with(nolock)  where Order_Date > '01-Oct-2017'

    -- Insert statements for procedure here
	IF @FromDate=''
	BEGIN
	     SELECT  EntryId,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
	     Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
	     [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'')  ,
	     case when  Order_Status='PENDING' then '<input onclientclick="return false;" type="button" id='+cast (EntryId as varchar(50))+' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">'  else Order_Status   end as [Order Status] 
	     ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason
	     FROM (select * from #tbl_BONDOrderEntry with(nolock))a-- where Order_Date > '01-Oct-2017') a 
	     INNER JOIN  #VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code --and SUB_BROKER=@SUB_BROKER  
	     order by a.Order_Date desc
	END
	ELSE 
	 BEGIN
	     SELECT  EntryId,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
	     Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
	     [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'')  ,
	     case when  Order_Status='PENDING' then '<input onclientclick="return false;" type="button" id='+cast (EntryId as varchar(50))+' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">'  else Order_Status   end as [Order Status] 
	     ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason
	     FROM (select * from #tbl_BONDOrderEntry with(nolock) )a-- where Order_Date > '01-Oct-2017') a 
	     INNER JOIN  #VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code --and SUB_BROKER=@SUB_BROKER  
	     where CONVERT(datetime,a.Order_Date,103) between CONVERT(datetime,@FromDate,103) and CONVERT(datetime,@ToDate,103)
	     order by a.Order_Date desc
	 END
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NXT_IPartner_BOND_ORDERBOOK_UAT
-- --------------------------------------------------
-- =============================================
-- Author:		Vivek Sphere
-- Create date: 25/02/2019
-- Description:	USP_NXT_IPartner_BOND_ORDERBOOK
-- exec USP_NXT_IPartner_BOND_ORDERBOOK '01/02/2019','25/02/2019','CBHO'
-- exec USP_NXT_IPartner_BOND_ORDERBOOK_UAT '','','CBHO'
-- =============================================
CREATE PROCEDURE [dbo].[USP_NXT_IPartner_BOND_ORDERBOOK_UAT]
	-- Add the parameters for the stored procedure here
	@FromDate varchar(30)=null,@ToDate varchar(30)=null,@SUB_BROKER varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @FromDate=''
	BEGIN
	     SELECT  EntryId,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
	     Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
	     [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'')  ,
	     case when  Order_Status='PENDING' then '<input onclientclick="return false;" type="button" id='+cast (EntryId as varchar(50))+' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">'  else Order_Status   end as [Order Status] 
	     ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason
	     FROM (select * from tbl_BONDOrderEntry_UAT where Order_Date > '01-Oct-2017') a 
	     INNER JOIN  INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code and SUB_BROKER=@SUB_BROKER  
	     order by a.Order_Date desc
	END
	ELSE 
	 BEGIN
	     SELECT  EntryId,BOND_Name as [Bond Name],Client_Code as [Client Code],ClientName as [Client Name],PAN as [PAN Number],DP as [DP ID],Order_Status as [Order Status],
	     Order_Qty as [Order Quantity],cast((RATE) as  decimal(16,2)) as Rate,cast((Total) as  decimal(16,2)) as [Total Amount],Segment as
	     [Bidding Exchange],Channel ,[SB/Dealer]=ISNULL(access_code,'')  ,
	     case when  Order_Status='PENDING' then '<input onclientclick="return false;" type="button" id='+cast (EntryId as varchar(50))+' value="REJECT" class="submit-button reject" style="font-size: 12px; height: 35px; width: 75px;">'  else Order_Status   end as [Order Status] 
	     ,convert(varchar(10),a.Order_Date,103) as Order_Date,Comment as Reason
	     FROM (select * from tbl_BONDOrderEntry_UAT where Order_Date > '01-Oct-2017') a 
	     INNER JOIN  INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS b WITH (NOLOCK) on a.Client_Code=b.party_code and SUB_BROKER=@SUB_BROKER  
	     where CONVERT(datetime,a.Order_Date,103) between CONVERT(datetime,@FromDate,103) and CONVERT(datetime,@ToDate,103)
	     order by a.Order_Date desc
	 END
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UI_Get_BONDMaster
-- --------------------------------------------------
  
CREATE proc [dbo].[USP_UI_Get_BONDMaster]  
 @Process varchar(100)='',  
 @BONDName VARCHAR(200)='',   
 @BONDSRNO INT=0,  
 @FromDate DATETIME,    
 @ToDate DATETIME ,  
 @Client_Code varchar(50)=''   
AS    
    
--EXEC dbo.USP_UI_Get_BONDMaster '',''    
--EXEC dbo.USP_UI_Get_BONDMaster '2013-01-01','2015-07-15'    
    
BEGIN    
 SET NOCOUNT ON    
  
     
 BEGIN   
   
   IF(@Process ='GETALLBOND')  
   BEGIN  
  
     ----OPEN BONDS  
      SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series', cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))  
      FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)    
      WHERE getdate() BETWEEN Startdate  AND Enddate  
  
      ----FORT COMMING  
  
      SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))  
      FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)    
      WHERE getdate() < Startdate    
  
  
     ----FORT CLOSED  
  
    SELECT  Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))  
      FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)    
      WHERE getdate() > Enddate   
  
  
  
  
   END   
  
  
    IF @Process='GETBONDBYSRNO'  
    BEGIN   
   
   -- Declare @IPO_Process as varchar(50)=''  
   
   --select m.*,case when (e.BOND_SrNo is null)then 'ADD' else 'UPDATE' end as 'Status' from (select * from  [TBL_BondMaster] where Srno=@BONDSRNO) m  
   --left join (select * from tbl_BONDOrderEntry where Client_Code =@Client_Code  and Order_Status<>'REJECTED' ) e  
   --on e.BOND_SrNo=m.Srno  
  
    declare @pan as varchar(50)=''  
    select @pan=pan_gir_no  from INTRANET.RISK.DBO.client_details where cl_code =@Client_Code  
  
    select Srno,SchemeName,Symbol,series,Rate,Startdate,  
                Enddate ,MinQty,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,MaxQty-ISNULL(qty,0) as MaxQty,  
                case when (e.BOND_SrNo is null) or ISNULL(qty,0) < MAXQ    then 'ADD' else 'UPDATE' end as 'Status',Category,MultipleOf   
                from (select Srno,SchemeName,Symbol,series,Rate,Startdate,  
                Enddate ,MinQty,MaxQty as MAXQ,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,MaxQty,Category,MultipleOf  from  [TBL_BondMaster] where Srno=@BONDSRNO) m  
       left join (select BOND_SrNo,ISNULL(SUM (order_qty),0) as qty from tbl_BONDOrderEntry where PAN =@pan  and Order_Status<>'REJECTED' group by BOND_SrNo ) e  
       on e.BOND_SrNo=m.Srno  
    
   
    END  
 END  
    
  
  
   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UI_Get_BONDMaster_IPartner
-- --------------------------------------------------
--USP_UI_Get_BONDMaster_IPartner 'GetAllBond','','','','',''
CREATE proc [dbo].[USP_UI_Get_BONDMaster_IPartner]
 @Process varchar(100)='',
 @BONDName VARCHAR(200)='', 
 @BONDSRNO INT=0,
 @FromDate DATETIME,  
 @ToDate DATETIME ,
 @Client_Code varchar(50)='' 
AS  
  
--EXEC dbo.USP_UI_Get_BONDMaster '',''  
--EXEC dbo.USP_UI_Get_BONDMaster '2013-01-01','2015-07-15'  
  
BEGIN  
 SET NOCOUNT ON  

   
 BEGIN 
 
		 IF(@Process ='GETALLBOND')
		 BEGIN

				 ----OPEN BONDS
				  SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series', cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() BETWEEN Startdate  AND Enddate

				  ----FORT COMMING

				  SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() < Startdate  


					----FORT CLOSED

				SELECT  Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() > Enddate 




		 END 


		  IF @Process='GETBONDBYSRNO'
			 BEGIN 
 
			-- Declare @IPO_Process as varchar(50)=''
 
			--select m.*,case when (e.BOND_SrNo is null)then 'ADD' else 'UPDATE' end as 'Status' from (select * from  [TBL_BondMaster] where Srno=@BONDSRNO) m
			--left join (select * from tbl_BONDOrderEntry where Client_Code =@Client_Code  and Order_Status<>'REJECTED' ) e
			--on e.BOND_SrNo=m.Srno

				declare @pan as varchar(50)=''
				select @pan=pan_gir_no  from INTRANET.RISK.DBO.client_details where cl_code =@Client_Code

				select Srno,SchemeName,Symbol,series,Rate,Startdate,
                Enddate ,MinQty,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,MaxQty-ISNULL(qty,0) as MaxQty,case when (e.BOND_SrNo is null) or ISNULL(qty,0) < MAXQ    then 'ADD' else 'UPDATE' end as 'Status' from (select Srno,SchemeName,Symbol,series,Rate,Startdate,
                Enddate ,MinQty,MaxQty as MAXQ,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,MaxQty  from  [TBL_BondMaster] where Srno=@BONDSRNO) m
			    left join (select BOND_SrNo,ISNULL(SUM (order_qty),0) as qty from tbl_BONDOrderEntry where PAN =@pan  and Order_Status<>'REJECTED' group by BOND_SrNo ) e
			    on e.BOND_SrNo=m.Srno
  
 
			 END
 END
  


	

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UI_Get_BONDMaster_IPartner_UAT
-- --------------------------------------------------
--USP_UI_Get_BONDMaster_IPartner_UAT 'GetAllBond','','','','',''
CREATE proc [dbo].[USP_UI_Get_BONDMaster_IPartner_UAT]
 @Process varchar(100)='',
 @BONDName VARCHAR(200)='', 
 @BONDSRNO INT=0,
 @FromDate DATETIME,  
 @ToDate DATETIME ,
 @Client_Code varchar(50)='' 
AS  
  
--EXEC dbo.USP_UI_Get_BONDMaster '',''  
--EXEC dbo.USP_UI_Get_BONDMaster '2013-01-01','2015-07-15'  
  
BEGIN  
 SET NOCOUNT ON  

   
 BEGIN 
 
		 IF(@Process ='GETALLBOND')
		 BEGIN

				 ----OPEN BONDS
				  SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series', cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM TBL_BondMaster_UAT--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() BETWEEN Startdate  AND Enddate

				  ----FORT COMMING

				  SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM TBL_BondMaster_UAT--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() < Startdate  


					----FORT CLOSED

				SELECT  Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM TBL_BondMaster_UAT--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() > Enddate 




		 END 


		  IF @Process='GETBONDBYSRNO'
			 BEGIN 
 
			-- Declare @IPO_Process as varchar(50)=''
 
			--select m.*,case when (e.BOND_SrNo is null)then 'ADD' else 'UPDATE' end as 'Status' from (select * from  [TBL_BondMaster] where Srno=@BONDSRNO) m
			--left join (select * from tbl_BONDOrderEntry where Client_Code =@Client_Code  and Order_Status<>'REJECTED' ) e
			--on e.BOND_SrNo=m.Srno

				declare @pan as varchar(50)=''
				select @pan=pan_gir_no  from INTRANET.RISK.DBO.client_details where cl_code =@Client_Code

				select Srno,SchemeName,Symbol,series,Rate,Startdate,
                Enddate ,MinQty,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,MaxQty-ISNULL(qty,0) as MaxQty,case when (e.BOND_SrNo is null) or ISNULL(qty,0) < MAXQ    then 'ADD' else 'UPDATE' end as 'Status' from (select Srno,SchemeName,Symbol,series,Rate,Startdate,
                Enddate ,MinQty,MaxQty as MAXQ,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,MaxQty  from  TBL_BondMaster_UAT where Srno=@BONDSRNO) m
			    left join (select BOND_SrNo,ISNULL(SUM (order_qty),0) as qty from tbl_BONDOrderEntry where PAN =@pan  and Order_Status<>'REJECTED' group by BOND_SrNo ) e
			    on e.BOND_SrNo=m.Srno
  
 
			 END
 END
  


	

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UI_Get_BONDMaster_UAT
-- --------------------------------------------------


CREATE proc [dbo].[USP_UI_Get_BONDMaster_UAT]
 @Process varchar(100)='',
 @BONDName VARCHAR(200)='', 
 @BONDSRNO INT=0,
 @FromDate DATETIME,  
 @ToDate DATETIME ,
 @Client_Code varchar(50)='' 
AS  
  
--EXEC dbo.USP_UI_Get_BONDMaster '',''  
--EXEC dbo.USP_UI_Get_BONDMaster '2013-01-01','2015-07-15'  
  
BEGIN  
 SET NOCOUNT ON  

   
 BEGIN 
 
		 IF(@Process ='GETALLBOND')
		 BEGIN

				 ----OPEN BONDS
				  SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series', cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() BETWEEN Startdate  AND Enddate

				  ----FORT COMMING

				  SELECT Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() < Startdate  


					----FORT CLOSED

				SELECT  Srno, SchemeName as 'Bond Name',Symbol,series as 'Bond Series',cast (cast( Rate as varchar(50)) as decimal (18,2)) as 'Bond Rate',MaxQty as 'Max Qty', OpenDate=DATEADD(hh,9,DATEDIFF(dd,0,Startdate)),CloseDate=DATEADD(hh,17,DATEDIFF(dd,0,Enddate))
				  FROM tbl_BondMaster--dbo.Vw_BONDMaster WITH (NOLOCK)  
				  WHERE getdate() > Enddate 




		 END 


		  IF @Process='GETBONDBYSRNO'
			 BEGIN 
 
			 Declare @IPO_Process as varchar(50)=''
 
			select m.*,case when (e.BOND_SrNo is null)then 'ADD' else 'UPDATE' end as 'Status' from (select * from  [TBL_BondMaster] where Srno=@BONDSRNO) m
			left join (select * from tbl_BONDOrderEntry_test where Client_Code =@Client_Code  and Order_Status<>'REJECTED' ) e
			on e.BOND_SrNo=m.Srno
  
 
			 END
 END
  


	

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPGetDealerClients_bond
-- --------------------------------------------------
--INSERT INTO ##PARTY_MIMANSA                                      
--EXEC USPGetDealerClients_bond 'E59646','broker'

CREATE procEDURE [dbo].[USPGetDealerClients_bond](@ACCESS_CODE VARCHAR(50),@ACCESS_TO VARCHAR(50))            
AS            
BEGIN            
IF(@ACCESS_TO <>'EXECUTIVE')            
 BEGIN            
    SELECT PARTY_CODE AS 'CLIENTCODE',LONG_NAME AS 'CLIENTNAME'        
    FROM (SELECT BRANCH_CD FROM [Mimansa].ANGELCS.DBO.ANGELUSERBRANCH with(nolock) WHERE EMP_NO = @ACCESS_CODE) ab             
    JOIN (SELECT PARTY_CODE, BRANCH_CD, LONG_NAME FROM [Mimansa].ANGELCS.DBO.ANGELCLIENT1  with(nolock)) PARTY  ON AB.BRANCH_CD = PARTY.BRANCH_CD      
    JOIN (SELECT DISTINCT CLIENT_CODE FROM tbl_BONDOrderEntry  with(nolock)) SIP ON PARTY.PARTY_CODE = SIP.CLIENT_CODE    
 END            
 ELSE            
 BEGIN            
    SELECT PARTY_CODE AS 'CLIENTCODE',LONG_NAME AS 'CLIENTNAME'        
    FROM [Mimansa].ANGELCS.DBO.ANGELCLIENT1 PARTY  with(nolock)          
   JOIN (SELECT DISTINCT  CLIENT_CODE FROM tbl_BONDOrderEntry  with(nolock) ) SIP ON PARTY.PARTY_CODE = SIP.CLIENT_CODE    
    WHERE RMDEALER = @ACCESS_CODE OR COMMDEALER1 = @ACCESS_CODE OR COMMDEALER2 = @ACCESS_CODE OR CURRENCYDEALER = @ACCESS_CODE             
 END            
END

GO

-- --------------------------------------------------
-- TABLE dbo.ActiveOrders_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[ActiveOrders_RENAMEDAS_PII]
(
    [Symbol] NVARCHAR(255) NULL,
    [Application No] NVARCHAR(255) NULL,
    [Bid Qty] FLOAT NULL,
    [Price] FLOAT NULL,
    [Amount] FLOAT NULL,
    [DP Name] NVARCHAR(255) NULL,
    [PAN No] NVARCHAR(255) NULL,
    [Mode] NVARCHAR(255) NULL,
    [Order Type] NVARCHAR(255) NULL,
    [Order Status] NVARCHAR(255) NULL,
    [Entry Time] DATETIME NULL,
    [Exchange] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bbnf
-- --------------------------------------------------
CREATE TABLE [dbo].[bbnf]
(
    [party_code] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Batch_process
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Batch_process]
(
    [Srno] INT NOT NULL,
    [ProcedureName] VARCHAR(200) NULL,
    [Active_Status] INT NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Flag] INT NULL,
    [spdesc] VARCHAR(200) NULL,
    [Errflag] VARCHAR(100) NULL,
    [section] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bond_batch_process_23Aug2023
-- --------------------------------------------------
CREATE TABLE [dbo].[bond_batch_process_23Aug2023]
(
    [Srno] INT NOT NULL,
    [ProcedureName] VARCHAR(200) NULL,
    [Active_Status] INT NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Flag] INT NULL,
    [spdesc] VARCHAR(200) NULL,
    [Errflag] VARCHAR(100) NULL,
    [section] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bond_batch_process_28May2021
-- --------------------------------------------------
CREATE TABLE [dbo].[bond_batch_process_28May2021]
(
    [Srno] INT NOT NULL,
    [ProcedureName] VARCHAR(200) NULL,
    [Active_Status] INT NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Flag] INT NULL,
    [spdesc] VARCHAR(200) NULL,
    [Errflag] VARCHAR(100) NULL,
    [section] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Batch_process_log
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Batch_process_log]
(
    [Srno] INT NOT NULL,
    [ProcedureName] VARCHAR(200) NULL,
    [Active_Status] INT NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Flag] INT NULL,
    [spdesc] VARCHAR(200) NULL,
    [Errflag] VARCHAR(100) NULL,
    [section] INT NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Jv
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Jv]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [tosegment] VARCHAR(5) NOT NULL,
    [markedamount] MONEY NULL,
    [availableamount] MONEY NULL,
    [JVAmount] MONEY NULL,
    [JVDate] DATETIME NULL,
    [ProcessDate] DATETIME NOT NULL,
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BO_Posted] VARCHAR(1) NOT NULL,
    [BO_RowState] INT NOT NULL,
    [OrderQty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Jv_28May2021
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Jv_28May2021]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [tosegment] VARCHAR(5) NOT NULL,
    [markedamount] MONEY NULL,
    [availableamount] MONEY NULL,
    [JVAmount] MONEY NULL,
    [JVDate] DATETIME NULL,
    [ProcessDate] DATETIME NOT NULL,
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BO_Posted] VARCHAR(1) NOT NULL,
    [BO_RowState] INT NOT NULL,
    [OrderQty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Jv_log
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Jv_log]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [tosegment] VARCHAR(5) NOT NULL,
    [markedamount] MONEY NULL,
    [availableamount] MONEY NULL,
    [JVAmount] MONEY NULL,
    [JVDate] DATETIME NULL,
    [ProcessDate] DATETIME NOT NULL,
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BO_Posted] VARCHAR(1) NOT NULL,
    [BO_RowState] INT NOT NULL,
    [OrderQty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Notallow
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Notallow]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [netpayable] MONEY NULL,
    [Order_qty] INT NULL,
    [srno] BIGINT NULL,
    [clientsrno] BIGINT NULL,
    [Adjustamt] MONEY NULL,
    [entryid] INT NOT NULL,
    [Updatedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_NotAllowed
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_NotAllowed]
(
    [Party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [netpayable] MONEY NULL,
    [Order_Qty] INT NULL,
    [EntryId] INT NOT NULL,
    [Updatedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_BSE
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_BSE]
(
    [ScripId] VARCHAR(100) NULL,
    [ApplicationNumber] VARCHAR(100) NOT NULL,
    [Category] VARCHAR(3) NOT NULL,
    [ApplicantName] VARCHAR(100) NULL,
    [Depository] VARCHAR(100) NOT NULL,
    [DPid] VARCHAR(30) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [Qty] INT NULL,
    [cutoffFlag] INT NOT NULL,
    [Rate] MONEY NULL,
    [ChequeReceivedFlag] VARCHAR(100) NOT NULL,
    [ChequeAmount] VARCHAR(100) NOT NULL,
    [ChequeNumber] VARCHAR(100) NOT NULL,
    [pannumber] VARCHAR(20) NULL,
    [Bankname] VARCHAR(100) NOT NULL,
    [location] VARCHAR(100) NOT NULL,
    [AccountNumber] VARCHAR(100) NOT NULL,
    [BidId] VARCHAR(100) NOT NULL,
    [ActivityType] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_BSE_Success_history_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_BSE_Success_history_RENAMEDAS_PII]
(
    [Scrip_Id] VARCHAR(200) NULL,
    [Application_No] VARCHAR(200) NULL,
    [Category] VARCHAR(200) NULL,
    [Applicant_Name] VARCHAR(200) NULL,
    [Depository] VARCHAR(200) NULL,
    [DpID] VARCHAR(200) NULL,
    [ClientId_Benf_Id] VARCHAR(200) NULL,
    [Quantity] VARCHAR(200) NULL,
    [Cut_off_flag] VARCHAR(200) NULL,
    [Rate] VARCHAR(200) NULL,
    [Cheque_Received_Flag] VARCHAR(200) NULL,
    [Cheque_Amount] VARCHAR(200) NULL,
    [Cheque_Number] VARCHAR(200) NULL,
    [Pan_No] VARCHAR(200) NULL,
    [Bank_Name] VARCHAR(200) NULL,
    [Location] VARCHAR(200) NULL,
    [Account_Number] VARCHAR(200) NULL,
    [Bid_Id] VARCHAR(200) NULL,
    [Action_Code] VARCHAR(200) NULL,
    [added_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_BSE_Success_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_BSE_Success_RENAMEDAS_PII]
(
    [Scrip_Id] VARCHAR(200) NULL,
    [Application_No] VARCHAR(200) NULL,
    [Category] VARCHAR(200) NULL,
    [Applicant_Name] VARCHAR(200) NULL,
    [Depository] VARCHAR(200) NULL,
    [DpID] VARCHAR(200) NULL,
    [ClientId_Benf_Id] VARCHAR(200) NULL,
    [Quantity] VARCHAR(200) NULL,
    [Cut_off_flag] VARCHAR(200) NULL,
    [Rate] VARCHAR(200) NULL,
    [Cheque_Received_Flag] VARCHAR(200) NULL,
    [Cheque_Amount] VARCHAR(200) NULL,
    [Cheque_Number] VARCHAR(200) NULL,
    [Pan_No] VARCHAR(200) NULL,
    [Bank_Name] VARCHAR(200) NULL,
    [Location] VARCHAR(200) NULL,
    [Account_Number] VARCHAR(200) NULL,
    [Bid_Id] VARCHAR(200) NULL,
    [Action_Code] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_NewFileFormate
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_NewFileFormate]
(
    [Symbol] VARCHAR(100) NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [Category] VARCHAR(10) NULL,
    [ClientName] VARCHAR(1000) NULL,
    [DepositoryName] VARCHAR(100) NULL,
    [DPid] VARCHAR(100) NULL,
    [BeneficiaryId] VARCHAR(200) NULL,
    [BidQuantity] VARCHAR(50) NULL,
    [CutoffIndicator] VARCHAR(10) NULL,
    [Rate] VARCHAR(50) NULL,
    [ChequeReceivedFlag] VARCHAR(10) NULL,
    [ChequeAmount] MONEY NULL,
    [ChequeNumber] VARCHAR(5) NULL,
    [Pannumber] VARCHAR(200) NULL,
    [BankName] VARCHAR(20) NULL,
    [LocationCode] VARCHAR(10) NULL,
    [RefNo] VARCHAR(8000) NULL,
    [OrderNo] VARCHAR(50) NOT NULL,
    [ActivityType] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_NSE_Success_history_NewFileFormate_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_NSE_Success_history_NewFileFormate_RENAMEDAS_PII]
(
    [Symbol] VARCHAR(100) NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [Category] VARCHAR(10) NULL,
    [ClientName] VARCHAR(1000) NULL,
    [DepositoryName] VARCHAR(100) NULL,
    [DPid] VARCHAR(100) NULL,
    [BeneficiaryId] VARCHAR(200) NULL,
    [BidQuantity] VARCHAR(50) NULL,
    [CutoffIndicator] VARCHAR(10) NULL,
    [Rate] VARCHAR(50) NULL,
    [ChequeReceivedFlag] VARCHAR(10) NULL,
    [ChequeAmount] MONEY NULL,
    [ChequeNumber] VARCHAR(5) NULL,
    [Pannumber] VARCHAR(200) NULL,
    [BankName] VARCHAR(20) NULL,
    [LocationCode] VARCHAR(10) NULL,
    [RefNo] VARCHAR(8000) NULL,
    [OrderNo] VARCHAR(50) NOT NULL,
    [ActivityType] VARCHAR(50) NOT NULL,
    [Userid] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_NSE_Success_history_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_NSE_Success_history_RENAMEDAS_PII]
(
    [Symbol] VARCHAR(200) NULL,
    [Series] VARCHAR(200) NULL,
    [depository_name] VARCHAR(200) NULL,
    [dp_id] VARCHAR(200) NULL,
    [benficiary_id] VARCHAR(200) NULL,
    [bid_quantity] VARCHAR(200) NULL,
    [rate_price] VARCHAR(200) NULL,
    [pan_number] VARCHAR(200) NULL,
    [reference_number] VARCHAR(200) NULL,
    [order_number] VARCHAR(200) NULL,
    [activity_type] VARCHAR(200) NULL,
    [application_number] VARCHAR(200) NULL,
    [user_id] VARCHAR(200) NULL,
    [added_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_NSE_Success_NewFileFormate_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_NSE_Success_NewFileFormate_RENAMEDAS_PII]
(
    [Symbol] VARCHAR(100) NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [Category] VARCHAR(10) NULL,
    [ClientName] VARCHAR(1000) NULL,
    [DepositoryName] VARCHAR(100) NULL,
    [DPid] VARCHAR(100) NULL,
    [BeneficiaryId] VARCHAR(200) NULL,
    [BidQuantity] VARCHAR(50) NULL,
    [CutoffIndicator] VARCHAR(10) NULL,
    [Rate] VARCHAR(50) NULL,
    [ChequeReceivedFlag] VARCHAR(10) NULL,
    [ChequeAmount] MONEY NULL,
    [ChequeNumber] VARCHAR(5) NULL,
    [Pannumber] VARCHAR(200) NULL,
    [BankName] VARCHAR(20) NULL,
    [LocationCode] VARCHAR(10) NULL,
    [RefNo] VARCHAR(8000) NULL,
    [OrderNo] VARCHAR(50) NOT NULL,
    [ActivityType] VARCHAR(50) NOT NULL,
    [Userid] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_NSE_Success_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_NSE_Success_RENAMEDAS_PII]
(
    [Symbol] VARCHAR(200) NULL,
    [Series] VARCHAR(200) NULL,
    [depository_name] VARCHAR(200) NULL,
    [dp_id] VARCHAR(200) NULL,
    [benficiary_id] VARCHAR(200) NULL,
    [bid_quantity] VARCHAR(200) NULL,
    [rate_price] VARCHAR(200) NULL,
    [pan_number] VARCHAR(200) NULL,
    [reference_number] VARCHAR(200) NULL,
    [order_number] VARCHAR(200) NULL,
    [activity_type] VARCHAR(200) NULL,
    [application_number] VARCHAR(200) NULL,
    [user_id] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_OrderFile_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_OrderFile_RENAMEDAS_PII]
(
    [Symbol] VARCHAR(100) NULL,
    [Series] VARCHAR(200) NULL,
    [DepositoryName] VARCHAR(100) NULL,
    [DPid] VARCHAR(100) NULL,
    [BeneficiaryId] VARCHAR(200) NULL,
    [BidQuantity] VARCHAR(50) NULL,
    [Rate] VARCHAR(50) NULL,
    [Pannumber] VARCHAR(200) NULL,
    [RefNo] VARCHAR(8000) NULL,
    [OrderNo] VARCHAR(50) NOT NULL,
    [ActivityType] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_SegVeriData
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_SegVeriData]
(
    [POrequestID] VARCHAR(25) NULL,
    [id] INT IDENTITY(1,1) NOT NULL,
    [ProcessDate] DATETIME NULL,
    [Entity] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Flag] CHAR(1) NULL,
    [Balance] MONEY NULL,
    [UnsettledCrBill] MONEY NULL,
    [UnrecoAmt] MONEY NULL,
    [ShortSellValue] MONEY NULL,
    [MarginAmt] MONEY NULL,
    [Deposit] MONEY NULL,
    [CashColl] MONEY NULL,
    [NonCashColl] MONEY NULL,
    [MarginAdjWithColl] MONEY NULL,
    [MarginShortage] MONEY NULL,
    [AccruedCharges] MONEY NULL,
    [OtherDebit] MONEY NULL,
    [NonCashConsideration] MONEY NULL,
    [ExpoUtilised] MONEY NULL,
    [NetPayable] MONEY NULL,
    [UnPosted_PO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_SegVeriData_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_SegVeriData_hist]
(
    [POrequestID] VARCHAR(25) NULL,
    [id] INT NOT NULL,
    [ProcessDate] DATETIME NULL,
    [Entity] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Flag] CHAR(1) NULL,
    [Balance] MONEY NULL,
    [UnsettledCrBill] MONEY NULL,
    [UnrecoAmt] MONEY NULL,
    [ShortSellValue] MONEY NULL,
    [MarginAmt] MONEY NULL,
    [Deposit] MONEY NULL,
    [CashColl] MONEY NULL,
    [NonCashColl] MONEY NULL,
    [MarginAdjWithColl] MONEY NULL,
    [MarginShortage] MONEY NULL,
    [AccruedCharges] MONEY NULL,
    [OtherDebit] MONEY NULL,
    [NonCashConsideration] MONEY NULL,
    [ExpoUtilised] MONEY NULL,
    [NetPayable] MONEY NULL,
    [UnPosted_PO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bond_Status
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_Status]
(
    [Status] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bondallotment_segmentwise
-- --------------------------------------------------
CREATE TABLE [dbo].[bondallotment_segmentwise]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [netpayable] MONEY NULL,
    [srno] BIGINT NULL,
    [clientsrno] BIGINT NULL,
    [Adjustamt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BondMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[BondMaster]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BondMaster_log
-- --------------------------------------------------
CREATE TABLE [dbo].[BondMaster_log]
(
    [Srno] INT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [ActionOccured] VARCHAR(30) NULL,
    [Editedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BondVerified_Cash_ShrtVal
-- --------------------------------------------------
CREATE TABLE [dbo].[BondVerified_Cash_ShrtVal]
(
    [sett_no] VARCHAR(7) NULL,
    [sett_type] VARCHAR(2) NULL,
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [short_qty] NUMERIC(17, 4) NULL,
    [poa_adj_qty] NUMERIC(17, 4) NULL,
    [seg] VARCHAR(5) NULL,
    [total_holding] NUMERIC(17, 4) NULL,
    [hld_ac_code] VARCHAR(16) NULL,
    [act_short_qty] NUMERIC(17, 4) NULL,
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSECM_Shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[BSECM_Shortage]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [Nsehold] INT NOT NULL,
    [Nsepledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientWiseLivelgr
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientWiseLivelgr]
(
    [Party_code] VARCHAR(50) NULL,
    [Sub_Broker] VARCHAR(50) NULL,
    [Client_Name] VARCHAR(200) NULL,
    [Client_Type] VARCHAR(50) NULL,
    [Client_Category] VARCHAR(50) NULL,
    [Ledger] MONEY NULL,
    [Net_Shortfall] MONEY NULL,
    [Accural_Amt] NUMERIC(18, 2) NULL,
    [Holding] MONEY NULL,
    [MOS] MONEY NULL,
    [ROI] MONEY NULL,
    [Total_Coll] MONEY NULL,
    [Gross_Exposure] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Net_Available] MONEY NULL,
    [Unreco_Credit] MONEY NULL,
    [Unbooked_Loss] MONEY NULL,
    [NBFC_Logical_Ledger] MONEY NULL,
    [Violation_Percentage] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [PureRisk_AfterDP] MONEY NULL,
    [Projected_Risk] MONEY NULL,
    [ProjRisk_After_DP_Adj] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [No_of_Dr_Days] INT NULL,
    [Last_Bill_Date] VARCHAR(20) NULL,
    [New_POA] VARCHAR(50) NULL,
    [Intraday_Status] VARCHAR(50) NULL,
    [MTF_Status] VARCHAR(50) NULL,
    [debitEmail] VARCHAR(1) NOT NULL,
    [squareoffEmail] VARCHAR(1) NOT NULL,
    [Last_Traded_Date] NVARCHAR(37) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Emaillog
-- --------------------------------------------------
CREATE TABLE [dbo].[Emaillog]
(
    [Emailid] VARCHAR(30) NULL,
    [EmailContent] VARCHAR(300) NULL,
    [Emaildate] DATETIME NULL,
    [EmailStatus] CHAR(1) NULL,
    [OrderSrno] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_Batch_process
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_Batch_process]
(
    [Srno] INT NOT NULL,
    [ProcedureName] VARCHAR(200) NULL,
    [Active_Status] INT NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Flag] INT NULL,
    [spdesc] VARCHAR(200) NULL,
    [Errflag] VARCHAR(100) NULL,
    [section] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_Batch_process_log
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_Batch_process_log]
(
    [Srno] INT NOT NULL,
    [ProcedureName] VARCHAR(200) NULL,
    [Active_Status] INT NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Flag] INT NULL,
    [spdesc] VARCHAR(200) NULL,
    [Errflag] VARCHAR(100) NULL,
    [section] INT NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_Jv
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_Jv]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [tosegment] VARCHAR(5) NOT NULL,
    [markedamount] MONEY NULL,
    [availableamount] MONEY NULL,
    [JVAmount] MONEY NULL,
    [JVDate] DATETIME NULL,
    [ProcessDate] DATETIME NOT NULL,
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BO_Posted] VARCHAR(1) NOT NULL,
    [BO_RowState] INT NOT NULL,
    [OrderQty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_Jv_log
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_Jv_log]
(
    [party_code] VARCHAR(10) NULL,
    [fromsegment] VARCHAR(10) NULL,
    [tosegment] VARCHAR(5) NOT NULL,
    [markedamount] MONEY NULL,
    [availableamount] MONEY NULL,
    [JVAmount] MONEY NULL,
    [JVDate] DATETIME NULL,
    [ProcessDate] DATETIME NOT NULL,
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BO_Posted] VARCHAR(1) NOT NULL,
    [BO_RowState] INT NOT NULL,
    [OrderQty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_NSE_OrderFile_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_NSE_OrderFile_RENAMEDAS_PII]
(
    [Symbol] VARCHAR(100) NULL,
    [Series] VARCHAR(100) NULL,
    [DepositoryName] VARCHAR(100) NULL,
    [DPid] VARCHAR(100) NULL,
    [BeneficiaryId] VARCHAR(200) NULL,
    [BidQuantity] VARCHAR(50) NULL,
    [Rate] VARCHAR(50) NULL,
    [Pannumber] VARCHAR(200) NULL,
    [RefNo] VARCHAR(8000) NULL,
    [OrderNo] VARCHAR(50) NOT NULL,
    [ActivityType] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_OrderFile
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_OrderFile]
(
    [Symbol] VARCHAR(100) NULL,
    [ApplicationNo] VARCHAR(100) NULL,
    [Filler1] VARCHAR(100) NULL,
    [ApplicantName] VARCHAR(100) NULL,
    [Depository] VARCHAR(100) NULL,
    [DPid] VARCHAR(100) NULL,
    [BeneficiaryId] VARCHAR(200) NULL,
    [Units] VARCHAR(50) NULL,
    [Filler2] VARCHAR(100) NULL,
    [Rate] VARCHAR(50) NULL,
    [Filler3] VARCHAR(100) NULL,
    [Filler4] VARCHAR(100) NULL,
    [Pan_UCC_Flag] VARCHAR(100) NULL,
    [Pannumber] VARCHAR(200) NULL,
    [Filler5] VARCHAR(100) NULL,
    [Filler6] VARCHAR(100) NULL,
    [Filler7] VARCHAR(100) NULL,
    [BIDID] VARCHAR(50) NOT NULL,
    [ActivityType] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_SegVeriData
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_SegVeriData]
(
    [POrequestID] VARCHAR(25) NULL,
    [id] INT IDENTITY(1,1) NOT NULL,
    [ProcessDate] DATETIME NULL,
    [Entity] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Flag] CHAR(1) NULL,
    [Balance] MONEY NULL,
    [UnsettledCrBill] MONEY NULL,
    [UnrecoAmt] MONEY NULL,
    [ShortSellValue] MONEY NULL,
    [MarginAmt] MONEY NULL,
    [Deposit] MONEY NULL,
    [CashColl] MONEY NULL,
    [NonCashColl] MONEY NULL,
    [MarginAdjWithColl] MONEY NULL,
    [MarginShortage] MONEY NULL,
    [AccruedCharges] MONEY NULL,
    [OtherDebit] MONEY NULL,
    [NonCashConsideration] MONEY NULL,
    [ExpoUtilised] MONEY NULL,
    [NetPayable] MONEY NULL,
    [UnPosted_PO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_SegVeriData_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_SegVeriData_hist]
(
    [POrequestID] VARCHAR(25) NULL,
    [id] INT NOT NULL,
    [ProcessDate] DATETIME NULL,
    [Entity] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Flag] CHAR(1) NULL,
    [Balance] MONEY NULL,
    [UnsettledCrBill] MONEY NULL,
    [UnrecoAmt] MONEY NULL,
    [ShortSellValue] MONEY NULL,
    [MarginAmt] MONEY NULL,
    [Deposit] MONEY NULL,
    [CashColl] MONEY NULL,
    [NonCashColl] MONEY NULL,
    [MarginAdjWithColl] MONEY NULL,
    [MarginShortage] MONEY NULL,
    [AccruedCharges] MONEY NULL,
    [OtherDebit] MONEY NULL,
    [NonCashConsideration] MONEY NULL,
    [ExpoUtilised] MONEY NULL,
    [NetPayable] MONEY NULL,
    [UnPosted_PO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSec_Status
-- --------------------------------------------------
CREATE TABLE [dbo].[GSec_Status]
(
    [Status] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSECM_Shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[NSECM_Shortage]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [BSEHold] INT NOT NULL,
    [BSEPledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OrderEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[OrderEntry]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [ClientCode] VARCHAR(30) NULL,
    [ClientName] VARCHAR(300) NULL,
    [PanNumber] VARCHAR(20) NULL,
    [DPid] VARCHAR(10) NULL,
    [DPName] VARCHAR(10) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Amount] MONEY NULL,
    [LimitValue] MONEY NULL,
    [BondSrno] INT NULL,
    [AppStatus] VARCHAR(30) NULL,
    [Channel] VARCHAR(30) NULL,
    [Enteredby] VARCHAR(30) NULL,
    [Enteredon] DATETIME NULL,
    [IPAddress] VARCHAR(30) NULL,
    [VerifiedOn] DATETIME NULL,
    [ExportedOn] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Remark] VARCHAR(2000) NULL,
    [internalreferencenumber] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OrderEntry_log
-- --------------------------------------------------
CREATE TABLE [dbo].[OrderEntry_log]
(
    [Srno] INT NULL,
    [ClientCode] VARCHAR(30) NULL,
    [ClientName] VARCHAR(300) NULL,
    [PanNumber] VARCHAR(20) NULL,
    [DPid] VARCHAR(10) NULL,
    [DPName] VARCHAR(10) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [Qty] INT NULL,
    [Rate] MONEY NULL,
    [Amount] MONEY NULL,
    [LimitValue] MONEY NULL,
    [BondSrno] INT NULL,
    [AppStatus] VARCHAR(30) NULL,
    [Channel] VARCHAR(30) NULL,
    [Enteredby] VARCHAR(30) NULL,
    [Enteredon] DATETIME NULL,
    [IPAddress] VARCHAR(30) NULL,
    [VerifiedOn] DATETIME NULL,
    [ExportedOn] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Remark] VARCHAR(2000) NULL,
    [internalreferencenumber] VARCHAR(8000) NULL,
    [ActionOccured] VARCHAR(30) NULL,
    [Editedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sheet1_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[Sheet1_RENAMEDAS_PII]
(
    [Order No] NVARCHAR(255) NULL,
    [Symbol] NVARCHAR(255) NULL,
    [Application No] NVARCHAR(255) NULL,
    [Bid Qty] FLOAT NULL,
    [Price] FLOAT NULL,
    [Amount] FLOAT NULL,
    [Physical / Demat] NVARCHAR(255) NULL,
    [DP Name] NVARCHAR(255) NULL,
    [PAN No] NVARCHAR(255) NULL,
    [DP Id] NVARCHAR(255) NULL,
    [Ben Id] NVARCHAR(255) NULL,
    [Order Status] NVARCHAR(255) NULL,
    [Entry Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMSlog
-- --------------------------------------------------
CREATE TABLE [dbo].[SMSlog]
(
    [MobileNumber] VARCHAR(30) NULL,
    [SMSContent] VARCHAR(300) NULL,
    [SMSdate] DATETIME NULL,
    [SMStime] VARCHAR(30) NULL,
    [SMSSatus] CHAR(1) NULL,
    [SMSAMPM] CHAR(2) NULL,
    [Purpose] VARCHAR(30) NULL DEFAULT 'Bond',
    [OrderSrno] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_bnd_30jun2020
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_bnd_30jun2020]
(
    [cltcode] NVARCHAR(255) NULL,
    [Trdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Bond_0212019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Bond_0212019]
(
    [PARTY_CODE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Bond_Encrption
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Bond_Encrption]
(
    [party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_Bond_FILEUPLOADMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_Bond_FILEUPLOADMASTER]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [FILETYPE] VARCHAR(200) NULL,
    [Bond_id] VARCHAR(200) NULL,
    [Segment] VARCHAR(200) NULL,
    [VAR_FILENAME] VARCHAR(200) NULL,
    [FILEGUIDNAME] VARCHAR(200) NULL,
    [FILEPATH] VARCHAR(400) NULL,
    [UPLOADED_BY_USERNAME] VARCHAR(50) NULL,
    [UPLOADED_BY_ACCESS_CODE] VARCHAR(50) NULL,
    [UPLOADED_ON] DATETIME NULL,
    [remarks] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_Bond_FILEUPLOADMASTER_NewFileFormate
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_Bond_FILEUPLOADMASTER_NewFileFormate]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [FILETYPE] VARCHAR(200) NULL,
    [Bond_id] VARCHAR(200) NULL,
    [Segment] VARCHAR(200) NULL,
    [VAR_FILENAME] VARCHAR(200) NULL,
    [FILEGUIDNAME] VARCHAR(200) NULL,
    [FILEPATH] VARCHAR(400) NULL,
    [UPLOADED_BY_USERNAME] VARCHAR(50) NULL,
    [UPLOADED_BY_ACCESS_CODE] VARCHAR(50) NULL,
    [UPLOADED_ON] DATETIME NULL,
    [remarks] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BOND_OTP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BOND_OTP]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [EMP_CODE] VARCHAR(30) NULL,
    [OTP] VARCHAR(100) NULL,
    [CREATION_DATE] DATETIME NULL,
    [FLG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL,
    [IssuanceDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_02Dec2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_02Dec2019]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_07062019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_07062019]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_09Sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_09Sep2019]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_13072022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_13072022]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL,
    [IssuanceDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_13sep2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_13sep2019]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_24122018
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_24122018]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_25Oct2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_25Oct2019]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BondMaster_log
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BondMaster_log]
(
    [Srno] INT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [ActionOccured] VARCHAR(30) NULL,
    [Editedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BondMaster_NewFileFormate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BondMaster_NewFileFormate]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL,
    [IssuanceDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BondMaster_UAT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BondMaster_UAT]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [SchemeName] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [series] VARCHAR(100) NULL,
    [Rate] MONEY NULL,
    [Startdate] DATETIME NULL,
    [Enddate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL,
    [MaxValue] MONEY NULL,
    [CreatedBy] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(30) NULL,
    [Updatedon] DATETIME NULL,
    [MultipleOf] INT NULL,
    [Category] VARCHAR(50) NULL,
    [IssuanceDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry_19072016_bk
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry_19072016_bk]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_bondorderentry_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_bondorderentry_hist]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry_log_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry_log_RENAMEDAS_PII]
(
    [EntryId] INT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ActionOccured] VARCHAR(30) NULL,
    [Editedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry_NewFileFormate_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry_NewFileFormate_RENAMEDAS_PII]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL,
    [TransactionRefNo] VARCHAR(20) NULL,
    [InternalRefNo] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry_RENAMEDAS_PII]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL,
    [TransactionRefNo] VARCHAR(20) NULL,
    [InternalRefNo] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry_test
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry_test]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BONDOrderEntry_UAT_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BONDOrderEntry_UAT_RENAMEDAS_PII]
(
    [EntryId] INT IDENTITY(1,1) NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_GSec_FILEUPLOADMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_GSec_FILEUPLOADMASTER]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [FILETYPE] VARCHAR(200) NULL,
    [Bond_id] VARCHAR(200) NULL,
    [Segment] VARCHAR(200) NULL,
    [VAR_FILENAME] VARCHAR(200) NULL,
    [FILEGUIDNAME] VARCHAR(200) NULL,
    [FILEPATH] VARCHAR(400) NULL,
    [UPLOADED_BY_USERNAME] VARCHAR(50) NULL,
    [UPLOADED_BY_ACCESS_CODE] VARCHAR(50) NULL,
    [UPLOADED_ON] DATETIME NULL,
    [remarks] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IPO_Exceptionlog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IPO_Exceptionlog]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Source] VARCHAR(30) NULL,
    [Message] VARCHAR(MAX) NULL,
    [UserId] VARCHAR(50) NULL,
    [IP] VARCHAR(50) NULL,
    [OccuredOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_UnpledgeFile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_UnpledgeFile]
(
    [partyCode] VARCHAR(50) NULL,
    [script] VARCHAR(50) NULL,
    [series] VARCHAR(10) NULL,
    [ISIN] VARCHAR(100) NULL,
    [Qty] VARCHAR(500) NULL,
    [sourceDPID] VARCHAR(10) NULL,
    [ClientDPID] VARCHAR(20) NULL,
    [ClientWiseId] VARCHAR(10) NULL,
    [ClientwiseDPID] VARCHAR(20) NULL,
    [Cl_Type] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Bondreject
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Bondreject]
(
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL,
    [netpayable] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempbonddata_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tempbonddata_RENAMEDAS_PII]
(
    [EntryId] INT NOT NULL,
    [BOND_SrNo] INT NULL,
    [BOND_Name] VARCHAR(500) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [ClientName] VARCHAR(200) NULL,
    [Order_Date] DATETIME NULL,
    [Order_Status] VARCHAR(30) NULL,
    [Order_Qty] INT NULL,
    [RATE] MONEY NULL,
    [Total] MONEY NULL,
    [ClientLimit] MONEY NULL,
    [BOND_Code] VARCHAR(50) NULL,
    [BOND_Symbol] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [DP] VARCHAR(100) NULL,
    [BONDCloseDate] DATETIME NULL,
    [ApplicationNo] VARCHAR(1000) NULL,
    [BeneficiaryId] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [DPName] VARCHAR(20) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Segment] VARCHAR(20) NULL,
    [Channel] VARCHAR(20) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    [EnteredOn] DATETIME NULL,
    [Verfiedon] DATETIME NULL,
    [Exportedon] DATETIME NULL,
    [ReverseConfirmation] DATETIME NULL,
    [Comment] VARCHAR(2000) NULL,
    [ACType] VARCHAR(20) NULL,
    [ACName] VARCHAR(100) NULL,
    [IFSCode] VARCHAR(30) NULL,
    [ACC_NUM] VARCHAR(100) NULL,
    [FlexiBlocked] DATETIME NULL,
    [POBlocked] DATETIME NULL,
    [netpayable] MONEY NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.BondMaster_trig
-- --------------------------------------------------


CREATE TRIGGER BondMaster_trig

   ON  dbo.tbl_BondMaster 

   AFTER Delete,update

AS 

	declare @action varchar(30),@editedon datetime

	

	if exists(select * from inserted) and exists(select * from deleted) 

	set @action ='Update'

	else

	set @action ='Delete'

	

	set @editedon=GETDATE()

	



	insert into tbl_BondMaster_log

	select Srno,SchemeName,Symbol,series,Rate,Startdate,Enddate,MinQty,MaxQty,MaxValue,CreatedBy,CreatedOn,UpdatedBy,Updatedon,

	@action,@editedon

	 from deleted

GO

-- --------------------------------------------------
-- TRIGGER dbo.OrderEntry_trig
-- --------------------------------------------------

CREATE TRIGGER OrderEntry_trig
   ON  dbo.OrderEntry 
   AFTER Delete,update
AS 
	declare @action varchar(30),@editedon datetime
	
	if exists(select * from inserted) and exists(select * from deleted) 
	set @action ='Update'
	else
	set @action ='Delete'
	
	set @editedon=GETDATE()
	

	insert into OrderEntry_log
	select Srno,ClientCode,ClientName,PanNumber,DPid,DPName,BeneficiaryId,Segment,Qty,Rate,Amount,LimitValue,BondSrno,AppStatus,Channel,Enteredby,Enteredon,IPAddress,VerifiedOn,ExportedOn,ReverseConfirmation,Remark,internalreferencenumber,
	@action,@editedon
	 from deleted

GO

-- --------------------------------------------------
-- TRIGGER dbo.tbl_BONDOrderEntry_trig
-- --------------------------------------------------




CREATE TRIGGER tbl_BONDOrderEntry_trig
   ON  dbo.tbl_BONDOrderEntry 
   AFTER Delete,update
AS 
	declare @action varchar(30),@editedon datetime
	
	if exists(select * from inserted) and exists(select * from deleted) 
	set @action ='Update'
	else
	set @action ='Delete'
	
	set @editedon=GETDATE()
	

	insert into tbl_BONDOrderEntry_log
	select EntryId,BOND_SrNo,BOND_Name,Client_Code,ClientName,Order_Date,Order_Status,Order_Qty,RATE,Total,ClientLimit,BOND_Code,BOND_Symbol,ISIN,PAN,DP,BONDCloseDate,ApplicationNo,BeneficiaryId,IPAddress,DPName,OrderType,Segment,Channel,access_to,access_code,EnteredBy,EnteredOn,Verfiedon,Exportedon,ReverseConfirmation,Comment,ACType,ACName,IFSCode,
	@action,@editedon
	 from deleted

GO

-- --------------------------------------------------
-- VIEW dbo.Bond_BondVerified_Cash_ShrtVal
-- --------------------------------------------------
create view Bond_BondVerified_Cash_ShrtVal   
as  
select * from  
(  
select   
x.party_code,x.scrip_cd,short_qty as ori_shortQty,  
(Case when isnull(y.netQty,0)-short_qty > 0 then 0 else abs(isnull(y.netQty,0)-short_qty) end) as short_qty,  
x.poa_adj_qty,x.seg,x.total_holding,x.hld_ac_code,  
(Case when isnull(y.netQty,0)-short_qty > 0 then 0 else abs(isnull(y.netQty,0)-short_qty) end) as act_short_qty,  
x.ISIN  
from   
(  
 select party_code,scrip_cd,SUM(short_qty) as short_qty,  
 SUM(poa_adj_qty) as poa_adj_qty,  
 seg,  
 SUM(total_holding) as total_holding,  
 hld_ac_code,  
 SUM(act_short_qty) as act_short_qty,  
 ISIN  
 from BondVerified_Cash_ShrtVal   
 group by party_code,scrip_cd,seg,hld_ac_code,isin  
 having SUM(act_short_qty) > 0  
) x left outer join  
[196.1.115.182].general.dbo.Vw_MILES_STOCKHOLDINGDATA y   
on x.PARTY_cODE=y.partycode and x.isin=y.isin   
) z where act_short_qty > 0

GO

-- --------------------------------------------------
-- VIEW dbo.Bond_EntityVeriData
-- --------------------------------------------------

CREATE View Bond_EntityVeriData          
as          
Select min(id) as id,max(processDate) as processDate,Entity,party_code,          
sum(Balance) as Balance,sum(UnsettledCrBill) as UnsettledCrBill,sum(UnrecoAmt) as UnrecoAmt,sum(ShortSellValue) as ShortSellValue,          
sum(MarginAmt) as MarginAmt,sum(Deposit) as Deposit,sum(CashColl) as CashColl,sum(NonCashColl) as NonCashColl,sum(MarginAdjWithColl) as MarginAdjWithColl,          
sum(MarginShortage) as MarginShortage,sum(AccruedCharges) as AccruedCharges,sum(OtherDebit) as OtherDebit,sum(NonCashConsideration) as NonCashConsideration,          
sum(ExpoUtilised) as ExpoUtilised,sum(NetPayable) as NetPayable          
from Bond_SegVeriData with (nolock)          
group by Entity,party_code

GO

-- --------------------------------------------------
-- VIEW dbo.Bond_EntityVeriData_EQ
-- --------------------------------------------------

CREATE View Bond_EntityVeriData_EQ         
as            
Select min(id) as id,max(processDate) as processDate,Entity='EQUITY',party_code,            
sum(Balance) as Balance,sum(UnsettledCrBill) as UnsettledCrBill,sum(UnrecoAmt) as UnrecoAmt,sum(ShortSellValue) as ShortSellValue,            
sum(MarginAmt) as MarginAmt,sum(Deposit) as Deposit,sum(CashColl) as CashColl,sum(NonCashColl) as NonCashColl,sum(MarginAdjWithColl) as MarginAdjWithColl,            
sum(MarginShortage) as MarginShortage,sum(AccruedCharges) as AccruedCharges,sum(OtherDebit) as OtherDebit,sum(NonCashConsideration) as NonCashConsideration,            
sum(ExpoUtilised) as ExpoUtilised,sum(NetPayable) as NetPayable            
from Bond_SegVeriData with (nolock)  where (Entity='Equity' )            
group by party_code

GO

-- --------------------------------------------------
-- VIEW dbo.Bond_SendSMS
-- --------------------------------------------------
CREATE View Bond_SendSMS  
as  
select a.ApplicationNo,a.Client_Code,SUM(c.JVamount) as ApprovedAmt,a.Order_Qty   
from tbl_bondorderentry a 
join bond_jv c with (nolock)  
on a.Client_Code=c.PArty_Code  
group by a.ApplicationNo,a.Client_Code,a.Order_Qty

GO

-- --------------------------------------------------
-- VIEW dbo.Bond_SendToExchange_VW
-- --------------------------------------------------
CREATE View Bond_SendToExchange_VW  
as  
select a.ApplicationNo,a.Client_Code,SUM(c.JVamount) as ApprovedAmt,a.Order_Qty   
from tbl_bondorderentry a 
join bond_jv c with (nolock)  
on a.Client_Code=c.PArty_Code  
where Order_Status='Exported' 
group by a.ApplicationNo,a.Client_Code,a.Order_Qty

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Bond_Data
-- --------------------------------------------------
-- =============================================
-- Author:		Neha Naiwar
-- Create date: 14 July 2022
-- ============================================= 
CREATE view Vw_Bond_Data   
as  
select Client_Code,Order_Date,Order_Status,Order_Qty,BOND_Name,channel,a.RATE,Total
from tbl_bondorderentry a  with(nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Bond_Detail
-- --------------------------------------------------
  
CREATE view Vw_Bond_Detail   
as  
select BOND_Name,b.Startdate,b.Enddate,Client_Code,Sub_Broker,First_Active_Date,Last_Inactive_Date,DOB = '',ClientName,Order_Date,Order_Status,Order_Qty,a.RATE,Total,Pan,DP,channel,ApplicationNo  
,case when b2c='Y' then 'B2C' else 'B2B' end as Type from tbl_bondorderentry a  with(nolock)  
left join tbl_BondMaster b with(nolock) on a.BOND_SrNo=b.Srno  
left join risk.dbo.client_Details c with(nolock) on a.Client_Code=c.party_code where a.Order_Date>='2016-04-01 00:00:00.000'

GO

-- --------------------------------------------------
-- VIEW dbo.VW_Bond_Master
-- --------------------------------------------------
CREATE view VW_Bond_Master
as
Select * from tbl_BondMaster with(nolock)

GO

