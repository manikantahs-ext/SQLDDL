-- DDL Export
-- Server: 10.253.33.89
-- Database: ROE
-- Exported: 2026-02-05T02:39:25.248687

USE ROE;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.client_survey
-- --------------------------------------------------
ALTER TABLE [dbo].[client_survey] ADD CONSTRAINT [PK_client_survey] PRIMARY KEY ([survey_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.client_survey_info
-- --------------------------------------------------
ALTER TABLE [dbo].[client_survey_info] ADD CONSTRAINT [PK_client_survey_info_1] PRIMARY KEY ([survey_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.QFR_survey
-- --------------------------------------------------
ALTER TABLE [dbo].[QFR_survey] ADD CONSTRAINT [PK_QFR_survey] PRIMARY KEY ([survey_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Sb_Survey
-- --------------------------------------------------
ALTER TABLE [dbo].[Sb_Survey] ADD CONSTRAINT [PK_Sb_Survey] PRIMARY KEY ([survey_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sb_survey_info
-- --------------------------------------------------
ALTER TABLE [dbo].[sb_survey_info] ADD CONSTRAINT [PK_sb_survey_info] PRIMARY KEY ([survey_id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.client_fund_balance
-- --------------------------------------------------
CREATE proc [dbo].[client_fund_balance]
(
 @segment varchar(100)
)
as
if @segment='ABL'
begin
declare @acyearfrom as datetime,@acyearto as datetime
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock) 
where sdtcur <=getdate() and ldtcur >=getdate()

select a.cltcode,b.acname, Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  from AngelBSECM.account_ab.dbo.ledger a (nolock) 
left outer join 
AngelBSECM.account_ab.dbo.acmast b
on a.cltcode=b.cltcode
where a.vdt >=@acyearfrom and a.vdt<=getdate()
and a.cltcode in 
(select cltcode from AngelBSECM.account_ab.dbo.acmast b where grpcode='A0303020000'
and cltcode not in (select cltcode from ff_bank_details where segment='BSECM' and cltcode <> 0)
 and cltcode<>'06000015'
and cltcode<>'10CNTR'
and cltcode<>'5100000005')
group by a.cltcode,b.acname
end

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.client_sb_list
-- --------------------------------------------------

CREATE proc client_sb_list  
(@opt as varchar(15))  
as  
  
  
if @opt='SB'  
begin  
select x.*,  
y.suggestion,y.name,y.clientid as client_id,y.branch,y.sbtag as sb_tag,y.email,y.mobileno,y.OffNo,  
convert(varchar(11),y.date,103) as date1,  
y.username as username1,y.survey_id as surveyid,  
y.main_branch as main_branch_new,convert(varchar(11),y.report_date,103) as reportdate,isnull(y.email_status,'-') as email_status  
,isnull(y.tel_status,'-') as tel_status,  
isnull(y.mobile_status,'-') as mobile_status,isnull(y.address1,'-') as address1,isnull(y.action_taken,'-') as action_taken  
,isnull(y.final_status,'-') as final_status  
from sb_survey x  
full join  sb_survey_info y  
on x.username=y.username and x.clientid=y.clientid  
and x.survey_id=y.survey_id  
where  y.clientid is not null    
end  
  
else  
begin  
  
select x.*,  
y.suggestion,y.name,y.clientid as client_id,y.branch,y.sbtag as sb_tag,y.email,y.mobile,y.offno,  
convert(varchar(11),y.date,103) as date1,  
y.username as username1,y.survey_id as surveyid,  
y.main_branch as main_branch_new,y.report_date as reportdate,isnull(y.email_status,'-') as email_status  
,isnull(y.tel_status,'-') as tel_status,  
isnull(y.mobile_status,'-') as mobile_status,isnull(y.address1,'-') as address1  
,isnull(y.actaken,'-') as actaken,isnull(y.finalstatus,'-') as finalstatus  
from client_survey x  
full join  client_survey_info y  
on x.username=y.username and x.clientid=y.clientid  
and x.survey_id=y.survey_id  
where  y.clientid is not null    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.client_survey_report
-- --------------------------------------------------
CREATE proc [dbo].[client_survey_report]         
(        
@branch as varchar(50), @strfdate as varchar(10), @strtdate as varchar(10)        
)        
as        
    
select name,Branch,SBTag,clientTag,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,  
q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,  
q28,q29,q30,q31,remark,email,email_status,mobile,mobile_status,office_tele,  
off_tel_stat,Address,Action_taken,status,Person_name    from cli_survey_q  
  
--select * from cli_survey_q      
union all        
--select * from client_survey      
        
select b.name,b.branch,b.sbtag,b.clientid,        
      
a.q1,a.q2,a.q3,a.q4,a.q5,a.q6,a.q7,a.q8,a.q9,        
a.q10,a.q11a,a.q12,a.q13,a.q14a,        
a.q15,a.q16,a.q17a,a.q18a,a.q18b,a.q18c,        
a.q18d,a.q19,a.q20,a.q21,a.q22a,a.q22b,a.q23,a.q24,      
a.q25,a.q26,a.q27b,          
upper(b.suggestion) as suggestion, b.email,b.email_status,b.mobile,b.mobile_status,b.offno,b.tel_status,b.address1,b.actaken,b.finalstatus,c.emp_name      
   from client_survey_info b, client_survey a, risk.dbo.emp_info c where a.survey_id = b.survey_id         
         and a.main_branch=@branch and b.date >=@strfdate and b.date <=@strtdate        
         and c.emp_no = b.username  and a.report_date=
--'1900-01-01 00:00:00.000'  
(
select DISTINCT report_date from client_survey_info 
where main_branch=@branch 
 and (date>= @strfdate and date<= @strtdate)
 )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.disp_values
-- --------------------------------------------------



CREATE proc [dbo].[disp_values]
(
@rdate datetime
)
as

--declare @rdate as varchar(25)
--set @rdate = '2007-11-30'


declare @BB as numeric(25,2)
declare @TP as numeric(25,2)
declare @FD as numeric(25,2)
declare @MR as numeric(25,2)
declare @LAS as numeric(25,2)
declare @HV as numeric(25,2)

select @BB = qty from  ff_tmmrsfund_details where rdate=@rdate and type='Bank balance'
select @TP = qty from  ff_tmmrsfund_details where rdate=@rdate and type='Tomorrow''s Pay-In/Ou'
select @FD = qty from  ff_tmmrsfund_details where rdate=@rdate and type='FD'
select @HV = qty from  ff_tmmrsfund_details where rdate=@rdate and type='H-V Cheq.'
select @MR = qty from  ff_tmmrsfund_details where rdate=@rdate and type='Margin Release'
select @LAS = qty from  ff_tmmrsfund_details where rdate=@rdate and type='LAS OD Limit'


declare @CI as numeric(25,2)
declare @MCX as numeric(25,2)
declare @ASL as numeric(25,2)
declare @BSE as numeric(25,2)
declare @NSE as numeric(25,2)
declare @FO as numeric(25,2)

select @CI = qty from  ff_transactions_details where rdate=@rdate and type='Cheque Issued'
select @MCX = qty from  ff_transactions_details where rdate=@rdate and type='ABC-MCX'
select @ASL = qty from  ff_transactions_details where rdate=@rdate and type='ABC-ASL'
select @BSE = qty from  ff_transactions_details where rdate=@rdate and type='ABC-BSE'
select @NSE = qty from  ff_transactions_details where rdate=@rdate and type='ABC-NSE'
select @FO = qty from  ff_transactions_details where rdate=@rdate and type='ABC-FO'


declare @total_B as numeric(25,2)
set @total_B = (select sum(bse+nse+nsefo+mcx+bsefo+ncdx) from ff_payin_details)

declare @total_A as numeric(25,2)
set @total_A = (select sum(fundsbalance) from ff_bank_details)

declare @total_C as numeric(25,2)
set @total_C = (select sum(ncdex+mcx+aslfo+bse+nse+nsefo) from ff_acc_details)


-- Acc_Details
select type,isnull(convert(varchar(40),NCDEX),0) as 'NCDEX',isnull(convert(varchar(40),MCX),0) as 'MCX',
isnull(convert(varchar(40),ASLFO),0) as 'ASLFO',isnull(convert(varchar(40),BSE),0) as 'ABL',isnull(convert(varchar(40),NSE),0) as 'ACDL',
isnull(convert(varchar(40),NSEFO),0) as 'ACDL FO', Total= isnull(convert(varchar(40), NCDEX+MCX+ASLFO+BSE+NSE+NSEFO),0)
 from  ff_acc_details where rdate=@rdate
-- Sum Total
union all
select 'Total(C)', isnull(convert(varchar(40),sum(NCDEX)),0),isnull(convert(varchar(40),sum(MCX)),0),
isnull(convert(varchar(40),sum(ASLFO)),0),isnull(convert(varchar(40),sum(BSE)),0),isnull(convert(varchar(40),sum(NSE)),0),
isnull(convert(varchar(40),sum(NSEFO)),0), Total=isnull(convert(varchar(40),(sum(NCDEX)+sum(MCX)+sum(ASLFO)+sum(BSE)+sum(NSE)+sum(NSEFO))),0)
 from  ff_acc_details where rdate = @rdate
-- add rows 
union all
select '','','','A','B','C','','(A+B+C)'
union all
select 'Net Total','','',convert(varchar(30),@total_A),convert(varchar(30),@total_B),convert(varchar(30),@total_C),'',convert(varchar(30),@total_A+@total_B+@total_C)
union all
select '','','','','','','',''
-- Todays Transactions
union all
select 'Today''s Transactions','Cheque Issued','ABC-MCX','ABC-ASL','ABC-BSE','ABC-NSE','ABC-FO','Total'
union all
select '',BB = isnull(convert(varchar(40),@CI),0),TP = isnull(convert(varchar(40),@MCX),0),FD = isnull(convert(varchar(40),@ASL),0),
HV = isnull(convert(varchar(40),@BSE),0),MR = isnull(convert(varchar(40),@NSE),0),LAS = isnull(convert(varchar(40),@FO),0),
NET = isnull(convert(varchar(40),(@CI + @MCX + @ASL + @BSE + @NSE + @FO)),0)
-- add blank row
union all
select '','','','','','','',''
union all
select 'Tomorrow''s Fund Position','','','','','','',''
-- Tomorrows Fund Balance
union all
select 'Bank Balance','Tomorrow Pay-In/Out','FD','','H-V Cheq.','Margin Release','LAS OD Limit','Net Balance'
union all
select BB = isnull(convert(varchar(40),@BB),0),TP = isnull(convert(varchar(40),@TP),0),FD = isnull(convert(varchar(40),@FD),0),
 empty='',HV = isnull(convert(varchar(40),@HV),0),MR = isnull(convert(varchar(40),@MR),0),LAS = isnull(convert(varchar(40),@LAS),0),
NET = isnull(convert(varchar(40),(@BB + @TP + @FD + @HV + @MR + @LAS)),0)

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Display_ABC
-- --------------------------------------------------


CREATE proc [dbo].[Display_ABC](
@rdate datetime)
as

declare @t1 numeric(30,2)
declare @t2 numeric(30,2)
declare @t3 numeric(30,2)
declare @t4 numeric(30,2)
declare @t5 numeric(30,2)
declare @tmargin as numeric(30,2)
declare @pre as numeric(30,2)

set @t1 = (select sum(bc) from  ff_ABCdeposit_details where rdate=@rdate+' 00:00:00.000')
set @t2 = (select sum(bg) from  ff_ABCdeposit_details where rdate=@rdate+' 00:00:00.000')
set @t3 = (select sum(fd) from  ff_ABCdeposit_details where rdate=@rdate+' 00:00:00.000')
set @t4 = (select sum(shares) from  ff_ABCdeposit_details where rdate=@rdate+' 00:00:00.000')
set @t5 = (select sum(cash) from  ff_ABCdeposit_details where rdate=@rdate+' 00:00:00.000')

print @t1
print @t2
print @t3
print @t4
print @t5

select type,isnull(convert(varchar(40),bc),0) as bc,isnull(convert(varchar(40),bg),0) as bg,
	isnull(convert(varchar(40),fd),0) as fd,isnull(convert(varchar(40),shares),0) as shares,
	isnull(convert(varchar(40),cash),0) as cash,isnull(convert(varchar(40),(bc+bg+fd+shares+cash)),0) as total
	from  ff_ABCdeposit_details where rdate=@rdate+' 00:00:00.000'
union all

select 'TOTAL',isnull(convert(varchar(40),@t1),0),isnull(convert(varchar(40),@t2),0),
	isnull(convert(varchar(40),@t3),0),isnull(convert(varchar(40),@t4),0),
	isnull(convert(varchar(40),@t5),0),isnull(convert(varchar(40),(@t1+@t2+@t3+@t4+@t5)),0)

union all

select '','','','','','' ,''

union all

select 'ABC UTILIZED','IM/VAR','M TO M GROSS EX.','TOTAL MARGIN','FREE','',''

union all

select U.type,isnull(convert(varchar(40),U.IMVAR),0), isnull(convert(varchar(40),U.MTOM),0),
		 isnull(convert(varchar(40),(U.IMVAR+U.MTOM)),0),
		isnull(convert(varchar(40),(select (bc+bg+fd+shares+cash) from  ff_ABCdeposit_details
				where type=U.type and rdate=@rdate)-(U.IMVAR+U.MTOM)),0),'',''
from  ff_ABCutilized_details U
where U.rdate=@rdate

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.display_chq_details
-- --------------------------------------------------
CREATE proc [dbo].[display_chq_details]      
(@rdate datetime)  
as  
select type,ncdex,mcx,aslfo,bse,nse,nsefo,total=(ncdex+mcx+aslfo+bse+nse+nsefo) into #temp   
from testdb.dbo.ff_acc_details  
where rdate=@rdate+' 00:00:00.000'  
  
  
declare @NCDEX numeric(20,2)  
declare @MCX numeric(20,2)  
declare @ASLFO numeric(20,2)  
declare @BSE numeric(20,2)  
declare @NSE numeric(20,2)  
declare @NSEFO numeric(20,2)  
declare @TOTAL numeric(20,2)  
  
set @NCDEX=(select sum(ncdex) as NCDEX from #temp)  
set @NCDEX=(select sum(mcx) as MCX from #temp)  
set @ASLFO=(select sum(aslfo) as ASLFO from #temp)  
set @BSE=(select sum(bse) as BSE from #temp)  
set @NSE=(select sum(nse) as NSE from #temp)  
set @NSEFO=(select sum(nsefo) as NSEFO from #temp)  
set @TOTAL=(select sum(total) as TOTAL from #temp)  
  
select * from #temp  
union all  
select 'TOTAL',@NCDEX,@NCDEX,@ASLFO,@BSE,@NSE,@NSEFO,@TOTAL  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Extract_values
-- --------------------------------------------------

CREATE proc [dbo].[Extract_values]
(
@date datetime
)
as 

declare @NCDEX_A26 as numeric(25,2)
declare @NSEFO_A26 as numeric(25,2)
declare @MCX_A as numeric(25,2)
declare @MCX_B as numeric(25,2)
declare @NSEFO_B8 as numeric(25,2)
declare @NSEFO_B9 as numeric(25,2)
declare @NCDEX_B8 as numeric(25,2)
declare @NCDEX_B9 as numeric(25,2)
declare @ABL_B8 as numeric(25,2)
declare @ABL_B9 as numeric(25,2)


set @NCDEX_B8 = (select isnull(sum(value),0) from ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NCDEX_B8')

set @NCDEX_B9 = (select isnull(sum(value),0) from ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NCDEX_B9')

set @NSEFO_B8 = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NSEFO_B8')

set @NSEFO_B9 = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NSEFO_B9')

set @MCX_A = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='MCX_A')

set @MCX_B = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='MCX_B')

set @NCDEX_A26 = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NCDEX_A2')-
		(select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NCDEX_A6')

set @NSEFO_A26 = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NSEFO_A2')-
		(select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='NSEFO_A6')

set @ABL_B8 = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='ABL_B8')

set @ABL_B9 = (select isnull(sum(value),0) from  ff_other_values
		where datemodified=@date+' 00:00:00.000' and type='ABL_B9')



select @NSEFO_A26 as NSEFO_A26, @NCDEX_A26 as NCDEX_A26, @MCX_A as MCX_A, @MCX_B as MCX_B,
 @NSEFO_B8 as NSEFO_B8, @NSEFO_B9 as NSEFO_B9, @NCDEX_B8 as NCDEX_B8, @NCDEX_B9 as NCDEX_B9,
@ABL_B8 as ABL_B8,@ABL_B9 as ABL_B9  --into #temp

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fileupload
-- --------------------------------------------------

CREATE proc [dbo].[fileupload]  
(  
 @data varchar(max),  
 @date datetime,  
 @fname varchar(max),  
 @segment varchar(100)  
)  
as  
  
declare @filecount as int 
declare @lastDate as datetime
 
select @filecount= count(upload_dt) from fileuploads where 
segment=--'ABL-CASH'
@segment 
and
upload_dt in 
(
select upload_dt from fileuploads where segment = --'ABL-CASH'
@segment 
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 

--select max(upload_dt) from fileuploads where segment =--'ABL-CASH')
--@segment
)

set @lastdate = ( select upload_dt from fileuploads where segment=--'ABL-CASH'
@segment 
 and
upload_dt in 
(
select upload_dt from fileuploads where segment = --'ABL-CASH'
@segment 
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 
) )

--print @filecount
--print @lastdate
/*
(select substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) from fileuploads where 
 substring(convert(varchar(30),max(upload_dt)),0,charindex(convert(varchar(5),datepart(yyyy,max(upload_dt))),max(upload_dt))+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 
having upload_dt < getdate() 
) 
*/
--print @filecount  
  
if (@filecount<>0)  
begin   
update fileuploads set data=@data ,filename=@fname, upload_dt=@date where segment=@segment and upload_dt = @lastdate
--like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4)   
end  
else  
begin  
insert into fileuploads values(@data,@date,@fname,@segment)  
end  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.funds_calc
-- --------------------------------------------------



CREATE proc [dbo].[funds_calc]
as
-------------------------- Setting current year ---------------------------
declare @acyearfrom as datetime,@acyearto as datetime
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock) 
where sdtcur <=getdate() and ldtcur >=getdate()

------- Clear Table
update ff_bank_details set fundsBalance=0

-------------------------- Get all Balances for BSE ---------------------------
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
into #funds_bse
from
(select cltcode,drcr,vamt,vdt from anand.account_ab.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details (nolock) where segment='BSECM') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode

-------------------------- Get all Balances for NSE ---------------------------
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
into #funds_nse
from
(select cltcode,drcr,vamt,vdt from anand1.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details (nolock) where segment='NSECM') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode

-------------------------- Get all Balances for NSE FO---------------------------
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
into #funds_nsefo
from
(select cltcode,drcr,vamt,vdt from angelfo.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details (nolock) where segment='NSEFO') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode


-------------------------- Update BSE Balances into FF_Bank_Details ---------------------------
update ff_bank_Details set ff_bank_Details.FundsBalance=isnull(b.fund_balance,0)
from #funds_bse b
where ff_bank_Details.cltcode=b.cltcode and ff_bank_Details.segment='BSECM'


-------------------------- Update NSE Balances into FF_Bank_Details ---------------------------
update ff_bank_Details set ff_bank_Details.FundsBalance=isnull(b.fund_balance,0)
from #funds_nse b
where ff_bank_Details.cltcode=b.cltcode and ff_bank_Details.segment='NSECM'

-------------------------- Update BSE Balances into FF_Bank_Details ---------------------------
update ff_bank_Details set ff_bank_Details.FundsBalance=isnull(b.fund_balance,0)
from #funds_nsefo b
where ff_bank_Details.cltcode=b.cltcode and ff_bank_Details.segment='NSEFO'


------------ Update HO with sum of all other cltcodes -----------
update ff_bank_details
set ff_bank_details.FundsBalance = 
(select sum(c.Fund_Balance) from 
( select a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end) from 
(select cltcode,drcr,vamt,vdt from anand.account_ab.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a 
where (a.cltcode<>'02050' and a.cltcode<>'02052' and a.cltcode<>'02063' and a.cltcode<>'02076' 
and a.cltcode<>'02075' and a.cltcode<>'02084' and a.cltcode<>'02041' and a.cltcode<>'02065' )
group by a.cltcode
) c)
where branch_code='HO' and segment='BSECM'


select branch_code, count(branch_code), 
BSE=isnull((select sum(fundsbalance) from ff_bank_Details (nolock) where segment='BSECM' and branch_code=a.branch_code group by segment ),0),
NSE=isnull((select sum(fundsbalance) from ff_bank_Details  (nolock) where segment='NSECM' and branch_code=a.branch_code group by segment),0),
NSEFO=isnull((select sum(fundsbalance) from ff_bank_Details  (nolock) where segment='NSEFO' and branch_code=a.branch_code group by segment),0),
MCX=isnull((select sum(fundsbalance) from ff_bank_Details  (nolock) where segment='MCX' and branch_code=a.branch_code group by segment),0),
NCDEX=isnull((select sum(fundsbalance) from ff_bank_Details  (nolock) where segment='NCDEX' and branch_code=a.branch_code group by segment),0)
from ff_bank_details a (nolock)
group by branch_code


--select * from ff_bank_details
-- exec funds_calc
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.funds_calc1
-- --------------------------------------------------




CREATE proc [dbo].[funds_calc1]
as
-------------------------- Setting current year ---------------------------
declare @acyearfrom as datetime,@acyearto as datetime
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock) 
where sdtcur <=getdate() and ldtcur >=getdate()

------- Clear Table
update ff_bank_details set fundsBalance=0

-------------------------- Get all Balances for BSE ---------------------------
update ff_bank_details set fundsBalance = x.Fund_balance
from
(select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
from
(select cltcode,drcr,vamt,vdt from anand.account_ab.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details where segment='BSECM') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode) x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='BSECM'


-------------------------- Get all Balances for BSEFO--------------------------
update ff_bank_details set fundsBalance = x.Fund_balance
from
(select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
from
(select cltcode,drcr,vamt,vdt from anand.accountbfo.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details where segment='BSEFO') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode) x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='BSEFO'


-------------------------- Get all Balances for NSE ---------------------------
update ff_bank_details set fundsBalance = x.Fund_balance
from
(select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
from
(select cltcode,drcr,vamt,vdt from anand1.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details where segment='NSECM') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode) x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='NSECM'


-------------------------- Get all Balances for NSE FO---------------------------
update ff_bank_details set fundsBalance = x.Fund_balance
from
(select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)
from
(select cltcode,drcr,vamt,vdt from angelfo.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,
(select * from FF_bank_Details where segment='NSEFO') b
where a.cltcode=b.cltcode
group by b.branch_Code,b.segment,a.cltcode) x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='NSEFO'


exec ho_fund_calc

select branch_code,
BSE=isnull((select sum(fundsbalance) from ff_bank_Details where segment='BSECM' and branch_code=a.branch_code group by segment ),0),
BSEFO=isnull((select sum(fundsbalance) from ff_bank_Details where segment='BSEFO' and branch_code=a.branch_code group by segment ),0),
NSE=isnull((select sum(fundsbalance) from ff_bank_Details  where segment='NSECM' and branch_code=a.branch_code group by segment),0),
NSEFO=isnull((select sum(fundsbalance) from ff_bank_Details where segment='NSEFO' and branch_code=a.branch_code group by segment),0),
MCX=isnull((select sum(fundsbalance) from ff_bank_Details  where segment='MCX' and branch_code=a.branch_code group by segment),0),
NCDEX=isnull((select sum(fundsbalance) from ff_bank_Details  where segment='NCDEX' and branch_code=a.branch_code group by segment),0),
Total=0
from ff_bank_details a (nolock)
group by branch_code
union all
select 'Total', 
bse= isnull((select sum(fundsbalance) from ff_bank_Details where segment='BSECM'),0), 
bsefo= isnull((select sum(fundsbalance) from ff_bank_Details where segment='BSEFO'),0), 
nse= isnull((select sum(fundsbalance) from ff_bank_Details where segment='NSECM'),0),
nsefo= isnull((select sum(fundsbalance) from ff_bank_Details where segment='NSEFO'),0),
mcx= isnull((select sum(fundsbalance) from ff_bank_Details where segment='MCX'),0),
ncdex= isnull((select sum(fundsbalance) from ff_bank_Details where segment='NCDEX'),0),
total= isnull((select sum(fundsbalance) from ff_bank_details),0)


-- exec funds_calc1
-- select * from ff_bank_details
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.funds_calc2
-- --------------------------------------------------

CREATE proc [dbo].[funds_calc2]      
as            
  
--(    
--@rdate datetime    
--)    
  
-------------------------- Setting current year ---------------------------            

declare @acyearfrom as datetime,@acyearto as datetime,@rdate datetime    
set @rdate=convert(varchar(11),getdate())  
--print @rdate  
            
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)             
where sdtcur <=getdate() and ldtcur >=getdate()            

            
------- Clear Table            
update ff_bank_details set fundsBalance=0            
--select * from ff_bank_details            
-------------------------- Get all Balances for BSE ---------------------------            
update ff_bank_details set fundsBalance = x.Fund_balance            
from            
/*
(
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)            
from  
(select cltcode,drcr,vamt,vdt from anand.account_ab.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,            
(select * from FF_bank_Details where segment='BSECM') b            
where a.cltcode=b.cltcode            
group by b.branch_Code,b.segment,a.cltcode) x            
*/
AngelBseCM.inhouse.dbo.ROE_Bank_Balance x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='BSECM'            
AND ff_bank_details.CLTCODE=X.CLTCODE    
  
        --group by a.cltcode,b.acname  
  
/*(select cltcode from intranet.roe.dbo.ff_bank_details where segment='BSECM' and cltcode <> 0)  
 and cltcode<>'06000015'  
and cltcode<>'10CNTR'  
and cltcode<>'5100000005')*/  
--)  
--group by a.cltcode,b.acname  
  
--) x  
            
  
  
/*  
select a.cltcode,b.acname, Fund_balance=sum(case when drcr='D' then -vamt else vamt end) from anand.account_ab.dbo.ledger a (nolock)   
left outer join   
anand.account_ab.dbo.acmast b  
on a.cltcode=b.cltcode  
where a.vdt >=@acyearfrom and a.vdt<=getdate()  
and a.cltcode in   
(select cltcode from anand.account_ab.dbo.acmast b where grpcode='A0303020000'  
and cltcode not in (select cltcode from ff_bank_details  where segment='BSECM' and cltcode <> 0)   
and cltcode not in (SELECT CLTCODE FROM FF_REJ_BANK_DETAILS  WHERE SEGMENT='BSECM' )  
*/  
  
-------------------------- Get all Balances for BSEFO--------------------------        
update ff_bank_details set fundsBalance = x.Fund_balance        
from        
/*
(
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)        
from        
(select cltcode,drcr,vamt,vdt from anand.accountbfo.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,        
(select * from FF_bank_Details where segment='BSEFO') b        
where a.cltcode=b.cltcode        
group by b.branch_Code,b.segment,a.cltcode
) x        
*/
AngelBSECM.inhouse_bfo.dbo.ROE_Bank_Balance X
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='BSEFO'        
AND ff_bank_details.CLTCODE=X.CLTCODE    
    
        
-------------------------- Get all Balances for NSE ---------------------------            
update ff_bank_details set fundsBalance = x.Fund_balance            
from            
/*
(select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)            
from            
(select cltcode,drcr,vamt,vdt from anand1.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,            
(select * from FF_bank_Details where segment='NSECM') b            
where a.cltcode=b.cltcode            
group by b.branch_Code,b.segment,a.cltcode) x            
*/
AngelNseCM.inhouse.dbo.ROE_Bank_Balance x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='NSECM'            
AND ff_bank_details.CLTCODE=X.CLTCODE    
            
            
-------------------------- Get all Balances for NSEFO---------------------------            
update ff_bank_details set fundsBalance = x.Fund_balance            
from            
/*
(
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)            
from            
(select cltcode,drcr,vamt,vdt from angelfo.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()) a,            
(select * from FF_bank_Details where segment='NSEFO') b            
where a.cltcode=b.cltcode            
group by b.branch_Code,b.segment,a.cltcode
) x            
*/
angelfo.inhouse.dbo.ROE_Bank_Balance x
where ff_bank_details.branch_code = x.branch_code and ff_bank_details.segment='NSEFO'            
AND ff_bank_details.CLTCODE=X.CLTCODE    
            
-------- update HO in all Segments        
exec ho_fund_calc         
    
drop table ff_bank_details_offline    
select * into ff_bank_details_offline from ff_bank_details    
  
------------ keep track of last update time  
truncate table ff_updates  
insert into ff_updates values(getdate(),@rdate)  
  
exec offline_bank_data @rdate    
    
--select * from  ff_bank_details_offlinedata    
--  select * from  ff_bank_details       
         
select branch_code,            
BSE=isnull((select sum(fundsbalance) from ff_bank_Details where segment='BSECM' and branch_code=a.branch_code group by segment ),0),            
BSEFO=isnull((select sum(fundsbalance) from ff_bank_Details where segment='BSEFO' and branch_code=a.branch_code group by segment ),0),        
NSE=isnull((select sum(fundsbalance) from ff_bank_Details  where segment='NSECM' and branch_code=a.branch_code group by segment),0),            
NSEFO=isnull((select sum(fundsbalance) from ff_bank_Details where segment='NSEFO' and branch_code=a.branch_code group by segment),0),            
MCX=isnull((select sum(fundsbalance) from ff_bank_Details  where segment='MCX' and branch_code=a.branch_code group by segment),0),            
NCDEX=isnull((select sum(fundsbalance) from ff_bank_Details  where segment='NCDEX' and branch_code=a.branch_code group by segment),0),          
Total=convert(float,0)          
into #temp          
from roe.dbo.ff_bank_details a (nolock)            
group by branch_code            
          
update #temp          
set total = convert(numeric(20,2),BSE + BSEFO + NSE + NSEFO + MCX + NCDEX)--round(,0)          
          
select * from #temp where branch_code = 'HO'        
union all        
select * from #temp where branch_code <> 'HO'        
union all        
select 'Total(A)',          
bse= isnull((select sum(BSE) from #temp),0),             
BSEFO=isnull((select sum(BSEFO) from #temp),0),             
nse= isnull((select sum(NSE) from #temp),0),            
nsefo= isnull((select sum(NSEFO) from #temp),0),            
mcx= isnull((select sum(MCX) from #temp),0),            
ncdex= isnull((select sum(NCDEX) from #temp),0),          
total= isnull((select sum(TOTAL) from #temp),0)            
            
--select * from ff_bank_details            
--select * from #temp          
-- exec funds_calc2           
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.generate_chartdata
-- --------------------------------------------------
CREATE proc generate_chartdata
(
 @option varchar(50),
 @branch varchar(50),
 @strfdate varchar(20),
 @strtdate varchar(20)
)

as

if @option='1'
begin
-------chart 1 ----------------
select 'Yes' as Prod, Total=
(select count(q2) as ctr from client_survey where main_branch=@branch 
and (q2='Y' or q2='S') and 
report_date=
(select DISTINCT report_date 
from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) )
) 
+
 (select count(q3) as ctr from client_survey 
where main_branch=@branch and q3='Y' and 
report_date= (select DISTINCT report_date 
from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) ) )

 union all 

select 'No' as Prod, Total= 
(select count(q2) as ctr from client_survey where main_branch=@branch
 and q2='N' and 
report_date=
(select DISTINCT report_date from client_survey_info where main_branch=@branch 
and (date>=@strfdate and date<= @strtdate) )
) 
+
 (select count(q3) as ctr from client_survey 
where main_branch=@branch and q3='N' and report_date=(select DISTINCT report_date from client_survey_info 
where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ) ) union all 
select 'NA' as Prod,
 Total=(select count(q2) as ctr from client_survey where main_branch=@branch and q2='' and report_date=
(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ) )
 + (select count(q3) as ctr from client_survey where main_branch=@branch and q3='' and report_date=
(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ) )

end

if @option='2'
begin
-------chart 2 ------------------------------------------------



select 'Yes' as Prod, Total=(select count(q4) as ctr from client_survey where 
main_branch=@branch and q4='Y' and report_date=(select DISTINCT report_date from client_survey_info
 where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ) ) union all select 'No'
as Prod, Total= (select count(q4) as ctr from client_survey where main_branch=@branch and q4='N' and 
report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) )) union all select 'NA' as Prod, Total=(select count(q4) as ctr from client_survey 
where main_branch=@branch and q4='' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) ))


end

if @option='3'

begin
-------chart 3 ------------------------------------------------



select 'Yes' as Prod, Total=(select count(q5) as ctr from client_survey where main_branch=@branch and q5='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and 
(date>=@strfdate and date<= @strtdate) )) + (select count(q6) as ctr from client_survey where 
main_branch=@branch and q6='G' and report_date=(select DISTINCT report_date from client_survey_info 
where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'Average'
 as Prod, Total=(select count(q5) as ctr from client_survey where main_branch=@branch and q5='S' and 
report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) )) + (select count(q6) as ctr from client_survey where main_branch=@branch and q6='A' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) )) union all select 'No' as Prod, Total=(select count(q5) as ctr from client_survey 
where main_branch=@branch and q5='N' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) + (select count(q6) as ctr from client_survey 
where main_branch=@branch and q6='B' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'NA' as Prod, Total=(select 
count(q5) as ctr from client_survey where main_branch=@branch and q5='' and report_date=(select DISTINCT report_date 
from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) + (select count(q6)
 as ctr from client_survey where main_branch=@branch and q6='' and report_date=(select DISTINCT report_date from 
client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ))

end

if @option='4'

begin
-------chart 4 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q9) as ctr from client_survey where main_branch=@branch and q9='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) ) ) union all select 'Average' as Prod, Total= (select count(q9) as ctr from client_survey 
where main_branch=@branch and q9='A' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total= 
(select count(q9) as ctr from client_survey where main_branch=@branch and q9='N' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 
union all select 'NA' as Prod, Total=(select count(q9) as ctr from client_survey where main_branch=@branch and q9=''
 and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) )) 

end


if @option='5'

begin
-------chart 5 ------------------------------------------------



select 'Yes' as Prod, Total=(select count(q12) as ctr from client_survey where main_branch=@branch and q12='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) ) ) union all select 'Average' as Prod, Total= (select count(q12) as ctr from client_survey 
where main_branch=@branch and q12='A' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total= 
(select count(q12) as ctr from client_survey where main_branch=@branch and q12='N' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 
union all select 'NA' as Prod, Total=(select count(q12) as ctr from client_survey where main_branch=@branch and q12=''
 and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) ))

end

if @option='6'

begin
-------chart 6 ------------------------------------------------


select 'Yes' as Prod, Total = (select count(q13) from client_survey where main_branch=@branch and q13 <> 'N' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch
 and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total = 
(select count(q13) from client_survey where main_branch=@branch and q13 = 'N' and report_date=
(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) ))


end

if @option='7'

begin
-------chart 7 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q14a) as ctr from client_survey where main_branch=@branch 
and q14a='Y' and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch 
and (date>=@strfdate and date<= @strtdate) ) ) union all select 'No' as Prod, Total= (select count(q14a) 
as ctr from client_survey where main_branch=@branch and q14a='N' and report_date=(select DISTINCT report_date 
from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 

end


if @option='8'

begin
-------chart 8 ------------------------------------------------



select 'Yes' as Prod, Total=(select count(q15) as ctr from client_survey where main_branch=@branch and q15='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'No' as Prod, Total= (select count(q15) as ctr from client_survey where
 main_branch=@branch and q15='N' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 

end



if @option='9'

begin
-------chart 9 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q16) as ctr from client_survey where main_branch=@branch and q16='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'No' as Prod, Total= (select count(q16) as ctr from client_survey where 
main_branch=@branch and q16='N' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'NA' as Prod, Total=(select 
count(q16) as ctr from client_survey where main_branch=@branch and q16='' and report_date=(select DISTINCT report_date
 from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 
end

if @option='10'

begin
-------chart 10 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q18a) as ctr from client_survey where main_branch=@branch and q18a='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) ) ) union all select 'Average' as Prod, Total= (select count(q18a) as ctr from client_survey 
where main_branch=@branch and q18a='S' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total= (select count
(q18a) as ctr from client_survey where main_branch=@branch and q18a='N' and report_date=(select DISTINCT report_date 
from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'NA'
 as Prod, Total=(select count(q18a) as ctr from client_survey where main_branch=@branch and q18a='' and report_date=
(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate)
 ))
end

if @option='11'

begin
-------chart 11 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q18b) as ctr from client_survey where main_branch=@branch and q18b='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) ) ) union all select 'Average' as Prod, Total= (select count(q18b) as ctr from client_survey 
where main_branch=@branch and q18b='S' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total= (select 
count(q18b) as ctr from client_survey where main_branch=@branch and q18b='N' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all 
select 'NA' as Prod, Total=(select count(q18b) as ctr from client_survey where main_branch=@branch and q18b='' and 
report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and 
date<= @strtdate) ))

end

if @option='12'

begin
-------chart 12 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q18c) as ctr from client_survey where main_branch=@branch and q18c='Y' and 
report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and 
date<= @strtdate) ) ) union all select 'Average' as Prod, Total= (select count(q18c) as ctr from client_survey where 
main_branch=@branch and q18c='S' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total= 
(select count(q18c) as ctr from client_survey where main_branch=@branch and q18c='N' and report_date=
(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and 
date<= @strtdate) )) union all select 'NA' as Prod, Total=(select count(q18c) as ctr from client_survey 
where main_branch=@branch and q18c='' and report_date=(select DISTINCT report_date from client_survey_info 
where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ))

end

if @option='13'

begin
-------chart 13 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q18d) as ctr from client_survey where main_branch=@branch 
and q18d='Y' and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and 
(date>=@strfdate and date<= @strtdate) ) ) union all select 'Average' as Prod, Total= (select count(q18d) as ctr 
from client_survey where main_branch=@branch and q18d='S' and report_date=(select DISTINCT report_date from 
client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 
'No' as Prod, Total= (select count(q18d) as ctr from client_survey where main_branch=@branch and q18d='N' and 
report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'NA' as Prod, Total=(select count(q18d) as ctr from client_survey where 
main_branch=@branch and q18d='' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) ))

end

if @option='14'

begin
-------chart 14 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q19) as ctr from client_survey where main_branch=@branch and q19='G' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) ) ) union all select 'Average' as Prod, Total=(select count(q19) as ctr from client_survey 
where main_branch=@branch and q19='A' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total=(select 
count(q19) as ctr from client_survey where main_branch=@branch and q19='B' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ))

end

if @option='15'

begin
-------chart 15 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q20) as ctr from client_survey where main_branch=@branch and q20='Y' and 
report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and 
date<= @strtdate) ) ) union all select 'No' as Prod, Total= (select count(q20) as ctr from client_survey where 
main_branch=@branch and q20='N' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'Average' as Prod, Total=
(select count(q20) as ctr from client_survey where main_branch=@branch and q20='S' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) ))

