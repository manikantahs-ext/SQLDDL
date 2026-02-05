-- DDL Export
-- Server: 10.253.78.163
-- Database: FranchiseeV3
-- Exported: 2026-02-05T12:29:58.072894

USE FranchiseeV3;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_diagramobjects
-- --------------------------------------------------

	CREATE FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END

GO

-- --------------------------------------------------
-- FUNCTION dbo.getfirstdate
-- --------------------------------------------------
CREATE function getfirstdate(@mmonth int, @myear int)        
RETURNs Datetime        
As        
Begin        
--declare @mmonth int     
--declare @myear int    
--set @mmonth =  11        
--set @myear  = 2007        
declare @tdate as datetime        
select @tdate=convert(datetime,convert(varchar(2),    
case when @mmonth < =12 then @mmonth else 1 end)+'/01/'+convert(varchar(4),        
case when @mmonth <= 12 then @myear else @myear+1 end))       
--print @tdate    
Return @tdate        
       
End

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
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Franchisee_glcode_Mast
-- --------------------------------------------------
ALTER TABLE [dbo].[Franchisee_glcode_Mast] ADD CONSTRAINT [PK_Franchisee_glcode_Mast] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B619DF76B4B] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_franch_exclude_extraexpense
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_franch_exclude_extraexpense] ADD CONSTRAINT [PK__tbl_fran__D7E170AB35BCFE0A] PRIMARY KEY ([Ftag], [code], [segment])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_FranchiseeCalc
-- --------------------------------------------------
CREATE Procedure Angel_FranchiseeCalc(@month as varchar(25),@year as varchar(25),@ftagVendor as varchar(30))                                                    
as                                                    
                                                    
Set Nocount On                                                    
declare @ftag as varchar(30),@vendor_id as varchar(11)                     
/*        
declare @month as varchar(25),@year as varchar(25)   ,@ftagVendor as varchar(30)                  
set @month =3            
set @year=2011          
set @ftagVendor='ALL'            
*/        
if(@ftagVendor = 'ALL')        
begin         
set @vendor_id='%'        
set  @ftag='%'        
        
end         
else        
begin        
--declare @ftag as varchar(30),@vendor_id as varchar(11),@ftagVendor as varchar(30)        
--set @ftagVendor='6036,AHD'        
set @vendor_id=SUBSTRING(@ftagVendor,0,charindex(',',@ftagVendor))        
set  @ftag=replace(SUBSTRING(@ftagVendor,charindex(',',@ftagVendor),LEN(@ftagVendor)),',','')        
end        
                                            
                  
declare @fromdate1 as varchar(25),@todate as varchar(25),@fromdate as varchar(25)                 
--select sdtcur from parameter where sdtcur <= 'Mar 31 2011' and ldtcur>='Mar 31 2011'            
set @todate=convert(varchar(11),dbo.getlastdate(@month,@year))             
set @fromdate1=convert(varchar(11),dbo.getfirstdate(@month,@year))            
select @fromdate=convert(varchar(11),sdtcur) from remisior.dbo.parameter where sdtcur <= @todate and ldtcur>=@todate            
            
--print @fromdate            
--print @todate            
                     
Set transaction isolation level read uncommitted                                                    
select code                             
into #file                                                    
from dbo.Franchisee_glcode_Mast(nolock)                                                     
where flag<>'X'           
         
                   
/*                    
select  account_code,entity_code,a.branch_code,Accounting_date,branchtag                    
,DAmt=convert(money,isnull(accounted_dr,0)) ,CAmt=Convert(money,isnull(accounted_Cr,0))                    
into #fin                    
from [196.1.115.219].oraclefin.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),                    
(                    
select branch_code,branchtag from [196.1.115.219].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE a ,                  
(select distinct ftag,ENTITY_CODE from Vw_franchisee_mast_entity where todate>=@todate) b                    
where a.branchtag=b.ftag                     
) b                    
where Accounting_date>=@fromdate and Accounting_date<=@todate+' 23:59:59' and                     
account_code in ( select code from #file)                     
and a.branch_code=b.branch_code --and branchtag='AHD'               
*/          
--select * from #fin        
        
                
select  account_code,entity_code,a.branch_code,Accounting_date,branchtag, b.vendor_id                   
,DAmt=convert(money,isnull(accounted_dr,0)) ,CAmt=Convert(money,isnull(accounted_Cr,0))                    
into #fin                    
from [ABCSOORACLEMDLW].oraclefin.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),                    
(                    
select branch_code,branchtag,fydate,vendor_id from [ABCSOORACLEMDLW].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE a ,                  
(select distinct ftag,ENTITY_CODE,vendor_id,fydate=case  when fromdate >= @fromdate then fromdate else @fromdate end from Vw_franchisee_mast_entity where todate>='Mar 31 2011') b                    
where a.branchtag=b.ftag --and b.vendor_id like @vendor_id                     
) b                    
where Accounting_date>=b.fydate and Accounting_date<=@todate+' 23:59:59' and                     
account_code in ( select code from #file)                     
and a.branch_code=b.branch_code and branchtag like @ftag                   
          
select cltcode=account_code,Amount=sum(DAmt-CAmt) ,branchtag,entity_code,long_name=SPACE(240)                    
into #calc                    
from #fin                     
group by account_code,branchtag,entity_code                    
                    
update #calc set long_name=b.description from [ABCSOORACLEMDLW].oraclefin.dbo.XXANG_ANGEL_ACCOUNT_CODE b                    
where #calc.cltcode=b.account_code                    
                    
delete from tbl_franchisee_calc where tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate) and  branch like @ftag                                                     
                    
insert into tbl_franchisee_calc                    
select cltcode,long_name,Amount,branchtag,entity_code,datepart(mm,@todate),datepart(yy,@todate)                    
from #calc                    
                    
                    
delete from  franchisee_b2b_b2c_brok  where tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)   and  branch like @ftag                       
                              
select BRANCH,subbrokcode,segment,brok_earned=sum(brok_earned)                                      
into #brok                    
from REMISIOR.DBO.comb_sb                                       
where sauda_date>=@fromdate and sauda_date<=@todate                 
and BRANCH in (select ftag from tbl_Franchisee_Mast (nolock))                                     
group by BRANCH,subbrokcode,segment                              
                    
insert into franchisee_b2b_b2c_brok                                    
select A.BRANCH,a.subbrokcode ,segment,                                       
 b2b_brok_earned=isnull(case when b.b2c_sb is null then  a.brok_earned end,0) ,                                       
b2c_brok_earned=isnull(case when b.b2c_sb is not null then  a.brok_earned end ,0)                                     
,tmonth=datepart(mm,@todate),tyear=datepart(yy,@todate)                         
 from                                      
#brok a                                      
left outer join                                       
remisior.dbo.b2c_sb b                                      
on a.subbrokcode=b.b2c_sb                         
                    
                    
                    
insert into tbl_franchisee_calc                    
select '1010101','GROSS BROKERAGE B2B',B2B_BROK_EARNED=SUM(B2B_BROK_EARNED),BRANCH,entity_code,tmonth,tyear                            
from  Vw_franchisee_b2b_b2c_brok where  tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)                           
group by BRANCH,entity_code,tmonth,tyear                            
UNION                            
select '2020202','GROSS BROKERAGE B2C',B2C_BROK_EARNED=SUM(B2C_BROK_EARNED),BRANCH,entity_code,tmonth,tyear                    
from  Vw_franchisee_b2b_b2c_brok where  tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)                    
group by BRANCH,entity_code,tmonth,tyear                            
                    
                        
                               
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_FranchiseeCalc_bak
-- --------------------------------------------------
CREATE Procedure Angel_FranchiseeCalc_bak(@fydate as varchar(25),@tdate as varchar(25))                                            
as                                            
                                            
Set Nocount On                                            
            
/*            
declare @fydate as varchar(25),@tdate as varchar(25)            
set @fydate  ='Apr 01 2010'            
set @tdate='Mar 31 2011'                                          
*/            
            
Set transaction isolation level read uncommitted                                            
select code                     
into #file                                            
from dbo.Franchisee_glcode_Mast(nolock)                                             
where flag<>'X'              
/*            
select  account_code,entity_code,a.branch_code,Accounting_date,branchtag            
,DAmt=convert(money,isnull(accounted_dr,0)) ,CAmt=Convert(money,isnull(accounted_Cr,0))            
into #fin            
from [196.1.115.219].oraclefin.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),            
(            
select branch_code,branchtag from [196.1.115.219].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE a ,          
(select distinct ftag,ENTITY_CODE from Vw_franchisee_mast_entity where todate>=@tdate) b            
where a.branchtag=b.ftag             
) b            
where Accounting_date>=@fydate and Accounting_date<=@tdate+' 23:59:59' and             
account_code in ( select code from #file)             
and a.branch_code=b.branch_code --and branchtag='AHD'       
*/           
select  account_code,entity_code,a.branch_code,Accounting_date,branchtag            
,DAmt=convert(money,isnull(accounted_dr,0)) ,CAmt=Convert(money,isnull(accounted_Cr,0))            
into #fin            
from [196.1.115.199].oraclefin_UAT.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),            
(            
select branch_code,branchtag,fydate from [196.1.115.199].oraclefin_UAT.dbo.XXANG_ANGEL_BRANCH_CODE a ,          
(select distinct ftag,ENTITY_CODE,fydate=case  when fromdate >= @fydate then fromdate else @fydate end from Vw_franchisee_mast_entity where todate>=@tdate) b            
where a.branchtag=b.ftag             
) b            
where Accounting_date>=b.fydate and Accounting_date<=@tdate+' 23:59:59' and             
account_code in ( select code from #file)             
and a.branch_code=b.branch_code --and branchtag='AHD'            
            
select cltcode=account_code,Amount=sum(DAmt-CAmt) ,branchtag,entity_code,long_name=SPACE(240)            
into #calc            
from #fin             
group by account_code,branchtag,entity_code            
            
update #calc set long_name=b.description from [196.1.115.199].oraclefin_UAT.dbo.XXANG_ANGEL_ACCOUNT_CODE b            
where #calc.cltcode=b.account_code            
            
delete from tbl_franchisee_calc where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                              
            
insert into tbl_franchisee_calc            
select cltcode,long_name,Amount,branchtag,entity_code,datepart(mm,@tdate),datepart(yy,@tdate)            
from #calc            
            
            
delete from  franchisee_b2b_b2c_brok  where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                 
                      
select BRANCH,subbrokcode,segment,brok_earned=sum(brok_earned)                              
into #brok            
from REMISIOR.DBO.comb_sb                               
where sauda_date>=@fydate and sauda_date<=@tdate             
and BRANCH in (select ftag from tbl_Franchisee_Mast (nolock))                             
group by BRANCH,subbrokcode,segment                      
            
insert into franchisee_b2b_b2c_brok                            
select A.BRANCH,a.subbrokcode ,segment,                               
 b2b_brok_earned=isnull(case when b.b2c_sb is null then  a.brok_earned end,0) ,                               
b2c_brok_earned=isnull(case when b.b2c_sb is not null then  a.brok_earned end ,0)                             
,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                 
 from                              
#brok a                              
left outer join                               
remisior.dbo.b2c_sb b                              
on a.subbrokcode=b.b2c_sb                 
            
            
            
insert into tbl_franchisee_calc            
select '1010101','GROSS BROKERAGE B2B',B2B_BROK_EARNED=SUM(B2B_BROK_EARNED),BRANCH,entity_code,tmonth,tyear                    
from  Vw_franchisee_b2b_b2c_brok where  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                   
group by BRANCH,entity_code,tmonth,tyear                    
UNION                    
select '2020202','GROSS BROKERAGE B2C',B2C_BROK_EARNED=SUM(B2C_BROK_EARNED),BRANCH,entity_code,tmonth,tyear            
from  Vw_franchisee_b2b_b2c_brok where  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
group by BRANCH,entity_code,tmonth,tyear                    
            
                
                       
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_FranchiseeCalc_bak1
-- --------------------------------------------------
CREATE Procedure Angel_FranchiseeCalc_bak1(@month as varchar(25),@year as varchar(25))                                              
as                                              
                                              
Set Nocount On                                              
              
/*          
declare @month as varchar(25),@year as varchar(25)              
set @month =3      
set @year=2011        
*/    
                                      
               
declare @fromdate1 as varchar(25),@todate as varchar(25),@fromdate as varchar(25)           
--select sdtcur from parameter where sdtcur <= 'Mar 31 2011' and ldtcur>='Mar 31 2011'      
set @todate=convert(varchar(11),dbo.getlastdate(@month,@year))       
set @fromdate1=convert(varchar(11),dbo.getfirstdate(@month,@year))      
select @fromdate=convert(varchar(11),sdtcur) from remisior.dbo.parameter where sdtcur <= @todate and ldtcur>=@todate      
      
--print @fromdate      
--print @todate      
              
Set transaction isolation level read uncommitted                                              
select code                       
into #file                                              
from dbo.Franchisee_glcode_Mast(nolock)                                               
where flag<>'X'                
/*              
select  account_code,entity_code,a.branch_code,Accounting_date,branchtag              
,DAmt=convert(money,isnull(accounted_dr,0)) ,CAmt=Convert(money,isnull(accounted_Cr,0))              
into #fin              
from [196.1.115.219].oraclefin.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),              
(              
select branch_code,branchtag from [196.1.115.219].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE a ,            
(select distinct ftag,ENTITY_CODE from Vw_franchisee_mast_entity where todate>=@todate) b              
where a.branchtag=b.ftag               
) b              
where Accounting_date>=@fromdate and Accounting_date<=@todate+' 23:59:59' and               
account_code in ( select code from #file)               
and a.branch_code=b.branch_code --and branchtag='AHD'         
*/             
select  account_code,entity_code,a.branch_code,Accounting_date,branchtag              
,DAmt=convert(money,isnull(accounted_dr,0)) ,CAmt=Convert(money,isnull(accounted_Cr,0))              
into #fin              
from [196.1.115.219].oraclefin_UAT.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),              
(              
select branch_code,branchtag,fydate from [196.1.115.219].oraclefin_UAT.dbo.XXANG_ANGEL_BRANCH_CODE a ,            
(select distinct ftag,ENTITY_CODE,fydate=case  when fromdate >= @fromdate then fromdate else @fromdate end from Vw_franchisee_mast_entity where todate>=@todate) b              
where a.branchtag=b.ftag               
) b              
where Accounting_date>=b.fydate and Accounting_date<=@todate+' 23:59:59' and               
account_code in ( select code from #file)               
and a.branch_code=b.branch_code --and branchtag='AHD'              
              
select cltcode=account_code,Amount=sum(DAmt-CAmt) ,branchtag,entity_code,long_name=SPACE(240)              
into #calc              
from #fin               
group by account_code,branchtag,entity_code              
              
update #calc set long_name=b.description from [196.1.115.219].oraclefin_UAT.dbo.XXANG_ANGEL_ACCOUNT_CODE b              
where #calc.cltcode=b.account_code              
              
delete from tbl_franchisee_calc where tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)                                                
              
insert into tbl_franchisee_calc              
select cltcode,long_name,Amount,branchtag,entity_code,datepart(mm,@todate),datepart(yy,@todate)              
from #calc              
              
              
delete from  franchisee_b2b_b2c_brok  where tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)                   
                        
select BRANCH,subbrokcode,segment,brok_earned=sum(brok_earned)                                
into #brok              
from REMISIOR.DBO.comb_sb                                 
where sauda_date>=@fromdate and sauda_date<=@todate           
and BRANCH in (select ftag from tbl_Franchisee_Mast (nolock))                               
group by BRANCH,subbrokcode,segment                        
              
insert into franchisee_b2b_b2c_brok                              
select A.BRANCH,a.subbrokcode ,segment,                                 
 b2b_brok_earned=isnull(case when b.b2c_sb is null then  a.brok_earned end,0) ,                                 
b2c_brok_earned=isnull(case when b.b2c_sb is not null then  a.brok_earned end ,0)                               
,tmonth=datepart(mm,@todate),tyear=datepart(yy,@todate)                   
 from                                
#brok a                                
left outer join                                 
remisior.dbo.b2c_sb b                                
on a.subbrokcode=b.b2c_sb                   
              
              
              
insert into tbl_franchisee_calc              
select '1010101','GROSS BROKERAGE B2B',B2B_BROK_EARNED=SUM(B2B_BROK_EARNED),BRANCH,entity_code,tmonth,tyear                      
from  Vw_franchisee_b2b_b2c_brok where  tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)                     
group by BRANCH,entity_code,tmonth,tyear                      
UNION                      
select '2020202','GROSS BROKERAGE B2C',B2C_BROK_EARNED=SUM(B2C_BROK_EARNED),BRANCH,entity_code,tmonth,tyear              
from  Vw_franchisee_b2b_b2c_brok where  tmonth=datepart(mm,@todate) and tyear=datepart(yy,@todate)              
group by BRANCH,entity_code,tmonth,tyear                      
              
                  
                         
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CommoditiesPaid
-- --------------------------------------------------
CREATE proc CommoditiesPaid      
as    
begin    
set nocount on;    
--select     
--Ftag,    
--ABLHOBrokPaid=sum(case Segment when 'ABL HO' then Brok_Paid else 0 end),    
--ABLBSECMBrokPaid=sum(case Segment when 'ABL BSECM' then Brok_Paid else 0 end),    
--ABLMCXCDBrokPaid=sum(case Segment when 'ABL MCXCD' then Brok_Paid else 0 end),    
--ABLNSECDBrokPaid=sum(case Segment when 'ABL NSECD' then Brok_Paid else 0 end),    
--ABLNSECMBrokPaid=sum(case Segment when 'ABL NSECM' then Brok_Paid else 0 end),    
--ABLNSEFOBrokPaid=sum(case Segment when 'ABL NSEFO' then Brok_Paid else 0 end),    
--ACBPLHOBrokPaid=sum(case Segment when 'ACBPL HO' then Brok_Paid else 0 end),    
--ACBPLMCXBrokPaid=sum(case Segment when 'ACBPL MCX' then Brok_Paid else 0 end),    
--ACBPLNCDEXBrokPaid=sum(case Segment when 'ACBPLNCDEX' then Brok_Paid else 0 end),    
    
--ABLHOBrokAccrual=sum(case Segment when 'ABL HO' then Brok_accrual else 0 end),    
--ABLBSECMBrokAccrual=sum(case Segment when 'ABL BSECM' then Brok_accrual else 0 end),    
--ABLMCXCDBrokAccrual=sum(case Segment when 'ABL MCXCD' then Brok_accrual else 0 end),    
--ABLNSECDBrokAccrual=sum(case Segment when 'ABL NSECD' then Brok_accrual else 0 end),    
--ABLNSECMBrokAccrual=sum(case Segment when 'ABL NSECM' then Brok_accrual else 0 end),    
--ABLNSEFOBrokAccrual=sum(case Segment when 'ABL NSEFO' then Brok_accrual else 0 end),    
--ACBPLHOBrokAccrual=sum(case Segment when 'ACBPL HO' then Brok_accrual else 0 end),    
--ACBPLMCXBrokAccrual=sum(case Segment when 'ACBPL MCX' then Brok_accrual else 0 end),    
--ACBPLNCDEXBrokAccrual=sum(case Segment when 'ACBPLNCDEX' then Brok_accrual else 0 end),    
--fromdate=MAX(fromdate),    
--todate=MAX(todate)    
--from tbl_Franch_BKG_Paid     
--group by Ftag    
--order by Ftag    
   
select [segment], [ftag], [brok_paid], [brok_accrual],   
[fromdate]=convert(varchar,[fromdate],103),   
[todate] =convert(varchar, [todate],103)   
from [tbl_franch_bkg_paid]   
where [brok_accrual] >0    
order by [ftag] ,[segment]   

set nocount off;    
end

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
-- PROCEDURE dbo.Franch_gl_marked
-- --------------------------------------------------
CREATE Procedure Franch_gl_marked          
as          
          
declare @nou as int          
select @nou=count(distinct updt) from Franchisee_glcode_Mast   (nolock)       
          
if @nou>1           
 begin          
 declare @ndt as datetime          
 select @ndt=max(updt) from Franchisee_glcode_Mast (nolock)   
         
 SELECT a.ID,GrpMap,Code,particulars,flag,Account_type,updt=convert(varchar(25),updt),GrpName=ISNULL(GrpName,'')   
 ,status=case when updt=@ndt then 'NEW' else 'OLD' end   
 FROM [Franchisee_glcode_Mast]a  (nolock)  left join Franch_expense_grp b on a.GrpMap=b.ID order by updt desc  
        
 end          
else          
 begin          
  SELECT  a.ID,GrpMap,Code,particulars,flag,Account_type,updt=convert(varchar(25),updt),GrpName=ISNULL(GrpName,'')   
  ,status='OLD'  
  FROM [Franchisee_glcode_Mast]a  (nolock)  left join Franch_expense_grp b on a.GrpMap=b.ID order by updt desc  
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
-- PROCEDURE dbo.Rpt_franch_Grp_Summary
-- --------------------------------------------------
CREATE procedure Rpt_franch_Grp_Summary(@branch as varchar(6),@tmonth as int,@tyear as int,@vid as int,@flag as int,@grpid as int)                                              
As                                              
                                      
set nocount on                                              
Set transaction isolation level read uncommitted                                               
              
/*               
declare @branch as varchar(6),@tmonth as int,@tyear as int,@vid as int  ,@flag as int,@grpid as int
                                    
set @branch='AHD'                                      
set @vid=6036                    
set @tmonth=3                                      
set @tyear=2011                
set @flag=1    
set @grpid=0 
*/  
select top 0 * into #file1a from Tbl_Rpt_Summ_Structure    
  
if @flag=2    
BEGIN    
 declare @tmonth1 as int,@tyear1 as int                  
 set @tmonth1= (select tmonth1=case when @tmonth=1 then 12 else @tmonth-1 end )                   
 set @tyear1=(select tyear1=case when @tmonth=1 then @tyear-1 else @tyear end)    
END              
    
 insert into #file1a              
 select a.code,a.particulars,amount,branch,tmonth,tyear,flag,a.entity_code,GrpMap                                                               
 from tbl_Franchisee_calc a(nolock)  ,Franchisee_glcode_Mast b  , Vw_franchisee_mast_entity c                                                         
 where a.code=b.Code and tmonth=@tmonth and tyear=@tyear      and branch=@branch  and  a.branch=c.ftag and a.entity_code=c.entity_code               
 and c.todate>=dbo.getlastDate(@tmonth,@tyear)  and c.vendor_id=@vid            
 and b.GrpMap=@grpid
               
     
           
if @flag=2    
BEGIN    
  insert into #file1a              
  select a.code,a.particulars,amount*-1,branch,tmonth=@tmonth,tyear=@tyear,flag,a.entity_code,GrpMap                                                               
  from tbl_Franchisee_calc a(nolock)  ,Franchisee_glcode_Mast b  , Vw_franchisee_mast_entity c                                                         
  where a.code=b.Code and tmonth=@tmonth1 and tyear=@tyear1      and branch=@branch  and  a.branch=c.ftag and a.entity_code=c.entity_code               
  and c.todate>=dbo.getlastDate(@tmonth1,@tyear1)  and c.vendor_id=@vid    
   
          
END              
    
select code,particulars,amount=SUM(amount),branch,tmonth,tyear,flag,entity_code,GrpMap     
into #final    
from #file1a    
group by code,particulars,branch,tmonth,tyear,flag,entity_code,GrpMap 
  
                               
                                     
                                

--select * from #final              
              
insert into #final              
select code=isnull(a.code,''),particulars=isnull(a.particulars,''),amount=ISNULL(amount,0),         
@branch,@tmonth,@tyear,              
flag=ISNULL(a.flag,''),entity_code=ISNULL(a.entity_code,b.entity_code),              
grpid=ISNULL(GrpMap,0)         
 from              