end

if @option='16'

begin
-------chart 16 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q21) as ctr from client_survey where main_branch=@branch and q21='G' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'Average' as Prod, Total=(select count(q21) as ctr from client_survey 
where main_branch=@branch and q21='A' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'Bad' as Prod, Total=(select 
count(q21) as ctr from client_survey where main_branch=@branch and q21='B' and report_date=(select DISTINCT report_date
 from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 
'NA' as Prod, Total= (select count(q21) as ctr from client_survey where main_branch=@branch and q21='' and report_date=
(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate)
 ))

end

if @option='17'

begin
-------chart 17 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q22a) as ctr from client_survey where main_branch=@branch and q22a='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'Average' as Prod, Total=(select count(q22a) as ctr from client_survey where 
main_branch=@branch and q22a='S' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total=(select 
count(q22a) as ctr from client_survey where main_branch=@branch and q22a='N' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 
union all select 'NA' as Prod, Total= (select count(q22a) as ctr from client_survey where main_branch=@branch 
and q22a='' and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and 
(date>=@strfdate and date<= @strtdate) ))

end


if @option='18'

begin
-------chart 18 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q23) as ctr from client_survey where main_branch=@branch and q23='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'Average' as Prod, Total=(select count(q23) as ctr from client_survey where 
main_branch=@branch and q23='A' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'No' as Prod, Total=(select 
count(q23) as ctr from client_survey where main_branch=@branch and q23='N' and report_date=(select DISTINCT report_date
 from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 
'NA' as Prod, Total= (select count(q23) as ctr from client_survey where main_branch=@branch and q23='' and report_date
=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= 
@strtdate) ))