(select * from #final)  a right outer join Vw_Rpt_Summ_Entity b              
on a.particulars=b.particulars and a.entity_code=b.entity_code              
where a.entity_code is null              
order by a.particulars              
              
              
              
select a.*,b.ENTITY_NAME into #final1               
from #final a ,              
( select ENTITY_CODE,ENTITY_NAME=REPLACE(ENTITY_NAME,' ','_')               
from tbl_franch_entity_mast where ENABLED_FLAG='Y') b              
where a.entity_code=b.ENTITY_CODE              
              
              
SELECT particulars,flag ,             
ABL__HO=ISNULL(ABL__HO,0),              
ABL_BSECM=ISNULL(ABL_BSECM,0),              
ABL_NSECM=ISNULL(ABL_NSECM,0),              
ABL_NSEFO=ISNULL(ABL_NSEFO,0),              
ABL_NSECD=ISNULL(ABL_NSECD,0),              
ABL_MCXCD=ISNULL(ABL_MCXCD,0),              
ACBPL_HO=ISNULL(ACBPL_HO,0),              
ACBPL_NCDEX=ISNULL(ACBPL_NCDEX,0),              
ACBPL_MCX=ISNULL(ACBPL_MCX,0) ,code              
FROM               
    (SELECT particulars, branch, flag,ENTITY_NAME,Amount,tmonth,tyear ,code             
        FROM #final1              
                      
        ) s               
PIVOT               
(               
    SUM(Amount)               
    FOR ENTITY_NAME               
    IN ([ABL__HO],[ABL_BSECM],[ABL_NSECM],[ABL_NSEFO],[ABL_NSECD],[ABL_MCXCD],[ACBPL_HO],[ACBPL_NCDEX],[ACBPL_MCX])               
) p               
ORDER BY particulars

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_franch_Summary
-- --------------------------------------------------
--exec Rpt_franch_Summary 'AHD','3','2011','6036',1  
  
  
CREATE procedure Rpt_franch_Summary(@branch as varchar(6),@tmonth as int,@tyear as int,@vid as int,@flag as int)                                                
As                                                
                                        
set nocount on                                                
Set transaction isolation level read uncommitted                                                 
                
/*                 
declare @branch as varchar(6),@tmonth as int,@tyear as int,@vid as int  ,@flag as int                                      
set @branch='AHD'                                        
set @vid=6036                      
set @tmonth=3                                        
set @tyear=2011                  
set @flag=2      
*/    
    
select top 0 * into #file1a from Tbl_Rpt_Summ_Structure      
select top 0 particular=particulars,Amount,branch,tmonth,tyear,flag=SPACE(30),entity_code,vendor_id=CONVERT(int,0)    
into #tempa from Tbl_Rpt_Summ_Structure      
    
if @flag=2      
BEGIN      
 declare @tmonth1 as int,@tyear1 as int                    
 set @tmonth1= (select tmonth1=case when @tmonth=1 then 12 else @tmonth-1 end )                     
 set @tyear1=(select tyear1=case when @tmonth=1 then @tyear-1 else @tyear end)      
END                
      
 insert into #file1a                
 select a.code,a.particulars,amount,branch,tmonth,tyear,flag,a.entity_code,GrpMap                                                                 
 from tbl_Franchisee_calc a(nolock)  ,Franchisee_glcode_Mast b  , Vw_franchisee_mast_entity c                                                           
 where a.code=b.Code and tmonth=@tmonth and tyear=@tyear      and branch=@branch  and  a.branch=c.ftag and a.entity_code=c.entity_code                 
 and c.todate>=dbo.getlastDate(@tmonth,@tyear)  and c.vendor_id=@vid              
    
 insert into #tempa           
 select particular,Amount,branch,tmonth,tyear,flag,a.entity_code,a.vendor_id                 
 from tbl_Franch_Final a, Vw_franchisee_mast_entity c                                                           
 where tmonth=@tmonth and tyear=@tyear     and branch=@branch  and  a.branch=c.ftag and a.entity_code=c.entity_code                 
 and c.todate>=dbo.getlastDate(@tmonth,@tyear)  and a.vendor_id=c.vendor_id and c.vendor_id=@vid             
                 
              
if @flag=2      
BEGIN      
  insert into #file1a                
  select a.code,a.particulars,amount*-1,branch,tmonth=@tmonth,tyear=@tyear,flag,a.entity_code,GrpMap                                                                 
  from tbl_Franchisee_calc a(nolock)  ,Franchisee_glcode_Mast b  , Vw_franchisee_mast_entity c                                                           
  where a.code=b.Code and tmonth=@tmonth1 and tyear=@tyear1      and branch=@branch  and  a.branch=c.ftag and a.entity_code=c.entity_code                 
  and c.todate>=dbo.getlastDate(@tmonth1,@tyear1)  and c.vendor_id=@vid      
     
    insert into #tempa           
 select particular,Amount*-1,branch,tmonth=@tmonth,tyear=@tyear,flag,a.entity_code,a.vendor_id                 
 from tbl_Franch_Final a, Vw_franchisee_mast_entity c                                                           
 where tmonth=@tmonth and tyear=@tyear     and branch=@branch  and  a.branch=c.ftag and a.entity_code=c.entity_code                 
 and c.todate>=dbo.getlastDate(@tmonth,@tyear)  and a.vendor_id=c.vendor_id and c.vendor_id=@vid             
            
END                
      
select code,particulars,amount=SUM(amount),branch,tmonth,tyear,flag,entity_code,GrpMap       
into #file1      
from #file1a      
group by code,particulars,branch,tmonth,tyear,flag,entity_code,GrpMap      
    
    
    
select particular,Amount=SUM(Amount),branch,tmonth,tyear,flag,entity_code,vendor_id    
into #temp    
from #tempa    
group by particular,branch,tmonth,tyear,flag,entity_code,vendor_id      
/*Any changes in this SP sud be also done in SP of JV generation(SP name Franchisee_JV)*/                                            
--select * from Franch_final1                                         
--select * from Franch_final1 where flag='I'ablcode='51000035'                                       
--select * from #file1 where flag='O' and ablcode='51000035'                                       
                                       
select                                        
particulars=isnull(b.grpname,a.particulars),                                        
Amount,                                        
flag,branch,tmonth,tyear,entity_code,                                        
Code,grpid=b.ID                                        
into #fin                                       
from                                        
(select* from #file1 where flag='O') a                                         
left outer join (select * from Franch_expense_grp) b                                         
on a.GrpMap=b.ID                                        
                                      
                                        
select                                         
particulars,Amount=sum(Amount)   ,                                 
flag,branch,tmonth,tyear,Code,grpid=isnull(grpid,0),entity_code                                        
into #flago                           
from                
#fin a                                        
group by                                         
particulars,flag,branch,tmonth,tyear,isnull(grpid,0) ,entity_code,Code                                       
                                        
                                        
select *,DisplayOrder=CONVERT(int,0) into #final from                                   
(                
select code,particulars,amount,branch,tmonth,tyear,flag,entity_code,grpid=0 from #file1 where flag<>'O'                                         
union                                        
select code,particulars,Amount,branch,tmonth,tyear,flag,entity_code,grpid from #flago                                        
) a order by flag,particulars,grpid                                       
                
                
update #final set DisplayOrder=1  where flag in ('I_B2C','I_B2B')                
                
update #final set DisplayOrder=2  where flag in ('E')                
                
                
    
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='NI',entity_code,0,DisplayOrder=3 from #temp                 
where flag='net_income'                
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='FSB',entity_code,0,DisplayOrder=4                 
from #temp where flag='b2b_franch_share'                
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='FSC',entity_code,0,DisplayOrder=5                 
from #temp where flag='b2c_franch_share'                
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='TFS',entity_code,0,DisplayOrder=6                 
from #temp where flag='total_franch_share'                
                
update #final set DisplayOrder=7  where flag in ('O')                
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='EFS',entity_code,0,DisplayOrder=8                 
from #temp where flag ='expense_franch_share'                
                
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='NPL',entity_code,0,DisplayOrder=9                 
from #temp where flag ='net_pf_loss'                
                
                
update #final set DisplayOrder=10  where flag in ('N')                
                
insert into #final                
select code=0,particular,Amount,branch,tmonth,tyear,flag='JPL',entity_code,0,DisplayOrder=11                 
from #temp where flag ='jv_pf_loss'                
                
                
--select * from #final                
                
insert into #final                
select code=isnull(a.code,b.code),particulars=isnull(a.particulars,b.particulars),amount=ISNULL(amount,0),           
@branch,@tmonth,@tyear,                
flag=ISNULL(a.flag,b.flag),entity_code=ISNULL(a.entity_code,b.entity_code),                
grpid=ISNULL(grpid,0),DisplayOrder=ISNULL(DisplayOrder,1)                
 from                
(select * from #final where DisplayOrder=1)  a right outer join Vw_Rpt_Summ_Entity b                
on a.particulars=b.particulars and a.entity_code=b.entity_code                
where a.entity_code is null                
order by DisplayOrder,a.particulars                
                
                
                
select a.*,b.ENTITY_NAME into #final1                 
from #final a ,                
( select ENTITY_CODE,ENTITY_NAME=REPLACE(ENTITY_NAME,' ','_')                 
from tbl_franch_entity_mast where ENABLED_FLAG='Y') b                
where a.entity_code=b.ENTITY_CODE                
                
 /*             
SELECT particulars,flag ,               
ABL__HO=ISNULL(ABL__HO,0),                
ABL_BSECM=ISNULL(ABL_BSECM,0),                
ABL_NSECM=ISNULL(ABL_NSECM,0),                
ABL_NSEFO=ISNULL(ABL_NSEFO,0),                
ABL_NSECD=ISNULL(ABL_NSECD,0),                
ABL_MCXCD=ISNULL(ABL_MCXCD,0),                
ACBPL_HO=ISNULL(ACBPL_HO,0),                
ACBPL_NCDEX=ISNULL(ACBPL_NCDEX,0),                
ACBPL_MCX=ISNULL(ACBPL_MCX,0) ,code ,grpid               
FROM                 
    (SELECT particulars, branch, flag,ENTITY_NAME,Amount,tmonth,tyear,DisplayOrder ,code,grpid               
        FROM #final1                
                        
        ) s                 
PIVOT                 
(                 
    SUM(Amount)                 
    FOR ENTITY_NAME                 
    IN ([ABL__HO],[ABL_BSECM],[ABL_NSECM],[ABL_NSEFO],[ABL_NSECD],[ABL_MCXCD],[ACBPL_HO],[ACBPL_NCDEX],[ACBPL_MCX])                 
) p                 
ORDER BY DisplayOrder,particulars    
*/                
                
SELECT particulars,flag ,               
ABL__HO=ISNULL(ABL__HO,0),                
ABL_BSECM=ISNULL(ABL_BSECM,0),                
ABL_NSECM=ISNULL(ABL_NSECM,0),                
ABL_NSEFO=ISNULL(ABL_NSEFO,0),                
ABL_NSECD=ISNULL(ABL_NSECD,0),                
ABL_MCXCD=ISNULL(ABL_MCXCD,0),   
ABL_Total=(ISNULL(ABL__HO,0)+ISNULL(ABL_BSECM,0)+ISNULL(ABL_NSECM,0)+ISNULL(ABL_NSEFO,0)+ISNULL(ABL_NSECD,0)+ISNULL(ABL_MCXCD,0)),               
ACBPL_HO=ISNULL(ACBPL_HO,0),                
ACBPL_NCDEX=ISNULL(ACBPL_NCDEX,0),                
ACBPL_MCX=ISNULL(ACBPL_MCX,0) ,ACBPL_Total=(ISNULL(ACBPL_HO,0)+ISNULL(ACBPL_NCDEX,0)+ISNULL(ACBPL_MCX,0)),code ,grpid               
  
FROM                 
    (SELECT particulars, branch, flag,ENTITY_NAME,Amount,tmonth,tyear,DisplayOrder ,code,grpid               
        FROM #final1                
                        
        ) s                 
PIVOT                 
(                 
    SUM(Amount)                 
    FOR ENTITY_NAME                 
    IN ([ABL__HO],[ABL_BSECM],[ABL_NSECM],[ABL_NSEFO],[ABL_NSECD],[ABL_MCXCD],[ABL_Total],[ACBPL_HO],[ACBPL_NCDEX],[ACBPL_MCX],[ACBPL_Total])                 
) p                 
ORDER BY DisplayOrder,particulars

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_alterdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_creatediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_dropdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagramdefinition
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_renamediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_upgraddiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateCommoditiesPaid
-- --------------------------------------------------
create proc UpdateCommoditiesPaid  
(
	@Segment varchar(50),	
	@Ftag varchar(50),
	@Brok_paid varchar(50),
	@Brok_accrual varchar(50),
	@fromdate varchar(50),
	@todate varchar(50)
)
as
 begin
	update tbl_Franch_BKG_Paid set Brok_paid=@Brok_paid,
			Brok_accrual=@Brok_accrual,
			fromdate=@fromdate,
			todate=@todate
	where Segment=@Segment and Ftag=@Ftag
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Add_GrpName
-- --------------------------------------------------
CREATE Proc Usp_Add_GrpName(@GrpName varchar(100))
  as
  IF(SELECT COUNT(1) FROM franch_expense_grp WHERE GrpName=@GrpName)=0
  bEGIN
    insert into franch_expense_grp(GrpName) values(@GrpName)
  enD

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Add_newAccountCode
-- --------------------------------------------------
CREATE Proc Usp_Add_newAccountCode        
  as        
  insert into [Franchisee_glcode_Mast]        
  select  ACCOUNT_CODE,DESCRIPTION,'X',ACCOUNT_TYPE,GETDATE(),0 from [ABCSOORACLEMDLW].ORACLEFIN.DBO.XXANG_ANGEL_ACCOUNT_CODE        
  WHERE ACCOUNT_CODE NOT IN         
  (SELECT Code FROM [Franchisee_glcode_Mast]) AND ACCOUNT_TYPE  IN ('Income','Expense')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_disp_extra_IE
-- --------------------------------------------------

create proc Usp_disp_extra_IE
as
SELECT * FROM tbl_Franch_ExtraExpense

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
CREATE PROCEDURE usp_findInUSP            
@dbname varchar(500),          
@srcstr varchar(500)            
AS            
            
 set nocount on          
 set @srcstr  = '%' + @srcstr + '%'            
          
 declare @str as varchar(1000)          
 set @str=''          
 if @dbname <>''          
 Begin          
 set @dbname=@dbname+'.dbo.'          
 End          
 else          
 begin          
 set @dbname=db_name()+'.dbo.'          
 End          
 print @dbname          
          
 set @str='select distinct O.name,O.xtype from '+@dbname+'sysComments  C '           
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id '           
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''            
 print @str          
  exec(@str)          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Franch_ledger
-- --------------------------------------------------
    
CREATE Proc USP_Franch_ledger(@tag as varchar(12),@fydate as varchar(11),@code as varchar(12))      
as      
select  vdt=Accounting_date,entity_Name,dist_line_distribution as [narr]      
,Debit=isnull(accounted_dr,0) ,Credit=isnull(accounted_Cr,0),balamt=Convert(money,isnull(accounted_dr,0))-convert(money,isnull(accounted_Cr,0))      
,pdt=invoice_date,edt=Accounting_date,enteredby='Processed Entry'      
from [196.1.115.199].oraclefin.dbo.XXANG_ACCOUNT_DETAILS a with (nolock),      
(      
select branch_code,branchtag from [196.1.115.199].oraclefin.dbo.XXANG_ANGEL_BRANCH_CODE a with (nolock)       
where a.branchtag=@tag      
) b , tbl_franch_entity_mast c (nolock)      
where Accounting_date>=@fydate  and account_code=@code      
and a.entity_code=c.entity_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Franch_newTag_06Nov2025
-- --------------------------------------------------
CREATE Proc Usp_Franch_newTag_06Nov2025                
as                
 /*                
 select vendor_id=CONVERT(int,0),vendor_site_id=CONVERT(int,0),                
 Ftag,FName,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate,                
 Contact_person,Address1,address2,city,state,zip,contact_num1,contact_num2,email,pan_no                
 into franchisee_mast                
 from [196.1.115.182].franchisee.dbo.franchisee_mast with (nolock)                
 */                
 update tbl_franchisee_mast set vendor_id=b.vendor_id,vendor_site_id=b.vendor_site_id                 
 from [ABCSOORACLEMDLW].oraclefin.dbo.xxc_vendor_master_detail b                
 where tbl_franchisee_mast.Ftag=b.vendor_site_code and tbl_franchisee_mast.fname=SUBSTRING(b.vendor_name,1,CHARINDEX('-',b.vendor_name)-1)                
 and vendor_type_lookup_code='REM-FRANCHISEE' and tbl_franchisee_mast.vendor_id=0                
               
                
                
insert into tbl_franchisee_mast(vendor_id,vendor_site_id,Segment,FStatus,Ftag,FName,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate            
)                
 select               
 vendor_id,vendor_site_id, b.ENTITY_NAME,'Unregistered', vendor_site_code,            
             
 Vendor_name_inhouse=SUBSTRING(vendor_name,1,CHARINDEX('-',vendor_name)-1),0,0,100,'Jan 01 1900','Jan 01 1900'                
 from                 
 [ABCSOORACLEMDLW].oraclefin.dbo.xxc_vendor_master_detail a with(nolock) ,tbl_franch_entity_mast b                
 where                 
 vendor_type_lookup_code='REM-FRANCHISEE'                
 and vendor_site_code+'|'+SUBSTRING(vendor_name,1,CHARINDEX('-',vendor_name)-1) not in                
 (select ftag+'|'+Fname from tbl_franchisee_mast) and b.ENABLED_FLAG='Y' 

 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Franch_newTag_old
-- --------------------------------------------------
CREATE Proc Usp_Franch_newTag_old    
as    
 /*    
 select vendor_id=CONVERT(int,0),vendor_site_id=CONVERT(int,0),    
 Ftag,FName,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate,    
 Contact_person,Address1,address2,city,state,zip,contact_num1,contact_num2,email,pan_no    
 into franchisee_mast    
 from [196.1.115.182].franchisee.dbo.franchisee_mast with (nolock)    
 */    
 update franchisee_mast set vendor_id=b.vendor_id,vendor_site_id=b.vendor_site_id     
 from [196.1.115.219].oraclefin.dbo.xxc_vendor_master_detail b    
 where franchisee_mast.Ftag=b.vendor_site_code and franchisee_mast.fname=SUBSTRING(b.vendor_name,1,CHARINDEX('-',b.vendor_name)-1)    
 and vendor_type_lookup_code='REM-FRANCHISEE' and franchisee_mast.vendor_id=0    
    
 insert into franchisee_mast(vendor_id,vendor_site_id,ftag,fname,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate)    
 select     
 vendor_id,vendor_site_id,vendor_site_code,Vendor_name_inhouse=SUBSTRING(vendor_name,1,CHARINDEX('-',vendor_name)-1),0,0,100,'Jan 01 1900','Jan 01 1900'    
 from     
 [196.1.115.219].oraclefin.dbo.xxc_vendor_master_detail with(nolock)     
 where     
 vendor_type_lookup_code='REM-FRANCHISEE'    
 and vendor_site_code+'|'+SUBSTRING(vendor_name,1,CHARINDEX('-',vendor_name)-1) not in    
 (select ftag+'|'+Fname from franchisee_mast)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Franch_newTag_tobedeleted09jan2026
-- --------------------------------------------------
CREATE Proc Usp_Franch_newTag                
as                
 /*                
 select vendor_id=CONVERT(int,0),vendor_site_id=CONVERT(int,0),                
 Ftag,FName,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate,                
 Contact_person,Address1,address2,city,state,zip,contact_num1,contact_num2,email,pan_no                
 into franchisee_mast                
 from [196.1.115.182].franchisee.dbo.franchisee_mast with (nolock)                
 */   
 insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

 update tbl_franchisee_mast set vendor_id=b.vendor_id,vendor_site_id=b.vendor_site_id                 
 from [ABCSOORACLEMDLW].oraclefin.dbo.xxc_vendor_master_detail b                
 where tbl_franchisee_mast.Ftag=b.vendor_site_code and tbl_franchisee_mast.fname=SUBSTRING(b.vendor_name,1,CHARINDEX('-',b.vendor_name)-1)                
 and vendor_type_lookup_code='REM-FRANCHISEE' and tbl_franchisee_mast.vendor_id=0                
               
                
                
insert into tbl_franchisee_mast(vendor_id,vendor_site_id,Segment,FStatus,Ftag,FName,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate            
)                
 select               
 vendor_id,vendor_site_id, b.ENTITY_NAME,'Unregistered', vendor_site_code,            
             
 Vendor_name_inhouse=SUBSTRING(vendor_name,1,CHARINDEX('-',vendor_name)-1),0,0,100,'Jan 01 1900','Jan 01 1900'                
 from                 
 [ABCSOORACLEMDLW].oraclefin.dbo.xxc_vendor_master_detail a with(nolock) ,tbl_franch_entity_mast b                
 where                 
 vendor_type_lookup_code='REM-FRANCHISEE'                
 and vendor_site_code+'|'+SUBSTRING(vendor_name,1,CHARINDEX('-',vendor_name)-1) not in                
 (select ftag+'|'+Fname from tbl_franchisee_mast) and b.ENABLED_FLAG='Y' 

 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Franch_summary
-- --------------------------------------------------
CREATE Procedure USP_Franch_summary(@tdate as varchar(25))                                                      
as                                                      
/*  
exec USP_Franch_summary '6/30/2011 12:00:00 AM'   
declare @tdate as varchar(25)                                                      
Set @tdate='Mar 31 2011'                                         
*/                                                    
                                                
 --set  @tdate=convert(varchar(11),cONVERT(datetime,@tdate))
                              
Set transaction isolation level read uncommitted                 
---------------------------------------BSE---------------------------------------------------------------------------------                                                   
                                                      
select a.code,a.particulars,amount,branch,tmonth,tyear,flag,a.entity_code, c.vendor_id                                                      
into #withflag                                                      
from tbl_Franchisee_calc a(nolock)  ,Franchisee_glcode_Mast b , Vw_Franchisee_mast_entity   c                                                 
where a.code=b.Code and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)       
and  a.branch=c.ftag and a.entity_code=c.entity_code           
and c.todate>=@tdate    
      
/*select * from Vw_Franchisee_entity_mast      
      
select* from Franchisee_glcode_Mast where particulars like '%paid%'       
*/            
/*      
if @flag='E'            
Begin              
 insert into #bse              
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))              
 ,datepart(yy,convert(datetime,@tdate))              
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate              
 and ftag not in (select branch from #bse where ABLCODE='520013' )              
               
 insert into #bse              
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))              
 ,datepart(yy,convert(datetime,@tdate))              
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate              
 and ftag not in (select branch from #bse where ABLCODE='520011')             
END                                                   
                                        
select ABLCODE,particulars,ABLCM=case when ABLCODE='520013'  then isnull(ABLCM,0)-isnull(bsecm_ba,0)                                            
when ABLCODE='520011'  then isnull(ABLCM,0)-isnull(bsecm_bp,0)                                            
else ABLCM end                                            
,branch=isnull(branch,ftag),tmonth,tyear                                            
into #bse1                                            
from #bse  a                                                   
full outer join                                             
BKG_PAID b                                            
on a.branch=b.ftag                                         
*/                                        
               
--------------------------------NSE----------------------------------------------------------------------------------------------              
      
select a.* into #fina  from #withflag a                                  
left outer join                                   
(select * from Vw_franch_exclude_extraexpense ) b                                  
on a.code=b.code and a.branch=b.ftag and a.entity_code=b.entity_code                              
where b.code is  null       
                                  
                
                         
 if (select count(1) from #fina where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and code='511104')=0                
 BEGIN                
 insert into #fina                
 select code='511104',particulars='Brokerage Paid - Franchisee',                                                    
 Amount=0 ,                                               
 branch=ftag,                              
 tmonth=datepart(mm,@tdate),                                                    
 tyear=datepart(yy,@tdate),                                                
 flag='N',entity_code ,vendor_id     
 from Vw_franchisee_mast_entity  (nolock)                
 where todate>getdate()                   
 END                                              
      
/*==================franch_final_cal ===========================================*/       
      
select particulars,                           
Amount=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                               
and flag='O' then round(-sum(Amount),0) when sum(Amount)<0 and flag in ('I_B2B','I_B2C')                                              
then round(-sum(Amount),0) else round(sum(Amount),0) end ,                           
flag,branch,tmonth,tyear,entity_code, vendor_id     
into #file2                                     
from dbo.#fina(nolock)                                               
where   flag in ('I_B2B','I_B2C','E','O')                    
group by particulars,flag,branch,tmonth,tyear,entity_code  , vendor_id         
            
      
select * into #all from #file2      
            
select *      
into #I_B2C                
from #file2               
where flag='I_B2C'             
            
        
select*      
into #OPERATIONAL_EXPENSES         
from  #file2 where flag='O'        
      
                  
select Amount=sum(isnull(a.Amount,0)-isnull(b.Amount,0))           
,flag='I_B2B',a.branch,a.tmonth,a.tyear   ,a.entity_code , a.vendor_id             
into #I_B2B                
from  #all a                
left outer join                
(select * from  #all where flag in ('E')) b                
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear   and    a.entity_code=b.entity_code and a.vendor_id=b.vendor_id          
where a.flag in ('I_B2B')                
group by a.branch,a.tmonth,a.tyear ,a.entity_code, a.vendor_id                    
                
select particular='NET INCOME',Amount=sum(isnull(a.Amount,0)+isnull(b.Amount,0))                
, a.branch,a.tmonth,a.tyear,flag='net_income',a.entity_code , a.vendor_id into #netincome from                
(select * from  #I_B2B where flag ='I_B2B')a                
left outer join                
(select * from  #all where flag ='I_B2c')b                
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear     and    a.entity_code=b.entity_code    and a.vendor_id=b.vendor_id        
group by a.branch,a.tmonth,a.tyear ,a.entity_code , a.vendor_id                   
                
--drop table #netincome      
               
              
                
select particular='Franchisees Share @ '+ convert(varchar(11),b.b2b_incomepercent) +'% (B2B)'+ b.fname ,      
Amount=a.Amount*(b.b2b_incomepercent/100)                 
,branch,tmonth,tyear,flag='b2b_franch_share',a.entity_code , a.vendor_id                
 into #b2b_franch_share                
 from                
(select * from #I_B2B where flag ='I_B2B') a                
left outer join                
( select * from Vw_franchisee_mast_entity )b                
on a.branch=b.ftag and a.entity_code=b.entity_code   and a.vendor_id=b.vendor_id            
                
      
select particular='Franchisees Share @ '+ convert(varchar(11),b.b2c_incomepercent) +'% (B2C)'+ b.fname,      
Amount=a.Amount*(b.b2c_incomepercent/100) ,branch,tmonth,tyear,flag='b2c_franch_share'  ,a.entity_code   , a.vendor_id              
into #b2c_franch_share        
 from                
(select * from #I_B2C) a                
left outer join                
(select * from Vw_franchisee_mast_entity  )b                
on a.branch=b.ftag   and a.entity_code=b.entity_code   and a.vendor_id=b.vendor_id                  
                
                
 select particular='Total Franchisee share',      
 Amount=sum(isnull(a.Amount,0)+isnull(b.Amount,0))               
,a.branch,a.tmonth,a.tyear,flag='total_franch_share',  a.entity_code  , a.vendor_id               
into #total_franch_share                 
from #b2c_franch_share a,#b2b_franch_share b            
where a.branch=b.branch  and a.tmonth=b.tmonth and a.tyear=b.tyear   and a.entity_code=b.entity_code   and a.vendor_id=b.vendor_id       
group by a.branch,a.tmonth,a.tyear ,a.entity_code  , a.vendor_id                 
                
                
                
select particular='Franchisees Share @ '+ convert(varchar(11),b.expenseshare) +'%'+b.fname,      
Amount=a.Amount*(b.expenseshare/100)                 
,branch,tmonth,tyear,flag='expense_franch_share',a.entity_code , a.vendor_id                     
into #expense_franch_share from                
(select * from #OPERATIONAL_EXPENSES) a                
left outer join                
(select * from Vw_franchisee_mast_entity  )b          
on a.branch=b.ftag      and a.entity_code=b.entity_code   and a.vendor_id=b.vendor_id       
                
                
 select particular='Net Profit/(Loss)',Amount=sum(isnull(a.Amount,0)-isnull(b.Amount,0))               
, a.branch,a.tmonth,a.tyear,flag='net_pf_loss' ,a.entity_code   , a.vendor_id                 
into #net_pf_loss                 
from #total_franch_share a left join #expense_franch_share b           
on  a.branch=b.branch  and a.tmonth=b.tmonth and a.tyear=b.tyear  and a.entity_code=b.entity_code  and a.vendor_id=b.vendor_id        
group by a.branch,a.tmonth,a.tyear        ,a.entity_code , a.vendor_id         
              
        
              
select particular='JV to be passed Profit/(Loss)',Amount=sum(isnull(a.Amount,0)-isnull(b.Amount,0))                
 ,a.branch,a.tmonth,a.tyear ,flag='jv_pf_loss'  ,a.entity_code  , a.vendor_id               
into #jv_pf_loss              
from  #net_pf_loss a                
left outer join                
(select * from dbo.#fina(nolock)                                               
where  flag in ('N')) b                
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear  and a.entity_code=b.entity_code   and a.vendor_id=b.vendor_id           
group by a.branch,a.tmonth,a.tyear  ,a.entity_code    , a.vendor_id            
                
select * into #final from      
(         
 select  particular='Operational Expense',Amount,branch,tmonth,tyear,flag,entity_code,vendor_id from #OPERATIONAL_EXPENSES        
 union            
 select *  from #netincome              
 union              
 select * from  #b2b_franch_share              
 union              
 select * from  #b2c_franch_share              
 union              
 select * from #total_franch_share              
 union              
 select * from #expense_franch_share              
 union              
 select * from #net_pf_loss              
 union              
 select * from #jv_pf_loss              
) a               
                
select a.*,b.ENTITY_NAME into #final1 from #final a ,      
( select ENTITY_CODE,ENTITY_NAME=REPLACE(ENTITY_NAME,' ','_')       
from tbl_franch_entity_mast where ENABLED_FLAG='Y') b      
where a.entity_code=b.ENTITY_CODE      
      
--select * into tbl_Franch_Final from #final1      
      
delete from tbl_Franch_Final where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)       
      
insert into tbl_Franch_Final      
select particular,Amount,branch,tmonth,tyear,flag,entity_code,ENTITY_NAME,vendor_id  from #final1      
/*      
SELECT particular,branch,flag,      
ABL__HO=ISNULL(ABL__HO,0),      
ABL_BSECM=ISNULL(ABL_BSECM,0),      
ABL_NSECM=ISNULL(ABL_NSECM,0),      
ABL_NSEFO=ISNULL(ABL_NSEFO,0),      
ABL_NSECD=ISNULL(ABL_NSECD,0),      
ABL_MCXCD=ISNULL(ABL_MCXCD,0),      
ACBPL_HO=ISNULL(ACBPL_HO,0),      
ACBPL_NCDEX=ISNULL(ACBPL_NCDEX,0),      
ACBPL_MCX=ISNULL(ACBPL_MCX,0),tmonth,tyear      
FROM       
    (SELECT particular, branch, flag,ENTITY_NAME,Amount,tmonth,tyear      
        FROM #final1) s       
PIVOT       
(       
    SUM(Amount)       
    FOR ENTITY_NAME       
    IN ([ABL__HO],[ABL_BSECM],[ABL_NSECM],[ABL_NSEFO],[ABL_NSECD],[ABL_MCXCD],[ACBPL_HO],[ACBPL_NCDEX],[ACBPL_MCX])       
) p       
ORDER BY branch,particular      
GO      
*/                                                    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetFranchDetails
-- --------------------------------------------------
CREATE proc usp_GetFranchDetails    
(    
 @tag varchar(50),
 @vendorid varchar(15) =null   
)    
as    
begin    
set nocount on     
   
 select *  
 from tbl_Franchisee_mast where Ftag=@tag and vendor_id = isnull(@vendorid,vendor_id)   
     
 select distinct a.*,b.Ftag,b.FName from tbl_Franchisee_Contact a     
  inner join tbl_Franchisee_mast b    
 on a.vendor_site_id =b.vendor_site_id    
 where b.Ftag=@tag and b.vendor_id = isnull(@vendorid,b.vendor_id)      
set nocount off    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_insert_Exclude_extra_IE
-- --------------------------------------------------

create proc Usp_insert_Exclude_extra_IE
(
@code as varchar(12),
@segment as varchar(50),
@ftag as varchar(8)
)

as
/*
Created by : Rozina Raje
Created on : 26 mar 2011
*/
/*
declare @particular as varchar(100),
@amt as money,
@tpe as varchar(50),
@ftag as varchar(8),
@month as int,
@year as int,
@segment as varchar(50)


set @particular='test'
set @amt='50000'
set @tpe='0'
set @ftag='AHD'
set @month='03'
set @year='2011'
set @segment='ABL BSECM'
*/
delete from tbl_franch_exclude_extraexpense where ftag=@ftag and segment=@segment and code=@code

INSERT INTO tbl_franch_exclude_extraexpense values(0,@ftag,@code,
@segment)
update tbl_franch_exclude_extraexpense set vendor_id=b.vendor_id from tbl_Franchisee_mast b
where tbl_franch_exclude_extraexpense.ftag=@ftag  and tbl_franch_exclude_extraexpense.code=@code 
and tbl_franch_exclude_extraexpense.segment=@segment
 and tbl_franch_exclude_extraexpense.ftag=b.ftag

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_insert_extra_IE
-- --------------------------------------------------

CREATE proc Usp_insert_extra_IE
(
@particular as varchar(100),
@amt as money,
@segment as varchar(50),
@tpe as varchar(50),
@ftag as varchar(8),
@month as int,
@year as int
)

as
/*
Created by : Rozina Raje
Created on : 26 mar 2011
*/
/*
declare @particular as varchar(100),
@amt as money,
@tpe as varchar(50),
@ftag as varchar(8),
@month as int,
@year as int,
@segment as varchar(50)


set @particular='test'
set @amt='50000'
set @tpe='0'
set @ftag='AHD'
set @month='03'
set @year='2011'
set @segment='ABL BSECM'
*/
delete from tbl_Franch_ExtraExpense where ftag=@ftag and segment=@segment and  month=@month and year=@year and particular=@particular 

INSERT INTO tbl_Franch_ExtraExpense values(0,@particular,@amt,
@tpe,@ftag,@month,@year,@segment)
update tbl_Franch_ExtraExpense set vendor_id=b.vendor_id from tbl_Franchisee_mast b
where tbl_Franch_ExtraExpense.ftag=@ftag and tbl_Franch_ExtraExpense.segment=@segment and  tbl_Franch_ExtraExpense.month=@month and tbl_Franch_ExtraExpense.year=@year and tbl_Franch_ExtraExpense.particular=@particular 
and tbl_Franch_ExtraExpense.segment=b.segment and tbl_Franch_ExtraExpense.ftag=b.ftag

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JV_Invoice_06Nov2025
-- --------------------------------------------------
CREATE Proc USP_JV_Invoice_06Nov2025(@month as int,@year as int )          
as          
          
          
          
select a.*,Company=substring(entity_name,1,CHARINDEX('_',entity_name)-1) into #ff           
from tbl_Franch_Final a join Vw_franchisee_mast_entity b          
on a.vendor_id=b.vendor_id and a.branch=b.ftag and a.entity_code=b.entity_code          
where tmonth=@month and tyear=@year and flag ='jv_pf_loss'                        
and fstatus='Registered'  and Amount>0          
          
          
Select                             
--c.invoice_number as INVOICE_NUM,            
'STANDARD' as INVOICE_TYPE_LOOKUP_CODE,                                
dbo.getlastdate(@month,@year) as INVOICE_DATE,                       
v.vendor_number as VENDOR_NUM,                      
v.VENDOR_SITE_CODE as VENDOR_SITE_CODE,                        
(CONVERT(DECIMAL,C.Amount) ) as INVOICE_AMOUNT,                   
'INR' as INVOICE_CURRENCY_CODE,                                
'Immediate' as TERMS_NAME,                                
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+''  AS Description,                                  
'NEVER VALIDATED' AS STATUS,                        
'REM-FRANCHISEE' AS source,                                
'STD INV' as DOC_CATEGORY_CODE,                                  
NULL as PAYMENT_METHOD_LOOKUP_CODE,          
dbo.getlastdate(@month,@year) as GL_DATE,                                  
 v.ORG_ID as ORG_ID,                      
'1' as LINE_NUMBER,                                
'ITEM' as LINE_TYPE_LOOKUP_CODE,                                  
(CONVERT(DECIMAL,C.Amount) ) as LINE_AMOUNT,                      
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+'' as Line_DESCRIPTION,                       
NULL as DIST_LINE_NUMBER,                              
NULL as DIST_AMOUNT,          
(select                                  
CASE WHEN c.company = 'ABL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ABL  HO')                                
WHEN c.company = 'ACBPL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ACBPL HO')                                
end                              
+ '-' +(SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Account' AND DESCRIPTION = 'Brokerage Paid - Franchisee')                                
+ '-' +(select top 1 isnull( convert(varchar,CODE),'99999999')  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Branch' AND DESCRIPTION  like ('%'+c.branch+'%'))                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'dept')                                
+ '-' +(SELECT convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'LOB' AND DESCRIPTION = 'Unspecified')                                
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'intercompany')                                
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'channel' and description='Unspecified' )                                
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'project' )                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future1')                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future2')                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future3')          
) as DIST_CODE_CONCATENATED                       
          
,dbo.getlastdate(@month,@year) as ACCOUNTING_DATE,                        
NULL as DIST_DESCRIPTION,                       
NULL as PAY_GROUP_LOOKUP_CODE,                      
NULL as SEGMENT_1,                      
NULL as SEGMENT_2,              
NULL as SEGMENT_3,                      
NULL as SEGMENT_4,                      
NULL as SEGMENT_5,              
NULL as SEGMENT_6,                      
NULL as SEGMENT_7,                      
NULL as SEGMENT_8,                      
NULL as SEGMENT_9,                      
NULL as SEGMENT_10,                      
NULL as SEGMENT_11,                      
NULL as ASSETS_TRACKING_FLAG,                      
'Franchisee' as ATTRIBUTE_CATEGORY,                                  
NULL as ATTRIBUTE1 ,                                  
'Y' as ATTRIBUTE2,                                
NULL as ATTRIBUTE3,                                
NULL as ATTRIBUTE4,                                  
NULL as ATTRIBUTE5,                       
NULL as ATTRIBUTE6,                      
NULL as ATTRIBUTE7,                      
GETDATE()  as ATTRIBUTE8,                      
NULL as ATTRIBUTE9,                      
NULL as ATTRIBUTE10,                      
NULL as ATTRIBUTE11,                      
NULL as ATTRIBUTE12,                      
NULL as ATTRIBUTE13,                      
NULL as ATTRIBUTE14,                      
NULL as ATTRIBUTE15,                      
NULL as DIST_ATTRIBUTE_CATEGORY ,                                 
NULL as DIST_ATTRIBUTE1 ,                                  
NULL as DIST_ATTRIBUTE2 ,                                  
NULL as DIST_ATTRIBUTE3 ,                                  
NULL as DIST_ATTRIBUTE4 ,                                  
NULL as DIST_ATTRIBUTE5 ,                       
NULL as DIST_GLOBAL_ATT_CATEGORY ,                                  
NULL as GLOBAL_ATTRIBUTE1 ,                                  
NULL as GLOBAL_ATTRIBUTE2 ,                                  
NULL as GLOBAL_ATTRIBUTE3 ,                                  
NULL as GLOBAL_ATTRIBUTE4 ,                                  
NULL as GLOBAL_ATTRIBUTE5 ,                      
NULL as PREPAY_NUM,                      
NULL as PREPAY_DIST_NUM,                                  
NULL as PREPAY_APPLY_AMOUNT ,                        
NULL as PREPAY_GL_DATE ,                         
NULL as INVOICE_INCLUDES_PREPAY_FLAG,                                   
NULL as PREPAY_LINE_NUM,                       
'Franch_Sys' as CREATED_BY ,                       
GETDATE() as CREATION_DATE ,                      
NULL as PROCESSED_STATUS,                      
NULL as ERROR_MESSAGE,                      
NULL as INVOICE_STATUS,                      
NULL as BATCH_NAME                      
from #ff c inner join [ABCSOORACLEMDLW].oraclefin.dbo.XXC_VENDOR_MASTER_DETAIL v                          
on  v.vendor_site_code = c.branch       and v.vendor_id = c.vendor_id          
where v.vendor_type_lookup_code='REM-FRANCHISEE' 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JV_Invoice_Registered_06Nov2025
-- --------------------------------------------------
  CREATE Proc USP_JV_Invoice_Registered_06Nov2025 (@month as int,@year as int )              
as              
              
              
              
select row_number() OVER (ORDER BY branch) as srno,a.*,Company=substring(entity_name,1,CHARINDEX('_',entity_name)-1) into #ff               
from tbl_Franch_Final a join Vw_franchisee_mast_entity b              
on a.vendor_id=b.vendor_id and a.branch=b.ftag and a.entity_code=b.entity_code              
where tmonth=@month and tyear=@year and flag ='jv_pf_loss'                            
and fstatus='Registered'  and Amount>0              
              
              
Select                                 
--c.invoice_number as INVOICE_NUM,                
Convert(varchar,(datepart(year,getdate())))+                              
(CASE WHEN Company = 'ABL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ABL  HO')                                  
WHEN Company = 'ACBPL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ACBPL HO')                                  
end)+'12'+                              
/*(case when srno < 10 then '00000'+ convert(varchar,srno)                              
   when srno < 100 then '0000'+ convert(varchar,srno)                             
   when srno < 1000 then '000'+ convert(varchar,srno)                              
   when srno < 10000 then '00'+ convert(varchar,srno)                              
   when srno < 100000 then '0'+ convert(varchar,srno)                              
   else convert(varchar,srno) end) as INVOICE_NUM*/          
   (replicate('0',6-len(srno))+convert(varchar,srno)) as INVOICE_NUM          
   ,            
'STANDARD' as INVOICE_TYPE_LOOKUP_CODE,                                    
dbo.getlastdate(@month,@year) as INVOICE_DATE,                           
v.vendor_number as VENDOR_NUM,                          
v.VENDOR_SITE_CODE as VENDOR_SITE_CODE,                            
(CONVERT(DECIMAL,C.Amount) ) as INVOICE_AMOUNT,                       
'INR' as INVOICE_CURRENCY_CODE,                                    
'Immediate' as TERMS_NAME,                                    
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+''  AS Description,                                      
'NEVER VALIDATED' AS STATUS,                            
'REM-FRANCHISEE' AS source,                                    
'STD INV' as DOC_CATEGORY_CODE,                                      
NULL as PAYMENT_METHOD_LOOKUP_CODE,              
dbo.getlastdate(@month,@year) as GL_DATE,                                      
 v.ORG_ID as ORG_ID,                          
'1' as LINE_NUMBER,                                    
'ITEM' as LINE_TYPE_LOOKUP_CODE,                                      
(CONVERT(DECIMAL,C.Amount) ) as LINE_AMOUNT,                          
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+'' as Line_DESCRIPTION,                           
NULL as DIST_LINE_NUMBER,                                  
NULL as DIST_AMOUNT,              
(select                                      
CASE WHEN c.company = 'ABL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ABL  HO')                                    
WHEN c.company = 'ACBPL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ACBPL HO')                                    
end                                  
+ '-' +(SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Account' AND DESCRIPTION = 'Brokerage Paid - Franchisee')                                    
+ '-' +(select top 1 isnull( convert(varchar,CODE),'99999999')  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Branch' AND DESCRIPTION  like ('%'+c.branch+'%'))           
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'dept')                                    
+ '-' +(SELECT convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'LOB' AND DESCRIPTION = 'Unspecified')                                    
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'intercompany')                                    
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'channel' and description='Unspecified' )                                    
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'project' )                                    
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future1')                                    
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future2')                                    
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future3')              
) as DIST_CODE_CONCATENATED                           
              
,dbo.getlastdate(@month,@year) as ACCOUNTING_DATE,                            
NULL as DIST_DESCRIPTION,                           
NULL as PAY_GROUP_LOOKUP_CODE,                          
NULL as SEGMENT_1,                          
NULL as SEGMENT_2,                          
NULL as SEGMENT_3,                          
NULL as SEGMENT_4,                          
NULL as SEGMENT_5,                          
NULL as SEGMENT_6,                          
NULL as SEGMENT_7,                          
NULL as SEGMENT_8,                          
NULL as SEGMENT_9,                          
NULL as SEGMENT_10,                          
NULL as SEGMENT_11,                          
NULL as ASSETS_TRACKING_FLAG,                          
'Franchisee' as ATTRIBUTE_CATEGORY,                                      
NULL as ATTRIBUTE1 ,                                      
'Y' as ATTRIBUTE2,                                    
NULL as ATTRIBUTE3,                                    
NULL as ATTRIBUTE4,                                      
NULL as ATTRIBUTE5,                           
NULL as ATTRIBUTE6,                          
NULL as ATTRIBUTE7,                          
GETDATE()  as ATTRIBUTE8,                          
NULL as ATTRIBUTE9,                          
NULL as ATTRIBUTE10,                          
NULL as ATTRIBUTE11,                          
NULL as ATTRIBUTE12,                          
NULL as ATTRIBUTE13,                          
NULL as ATTRIBUTE14,                          
NULL as ATTRIBUTE15,                          
NULL as DIST_ATTRIBUTE_CATEGORY ,                                     
NULL as DIST_ATTRIBUTE1 ,                                      
NULL as DIST_ATTRIBUTE2 ,                                      
NULL as DIST_ATTRIBUTE3 ,                                      
NULL as DIST_ATTRIBUTE4 ,                                      
NULL as DIST_ATTRIBUTE5 ,                           
NULL as DIST_GLOBAL_ATT_CATEGORY ,                                      
NULL as GLOBAL_ATTRIBUTE1 ,                                      
NULL as GLOBAL_ATTRIBUTE2 ,                                      
NULL as GLOBAL_ATTRIBUTE3 ,                                      
NULL as GLOBAL_ATTRIBUTE4 ,                                      
NULL as GLOBAL_ATTRIBUTE5 ,                          
NULL as PREPAY_NUM,                          
NULL as PREPAY_DIST_NUM,                                      
NULL as PREPAY_APPLY_AMOUNT ,                            
NULL as PREPAY_GL_DATE ,                             
NULL as INVOICE_INCLUDES_PREPAY_FLAG,                                       
NULL as PREPAY_LINE_NUM,                           
'Franch_Sys' as CREATED_BY ,                           
GETDATE() as CREATION_DATE ,                          
NULL as PROCESSED_STATUS,                          
NULL as ERROR_MESSAGE,               
NULL as INVOICE_STATUS,                          
NULL as BATCH_NAME                          
from #ff c inner join [ABCSOORACLEMDLW].oraclefin.dbo.XXC_VENDOR_MASTER_DETAIL v                              
on  v.vendor_site_code = c.branch       and v.vendor_id = c.vendor_id              
where v.vendor_type_lookup_code='REM-FRANCHISEE' 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JV_Invoice_Registered_tobedeleted09jan2026
-- --------------------------------------------------
  CREATE Proc USP_JV_Invoice_Registered(@month as int,@year as int )              