end



if @option='19'

begin
-------chart 19 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q23) as ctr from client_survey where main_branch=@branch and q23='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'No' as Prod, Total=(select count(q23) as ctr from client_survey where 
main_branch=@branch and q23='N' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 

end

if @option='20'

begin
-------chart 20 ------------------------------------------------


select 'Good' as Prod, Total=(select count(q24) as ctr from client_survey where main_branch=@branch and q24='G' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate 
and date<= @strtdate) )) union all select 'Average' as Prod, Total=(select count(q24) as ctr from client_survey where 
main_branch=@branch and q24='A' and report_date=(select DISTINCT report_date from client_survey_info where 
main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'Bad' as Prod, Total=(select 
count(q24) as ctr from client_survey where main_branch=@branch and q24='B' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 
union all select 'NA' as Prod, Total=(select count(q24) as ctr from client_survey where main_branch=@branch 
and q24='' and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and 
(date>=@strfdate and date<= @strtdate) ))
end


if @option='21'

begin
-------chart 21 ------------------------------------------------


select 'Yes' as Prod, Total=(select count(q26) as ctr from client_survey where main_branch=@branch and q26='Y' 
and report_date=(select DISTINCT report_date from client_survey_info where main_branch=@branch and (date>=@strfdate
 and date<= @strtdate) )) union all select 'No' as Prod, Total=(select count(q26) as ctr from client_survey where
 main_branch=@branch and q26='N' and report_date=(select DISTINCT report_date from client_survey_info where
 main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) union all select 'NA' as Prod, Total=(select 
count(q26) as ctr from client_survey where main_branch=@branch and q26='' and report_date=(select DISTINCT 
report_date from client_survey_info where main_branch=@branch and (date>=@strfdate and date<= @strtdate) )) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.HO_fund_calc
-- --------------------------------------------------

CREATE proc [dbo].[HO_fund_calc]        
as        
         
-------------------------- Setting current year ---------------------------        
--if (convert(varchar(2),getdate(),114)<=15  or convert(varchar(2),getdate(),114)>=18) or datepart(dw,getdate()) = 7    
--begin      

/*      
declare @acyearfrom as datetime,@acyearto as datetime        
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)         
where sdtcur <=getdate() and ldtcur >=getdate()        
*/         
        
update ff_bank_details        
set ff_bank_details.FundsBalance =         
/*
(        
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  
from anand.account_ab.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()        
and cltcode in         
(select cltcode from anand.account_ab.dbo.acmast where       
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='BSECM')      
and cltcode not in (SELECT CLTCODE FROM intranet.roe.dbo.FF_REJ_BANK_DETAILS WHERE SEGMENT='BSECM')      
and cltcode not in (select cltcode from intranet.roe.dbo.ff_bank_details where segment='BSECM' and cltcode <> 0)      
and branchcode not in (select distinct(branch_code) from intranet.roe.dbo.ff_bank_details where branch_code <> 'HO')      
*/
/*      
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='BSECM')      
and cltcode not in (select cltcode from ff_bank_details where segment='BSECM' and cltcode <> 0)        
 and cltcode NOT IN (SELECT CLTCODE FROM FF_REJ_BANK_DETAILS WHERE SEGMENT='BSECM' )      

)        
--not in (select cltcode from ff_bank_details where segment='BSECM' and cltcode <> 0)        
--and cltcode in (select cltcode from anand.account_ab.dbo.acmast where grpcode='A0303020000')        
) 
*/
(select fund_balance from AngelBSECM.inhouse.dbo.ROE_GetHOfund)
where branch_code='HO' and segment='BSECM' and cltcode=0        
           
--select * from ff_bank_grpcode        
      
update ff_bank_details        
set ff_bank_details.FundsBalance =         
/*
(        
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  from anand.accountbfo.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()        
and cltcode in         
(select cltcode from anand.accountbfo.dbo.acmast where       
--grpcode  ='A0202000000'        
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='BSEFO')      
and cltcode not in         
(select cltcode from ff_bank_details where segment='BSEFO' and cltcode <> 0)        
)        
)
*/
(select fund_balance from AngelBSECM.inhouse_bfo.dbo.ROE_GetHOfund)  
where branch_code='HO' and segment='BSEFO' and cltcode=0        
        
        
        
update ff_bank_details        
set ff_bank_details.FundsBalance =         
/*
(        
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  from anand1.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()        
and cltcode in         
(select cltcode from anand1.inhouse.dbo.acmast where       
--grpcode='A0202000000'        
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='NSECM')      
and cltcode not in (select cltcode from ff_bank_details where segment='NSECM' and cltcode <> 0)        
and cltcode not in (SELECT CLTCODE FROM FF_REJ_BANK_DETAILS WHERE SEGMENT='NSECM')        
))
*/
(select* from AngelNseCM.inhouse.dbo.ROE_GetHOfund)
where branch_code='HO' and segment='NSECM'  and cltcode=0        
         
        
update ff_bank_details        
set ff_bank_details.FundsBalance =         
/*
(        
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  from angelfo.inhouse.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()        
and cltcode in         
(
select cltcode from angelfo.inhouse.dbo.acmast where       
--grpcode='A0202000000'         
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='NSEFO')      
and cltcode not in (select cltcode from ff_bank_details where segment='NSEFO' and cltcode <> 0)        
and cltcode not in (SELECT CLTCODE FROM intranet.roe.dbo.FF_REJ_BANK_DETAILS WHERE SEGMENT='NSEFO')       
)         
)
*/
(select * from angelfo.inhouse.dbo.ROE_GetHOfund)
where branch_code='HO' and segment='NSEFO' and cltcode=0        
        
         
        
update ff_bank_details        
set ff_bank_details.FundsBalance =         
/*
(        
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)          
from angelcommodity.accountmcdx.dbo.ledger (nolock)         
where vdt >=@acyearfrom and vdt<=getdate()        
and cltcode in         
(select cltcode from angelcommodity.accountmcdx.dbo.acmast where       
--grpcode='A0312000000'         
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='MCX')      
and cltcode not in (select cltcode from ff_bank_details where segment='MCX' and cltcode <> 0)        
)         
)
*/
(select fund_balance from angelcommodity.inhouse_mcdx.dbo.ROE_GetHOfund)
where branch_code='HO' and segment='MCX' and cltcode=0        
        
         
        
update ff_bank_details        
set ff_bank_details.FundsBalance =         
/*
(        
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  from angelcommodity.accountncdx.dbo.ledger (nolock) where vdt >=@acyearfrom and vdt<=getdate()        
and cltcode in         
(select cltcode from angelcommodity.accountncdx.dbo.acmast where       
--grpcode='A0312000000'         
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='NCDX')      
and cltcode not in (select cltcode from ff_bank_details where segment='NCDEX' and cltcode <> 0)         
)        
) 
*/
(select fund_balance from angelcommodity.inhouse_ncdx.dbo.ROE_GetHOfund)
where branch_code='HO' and segment='NCDEX' and cltcode=0        
--select * from ff_bank_grpcode      
--end     
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.offline_bank_data
-- --------------------------------------------------
CREATE proc [dbo].[offline_bank_data]    
(    
@rdate datetime        
)    
as    
   
declare @cnt integer        
set @cnt=(select count(rdate) from ff_bank_details_offlinedata  with (nolock)
where rdate=@rdate+' 00:00:00.000' )        
  
--insert into ff_bank_details_offlinedata  
select @rdate as 'rdate',branch_code, segment, convert(numeric(25,2),sum(fundsbalance)) as 'fundsbalance'    
into #temp    
from ff_bank_details with (nolock) group by branch_code, segment   
    
  
-- select * from #temp  
    
if @cnt > 0        
begin        
 delete from ff_bank_details_offlinedata where rdate=@rdate  
end       
    
insert into ff_bank_details_offlinedata      
select * from #temp    
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.offline_fund_calc
-- --------------------------------------------------

CREATE proc [dbo].[offline_fund_calc]
(
@rdate datetime
)
as

select branch_code,        
BSE=isnull((select sum(fundsbalance) from ff_bank_details_offline where segment='BSECM' and branch_code=a.branch_code group by segment ),0),        
BSEFO=isnull((select sum(fundsbalance) from ff_bank_details_offline where segment='BSEFO' and branch_code=a.branch_code group by segment ),0),    
NSE=isnull((select sum(fundsbalance) from ff_bank_details_offline  where segment='NSECM' and branch_code=a.branch_code group by segment),0),        
NSEFO=isnull((select sum(fundsbalance) from ff_bank_details_offline where segment='NSEFO' and branch_code=a.branch_code group by segment),0),        
MCX=isnull((select sum(fundsbalance) from ff_bank_details_offline  where segment='MCX' and branch_code=a.branch_code group by segment),0),        
NCDEX=isnull((select sum(fundsbalance) from ff_bank_details_offline  where segment='NCDEX' and branch_code=a.branch_code group by segment),0),      
Total=convert(float,0)      
into #temp      
from ff_bank_details_offline a (nolock)        
group by branch_code        
      
update #temp      
set total = convert(numeric(20,2),BSE + BSEFO + NSE + NSEFO + MCX + NCDEX)--round(,0)      
      
select * from #temp where branch_code = 'HO'    
union all    
select * from #temp where branch_code <> 'HO'    
union all    
select 'Total(A)',      
bse= isnull((select sum(BSE) from #temp),0),         
BSEFO=isnull((select sum(BSEFO) from #temp),0),         
nse= isnull((select sum(NSE) from #temp),0),        
nsefo= isnull((select sum(NSEFO) from #temp),0),        
mcx= isnull((select sum(MCX) from #temp),0),        
ncdex= isnull((select sum(NCDEX) from #temp),0),      
total= isnull((select sum(TOTAL) from #temp),0)        

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.offline_fund_disp
-- --------------------------------------------------

create proc [dbo].[offline_fund_disp]
(
@rdate datetime
)
as

select branch_code,        
BSE=isnull((select sum(fundsbalance) from ff_bank_details_offlinedata where segment='BSECM' and branch_code=a.branch_code and rdate=@rdate group by segment ),0),        
BSEFO=isnull((select sum(fundsbalance) from ff_bank_details_offlinedata where segment='BSEFO' and branch_code=a.branch_code and rdate=@rdate group by segment ),0),    
NSE=isnull((select sum(fundsbalance) from ff_bank_details_offlinedata  where segment='NSECM' and branch_code=a.branch_code and rdate=@rdate group by segment),0),        
NSEFO=isnull((select sum(fundsbalance) from ff_bank_details_offlinedata where segment='NSEFO' and branch_code=a.branch_code and rdate=@rdate group by segment),0),        
MCX=isnull((select sum(fundsbalance) from ff_bank_details_offlinedata  where segment='MCX' and branch_code=a.branch_code and rdate=@rdate group by segment),0),        
NCDEX=isnull((select sum(fundsbalance) from ff_bank_details_offlinedata  where segment='NCDEX' and branch_code=a.branch_code and rdate=@rdate group by segment),0),      
Total=convert(float,0)      
into #temp      
from ff_bank_details_offlinedata a (nolock)        
group by branch_code        
      
update #temp      
set total = convert(numeric(20,2),BSE + BSEFO + NSE + NSEFO + MCX + NCDEX)--round(,0)      
      
select * from #temp where branch_code = 'HO'    
union all    
select * from #temp where branch_code <> 'HO'    
union all    
select 'Total(A)',      
bse= isnull((select sum(BSE) from #temp),0),         
BSEFO=isnull((select sum(BSEFO) from #temp),0),         
nse= isnull((select sum(NSE) from #temp),0),        
nsefo= isnull((select sum(NSEFO) from #temp),0),        
mcx= isnull((select sum(MCX) from #temp),0),        
ncdex= isnull((select sum(NCDEX) from #temp),0),      
total= isnull((select sum(TOTAL) from #temp),0)        

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.offline_payin_calc
-- --------------------------------------------------



CREATE proc [dbo].[offline_payin_calc]
(
@rdate datetime
)
as

select *,total=convert(float,0)  into #temp1 from ff_payin_details  

update #temp1   
set total = bse + bsefo +nse + nsefo + mcx + ncdx  
  
declare @bse float  
declare @nse float  
declare @bsefo float  
declare @nsefo float  
declare @mcx float  
declare @ncdx float  
declare @total float  
  
set @bse = isnull((select sum(BSE) from #temp1),0)  
set @nse = isnull((select sum(NSE) from #temp1),0)  
set @bsefo = isnull((select sum(BSEFO) from #temp1),0)  
set @nsefo = isnull((select sum(NSEFO) from #temp1),0)  
set @mcx = isnull((select sum(MCX) from #temp1),0)  
set @ncdx = isnull((select sum(NCDX) from #temp1),0)  
set @total = isnull((select sum(TOTAL) from #temp1),0)  

---------------------- Get BSE SEtt No.
select dwn=datepart(dw,start_date),sett='D/'+convert(varchar(3),right(sett_no,3))+space(10)
into #sett
from risk.dbo.bse_sett_mst where sett_type='D' 
and start_date >= convert(varchar(11),getdate())
and start_date <= convert(varchar(11),getdate()+6)

---------------------- Get NSE SEtt No.
update #sett set sett=ltrim(rtrim(#sett.sett))+' '+x.sett from
(
select dwn=datepart(dw,start_date),sett='N/'+convert(varchar(3),right(sett_no,3))
from risk.dbo.nse_sett_mst where sett_type='N' 
and start_date >= convert(varchar(11),getdate())
and start_date <= convert(varchar(11),getdate()+6)
) x where #sett.dwn=x.dwn

alter table #temp1 alter column dow varchar(30)
update #temp1   set dow=ltrim(rtrim(dow))+' ['+b.sett+']' from #sett b where #temp1.dwn=b.dwn

----------------------

select * from
(  
select dow,bse,bsefo,nse,nsefo,MCX,NCDX,total,dwn
from #temp1    
where bse <> 0 or nse <>0 or bsefo <>0 or nsefo <>0 or mcx <>0 or ncdx<>0 --or dow='total'  
union ALL  
SELECT dow='Total(B)',  
bse=@bse,bsefo=@bsefo,nse=@nse,nsefo=@nsefo,mcx=@mcx,ncdex=@ncdx,total=@total,dwn=99
) x
order by 
(case when (dwn-datepart(dw,getdate())) < 0 then abs((datepart(dw,getdate())-dwn)-7)
else (dwn-datepart(dw,getdate())) end
 ) 

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.offline_payin_data
-- --------------------------------------------------

create proc [dbo].[offline_payin_data]  
(  
@rdate datetime      
)  
as  
 
declare @cnt integer 
set @cnt=(select count(rdate) from ff_payin_details_offlinedata    
where rdate=@rdate+' 00:00:00.000' )      


select @rdate as 'rdate',a.* 
into #temp  
from ff_payin_details a
where bse<>0 or nse<>0 or nsefo<>0 or mcx<>0 or ncdx<>0 or bsefo<>0

  

-- select * from #temp
  
if @cnt > 0      
begin      
 delete from ff_payin_details_offlinedata where rdate=@rdate
   
end     
  
insert into ff_payin_details_offlinedata    
select * from #temp  

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.offline_payin_disp
-- --------------------------------------------------


CREATE proc [dbo].[offline_payin_disp]
(
@rdate datetime
)
as

select *,total=convert(float,0)  into #temp1 from ff_payin_details_offlinedata
where rdate=@rdate

update #temp1   
set total = bse + bsefo +nse + nsefo + mcx + ncdx  
  
declare @bse float  
declare @nse float  
declare @bsefo float  
declare @nsefo float  
declare @mcx float  
declare @ncdx float  
declare @total float  
  
set @bse = isnull((select sum(BSE) from #temp1),0)  
set @nse = isnull((select sum(NSE) from #temp1),0)  
set @bsefo = isnull((select sum(BSEFO) from #temp1),0)  
set @nsefo = isnull((select sum(NSEFO) from #temp1),0)  
set @mcx = isnull((select sum(MCX) from #temp1),0)  
set @ncdx = isnull((select sum(NCDX) from #temp1),0)  
set @total = isnull((select sum(TOTAL) from #temp1),0)  

---------------------- Get BSE SEtt No.
select dwn=datepart(dw,start_date),sett='D/'+convert(varchar(3),right(sett_no,3))+space(10)
into #sett
from risk.dbo.bse_sett_mst where sett_type='D' 
and start_date >= convert(varchar(11),getdate())
and start_date <= convert(varchar(11),getdate()+6)

---------------------- Get NSE SEtt No.
update #sett set sett=ltrim(rtrim(#sett.sett))+' '+x.sett from
(
select dwn=datepart(dw,start_date),sett='N/'+convert(varchar(3),right(sett_no,3))
from risk.dbo.nse_sett_mst where sett_type='N' 
and start_date >= convert(varchar(11),getdate())
and start_date <= convert(varchar(11),getdate()+6)
) x where #sett.dwn=x.dwn

alter table #temp1 alter column dow varchar(30)
update #temp1   set dow=ltrim(rtrim(dow))+' ['+b.sett+']' from #sett b where #temp1.dwn=b.dwn

----------------------


select * from
(  
select dow,bse,bsefo,nse,nsefo,MCX,NCDX,total,dwn
from #temp1    
where bse <> 0 or nse <>0 or bsefo <>0 or nsefo <>0 or mcx <>0 or ncdx<>0 --or dow='total'  
union ALL  
SELECT dow='Total(B)',  
bse=@bse,bsefo=@bsefo,nse=@nse,nsefo=@nsefo,mcx=@mcx,ncdex=@ncdx,total=@total,dwn=99
) x
order by 
(case when (dwn-datepart(dw,getdate())) < 0 then abs((datepart(dw,getdate())-dwn)-7)
else (dwn-datepart(dw,getdate())) end
 ) 

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.payin_calc
-- --------------------------------------------------




CREATE proc [dbo].[payin_calc]
as 

declare @acyearfrom as datetime,@acyearto as datetime
select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock) 
where sdtcur <= getdate() and ldtcur >= getdate()
 
---  Clear table
update ff_payin_Details set ff_payin_Details.bse=0,
ff_payin_Details.nse=0, ff_payin_Details.nsefo=0, ff_payin_Details.mcx=0, ff_payin_Details.ncdx=0

-------------------------- Get all Pay IN/Out for BSE ---------------------------
select segment='BSECM',b.cltcode,
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),
Amount=sum(case when a.drcr='D' then -vamt else vamt end)
into #pay_bse
from AngelBSECM.account_ab.dbo.ledger a 
,(select * from FF_bank_Details (nolock) where segment='BSECM') b
where a.cltcode=b.cltcode
and a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto 
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt)),segment,b.cltcode


-------------------------- Get all Pay IN/Out for NSE ---------------------------
select segment='NSECM',b.cltcode,
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),
Amount=sum(case when a.drcr='D' then -vamt else vamt end)
into #pay_nse
from AngelNseCM.inhouse.dbo.ledger a 
,(select * from FF_bank_Details (nolock) where segment='NSECM') b
where a.cltcode=b.cltcode
and a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto 
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt)),segment,b.cltcode

-------------------------- Get all Pay IN/Out for NSEFO ---------------------------
select segment='NSEFO',b.cltcode,
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),
Amount=sum(case when a.drcr='D' then -vamt else vamt end)
into #pay_nsefo
from angelfo.inhouse.dbo.ledger a 
,(select * from FF_bank_Details (nolock) where segment='NSEFO') b
where a.cltcode=b.cltcode
and a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto 
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt)),segment,b.cltcode

-------------------------- Get all Pay IN/Out for MCX ---------------------------
select segment='MCX',b.cltcode,
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),
Amount=sum(case when a.drcr='D' then -vamt else vamt end)
into #pay_mcx
from angelcommodity.accountmcdx.dbo.ledger a 
,(select * from FF_bank_Details (nolock) where segment='MCX') b
where a.cltcode=b.cltcode
and a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto 
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt)),segment,b.cltcode

-------------------------- Get all Pay IN/Out for NCDEX ---------------------------
select segment='NCDEX',b.cltcode,
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),
Amount=sum(case when a.drcr='D' then -vamt else vamt end)
into #pay_NCDX
from angelcommodity.accountNcdx.dbo.ledger a 
,(select * from FF_bank_Details (nolock) where segment='NCDEX') b
where a.cltcode=b.cltcode
and a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto 
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt)),segment,b.cltcode


-------------------------- Update ALL PAYINs into FF_payin_Details ---------------------------
update ff_payin_Details 
set ff_payin_Details.bse=isnull((select pay_amt_BSE=sum(amount) from #pay_bse where dow = ff_payin_Details.dow group by dow),0), 
ff_payin_Details.nse=isnull((select pay_amt_NSE=sum(amount) from #pay_nse where dow = ff_payin_Details.dow group by dow),0),
ff_payin_Details.nsefo=isnull((select pay_amt_NSEfo=sum(amount) from #pay_nsefo where dow = ff_payin_Details.dow group by dow),0),
ff_payin_Details.mcx=isnull((select pay_amt_mcx=sum(amount) from #pay_mcx where dow = ff_payin_Details.dow group by dow),0),
ff_payin_Details.ncdx=isnull((select pay_amt_ncdx=sum(amount) from #pay_ncdx where dow = ff_payin_Details.dow group by dow),0)

select *,total=convert(float,0)  into #temp1 from ff_payin_details
update #temp1 
set total = bse +nse + nsefo + mcx + ncdx

declare @bse float
declare @nse float
--declare @bsefo float
declare @nsefo float
declare @mcx float
declare @ncdx float
declare @total float

set @bse = isnull((select sum(BSE) from #temp1),0)
set @nse = isnull((select sum(NSE) from #temp1),0)
--set @bsefo = isnull((select sum(BSEFO) from #temp1),0)
set @nsefo = isnull((select sum(NSEFO) from #temp1),0)
set @mcx = isnull((select sum(MCX) from #temp1),0)
set @ncdx = isnull((select sum(NCDX) from #temp1),0)
set @total = isnull((select sum(TOTAL) from #temp1),0)

/*insert into #temp1 values('Total',@bse,@nse,@nsefo,@mcx,@ncdx,@total)

*/


select dow,bse,nse,nsefo,MCX,NCDX,total from #temp1  
where bse <> 0 or nse <>0 or bsefo <>0 or nsefo <>0 or mcx <>0 or ncdx<>0 --or dow='total'
union ALL
SELECT 'Total(B)',
@bse,@nse,@nsefo,@mcx,@ncdx,@total


/*
drop table #pay_bse
drop table #pay_nse
drop table #pay_nsefo

drop table #pay_MCX
drop table #pay_NCDX


update ff_payin_Details 
set ff_payin_Details.bse=0,
ff_payin_Details.nse=0,
ff_payin_Details.nsefo=0,
ff_payin_Details.mcx=0,
ff_payin_Details.ncdx=0


select * from ff_payin_details
update ff_bank_details
set fundsBalance=0

select distinct(b.dow),b.cltcode,amount1=(case when (b.segment='BSECM' and b.cltcode=a.cltcode) then b.amount else 0 end) from #pay_bse b, 
(select cltcode from ff_bank_details where segment='BSECM') a

*/

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.payin_calc1
-- --------------------------------------------------




CREATE proc [dbo].[payin_calc1]      
as       

--(  @rdate as datetime  )  
      
declare @acyearfrom as datetime,@acyearto as datetime,@rdate as datetime        
set @rdate=convert(varchar(11),getdate())  

select @acyearfrom=sdtcur,@acyearto=ldtcur from risk.dbo.parameter (nolock)       
where sdtcur <= getdate() and ldtcur >= getdate()      
    
    
    
---  Clear table      
update ff_payin_Details   
set ff_payin_Details.bse=0,ff_payin_Details.bsefo=0,      
ff_payin_Details.nse=0, ff_payin_Details.nsefo=0,   
ff_payin_Details.mcx=0, ff_payin_Details.ncdx=0      
truncate table ff_week_values    
      
-------------------------- Get all Pay IN/Out for BSE ---------------------------      
select     
segment='BSECM',--b.cltcode,      
--dwn=datepart(dw,a.edt),  
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),      
Amount=sum(case when a.drcr='D' then vamt else -vamt end)      
into #pay_bse      
from AngelBseCM.account_ab.dbo.ledger a       
--,(select * from FF_bank_Details (nolock) where segment='BSECM') b      
where a.cltcode='99785' and vtyp=15 and narration not like'%BSECMA%' and  
/*  
in (select cltcode from anand.account_ab.dbo.acmast where grpcode='A0303020000'     
and cltcode<>'06000015'    
and cltcode<>'10CNTR'    
and cltcode<>'5100000005') and    
*/  
--b.cltcode and     
a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto       
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt))    
--,segment--,b.cltcode     
    
    
    
-------------------------- Get all Pay IN/Out for BSEFO ---------------------------      
select     
segment='BSEFO',--b.cltcode,      
--dwn=datepart(dw,a.edt),  
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),      
Amount=sum(case when a.drcr='D' then vamt else -vamt end)      
into #pay_bsefo      
from AngelBseCM.accountbfo.dbo.ledger a       
--,(select * from FF_bank_Details (nolock) where segment='BSEFO') b      
where a.cltcode='99885' and vtyp=15 and   
/*  
in (select cltcode from anand.accountbfo.dbo.acmast where grpcode='A0202000000'    
and cltcode<>'06000015'    
and cltcode<>'10CNTR'    
and cltcode<>'5100000005') and    
--b.cltcode  and    
*/  
a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto       
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt))    
--,segment--,b.cltcode      
      
      
-------------------------- Get all Pay IN/Out for NSE ---------------------------      
select     
segment='NSECM',--b.cltcode,      
--dwn=datepart(dw,a.edt),  
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),      
Amount=sum(case when a.drcr='D' then vamt else -vamt end)      
into #pay_nse      
from AngelNseCM.inhouse.dbo.ledger a       
--,(select * from FF_bank_Details (nolock) where segment='NSECM') b      
where a.cltcode='99985' and vtyp=15 and narration not like'%NSECMA%' and  
/*  
a.cltcode  in (select cltcode from anand1.inhouse.dbo.acmast where grpcode='A0202000000'    
and cltcode<>'06000015'    
and cltcode<>'10CNTR'    
and cltcode<>'5100000005') and    
*/  
--=b.cltcode  and     
a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto       
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt))    
--,segment--,b.cltcode      
     
-------------------------- Get all Pay IN/Out for NSEFO ---------------------------      
  
select segment='NSEFO',  
--dwn=datepart(dw,getdate()),
--dow=datename(dw,getdate()),PDate=convert(datetime,convert(varchar(11),getdate())),  
dow=(case when (datename(dw,getdate()+1)='Sunday') then datename(dw,getdate()+2) else datename(dw,getdate()+1) end ),
--PDate=convert(datetime,convert(varchar(11),getdate()+1)),  
Amount=  
(  
select value from ff_other_values where type='NSEFO_BK01' and   
dateModified=convert(datetime,convert(varchar(11),getdate()))  
)  
into #pay_nsefo      


--select * from #pay_nsefo 
--drop table #pay_nsefo 

/*  
select     
segment='NSEFO',--b.cltcode,      
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),      
Amount=sum(case when a.drcr='D' then -vamt else vamt end)      
into #pay_nsefo      
from angelfo.inhouse.dbo.ledger a       
--,(select * from FF_bank_Details (nolock) where segment='NSEFO') b      
where     
a.cltcode in (select cltcode from angelfo.inhouse.dbo.acmast where grpcode='A0202000000'    
and cltcode<>'06000015'    
and cltcode<>'10CNTR'    
and cltcode<>'5100000005') and    
--=b.cltcode  and     
a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto       
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt))    
--,segment--,b.cltcode      
*/      
-------------------------- Get all Pay IN/Out for MCX ---------------------------      
select segment='MCX',  
--dwn=datepart(dw,getdate()),  
dow=datename(dw,getdate()),PDate=convert(datetime,convert(varchar(11),getdate())),Amount=0  
into #pay_mcx      
  
/*  
select     
segment='MCX',--b.cltcode,      
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),      
Amount=sum(case when a.drcr='D' then -vamt else vamt end)      
into #pay_mcx      
from angelcommodity.accountmcdx.dbo.ledger a       
--,(select * from FF_bank_Details (nolock) where segment='MCX') b      
where a.cltcode='99885' and vtyp=15 and --narration not like'%NSECMA%' and  
--=b.cltcode  and    
a.edt >= convert(varchar(11),getdate()-1)+' 00:00' and a.edt <= --@acyearto       
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt))    
*/  
--,segment--,b.cltcode      
      
-------------------------- Get all Pay IN/Out for NCDEX ---------------------------      
  
select segment='NCDEX',  
--dwn=datepart(dw,getdate()),  
dow=datename(dw,getdate()),PDate=convert(datetime,convert(varchar(11),getdate())),Amount=0  
into #pay_NCDX      
  
/*  
select     
segment='NCDEX',--b.cltcode,      
dow=datename(dw,a.edt),PDate=convert(datetime,convert(varchar(11),a.edt)),      
Amount=sum(case when a.drcr='D' then -vamt else vamt end)      
into #pay_NCDX      
from angelcommodity.accountNcdx.dbo.ledger a       
--,(select * from FF_bank_Details (nolock) where segment='NCDEX') b      
where     
a.cltcode in (select cltcode from angelcommodity.accountncdx.dbo.acmast where grpcode='A0312000000'    
and cltcode<>'06000015'    
and cltcode<>'10CNTR'    
and cltcode<>'5100000005') and    
--=b.cltcode  and    
a.edt >= convert(varchar(11),getdate())+' 00:00' and a.edt <= @acyearto       
group by datename(dw,a.edt),convert(datetime,convert(varchar(11),a.edt))    
--,segment--,b.cltcode      
*/      
      
-------------------------- Update ALL PAYINs into FF_payin_Details ---------------------------      
update ff_payin_Details       
set ff_payin_Details.bse=isnull((select pay_amt_BSE=sum(amount) from #pay_bse where dow = ff_payin_Details.dow group by dow),0),       
ff_payin_Details.bsefo=isnull((select pay_amt_BSEFO=sum(amount) from #pay_bsefo where dow = ff_payin_Details.dow group by dow),0),       
ff_payin_Details.nse=isnull((select pay_amt_NSE=sum(amount) from #pay_nse where dow = ff_payin_Details.dow group by dow),0),      
ff_payin_Details.nsefo=isnull((select pay_amt_NSEfo=sum(amount) from #pay_nsefo where dow = ff_payin_Details.dow group by dow),0),      
ff_payin_Details.mcx=isnull((select pay_amt_mcx=sum(amount) from #pay_mcx where dow = ff_payin_Details.dow group by dow),0),      
ff_payin_Details.ncdx=isnull((select pay_amt_ncdx=sum(amount) from #pay_ncdx where dow = ff_payin_Details.dow group by dow),0)      
      
    
--drop table #temp1    
  
select *,total=convert(float,0)  into #temp1 from ff_payin_details    
  
update #temp1     
set total = bse + bsefo +nse + nsefo + mcx + ncdx   

-------------- Refreshing data for the day by 12 noon
declare @dt as numeric
set @dt = convert(numeric,Datepart(hh,getdate()))
--print @dt
if @dt >= 12
begin
--select * from #temp1 where dow like '%' + datename(dw,getdate()) + '%'
update #temp1 set bse=0,nse=0,nsefo=0,mcx=0,ncdx=0,bsefo=0,total=0
where dow like '%' + datename(dw,getdate()) + '%'
update ff_payin_details set bse=0,nse=0,nsefo=0,mcx=0,ncdx=0,bsefo=0
where dow like '%' + datename(dw,getdate()) + '%'

end
--------------------------    
declare @bse float    
declare @nse float    
declare @bsefo float    
declare @nsefo float    
declare @mcx float    
declare @ncdx float    
declare @total float    
    
set @bse = isnull((select sum(BSE) from #temp1),0)    
set @nse = isnull((select sum(NSE) from #temp1),0)    
set @bsefo = isnull((select sum(BSEFO) from #temp1),0)    
set @nsefo = isnull((select sum(NSEFO) from #temp1),0)    
set @mcx = isnull((select sum(MCX) from #temp1),0)    
set @ncdx = isnull((select sum(NCDX) from #temp1),0)    
set @total = isnull((select sum(TOTAL) from #temp1),0)    
  
---------------------- Get BSE SEtt No.  
select dwn=datepart(dw,start_date),sett='D/'+convert(varchar(3),right(sett_no,3))+space(10)  
into #sett  
from risk.dbo.bse_sett_mst where sett_type='D'   
and start_date >= convert(varchar(11),getdate())  
and start_date <= convert(varchar(11),getdate()+6)  
  
---------------------- Get NSE SEtt No.  
update #sett set sett=ltrim(rtrim(#sett.sett))+' '+x.sett from  
(  
select dwn=datepart(dw,start_date),sett='N/'+convert(varchar(3),right(sett_no,3))  
from risk.dbo.nse_sett_mst where sett_type='N'   
and start_date >= convert(varchar(11),getdate())  
and start_date <= convert(varchar(11),getdate()+6)  
) x where #sett.dwn=x.dwn  
  
alter table #temp1 alter column dow varchar(30)  
update #temp1   set dow=ltrim(rtrim(dow))+' ['+b.sett+']' from #sett b where #temp1.dwn=b.dwn  
  
----------------------  
truncate table ff_week_values  
  
insert into ff_week_values   
select dow,nsefo,(bse+nse),dwn from #temp1 (nolock) where bse <> 0 or nse <>0 or bsefo <>0 or nsefo <>0 or mcx <>0 or ncdx<>0   
  
exec offline_payin_data @rdate  
-- select * from ff_week_values (nolock) order by dwn asc  
  
select * from  
(    
select dow,bse,bsefo,nse,nsefo,MCX,NCDX,total,dwn  
from #temp1      
where bse <> 0 or nse <>0 or bsefo <>0 or nsefo <>0 or mcx <>0 or ncdx<>0 --or dow='total'    
union ALL    
SELECT dow='Total(B)',    
bse=@bse,bsefo=@bsefo,nse=@nse,nsefo=@nsefo,mcx=@mcx,ncdex=@ncdx,total=@total,dwn=99  
) x  
order by   
(case when (dwn-datepart(dw,getdate())) < 0 then abs((datepart(dw,getdate())-dwn)-7)  
else (dwn-datepart(dw,getdate())) end  
 )   
    
/*      
drop table #pay_bse      
drop table #pay_nse      
drop table #pay_nsefo      
      
drop table #pay_MCX      
drop table #pay_NCDX      
      
  
update ff_payin_Details       
set ff_payin_Details.bse=0,      
ff_payin_Details.nse=0,      
ff_payin_Details.nsefo=0,      
ff_payin_Details.mcx=0,      
ff_payin_Details.ncdx=0      
      
      
select * from ff_payin_details      
update ff_bank_details      
set fundsBalance=0      
      
select distinct(b.dow),b.cltcode,amount1=(case when (b.segment='BSECM' and b.cltcode=a.cltcode) then b.amount else 0 end) from #pay_bse b,       
(select cltcode from ff_bank_details where segment='BSECM') a      
      
*/      
      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.QFR_Chart
-- --------------------------------------------------
CREATE proc QFR_Chart
as

declare @count as int    
set @count = (select count(*) from QFR_survey where report_date='1900-01-01 00:00:00.000')    

if @count<> 0
begin    
select 'Excellent' as Prod,  
Total = (((Select count(q1) from QFR_survey where q1='Excellent' and report_date='1900-01-01 00:00:00.000')  * 100 / @count ))    
union all 
select 'Very Good' as Prod,  
Total = (((Select count(q1) from QFR_survey where q1='Very Good' and report_date='1900-01-01 00:00:00.000')  * 100 / @count ))    
union all 
select 'Good' as Prod,  
Total = (((Select count(q1) from QFR_survey where q1='Good' and report_date='1900-01-01 00:00:00.000')  * 100 / @count ))    
union all 
select 'Average' as Prod,  
Total = (((Select count(q1) from QFR_survey where q1='Average' and report_date='1900-01-01 00:00:00.000')  * 100 / @count ))    
union all 
select 'Bad' as Prod,  
Total = (((Select count(q1) from QFR_survey where q1='Bad' and report_date='1900-01-01 00:00:00.000')  * 100 / @count ))    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.QFR_ChartReport
-- --------------------------------------------------
CREATE proc QFR_ChartReport
(
@repDate varchar(15)
)  
as  
  
declare @count as int      
set @count = (select count(*) from QFR_survey where convert(varchar(11),report_date,103)=@repDate)      
  
if @count<> 0  
begin      
select 'Excellent' as Prod,    
Total = (((Select count(q1) from QFR_survey where q1='Excellent' and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))      
union all   
select 'Very Good' as Prod,    
Total = (((Select count(q1) from QFR_survey where q1='Very Good' and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))      
union all   
select 'Good' as Prod,    
Total = (((Select count(q1) from QFR_survey where q1='Good' and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))      
union all   
select 'Average' as Prod,    
Total = (((Select count(q1) from QFR_survey where q1='Average' and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))      
union all   
select 'Bad' as Prod,    
Total = (((Select count(q1) from QFR_survey where q1='Bad' and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))      
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
-- PROCEDURE dbo.save_ABC_details
-- --------------------------------------------------


CREATE proc [dbo].[save_ABC_details]  
(  
@rdate datetime,  
@type varchar(30),  
@flag integer,  
@bc numeric(25,2),  
@bg numeric(25,2),  
@fd numeric(25,2),  
@shares numeric(25,2),  
@cash numeric(25,2)  
)  
as  
declare @cnt as integer  
if @flag=1 ------------------------DEPOSIT DETAILS----------------------------------  
begin  
  
   
 set @cnt = (select count(rdate) from ff_ABCDeposit_details  
  where rdate = @rdate+' 00:00:00.000' and type = @type)  
 print @cnt  
  
 if @cnt > 0   
 begin  
  update ff_ABCDeposit_details set  
  type=@type, bc=@bc, bg=@bg, fd=@fd, shares=@shares, cash=@cash  
  where rdate = @rdate+' 00:00:00.000' and type = @type   
 end   
 if @cnt <= 0  
 begin  
  insert into ff_ABCDeposit_details values  
  (@rdate,@type,@bc,@bg,@fd,@shares,@cash)  
 end  
end  
else  ------------------------UTILIZED DETAILS----------------------------------  
begin  
 declare @IMVAR as numeric(25,2)  
 declare @MTOM as numeric(25,2)  
  
 set @IMVAR = @BC  ------------------------- IMVAR is mapped to @BC and MTOM is mapped to @BG  
 set @MTOM = @BG   ------------------------- IMVAR is mapped to @BC and MTOM is mapped to @BG  
 set @cnt = (select count(rdate) from ff_ABCUtilized_Details  
  where rdate = @rdate+' 00:00:00.000' and type = @type)  
 print @cnt  
  
 if @cnt > 0   
 begin  
  update ff_ABCUtilized_Details set  
  type=@type, IMVAR=@IMVAR, MTOM=@MTOM  
  where rdate = @rdate+' 00:00:00.000' and type = @type   
 end   
 if @cnt <= 0  
 begin  
  insert into ff_ABCUtilized_Details values  
  (@rdate,@type,@bc,@bg)  
 end  
   
  
end  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_abl_details
-- --------------------------------------------------
 
CREATE proc [dbo].[save_abl_details]        
(       
@rdate datetime,    
@type varchar(20),  
@type1 varchar(20),  
@val numeric(25,2),  
@val1 numeric(25,2),
@opt numeric    
)    
as    
    
declare @cnt integer    
set @cnt=(select count(TYPE) from ff_other_values  
 where datemodified=@rdate+' 00:00:00.000' and type=@type)    

if @cnt > 0    
begin    
		update ff_other_values set  value= @val  
		where datemodified=@rdate+' 00:00:00.000' and type=@type  
   
		if @opt=1 -- If inserting for ABL 
		begin
		update ff_other_values set value= @val1  
		where datemodified=@rdate+' 00:00:00.000' and type=@type1   
		end 
end   
else    
begin    
		insert into ff_other_values values (@type,@val,@rdate) 
		
		if @opt=1 -- If inserting for ABL
		begin   
		insert into ff_other_values values  (@type1,@val1,@rdate)    
		end
end    

 
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_chq_details
-- --------------------------------------------------

CREATE proc [dbo].[save_chq_details]        
(       
@rdate datetime,    
@type varchar(20),    
@NCDEX numeric(20,2),    
@MCX numeric(20,2),    
@ASLFO numeric(20,2),    
@BSE numeric(20,2),    
@NSE numeric(20,2),    
@NSEFO numeric(20,2)    
)    
as    
/*declare @rdate as datetime    
set @rdate = '2007-11-29 00:00:00.000'*/    
    
declare @cnt integer    
set @cnt=(select count(TYPE) from  ff_acc_details    
 where rdate=@rdate+' 00:00:00.000' and type=@type)    
if @cnt > 0    
 begin    
 update  ff_acc_details set    
  NCDEX=@NCDEX,    
  MCX=@MCX,    
  ASLFO=@ASLFO,    
  BSE=@BSE,    
  NSE=@NSE,    
  NSEFO=@NSEFO    
 where rdate=@rdate+' 00:00:00.000' and type=@type    
 end    
else    
 begin    
 insert into  ff_acc_details values    
  (@rdate,@type,@NCDEX,@MCX,@ASLFO,@BSE,@NSE,@NSEFO)    
 end    
    
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_mcx_details
-- --------------------------------------------------

CREATE proc [dbo].[save_mcx_details]      
(     
@rdate datetime,  
@type varchar(20),
@type1 varchar(20),
@type2 varchar(20),
@val2 numeric(25,2),
@val numeric(25,2),
@val1 numeric(25,2)  
)  
as  
  
declare @cnt integer  
set @cnt=(select count(TYPE) from  ff_other_values
 where datemodified=@rdate+' 00:00:00.000' and type=@type)  
if @cnt > 0  
 begin  
 update  ff_other_values set  
  value= @val  where datemodified=@rdate+' 00:00:00.000' and type=@type
 
update  ff_other_values set  
  value= @val1  where datemodified=@rdate+' 00:00:00.000' and type=@type1 
update  ff_other_values set  
  value= @val2  where datemodified=@rdate+' 00:00:00.000' and type=@type2 

 end  
else  
 begin  
 insert into  ff_other_values values  
  (@type,@val,@rdate)  
insert into  ff_other_values values  
  (@type1,@val1,@rdate)  
insert into  ff_other_values values  
  (@type2,@val2,@rdate)  

 end  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_ncdex_details
-- --------------------------------------------------

CREATE proc [dbo].[save_ncdex_details]      
(     
@rdate datetime,  
@type varchar(20),
@type1 varchar(20),
@type2 varchar(20),
@type3 varchar(20),
@type4 varchar(20),
@type5 varchar(20),
@type6 varchar(20),
@type7 varchar(20),
@type8 varchar(20),
@val numeric(25,2),
@val1 numeric(25,2),
@val2 numeric(25,2),
@val3 numeric(25,2),
@val4 numeric(25,2),
@val5 numeric(25,2),  
@val6 numeric(25,2),
@val7 numeric(25,2),
@val8 numeric(25,2) 
)  
as  
  
declare @cnt integer  
set @cnt=(select count(TYPE) from  ff_other_values
 where datemodified=@rdate+' 00:00:00.000' and type=@type)  
if @cnt > 0  
 begin  
 update  ff_other_values set  
  value= @val
 where datemodified=@rdate+' 00:00:00.000' and type=@type
 
update  ff_other_values set  
  value= @val1
 where datemodified=@rdate+' 00:00:00.000' and type=@type1
 
update  ff_other_values set  
  value= @val2
 where datemodified=@rdate+' 00:00:00.000' and type=@type2
 
update  ff_other_values set  
  value= @val3
 where datemodified=@rdate+' 00:00:00.000' and type=@type3
 
update  ff_other_values set  
  value= @val4
 where datemodified=@rdate+' 00:00:00.000' and type=@type4
 
update  ff_other_values set  
  value= @val5
 where datemodified=@rdate+' 00:00:00.000' and type=@type5

update  ff_other_values set  
  value= @val6
 where datemodified=@rdate+' 00:00:00.000' and type=@type6

update  ff_other_values set  
  value= @val7
 where datemodified=@rdate+' 00:00:00.000' and type=@type7

update  ff_other_values set  
  value= @val8
 where datemodified=@rdate+' 00:00:00.000' and type=@type8
 
end  
else  
 begin  
 insert into  ff_other_values values  
  (@type,@val,@rdate)  
insert into  ff_other_values values  
  (@type1,@val1,@rdate)  
insert into  ff_other_values values  
  (@type2,@val2,@rdate)  

insert into  ff_other_values values  
  (@type3,@val3,@rdate)  

insert into  ff_other_values values  
  (@type4,@val4,@rdate)  

insert into  ff_other_values values  
  (@type5,@val5,@rdate)  

insert into  ff_other_values values  
  (@type6,@val6,@rdate)  

insert into  ff_other_values values  
  (@type7,@val7,@rdate)  

insert into  ff_other_values values  
  (@type8,@val8,@rdate)  

 end  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_nsefo_details
-- --------------------------------------------------

CREATE proc [dbo].[save_nsefo_details]      
(     
@rdate datetime,  
@type varchar(20),
@type1 varchar(20),
@type2 varchar(20),
@type3 varchar(20),
@type4 varchar(20),
@type5 varchar(20),
@type6 varchar(20),
@type7 varchar(20),
@type8 varchar(20),
@val numeric(25,2),
@val1 numeric(25,2),
@val2 numeric(25,2),
@val3 numeric(25,2),
@val4 numeric(25,2),
@val5 numeric(25,2),  
@val6 numeric(25,2),
@val7 numeric(25,2),
@val8 numeric(25,2) 
)  
as  
  
declare @cnt integer  
set @cnt=(select count(TYPE) from  ff_other_values
 where datemodified=@rdate+' 00:00:00.000' and type=@type)  
if @cnt > 0  
 begin  
 update  ff_other_values set  
  value= @val
 where datemodified=@rdate+' 00:00:00.000' and type=@type
 
update  ff_other_values set  
  value= @val1
 where datemodified=@rdate+' 00:00:00.000' and type=@type1
 
update  ff_other_values set  
  value= @val2
 where datemodified=@rdate+' 00:00:00.000' and type=@type2
 
update  ff_other_values set  
  value= @val3
 where datemodified=@rdate+' 00:00:00.000' and type=@type3
 
update  ff_other_values set  
  value= @val4
 where datemodified=@rdate+' 00:00:00.000' and type=@type4
 
update  ff_other_values set  
  value= @val5
 where datemodified=@rdate+' 00:00:00.000' and type=@type5

update  ff_other_values set  
  value= @val6
 where datemodified=@rdate+' 00:00:00.000' and type=@type6

update  ff_other_values set  
  value= @val7
 where datemodified=@rdate+' 00:00:00.000' and type=@type7

update  ff_other_values set  
  value= @val8
 where datemodified=@rdate+' 00:00:00.000' and type=@type8
 
end  
else  
 begin  
 insert into  ff_other_values values  
  (@type,@val,@rdate)  
insert into  ff_other_values values  
  (@type1,@val1,@rdate)  
insert into  ff_other_values values  
  (@type2,@val2,@rdate)  

insert into  ff_other_values values  
  (@type3,@val3,@rdate)  

insert into  ff_other_values values  
  (@type4,@val4,@rdate)  

insert into  ff_other_values values  
  (@type5,@val5,@rdate)  

insert into  ff_other_values values  
  (@type6,@val6,@rdate)  

insert into  ff_other_values values  
  (@type7,@val7,@rdate)  

insert into  ff_other_values values  
  (@type8,@val8,@rdate)  

 end  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_transactions_details
-- --------------------------------------------------

CREATE proc [dbo].[save_transactions_details]      
(      
@rdate datetime,      
@type varchar(20),      
@qty numeric(20,2),      
@flag numeric  
)      
as      
      
declare @cnt as integer      
      
if @flag=1 -------------- TRANSACTION DETAILS      
begin      
      
   set @cnt= (select count(rdate) from  ff_transactions_details      
    where rdate=@rdate+' 00:00:00.000' and type=@type)      
   if @cnt>0      
     begin      
      update  ff_transactions_details set      
       qty=@qty      
      where rdate=@rdate+' 00:00:00.000' AND type=@type      
     end      
   else      
     begin      
      insert into  ff_transactions_details      
      values(@rdate+' 00:00:00.000',@type,@qty)      
     end   
     
end      
      
if @flag=2  --------------------- TMMORROW's FUND DETAILS      
begin      
      
 set @cnt= (select count(rdate) from  ff_tmmrsfund_details      
 where rdate=@rdate+' 00:00:00.000' and type=@type)      
  if @cnt>0      
    begin      
     update  ff_tmmrsfund_details set      
      qty=@qty      
     where rdate=@rdate+' 00:00:00.000' AND type=@type      
    end      
  else      
    begin      
     insert into  ff_tmmrsfund_details      
     values(@rdate+' 00:00:00.000',@type,@qty)      
    end      
end      
      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_weekly_ff
-- --------------------------------------------------
CREATE proc save_weekly_ff
(
@dayOfWeek varchar(20),
@week numeric,
@savedate datetime,
@OD numeric(25,2),
@icici_citi numeric(25,2),
@bsense_payout numeric(25,2),
@nsefo_payout numeric(25,2),
@rel_bsense numeric(25,2),
@rel_nsefo numeric(25,2),
@rel_cx numeric(25,2),
@rel_buff numeric(25,2),
@col_icici_cl numeric(25,2),
@col_icici_ucl numeric(25,2),
@col_hdfc_cl numeric(25,2),
@col_hdfc_ucl numeric(25,2),
@bsense_payin numeric(25,2),
@nsefo_payin numeric(25,2),
@nsefo_epayin numeric(25,2),
@abc_bsense numeric(25,2),
@abc_nsefo numeric(25,2),
@cl_payout numeric(25,2)
)
as

declare @cnt integer  
set @cnt=(select count(dayofWeek) from  ff_weekvalues_entered
 where savedate=@savedate+' 00:00:00.000')
  
--select count(*) from ff_weekvalues_entered where savedate='2007-12-15 00:00:00.000'

if @cnt >= 8  
 begin  
 update  ff_weekvalues_entered set  
  dayofWeek=@dayOfWeek,week=@week,savedate=@savedate,od=@OD,icici_citi=@icici_citi,
bsense_payout=@bsense_payout,nsefo_payout=@nsefo_payout,rel_bsense=@rel_bsense,rel_nsefo=@rel_nsefo,
rel_cx=@rel_cx,rel_buff=@rel_buff,col_icici_cl=@col_icici_cl,col_icici_ucl=@col_icici_ucl,
col_hdfc_cl=@col_hdfc_cl,col_hdfc_ucl=@col_hdfc_ucl,bsense_payin=@bsense_payin,nsefo_payin=@nsefo_payin,
nsefo_epayin=@nsefo_epayin,abc_bsense=@abc_bsense,abc_nsefo=@abc_nsefo,cl_payout=@cl_payout
where savedate=@savedate+' 00:00:00.000' and dayofWeek=@dayOfWeek and week = @week
 end  
else  
 begin  
insert into ff_weekvalues_entered values(@dayOfWeek,@week,@savedate,@OD,@icici_citi,
@bsense_payout,@nsefo_payout,@rel_bsense,@rel_nsefo,@rel_cx,@rel_buff,@col_icici_cl,
@col_icici_ucl,@col_hdfc_cl,@col_hdfc_ucl,@bsense_payin,@nsefo_payin,@nsefo_epayin,
@abc_bsense,@abc_nsefo,@cl_payout)
 end  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_weekly_util
-- --------------------------------------------------
create proc [dbo].[save_weekly_util]
(
@savedate datetime,
@mtom numeric(25,2),
@pp numeric(25,2),
@u_abcnsefo numeric(25,2),
@u_abcbse numeric(25,2),
@u_abcnse numeric(25,2),
@u_ac_bank numeric(25,2),
@u_icici_ucl numeric(25,2),
@od numeric(25,2),
@cf_sday numeric(25,2),
@cf_icici numeric(25,2),
@ucl_icici numeric(25,2),
@epayout numeric(25,2),
@rel numeric(25,2),
@bsense_payin numeric(25,2),
@fo_payin numeric(25,2),
@abc_bse numeric(25,2),
@netdebit numeric(25,2)
)
as

declare @cnt integer  
set @cnt=(select count(savedate) from  ff_week_util
 where savedate=@savedate+' 00:00:00.000')
  
if @cnt >= 1  
 begin  
 update  ff_week_util set  
  mtom=@mtom,pp=@pp,u_abcnsefo=@u_abcnsefo,u_abcbse=@u_abcbse,u_abcnse=@u_abcnse,
u_ac_bank=@u_ac_bank,u_icici_ucl=@u_icici_ucl,od=@od,cf_sday=@cf_sday,
cf_icici=@cf_icici,ucl_icici=@ucl_icici,epayout=@epayout,rel=@rel,
bsense_payin=@bsense_payin,fo_payin=@fo_payin,abc_bse=@abc_bse,netdebit=@netdebit,
savedate=@savedate
where savedate=@savedate+' 00:00:00.000'
 end  
else  
 begin  
insert into ff_week_util values(@savedate,@mtom,@pp,@u_abcnsefo,@u_abcbse,
@u_abcnse,@u_ac_bank,@u_icici_ucl,@od,@cf_sday,@cf_icici,@ucl_icici,
@epayout,@rel,@bsense_payin,@fo_payin,@abc_bse,@netdebit)
 end  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sb_survey_report
-- --------------------------------------------------

  CREATE proc sb_survey_report     
(    
@branch as varchar(50), @strfdate as varchar(10), @strtdate as varchar(10)    
)    
as    
    
select * from sb_survey_q    
union all    
--select * from sb_survey    
    
select b.name,b.branch,b.sbtag,    
a.q1,a.q2,a.q3,a.q4,a.q5a,a.q5b,a.q6,a.q7a,a.q7b,    
a.q8a,a.q8b,a.q8c,a.q8d,a.q8e,a.q9a,a.q9b,    
a.q10a,a.q10b,a.q11,a.q12,a.q13a,a.q13b,    
a.q14a,a.q14b,a.q15,a.q16,a.q17,a.q18b,    
    
b.suggestion, b.email,b.email_status,b.mobileno,b.mobile_status,
b.offno,b.tel_status,b.address1,
b.action_taken,final_status,c.emp_name    
   from sb_survey_info b, sb_survey a, risk.dbo.emp_info c where a.survey_id = b.survey_id     
         and a.main_branch=@branch and b.date >=@strfdate and b.date <=@strtdate    
         and c.emp_no = b.username  and a.report_date='1900-01-01 00:00:00.000'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.summaryChart
-- --------------------------------------------------
CREATE proc [dbo].[summaryChart](@branch as varchar(50), @strfdate as varchar(10), @strtdate as varchar(10) )    
as    
    
declare @count as int    
set @count = (select count(*) from sb_survey_info where main_branch=@branch and report_date='1900-01-01 00:00:00.000' and (date>= @strfdate and date<= @strtdate))    
    
select 'Delighted' as Prod,Total = (((Select count(q18b) from sb_survey where q18b='V' and report_date='1900-01-01 00:00:00.000' and main_branch=@branch  and (date>= @strfdate and date<= @strtdate))  * 100 / @count ))    
union all select 'Satisfied'  as Prod,Total=(((Select count(q18b) from sb_survey where q18b='S' and report_date='1900-01-01 00:00:00.000' and main_branch=@branch  and (date>= @strfdate and date<= @strtdate))  * 100/ @count ))    
union all select 'Dissatisfied'  as Prod,Total=(((Select count(q18b) from sb_survey where q18b='D' and report_date='1900-01-01 00:00:00.000' and main_branch=@branch  and (date>= @strfdate and date<= @strtdate))  * 100/ @count ))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.summaryChart_client
-- --------------------------------------------------
CREATE proc summaryChart_client(@main_branch as varchar(50), @strfdate as varchar(10), @strtdate as varchar(10) )          
as 
         
/*DECLARE @main_branch varchar(50), @strfdate varchar(10), @strtdate varchar(10)

SET @main_branch='FORT'
SET  @strFdate='2008-06-01'
SET  @strtdate='2008-06-30'*/
declare @count as int          
--set @count = (select count(*) from client_survey_info 
--where main_branch=@main_branch and report_date='1900-01-01 00:00:00.000'
 --and (date>= @strfdate and date<= @strtdate))       
--PRINT @count
--IF @COUNT=0 
--BEGIN
set @count = (select count(*) from client_survey_info 
where main_branch=@main_branch 
 and (date>= @strfdate and date<= @strtdate)
and report_date=
(
select DISTINCT report_date from client_survey_info 
where main_branch=@main_branch 
 and (date>= @strfdate and date<= @strtdate)
))   
--PRINT @COUNT    
--END   
        
IF @COUNT<>0
BEGIN  
select 'Delighted' as Prod,Total = (((Select count(q27b) from client_survey where q27b='VS' and report_date=
(
select DISTINCT report_date from client_survey_info 
where main_branch=@main_branch 
 and (date>= @strfdate and date<= @strtdate)
)
and main_branch=@main_branch)  * 100 / @count ))  
        
union all 

select 'Satisfied'  as Prod,Total=(((Select count(q27b) from client_survey where q27b='S' and report_date=
(
select DISTINCT report_date from client_survey_info 
where main_branch=@main_branch 
 and (date>= @strfdate and date<= @strtdate)
)

 and main_branch=@main_branch)  * 100/ @count ))   
       
union all 

select 'Dissatisfied'  as Prod,Total=(((Select count(q27b) from client_survey where q27b='D' and report_date=
(
select DISTINCT report_date from client_survey_info 
where main_branch=@main_branch 
 and (date>= @strfdate and date<= @strtdate)
)
 and main_branch=@main_branch)  * 100/ @count ) )          

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.summaryChart_report
-- --------------------------------------------------
CREATE proc [dbo].[summaryChart_report](@branch as varchar(50), @repDate as varchar(10))  
as  
  
declare @count as int  
set @count = (select count(*) from sb_survey_info where main_branch=@branch and convert(varchar(11),report_date,103) = @repDate)  
  
select 'Delighted' as Prod,
Total = (((Select count(q18b) from sb_survey where q18b='V' and main_branch=@branch and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))  
union all select 'Satisfied'  as Prod,Total=(((Select count(q18b) from sb_survey where q18b='S' and main_branch=@branch and convert(varchar(11),report_date,103)=@repDate)  * 100/ @count ))  
union all select 'Dissatisfied'  as Prod,Total=(((Select count(q18b) from sb_survey where q18b='D' and main_branch=@branch and convert(varchar(11),report_date,103)=@repDate)  * 100/ @count ))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.summaryChartCli_report
-- --------------------------------------------------
CREATE proc [dbo].[summaryChartCli_report](@branch as varchar(50), @repDate as varchar(10))    
as    
    
declare @count as int    
set @count = (select count(*) from client_survey_info where main_branch=@branch and convert(varchar(11),report_date,103) = @repDate)    
    
select 'Delighted' as Prod,  
Total = (((Select count(q27b) from client_survey where q27b='VS' and main_branch=@branch and convert(varchar(11),report_date,103)=@repDate)  * 100 / @count ))    
union all select 'Satisfied'  as Prod,Total=(((Select count(q27b) from client_survey where q27b='S' and main_branch=@branch and convert(varchar(11),report_date,103)=@repDate)  * 100/ @count ))    
union all select 'Dissatisfied'  as Prod,Total=(((Select count(q27b) from client_survey where q27b='D' and main_branch=@branch and convert(varchar(11),report_date,103)=@repDate)  * 100/ @count ))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_client_survey
-- --------------------------------------------------

CREATE procedure [dbo].[usp_client_survey](@Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),                
@Q5 as varchar(05),@Q6 as varchar(05),@Q7 as varchar(05),@Q8 as varchar(05),@Q9 as varchar(05),@Q10 as varchar(05),                  
@Q11a as varchar(05),@Q11b as varchar(50),@Q12 as varchar(05),@Q13 as varchar(05),@Q14a as varchar(05),@Q14b as varchar(50),              
@Q15 as varchar(05),@Q16 as varchar(05),@Q17a as varchar(05),@Q17b as varchar(50),@Q18a as varchar(05),@Q18b as varchar(05),              
@Q18c as varchar(05),@Q18d as varchar(50),@Q19 as varchar(05),@Q20 as varchar(05),@Q21 as varchar(05),@Q22a as varchar(05),              
@Q22b as varchar(05),@Q23 as varchar(05),@Q24 as varchar(05),@Q25 as varchar(05),@Q26 as varchar(05),@Q27a as varchar(50),              
@Q27b as varchar(05),@username as varchar(50),@suggestion as varchar(5000),@name as varchar(50),@clientid as varchar(50),              
@branch as varchar(50),@sbtag as varchar(50),@email as varchar(50),@mobile as  varchar(50),@offno as  varchar(50),@mn_branch as varchar(50))            
as                  
/*                  
declare @Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),@Q5a as varchar(05)                  
,@Q5b as varchar(05),@Q6 as varchar(05),@Q7a as varchar(05),@Q7b as varchar(50),@Q8a as varchar(05)                  
,@Q8b as varchar(05),@Q8c as varchar(05),@Q8d as varchar(05),@Q8e as varchar(05),@Q9a as varchar(50)                  
,@Q9b as varchar(05),@Q10a as varchar(50),@Q10b as varchar(05),@Q11 as varchar(05),@Q12 as varchar(05)                  
,@Q13a as varchar(05),@Q13b as varchar(05),@Q14a as varchar(05),@Q14b as varchar(05),@Q14c as varchar(05)                  
,@Q15 as varchar(05),@Q16 as varchar(05),@Q17 as varchar(05),@Q18a as varchar(50),@Q18b as varchar(05),@username as varchar(50),@sbtag as varchar(15)                
set @Q1='a' ;                  
set @Q2='a' ;set @Q3='a' ;set @Q4='' ;set @Q5a=''                   
;set @Q5b='' ;set @Q6='' ;set @Q7a='a' ;set @Q7b='' ;set @Q8a='a'                  
;set @Q8b ='';set @Q8c='' ;set @Q8d='a' ;set @Q8e='' ;set @Q9a ='a'                  
;set @Q9b='' ;set @Q10a='' ;set @Q10b='a' ;set @Q11='';set @Q12='a'                   
;set @Q13a='' ;set @Q13b='' ;set @Q14a='' ;set @Q14b='' ;set @Q14c ='a'                  
;set @Q15='' ;set @Q16='' ;set @Q17='' ;set @Q18a='' ;set @Q18b='a' ;set @username='sukal';set @sbtag='acm'                  
 */                
begin tran         
  
declare @Survey_id as varchar(10)  
set @Survey_id = (select count(Survey_id) from client_survey (nolock)) + 1    
          
declare @str as  varchar(8000)                 
declare @str1 as  varchar(8000)                   
set @str='insert into client_survey values('''+@Q1+''','''+@Q2+''','''+@Q3+''','''+@Q4+''','''+@Q5+''','''+@Q6+''',                  
'''+@Q7+''','''+@Q8+''','''+@Q9+''','''+@Q10+''','''+@Q11a+''','''+@Q11b+''','''+@Q12+''','''+@Q13+''',                  
'''+@Q14a+''','''+@Q14b+''','''+@Q15+''','''+@Q16+''','''+@Q17a+''','''+@Q17b+''','''+@Q18a+''','''+@Q18b+''',                  
'''+@Q18c+''','''+@Q18d+''','''+@Q19+''','''+@Q20+''','''+@Q21+''','''+@Q22a+''','''+@Q22b+''','''+@Q23+''','''+@Q24+''',              
'''+@Q25+''','''+@Q26+''','''+@Q27a+''','''+@Q27b+''',convert(char(10),getdate(),101),'''+@username+''','''+@clientid+''','''+@sbtag+''','''+@Survey_id+''','''+@mn_branch+''','''')'             
--'''+@sur_id+''',               
--print @str                  
exec(@str)                  
                
                
/*declare @Q19 as varchar(2000),@Q20 as varchar(50),@Q21 as varchar(25),@Q22 as varchar(15),                
@Q23 as  varchar(50)                
declare @Q24 as numeric,@Q25 as  numeric                
declare @Q26 as datetime                
declare @str1 as varchar(1000)                
                
set @Q19='a' ;set @Q20='b' ;set @Q21='c' ;set @Q22='d' ;                
set @Q23='e' ;set @Q24=0 ;set @Q25=1 ;set @Q26='2007-01-18'                 
set @str1='insert into sb_survey_info values('''+@Q19+''','''+@Q20+''','''+@Q21+''','''+@Q22+''','''+@Q23+''','+convert(varchar(10),@Q24)+',                
'+convert(varchar(10),@Q25)+',convert(char(10),getdate(),101))'                
--print @str1                
exec(@str1)                
*/                
set @str1='insert into client_survey_info values('''+@suggestion+''','''+@name+''','''+@clientid+''','''+@branch+''',              
'''+@sbtag+''','''+@email+''','+@mobile+','+@offno+',convert(char(10),getdate(),101),'''+@username+''','''+@Survey_id+''','''+@mn_branch+''','''')'            
--'''+@sur_id+''',               
exec(@str1)                
          
begin            
if @@error = 0             
commit tran            
else            
rollback tran            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_client_survey_data
-- --------------------------------------------------
CREATE procedure [dbo].[usp_client_survey_data](@Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),      
@Q5 as varchar(05),@Q6 as varchar(05),@Q7 as varchar(05),@Q8 as varchar(05),@Q9 as varchar(05),@Q10 as varchar(05),        
@Q11a as varchar(05),@Q11b as varchar(50),@Q12 as varchar(05),@Q13 as varchar(05),@Q14a as varchar(05),@Q14b as varchar(50),    
@Q15 as varchar(05),@Q16 as varchar(05),@Q17a as varchar(05),@Q17b as varchar(50),@Q18a as varchar(05),@Q18b as varchar(05),    
@Q18c as varchar(05),@Q18d as varchar(50),@Q19 as varchar(05),@Q20 as varchar(05),@Q21 as varchar(05),@Q22a as varchar(05),    
@Q22b as varchar(05),@Q23 as varchar(05),@Q24 as varchar(05),@Q25 as varchar(05),@Q26 as varchar(05),@Q27a as varchar(50),    
@Q27b as varchar(05),@username as varchar(50),@suggestion as varchar(2000),@name as varchar(50),@clientid as varchar(50),    
@branch as varchar(50),@sbtag as varchar(50),@email as varchar(50),@mobile as numeric,@offno as numeric,@sur_id as varchar(50),@mn_branch as varchar(50))      
as        
  
update client_survey set  
Q1=@Q1,  
Q2=@Q2,  
Q3=@Q3,  
Q4=@Q4,  
Q5=@Q5,  
Q6=@Q6,  
Q7=@Q7,  
Q8=@Q8,  
Q9=@Q9,  
Q10=@Q10,  
Q11a=@Q11a,  
Q11b=@Q11b,  
Q12=@Q12,  
Q13=@Q13,  
Q14a=@Q14a,  
Q14b=@Q14b,  
Q15=@Q15,  
Q16=@Q16,  
Q17a=@Q17a,  
Q17b=@Q17b,  
Q18a=@Q18a,  
Q18b=@Q18b,  
Q18c=@Q18c,  
Q18d=@Q18d,  
Q19=@Q19,  
Q20=@Q20,  
Q21=@Q21,  
Q22a=@Q22a,  
Q22b=@Q22b,  
Q23=@Q23,  
Q24=@Q24,  
Q25=@Q25,  
Q26=@Q26,  
Q27a=@Q27a,  
Q27b=@Q27b,  
username=@username,  
clientid=@clientid,  
sbtag=@sbtag,  
main_branch=@mn_branch where survey_id=@sur_id 
and (date between (getdate() - 3) and (getdate() + 3))  
  
update client_survey_info set  
suggestion=@suggestion,  
name=@name,  
clientid=@clientid,  
branch=@branch,  
sbtag=@sbtag,  
email=@email,  
mobile=@mobile,  
offno=@offno,  
username=@username,  
main_branch=@mn_branch  
where survey_id=@sur_id  
and (date between (getdate() - 3) and (getdate() + 3))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_client_survey1
-- --------------------------------------------------
CREATE procedure [dbo].[usp_client_survey1]      
(@Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),                        
@Q5 as varchar(05),@Q6 as varchar(05),@Q7 as varchar(05),@Q8 as varchar(05),      
@Q9 as varchar(05),@Q10 as varchar(05),                          
@Q11a as varchar(05),@Q11b as varchar(50),@Q12 as varchar(05),@Q13 as varchar(05),      
@Q14a as varchar(05),@Q14b as varchar(50),                      
@Q15 as varchar(05),@Q16 as varchar(05),@Q17a as varchar(05),@Q17b as varchar(50),      
@Q18a as varchar(05),@Q18b as varchar(05),                      
@Q18c as varchar(05),@Q18d as varchar(50),@Q19 as varchar(05),@Q20 as varchar(05),      
@Q21 as varchar(05),@Q22a as varchar(05),                      
@Q22b as varchar(05),@Q23 as varchar(05),@Q24 as varchar(05),@Q25 as varchar(05),      
@Q26 as varchar(05),@Q27a as varchar(50),                      
@Q27b as varchar(05),@username as varchar(50),@suggestion as varchar(5000),@name as varchar(50),      
@clientid as varchar(50),                      
@branch as varchar(50),@sbtag as varchar(50),@email as varchar(50),@mobile as  varchar(50),      
@offno as  varchar(50),@mn_branch as varchar(50),
---created on 25-06-2008
@emailstatus as varchar(100),@telstatus as varchar(50),@mobstatus as varchar(50),@address1 as  varchar(500),      
@actaken as  varchar(50),@ddlfinalstatus as varchar(50)
)                    
as                          
/*                          
declare @Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),@Q5a as varchar(05)                          
,@Q5b as varchar(05),@Q6 as varchar(05),@Q7a as varchar(05),@Q7b as varchar(50),@Q8a as varchar(05)                          
,@Q8b as varchar(05),@Q8c as varchar(05),@Q8d as varchar(05),@Q8e as varchar(05),@Q9a as varchar(50)                          
,@Q9b as varchar(05),@Q10a as varchar(50),@Q10b as varchar(05),@Q11 as varchar(05),@Q12 as varchar(05)                          
,@Q13a as varchar(05),@Q13b as varchar(05),@Q14a as varchar(05),@Q14b as varchar(05),@Q14c as varchar(05)                          
,@Q15 as varchar(05),@Q16 as varchar(05),@Q17 as varchar(05),@Q18a as varchar(50),@Q18b as varchar(05),@username as varchar(50),@sbtag as varchar(15)                        
set @Q1='a' ;                          
set @Q2='a' ;set @Q3='a' ;set @Q4='' ;set @Q5a=''                           
;set @Q5b='' ;set @Q6='' ;set @Q7a='a' ;set @Q7b='' ;set @Q8a='a'                          
;set @Q8b ='';set @Q8c='' ;set @Q8d='a' ;set @Q8e='' ;set @Q9a ='a'                          
;set @Q9b='' ;set @Q10a='' ;set @Q10b='a' ;set @Q11='';set @Q12='a'                           
;set @Q13a='' ;set @Q13b='' ;set @Q14a='' ;set @Q14b='' ;set @Q14c ='a'                          
;set @Q15='' ;set @Q16='' ;set @Q17='' ;set @Q18a='' ;set @Q18b='a' ;set @username='sukal';set @sbtag='acm'                          
 */                        
begin tran                 
          
declare @Survey_id as varchar(10)          
--set @Survey_id = (select count(Survey_id) from client_survey (nolock)) + 1            
set @Survey_id = (select max(convert(numeric,Survey_id)) from client_survey (nolock)) + 1  
   --print @Survey_id          
declare @str as  varchar(8000)                         
declare @str1 as  varchar(8000)                           
set @str='insert into client_survey values('''+@Q1+''','''+@Q2+''','''+@Q3+''','''+@Q4+''','''+@Q5+''','''+@Q6+''',                          
'''+@Q7+''','''+@Q8+''','''+@Q9+''','''+@Q10+''','''+@Q11a+''','''+@Q11b+''','''+@Q12+''','''+@Q13+''',                          
'''+@Q14a+''','''+@Q14b+''','''+@Q15+''','''+@Q16+''','''+@Q17a+''','''+@Q17b+''','''+@Q18a+''','''+@Q18b+''',                          
'''+@Q18c+''','''+@Q18d+''','''+@Q19+''','''+@Q20+''','''+@Q21+''','''+@Q22a+''','''+@Q22b+''','''+@Q23+''',      
'''+@Q24+''',                      
'''+@Q25+''','''+@Q26+''','''+@Q27a+''','''+@Q27b+''',      
convert(char(10),getdate(),101),      
'''+@username+''','''+@clientid+''','''+@sbtag+''','+@Survey_id+','''+@mn_branch+''','''')'                     
--'''+@sur_id+''',                       
print @str                          
exec(@str)                 
                        
                        
/*declare @Q19 as varchar(2000),@Q20 as varchar(50),@Q21 as varchar(25),@Q22 as varchar(15),                        
@Q23 as  varchar(50)             
declare @Q24 as numeric,@Q25 as  numeric                        
declare @Q26 as datetime           
declare @str1 as varchar(1000)                        
                        
set @Q19='a' ;set @Q20='b' ;set @Q21='c' ;set @Q22='d' ;                        
set @Q23='e' ;set @Q24=0 ;set @Q25=1 ;set @Q26='2007-01-18'                         
set @str1='insert into sb_survey_info values('''+@Q19+''','''+@Q20+''','''+@Q21+''','''+@Q22+''','''+@Q23+''','+convert(varchar(10),@Q24)+',                        
'+convert(varchar(10),@Q25)+',convert(char(10),getdate(),101))'                        
--print @str1                        
exec(@str1)                        
*/        
        
if(@mobile='' or @mobile='NA')        
begin        
set @mobile = '0'        
end        
        
if(@offno='' or @offno='NA')        
begin        
set @offno = '0'        
end        
--                        
set @str1='insert into client_survey_info values('''+@suggestion+''','''+@name+''','''+@clientid+''','''+@branch+''',                      
'''+@sbtag+''','''+@email+''','+@mobile+','+@offno+',convert(char(10),getdate(),101),'''+@username+''','+@Survey_id+','''+@mn_branch+''','''',
'''+@emailstatus+''','''+@telstatus+''','''+@mobstatus+''','''+@address1+''','''+@actaken+''','''+@ddlfinalstatus+''')'                    
--'''+@sur_id+''',                       
print @str1        
exec(@str1)                        
               
        
begin                    
if @@error = 0                     
commit tran                    
else                    
rollback tran                    
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
-- PROCEDURE dbo.usp_result_sb_survey
-- --------------------------------------------------
 
CREATE procedure [dbo].[usp_result_sb_survey](@intro as varchar(max),@sbtag as varchar(max),@r1a1 as varchar(max),
@r1a2 as varchar(max),@r2a1 as varchar(max),@r2a2 as varchar(max),@r2b1 as varchar(max),@r2b2 as varchar(max),
@r3a1 as varchar(max),@r3a2 as varchar(max),@r4a1 as varchar(max),@r4a2 as varchar(max),@r5a1 as varchar(max),
@r5a2 as varchar(max),@r6a1 as varchar(max),@r6a2 as varchar(max),@r7a1 as varchar(max),@r7a2 as varchar(max),
@r8a1 as varchar(max),@r8a2 as varchar(max),@r9a1 as varchar(max),@r9a2 as varchar(max),@r10a1 as varchar(max),
@r10a2 as varchar(max),@r11a1 as varchar(max),@r11a2 as varchar(max),@r12a1 as varchar(max),@r12a2 as varchar(max),
@r12b1 as varchar(max),@r12b2 as varchar(max),@r13a1 as varchar(max),@r13a2 as varchar(max),@r13b1 as varchar(max),
@r13b2 as varchar(max),@r14a1 as varchar(max),@r14a2 as varchar(max),@r15a1 as varchar(max),@r15a2 as varchar(max),
@date as datetime,@username as varchar(15))  
as    

declare @str as varchar(5000)   

set @str='insert into result_sb_survey values('''+@intro+''','''+@sbtag+''','''+@r1a1+''','''+@r1a2+''','''+@r2a1+''','''+@r2a2+''',    
'''+@r2b1+''','''+@r2b2+''','''+@r3a1+''','''+@r3a2+''','''+@r4a1+''','''+@r4a2+''','''+@r5a1+''','''+@r5a2+''',    
'''+@r6a1+''','''+@r6a2+''','''+@r7a1+''','''+@r7a2+''','''+@r8a1+''','''+@r8a2+''','''+@r9a1+''','''+@r9a2+''',    
'''+@r10a1+''','''+@r10a2+''','''+@r11a1+''','''+@r11a2+''','''+@r12a1+''','''+@r12a2+''','''+@r12b1+''','''+@r12b2+''',  
'''+@r13a1+''','''+@r13a2+''','''+@r13b1+''','''+@r13b2+''','''+@r14a1+''','''+@r14a2+''','''+@r15a1+''','''+@r15a2+''',
convert(char(10),getdate(),101),'''+@username+''') '   
--print @str    
exec(@str)     
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sb_survey
-- --------------------------------------------------
CREATE procedure [dbo].[usp_sb_survey]
(@Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),                              
@Q5a as varchar(05),@Q5b as varchar(05),@Q6 as varchar(05),@Q7a as varchar(05),
@Q7b as varchar(50),@Q8a as varchar(05)                                
,@Q8b as varchar(05),@Q8c as varchar(05),@Q8d as varchar(05),@Q8e as varchar(05),
@Q9a as varchar(50)                                
,@Q9b as varchar(05),@Q10a as varchar(50),@Q10b as varchar(05),@Q11 as varchar(05),
@Q12 as varchar(05)                                
,@Q13a as varchar(05),@Q13b as varchar(05),@Q14a as varchar(05),@Q14b as varchar(05),
@Q14c as varchar(05)                                
,@Q15 as varchar(05),@Q16 as varchar(05),@Q17 as varchar(05),@Q18a as varchar(50),
@Q18b as varchar(05),                              
@Q19 as varchar(2000),@Q20 as varchar(50),@Q21 as varchar(25),@Q22 as varchar(15),@Q23 as varchar(50),                
@Q24 as varchar(20),@Q25 as varchar(20),@username as varchar(50),@sbtag as varchar(15),                
@ClientId as varchar(50),@mn_branch as varchar(50),  
@emailstatus as varchar(70),@telstatus as varchar(70),  
@mobstatus as varchar(70),@address1 as varchar(500),  
@actaken as varchar(100),@ddlfinalstatus as varchar(10)  
 )                              
--@sur_id as varchar(50),                     
as                                
/*                                
declare @Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),@Q5a as varchar(05)                                
,@Q5b as varchar(05),@Q6 as varchar(05),@Q7a as varchar(05),@Q7b as varchar(50),@Q8a as varchar(05)                                
,@Q8b as varchar(05),@Q8c as varchar(05),@Q8d as varchar(05),@Q8e as varchar(05),@Q9a as varchar(50)                                
,@Q9b as varchar(05),@Q10a as varchar(50),@Q10b as varchar(05),@Q11 as varchar(05),@Q12 as varchar(05)                                
,@Q13a as varchar(05),@Q13b as varchar(05),@Q14a as varchar(05),@Q14b as varchar(05),@Q14c as varchar(05)                                
,@Q15 as varchar(05),@Q16 as varchar(05),@Q17 as varchar(05),@Q18a as varchar(50),@Q18b as varchar(05),@username as varchar(50),@sbtag as varchar(15)                              
set @Q1='a' ;                                
set @Q2='a' ;set @Q3='a' ;set @Q4='' ;set @Q5a=''                                 
;set @Q5b='' ;set @Q6='' ;set @Q7a='a' ;set @Q7b='' ;set @Q8a='a'                                
;set @Q8b ='';set @Q8c='' ;set @Q8d='a' ;set @Q8e='' ;set @Q9a ='a'                                
;set @Q9b='' ;set @Q10a='' ;set @Q10b='a' ;set @Q11='';set @Q12='a'                                 
;set @Q13a='' ;set @Q13b='' ;set @Q14a='' ;set @Q14b='' ;set @Q14c ='a'                                
;set @Q15='' ;set @Q16='' ;set @Q17='' ;set @Q18a='' ;set @Q18b='a' ;set @username='sukal';set @sbtag='acm'                                
 */                              
begin tran                          
                          
declare @str as varchar(8000)                               
declare @str1 as varchar(8000)                             
declare @sur_id as varchar(10)                  
                  
--set @sur_id= (select max(survey_id) from sb_survey (nolock) group by survey_id) + 1         
 set @sur_id = (select max(convert(numeric,survey_id)) from sb_survey (nolock)) + 1    
    
--print @sur_id    
                          
                              
set @str='insert into sb_survey  values('''+@Q1+''','''+@Q2+''','''+@Q3+''','''+@Q4+''','''+@Q5a+''','''+@Q5b+''',                                
'''+@Q6+''','''+@Q7a+''','''+@Q7b+''','''+@Q8a+''','''+@Q8b+''','''+@Q8c+''','''+@Q8d+''','''+@Q8e+''',                                
'''+@Q9a+''','''+@Q9b+''','''+@Q10a+''','''+@Q10b+''','''+@Q11+''','''+@Q12+''','''+@Q13a+''','''+@Q13b+''',                                
'''+@Q14a+''','''+@Q14b+''','''+@Q14c+''','''+@Q15+''','''+@Q16+''','''+@Q17+''','''+@Q18a+''','''+@Q18b+''',                              
convert(varchar(10),getdate(),101),'''+@username+''','''+@sbtag+''','''+@sur_id+''','''+@mn_branch+''','''+@ClientId+''','''')'                                
--'''+@sur_id+''',                              
print @str                       
exec(@str)                                
                              
if(@Q24=''or @Q24='NA' )                  
begin                  
set @Q24 = '0'                  
end                  
                  
if(@Q25=''or @Q25='NA' )                  
begin                  
set @Q25 = '0'                  
end                  
                  
set @str1='insert into sb_survey_info  values('''+@Q19+''','''+@Q20+''','''+@Q21+''','''+@Q22+''','''+@Q23+''','+@Q24+',                          
'+@Q25+',convert(varchar(10),getdate(),101),'''+@username+''','''+@sur_id+''','''+@mn_branch+''','''+@ClientId+''','''',  
'''+@emailstatus+''','''+@telstatus+''','''+@mobstatus+''','''+@address1+''','''+@actaken+''','''+@ddlfinalstatus+''')'                                
--'''+@sur_id+''',                              
print @str1                  
exec(@str1)                              
--return                           
      --select top 1 * from sb_survey_info                  
begin                        
if @@error = 0                        
commit tran                        
else                        
rollback tran                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sb_survey_edit
-- --------------------------------------------------
CREATE procedure [dbo].[usp_sb_survey_edit](@Q1 as varchar(05),@Q2 as varchar(05),@Q3 as varchar(05),@Q4 as varchar(05),      
@Q5a as varchar(05),@Q5b as varchar(05),@Q6 as varchar(05),@Q7a as varchar(05),@Q7b as varchar(50),@Q8a as varchar(05)        
,@Q8b as varchar(05),@Q8c as varchar(05),@Q8d as varchar(05),@Q8e as varchar(05),@Q9a as varchar(50)        
,@Q9b as varchar(05),@Q10a as varchar(50),@Q10b as varchar(05),@Q11 as varchar(05),@Q12 as varchar(05)        
,@Q13a as varchar(05),@Q13b as varchar(05),@Q14a as varchar(05),@Q14b as varchar(05),@Q14c as varchar(05)        
,@Q15 as varchar(05),@Q16 as varchar(05),@Q17 as varchar(05),@Q18a as varchar(50),@Q18b as varchar(05),      
@username as varchar(50),@sbtag as varchar(15),@Q19 as varchar(2000),@Q20 as varchar(50),@Q21 as varchar(25)      
,@Q23 as varchar(50),@Q24 as varchar(10),@Q25 as varchar(10),@mn_branch as varchar(50),@ClientId as varchar(50),@sur_id as varchar(50) )      
      
as        
    
update sb_survey set     
Q1=@Q1,    
Q2=@Q2,    
Q3=@Q3,    
Q4=@Q4,    
Q5a=@Q5a,    
Q5b=@Q5b,    
Q6=@Q6,    
Q7a=@Q7a,    
Q7b=@Q7b,    
Q8a=@Q8a,    
Q8b=@Q8b,    
Q8c=@Q8c,    
Q8d=@Q8d,    
Q8e=@Q8e,    
Q9a=@Q9a,    
Q9b=@Q9b,    
Q10a=@Q10a,    
Q10b=@Q10b,    
Q11=@Q11,    
Q12=@Q12,    
Q13a=@Q13a,    
Q13b=@Q13b,    
Q14a=@Q14a,    
Q14b=@Q14b,    
Q14c=@Q14c,    
Q15=@Q15,    
Q16=@Q16,    
Q17=@Q17,    
Q18a=@Q18a,    
Q18b=@Q18b,    
username=@username,    
sbtag=@sbtag,    
main_branch=@mn_branch,    
clientid=@clientid    
where survey_id=@sur_id   
and (date between (getdate() - 3) and (getdate() + 3))     
    
update sb_survey_info set     
suggestion=@Q19,    
name=@Q20,    
branch=@Q21,    
sbtag=@sbtag,    
email=@Q23,    
mobileno=@Q24,    
offno=@Q25,    
username=@username,    
main_branch=@mn_branch,    
clientid=@clientid    
where survey_id=@sur_id  
and (date between (getdate() - 3) and (getdate() + 3))

GO

-- --------------------------------------------------
-- TABLE dbo.acdlledger
-- --------------------------------------------------
CREATE TABLE [dbo].[acdlledger]
(
    [family] VARCHAR(10) NULL,
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [acname] VARCHAR(100) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NULL,
    [balamt] MONEY NULL,
    [cltcode] VARCHAR(10) NULL,
    [narration] VARCHAR(234) NULL,
    [damt] MONEY NULL,
    [camt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cli_survey_q
-- --------------------------------------------------
CREATE TABLE [dbo].[cli_survey_q]
(
    [name] NCHAR(10) NULL,
    [Branch] NCHAR(10) NULL,
    [SBTag] NCHAR(10) NULL,
    [clientTag] NCHAR(10) NULL,
    [q1] VARCHAR(300) NULL,
    [q2] VARCHAR(300) NULL,
    [q3] VARCHAR(300) NULL,
    [q4] VARCHAR(300) NULL,
    [q5] VARCHAR(300) NULL,
    [q6] VARCHAR(300) NULL,
    [q7] VARCHAR(300) NULL,
    [q8] VARCHAR(300) NULL,
    [q9] VARCHAR(300) NULL,
    [q10] VARCHAR(300) NULL,
    [q11] VARCHAR(300) NULL,
    [q12] VARCHAR(300) NULL,
    [q13] VARCHAR(300) NULL,
    [q14] VARCHAR(300) NULL,
    [q15] VARCHAR(300) NULL,
    [q16] VARCHAR(300) NULL,
    [q17] VARCHAR(300) NULL,
    [q18] VARCHAR(300) NULL,
    [q19] VARCHAR(300) NULL,
    [q20] VARCHAR(300) NULL,
    [q21] VARCHAR(300) NULL,
    [q22] VARCHAR(300) NULL,
    [q23] VARCHAR(300) NULL,
    [q24] VARCHAR(300) NULL,
    [q25] VARCHAR(300) NULL,
    [q26] VARCHAR(300) NULL,
    [q27] VARCHAR(300) NULL,
    [q28] VARCHAR(300) NULL,
    [q29] VARCHAR(300) NULL,
    [q30] VARCHAR(300) NULL,
    [q31] VARCHAR(300) NULL,
    [remark] VARCHAR(300) NULL,
    [email] VARCHAR(300) NULL,
    [email_status] VARCHAR(300) NULL,
    [mobile] VARCHAR(300) NULL,
    [mobile_status] VARCHAR(300) NULL,
    [office_tele] VARCHAR(300) NULL,
    [off_tel_stat] VARCHAR(300) NULL,
    [Action_taken] VARCHAR(300) NULL,
    [status] VARCHAR(300) NULL,
    [Address] VARCHAR(300) NULL,
    [Person_name] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIDETAILS]
(
    [SAUDA_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [FAMILYCODE] VARCHAR(10) NULL,
    [FAMILYNAME] VARCHAR(30) NULL,
    [BROKERAGE] FLOAT NULL,
    [DUMMY1] VARCHAR(5) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL,
    [fromdt] DATETIME NULL,
    [todate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIDETAILSBSE
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIDETAILSBSE]
(
    [SAUDA_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [FAMILYCODE] VARCHAR(10) NULL,
    [FAMILYNAME] VARCHAR(30) NULL,
    [BROKERAGE] FLOAT NULL,
    [DUMMY1] VARCHAR(5) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL,
    [fromdt] DATETIME NULL,
    [todate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIDETAILSFO
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIDETAILSFO]
(
    [SAUDA_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [FAMILYCODE] VARCHAR(10) NULL,
    [FAMILYNAME] VARCHAR(30) NULL,
    [BROKERAGE] FLOAT NULL,
    [DUMMY1] VARCHAR(5) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL,
    [fromdt] DATETIME NULL,
    [todate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_report_data
-- --------------------------------------------------
CREATE TABLE [dbo].[client_report_data]
(
    [main_branch] VARCHAR(50) NULL,
    [date] DATETIME NULL,
    [userno] VARCHAR(20) NULL,
    [summary] VARCHAR(MAX) NULL,
    [branch_data] VARCHAR(500) NULL,
    [at_q1] VARCHAR(5000) NULL,
    [sa_q1] VARCHAR(5000) NULL,
    [at_q2] VARCHAR(5000) NULL,
    [sa_q2] VARCHAR(5000) NULL,
    [at_q3a] VARCHAR(5000) NULL,
    [sa_q3a] VARCHAR(5000) NULL,
    [at_q3b] VARCHAR(5000) NULL,
    [sa_q3b] VARCHAR(5000) NULL,
    [at_q4] VARCHAR(5000) NULL,
    [sa_q4] VARCHAR(5000) NULL,
    [at_q5] VARCHAR(5000) NULL,
    [sa_q5] VARCHAR(5000) NULL,
    [at_q6] VARCHAR(5000) NULL,
    [sa_q6] VARCHAR(5000) NULL,
    [at_q7a] VARCHAR(5000) NULL,
    [sa_q7a] VARCHAR(5000) NULL,
    [at_q7b] VARCHAR(5000) NULL,
    [sa_q7b] VARCHAR(5000) NULL,
    [at_q8] VARCHAR(5000) NULL,
    [sa_q8] VARCHAR(5000) NULL,
    [at_q9] VARCHAR(5000) NULL,
    [sa_q9] VARCHAR(5000) NULL,
    [at_q10] VARCHAR(5000) NULL,
    [sa_q10] VARCHAR(5000) NULL,
    [at_q11] VARCHAR(5000) NULL,
    [sa_q11] VARCHAR(5000) NULL,
    [at_q12] VARCHAR(5000) NULL,
    [sa_q12] VARCHAR(5000) NULL,
    [at_q13a] VARCHAR(5000) NULL,
    [sa_q13a] VARCHAR(5000) NULL,
    [at_q13b] VARCHAR(5000) NULL,
    [sa_q13b] VARCHAR(5000) NULL,
    [at_q14a] VARCHAR(5000) NULL,
    [sa_q14a] VARCHAR(5000) NULL,
    [at_q14b] VARCHAR(5000) NULL,
    [sa_q14b] VARCHAR(5000) NULL,
    [at_q15] VARCHAR(5000) NULL,
    [sa_q15] VARCHAR(5000) NULL,
    [at_q16] VARCHAR(5000) NULL,
    [sa_q16] VARCHAR(5000) NULL,
    [at_q17] VARCHAR(5000) NULL,
    [sa_q17] VARCHAR(5000) NULL,
    [Highlights_client] VARCHAR(5000) NULL,
    [Sugg_client] VARCHAR(5000) NULL,
    [conducted_by] VARCHAR(80) NULL,
    [reviewed_by] VARCHAR(80) NULL,
    [approved_by] VARCHAR(80) NULL,
    [released_date] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_survey
-- --------------------------------------------------
CREATE TABLE [dbo].[client_survey]
(
    [Q1] VARCHAR(5) NULL,
    [Q2] VARCHAR(5) NULL,
    [Q3] VARCHAR(5) NULL,
    [Q4] VARCHAR(5) NULL,
    [Q5] VARCHAR(5) NULL,
    [Q6] VARCHAR(5) NULL,
    [Q7] VARCHAR(5) NULL,
    [Q8] VARCHAR(50) NULL,
    [Q9] VARCHAR(5) NULL,
    [Q10] VARCHAR(5) NULL,
    [Q11a] VARCHAR(5) NULL,
    [Q11b] VARCHAR(50) NULL,
    [Q12] VARCHAR(50) NULL,
    [Q13] VARCHAR(5) NULL,
    [Q14a] VARCHAR(5) NULL,
    [Q14b] VARCHAR(50) NULL,
    [Q15] VARCHAR(5) NULL,
    [Q16] VARCHAR(5) NULL,
    [Q17a] VARCHAR(5) NULL,
    [Q17b] VARCHAR(50) NULL,
    [Q18a] VARCHAR(5) NULL,
    [Q18b] VARCHAR(5) NULL,
    [Q18c] VARCHAR(5) NULL,
    [Q18d] VARCHAR(5) NULL,
    [Q19] VARCHAR(5) NULL,
    [Q20] VARCHAR(5) NULL,
    [Q21] VARCHAR(5) NULL,
    [Q22a] VARCHAR(5) NULL,
    [Q22b] VARCHAR(5) NULL,
    [Q23] VARCHAR(5) NULL,
    [Q24] VARCHAR(5) NULL,
    [Q25] VARCHAR(5) NULL,
    [Q26] VARCHAR(5) NULL,
    [Q27a] VARCHAR(50) NULL,
    [Q27b] VARCHAR(5) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(50) NULL,
    [clientid] VARCHAR(50) NULL,
    [sbtag] VARCHAR(50) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [main_branch] VARCHAR(50) NULL,
    [report_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_survey_info
-- --------------------------------------------------
CREATE TABLE [dbo].[client_survey_info]
(
    [suggestion] VARCHAR(8000) NULL,
    [name] VARCHAR(50) NULL,
    [clientid] VARCHAR(50) NULL,
    [branch] VARCHAR(50) NULL,
    [sbtag] VARCHAR(50) NULL,
    [email] VARCHAR(50) NULL,
    [mobile] VARCHAR(50) NULL,
    [offno] VARCHAR(50) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(50) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [main_branch] VARCHAR(50) NULL,
    [report_date] DATETIME NULL,
    [email_status] VARCHAR(100) NULL,
    [tel_status] VARCHAR(20) NULL,
    [mobile_status] VARCHAR(20) NULL,
    [address1] VARCHAR(500) NULL,
    [actaken] VARCHAR(50) NULL,
    [finalstatus] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_survey_info_new
-- --------------------------------------------------
CREATE TABLE [dbo].[client_survey_info_new]
(
    [suggestion] VARCHAR(8000) NULL,
    [name] VARCHAR(50) NULL,
    [clientid] VARCHAR(50) NULL,
    [branch] VARCHAR(50) NULL,
    [sbtag] VARCHAR(50) NULL,
    [email] VARCHAR(50) NULL,
    [mobile] VARCHAR(50) NULL,
    [offno] VARCHAR(50) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(50) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [main_branch] VARCHAR(50) NULL,
    [report_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_survey_new
-- --------------------------------------------------
CREATE TABLE [dbo].[client_survey_new]
(
    [Q1] VARCHAR(5) NULL,
    [Q2] VARCHAR(5) NULL,
    [Q3] VARCHAR(5) NULL,
    [Q4] VARCHAR(5) NULL,
    [Q5] VARCHAR(5) NULL,
    [Q6] VARCHAR(5) NULL,
    [Q7] VARCHAR(5) NULL,
    [Q8] VARCHAR(50) NULL,
    [Q9] VARCHAR(5) NULL,
    [Q10] VARCHAR(5) NULL,
    [Q11a] VARCHAR(5) NULL,
    [Q11b] VARCHAR(50) NULL,
    [Q12] VARCHAR(50) NULL,
    [Q13] VARCHAR(5) NULL,
    [Q14a] VARCHAR(5) NULL,
    [Q14b] VARCHAR(50) NULL,
    [Q15] VARCHAR(5) NULL,
    [Q16] VARCHAR(5) NULL,
    [Q17a] VARCHAR(5) NULL,
    [Q17b] VARCHAR(50) NULL,
    [Q18a] VARCHAR(5) NULL,
    [Q18b] VARCHAR(5) NULL,
    [Q18c] VARCHAR(5) NULL,
    [Q18d] VARCHAR(5) NULL,
    [Q19] VARCHAR(5) NULL,
    [Q20] VARCHAR(5) NULL,
    [Q21] VARCHAR(5) NULL,
    [Q22a] VARCHAR(5) NULL,
    [Q22b] VARCHAR(5) NULL,
    [Q23] VARCHAR(5) NULL,
    [Q24] VARCHAR(5) NULL,
    [Q25] VARCHAR(5) NULL,
    [Q26] VARCHAR(5) NULL,
    [Q27a] VARCHAR(50) NULL,
    [Q27b] VARCHAR(5) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(50) NULL,
    [clientid] VARCHAR(50) NULL,
    [sbtag] VARCHAR(50) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [main_branch] VARCHAR(50) NULL,
    [report_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_ABCDeposit_details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_ABCDeposit_details]
(
    [rdate] DATETIME NULL,
    [type] VARCHAR(30) NULL,
    [bc] NUMERIC(25, 2) NULL,
    [bg] NUMERIC(25, 2) NULL,
    [fd] NUMERIC(25, 2) NULL,
    [shares] NUMERIC(25, 2) NULL,
    [cash] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_ABCUtilized_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_ABCUtilized_Details]
(
    [rdate] DATETIME NULL,
    [type] VARCHAR(30) NULL,
    [IMVAR] NUMERIC(25, 2) NULL,
    [MTOM] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_acc_details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_acc_details]
(
    [rdate] DATETIME NULL,
    [type] VARCHAR(50) NULL,
    [NCDEX] NUMERIC(25, 2) NULL,
    [MCX] NUMERIC(25, 2) NULL,
    [ASLFO] NUMERIC(25, 2) NULL,
    [BSE] NUMERIC(25, 2) NULL,
    [NSE] NUMERIC(25, 2) NULL,
    [NSEFO] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FF_bank_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[FF_bank_Details]
(
    [Branch_code] VARCHAR(100) NULL,
    [Segment] VARCHAR(10) NULL,
    [Cltcode] VARCHAR(10) NULL,
    [FundsBalance] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_bank_details_offline
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_bank_details_offline]
(
    [Branch_code] VARCHAR(100) NULL,
    [Segment] VARCHAR(10) NULL,
    [Cltcode] VARCHAR(10) NULL,
    [FundsBalance] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_bank_details_offlinedata
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_bank_details_offlinedata]
(
    [rdate] DATETIME NOT NULL,
    [branch_code] VARCHAR(100) NULL,
    [segment] VARCHAR(10) NULL,
    [fundsbalance] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_bank_grpcode
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_bank_grpcode]
(
    [grpcode] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_other_values
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_other_values]
(
    [type] VARCHAR(100) NULL,
    [value] NUMERIC(25, 2) NULL,
    [dateModified] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_payin_details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_payin_details]
(
    [dow] VARCHAR(20) NULL,
    [bse] FLOAT NULL,
    [nse] FLOAT NULL,
    [nsefo] FLOAT NULL,
    [mcx] FLOAT NULL,
    [ncdx] FLOAT NULL,
    [bsefo] FLOAT NULL,
    [dwn] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_payin_details_offlinedata
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_payin_details_offlinedata]
(
    [rdate] DATETIME NULL,
    [dow] VARCHAR(20) NULL,
    [bse] FLOAT NULL,
    [nse] FLOAT NULL,
    [nsefo] FLOAT NULL,
    [mcx] FLOAT NULL,
    [ncdx] FLOAT NULL,
    [bsefo] FLOAT NULL,
    [dwn] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_rej_bank_details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_rej_bank_details]
(
    [segment] VARCHAR(100) NULL,
    [cltcode] VARCHAR(100) NULL,
    [date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_tmmrsfund_details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_tmmrsfund_details]
(
    [rdate] DATETIME NULL,
    [type] VARCHAR(100) NOT NULL,
    [qty] NUMERIC(20, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_transactions_details
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_transactions_details]
(
    [rdate] DATETIME NULL,
    [type] VARCHAR(50) NULL,
    [qty] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_updates
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_updates]
(
    [update_time] DATETIME NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_week_util
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_week_util]
(
    [savedate] DATETIME NULL,
    [mtom] NUMERIC(25, 2) NULL,
    [pp] NUMERIC(25, 2) NULL,
    [u_abcnsefo] NUMERIC(25, 2) NULL,
    [u_abcbse] NUMERIC(25, 2) NULL,
    [u_abcnse] NUMERIC(25, 2) NULL,
    [u_ac_bank] NUMERIC(25, 2) NULL,
    [u_icici_ucl] NUMERIC(25, 2) NULL,
    [od] NUMERIC(25, 2) NULL,
    [cf_sday] NUMERIC(25, 2) NULL,
    [cf_icici] NUMERIC(25, 2) NULL,
    [ucl_icici] NUMERIC(25, 2) NULL,
    [epayout] NUMERIC(25, 2) NULL,
    [rel] NUMERIC(25, 2) NULL,
    [bsense_payin] NUMERIC(25, 2) NULL,
    [fo_payin] NUMERIC(25, 2) NULL,
    [abc_bse] NUMERIC(25, 2) NULL,
    [netdebit] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_week_values
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_week_values]
(
    [dayofweek] VARCHAR(30) NULL,
    [nsefo] NUMERIC(15, 2) NULL,
    [bsense] NUMERIC(15, 2) NULL,
    [dwn] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_weekvalues_entered
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_weekvalues_entered]
(
    [dayOfWeek] VARCHAR(20) NULL,
    [week] SMALLINT NULL,
    [savedate] DATETIME NULL,
    [OD] NUMERIC(25, 2) NULL,
    [icici_citi] NUMERIC(25, 2) NULL,
    [bsense_payout] NUMERIC(25, 2) NULL,
    [nsefo_payout] NUMERIC(25, 2) NULL,
    [rel_bsense] NUMERIC(25, 2) NULL,
    [rel_nsefo] NUMERIC(25, 2) NULL,
    [rel_cx] NUMERIC(25, 2) NULL,
    [rel_buff] NUMERIC(25, 2) NULL,
    [col_icici_cl] NUMERIC(25, 2) NULL,
    [col_icici_ucl] NUMERIC(25, 2) NULL,
    [col_hdfc_cl] NUMERIC(25, 2) NULL,
    [col_hdfc_ucl] NUMERIC(25, 2) NULL,
    [bsense_payin] NUMERIC(25, 2) NULL,
    [nsefo_payin] NUMERIC(25, 2) NULL,
    [nsefo_epayin] NUMERIC(25, 2) NULL,
    [abc_bsense] NUMERIC(25, 2) NULL,
    [abc_nsefo] NUMERIC(25, 2) NULL,
    [cl_payout] NUMERIC(25, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FileUploads
-- --------------------------------------------------
CREATE TABLE [dbo].[FileUploads]
(
    [data] VARCHAR(MAX) NULL,
    [upload_dt] DATETIME NULL,
    [fileName] VARCHAR(100) NULL,
    [segment] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINREP
-- --------------------------------------------------
CREATE TABLE [dbo].[FINREP]
(
    [FAMILYCODE] VARCHAR(10) NULL,
    [FAMILYNAME] VARCHAR(30) NULL,
    [ABL_BROKERAGE] FLOAT NULL,
    [ACDL_BROKERAGE] FLOAT NULL,
    [FO_BROKERAGE] FLOAT NULL,
    [AVERAGE_BROKERAGE] FLOAT NULL,
    [AVGRAGE_LEDGER] FLOAT NULL,
    [ROE] FLOAT NULL,
    [NOOFDAYS] VARCHAR(5) NULL,
    [DUMMY1] VARCHAR(5) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL,
    [bfromdate] DATETIME NULL,
    [btodate] DATETIME NULL,
    [nfromdate] DATETIME NULL,
    [ntodate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledgerbse
-- --------------------------------------------------
CREATE TABLE [dbo].[ledgerbse]
(
    [vdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NULL,
    [acname] VARCHAR(50) NULL,
    [familycode] VARCHAR(10) NULL,
    [familyname] VARCHAR(30) NULL,
    [drcr] VARCHAR(1) NULL,
    [vamt] FLOAT NULL,
    [vtype] INT NULL,
    [DUMMY1] VARCHAR(5) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledgernse
-- --------------------------------------------------
CREATE TABLE [dbo].[ledgernse]
(
    [vdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NULL,
    [acname] VARCHAR(50) NULL,
    [familycode] VARCHAR(10) NULL,
    [familyname] VARCHAR(30) NULL,
    [drcr] VARCHAR(1) NULL,
    [vamt] FLOAT NULL,
    [vtype] INT NULL,
    [DUMMY1] VARCHAR(5) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.QFR_Report
-- --------------------------------------------------
CREATE TABLE [dbo].[QFR_Report]
(
    [username] VARCHAR(15) NULL,
    [report_date] DATETIME NULL,
    [suggestions] VARCHAR(3000) NULL,
    [suggActions] VARCHAR(3000) NULL,
    [summary] VARCHAR(4000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.QFR_survey
-- --------------------------------------------------
CREATE TABLE [dbo].[QFR_survey]
(
    [client_tag] VARCHAR(15) NULL,
    [report_date] DATETIME NULL,
    [username] VARCHAR(50) NULL,
    [q1] VARCHAR(20) NULL,
    [survey_id] INT IDENTITY(1,1) NOT NULL,
    [entry_date] DATETIME NULL,
    [suggestions] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.result_sb_survey
-- --------------------------------------------------
CREATE TABLE [dbo].[result_sb_survey]
(
    [intro] VARCHAR(MAX) NULL,
    [sbtag] VARCHAR(50) NULL,
    [r1a1] VARCHAR(MAX) NULL,
    [r1a2] VARCHAR(MAX) NULL,
    [r2a1] VARCHAR(MAX) NULL,
    [r2a2] VARCHAR(MAX) NULL,
    [r2b1] VARCHAR(MAX) NULL,
    [r2b2] VARCHAR(MAX) NULL,
    [r3a1] VARCHAR(MAX) NULL,
    [r3a2] VARCHAR(MAX) NULL,
    [r4a1] VARCHAR(MAX) NULL,
    [r4a2] VARCHAR(MAX) NULL,
    [r5a1] VARCHAR(MAX) NULL,
    [r5a2] VARCHAR(MAX) NULL,
    [r6a1] VARCHAR(MAX) NULL,
    [r6a2] VARCHAR(MAX) NULL,
    [r7a1] VARCHAR(MAX) NULL,
    [r7a2] VARCHAR(MAX) NULL,
    [r8a1] VARCHAR(MAX) NULL,
    [r8a2] VARCHAR(MAX) NULL,
    [r9a1] VARCHAR(MAX) NULL,
    [r9a2] VARCHAR(MAX) NULL,
    [r10a1] VARCHAR(MAX) NULL,
    [r10a2] VARCHAR(MAX) NULL,
    [r11a1] VARCHAR(MAX) NULL,
    [r11a2] VARCHAR(MAX) NULL,
    [r12a1] VARCHAR(MAX) NULL,
    [r12a2] VARCHAR(MAX) NULL,
    [r12b1] VARCHAR(MAX) NULL,
    [r12b2] VARCHAR(MAX) NULL,
    [r13a1] VARCHAR(MAX) NULL,
    [r13a2] VARCHAR(MAX) NULL,
    [r13b1] VARCHAR(MAX) NULL,
    [r13b2] VARCHAR(MAX) NULL,
    [r14a1] VARCHAR(MAX) NULL,
    [r14a2] VARCHAR(MAX) NULL,
    [r15a1] VARCHAR(MAX) NULL,
    [r15a2] VARCHAR(MAX) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.roe_broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[roe_broktable]
(
    [Table_No] INT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] NUMERIC(10, 2) NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [Table_name] CHAR(30) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_report_data
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_report_data]
(
    [main_branch] VARCHAR(50) NULL,
    [date] DATETIME NULL,
    [userno] VARCHAR(20) NULL,
    [summary] VARCHAR(MAX) NULL,
    [branch_data] VARCHAR(500) NULL,
    [at_q1] VARCHAR(5000) NULL,
    [sa_q1] VARCHAR(5000) NULL,
    [at_q2a] VARCHAR(5000) NULL,
    [sa_q2a] VARCHAR(5000) NULL,
    [at_q2b] VARCHAR(5000) NULL,
    [sa_q2b] VARCHAR(5000) NULL,
    [at_q3] VARCHAR(5000) NULL,
    [sa_q3] VARCHAR(5000) NULL,
    [at_q4] VARCHAR(5000) NULL,
    [sa_q4] VARCHAR(5000) NULL,
    [at_q5] VARCHAR(5000) NULL,
    [sa_q5] VARCHAR(5000) NULL,
    [at_q6] VARCHAR(5000) NULL,
    [sa_q6] VARCHAR(5000) NULL,
    [at_q7] VARCHAR(5000) NULL,
    [sa_q7] VARCHAR(5000) NULL,
    [at_q8] VARCHAR(5000) NULL,
    [sa_q8] VARCHAR(5000) NULL,
    [at_q9] VARCHAR(5000) NULL,
    [sa_q9] VARCHAR(5000) NULL,
    [at_q10] VARCHAR(5000) NULL,
    [sa_q10] VARCHAR(5000) NULL,
    [at_q11] VARCHAR(5000) NULL,
    [sa_q11] VARCHAR(5000) NULL,
    [at_q12a] VARCHAR(5000) NULL,
    [sa_q12a] VARCHAR(5000) NULL,
    [at_q12b] VARCHAR(5000) NULL,
    [sa_q12b] VARCHAR(5000) NULL,
    [at_q13a] VARCHAR(5000) NULL,
    [sa_q13a] VARCHAR(5000) NULL,
    [at_q13b] VARCHAR(5000) NULL,
    [sa_q13b] VARCHAR(5000) NULL,
    [at_q14] VARCHAR(5000) NULL,
    [sa_q14] VARCHAR(5000) NULL,
    [at_q15] VARCHAR(5000) NULL,
    [sa_q15] VARCHAR(5000) NULL,
    [highlights] VARCHAR(5000) NULL,
    [sugg] VARCHAR(5000) NULL,
    [conducted_By] VARCHAR(80) NULL,
    [reviewed_by] VARCHAR(80) NULL,
    [approved_by] VARCHAR(80) NULL,
    [release_date] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sb_Survey
-- --------------------------------------------------
CREATE TABLE [dbo].[Sb_Survey]
(
    [Q1] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q2] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q3] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q4] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q5a] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q5b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q6] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q7a] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q7b] VARCHAR(50) NOT NULL DEFAULT 'NA',
    [Q8a] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q8b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q8c] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q8d] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q8e] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q9a] VARCHAR(50) NOT NULL DEFAULT 'NA',
    [Q9b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q10a] VARCHAR(50) NOT NULL DEFAULT 'NA',
    [Q10b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q11] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q12] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q13a] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q13b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q14a] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q14b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q14c] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q15] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q16] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q17] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Q18a] VARCHAR(50) NOT NULL DEFAULT 'NA',
    [Q18b] VARCHAR(5) NOT NULL DEFAULT 'NA',
    [Date] DATETIME NULL,
    [username] VARCHAR(25) NULL,
    [sbtag] VARCHAR(15) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [Main_Branch] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [report_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_survey_info
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_survey_info]
(
    [suggestion] VARCHAR(8000) NULL,
    [name] VARCHAR(100) NULL,
    [branch] VARCHAR(25) NULL,
    [sbtag] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [mobileno] VARCHAR(20) NULL,
    [OffNo] VARCHAR(20) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(25) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [Main_Branch] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [report_date] DATETIME NULL,
    [email_status] VARCHAR(70) NULL,
    [tel_status] VARCHAR(70) NULL,
    [mobile_status] VARCHAR(70) NULL,
    [address1] VARCHAR(500) NULL,
    [action_taken] VARCHAR(100) NULL,
    [final_status] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_survey_info_new
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_survey_info_new]
(
    [suggestion] VARCHAR(8000) NULL,
    [name] VARCHAR(100) NULL,
    [branch] VARCHAR(25) NULL,
    [sbtag] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [mobileno] VARCHAR(20) NULL,
    [OffNo] VARCHAR(20) NULL,
    [date] DATETIME NULL,
    [username] VARCHAR(25) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [Main_Branch] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [report_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_survey_new
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_survey_new]
(
    [Q1] VARCHAR(5) NOT NULL,
    [Q2] VARCHAR(5) NOT NULL,
    [Q3] VARCHAR(5) NOT NULL,
    [Q4] VARCHAR(5) NOT NULL,
    [Q5a] VARCHAR(5) NOT NULL,
    [Q5b] VARCHAR(5) NOT NULL,
    [Q6] VARCHAR(5) NOT NULL,
    [Q7a] VARCHAR(5) NOT NULL,
    [Q7b] VARCHAR(50) NOT NULL,
    [Q8a] VARCHAR(5) NOT NULL,
    [Q8b] VARCHAR(5) NOT NULL,
    [Q8c] VARCHAR(5) NOT NULL,
    [Q8d] VARCHAR(5) NOT NULL,
    [Q8e] VARCHAR(5) NOT NULL,
    [Q9a] VARCHAR(50) NOT NULL,
    [Q9b] VARCHAR(5) NOT NULL,
    [Q10a] VARCHAR(50) NOT NULL,
    [Q10b] VARCHAR(5) NOT NULL,
    [Q11] VARCHAR(5) NOT NULL,
    [Q12] VARCHAR(5) NOT NULL,
    [Q13a] VARCHAR(5) NOT NULL,
    [Q13b] VARCHAR(5) NOT NULL,
    [Q14a] VARCHAR(5) NOT NULL,
    [Q14b] VARCHAR(5) NOT NULL,
    [Q14c] VARCHAR(5) NOT NULL,
    [Q15] VARCHAR(5) NOT NULL,
    [Q16] VARCHAR(5) NOT NULL,
    [Q17] VARCHAR(5) NOT NULL,
    [Q18a] VARCHAR(50) NOT NULL,
    [Q18b] VARCHAR(5) NOT NULL,
    [Date] DATETIME NULL,
    [username] VARCHAR(25) NULL,
    [sbtag] VARCHAR(15) NULL,
    [survey_id] VARCHAR(50) NOT NULL,
    [Main_Branch] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [report_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_survey_q
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_survey_q]
(
    [name] NVARCHAR(100) NULL,
    [Branch] NVARCHAR(50) NULL,
    [SBTag] NVARCHAR(50) NULL,
    [q1] NVARCHAR(300) NULL,
    [q2] NVARCHAR(300) NULL,
    [q3] NVARCHAR(300) NULL,
    [q4] NVARCHAR(300) NULL,
    [q5a] NVARCHAR(300) NULL,
    [q5b] NVARCHAR(300) NULL,
    [q6] NVARCHAR(300) NULL,
    [q7a] NVARCHAR(300) NULL,
    [q7b] NVARCHAR(300) NULL,
    [q8a] NVARCHAR(300) NULL,
    [q8b] NVARCHAR(300) NULL,
    [q8c] NVARCHAR(300) NULL,
    [q8d] NVARCHAR(300) NULL,
    [q8e] NVARCHAR(300) NULL,
    [q9a] NVARCHAR(300) NULL,
    [q9b] NVARCHAR(300) NULL,
    [q10a] NVARCHAR(300) NULL,
    [q10b] NVARCHAR(300) NULL,
    [q11] NVARCHAR(300) NULL,
    [q12] NVARCHAR(300) NULL,
    [q13a] NVARCHAR(300) NULL,
    [q13b] NVARCHAR(300) NULL,
    [q14a] NVARCHAR(300) NULL,
    [q14b] NVARCHAR(300) NULL,
    [q15] NVARCHAR(300) NULL,
    [q16] NVARCHAR(300) NULL,
    [q17] NVARCHAR(300) NULL,
    [q18] NVARCHAR(300) NULL,
    [remark] VARCHAR(50) NULL,
    [email] NVARCHAR(150) NULL,
    [email_status] NVARCHAR(100) NULL,
    [mobile] NCHAR(11) NULL,
    [mobile_status] NVARCHAR(50) NULL,
    [office_tele] NVARCHAR(50) NULL,
    [off_tel_stat] NVARCHAR(100) NULL,
    [Action_taken] VARCHAR(150) NULL,
    [status] VARCHAR(50) NULL,
    [Address] NVARCHAR(200) NULL,
    [Person_name] NCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Survey_Branch
-- --------------------------------------------------
CREATE TABLE [dbo].[Survey_Branch]
(
    [brname] VARCHAR(50) NULL,
    [brid] INT IDENTITY(1,1) NOT NULL
);

GO