as              
              
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())              
              
select row_number() OVER (ORDER BY branch) as srno,a.*,Company=substring(entity_name,1,CHARINDEX('_',entity_name)-1) into #ff               
from tbl_Franch_Final a join Vw_franchisee_mast_entity b              
on a.vendor_id=b.vendor_id and a.branch=b.ftag and a.entity_code=b.entity_code              
where tmonth=@month and tyear=@year and flag ='jv_pf_loss'                            
and fstatus='Registered'  and Amount>0              
              
              
Select                                 
--c.invoice_number as INVOICE_NUM,                
Convert(varchar,(datepart(year,getdate())))+                              
(CASE WHEN Company = 'ABL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ABL  HO')                                  
WHEN Company = 'ACBPL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ACBPL HO')                                  
end)+'12'+                              
/*(case when srno < 10 then '00000'+ convert(varchar,srno)                              
   when srno < 100 then '0000'+ convert(varchar,srno)                             
   when srno < 1000 then '000'+ convert(varchar,srno)                              
   when srno < 10000 then '00'+ convert(varchar,srno)                              
   when srno < 100000 then '0'+ convert(varchar,srno)                              
   else convert(varchar,srno) end) as INVOICE_NUM*/          
   (replicate('0',6-len(srno))+convert(varchar,srno)) as INVOICE_NUM          
   ,            
'STANDARD' as INVOICE_TYPE_LOOKUP_CODE,                                    
dbo.getlastdate(@month,@year) as INVOICE_DATE,                           
v.vendor_number as VENDOR_NUM,                          
v.VENDOR_SITE_CODE as VENDOR_SITE_CODE,                            
(CONVERT(DECIMAL,C.Amount) ) as INVOICE_AMOUNT,                       
'INR' as INVOICE_CURRENCY_CODE,                                    
'Immediate' as TERMS_NAME,                                    
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+''  AS Description,                                      
'NEVER VALIDATED' AS STATUS,                            
'REM-FRANCHISEE' AS source,                                    
'STD INV' as DOC_CATEGORY_CODE,                                      
NULL as PAYMENT_METHOD_LOOKUP_CODE,              
dbo.getlastdate(@month,@year) as GL_DATE,                                      
 v.ORG_ID as ORG_ID,                          
'1' as LINE_NUMBER,                                    
'ITEM' as LINE_TYPE_LOOKUP_CODE,                                      
(CONVERT(DECIMAL,C.Amount) ) as LINE_AMOUNT,                          
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+'' as Line_DESCRIPTION,                           
NULL as DIST_LINE_NUMBER,                                  
NULL as DIST_AMOUNT,              
(select                                      
CASE WHEN c.company = 'ABL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ABL  HO')                                    
WHEN c.company = 'ACBPL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ACBPL HO')                                    
end                                  
+ '-' +(SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Account' AND DESCRIPTION = 'Brokerage Paid - Franchisee')                                    
+ '-' +(select top 1 isnull( convert(varchar,CODE),'99999999')  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Branch' AND DESCRIPTION  like ('%'+c.branch+'%'))           
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'dept')                                    
+ '-' +(SELECT convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'LOB' AND DESCRIPTION = 'Unspecified')                                    
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'intercompany')                                    
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'channel' and description='Unspecified' )                                    
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'project' )                                    
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future1')                                    
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future2')                                    
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future3')              
) as DIST_CODE_CONCATENATED                           
              
,dbo.getlastdate(@month,@year) as ACCOUNTING_DATE,                            
NULL as DIST_DESCRIPTION,                           
NULL as PAY_GROUP_LOOKUP_CODE,                          
NULL as SEGMENT_1,                          
NULL as SEGMENT_2,                          
NULL as SEGMENT_3,                          
NULL as SEGMENT_4,                          
NULL as SEGMENT_5,                          
NULL as SEGMENT_6,                          
NULL as SEGMENT_7,                          
NULL as SEGMENT_8,                          
NULL as SEGMENT_9,                          
NULL as SEGMENT_10,                          
NULL as SEGMENT_11,                          
NULL as ASSETS_TRACKING_FLAG,                          
'Franchisee' as ATTRIBUTE_CATEGORY,                                      
NULL as ATTRIBUTE1 ,                                      
'Y' as ATTRIBUTE2,                                    
NULL as ATTRIBUTE3,                                    
NULL as ATTRIBUTE4,                                      
NULL as ATTRIBUTE5,                           
NULL as ATTRIBUTE6,                          
NULL as ATTRIBUTE7,                          
GETDATE()  as ATTRIBUTE8,                          
NULL as ATTRIBUTE9,                          
NULL as ATTRIBUTE10,                          
NULL as ATTRIBUTE11,                          
NULL as ATTRIBUTE12,                          
NULL as ATTRIBUTE13,                          
NULL as ATTRIBUTE14,                          
NULL as ATTRIBUTE15,                          
NULL as DIST_ATTRIBUTE_CATEGORY ,                                     
NULL as DIST_ATTRIBUTE1 ,                                      
NULL as DIST_ATTRIBUTE2 ,                                      
NULL as DIST_ATTRIBUTE3 ,                                      
NULL as DIST_ATTRIBUTE4 ,                                      
NULL as DIST_ATTRIBUTE5 ,                           
NULL as DIST_GLOBAL_ATT_CATEGORY ,                                      
NULL as GLOBAL_ATTRIBUTE1 ,                                      
NULL as GLOBAL_ATTRIBUTE2 ,                                      
NULL as GLOBAL_ATTRIBUTE3 ,                                      
NULL as GLOBAL_ATTRIBUTE4 ,                                      
NULL as GLOBAL_ATTRIBUTE5 ,                          
NULL as PREPAY_NUM,                          
NULL as PREPAY_DIST_NUM,                                      
NULL as PREPAY_APPLY_AMOUNT ,                            
NULL as PREPAY_GL_DATE ,                             
NULL as INVOICE_INCLUDES_PREPAY_FLAG,                                       
NULL as PREPAY_LINE_NUM,                           
'Franch_Sys' as CREATED_BY ,                           
GETDATE() as CREATION_DATE ,                          
NULL as PROCESSED_STATUS,                          
NULL as ERROR_MESSAGE,               
NULL as INVOICE_STATUS,                          
NULL as BATCH_NAME                          
from #ff c inner join [ABCSOORACLEMDLW].oraclefin.dbo.XXC_VENDOR_MASTER_DETAIL v                              
on  v.vendor_site_code = c.branch       and v.vendor_id = c.vendor_id              
where v.vendor_type_lookup_code='REM-FRANCHISEE' 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JV_Invoice_tobedeleted09jan2026
-- --------------------------------------------------
CREATE Proc USP_JV_Invoice(@month as int,@year as int )          
as          
          
          
 insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

select a.*,Company=substring(entity_name,1,CHARINDEX('_',entity_name)-1) into #ff           
from tbl_Franch_Final a join Vw_franchisee_mast_entity b          
on a.vendor_id=b.vendor_id and a.branch=b.ftag and a.entity_code=b.entity_code          
where tmonth=@month and tyear=@year and flag ='jv_pf_loss'                        
and fstatus='Registered'  and Amount>0          
          
          
Select                             
--c.invoice_number as INVOICE_NUM,            
'STANDARD' as INVOICE_TYPE_LOOKUP_CODE,                                
dbo.getlastdate(@month,@year) as INVOICE_DATE,                       
v.vendor_number as VENDOR_NUM,                      
v.VENDOR_SITE_CODE as VENDOR_SITE_CODE,                        
(CONVERT(DECIMAL,C.Amount) ) as INVOICE_AMOUNT,                   
'INR' as INVOICE_CURRENCY_CODE,                                
'Immediate' as TERMS_NAME,                                
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+''  AS Description,                                  
'NEVER VALIDATED' AS STATUS,                        
'REM-FRANCHISEE' AS source,                                
'STD INV' as DOC_CATEGORY_CODE,                                  
NULL as PAYMENT_METHOD_LOOKUP_CODE,          
dbo.getlastdate(@month,@year) as GL_DATE,                                  
 v.ORG_ID as ORG_ID,                      
'1' as LINE_NUMBER,                                
'ITEM' as LINE_TYPE_LOOKUP_CODE,                                  
(CONVERT(DECIMAL,C.Amount) ) as LINE_AMOUNT,                      
'Provision to '+v.VENDOR_SITE_CODE+' Branch for '+convert(varchar(2),@month)+' '+convert(varchar(4),@year)+'' as Line_DESCRIPTION,                       
NULL as DIST_LINE_NUMBER,                              
NULL as DIST_AMOUNT,          
(select                                  
CASE WHEN c.company = 'ABL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ABL  HO')                                
WHEN c.company = 'ACBPL' THEN (SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'ENTITY' AND DESCRIPTION = 'ACBPL HO')                                
end                              
+ '-' +(SELECT convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Account' AND DESCRIPTION = 'Brokerage Paid - Franchisee')                                
+ '-' +(select top 1 isnull( convert(varchar,CODE),'99999999')  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'Branch' AND DESCRIPTION  like ('%'+c.branch+'%'))                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'dept')                                
+ '-' +(SELECT convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'LOB' AND DESCRIPTION = 'Unspecified')                                
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'intercompany')                                
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'channel' and description='Unspecified' )                                
+ '-' +(select convert(varchar,CODE) FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'project' )                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future1')                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future2')                                
+ '-' +(select convert(varchar,CODE)  FROM mis.sb_comp.dbo.COA_MAPPING WHERE [TYPE] = 'future3')          
) as DIST_CODE_CONCATENATED                       
          
,dbo.getlastdate(@month,@year) as ACCOUNTING_DATE,                        
NULL as DIST_DESCRIPTION,                       
NULL as PAY_GROUP_LOOKUP_CODE,                      
NULL as SEGMENT_1,                      
NULL as SEGMENT_2,              
NULL as SEGMENT_3,                      
NULL as SEGMENT_4,                      
NULL as SEGMENT_5,              
NULL as SEGMENT_6,                      
NULL as SEGMENT_7,                      
NULL as SEGMENT_8,                      
NULL as SEGMENT_9,                      
NULL as SEGMENT_10,                      
NULL as SEGMENT_11,                      
NULL as ASSETS_TRACKING_FLAG,                      
'Franchisee' as ATTRIBUTE_CATEGORY,                                  
NULL as ATTRIBUTE1 ,                                  
'Y' as ATTRIBUTE2,                                
NULL as ATTRIBUTE3,                                
NULL as ATTRIBUTE4,                                  
NULL as ATTRIBUTE5,                       
NULL as ATTRIBUTE6,                      
NULL as ATTRIBUTE7,                      
GETDATE()  as ATTRIBUTE8,                      
NULL as ATTRIBUTE9,                      
NULL as ATTRIBUTE10,                      
NULL as ATTRIBUTE11,                      
NULL as ATTRIBUTE12,                      
NULL as ATTRIBUTE13,                      
NULL as ATTRIBUTE14,                      
NULL as ATTRIBUTE15,                      
NULL as DIST_ATTRIBUTE_CATEGORY ,                                 
NULL as DIST_ATTRIBUTE1 ,                                  
NULL as DIST_ATTRIBUTE2 ,                                  
NULL as DIST_ATTRIBUTE3 ,                                  
NULL as DIST_ATTRIBUTE4 ,                                  
NULL as DIST_ATTRIBUTE5 ,                       
NULL as DIST_GLOBAL_ATT_CATEGORY ,                                  
NULL as GLOBAL_ATTRIBUTE1 ,                                  
NULL as GLOBAL_ATTRIBUTE2 ,                                  
NULL as GLOBAL_ATTRIBUTE3 ,                                  
NULL as GLOBAL_ATTRIBUTE4 ,                                  
NULL as GLOBAL_ATTRIBUTE5 ,                      
NULL as PREPAY_NUM,                      
NULL as PREPAY_DIST_NUM,                                  
NULL as PREPAY_APPLY_AMOUNT ,                        
NULL as PREPAY_GL_DATE ,                         
NULL as INVOICE_INCLUDES_PREPAY_FLAG,                                   
NULL as PREPAY_LINE_NUM,                       
'Franch_Sys' as CREATED_BY ,                       
GETDATE() as CREATION_DATE ,                      
NULL as PROCESSED_STATUS,                      
NULL as ERROR_MESSAGE,                      
NULL as INVOICE_STATUS,                      
NULL as BATCH_NAME                      
from #ff c inner join [ABCSOORACLEMDLW].oraclefin.dbo.XXC_VENDOR_MASTER_DETAIL v                          
on  v.vendor_site_code = c.branch       and v.vendor_id = c.vendor_id          
where v.vendor_type_lookup_code='REM-FRANCHISEE' 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JV_Invoice_UnRegistered
-- --------------------------------------------------
CREATE Proc USP_JV_Invoice_UnRegistered(@month as int,@year as int )  
as  
  
select vno=1,fdate=dbo.getlastdate(@month,@year),tdate=dbo.getlastdate(@month,@year),a.branch,DRCR='C',Amount,  
Narration='Provision to '+fname+' for '+rtrim(a.branch)+' Branch for '+DATENAME(month,dbo.getlastdate(@month,@year))+' '+convert(varchar(4),2011)+''
,coCode
into #file
from tbl_Franch_Final a join Vw_franchisee_mast_entity b  
on a.vendor_id=b.vendor_id and a.branch=b.ftag and a.entity_code=b.entity_code  
where tmonth=3 and tyear=2011 and flag ='jv_pf_loss'                
and fstatus<>'Registered'  and Amount>0

select Vno,Vdate,Edate,Cltcode,DRCR,Amount,Narration,BranchCode --into #JV
from       
(      
select Row_number() over (order by branch) as vno,convert(varchar(11),fdate,103) as vdate,convert(varchar(11),tdate,103) as edate,
cltcode='21'+branch,DRCR='C',Amount,branchcode=cocode,Narration from #file  
union all      
select Row_number() over (order by branch) as vno,convert(varchar(11),fdate,103) as vdate,convert(varchar(11),tdate,103) as edate,
cltcode='520012-'+cocode,DRCR='D',Amount,branchcode=branch,Narration from #file     
 ) a      
order by Vno,DRCR 


drop table #file

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateContactDetails
-- --------------------------------------------------
CREATE proc usp_UpdateContactDetails    
(    
 @Contact_person varchar(50),    
 @Address1 varchar(50),    
 @address2 varchar(50),    
 @city varchar(20),    
 @state varchar(50),    
 @zip varchar(7),    
 @contact_num1 varchar(15),    
 @contact_num2 varchar(15),    
 @email varchar(50),    
 @pan_no varchar(50),    
 @tag varchar(50),
 @vendor_id varchar(20) = null    
)    
as    
begin    
set nocount on;  
 --select distinct a.Contact_person,    
 -- a.Address1,    
 -- a.address2,    
 -- a.city,    
 -- a.state,    
 -- a.zip,    
 -- a.contact_num1,    
 -- a.contact_num2,    
 -- a.email,    
 -- a.pan_no,    
 -- b.Ftag,    
 -- b.FName from tbl_Franchisee_Contact a       
 --  inner join tbl_Franchisee_mast b      
 -- on a.vendor_site_id =b.vendor_site_id      
 -- where b.Ftag=@tag      
     
 UPDATE a     
  set Contact_person=@Contact_person,    
  Address1=@Address1,    
  address2=address2,    
  city=@city,    
  state=@state,    
  zip=@zip,    
  contact_num1=@contact_num1,    
  contact_num2=@contact_num2,    
  email=@email,    
  pan_no=@pan_no    
  from tbl_Franchisee_Contact a    
   inner join tbl_Franchisee_mast b      
  on a.vendor_site_id =b.vendor_site_id      
  and a.vendor_id =b.vendor_id      
  where b.Ftag=@tag   and b.vendor_id = isnull(@vendor_id , b.vendor_id )  
set nocount off;  
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateFranchDetails
-- --------------------------------------------------
CREATE proc usp_UpdateFranchDetails  
(  
 @Ftag varchar(50),  
 @Vendor_id int,  
 @Vendor_site_id int,  
 @Segment varchar(50),  
 @FromDt varchar(50),  
 @ToDt varchar(50),  
 @IncoB2B money,  
 @IncoB2C money,  
 @FStatus varchar(50),  
 @ExpenseSharing money  
   
)  
as  
begin  
 set nocount on;  
  --Select FStatus,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare,FromDate,ToDate   
  --from tbl_Franchisee_mast   
  --where Ftag=@Ftag  
  --and vendor_id=@Vendor_id   
  --and vendor_site_id=@Vendor_site_id  
  --and Segment=@Segment    
  
  update tbl_Franchisee_mast set FStatus=@FStatus,
	B2B_IncomePercent=@IncoB2B,
	B2C_IncomePercent=@IncoB2C,
	ExpenseShare=@ExpenseSharing,
	FromDate=@FromDt,
	ToDate =@ToDt  
  where Ftag=@Ftag  
  and vendor_id=@Vendor_id   
  and vendor_site_id=@Vendor_site_id  
  and Segment=@Segment
 set nocount off;  
end

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_expense_grp
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_expense_grp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [GrpName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.franch_Final
-- --------------------------------------------------
CREATE TABLE [dbo].[franch_Final]
(
    [particular] VARCHAR(68) NULL,
    [branch] CHAR(35) NULL,
    [flag] VARCHAR(20) NULL,
    [ABL__HO] FLOAT NOT NULL,
    [ABL_BSECM] FLOAT NOT NULL,
    [ABL_NSECM] FLOAT NOT NULL,
    [ABL_NSEFO] FLOAT NOT NULL,
    [ABL_NSECD] FLOAT NOT NULL,
    [ABL_MCXCD] FLOAT NOT NULL,
    [ACBPL_HO] FLOAT NOT NULL,
    [ACBPL_NCDEX] FLOAT NOT NULL,
    [ACBPL_MCX] FLOAT NOT NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.franchisee_b2b_b2c_brok
-- --------------------------------------------------
CREATE TABLE [dbo].[franchisee_b2b_b2c_brok]
(
    [BRANCH] VARCHAR(10) NULL,
    [subbrokcode] VARCHAR(10) NULL,
    [segment] VARCHAR(10) NULL,
    [b2b_brok_earned] MONEY NOT NULL,
    [b2c_brok_earned] MONEY NOT NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_glcode_Mast
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_glcode_Mast]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Code] INT NULL,
    [particulars] VARCHAR(100) NULL,
    [flag] VARCHAR(5) NULL,
    [Account_type] VARCHAR(8) NULL,
    [updt] DATETIME NULL,
    [GrpMap] INT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.franchisee_mast1
-- --------------------------------------------------
CREATE TABLE [dbo].[franchisee_mast1]
(
    [vendor_id] INT NULL,
    [vendor_site_id] INT NULL,
    [Ftag] VARCHAR(8) NOT NULL,
    [FName] VARCHAR(30) NULL,
    [B2B_IncomePercent] FLOAT NULL,
    [B2C_IncomePercent] REAL NULL,
    [ExpenseShare] FLOAT NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [Contact_person] VARCHAR(50) NULL,
    [Address1] VARCHAR(50) NULL,
    [address2] VARCHAR(50) NULL,
    [city] VARCHAR(20) NULL,
    [state] VARCHAR(20) NULL,
    [zip] VARCHAR(7) NULL,
    [contact_num1] VARCHAR(15) NULL,
    [contact_num2] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [pan_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysdiagrams
-- --------------------------------------------------
CREATE TABLE [dbo].[sysdiagrams]
(
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT IDENTITY(1,1) NOT NULL,
    [version] INT NULL,
    [definition] VARBINARY(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Franch_BKG_Paid
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Franch_BKG_Paid]
(
    [Segment] VARCHAR(50) NULL,
    [vendor_id] INT NULL,
    [Ftag] VARCHAR(8) NULL,
    [Brok_paid] MONEY NULL,
    [Brok_accrual] MONEY NULL,
    [fromdate] DATETIME NULL,
    [todate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Franch_BKG_Paid_bak
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Franch_BKG_Paid_bak]
(
    [Segment] VARCHAR(50) NULL,
    [vendor_id] INT NULL,
    [Ftag] VARCHAR(8) NULL,
    [Brok_paid] MONEY NULL,
    [Brok_accrual] MONEY NULL,
    [fromdate] DATETIME NULL,
    [todate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_franch_entity_mast
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_franch_entity_mast]
(
    [ENTITY_CODE] VARCHAR(150) NOT NULL,
    [ENTITY_NAME] VARCHAR(240) NULL,
    [PARENT_CODE] VARCHAR(60) NOT NULL,
    [PARENT_NAME] VARCHAR(240) NULL,
    [ENABLED_FLAG] VARCHAR(1) NOT NULL,
    [START_DATE_ACTIVE] DATETIME NULL,
    [END_DATE_ACTIVE] DATETIME NULL,
    [segment] VARCHAR(12) NULL,
    [coCode] VARCHAR(7) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_franch_exclude_extraexpense
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_franch_exclude_extraexpense]
(
    [vendor_id] INT NULL,
    [Ftag] VARCHAR(8) NOT NULL,
    [code] VARCHAR(12) NOT NULL,
    [segment] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_franch_extraexpense
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_franch_extraexpense]
(
    [vendor_id] INT NULL,
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(50) NULL,
    [Ftag] VARCHAR(8) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Franch_Final
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Franch_Final]
(
    [particular] VARCHAR(68) NULL,
    [Amount] FLOAT NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL,
    [flag] VARCHAR(20) NULL,
    [entity_code] INT NULL,
    [ENTITY_NAME] VARCHAR(8000) NULL,
    [vendor_id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_franchisee_calc
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_franchisee_calc]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [entity_code] INT NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Franchisee_Contact
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Franchisee_Contact]
(
    [vendor_id] INT NULL,
    [vendor_site_id] INT NULL,
    [Contact_person] VARCHAR(50) NULL,
    [Address1] VARCHAR(50) NULL,
    [address2] VARCHAR(50) NULL,
    [city] VARCHAR(20) NULL,
    [state] VARCHAR(50) NULL,
    [zip] VARCHAR(7) NULL,
    [contact_num1] VARCHAR(15) NULL,
    [contact_num2] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [pan_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_franchisee_lock
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_franchisee_lock]
(
    [month1] VARCHAR(13) NULL,
    [year1] VARCHAR(13) NULL,
    [locked_on] VARCHAR(25) NULL,
    [locked_by] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Franchisee_mast
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Franchisee_mast]
(
    [vendor_id] INT NULL,
    [vendor_site_id] INT NULL,
    [Segment] VARCHAR(50) NULL,
    [FStatus] VARCHAR(30) NULL,
    [Ftag] VARCHAR(8) NULL,
    [FName] VARCHAR(30) NULL,
    [B2B_IncomePercent] FLOAT NULL,
    [B2C_IncomePercent] FLOAT NULL,
    [ExpenseShare] FLOAT NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Rpt_Summ_Structure
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Rpt_Summ_Structure]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL,
    [flag] VARCHAR(5) NULL,
    [entity_code] INT NULL,
    [GrpMap] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tobedeletelate
-- --------------------------------------------------
CREATE TABLE [dbo].[tobedeletelate]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_franch_exclude_extraexpense
-- --------------------------------------------------
Create view Vw_franch_exclude_extraexpense
as
select  a.*,ENTITY_CODE from tbl_franch_exclude_extraexpense a join tbl_franch_entity_mast b 
on a.Segment=b.ENTITY_NAME

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_franchisee_b2b_b2c_brok
-- --------------------------------------------------
Create View Vw_franchisee_b2b_b2c_brok
as
select a.*,entity_code from franchisee_b2b_b2c_brok a (nolock)
join
(
select  entity_code,segment from tbl_franch_entity_mast (nolock)
 where enabled_flag='Y'
and segment<>''    
) b
on a.segment=b.segment

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Franchisee_mast
-- --------------------------------------------------
CREATE View Vw_Franchisee_mast  
 as  
 select distinct Ftag=convert(varchar(12),vendor_id)+'-'+ftag,Tag=Ftag,FName from tbl_Franchisee_mast(nolock)  where vendor_id<>0

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_franchisee_mast_entity
-- --------------------------------------------------
CREATE view Vw_franchisee_mast_entity  
as  
select  a.*,ENTITY_CODE,coCode from tbl_franchisee_mast a join tbl_franch_entity_mast b   
on a.Segment=b.ENTITY_NAME

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Rpt_Summ_Entity
-- --------------------------------------------------
CREATE View Vw_Rpt_Summ_Entity
as
select Code,particulars,entity_code,ENTITY_NAME,flag
from Franchisee_glcode_Mast  a ,
( select entity_code,ENTITY_NAME 
from tbl_franch_entity_mast where ENABLED_FLAG='Y' ) b
where flag in ('I_B2C','I_B2B')

GO

